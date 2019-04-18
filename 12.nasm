;Problem statement::
;Write 80387 ALP to obtain: i) Mean ii) Variance iii) Standard Deviation Also plot the histogram for the data set. The data elements ;
;are available in a text file

%macro write 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,03
	mov rdi,00
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data

	msg1 db 10, 'mean is:  '
	msg1len equ $- msg1

	msg2 db 10, 'std deviation is:'
	msg2len equ $- msg2

	msg3 db 10, 'variance is:'
	msg3len equ $- msg3

	data dd 9.0,1.0
	datacnt dw 02
	hdec dq 100

	decpt db '.'

section .bss

	res rest 01
	mean resd 01
	var resd 01 
	dispbuff resb 01

section .text
	global _start
               _start:

        write msg1,msg1len

        finit                  
	fldz
	mov rbx,data
	mov rsi,00
	xor rcx,rcx
	mov cx,[datacnt]

bk:	fadd dword[rbx+rsi*4]
	inc rsi
	loop bk                 

	fidiv word[datacnt]
	fst dword[mean]
	call dispres

	MOV RCX,00
	MOV CX,[datacnt]
	MOV RBX,data
	MOV RSI,00
	FLDZ
up1:	FLDZ
	FLD DWORD[RBX+RSI*4]
	FSUB DWORD[mean]
	FST ST1
	FMUL                 ;squaring ie st0*st1
	FADD                 
	INC RSI
	LOOP up1
	FIDIV word[datacnt]
	FST DWORD[var]
	FSQRT

        write msg2,msg2len
	CALL dispres

	FLD dWORD[var]
	write msg3,msg3len
	CALL dispres

exit: 	mov rax,60
	mov rbx,00
	syscall

disp8_proc:
	mov rdi,dispbuff
	mov rcx,02
back:	rol bl,04
	mov dl,bl
	and dl,0FH
	cmp dl,09
	jbe next1
	add dl,07H
next1:  add dl,30H
	mov [rdi],dl
	inc rdi
	loop back
	ret

dispres:
	fimul dword[hdec]
	fbstp tword[res]   
	xor rcx,rcx
	mov rcx,09H
	mov rsi,res+9
up2:	push rcx
	push rsi
	mov bl,[rsi]
	call disp8_proc
	write dispbuff,2	
	pop rsi
	dec rsi
	pop rcx
	loop up2
	write decpt,1

	mov bl,[res]
	call disp8_proc
	write dispbuff,2	
        ret

