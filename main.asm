ORG 0080h ;Definição do inicio do programa

Main:
	MOV R2, #03h ; Criamos o R2 em 3 para ser usado futuramente como contador de tentativas
	MOV R1, #10h ;Criamos o R1 em 10 para armazenarmos a senha nessa posicao da memoria
	MOV R6, #00h ;Criamos o R6 em 0 para usarmo como contador do numero de caracteres inseridos na senha
	
	MOV DPTR, #TxtPedeSenha	;Movemos para o DPTR o texto de soliciação de senha

	Call ConfiguraDisplay	;Chamamos a rotina que configura o Display para exibição
	Call Escreve 	;Chamamos a rotina que escreve o texto presente no DPTR

PedeSenha: 

	Call ScanTeclado ;Chama a rotina que recebe a entrada do usuário e armazena no valor do R1 na memória e no R7 que não é usado ainda
	SetB P1.3	

	Clr A ; Limpamos o valor de A 
	Mov A, #'X' ;enviamos o valor de X como caracter
	Call CriptoGrafa	;Chamamos a rotina que envia o valor do A para o display
	
	Inc R1
	Inc R6 ;Incrementamos o R6 a cada repetição
	Cjne R6, #04H, PedeSenha ;Repetimos a rotina enquanto o R6 não for 4

PreparaConfirmaSenha:
	
	Call clearDisplay ;Chamamos a rotina que limpa o Display
	MOV DPTR, #TxtConfirmaSenha ;Movemos para o DPTR o texto que pede a confirmação da senha
	Call Escreve ;Chamamos a rotina que escreve o texto presente no DPTR

	MOV R4, #00h ;Criamos o R4 em 0 para controlar o numero de caracteres inseridos na senha
	MOV R5, #00h ;Criamos o R5 em 0 para controlar o número de caracteres correctos inseridos
	MOV R0, #10h ;Criamos o R0 em 10 para acessar a senha armazenada sem alterar o valor original
	MOV R1, #70h ;Desviamos o valor do R1 para 70 para não influenciar em outra parte do código

RecebeSenha: ;Vamos receber a confirmação da senha

	Call ScanTeclado ;Chama a rotina que recebe a entrada do usuário e armazena no valor do R1 na memória e no R7 que agora é usado para comparacao
	SetB P1.3 
	Clr A ; Limpamos o valor de A 
	Mov A, #'X' ;enviamos o valor de X como caracter
	Call CriptoGrafa	;Chamamos a rotina que envia o valor do A para o display
		
	
	Clr A ;Limpamos o valor de A
	Mov A,@R0 ;Armazenamos o valor na memória do R0 no A para comparar futuramente
	Call Compara ;Chamamos a rotina que faz a comparação

	Inc R0 ;Incrementamos o valor de R0
	Inc R4 ;Incremetamos o valor do R4

	Cjne R4,#04h,RecebeSenha ;Repetimos a rotina caso o usuário ainda não tenha inserido 4 caracteres
	
	Cjne R5,#04h,PreparaConfirmaSenha ;Repetimos a rotina desde a preparação das variáveis caso o usuário tenha errado algum dos caracteres

SenhaCorreta:

	CALL clearDisplay
	MOV DPTR, #TxtSenhaAprovada
	MOV R1, #70H
	CALL Escreve
	Call delay

	Jmp PreparaTentativas

PreparaTentativas:
	Call clearDisplay
	Setb p1.3
	MOV DPTR, #TxtTentativa

	CLR A
	Mov A, R2
	Jz TentativasExcedidas

	Call Escreve

Proximo3: 	

	MOV R4, #00h
	MOV R5, #00h
	MOV R0, #10h
	
RecebeSenha2: 
	
	Call ScanTeclado	
	SetB P1.3		
	Clr A
	Mov A,#'X'
	Call CriptoGrafa	
	
	Clr A
	Mov A,@R0	
	Call Compara	
	Inc R0
	Inc R4

	Cjne R4,#04h,RecebeSenha2
	
	DEC R2
	Cjne R5,#04h,PreparaTentativas	
	

AcessoAprovado:
	CALL clearDisplay
	MOV DPTR, #TxtAcessoAprovado
	Call Escreve
	Call GiraMotor

TentativasExcedidas:
	Call clearDisplay
	
	MOV DPTR, #TxtBloqueado
	
	Call Escreve
	Call Delay
	CALL clearDisplay
	
	MOV DPTR, #TxtTentativa
	
	CALL Escreve
	CALL Delay
	cALL PosicaoCursor
	
	MOV DPTR, #TxtChave
	
	CALL CriaChaveMestre

	CALL Escreve
	Call Delay
	Call clearDisplay

	MOV DPTR, #TxtTentativa
	
	CALL Escreve

Proximo5:
	MOV R4, #00h
	MOV R5, #00h
	MOV R0, #30h
	
RecebeSenha3: 
	
	Call ScanTeclado	
	SetB P1.3		
	Clr A
	Mov A,#'X'
	Call CriptoGrafa	
	
	Clr A
	Mov A,@R0	
	Call Compara	
	Inc R0
	Inc R4

	Cjne R4,#04h,RecebeSenha3
	
	DEC R2
	Cjne R5,#04h,TentativasExcedidas	


Acertou:
	JMP AcessoAprovado

Bloqueado:
	JMP TentativasExcedidas

CriaChaveMestre:
	MOV 30h, #'1'
	MOV 31h, #'2'
	MOV 32h, #'3'
	MOV 33h, #'4'

Escreve:
	Clr A
	Movc A,@A+DPTR	
	Jz Saida		
	Call CriptoGrafa	
	Inc DPTR		
	Jmp Escreve

Compara:	
	Cjne A,07H,Saida	
	Inc R5
Saida:
	Ret
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
	Clr  P1.3	
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

	SetB P1.3
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

CriptoGrafa:	
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

Delay:		

	Mov R3, #50
	Djnz R3, $
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
    MOV R7, #'3'
	MOV @R1, #'3'
	;INC R1
	RET				

Bt2:	

	SETB F0		
    MOV R7, #'2'
	MOV @R1, #'2'
	;INC R1
	RET				

Bt1:	

	SETB F0		
    MOV R7, #'1'
	MOV @R1, #'1'
	;INC R1	
	RET				

Linha2:	

	JNB P0.4, Bt6	
	JNB P0.5, Bt5	
	JNB P0.6, Bt4	
	RET					

Bt6:	

	SETB F0		
    MOV R7, #'6'
	MOV @R1, #'6'
	;INC R1	
	RET				

Bt5:	

	SETB F0		
    MOV R7, #'5'
	MOV @R1, #'5'
	;INC R1	
	RET				

Bt4:	

	SETB F0		
    MOV R7, #'4'
	MOV @R1, #'4'
	;INC R1
	RET				

Linha3:	

	JNB P0.4, Bt9	
	JNB P0.5, Bt8	
	JNB P0.6, Bt7	
	RET					

Bt9:	

	SETB F0		
    MOV R7, #'9'
	MOV @R1, #'9'
	;INC R1	
	RET				

Bt8:	

	SETB F0		
    MOV R7, #'8'
	MOV @R1, #'8'
	;INC R1	
	RET				

Bt7:	

	SETB F0		
    MOV R7, #'7'
	MOV @R1, #'7'
	;INC R1	
	RET				

Linha4:	

	JNB P0.5, Bt0	
	RET					

Bt0:	

	SETB F0	
    MOV R7, #'0'
	MOV @R1, #'0'
	;INC R1	
	RET				
		
GiraMotor:          
    CLR P3.1    
    Call Delay  
    Call Delay  
    SETB P3.1   
    Call Delay  
    Call Delay  

	CLR P3.1    
    Call Delay  
    Call Delay  
    SETB P3.1   
    Call Delay  
    Call Delay  

	CLR P3.1    
    Call Delay  
    Call Delay  
    SETB P3.1   
    Call Delay  
    Call Delay  

	CLR P3.1    
    Call Delay  
    Call Delay  
    SETB P3.1   
    Call Delay  
    Call Delay  
	JMP $

TxtPedeSenha:		DB 'C', 'R', 'I', 'E', 32, 'S', 'E', 'N', 'H', 'A',':',0
TxtConfirmaSenha:   DB 'C', 'O', 'N', 'F', 'I', 'R', 'M', 'E', ':', 0
TxtTentativa:       DB 'I', 'N', 'S', 'I', 'R', 'A', ':', 0
TxtBloqueado: 		DB 'B', 'L', 'O', 'Q', 'U', 'E', 'A', 'D', 'O', 0
TxtChave:  			DB 'C', 'H', 'A', 'V', 'E', 32, 'M', 'E', 'S', 'T', 'R', 'A', 0
TxtSenhaAprovada:   DB 'S', 'E', 'N', 'H', 'A', 32, 'C', 'R', 'I', 'A', 'D', 'A', 0
TxtAcessoAprovado:  DB 'A', 'C', 'E', 'S', 'S', 'O', 32, 'A', 'P', 'R', 'O', 'V', 'A', 'D', 'O', 0