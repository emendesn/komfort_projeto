#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYTMOV09 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  21/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA DE MONITOR DE CLIENTES - PENDENCIAS FINANCEIRAS PEDIDOบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYTMOV09(cCliente,cLjCli)

Local cQuery  	:= ""
Local cStatus 	:= ""
Local aButtons  := {}    
Local aSize     := MsAdvSize()
Local oSt1      := LoadBitmap(GetResources(),'BR_VERDE')
Local oSt2      := LoadBitmap(GetResources(),'BR_AMARELO')
Local oSt3      := LoadBitmap(GetResources(),'BR_VERMELHO')   
Local oTelaFin 
Local oFnt               
Local oLogo
Local oPnlInfo, oPlnCabec, oPnlItens
Local oBmpPed1 , oBmpPed2 , oBmpPed3 
Local oBrwCabec 
Local oScroll, oPnlScroll

Private aInfCabec := {{"1" , "" , "", 0, "", ""}}  
Private aInfItens := {{"","","","","","","","",0}}
Private oBrwItens

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ POSICIONA NO CLIENTE INFORMADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cCliente + cLjCli)) 

FwMsgRun( ,{|| FILDET() }, , "Filtrando status financeiro dos pedidos , por favor aguarde..." )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA PRINCIPAL DO MONITORAMENTO DE CLIENTE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTelaFin FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Pendencias Financeiras dos Pedidos" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTelaFin:lEscClose := .F.      

oScroll := TScrollArea():New(oTelaFin,000,000,000,000,.T.,.T.,.T.)
oScroll:Align := CONTROL_ALIGN_ALLCLIENT

//@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 2150,2150 //#AFD201800601.O
@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 600,320 //#AFD201800601.N
oScroll:SetFrame( oPnlScroll )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES GERAIS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlInfo:= TPanel():New(005,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,655,045, .T., .F. )
oPnlInfo:NCLRPANE:=RGB(220,220,220) 

// TRAZ O LOGO DA KOMFORT HOSUE
@ 005,590 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oPnlInfo PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.       

@ 005,005 Say "Informa็๕es pendencias fincanceiras dos pedidos" 								Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlInfo
@ 017,005 Say "Cliente : " + ALLTRIM(SA1->A1_COD) + " - " + ALLTRIM(SA1->A1_NOME)				Size 200,010 Font oFnt 					Pixel Of oPnlInfo
@ 029,005 Say "Total de Pedidos : " + Transform(Len(aInfCabec) ,"@E 999")						Size 600,020 Font oFnt 					Pixel Of oPnlInfo  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA O PAINEL COM OS CABECALHOS ณ                                                                 	
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPlnCabec:= TPanel():New(055,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,100, .T., .F. ) 
oPlnCabec:NCLRPANE:=RGB(220,220,220)     

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 065,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 065,595 SAY "Pago" OF oPnlScroll Font oFnt  PIXEL

@ 085,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 085,595 SAY "A pagar" OF oPnlScroll Font oFnt PIXEL

@ 105,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 105,595 SAY "Vencido" OF oPnlScroll Font oFnt PIXEL       

oBrwCabec:= TWBrowse():New(000,000,000,000,,{"","Pedido","Dt.Emissใo","Valor","Loja Origem"},,oPlnCabec,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwCabec:SetArray(aInfCabec)
oBrwCabec:bLine := {|| { IF(aInfCabec[oBrwCabec:nAt,01] == "1",oSt1,IF(aInfCabec[oBrwCabec:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aInfCabec[oBrwCabec:nAt,02] 													,;	// PEDIDO
DTOC(STOD(aInfCabec[oBrwCabec:nAt,03]))										,;	// DATA DE EMISSAO DO PEDIDO
Transform(aInfCabec[oBrwCabec:nAt,04] ,PesqPict('SC6','C6_VALOR'))				,;	// VALOR TOTAL DO PEDIDO
aInfCabec[oBrwCabec:nAt,05]  + " - " + ALLTRIM(aInfCabec[oBrwCabec:nAt,06]) 	,;	// LOJA DE ORIGEM
}}
oBrwCabec:Align:=CONTROL_ALIGN_ALLCLIENT  
oBrwCabec:bChange:={|| FILITENS(aInfcabec[oBrwCabec:nAt]) } 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA O PAINEL COM OS ITENS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlItens:= TPanel():New(165,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,150, .T., .F. ) 
oPnlItens:NCLRPANE:=RGB(220,220,220)    

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 195,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 195,595 SAY "Pago" OF oPnlScroll Font oFnt  PIXEL

@ 215,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 215,595 SAY "A pagar" OF oPnlScroll Font oFnt PIXEL

@ 235,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 235,595 SAY "Vencido" OF oPnlScroll Font oFnt PIXEL   

// MONTA O BROWSE COM OS DETALHES DO PEDIDO - FINANCEIRO
oBrwItens:= TWBrowse():New(090,005,390,200,,{"","N๚mero","Prefixo","Parcela","Tipo","Natureza","Dt.Emissใo","Dt.Vencimento Real","Valor"},,oPnlItens,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwItens:SetArray(aInfItens)
oBrwItens:bLine := {|| { IF(aInfItens[oBrwItens:nAt,01] == "1",oSt1,IF(aInfItens[oBrwItens:nAt,01] == "2",oSt2,oSt3)) 							,;	// LEGENDA   
aInfItens[oBrwItens:nAt,02] 													,;	// NUMERO DO TITULO
aInfItens[oBrwItens:nAt,03] 													,;	// PREFIXO
aInfItens[oBrwItens:nAt,04] 													,;	// PARCELA
aInfItens[oBrwItens:nAt,05] 													,;	// TIPO
aInfItens[oBrwItens:nAt,06] 													,;	// NATUREZA
DTOC(STOD(aInfItens[oBrwItens:nAt,07]))										,;	// DATA DE EMISSAO
DTOC(STOD(aInfItens[oBrwItens:nAt,08]))										,;	// DATA VENCIMENTO REAL
Transform(aInfItens[oBrwItens:nAt,09] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR
}}
oBrwItens:Align:=CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oTelaFin ON INIT EnchoiceBar( oTelaFin, { || oTelaFin:End() } , { || oTelaFin:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILFIN บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  14/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS DADOS FINANCEIROS DOS PEDIDOS				    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILDET()

Local cQuery  := ""
Local cStatus := "1"

cQuery := " SELECT E1_PEDIDO, E1_EMISSAO, SUM(E1_VALOR) AS VALOR , E1_MSFIL, FILIAL FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " INNER JOIN SM0010 ON FILFULL = E1_MSFIL "
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_PEDIDO <> ' '  "
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " GROUP BY E1_PEDIDO, E1_EMISSAO, E1_MSFIL, FILIAL "
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
	
	aAdd( aInfCabec, { "1" , TRB->E1_PEDIDO, TRB->E1_EMISSAO, TRB->VALOR , TRB->E1_MSFIL, TRB->FILIAL } )
	
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VERIFICANDO OS DADOS SELECIONADOS PARA ATUALIZAR OS STATUS DO MESMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX:=1 To Len(aInfCabec)
	cQuery := ""
	cQuery := " SELECT (CASE WHEN E1_SALDO = 0 THEN '1' ELSE "
	cQuery += " CASE WHEN E1_VENCREA >= '" + DtoS(dDataBase) + "' THEN '2' ELSE  "
	cQuery += " CASE WHEN  E1_VENCREA < '" + DtoS(dDataBase) + "' AND E1_SALDO <> 0 THEN '3' "
	cQuery += " END END END) AS SITUACAO "
	cQuery += " FROM" + RETSQLNAME("SE1")
	cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND E1_PEDIDO = '" + aInfCabec[nX,2] + "'
	cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
	cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	
	While TMP->(!EOF())
		IF TMP->SITUACAO == "1" .AND. cStatus = "1"
			cStatus := "1"
		ElseIF TMP->SITUACAO == "2" .AND. cStatus <> "2"
			cStatus := "2"
		ElseIF TMP->SITUACAO == "3"
			cStatus := "3"
			Exit
		EndIF
		TMP->(DbSkip())
	EndDo
	
	aInfCabec[nX,1] := cStatus
	cStatus 	    := "1"
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILITENS บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  21/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS ITENS DO CHAMADO           	    			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILITENS(aDados)

Local cQuery    := ""   
Local cDescAss  := ""  
Local cDescProd := ""
Local cDescOcor := ""
Local cDescTpAc := ""
Local cNomeOper := ""

aInfItens := {{"","","","","","","","",0}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FILTRA OS DADOS NO SE1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_EMISSAO, E1_VENCREA, E1_VALOR, "
cQuery += " (CASE WHEN E1_SALDO = 0 THEN '1' ELSE "
cQuery += " CASE WHEN E1_VENCREA >= '" + DtoS(dDataBase) + "' THEN '2' ELSE  "
cQuery += " CASE WHEN  E1_VENCREA < '" + DtoS(dDataBase) + "' AND E1_SALDO <> 0 THEN '3' "
cQuery += " END END END) AS SITUACAO "
cQuery += " FROM" + RETSQLNAME("SE1")
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND E1_PEDIDO = '" + aDados[2] + "'
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

While TMP->(!EOF())  
	IF EMPTY(aInfItens[1,2])
		aInfItens := {}
	EndIF
					
	aAdd( aInfItens , { TMP->SITUACAO, TMP->E1_NUM, TMP->E1_PREFIXO, TMP->E1_PARCELA, TMP->E1_TIPO, TMP->E1_NATUREZ, TMP->E1_EMISSAO, TMP->E1_VENCREA, TMP->E1_VALOR } )	
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

oBrwItens:AARRAY := aInfItens
oBrwItens:REFRESH()

RETURN()