#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYTMOV09 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  21/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ TELA DE MONITOR DE CLIENTES - CREDITOS (RA E NCC)          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYTMOV10(cCliente,cLjCli)

Local cQuery  	:= ""
Local aButtons  := {}
Local aSize     := MsAdvSize()
Local oSt1      := LoadBitmap(GetResources(),'BR_VERDE')
Local oSt2      := LoadBitmap(GetResources(),'BR_AMARELO')
Local oSt3      := LoadBitmap(GetResources(),'BR_VERMELHO')
Local oTelaCredito
Local oFnt
Local oLogo
Local oPnlInfo, oPlnCabec
Local oBmpPed1 , oBmpPed2 , oBmpPed3
Local oBrwCabec 
Local oScroll, oPnlScroll                                           

Private aInfCabec := {{"1" , "" , 0 , 0 , "" , "" , "" , "" , "", "", "", "" , "", "", ""}}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VARIAVEIS DE TOTAIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nQtdTot   := 0
Private nVlrTot   := 0
Private nQtdAbe   := 0
Private nVlrAbe   := 0
Private nQtdPar   := 0
Private nVlrPar   := 0
Private nQtdUti   := 0
Private nVlrUti   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POSICIONA NO CLIENTE INFORMADO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cCliente + cLjCli))

FwMsgRun( ,{|| FILDET() }, , "Filtrando os créditos do cliente , por favor aguarde..." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA PRINCIPAL DO MONITORAMENTO DE CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTelaCredito FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Pendencias Financeiras dos Pedidos" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTelaCredito:lEscClose := .F.   

oScroll := TScrollArea():New(oTelaCredito,000,000,000,000,.T.,.T.,.T.)
oScroll:Align := CONTROL_ALIGN_ALLCLIENT

//@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 2150,2150 //#AFD201800601.O
@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 600,320 //#AFD201800601.N
oScroll:SetFrame( oPnlScroll )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA PAINEL COM AS INFORMACOES GERAIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPnlInfo:= TPanel():New(005,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,655,045, .T., .F. )
oPnlInfo:NCLRPANE:=RGB(220,220,220)

// TRAZ O LOGO DA KOMFORT HOSUE
@ 005,590 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oPnlInfo PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

@ 005,005 Say "Informações dos créditos do cliente   - " 											Size 200,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlInfo
@ 005,120 Say "Total de Créditos : " + Transform(nQtdTot ,"@E 999")									Size 600,020 Font oFnt Color CLR_BLUE 		Pixel Of oPnlInfo
@ 005,200 Say "Valor Total dos Créditos : " + Transform(nVlrTot ,PesqPict('SC6','C6_VALOR'))		Size 600,020 Font oFnt Color CLR_BLUE		Pixel Of oPnlInfo

@ 017,005 Say "Cliente : " + ALLTRIM(SA1->A1_COD) + " - " + ALLTRIM(SA1->A1_NOME)					Size 200,010 Font oFnt 						Pixel Of oPnlInfo

@ 005,350 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlInfo Size 10,10 NoBorder When .F. Pixel
@ 005,360 Say "Em aberto : " + Transform(nQtdAbe ,"@E 999")											Size 600,020 Font oFnt  					Pixel Of oPnlInfo
@ 005,450 Say "Valor Total : " + Transform(nVlrAbe ,PesqPict('SC6','C6_VALOR'))					Size 600,020 Font oFnt  					Pixel Of oPnlInfo

@ 017,350 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlInfo Size 10,10 NoBorder When .F. Pixel
@ 017,360 Say "Parcialmente Utilizados  : " + Transform(nQtdPar ,"@E 999")							Size 600,020 Font oFnt  					Pixel Of oPnlInfo
@ 017,450 Say "Valor Total : " + Transform(nVlrPar ,PesqPict('SC6','C6_VALOR'))					Size 600,020 Font oFnt 						Pixel Of oPnlInfo

@ 029,350 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlInfo Size 10,10 NoBorder When .F. Pixel
@ 029,360 Say "Utilizados : " + Transform(nQtdUti ,"@E 999")										Size 600,020 Font oFnt  					Pixel Of oPnlInfo
@ 029,450 Say "Valor Total : " + Transform(nVlrUti ,PesqPict('SC6','C6_VALOR'))					Size 600,020 Font oFnt 						Pixel Of oPnlInfo  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O PAINEL COM OS CABECALHOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oPlnCabec:= TPanel():New(055,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,300, .T., .F. ) //#AFD201800601.O
oPlnCabec:= TPanel():New(055,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,260, .T., .F. ) //#AFD201800601.N
oPlnCabec:NCLRPANE:=RGB(220,220,220)

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 065,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 065,595 SAY "Em aberto" OF oPnlScroll Font oFnt  PIXEL

@ 085,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 085,595 SAY "Parcialmente Utilizados" OF oPnlScroll Font oFnt PIXEL

@ 105,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 105,595 SAY "Utilizados" OF oPnlScroll Font oFnt PIXEL     

oBrwCabec:= TWBrowse():New(000,000,000,000,,{"","Tipo","Valor","Saldo","Num.Título","Dt.Emissão","Pedido","Forma de Pagamento","Loja de Origem","Usuário","SAC","Tipo NCC","Data Baixa"},,oPlnCabec,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwCabec:SetArray(aInfCabec)
oBrwCabec:bLine := {|| { 	IF(aInfCabec[oBrwCabec:nAt,01] == "1",oSt1,IF(aInfCabec[oBrwCabec:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aInfCabec[oBrwCabec:nAt,02] 													,;	// TIPO DO CREDITO
Transform(aInfCabec[oBrwCabec:nAt,03] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR
Transform(aInfCabec[oBrwCabec:nAt,04] ,PesqPict('SC6','C6_VALOR')) 			,;	// SALDO
aInfCabec[oBrwCabec:nAt,05] 													,;	// NUMERO TITULO - FINANCEIRO
DTOC(STOD(aInfCabec[oBrwCabec:nAt,06]))										,;	// DATA DE EMISSAO
aInfCabec[oBrwCabec:nAt,07] 													,;	// NUMERO DO PEDIDO QUE UTILIZOU O CREDITO
aInfCabec[oBrwCabec:nAt,08] 													,;	// FORMA DE PAGAMENTO [NOS CASOS DE RA]
aInfCabec[oBrwCabec:nAt,09] + " - " + ALLTRIM(aInfCabec[oBrwCabec:nAt,13])		,;	// LOJA DE ORIGEM
ALLTRIM(aInfCabec[oBrwCabec:nAt,10] )											,;	// USUARIO QUE FEZ O LANCAMENTO DO CREDITO
aInfCabec[oBrwCabec:nAt,11] 													,;	// NUMERO DO SAC
aInfCabec[oBrwCabec:nAt,12] + " - " + ALLTRIM(aInfCabec[oBrwCabec:nAt,14])		,;	// TIPO NCC 
DTOC(STOD(aInfCabec[oBrwCabec:nAt,15]))                                        ,;  // DATA DA BAIXA
}}
oBrwCabec:Align:=CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oTelaCredito ON INIT EnchoiceBar( oTelaCredito, { || oTelaCredito:End() } , { || oTelaCredito:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILDET º Autor ³ Luiz Eduardo F.C.  º Data ³  21/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FILTRA OS CREDITOS DO CLIENTE         				    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION FILDET()

Local cQuery  := ""
Local cStatus := ""  

nQtdTot   := 0
nVlrTot   := 0
nQtdAbe   := 0
nVlrAbe   := 0
nQtdPar   := 0
nVlrPar   := 0
nQtdUti   := 0
nVlrUti   := 0

cQuery := " SELECT E1_TIPO, E1_VALOR, E1_SALDO, E1_NUM, E1_EMISSAO, '' AS PEDIDO, E1_FORMREC, E1_MSFIL, E1_USRNAME, E1_01SAC, E1_01MOTIV, FILIAL, X5_DESCRI, E1_BAIXA FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " INNER JOIN SM0010 ON FILFULL = E1_MSFIL "
cQuery += " INNER JOIN " + RETSQLNAME("SX5") + " SX5 ON X5_CHAVE = E1_01MOTIV "
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND X5_FILIAL = '" + XFILIAL("SX5") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_TIPO IN ('NCC','RA') "
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " AND SX5.D_E_L_E_T_ = ' ' "
cQuery += " AND X5_TABELA = 'O1' "
cQuery += " ORDER BY E1_EMISSAO DESC "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aInfCabec[1,2])
		aInfCabec := {}
	EndIF
	
	IF TRB->E1_SALDO = 0
		cStatus := "3"
		// CARREGA AS VARIAVEIS DE CREDITOS UTILIZADOS
		nQtdUti   := nQtdUti + 1
		nVlrUti   := nVlrUti + TRB->E1_VALOR
	ELSEIF TRB->E1_SALDO = TRB->E1_VALOR
		cStatus := "1"
		// CARREGA AS VARIAVEIS DE CREDITOS EM ABERTO
		nQtdAbe   := nQtdAbe + 1
		nVlrAbe   := nVlrAbe + TRB->E1_VALOR
	Else   
		cStatus := "2"  
		// CARREGA AS VARIAVEIS DE CREDITOS PARCIALMENTE UTILIZADOS	
		nQtdPar   := nQtdPar + 1
		nVlrPar   := nVlrPar + TRB->E1_VALOR
	EndIF
	aAdd( aInfCabec, { cStatus , TRB->E1_TIPO, TRB->E1_VALOR, TRB->E1_SALDO, TRB->E1_NUM, TRB->E1_EMISSAO, TRB->PEDIDO, TRB->E1_FORMREC, TRB->E1_MSFIL, TRB->E1_USRNAME, TRB->E1_01SAC, TRB->E1_01MOTIV, TRB->FILIAL, TRB->X5_DESCRI, TRB->E1_BAIXA } )
     
	// CARREGA AS VARIAVEIS DE VALOR TOTAL
	nQtdTot := nQtdTot + 1   
	nVlrTot := nVlrTot + TRB->E1_VALOR
	
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

RETURN()