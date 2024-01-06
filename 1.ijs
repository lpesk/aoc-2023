NB. Parsing

NB. Cut the input at every occurrence of its final character (i.e. '\n'), giving a boxed list of the input strings.
strings=. < ;. _2 freads '1_input.txt'

NB. Part 1

NB. Form the set of non-digit ascii characters by excluding the digit range from the ascii range.
digits =. (48 + i.10) { a.
nondigits =. a. -. digits

NB. Strip the non-digits from the input strings, then select the first and last characters from each string.
NB. Finally, convert each 2-digit string to a number.
reconstruct =. (". @ ({. , {:) @ (-. & nondigits)) @ >

NB. Sum the results.
+/ reconstruct strings

NB. Part 2

NB. Make two lists, one of number names and one of digits.
NB. It's convenient for these to have the same shape, so reformat the raw character list 'digits' from part 1
NB. into a boxed list of character lists (each of length 1).
numbers =. 'zero' ; 'one' ; 'two' ; 'three' ; 'four' ; 'five' ; 'six' ; 'seven' ; 'eight' ; 'nine'
digits =. 1 < \ digits

NB. Given a string, form a table of all the infixes of length <= 5 (the length of the longest number name).
NB. Take the transpose of the infix table so that entries are ordered by the index of their first character, then by length.
NB. Then, for each substring in the table, find its index in 'numbers' and in 'digits' and take the minimum.
NB. For convenience in the next steps, flatten each table into a list of indices.
NB. Select the indices that are <10, since an index of 10 means that the substring isn't in either list.
NB. Take the first and last elements of each numeric list, convert them to characters, concatenate, and convert back to a number.
reconstruct =. ((". @ (": @ {., ": @ {:) @ ]) ((<&10) # ]) @ (; @ ;) / @ (numbers & i. <. digits & i.) @ |: @ ((>: i.5) < \ ])) @ >

NB. Sum the results.
+/ reconstruct strings
