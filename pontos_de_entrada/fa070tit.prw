#Include "protheus.ch"
#Include "topconn.ch"
#Include "totvs.ch"

/*
-> Ponto de Entrada utilizado na Confirmacao Baixa (Contas a Receber)
-> By Alexis Duarte
-> Komfort House
*/
User Function FA070TIT()
	
	Local lRet := .T. //Varial de Controle, .T. Realiza a baixa <---> .F. Não Realiza a baixa

	//msgRun("Realizando validações.","Aguarde ....",{|| PerLib(lRet) })
	//Liberação automatica do Financeiro desativada por determinação do Mohammed. 19/03/2020

Return lRet

/*
-> Validacao e atualizacao do percentual de desconto para liberação do (Pedido de venda) 
-> By Alexis Duarte
-> Komfort House
*/
Static Function PerLib(lRet)

	Local aArea := getArea()
	Local cQuery := ""
    Local cAlias := getNextAlias()
	Local nValorAtu := SE1->E1_VALOR //Valor atual a ser baixado
	
	Local ctitulo := SE1->E1_NUM
	Local cPedido := SE1->E1_PEDIDO
	Local _cFilial := SE1->E1_MSFIL
	Local _cCliente := SE1->E1_CLIENTE
	
	Default lRet := .T.

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
	
	//#RVC20181031.bn	
	 //Tratativa p/ a rotina de baixa por CNAB aonde o PE é executado após a baixa do título em questão.
	if IsInCallStack('U_F200TIT')
		nValorAtu := 0
	endIf
	//#RVC20181031.en
		
	if (cAlias)->(!eof())
		if ((cAlias)->RECEBIDO + nValorAtu) >= (cAlias)->VALOR_MINIMO
				
			dbselectarea("SC5")
			SC5->(dbsetorder(1))
				
			if SC5->(dbseek(xFilial()+(cAlias)->UA_NUMSC5))
				recLock("SC5",.F.)
					SC5->C5_PEDPEND := "4"
				SC5->(msUnlock())
			endif
				
			dbselectarea("SC6")
			SC6->(dbsetorder(1))
				
			if SC6->(dbseek(xFilial()+ (cAlias)->UA_NUMSC5))
				while SC6->C6_MSFIL == _cFilial .and. SC6->C6_NUM == (cAlias)->UA_NUMSC5
					recLock("SC6",.F.)
						SC6->C6_PEDPEND := "4"
					SC6->(msUnlock())
				SC6->(dbskip())
				end
			endif
		Endif

	endif
	
	(cAlias)->(dbCloseArea())

	restArea(aArea)

Return lRet