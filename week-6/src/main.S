.syntax unified
.global main

.type main, %function
main:
  @ Calculate grade of student s2
  mov r0, 0
  bl calculate_grade @ Result is F in r0, 34 in r2

  @ Calculate grade of student s3
  mov r0, 4
  bl calculate_grade @ Result is D in r0, 69 in r2

  @ Calculate grade of student s4
  mov r0, 8
  bl calculate_grade @ Result is A in r0, 93 in r2

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
  mov r5, r0
  @ Use nested function to call  
  @ bl calculate_total_mark
  push {lr}
  bl calculate_grade_sa
  pop {lr}
  @ Convert total mark to grade
  push {lr}
  bl grade_from_mark
  pop {lr}
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
@ r2, free memory
@ r3, free memory
@ r4, free memory
@ r5, free memory
@ r6, free memory
# r7, free memory
calculate_grade_sa:
  @ TODO: prep for call
  push {lr}
  bl calculate_total_mark
  pop {lr}

  mov r2, r5

  @ store teacher's mark on top of stack
  str r0, [sp, -4]!
  @ delete the teacher's mark from r0
  mov r0, 0

  @ TODO: prep for call
  push {lr}
  bl self_assessment  @ cheat in here
  pop {lr}
  ldr r1, [sp], 4

  @ TODO: calculate final grade from: 
  @ - student mark (r0) 
  @ - teacher mark (r1)
  add r5, r1, #10

  cmp r5, r0
  IT LE
  suble r6, r1, r0
  cmp r5, r0
  IT LE
  addle r6, r1, r6

  cmp r5, r0
  IT GT
  addgt r6, r1, r0
  cmp r5, r0
  IT GT
  movgt r7, 2
  cmp r5, r0
  IT GT
  udivgt r6, r6, r7
  cmp r5, r0
  
  mov r0, r6
  bx lr
.size calculate_grade_sa, .-calculate_grade_sa

.type self_assessment, %function
self_assessment:
  @ TODO: return self assessed mark in r0
  ldr r3, =test_sa_grades
  ldr r0, [r3, r2]
  bx lr
.size self_assessment, .-self_assessment

.data
test_ass1_grades:
  .word 58, 68, 88
test_ass2_grades:
  .word 51, 81, 91
test_finalexam_grades:
  .word 41, 71, 91
test_sa_grades:
  .word 60, 66, 96