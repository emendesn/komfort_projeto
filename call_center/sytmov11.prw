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
±±ºDescricao ³ TELA DE MONITOR DE CLIENTES - PEDIDOS                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ - KOMFORT HOUSE -                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYTMOV11(cCliente,cLjCli)

Local cQuery  	:= ""
Local cStatus 	:= ""
Local aButtons  := {}
Local aSize     := MsAdvSize()
Local oSt1      := LoadBitmap(GetResources(),'BR_VERDE')		   
Local oSt2      := LoadBitmap(GetResources(),'BR_AMARELO')		
Local oSt3      := LoadBitmap(GetResources(),'BR_VERMELHO') 	
Local oSt4      := LoadBitmap(GetResources(),'BR_VERDE')  		
Local oSt5      := LoadBitmap(GetResources(),'BR_AZUL')  		
Local oSt6      := LoadBitmap(GetResources(),'BR_VERMELHO')  		
Local oSt7      := LoadBitmap(GetResources(),'BR_AMARELO')  	
Local oSt8      := LoadBitmap(GetResources(),'BR_CINZA')  
Local oSt9      := LoadBitmap(GetResources(),'BR_PRETO')  
Local oSt0      := LoadBitmap(GetResources(),'BR_MARROM')
Local oStA      := LoadBitmap(GetResources(),'BR_BRANCO')  

Local oTelaFin
Local oFnt
Local oLogo
Local oPnlInfo, oPlnCabec, oPnlItens
Local oBmpPed1 , oBmpPed2 , oBmpPed3
Local oBrwCabec
Local oScroll, oPnlScroll
local oCor

Private aInfCabec := {{"1" , "" , "", 0, 0 , "", "", "", "" , "", "", ""}}
Private aInfItens := {{"","","","",0,"",0,0,"","","",""}}
Private oBrwItens

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POSICIONA NO CLIENTE INFORMADO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cCliente + cLjCli))

FwMsgRun( ,{|| FILDET() }, , "Filtrando pedidos , por favor aguarde..." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA PRINCIPAL DO MONITORAMENTO DE CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTelaFin FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Pedidos" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTelaFin:lEscClose := .F.

oScroll := TScrollArea():New(oTelaFin,000,000,000,000,.T.,.T.,.T.)
oScroll:Align := CONTROL_ALIGN_ALLCLIENT

//@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 2150,2150 //#AFD201800601.O
@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 600,330 //#AFD201800601.N
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

@ 005,005 Say "Informações dos pedidos" 								Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlInfo
@ 017,005 Say "Cliente : " + ALLTRIM(SA1->A1_COD) + " - " + ALLTRIM(SA1->A1_NOME)				Size 200,010 Font oFnt 					Pixel Of oPnlInfo
@ 029,005 Say "Total de Pedidos : " + Transform(Len(aInfCabec) ,"@E 999")						Size 600,020 Font oFnt 					Pixel Of oPnlInfo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O PAINEL COM OS CABECALHOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPlnCabec:= TPanel():New(055,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,100, .T., .F. )
oPlnCabec:NCLRPANE:=RGB(220,220,220)

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 065,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 065,595 SAY "Em Aberto" OF oPnlScroll Font oFnt  PIXEL

@ 085,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 085,595 SAY "Em Processamento" OF oPnlScroll Font oFnt PIXEL

@ 105,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 105,595 SAY "Finalizado" OF oPnlScroll Font oFnt PIXEL

oBrwCabec:= TWBrowse():New(000,000,000,000,,{"","Pedido","Num.TMK","Valor","Quantidade","Loja Origem","Vendedor","Dt.Emissão","Dt.Entrega","SAC"},,oPlnCabec,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwCabec:SetArray(aInfCabec)
oBrwCabec:bLine := {|| { IF(aInfCabec[oBrwCabec:nAt,01] == "1",oSt1,IF(aInfCabec[oBrwCabec:nAt,01] == "2",oSt2,oSt3))							,;	// LEGENDA
						 aInfCabec[oBrwCabec:nAt,02] 													,;	// PEDIDO
						 aInfCabec[oBrwCabec:nAt,03] 													,;	// NUMERO ORCAMENTO TELEVENDAS
						 Transform(aInfCabec[oBrwCabec:nAt,04] ,PesqPict('SC6','C6_VALOR'))				,;	// VALOR TOTAL DOS ITENS
						 Transform(aInfCabec[oBrwCabec:nAt,05] ,PesqPict('SC6','C6_QTDVEN'))			,;	// QUANTIDADE TOTAL DOS ITENS
						 aInfCabec[oBrwCabec:nAt,06] + " - "+ ALLTRIM(aInfCabec[oBrwCabec:nAt,12])		,;	// LOJA DE ORIGEM
						 aInfCabec[oBrwCabec:nAt,07] + " - "+ ALLTRIM(aInfCabec[oBrwCabec:nAt,11])		,;	// VENDEDOR - CODIGO + NOME
						 DTOC(STOD(aInfCabec[oBrwCabec:nAt,08]))											,;	// DATA DA EMISSAO DO PEDIDO
						 DTOC(STOD(aInfCabec[oBrwCabec:nAt,09]))											,;	// DATA DA ENTREGA DO PEDIDO
						 aInfCabec[oBrwCabec:nAt,10] 													,;	// NUMERO DO ATENDIMENTO NO SAC
}}
oBrwCabec:Align:=CONTROL_ALIGN_ALLCLIENT  
oBrwCabec:bChange:={|| FILITENS(aInfcabec[oBrwCabec:nAt]) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O PAINEL COM OS ITENS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPnlItens:= TPanel():New(165,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,150, .T., .F. )
oPnlItens:NCLRPANE:=RGB(220,220,220)

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC       
@ 170,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 170,595 SAY "Disponivel para Agendamento" OF oPnlScroll Font oFnt  PIXEL

@ 190,585 BITMAP oBmpPed1 ResName "BR_AZUL" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 190,595 SAY "Aguardando Compras" OF oPnlScroll Font oFnt  PIXEL

@ 210,585 BITMAP oBmpPed2 ResName "BR_BRANCO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 210,595 SAY "Produto Agendado" OF oPnlScroll Font oFnt PIXEL

@ 230,585 BITMAP oBmpPed2 ResName "BR_VERMELHO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 230,595 SAY "Aguardo Avaliação Técnica" OF oPnlScroll Font oFnt PIXEL

@ 250,585 BITMAP oBmpPed3 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 250,595 SAY "Separação Estoque" OF oPnlScroll Font oFnt PIXEL   

@ 270,585 BITMAP oBmpPed3 ResName "BR_CINZA" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 270,595 SAY "Em Entrega" OF oPnlScroll Font oFnt PIXEL

@ 290,585 BITMAP oBmpPed3 ResName "BR_PRETO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 290,595 SAY "Entregue ao Cliente" OF oPnlScroll Font oFnt PIXEL 

@ 310,585 BITMAP oBmpPed3 ResName "BR_MARROM" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 310,595 SAY "Devolução / Troca" OF oPnlScroll Font oFnt PIXEL

// MONTA O BROWSE COM OS DETALHES DO PEDIDO

oBrwItens:= TWBrowse():New(090,005,390,200,,{"","Item","Código","Descrição","Qtde","Armazem","Valor Unitário","Valor Total","Data Prevista Entrega Cliente","Data Prevista Entrega Fornecedor","Ordem_Producao","Dt_Entrega_OP"},,oPnlItens,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwItens:SetArray(aInfItens)


//LEGENDAS
//TIPO 1 - oSt4 - "BR_VERDE" "Disponivel para Agendamento"
//TIPO 2 - oSt5 - "BR_AZUL" "Aguardando Compras"  
//TIPO 3 - oStA - "BR_BRANCO"  "Produto Agendado" 
//TIPO 4 - oSt3 - "BR_VERMELHO" "Aguardo Avaliação Técnica"
//TIPO 5 - oSt8 - "BR_CINZA" "Em Entrega"
//TIPO 6 - oSt9 - "BR_PRETO" "Entregue ao Cliente"
//TIPO 7 - oSt7 - "BR_AMARELO" "Em separação"
//oSt0 - BR_MARROM "Devolução / Troca"

//oBrwItens:bLine := {|| {oCor												,;	// LEGENDA
oBrwItens:bLine := {|| { IF(aInfItens[oBrwItens:nAt,01] == "1",oSt4,(IF(aInfItens[oBrwItens:nAt,01] == "2",oSt5,(IF(aInfItens[oBrwItens:nAt,01] == "3",oStA,(IF(aInfItens[oBrwItens:nAt,01] == "4",oSt3,(IF(aInfItens[oBrwItens:nAt,01] == "5",oSt8,(IF(aInfItens[oBrwItens:nAt,01] == "6",oSt9,(IF(aInfItens[oBrwItens:nAt,01] == "7",oSt7,oSt0))))))))))))) ,;
						 ALLTRIM(aInfItens[oBrwItens:nAt,02]) 										,;	// ITEM DO PEDIDO DE VENDA
						 ALLTRIM(aInfItens[oBrwItens:nAt,03]) 										,;	// CODIGO DO PRODUTO
						 ALLTRIM(aInfItens[oBrwItens:nAt,04]) 										,;	// DESCRICAO
						 Transform(aInfItens[oBrwItens:nAt,06] ,PesqPict('SC6','C6_QTDVEN')) 		,;	// QUANTIDADE VENDIDA
						 ALLTRIM(aInfItens[oBrwItens:nAt,05]) 										,;	// ARMAZEM DE SAIDA
						 Transform(aInfItens[oBrwItens:nAt,07] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR UNITARIO
						 Transform(aInfItens[oBrwItens:nAt,08] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR TOTAL
						 DTOC(STOD(aInfItens[oBrwItens:nAt,09])) 										,;	// DATA ENTREGA CLIENTE
						 DTOC(STOD(aInfItens[oBrwItens:nAt,10])) 										,;	// DATA ENTREGA FORNECEDOR
						 ALLTRIM(aInfItens[oBrwItens:nAt,11])											,;	// NUMERO DA OP
						 DTOC(STOD(aInfItens[oBrwItens:nAt,12]))										,;	// DATA ENTREGA OP
		}}                                    
oBrwItens:Align:=CONTROL_ALIGN_ALLCLIENT
                                                                              
ACTIVATE MSDIALOG oTelaFin ON INIT EnchoiceBar( oTelaFin, { || oTelaFin:End() } , { || oTelaFin:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILFIN º Autor ³ Luiz Eduardo F.C.  º Data ³  14/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FILTRA OS DADOS FINANCEIROS DOS PEDIDOS				    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION FILDET()

Local cQuery  := ""
Local nLoop   := 1
Local cStatus := ""
Local cVlrTot := 0
Local cQuant  := 0

cQuery := " SELECT '' AS STS , C5_NUM, C5_NUMTMK, '' AS VALOR , '' AS QTDE, C5_MSFIL, C5_VEND1, C5_EMISSAO, C5_FECENT , C5_01SAC, A3_NOME, FILIAL FROM " + RETSQLNAME("SC5") + " SC5 "
cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON A3_COD = C5_VEND1 "
cQuery += " INNER JOIN SM0010 SM0 ON FILFULL = C5_MSFIL "
cQuery += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' "
cQuery += " AND C5_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND C5_LOJACLI = '" + SA1->A1_LOJA + "' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SA3.D_E_L_E_T_ = ' ' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aInfCabec[1,2])
		aInfCabec := {}
	EndIF
	
	aAdd( aInfCabec, { TRB->STS , TRB->C5_NUM , TRB->C5_NUMTMK, TRB->VALOR, TRB->QTDE , TRB->C5_MSFIL, TRB->C5_VEND1, TRB->C5_EMISSAO, TRB->C5_FECENT , TRB->C5_01SAC, TRB->A3_NOME, TRB->FILIAL } )
	TRB->(DbSkip())
EndDo

aSort(aInfCabec,,,{ |x,y| y[8] > x[8] } )//#AFD201800601.N

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

For nX:=1 To Len(aInfCabec)
	cQuery := ""
	cQuery := " SELECT * FROM " + RETSQLNAME("SC6")
	cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") +  "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_NUM = '" + aInfCabec[nX,2] + "' "
	cQuery += " AND C6_CLI = '" + SA1->A1_COD + "' "
	cQuery += " AND C6_LOJA = '" + SA1->A1_LOJA + "' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.) 
	
	cStatus := "1"
	
	While TRB->(!EOF())
		
		IF TRB->C6_01STATU <> "1"
			cStatus := "2"
		EndIF
		
		cVlrTot := cVlrTot + TRB->C6_VALOR
		cQuant  := cQuant + TRB->C6_QTDVEN
		
		TRB->(DbSkip())
	EndDo
	
	aInfCabec[nX,1] := cStatus
	aInfCabec[nX,4] := cVlrTot
	aInfCabec[nX,5] := cQuant
	
	cVlrTot := 0
	cQuant  := 0
	cStatus := ""
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILITENS º Autor ³ Luiz Eduardo F.C.  º Data ³  21/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FILTRA OS ITENS DO CHAMADO                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION FILITENS(aDados)

Local cQuery    := ""   
Local cDescAss  := ""  
Local cDescProd := ""
Local cDescOcor := ""
Local cDescTpAc := ""
Local cNomeOper := ""

aInfItens := {{"","","","",0,"",0,0,"","","",""}}

cQuery := " SELECT DISTINCT C6_01STATU, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_LOCAL, C6_QTDVEN, C6_PRCVEN, C6_XDTFORN, C6_VALOR, C6_ENTREG, '' AS DT_ENTREGA_FOR, "
cQuery += " C2_NUM AS ORDEM_PRODUCAO,C2_DATPRF AS ENTREGA_OP " 
cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " LEFT JOIN SC2010 SC2  ON C2_PEDIDO = C6_NUM AND SC2.D_E_L_E_T_='' "
cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
cQuery += " AND SC6.D_E_L_E_T_ = '  ' " 
cQuery += " AND C6_CLI = '" + SA1->A1_COD + "' "
cQuery += " AND C6_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " AND C6_NUM = '" + aDados[2] + "' "
                                                                 
If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)        

While TMP->(!EOF())  
	IF EMPTY(aInfItens[1,2])
		aInfItens := {}
	EndIF
					  //     1                2              3               4               5                6               7             8             9                  10               11  apresenta somente kmh                                     12
	aAdd( aInfItens , { TMP->C6_01STATU, TMP->C6_ITEM, TMP->C6_PRODUTO, TMP->C6_DESCRI, TMP->C6_LOCAL, TMP->C6_QTDVEN, TMP->C6_PRCVEN, TMP->C6_VALOR, TMP->C6_ENTREG, TMP->C6_XDTFORN, IIf("KMH"$TMP->C6_PRODUTO,TMP->ORDEM_PRODUCAO,""), IIf("KMH"$TMP->C6_PRODUTO,TMP->ENTREGA_OP,"")} )	
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

oBrwItens:AARRAY := aInfItens
oBrwItens:REFRESH()

RETURN()