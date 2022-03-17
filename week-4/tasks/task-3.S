.syntax unified
.global main

.type main, %function
main:
  ldr r1, =storage
  @ your code starts here
  ldr r0, [r1, 12]
  add r0, r0, 1
  str r0, [r1, 12]
.data
storage:
  .word 2, 3, 0, 0 @ don't change this line