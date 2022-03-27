.syntax unified
.global main

.type main, %function
main:
  @ set up the arguments
  mov r0, 66 @ ass1 mark
  mov r1, 73 @ ass2 mark
  mov r2, 71 @ final exam mark

  @ call the function
  bl calculate_total_mark

  @ go to the end loop
  b end
.size main, .-main

end:
  b end

.type calculate_total_mark, %function
@ args:
@ r0, ass1 mark, worth 25% mark
@ r1, ass2 mark, worth 25% mark
@ r2, final exam mark, worth 50% mark
@ result: r0
calculate_total_mark:
  mov r3, 25
  mul r0, r0, r3
  mul r1, r1, r3

  mov r3, 50
  mul r2, r2, r3
  
  add r0, r0, r1
  add r0, r0, r2

  @ @ put the result in r0
  mov r3, 100
  udiv r0, r0, r3

  @ @ go back to where the function was called from
  bx lr
.size calculate_total_mark, .-calculate_total_mark
