;Write 80387 ALP to find the roots of the quadratic equation. All the possible cases must be considered in calculating the roots.

%macro write 2
        mov edx,%1
        mov esi,%2
        mov edi,1
        mov eax,1
        syscall
%endmacro
		
%macro read 2
	mov edx,%1
	mov esi,%2
	mov edi,0
	mov eax,0
	syscall
%endmacro
		
%macro exit 0
	mov rax,60
	syscall
%endmacro		

section .data
	msg1 db 'Complex Root',0Ah
	len1 equ $-msg1
	
	msg2 db 'First root is: ',0Ah
	len2 equ $-msg2
	
	msg3 db 'Second root is: ',0Ah
	len3 equ $-msg3
	
	msg db ' ',0Ah
	len equ $-msg
	
	a dd 1.00
	b dd 8.00
	c dd 15.00
	four dd 4.00
	two dd 2.00
	
	hdec dq 100
	point db "."
	
	section .bss
		root1 resb 1
		root2 resb 1
		resbuff resb 1
		temp resb 2
		disc resd 1
		
	section .text
		global _start
			   _start:
			   
			   	finit
			   	fld dword[b]
			   	fmul dword[b]
			   	fld dword[a]
			   	fmul dword[c]
			   	fmul dword[four]
			   	fsub
			   	ftst
			   	fstsw ax
			   	sahf
			   	jb no_real_solution
			   	fsqrt
			   	fst dword[disc]
			   	fsub dword[b]
			   	fdiv dword[a]
			   	fdiv dword[two]
			   	write len,msg
			   	write len2,msg2		   	
			   	call disp_proc
			   	write len,msg
			   	fldz
			   	fsub dword[disc] 
			   	fsub dword[b]
			   	fdiv dword[a]
			   	fdiv dword[two]
			   	write len,msg
			   	write len3,msg3
			   	call disp_proc
			   	write len,msg
			   	jmp exit
		no_real_solution:
				write len1,msg1
			        exit
	
	
	disp_proc:
				FIMUL dword[hdec]
				FBSTP tword[resbuff]
				mov rsi,resbuff+9
				mov rcx,09
				
		next1:	push rcx
				push rsi		
				mov bl,[rsi]
				call disp
				pop rsi
				pop rcx
				dec rsi
				loop next1
				push rsi
				write point,1
				pop rsi
				mov bl,[rsi]
				call disp
				ret	
			   	
		disp:
        		       mov edi,temp
	        	       mov ecx,02
	            dispup1:   rol bl,4
       		       	   mov dl,bl
			   and dl,0Fh
			   add dl,30h
			   cmp dl,39h
			   jbe dispskip1
			   add dl,07h
	   dispskip1: mov [edi],dl
			   inc edi
			   loop dispup1
			   write 2,temp
			   ret	
