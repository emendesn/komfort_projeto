
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA265TDOK � Autor � Vanito Rocha      � Data �  29/03/19   ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. NA VALIDA��O DO ENDERE�AMENTO       			      ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE - Ticket  8767                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MA265TDOK()

Local lRet:=.T.
Local cLocaliz:=GdFieldGet("DB_LOCALIZ")
Local cLocal:=SDA->DA_LOCAL
Local cQuery:=""
Local _cAlias:=getNextAlias()
Local xQuantBf:=0
Local xPosEnd:=0
Local xQuantZL:=0
/*
If !l265Auto
	If cLocal='01'
		DbSelectArea("SBE")
		DbSetOrder(1)
		If (DbSeek(xFilial("SBE")+cLocal+cLocaliz))
			
			cQuery := " SELECT SUM(BF_QUANT) AS QUANTBF FROM " + RETSQLNAME("SBF")
			cQuery += " WHERE BF_FILIAL = '" + xFilial("SBF") + "'
			cQuery += " AND BF_LOCAL = '" + cLocal + "' "
			cQuery += " AND BF_LOCALIZ = '" + cLocaliz + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
			
			xQuantBf:=(_cAlias)->QUANTBF
			xPosEnd :=Val(Substr(cLocaliz,9,9))
			
			DbSelectArea(_cAlias)
			(_cAlias)->(DbCloseArea())
			
			If xPosEnd > 2 .AND. xQuantBF > 0
				
				MsgAlert("O Endere�o informado com a capacidade indisponivel - Selecione outro endereco - "+cLocaliz,"Aten��o!")
				
				lRet:=.F.
				
			Endif
			
			cQuery := " SELECT SUM(ZL2_QUANT) AS QUANTZL2 FROM " + RETSQLNAME("ZL2")
			cQuery += " WHERE ZL2_FILIAL = '" + xFilial("ZL2") + "'
			cQuery += " AND ZL2_LOCAL = '" + cLocal + "' "
			cQuery += " AND ZL2_LOCALI = '" + cLocaliz + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
			
			xQuantZL:=(_cAlias)->QUANTZL2
			xPosEnd :=Val(Substr(cLocaliz,9,9))
			
			DbSelectArea(_cAlias)
			(_cAlias)->(DbCloseArea())
			
			
			If xPosEnd > 2 .AND. (xQuantBF+xQuantZL) > 0
				
				MsgAlert("O Endere�o informado com a capacidade indisponivel - Selecione outro endereco - "+cLocaliz,"Aten��o!")
				
				lRet:=.F.
				
			Endif
		Endif
	Endif
Endif
*/
Return lRet
