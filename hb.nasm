;(HEXADECIMAL TO BCD)


;Write X86/64 ALP to convert 4-digit Hex number into its equivalent BCD number a




%macro write 2
   mov rdx,%1
   mov rsi,%2
   mov rdi,1
   mov rax,1
   syscall
  %endmacro

  %macro read 2	
   mov rdx,%1
   mov rsi,%2
   mov rdi,0
   mov rax,0
   syscall
 %endmacro

  %macro exit 0
   mov rax,60
   syscall
  %endmacro

section .bss
 num1 resb 20
 num2 resb 20
 num2len equ $-num2 
 
section .data 
   
   msg1 db 10,13,"Enter the 4 digit HEX number : " 
	len1 equ $-msg1
	msg2 db 10,13,"BCD Number: " 
	len2 equ $-msg2 
	msg3 db 10,13,"  " 
	len3 equ $-msg3 
	
section .text
        global _start
               _start:
                 write len1,msg1
                 read 5,num1
                 call accept
                 mov rax,rbx
                 mov rbx,0Ah
                 mov rcx,0
              t1:mov rdx,0
                 div rbx
                 push rdx
                 inc rcx
                 cmp rax,0
                 jne t1
                
                 mov r9,num2
                
             t2: pop rdx
                 add rdx,30h
                 mov [r9],rdx
                 inc r9
                 dec rcx
                 jnz t2
                  
                 write len2,msg2
                 write num2len,num2
                 write len3,msg3
                 exit
                 
accept: 
	mov rbx,0 
	mov rcx,4 
	 
	mov r8,num1 
	 
	L1 : 
		shl rbx,4 
		mov al,[r8] 
		cmp al,39h 
		jbe L2 
		sub al,07h 
        L2 : 
		sub al,30h 
		add rbx,rax 
		inc r8 
		dec rcx 
		jnz L1 
		ret 
	
