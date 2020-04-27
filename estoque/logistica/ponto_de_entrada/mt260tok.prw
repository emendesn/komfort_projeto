/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT260TOK  º Autor ³ Vanito Rocha      º Data ³  29/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. NA VALIDAÇÃO DO ENDEREÇAMENTO       			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE - Ticket  8767                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
				MsgAlert("O Endereço informado está com a capacidade indisponivel - Selecione outro endereco - "+xLocaliz,"Atenção!")
				_lRet:=.F.
			Endif
			If nQuant260 > 1 .AND. xPosEnd > 2
				MsgAlert("A quantidade informada não pode ser transferida - Endereço com capacidade inferior "+xLocaliz,"Atenção!")
				_lRet:=.F.
			Endif
		Endif
	Endif
Endif
Return _lRet
