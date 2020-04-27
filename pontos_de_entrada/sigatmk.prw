#Include "Protheus.Ch"
#INCLUDE "TbiConn.ch"
#Include "TopConn.Ch"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SIGATMK   �Autor  �Microsiga           � Data �  12/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado na abertura do modulo e tem como ���
���          �objetivo atualizar os atendimentos que ocorrem erros.       ���
�������������������������������������������������������������������������͹��
���#RVC20180925 �Atualiza��o dos pedidos com inconsist�ncias nos status   ���
���             �da opera��o quando convertidos para faturamento     .    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function SIGATMK()

Local aArea := GetArea()
Local cQuery:= ""

IF GetMv("KH_ATUASUA",,.T.) //Parametro para "Ligar ou Desligar" a atualiza��o da tabeLA SUA.
	
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