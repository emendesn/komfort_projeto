#Include "PROTHEUS.CH"
#Include "TOTVS.CH"

/*
-> Ponto de Entrada utilizado na Confirmacao Baixa do CNAB (Contas a Receber)
-> By Rafael Cruz
-> Komfort House
*/
User Function F200TIT()
	
	Local lRet := .T. //Varial de Controle, .T. Realiza a baixa <---> .F. N�o Realiza a baixa
	
	If !Empty(SE1->E1_PEDIDO)
		msgRun("Realizando valida��es.","Aguarde ....",{|| StaticCall(FA070TIT,PerLib,@lRet) })
	EndIf
   
   If !lRet
   		msgstop("PV "+ SE1->E1_PEDIDO +" n�o foi desbloqueado. Entre em contato com o suporte.", "Pend�ncia Financeira")
   EndIF
   
Return 