#include 'protheus.ch'
#include 'parmtype.ch'

user function KMFATA02(cOpc)
	
	Local cNom := ''
	local cCodCli := IIf(cOpc == '1',M->C5_CLIENTE + M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	Local cTipo := IIf(cOpc == '1',M->C5_TIPO,SC5->C5_TIPO)
	
	If cTipo $ ('D', 'B') 
		cNom := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+cCodCli,1)
	ELSE
		cNom := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+ cCodCli,1)
	ENDIF
	
	cNom := SubStr(cNom, 1 , 30)
	
	

		
return cNom