#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMLOJC01 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  07/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CONSULTA OS PEDIDOS DE VENDA DE UM DETERMINADO PRODUTO     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                      '
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMLOJC01()

Private cProduto := ""

IF oFolder:NOPTION = 3
	IF EMPTY(oGetD3:AARRAY[oGetD3:NAT,2])
		MsgInfo("Por favor, posicione em produto!")
	Else
		IF MsgYesNo("Deseja consultar pedidos de compra do produto -  [" + ALLTRIM(oGetD3:AARRAY[oGetD3:NAT,2]) + "  /  " + ALLTRIM(oGetD3:AARRAY[oGetD3:NAT,3]) + "] ???","Confirma?")
			cProduto := oGetD3:AARRAY[oGetD3:NAT,2]
			FwMsgRun( ,{|| CONSPROD() }, , "Filtrando os pedidos de compra, por favor aguarde..." )
		EndIF
	EndIF
Else
	IF EMPTY(oGetD2:AARRAY[oGetD2:NAT,7])
		MsgInfo("Por favor, posicione em produto!")
	Else
		IF MsgYesNo("Deseja consultar pedidos de compra do produto -  [" + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,7]) + "  /  " + ALLTRIM(oGetD2:AARRAY[oGetD2:NAT,3]) + "] ???","Confirma?")
			cProduto := oGetD2:AARRAY[oGetD2:NAT,7]
			FwMsgRun( ,{|| CONSPROD() }, , "Filtrando os pedidos de compra, por favor aguarde..." )
		EndIF
	EndIF
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMLOJC01 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  07/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CONSULTA OS PEDIDOS DE VENDA DE UM DETERMINADO PRODUTO     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                                      '
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION CONSPROD()

Local cQuery    := ""
Local aPedSKU   := {}
Local aButtons  := {}
Local oDlg, oLogo, oFnt, oBrw

Private cCadastro := "CONSULTA DE PEDIDOS DE COMPRA"

cQuery := " SELECT C7_FILENT, FILIAL, C7_NUM, A2_NREDUZ, C7_EMISSAO, C7_DATPRF, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT "
cQuery += " FROM " + RETSQLNAME("SC7") + " SC7 "
cQuery += " INNER JOIN SM0010 ON FILFULL = C7_FILENT "
cQuery += " INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON A2_COD = C7_FORNECE "
cQuery += " AND A2_LOJA = C7_LOJA "
cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_COD = C7_PRODUTO "
cQuery += " WHERE C7_QUANT > C7_QUJE "
cQuery += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "
cQuery += " AND A2_FILIAL = '" + XFILIAL("SA2") + "' "
cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " AND C7_PRODUTO = '" + cProduto + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

TRB->(DbGoTop())

While TRB->(!EOF())
	aAdd( aPedSKU , { TRB->C7_FILENT, TRB->FILIAL, TRB->C7_NUM, TRB->C7_EMISSAO, TRB->C7_DATPRF, TRB->C7_PRODUTO, TRB->B1_DESC, TRB->C7_UM, TRB->C7_QUANT, TRB->A2_NREDUZ } )
	TRB->(DbSkip())
EndDo

IF Len(aPedSKU) > 0	
	cQuery := " SELECT SUM(B2_QATU) AS ESTOQUE, SUM(B2_QEMP + B2_RESERVA + B2_QPEDVEN) AS PEDIDO, "
	cQuery += " SUM(B2_QATU) - SUM(B2_QEMP + B2_RESERVA + B2_QPEDVEN) AS SALDO "
	cQuery += " FROM " + RETSQLNAME("SB2") + " SB2 "
	cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_COD = B2_COD "
	cQuery += " WHERE B2_LOCAL = B1_LOCPAD "
	cQuery += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "
	cQuery += " AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND B2_COD = '" + cProduto + "' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	TRB->(DbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MONTA A TELA COM AS INFORMACOES DETALHADAS DO PRODUTO SELECIONADO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oDlg FROM 0,0 TO 530,715 TITLE "Pedidos de Compra - KMLOJC01" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	
	// TRAZ O LOGO DA KOMFORT
	@ 035,010 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.
	
	@ 040,080 Say "Produto   : " + cProduto 												Size 600,010 Font oFnt Pixel Of oDlg
	@ 055,080 Say "Descricao : " + POSICIONE("SB1",1,XFILIAL("SB1") +cProduto,"B1_DESC") 	Size 600,010 Font oFnt Pixel Of oDlg
	
	@ 070,000 Say REPLICATE("_",500) Size 2000,010 Font oFnt Pixel Of oDlg
	
	@ 090,010 Say "Saldo em Estoque : " + Transform(TRB->ESTOQUE,PesqPict('SB2','B2_QATU')) 	Size 300,010 Font oFnt Pixel Of oDlg
	@ 090,130 Say "Em Pedido Venda : "  + Transform(TRB->PEDIDO ,PesqPict('SB2','B2_QATU')) 	Size 300,010 Font oFnt Pixel Of oDlg
	@ 090,250 Say "Saldo Disponivel : " + Transform(TRB->SALDO  ,PesqPict('SB2','B2_QATU')) 	Size 300,010 Font oFnt Pixel Of oDlg
		
	// MONTA O BROWSE COM OS PRODUTOS (SKU)
	oBrw:= TWBrowse():New(110,005,350,150,,{"Loja Entrega","Pedido","Fornecedor","Dt.Emissão","Dt.Prevista Entrega","Quantidade"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aPedSKU)
	oBrw:bLine := {|| {		ALLTRIM(aPedSKU[oBrw:nAt,01]) + " - " + ALLTRIM(aPedSKU[oBrw:nAt,02])	,; 	// CODIDO FILIAL + DESCRICAO
	aPedSKU[oBrw:nAt,03] ,; 																			// NUMERO PEDIDO DE VENDA
	aPedSKU[oBrw:nAt,10] ,;			 																	// NOME FORNECEDOR
	DTOC(STOD(aPedSKU[oBrw:nAt,04])) ,; 																// DATA DE EMISSAO DO PEDIDO DE COMPRA
	DTOC(STOD(aPedSKU[oBrw:nAt,05])) ,; 																// DATA PREVISTA DE ENTRGA DO PEDIDO DE COMPRA
	Transform(aPedSKU[oBrw:nAt,09],PesqPict('SC7','C7_QUANT')) }}										// QUANTIDADE
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End() } , { || oDlg:End() },, aButtons)	
Else
	MsgInfo("Não exitem pedidos de compra para este produto!")
EndIF


RETURN()
