;(BCD TO HEXADECIMAL)

;Write X86/64 ALP to convert 5-digit BCD number into its equivalent HEX number. 


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

section .data
msg1 db 'Enter 5 digit bcd number: ',0AH
len1 equ $-msg1

msg2 db ' Hexadecimal number is: ',0AH
len2 equ $-msg2

section .bss
num1 resb 10
num2 resb 10

section .text

global _start:
       _start:
       
      write len1,msg1
      read 6,num1
      mov ax,bx
      mov bx, 0AH
      mov cl,0 
     
      mov rax,0
      mov rbx,0AH
      mov rcx,5
      mov rdx,00
      mov r8,num1
      
  l1: mul rbx
      mov rdx,00
      mov dl,[r8]
      sub dl,30H
      add rax,rdx
      inc r8
      dec cl
      jnz l1
      mov rbx,rax
      call display    
      exit
          
  display:
  	  mov rcx,2
  	  mov edi,num2
  	  	
       l2:rol bl,4
          mov al,bl
          and al,0FH
          cmp al,0FH
          cmp AL,09H
          jbe l3
          add al,07H
       l3:add al,30H
          mov [edi],al
          inc edi
          dec rcx
          jnz l2
          write len2,msg2
			 write 5,num2
          ret
 
