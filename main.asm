ORG 0080h

Main:
	Clr P1.3		
	Call ConfiguraDisplay	
	SetB P1.3	
	MOV DPTR, #TxtPedeSenha	

PedeSenha:

	Clr A
	Movc A,@A+DPTR	
	Jz Proximo		
	Call Escreve	
	Inc DPTR		
	Jmp PedeSenha
	
Proximo: 	

	MOV R1, #10h
	MOV R6, #00h

Iterar: 

	Call ScanTeclado	
	SetB P1.3		
	Clr A
	Mov A, #'X'
	Call Escreve	
	
	Inc R6
	Cjne R6, #04H, Iterar

PreparaConfirmaSenha:
	Call clearDisplay

	CALL PosicaoCursor
	Setb p1.3
	MOV DPTR, #TxtConfirmaSenha


ConfirmaSenha:
	Clr A
	Movc A,@A+DPTR	
	Jz Proximo2		
	Call Escreve	
	Inc DPTR		
	Jmp ConfirmaSenha

Proximo2: 	

	MOV R4, #00h
	MOV R5, #00h
	MOV R1, #10h

RecebeSenha: 

	Call ScanTeclado_r7	
	SetB P1.3		
	Clr A
	Mov A,#'X'
	Call Escreve	
	
	Clr A
	Mov A,@R1	
	Call Compara	
	Inc R1
	Inc R4
	Cjne R4,#04h,RecebeSenha
	
	Cjne R5,#04h,AcessoNegado	

AcessoLiberado:
	MOV A, #20H
	Jmp $



AcessoNegado:
	MOV A, #25H
	Jmp $
clearDisplay:
	CLR P1.3	
	CLR P1.7		
	CLR P1.6		
	CLR P1.5
	CLR P1.4

	SETB P1.2
	CLR P1.2

	CLR P1.7
	CLR P1.6
	CLR P1.5
	SETB P1.4

	SETB P1.2
	CLR P1.2

	MOV R6, #40
	rotC:
	CALL delay
	DJNZ R6, rotC
	RET


ConfiguraDisplay:	
	
	Clr  P1.7		
	Clr  P1.6		
	SetB P1.5		
	Clr  P1.4	
	
	Call Pulso
	Call Delay		
	Call Pulso
						
	SetB P1.7		 
	Clr  P1.6
	Clr  P1.5
	Clr  P1.4
		
	Call Pulso
	Call Delay
	
	Clr P1.7		 
	Clr P1.6		 
	Clr P1.5		 
	Clr P1.4	  

	Call Pulso

	SetB P1.7		
	SetB P1.6		
	SetB P1.5		
	SetB P1.4		
	
	Call Pulso
	Call Delay

	Clr P1.7		
	Clr P1.6		
	Clr P1.5		
	Clr P1.4		

	Call Pulso

	Clr  P1.7		
	SetB P1.6		
	SetB P1.5		
	Clr  P1.4		 

	Call Pulso
	Call Delay

	Ret


PosicaoCursor:	
	Clr P1.3
	SetB P1.7		
	SetB P1.6		
	Clr P1.5											 
	Clr P1.4		 									 
						
	Call Pulso

	Clr P1.7		 									 
	Clr P1.6											 
	Clr P1.5											 
	Clr P1.4		 									 
						
	Call Pulso

	Call Delay			
	Ret

Pulso:		

	SetB P1.2		
	Clr  P1.2		
	Ret

Escreve:	
	Setb P1.3

	Mov C, ACC.7		
	Mov P1.7, C		
	Mov C, ACC.6		
	Mov P1.6, C		
	Mov C, ACC.5		
	Mov P1.5, C		
	Mov C, ACC.4		
	Mov P1.4, C		

	Call Pulso

	Mov C, ACC.3		
	Mov P1.7, C		
	Mov C, ACC.2		
	Mov P1.6, C		
	Mov C, ACC.1		
	Mov P1.5, C		
	Mov C, ACC.0		
	Mov P1.4, C		

	Call Pulso
	Call Delay		
	
	Ret



Compara:	
	Cjne A,07H,Saida	
	Inc R5

Saida:
	Ret

Delay:		

	Mov R0, #50
	Djnz R0, $
	Ret
			
ScanTeclado:	

	CLR P0.3			
	CALL Linha1
	SetB P0.3			
	JB F0,Feito  		
				
	CLR P0.2			
	CALL Linha2		
	SetB P0.2			
	JB F0,Feito						

	CLR P0.1			
	CALL Linha3		
	SetB P0.1			
	JB F0,Feito							

	CLR P0.0			
	CALL Linha4		
	SetB P0.0			
	JB F0,Feito														
	JMP ScanTeclado							
			
Feito:

	Clr F0		        	
	Ret
	
Linha1:	

	JNB P0.4, Bt3	
	JNB P0.5, Bt2	
	JNB P0.6, Bt1	
	RET					

Bt3:	

	SETB F0	
	MOV @R1, #'3'
	INC R1
	RET				

Bt2:	

	SETB F0			
	MOV @R1, #'2'
	INC R1
	RET				

Bt1:	

	SETB F0			
	MOV @R1, #'1'
	INC R1	
	RET				

Linha2:	

	JNB P0.4, Bt6	
	JNB P0.5, Bt5	
	JNB P0.6, Bt4	
	RET					

Bt6:	

	SETB F0			
	MOV @R1, #'6'
	INC R1	
	RET				

Bt5:	

	SETB F0			
	MOV @R1, #'5'
	INC R1	
	RET				

Bt4:	

	SETB F0			
	MOV @R1, #'4'
	INC R1
	RET				

Linha3:	

	JNB P0.4, Bt9	
	JNB P0.5, Bt8	
	JNB P0.6, Bt7	
	RET					

Bt9:	

	SETB F0			
	MOV @R1, #'9'
	INC R1	
	RET				

Bt8:	

	SETB F0			
	MOV @R1, #'8'
	INC R1	
	RET				

Bt7:	

	SETB F0			
	MOV @R1, #'7'
	INC R1	
	RET				

Linha4:	

	JNB P0.5, Bt0	
	RET					

Bt0:	

	SETB F0			
	MOV @R1, #'0'
	INC R1	
	RET				
		

ScanTeclado_r7:

    CLR P0.3
    CALL Linha1_r7
    SetB P0.3
    JB F0,Feito_r7

    CLR P0.2
    CALL Linha2_r7
    SetB P0.2
    JB F0,Feito_r7

    CLR P0.1
    CALL Linha3_r7
    SetB P0.1
    JB F0,Feito_r7

    CLR P0.0
    CALL Linha4_r7
    SetB P0.0
    JB F0,Feito_r7
    JMP ScanTeclado_r7

Feito_r7:

    Clr F0
    Ret

Linha1_r7:

    JNB P0.4, Bt3_r7
    JNB P0.5, Bt2_r7
    JNB P0.6, Bt1_r7
    RET

Bt3_r7:

    SETB F0
    MOV R7, #'3'
    RET

Bt2_r7:

    SETB F0
    MOV R7, #'2'
    RET

Bt1_r7:

    SETB F0
    MOV R7, #'1'
    RET

Linha2_r7:

    JNB P0.4, Bt6_r7
    JNB P0.5, Bt5_r7
    JNB P0.6, Bt4_r7
    RET

Bt6_r7:

    SETB F0
    MOV R7, #'6'
    RET

Bt5_r7:

    SETB F0
    MOV R7, #'5'
    RET

Bt4_r7:

    SETB F0
    MOV R7, #'4'
    RET

Linha3_r7:

    JNB P0.4, Bt9_r7
    JNB P0.5, Bt8_r7
    JNB P0.6, Bt7_r7
    RET

Bt9_r7:

    SETB F0
    MOV R7, #'9'
    RET

Bt8_r7:

    SETB F0
    MOV R7, #'8'
    RET

Bt7_r7:

    SETB F0
    MOV R7, #'7'
    RET

Linha4_r7:

    JNB P0.5, Bt0_r7
    RET

Bt0_r7:
    SETB F0
    MOV R7, #'0'
    RET



TxtPedeSenha:		DB 'C', 'R', 'I', 'E', 32, 'S', 'E', 'N', 'H', 'A',':',0
TxtConfirmaSenha:   DB 'C', 'O', 'N', 'F', 'I', 'R', 'M', 'E', ':', 0