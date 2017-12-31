% A matrix which contains zeroes and ones gets "x-rayed" vertically and
% horizontally, giving the total number of ones in each row and column.
% The problem is to reconstruct the contents of the matrix from this
% information. Sample run:
%
%	?- p.
%	    0 0 7 1 6 3 4 5 2 7 0 0
%	 0
%	 0
%	 8      * * * * * * * *
%	 2      *             *
%	 6      *   * * * *   *
%	 4      *   *     *   *
%	 5      *   *   * *   *
%	 3      *   *         *
%	 0
%	 0
%

:- use_module(library(clpfd)).

ejemplo1( [0,0,8,2,6,4,5,3,7,0,0], [0,0,7,1,6,3,4,5,2,7,0,0] ).
ejemplo2( [10,4,8,5,6], [5,3,4,0,5,0,5,2,2,0,1,5,1] ).
ejemplo3( [11,5,4], [3,2,3,1,1,1,1,2,3,2,1] ).


p:-	ejemplo1(RowSums,ColSums), print('1'), nl,
	length(RowSums,NumRows), print('2'), nl,
	length(ColSums,NumCols),  print('3'), nl,
	NVars is NumRows*NumCols,  print('4'), nl,
	listVars(NVars,L),  print('5'), nl,  % generate a list of Prolog vars (their names do not matter)
	L ins 0..1,  print('6'), nl,
	matrixByRows(L,NumCols,MatrixByRows),  print('7'), nl,
	transpose(MatrixByRows, MatrixByCols),  print('8'), nl,
	declareConstraints(NumRows, MatrixByRows, RowSums),  print('9'), nl,
	declareConstraints(NumCols, MatrixByCols, ColSums),  print('10'), nl,
	%labeling(L, MatrixByRows),  print('11'), nl,
	pretty_print(RowSums,ColSums,MatrixByRows).


pretty_print(_,ColSums,_):- write('     '), member(S,ColSums), writef('%2r ',[S]), fail.
pretty_print(RowSums,_,M):- nl,nth1(N,M,Row), nth1(N,RowSums,S), nl, writef('%3r   ',[S]), member(B,Row), wbit(B), fail.
pretty_print(_,_,_).
wbit(1):- write('*  '),!.
wbit(0):- write('   '),!.


listVars(NVars, L):- length(L, NVars).

matrixByRows([], _, []).
matrixByRows(L, NumCols, [X|MatrixByRows]):-
   length(X, NumCols),
   append(X, L1, L),
   matrixByRows(L1, NumCols, MatrixByRows).

declareConstraints(0, [], []):-!.
declareConstraints(NumElem, [L | Matrix], [RealSum | ElemSums]):-
	sum(L, #=, RealSum),
	NextNumElem is NumElem - 1,
	declareConstraints(NextNumElem, Matrix, ElemSums).

sum([X], X).
sum([Y, Z | L], Sum) :-
	X is Y + Z,
  sum([X | L], Sum).
