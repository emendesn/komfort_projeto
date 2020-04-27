#Include "protheus.ch"
#Include "topconn.ch"
#Include "totvs.ch"

/*
Ponto de entrada no cancelamento da bx receb, nï¿½o permitindo 
cancelar a baixa se a data base estiver diferente da data da baixa
*/
                                                                          
User Function FA070CA4()

	Local lRet := .T.
	
	if !ISINCALLSTACK('A410EXC')//AFD20180615.N
		msgRun("Realizando validações.","Aguarde ....",{|| PerLibEst(@lRet) })
  endif //AFD20180615.N
    
Return(lRet)


/*
-> Validacao e atualizacao do percentual de desconto para liberaï¿½ï¿½o do (Pedido de venda) (Estorno 'Cancelamento de baixa')
-> By Alexis Duarte
-> Komfort House
*/
Static Function PerLibEst(lRet)

	Local aArea := getArea()
	Local cQuery := ""
	Local cAlias := getNextAlias()

	Local cCarga := ""
	Local cNFiscal := ""

	Local nValorBx := SE1->E1_VALOR
	Local ctitulo := SE1->E1_NUM
	Local cPedido := SE1->E1_PEDIDO
	Local _cFilial := SE1->E1_MSFIL
	Local _cCliente := SE1->E1_CLIENTE	

	default lRet := .T.
	
	cQuery := "SELECT *" 								+ chr(13)+chr(10)
	cQuery += "FROM "+ RetSqlName("SC9")				+ chr(13)+chr(10)
	cQuery += "WHERE C9_FILIAL = '"+ _cFilial +"'" 		+ chr(13)+chr(10)
	cQuery += "AND C9_PEDIDO = '"+ cPedido +"'"			+ chr(13)+chr(10)
	cQuery += "AND D_E_L_E_T_ = ' '"					+ chr(13)+chr(10)
	
	plsQuery(cQuery,cAlias)

	While (cAlias)->(!eof())
		
		cCarga := iif(!empty(alltrim((cAlias)->C9_CARGA)),(cAlias)->C9_CARGA,"")
		cNFiscal := iif(!empty(alltrim((cAlias)->C9_NFISCAL)),(cAlias)->C9_NFISCAL,"")

	(cAlias)->(dbskip())
	End

	If !empty(alltrim(cCarga))
		msgInfo("O titulo referente ao Pedido "+ alltrim((cAlias)->C9_PEDIDO) +", Já se encontra em carga." ,"Atenção")
		lRet := .F.
	EndIf

	If !empty(alltrim(cNFiscal))
		msgInfo("O titulo referente ao Pedido "+ alltrim((cAlias)->C9_PEDIDO) +", Já foi faturado." ,"Atenção")
		lRet := .F.
	EndIf
    
	(cAlias)->(dbCloseArea())

	If lRet
		cAlias := getNextAlias()

	  cQuery := "SELECT UA_NUMSC5, (UA_VLRLIQ/100)*UA_XPERLIB AS VALOR_MINIMO, ("	+ chr(13)+chr(10)
		cQuery += "																SELECT " + chr(13)+chr(10)
		cQuery += "																CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR" + chr(13)+chr(10)
		cQuery += "																FROM "+retsqlname("SE1")+ " (NOLOCK)" + chr(13)+chr(10)
		cQuery += "																WHERE E1_MSFIL = '"+_cFilial+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_PEDIDO = '"+cPedido+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_CLIENTE = '"+_cCliente+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_TIPO NOT IN ('BOL','CHK','RA') " + chr(13)+chr(10)
		cQuery += "																AND D_E_L_E_T_ = ' ') " + chr(13)+chr(10)
		cQuery += "																+ " + chr(13)+chr(10)
		cQuery += "																(SELECT " + chr(13)+chr(10)
		cQuery += "																CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR" + chr(13)+chr(10)
		cQuery += "																FROM "+retsqlname("SE1")+ " (NOLOCK)" + chr(13)+chr(10)
		cQuery += "																WHERE E1_MSFIL = '"+_cFilial+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_PEDIDO = '"+cPedido+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_CLIENTE = '"+_cCliente+"'" + chr(13)+chr(10)
		cQuery += "																AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B'" + chr(13)+chr(10)
		cQuery += "																AND D_E_L_E_T_ = ' ') AS RECEBIDO" + chr(13)+chr(10)
		cQuery += "FROM "+retsqlname("SUA") + chr(13)+chr(10)
		cQuery += "WHERE UA_FILIAL = '"+_cFilial+"'" + chr(13)+chr(10)
		cQuery += "AND UA_NUMSC5 = '"+cPedido+"'" + chr(13)+chr(10)
		cQuery += "AND D_E_L_E_T_ = ' '" + chr(13)+chr(10)

		plsQuery(cQuery, cAlias)
		
		if (cAlias)->(!eof())
			if ((cAlias)->RECEBIDO - nValorBx) < (cAlias)->VALOR_MINIMO
				
				dbselectarea("SC5")
				SC5->(dbsetorder(1))
				
				if SC5->(dbseek(xFilial()+(cAlias)->UA_NUMSC5))
					recLock("SC5",.F.)
						SC5->C5_PEDPEND := "2"
					msUnlock()
				endif
				
				dbselectarea("SC6")
				SC6->(dbsetorder(1))
				
				if SC6->(dbseek(xFilial()+ (cAlias)->UA_NUMSC5))
					while SC6->C6_MSFIL == _cFilial .and. SC6->C6_NUM == (cAlias)->UA_NUMSC5
						recLock("SC6",.F.)
							SC6->C6_PEDPEND := "2"
						msUnlock()
					dbskip()
					end
				endif
			Endif

		endif
	EndIf

	restArea(aArea)

Return lRet

