.syntax unified
.global main

.type main, %function
main:
  bl audio_init
  mov r5, #0
  ldr r6, =sound_length
  mov r7, 0
  mov r8, 4
  mov r9, 6
loop:
  add r5, #1 @ increment r5

  @ mov r0, r5

  @ lsr r0, r5, #8
  @ mul r0, r0, r5

  @ @ ((t >> 10) & 42) * t
  @ lsr r0, r5, #10
  @ and r0, #42
  @ mul r0, r0, r5

  mul r10, r7, r8
  ldr r11, [r6, r10]

  lsr r0, r5, #11
  and r0, r11
  mul r0, r0, r5
  
  push {r5}
  bl audio_play_sample
  pop {r5}

  add r7, r7, 1
  cmps r7, r9
  beq reset
  b loop
.size main, .-main

reset:
  mov r7, 0
  b loop

.data
sound_length:
  .word 1, 63, 3, 31, 7, 15
