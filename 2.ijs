NB. Parsing

NB. Arranges the data as a list of boxed tables. Each top-level box represents a game.
NB. The tables have one row per round.
NB. Each cell of the table is a 2-element boxed list of form (<count>, <color>).
games =. (< @ ;: ;. _2 @ (','&(,~)) ;. _2 @ (';'&(,~))) each (1&{ @ (< ;. _2 @ (':'&(,~)))) ;. _2 freads '2_input.txt'

NB. Helpers

NB. A verb that extracts the counts from 'games' and converts the numeric strings to numbers.
count =. (".)&.(> @ > @ >) @ ((0&{"1)&.(> @ >))
NB. A verb that extracts the color names from 'games'.
color =. (1&{"1)&.(> @ >)
NB. A verb that computes all the indices in 'games' (left arg) of cells that have a given color (right arg).
match =. ; @ ((< @ < @ < @ ]) =&.(> @ >) (color @ [))
NB. A verb that computes the max count per game, given a list of games (left arg) and a color name (right arg).
max =.  > @ ((>./ @ ,)&.>) @ > @ > @ (([ match ]) #"0&.(> @ > @ >) (count @ [))

NB. Part 1

NB. Compute the per-game max for each color, select the game indices that match the constraints, and sum those IDs.
+/ >: I. (((games max 'blue') <: 14) *. ((games max 'red') <: 12) *. ((games max 'green') <: 13))

NB. Part 2

NB. Multiply the per-color maxes for each game, then sum.
+/ (games max 'blue') * (games max 'red') * (games max 'green')
