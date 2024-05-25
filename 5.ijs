NB. Parsing

NB. Cut the input at newlines.
in =. < ;. _2 LF ,~ freads '5_input.txt'
NB. Extract the sequence of maps.
NB. Each map is represented as a list of boxed numeric triples, and `maps` is a boxed list of maps.
maps =. ". each each }. each < ;. _2 }.}. in

NB. Part 1

NB. Extract the seeds, represented as a boxed flat list.
seeds =. ". each 1&{ < ;. _2 ':'&(,~) @ > {. in

NB. Helpers

NB. Check if a map range (a numeric triple; left arg) contains an integer (right arg)
contains =. (((1&{ @ [) <: ]) *. (((2&{ + 1&{) @ [) > ]))
NB. Given a list of map ranges and an input, checks if any of the ranges contains the input.
NB. If so, returns the updated integer; otherwise, returns 0.
NB. (The puzzle is constructed so that each input is affected by at most one range in each map.)
new =. +&.> / @: ((((0&{ @ [) + (] - (1&{ @ [))) * contains)&.>)
NB. Given a list of map ranges and an input, checks if any of the ranges contains the input.
NB. If not, returns the original integer; otherwise, returns 0.
old =. (] *&.> (-.&.> @ (+.&.> / @: (contains&.>))))
NB. Given a list of map ranges and an input, returns the updated input if one of the ranges includes
NB. the input, or returns the unchanged input if not.
update =. (new +&.> old)

NB. A verb that iterates over the maps, applying each map to the output of the previous one.
  apply =: dyad : 0
current =. y
for_map. x do. current =. (> map) update current end.
> current
)

NB. Apply the maps to the input seeds, and return the minimum of the final output.
<. /  maps apply seeds

NB. Part 2

NB. The strategy:
NB. 1. Given a map, split all of the input ranges against the map ranges. After this step,
NB.    each of the new input ranges is either contained in or disjoint from any given
NB.    range of the map.
NB. 2. Identify the set of input ranges that are affected by (i.e. contained in) some map range.
NB. 3. Subtract affected input ranges from the original input ranges; the resulting ranges are
NB.    returned unchanged.
NB. 4. Shift the affected ranges according to the map.

NB. Re-parse the seeds, this time as a list of boxed numeric pairs.
pairs =. <"1 (((2&(%~) @ #) , 2:) $ ]) (> seeds)

NB. Helpers

NB. Given a map range (a numeric triple; left arg) and an input range (a numeric pair; right arg),
NB. checks whether the ranges intersect.
intersects =. (((1&{ @ [) < ((1&{ + 0&{) @ ])) *. (((2&{ + 1&{) @ [) > (0&{ @ ])))
NB. Given a map range (a numeric triple; left arg) and an input range (a numeric pair; right arg),
NB. returns their intersection as either a boxed numeric pair of form [start length], or an empty
NB. box.
intersection =. (> @ a:) ` (< @ (((1&{ @ [) >. (0&{ @ ])) , ((((2&{ + 1&{) @ [) <. ((1&{ + 0&{) @ ])) - ((1&{ @ [) >. (0&{ @ ]))))) @. intersects
NB. Given a map range (a numeric triple; left arg) and an input range (a numeric pair; right arg)
NB. that is either *contained* in the map range or is *disjoint* from it, returns either the
NB. shifted range or an empty result (respectively).
transform =. (> @ a:) ` (< @ (((0&{ @ ]) - ((1&{ @ [) - (0&{ @ [))) , (1&{ @ ]))) @. intersects

NB. Given two ranges (numeric pairs), return the sub-range of the left range that is below the right range.
below =. (> @ a:) ` ((0&{ @ [) , ((0&{ @ > @ ]) - (0&{ @ [))) @. ((0&{ @ [) < (0&{ @ > @ ]))
NB. Given two ranges (numeric pairs), return the sub-range of the left range that is above the right range.
above =. (((0&{ + 1&{) @ > @ ]) , (((0&{ + 1&{) @ [) - ((0&{ + 1&{) @ > @ ]))) ` (> @ a:) @. (((0&{ + 1&{) @ [) <: ((0&{ + 1&{) @ > @ ]))

NB. Given a range (a numeric pair; left arg) and a list of ranges (right arg), return a list of sub-ranges
NB. of the left range that are *not* contained in any ranges of the right arg.
  remainder =: dyad : 0
current =. x
result =. a:
for_range. y do.
   result =. (result , (<(current below range)))
   current =. (current above range)
end.
NB. Removes any empty boxes that accumulated in the result before returning.
((((a:)&~:) # ]) (result , <current))
)

NB. Given a list of maps (left arg) and a list of input ranges (right arg), successively
NB. applies each map to the output of the previous one.
  apply =: dyad : 0
current =. y
for_map. x do.
   NB. For each input range, get a sorted list of intersections with the map ranges.
   intersections =. ((/: @ ]) { ])&.> (,&.> / ((> map) intersection&.> / current))
   NB. For each input range, find the sub-ranges which are unaffected by all map ranges.
   remain =. (current remainder&.> intersections)
   NB. Transform each of the affected ranges.
   transformed =. (, ((> map) transform&.> / (; intersections)))
   NB. Append the unaffected ranges to the transformed ranges.
   current =. (; transformed) , (; remain)
end.
current
)

NB. Apply the maps to the input seed ranges, extract the first element of each output range,
NB. and return the smallest value.
<. / > (0&{)&.> (maps apply pairs)
