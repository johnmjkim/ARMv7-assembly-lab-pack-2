.syntax unified
.global main

.type main, %function
main:
  @ LED Output setup
  @ load r1 with the base address of P0
  ldr r1, =0x50000000

  @ load r2 with the value of P0 DIR
  @ (note the 0x514 offset from the P0 base address)
  ldr r2, [r1, 0x514]

  @ set bit 21 of this register by doing a logical or with 0b1 left-shifted by 21
  @ think: why does this work?
  mov r3, 0b1
  lsl r3, r3, #21
  orr r2, r2, r3

  @ @ set bit 28 of this register by doing a logical or with 0b1 left-shifted by 28
  @ @ and then use or operation to set both 21 & 28
  @ mov r4, 0b1
  @ lsl r4, r4, #28
  @ orr r2, r2, r4

  @ store the modified result back into P0 DIR
  str r2, [r1, 0x514]

  @ LED Output setup
  @ load r1 with the base address of P1
  ldr r1, =0x50000300

  @ load r2 with the value of P1 DIR
  @ (note the 0x514 offset from the P1 base address)
  ldr r2, [r1, 0x514]

  @ set bit 5 of this register by doing a logical or with 0b1 left-shifted by 5
  @ think: why does this work?
  mov r3, 0b1
  lsl r3, r3, #5
  orr r2, r2, r3

  @ store the modified result back into P1 DIR
  str r2, [r1, 0x514]

  b lighton
@ when it's all done, spin in an infinite loop

lighton:
  nop
  @ load r1 with the base address of P0
  ldr r1, =0x50000000

  @ load r2 with the value of P0 OUT
  @ (note the 0x504 offset from the P0 base address)
  ldr r2, [r1, 0x504]

  @ set bit 21 of this register by doing a logical or with 0b1 left-shifted by 21
  mov r3, 0b1
  lsl r3, r3, #21
  orr r2, r2, r3

  @ store the modified result back into P0 OUT
  str r2, [r1, 0x504]
  ldr r5, =0x500000
  b delayandlightoff

lightoff:
  nop
  @ load r1 with the base address of P0
  ldr r1, =0x50000000

  @ load r2 with the value of P0 OUT
  @ (note the 0x504 offset from the P0 base address)
  ldr r2, [r1, 0x504]

  @ set bit 21 of this register by 0
  mov r2, 0

  @ store the modified result back into P0 OUT
  str r2, [r1, 0x504]
  ldr r5, =0x500000
  b delayandlighton

delayandlightoff:
  nop
  subs r5, r5, 1
  bmi lightoff

  b delayandlightoff

delayandlighton:
  nop
  subs r5, r5, 1
  bmi lighton

  b delayandlighton
