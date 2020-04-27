#Include "Protheus.Ch"

#DEFINE CRLF	   CHR(10)+CHR(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110VLD  ºAutor  ³Totvs               º Data ³  12/15/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada que valida o registro na Solic. de Compra  º±±
±±º          ³Irã limpar campos da SC6 no momento de excluir uma SC       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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