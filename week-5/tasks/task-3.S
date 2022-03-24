.syntax unified
.global main

.type main, %function
main:
  @ Setup topleft LED : ROW1, COL1
  @ Light on-off the LED
  @ Unset topleft LED : ROW1, COL1
  bl set_topleft

  bl on_row1
  ldr r0, =0x500000
  bl time_delay
  bl off_row1
  ldr r0, =0x500000
  bl time_delay

  bl unset_topleft

  @ Setup topleft LED : ROW1, COL5
  @ Light on-off the LED
  @ Unset topleft LED : ROW1, COL5
  bl set_topright

  bl on_row1
  ldr r0, =0x500000
  bl time_delay
  bl off_row1
  ldr r0, =0x500000
  bl time_delay

  bl unset_topright

  b main

  mov r6, 0
  mov r7, 20
  mov r8, 3
  mov r9, 5
  mov r12, 0
  b count_loop

count_loop:
  @ number divisable with 3
  udiv r10, r6, r8
  mls r11, r10, r8, r6
  cmps r11, r12
  str lr, [sp]
  beq divisable3
  ldr lr, [sp]

  @ nubmer divisable with 5
  udiv r10, r6, r9
  mls r11, r10, r9, r6
  cmps r11, r12
  str lr, [sp]
  beq divisable5
  ldr lr, [sp]

  bl on_row1
  ldr r0, =0x500000
  bl time_delay
  bl off_row1
  ldr r0, =0x500000
  bl time_delay

  bl unset_topleft
  bl unset_topright

  add r6, r6, 1
  subs r10, r7, r6
  bpl count_loop
  b loop

loop:
  b loop

divisable3:
  bl set_topleft
  bx lr

divisable5:
  bl set_topright
  bx lr

.data
base_address:
  @ Base address of P0, P1
  .word 0x50000000, 0x50000300

.data
offset:
  @ Offest of OUT, DIR
  .word 0x504, 0x514

.data
led_row:
  @ LED pin row number 1~5
  @ ROW1, ROW2, ROW3, ROW4, ROW5
  .word 21, 22, 15, 24, 19

.data
led_col:
  @ LED pin col number 1~5
  @ COL1, COL2, COL3, COL4, COL5
  @ COL4 uses base address of P1
  .word 28, 11, 31, 5, 30

.type set_topleft, %function
set_topleft:
  @ Set base address of P0, 0x50000000
  ldr r0, =base_address
  ldr r1, [r0]
  @ Set offset as DIR, 0x514
  ldr r0, =offset
  ldr r2, [r0, 4]
  @ Set led row ROW1, 21
  ldr r0, =led_row
  ldr r3, [r0]
  str lr, [sp]
  bl set_bit
  ldr lr, [sp]

  @ Set led col COL1, 28
  ldr r0, =led_col
  ldr r3, [r0]
  str lr, [sp]
  bl set_bit
  ldr lr, [sp]
  bx lr
.size set_topleft, .-set_topleft

.type unset_topleft, %function
unset_topleft:
  @ Set base address of P0, 0x50000000
  ldr r0, =base_address
  ldr r1, [r0]
  @ Set offset as DIR, 0x514
  ldr r0, =offset
  ldr r2, [r0, 4]
  @ Set led row ROW1, 21
  ldr r0, =led_row
  ldr r3, [r0]
  str lr, [sp]
  bl clear_bit
  ldr lr, [sp]

  @ Set led col COL1, 28
  ldr r0, =led_col
  ldr r3, [r0]
  str lr, [sp]
  bl clear_bit
  ldr lr, [sp]
  bx lr
.size unset_topleft, .-unset_topleft

.type set_topright, %function
set_topright:
  @ Set base address of P0, 0x50000000
  ldr r0, =base_address
  ldr r1, [r0]
  @ Set offset as DIR, 0x514
  ldr r0, =offset
  ldr r2, [r0, 4]
  @ Set led row ROW1, 21
  ldr r0, =led_row
  ldr r3, [r0]
  @ set bit to set
  str lr, [sp]
  bl set_bit
  ldr lr, [sp]

  @ Set led col COL5, 30
  ldr r0, =led_col
  ldr r3, [r0, 16]
  @ set bit to set
  str lr, [sp]
  bl set_bit
  ldr lr, [sp]
  bx lr
.size set_topright, .-set_topright

.type unset_topright, %function
unset_topright:
  @ Set base address of P0, 0x50000000
  ldr r0, =base_address
  ldr r1, [r0]
  @ Set offset as DIR, 0x514
  ldr r0, =offset
  ldr r2, [r0, 4]
  @ Set led row ROW1, 21
  ldr r0, =led_row
  ldr r3, [r0]
  @ clear bit to unset
  str lr, [sp]
  bl clear_bit
  ldr lr, [sp]

  @ Set led col COL5, 30
  ldr r0, =led_col
  ldr r3, [r0, 16]
  @ clear bit to unset
  str lr, [sp]
  bl clear_bit
  ldr lr, [sp]
  bx lr
.size unset_topright, .-unset_topright

.type on_row1, %function
on_row1:
@ Offet of OUT, 0x504
  ldr r0, =offset
  ldr r2, [r0]
  
  ldr r0, =led_row
  ldr r3, [r0]
  str lr, [sp]
  bl set_bit
  ldr lr, [sp]
  bx lr
.size on_row1, .-on_row1

.type off_row1, %function
off_row1:
  ldr r0, =offset
  ldr r2, [r0]
  ldr r0, =led_row
  ldr r3, [r0]
  str lr, [sp]
  bl clear_bit
  ldr lr, [sp]
  bx lr
.size off_row1, .-off_row1

.type set_bit, %function
@ args:
@ r1: base address
@ r2: offset
@ r3: bit index
@ result: r1
set_bit:
  nop
  @ load r4 to get value of pin by using r2
  ldr r4, [r1, r2]

  @ set bit of r4 at the bit index of r3
  @ by doing a logical or with 0b1 left-shifted by bit index r3
  mov r5, 0b1
  lsl r5, r5, r3
  orr r4, r4, r5

  @ store the modified result back into pin by using r2
  str r4, [r1, r2]
  bx lr
.size set_bit, .-set_bit

.type clear_bit, %function
@ args:
@ r1: base address
@ r2: offset
@ r3: bit index
@ result: r1
clear_bit:
  nop
  @ load r4 to get value of pin by using r2
  ldr r4, [r1, r2]

  @ set bit of r4 at the bit index of r3
  @ by doing a ~~~ with 0b1 left-shifted by bit index r3
  mov r5, 0b1
  lsl r5, r5, r3
  bic r4, r4, r5

  @ store the modified result back into pin by using r2
  str r4, [r1, r2]
  bx lr
.size clear_bit, .-clear_bit

.type time_delay, %function
@ args:
@ r0: amount of time
time_delay:
  nop
  subs r0, r0, 1

  bpl time_delay
  bx lr