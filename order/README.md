## Exploration of CS2 edge selection vs input order

This is an experiment that shows how CS2 generates optimal solutions when many exist, based on 
permuting the input order of the edges involved in the optimal solutions.

The solutions involve a graph that looks like the following.  There are four nodes and the graph
shows the capacities at each node and the costs per unit flow over the arcs.  We want to see what
edges are created when a min-cost max flow is run on this network.


```
                       -1
       (cap 2)   3 ---------> 5   (cap -1)
                   \         ^
                  -1 \     /
                       \_/
                  -1 /     \
                   /         v
       (cap 2)   4 ---------> 6   (cap -1)
                       -1
```


### After sorting edge output order 

Edge List            | Count
-------------------- | ------
{ 3 &rarr; 6, 4 &rarr; 5 } | 7
{ 4 &rarr; 5, 4 &rarr; 6 } | 7
{ 3 &rarr; 5, 3 &rarr; 6 } | 5
{ 3 &rarr; 5, 4 &rarr; 6 } | 5


### Without sorting edge output order

Edge List            | Count
-------------------- | ------
{ 3 &rarr; 6, 4 &rarr; 5 } | 7
{ 3 &rarr; 5, 4 &rarr; 6 } | 5
{ 4 &rarr; 5, 4 &rarr; 6 } | 5
{ 3 &rarr; 6, 3 &rarr; 5 } | 3
{ 3 &rarr; 5, 3 &rarr; 6 } | 2
{ 4 &rarr; 6, 4 &rarr; 5 } | 2


### Unordered

Edge Declaration Order | Resulting Edge List
---------------------- | --------------------
35364546               | { 4 &rarr; 5, 4 &rarr; 6 }
35364645               | { 3 &rarr; 6, 4 &rarr; 5 }
35453646               | { 4 &rarr; 5, 4 &rarr; 6 }
35454636               | { 4 &rarr; 5, 4 &rarr; 6 }
35463645               | { 3 &rarr; 6, 4 &rarr; 5 }
35464536               | { 3 &rarr; 6, 4 &rarr; 5 }
36354546               | { 3 &rarr; 6, 4 &rarr; 5 }
36354645               | { 4 &rarr; 6, 4 &rarr; 5 }
36453546               | { 4 &rarr; 5, 4 &rarr; 6 }
36454635               | { 3 &rarr; 5, 4 &rarr; 6 }
36463545               | { 3 &rarr; 6, 4 &rarr; 5 }
36464535               | { 3 &rarr; 5, 4 &rarr; 6 }
45353646               | { 3 &rarr; 5, 3 &rarr; 6 }
45354636               | { 3 &rarr; 5, 4 &rarr; 6 }
45363546               | { 3 &rarr; 5, 4 &rarr; 6 }
45364635               | { 3 &rarr; 6, 3 &rarr; 5 }
45463536               | { 3 &rarr; 6, 3 &rarr; 5 }
45463635               | { 3 &rarr; 5, 4 &rarr; 6 }
46353645               | { 3 &rarr; 6, 4 &rarr; 5 }
46354536               | { 4 &rarr; 6, 4 &rarr; 5 }
46363545               | { 3 &rarr; 6, 4 &rarr; 5 }
46364535               | { 3 &rarr; 6, 3 &rarr; 5 }
46453536               | { 4 &rarr; 5, 4 &rarr; 6 }
46453635               | { 3 &rarr; 5, 3 &rarr; 6 }

### Ordered

Edge Declaration Order | Resulting Edge List
---------------------- | --------------------
35364546               | { 4 &rarr; 5, 4 &rarr; 6 }
35364645               | { 3 &rarr; 6, 4 &rarr; 5 }
35453646               | { 4 &rarr; 5, 4 &rarr; 6 }
35454636               | { 4 &rarr; 5, 4 &rarr; 6 }
35463645               | { 3 &rarr; 6, 4 &rarr; 5 }
35464536               | { 3 &rarr; 6, 4 &rarr; 5 }
36354546               | { 3 &rarr; 6, 4 &rarr; 5 }
36354645               | { 4 &rarr; 5, 4 &rarr; 6 }
36453546               | { 4 &rarr; 5, 4 &rarr; 6 }
36454635               | { 3 &rarr; 5, 4 &rarr; 6 }
36463545               | { 3 &rarr; 6, 4 &rarr; 5 }
36464535               | { 3 &rarr; 5, 4 &rarr; 6 }
45353646               | { 3 &rarr; 5, 3 &rarr; 6 }
45354636               | { 3 &rarr; 5, 4 &rarr; 6 }
45363546               | { 3 &rarr; 5, 4 &rarr; 6 }
45364635               | { 3 &rarr; 5, 3 &rarr; 6 }
45463536               | { 3 &rarr; 5, 3 &rarr; 6 }
45463635               | { 3 &rarr; 5, 4 &rarr; 6 }
46353645               | { 3 &rarr; 6, 4 &rarr; 5 }
46354536               | { 4 &rarr; 5, 4 &rarr; 6 }
46363545               | { 3 &rarr; 6, 4 &rarr; 5 }
46364535               | { 3 &rarr; 5, 3 &rarr; 6 }
46453536               | { 4 &rarr; 5, 4 &rarr; 6 }
46453635               | { 3 &rarr; 5, 3 &rarr; 6 }


### Ordered by result, then input

Edge Declaration Order | Resulting Edge List
---------------------- | --------------------
45353646               | { 3 &rarr; 5, 3 &rarr; 6 }
45364635               | { 3 &rarr; 5, 3 &rarr; 6 }
45463536               | { 3 &rarr; 5, 3 &rarr; 6 }
46364535               | { 3 &rarr; 5, 3 &rarr; 6 }
46453635               | { 3 &rarr; 5, 3 &rarr; 6 }
36454635               | { 3 &rarr; 5, 4 &rarr; 6 }
36464535               | { 3 &rarr; 5, 4 &rarr; 6 }
45354636               | { 3 &rarr; 5, 4 &rarr; 6 }
45363546               | { 3 &rarr; 5, 4 &rarr; 6 }
45463635               | { 3 &rarr; 5, 4 &rarr; 6 }
35364645               | { 3 &rarr; 6, 4 &rarr; 5 }
35463645               | { 3 &rarr; 6, 4 &rarr; 5 }
35464536               | { 3 &rarr; 6, 4 &rarr; 5 }
36354546               | { 3 &rarr; 6, 4 &rarr; 5 }
36463545               | { 3 &rarr; 6, 4 &rarr; 5 }
46353645               | { 3 &rarr; 6, 4 &rarr; 5 }
46363545               | { 3 &rarr; 6, 4 &rarr; 5 }
35364546               | { 4 &rarr; 5, 4 &rarr; 6 }
35453646               | { 4 &rarr; 5, 4 &rarr; 6 }
35454636               | { 4 &rarr; 5, 4 &rarr; 6 }
36354645               | { 4 &rarr; 5, 4 &rarr; 6 }
36453546               | { 4 &rarr; 5, 4 &rarr; 6 }
46354536               | { 4 &rarr; 5, 4 &rarr; 6 }
46453536               | { 4 &rarr; 5, 4 &rarr; 6 }



### Script to run cs2 over the files to determine the output order.

```bash
cd order
for FILE in ./*; do
  echo $FILE
  cat $FILE | cs2 2>/dev/null | grep -P '^f\s+[34]\s+[56]\s+1$' | tr -s [:blank:] | tr [:blank:] '\t' | cut -f2,3
  echo
done
```