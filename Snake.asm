org 100h
MainManue:
call ClearAllRegAndVars

call SetUpSnake
Step:
;call CheckDirectionChange 
call SnakeMove
pop ax
cmp ax,1
je MainManue
call CheckDirectionChange
;call CheckWin
jmp Step

hlt
;=================================================================================================
proc SetUpSnake
    ClearField:
    mov dl,0
    mov dh,0  
    clear:
    mov bh, 0
    mov ah, 0x2
    int 0x10
    mov cx, 80 ; print chars
    mov bh, 0
    mov bl, 00d ; green bg/blue fg
    mov al, 0;'*';0x20 ; blank char
    mov ah, 0x9
    int 0x10
    inc dh
    
    cmp dh,25d
    jne clear
    
    mov dl,0
    mov dh,0
    
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
    inc dh
    mov cl,' '
    mov ch,20d
    push dx
    push cx
    push dx
    call SetPoint
    pop dx
    cmp dh,25d               
     
    jne L_drow 
          
    
    mov dl,79
    mov dh,0
     
    R_drow:
    inc dh
    mov cl,' '
    mov ch,20d
    push dx
    push cx
    push dx
    call SetPoint
    pop dx
    cmp dh,25d
    jne R_drow
    
     
    
    B_drow:
    mov bh, 0
    mov ah, 0x2
    int 0x10
    
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
proc ClearAllRegAndVars
    xor ax,ax
    xor bx,bx
    xor dx,dx
    xor cx,cx
    mov Head_X,1
    mov Head_Y,1
    mov Tail_X,1
    mov Tail_Y,1
    mov HeadDirection,2
    mov TailDirection,2
    mov Points,0d
    
    ret 
endp ClearAllReg
;===========================TESTS============================                      
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
;===========================TESTS==============================
 
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

proc GetPoint;Return to stack high-Color Low-Shape
    pop [150]
    pop dx;place dh = y; dl = x
    
    mov al,dh;mov al y value
    mov bl,80d
    mul bl
    add ax,ax
    add dl,dl
    mov dh,0
    add ax,dx
    mov bx,ax
    
    
    push ds
    mov ax, 0b800h
    mov ds,ax
    ;mov bx,1
    mov cx,[bx] 
    pop ds
    push cx
    push [150] 
    
    
    
    ret
endp GetPoint


;WORNING- May be a problem with Turns array problem and his word size
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
    cmp HeadDirection,1
    je Knone
    mov HeadDirection,1
    ;========Turns Alg=========
    cmp Turns_Length,0
    je Add_Turn1
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov dx,Turns[si-1]
    sub ah,dh
    mov Turns[si],ax
    jmp Knone
    Add_Turn1:
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov Turns[si],ax 
    inc Turns_Length
    ;===========================
    jmp Knone
    
    Kright:
    cmp HeadDirection,2
    je Knone
    mov HeadDirection,2
    
    ;========Turns Alg=========
    cmp Turns_Length,0
    je Add_Turn2
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov dx,Turns[si-1]
    sub ah,dh
    mov Turns[si],ax
    jmp Knone
    Add_Turn2:
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov Turns[si],ax
    inc Turns_Length 
    ;===========================
    
    
    
    jmp Knone
          
    Kdown:
    cmp HeadDirection,3
    je Knone
    mov HeadDirection,3
    
    ;========Turns Alg=========
    cmp Turns_Length,0
    je Add_Turn3
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov dx,Turns[si-1]
    sub ah,dh
    mov Turns[si],ax
    jmp Knone
    Add_Turn3:
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov Turns[si],ax
    inc Turns_Length 
    ;===========================
    jmp Knone
    
    Kleft:
    cmp HeadDirection,4
    je Knone
    mov HeadDirection,4
     
     ;========Turns Alg=========
    cmp Turns_Length,0
    je Add_Turn4
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov dx,Turns[si-1]
    sub ah,dh
    mov Turns[si],ax
    jmp Knone
    Add_Turn4:
    mov si,[Turns_Length]
    inc si
    mov al,HeadDirection
    mov ah,Snake_Size
    mov Turns[si],ax
    inc Turns_Length 
    ;===========================
    
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
    cmp IsSnakeEatten,1
    je skip
           
    cmp Turns_Length,0
    je RemoveTail
    mov si,1
    mov ax,Turns[si]
    
    dec ah
    mov Turns[si],ax
    
    cmp ah,0
    je ChangeTailDirection
    
    jmp RemoveTail
     
    ChangeTailDirection:
    ;up
    cmp al,1
    je Tail_Up
    cmp al,2
    je Tail_Right
    cmp al,3
    je Tail_Down
    cmp al,4
    je Tail_Left
    
    
    Tail_Up:
    mov TailDirection,1
    jmp RemoveTurnFromArray
    
    Tail_Right:
    
    mov TailDirection,2
    jmp RemoveTurnFromArray
    
    Tail_Down:
    mov TailDirection,3
    jmp RemoveTurnFromArray
    Tail_Left:
    mov TailDirection,4
    
    RemoveTurnFromArray:
    mov si,0
    cmp Turns_Length,1
    ja conti 
    
    mov Turns[si],0000h
    dec Turns_Length
    jmp RemoveTail
    
    conti:
    
    mov cx,Turns_Length
    dec cx 
    SortArray:
    mov ax,Turns[si+1]
    mov Turns[si],ax
    inc si
    loop SortArray
    dec Turns_Length 
    
    
    
     
    
    
    
    RemoveTail:
    
     mov cl,0
    mov ch,0
    push cx
    
    mov dh,Tail_Y
    mov dl,Tail_X 
    push dx
    call SetPoint
    
    mov IsSnakeEatten,0
    
    cmp TailDirection,1
    je MoveTailUp
    cmp TailDirection,2
    je MoveTailRight
    cmp TailDirection,3
    je MoveTailDown
    cmp TailDirection,4
    je MoveTailLeft
    
    
    MoveTailUp:
    dec Tail_Y
    jmp skip 
    MoveTailRight:
    inc Tail_X
    jmp skip
    MoveTailDown:
    inc Tail_Y
    jmp skip
    MoveTailLeft:
    dec Tail_X
    
    skip:
    
    
    
    
    
   
    
;    
;    push bx  
;    push dx
;    call SetPoint
;    
;    mov al,Blank
;    mov Snake_Shape,al 
    
    ;============
    
    cmp HeadDirection,1
    je up
    
    cmp HeadDirection,2
    je right
    
    cmp HeadDirection,3
    je down
    
    cmp HeadDirection,4
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
    
    call CheckLose
    pop ax
    cmp ax,1
    je GameLost
    mov cl,Snake_Shape
    mov ch,Snake_Color
    push cx
    
    mov dh,Head_Y
    mov dl,Head_X 
    push dx
    call SetPoint
    jmp PointDone
    GameLost:
    call GameOver
    pop [150]
    push 1
    push [150] 
    ret
    
    PointDone:
    
    
    ret
endp SnakeMove

proc CheckLose
    
    mov dh,Head_Y
    mov dl,Head_X
              
    push dx
    call GetPoint
    pop cx
    cmp cl,20h
    je Lost
    cmp cl,2ah
    je Lost
    jmp Continue
    
    
    
    Lost:
    pop [150]
    push 1
    push [150]
    ret
    Continue:
    pop [150]
    push 0
    push [150]
    ret
endp CheckLose

proc GameOver
    mov bh,0
    mov ah,13h
    mov al,0
    mov dh,10
    mov dl,10 
    mov bl,10
    mov cx,50d
    mov bp,offset MSG_GameOver1 
    int 10h 
    inc dh
    mov bp,offset MSG_GameOver2 
    int 10h
    inc dh
    mov bp,offset MSG_GameOver3 
    int 10h
    inc dh
    mov bp,offset MSG_GameOver4 
    int 10h
    
                        
    
    
    ret
endp GameOver
;====================



ret  

;========VARS========
;Cords
Head_X db 1  

Head_Y db 1

Tail_X db 1

Tail_Y db 1


HeadDirection db 2
TailDirection db 2

 


;Blank db ''
Turns dw 2000 dup(?)
Turns_Length dw 0

Snake_Size db 1

IsSnakeEatten db 0
                
              
 
 
;Values 
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

 
 
;===============STRINGS===============

MSG_GameOver1 db "  ___   __   _  _  ____     __   _  _  ____  ____ " 
MSG_GameOver2 db " / __) / _\ ( \/ )(  __)   /  \ / )( \(  __)(  _ \"
MSG_GameOver3 db "( (_ \/    \/ \/ \ ) _)   (  O )\ \/ / ) _)  )   /"
MSG_GameOver4 db " \___/\_/\_/\_)(_/(____)   \__/  \__/ (____)(__\_)" 

GO_Len equ $ - MSG_GameOver             

          


