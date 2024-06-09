NB. Parsing

NB. Replace '-' characters with J's negative sign '_'. Then convert the input
NB. to a numeric table.
in =. ". @ ('_' (I. @ ('-'&=) @ ]) } ]) ;. _2 freads '9_input.txt'

NB. Helpers

NB. Take the difference between an array and its shift one place to the right,
NB. dropping the first element of the difference.
diff =. (}. @ (] - (_1&|.)))"1

NB. Given an array (right arg), compute the list of successive diffs until the
NB. diff is all 0. Then apply a function 'next' to the list of diffs to predict
NB. a new value.
  predict =: monad : 0 " 1
stages =. <y
while. (+/ (0~: > {: stages))
do.
    stages =. stages , (diff&.> {: stages)
end.
next stages
)

NB. Part 1

NB. Select the last element from each stage of the progression.
NB. Sum them to get the prediction for the input row.
next =. (+/ @: ({: @ >))

NB. Compute the prediction for each input array and sum the results.
+/ predict in

NB. Part 2

NB. Select the first element from each stage of the progression.
NB. Sequentially subtract to get the prediction for the input row.
next =. (-/ @: ({. @ >))

NB. Compute the prediction for each input array and sum the results.
+/ predict in
