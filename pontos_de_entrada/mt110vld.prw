#Include "Protheus.Ch"

#DEFINE CRLF	   CHR(10)+CHR(13)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110VLD  �Autor  �Totvs               � Data �  12/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada que valida o registro na Solic. de Compra  ���
���          �Ir� limpar campos da SC6 no momento de excluir uma SC       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT110VLD()

Local nOpc		:= Paramixb[1]
Local lRet		:= .T.   
Local cQuery 	:= ""

If nOpc == 6 

	cQuery := " UPDATE 	"+RetSqlName("SC6")	+ CRLF
	cQuery += "	SET		C6_XNUMSC	= ' ',"	+ CRLF
	cQuery += "			C6_XITEMSC	= ' ' "	+ CRLF
	cQuery += "	WHERE	C6_FILIAL  = '" + xFilial("SC6")+"' " 		+ CRLF	
	cQuery += " AND C6_XNUMSC = '" + SC1->C1_NUM +"' " + CRLF
	cQuery += " AND C6_XITEMSC = '" + RIGHT(SC1->C1_ITEM,2)+"' " + CRLF
	cQuery += " AND D_E_L_E_T_   = ' '  "
	
	If TcSqlExec(cQuery) < 0
		lRet := .F.
		AutoGrLog(TcSqlError())
		MostraErro()
	EndIf
	
Endif 


Return lRet