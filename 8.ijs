NB. Parsing

NB. Format the input as a boxed list. Then extract the initial directions
NB. as a string, and the current->(left, right) map as a 3-column table of boxed strings.
NB. In the comments below, let's say that a "position" is a row of this map.
in =. < ;. _2 freads '8_input.txt'
dir =. > 0 { in
map =. 0 3 5 {"1 > ;: each }.}. in

NB. Helpers

NB. Map an integer to an index into the list of directions, wrapping around.=
index =. (# dir) & |
NB. Given an integer index (right arg) into the list of directions, map it to a
NB. 'L' or 'R' direction, then get the left or right box from a position (left arg).
next =. (2&{ @ [) ` (1&{ @ [) @. ('L'&= @ (dir&({~) @ (index @ ])))
NB. Given a position in the map (left arg) and an index into the list of directions
NB. (right arg), follow the direction and return the next position.
follow =. , @ (map&(#~) @ ]) @ (0{"1 map = ]) @ (next)

NB. Starting from a position (right arg), walk a path to the end and return the
NB. number of steps.
  walk =: monad : 0 " 1
position =. y
step =. 0
while. -.(done position)
do. position =. position follow step
    step =. >: step
end.
step
)

NB. Part 1

NB. Start at the position with ID = 'AAA'.
start =. (((<'AAA') = (0&{"1)) # ]) map

NB. Define the stopping condition.
NB. We're done with a path when the position's first element is 'ZZZ'.
done =. ((<'ZZZ') = ({. @ ]))

NB. Walk the path and return the number of steps.
walk start

NB. Part 2

NB. Start at the positions whose IDs end in 'A'.
starts =. ((<'A') = ((2&{) each (0&{"1 @ ]) map)) (#) map

NB. Redefine the stopping condition.
NB. We're done with a path when the first element of the position starts with 'Z'.
done =. ('Z' = {: @ > @ {. @ ])

NB. Walk the path from each starting position, returning the number of steps for each
NB. path. Then compute the least common multiple of the path lengths.
*. / walk starts
