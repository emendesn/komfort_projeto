/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT260TOK  � Autor � Vanito Rocha      � Data �  29/03/19   ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. NA VALIDA��O DO ENDERE�AMENTO       			      ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - Ticket  8767                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT260TOK

Local _lRet:=.T.
Local xLocaliz:=cLoclzDest
Local xLocal:=cLocOrig
Local xLocdest:=cLocDest
Local cQuery:=""
Local _cAlias:=getNextAlias()
Local xQuantBf:=0
Local xPosEnd:=0
Local xQuant:=nQuant260

If xLocal='01'
	If xLocdest='01'
		xLocal:=xLocdest
		
		DbSelectArea("SBE")
		DbSetOrder(1)
		If (DbSeek(xFilial("SBE")+xLocal+xLocaliz))
			
			cQuery := " SELECT SUM(BF_QUANT) AS QUANTBF FROM " + RETSQLNAME("SBF")
			cQuery += " WHERE BF_FILIAL = '" + xFilial("SBF") + "'
			cQuery += " AND BF_LOCAL = '" + xLocal + "' "
			cQuery += " AND BF_LOCALIZ = '" + xLocaliz + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
			
			xQuantBf:=(_cAlias)->QUANTBF
			xPosEnd :=Val(Substr(xLocaliz,9,9))
			
			DbSelectArea(_cAlias)
			(_cAlias)->(DbCloseArea())
			
			If xPosEnd > 2 .AND. xQuantBF > 0
				MsgAlert("O Endere�o informado est� com a capacidade indisponivel - Selecione outro endereco - "+xLocaliz,"Aten��o!")
				_lRet:=.F.
			Endif
			If nQuant260 > 1 .AND. xPosEnd > 2
				MsgAlert("A quantidade informada n�o pode ser transferida - Endere�o com capacidade inferior "+xLocaliz,"Aten��o!")
				_lRet:=.F.
			Endif
		Endif
	Endif
Endif
Return _lRet
