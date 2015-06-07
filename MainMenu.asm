
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

call DrawMainMenu  

ClickListener:




jmp ClickListener

ret

proc DrawMainMenu
    mov al,3h
    int 10h
    mov ah,2h
    int 10h
    
    ret
endp DrawMainMenu 



space db 20
menu db 40






