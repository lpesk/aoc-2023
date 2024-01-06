NB. Parsing

NB. Cut on newlines to represent the input as a table of characters.
in =. ] ;. _2 freads '3_input.txt'

NB. Helpers

NB. A bitmap with a 1 wherever 'in' has a digit character.
numeric =. < (e.&((48 + i.10) { a.)) in

NB. A verb that zeros out the first 'x' rows of 'y' if 'x' is positive, or the last abs('x') rows of y
NB. if 'x' is negative.
zero =: dyad : ' 0 ((i. ` ({.&(i.(#y))) @. (<&0)) x) } y '
NB. A verb that shifts a 2-dimensional numeric array (right arg) upward by a number of rows (left arg),
NB. leaving zeros in the bottom row(s). Shifts downward if the left arg is negative.
up =. ([ |. zero)
NB. A verb that shifts a 2-dimensional numeric array (right arg) leftward by a number of rows (left arg),
NB. leaving zeros in the bottom row(s). Shifts rightward if the left arg is negative.
left =. up&.|:
NB. A verb that removes the middle element from an odd-length list (right arg).
exclude =. (((<.@ %&2 @ #) ~: (i. @ #)) # ])

NB. A verb that takes a bitmap 'y' (right arg) and returns another bitmap with a 1 in all cells that are adjacent
NB. (in any direction, including diagonally) to a '1' cell of 'y'.
adjacent =: monad : '+.&.> / exclude , (1 0 _1) (left)&.> / ((1 0 _1) up&.> / y) '"0
NB. A verb that takes a bitmap 'y' (right arg) and a length 'x' (left arg) and returns another bitmap with a 1 in
NB. all cells that:
NB. (1) contain a digit in 'in', and either:
NB. (2a) contain a '1' in 'y', or
NB. (2b) are connected to a '1' in 'y' by a consecutive string of at most 2*'x' digits.
NB. This gives a bitmap of the positions of all <= 2*'x'-digit numbers that are selected by 'y'.
digits =. ([ ((+.&.> / @ ( numeric&(*.&.>) @ ((1 0 _1) & (left&.> /)))) @ ]) ((<: @ [) $: ])) ` (numeric&(*.&.>) @ ]) @. (0&= @ [)

NB. A adverb that, given a verb that computes a boxed bitmap (or list of boxed bitmaps) of the positions of some
NB. set of symbols, returns a verb that computes a list of the numbers that are adjacent to that set of symbols.
NB. This calls 'digits' with a length equal to the right arg's row length, but a length of 2 is enough to solve the problems.
numbers =: adverb : ' (". @  ,)&.> @ ( ((# @ |: @ ]) digits (adjacent @ u @ ])) (#"0)&.> <) '

NB. Part 1

NB. A verb that returns a boxed bitmap of all the symbol positions in the input.
symbols =. < @ (e.&'+-*#$%/=@&')
NB. Compute the list of numbers that are adjacent to a symbol, and display the sum.
+/ > (symbols numbers) in

NB. Part 2

NB. This time, we need to know the length of the list of adjacent numbers for each individual symbol.
NB. Compute a bitmap of the positions of '*' characters, then fan it out into a boxed list of bitmaps that each
NB. have a single '1' cell.
indicator =: dyad : ' < ($ x) $ (- y) |. (1, ((<: #, x) $ 0)) '"_ 0
symbols =. (] indicator (I. @ , @ e.&'*' @ ]))
NB. A verb that, given a numeric list (right arg), returns the product of the elements if the list has length 2, or 0 otherwise.
ratio =. 0:`(*/)@.(2&=@#)
NB. For each star, compute its gear ratio if it has exactly 2 adjacent numbers, and sum the results.
+/ > ratio&.> (symbols numbers) in