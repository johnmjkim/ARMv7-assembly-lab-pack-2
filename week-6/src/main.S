.syntax unified
.global main

.type main, %function
main:
  @ Set grades to mark : 15, 99, 70, 3
  mov r0, 0
  @ Convert grades to mark : 15 -> 0xF
  bl grade_from_mark_recursive_base

  mov r0, 4
  @ Convert grades to mark : 99 -> 0xA
  bl grade_from_mark_recursive_base

  mov r0, 8
  @ Convert grades to mark : 70 -> 0xC
  bl grade_from_mark_recursive_base

  mov r0, 12
  @ Convert grades to mark : 3 -> 0xF
  bl grade_from_mark_recursive_base

  @ go to the end loop
  b end
.size main, .-main

end:
  b end

.type grade_from_mark_recursive_base, %function
@ setup base case of recursive function
grade_from_mark_recursive_base:
  ldr r1, =test_grades
  ldr r2, [r1, r0]
  mov r3, 40
  mov r0, 0x10
  str lr, [sp]
  bl grade_from_mark_recursive
  ldr lr, [sp]
  bx lr
.size grade_from_mark_recursive_base, .-grade_from_mark_recursive_base

.type grade_from_mark_recursive, %function
@ args:
@ r2, numerical mark
@ result: r0
grade_from_mark_recursive:
  add r3, r3, 10
  sub r0, r0 , 1
  subs r1, r2, r3
  bpl grade_from_mark_recursive
  bx lr
.size grade_from_mark_recursive, .-grade_from_mark_recursive

.type grade_from_mark, %function
@ args:
@ r2, numerical mark
@ result: r0
grade_from_mark:
  subs r1, r2, #50
  bpl notF 
  mov r0, 0xF
  bx lr
.size grade_from_mark, .-grade_from_mark

notF:
  subs r1, r2, #60
  bpl notE
  mov r0, 0xE
  bx lr

notE:
  subs r1, r2, #70
  bpl notD
  mov r0, 0xD
  bx lr

notD:
  subs r1, r2, #80
  bpl notC
  mov r0, 0xC
  bx lr

notC:
  subs r1, r2, #90
  bpl notB
  mov r0, 0xB
  bx lr

notB:
  mov r0, 0xA
  bx lr

.data
test_grades:
  .word 15, 99, 70, 3