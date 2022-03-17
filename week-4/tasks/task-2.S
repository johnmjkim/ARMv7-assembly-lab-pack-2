.syntax unified
.global main

.type main, %function
main:
  nop
  @ instruction calls address of label operation
  ldr r1, =operation

  @ instruction calls address of label checkpoint
  @ the label checkpoint is done after the instruction 'movs r3, 1'
  ldr r2, =checkpoint

  @ we obtain size of instruction 'movs r3, 1' by subtracting two addresses r2, r1
  sub r0, r2, r1
@ when it's all done, spin in an infinite loop

loop:
  nop
  b loop

.data

  @ we obtain size of instruction 
operation:
  movs r3, 1
checkpoint: