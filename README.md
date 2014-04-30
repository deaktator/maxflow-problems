maxflow-problems
================

Some simple example flows to illustrate various optimization concepts.

These flow files can be run through a [DIMACS](http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm) compatible solver 
such as [CS2](https://github.com/iveney/cs2).

| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="200px" /> |


```bash
# =================================================================================================
#  Run the optimization and print out the matches.
#
#  cs2 runs the optimization.  Lines with matches start with 'f'.  The second column is the arc 
#  tail and the third column is the arc head.  Since we know for this example the node IDs we are
#  interested in are {2, 3, 4, 5}, we can ignore all others (used for applying penalties).
# =================================================================================================
cat pen_2_nodes_no_matches.flow \
  | cs2 2>/dev/null             \
  | grep -P '^f.*[^0]$'         \
  | tr -s [:blank:]             \
  | tr [:blank:] '\t'           \
  | cut -f2,3                   \
  | grep -P '[2345]\t[2345]'    \
  | sort -n 
```

```
3	4
```

| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_all_nodes_get_matches.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_all_nodes_get_matches_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="200px" /> |


```bash
cat pen_all_nodes_get_matches.flow \
  | cs2 2>/dev/null                \
  | grep -P '^f.*[^0]$'            \
  | tr -s [:blank:]                \
  | tr [:blank:] '\t'              \
  | cut -f2,3                      \
  | grep -P '[2345]\t[2345]'       \
  | sort -n 
```

```
2	4
3	5
```
