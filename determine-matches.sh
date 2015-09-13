#!/usr/bin/env bash

# =================================================================================================
#  R M Deak                           determine-matches.sh                              2014-05-12
# =================================================================================================
#  Determine the matches when a min-cost max flow associated with a bipartite graph is solved.
#  This script processes the output of a DIMACS compatible solver.  For information on the 
#  DIMACS format, see:
# 
#    http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm
# =================================================================================================

usage() {
(
  cat <<EOD
usage: determine-matches.sh <source-node-ID> <sink-node-ID>

where: 
  source-node-ID   an integer ID representing the source node.
  sink-node-ID     an integer ID representing the sink node.
  
This script processes DIMACS compatible solution outputs passed on standard input.  For more
information, see:

  http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm
EOD
) >&2
}

if [ "$#" -ne 2 ]; then
  usage
  exit -1
else
  # Name the arguments.
  SOURCE_NODE=$1
  SINK_NODE=$2

  # This works for CS 4.5 and CS 4.6 versions of cs2.
  cat \
    | grep -E "^f\s+\d+\s+\d+\s+1(\s+-?\d+)?$" \
    | grep -vE "^f\s+${SOURCE_NODE}\s+.*$"     \
    | grep -vE "^f\s+\d+\s+${SINK_NODE}\s+.*$" \
    | tr -s [:blank:]                          \
    | tr [:blank:] '\t'                        \
    | cut -f2,3
fi
