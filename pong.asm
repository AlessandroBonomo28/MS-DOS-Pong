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
        
        
        ;MOV CX, 0001h
        ;MOV DX, 86A0h ;100ms 
        
        ;MOV CX,0000h
        ;MOV DX,03E8h ;1ms 
        
        ;MOV AH, 86h
        ;INT 15h    ;delay  
        
        mov ah,0
        mov al,12h
        int 10h  ;clr screen
        
        ;LEA bx,colorDraw   
        ;mov byte ptr [bx], 0000b ; set colorDraw = black
        
        ;call DrawRect ; erase ball
        
        
        ;-------------------
        ; START check ball_bottom hit left wall and change xDirBall
        
        mov ax,xBall
        cmp ax,0000h ; se xBall = 0
        jne cansub1
           
        ; caso xBall = 0
        
        mov bl,xDirBall
        cmp bl,1b  ; se xDir = -1
        jne cansub1  
        
        ; caso xDirBall = -1 
                    
        LEA bx,xDirBall
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
        
        jne endprogram  ; esci se ricevi input (ZF=0)
        jmp loop
endprogram:   





     
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
charColor  DB 1010b

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
xDirBall DB 0b
yDirBall DB 1b 
ballColor  DB 1010b  


END