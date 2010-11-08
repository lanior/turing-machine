put ((1+3)*2-6)/2+1*((3))
filler =
state rpn-1

# @rpn(rpn-1 -> halt)
# input:  a - expr
# output: a - expr in RPN

= rpn-1 -> = rpnc-1 L
  s         rpnc-1 -> s rpnc-1  L
  =         rpnc-1 -> = rpnc-2  L

  [-+*/|()] rpnc-2 -> $$ rpnc-2 L
  =         rpnc-2 -> S  rpo-1  R


[0-9] rpn-1 -> $$ rmn-1 R

+ rpn-1 -> s rpnoa-1 L
  s         rpnoa-1 -> s  rpnoa-1 L
  =         rpnoa-1 -> =  rpnoa-2 L

  [-+*/|()] rpnoa-2 -> $$ rpnoa-2 L
  =         rpnoa-2 -> +  rpo-1   R

- rpn-1 -> s rpnos-1 L
  s         rpnos-1 -> s  rpnos-1 L
  =         rpnos-1 -> =  rpnos-2 L

  [-+*/|()] rpnos-2 -> $$ rpnos-2 L
  =         rpnos-2 -> -  rpo-1   R

* rpn-1 -> s rpnom-1 L
  s         rpnom-1 -> s  rpnom-1 L
  =         rpnom-1 -> =  rpnom-2 L

  [-+*/|()] rpnom-2 -> $$ rpnom-2 L
  =         rpnom-2 -> *  rpo-1   R

/ rpn-1 -> s rpnod-1 L
  s         rpnod-1 -> s  rpnod-1 L
  =         rpnod-1 -> =  rpnod-2 L

  [-+*/|()] rpnod-2 -> $$ rpnod-2 L
  =         rpnod-2 -> /  rpo-1   R

( rpn-1 -> s rpnop-1 L
  s         rpnop-1 -> s  rpnop-1 L
  =         rpnop-1 -> =  rpnop-2 L

  [-+*/|()] rpnop-2 -> $$ rpnop-2 L
  =         rpnop-2 -> (  rpo-1   R

) rpn-1 -> s rpnoc-1 L
  s         rpnoc-1 -> s  rpnoc-1 L
  =         rpnoc-1 -> =  rpnoc-2 L

  [-+*/|()] rpnoc-2 -> $$ rpnoc-2 L
  =         rpnoc-2 -> )  rpo-1   R

# @rpn_process_operator(rpo-1 -> rpor-1 or main)
# input:  a - operator
# cursor: after a

= rpo-1 -> = rpoa-1 L
  # append operator
  s rpoa-1 -> s rpoa-1 L

  + rpoa-1 -> = rpoaa-1 R
    s rpoaa-1 -> = rpoaa-1 R
    | rpoaa-1 -> | rpoaa-2 L
    = rpoaa-1 -> = rpoaa-2 L

    = rpoaa-2 -> + rpoaa-3 L
    = rpoaa-3 -> | rpor-1  R

  - rpoa-1 -> = rpoas-1 R
    s rpoas-1 -> = rpoas-1 R
    | rpoas-1 -> | rpoas-2 L
    = rpoas-1 -> = rpoas-2 L

    = rpoas-2 -> - rpoas-3 L
    = rpoas-3 -> | rpor-1  R

  * rpoa-1 -> = rpoam-1 R
    s rpoam-1 -> = rpoam-1 R
    | rpoam-1 -> | rpoam-2 L
    = rpoam-1 -> = rpoam-2 L

    = rpoam-2 -> * rpoam-3 L
    = rpoam-3 -> | rpor-1  R

  / rpoa-1 -> = rpoad-1 R
    s rpoad-1 -> = rpoad-1 R
    | rpoad-1 -> | rpoad-2 L
    = rpoad-1 -> = rpoad-2 L

    = rpoad-2 -> / rpoad-3 L
    = rpoad-3 -> | rpor-1  R

  ( rpoa-1 -> = rpoap-1 R
    s rpoap-1 -> = rpoap-1 R
    | rpoap-1 -> | rpoap-2 L
    = rpoap-1 -> = rpoap-2 L

    = rpoap-2 -> ( rpoap-3 L
    = rpoap-3 -> | rpor-1  R

  ) rpoa-1 -> = rpor-1 R


S rpoa-1 -> = rpof-1 R
  # finish!
  s        rpof-1 -> =  rpof-1 R
  =        rpof-1 -> =  rpof-2 R
  s        rpof-2 -> =  rpof-2 R
  =        rpof-2 -> =  rpof-3 R

  # remove rightmost |
  [1|+*/-] rpof-3 -> $$ rpof-3 R
  =        rpof-3 -> =  rpof-4 L

  |        rpof-4 -> =  rpof-5 L
  =        rpof-4 -> =  rpof-5 L

  [1|+*/-] rpof-5 -> $$ rpof-5 L
  =        rpof-5 -> =  main   R
# =        rpof-5 -> =  halt   S


| rpo-1 -> | rpoc-1 R
  # precedence check
  + rpoc-1 -> + rpoca-1 L
  - rpoc-1 -> - rpoca-1 L
    |        rpoca-1 -> |  rpoca-2 L
    s        rpoca-2 -> s  rpoca-2 L

    [S)+-]   rpoca-2 -> $$ rpopo-1 R
    [(*/]    rpoca-2 -> $$ rpoca-3 L
    =        rpoca-3 -> =  rpoa-1  R

  * rpoc-1 -> * rpocm-1 L
  / rpoc-1 -> / rpocm-1 L
    |        rpocm-1 -> |  rpocm-2 L
    s        rpocm-2 -> s  rpocm-2 L

    [S)*/+-] rpocm-2 -> $$ rpopo-1 R
    (        rpocm-2 -> $$ rpocm-3 L
    =        rpocm-3 -> =  rpoa-1  R

  ( rpoc-1 -> ( rpocp-1 L
    |        rpocp-1 -> |  rpocp-2 L
    s        rpocp-2 -> s  rpocp-2 L

    [S(*/+-] rpocp-2 -> $$ rpocp-3 L
    =        rpocp-3 -> =  rpoa-1  R

    )        rpocp-2 -> =  rpocp-4 R
    s        rpocp-4 -> =  rpocp-4 R
    |        rpocp-4 -> =  rpocp-5 R
    (        rpocp-5 -> =  rpor-1  R



# @rpn_pop_operator(rpopo-1 -> rpo-1)
s rpopo-1 -> s rpopo-1 R
| rpopo-1 -> s rpopo-2 R

+ rpopo-2 -> s rpopoa-1 R
  [-+*/|()]    rpopoa-1 -> $$ rpopoa-1 R
  =            rpopoa-1 -> =  rpopoa-2 R

  [0-9s()+*/-] rpopoa-2 -> $$ rpopoa-2 R
  =            rpopoa-2 -> =  rpopoa-3 R
  [1|+*/-]     rpopoa-3 -> $$ rpopoa-3 R
  =            rpopoa-3 -> +  rpopor-1 R

- rpopo-2 -> s rpopos-1 R
  [-+*/|()]    rpopos-1 -> $$ rpopos-1 R
  =            rpopos-1 -> =  rpopos-2 R

  [0-9s()+*/-] rpopos-2 -> $$ rpopos-2 R
  =            rpopos-2 -> =  rpopos-3 R
  [1|+*/-]     rpopos-3 -> $$ rpopos-3 R
  =            rpopos-3 -> -  rpopor-1 R

* rpopo-2 -> s rpopom-1 R
  [-+*/|()]    rpopom-1 -> $$ rpopom-1 R
  =            rpopom-1 -> =  rpopom-2 R

  [0-9s()+*/-] rpopom-2 -> $$ rpopom-2 R
  =            rpopom-2 -> =  rpopom-3 R
  [1|+*/-]     rpopom-3 -> $$ rpopom-3 R
  =            rpopom-3 -> *  rpopor-1 R

/ rpopo-2 -> s rpopod-1 R
  [-+*/|()]    rpopod-1 -> $$ rpopod-1 R
  =            rpopod-1 -> =  rpopod-2 R

  [0-9s()+*/-] rpopod-2 -> $$ rpopod-2 R
  =            rpopod-2 -> =  rpopod-3 R
  [1|+*/-]     rpopod-3 -> $$ rpopod-3 R
  =            rpopod-3 -> /  rpopor-1 R


# put | and return to op stack
=            rpopor-1 -> |  rpopor-2 L
[1|+*/-]     rpopor-2 -> $$ rpopor-2 L
=            rpopor-2 -> =  rpopor-3 L

[0-9s()+*/-] rpopor-3 -> $$ rpopor-3 L
=            rpopor-3 -> =  rpopor-4 L

[-+*/|()]    rpopor-4 -> $$ rpopor-4 L
s            rpopor-4 -> s  rpo-1    R



# @rpn_process_op_return(rpor-1 -> rpn-1)

[-+*/|(]     rpor-1 -> $$ rpor-1 R

=            rpor-1 -> =  rpor-2 R

s            rpor-2 -> s  rpor-2 R
[0-9()+*/=-] rpor-2 -> $$ rpor-3 L

=            rpor-3 -> =  rpn-1  R
s            rpor-3 -> s  rpn-1  R



# @rpn_move_number(rmn-1 -> rpn-1)
# input:  a - decimal number
# appends unary a to output

[0-9]     rmn-1 -> $$ rmn-1 R
[()+*/=-] rmn-1 -> $$ rmn-2 L

0 rmn-2 -> 9 rmn-2  L
1 rmn-2 -> 0 rmn-3  R
2 rmn-2 -> 1 rmn-3  R
3 rmn-2 -> 2 rmn-3  R
4 rmn-2 -> 3 rmn-3  R
5 rmn-2 -> 4 rmn-3  R
6 rmn-2 -> 5 rmn-3  R
7 rmn-2 -> 6 rmn-3  R
8 rmn-2 -> 7 rmn-3  R
9 rmn-2 -> 8 rmn-3  R
= rmn-2 -> = rmne-1 R
s rmn-2 -> s rmne-1 R
  # erase decimal number
  # add | to output and return

  9           rmne-1 -> s  rmne-1 R
  [()+*/=-]   rmne-1 -> $$ rmne-2 L
  s           rmne-2 -> s  rmne-3 R

  [0-9()+*/-] rmne-3 -> $$ rmne-3 R
  =           rmne-3 -> =  rmne-4 R
  [1|+*/-]    rmne-4 -> $$ rmne-4 R
  =           rmne-4 -> |  rmne-5 L

  [1|+*/-]    rmne-5 -> $$ rmne-5 L
  =           rmne-5 -> =  rmne-6 L
  [0-9()+*/-] rmne-6 -> $$ rmne-6 L
  s           rmne-6 -> s  rpn-1  R


[0-9()+*/-] rmn-3 -> $$ rmn-3 R
=           rmn-3 -> =  rmn-4 R

[1|+*/-]    rmn-4 -> $$ rmn-4 R
=           rmn-4 -> 1  rmn-5 L

[1|+*/-]    rmn-5 -> $$ rmn-5 L
=           rmn-5 -> =  rmn-6 L

[0-9()+*/-] rmn-6 -> $$ rmn-6 L

=           rmn-6 -> = rmn-1  R
s           rmn-6 -> s rmn-1  R



# @main(main -> halt)
# input:  a - RPN expr
# output: r - calculated result

# exit
= main -> = me-1 L
  s me-1 -> = me-1   L
  = me-1 -> = me-2   L

  = me-2 -> 0 halt   S
  | me-2 -> = pbe-1  L
  1 me-2 -> 1 me-3   L

  | me-3 -> = pbe-1  L
  1 me-3 -> 1 me-3   L
  = me-3 -> = rdec-1 R

# push number
1 main -> s mn-1 L
  s mn-1 -> s mn-1 L
  = mn-1 -> = mn-2 L

  1 mn-2 -> 1 mn-2 L
  | mn-2 -> | mn-2 L

  = mn-2 -> 1 mr-1 R

# push stack separator
| main -> s ms-1 L
  s ms-1 -> s ms-1 L
  = ms-1 -> = ms-2 L

  1 ms-2 -> 1 ms-2 L
  | ms-2 -> | ms-2 L

  = ms-2 -> | mr-1 R

# pop and sum 2 args
+ main -> s moa-1 L
  s moa-1 -> s moa-1 L
  = moa-1 -> = moa-2 L

  1 moa-2 -> 1 moa-2 L
  | moa-2 -> | moa-2 L

  = moa-2 -> = moa-3 R
  | moa-3 -> = mad-1 R

# pop and sub 2 args
- main -> s mos-1 L
  s mos-1 -> s mos-1 L
  = mos-1 -> = mos-2 L

  1 mos-2 -> 1 mos-2 L
  | mos-2 -> | mos-2 L

  = mos-2 -> = mos-3 R
  | mos-3 -> = msu-1 R

# pop and mul 2 args
* main -> s mom-1 L
  s mom-1 -> s mom-1 L
  = mom-1 -> = mom-2 L

  1 mom-2 -> 1 mom-2 L
  | mom-2 -> | mom-2 L

  = mom-2 -> = mom-3 R
  | mom-3 -> = mmu-1 R

# pop and div 2 args
/ main -> s mod-1 L
  s mod-1 -> s mod-1 L
  = mod-1 -> = mod-2 L

  1 mod-2 -> 1 mod-2 L
  | mod-2 -> | mod-2 L

  = mod-2 -> = mod-3 R
  | mod-3 -> = mdi-1 R

# return to a
1 mr-1 -> 1 mr-1 R
| mr-1 -> | mr-1 R
= mr-1 -> = mr-2 R


s         mr-2 -> s  mr-2 R
[1|+*/=-] mr-2 -> $$ mr-3 L

s         mr-3 -> s  main R

#
# operations
#

# @addition(mad-1 -> mr-1)
# input:  b|a
# output: r, r=a+b

1 mad-1 -> = mad-2 R
| mad-1 -> = mr-1  R

1 mad-2 -> 1 mad-2 R
| mad-2 -> 1 mr-1  R



# @subtraction(msu-1 -> mr-1)
# input:  b|a
# output: r, r=a-b, a>b
# output: 0, a<=b

# b<=a
| msu-1 -> = msur-1 R
  # skip a and return
  s msur-1 -> = msur-1 R
  1 msur-1 -> 1 msur-1 R
  | msur-1 -> | mr-1   L
  = msur-1 -> = msur-2 L
  = msur-2 -> = mr-1   R
  1 msur-2 -> 1 mr-1   R

# go to a
1 msu-1 -> 1 msu-2 R
1 msu-2 -> 1 msu-2 R
| msu-2 -> | msu-3 R

s msu-3 -> s msu-3 R

# a<b, clear b
| msu-3 -> | msuc-1 L
= msu-3 -> = msuc-1 L
  s msuc-1 -> s msuc-1 L
  | msuc-1 -> s msuc-2 L

  1 msuc-2 -> s msuc-2 L
  = msuc-2 -> = msur-1 R

# a--, b--
1 msu-3 -> s msu-4 L
s msu-4 -> s msu-4 L
| msu-4 -> | msu-5 L

1 msu-5 -> 1 msu-5 L
= msu-5 -> = msu-6 R
1 msu-6 -> = msu-1 R



# @multiplication(mmu-1 -> mr-1)
# input:  b|a
# output: r, r=a*b

| mmu-1 -> = mmue-1 R
  # erase a and return
  1 mmue-1 -> = mmue-1 R
  = mmue-1 -> = mmue-2 L
  | mmue-1 -> | mmue-2 L
  = mmue-2 -> = mr-1   R

1 mmu-1 -> = mmu-3 R

| mmu-2 -> = mr-1 R
1 mmu-2 -> = mmu-3 R

1 mmu-3 -> 1 mmu-3 R
s mmu-3 -> s mmu-3 R
| mmu-3 -> | mmu-4 R

1 mmu-4 -> 1 mmu-4 R
= mmu-4 -> = mmu-5 L
| mmu-4 -> | mmu-5 L
s mmu-4 -> s mmu-5 L

| mmu-5 -> | mmur-1 L
  s mmur-1  -> s mmur-2  L

  # erase b,a if a=0
  1 mmur-1  -> = mmue2-1 L
  = mmur-1  -> = mmue2-3 R

  # erase b,a and return
  1 mmue2-1 -> = mmue2-1 L
  = mmue2-1 -> = mmue2-3 R

  = mmue2-3 -> = mmue2-3 R
  | mmue2-3 -> = mmue-1  R

  # a>0
  s mmur-2 -> s mmur-2 L
  = mmur-2 -> = mmur-3 R
  1 mmur-2 -> 1 mmur-3 R

  s mmur-3 -> | mmur-4 R
  s mmur-4 -> 1 mmur-4 R
  | mmur-4 -> 1 mmur-5 L

  1 mmur-5 -> 1 mmur-5 L
  | mmur-5 -> | mmur-6 L

  1 mmur-6 -> 1 mmur-7 L

  1 mmur-7 -> 1 mmur-7 L
  = mmur-7 -> = mmu-2  R

1 mmu-5 -> s mmu-6 L
1 mmu-6 -> 1 mmu-6 L
| mmu-6 -> | mmu-7 L

# b=0
= mmu-7 -> = mmuc-1 R
  # convert s to 1 and return
  | mmuc-1 -> = mmuc-2 R
  1 mmuc-2 -> 1 mmuc-2 R
  s mmuc-2 -> 1 mmuc-2 R

  = mmuc-2 -> = mmuc-3 L
  | mmuc-2 -> | mmuc-3 L

  1 mmuc-3 -> 1 mr-1   R

s mmu-7 -> s mmu-7 L
1 mmu-7 -> s mmu-8 L

1 mmu-8 -> 1 mmu-8 L
= mmu-8 -> 1 mmu-3 R



# @division(mdi-1 -> mr-1)
# input:  b|a
# output: r, r=a/b, b > 0

1 mdi-1  -> s mdis-1 R

1 mdis-1 -> 1 mdi-3  R

# b=1
| mdis-1 -> = mdis-2 L
  s mdis-2 -> = mdis-3 R
  = mdis-3 -> = mr-1   R

1 mdi-2 -> s mdi-3 R

1 mdi-3 -> 1 mdi-3 R
| mdi-3 -> | mdi-4 R

1 mdi-4 -> 1 mdi-4 R
= mdi-4 -> = mdi-5 L
| mdi-4 -> | mdi-5 L
s mdi-4 -> s mdi-5 L

| mdi-5 -> s mdir-1 L
  1 mdir-1 -> s mdir-1 L
  s mdir-1 -> s mdir-1 L
  = mdir-1 -> = mdir-2 R

  s mdir-2 -> = mdir-2 R
  1 mdir-2 -> 1 mdir-3 L
  = mdir-2 -> = mdir-3 L
  | mdir-2 -> | mdir-3 L

  1 mdir-3 -> 1 mr-1   R
  = mdir-3 -> = mr-1   R

1 mdi-5 -> s mdi-6 L
1 mdi-6 -> 1 mdi-6 L
| mdi-6 -> | mdi-7 L

s mdi-7 -> s mdii-1 R
  # c++
  | mdii-1 -> | mdii-2 R
  1 mdii-2 -> 1 mdii-2 R
  s mdii-2 -> s mdii-3 R

  s mdii-3 -> s mdii-3 R
  1 mdii-3 -> 1 mdii-4 L
  = mdii-3 -> = mdii-4 L
  | mdii-3 -> | mdii-4 L

  s mdii-4 -> 1 mdii-5 L

  # go to b
  s mdii-5 -> s mdii-5 L
  1 mdii-5 -> 1 mdii-5 L
  | mdii-5 -> | mdii-6 L

  # restore b
  s mdii-6 -> 1 mdii-6 L
  = mdii-6 -> = mdi-2  R

1 mdi-7 -> 1 mdi-8 L
1 mdi-8 -> 1 mdi-8 L
s mdi-8 -> s mdi-2 R



# @result_to_dec(rdec-1 -> halt)
# input:  a - unary
# output: r - decimal

1 rdec-1 -> 1 rdec-1 R
= rdec-1 -> = rdec-2 L

1 rdec-2 -> = rdec-3 L
1 rdec-3 -> 1 rdec-3 L
= rdec-3 -> = rdec-4 L

= rdec-4 -> 1 rdec-5 R
0 rdec-4 -> 1 rdec-5 R
1 rdec-4 -> 2 rdec-5 R
2 rdec-4 -> 3 rdec-5 R
3 rdec-4 -> 4 rdec-5 R
4 rdec-4 -> 5 rdec-5 R
5 rdec-4 -> 6 rdec-5 R
6 rdec-4 -> 7 rdec-5 R
7 rdec-4 -> 8 rdec-5 R
8 rdec-4 -> 9 rdec-5 R
9 rdec-4 -> 0 rdec-4 L

[0-9] rdec-5 -> $$ rdec-5 R
=     rdec-5 -> =  rdec-6 R

1 rdec-6 -> 1 rdec-1 R
= rdec-6 -> = rdec-7 L
  =     rdec-7 -> =  rdec-8 L
  [0-9] rdec-8 -> $$ rdec-8 L

  =     rdec-8 -> =  rdec-9 R
  [0-9] rdec-9 -> $$ halt   S



# @bad_expression(pbe-1 -> halt)
# output: badExpr

1 pbe-1 -> = pbe-1 L
| pbe-1 -> = pbe-1 L
= pbe-1 -> = pbe-2 R

= pbe-2 -> b pbe-3 R
= pbe-3 -> a pbe-4 R
= pbe-4 -> d pbe-5 R
= pbe-5 -> E pbe-6 R
= pbe-6 -> x pbe-7 R
= pbe-7 -> p pbe-8 R
= pbe-8 -> r halt  S

