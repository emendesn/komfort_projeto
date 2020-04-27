#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
--------------------------------------------------------|
-> Realiza a liberação dos itens do pedido de venda.	|
-> By Alexis Duarte									    |
-> 14/08/2018                                           |
-> Uso: Komfort House                                   |
--------------------------------------------------------|
*/


User Function LibEst(_cPedido,_cItem,_cProd,_nQuant,_nSaldo,lMostraMsg)

	Local cPedido 	:= _cPedido
	Local cItem		:= _cItem
	Local cProduto	:= _cProd
	Local nQuant	:= _nQuant
	Local nQtdEst	:= _nSaldo
	Local cFilBkp	:= cFilAnt
	
	Local nQtdLib	:= 0
	
	Local lAvalCre 	:= .T.	// Avaliacao de Credito
	Local lBloqCre 	:= .F. 	// Bloqueio de Credito
	Local lAvalEst	:= .T.	// Avaliacao de Estoque
	Local lBloqEst	:= .T.	// Bloqueio de Estoque
	Local lRet := .F.
	
	Default lMostraMsg := .T.

	Begin Transaction
	
	If nQtdEst >= nQuant
		
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6") + AvKey(cPedido,"C6_NUM") + AvKey(cItem,"C6_ITEM") + AvKey(cProduto,"C6_PRODUTO") ))
			
			cFilAnt := SC6->C6_MSFIL
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(xFilial("SC9") + AvKey(cPedido,"C9_NUM") + AvKey(cItem,"C9_ITEM") ))
				//-- Estorna a Liberação do Pedido por meio da rotina padrão de estorno.
				if empty(SC6->C6_RESERVA)
					if (SC9->C9_BLEST <> '' .or. SC9->C9_BLCRED <> '')
						A460Estorna()
					endif
				endif
			EndIF
	
			cFilAnt := "0101"
			
			RecLock("SC6",.F.)
				SC6->C6_QTDLIB := nQuant
			MsUnlock()
		
			nQtdLib := MaLibDoFat(SC6->(RecNo()),nQuant,@lBloqCre,@lBloqEst,lAvalCre,lAvalEst,.F.,.F.,NIL,NIL,NIL,NIL,NIL,0)
			
			If nQtdLib > 0
				Sleep(1500) //Sleep de 2 segundo
				SC6->(MaLiberOk({cPedido},.F.))
				lRet := .T.
				if lMostraMsg
					MsgInfo("Produto: "+Alltrim(SC6->C6_PRODUTO)+" liberado estoque com sucesso!","Atenção")
				endif
			Else
				if lMostraMsg
					MsgInfo("Produto: "+Alltrim(SC6->C6_PRODUTO)+" não possui Saldo para efetuar a liberação.","Atenção")
				endif
			Endif
			
			cFilAnt := cFilBkp
			
		Endif
		
	Else
		if lMostraMsg
			MsgInfo("Este item não possui quantidade suficiente para ser liberado, selecione outro item.","Atenção")
		endif
	Endif
	
	End Transaction
	
	cFilAnt := cFilBkp

Return lRet