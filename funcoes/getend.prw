#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
------------------------------------------------|
-> Retorna o endereço disponivel com saldo .	|
-> By Alexis Duarte								|
-> 14/08/2018                                   |
-> Uso: Komfort House                           |
------------------------------------------------|
*/

User Function getEnd(_cProd, _cLocal, _nQuant, cUsados, nSaldo)
    
	Local cQuery := ""
	Local cAlias := getNextAlias()
	Local cEndereco := ""
	  
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))

	If SB1->B1_LOCALIZ == 'S'
	//if Localiza(_cProd)
	
		cQuery := "SELECT TOP 1 R_E_C_N_O_ as RECSBF FROM "+ RetSqlName("SBF")
		cQuery += " WHERE BF_FILIAL = '0101'"
		cQuery += " AND BF_PRODUTO = '" + _cProd + "'"
		cQuery += " AND BF_LOCAL = '" + _cLocal + "'"
		
		if _cLocal == '03' 
			cQuery += " AND BF_LOCALIZ IN ('MOSTRUARIO')"
		else
			cQuery += " AND BF_LOCALIZ NOT IN ('9999','DEVOLUCAO','MOSTRUARIO')"	
		endif
		
		cQuery += " AND (BF_QUANT - BF_EMPENHO) >= " + cValToChar(_nQuant)
		cQuery += " AND D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY BF_LOCAL, BF_LOCALIZ"
	    
		plsQuery(cQuery,cAlias)
	
		if (cAlias)->(!eof())
			
			dbselectarea("SBF")
			SBF->(dbgoto((cAlias)->RECSBF))
			
			cEndereco := SBF->BF_LOCALIZ
			cUsados += ",'"+cEndereco+"'"
			nSaldo := (SBF->BF_QUANT - SBF->BF_EMPENHO)
			
			SBF->(dbCloseArea())
			
		endif
	else
		cQuery := "SELECT TOP 1 R_E_C_N_O_ as RECSB2"
		cQuery += " FROM "+RetSqlName("SB2")
		cQuery += " WHERE B2_COD = '"+_cProd+"'"
		cQuery += " AND B2_FILIAL = '0101'
		cQuery += " AND B2_LOCAL = '"+_cLocal+"'"
		cQuery += " AND D_E_L_E_T_ = ' '"

		plsQuery(cQuery,cAlias)		

		if (cAlias)->(!eof())
			
			dbselectarea("SB2")
			SB2->(dbgoto((cAlias)->RECSB2))
			
			cEndereco := ""
			nSaldo := SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS)

			SB2->(dbCloseArea())

		endif		
	endif

	(cAlias)->(dbCloseArea())
	
return cEndereco