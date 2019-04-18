%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

%macro fopen 1
mov rax,2
mov rdi,%1
mov rsi,2
mov rdx,0777o
syscall
%endmacro

%macro fread 3
mov rax,0
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

%macro fwrite 3
mov rax,1
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

%macro fclose 1
mov rax,3
mov rdi,%1
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
fmsg db 10,"Enter File name:"
l4 equ $-fmsg

errmsg db "File not Present..."
l5 equ $-errmsg

fmsg1 db "File  Present..."
l6 equ $-fmsg1

delmsg db 10,"File deleted successfully...."
l7 equ $-delmsg

wmsg db 10,"Write Successfully"
wmsgl equ $-wmsg

section .bss

choice resb 2
filename resb 50
filename1 resb 50
fhandle resq 1
fhandle1 resq 1
buff resb 1024
bufflen equ $-buff
act_len resq 2

cnt1 resq 1
cnt2 resb 2
dispbuff resb 5
section .text

global _start

_start:

	scall 1,1,fmsg,l4
	scall 0,0,filename,50
	dec rax
	mov byte[filename+rax],0
	fopen filename
	cmp rax,-1H
	jle err
	mov [fhandle],rax
	fread [fhandle],buff,bufflen
	dec rax
	mov [act_len],rax
	scall 1,1,buff,act_len
	jmp n
err:
	scall 1,1,errmsg,l5
	
n: 
mov rax,60
syscall


