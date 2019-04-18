;Name : joshi rahul
;Div: A
;rno : 50

;Write X86/64 ALP to switch from real mode to protected mode and display the values of GDTR, ;
;LDTR, IDTR, TR and MSW Registers.


%macro disp 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
	welmsg db 'Welcome',10
	wmsg_len equ $-welmsg
	gdtmsg db 10,'GDT Contents are:'
	gmsg_len equ $-gdtmsg
	ldtmsg db 10,'LDT Contents are:'
	lmsg_len equ $-ldtmsg
	idtmsg db 10,'IDT Contents are:'
	imsg_len equ $-idtmsg
	trmsg db 10,'TR Contents are:'
	tmsg_len equ $-trmsg
	mswmsg db 10,'MSW Contents are:'
	crmsg_len equ $-mswmsg
	nxline db 10
	colmsg db ':'       		;msg to display colon 
	rmodemsg db 10,'Processor is in Real Mode'
	rmsg_len equ $-rmodemsg
	pmodemsg db 10,'Processor is in Protected Mode'
	pmsg_len equ $-pmodemsg
	msg1 db 10,13,' '
	len1 equ $-msg1

section .bss
	gdt resd 1
 	resw 1
	ldt resw 1
	idt resd 1
	tr resw 1
	dnum_buff resb 04
	cr0_data resd 1


section .text

global _start
_start:	
	
	disp welmsg,wmsg_len
	smsw eax			;storing the machine status word
	mov [cr0_data],eax       ;loading the machine status word from eax to CRO buffer
	ror eax,1			;Checking PE bit, if 1=Protected Mode, else Real Mode
	jc prmode
	disp rmodemsg,rmsg_len
	jmp nxt1

prmode:	disp pmodemsg,pmsg_len

nxt1:	sgdt [gdt]			;storing the GDTR
	sldt [ldt]			;storing the LDTR
	sidt [idt]			;storing the IDTR
	str [tr]			;storing the TR
	disp gdtmsg,gmsg_len		; for displaying contents of GDT
	mov bx,[gdt+4]
	call disp_num
	mov bx,[gdt+2]
	call disp_num
	disp colmsg,1
	mov bx,[gdt]
	call disp_num

	disp ldtmsg,lmsg_len		; for displaying contents of LDT
	mov bx,[ldt]
	call disp_num

	disp idtmsg,imsg_len		; for displaying contents of IDT
	mov bx,[idt+4]				
	call disp_num
	mov bx,[idt+2]
	call disp_num
     	disp colmsg,1
	mov bx,[idt]
	call disp_num

	disp trmsg,tmsg_len		; for displaying contents of TR
	mov bx,[tr]
	call disp_num

	disp mswmsg,crmsg_len		; for displaying contents of MSW
	mov bx,[cr0_data]
	call disp_num
	disp msg1,len1
	
exit:		mov rax,60
		mov rdi,00
		syscall


;DISPLAY PROCEDURE
disp_num:
	mov esi,dnum_buff		;point esi to buffer
	mov ch,04			;load number of digits to display 
	mov cl,04			;load count of rotation in cl
up1:
	rol bx,cl			;rotate number left by four bits
	mov dl,bl			;move lower byte in dl
	and dl,0fh			;mask upper digit of byte in dl
	add dl,30h			;add 30h to calculate ASCII code
	cmp dl,39h			;compare with 39h
	jbe skip1			;if less than 39h skip adding 07 more 
	add dl,07h			;else add 07

skip1:
	mov [esi],dl			;store ASCII code in buffer
	inc esi				;point to next byte
	dec ch			;decrement the count of digits to display
	jnz up1			;if not zero jump to repeat
	mov rax,1			;display the number from buffer
	mov rdi,1	
	mov rsi,dnum_buff
	mov rdx,4
	syscall
	ret
	
;OUTPUI::
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44/v1$ nasm -f elf64 pr6.nasm
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44/v1$ ld -o pr6 pr6.o 
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44/v1$ ./pr6
;Welcome

;Processor is in Protected Mode
;GDT Contents are:00085000:007F
;LDT Contents are:0000
;IDT Contents are:00400000:0FFF
;TR Contents are:0040
;MSW Contents are:0033
;gescoe@gescoe-OptiPlex-3020:~/Desktop/44/v1$ 
	
