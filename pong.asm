; 03h text mode   
; 13h graphical mode. 40x25. 256 colors. 320x200 pixels. 1 page. 
; 12h  12h = G  80x30	 8x16  640x480	 16/256K  .   A000 VGA,ATI VIP
; MS DOS usa 12h resolution

CreateWindow MACRO 
                 
    MOV AL, 12h   
    MOV AH, 0
    int 10h 
    
ENDM

org 100h

        CreateWindow
        
        ;LEA bx,charToWrite   
        ;mov byte ptr [bx], 50
        ;call WriteChar
        
loop:   NOP

        LEA bx,xDraw
        mov ax,xBall
        mov word ptr [bx], ax ; set xDraw = xBall
        
        LEA bx,yDraw 
        mov ax,yBall
        mov word ptr [bx], ax ; set yDraw = yBall
        
        LEA bx,widthDraw
        mov ax,ballWidth
        mov word ptr [bx], ax  ; set widthDraw = widthBall
        
        LEA bx,heightDraw      
        mov word ptr [bx], ax  ; set heightDraw = widthBall
        
        LEA bx,colorDraw   
        mov al,ballColor
        mov byte ptr [bx], al  ; set colorDraw = colorBall
        
        call DrawRect ; draw ball
        
        ;------------------------------
        
        LEA bx,xDraw
        mov ax,xOffPlayer
        mov word ptr [bx], ax ; set xDraw = xOffPlayer
        
        LEA bx,yDraw 
        mov ax,yPlayer1
        mov word ptr [bx], ax ; set yDraw = yPlayer1
        
        LEA bx,widthDraw
        mov ax,widthPlayer
        mov word ptr [bx], ax  ; set widthDraw = widthPlayer
        
        LEA bx,heightDraw
        mov ax,heightPlayer     
        mov word ptr [bx], ax  ; set heightDraw = heightPlayer
        
        LEA bx,colorDraw   
        mov al,colorPlayer
        mov byte ptr [bx], al  ; set colorDraw = colorPlayer
        
        call DrawRect ; draw player 1
        
        ;------------------------------
        
        LEA bx,xDraw
        mov ax,xMax
        sub ax,xOffPlayer
        mov word ptr [bx], ax ; set xDraw = xMax - xOffPlayer
        
        LEA bx,yDraw 
        mov ax,yPlayer2
        mov word ptr [bx], ax ; set yDraw = yPlayer2
        
        LEA bx,widthDraw
        mov ax,widthPlayer
        mov word ptr [bx], ax  ; set widthDraw = widthBall
        
        LEA bx,heightDraw
        mov ax,heightPlayer     
        mov word ptr [bx], ax  ; set heightDraw = widthBall
        
        LEA bx,colorDraw   
        mov al,colorPlayer
        mov byte ptr [bx], al  ; set colorDraw = colorBall
        
        call DrawRect ; draw player 2
        
        
        ;MOV CX, 0001h
        ;MOV DX, 86A0h ;100ms 
        
        ;MOV CX,0000h
        ;MOV DX,03E8h ;1ms 
        
        ;MOV AH, 86h
        ;INT 15h    ;delay  
        
        mov ah,0
        mov al,12h
        int 10h  ;clear screen
        
        ;LEA bx,colorDraw   
        ;mov byte ptr [bx], 0000b ; set colorDraw = black
        
        ;call DrawRect ; erase ball
        
        
        ;-------------------
        ; START check ball_bottom hit left wall and change xDirBall
        
        mov ax,xBall
        ; CASO xBall = 0
        cmp ax,0000h
        je p1loss
         
        mov dx,xOffPlayer
        add dx,widthPlayer
        
        cmp ax,dx ; se xBall = xOffPlayer+widthPlayer
        jne cansub1
           
        ; caso xBall = 0
        
        mov bl,xDirBall
        cmp bl,1b  ; se xDir = -1
        jne cansub1  
        
        ; caso xDirBall = -1 
        
        mov dx,yPlayer1
        mov cx,yBall
        cmp cx,dx; se xBall >= yplayer
        jae cond1
        jmp cansub1
cond1:  
        mov bx,heightPlayer
        
        add dx,bx
        cmp cx,dx
        jb hitp1
        jmp cansub1
                   
hitp1:  LEA bx,xDirBall
        mov byte ptr [bx], 0b ; set xDirBall = 0 
        
cansub1:; xBall > 0, END check wall for xDirBall
        
        
        ;-------------------
                            
        ; START check ball_bottom hit down wall and change yDirBall
        
        mov ax,yBall
        cmp ax,0000h ; se yBall = 0
        jne cansub2
           
        ; caso yBall = 0
        
        mov bl,yDirBall
        cmp bl,1b  ; se yDir = -1
        jne cansub2  
        
        ; caso yDirBall = -1 
                    
        LEA bx,yDirBall
        mov byte ptr [bx], 0b ; set yDirBall = 0 
        
cansub2: ; yBall > 0, END check wall for yDirBall
                            
        ;-------------------
                            
        ; START check ball_top hit right wall and change xDirBall
        mov ax,xBall
        mov bx,ballWidth
        add ax,bx 
        cmp ax,xMax ; se xBall+ballWidth = xMax
        jne canadd1
                           
        ; caso xBall+ballWidth = xMax
        
        mov bl,xDirBall
        cmp bl,0b  ; se xDir = 1
        jne canadd1                      
        
        ; caso xDirBall = 1 
                    
        LEA bx,xDirBall
        mov byte ptr [bx], 1b ; set xDirBall = 0 
        
canadd1: ; xBall > 0, END check wall for xDirBall
                   
        ;-------------------
        
        ; START check ball_top hit up wall and change yDirBall
        mov ax,yBall
        mov bx,ballWidth
        add ax,bx 
        cmp ax,yMax ; se yBall+ballWidth = yMax
        jne canadd2
                           
        ; caso yBall+ballWidth = yMax
        
        mov bl,yDirBall
        cmp bl,0b  ; se xDir = 1
        jne canadd2                      
        
        ; caso xDirBall = 1 
                    
        LEA bx,yDirBall
        mov byte ptr [bx], 1b ; set xDirBall = 0 
        
canadd2: ; xBall > 0, END check wall for xDirBall
                   
        ;-------------------
        
        ; change x
           
        
        mov ax,xBall
        
        mov bl, xDirBall
        cmp bl,1b ; se xDirBall = -1
        je decr1
        add ax,0001h  ;incremento
        jmp endinc1 
decr1:  sub ax,0001h      
endinc1:        
        
        
        LEA bx,xBall
        mov word ptr [bx], ax 
        
        ; change y 
        
        
        mov ax,yBall
        
        mov bl, yDirBall
        cmp bl,1b ; se yDirBall = -1
        je decr2
        add ax,0001h  ;incremento
        jmp endinc2 
decr2:  sub ax,0001h      
endinc2:


        LEA bx,yBall
        mov word ptr [bx], ax 
        
                 
           
        MOV AH,01h
        INT 16H  ; interrupt check input
        
        ; al contains keypressed
        jne press 
        jmp nokeys  
        
press:  cmp al,77h ; w press
        je wpress
        jmp next1 
        
wpress: mov dx,yPlayer1
        push dx
        
        add dx,heightPlayer
        mov cx,yMax
        cmp dx,cx
        jae flush
        
        pop dx
        inc dx
        
        LEA bx,yPlayer1
        mov word ptr [bx], dx
next1:  

        cmp al,73h ; s press
        je spress
        jmp next2 
        
spress: mov dx,yPlayer1
        
        cmp dx,0000h
        je flush
        
        sub dx,0001h
        
        LEA bx,yPlayer1
        mov word ptr [bx], dx
next2:  

;------------

        cmp al,69h ; i press
        je ipress
        jmp next3 
        
ipress: mov dx,yPlayer2
        push dx
        
        add dx,heightPlayer
        mov cx,yMax
        cmp dx,cx
        jae flush
        
        pop dx
        inc dx
        
        LEA bx,yPlayer2
        mov word ptr [bx], dx
next3:  

        cmp al,6Bh ; k press
        je kpress
        jmp next4 
        
kpress: mov dx,yPlayer2
        
        cmp dx,0000h
        je flush
        
        sub dx,0001h
        
        LEA bx,yPlayer2
        mov word ptr [bx], dx
next4:

;-----------
        cmp al,71h ; q press ends program
        je endprogram 
        
flush:  mov ah,0ch
        mov al,0
        int 21h ; flush buffer
        
nokeys:
        
        ;jne endprogram  ; esci se ricevi input (ZF=0)
        jmp loop

p1loss: 
        LEA bx,charColor   
        mov byte ptr [bx], 0001b
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 80 ;P
        LEA bx,xChar   
        mov byte ptr [bx], 0Ah ;x
        LEA bx,yChar   
        mov byte ptr [bx], 05 ;y
        call WriteChar
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 49 ;1 
        LEA bx,xChar   
        mov byte ptr [bx], 0Bh ;x
        call WriteChar
        
        LEA bx,charColor   
        mov byte ptr [bx], 1100b 
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 76 ;L 
        LEA bx,xChar   
        mov byte ptr [bx], 0Dh ;x
        call WriteChar
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 79 ;O 
        LEA bx,xChar   
        mov byte ptr [bx], 0Eh ;x
        call WriteChar 
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 83 ;S 
        LEA bx,xChar   
        mov byte ptr [bx], 0Fh ;x
        call WriteChar
        
        LEA bx,charToWrite   
        mov byte ptr [bx], 83 ;S 
        LEA bx,xChar   
        mov byte ptr [bx], 10h ;x
        call WriteChar
        
endprogram:   

        
MOV CX,001Eh
MOV DX,8480h ;2s 

MOV AH, 86h
INT 15h    ;delay

     
RET


xDraw DW 0000h
yDraw DW 0000h
widthDraw  DW 0005h
heightDraw DW 0005h
colorDraw DB 1100b

              
DrawRect PROC 
         
         mov ax,0 ; init counter primo for 
loop1:   mov cx,0 ; init counter for annidato

loop2:   mov bx,cx ; copia counter cx in bx
    	 
    	 mov dx,xDraw
    	 add cx,dx    ; cx = x of pixel for int10h
    	 	 
    	 mov dx,yDraw
    	 add dx,ax ; dx = y of pixel for int10h 
    	 
    	 push ax
    	 push bx ; salva i counter
    	 
    	 push dx
    	 
    	 mov ah, 0ch
    	 mov dl, colorDraw
    	 mov al, dl
    	 
    	 pop dx
    	 
    	 int 10h     ; set pixel
         
         pop cx 
         pop ax ; ripristina i counter
         inc cx
         
         mov dx,widthDraw       
         cmp cx,dx  ; iterazioni for annidato
         jne loop2 
         inc ax 
         mov dx,heightDraw         
         cmp ax,dx  ; iterazioni primo for 
         jne loop1    
        
RET
    
ENDP

xChar DB 05h
yChar DB 05h
charToWrite  DB 49
charColor  DB 0001b

WriteChar PROC 
     
    mov dh, yChar
	mov dl, xChar
	mov bh, 0
	mov ah, 2
	int 10h ; set cursor 
	
	mov ah,09h
	mov AL,charToWrite ; = character to display.
    mov BH,0 ; page number.
    mov BL,charColor ; = attribute.
    mov CX,1 ;= number of times to write character.
    
    
    INT 10h  ;write char
    
RET

ENDP

; resolution of int 12h is 640x480 

; range x: [0-639]; range y: [0-479]


xMax DW 027Fh ; = 639
yMax DW 01DFh ; = 479 

xBall DW 017Fh
yBall DW 0190h
ballWidth DW 0005h
xDirBall DB 1b
yDirBall DB 0b 
ballColor  DB 1010b  


yPlayer1 DW 00BEh
yPlayer2 DW 00BEh

widthPlayer DW 0002h
heightPlayer DW 0064h
xOffPlayer DW 000Ah
yOffPlayer DW 00BEh
colorPlayer  DB 1100b 

END