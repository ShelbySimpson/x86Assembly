;  Build using these commands:
;    nasm -f elf -g -F stabs hwk5.asm
;    ld -o hwk5 hwk5.o
;

SECTION .data			; Section containing initialised data
	errorMsg: db 'ERROR!!!',10
	errorLen: equ $ -errorMsg

SECTION .bss				
	SIZE: equ 1024
	buffer: resb SIZE	

SECTION .text			; Section containing code

global 	_start			; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...
	mov eax,3		; Read to standard input
	mov ebx,0		; file descriptor 0, standard input
	mov ecx,buffer		; buffer to read into
	mov edx,SIZE		; Number of bytes to read
	int 80H			; Make kernel call
	

	mov ecx,eax		; ecx stores buffer size
	mov ebx, 0		; ebx stores loop counter
	push 45			; Mark Stack Empty

	_loop
	  mov eax,[buffer+ebx]		 ; Stack Value
	  mov edx,0			 ; ensure edx is 0
	  mov dl,al 			 ; prep edx to push on stack 
	  cmp ecx,ebx			 ;compare counter and buffer size
	  je _checkStkEmpty              ;end of buffer check stack

	  ;Parse buffer, put open brackets on stack for comparison when
	  ; closed brackets are parsed is compared to top of stack
	  cmp byte [buffer+ebx],'{'      ; Compare, push if matched
	  je _openPush
	 
	  cmp byte [buffer+ebx],'('      ; Compare, push if matched
	  je _openPush

	  cmp byte [buffer+ebx],'['      ; Compare, push if matched
	  je _openPush

	  ; Parse buffer, compare closed bracket with top of stack.
	  ; No match means unbalanced parenthesis
	  cmp byte[buffer+ebx],'}'	 ;compare for stack comparison
	  je _stackCmp			 ;jump to stackCmp
 
	  cmp byte[buffer+ebx],')'	 ;compare for stack comparison
	  je _stackCmp			 ;jump to stackCmp
 
	  cmp byte[buffer+ebx],']'	 ;compare for stack comparison
	  je _stackCmp			 ;jump to stackCmp 

	 
	  inc ebx			 ; increment loop counter
	  jmp _loop

	; Stack comparison implementation
	_stackCmp			
	  inc ebx		       	; increment loop counter
	  pop eax		       	; pop to eax
	  cmp eax,'{'			; match back to loop
	  je  _loop			

	  cmp eax,'('			;match back to loop
	  je  _loop

	  cmp eax,'['			;match back to loop
	  je  _loop

	  jmp _errorEndProgram

	; Push open bracket to stack implementation
	_openPush
	  push edx			; push bracket to stack
	  inc ebx			; incremtent counter
	  jmp _loop			; back to loop
	
	; At this point the buffer has been completly parsed. If the
	; stack is empty then all open bracket have been use and 
	; parenthesis were balanced. If not, unbalanced and display
	; error message.
	_checkStkEmpty
	  pop eax			; pop for comparison	
	  cmp eax,45			; check if stack is empty
	  je _endProgram		; stack is empty
	  jmp _errorEndProgram		; stack is not empty
	
	; End program, parenthesis balanced
	_endProgram
	  mov eax,4		; Write to standard output
	  mov ebx,1		; file descriptor 1 standard output
	  mov ecx,buffer	; pointer to buffer
	  mov edx,SIZE		; number of bytes to write
	  int 80H		; Make kernel call
	  mov eax,1		; Code for Exit Syscall
	  mov ebx,0		; Return a code of zero	
	  int 80H		; Make kernel call

	; End program, parenthesis not balanced.
	_errorEndProgram
	  mov eax,4		; Write to standard output
	  mov ebx,1		; file descriptor 1 Standard output
	  mov ecx,errorMsg	; pointer to bytes to write
	  mov edx,errorLen	; number of bytes to write
	  int 80H		; Make kernel call
	  mov eax,1		; Code for Exit Syscall
	  mov ebx,0		; Return a code of zero	
	  int 80H		; Make kernel call

