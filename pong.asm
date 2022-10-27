WriteChar MACRO x, y, char, color
    
    mov dh, y
	mov dl, x
	mov bh, 0
	mov ah, 2
	int 10h ; set cursor
    
    MOV BH,0
    MOV AH, 0Ah
    MOV AL,char
    MOV CX,1
    INT 10h  ;write char
    
ENDM







CreateWindow MACRO 
                 ; 03h text mode
    
                 ; 13h graphical mode. 40x25. 256 colors. 320x200 pixels. 1 page. 
                 ; 12h  12h = G  80x30	 8x16  640x480	 16/256K  .   A000 VGA,ATI VIP
                 ; MS DOS usa 12h resolution
    
    MOV AL, 12h   
    MOV AH, 0
    int 10h 
    
    

ENDM

org 100h
        CreateWindow
        
        ;0Fch = white
        
        WriteChar 5,5,49,0Fch
        
        
        
        
        call DrawRect 
        
        LEA bx,xDraw
        mov word ptr [bx], 0005h
        
        LEA bx,yDraw
        mov word ptr [bx], 0005h
        
        call DrawRect 
        
        
        
loop:   MOV AH,01h
        INT 16H  ; interrupt check input
        
        
        NOP
        
        
        jne endlabel  ; esci se ricevi input (ZF=0)
        jmp loop
endlabel:   





     
RET


xDraw DW 0000h
yDraw DW 0000h
widthDraw  DW 0005h
heightDraw DW 0005h
colorDraw DB 1100b

              
DrawRect PROC 
              
         mov ax,0 ;init counter ax 
loop1:   mov cx,0  
loop2:   push ax
         push cx ; conserva i counter nello stack
         
         
         
         
         nop ; operazioni a piacere for annidato
         
          ; set graphics video mode. 
    	  
    	 pop cx ; cx = ax counter (yoff)
    	 pop ax ; ax = cx counter = xoff
    	 
    	 mov bx,cx ; bx = cx (ax counter)
    	 
    	 mov dx,yDraw
    	 add cx,dx    ; cx = y of pixel for int10h
    	 
         	 
    	 mov dx,xDraw
    	 add dx,ax ; dx = x of pixel for int10h 
    	 
    	    
    	 
    	 push ax
    	 push bx
    	 
    	 push dx
    	 
    	 mov ah, 0ch
    	 mov dl, colorDraw
    	 mov al, dl
    	 
    	 pop dx
    	 
    	 int 10h     ; set pixel
         
         
         
         pop cx
         pop ax ; ripristina i counter
         inc cx
         ; fine op for annidato 
         mov dx,widthDraw       
         cmp cx,dx  ; iterazioni for annidato
         jne loop2 
         inc ax 
         mov dx,heightDraw         
         cmp ax,dx  ; iterazioni primo for 
         jne loop1    
        
RET
    
ENDP
              



END