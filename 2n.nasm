
; ALP to perform non-overlapped block transfer Block containing data can be defined in the data 
;segment.


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

	srblk db 01h,02h,03h,04h,05h
	desblk db 00h,00h,00h,00h,00h
	
	dest db '   ',0AH
	len equ $-dest

	msg1 db 'block before execution ',0AH
	len1 equ $-msg1

	msg2 db 'source block',0AH
	len2 equ $-msg2

	msg3 db 'destination blk',0AH
	len3 equ $-msg3

	msg4 db 'block after execution ',0AH
	len4 equ $-msg4

	cnt equ 5

section .bss


	num2 resb 02
	num3 resb 05



section .text
        global _start
               _start:
               
               write len1,msg1
               write len2,msg2
               call srblock
               
               write len,dest
               write len3,msg3
               call desblock
               
               write len,dest
               write len4,msg4
               write len2,msg2
               call srblock
               
               write len,dest
               write len3,msg3
	       
	       
	       
               mov r8,srblk
               mov r9,desblk
               mov cl,cnt
               
l6:		mov al,[r8]
		mov [r9],al
		inc r8
		inc r9
		dec cl
		jnz l6

               call desblock
     
               exit


srblock:

	   mov r8,srblk
	   mov rcx,0
	   mov rcx,cnt


l5:	   push rcx
	   mov bl,[r8]
	   call display
	   inc r8
	   pop rcx
	   loop l5
	   ret
   

desblock:

	   mov r9,desblk
	   mov rcx,0
	   mov rcx,cnt
l7:        
	   push rcx
	   mov bl,[r9]
	   call display
	   inc r9
	   pop rcx
	   loop l7
	   ret
               
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
	   write 2,num2

	   ret    
	   
	   
	   
;OUTPUT::

;gescoe@gescoe-OptiPlex-3020:~/Desktop/44$ nasm -f elf64 pr2n.nasm
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44$ ld pr2n.o -o pr2n
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44$ ./pr2n

;block before execution 
;source block
;0102030405   
;destination blk
;0000000000   

;block after execution 
;source block
;0102030405   
;destination blk
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44$ 

	   
	          
