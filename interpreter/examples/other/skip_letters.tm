put testStringToSkip
filler =
state g1

[a-zA-Z] g1 -> $$ g1 R
=        g1 -> =  g0 S

