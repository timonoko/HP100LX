;==================================================
; Keyboard clicker and CCMAIL-key-reprogrammer
; for HP100LX, by Timo Noko (c) 1995
;==================================================

CODE	SEGMENT  PUBLIC
	ORG	100H
	ASSUME	CS:CODE, DS:CODE, ES:CODE

CLICK:	JMP	START

OLD 	DW 0
OLD2	DW 0

INTTI:
	NOP
	NOP
	PUSHF	                                   
	PUSH	AX                                 
	IN	AL,60H
	CMP	AL,73H ; IF CCMAIL-KEY
	JNZ	NOBLUE
	AND	AL,8FH ; 03H = CODE FOR '2'
	OUT	60H,AL ; send it instead
NOBLUE:	AND	AL,80H
	JNZ	KLIK
KLOK:	IN	AL,61H 
	AND	AL,11111110B
	OR	AL,10B
	OUT	61H,AL
	JMP	THEEND
KLIK:	IN	AL,61H
	AND	AL,11111100B
	OUT	61H,AL
THEEND:	POP	AX                                 
	POPF	                                   
	;JMP	FAR CS:[OLD] ; Error, uh?                          
	DB 2EH,0FFH,2EH,03H,01H   ; ok, ok, I can code it myself

START:	MOV	AX,3509H                            
	INT	21H                                 
	MOV	[OLD],BX                          
	MOV	[OLD2],ES                          
	MOV	DX,OFFSET INTTI                           
	MOV	AX,2509H                            
	INT	21H                                 
	MOV	DX,OFFSET START                            
	INT	27H                                 


CODE	ENDS
	END CLICK

