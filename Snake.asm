org 100h
call ClearAllReg
call SetUpSnake
Step:
call CheckDirectionChange 
call SnakeMove
call CheckLose
;call CheckWin
;jmp Step
call CheckDirectionChange
jmp Step
hlt
 ;=================================================================================================
proc SetUpSnake
    
    
    BuildField:
    
    ;Drow the top border
    T_drow:
    mov bh, 0
    mov ah, 0x2
    int 0x10 ;set mod 
    
    ; dh = y
;     dl = x 
    mov dl,0
    mov dh,0  
    
    mov cx, 80 ; print chars
    mov bh, 0
    mov bl, 20d ; green bg/blue fg
    mov al, ' ';'*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
     
    L_drow: 
    mov cx, 1 ; print chars
    mov bh, 0
    mov bl, 20d ;  bg/fg
    mov al, ' ';'*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
    inc dh
    mov ah, 0x2
    int 0x10
    cmp dh,25d
    jne L_drow 
          
    
    mov dl,79
    mov dh,0
     
    R_drow:
    
    
     
    mov cx, 1 ; print chars
    mov bh, 0
    mov bl, 20d ;  bg/fg
    mov al, ' ';'*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
    inc dh
    mov ah, 0x2
    int 0x10
    cmp dh,25d
    jne R_drow
    
     
    
    B_drow:
    mov dl,0
    mov dh,24
    
    mov ah, 0x2
    int 0x10
    
    
    mov cx, 80 ; print chars
    mov bh, 0
    mov bl, 20d ; green bg/blue fg
    mov al, ' ';'*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
    
    
    
    
    
  
       
       
    mov cl,Snake_Shape
    mov ch,Snake_Color
    push cx
       
    mov dh,Head_Y
    mov dl,Head_X  
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




;USE THIS:
;proc SetPoint
;    pop [150]
;    pop dx;place
;    ; dh = y
;    ; dl = x  Set cursor to top left-most corner of screen
;    mov bh, 0
;    mov ah, 0x2
;    int 0x10 
;    
;    mov cx, 1 ; print chars
;    mov bh, 0
;    mov bl, Snake_Color ; green bg/blue fg
;    mov al, Snake_Shape;'*';0x20 ; blank char
;    mov ah, 0x9
;    int 0x10
;    push [150]
;    ret
;endp SetPoint 
proc SetPoint
    pop [150]
    pop dx;place dh = y; dl = x
    
    pop cx ;cl Shape, ch Color
    
    mov al,dh;mov al y value
    mov bl,80d
    mul bl
    add ax,ax
    add dl,dl
    mov dh,0
    add ax,dx
    mov bx,ax
     
    push ds
    
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


;TODO:
proc CheckDirectionChange 
    ;check if keyboard clicked
    
    mov ah,1h ;Check if any key was pressed in the keyboard!
    int 16h
    jnz getKey;key was pressed!
    jmp Knone;key wasent pressed!
    
    getKey:
    mov ah,0h;Get the key that was pressed!
    int 16h
    
    ;compiration with al and the key that you need
    cmp al,'w'
    je Kup  
    cmp al,'a'
    je Kleft
    cmp al,'d'
    je Kright
    cmp al,'s'
    je Kdown
    jmp Knone
    
    Kup:
    mov Direction,1 
    jmp Knone
    
    Kright:
    mov Direction,2
    jmp Knone
          
    Kdown:
    mov Direction,3
    jmp Knone
    
    Kleft:
    mov Direction,4
     
    
    Knone:
     
    ret
    
endp CheckDirectionChange 
   
   
proc SnakeMove
    ;============ 
    
    ;mov al,Snake_Shape
;    mov Blank, al
;    mov Snake_Shape,' '
;     
;    mov bl,00
;    
;    mov dh,Head_Y
;    mov dl,Head_X
;    
;    push bx  
;    push dx
;    call SetPoint
;    
;    mov al,Blank
;    mov Snake_Shape,al 
    
    ;============
    
    cmp Direction,1
    je up
    
    cmp Direction,2
    je right
    
    cmp Direction,3
    je down
    
    cmp Direction,4
    je left 
    
    
    
    up:;UP
    dec Head_Y
    jmp move 
    right:;RIGHT
    inc Head_X
    jmp move
    down:;DOWN
    inc Head_Y
    jmp move
    left:;LEFT
    dec Head_X
    
    
    move:
    mov cl,Snake_Shape
    mov ch,Snake_Color
    push cx
    
    mov dh,Head_Y
    mov dl,Head_X 
    push dx
    call SetPoint
    
    ret
endp SnakeMove

proc CheckLose
    cmp Direction,1
    je upCheck
    
    cmp Direction,2
    je rightCheck
    
    cmp Direction,3
    je downCheck
    
    cmp Direction,4
    je leftCheck 
    
    upCheck:;UP
    jmp check 
    rightCheck:;RIGHT
    jmp check
    downCheck:;DOWN
    jmp check
    leftCheck:;LEFT
    
    check:
    
    ret
endp CheckLose
;====================



ret  

;========VARS========

Head_X db 1  

Head_Y db 1

Tail_X db 1

Tail_Y db 1

Direction db 2 


Blank db ''

SnakeArray dw 2000 dup(?)

Points db 0d



;===============SETTINGS================

;SNAKE PROPERTIES:

Snake_Color db 11
Snake_Shape db '*'

;FOOD VALUE:

P_Berry db 10d;*
P_Apple db 20d;@
P_Waffels db 30d;#

;FOOD SHAPE:

S_Berry db '*'
S_Apple db '@'
S_Waffels db '#'



          


