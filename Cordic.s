	@File: Cordic.asm
	@Author: Dylan Demchuk
maxAng:	.word 90
userAng:	.word 33.33
answer:	 .space 1
CosVals:  .space 1 	


cos:
	@ R7 will be the counter for position in the precomputed values
	MOV R7,#0
	
	@S0 will hold the current angle being added or subtracted
	MOV R6,#maxAng
	VLDR.F32  S0,[R6]
	
	@R5 will be the workng angle register
	MOV R5, #angle
	VLDR.F32 S1,[R5]

	MOV R5,#0
	VMOV.F32 S2, R5

	@S4 will be the constant .5
	MOV R6,#2
	MOV R5,#1
	VMOV.F32 S5,R6
	VMOV.F32 S4,R5
	VDIV.F32 S4,S4,S5
	
	@ R6 will hold the address of the current cosine value
	MOV R6,#CosVals

cosInc:
	ADD R7,R7,#1
	ADD R6,R6,#4

	VMUL.F32 S0,S0,S4
	
	VLDR.F32 S2,[R6]
	VCMP.F32 S1,S0
	BL  cosSub
	BGT cosAdd
	BEQ done
	
cosAdd:	
	SUB R5,R5,R6

	VADD.F32 S2,S2,S3
	B cosInc
cosSub:
	SUB R5,R5,R6

	VSUB.F32 S2,S2,S3
	B cosInc

done:
	
