.syntax unified
.global main

.type main, %function
main:
  ldr r0, =0xcafe0000
  ldr r1, =0xffff

  @ orr instruction to make 0xcafe ffff
  @ 0xcafe0000 OR 0xffff
  orr r3, r0, r1

  @ lsr instruction to make 0xcafe
  @ shift right 4-bit
  lsr r4, r0, 16

  @ make r5 0xca00 0000
  lsr r2, r0, 24
  lsl r5, r2, 24
  @ make r2 0xff 0000
  lsr r2, r1, 8
  lsl r2, r2, 16
  @ orr instruction to make 0xcaff 0000
  orr r5, r5, r2

  @ make r6 0xc000 0000
  lsr r6, r0, 28
  lsl r6, r6, 28
  @ make r2 0xfe 0000
  lsl r2, r0, 8
  lsr r2, r2, 8
  @ orr instruction to make 0xc0fe 0000
  orr r6, r6, r2

@ when it's all done, spin in an infinite loop
loop:
  nop
  b loop