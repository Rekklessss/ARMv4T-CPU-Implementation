.text

mov r0,#0x1
mov r1, #0x4
mov r2, #8
@ldr r7,=mem
mov r7,#4

add r3, r2, r1, LSL #3
add r4, r2, r1, LSL r0
str r4, [r7, r2, LSR #1]
ldr r5, [r7, #4]
mov r0,#512
sub r8, r1,r2
rsb r9,r2,r8, ROR #1
mov r10,r8, ASR #1
mov r6,r8, LSR #1


.data
mem: .space 200
