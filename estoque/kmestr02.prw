#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

User Function KMESTR02()

Local aSize		:= MsAdvSize()
Local aPosObj   := {}
Local aObjects  := {}
Local aInfo     := {}
Local cPerg	 	:= Padr("KMESTR02",10)
Local nOpc		:= 0
Local oFont1 	:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
Local oLogo

Private _cQuery  := ""
Private aRegs1 	 := {}
Private aHead2 	 := {}
Private aCols2	 := {}
Private oGetD1
Private oGetD2
Private aHead3 	 := {}
Private aCols3	 := {}
Private oGetD3
Private aHead4 	 := {}
Private aCols4	 := {}
Private oGetD4
Private aButtons := {}
Private oOk := LoadBitmap(GetResources(),'BR_VERDE')
Private oNok := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oNad := LoadBitmap(GetResources(),'BR_AMARELO')
Private oTela, oPanel1, oPanel2
Private nVlrTot  := 0
Private nVlrRA   := 0
Private nVlrCR   := 0
Private nVlrCX   := 0
Private nVlrConf := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
//AAdd( aObjects, { 100, 100, .T., .F. } )
//AAdd( aObjects, { 100, 015, .T., .F. } )
AAdd( aObjects, { 033, 033, .F., .T. } )
AAdd( aObjects, { 033, 033, .T., .F. } )
AAdd( aObjects, { 033, 033, .T., .F. } )

//aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 4 }
aPosObj := MsObjSize( aInfo, aObjects )
//aPosObj[1][3] := 230

AjustaSx1(cPerg)

IF !Pergunte(cPerg,.T.)
	Return
EndIF

FwMsgRun( ,{|| FILDADOS()   }, , "Filtrando Dados, por favor aguarde..." )

If Len(aRegs1) > 0
	
	//	CarregaVdas()
	
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Notas de Transfer๊ncia" Of oMainWnd PIXEL
	
	//@ 005,005 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oTela PIXEL NOBORDER
	//oLogo:LAUTOSIZE    := .F.
	//oLogo:LSTRETCH     := .T.
	
	oFWLayerItens:= FwLayer():New()
	oFWLayerItens:Init(oTela,.T.)
	
	oFWLayerItens:addLine("ORวAMENTOS", 35, .F.)
	oFWLayerItens:addCollumn( "COL1",100,.F.,"ORวAMENTOS")
	oFWLayerItens:addWindow ( "COL1","WIN1","Or็amentos",100,.T.,.F.,,"ORวAMENTOS")
	
	oPanel1:= oFWLayerItens:GetWinPanel("COL1","WIN1","ORวAMENTOS")
	
	oGetD1 := TwBrowse():New(0,0,0,0,,{" ","Filial","Desc. Filial","Or็amento","Pedido","Emissใo","Cod. Cliente","Nome Cliente"},,oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oGetD1:Align        := CONTROL_ALIGN_ALLCLIENT
	oGetD1:lColDrag		:= .T.
	oGetD1:SetArray(aRegs1)
	oGetD1:bLine		:= { || {Iif(ALLTRIM(aRegs1[oGetD1:nAt,1])=='1',oOk,IIF(ALLTRIM(aRegs1[oGetD1:nAt,1])=='2',oNok,oNad)),;
	ALLTRIM(aRegs1[oGetD1:nAt,2]),;
	ALLTRIM(aRegs1[oGetD1:nAt,3]),;
	ALLTRIM(aRegs1[oGetD1:nAt,4]),;
	ALLTRIM(aRegs1[oGetD1:nAt,5]),;
	DtoC(StoD(aRegs1[oGetD1:nAt,6])),;
	ALLTRIM(aRegs1[oGetD1:nAt,7]),;
	ALLTRIM(aRegs1[oGetD1:nAt,8])}}
	
	oGetD1:bChange		:= { || CargDados(aRegs1[oGetD1:nAt,2],aRegs1[oGetD1:nAt,4]) }
	
	oFWLayerItens:addLine("DADOS", 50, .F.)
	oFwLayerItens:addCollumn( "COL1", 33, .F. , "DADOS")
	oFwLayerItens:addCollumn( "COL2", 33, .F. , "DADOS")
	oFwLayerItens:addCollumn( "COL3", 33, .F. , "DADOS")
	
	oFwLayerItens:addWindow(  "COL1", "WIN1", "Pedido"	, 100, .T., .F., , "DADOS")
	oFwLayerItens:addWindow(  "COL2", "WIN2", "Nf Saํda"		, 100, .T., .T., , "DADOS")
	oFwLayerItens:addWindow(  "COL3", "WIN3", "Nf Entrada"		, 100, .T., .T., , "DADOS")
	
	oPanel2:= oFWLayerItens:GetWinPanel("COL1","WIN1","DADOS")
	
	oGetD2:= TwBrowse():New(0,0,0,0,, {" ","Filial","Pedido","Item","Produto","Qtd","NF","Serie","Chv"},,oPanel2,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oGetD2:SetArray(aCols2)
	
	oGetD2:bLine := {|| { 	IIF(AllTrim(aCols2[oGetD2:nAt,01])=='1',oOk,IIF(Alltrim(aCols2[oGetD2:nAt,01])=='2',oNok,oNad)) ,;
	aCols2[oGetD2:nAt,02] ,;
	aCols2[oGetD2:nAt,03] ,;
	aCols2[oGetD2:nAt,04] ,;
	aCols2[oGetD2:nAt,05] ,;
	ALLTRIM(Transform(aCols2[oGetD2:nAt,06],"@E 999,999,999.99")) ,;
	aCols2[oGetD2:nAt,07] ,;
	aCols2[oGetD2:nAt,08] ,;
	aCols2[oGetD2:nAt,09] }}
	oGetD2:Align:= CONTROL_ALIGN_ALLCLIENT
	
	
	oPanel3:= oFWLayerItens:GetWinPanel("COL2","WIN2","DADOS")
	
	oGetD3:= TwBrowse():New(0,0,0,0,, {" ","Filial","NF","Serie","Item","Produto","Qtd"},,oPanel3,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oGetD3:SetArray(aCols3)
	
	oGetD3:bLine := {|| { 	Iif(ALLTRIM(aCols3[oGetD3:nAt,1])=='1',oOk,Iif(ALLTRIM(aCols3[oGetD3:nAt,1])=='2',oNok,oNad)) ,;
	aCols3[oGetD3:nAt,02] ,;
	aCols3[oGetD3:nAt,03] ,;
	aCols3[oGetD3:nAt,04] ,;
	aCols3[oGetD3:nAt,05] ,;
	aCols3[oGetD3:nAt,06] ,;
	ALLTRIM(Transform(aCols3[oGetD3:nAt,07],"@E 999,999,999.99")) }}
	oGetD3:Align:= CONTROL_ALIGN_ALLCLIENT
	
	oPanel4:= oFWLayerItens:GetWinPanel("COL3","WIN3","DADOS")
	
	oGetD4:= TwBrowse():New(0,0,0,0,, {" ","Filial","NF","Serie","Item","Produto","Qtd"},,oPanel4,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oGetD4:SetArray(aCols4)
	
	oGetD4:bLine := {|| { 	Iif(ALLTRIM(aCols4[oGetD4:nAt,1])=='1',oOk,Iif(ALLTRIM(aCols4[oGetD4:nAt,1])=='2',oNok,oNad)) ,;
	aCols4[oGetD4:nAt,02] ,;
	aCols4[oGetD4:nAt,03] ,;
	aCols4[oGetD4:nAt,04] ,;
	aCols4[oGetD4:nAt,05] ,;
	aCols4[oGetD4:nAt,06] ,;
	ALLTRIM(Transform(aCols4[oGetD4:nAt,07],"@E 999,999,999.99")) }}
	oGetD4:Align:= CONTROL_ALIGN_ALLCLIENT
	
	FwMsgRun( ,{|| CargDados(aRegs1[oGetD1:nAt,2],aRegs1[oGetD1:nAt,4]) }, , "Filtrando Dados, por favor aguarde..." )
	
	ACTIVATE MSDIALOG oTela CENTERED ON INIT ( EnchoiceBar(oTela,{|| nOpc := 1 , oTela:End()  }, {||  nOpc := 0 , oTela:End() },,aButtons) )
	
Else
	MsgStop("Nใo faturas para os parโmetros informados","Aten็ใo")
	RETURN()
EndIF

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FILDADOS()

Local _cStatus   := ""
Local _cAlias   := GetNextAlias()

_cQuery := " SELECT UA_FILIAL FILIAL, UA_01FILIA DESCFI, UA_NUM ORCA, UA_NUMSC5 PEDIDO, UA_CLIENTE+UA_LOJA CODCLI, UA_EMISSAO EMISSAO, A1_NOME NOMECLI, * "
_cQuery += " FROM " + RETSQLNAME("SUA") + " (NOLOCK) SUA "
_cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " (NOLOCK) SA1 ON A1_COD = UA_CLIENTE AND UA_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE SUA.D_E_L_E_T_ <> '*' "
_cQuery += " AND UA_FILIAL+UA_NUM IN (SELECT UB_FILIAL+UB_NUM FROM SUB010 SUB WHERE UB_MOSTRUA IN ('4') AND SUB.D_E_L_E_T_ <> '*') "
_cQuery += " AND UA_NUMSC5 <> '' "
_cQuery += " AND UA_STATUS <> 'CAN' "
_cQuery += " AND UA_CANC <> 'S' "
_cQuery += " AND UA_NUMSC5 <> '' "
_cQuery += " AND UA_FILIAL BETWEEN '" + AllTrim(MV_PAR01) + "' AND '" + AllTrim(MV_PAR02) + "'"
_cQuery += " AND UA_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'"
_cQuery += " ORDER BY UA_FILIAL,UA_EMISSAO "
_cQuery := ChangeQuery(_cQuery)

If Select(_cAlias) > 0
	_cAlias->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

While (_cAlias)->(!EOF())
	
	_cStatus := fVerStat((_cAlias)->FILIAL,(_cAlias)->ORCA)
	
	aAdd( aRegs1, { _cStatus,;
	(_cAlias)->FILIAL,;
	(_cAlias)->DESCFI,;
	(_cAlias)->ORCA,;
	(_cAlias)->PEDIDO,;
	(_cAlias)->EMISSAO,;
	(_cAlias)->CODCLI,;
	(_cAlias)->NOMECLI,} )
	
	(_cAlias)->(DbSkip())
	
EndDo

(_cAlias)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM107   บAutor  ณMicrosiga           บ Data ณ  06/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CargDados(_cFil,_cOrc)

Local _ny     := 0
Local _cQuery := ""
Local _cSta1   := "1"
Local _cSta2   := "1"
Local _cSta3   := "1"
Local _cAlias := GetNextAlias()

aCols2 := {}
aCols3 := {}
aCols4 := {}

_cQuery += " SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO,C6_QTDVEN, C6_NOTA,C6_SERIE, C6_XCHVTRA, D2_FILIAL, D2_DOC, D2_SERIE,D2_ITEM, D2_COD,  D2_QUANT, D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM, D1_COD, D1_QUANT, D1_CLASFIS "
_cQuery += " FROM "+RetSqlName("SUB")+" (NOLOCK) SUB "
_cQuery += " INNER JOIN "+RetSqlName("SC6")+" (NOLOCK) SC6 ON C6_XCHVTRA = UB_FILIAL+UB_NUM+UB_ITEM AND SC6.D_E_L_E_T_ <> '*' "
_cQuery += " LEFT JOIN "+RetSqlName("SD2")+" (NOLOCK) SD2 ON D2_DOC = C6_NOTA AND D2_SERIE = C6_SERIE AND D2_CLIENTE = C6_CLI AND D2_LOJA = C6_LOJA AND D2_PEDIDO = C6_NUM AND C6_ITEM = D2_ITEMPV AND SD2.D_E_L_E_T_ <> '*' "
_cQuery += " LEFT JOIN "+RetSqlName("SD1")+" (NOLOCK) SD1 ON D1_DOC = C6_NOTA AND D1_SERIE = C6_SERIE AND D1_COD = C6_PRODUTO AND C6_ITEM = RIGHT(D1_ITEM,2) "
_cQuery += " AND D1_FORNECE = (SELECT A2_COD FROM SA2010 SA2 WHERE SA2.D_E_L_E_T_ <> '*' AND A2_FILTRF = '"+ _cFil +"') AND D1_LOJA = (SELECT A2_LOJA FROM SA2010 SA2B WHERE SA2B.D_E_L_E_T_ <> '*' AND A2_FILTRF = '"+ _cFil +"') "
_cQuery += " AND D1_FILIAL = '0101' AND SD1.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE SUB.D_E_L_E_T_ <> '*' "
_cQuery += " AND UB_FILIAL = '"+ _cFil +"' "
_cQuery += " AND UB_NUM = '"+ _cOrc +"' "
_cQuery += " ORDER BY C6_ITEM "

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

(_cAlias)->(DbGotop())

If (_cAlias)->(Eof())
	
	_cSta1   := "2"
	_cSta2   := "2"
	_cSta3   := "2"
	
	AAdd( aCols2 , { _cSta1,"NรO ACHOU", "NรO ACHOU", "NรO ACHOU","NรO ACHOU",0,"NรO ACHOU","NรO ACHOU","NรO ACHOU" } )
	
	AAdd( aCols3 , { _cSta2,"NรO ACHOU", "NรO ACHOU", "NรO ACHOU","NรO ACHOU","NรO ACHOU",0 } )
	
	AAdd( aCols4 , { _cSta3,"NรO ACHOU", "NรO ACHOU", "NรO ACHOU","NรO ACHOU","NรO ACHOU",0,""  } )
	
Else
	
	While (_cAlias)->(!Eof())
		
		If Empty(AllTrim((_cAlias)->C6_NUM))
			
			_cSta1 := "3"
			
		EndIf
		
		If Empty(AllTrim((_cAlias)->D2_DOC))
			
			_cSta2 := "3"
			
		EndIf
		
		If Empty(AllTrim((_cAlias)->D1_DOC))
			
			_cSta3 := "3"
			
		EndIf
		
		If !Empty(AllTrim((_cAlias)->C6_NUM))
			
			AAdd( aCols2 , { "",(_cAlias)->C6_FILIAL, (_cAlias)->C6_NUM, (_cAlias)->C6_ITEM, (_cAlias)->C6_PRODUTO,(_cAlias)->C6_QTDVEN, (_cAlias)->C6_NOTA,(_cAlias)->C6_SERIE, (_cAlias)->C6_XCHVTRA } )
			
		Else
			
			AADD(aCols2,{'2','','','','',0,'','',''})
			
		EndIf
		
		If !Empty(AllTrim((_cAlias)->D2_DOC))
			
			AAdd( aCols3 , { "",(_cAlias)->D2_FILIAL, (_cAlias)->D2_DOC, (_cAlias)->D2_SERIE,(_cAlias)->D2_ITEM, (_cAlias)->D2_COD,  (_cAlias)->D2_QUANT } )
			
		Else
			
			AADD(aCols3,{'2','','','','','',0})
			
		EndIf
		
		If !Empty(AllTrim((_cAlias)->D1_DOC))
			
			AAdd( aCols4 , { "",(_cAlias)->D1_FILIAL, (_cAlias)->D1_DOC, (_cAlias)->D1_SERIE, (_cAlias)->D1_ITEM, (_cAlias)->D1_COD, (_cAlias)->D1_QUANT, (_cAlias)->D1_CLASFIS } )
			
		Else
			
			AADD(aCols4,{'2','','','','','',0,''})
			
		EndIf
		
		(_cAlias)->(DbSkip())
		
	EndDo
	
	If Len(aCols2) > 0
		
		For _ny := 1 To Len(aCols2)
			
			aCols2[_ny,1] := _cSta1
			
		Next _ny
		
	EndIf
	
	If Len(aCols3) > 0
		
		For _ny := 1 To Len(aCols3)
			
			aCols3[_ny,1] := _cSta2
			
		Next _ny
		
	EndIf
	
	If Len(aCols4) > 0
		
		For _ny := 1 To Len(aCols4)
		
			If Empty(AllTrim(aCols4[_ny,8]))
			
				aCols4[_ny,1] := '3'
							
			Else
			
				aCols4[_ny,1] := _cSta3
				
			EndIf	
			
		Next _ny
		
	EndIf
	
EndIf

(_cAlias)->( dbCloseArea() )

oGetD2:AARRAY:= aCols2
oGetD2:Refresh()
oGetD3:AARRAY:= aCols3
oGetD3:Refresh()
oGetD4:AARRAY:= aCols4
oGetD4:Refresh()
oTela:REFRESH()

Return
                                                                                 
Static Function fVerStat(_cFil,_cOrc)

Local _cSta   := "1"
Local _cAlias   := GetNextAlias()

_cQuery := " SELECT DISTINCT C6_NOTA C6NF, D2_DOC D2NF, F1_DOC F1NF , F1_STATUS F1STATUS"
_cQuery += " FROM " + RETSQLNAME("SUB") + " (NOLOCK) SUB "
_cQuery += " INNER JOIN " + RETSQLNAME("SC6") + " (NOLOCK) SC6 ON C6_XCHVTRA = UB_FILIAL+UB_NUM+UB_ITEM AND SC6.D_E_L_E_T_ <> '*' "
_cQuery += " LEFT JOIN  " + RETSQLNAME("SD2") + " (NOLOCK) SD2 ON D2_DOC = C6_NOTA AND D2_SERIE = C6_SERIE AND D2_CLIENTE = C6_CLI AND D2_LOJA = C6_LOJA AND D2_PEDIDO = C6_NUM AND C6_ITEM = D2_ITEMPV AND SD2.D_E_L_E_T_ <> '*' "
_cQuery += " LEFT JOIN " + RETSQLNAME("SF1") + " (NOLOCK) SF1 ON F1_DOC = C6_NOTA AND F1_SERIE = C6_SERIE AND F1_FORNECE = (SELECT A2_COD FROM SA2010 SA2B WHERE SA2B.D_E_L_E_T_ <> '*' AND  A2_FILTRF = '"+ _cFil +"') "
_cQuery += " AND F1_LOJA = (SELECT A2_LOJA FROM SA2010 SA2 WHERE SA2.D_E_L_E_T_ <> '*' AND A2_FILTRF = '"+ _cFil +"') AND F1_FILIAL = '0101' AND SF1.D_E_L_E_T_ <> '*' " 
_cQuery += " WHERE SUB.D_E_L_E_T_ <> '*' "
_cQuery += " AND UB_FILIAL = '"+ _cFil +"' "
_cQuery += " AND UB_NUM = '"+ _cOrc +"' "
_cQuery := ChangeQuery(_cQuery)

If Select(_cAlias) > 0
	_cAlias->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

If (_cAlias)->(EOF())
	
	_cSta   := "2"//Nใo achou - Vermelho
	
EndIf

While (_cAlias)->(!EOF())
	
	If Empty(AllTrim((_cAlias)->C6NF)) .Or. Empty(AllTrim((_cAlias)->D2NF)) .Or. Empty(AllTrim((_cAlias)->F1NF)) .Or. Empty(AllTrim((_cAlias)->F1STATUS))  
		
		_cSta := "3"
		
	EndIf
	
	(_cAlias)->(DbSkip())
	
EndDo

(_cAlias)->(DbCloseArea())

Return _cSta


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSx1บAutor  ณ SYMM Consultoria	 บ Data ณ  22/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Perguntas na SX1 atraves da funcao PUTSX1().          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)

Local aPergunta := {}
Local i
Local aAreaBKP := GetArea()

Aadd(aPergunta,{cPerg,"01","Filial De... ?"		,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","",""	,"SM0"   	})
Aadd(aPergunta,{cPerg,"02","Filial At้.. ?"		,"MV_CH02" ,"C",004,00,"G","MV_PAR02",""     ,""      ,""			,"","",""	,"SM0"   	})
Aadd(aPergunta,{cPerg,"03","Data de... ?"		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""		})
Aadd(aPergunta,{cPerg,"04","Data at้.. ?" 		,"MV_CH04" ,"D",008,00,"G","MV_PAR04",""     ,""      ,""			,"","",""	,""		})

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
	SX1->X1_GRUPO 		:= aPergunta[i,1]
	SX1->X1_ORDEM		:= aPergunta[i,2]
	SX1->X1_PERGUNT		:= aPergunta[i,3]
	SX1->X1_VARIAVL		:= aPergunta[i,4]
	SX1->X1_TIPO		:= aPergunta[i,5]
	SX1->X1_TAMANHO		:= aPergunta[i,6]
	SX1->X1_DECIMAL		:= aPergunta[i,7]
	SX1->X1_GSC			:= aPergunta[i,8]
	SX1->X1_VAR01		:= aPergunta[i,9]
	SX1->X1_DEF01		:= aPergunta[i,10]
	SX1->X1_DEF02		:= aPergunta[i,11]
	SX1->X1_DEF03		:= aPergunta[i,12]
	SX1->X1_DEF04		:= aPergunta[i,13]
	SX1->X1_DEF05		:= aPergunta[i,14]
	SX1->X1_F3			:= aPergunta[i,15]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

RETURN()

