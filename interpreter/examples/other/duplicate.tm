put 111
state q1
filler 0

# input:  a, a>0
# output: a0b, b=a

# make border
1 q1 -> 1 q2 L
0 q2 -> 0 q3 L
0 q3 -> 1 q4 R
0 q4 -> 0 q5 R

# move 1
1 q5 -> 0 q6 R

1 q6 -> 1 q6 R
0 q6 -> 0 q8 R

1 q8 -> 1 q8 R
0 q8 -> 1 q9 L

# find separator
1 q9 -> 1 q9 L
0 q9 -> 0 q10 L

1 q10 -> 1 q11 L
 # a>0, find leftmost 1
 1 q11 -> 1 q11 L
 0 q11 -> 0 q5 R
0 q10 -> 1 q12 L
 # a=0, lets restore it
 0 q12 -> 1 q12 L

 # found border
 # erase it
 1 q12 -> 0 q13 R
 1 q13 -> 0 q14 R

 # come back
 1 q14 -> 1 q0 S

