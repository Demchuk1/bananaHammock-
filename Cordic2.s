

	
.data
inAngleInt:	.word  89
inAngleDec:	.word  2  
X0:		.word 156
Y0:		.word 0
sumAngle:	.word 0	
Tan:		.word 14		 
arctan:		.word 11520,6800,3593,1824
		.word 915,458,229,114,57,28
		.word 14,7,3,1,1
OffAng:		.word 5
	
	.text
	.global _start
Cos:
	LDR R1, =Tan
	@R7 is the loop counter
	MOV R7,#0
	LDR R3,=X0

	@R2 is the loop end point
	LDR R2,[R1]
	@R8 holds X0
	LDR R8,[R3]

	LDR R1,=X0
	
	@R8 holds Y0
	LDR R1,=Y0
	LDR R9,[R1]			
	
	@R0 is the user's angle
	LDR R1,=inAngleInt		
	LDR R0,[R1]
	LSL R0,#8
	
CosInc:
	@Check if Loop counter equals end point
	CMP R7,R2
	BEQ CosStr

	@Load R3 with current ArcTan Angle 
	LDR R1, =arctan
	LDR R3,[R1,R7, LSL #2]

	@increment Loop
	ADD R7,R7,#1

	LSR R10, r0,#31
	CMP R10,#0
	BEQ CosAdd
	BGT CosSub
	

	@x= xi - yi*2^-i   x-y then bit-shift i
	@inangle = inangle + arctan(i)
CosAdd:
	@Load X0 andY0 into registers R5 & R6 respectively
	@Shift them for later calculations
	LSR R5,R8,R7
	lSR R6,R9,R7

	@Update X value
	@Xi = X0 + Y0>>R7
	ADD R4,R8,R6
	LDR R1,=X0
	STR R4,[R1]

	@update Y Value
	@Yi = Y0 - X0>>R7
	SUB R5,R6,R11
	LDR R1, =Y0
	STR R5,[R1]

	@update Angle Value
	SUB R0,R0, R3
	
	B CosInc
CosSub:
	@Load X0 andY0 into registers R5 & R6 respectively
	@Shift them for later calculations
	LSR R5,R8,R7
	lSR R6,R9,R7

	@Update X value
	@Xi = X0 + Y0>>R7
	SUB R4,R8,R6
	LDR R1,=X0
	STR R4,[R1]

	@update Y Value
	@Yi = Y0 - X0>>R7
	ADD R5,R9,R5
	LDR R1,=Y0
	STR R5,[R1]

	@update Angle Value
	ADD R0,R0, R3
	
	B CosInc
CosStr:
	EOR R0,R0
	.end
