;Write x86 ALP to find the factorial of a given integer number on a command line by using recursion. Explicit stack manipulation is ;
;expected in the code.


section .data

    num db 00h
    msg db 'Factorial is',0AH
    len equ $-msg
    
    msg1 db'**Problem to find factorial of a number**',0AH
         db'Enter the number',0AH
    len1 equ $-msg1
    
    zerofact db'00000001'
    zerofactlen equ $-zerofact
    
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
	
	
section .bss
    dispnum resb 16
    result resb 4
    tcmp resb 3
    
section .text
    global _start
           _start:
           write len1,msg1
           read 3,tcmp
           call convert
           mov [num],dl
           write len,msg
           
           xor rdx,rdx
           xor rax,rax
           mov al,[num]	
	       cmp al,01h
	       jbe endfact
	       
	       xor rbx,rbx
	       mov bl,01h
	       call factr
	       call display
	       exit
	       
	  convert: mov rsi,tcmp
	           mov cl,02h
	           xor rax,rax
	           xor rdx,rdx
	     contc: rol dl,04h
	            mov al,[rsi]
	            cmp al,39h
	            jbe skipc
	            sub al,07h
	      skipc: sub al,30h
	             add dl,al
	             inc rsi
	             dec cl
	             jnz contc
	             ret
	           
	     endfact: write zerofactlen,zerofact
	                exit
	                
	         factr:cmp rax,01h
	               je retcon1
	               push rax
	               dec rax
	               call factr
	         retcon:pop  rbx
	                mul rbx
	                jmp endpr
	        retcon1:pop rbx
	                jmp retcon
	          endpr:
	                ret
	                  
	        display:mov rsi,dispnum+15
	                xor rcx,rcx
	                mov cl,16
	           cont:xor rdx,rdx
	                xor rbx,rbx
	                mov bl,10h
	                div ebx
	                cmp dl,09h
	                jbe skip
	                add dl,07h
	           skip:add dl,30h
	                mov [rsi],dl
	                dec rsi
	                loop cont   
	                write 16,dispnum
	                ret
	                
;input eg; 04
                
