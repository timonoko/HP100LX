	TITLE	launch.com by timo noko
CSEG	SEGMENT
	ASSUME	CS:CSEG,DS:CSEG,ES:CSEG,SS:CSEG
	ORG	0100h
LB0100:
	MOV	AX,0500h
	MOV	CX,01c0dh
	INT	016h
	MOV	AX,0500h
	MOV	CX,0a400h
	INT	016h
	MOV	AX,0500h
	MOV	CX,0c800h
	INT	016h
	MOV	AX,0500h
	MOV	CX,01e41h
	INT	016h
	MOV	AX,0500h
	MOV	CX,01454h
	INT	016h
	MOV	AX,0500h
	MOV	CX,04400h
	INT	016h
	mov	si,80h
	mov	bl,[si]
	dec	bl
	inc	si
	inc	si
looppi:	push	si
	push	bx
	MOV	AX,0500h
	MOV	Ch,01eh
	mov	cl,[si]
	INT	016h
	pop	bx
	pop	si
	inc	si
	dec	 bl
	jnz	looppi
	MOV	AX,0500h
	MOV	CX,01c0dh
	INT	016h
joo:	MOV	AH,04ch
	INT	021h

db 'launch.com for Hp100lx by timo noko 1995'

CSEG	ENDS
	END	LB0100
