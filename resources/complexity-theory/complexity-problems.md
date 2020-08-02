PROBLEMS
========
<br/>
<br/>

RCH
----
**L (for undirected graphs), NLC** <br/>
*Given:* a directed graph G and nodes x,y <br/>
**Decide:** is there a path x →···→ y ?
<br/>
<br/>
<br/>



2SAT
----
**NLC → P** <br/>
*Given:* a set of clauses of *2 literals* <br/>
**Decide:** is there a satisfying truth assignment? <br/>
*Variations:* **F-2SAT (P?)** - finds the truth assignment (not only checks if one exists)
<br/>
<br/>
<br/>



CV
--
**PC** <br/>
*Given:* given a variable-free circuit. <br/>
**Find:** Determine its output.
<br/>
<br/>
<br/>



LP (LinProg)
------------
**PC** <br/>
*Given:* given f(x) subject to constraints. <br/>
**Optimise:** Maximize f(x) (non-integer solutions allowed).
<br/>
<br/>
<br/>



COMPOSITE
---------
**NP, co-NP, P** <br/>
*Given:* x a natural number <br/>
**Decide:** are there numbers y, z such that x = yz ?
<br/>
<br/>
<br/>



GIsom
-----
**NP, not sure if NPC, could be NPI** <br/>
*Given:* G1, G2 graphs <br/>
**Decide:** G1 is isomorphic to G2 <br/>
*Variation:* **SGI - SubGIsom (NPC)** - given 2 graphs, *decide* is one isomorphic to a subgraph of the other? 
<br/>
<br/>
<br/>



SAT
---
**NPC** <br/>
*Given:* a *set of clauses* (disjunction of literals eg x V  not y ) <br/>
**Decide:**: is there a satisfying truth assignment? <br/>
*Variations:* **3SAT (NPC)**- given a set of clauses of *3 literals*, better for reductions <br/>
<br/>
<br/>
<br/>



HP
--
**NPC** <br/>
*Given:* an undirected graph (no loops or multiple edges)<br/>
**Decide:**: is there a path visiting each *node* exactly once? <br/>
*Variation:* **TC (NPC)**
<br/>
<br/>
<br/>



TSP
---
**NPC, TSP(D) strongly NPC** <br/>
*Given:* a set of n cities and distances between them. <br/> 
**Optimise:** find a tour visiting each city once and returning to the start of shortest distance. <br/>
**Decide - TSP(D):** **(NPC)** - also given *a bound B*, decide if we can visit each city once and return to the
start *with total distance <= B.*
<br/>
<br/>
<br/>



IP(D)
-----
**NPC** <br/>
Decision version of zero-one integer programming.<br/>
*Given:* given f(x) subject to constraints.
**Optimise:** Maximize f(x) with integer solutions only.
<br/>
<br/>
<br/>



TRI
---
**NPC** <br/>
*Given:* 3 sets B, G, H each with n elements and T ⊆ B × G × H<br/>
**Decision:** is there a set of n triples in T such that no 2 triples have elements in common? <br>


BIN 
---
Decision version of Scheduling <br/>
**NPC, strongly NPC** <br/>
*Given:* a set of n items with sizes s1, ..., sn and bins each with capacity c <br/>
**Optimise:** find the minimum number of bins required to accommodate the n items.<br/>
**Decide - BIN(D):** **(NPC)** (same as Scheduling) - Given n positive integers a1,...,an (the items), B (number of bins), and C (capacity), can we partition the numbers into B subsets, each of which has sum ≤ C? . 
<br/>
<br/>
<br/>



KNAPSACK
--------
**NPC** <br/>
*Given:* m items with values vi and weights wi, and weight limit W.<br/>
**Optimize:** Want to pick some to maximise value, subject to weight ≤ W <br/> 
**Decide - KNAPSACK(D):** **(NPC)** given K, can we have value >= K?
<br/>
<br/>
<br/>



SubsetSum
---------
**NPC** <br/>
*Given:* a set of m positive integers and another integer K. <br/>
**Decide:** is there a subset with sum = K? 
<br/>
<br/>
<br/>



IND
---
**NPC** <br/>
Given an undirected graph G a set I of nodes of G is said to be independent if no 2 nodes of I are adjacent.<br/> 
*Given:* a graph G and k >= 0 <br/> 
**Decide:** does G have an independent set of size k?
<br/>
<br/>
<br/>



CLIQUE
------
**NPC** <br/>
*Given:* an undirected graph G and a natural number N, a clique is a set I ⊆ nodes(G) such that if i, j ∈ I then i and j are adjacent.<br/>
**Decide:** is there a clique of size N?
<br/>
<br/>
<br/>



VC
--
**NPC** <br/>
*Given:* a graph G,a vertex cover is a subset U of the vertices of G such that for every edge of G, at least one endpoint is in U <br/>
**Optimise:** find the size of the smallest vertex cover <br/>
**Decide - VC(D):** is there a vertex cover of size <= B? 
<br/>
<br/>
<br/>



PARTITION
---------
**NPC** <br/>
*Given:* a sequence a1, ..., an of positive integers <br/> 
**Decide:** is there a subset S of {1, ..., n} such that Sum(ai)[i in S] = Sum(ai)[i not in S]
<br/>
<br/>
<br/>



Quantiﬁed Boolean Formulae (QBF)
--------------------------------
**PSPACEC** <br/>
Given a formula of the form
∃x1∀x2 ...Qxn.ϕ(x1,...,xn) 
is it true?
