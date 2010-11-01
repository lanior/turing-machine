put 111111111111111111111111111111
state m1
filler 0

# input: a
# b=log6(a), a > 0

# @main
# entry point: m1
# exit point: m0

# call div6
0 m1 -> 0 m2 L
1 m1 -> 1 m2 L
0 m2 -> 0 d1 R

# till we got 0
0 m3 -> 0 m0 S
1 m3 -> 1 m4 L
 0 m4 -> 0 m5 L
 1 m5 -> 1 m5 L
 0 m5 -> 1 m6 R

 1 m6 -> 1 m6 R
 0 m6 -> 0 d1 R

# @div6
# entry point: d1
# exit point: m3

1 d1 -> 1 d2 R
0 d1 -> 1 d2 R

1 d2 -> 0 d3 R
0 d2 -> 0 d7 L

1 d3 -> 0 d4 R
0 d3 -> 0 d7 L

1 d4 -> 0 d5 R
0 d4 -> 0 d7 L

1 d5 -> 0 d6 R
0 d5 -> 0 d7 L

1 d6 -> 0 d8 R
0 d6 -> 0 d7 L

# remain < 6
0 d7 -> 0 d7 L
1 d7 -> 0 d15 L

# remain = 6
0 d8 -> 0 d9 L
0 d9 -> 0 d9 L
1 d9 -> 1 d15 L

# remain > 6
1 d8 -> 1 d10 L
0 d10 -> 0 d10 L
1 d10 -> 1 d11 R

0 d11 -> 1 d12 R
0 d12 -> 0 d12 R
1 d12 -> 0 d2 R

# find leftmost 1
1 d15 -> 1 d15 L
0 d15 -> 0 m3 R

