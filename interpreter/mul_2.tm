put 0111110
cursor 1
state q1
filler 0

0 q1 -> 0 q0 S
1 q1 -> 0 q2 R

1 q2 -> 1 q2 R
0 q2 -> 0 q3 R

1 q3 -> 1 q3 R
0 q3 -> 1 q4 R
0 q4 -> 1 q5 L

1 q5 -> 1 q5 L
0 q5 -> 0 q6 L

0 q6 -> 0 q0 S
1 q6 -> 1 q7 L

1 q7 -> 1 q7 L
0 q7 -> 0 q1 R

