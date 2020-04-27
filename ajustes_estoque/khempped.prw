#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'

user function KHEMPPED()

Local nx := 0
Local nY := 0
Local  cQuery := ""
Local  cQueB2 := ""
Local cAliEm := GetNextAlias()
Local cAliB2 := GetNextAlias()
Local aAjusta  := {}
Local aESb2 := {}



cQuB2 := CRLF + "  SELECT B2_COD  FROM " + RetSqlName("SB2") +  " (NOLOCK) "
cQuB2 += CRLF + "  WHERE B2_COD IN(  "
cQuB2 += CRLF + "   SELECT C6_PRODUTO "
cQuB2 += CRLF + "   FROM SC6010 (NOLOCK) SC6 "
cQuB2 += CRLF + "   INNER JOIN SM0010 (NOLOCK) SM0 ON SC6.C6_MSFIL = SM0.FILFULL "
cQuB2 += CRLF + "   INNER JOIN SC5010 (NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM  "
cQuB2 += CRLF + "   LEFT JOIN  SC9010 (NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = '' "
cQuB2 += CRLF + "   INNER JOIN SB1010 (NOLOCK) B1 ON B1_COD = C6_PRODUTO "
cQuB2 += CRLF + "   INNER JOIN SA1010 (NOLOCK) SA1 ON SA1.A1_COD = C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI "
cQuB2 += CRLF + "  WHERE SC6.D_E_L_E_T_ = ' ' "
cQuB2 += CRLF + "  AND C5_XPRIORI <> '1' "
cQuB2 += CRLF + "  AND C5_NOTA = '' "
cQuB2 += CRLF + "  AND SC5.D_E_L_E_T_ = ' ' "
cQuB2 += CRLF + "  AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB' "
cQuB2 += CRLF + "  AND C6_BLQ <> 'R' "
cQuB2 += CRLF + "  AND C6_NOTA = '' "
cQuB2 += CRLF + "  AND C6_LOCAL = '01' "
cQuB2 += CRLF + "  AND C6_XVENDA <> '1' "
cQuB2 += CRLF + "  ) "
cQuB2 += CRLF + "  AND B2_QATU  > B2_RESERVA "
cQuB2 += CRLF + "  AND B2_LOCAL = '01' "
cQuB2 += CRLF + "  AND B2_FILIAL = '0101' "
cQuB2 += CRLF + "  AND B2_RESERVA > 0 "

PlsQuery(cQuB2,cAliB2)
while (cAliB2)-> (!eof())
Aadd(aESb2,{(cAliB2)->B2_COD})
(cAliB2)->(DbSkip())
End
(cAliB2)->(dbCloseArea())

If len(aESb2) == 0
return

Else 
	for ny := 1 to  len(aESb2)
	cQuery := CRLF + " SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_LOCAL,C6_QTDVEN "
	cQuery += CRLF + "  FROM SC6010 (NOLOCK) SC6 "
	cQuery += CRLF + "  INNER JOIN SM0010 (NOLOCK) SM0 ON SC6.C6_MSFIL = SM0.FILFULL "
	cQuery += CRLF + "  INNER JOIN SC5010 (NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM  "
	cQuery += CRLF + "  LEFT JOIN  SC9010 (NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = '' "
	cQuery += CRLF + "  INNER JOIN SB1010 (NOLOCK) B1 ON B1_COD = C6_PRODUTO "
	cQuery += CRLF + "  INNER JOIN SA1010 (NOLOCK) SA1 ON SA1.A1_COD = C5_CLIENT AND SA1.A1_LOJA = SC5.C5_LOJACLI "
	cQuery += CRLF + " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + " AND C5_XPRIORI <> '1' "
	cQuery += CRLF + " AND C5_NOTA = '' "
	cQuery += CRLF + " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + " AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB' "
	cQuery += CRLF + " AND C6_BLQ <> 'R' "
	cQuery += CRLF + " AND C6_NOTA = '' "
	cQuery += CRLF + " AND C6_LOCAL = '01' "
	cQuery += CRLF + " AND C6_XVENDA <> '1' "
	cQuery += CRLF + " AND C6_PRODUTO = '"+aESb2[ny][1]+"' "
	cQuery += CRLF + " ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM "
	
	PLSQuery(cQuery, cAliEm)
		
		aAjusta := {}
		
		while (cAliEm)->(!eof())	
		Aadd(aAjusta,{ (cAliEm)->C6_NUM,;//PEDIDO
					(cAliEm)->C6_ITEM,; //ITEM
					(cAliEm)->C6_PRODUTO,; //PRODUTO
					(cAliEm)->C6_LOCAL,; //LOCAL
					(cAliEm)->C6_QTDVEN}) //QUANTIDADE DE VENDA 
			(cAliEm)->(DbSkip())
		end 
			(cAliEm)->(dbCloseArea())
	
		If Len(aAjusta) == 0
		
		Else
				for nx := 1 to len(aAjusta)
				U_fSBF(aAjusta[nx][1],aAjusta[nx][2],aAjusta[nx][3],aAjusta[nx][4],aAjusta[nx][5])
				Next nx
		EndIf
	next ny
EndIf

return


User Function KHJOBEMP(aEmp)
	

	Local aEmp := {"01","0101"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_KHEMPPED()


Return 


