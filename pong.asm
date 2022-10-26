
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
        
        
        mov AX, xBall
        mov BX, yBall
        add AX,BX ;somma i due interi

loop:   MOV AH,01h
        INT 16H  ; interrupt check input
        
        jne end  ; esci se ricevi input (ZF=0)
        jmp loop
end:        
        ret
              
              
              
              
        xBall DW 0019h ; intero
        yBall DW 000Fh ; intero


