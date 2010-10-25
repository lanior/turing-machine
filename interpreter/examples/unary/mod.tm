put 11111101111
state q1
filler 0

# input: a0b
# c=a%b, a > 0, b > 0

# erase 1 in a
1 q1 -> 0 q13 R

# inverse b
0 q13 -> 1 q14 R
 0 q14 -> 1 q14 R

 1 q14 -> 0 q15 R

 # b=c, erase everything
 0 q15 -> 0 q17 L
  0 q17 -> 0 q17 L
  1 q17 -> 0 q18 L
  1 q18 -> 0 q18 L
  0 q18 -> 0 q0 S
 # b>c, continue inversing
 1 q15 -> 0 q16 R
  1 q16 -> 0 q16 R
  0 q16 -> 0 q0 S

1 q13 -> 1 q2 R

# qo to b
1 q2 -> 1 q2 R
0 q2 -> 0 q4 R

0 q4 -> 0 q4 R

# find leftmost 1 in b
1 q4 -> 0 q5 R
 # restore b
 0 q5 -> 0 q6 L
  0 q6 -> 1 q6 L
  # restore ab separator
  1 q6 -> 1 q7 R
  1 q7 -> 0 q10 L
 1 q5 -> 1 q9 L
 0 q9 -> 0 q10 L

# qo to a
0 q10 -> 0 q10 L
1 q10 -> 1 q12 L

# find leftmost 1 in a
1 q12 -> 1 q12 L
0 q12 -> 0 q1 R

