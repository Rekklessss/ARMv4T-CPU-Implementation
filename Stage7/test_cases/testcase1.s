mov r0,#2
mov r1,#3
mov r2,#4
sub r3,r0,r2
mov r4, r3
umull r5,r6,r3, r4
smull r7,r8,r3, r4
mov r9,r7
mov r10,r8
umlal r9,r10,r0, r2
mov r11,r9
mov r12,r10
smlal r11,r12,r0, r2