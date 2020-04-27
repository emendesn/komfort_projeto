#Include "Protheus.Ch"
#INCLUDE "TbiConn.ch"
#Include "TopConn.Ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSIGATMK   บAutor  ณMicrosiga           บ Data ณ  12/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada executado na abertura do modulo e tem como บฑฑ
ฑฑบ          ณobjetivo atualizar os atendimentos que ocorrem erros.       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ#RVC20180925 ณAtualiza็ใo dos pedidos com inconsist๊ncias nos status   บฑฑ
ฑฑบ             ณda opera็ใo quando convertidos para faturamento     .    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function SIGATMK()

Local aArea := GetArea()
Local cQuery:= ""

IF GetMv("KH_ATUASUA",,.T.) //Parametro para "Ligar ou Desligar" a atualiza็ใo da tabeLA SUA.
	
	If LockByName("SIGATMK", .F., .F.)
		
		cQuery := " UPDATE " + RetSqlName("SUA") + " SET UA_OPER = '2' WHERE UA_OPER = '1' AND UA_NUMSC5 =  ' ' AND D_E_L_E_T_ = ' ' ;"
		cQuery += " UPDATE " + RetSqlName("SUA") + " SET UA_OPER = '1' WHERE UA_OPER = '2' AND UA_NUMSC5 <> ' ' AND D_E_L_E_T_ = ' ' "	//#RVC20180925.n
		If (TCSQLExec(cQuery) < 0)
			Return MsgStop("TCSQLError() " + TCSQLError())
		EndIf
		
		// Controle de Semaforo
		UnLockByName("SIGATMK", .F., .F.)
		
	EndIf
	
EndIf

RestArea(aArea)

Return