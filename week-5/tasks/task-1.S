.syntax unified
.global main

.type main, %function
main:
  @ mov r0, 3
  @ mov r1, 2
  @ bl sum_x_y

  ldr r1, =0x50000000
  mov r2, 0x514
  mov r3, #21
  bl set_bit

  mov r3, #28
  bl set_bit

  mov r2, 0x504
  mov r3, #21
  bl set_bit

  mov r3, #21
  bl clear_bit

  b main
@ when it's all done, spin in an infinite loop

@ .type sum_x_y, %function
@ sum_x_y:
@   add r0, r1
@   bx lr
@   .size sum_x_y, .-sum_x_y

.type set_bit, %function
@ args:
@ r1: base address
@ r2: offset
@ r3: bit index
@ result: r1
set_bit:
  nop
  @ load r4 to get value of pin by using r2
  ldr r4, [r1, r2]

  @ set bit of r4 at the bit index of r3
  @ by doing a logical or with 0b1 left-shifted by bit index r3
  mov r5, 0b1
  lsl r5, r5, r3
  orr r4, r4, r5

  @ store the modified result back into pin by using r2
  str r4, [r1, r2]
  bx lr
.size set_bit, .-set_bit

.type clear_bit, %function
@ args:
@ r1: base address
@ r2: offset
@ r3: bit index
@ result: r1
clear_bit:
  nop
  @ load r4 to get value of pin by using r2
  ldr r4, [r1, r2]

  @ set bit of r4 at the bit index of r3
  @ by doing a ~~~ with 0b1 left-shifted by bit index r3
  mov r5, 0b1
  lsl r5, r5, r3
  bic r4, r4, r5

  @ store the modified result back into pin by using r2
  str r4, [r1, r2]
  bx lr
.size clear_bit, .-clear_bit