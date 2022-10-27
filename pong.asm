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

DrawRect MACRO x, y, width, height, color
        
            
        
         mov dx,0
        
         mov ax,0 ;init counter ax 
loop1:   mov cx,0  
loop2:   push ax
         push cx ; conserva i counter nello stack
         
         
         
         
         nop ; operazioni a piacere for annidato
         
          ; set graphics video mode. 
    	  
    	 pop cx ; cx = ax counter (yoff)
    	 pop ax ; ax = cx counter = xoff
    	 
    	 mov bx,cx ; bx = cx (ax counter)
    	 
    	 add cx,y    ; cx = y of pixel for int10h
    	 
    	 mov dx,ax
    	 
    	 add dx, x   ; dx = x of pixel for int10h 
    	 
    	 push ax
    	 push bx
    	 
    	 mov ah, 0ch
    	 mov al, color
    	 int 10h     ; set pixel
         
         
         
         pop cx
         pop ax ; ripristina i counter
         inc cx
         ; fine op for annidato        
         cmp cx,width  ; iterazioni for annidato
         jne loop2 
         inc ax          
         cmp ax,height  ; iterazioni primo for 
         jne loop1    
        
 
    
ENDM



CreateWindow MACRO ; graphical mode. 40x25. 256 colors. 320x200 pixels. 1 page.
 
    

    
    MOV AL, 13h   ; 03h text mode - 13h graphic mode
    MOV AH, 0
    int 10h 
    
    

ENDM

org 100h
        CreateWindow
        
        ;0Fch = white
        
        ;WriteChar 5,5,49,0Fch
        ;WriteChar 5,6,50,03ch
        
        
        ;LEA BX,wBall
        DrawRect 5,5,50,50,1100b 
        
        ;DrawRect 0,0,5,5,1100b
        
        
loop:   MOV AH,01h
        INT 16H  ; interrupt check input
        
        
        NOP
        
        
        jne end  ; esci se ricevi input (ZF=0)
        jmp loop
end:        
        ret
              
              
              
        wBall DW 000Ah      
        xBall DW 0019h ; intero
        yBall DW 000Fh ; intero


