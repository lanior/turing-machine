put 1111111111111111111111110111111
state q1
filler 0

# input: a0b
# c=a/b, a > 0, b > 0

1 q1 -> 0 q13 R

# a=1
0 q13 -> 0 q14 R

# a>1
1 q13 -> 1 q2 R

1 q2 -> 1 q2 R
0 q2 -> 0 q3 R

# find rightmost 1 in b
0 q3 -> 0 q3 R
1 q3 -> 0 q4 R

# b=0 for now
0 q4 -> 0 q5 R
 # increase c by 1
 1 q5 -> 1 q5 R
 0 q5 -> 1 q6 L

 1 q6 -> 1 q6 L
 0 q6 -> 0 q7 L

 # restore b
 0 q7 -> 1 q7 L
 1 q7 -> 1 q8 R

 # restore ab separator
 1 q8 -> 0 q12 L

1 q4 -> 1 q10 L
 0 q10 -> 0 q10 L
 1 q10 -> 1 q12 L

# find leftmost 1 in a
1 q12 -> 1 q12 L
0 q12 -> 0 q1 R

# erase b
0 q14 -> 0 q14 R
1 q14 -> 0 q15 R

# b=1 => a%b=0, add one 1
0 q15 -> 1 q0 S

# a%b!=0
1 q15 -> 0 q16 R
 1 q16 -> 0 q16 R
 0 q16 -> 0 q0 S

