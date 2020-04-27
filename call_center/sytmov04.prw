#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYTMOV04 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  21/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ BUSCA OS ITENS DO PEDIDO INFORMADO                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYTMOV04()

Local cQuery   := ""
Local oOk	   := LoadBitMap(GetResources(), "LBOK")
Local oNo	   := LoadBitMap(GetResources(), "LBNO")
Local oItPed, oBtnSair, oBrwItPed

Private aItPed   := {}
Private cMascara := "Desmarcar Todos"
Private oBtnMark

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDA PARA A ROTINA SO SER CHAMADA DO FOLDER DO SAC ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nFolder <> 1
	MsgAlert("Esta rotina deve ser acessada somente no SAC.","Aten็ใo")
	RETURN()
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDA SE O CAMPO DE PEDIDO DE VENDA ESTA PREENCHIDO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF EMPTY(M->UC_01PED) .OR. EMPTY(M->UC_CODCONT)
	MsgAlert("Campo [Pedido de Venda] ou campo [Contato] em branco, por favor preencha!","Aten็ใo")
	RETURN()
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A QUERY PARA FILTRAR OS ITENS DO PEDIDO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT * FROM " + RETSQLNAME("SC6")
cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND C6_NUM = '" + RIGHT(M->UC_01PED,6) + "' "
cQuery += " AND C6_MSFIL = '" + LEFT(M->UC_01PED,4) + "' "
//cQuery += " AND C6_NOTA <> ' ' "
cQuery += " ORDER BY C6_FILIAL,C6_NUM,C6_ITEM"

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	aAdd( aItPed, { .F. ,;
	 				TRB->C6_ITEM,;
					TRB->C6_PRODUTO,; 
					TRB->C6_DESCRI,; 
					TRB->C6_UM,; 
					TRB->C6_QTDVEN,; 
					TRB->C6_PRCVEN,; 
					TRB->C6_VALOR ,; 
					TRB->C6_LOCAL,; 
					TRB->C6_NUMTMK,; 
					TRB->C6_DTAGEND,; 
					TRB->C6_ENTREG,; 
					TRB->C6_NOTA,;
					TRB->C6_SERIE,;
					iif(Posicione('SB1',1,xFilial('SB1')+TRB->C6_PRODUTO,'B1_01FORAL')=="F","SIM","NรO"),;
					"" } )
	TRB->(DbSkip())
EndDo
TRB->(DbCloseArea())  

If(!EMPTY(M->UC_CODCONT))  
	U_TK272PFIN(M->UC_CODCONT)//Cliente com pendencia financeira serแ emitido o alerta informado no gatilho do campo UC_CODCONT. Marcio Nunes - Chamado: 11114
EndIf

If Len(aItPed) > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MONTA A TELA COM OS ITENS DO PEDIDO SELECIONADO ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oItPed FROM 0,0 TO 360,1000 TITLE "Itens do Pedido" Of oMainWnd PIXEL
	
	oItPed:lEscClose := .F.
	
	@ 005, 005 Say "Escolha os Status : " Size 100,010 Pixel Of oItPed
	
	oBrwItPed:= TWBrowse():New(015,005,495,140,,{"","Nota Fiscal","S้rie","Item","Fora de Linha","Cod.Produto","Produto","Un.Medida","Qtde.Venda","Prc.Venda","Vlr.Total","Armz.","Orc.TMK","Dt.Agendamento","Dt.Prevista Entrega","Dt.Efetiva Entrega"},,oItPed,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrwItPed:SetArray(aItPed)
	oBrwItPed:bLine := {|| { 	If(aItPed[oBrwItPed:nAt,01],oOK,oNO)									,;	// CHECK BOX 015666
	aItPed[oBrwItPed:nAt,13] 											,;	// NOTA FISCAL
	aItPed[oBrwItPed:nAt,14] 											,;	// SERIE
	aItPed[oBrwItPed:nAt,02] 											,;	// ITEM DO PRODUTO DO PEDIDO
	aItPed[oBrwItPed:nAt,15] 											,;	// FORA DE LINHA
	aItPed[oBrwItPed:nAt,03] 											,;	// CODIGO DO PRODUTO
	alltrim(aItPed[oBrwItPed:nAt,04])									,;	// DESCRICAO DO PRODUTO
	aItPed[oBrwItPed:nAt,05] 											,;	// UNIDADE DE MEDIDA
	Transform(aItPed[oBrwItPed:nAt,06],PesqPict('SC6','C6_QTDVEN'))	,;	// QUANTIDADE VENDIDA
	Transform(aItPed[oBrwItPed:nAt,07],PesqPict('SC6','C6_PRCVEN'))	,;	// PRECO DE VENDA
	Transform(aItPed[oBrwItPed:nAt,08],PesqPict('SC6','C6_VALOR'))		,;	// PRECO TOTAL
	aItPed[oBrwItPed:nAt,09] 											,;	// ARMAZEM DE SAIDA DO PRODUTO
	aItPed[oBrwItPed:nAt,10] 											,;	// NUMERO DO CHAMADO DO TELEMARKETING
	DTOC(STOD(aItPed[oBrwItPed:nAt,11]))								,;	// DATA DE AGENDAMENTO DO ITEM DO PEDIDO
	DTOC(STOD(aItPed[oBrwItPed:nAt,12]))								,;	// DATA DE ENTREGA DO ITEM DO PEDIDO
	DTOC(POSICIONE("SF2",1,LEFT(M->UC_01PED,4)+aItPed[oBrwItPed:nAt,13]+aItPed[oBrwItPed:nAt,14],"F2_DTENTR"))								,;	// DATA DA ENTREGA EFETIVA DA NOTA FISCAL
	}}
	
	oBrwItPed:bLDblClick := {|| ( aItPed[oBrwItPed:nAt,1] := !aItPed[oBrwItPed:nAt,1] , oBrwItPed:Refresh() ) }
	
	oBtnOK:= TButton():New( 160,075, "OK" , oItPed , {||},065,012, , , , .T. , , , , { ||})
	oBtnOK:BLCLICKED:= {|| CARDADOS(), oItPed:End() }
	
	oBtnSair:= TButton():New( 160,145, "Sair" , oItPed , {||},065,012, , , , .T. , , , , { ||})
	oBtnSair:BLCLICKED:= {|| lFinaliza := .F., oItPed:End() }
	
	oBtnMark:= TButton():New( 160,005, "Desmarcar Todos" , oItPed , {||},065,012, , , , .T. , , , , { ||})
	oBtnMark:BLCLICKED:= {|| MarkAll(), oBrwItPed:Refresh()  }
	
	ACTIVATE DIALOG oItPed CENTERED   
	
Else
	
	MsgStop("Nใo existem notas fiscais para este pedido.","Aten็ใo")
	
Endif

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarkAll  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  23/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION MarkAll()

Local nX := 0

If cMascara == "Marcar Todos"
	For nX:=1 To Len(aItPed)
		aItPed[nX,1] := .T.
	Next
	cMascara := "Desmarcar Todos"
Else
	For nX:=1 To Len(aItPed)
		aItPed[nX,1] := .F.
	Next
	cMascara := "Marcar Todos"
EndIF

oBtnMark:CCAPTION := cMascara
oBtnMark:Refresh()

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ CARDADOS บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  23/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ CARREGA OS DADOS DOS ITENS SELECIONADOS PARA A TELA DO SAC บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION CARDADOS()

Local nAtual	:= 0
Local nColuna	:= 0
Local nCont		:= 0 
Local nFreteA	:= 0
Local aAreaSC5  := SC5->(GetArea())
Local aAreaNNR  := NNR->(GetArea())
Local aAreaSA3  := SA3->(GetArea())
Local aAreaSM0  := SM0->(GetArea())
Local aClone    := {}
Local lNtroca	:= .T.
Local lAlert    := .F.

Private nPRODUTO	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_PRODUTO"})
Private nDESCPRO	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_DESCPRO"})
Private n01PRCVE	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01PRCVE"})
Private n01QTDVE	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01QTDVE"})
Private n01VLPED	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01VLPED"})
Private n01UM    	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01UM"})
Private n01LOCAL	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01LOCAL"})
Private n01DTENT	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DTENT"})
Private n01LJORI	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01LJORI"})
Private n01VEND   	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01VEND"})
Private n01DTEMI	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DTEMI"})
Private n01DEFEI	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DEFEI"})
Private n01PEDOR	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01PEDOR"})
Private nCHECKBOX	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "CHECKBOX"})
Private n01DSCLJ	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DSCLJ"})
Private n01NOMVE	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01NOMVE"})
Private n01DESCL	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DESCL"})
Private nSTATUS  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_STATUS"})
Private nUserLog	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_XUSER"}) // Alexis.Duarte 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CRIADO OS CAMPOS DE NOTA FISCAL DE ORIGEM, SERIE DE ORIGEM E ITEM DE ORIGEM - LUIZ EDUARDO F.C. - 03/11/2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private n01NUMNF  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01NUMNF"})
Private n01SERIE  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01SERIE"})
Private n01ITEM  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01ITEM"})    
Private n01DTREA  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_01DTREA"})    

//UD_01DTREA

Private oSt7         := LoadBitmap(GetResources(),'BR_VERMELHO')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SELECIONA O CABECALHO DO PEDIDO INFORMADO - SC5 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SC5")
SC5->(DbOrderNickName("SC5MSFIL"))
SC5->(DbSeek(xFilial("SC5") + RIGHT(M->UC_01PED,6) + LEFT(M->UC_01PED,4) ))

/*
For nX:=1 To Len(aItPed)
IF aItPed[nX,1]
aAdd( aClone , aSvFolder[1][2][1] )
nLen := Len(aClone)
aClone[nLen,nCHECKBOX] := oSt7
aClone[nLen,nPRODUTO]  := aItPed[nX,03]
aClone[nLen,nDESCPRO]  := aItPed[nX,04]
aClone[nLen,n01PRCVE]  := aItPed[nX,07]
aClone[nLen,n01QTDVE]  := aItPed[nX,06]
aClone[nLen,n01VLPED]  := aItPed[nX,08]
aClone[nLen,n01UM]     := aItPed[nX,05]
aClone[nLen,n01LOCAL]  := aItPed[nX,09]
aClone[nLen,n01DTENT]  := STOD(aItPed[nX,12])
aClone[nLen,n01LJORI]  := LEFT(M->UC_01PED,4)
aClone[nLen,n01VEND]   := SC5->C5_VEND1
aClone[nLen,n01DTEMI]  := SC5->C5_EMISSAO
aClone[nLen,n01DEFEI]  := ""
aClone[nLen,n01PEDOR]  := RIGHT(M->UC_01PED,6)
aClone[nLen,n01NOMVE]  := POSICIONE("SA3",1,LEFT(M->UC_01PED,4)+SC5->C5_VEND1,"A3_NOME")
aClone[nLen,n01DESCL]  := POSICIONE("NNR",1,LEFT(M->UC_01PED,4)+aItPed[nX,09],"NNR_DESCRI")
aClone[nLen,n01DSCLJ]  := POSICIONE("SM0",1,LEFT(M->UC_01PED,4),"M0_FILIAL")
EndIF

aAdd( aCols , aClone[nX] )
aClone := {}
Next
*/
If Len(aCols) > 0 .And. !Empty(aCols[1][nPRODUTO])
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega o conteudo o ultimo item (Valor)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nAtual	:= Len(aCols)
Else
	aCols 	:= {}
	nAtual	:= Len(aCols)
Endif


For nCont := 1 to Len(aItPed)
	If aItPed[nCont,1]
		If Len(aCols) == 0
			AADD(aCols,Array(Len(aHeader)+1))
			nAtual++
		ElseIf !Empty(aCols[Len(aCols)][nPRODUTO])
			AADD(aCols,Array(Len(aHeader)+1))
			nAtual++
		EndIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicializa as variaveis da aCols (tratamento para    ณ
		//ณcampos criados pelo usu rio)							ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nColuna := 1 to Len( aHeader )
			
			If aHeader[nColuna][8] == "C"
				aCols[nAtual][nColuna] := Space(aHeader[nColuna][4])
				
			ElseIf aHeader[nColuna][8] == "D"
				aCols[nAtual][nColuna] := dDataBase
				
			ElseIf aHeader[nColuna][8] == "M"
				aCols[nAtual][nColuna] := ""
				
			ElseIf aHeader[nColuna][8] == "N"
				aCols[nAtual][nColuna] := 0
				
			Else
				aCols[nAtual][nColuna] := .F.
			Endif
			
		Next nColuna
		
		aCols[nAtual][Len(aHeader)+1] := .F.
		
		aCols[nAtual,nCHECKBOX] := oSt7
		aCols[nAtual,nPRODUTO]  := aItPed[nCont,03]
		aCols[nAtual,nDESCPRO]  := aItPed[nCont,04]
		           
		//Troca por adapta็ใo subtrai o valor da taxa informada manualmente pelo supervisor da แrea - Marcio Nunes - V1T-Z6T-QDX4 
		For nZ := 1 To Len(aCols)                
			If (aCols[nZ][5] == aCols[nAtual][5]) .And. aCols[nZ][24] == "NCCSAC"      
		   		lNtroca := .F.	//nใo permite gerar desconto novamente para o mesmo produto 	
			EndIf
		Next nZ
													// garante que o usuแrio ้ diferente do supervisor da แrea 
		If !EMPTY(M->UC_01TROCA) .And. Altera .And. (!(LogUserName() == "isaias.gomes") .Or. !(LogUserName() == "alessandra.dossantos")) .And. lNtroca// caso ja exista o desconto nใo serแ aplicado mais para o mesmo produto
											//garante que serแ descontado apenas uma vez o valor do frete pois estแ trazendo do cabe็alho SC5					
			If M->UC_01TRFRE == "1" .And. Empty(nFreteA)
				nFreteA	:= SC5->C5_FRETE //DESCONTA O FRETE DO CLIENTE  
			Else
				nFreteA	:= 0     
			EndIf    
			aCols[nAtual,n01PRCVE]  := aItPed[nCont,07] - ((aItPed[nCont,07]*M->UC_01TROCA)/100) - nFreteA//subtrai o valor em % da taxa de troca por adapta็ใo
		Else
			aCols[nAtual,n01PRCVE]  := aItPed[nCont,07]   		
		EndIf
		aCols[nAtual,n01QTDVE]  := aItPed[nCont,06]       
		If !EMPTY(M->UC_01TROCA) .And. Altera  .And. (!(LogUserName() == "isaias.gomes") .Or. !(LogUserName() == "alessandra.dossantos")) .And. lNtroca// caso ja exista o desconto nใo serแ aplicado mais para o mesmo produto
			aCols[nAtual,n01VLPED]  := aItPed[nCont,08] - ((aItPed[nCont,07]*M->UC_01TROCA)/100) - nFreteA //subtrai o valor em % da taxa de troca por adapta็ใo
			lAlert := .T.
		Else
			aCols[nAtual,n01VLPED]  := aItPed[nCont,08]		   
		EndIf                                                       
		
		aCols[nAtual,n01UM]     := aItPed[nCont,05]
		aCols[nAtual,n01LOCAL]  := aItPed[nCont,09]
		aCols[nAtual,n01DTENT]  := STOD(aItPed[nCont,12])
		aCols[nAtual,n01LJORI]  := LEFT(M->UC_01PED,4)
		aCols[nAtual,n01VEND]   := SC5->C5_VEND1
		aCols[nAtual,n01DTEMI]  := SC5->C5_EMISSAO
		aCols[nAtual,n01DEFEI]  := SPACE(06)
		aCols[nAtual,n01PEDOR]  := RIGHT(M->UC_01PED,6)
		aCols[nAtual,n01NOMVE]  := POSICIONE("SA3",1,LEFT(M->UC_01PED,4)+SC5->C5_VEND1,"A3_NOME")
		aCols[nAtual,n01DESCL]  := POSICIONE("NNR",1,LEFT(M->UC_01PED,4)+aItPed[nCont,09],"NNR_DESCRI")
		aCols[nAtual,n01DSCLJ]  := POSICIONE("SM0",1,LEFT(M->UC_01PED,4),"M0_FILIAL")
		aCols[nAtual,nSTATUS ]  := "1"
		aCols[nAtual,nUserLog]	:= LogUserName() // Alexis.Duarte
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ CRIADO OS CAMPOS DE NOTA FISCAL DE ORIGEM, SERIE DE ORIGEM E ITEM DE ORIGEM - LUIZ EDUARDO F.C. - 03/11/2017 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		aCols[nAtual,n01NUMNF]  := aItPed[nCont,13]
		aCols[nAtual,n01SERIE]  := aItPed[nCont,14]
		aCols[nAtual,n01ITEM]   := aItPed[nCont,02]
		aCols[nAtual,n01DTREA]  := POSICIONE("SF2",1,LEFT(M->UC_01PED,4)+aItPed[nCont,13]+aItPed[nCont,14],"F2_DTENTR")
	EndIF
Next

If lAlert
	MsgAlert("Serแ descontado o Percentual de "+ cValToChar(M->UC_01TROCA)+"% + Frete "+cValToChar(nFreteA)+" da troca por adapta็ใo")
EndIF



n := nAtual

If Len(aCols) >= 1
	oGetTmk:oBrowse:Refresh()
Endif

RestArea(aAreaSC5)
RestArea(aAreaNNR)
RestArea(aAreaSA3)
RestArea(aAreaSM0)

RETURN()
