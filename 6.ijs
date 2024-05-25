NB. Parsing

NB. Cut the input on newlines, then colons, then drop the rows containing the text.
in =. > 1&{ each < ;. _2 each ':' ,~ each < ;. _2 freads '6_input.txt'

NB. Part 1

NB. Arrange the input as a 2-row table where row 0 is time and row 1 is distance, with columns corresponding to rounds of the game.
data =. ". > in

NB. The relationship between the race length (T), the charging time (P), and the distance traveled (D) is D = P * (T - P).
NB. This is a downward-facing parabola with its peak at T/2, so D will be greater than the goal distance (G) as long as P is strictly between the two x-coordinates of the intersections of the parabola with the line y = G.
NB. The intersection points have x-values = (T/2 +/- (sqrt(T^2 - 4G)/2)), and 'count' returns the number of integer points strictly between those points.

NB. Helpers

NB. Round up to the next integer that is strictly greater.
up =. (>.) ` (>:) @. (] = >.)
NB. Round down to the nearest integer that is strictly smaller.
down =. (<.) ` (<:) @. (] = <.)

NB. Take the difference between the two (rounded) solutions to the quadratic equation.
count =. (>: @: ((down @ %&2) @: ([ + (%: @: ((*: @ [) - (4&* @ ]))))) - ((up @ %&2) @: ([ - (%: @: ((*: @ [) - (4&* @ ]))))))

NB. Apply 'count' to the rows of 'data', then take the product of those results.
*/ (({.@]) count ({:@])) data

NB. Part 2

NB. Re-parse, converting rows to strings and stripping out empty characters.
data =. >> ". each ((' '&~: # ])) each ":&.> > each in

NB. Same calculation as part 1.
*/ (({.@]) count ({:@])) data
