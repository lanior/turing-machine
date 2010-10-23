put 111011111
state q1
filler 0

# input: a0b
# c=a*b, a > 0, b > 0

# a times
1 q1 -> 1 q2 R
0 q1 -> 0 q14 R

1 q2 -> 1 q2 R
0 q2 -> 0 q3 R

# append b to c

# move 1 to c
1 q3 -> 0 q4 R
1 q4 -> 1 q4 R
0 q4 -> 0 q5 R

1 q5 -> 1 q5 R
0 q5 -> 1 q6 L

1 q6 -> 1 q6 L
0 q6 -> 0 q7 L

# find leftmost 1 in b
1 q7 -> 1 q8 L
 1 q8 -> 1 q8 L
 0 q8 -> 0 q3 R

# or restore b
0 q7 -> 1 q9 L
 0 q9 -> 1 q9 L
 1 q9 -> 1 q10 R
  # restore ab separator
  1 q10 -> 0 q11 L

# find leftmost 1 in a
1 q11 -> 1 q12 L

1 q12 -> 1 q12 L
0 q12 -> 0 q13 R

1 q13 -> 0 q1 R

# erase b
1 q14 -> 0 q14 R
0 q14 -> 0 q0 S

