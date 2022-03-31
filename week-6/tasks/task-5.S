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
@ r1, free memory
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
  @ bl calculate_total_mark
  bl calculate_grade_sa
  @ Convert total mark to grade
  bl grade_from_mark
  ldr lr, [sp]
  bx lr
.size calculate_grade, .-calculate_grade

.type grade_from_mark, %function
@ args:
@ r1, free memeory
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
@ r1, free memory
@ r2, ass1 mark, worth 25% mark
@ r3, ass2 mark, worth 25% mark
@ r4, final exam mark, worth 50% mark
@ result: r0
calculate_total_mark:
  mov r1, 25
  mul r2, r2, r1
  mul r3, r3, r1

  mov r1, 50
  mul r4, r4, r1
  
  add r2, r3, r2
  add r2, r2, r4

  @ @ put the result in r0
  mov r1, 100
  udiv r0, r2, r1

  @ @ go back to where the function was called from
  bx lr
.size calculate_total_mark, .-calculate_total_mark

.type calculate_grade_sa, %function
calculate_grade_sa:
  @ TODO: prep for call
  bl calculate_total_mark

  @ store teacher's mark on top of stack
  str r0, [sp, -4]!
  @ delete the teacher's mark from r0
  mov r0, 0

  @ TODO: prep for call
  bl self_assessment  @ cheat in here
  ldr r1, [sp], 4

  @ TODO: calculate final grade from: 
  @ - student mark (r0) 
  @ - teacher mark (r1)
  @ ...
  bx lr
.size calculate_grade_sa, .-calculate_grade_sa

.type self_assessment, %function
self_assessment:
  @ TODO: return self assessed mark in r0
  @ ...
  bx lr
.size self_assessment, .-self_assessment

.data
test_ass1_grades:
  .word 58, 68, 88

.data
test_ass2_grades:
  .word 51, 81, 91

.data
test_finalexam_grades:
  .word 41, 71, 91