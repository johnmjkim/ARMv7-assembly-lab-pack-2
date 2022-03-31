.syntax unified
.global main

.type main, %function
@ r6 : number of arrays
@ r7 : total index
@ r8 : store 4
@ r9 : counting index
@ r10 : -1
@ r11 : storing index
main:
  @ Checked all correct in view memory of =results
  @ All successfully stores letter grades in data =results
  @ 0F, 0C, 0E, 0B, 0C, 0A
  ldr r0, =results
  ldr r6, [r0]
  mov r8, 4
  mul r9, r6, r8
  mul r7, r9, r8
  mov r9, 4
  mov r10, -1
  push {lr}
  bl calculate_lab_grades
  pop {lr}
  nop
  b main
.size main, .-main

.type calculate_lab_grades, %function
@ input:
@ r0: address of start of mark array with format,
@ .word size of array
@ .word a1, a2, final, 0
@ output:
@ .word a1, a2, final, grade
@ ...
calculate_lab_grades:
  push {lr}
  cmp r7, r9
  IT GE
  blge calculate_grade
  pop {lr}

  push {lr}
  cmp r7, r9
  IT GE
  blge calculate_lab_grades
  pop {lr}

  bx lr
.size calculate_lab_grades, .-calculate_lab_grades

.type calculate_grade, %function
@ args:
@ r2, ass1 mark, worth 25% mark
@ r3, ass2 mark, worth 25% mark
@ r4, final exam mark, worth 50% mark
@ result: r2
calculate_grade:
  ldr r2, [r0, r9]
  add r9, r9 , r8
  ldr r3, [r0, r9]
  add r9, r9, r8
  ldr r4, [r0, r9]
  add r9, r9, r8
  @ Use nested function to call  
  push {lr}
  bl calculate_total_mark
  pop {lr}
  @ Convert total mark to grade
  push {lr}
  bl grade_from_mark
  pop {lr}
  mul r11, r9, r10
  str r5, [r0, r9]
  add r9, r9, r8
  bx lr
.size calculate_grade, .-calculate_grade

.type grade_from_mark, %function
@ args:
@ r2, numerical mark
@ result: r5
grade_from_mark:
  mov r2, r5
  subs r1, r2, #50
  bpl notF 
  mov r5, 0xF
  bx lr
.size grade_from_mark, .-grade_from_mark

notF:
  subs r1, r2, #60
  bpl notE
  mov r5, 0xE
  bx lr

notE:
  subs r1, r2, #70
  bpl notD
  mov r5, 0xD
  bx lr

notD:
  subs r1, r2, #80
  bpl notC
  mov r5, 0xC
  bx lr

notC:
  subs r1, r2, #90
  bpl notB
  mov r5, 0xB
  bx lr

notB:
  mov r5, 0xA
  bx lr

.type calculate_total_mark, %function
@ args:
@ r2, ass1 mark, worth 25% mark
@ r3, ass2 mark, worth 25% mark
@ r4, final exam mark, worth 50% mark
@ result: r5
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
  udiv r5, r2, r5

  @ @ go back to where the function was called from
  bx lr
.size calculate_total_mark, .-calculate_total_mark

.data
results:
  @ Length of array: 6
  .word 6
  @S1
  .word 50, 50, 40, 0
  @S2
  .word 77, 80, 63, 0
  @S3
  .word 40, 50, 60, 0
  @S4
  .word 80, 82, 89, 0
  @S5
  .word 80, 85, 77, 0
  @S6
  .word 91, 90, 95, 0