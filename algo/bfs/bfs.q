.algo.ensureList:{:$[0 <= type x;x;enlist x]};

.algo.bfs:{[graph;node]
    :{[graph; nodes; toVisit]
        node:nodes[toVisit];
        newNodes:.algo.ensureList[graph[node]] except nodes;
        $[0<count newNodes; .z.s[graph;nodes,newNodes;toVisit+1]; nodes]
    }[graph;enlist node;0]
};


// Tests
.algo.g1:`a`b`c`d!(`b`c;`a`d;`a`d;`a); // contains cycles
.algo.g2:`a`b`c`d!(`b`c;`d;();()); // no cycles
.algo.g3:`a`b`c`d`e`f!(`b`c;`d`e;enlist `f;();enlist `f;());

$[.algo.bfs[.algo.g1;`a]~`a`b`c`d;1b;'"Cycle test failed"];
$[.algo.bfs[.algo.g2;`a]~`a`b`c`d;1b;'"No cycle test failed"];
$[.algo.bfs[.algo.g3;`a]~`a`b`c`d`e`f;1b;'"A to F test failed"];

$[.algo.ensureList[`a]~enlist `a;1b;'"Singleton symbol failed"];
$[.algo.ensureList[`a`b]~`a`b;1b;'"Symbols failed"];
$[.algo.ensureList[1]~enlist 1;1b;'"Singleton int failed"];
$[.algo.ensureList[1 2]~1 2;1b;'"Ints failed"];
$[.algo.ensureList[1.2 1.3]~1.2 1.3;1b;'"Floats failed"];
$[.algo.ensureList["a"]~enlist "a";1b;'"Singleton char failed"];
$[.algo.ensureList["ab"]~"ab";1b;'"String failed"];
$[.algo.ensureList[2020.04.30]~enlist 2020.04.30;1b;'"Singleton date failed"];
$[.algo.ensureList[2020.04.30 2020.05.01]~2020.04.30 2020.05.01;1b;'"Dates failed"];
$[.algo.ensureList[(2020.04.30 2020.05.01; `a`b; 1 2)]~(2020.04.30 2020.05.01; `a`b; 1 2);1b;'"Mixed failed"];