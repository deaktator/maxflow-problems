#!/usr/bin/env bash

# =================================================================================================
#  R M Deak                           determine-matches.sh                              2014-05-06
# =================================================================================================
#  Determine the matches by running a min-cost max flow on the input file
#
#  NOTE: Assumes a DIMACS-compatible solver named cs2 is on the path.
# =================================================================================================

usage() {
(
  cat <<EOD
usage: determine-matches.sh <flow-file-path> <source-node-ID> <sink-node-ID>

where: 
  flow-file-path   is a path to a DIMACS formatted flow file.  For more information, see
                   http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm

  source-node-ID   an integer ID representing the source node.

  sink-node-ID     an integer ID representing the sink node.
EOD
) >&2
}

if [ "$#" -ne 3 ]; then
  usage
  exit -1
else
  # Name the arguments.
  FLOW_FILE=$1
  SOURCE_NODE=$2
  SINK_NODE=$3

  cat ${FLOW_FILE}                             \
    | cs2 2>/dev/null                          \
    | grep -P "^f.*\s+1$"                      \
    | grep -vP "^f\s+${SOURCE_NODE}\s+.*$"     \
    | grep -vP "^f\s+\d+\s+${SINK_NODE}\s+.*$" \
    | tr -s [:blank:]                          \
    | tr [:blank:] '\t'                        \
    | cut -f2,3
fi
