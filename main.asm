ORG 0080h ;Definição do inicio do programa

Apresenta:
	Call ConfiguraDisplay; Chamamos a rotina que configura o display
	
	MOV DPTR, #TxtApresenta1; Texto inicial da apresentacao
	
	Call escreve ;Chamamos a rotina que escreve o texto do DPTR
	Call PosicaoCursor ;Movemos o cursor para a linha de baixo do LCD

	MOV DPTR, #TxtApresenta2; Movemos o texto final da apresentacao para o DPTR
	
	Call escreve; Chamamos a rotina que escreve o texto do DPTR, agora na linha de baixo
	Call delay; Um pequeno delay
	Call clearDisplay; Limpamos o display

	MOV DPTR, #TxtTiago; Movemos o nome do primeiro integrante
	
	Call escreve; Chamamos a rotina que escreve o texto que está no DPTR
	Call PosicaoCursor; Posicionamos o cursor na linha de baixo do LCD

	MOV DPTR, #TxtHenrique; Movemos o nome do segundo integrante
	
	Call escreve; Rotina que escreve o texto do DPTR, agora na linha de baixo
	Call delay; um pequeno delay
	Call clearDisplay; limpamos o display 


Main:
	MOV R2, #03h ; Criamos o R2 em 3 para ser usado futuramente como contador de tentativas
	MOV R1, #10h ;Criamos o R1 em 10 para armazenarmos a senha nessa posicao da memoria
	MOV R6, #00h ;Criamos o R6 em 0 para usarmo como contador do numero de caracteres inseridos na senha

	MOV DPTR, #TxtPedeSenha	;Movemos para o DPTR o texto de soliciação de senha

	Call Escreve 	;Chamamos a rotina que escreve o texto presente no DPTR

PedeSenha: 

	Call ScanTeclado ;Chama a rotina que recebe a entrada do usuário e armazena no valor do R1 na memória e no 07h que não é usado ainda
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

	Call ScanTeclado ;Chama a rotina que recebe a entrada do usuário e armazena no valor do R1 na memória e no 07h que agora é usado para comparacao
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

SenhaCorreta: ; Rotina para a senha correta, apenas para orientação

	CALL clearDisplay ;Chamamos a função que limpa o LCD
	MOV DPTR, #TxtSenhaAprovada ;Movemos o texto para quando a senha é aprovada
	;MOV R1, #70H
	CALL Escreve ;Chamamos a rotina que escreve o texto que estiver no DPTR
	Call delay ; Aplicamos um delay

	;Jmp PreparaTentativas

PreparaTentativas: ; Chamamos a rotina que prepara o codigo em 
	Call clearDisplay ; Limpamos o display
	; Setb p1.3
	MOV R4, #00h ;Zeramos o valor de R4 para limitar o numero de caracteres por senha
	MOV R5, #00h ;Zeramos o valor de R5 para identificar caso o usuario erre
	MOV R0, #10h ;Movemos o valor de 10 para o R0 para acessar a senha armazena

	Mov A, R2 ; Movemos para o A o valor do R2, usado para limitar o numero de vezes que o usuario pode tentar acertar a senha criada
	
	Jz TentativasExcedidas ; Pulamos para a rotina de tentativas excedidas caso o valor A/R2 chegue em 0

	MOV DPTR, #TxtTentativa ; Movemos o texto de tentativas para o DPTR
	Call Escreve ;Chamamos a rotina que escreve o texto do DPTR

RecebeSenha2: ; Rotina para receber a senha do usuário
	
	Call ScanTeclado ; Rotina para armazenar o valor inserido no 07h	
	SetB P1.3
	Clr A ;Limpamos o valor de A
	Mov A,#'X' ;Movemos o valor do caracter X para o A
	Call CriptoGrafa ;Enviamos o caracter X para a tela 
	
	Clr A ; Limpamos o valor de A
	Mov A,@R0 ;Movemos para o A o valor armazenado na posicao do valor R0
	Call Compara ;Chamamos a rotina que compara os valores do A com o 07h
	
	Inc R0 ;Incrementamos a posicao na memoria
	Inc R4 ;Incrementamos o numero de caracteres inseridos

	Cjne R4,#04h,RecebeSenha2 ;Repetimos o código dessa rotina enquanto o R4 não tiver valor 4 (Enquanto o usuario não inserir 4 caracteres)
	
	DEC R2 ;Decrementamos o valor do R2 para contar como uma tentativa

	Cjne R5,#04h,PreparaTentativas	;Comparamos o valor do R5 (Incrementado na função compara) com 4, caso ele seja 4 então sabemos que o usuario acertou cada caracter
									;Caso seja diferente de 4 então repetimos o código desde a função PreparaTentativas

AcessoAprovado: ;Rotina para quando o acesso é aprovado (Dentro dessa rotina o código acaba)
	
	CALL clearDisplay;Limpamos o display
	
	MOV DPTR, #TxtAcessoAprovado ;Movemos para o DPTR o texto de Acesso Aprovado
	Call Escreve ;Rotina que escreve o texto preste no DPTR
	Call GiraMotor ;Rotina que gira o motor no simulador (Essa rotina encerra o código)

TentativasExcedidas:; Rotina para quando o usuario erra em todas as suas tentativas de acesso com a senha criada
	
	MOV R4, #00h ;Movemos o valor de 0 para controlar o numero de caracteres da senha
	MOV R5, #00h ;Movemos o valor de 0 para saber quando o usuario acertou ou não 
	MOV R0, #30h ;Movemos o valor de 30 para acessar a chave mestra na memoria

	Call clearDisplay ;Limpamos o display
	
	MOV DPTR, #TxtBloqueado ; Movemos o texto de bloqueado
	
	Call Escreve; Escrevemos o texto no DPTR
	Call Delay ;Um pequeno delay
	CALL clearDisplay; Limpamos o LCD
	
	MOV DPTR, #TxtTentativa ;Movemos o texto de tentativa
	
	CALL Escreve ;Escrevemos o texto
	CALL Delay ;Um pequeno delay
	CALL PosicaoCursor ;Alteramos a posicao do cursor para a linha de baixo do LCD 
	
	MOV DPTR, #TxtChave ;Movemos o texto da Chave Mestra
	
	CALL CriaChaveMestre ;Chamamos a rotina que cria a chame mestra na memória

	CALL Escreve ;Escrevemos o texto do DPTR no LCD (Agora na linha de baixo sem apagar o texto anterior)
	Call Delay ;Pequeno delay
	Call clearDisplay ;Agora limpamos o delay

	MOV DPTR, #TxtTentativa ;Movemos o texto de tentativa
	
	CALL Escreve ;E escrevemos o texto

RecebeSenha3: 
	
	Call ScanTeclado ;Rotina para receber a entrada do usario
	SetB P1.3		
	
	Mov A,#'X' ;Movemos o valor do caracter X para o A
	
	Call CriptoGrafa	;Enviamos o X para a o LCD
	
	Mov A,@R0 ;Movemos para o A o valor na memória do valor do R0
	Call Compara	;Chamamos a rotina que compara a entrada do usuario com o A
	
	Inc R0 ;Incrementamos o R0 para avançar na memória
	Inc R4 ;Incrementamos o R4 para controlar o numero de caracteres inseridos

	Cjne R4,#04h,RecebeSenha3 ;Repetimos o código caso o usuario ainda não tenha inserido 4 caracteres
		
	Cjne R5,#04h,TentativasExcedidas ;Verificamos se o usuario acertou os 4 caracteres da senha, caso contrario voltamos para a rotina de tentativas excedidas 
									; para o usuario tentar novamente

Acertou:; Caso o usuario tenha acertado a chave Mestra então voltamos para a rotina de acesso aprovado
	JMP AcessoAprovado 

CriaChaveMestre: ;Rotina para criar a chave mestre na memória da posicao 30
	MOV 30h, #'1'
	MOV 31h, #'2'
	MOV 32h, #'3'
	MOV 33h, #'4'

Escreve: ;Rotina para escrever o texto do DPTR
	Clr A ;Limpamos o valor do A
	Movc A,@A+DPTR ;Movemos para o A o valor do na memória do valor de A somado com o DPTR
	Jz Retorna ;Caso o valor do A seja zero então retornamos para o código em que a rotina foi chamada	
	Call CriptoGrafa ;Chamamos a rotina que envia o para o LCD o caracter presente no A
	Inc DPTR ;Incrementamos o DPTR para a proxima posicao
	Jmp Escreve ;Voltamos para a própria rotina como um laço

Compara:	
	Cjne A,07H,Retorna	;Comparamos o valor de A com o valor do armazenado em 07 na memória, caso ele seja diferente vamos para a rotina que retorna
	Inc R5; Caso contrario incrementamos o R5 para sabermos que o usuario acertou

Retorna: ;Rotina para podermos usar o 'Ret' com mais flexibilidade
	Ret


;----------------------------------------------------------------------------
;Rotina feitas de acordo com os programas de exmplo na documentação do Edsim51
;----------------------------------------------------------------------------

clearDisplay: ;Rotina que faz a limpeza dos caracteres presentes no LCD, através da alteracao dos Bits de P1
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

	MOV R6, #30
	rotC:
	CALL delay
	DJNZ R6, rotC
	RET


ConfiguraDisplay: ;Funcao para configurarmos o display para ser usado no principio do código
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

PosicaoCursor:	;Rotina para mover o cursor usado para a linha inferior do LCD
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

Pulso:		;Rotina para fazer um pulso com um dos bits do P1 (Necessário para o funcionamento do LCD)
	SetB P1.2		
	Clr  P1.2		
	Ret

CriptoGrafa: ;Rotina para enviar o caracter presente no A para o LCD
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

Delay:	;Rotina para aplicar delay

	Mov R3, #50
	Djnz R3, $
	Ret
			
ScanTeclado: ;Rotina para ler a entrada do usuario
	
	CLR P0.3			
	CALL Linha1 ;Rotina para ler a primeira linha da matriz do teclado
	SetB P0.3			
	JB F0,Feito  		
				
	CLR P0.2			
	CALL Linha2	;Rotina para ler a segunda linha da matriz do teclado
	SetB P0.2			
	JB F0,Feito						

	CLR P0.1			
	CALL Linha3	;Rotina para ler a terceira linha da matriz do teclado
	SetB P0.1			
	JB F0,Feito							

	CLR P0.0			
	CALL Linha4	;Rotina para ler a quarta linha da matriz do teclado	
	SetB P0.0			
	JB F0,Feito														
	JMP ScanTeclado							
			
Feito:

	Clr F0		        	
	Ret
	
Linha1:	
	;Rotina para identificarmos qual coluna foi pressionada
	JNB P0.4, Bt3	;Armazenamos o valor de cada botão 
	JNB P0.5, Bt2	
	JNB P0.6, Bt1	
	RET					

Bt3:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0	
    MOV 07h, #'3'
	MOV @R1, #'3'
	RET				

Bt2:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'2'
	MOV @R1, #'2'
	RET				

Bt1:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'1'
	MOV @R1, #'1'
	RET				

Linha2:	
;Rotina para identificarmos qual coluna foi pressionada
	JNB P0.4, Bt6	
	JNB P0.5, Bt5	
	JNB P0.6, Bt4	
	RET					

Bt6:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'6'
	MOV @R1, #'6'
	RET				

Bt5:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'5'
	MOV @R1, #'5'
	RET				

Bt4:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'4'
	MOV @R1, #'4'
	RET				

Linha3:	
;Rotina para identificarmos qual coluna foi pressionada
	JNB P0.4, Bt9	
	JNB P0.5, Bt8	
	JNB P0.6, Bt7	
	RET					

Bt9:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'9'
	MOV @R1, #'9'
	RET				

Bt8:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'8'
	MOV @R1, #'8'	
	RET				

Bt7:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0		
    MOV 07h, #'7'
	MOV @R1, #'7'	
	RET				

Linha4:	
;Rotina para identificarmos qual coluna foi pressionada
	JNB P0.5, Bt0	
	RET					

Bt0:	
;Armazeno o valor no R1 para guardar na memoria e no 07h para comparacao
	SETB F0	
    MOV 07h, #'0'
	MOV @R1, #'0'	
	RET				
		
GiraMotor: ;Rotina para girar parte do motor  
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


;----------------------------------------------------------------------------------
;Textos armazenados para uso durante o código
;Colocamos cada caracter para podermos usar outros tipos de caracteres e espacos
;Usamos o 0 como controle para saber quando o texto acaba
;----------------------------------------------------------------------------------

TxtTiago: 			DB 'T', 'I', 'A', 'G', 'O', 0
TxtHenrique:   		DB 'H', 'E', 'N', 'R', 'I', 'Q', 'U', 'E', 0
TxtApresenta1:		DB 'P', 'R', 'O', 'G', 'R', 'A', 'M', 'A', 0
TxtApresenta2:		DB 'F', 'E', 'I', 'T', 'O', 32, 'P', 'O', 'R', 0

TxtPedeSenha:		DB 'C', 'R', 'I', 'E', 32, 'S', 'E', 'N', 'H', 'A',':',0
TxtConfirmaSenha:   DB 'C', 'O', 'N', 'F', 'I', 'R', 'M', 'E', ':', 0
TxtTentativa:       DB 'I', 'N', 'S', 'I', 'R', 'A', ':', 0
TxtBloqueado: 		DB 'B', 'L', 'O', 'Q', 'U', 'E', 'A', 'D', 'O', 0
TxtChave:  			DB 'C', 'H', 'A', 'V', 'E', 32, 'M', 'E', 'S', 'T', 'R', 'A', 0
TxtSenhaAprovada:   DB 'S', 'E', 'N', 'H', 'A', 32, 'C', 'R', 'I', 'A', 'D', 'A', 0
TxtAcessoAprovado:  DB 'A', 'C', 'E', 'S', 'S', 'O', 32, 'A', 'P', 'R', 'O', 'V', 'A', 'D', 'O', 0