
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

call DrawMainMenu  

ClickListener:




jmp ClickListener

ret

proc DrawMainMenu
    push 1320h
    push 0101h
    
    call SetPoint
    mov ax,1
    int 33h
     
    
    
    ret
endp DrawMainMenu

proc SetPoint
    ; Get params to stack, first parameter that you need to push
    ; is the shape and the second one is the location...
    
    pop [150]
    pop dx;place dh = y; dl = x
    
    pop cx ;cl Shape, ch Color
    ;change the dh and dl to one number algorithem...
    mov al,dh;mov al y value
    mov bl,80d
    mul bl
    add ax,ax
    add dl,dl
    mov dh,0
    add ax,dx
    mov bx,ax        
     
    push ds ;move data seg to 0b800h
    
    ;mov cl,Snake_Shape;shape 
    ;mov ch,Snake_Color ;color
    mov ax, 0b800h
    mov ds,ax
    ;mov bx,1
    mov [bx],cx 
    pop ds
    push [150]
    ret
endp SetPoint



space db 20
menu db 40






