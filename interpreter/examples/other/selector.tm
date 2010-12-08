put 1111101011011101111
state q1
filler 0

# input:  k, x1, ..., xn
# output: xk

1 q1 -> 0 q2 R

1 q2 -> 1 q3 R
  1 q3 -> 1 q3 R
  0 q3 -> 0 q4 R

  0 q4 -> 0 q4 R
  1 q4 -> 0 q5 R
  1 q5 -> 0 q5 R
  0 q5 -> 0 q6 L

  0 q6 -> 0 q6 L
  1 q6 -> 1 q7 L
  1 q7 -> 1 q7 L
  0 q7 -> 0 q1 R

0 q2 -> 0 q8 R
  0 q8 -> 0 q8 R
  1 q8 -> 1 q9 R

  1 q9 -> 1 q9 R
  0 q9 -> 0 q10 R

  0 q10 -> 0 q11 L
    0 q11 -> 0 q11 L
    1 q11 -> 1 q12 L

    1 q12 -> 1 q12 L
    0 q12 -> 0 q13 R
    1 q13 -> 1 q0 S

  1 q10 -> 0 q14 R
    1 q14 -> 0 q14 R
    0 q14 -> 0 q10 R

