;------------------------------
; DBL database launcher program
;------------------------------

; (c) Paul J. Miller 1995

; Launch the database program on the HP200LX with the database
; file given in the command tail.

TAIL_BUFF EQU 080H  ; we'll read command tail right where
		    ; MSDOS gives it to us

ORG	0100H

LAUNCH:
  MOV DI,TAIL_BUFF  ; point to the command tail length
  MOV BL,B[DI]	    ; Get the length of the command tail
  MOV BH,0
  INC DI	    ; point to start of command tail
  INC DI	    ; point to start of command ( skip space )
  PUSH DI	    ; save pointer to command tail
  DEC BX	    ; remove an extra byte ( the space )
  PUSH BX	    ; save length of command tail for later

  MOV DX,FILENAME

; MCREAT creates a file whose path name is pointed to by
; DS:DX, giving the file a standard set of permissions.

MCREAT:
  MOV CX,0          ; 0-code provides the standard access
  MOV AH,03CH       ; MSDOS function number for CREAT
  INT 021H          ; call MSDOS to do the creation
  MOV BX,AX         ; copy file handle to BX, for convenience

  JC ERROR

  POP CX	    ; get length in CX
  POP DX	    ; get pointer to command tail in DX
  PUSH BX	    ; save file handle

; MWRITE writes CX bytes from DX to the open-file numbered
; BX. DOS returns Carry if the write failed, with AX set to
; an error number.

MWRITE:
  MOV AH,040H       ; MSDOS function number for WRITE
  INT 021H          ; call MSDOS

  JC ERROR

  POP BX	    ; restore flie handle

; MCLOSE closes the open-file numbered BX.

MCLOSE:
  MOV AH,03EH       ; MSDOS function number for CLOSE
  INT 021H          ; call MSDOS

  JC ERROR

  MOV AL,01DH	    ; scan code for Ctrl down
  OUT 060H,AL
  INT 09H	    ; press the Key

  MOV AL,075H	    ; scan code for Phone down
  OUT 060H,AL
  INT 09H	    ; press the Key

  MOV AL,0F5H	    ; scan code for Phone up
  OUT 060H,AL
  INT 09H	    ; press the Key

  MOV AL,09DH	    ; scan code for Ctrl up
  OUT 060H,AL
  INT 09H	    ; press the Key

EXIT:

;  The next two instructions check the keyboard status and
;  allow System Manager to take over and start the Database
;  program. Without these instructions DBL often returns
;  to the desktop before System Manager responds to the
;  keypresses, which would be OK if it were consistant, but
;  it isn't. If it were possible to gaurantee that DBL would
;  always return to the desktop before the keys were
;  detected then there would not be a DOS program running
;  in the background and it wouldnt disable the alarms.
;  You can tell if it returns to the desktop because there
;  is a screen redraw before the database runs.

;  If you want to try it then just comment out the next two
;  instructions and re assemble the program.

  MOV AH,0BH	    ; check keyboard status
  INT 021H          ; call MSDOS


; EXIT exits the program back to the invoking process, with
; a status of AL.

  MOV AX,04C00H     ; MSDOS function number for EXIT
  INT 021H          ; call MSDOS

ERROR:		; something went wrong
  MOV AH,2
  MOV DL,7	    ; send BEEP to console
  INT 021H          ; call MSDOS
  MOV AX,04C01H     ; MSDOS function number for EXIT
  INT 021H          ; call MSDOS

; ----------------- THE END -------------------

FILENAME:
  DB 'C:\_DAT\DB.ENV'
  DB 0
