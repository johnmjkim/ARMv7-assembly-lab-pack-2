.syntax unified
.global main

.type main, %function
main:
  nop
  movs r3, 1
  ldr r0, =main

@ when it's all done, spin in an infinite loop
loop:
  nop
  b loop