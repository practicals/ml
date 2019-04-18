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
msg1 db 'GDT Contents:',0AH
len1 equ $-msg1
msg2 db 'LDT Contents:',0AH
len2 equ $-msg2
msg3 db 'IDT Contents:',0AH
len3 equ $-msg3
msg4 db ' ',0AH
len4 equ $-msg4
msg5 db 'MSW Contents: ',0AH
len5 equ $-msg5
msg6 db 'TR Contents:',0AH
len6 equ $-msg6
msg7 db 'processor in real mode',0AH
len7 equ $-msg7
msg8 db 'processor in protected mode ',0AH
len8 equ $-msg8
colmsg db ':'

msg db 'len',0AH
msg_len equ $-msg


section .bss
num2 resb 16
gdt resd 1
resw 1
ldt resw 1
idt resd 1
tr resw 1
msw resd 1
cro_data resd 1

section .text
global _start
       _start:    
smsw eax
mov [cro_data],eax
ror eax,1
jc prmode
write len7,msg7
jmp nxt1

prmode: write len8,msg8
nxt1: sgdt [gdt]
	sldt [ldt]
	sidt [idt]
	str [tr]
write len1,msg1
mov bx,[gdt+4]
call display
mov bx,[gdt+2]
call display
write 1,colmsg
mov bx,[gdt]
call display
write len4,msg4
write len2,msg2
mov bx,[ldt]
call display
write len4,msg4
write len3,msg3
mov bx,[idt+4]
call display
mov bx,[idt+2]
call display
write 1,colmsg
mov bx,[idt]
call display
write len4,msg4
write len5,msg5
mov bx,[cro_data]
call display
write len4,msg4
write len6,msg6
mov bx,[tr]
call display
write len4,msg4


exit

display:
              mov ecx,4
              mov edi,num2
              
              L5:rol bl,4
                 mov al,bl
                 and ax,0FH
                 cmp al,09H
                 jbe L4
                 add al,07H
              
              L4:add al,30H
                 mov [edi],ax
                 inc edi
                 dec ecx
                 jnz L5
               write 4,num2
              ret 
              
              

