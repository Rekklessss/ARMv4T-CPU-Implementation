mov r8, #260
movs r7,#0
add r7,r7,#3
strne r7,[r8]
ldreq r1,[r8]
streq r7,[r8]
ldrne r2,[r8]
ldreq r3,[r8]