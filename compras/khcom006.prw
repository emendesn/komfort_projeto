#include 'protheus.ch'
#include 'parmtype.ch'

User function KHCOM006(cNum)

Local aPedCo := {}
Local cAlias := GetNextAlias()
Local cQuery := ""
Local cQuery2 := ''
Local aDados  := ''
Local cAlias2 := GetNextAlias()
Local dData  := Date()


		cQuery := CRLF + " SELECT C6_MSFIL,C5_EMISSAO,C5_NUM,C6_PRODUTO,B1_DESC,C6_ITEM,C6_QTDVEN,C6_LOCAL,B1_PROC "
		cQuery += CRLF + " FROM SC6010 SC6 "
		cQuery += CRLF + " INNER JOIN SC5010 SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL"
		cQuery += CRLF + " AND SC5.C5_NUM = SC6.C6_NUM "
		cQuery += CRLF + " LEFT JOIN SC9010 SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''"
		cQuery += CRLF + " INNER JOIN SB1010 SB1 ON SC6.C6_PRODUTO = SB1.B1_COD "
		cQuery += CRLF + " WHERE SC6.D_E_L_E_T_ = ' ' "
		cQuery += CRLF + " AND SC5.D_E_L_E_T_ = ' '	"
		cQuery += CRLF + " AND C6_RESERVA = ' ' "
		cQuery += CRLF + " AND C5_NUM = '"+cNum+"'"
		cQuery += CRLF + " AND ISNULL(C9_BLEST,'XX') <> ''"
		cQuery += CRLF + " AND (SELECT (B2_QATU-B2_RESERVA) AS SALDO  "
		cQuery += CRLF + " FROM " + retSqlname('SB2') + "(NOLOCK) SB2"
		cQuery += CRLF + " WHERE B2_COD = C6_PRODUTO"
		cQuery += CRLF + " AND B2_FILIAL = '0101'"
		cQuery += CRLF + " AND B1_XENCOME = '2'"
		cQuery += CRLF + " AND B2_LOCAL = '01'"
		cQuery += CRLF + " AND D_E_L_E_T_ = ' ') = 0"
		
		PlsQuery(cQuery,cAlias)
			aPedCo := {}
		    While (cAlias)->(!EOF())
			
					Aadd(aPedCo,{ (cAlias)->C6_MSFIL,;
								  (cAlias)->C5_EMISSAO,;
								  (cAlias)->C5_NUM,;
								  (cAlias)->C6_PRODUTO,;
								  (cAlias)->B1_DESC,;
								  (cAlias)->C6_ITEM,;
								  (cAlias)->C6_QTDVEN,;
								  (cAlias)->C6_LOCAL,;
								  (cAlias)->B1_PROC;
					  })
					  (cAlias)->(DbSkip())
		    End
				
		   (cAlias)->(dbCloseArea())
				
		If Len(aPedCo) == 0
			Return 
		EndIf
				
		DbSelectArea('Z16')
			For nx := 1 to Len(aPedco)
			Z16->(DbSetOrder(2))//Z16_XFILIA+Z16_NUMPV+Z16_ITEM                                                                                                                                  
				if Z16->(DbSeek(aPedco[nx][01]+aPedco[nx][03]+aPedco[nx][06]))
					Reclock("Z16",.F.)
				Else
					Reclock("z16",.T.)
				EndIf
				Z16_XFILIA := aPedCo[nx][01]
				Z16_EMISSA := aPedCo[nx][02]
				Z16_NUMPV  := aPedCo[nx][03]
				Z16_PRODUT := aPedCo[nx][04]
				Z16_DESC   := aPedCo[nx][05]
				Z16_ITEM   := aPedCo[nx][06]
				Z16_QTDVEM := aPedCo[nx][07]
				Z16_LOCAL  := aPedCo[nx][08]
				Z16_FORNEC := aPedCo[nx][09]
				Z16_STATUS := "2"
				Z16_DATA   := dData 
				MsUnLock()
			Next nx
		Z16->(dbCloseArea())

// Tratamento para desassociar o PV cancelado do pedido de compra limpando o campo C7_01NUMPV
cQuery2 := " SELECT C7_FILIAL,C7_PRODUTO,C7_NUM,C7_ITEM,C7_01NUMPV,SC7.R_E_C_N_O_ " + CRLF
cQuery2 += " FROM "+ RetSqlName("SC7") +"(NOLOCK) SC7 " + CRLF 
cQuery2 += " WHERE C7_01NUMPV = '"+ cNum +"' AND C7_RESIDUO <> 'S' AND D_E_L_E_T_ = '' " + CRLF

PlsQuery(cQuery2, cAlias2)		

While (cAlias2)->(!EOF())
	AADD(aDados, {(cAlias2)->C7_FILIAL,;
	              (cAlias2)->C7_PRODUTO,;
	              (cAlias2)->C7_NUM,;
	              (cAlias2)->C7_ITEM,;
	              (cAlias2)->C7_01NUMPV,;
	              (cAlias2)->R_E_C_N_O_,;
	               })
	(cAlias2)->(DbSkip())
EndDo

If (Len(aDados) > 0)
	DbSelectArea('SC7')
		
	For ny := 1 To Len(aDados)
		SC7->(dbgoto(aDados[nx][6])) 
		IF SC7->(!EOF())
			RecLock("SC7",.F.)
				SC7->C7_01NUMPV := ''
				SC7->C7_01PCEST := aDados[nx][5] 
			SC7->(msUnLock())
		EndIF
	Next ny
	
	SC7->(dbCloseArea())		
EndIf		

return