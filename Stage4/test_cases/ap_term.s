mov r1,#1			@starting term
mov r2,#4			@number of terms in the ap
mov r3,#2			@common difference

mov r4,#1			@loop variable

Loop:   cmp r4,r2
	beq out 
	
	add r1,r1,r3
	add r4,r4,#1
	b Loop
	
out: mov r0,r1

