put 1212222
state q1
filler 0

# input:  a, a>0
# output: reversed a

1 q1 -> 0 q2 R
 1 q2 -> 1 q2 R
 2 q2 -> 2 q2 R
 0 q2 -> 1 q3 L
2 q1 -> 0 q4 R
 1 q4 -> 1 q4 R
 2 q4 -> 2 q4 R
 0 q4 -> 2 q3 L

1 q3 -> 0 q5 L
 1 q5 -> 1 q5 L
 2 q5 -> 2 q5 L
 0 q5 -> 1 q1 R
2 q3 -> 0 q6 L
 1 q6 -> 1 q6 L
 2 q6 -> 2 q6 L
 0 q6 -> 2 q1 R

0 q3 -> 0 q7 L

0 q7 -> 0 q11 R
 0 q11 -> 0 q11 R
 1 q11 -> 1 q0 S
 2 q11 -> 2 q0 S
1 q7 -> 0 q8 R
 0 q8 -> 1 q9 L
2 q7 -> 0 q10 R
 0 q10 -> 2 q9 L
0 q9 -> 0 q7 L

