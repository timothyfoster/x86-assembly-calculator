; TWF - Last Modified: 28 August 2011
; ------------------------------------------------------------
; This program reads two single digit numbers from the
; Keyboard and performs a mathematical operation on them
;
; *****
; Compiled using Borland's TASM & TLINK - not tested on FASM.
; DOSBOX or a 32bit VM should be used to compile and run the
; program.
; To compile run: "TASM main" followed by "TLINK main"
; *****
; Also tested using emu8086: http://www.emu8086.com/
; Usage: open main.asm -> emulate -> run
; ------------------------------------------------------------

.model small
.stack

.data

	; Some messages to the user
	msgA DB "Enter the first one digit number: $"
	msgB DB 10, 13, "Enter the second one digit number: $"
	msgC DB 10, 13, "Enter which operator must be used: $"
	msgD DB 10, 13, 10, 13, "The answer is: $"
	msgE DB 10, 13, 10, 13, "!! Incorrect input, please retry !!", 10, 13, 10, 13, "$"

.code
	
	; Skip variable declaration
	jmp start

	; Define some variables
	charA DB ?
	charB DB ?
	result DB ?
	operator DB ?
	
	fail:
			
		; Wrong input
		mov ah, 09
		mov dx, offset msgE
		int 21h
	
	start:
	
		; Put the address of data into ax, ds
		mov ax, @data 
		mov ds, ax
		
		; Ask the user for the first single digit number
		mov ah, 09
		mov dx, offset msgA
		int 21h
		
		; Use subfunction one to get character from keyboard
		mov ah, 01
		int 21h
		mov charA, al
		
		; Jump if it's less than zero
		cmp charA, "0"
		jl fail
		
		; Jump if greater than nine
		cmp charA, "9"
		jg fail
		
		; Ask for second one digit number
		mov ah, 09
		mov dx, offset msgB
		int 21h
		
		; Get input from keyboard for second number
		mov ah, 01
		int 21h
		mov charB, al
		
		; Jump if it's less than zero
		cmp charB, "0"
		jl fail
		
		; Jump if greater than nine
		cmp charB, "9"
		jg fail
		
		; Ask for the operator
		mov ah, 09
		mov dx, offset msgC
		int 21h
		
		; Store the operator in a variable
		mov ah, 01
		int 21h
		mov operator, al
		
		; If operator is a plus go to addition
		cmp operator, "+"
		je addition
		
		; But if it is a minus go to subtraction
		cmp operator, "-"
		je subtraction
		
		; If it is neither then jump to fail
		jmp fail
		
	addition:
		
		; Add charB to charA and store in ah
		mov ah, charA
		add ah, charB
		
		; Move ah into result and convert to integer
		mov result, ah
		sub result, 48
		
		; Jump to extra if the result is >9
		cmp result, 58
		jnb extra
		
		; Show message
		mov ah, 09
		mov dx, offset msgD
		int 21h
		
		; Print the result
		mov ah, 02
		mov dl, result
		int 21h
		
		; Jump to exit
		jmp exit
		
	extra:
	
		; Show message "The answer is"
		mov ah, 09
		mov dx, offset msgD
		int 21h
		
		; Load "1" into ah (two single didgit numbers can
		; Never be > 18. Therefore we know that if the result
		; Is two digits, the first digit must be a "1"
		mov ah, 02
		mov dl, 49
		int 21h
		
		; Find the unit component of the result and print
		sub result, 10
		mov ah, 02
		mov dl, result
		int 21h
		
		; Jump to exit
		jmp exit
		
	subtraction:
	
		; Jump to negative if charA is below charB
		mov ah, charA
		cmp ah, charB
		jb negative
		
		; Subtract charB from charA
		mov ah, charA
		sub ah, charB
		
		; Put ah into result and convert to decimal
		mov result, ah
		add result, 48
		
		; Show message "The answer is"
		mov ah, 09
		mov dx, offset msgD
		int 21h
		
		; Display result
		mov ah, 02
		mov dl, result
		int 21h
		
		; Jump to exit
		jmp exit
		
	negative:
	
		; Subtract charA from charB
		mov ah, charB
		sub ah, charA
		mov result, ah
		add result, 48
		
		; Display message "The answer is"
		mov ah, 09
		mov dx, offset msgD
		int 21h
		
		; Print out the negative sign
		mov ah, 02
		mov dl, 45
		int 21h
		
		; Display the result
		mov ah, 02
		mov dl, result
		int 21h
		
	exit:
	
		; Back to system - End program
		mov ax, 4c00h
		int 21h

; Indicate that no more commands follow
END