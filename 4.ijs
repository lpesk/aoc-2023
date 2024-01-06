NB. Parsing

NB. Cut the input at newlines, then colons, then pipes.
cards =. ;: each >> ;. _2 each each '|' ,~ each each 1 & { each < ;. _2 each ':',~ each < ;. _2 freads '4_input.txt'
NB. Compute the number of matches for each card.
matches =. , > +/ each ((". each ; (0 & {) each cards) e.&.> (". each ; (1 & {) each cards))

NB. Part 1

NB. From 'matches', select elements that are > 0.
NB. Subtract 1 from each element and raise 2 to that power.
+/ 2&^ <: (-. (0&= @ >) # ]) matches

NB. Part 2

NB. The list of increments that should be added to the id of each card with a match.
increments =. (>: @ i."0) matches
NB. The list of ids of cards with matches.
ids =. >: (i. @ #) matches
NB. A table of all the card ids that are bundled together with a given id due to matches.
runs =. ids ,. (increments + ids) *. (-. (increments = 0))
NB. A verb that computes the multiplicity of a matching card id, given the multiplicities of all matching
NB. card ids that are less than that id.
multiplicity =. ] , >: @ ((( +/ @ (|: @ ((] @ $ (>: @ ])) ="0 (runs {~ i.))) ) @ # ) (+/ . *) ])
NB. Recurse to get the list of all multiplicities, and sum.
total =. (multiplicity @ $: @ }.) ` (1:) @. (# = 1:)
+/ total (>: i.(# cards))
