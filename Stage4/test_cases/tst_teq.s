		mov r0, #4
		mov r6, #0
		mov r1, #3
		mov r0,#1
L:		tst r0, r1
		beq END
		add  r0,r0,#1
		b L
END:		add r4, r1, r0
		teq r6,#0
