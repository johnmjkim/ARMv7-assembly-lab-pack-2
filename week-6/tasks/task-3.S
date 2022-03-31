.syntax unified
.global main

.type main, %function
main:
  @ Calculate grade of student s2
  mov r0, 0
  bl calculate_grade @ Result is F in r0

  @ Calculate grade of student s3
  mov r0, 4
  bl calculate_grade @ Result is C in r0

  @ Calculate grade of student s4
  mov r0, 8
  bl calculate_grade @ Result is A in r0

  @ go to the end loop
  b end
.size main, .-main

end:
  b end

.type calculate_grade, %function
@ args:
@ r2, ass1 mark, worth 25% mark
@ r3, ass2 mark, worth 25% mark
@ r4, final exam mark, worth 50% mark
@ result: r2
calculate_grade:
  ldr r1, =test_ass1_grades
  ldr r2, [r1, r0]
  ldr r1, =test_ass2_grades
  ldr r3, [r1, r0]
  ldr r1, =test_finalexam_grades
  ldr r4, [r1, r0]
  @ Use nested function to call  
  str lr, [sp]
  bl calculate_total_mark
  @ Convert total mark to grade
  bl grade_from_mark
  ldr lr, [sp]
  bx lr
.size calculate_grade, .-calculate_grade

.type grade_from_mark, %function
@ args:
@ r2, numerical mark
@ result: r0
grade_from_mark:
  mov r2, r0
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

.type calculate_total_mark, %function
@ args:
@ r2, ass1 mark, worth 25% mark
@ r3, ass2 mark, worth 25% mark
@ r4, final exam mark, worth 50% mark
@ result: r0
calculate_total_mark:
  mov r5, 25
  mul r2, r2, r5
  mul r3, r3, r5

  mov r5, 50
  mul r4, r4, r5
  
  add r2, r3, r2
  add r2, r2, r4

  @ @ put the result in r0
  mov r5, 100
  udiv r0, r2, r5

  @ @ go back to where the function was called from
  bx lr
.size calculate_total_mark, .-calculate_total_mark

.data
test_ass1_grades:
  .word 58, 68, 88
test_ass2_grades:
  .word 51, 81, 91
test_finalexam_grades:
  .word 41, 71, 91