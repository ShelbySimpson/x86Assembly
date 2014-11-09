;  Build using these commands:
;    nasm -f elf -g -F stabs hwk4.asm
;    ld -o hwk4 hwk4.o
;

SECTION .data			; Section containing initialised data
	x: db 2		   	  ;Step 1 complete X
	
SECTION .bss			; Section containing uninitialized data	

SECTION .text			; Section containing code

global 	_start		; Linker needs this to find the entry point!
	
_start:
	nop			; This no-op keeps gdb happy...
	mov eax,4		  ; eax 4
	mov ebx,[x]		; ebx 2
	add ebx,eax		; 4+2, 6 ebx Step two Complete Y
	mov edx,ebx		;relocate y to edx
	mov eax,1		  ;1 to eax
	add eax,[x]		;eax = 3 result of x+1
	sub ebx,eax		;Step 3 Complete Z
	mov cl,dl		  ;step 1 y to clof storing z,y into ecx
	mov ch,bl		  ;step 2 z to ch
	mov eax,0		  ;empty eax
	mov al,cl		  ;move y to eax
	mov ebx,2		  ;ebx set to 2
	div bl			  ;y/2 set to eax
	mov ebx,[x]		;ebx set to x
	add bl,ch		  ;add z and x
	mul ebx			  ;mul (x+z) * (y/2)
	mov edx,eax		;(x+z) * (y/2) set to edx
	mov eax,0		  ;empty eax
	mov al,ch		  ;mov z to eax
	mul al			  ;z^2
	add edx,eax		;A set to edx
	mov eax,edx		;mov edx to eax
	add al,ch		  ;a+z
	mov bl,cl		  ;y set to ebx
	mov cl,ch	  	;mov c to ecx
	mov ch,0	  	;set ch to 0
	int 80H			  ; Make kernel call

	MOV eax,1	  	; Code for Exit Syscall
	mov ebx,0	 	  ; Return a code of zero	
	int 80H			  ; Make kernel call
