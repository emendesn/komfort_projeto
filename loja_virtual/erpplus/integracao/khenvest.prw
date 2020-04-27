#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'
#Include 'TbiConn.ch'

#DEFINE CRLF Chr(13) + Chr(10) 



/*/{Protheus.doc} KHENVEST
//TODO Envia saldo em estoque para E-commerceda Rakuten.
@author ERPPLUS
@since 29/04/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User function KHENVEST()

	Local oEstoque := Nil 
	Local cQuery   := ""
	Local nLoja	 	:= 0
	Local cCodProd  := ""
	Local nQtdEst	:= 0
	Local nQtdMin	:= 0
	Local nPos		:= 0
	local nStatus	:= 6 //Aguardando pagamento - Anexo 3/ Pag. 42 / IKCWebservice 2.2 - 14. Pedidos.pdf
	Local nTipoAlt  := 3
	Local cA1		:= ""
	Local cA2		:= ""
	Local cPai 		:= ""
	Local aSaldoSite := {} //Array para controle de saldo de produtos dos pedidos pendentes de pagamentos (boletos)
	Local oPedido    	 := WSPedidoKH():New()

return

	DbSelectArea("Z07")
	
	cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","078ecd14-64d8-40a8-9045-0705f267a262"))
	cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","860ff9f1-657c-4f93-bdea-2437af2d813c"))
	
	//Tratamento para consultar o saldo dos produtos de cada pedido pendente de pagamento e abater saldo
	if oPedido:ListarNovos(nLoja,nStatus,"",cA1,cA2)
		if oPedido:oWsListarNovosResult:nCodigo == 1
			aPedidos := oPedido:oWsListarNovosResult:oWsLista:oWsClsPedido
			For nAux := 1 to len(aPedidos)
				aItens:= aPedidos[nAux]:oWsItens:oWsItem //Itens dos Pedidos
				For nX := 1 to len(aItens)

					nPos := aScan(aSaldoSite,{ |x| Alltrim(x[1]) == AllTrim(aItens[nX]:CITEMPARTNUMBER) })

					if nPos > 0
						aSaldoSite[nPos][2] += aItens[nX]:NITEMQTDE
					Else
						//aAdd(aSaldoSite,{CODIGOKIT,QUANTIDADE})
						aAdd(aSaldoSite,{aItens[nX]:CITEMPARTNUMBER,aItens[nX]:NITEMQTDE})
					Endif

				Next nX
			Next nAux 
		Else
			U_KHLOGWS("Z07",dDataBase,Time(),oPedido:oWsListarNovosResult:cDescricao + " KHENVEST","SITE")	
		Endif
	Else
		U_KHLOGWS("Z07",dDataBase,Time(),"Erro ao consumir WebService, favor verificar dados informados na requisição - KHENVEST","SITE")
	Endif
	
	cQuery := "SELECT  DISTINCT" + CRLF
	cQuery += "	Z07_PRODUT, Z07_QUANT,Z07_ESTSEG,Z07.R_E_C_N_O_ Z07RECNO "  + CRLF 
	cQuery += "FROM "+RetSqlName("Z07")+" Z07 " + CRLF 
	cQuery += "WHERE Z07_FILIAL = '"+xFilial("Z07")+"' " + CRLF 
	cQuery += "AND Z07_INTEG = 'S' AND Z07.D_E_L_E_T_ = ' ' "
	//cQuery += " AND Z07_PRODUT = 'LINPAR154202420000000' "
	
	MemoWrite("T07.SQL",cQuery)
	If SELECT("TZ07") > 0
		TZ07->(DbCloseArea())
	Endif
	TcQuery cQuery New Alias "TZ07"
	nLoja := 0
	oEstoque := WSEstoqueKh():New()	//Instancio o Serviço
	While !( TZ07->( Eof() ) )	
		cCodProd	:= AllTrim(TZ07->Z07_PRODUT) 
		nQtdEst		:= TZ07->Z07_QUANT
		nQtdMin		:= TZ07->Z07_ESTSEG
		cPAi		 := Substr(cCodProd,1,14)
		//Verifico se foi realizado pedido para algum produto, se ainda não foi pago 
		//e diminuo a quantidade do saldo antes de enviar ao site
		if Len(aSaldoSite) > 0
			nPos := aScan(aSaldoSite,{ |x| Alltrim(x[1]) == cCodProd })
			if nPos > 0
				nQtdEst := ( nQtdEst - aSaldoSite[nPos][2] )
			Endif
		Endif
		If oEstoque:Salvar(nLoja,cPAi,cCodProd,nQtdEst,nQtdMin,nTipoAlt,cA1,cA2) 
			If oEstoque:oWSSalvarResult:nCodigo == 1		
			   Z07->(DbGoTo(TZ07->Z07RECNO))
			   RecLock("Z07",.F.)	
			   Z07->Z07_DTINTE	:= dDataBase
			   Z07->Z07_HRINTE	:= Time()
			   Z07->Z07_INTEG  := "N"		
			   Z07->(MsUnlock())
			Else
			   U_KHLOGWS("Z07",dDataBase,Time(),oEstoque:oWSSalvarResult:cDescricao + " KHENVEST","SITE")//GRAVA NA TABELA DE LOG
			Endif
	    Else
			U_KHLOGWS("Z07",dDataBase,Time(),"Erro ao consumir o web Service, favor verificar os dados de acesso - KHENVEST","SITE")
		Endif
		TZ07->(DbSkip())	
	EndDo

	aSaldoSite := {}
	TZ07->(DbCloseArea())

return

User Function KHESTJOB(aEmp)

	Local aEmp := {"01","0142"}


	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_KHENVEST()

Return 
