.syntax unified
.global main

.type main, %function
main:
  nop
  ldr r0, =operation
@ when it's all done, spin in an infinite loop

loop:
  nop
  b loop

.data
operation:
  movs r3, 1