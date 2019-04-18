
.model small
.386
.stack 100

.data
msg db 10,13,'This is sine wave$'
one_eighty dw 180
hundread dw 100
scale dw 60
rint dw 0
x dw 0

.code
main:

mov eax,@data           ;initialize DS
mov ds,eax
mov eax,0A000h          ;segment to video memory
mov es,eax

mov ax,13h              ;switch to 320x200
int 10h

mov cx,0
l1:push cx
call get_sine
mov bx,cx
call vector_to_memory
mov di,ax
mov al,03h               ;color
mov [es:di],al           ;putpixel
pop cx                   ;restore cx
inc cx
cmp cx,320
jne l1

mov ah,09h               ;display message
lea dx,msg
int 21h

xor ah,ah                ;keyboard(wait for key press)
int 16h
mov ax,3
int 10h                  ;switch to text mode
mov ax,4C00h             ;exit code 0
int 21h                  ;return from DOS

get_sine:mov word[x],cx
fldpi                          ; load pi
fimul word[x]                  ;pi*cx
fidiv word[one_eighty]         ;(pi*cx)/180
fsin                           ; calculate sine angle in radians
fimul word[scale]              ;60*sin(pi*cx)/180
fild word[hundread]            ; load 100
fsub st,st(1)                  ; 100-60*SIN(pi*cx)/180
fist word[rint]                ;store integer result by rounding float value 
mov ax,word[rint]
ret

vector_to_memory:push dx     ; calculate offset di
mov cx,320
mul cx                       ;Y*320+X
add ax,bx
pop dx
ret

end main
