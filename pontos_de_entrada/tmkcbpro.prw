// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : TMKCBPRO
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             		| Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio 	| Inclusão de botões na enchoice
// ---------+-------------------+-----------------------------------------------------------
User Function TMKCBPRO()

Local aArea		:= GetArea()
Local aButtons 	:= {}	

//AAdd(aButtons ,{ "Follow Up"		,	{|| U_A273VLD6(M->UA_NUM) 		}, "Follow Up"	,"Follow Up"})	
//AAdd(aButtons ,{ "Altera PV"		,	{|| U_A273ALTP(M->UA_NUMSC5)	}, "Altera PV"	,"Altera PV"})	

RestArea(aArea)

Return(aButtons)            

User Function A273ALTP(cPedido)

Local cAlias  := "SC5"
Local nReg	  := 0
Local nOpc	  := 4
Local nModOld := nModulo

If !Empty(cPedido)

	l410Auto := .F.
	nModulo  := 5
	
	SC5->(DbSetOrder(1))
	SC5->(xFilial("SC5") + cPedido )
	nReg := Recno()

	A410Altera(cAlias,nReg,nOpc)
	
	nModulo := nModOld
	
Endif
	
Return                                   