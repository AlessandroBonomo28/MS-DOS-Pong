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
        
        mov bh,width
        sub bh,x  ; tot pixel x
        mov bl,x,height
        sub bl,y  ; tot pixel y
        
        mov ax,1 ;init counter ax
loop1   mov cx,bh ; iterazioni primo loop init a tot pixel x   
loop2   nop ; set pixel TODO
                 
        
        loop loop2           
        cmp ax,bl  ;iterazioni sub-loop int a tot pixel y 
        je loop1    
        
 
    
ENDM



CreateWindow MACRO ; graphical mode. 40x25. 256 colors. 320x200 pixels. 1 page.
 
    

    
    MOV AL, 13h   ; 03h text mode - 13h graphic mode
    MOV AH, 0
    int 10h 
    
    

ENDM

org 100h
        CreateWindow
        
        ;0Fch = white
        
        WriteChar 5,5,49,0Fch
        WriteChar 5,6,50,03ch
        
        
        ;LEA BX,wBall
        ;DrawRect 10,10,[BX],[BX],0Fch
        
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


