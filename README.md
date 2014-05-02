maxflow-problems
================

Motivation
----------

Some simple example flows to illustrate various optimization concepts.

These flow files can be run through a [DIMACS](http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm) compatible solver 
such as [CS2](https://github.com/iveney/cs2).


Bipartite matching with no penalization scheme
-----------------------------------------------

Let's say we want to score some dyadic data and deliver certain dyads to maximize the sum of scores while taking into account certain capacity constraints.  This can be formulated as a flow network.  Let's take for instance the following example.  We'll solve this using a single source, single sink min-cost max flow algorithm.

| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/no_penalties.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/no_penalties_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


```bash
cat no_penalties.flow              \
  | cs2 2>/dev/null                \
  | grep -P '^f.*[^0]$'            \
  | tr -s [:blank:]                \
  | tr [:blank:] '\t'              \
  | cut -f2,3                      \
  | grep -P '[2345]\t[2345]'       \
  | sort -n 
```

```
3	4
```

In this example, there are four entities represented as nodes {2, 3, 4, 5} in the graph and there are many edges (hereafter arcs) representing various properties within the graph.  Associated with each arc is an ordered triple representing:

  _minimum capacity_, _maximum capacity_, _cost_

There are two different sets of arcs in this example.  The 3 green arcs represent the (scored) dyadic relationships between the associated nodes and the 4 blue arcs represent the capacities of the nodes.  That is, the capacities are the number of times a node can be involved in a dyadic relationship in the resulting solution.  Since we are interested in maximizing the sum of dyadic scores, we can represent these scores as negative costs in the min-cost max flow problem.  Because the capacity constraints shouldn't affect the sum, they have zero costs.

Something interesting happens in the solution of this problem formulation.  It is better from an overall optimization perspective to reify only one of these possible relationships (arc 3 &rarr; 4) and serve only two of the entities rather than to reify the two relationships (arcs 2 &rarr; 4, 3 &rarr; 5) and serve all of the entities.  This shows that the optimization is rather Machiavellian and may not only reify less relationships in an optimal solution, but may also serve less entities.  This can be problematic, especially when those entities are patrons.


Bipartite matching with penalties for unserved entities
--------------------------------------------------------

We can overcome the above issues by requiring the optimization to penalize solutions that have nodes with no incoming or outgoing arcs.  


| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


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

Penalties outweigh delivery of unpenalized optimum
--------------------------------------------------


| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_all_nodes_get_matches.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_all_nodes_get_matches_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


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

Penalties work with unequal capacities the two sides of bipartite graph 
-----------------------------------------------------------------------

| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_0_2__1_0.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_0_2__1_0_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


```bash
cat pen_0_2__1_0.flow              \
  | cs2 2>/dev/null                \
  | grep -P '^f.*[^0]$'            \
  | tr -s [:blank:]                \
  | tr [:blank:] '\t'              \
  | cut -f2,3                      \
  | grep -P '[2345]\t[2345]'       \
  | sort -n 
```

```
2	5
3	4
```


Opimization Equations
---------------------


![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/opt_func_sum.png)

_subject to_

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_pos_scores.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ind_le_score.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_x.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_y.png)


Opimization Equations for Penalization
--------------------------------------

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/opt_func_penalized.png)

_subject to_

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_pos_scores.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ind_le_score.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_x.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_y.png)


