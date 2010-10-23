put 101101010
state q1
filler =

# find right border
0 q1 -> 0 q1 R
1 q1 -> 1 q1 R
= q1 -> = q2 L

# decrease by one
1 q2 -> 0 q3 L
 0 q3 -> 0 q1 R
 1 q3 -> 1 q1 R
 = q3 -> = q4 R
  0 q4 -> = q1 R
0 q2 -> 1 q2 L
= q2 -> = q0 S

