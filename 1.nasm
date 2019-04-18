
;Write X86/64 ALP to count number of positive and negative numbers from the array



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
   mov eax,60
   syscall
%endmacro


section .data

arr dq 1234567895ABCDEFH,-123456789000000H,-123456789000000H,7FFFFFFFFFFFFFFH
n equ 4                          ;no of element in array


pmsg db 'positive numbers count : '
plen equ $-pmsg


nmsg db 'negative numbers count : '
nlen equ $-nmsg


msg db '',0AH
len equ $-msg

;nwline db 10

section .bss

	pcnt resb 10
	ncnt resb 10
	num2 resb 14

section .text
global _start
       _start:

      mov rsi,arr
      mov rdi,n
      mov rbx,0                    ;+ve no counter initialize to 0
      mov rcx,0                    ;-ve no counter initialize to 0
      
   up:
      mov rax,[rsi]
      
      cmp rax,0000000000000000H
      js negative                  ;jump if sign
      
   positive:
      inc rbx
      jmp next
      
   negative:
      inc rcx
      
   next:
      add rsi,8                    ;for 16 digit no stored at lower & higher
      dec rdi
      jnz up
      
      mov [pcnt],rbx
      mov [ncnt],rcx
      
      
      ;display +ve no
      write plen,pmsg
      mov rax,[pcnt]
      call display
      
      
      ;display -ve no
      write len,msg
      write nlen,nmsg
      mov rbx,[ncnt]
      call display
      write len,msg
      
      exit
      
display:
   
   mov ecx,2
   mov edi,num2 


l3:
   rol bl,4
   mov al,bl
   and al,0FH
   cmp al,09H
   jbe l4
   add al,07H


l4:
   add al,30H
   mov [edi],al
   inc edi
   dec ecx
   jnz l3
   write 14,num2
   
   ret 
   
