#Include "PROTHEUS.CH"
#Include "TOTVS.CH"

/*
-> Ponto de Entrada utilizado na Confirmacao Baixa do CNAB (Contas a Receber)
-> By Rafael Cruz
-> Komfort House
*/
User Function F200TIT()
	
	Local lRet := .T. //Varial de Controle, .T. Realiza a baixa <---> .F. Não Realiza a baixa
	
	If !Empty(SE1->E1_PEDIDO)
		msgRun("Realizando validações.","Aguarde ....",{|| StaticCall(FA070TIT,PerLib,@lRet) })
	EndIf
   
   If !lRet
   		msgstop("PV "+ SE1->E1_PEDIDO +" não foi desbloqueado. Entre em contato com o suporte.", "Pendência Financeira")
   EndIF
   
Return 