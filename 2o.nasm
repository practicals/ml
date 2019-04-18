

; ALP to perform overlapped block transfer Block containing data can be defined in the data 
;segment


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

	srblock db 01h,02h,03h,04h,05h	
	desblock db 00h,00h,00h,00h,00h

	dest db '   ',0AH
	len equ $-dest

	msg1 db 'block before execution',0AH
	len1 equ $-msg1
	
	msg2 db 'source block',0AH
	len2 equ $-msg2
	
	msg3 db 'destination block',0AH
	len3 equ $-msg3
	
	msg4 db 'block after execution',0AH
	len4 equ $-msg4
	
	msg5 db 'enter the overlap size',0AH
	len5 equ $-msg5
	
	cnt equ 5




section .bss
	
	num2 resb 02
	num1 resb 02
	cnt1 resb 00
	

section .text
	global _start
		_start:
	
		write len1,msg1
		write len2,msg2
		write len,dest
		call srblk
		
		write len3,msg3
		write len,dest
		write len,dest
		call desblk
		
		write len5,msg5
		read 2,num1
		mov r8,num1
		mov bl,[r8]
		cmp bl,39h
		jbe t1
		sub bl,07h

t1:		sub bl,30h
		mov [cnt1],bl
		write len4,msg4
		write len2,msg2
		write len,dest
		call srblk
		
		write len,dest
		write len3,msg3
		write len,dest
		mov r8,srblock+4
		mov r9,r8
		add r9,[cnt1]
		mov cl,cnt

t2:		mov al,[r8]
		mov [r9],al
		dec r9
		dec r8
		dec cl
		jnz t2
		call shlblk
		write len,dest



 exit


shlblk:
	
	mov r8,srblock
	mov rcx,0
	mov rcx,cnt
	add rcx,[cnt1]


l9:		
	push rcx
 	mov bl,[r8]
 	call display
 	write len,dest
 	inc r8
 	pop rcx
 	loop l9
 	
 	ret	
 



srblk:	
	 mov r8,srblock
	 mov rcx,0
	 mov rcx,cnt
 
 l5:	
 		
 	push rcx
 	mov bl,[r8]
 	call display
 	write len,dest
 	inc r8
 	pop rcx
 	loop l5
 	ret

desblk:
	
	mov r9,desblock
	mov rcx,0
	mov rcx,cnt

l7:		
	push rcx
	mov bl,[r9]
	call display
	write len,dest
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
	add al ,07H
l4:			
	add al,30H
	mov [edi],al
	inc edi
	dec ecx
	jnz l3
	write 2,num2
	
	ret			

