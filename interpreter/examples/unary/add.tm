put 1111101111
state q1
filler 0

# input: a0b
# c=a+b, a > 0, b > 0

1 q1 -> 0 q2 R

1 q2 -> 1 q2 R
0 q2 -> 1 q0 S

