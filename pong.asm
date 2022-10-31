MACRO HowToPlay
        mov charColor, 0001b
        
        mov charToWrite , 80 ;P
        mov xChar, 05h ;x
        mov yChar, 05h ;y
        call WriteChar
        
        mov charToWrite, 49 ;1 
        mov xChar, 06h ;x
        call WriteChar
         
        mov charColor, 1111b
        
        mov charToWrite, 24d ; freccia su
        mov xChar, 0Ah ;x
        mov yChar, 05h ;y
        call WriteChar    
        
        
        mov charToWrite, 87d ; W
        mov xChar, 0Ch ;x
        mov yChar, 05h ;y
        call WriteChar   
        
        mov charToWrite, 25d ; freccia giu
        mov xChar, 0Ah ;x
        mov yChar, 08h ;y
        call WriteChar    
        
        
        mov charToWrite, 83d ; S
        mov xChar, 0Ch ;x
        mov yChar, 08h ;y
        call WriteChar  
        
        ;----
        
        mov charColor, 0001b
        
        mov charToWrite, 80 ;P
        mov xChar, 15h ;x
        mov yChar, 05h ;y
        call WriteChar
        
        mov charToWrite, 50 ;2 
        mov xChar, 16h ;x
        call WriteChar
         
        mov charColor, 1111b
        
        mov charToWrite, 24d ; freccia su
        mov xChar, 1Ah ;x
        mov yChar, 05h ;y
        call WriteChar    
        
        
        mov charToWrite, 73d ; I
        mov xChar, 1Ch ;x
        mov yChar, 05h ;y
        call WriteChar   
        
        mov charToWrite, 25d ; freccia giu
        mov xChar, 1Ah ;x
        mov yChar, 08h ;y
        call WriteChar    
        
        
        mov charToWrite, 75d ; K
        mov xChar, 1Ch ;x
        mov yChar, 08h ;y
        call WriteChar
        
        ;----
        
        mov charColor, 1100b
        
        mov charToWrite, 83d ;s
        mov xChar, 05h ;x
        mov yChar, 0Fh ;y
        call WriteChar
        
        mov charToWrite, 84d ;t
        mov xChar, 06h ;x
        mov yChar, 0Fh ;y
        call WriteChar
        
        mov charToWrite, 65d ;a
        mov xChar, 07h ;x
        mov yChar, 0Fh ;y
        call WriteChar
        
        mov charToWrite, 82d ;r
        mov xChar, 08h ;x
        mov yChar, 0Fh ;y
        call WriteChar
        
        mov charToWrite, 84d ;t
        mov xChar, 09h ;x
        mov yChar, 0Fh ;y
        call WriteChar 
        
        mov charToWrite, 16d ;play
        mov xChar, 0Bh ;x
        mov yChar, 0Fh ;y
        call WriteChar   
        
loop0:    
        MOV AH,01h
        INT 16H  ; interrupt check input
        
        ; al now contains keypressed
        jne press0 
        jmp nokeys0  
        
press0: 
        
        mov ah,0ch
        mov al,0
        int 21h ; flush buffer
        jmp endmacro0
nokeys0:
        
        jmp loop0

endmacro0:
mov ah,0
mov al,12h
int 10h  ;clear screen    
    
ENDM

org 100h

        MOV AL, 12h   
        MOV AH, 0
        int 10h  ; set MSDOS compatible video mode
        ; mode 12h:
        ; text res: 80x30, pixel box: 8x16  
        ; pixel res: 640x480, colors: 16/256K
        ; video mem address: A000, system: VGA,ATI VIP 
        HowToPlay
        
        
loop:   
        
        MOV AH,2Ch
		INT 21h    	; get sys time		
		
		CMP DL,curTime  	
		JE loop   
        
        MOV curTime,DL    ;update time
        
        mov ah,0
        mov al,12h
        int 10h  ;clr screen

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
        sub ax,widthPlayer
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
        
        ;mov ah,0
        ;mov al,12h
        ;int 10h  ;clear screen
        
        ;----------------------------
        
        ; check ball_bottom hit left wall
        
        mov ax,xBall
        cmp ax,0000h
        je p1loss 
        
        ; xBall is 0 
        
        mov dx, xOffPlayer
        cmp ax,dx ; if xBall < xOffPlayer
        jb cansub1
        
        mov dx,xOffPlayer
        add dx,widthPlayer
        ;add dx,ballStep
        
        cmp ax,dx ; if xBall >= xOffPlayer+widthPlayer+ stepBall
        jae cansub1 
        
        
           
        ; xBall = xOffPlayer+widthPlayer
        
        mov bl,xDirBall
        cmp bl,1b  ; se xDir = -1
        jne cansub1  
        
        ; xDirBall = -1 
        
        mov dx,yPlayer1
        mov cx,yBall
        cmp cx,dx; if xBall >= yPlayer1
        jae condp1
        jmp cansub1
condp1: 
        mov bx,heightPlayer
        
        add dx,bx ; dx = yPlayer1 + heightPlayer
        cmp cx,dx
        jb hitp1
        jmp cansub1
                   
hitp1:  LEA bx,xDirBall ; if yPlayer2 + heightPlayer < yBall
        mov byte ptr [bx], 0b ; set xDirBall = 0 (positive direction)
        
cansub1:
        ; ball will not hit left wall and player
        
        
        ;-------------------
                            
        ; check ball_bottom hit down wall
        
        mov ax,yBall
        cmp ax,0000h ; se yBall = 0
        jne cansub2
           
        ; caso yBall = 0
        
        mov bl,yDirBall
        cmp bl,1b  ; se yDir = -1
        jne cansub2  
        
        ; caso yDirBall = -1 
                    
        LEA bx,yDirBall
        mov byte ptr [bx], 0b ; set yDirBall = 0 (positive direction)
        
cansub2: ; ball will not hit down wall
                            
        ;-------------------
                            
        ; check ball_top hit right wall
        
        mov ax,xBall
        mov bx,ballWidth
        add ax,bx 
        mov cx,xMax
        cmp ax,cx ; if xBall+ballWidth = xMax
        je p2loss
        
        
        mov ax,xBall
        mov bx,ballWidth
        add ax,bx 
        mov cx,xMax
        sub cx,xOffPlayer
        cmp ax,cx ; if xBall+ballWidth > xMax - xOffPlayer
        ja canadd1
        
        mov ax,xBall
        mov bx,ballWidth
        add ax,bx 
        mov cx,xMax
        sub cx,xOffPlayer  
        sub cx,widthPlayer
        cmp ax,cx ; if xBall+ballWidth < xMax - xOffPlayer - widthPlayer
        jb canadd1
                           
        ; xBall+ballWidth = xMax - xOffPlayer
        
        mov bl,xDirBall
        cmp bl,0b  ; if xDir = 1
        jne canadd1                      
        
        ; xDirBall = 1 
        
        mov dx,yPlayer2
        mov cx,yBall
        add cx,ballWidth
        cmp cx,dx ; if yBall+ballWidth >= yPlayer2
        jae condp2
        jmp canadd1
condp2:  
        mov bx,heightPlayer
        
        add dx,bx
        cmp cx,dx ; if yPlayer2 + heightPlayer < yBall +ballWidth
        jb hitp2
        jmp canadd1
                   
hitp2:  LEA bx,xDirBall
        mov byte ptr [bx], 1b ; set xDirBall = 1 (negative direction) 
        
canadd1: ; ball will not touch right wall and player2
                   
        ;-------------------
        
        ; check ball_top hit up wall
        mov ax,yBall
        mov bx,ballWidth
        add ax,bx 
        cmp ax,yMax ; se yBall+ballWidth = yMax
        jne canadd2
                           
        ; caso yBall+ballWidth = yMax
        
        mov bl,yDirBall
        cmp bl,0b  ; se yDir = 1
        jne canadd2                      
        
        ; caso yDirBall = 1 
                    
        LEA bx,yDirBall
        mov byte ptr [bx], 1b ; set yDirBall = 1 (negative direction) 
        
canadd2: ; ball will not hit top wall
                   
        ;-------------------
        
        call UpdateBall 
        
                 
           
        MOV AH,01h
        INT 16H  ; interrupt check input
        
        ; al now contains keypressed
        jne press 
        jmp nokeys  
        
press:  cmp al,73h ; s pressed
        je dwnkey1
        jmp next1 
        
dwnkey1:  
      
        mov dx,yPlayer1
        add dx,heightPlayer
        mov bx,yMax
        sub bx,playerStep
        cmp dx,bx ; se al prossimo step esci dal muro top
        jb incyp1 
        ; caso esci dal muro  
        mov bx,yMax
        sub bx,heightPlayer
        mov yPlayer1,bx 
        jmp flush      
incyp1: mov bx,yPlayer1
        add bx,playerStep
        mov yPlayer1,bx        
next1:  

        cmp al,77h ; w pressed
        je upkey1
        jmp next2 
        
upkey1: 
        mov dx,playerStep
        cmp dx,yPlayer1 ; se esci dal muro bottom
        jb subyp1
        mov yPlayer1, 0000h
        jmp flush
        
subyp1: mov dx,yPlayer1
        sub dx,playerStep
        mov yPlayer1,dx
next2:  

;------------

        cmp al,6Bh ; k pressed
        je dwnkey2
        jmp next3 
        
dwnkey2:
        
        mov dx,yPlayer2
        add dx,heightPlayer
        mov bx,yMax
        sub bx,playerStep
        cmp dx,bx ; se al prossimo step esci dal muro top
        jb incyp2 
        ; caso esci dal muro  
        mov bx,yMax
        sub bx,heightPlayer
        mov yPlayer2,bx 
        jmp flush      
incyp2: mov bx,yPlayer2
        add bx,playerStep
        mov yPlayer2,bx
next3:  

        cmp al,69h ; i pressed
        je upkey2
        jmp next4 
        
upkey2:
        mov dx,playerStep
        cmp dx,yPlayer2 ; se esci dal muro bottom
        jb subyp2
        mov yPlayer2, 0000h
        jmp flush
        
subyp2: mov dx,yPlayer2
        sub dx,playerStep
        mov yPlayer2,dx
next4:

;-----------
        cmp al,71h ; q press ends program
        je endprogram 
        
flush:  mov ah,0ch
        mov al,0
        int 21h ; flush buffer
        
nokeys:
        
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
        
        jmp msg
p2loss: 

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
        mov byte ptr [bx], 50 ;2 
        LEA bx,xChar   
        mov byte ptr [bx], 0Bh ;x
        call WriteChar
               
msg:    LEA bx,charColor   
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
        
        MOV CX,001Eh
        MOV DX,8480h ;2s 
        
        MOV AH, 86h
        INT 15h    ;delay
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
    	 add cx,dx    
    	 	 
    	 mov dx,yDraw
    	 add dx,ax   
    	 
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

PROC UpdateBall  
    
        mov ax,ballStep
        cmp ax,xBall ; se dista uno step da left wall
        jb L1
        mov al,xDirBall
        cmp al,1b    ; se la direzione x = -1
        jne L1
        
        mov xBall,0000h
        jmp updated
    
L1:     ; in bound left wall
        
        mov ax,ballStep
        cmp ax,yBall
        jb L2 
        mov al,yDirBall
        cmp al,1b     ; se la direzione y = -1
        jne L2
        mov yBall,0000h
        jmp updated
L2:     ; in bound bottom wall

        
        mov ax,xBall
        add ax,ballWidth
        
        mov bx,xMax
        sub bx,ballStep
        
        cmp ax,bx
        jb L3     
        
        mov al,xDirBall
        cmp al,0b
        jne L3
        
        mov ax,xMax
        sub ax,ballWidth
        mov xBall,ax
        jmp updated
L3:     ; in bound right wall

        mov ax,yBall
        add ax,ballWidth
        
        mov bx,yMax
        sub bx,ballStep
        
        cmp ax,bx
        jb L4     
        
        mov al,yDirBall
        cmp al,0b
        jne L4
        
        mov ax,yMax
        sub ax,ballWidth
        mov yBall,ax
        jmp updated
L4:     ; in bound top wall
        
        
     ; update xBall
           
        
        mov ax,xBall
        
        mov bl, xDirBall
        cmp bl,1b
        je decr1
        add ax,ballStep  
        jmp endinc1 
decr1:  sub ax,ballStep      
endinc1:        
        
        
        LEA bx,xBall
        mov word ptr [bx], ax 
        
        ; update yBall
        
        
        mov ax,yBall
        
        mov bl, yDirBall
        cmp bl,1b
        je decr2
        add ax,ballStep  
        jmp endinc2 
decr2:  sub ax,ballStep      
endinc2:


        LEA bx,yBall
        mov word ptr [bx], ax 
        
    
updated:RET
ENDP

; resolution of int 12h is 640x480 

; range x: [0-639]; range y: [0-479]


xMax DW 027Fh ; = 639
yMax DW 01DFh ; = 479 

xBall DW 01F4h
yBall DW 0190h
ballWidth DW 0006h
xDirBall DB 1b ; 1b = -dir, 0b = +dir
yDirBall DB 0b ; 1b = -dir, 0b = +dir
ballColor  DB 1010b
  
ballStep DW 0006h

yPlayer1 DW 00BEh
yPlayer2 DW 00BEh

widthPlayer DW 0006h ; deve essere >= ballStep
heightPlayer DW 0064h
xOffPlayer DW 00012h
yOffPlayer DW 00BEh
colorPlayer  DB 1100b 

playerStep DW 000Ah

curTime DB 00h 

END