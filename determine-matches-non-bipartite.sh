#!/usr/bin/env bash 

# ============================================================================
#  R M Deak           determine-matches-non-bipartite.sh           2015-09-13
# ============================================================================
#  Determine the matches when a min-cost max flow associated with a 
#  non-bipartite graph is solved.  This script processes the output of a 
#  DIMACS compatible solver.  For information on the DIMACS format, see:
# 
#    http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm
#
#  This assumes that the "input" nodes are 2*k and "output" nodes are 2*k+1 
#  for some k.  For what an "input" and "output" node means, see:
#
#    https://en.wikipedia.org/wiki/Maximum_flow_problem#Maximum_flow_problem_with_vertex_capacities
#
#  Returns the node IDs k, not 2*k or 2*k+1 for "input" and "output" nodes.
# 
# ============================================================================

usage() {
(
  cat <<EOD
usage: determine-matches-non-bipartite.sh <source-node-ID> <sink-node-ID>
where: 
  source-node-ID   an integer ID representing the source node.
  sink-node-ID     an integer ID representing the sink node.
  
This script processes DIMACS compatible solution outputs passed on standard 
input.  For more information, see:
  http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm
EOD
) >&2
}

initial_edge_filter() {
  grep -E "^f\s+\d+\s+\d+\s+1(\s+-?\d+)?$"
}

omit_source_and_sink() {
  grep -vE "\s($SOURCE_NODE|$SINK_NODE)\s"
}

omit_in_to_out_edges() {
  grep -vE '\d*[02468]\s+\d+\s'
}

get_edges() {
  grep -oE 'f\s+\d+\s+\d+' | \
  tr -s [[:blank:]]        | \
  tr [[:blank:]] '\t'      | \
  cut -f2,3
}

# Integer divide vertex IDs by 2 since "input" nodes are 2*k and "output" 
# nodes are 2*k+1.  Integer division yields k in both cases.
get_vertices() {
  while IFS='' read -r LINE; do
    for X in $LINE; do
      echo $((X / 2))
    done | tr '\n' '\t' | cut -f1,2
  done
}

# ============================================================================

if [ "$#" -ne 2 ]; then
  usage
  exit -1
else
  # Name the arguments.
  SOURCE_NODE=$1
  SINK_NODE=$2

  # This works for CS 4.5 and CS 4.6 versions of cs2.
  initial_edge_filter  |\
  omit_source_and_sink |\
  omit_in_to_out_edges |\
  get_edges            |\
  get_vertices
fi
