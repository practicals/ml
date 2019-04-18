

%macro read 2 
	mov rdx,%1 
	mov rsi,%2 
	mov rdi,0 
	mov rax,0 
	syscall 
%endmacro 

%macro write 2 
	mov rdx,%1 
	mov rsi,%2 
	mov rdi,1 
	mov rax,1 
	syscall 
%endmacro 

%macro exit 0 
mov rax,60 
syscall 
%endmacro	 

section .data	 
	 
		msg db 'Enter 1st Multiplicant :' 
		len equ $-msg 
		 
		msg1 db 'Enter 2nd Multiplicant :' 
		len1 equ $-msg1 
		 
		msg2 db ' :',10,13 
		len2 equ $-msg2 
		 
		msg3 db '',10,13 
		len3 equ $-msg3 



section .bss 

	num1 resb 10 
	num2 resb 10 
	mul1 resb 14 
	mul2 resb 14 
	result resb 14 
	 
section .txt 
global _start 
	_start: 

	write len,msg 
 	read 3,num1 	 
 	call accept 
	mov [mul1],bl 
 	 
 	 
 
 	write len1,msg1 
 	read 3,num1 
 	call accept 
	mov [mul2],bl 
 	 
	 
	mov cl,00 
	mov dl,8 
	 
	mov al,[mul1] 
	mov bl,[mul2] 
	 
    t2:	rcr al,01 
	jnc t1 
	shl bl,cl 
	add [result],bl 
	mov bl,[mul2] 
      
    t1:	inc cl 
	dec dl 
	jnz t2 

	mov bl,[result] 
	call display 
	write 4,num2        
	write len3,msg3 
exit 

accept: 	 
	mov bl,00 
	mov rsi,num1 
	mov rcx,2 
	 
     l1:rol bl,4	 
        mov al,[esi] 
        cmp al,39h 
        
        jbe l2 
        sub al,07h 
     
     l2:sub al,30h 
        add bl,al 
        inc rsi 
        dec rcx 
        jnz l1 
ret 

display: 	 
	mov rcx,4 
	mov rdi,num2 
	 
	 
     l3:rol bx,04	 
        mov al,bl 
        and al,0Fh 
        cmp al,09h 
        jbe l4 
        add al,07h 
     l4:add al,30h 
        mov [rdi],al 
        inc rdi 
        dec rcx 
        jnz l3 
        
        
ret 

