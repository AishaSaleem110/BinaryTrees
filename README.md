# BinaryTrees
The task is to implement binary search trees (a form of finite map) as trees of processes. Every tree node, including empty trees, is a process. The behaviour
of these processes can evolve, so in particular each empty subtree is a different process.

We need two kinds of tree process behaviour: empty trees, and binary tree nodes. What they should do is dependent on the protocol which we will come
to later. The data these behaviours carry (parameters of their functions) is as follows:

• empty trees: no data

• binary tree nodes: a key, a value (both of these are arbitrary Erlang values), and two tree nodes. One of the tree nodes contains in its expanded
tree only nodes whose keys are smaller than this key, the other contains only nodes whose keys are larger. Note: “tree node” means here that they
are process identifiers.


### The Code

This code is written in Erlang

### Running The Code
*To run the code, open the https://replit.com/~ and create a new Replit and paste the code:

Start the erlang shell by typing the following in the replit console:

erl
c(main).
% then to create an empty binary tree type the following:
A = main:empty().

*The files are self-contained and all necessary libraries are imported.

