-module(main). 
-export([empty_tree/0,empty/0,binary_tree/4,fold/3,get/2,put/3,is_empty/1]).

% empty tree
empty()->
  spawn(?MODULE, empty_tree,[]).

% empty tree behaviour
empty_tree()->
  
  receive
    
    {is_empty,PID} ->PID ! true,
      empty_tree();

    {get,_,PID} ->
      PID!{nothing},
      empty_tree();
    
    {put,K,V,PID} ->
      PID!done, 
      % evolving to binary tree behaviour
      binary_tree(K,V, empty(),empty());    

    {fold,FE,_,PID} ->
      PID!{folded, FE,self()},
      empty_tree()
  end. 

binary_tree(K,V,LSubtree,RSubtree)->

    receive

      {is_empty,PID} ->
            PID!false,
            binary_tree(K,V,LSubtree,RSubtree);        

      {get,Key,PID}->
            if (K == Key) ->
                PID!{just,V};
            (K < Key)->
                RSubtree!{get,Key,PID};              
            (K > Key) ->
                LSubtree!{get,Key,PID}
            end,
            binary_tree(K,V,LSubtree,RSubtree);      
        

      {put,Key,Value,PID} ->
            if(Key > K) ->
                RSubtree!{put,Key,Value,self()},
                PID!done,
                binary_tree(K,V,LSubtree,RSubtree);
            (Key == K) ->
                PID!done,
                binary_tree(K,Value,LSubtree,RSubtree);
            Key < K ->
                LSubtree!{put,Key,Value,self()},
                PID!done,
                binary_tree(K,V,LSubtree,RSubtree)

            end;

       

        {fold,FE,FB,PID} ->
                % folding left sub tree
                LSubtree!{fold, FE,FB,self()},        
                VL = receive
                       {folded,RESL,_} -> RESL 
                     end,
                %folding right subtree
                RSubtree!{fold, FE,FB,self()},        
                VR = receive 
                       {folded, RESR,_} -> RESR 
                     end,        
                PID ! {folded, FB(VL,K,V,VR),self()},        
                binary_tree(K,V,LSubtree,RSubtree)

    end.

 
%wrapper functions

%to get a value from a tree by key
get(PID,K) ->
    PID! {get,K,self()}, 
    receive
        {just,M}->M;
        {nothing} -> nothing
    end.

% to put a new key/value pair in a tree
put(PID,K,V) ->
    PID! {put,K,V,self()}, 
    receive
        done -> done   
    end.

% to check if a tree is empty
is_empty(PID) -> 
    PID ! {is_empty , self()},
    receive
        X -> X
    end.

% to fold a tree
fold(PID,FE,FB) ->
    PID ! {fold, FE,FB,self()},
    receive
        {folded, RES, _} -> RES
    end.
