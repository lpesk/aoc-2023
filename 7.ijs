NB. Parsing

NB. Format the input as a 2-column table of strings.
in =. ": ;. _2 freads '7_input.txt'
NB. A verb that extracts the list of hands from 'in', still as strings.
hands =. ((i.5) {"1 ])
NB. A verb that extracts the list of bids from 'in', as integers.
bids =. (". @ (5&}.)"1)

NB. Part 1

NB. A list of card names in increasing rank order: '23456789TJQKA'
cards =. ((50 + i.8) { a.), 'TJQKA'

NB. Given a list of hands (right arg), calculate the number of occurrences of each card (left arg).
NB. Format each row of the result as a list of counts in descending order, padded with '0's on the
NB. right to a uniform length (like '1 1 1 1 1' or '3 1 1 0 0').
count =. (\: ])"1 @ ((0&~: # ]) @ (+/ @ |: @ ([ ="0 2 (hands @ ]))))"1

NB. A verb that generates row-level permutation keys from the per-hand card counts followed by card
NB. ranks, and orders the bids accordingly. Then multiplies each bid by its rank in the sorted list.
score =. (>: @ (i. @ (# @ ])) * ((bids @ ]) /: (count ,"1 i.)))

NB. Compute the score for each hand, then sum.
+/ cards score in

NB. Part 2

NB. The list of cards in the new increasing rank order.
cards =. 'J', ((50 + i.8) { a.), 'TQKA'

NB. Computes the per-hand card counts according to the new rules, first omitting the 'J's and then
NB. adding the 'J' count to the highest count.
count2 =. ((({. @ [) count ]) (([ + ({. @ ])) , (}. @ ]))"1 ((}. @ [) count ]))

NB. Computes the sum of scores in the same way as in Part 1.
score =. (>: @ (i. @ (# @ ])) * ((bids @ ]) /: (count2 ,"1 i.)))
+/ cards score in
