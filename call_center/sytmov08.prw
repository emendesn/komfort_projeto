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
±±ºPrograma  ³ SYTMOV08 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  21/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ TELA DE MONITOR DE CLIENTES - CHAMADOS DO SAC              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYTMOV08(cCliente,cLjCli)

Local cQuery  	:= ""
Local cStatus 	:= ""
Local aButtons  := {}    
Local aSize     := MsAdvSize()
Local oSt1      := LoadBitmap(GetResources(),'BR_VERDE')
Local oSt2      := LoadBitmap(GetResources(),'BR_AMARELO')
Local oSt3      := LoadBitmap(GetResources(),'BR_VERMELHO')  
Local oTelaSAC 
Local oFnt               
Local oLogo
Local oPnlInfo, oPlnCabec, oPnlItens
Local oBmpPed1 , oBmpPed2 , oBmpPed3 
Local oBrwCabec  
Local oScroll, oPnlScroll

Private aInfCabec := {{"1" , "" , "", "", "", "", "", ""}}   
Private aInfItens := {{"1","","","","","","",0,0,"","","","","","","","","",""}}
Private oBrwItens

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POSICIONA NO CLIENTE INFORMADO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cCliente + cLjCli))  

FwMsgRun( ,{|| FILSAC() }, , "Filtrando os chamados do SAC , por favor aguarde..." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA PRINCIPAL DO MONITORAMENTO DE CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTelaSAC FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Monitoramento de Clientes" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTelaSAC:lEscClose := .F.    

oScroll := TScrollArea():New(oTelaSAC,000,000,000,000,.T.,.T.,.T.)
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

@ 005,005 Say "Informações gerais do SAC" 														Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlInfo
@ 017,005 Say "Cliente : " + ALLTRIM(SA1->A1_COD) + " - " + ALLTRIM(SA1->A1_NOME)				Size 200,010 Font oFnt 					Pixel Of oPnlInfo
@ 029,005 Say "Total de Chamados : " + Transform(Len(aInfCabec) ,"@E 999")	Size 600,020 Font oFnt 					Pixel Of oPnlInfo 
                                                                                           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O PAINEL COM OS CABECALHOS DOS CHAMADOS DO SAC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPlnCabec:= TPanel():New(055,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,100, .T., .F. ) 
oPlnCabec:NCLRPANE:=RGB(220,220,220)     

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 065,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 065,595 SAY "Em aberto" OF oPnlScroll Font oFnt  PIXEL

@ 085,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 085,595 SAY "Em processamento" OF oPnlScroll Font oFnt PIXEL

@ 105,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 105,595 SAY "Finalizado" OF oPnlScroll Font oFnt PIXEL         
                                                        
oBrwCabec:= TWBrowse():New(000,000,000,000,,{"","Atendimento","Operador","Nome","Dt.Abertura","Hr.Abertura","Pedido","Loja de Origem do Pedido"},,oPlnCabec,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwCabec:SetArray(aInfcabec)
oBrwCabec:bLine := {|| { 	 IF(aInfcabec[oBrwCabec:nAt,01] == "1",oSt1,IF(aInfcabec[oBrwCabec:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aInfcabec[oBrwCabec:nAt,02] 													,;	// ATENDIMENTO
aInfcabec[oBrwCabec:nAt,03] 													,;	// CODIGO OPERADOR
aInfcabec[oBrwCabec:nAt,04]												   		,;	// NOME DO OPERADOR
DTOC(STOD(aInfcabec[oBrwCabec:nAt,05]))										,;	// DATA DA ABERTURA DO CHAMADO
aInfcabec[oBrwCabec:nAt,06]														,;	// HORA DE ABERTURA DO CHAMADO
aInfcabec[oBrwCabec:nAt,07] 													,;	// NUMERO DO PEDIDO
aInfcabec[oBrwCabec:nAt,08] 													,;	// LOJA DE ORIGEM DO PEDIDO
}}     
oBrwCabec:Align:=CONTROL_ALIGN_ALLCLIENT 
oBrwCabec:bChange:={|| FILITENS(aInfcabec[oBrwCabec:nAt]) } 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA O PAINEL COM OS ITENS DOS CHAMADOS DO SAC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPnlItens:= TPanel():New(165,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,150, .T., .F. ) 
oPnlItens:NCLRPANE:=RGB(220,220,220)    

// MONTA O BROWSE COM OS DETALHES DO PEDIDO - FINANCEIRO
oBrwItens:= TWBrowse():New(090,005,390,200,,{"","Chamado [SAC]","Assunto","Produto","Pedido Original","Qtde.Vendida","Preço","Ocorrencia","Tipo Ação","Defeito","Responsável","OBS WorkFlow","Data Abertura"},,oPnlItens,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwItens:SetArray(aInfItens)
oBrwItens:bLine := {|| { IF(aInfItens[oBrwItens:nAt,01] == "1",oSt1,oSt3) 							,;	// LEGENDA   
ALLTRIM(aInfItens[oBrwItens:nAt,02]) 																,;	// NUMERO DO CHAMADO DO SAC
ALLTRIM(aInfItens[oBrwItens:nAt,03]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,04])				,;	// ASSUNTO - CODIGO + DESCRICAO
ALLTRIM(aInfItens[oBrwItens:nAt,05]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,06])				,;	// PRODUTO - CODIGO + DESCRICAO
ALLTRIM(aInfItens[oBrwItens:nAt,07]) 																,;	// PEDIDO ORIGINAL
Transform(aInfItens[oBrwItens:nAt,08] ,PesqPict('SC6','C6_QTDVEN')) 								,;	// QUANTIDADE VENDIDA NO PEDIDO ORIGINAL
Transform(aInfItens[oBrwItens:nAt,09] ,PesqPict('SC6','C6_VALOR')) 								,;	// PRECO DE VENDA NO PEDIDO ORIGINAL
ALLTRIM(aInfItens[oBrwItens:nAt,10]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,11])				,;	// OCORRENCIA - CODIGO + DESCRICAO
ALLTRIM(aInfItens[oBrwItens:nAt,12]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,13])				,;	// TIPO DE ACAO - CODIGO + DESCRICAO
ALLTRIM(aInfItens[oBrwItens:nAt,14]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,15])				,;	// DEFEITO - CODIGO + DESCRICAO 
ALLTRIM(aInfItens[oBrwItens:nAt,16]) + " - " + ALLTRIM(aInfItens[oBrwItens:nAt,17])				,;	// OPERADOR - CODIGO + DESCRICAO
ALLTRIM(aInfItens[oBrwItens:nAt,18]) 																,;	// OBSERVACAO DO WORKFLOW 
DTOC(STOD(aInfItens[oBrwItens:nAt,19])) 															,;	// DATA DE ABERTURA DO ITEM NO CHAMADO
}}
oBrwItens:Align:=CONTROL_ALIGN_ALLCLIENT  

// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC
@ 195,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 195,595 SAY "Encerrado" OF oPnlScroll Font oFnt  PIXEL

@ 215,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 215,595 SAY "Pendente" OF oPnlScroll Font oFnt PIXEL         

ACTIVATE MSDIALOG oTelaSAC ON INIT EnchoiceBar( oTelaSAC, { || oTelaSAC:End() } , { || oTelaSAC:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILSAC º Autor ³ Luiz Eduardo F.C.  º Data ³  14/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FILTRA OS CHAMADOS NO SAC DO CLIENTE					    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION FILSAC()

Local cQuery  := ""
Local cStatus := ""

cQuery := " SELECT UC_STATUS, UC_CODIGO, UC_OPERADO, U7_NOME, UC_DATA, UC_INICIO, UC_01PED, FILIAL FROM " + RETSQLNAME("SUC") + " SUC "
cQuery += " INNER JOIN " + RETSQLNAME("SU7") + " SU7 ON U7_COD = UC_OPERADO "
//cQuery += " INNER JOIN SM0010 ON FILFULL = LEFT(UC_01PED,4) "
// ALTEREI A QUERY PARA QUE PEGASSE A FILIAL DE ORIGEM DO CAMPO UC_MSFIL - LUIZ EDUARDO F.C. - 19.05.2017
cQuery += " INNER JOIN SM0010 ON FILFULL = UC_MSFIL "
cQuery += " WHERE SUC.UC_FILIAL = '" + XFILIAL("SUC") + "' "
cQuery += " AND SUC.D_E_L_E_T_ = ' ' "
cQuery += " AND SU7.D_E_L_E_T_ = ' ' "
cQuery += " AND UC_CHAVE = '" + SA1->A1_COD + SA1->A1_LOJA + "' "
cQuery += " ORDER BY UC_DATA DESC "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aInfCabec[1,2])
		aInfCabec := {}
	EndIF
	
	aAdd( aInfCabec, { IF(ALLTRIM(TRB->UC_STATUS)=="2","1","3"), TRB->UC_CODIGO, TRB->UC_OPERADO, TRB->U7_NOME, TRB->UC_DATA, TRB->UC_INICIO, RIGHT(TRB->UC_01PED,6) , TRB->FILIAL } )
	
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICANDO OS DADOS SELECIONADOS PARA ATUALIZAR OS STATUS DO MESMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 To Len(aInfCabec)
	IF aInfCabec[nX,1] == "1"
		cQuery := ""
		cQuery := " SELECT UD_STATUS FROM " + RETSQLNAME("SUD")
		cQuery += " WHERE UD_FILIAL = '" + XFILIAL("SUD") + "' "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery += " AND UD_CODIGO = '" + aInfCabec[nX,2] + "' "
		
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
		
		While TMP->(!EOF())
			IF TMP->UD_STATUS == "1"
				cStatus := "1"
			ElseIF TMP->UD_STATUS == "2"
				cStatus := "2"
				Exit
			EndIF
			TMP->(DbSkip())
		EndDo
		
		aInfCabec[nX,1]   := cStatus
		cStatus 	 := ""
		
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
	EndIF
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILITENS º Autor ³ Luiz Eduardo F.C.  º Data ³  21/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FILTRA OS ITENS DO CHAMADO           	    			  º±±
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

aInfItens := {{"1","","","","","","",0,0,"","","","","","","","","",""}}  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FILTRA OS DADOS NO SUD ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT UD_STATUS, UD_ASSUNTO, '' AS DESC_ASSUNTO, UD_PRODUTO, '' AS DESC_PRODUTO, UD_01PEDID, UD_01QTDVE, UD_01PRCVE, UD_OCORREN, '' AS DESC_OCORREN, "
cQuery += " UD_01TIPO, '' AS DESC_TIPO, UD_01DEFEI, UD_01DESDE, UD_OPERADO, '' AS DESC_OPERADO, UD_OBSWKF, UD_DATA  FROM " + RETSQLNAME("SUD")
cQuery += " WHERE UD_FILIAL = '" + XFILIAL("SUD") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND UD_CODIGO ='" + aDados[2] + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

While TMP->(!EOF())  
	IF EMPTY(aInfItens[1,2])
		aInfItens := {}
	EndIF 
	
	cDescAss  := POSICIONE("SX5",1,XFILIAL("SX5") + "T1" + TMP->UD_ASSUNTO,"X5_DESCRI")
	cDescProd := POSICIONE("SB1",1,XFILIAL("SB1") + TMP->UD_PRODUTO,"B1_DESC")          
	cDescOcor := POSICIONE("SU9",1,XFILIAL("SU9") + TMP->UD_ASSUNTO + TMP->UD_OCORREN,"U9_DESC") 
	cDescTpAc := POSICIONE("Z01",1,XFILIAL("Z01") + TMP->UD_01TIPO,"Z01_DESC")    
	cNomeOper := POSICIONE("SU7",1,XFILIAL("Z01") + TMP->UD_OPERADO,"U7_NOME")          
	                                                                                                                          	
	aAdd( aInfItens , { TMP->UD_STATUS, aDados[2] , TMP->UD_ASSUNTO, cDescAss, TMP->UD_PRODUTO, cDescProd, TMP->UD_01PEDID, TMP->UD_01QTDVE, TMP->UD_01PRCVE, TMP->UD_OCORREN, cDescOcor, TMP->UD_01TIPO, cDescTpAc, TMP->UD_01DEFEI, TMP->UD_01DESDE, TMP->UD_OPERADO, cNomeOper, TMP->UD_OBSWKF, TMP->UD_DATA} )	
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf    

oBrwItens:AARRAY := aInfItens
oBrwItens:REFRESH()

RETURN()