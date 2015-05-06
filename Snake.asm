org 100h
call ClearAllReg
call SetUpSnake
Step:
call CheckDirectionChange 
;call SnakeMove
;call CheckLose
;call CheckWin
;jmp Step
hlt
 ;=================================================================================================
proc SetUpSnake
    mov bl, Snake_Color
    
    mov dh,Head_Y
    mov dl,Head_X
    
    push bx  
    push dx
    call SetPoint 
    ret
endp SetUpSnake




;clear all the registries
proc ClearAllReg
    xor ax,ax
    xor bx,bx
    xor dx,dx
    xor cx,cx
    ret 
endp ClearAllReg
                      
;proc SetPoint;Use stack to cx ch=Colors cl= Letters Ascii  
;    pop [160]
;    pop bx ; Place
;    mov al,80d
;    mul bl
;    add al,bh
;    mov bx,ax 
;    
;    mov ch,0ah
;    mov cl,'*'
;    mov ax,0B800h     ;   Letter Color
;    mov es,ax         ;  B|ack ground
;                      ;  ||
;    mov es:bx,cx;        ||
;    push [160]  ;        0c31h
;    ret               ;    || 
;endp SetPoint         ;    Letter   





proc SetPoint
    pop [150]
    pop dx;place
    pop [160]
    ; dh = y
    ; dl = x  Set cursor to top left-most corner of screen
    mov bh, 0
    mov ah, 0x2
    int 0x10 
    
    mov cx, 1 ; print chars
    mov bh, 0
    mov bl, [160] ; green bg/blue fg
    mov al, '*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
    push [150]
    ret
endp SetPoint




;TODO:
proc CheckDirectionChange
    mov ah,1h
    int 16h
    cmp ah,0x48
    je up
    hlt  
    up:
     
    ret
    
endp CheckDirectionChange 

proc SnakeMove
    ret
endp SnakeMove

proc CheckLose
    ret
endp CheckLose
;====================



ret

Head_X db 1  

Head_Y db 1

Tail_X db 1

Tail_Y db 1

Direction db 2 

Snake_Color db 3h


          


