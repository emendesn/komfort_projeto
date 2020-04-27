#include "totvs.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMK150EXC ºAutor  ³ Cristiam Rossi     º Data ³  24/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. rotina de exclusão de Orçamento/PV no Call Center     º±±
±±º          ³ antes de montar a tela para usuário confirmar              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse / Global                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±21/04/2018 ³ #RVC20180421 - Ajuste do Cancelamento do PV				   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMK150EXC()

Local 	lRet		:= .T.	//permite excluir
Local 	cMsg		:= ""
Local	cTitulo		:= "Exclusão de Pedido"
Private _lBaixaE2 	:= .F.	//#CMG20180713.n
Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente operacao 1=Faturamento.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SUA->UA_OPER <> "1"
	cMsg :=	"Exclusão não permitida para orçamento."
	MsgStop(cMsg,cTitulo)	//#RVC20180918.n
	lRet := .F.
	Return(lRet)
EndIF

If lRet
	//#RVC20180613.bn
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	If !Empty(SUA->UA_NUMSC5)
		If SC5->(DbSeek(xFilial("SC5") + Alltrim(SUA->UA_NUMSC5)))
			If (dDataBase <> SC5->C5_EMISSAO)
				cMsg := "Somente é permitido o cancelamento da venda, no mesmo dia em que foi realizada."
				MsgStop(cMsg,cTitulo)
				lRet := .F.
				Return lRet	//#RVC20180925.n
			Endif
		Else
			cMsg := "Pedido "+SUA->UA_NUMSC5+" não encontrado. Acione o Administrador do Sistema"
			MsgStop(cMsg,cTitulo)
			lRet := .F.
			Return lRet	//#RVC20180925.n
		EndIf
	Else
		cMsg := "Não há pedido de venda vinculado à proposta n. "+SUA->UA_NUM +" . Acione o Administrador do Sistema"
		MsgStop(cMsg,cTitulo)
		lRet := .F.
		Return lRet	//#RVC20180925.n
	EndIF
EndIF

If lRet
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se nao tiver sido faturado ou tiver a NF cancelada entao pode-se cancelar o pedido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SUA->UA_STATUS == "NF."
		Help(" ",1,"NF.EMITIDA")
		Return(.F.)
	Endif
	
	//ÚÄLocalizacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se n„o tiver sido REMITITDO ou tiver a RM cancelado entao pode-se cancelar o pedido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SUA->UA_STATUS == "RM."
		Help(" ",1,"RM.ENVIADA")
		Return(.F.)
	Endif
	
	If fVldBord()
		Help(" ",1,"TITBORDERO", NIL,NIL, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Título(s) à Receber já está em borderô. Acione o depto. crédito"})
		Return(.F.)
	EndIf
	//#RVC20180925.bn
	If fVldBdE2()
		Help(" ",1,"TITBORDERO", NIL,NIL, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Título(s) à Pagar (Taxas) já está em borderô. Acione o depto. financeiro"})
		Return(.F.)
	EndIf
	//#RVC20180925.en
	If ValidaE2()
		Help(" ",1,"TITBAIXADO", NIL,NIL, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Título(s) já processado(s). Acione o Financeiro (C.Pagar)"})
		Return(.F.)
	EndIf
	
	If CancelSC6(SUA->UA_NUMSC5)
		lRet := .T.
		//FwMsgRun( ,{|| lRet := MaLiberOk({SUA->UA_NUMSC5},.T.)}, , "Aguarde, estornando o Pedido de Vendas..." ) //Completa a eliminação de resíduo do PV.
	Else
		msgAlert("Não foi possível eliminar o pedido N. " + SUA->UA_NUMSC5 +". "  + Chr(13) + Chr(10) + "Verifique se o mesmo encontra-se faturado ou em Carga.")
		Return(.F.)			//#RVC20180918.n
	EndIf
	
	//#RVC20180918.bn
Else
	cMsg := "Não foi possível excluir o Atendimento N. " + SUA->UA_NUM +". "  + Chr(13) + Chr(10) + "Verifique se o mesmo possui restrição."
	MsgStop(cMsg,cTitulo)
EndIf
//#RVC20180918.en

Return lRet

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CancelSC6 º Autor ³ Rafael Cruz        º Data ³  19/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function CancelSC6(cPedido)

local lCarga 	:= .F.
Local lNota  	:= .F.
Local lRet	 	:= .T.
Local lReserva	:= .F.
Local aAreaSC5  := SC5->( getArea() )
Local aAreaSC6  := SC6->( getArea() )
Local _aSB9     := {}
local _cMsFil 	:= ""

DbSelectArea("SB2")
SB2->(DbSetOrder(1))//B2_FILIAL+B2_COD+B2_LOCAL
SB2->(DbGoTop())

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbGoTop())

SC6->(DbSeek(xFilial("SC6")+cPedido))



While !SC6->(Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedido
	
	If !(SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))) .And. SC6->C6_LOCAL <> '01'
		
		If RecLock("SB2",.T.)
			
			SB2->B2_FILIAL := xFilial("SB2")
			SB2->B2_COD    := SC6->C6_PRODUTO
			SB2->B2_LOCAL  := SC6->C6_LOCAL
			SB2->B2_QATU   := 0
			SB2->B2_VATU1  := 0
			SB2->B2_TIPO   := '1'
			
		EndIf
		
	EndIf
	
	SC6->(DbSkip())
	
EndDo


DbSelectArea("SC5")
DbSetOrder(1)
If SC5->(dbSeek(xFilial("SC5") + cPedido ))
	
	_cMsFil := SC5->C5_MSFIL
	
	SC6->(dbGoTop())
	SC6->(dbSeek( xFilial("SC6") + cPedido ) )
	While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == SC5->C5_NUM
		
		If OmsHasCg(SC6->C6_NUM,SC6->C6_ITEM)
			lCarga := .T.
			Exit
		ElseIf !Empty(SC6->C6_NOTA)
			lNota := .T.
			Exit
		Endif
		
		SC6->(dbSkip())
	EndDo
	
	If lCarga
		msgAlert("[TMK150EXC] Não foi possível estornar o pedido N." + cPedido + ". Pedido em Carga.","ATENÇÃO")
		Return(.F.)
	ElseIf lNota
		msgAlert("[TMK150EXC] Não foi possível estornar o pedido N." + cPedido + ". Pedido Faturado.","ATENÇÃO")
		Return(.F.)
	ElseIf lReserva
		msgAlert("[TMK150EXC] Não foi possível estornar o pedido N." + cPedido + ". Pedido possui Reserva.","ATENÇÃO")
		Return(.F.)
	EndIf
EndIf

//#RVC20190919.bn
If lRet
	
	fAltPed(_cMsFil, cPedido)
	//Ma410Resid("SC5",SC5->(recno()),1)
	
	RecLock("SC5",.F.)
	SC5->C5_XSTATUS := "3" // 3-CANCELADO
	msunlock()
EndIf
//#RVC20190919.en

SC6->( restArea( aAreaSC6 ) )
SC5->( restArea( aAreaSC5 ) )

Return lRet

//+------------+--------------+-------+------------------------+------+------------+
//| Função:    | Reserva       | Autor | Ellen Santiago         | Data | 02/05/2018 |
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Verifica se existe reserva para o produto em questao               |
//+------------+--------------------------------------------------------------------+
//|Uso         | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+

Static Function Reserva(xFilial, cNum, cProduto, cLocal)

Local lContinua := .F.

dbSelectArea("SC0")
dbSetOrder(1)  // FILIAL + NUMERO + PRODUTO + Local
If SC0->(dbSeek(xFilial + cNum + cProduto + cLocal   ))
	lContinua := .T.
Endif

Return lContinua


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fVldBord ºAutor  ³ Caio garcia        º Data ³  29/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVldBord()

Local cQuery 	:= ""
Local _cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aRotAuto 	:= {}
Local aBaixa   	:= {}

If INCLUI .OR. ALTERA
	Return(lOk)
EndIf

cQuery += " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
cQuery += " E1_FILORIG 		= '"+ Alltrim(cFilAnt) +"' "
cQuery += " AND E1_NUMSUA 	= '"+SUA->UA_NUM+"' "
cQuery += " AND E1_CLIENTE 	= '"+SUA->UA_CLIENTE+"' "
cQuery += " AND E1_LOJA    	= '"+SUA->UA_LOJA+"' "
cQuery += " AND E1_NUMBOR <> ' ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

(_cAlias)->(DbGotop())

If (_cAlias)->(Eof())
	lOk := .F.
Endif

(_cAlias)->( dbCloseArea() )

Return(lOk)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaE2 ºAutor  ³ Rafael Cruz        º Data ³  19/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a exclusao do titulos financeiros gerado pelo       º±±
±±º          ³ orcamento de vendas.	                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TELEVENDAS - CALL CENTER                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidaE2()

Local cQuery 	:= ""
Local _cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aTipo		:= SuperGetMv("KH_FRMTX",,"CC/CD/BOL/BST")

If INCLUI .OR. ALTERA
	Return(lOk)
EndIf

cQuery += " SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ "
cQuery += " FROM "+RetSqlName("SE2")+" SE2 "
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  "
cQuery += " AND E2_TIPO IN " + FormatIn(aTipo,"/")
cQuery += " AND E2_MSFIL = '" + Alltrim(cFilAnt) + "' "
cQuery += " AND E2_HIST = '" + Alltrim(SUA->UA_NUMSC5) + "' "
cQuery += " AND E2_BAIXA <> ' ' "
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

(_cAlias)->(DbGotop())

If (_cAlias)->(Eof())
	lOk := .F.
Else
	_lBaixaE2 := .T. //#CMG20180713.n
Endif

(_cAlias)->( dbCloseArea() )

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fVldBdE2 ºAutor  ³ Rafael Cruz        º Data ³  25/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVldBdE2()

Local cQuery 	:= ""
Local _cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aRotAuto 	:= {}
Local aBaixa   	:= {}
Local cPrfx		:= SuperGetMv("KH_PREFSE2",.F.,"TXA")
Local aTipo		:= SuperGetMv("KH_FRMTX",,"CC/CD/BOL/BST")

If INCLUI .OR. ALTERA
	Return(lOk)
EndIf

cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SE2")+" SE2 "
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  "
cQuery += " AND E2_TIPO IN " + FormatIn(aTipo,"/")
cQuery += " AND E2_HIST = '" + Alltrim(SUA->UA_NUMSC5) + "' "
cQuery += " AND E2_PREFIXO = '"  + cPrfx                  + "'  "
cQuery += " AND E2_NUMBOR <> ' ' "
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

(_cAlias)->(DbGotop())

If (_cAlias)->(Eof())
	lOk := .F.
Endif

(_cAlias)->( dbCloseArea() )

Return(lOk)

//--------------------------------------------------------------
/*/{Protheus.doc} fAltPed
Description //Estorna o pedido de vendas
@param aReserva Parameter // MSFIL, NUMERO PV, ALTERA DA AGENDAMENTO
@return xRet Return Description
@author  - Alexis Duarte
@since 17/10/2018
/*/
//--------------------------------------------------------------
Static Function fAltPed(cMsFil, cNumPed, lAltDtAgen)

Local aArea := getArea()
Local cQuery := ""
Local cAlias := getNextAlias()
Local aCabec := {}
Local aLinha := {}
Local aItens := {}
Local aReserva := {}
Local aItensPed := {}
Local cGerados := ""
Local aGerados := {}

Private lMsErroAuto := .F.

Default lAltDtAgen := .F.

cQuery := "SELECT * "
cQuery += " FROM "+ RetSqlName("SC6")+" SC6"
cQuery += " INNER JOIN "+ RetSqlName("SC5")+" SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM"
cQuery += "	WHERE C5_MSFIL = '"+cMsFil+"'"
cQuery += "	AND C5_NUM = '"+cNumPed+"'"
cQuery += "	AND SC5.D_E_L_E_T_ = ' '"
cQuery += "	AND SC6.D_E_L_E_T_ = ' '"
cQuery += "	ORDER BY C6_NUM, C6_ITEM"

PLSQuery(cQuery, cAlias)

if (cAlias)->(!eof())
	
	aadd(aCabec,{"C5_NUM",(cAlias)->C5_NUM,Nil})
	aadd(aCabec,{"C5_TIPO","N",Nil})
	aadd(aCabec,{"C5_CLIENTE",(cAlias)->C5_CLIENTE,Nil})
	aadd(aCabec,{"C5_LOJACLI",(cAlias)->C5_LOJACLI,Nil})
	aadd(aCabec,{"C5_LOJAENT",(cAlias)->C5_LOJAENT,Nil})
	aadd(aCabec,{"C5_CONDPAG",(cAlias)->C5_CONDPAG,Nil})
	aadd(aCabec,{"C5_CONTRA",'000000',Nil})
	aadd(aCabec,{"C5_TIPOCLI",(cAlias)->C5_TIPOCLI,Nil})
	
endif

//Alteração solicitada no chamado 9628
DbselectArea("DAI")
DAI->(dbsetorder(4))
If DAI->(DbSeek(xFilial("DAI") + cNumPed))
	cMsgCarga := "O pedido: "+ cNumPed +" ja possui carga montada"+ENTER
	cMsgCarga += "Não é permitido sua exclusao. Entre em contato com a Logistica!"
	msgStop(cMsgCarga,"ATENÇÃO")
	return
Endif





While (cAlias)->(!eof())
	
	aLinha := {}
	
	aadd(aLinha,{"LINPOS"		,"C6_ITEM",(cAlias)->C6_ITEM})
	aadd(aLinha,{"AUTDELETA"	,"N",Nil})
	aadd(aLinha,{"C6_PRODUTO"	,(cAlias)->C6_PRODUTO,Nil})
	aadd(aLinha,{"C6_QTDVEN"	,(cAlias)->C6_QTDVEN,Nil})
	aadd(aLinha,{"C6_PRCVEN"	,(cAlias)->C6_PRCVEN,Nil})
	aadd(aLinha,{"C6_PRUNIT"	,(cAlias)->C6_PRUNIT,Nil})
	aadd(aLinha,{"C6_VALOR"		,(cAlias)->C6_VALOR,Nil})
	aadd(aLinha,{"C6_TES"		,(cAlias)->C6_TES,Nil})
	aadd(aLinha,{"C6_LOCAL"		,(cAlias)->C6_LOCAL,Nil})
	
	if lAltDtAgen
		aadd(aLinha,{"C6_ENTREG"	,stod('99910909'),Nil})
	endif
	
	if !empty(alltrim((cAlias)->C6_RESERVA))
		
		aadd(aLinha,{"C6_LOCALIZ"	,"",Nil})
		aadd(aLinha,{"C6_RESERVA"	,"",Nil})
		aadd(aLinha,{"C6_01AGEND"	,"2",Nil})
		
		aadd(aReserva,{(cAlias)->C6_RESERVA})
		
		// itens para geração da solicitação de compras.
		// aItensPed(Pedido,Produto,Item,Qtd Venda)
		aadd(aItensPed,{(cAlias)->C6_NUM, (cAlias)->C6_PRODUTO, (cAlias)->C6_ITEM, (cAlias)->C6_QTDVEN})
	else
		aadd(aLinha,{"C6_LOCALIZ"	,"",Nil})
		aadd(aLinha,{"C6_01AGEND"	,"2",Nil})
	endif
	
	aadd(aItens,aLinha)
	(cAlias)->(DbSkip())
enddo

if len(aCabec) > 0 .and. len(aItens) > 0
	cFilAntBkp := cFilAnt
	cFilAnt := '0101'
	
	BEGIN TRANSACTION
	
	MsExecAuto({|x,y,z| MATA410(x,y,z)}, aCabec, aItens, 4)
	
	if lMsErroAuto
		DisarmTransaction()
		MostraErro()
	else
		if len(aReserva) > 0
			//Exclui Reservas
			fExcReserv(aReserva)
			
			//Gera Solicitação de compras
		   //	U_KHGERSC(aItensPed,@aGerados) //FUNÇÃO COMENTADA POIS NÃO É GERADA SOLICITAÇÃO DE COMPRAS PARA MATERIAIS DE REVENDA - Marcio Nunes - 30/09/2019
		endif
	endIf
	
	END TRANSACTION
	
	cFilAnt := cFilAntBkp
	
endif

(cAlias)->(dbCloseArea())

if len(aGerados) > 0
	cGerados := "Solicitações Geradas:"+ ENTER
	
	for nx := 1 to len(aGerados)
		cGerados += aGerados[nx][1] + ENTER
	next nx
	
	msgInfo(cGerados,"SOLICITAÇÕES GERADAS")
endif


RestArea(aArea)

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fExcReserv
Description //Exclusão de Reserva
@param aReserva Parameter Array com as reservas a serem excluidas
@return xRet Return Description
@author  - Alexis Duarte
@since 17/10/2018
/*/
//--------------------------------------------------------------
Static Function fExcReserv(aReserva)

Local nx := 0
Local nOperacao := 3
Local cObs := "Exclusão de reserva ao estornar o pedido de venda."
Local cQuery := ""
Local cProduto := ""
Local cLocal := ""
Local nQuant := 0
Local cAlias := getNextAlias()
Local nUso := 0

Local lReserv := .F.

Local aLote := {}
Local aOperacao := {}

Local aHeaderAux := {}
Local aColsAux := {}

dbSelectArea("SX3")
dbSetOrder(2)

if dbSeek("C0_VALIDA ")
	nUso++
	aAdd(aHeaderAux,{ TRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT }	)
endif

aColsAux := Array(nUso+1)

for nx := 1 to len(aReserva)
	
	aOperacao := {}
	lReserv := .F.
	
	cQuery := "SELECT * FROM "+retSqlName("SC0")
	cQuery += " WHERE C0_NUM = '"+ aReserva[nx][1] +"'"
	cQuery += " AND C0_QUANT > 0"
	cQuery += " AND D_E_L_E_T_ = ' '"
	
	PLSQuery(cQuery, cAlias)
	
	if (cAlias)->(!eof())
		
		aColsAux[1] := (cAlias)->C0_VALIDA
		aColsAux[nUso+1] := .F.
		
		aOperacao := {	nOperacao				,;	// Operacao : 1 Inclui,2 Altera,3 Exclui
		(cAlias)->C0_TIPO		,;	// Tipo da Reserva : PD - Pedido
		(cAlias)->C0_DOCRES		,;	// Documento que originou a Reserva
		UsrRetName(RetCodUsr())	,;	// Solicitante
		(cAlias)->C0_FILIAL		,;	// Filial
		cObs					}	// Observacao
		
		aLote := {"","",(cAlias)->C0_LOCALIZ,""} // Array com os dados do lote para a rotina a430Reserv
		
	endif
	
	if len(aOperacao) > 0
		
		cProduto := (cAlias)->C0_PRODUTO
		cLocal := (cAlias)->C0_LOCAL
		nQuant := (cAlias)->C0_QUANT
		
		cNumRes := (cAlias)->C0_NUM
		
		lReserv := A430Reserv (aOPERACAO,cNumRes,cProduto,cLocal,nQuant,aLOTE,aHeaderAux,aColsAux,NIL,.F.)
		
		SC0->( MsUnLock() )  //-->Libera a tabela SC0 para confirmar reserva
		
		if !lReserv
			MostraErro()
			RollBackSx8()
		else
			ConfirmSX8()
		endif
		
	endif
	
next nx
Return
