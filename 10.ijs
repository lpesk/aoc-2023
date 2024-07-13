NB. Parsing

NB. Read in the input as a table of characters.
in =. ] ;. _2 freads '10_input.txt'

NB. Helpers
NB. The state at a given location is going to be represented by a boxed list
NB. of 2 elements: the first box contains the direction from which the location
NB. was entered, and the second contains a bitmap with a '1' at the location.
NB. Most of these helpers operate on that type or on one of its components.

NB. Shift a numeric table in the given direction, filling the new row or
NB. column with zeros.
right =. (|. !. 0)"1
left =. 1&right
down =. (|. !. 0)"2
up =. 1&down

NB. The same, but also record the direction of movement.
east =. < @ ('w' ; right)
west =. < @ ('e' ; left)
south =. < @ ('n' ; down)
north =. < @ ('s' ; up)

NB. Given a state, extract the direction and the location bitmap.
direction =. (> @ (0&{ @ > @ ]))
location =. (> @ (1&{ @ > @ ]))

NB. Given a location bitmap, get the character at that location.
char =. ((' '&~: # ]) @ , @ (in&(#"0~)) @ ])"2

NB. Given a list of 2 location bitmaps, return 1 if they are equal and 0 if different.
same =. ((+. /) @ , @ (*. /))

NB. Given a state, look up the corresponding character and return the next state.
  turn =. monad : 0 "0
loc =. location y
instr =. < (direction y) , (char loc)
if. instr = <'n|' do. south loc
elseif. instr = <'s|' do. north loc
elseif. instr = <'e-' do. west loc
elseif. instr = <'w-' do. east loc
elseif. instr = <'nL' do. east loc
elseif. instr = <'eL' do. north loc
elseif. instr = <'nJ' do. west loc
elseif. instr = <'wJ' do. north loc
elseif. instr = <'w7' do. south loc
elseif. instr = <'s7' do. west loc
elseif. instr = <'eF' do. south loc
elseif. instr = <'sF' do. east loc
else. a:
end.
)

NB. Find the two locations adjacent to the starting location, and return their states.
first =. (((a: ~: turn) # ]) @ (north , south , east , west) @ (e.&'S'))

NB. Part 1

NB. Given the map of the pipe system, find the two valid routes way from the
NB. starting point. Walk in both directions simultaneously until the paths meet.
NB. Return the step count.
  walk =. monad : 0
states =. first y
step =. 1
while. -.(same location states)
do. states =. turn states
    step =. >: step
end.
step
)

walk in

NB. Part 2

NB. A verb that gives the starting pipe shape, depending on the locations
NB. of the adjacent pipes.
  pipe =. monad : 0
y =. <y
if. y = <'ne' do. '7'
elseif. y = <'se' do. 'J'
elseif. y = <'nw' do. 'F'
elseif. y = <'sw' do. 'L'
else. a:
end.
)

NB. Given the map of the pipe system, draw a map of the main loop.
NB. Replace the 'S' starting pipe with the correct pipe shape.
NB. The result is a table of characters with a space character in
NB. every position that is not part of the main loop.
NB.
NB. (We could use this map to solve part 1: just count the number
NB. of nonempty locations and divide by 2.)
  draw =. monad : 0
map =. (y e. 'S')
states =. first y
start =. pipe direction states
input =. start (('S'&="0 @ ]) #"1 (i. @ #"1 @ ])) }"0 y
map =. map + (+. / location states)
while. -.(same location states)
do. states =. turn states
    map =. (map + (+. / location states))
end.
|: ,. / map #"0 input
)

NB. A location is inside the main loop if:
NB. * It's not on the main loop
NB. * In any given direction, a line extending outward from the location
NB.   has an odd number of intersections with the loop.
NB.
NB. Let's count the loop crossings to the left of each location.
NB. For each location on the map, score it as follows:
NB. +1 for each '|' to the left of the location
NB. +1 for each 'F-J' pattern to the left of the location (with any number of '-'s)
NB. +1 for each 'L-7' pattern to the left of the location (with any number of '-'s)
NB.
NB. More precisely, we'll assign a score to the substring of characters to the left
NB. of a location (inclusive) in the map of the main loop.

NB. Check whether a string is exactly an 'F-*J' pattern.
isfj =. (((*./ @ (=&'-')) +. (=&0 @ #))  @ (}. @ }:)) *. (=&'J' @ {:) *. (=&'F' @ {.)
NB. Check whether a string is exactly an 'L-*7' pattern.
isl7 =. (((*./ @ (=&'-')) +. (=&0 @ #))  @ (}. @ }:)) *. (=&'7' @ {:) *. (=&'L' @ {.)

NB. Scan over all substrings of a given string. Count the number of each kind of
NB. pattern, and sum the counts to get the total score for the string.
bars =. (+/ @: =&(<(,'|')))
fjs =. (+/ @: (> @ (isfj&.>)))
l7s =. (+/ @: (> @ (isl7&.>)))
scan =. , @ ((>: @ i. @ # @ ]) (< \) ])
score =. (fjs + l7s + bars) @ scan

NB. Draw the map of the main loop.
map =. draw in
NB. Compute the score for each location on the map; i.e., compute the string score
NB. for each prefix of each row of the map.
scores =. (> @ (score&.> @ (< \)))"1 map
NB. Select locations that are not on the main loop and that have odd scores.
inside =. (((2 | ]) scores) * (map e. ' '))
NB. Count the number of locations inside the loop.
+/+/ inside
