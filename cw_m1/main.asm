.macro Load_Const
ldi @0, low(1234)
ldi @1, high(1234)
.endmacro

MainLoop:
Load_const R16,R17
rjmp MainLoop
