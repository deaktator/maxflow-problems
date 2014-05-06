maxflow-problems
================

Motivation
----------

Some simple example flows to illustrate various optimization concepts.

These flow files can be run through a [DIMACS](http://lpsolve.sourceforge.net/5.5/DIMACS_mcf.htm) compatible solver 
such as [CS2](https://github.com/iveney/cs2).


Bipartite matching with no penalization scheme
-----------------------------------------------

Let's say we want to score some dyadic data and deliver certain dyads to maximize the sum of scores 
while taking into account certain capacity constraints.  This can be formulated as a flow network.  
Let's take for instance the following example.  We'll solve this using a single source, single 
sink min-cost max flow algorithm.

| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/no_penalties.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/no_penalties_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


```bash
# =================================================================================================
#  Run the optimization and print out the matches.
#
#  cs2 runs the optimization.  Lines with matches start with 'f'.  The second column is the arc 
#  tail and the third column is the arc head.  Since we know for this example the node IDs we are
#  interested in are {2, 3, 4, 5}, we can ignore all others (used for applying penalties).
# =================================================================================================

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

In this example, there are four entities represented as nodes {2, 3, 4, 5} in the graph and there 
are many edges (hereafter arcs) representing various properties within the graph.  Associated with 
each arc is an ordered triple representing:

  _minimum capacity_, _maximum capacity_, _cost_

There are two different sets of arcs in this example.  The 3 green arcs represent the (scored) dyadic 
relationships between the associated nodes and the 4 blue arcs represent the capacities of the nodes.  
That is, the capacities are the number of times a node can be involved in a dyadic relationship in 
the resulting solution.  Since we are interested in maximizing the sum of dyadic scores, we can 
represent these scores as negative costs in the min-cost max flow problem.  Because the capacity 
constraints shouldn't affect the sum, they have zero costs.

Something interesting happens in the solution of this problem formulation.  It is better from an 
overall optimization perspective to reify only one of these possible relationships (arc 3 &rarr; 4) 
and serve only two of the entities rather than to reify the two relationships 
(arcs 2 &rarr; 4, 3 &rarr; 5) and serve all of the entities.  This shows that the optimization is 
rather Machiavellian and may not only reify less relationships in an optimal solution, but may also 
serve less entities.  This can be problematic, especially when those entities are paying customers.


Bipartite matching with penalties for unserved entities
--------------------------------------------------------

We can overcome the above issues by requiring the optimization to penalize solutions that have 
nodes with no incoming or outgoing arcs.  


| Problem | Solution | Legend |
| ------- | -------- | ------ |
| <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/pen_2_nodes_no_matches_solution.png" width="300px" /> | <img src="https://github.com/deaktator/maxflow-problems/raw/master/images/legend.png" width="100px" /> |


```bash
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

Optimization Equations
----------------------

A basic optimization function in which we try to maximize the sum of positive scores while adhering
to constraints on the number of relationships each entity can participate in can be written as 
follows.  

_I_<sub>_x_,_y_</sub> is the indicator function specifying that the solution contains a
relationship between _x_ and _y_.  _C_<sub>_x_</sub> represents the number of relationships in 
which _x_ can participate.

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/opt_func_argmax.png)

_subject to_

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ind_le_score.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_x.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_y.png)


Optimization Equations for Penalization
---------------------------------------

Assuming penalization functions _p_<sub>_x_</sub> and _p_<sub>_y_</sub> have the following form: 

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/p_x_func.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/p_y_func.png)

where _P_(_X_) represents the the powerset of _X_, and _N_ represents the set of natural numbers,
we can create a penalized version of the optimization function as follows:


![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/opt_func_argmax_penalized.png)

_subject to_

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ind_le_score.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_x.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_ml_y.png)


Types of Penalization Functions
-------------------------------

Assume for each _x_ we create a penalization function _h_<sub>_x_</sub> that returns a natural number 
and is monotonically non-increasing on inputs from 0 to _C_<sub>_x_</sub> and is 0 for all input 
values at least _C_<sub>_x_</sub>.  Assume that we have similar penalization functions for all 
_y_.  This is specified as:

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_h_lt_Ci.png)  ![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_h_mono_noninc.png)

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_h_gte_Ci.png)  ![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/constraint_h_0.png)


Then we can create penalizations functions _g_<sub>_x_</sub> of the following form:

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/g.png)

So we can set _p_<sub>_x_</sub> as:

![](https://github.com/deaktator/maxflow-problems/raw/master/images/eqs/p_x_func_def.png)

This class of penalization functions is easy to incorporate into a min-cost max flow problem 
because the penalties in _h_<sub>_x_</sub> are additive to form the penalization function 
_g_<sub>_x_</sub>.


Algorithm for Penalized Min-Cost Max Flow
------------------------------------------

1. Create a bipartite graph between _X_ and _Y_ with arcs between _x_ and _y_ if _s_(_x_, _y_) > 0.
   label these arcs with the negative score -_s_ and set the minimum capacity to 0 and the maximum 
   capacity to 1.
2. Create a source and sink node.  Construct an arc between the source and each _x_ &isin; _X_
   with cost 0, min capacity 0 and max capacity _C_<sub>_x_</sub>.  Construct an arc between 
   each _y_ &isin; _Y_ and the sink with cost 0, min capacity 0 and max capacity _C_<sub>_y_</sub>.  
3. For each _i_ from 0 ... _C_<sub>_x_</sub>, construct an arc from _x_ to sink with min 
   capacity 0, max capacity 1 and cost _p_<sub>_x_</sub>(_i_).
4. For each _i_ from 0 ... _C_<sub>_y_</sub>, construct an arc from source to _y_ with min 
   capacity 0, max capacity 1 and cost _p_<sub>_y_</sub>(_i_).
5. Combine all arcs from a node m to a node n with the same cost, _c_, into one new arc with min 
   capacity 0, cost _c_, and max capacity equal to the sum of the maximum capacities of all arcs in 
   questions.  Remove all of the arcs that were combined into the new arc. 
