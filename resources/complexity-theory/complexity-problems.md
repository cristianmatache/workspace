# PROBLEMS

## RCH

**L (for undirected graphs), NLC** <br/> <!-- markdownlint-disable -->
_Given:_ a directed graph G and nodes x,y <br/> <!-- markdownlint-disable -->
**Decide:** is there a path x →···→ y ?

## 2SAT

**NLC → P** <br/> <!-- markdownlint-disable -->
_Given:_ a set of clauses of _2 literals_ <br/> <!-- markdownlint-disable -->
**Decide:** is there a satisfying truth assignment? <br/> <!-- markdownlint-disable -->
_Variations:_ **F-2SAT (P?)** - finds the truth assignment (not only checks if one exists)

## CV

**PC** <br/> <!-- markdownlint-disable -->
_Given:_ given a variable-free circuit. <br/> <!-- markdownlint-disable -->
**Find:** Determine its output.

## LP (LinProg)

**PC** <br/> <!-- markdownlint-disable -->
_Given:_ given f(x) subject to constraints. <br/> <!-- markdownlint-disable -->
**Optimise:** Maximize f(x) (non-integer solutions allowed).

## COMPOSITE

**NP, co-NP, P** <br/> <!-- markdownlint-disable -->
_Given:_ x a natural number <br/> <!-- markdownlint-disable -->
**Decide:** are there numbers y, z such that x = yz ?

## GIsom

**NP, not sure if NPC, could be NPI** <br/> <!-- markdownlint-disable -->
_Given:_ G1, G2 graphs <br/> <!-- markdownlint-disable -->
**Decide:** G1 is isomorphic to G2 <br/> <!-- markdownlint-disable -->
_Variation:_ **SGI - SubGIsom (NPC)** - given 2 graphs, _decide_ is one isomorphic to a subgraph of the other?

## SAT

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a _set of clauses_ (disjunction of literals eg x V not y ) <br/> <!-- markdownlint-disable -->
**Decide:**: is there a satisfying truth assignment? <br/> <!-- markdownlint-disable -->
_Variations:_ **3SAT (NPC)**- given a set of clauses of _3 literals_, better for reductions <br/> <!-- markdownlint-disable -->

## HP

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ an undirected graph (no loops or multiple edges)<br/> <!-- markdownlint-disable -->
**Decide:**: is there a path visiting each _node_ exactly once? <br/> <!-- markdownlint-disable -->
_Variation:_ **TC (NPC)**

## TSP

**NPC, TSP(D) strongly NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a set of n cities and distances between them. <br/> <!-- markdownlint-disable -->
**Optimise:** find a tour visiting each city once and returning to the start of shortest distance. <br/> <!-- markdownlint-disable -->
**Decide - TSP(D):** **(NPC)** - also given _a bound B_, decide if we can visit each city once and return to the start _
with total distance <= B._

## IP(D)

**NPC** <br/> <!-- markdownlint-disable -->
Decision version of zero-one integer programming.<br/> <!-- markdownlint-disable -->
_Given:_ given f(x) subject to constraints.
**Optimise:** Maximize f(x) with integer solutions only.

## TRI

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ 3 sets B, G, H each with n elements and T ⊆ B × G × H<br/> <!-- markdownlint-disable -->
**Decision:** is there a set of n triples in T such that no 2 triples have elements in common? <br/> <!-- markdownlint-disable -->

## BIN

Decision version of Scheduling <br/> <!-- markdownlint-disable -->
**NPC, strongly NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a set of n items with sizes s1, ..., sn and bins each with capacity c <br/> <!-- markdownlint-disable -->
**Optimise:** find the minimum number of bins required to accommodate the n items.<br/> <!-- markdownlint-disable -->
**Decide - BIN(D):** **(NPC)** (same as Scheduling) - Given n positive integers a1,...,an (the items), B (number of
bins), and C (capacity), can we partition the numbers into B subsets, each of which has sum ≤ C? .

## KNAPSACK

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ m items with values vi and weights wi, and weight limit W.<br/> <!-- markdownlint-disable -->
**Optimize:** Want to pick some to maximise value, subject to weight ≤ W <br/> <!-- markdownlint-disable -->
**Decide - KNAPSACK(D):** **(NPC)** given K, can we have value >= K?

## SubsetSum

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a set of m positive integers and another integer K. <br/> <!-- markdownlint-disable -->
**Decide:** is there a subset with sum = K?

## IND

**NPC** <br/> <!-- markdownlint-disable -->
Given an undirected graph G a set I of nodes of G is said to be independent if no 2 nodes of I are adjacent.<br/> <!-- markdownlint-disable -->
_Given:_ a graph G and k >= 0 <br/> <!-- markdownlint-disable -->
**Decide:** does G have an independent set of size k?

## CLIQUE

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ an undirected graph G and a natural number N, a clique is a set I ⊆ nodes(G) such that if i, j ∈ I then i and j
are adjacent.<br/> <!-- markdownlint-disable -->
**Decide:** is there a clique of size N?

## VC

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a graph G,a vertex cover is a subset U of the vertices of G such that for every edge of G, at least one
endpoint is in U <br/> <!-- markdownlint-disable -->
**Optimise:** find the size of the smallest vertex cover <br/> <!-- markdownlint-disable -->
**Decide - VC(D):** is there a vertex cover of size <= B?

## PARTITION

**NPC** <br/> <!-- markdownlint-disable -->
_Given:_ a sequence a1, ..., an of positive integers <br/> <!-- markdownlint-disable -->
**Decide:** is there a subset S of {1, ..., n} such that Sum\[ai\](i in S) = Sum\[ai\](i not in S)

## Quantiﬁed Boolean Formulae (QBF)

**PSPACEC** <br/> <!-- markdownlint-disable -->
Given a formula of the form ∃x1∀x2 ...Qxn.ϕ(x1,...,xn)
is it true?
