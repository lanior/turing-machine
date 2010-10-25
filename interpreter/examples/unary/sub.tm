put 11111011
state q1
filler 0

# input: a0b
# a > 0, b > 0
# c=a-b, a>b
# c=0, a<=b

# a--
1 q1 -> 0 q2 R

# a=0, erase b
0 q2 -> 0 q3 R
 1 q3 -> 0 q3 R
 0 q3 -> 0 q0 S

1 q2 -> 1 q4 R

# skip a
1 q4 -> 1 q4 R
0 q4 -> 0 q5 R

1 q5 -> 1 q6 R

# b=1, erase and stop
0 q6 -> 0 q7 L
 1 q7 -> 0 q0 S

# b>1, find rightmost 1
1 q6 -> 1 q8 R
1 q8 -> 1 q8 R
0 q8 -> 0 q9 L

# b--
1 q9 -> 0 q10 L

1 q10 -> 1 q10 L
0 q10 -> 0 q11 L

# find leftmost 1 in a
1 q11 -> 1 q11 L
0 q11 -> 0 q1 R

