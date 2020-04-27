#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

STATIC nSel01 	 := 1
Static MVDirFoto := SuperGetMV("MV_SYDIRFO",,"C:\FOTOS\BESNI\")
STATIC cRetProd
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  SYVA103		บAutor  ณEduardo Patrianiบ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Consulta de Produtos.                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVA103()

Local nX,nY,nPos
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local aButtons 		:= {}
Local bColorHis 	:= &("{|| a103CorBrw(@aCorGrd,1) }")
Local cQry			:= ''
Local oFont1 		:= TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
Local nOpc			:= 0
Local bSavKeyF4  	:= SetKey(VK_F4,Nil)
Local bSavKeyF5  	:= SetKey(VK_F5,Nil)
Local oDlg
Local oPanel1
Local oPanel2
Local oFwLayerRes
Local oBtnOk, oBtnLim

Local aCorGrd := {	;
{ Rgb(240,255,255)	, Nil , 'Azure'				} ,;
{ Rgb(230,230,250) 	, Nil , 'Lavander'			} ,;
{ Rgb(0,255,255) 	, Nil , 'Cyan'				} ,;
{ Rgb(193,255,193) 	, Nil , 'Lavander'			} ,;
{ Rgb(202,225,255)	, Nil , 'DarkSeaGreen1'		} ,;
{ Rgb(192,255,62) 	, Nil , 'OliveDrab1'		} ,;
{ Rgb(255,255,240)	, Nil , 'Ivory1'			} ,;
{ Rgb(255,239,213)	, Nil , 'PapayaWhip' 		} ,;
{ Rgb(255,250,205)	, Nil , 'LemonChiffon' 		} ,;
{ Rgb(240,255,240)	, Nil , 'Honeydew' 			} ,;
{ Rgb(127,255,212)	, Nil , 'Aquamarine1'		} ,;
{ Rgb(245,255,250)	, Nil , 'MintCream' 		} ,;
{ Rgb(255,240,245)	, Nil , 'LavenderBlush' 	} ,;
{ Rgb(255,225,255)	, Nil , 'Thistle1' 			} ,;
{ Rgb(255,250,250)	, Nil , 'Snow' 				} }

Private aHead1 	 := {}
Private aCols1	 := {}
Private oGetD1

Private aHead2 	 := {"","Cor","Descri็ใo","Pre็o","Estoque","Qtd.Prevista","C๓d.Interno","Armazem","Descri็ใo Armazem"}
Private aRegs2	 :=	{{.F.,"","",0,0,0,"","","",.F.,"ESTOQUE PRINCIPAL"}}
Private oGetD2

Private aHead3 	 := {"","C๓digo","Descri็ใo","Pre็o","Estoque","Qtd.Prevista","Fora Linha","Campanha","Armazem","Descri็ใo Armazem"}
Private aRegs3	 := {{.F.,"","",0,0,0,"","","",.F.}}
Private oGetD3

Private aHead4 	 := {"","Referencia","Cor","Descri็ใo","Pre็o","Observa็ใo"}
Private aRegs4	 := {{.F.,"","","",0,""}}
Private oGetD4

Private cProduto := CriaVar("B4_COD"  ,.F.)
Private cDescri  := CriaVar("B4_DESC" ,.F.)
Private cTabPad	  := ""//GetMv("MV_TABPAD") //GetMv("MV_STABPAD",,"100")
Private nVlPrzMe := GetMv("MV_CCPRZME",,10)
Private cArmMos	 := Alltrim(POSICIONE("SX5",1,xFilial("SX5")+"Z1"+cFilAnt,"X5_DESCRI"))
Private aTabela	  := {}

Private cComboR  := 0
Private cComboM  := 0
Private aComboR	 := {}
Private aComboM	 := {}
Private oComboR	 := Nil
Private oComboM	 := Nil

Private aMascara := Separa(GetMv('MV_MASCGRD',,'09,04,02,02'),',')
Private nTamPai  := Val(aMascara[1])
Private nTamLin  := Val(aMascara[2])
Private nTamCol  := Val(aMascara[3])
Private nTamRef  := IIF(Len(aMascara)==4,Val(aMascara[4]),0)

Private oOk	 := LoadBitMap(GetResources(), "LBOK")
Private oNo	 := LoadBitMap(GetResources(), "LBNO")

Private nLargura := 0
Private nAltura  := GetMV("KH_01ALGRD",,1.10)
Private nCompri  := GetMV("KH_01COGRD",,1.00)

Private oLargura
Private oAltura
Private oCompri

Private cLocDep	:= GetMv("MV_SYLOCDP",,"100001")
Private cTabMost:= GetMv("MV_SYTABMO") //Tabela de Preco de Produtos Mostruแrios

Private oProduto := Nil
Private oDescri	 := Nil

Private _cSYLocPad	:= SuperGetMV("SY_LOCPAD",.F.,"01")	//#CMG20180726.n
Private _lForal		:= .F.	//#RVC20181121.n


MV_PAR01 	:= NIL

If nFolder <> 2
	MsgAlert("Esta rotina deve ser acessada somente no Televendas.","Aten็ใo")
	Return
Endif

If Empty(M->UA_CLIENTE)
	MsgStop( "O Cliente nใo informado.","Aten็ใo" )
	Return
Endif

AAdd(aButtons,{	'',{|| U_SYTM0066A(oGetD1:aCols[oGetD1:nAt,1]) }, "Manuten็ใo de Fotos <F4>"} )
AAdd(aButtons,{	'',{|| A103TABELA() }, "Tabela de Pre็os <F5>"} )
AAdd(aButtons,{	'',{|| U_SYTMOV02() }, "Pesquisa Estoque em Outras Filiais <F7>"} )

SetKey( VK_F4 , { || U_SYTM006A(oGetD1:aCols[oGetD1:nAt,1]) } )
SetKey( VK_F5 , { || A103TABELA() } )
SetKey( VK_F7 , { || U_SYTMOV02() } )

DEFINE FONT oFonteMemo 	NAME "Arial" SIZE 0,-15 BOLD

//Produtos
Aadd(aHead1,{RetTitle('B4_COD')		,'CODIGO' 		, PesqPict('SB4','B4_COD')	,TamSx3('B4_COD')[1]	,X3Decimal('B4_COD' )	,'','','C','','',''})
Aadd(aHead1,{RetTitle('B4_DESC')	,'DESCRICAO'	, PesqPict('SB4','B4_DESC')	,TamSx3('B4_DESC')[1]	,X3Decimal('B4_DESC')	,'','','C','','',''})

Aadd(aCols1,Array(Len(aHead1)+1))
nPos := Len(aCols1)

aCols1[nPos,1] := CriaVar("B4_COD" ,.F.)
aCols1[nPos,2] := CriaVar("B4_DESC",.F.)
aCols1[nPos,Len(aHead1)+1] := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosObj[1][3] := 230

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Dialogo.		                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//DEFINE MSDIALOG oDlg TITLE "Consulta de Produtos" FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
DEFINE MSDIALOG oDlg TITLE "Consulta de Produtos" FROM 0,0 TO 620,950 OF oMainWnd PIXEL

//??????????????????????????????????????????????????????????????????????????????????????????????????????????
//? Dados do Folder 1 (Cabecalho do Pedido).		        												?
//???????????????????????????????????????????????????????????????????????????????????????????????????????????
oPanelCabec		  := TPanel():New(0, 0, '', oDlg, NIL, .T., .F., NIL, NIL, 0,30, .T., .F. )
oPanelCabec:Align := CONTROL_ALIGN_TOP

oPanelList	:= TPanel():New( 0,0,'',oPanelCabec,,,,,,(((oPanelCabec:NCLIENTWIDTH/2)*80)/100),040)	//Linha/Coluna/Largura/Altura
oPainelFoto := TPanel():New(0,(((oPanelCabec:NCLIENTWIDTH/2)*80)/100)+2,'',oPanelCabec,,,,,,(oPanelCabec:NCLIENTWIDTH/2) - (((oPanelCabec:NCLIENTWIDTH/2)*80)/100),40)

@ 005,010 SAY "Produto" 	OF oPanelList PIXEL SIZE 038,010
@ 004,040 MSGET oProduto Var cProduto 	PICTURE PesqPict('SB4','B4_COD') 	WHEN .T. F3 "SB4" OF oPanelList FONT oFont1 PIXEL SIZE 070,010 HASBUTTON
oProduto:bLostFocus	:= {|| cDescri := Posicione("SB4",1,xFilial("SB4")+cProduto,"B4_DESC") , oDescri:Refresh() }

@ 005,130 SAY "Descri็ใo" 	OF oPanelList PIXEL SIZE 038,010
@ 004,170 MSGET oDescri Var cDescri 	PICTURE PesqPict('SB4','B4_DESC') 	WHEN .T. OF oPanelList FONT oFont1 PIXEL SIZE 150,010 HASBUTTON

//DEFINE SBUTTON oSButton1 FROM 005, 330 /*625*/ TYPE 01 OF oPanelList ENABLE ACTION ( LjMsgRun("Por favor aguarde, verificando produtos...",, {|| SyCarProd() }),.T.)
//DEFINE SBUTTON oSButton2 FROM 005, 390 /*625*/ TYPE 02 OF oPanelList ENABLE ACTION ( SyLimpaCpo(@cProduto,@cDescri,@oProduto,@oDescri) )
oBtnOk := TButton():New(005,330,"Ok"		,oPanelList,{|| LjMsgRun("Por favor aguarde, verificando produtos...",, {|| SyCarProd() }) }	,030,010,,,,.T.,,,,,,)
oBtnLim:= TButton():New(020,330,"Limpar"	,oPanelList,{|| SyLimpaCpo(@cProduto,@cDescri,@oProduto,@oDescri) }							,030,010,,,,.T.,,,,,,)

oFwLayerRes:= FwLayer():New()
oFwLayerRes:Init(oDlg,.T.)
oFwLayerRes:addLine("CONSULTA", 095, .F.)
oFwLayerRes:addCollumn( "COL1",100, .T. , "CONSULTA")
oFWLayerRes:addWindow ( "COL1", "WIN2", "Produtos"		, 035 , .T., .F., , "CONSULTA")
oFWLayerRes:addWindow ( "COL1", "WIN3", "Acabamentos"	, 055 , .T., .F., , "CONSULTA")

oPanel2:= oFwLayerRes:GetWinPanel("COL1","WIN2","CONSULTA")

oGetD1:=MsNewGetDados():New(0,0,0,0,0,"Allwaystrue","AllWaysTrue","",,,Len(aCols1),,,,oPanel2,@aHead1,@aCols1)
oGetD1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetD1:oBrowse:SetBlkBackColor({|| GETDCLR(oGetD1:nAt,.F.)})

oGetD1:oBrowse:bChange:= {|| 	SyCarRef(@oComboR,@cComboR,@aComboR,oGetD1:aCols[oGetD1:nAt,1]) ,;
SyIniComb(@oComboM,@cComboM,@aComboM) ,;
MostraFoto(oGetD1:aCols[oGetD1:nAt,1],@oPainelFoto),;
nSel01 := oGetD1:oBrowse:nAt,;
oGetD1:oBrowse:Refresh() }

oGetD1:oBrowse:bLostFocus:= {||	SyCarRef(@oComboR,@cComboR,@aComboR,oGetD1:aCols[oGetD1:nAt,1]) ,;
SyIniComb(@oComboM,@cComboM,@aComboM) ,;
MostraFoto(oGetD1:aCols[oGetD1:nAt,1],@oPainelFoto),;
nSel01 := oGetD1:oBrowse:nAt,;
oGetD1:oBrowse:Refresh() }

oGetD1:oBrowse:bGotFocus:= {|| 	SyCarRef(@oComboR,@cComboR,@aComboR,oGetD1:aCols[oGetD1:nAt,1]) ,;
SyIniComb(@oComboM,@cComboM,@aComboM) ,;
MostraFoto(oGetD1:aCols[oGetD1:nAt,1],@oPainelFoto),;
nSel01 := oGetD1:oBrowse:nAt,;
oGetD1:oBrowse:Refresh() }


oPanel3:= oFwLayerRes:GetWinPanel("COL1","WIN3","CONSULTA")

oFolder:=TFolder():New(0,0,{"Medidas Padr๕es","Medidas Especiais","Produtos"},,oPanel3,,,,.T.,.F.,0,0)
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

//Folder1
@ 001,002 GROUP oGrp1 TO 030, 462 LABEL "Padr๕es" OF oFolder:aDialogs[1] PIXEL

@ 007,005 SAY "Referencia(s)" OF oFolder:aDialogs[1] PIXEL SIZE 038,010
@ 014,005 MSCOMBOBOX oComboR VAR cComboR ITEMS aComboR SIZE 150, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 007,182 SAY "Medida(s)" 	OF oFolder:aDialogs[1] PIXEL SIZE 038,010
@ 014,182 MSCOMBOBOX oComboM VAR cComboM ITEMS aComboM SIZE 150, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

oGetD2				:= TwBrowse():New(035,001,460,090,,aHead2,,oFolder:aDialogs[1],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oGetD2:lColDrag		:= .T.
oGetD2:SetArray(aRegs2)
oGetD2:bLine		:= { || {	IIF(aRegs2[oGetD2:nAt,1],oOk,oNo),;
aRegs2[oGetD2:nAt,2],;
aRegs2[oGetD2:nAt,3],;
Transform(aRegs2[oGetD2:nAt,4],PesqPict('SB1','B1_PRV1')),;
Transform(aRegs2[oGetD2:nAt,5],PesqPict('SB2','B2_QATU')),;
Transform(aRegs2[oGetD2:nAt,6],PesqPict('SB2','B2_QATU')),;
aRegs2[oGetD2:nAt,7] ,;
aRegs2[oGetD2:nAt,8] ,;
aRegs2[oGetD2:nAt,11]} }

oGetD2:bLDblClick 	:= { || A103VLD3(aRegs2,@oGetD2) }
//oGetD2:bLDblClick 	:= { || If(aRegs2[oGetD2:nAt,4]>0,aRegs2[oGetD2:nAt,1]:= !aRegs2[oGetD2:nAt,1],aRegs2[oGetD2:nAt,1]:=.F.), oGetD2:Refresh()}
//oGetD2:bHeaderClick	:= { || AEval(aRegs2,{|x| x[1]:= !x[1]}), oGetD2:Refresh()}

//Folder2
@ 001,002 GROUP oGrp1 TO 030, 462 LABEL "Especiais" OF oFolder:aDialogs[2] PIXEL

@ 010,005 SAY "Largura" 		OF oFolder:aDialogs[2] PIXEL SIZE 038,010
@ 009,030 MSGET oLargura Var nLargura PICTURE PesqPict('SB4','B4_01LARMI') 	VALID A103VLD1(nLargura,1) WHEN .T. OF oFolder:aDialogs[2] PIXEL SIZE 060,010 HASBUTTON

@ 010,125 SAY "Profundidade" 	OF oFolder:aDialogs[2] PIXEL SIZE 038,010
@ 009,165 MSGET oCompri Var nCompri	PICTURE PesqPict('SB4','B4_01PROMI') 	VALID A103VLD1(nCompri,3) WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 060,010 HASBUTTON

@ 010,245 SAY "Altura" 			OF oFolder:aDialogs[2] PIXEL SIZE 038,010
@ 009,270 MSGET oAltura Var nAltura	PICTURE PesqPict('SB4','B4_01ALTMI') 	VALID A103VLD1(nAltura,2) WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 060,010 HASBUTTON

DEFINE SBUTTON oSButton2 FROM 010,420 TYPE 01 OF oFolder:aDialogs[2] ENABLE ACTION ( LjMsgRun("Por favor aguarde, carregando pre็os...",, {|| SyCarPrcME(oGetD1:aCols[oGetD1:nAt,1],nLargura,nAltura,nCompri) }),.T.)

oGetD4				:= TwBrowse():New(035,001,460,090,,aHead4,,oFolder:aDialogs[2],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oGetD4:lColDrag		:= .T.
oGetD4:SetArray(aRegs4)
oGetD4:bLine		:= { || {	IIF(aRegs4[oGetD4:nAt,1],oOk,oNo),;
aRegs4[oGetD4:nAt,2],;
aRegs4[oGetD4:nAt,3],;
aRegs4[oGetD4:nAt,4],;
Transform(aRegs4[oGetD4:nAt,5],PesqPict('SB1','B1_PRV1')),;
aRegs4[oGetD4:nAt,6]} }

oGetD4:bLDblClick 	:= { || If(aRegs4[oGetD4:nAt,5]>0,aRegs4[oGetD4:nAt,1]:= !aRegs4[oGetD4:nAt,1],aRegs4[oGetD4:nAt,1]:=.F.), aRegs4[oGetD4:nAt,6] := DIGOBSME() , oGetD4:Refresh()}
oGetD4:bHeaderClick	:= { || AEval(aRegs4,{|x| x[1]:= !x[1]}), oGetD4:Refresh()}

//Folder3
oGetD3				:= TwBrowse():New(1,1,1,1,,aHead3,,oFolder:aDialogs[3],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oGetD3:Align        := CONTROL_ALIGN_ALLCLIENT
oGetD3:lColDrag		:= .T.
oGetD3:SetArray(aRegs3)
oGetD3:bLine		:= { || {	IIF(aRegs3[oGetD3:nAt,1],oOk,oNo),;
aRegs3[oGetD3:nAt,2],;
aRegs3[oGetD3:nAt,3],;
Transform(aRegs3[oGetD3:nAt,4],PesqPict('SB1','B1_PRV1')),;
Transform(aRegs3[oGetD3:nAt,5],PesqPict('SB2','B2_QATU')),;
Transform(aRegs3[oGetD3:nAt,6],PesqPict('SB2','B2_QATU')),;
aRegs3[oGetD3:nAt,7],;
aRegs3[oGetD3:nAt,8],;
aRegs3[oGetD3:nAt,9]}}

oGetD3:bLDblClick 	:= { || A103VLD2(aRegs3,@oGetD3) }
//oGetD3:bLDblClick 	:= { || If( (aRegs3[oGetD3:nAt,6]=="F" .And. aRegs3[oGetD3:nAt,5]==0),(MsgStop("Produto fora de linha e sem estoque para venda.","Aten็ใo"),aRegs3[oGetD3:nAt,1]:=.F.),aRegs3[oGetD3:nAt,1]:= !aRegs3[oGetD3:nAt,1]), oGetD3:Refresh()}
//oGetD3:bHeaderClick	:= { || AEval(aRegs3,{|x| x[1]:= !x[1]}), oGetD3:Refresh()}


ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| IIF( a103Sair(aRegs2,oGetD2) , oDlg:End() , .F. )  }, {||  oDlg:End() },,aButtons) )

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณa103CorBrwบAutor  ณMicrosiga           บ Data ณ  14/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de cores na GetDados.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function a103CorBrw(aCorGrd,nOrig)

IF nOrig == 1
	IF Empty(oGetD1:aCols[oGetD1:nAt,1])
		Return(Rgb(255,255,0))
	Else
		Return(Rgb(240,255,255))
	EndIF
EndIF

Return(cCor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarProd บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os produtos conforme a pesquisa.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarProd()

Local aArea 	:= GetArea()
Local cAlias    := GetNextAlias()
Local cQry		:= ''
Local cString 	:= ''
Local aInfo		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAcionado pela consulta padrao do campo produto     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cProduto) .And. !Empty(cDescri)
	
	aCols1 := {}
	
	Aadd(aCols1,Array(Len(aHead1)+1))
	nPos := Len(aCols1)
	
	aCols1[nPos,1] := cProduto
	aCols1[nPos,2] := cDescri
	aCols1[nPos,3] := ""
	aCols1[nPos,Len(aHead1)+1] := .F.
	
	//Gera os produtos conforme a pesquisa.
	cString += "%"+Alltrim(cProduto)+"%"
	SyCarSB1(cString,"1")
	
Else
	aInfo := Separa(cDescri," ",.F.)
	
	If Len(aInfo) > 0
		
		For nI := 1 To Len(aInfo)
			cString += "%"+Alltrim(aInfo[nI])
		Next
		cString += "%"
		
	EndIf
	
	cQry += " SELECT DISTINCT B1_01PRODP, B4_DESC " + CRLF
	cQry += " FROM "+RetSqlName("SB1")+" SB1 " + CRLF
	cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' " + CRLF //Eduardo 27/11/2014
	cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' " + CRLF
	
	For nI:=1 To Len(aInfo)
		cQry += " AND B1_DESC LIKE '%" + aInfo[nI] + "%' " + CRLF
	Next
	//cQry += " B1_DESC LIKE "
	
	//cQry += "'"+cString+"'"
	cQry += " AND SB1.B1_MSBLQL <> '1' " + CRLF	//#RVC20180416.n
	cQry += " AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	
	If !Empty((cAlias)->B1_01PRODP)
		aCols1 := {}
	Endif
	
	While (cAlias)->(!Eof())
		
		Aadd(aCols1,Array(Len(aHead1)+1))
		nPos := Len(aCols1)
		
		aCols1[nPos,1] := (cAlias)->B1_01PRODP
		aCols1[nPos,2] := (cAlias)->B4_DESC
		aCols1[nPos,Len(aHead1)+1] := .F.
		
		(cAlias)->(DbsKIP())
	End
	(cAlias)->( dbCloseArea() )
	
	//Gera os produtos conforme a pesquisa.
	SyCarSB1(cString,"2")
Endif

oGetD1:aCols := aClone(aCols1)
oGetD1:Refresh()


RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarRef  บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega as referencias conforme o produto posicionado.      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarRef(oCombo,cCombo,aCombo,cProduto)

Local aArea 	:= GetArea()
Local cAlias    := GetNextAlias()
Local cQry		:= ''

cCombo := 1
aCombo := {""}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsulta no produto, se e permitido a utilizacao de medidas especiais  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SB4")
DbSetOrder(1)
DbSeek(xFilial("SB4") + cProduto )
If SB4->B4_01MEDES=="2"
	oFolder:aEnable(2,.F.)
Else
	oFolder:aEnable(2,.T.)
Endif

cQry += " SELECT DISTINCT B1_01RFGRD, B1_01DREF "
cQry += " FROM "+RetSqlName("SB1")+" SB1 "
cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' "//Eduardo 27/11/2014
cQry += " WHERE B1_01PRODP = '"+cProduto+"' "
cQry += " AND SB1.B1_MSBLQL <> '1' " //#RVC20180416.n
cQry += " AND SB1.D_E_L_E_T_ = ' ' "
cQry += " ORDER BY B1_01RFGRD, B1_01DREF "

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	If !Empty((cAlias)->B1_01RFGRD)
		AAdd(aCombo , Alltrim((cAlias)->B1_01RFGRD)+"-"+Alltrim((cAlias)->B1_01DREF) )
	Endif
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

If Len(aCombo)==1
	AAdd(aCombo , "1-Sem Referencia" )
Endif

oCombo:aItems := aClone(aCombo)
oCombo:bChange:= {|| 	SyCarMed(@oComboM,@cComboM,@aComboM,oGetD1:aCols[oGetD1:nAt,1],Left(oCombo:aItems[oCombo:nAt],nTamRef)) }  //,;
//MostraFoto(Padr(oGetD1:aCols[oGetD1:nAt,1],nTamPai)+Left(oCombo:aItems[oCombo:nAt],1),@oPainelFoto)}
oCombo:Refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarRef  บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega as referencias conforme o produto posicionado.      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarMed(oCombo,cCombo,aCombo,cProduto,cComboRef)

Local aArea 	:= GetArea()
Local cAlias    := GetNextAlias()
Local cQry		:= ''

cCombo 	  := 1
aCombo 	  := {""}

DbSelectArea("SB4")
DbSetOrder(1)
DbSeek(xFilial("SB4") + cProduto )

cQry += " SELECT DISTINCT B1_01CLGRD,BV_DESCRI "
cQry += " FROM "+RetSqlName("SB1")+" SB1 "
cQry += " INNER JOIN "+RetSqlName("SBV")+" SBV ON BV_TABELA = '"+SB4->B4_COLUNA+"' AND BV_CHAVE = B1_01CLGRD AND SBV.D_E_L_E_T_ = ' ' "
cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' "//Eduardo 27/11/2014
cQry += " WHERE B1_01PRODP = '"+cProduto+"' "
cQry += " AND B1_01RFGRD = '"+cComboRef+"' "
cQry += " AND SB1.B1_MSBLQL <> '1' " //#RVC20180416.n
cQry += " AND SB1.D_E_L_E_T_ = ' ' "
cQry += " ORDER BY B1_01CLGRD "

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	AAdd(aCombo , Alltrim((cAlias)->B1_01CLGRD)+"-"+Alltrim((cAlias)->BV_DESCRI) )
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

oCombo:aItems := aClone(aCombo)
oCombo:bChange:= {|| SyCarAcab( oGetD1:aCols[oGetD1:nAt,1] , cComboRef , Left(oCombo:aItems[oCombo:nAt],nTamCol)  )}
oCombo:Refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarAcab บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega as acabamentos do produto posicionado.              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarAcab(cProduto,cComboRef,cComboLn)

Local aArea 	:= GetArea()
Local cAlias    := GetNextAlias()
Local cQry		:= ''
Local cSku		:= ''
Local cFilAtu	:= ''
Local nSaldoSB2	:= 0
Local nSalPrev	:= 0
Local nQtdPrev	:= 0
Local cLocPad	:= ''

aRegs2 := {}

DbSelectArea("SB4")
DbSetOrder(1)
DbSeek(xFilial("SB4") + cProduto )

cQry += " SELECT DISTINCT B1_01LNGRD,BV_DESCRI "
cQry += " FROM "+RetSqlName("SB1")+" SB1 "
cQry += " INNER JOIN "+RetSqlName("SBV")+" SBV ON BV_TABELA = '"+SB4->B4_LINHA+"' AND BV_CHAVE = B1_01LNGRD AND SBV.D_E_L_E_T_ = ''
cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' "//Eduardo 27/11/2014
cQry += " WHERE B1_01PRODP = '"+cProduto+"' "
cQry += " AND B1_01RFGRD = '"+cComboRef+"' "
cQry += " AND B1_01CLGRD = '"+cComboLn+"' "
cQry += " AND SB1.B1_MSBLQL <> '1' " //#RVC20180416.n
cQry += " AND SB1.D_E_L_E_T_ = ' ' "
cQry += " ORDER BY B1_01LNGRD

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	
	cSku := Padr(Substr(cProduto,1,nTamPai),nTamPai)	//Pai
	cSku += Substr((cAlias)->B1_01LNGRD,1,nTamLin) 	//Cor
	cSku += Substr(cComboLn,1,nTamCol)					//Tam
	cSku += Substr(cComboRef,1,nTamRef)	 				//Ref
	cSku := Padr(cSku,TamSx3("B1_COD")[1])				//SKU
	
	SB1->( DbSetOrder(1) )
	IF !SB1->( DbSeek( xFilial("SB1")+cSku ) )
		Alert('Este SKU nใo existe ['+Alltrim(cSku)+'] na Filial: ' + cFilAnt )
		Loop
	EndIF
	
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + SB1->B1_PROC + SB1->B1_LOJPROC ))
	If SA2->A2_XFORFAT=="1"
		cFilAtu := xFilial("SB2")
	Else
		cFilAtu := cLocDep
	Endif
	
	//Tratamento dos armazens para pecas especifica
	SB4->(DbSetOrder(1))
	SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
	cLocPad := SB1->B1_LOCPAD
	
	//nQtdPrev := U_A273VLDE(PADR(cSku,TAMSX3("B1_COD")[1]))
	
	If Select("TRB2") > 0
		TRB2->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TRB2"
		SELECT *
		FROM %Table:SB2% SB2
		WHERE
		B2_FILIAL 	= %Exp:cLocDep%
		AND B2_COD 		= %Exp:SB1->B1_COD%
//		AND B2_LOCAL 	= %Exp:cLocPad% - #CMG20181122.o
		AND B2_LOCAL 	= %Exp:_cSYLocPad% //#CMG20181122.n - buscar o armazem padrใo da loja
		AND SB2.%notDel%
	EndSql
	
	IF TRB2->(!Eof())
		nSaldoSB2 := 0
		nSaldoSB2 := ((TRB2->B2_QATU+nQtdPrev) - (TRB2->B2_QEMP + TRB2->B2_RESERVA + IIF(TRB2->B2_QPEDVEN<0,0,TRB2->B2_QPEDVEN)))
		nSaldoSB2 := If( nSaldoSB2 > 0 , nSaldoSB2 , 0)
		nSalPrev  := If( TRB2->B2_01SALPE > 0 , TRB2->B2_01SALPE , 0)
	Else
		nSaldoSB2 := 0
	EndIF
	
	DA1->(DbSetOrder(1))
	DA1->(DbSeek(xFilial("DA1") + cTabPad + PADR(cSku,TAMSX3("DA1_CODPRO")[1]) ))
	
	AAdd( aRegs2 , {.F. , Alltrim((cAlias)->B1_01LNGRD) , Alltrim((cAlias)->BV_DESCRI) , DA1->DA1_PRCVEN , nSaldoSB2 , nSalPrev , cSku , cLocPad , "" , .F.,"ESTOQUE PRINCIPAL"} )
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

oGetD2:aArray := aClone(aRegs2)
oGetD2:Refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyIniComb	บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializa os combos e variaveis                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyIniComb(oComboM,cComboM,aComboM)

cComboM:=''
aComboM:={}
oComboM:cReadVar := cComboM
oComboM:aItems   := aClone(aComboM)
oComboM:Refresh()

//Zera as variaveis das medidas especiais
nLargura := 0
oLargura:Refresh()

//Zera aRegs2 apos mudan็a do produto.
aRegs2:= {{.F.,"","",0,0,0,"","","",.F.,"ESTOQUE PRINCIPAL"}}
oGetD2:aArray := aClone(aRegs2)
oGetD2:Refresh()

//Zera aRegs4 apos mudan็a do produto.
aRegs4:= {{.F.,"","","",0,""}}
oGetD4:aArray := aClone(aRegs4)
oGetD4:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETDCLR	บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de cores no browse.                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GETDCLR(nLinha,lTotal)

Local nCor1 := CLR_YELLOW
Local nRet  := Rgb(202,225,255)//CLR_WHITE
Local nSelec:= nSel01

If lTotal
	nRet := Rgb(202,225,255) //Rgb(130,130,130)
Else
	If nLinha == nSelec
		nRet := nCor1
	EndIf
EndIf

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarSB1	บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarregas todos os produtos conforme a palavra digitada.     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarSB1(cString,nOper)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local cQry	 	:= ''
Local cFilAtu	:= ''
Local nSaldoSB2 := 0
Local nSalPrev	:= 0
Local nQtdPrev	:= 0
Local cLocPad	:= ''
Local aDesc    	:= {}
Local nPrcven	:= 0
Local aDados	:= {}
Local lFora		:= .F.

//#CMG20180926.bn
Local _nB2QEmp := 0
Local _nB2Rese := 0
Local _nB2QPed := 0
Local _nB2QACl := 0                                         
Local _nB2QAtu := 0
//#CMG20180926.en

aRegs3 := {}

cQry += " SELECT DISTINCT B1_COD, B1_DESC, B1_PRV1, B2_QATU, B2_QEMP, B2_RESERVA, B2_QPEDVEN, B2_QACLASS , B1_01FORAL, B1_PROC,  B1_LOJPROC, B1_01PRODP, B2_01SALPE " + CRLF //cQry += " SELECT DISTINCT B1_COD, B1_DESC, B1_PRV1, ISNULL((SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + SB2.B2_QPEDVEN)),0) B2_QATU, B1_01FORAL, B1_PROC,  B1_LOJPROC "
cQry += " FROM "+RetSqlName("SB1")+" SB1 " + CRLF
cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' " + CRLF //Eduardo 27/11/2014
cQry += " LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_COD=B1_COD AND B2_LOCAL = '01' AND B2_FILIAL = '"+cLocDep+"' AND SB2.D_E_L_E_T_ = '' " + CRLF
cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' " + CRLF

IF nOper<>"1"
	aDesc := SEPARA(cString,"%",.F.)
	For nX:=1 To Len(aDesc)
		cQry += " AND B1_DESC LIKE '%" + aDesc[nX] + "%' " + CRLF
	Next
Else
	cQry += " AND B1_COD LIKE " + CRLF
	cQry += "'"+cString+"'" + CRLF
Endif

cQry += " AND SB1.B1_MSBLQL <> '1' " + CRLF //#RVC20180416.n
cQry += " AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQry += " ORDER BY B1_COD " + CRLF

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	_lForal	:= .F.	//#RVC20181121.n

	_nB2QEmp := IIF((cAlias)->B2_QEMP<0,0,(cAlias)->B2_QEMP)
	_nB2Rese := IIF((cAlias)->B2_RESERVA<0,0,(cAlias)->B2_RESERVA)
	_nB2QPed := fQtdPed((cAlias)->B1_COD,'01')//IIF((cAlias)->B2_QPEDVEN<0,0,(cAlias)->B2_QPEDVEN) - #CMG20181113.n
	_nB2QACl := IIF((cAlias)->B2_QACLASS<0,0,(cAlias)->B2_QACLASS)
	_nB2QAtu := IIF((cAlias)->B2_QATU<0,0,(cAlias)->B2_QATU)	
	
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + (cAlias)->B1_PROC + (cAlias)->B1_LOJPROC ))
	If SA2->A2_XFORFAT=="1"
		cFilAtu := xFilial("SB2")
	Else
		cFilAtu := cLocDep
	Endif
	
	SB1->(DbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1") + PADR((cAlias)->B1_COD,TAMSX3("B1_COD")[1]) ))
	
	//Tratamento dos armazens para pecas especificas
	SB4->(DbSetOrder(1))
	SB4->(MsSeek(xFilial("SB4") + (cAlias)->B1_01PRODP ))
	cLocPad := SB1->B1_LOCPAD

    //          SALDO ATUAL - (EMPENHO + RESERVA + QTD.PEDIDO + QTD. A CLASSIFICAR)		
	nSaldoSB2 := _nB2Qatu - (_nB2QEmp+_nB2Rese+_nB2QPed+_nB2QACl)
	nSaldoSB2 := IIF(nSaldoSB2>0,nSaldoSB2,0)
	nSalPrev := (cAlias)->B2_01SALPE //AFD20180601.N
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSaldo do Produto fora de linha da loja que estiver realizando a venda - #ES20180607ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ-ฤฤฤฤฤฤฤู
	If (cAlias)->B1_01FORAL == 'F' .And. nSaldoSB2 == 0//#CMG20180926.n - verifica se nใo tem saldo no 01 para procurar saldo de mostruario
		
		_lForal := .T.	//#RVC20181121.n
		
		cQry := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_LOCALIZ," + CRLF
		cQry += " B2_QATU, B2_QEMP, B2_RESERVA, B2_QPEDVEN, B2_QACLASS FROM "+RetSqlName("SB2")+" SB2 " + CRLF
		cQry += " WHERE RIGHT(B2_FILIAL,2) = '" + RIGHT(CFILANT,2) + "' " + CRLF 
		cQry += " AND D_E_L_E_T_ = ' ' " + CRLF
		cQry += " 	AND B2_COD = '" + (cAlias)->B1_COD + "' " + CRLF
		cQry += " 	AND B2_LOCAL = '" + _cSYLocPad + "' " + CRLF //#CMG20181123.n		
		cQry += " 	AND (SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + SB2.B2_QPEDVEN)) > 0 " + CRLF
		
		If Select("PFL") > 0
			PFL->(DbCloseArea())
		EndIf
		
		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"PFL",.F.,.T.)
		                
		_nB2QEmp := IIF(PFL->B2_QEMP<0,0,PFL->B2_QEMP)
		_nB2Rese := IIF(PFL->B2_RESERVA<0,0,PFL->B2_RESERVA)
		_nB2QPed := fQtdPed(PFL->B2_COD,_cSYLocPad)//IIF(PFL->B2_QPEDVEN<0,0,PFL->B2_QPEDVEN) - #CMG20181113.n
		_nB2QACl := IIF(PFL->B2_QACLASS<0,0,PFL->B2_QACLASS)
		_nB2QAtu := IIF(PFL->B2_QATU<0,0,PFL->B2_QATU)	
			           				
		//Se tiver saldo na loja considera esse saldo, caso contrario busca saldo da Matriz - CD 01
		nSaldoSB2 := _nB2Qatu - (_nB2QEmp+_nB2Rese+_nB2QPed+_nB2QACl)    
		nSaldoSB2 := IIF(nSaldoSB2<0,0,nSaldoSB2)
		lFora := Iif(nSaldoSB2 > 0,.T.,.F.) //#CMG20180718.n
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ A tabela de pre็o serah por fornecedor sendo necessแrio      ณ	 
	//ณ	localizar o produto em N tabelas priorizando a tabela de     ณ	
	//ณ	fornecedor e na sequencia a tabela principal #Ellen 04062018 ณ	
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	DbSelectArea("DA0") 
	Dbsetorder(1)
	
	DbSelectArea("DA1") 
	DA1->(DbSetOrder(1))
	
	DA0->(DbGotop())
	While DA0->(!Eof())
		//If DA0->DA0_ATIVO == '1' .And. ( DA0->DA0_CODTAB <> '001' .OR. DA0->DA0_CODTAB <> '002' ) - #CMG20180613.o
		If DA0->DA0_ATIVO == '1' .And. ( DA0->DA0_CODTAB <> '001' .And. DA0->DA0_CODTAB <> '002' )  //#CMG20180613.n 
		If DA1->(MsSeek(xFilial("DA1") + DA0->DA0_CODTAB + (cAlias)->B1_COD ))
			nPrcven := DA1->DA1_PRCVEN 
				AAdd(aTabela,DA1->DA1_CODTAB)
			Exit
		Endif 
		Endif
	DA0->(DbsKIP())
	EndDo
	If nPrcven > 0
		AAdd(aRegs3 ,{.F.,(cAlias)->B1_COD,(cAlias)->B1_DESC,nPrcven,nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N", Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		nPrcven := 0
	Else
		aDados := KMHTAB001((cAlias)->B1_COD)// Verifica se existe na tabela principal
		If Len(aDados) > 0  
			AAdd(aRegs3 ,{.F.,(cAlias)->B1_COD,(cAlias)->B1_DESC,aDados[1][2],nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N",Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		Else // Se nao tem na tabela de preco por fornecedor retorna preco zero
			AAdd(aRegs3 ,{.F.,(cAlias)->B1_COD,(cAlias)->B1_DESC,0,nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N",Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		Endif
		cTabpad := '001'
	Endif
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

DA0->( dbCloseArea() )
DA1->( dbCloseArea() )

If Len(aRegs3)==0
	aRegs3 := {{.F.,"","",0,0,0,"","","",.F.}}
Endif

oGetD3:aArray := aClone(aRegs3)
oGetD3:Refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSyCarPrcMEบAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os produtos das medidas especiais.                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SyCarPrcME(cProduto,nLargura,nAltura,nCompri)

Local aArea 		:= GetArea()
Local cAlias    	:= GetNextAlias()
Local nVlrM2 		:= 0
Local nY			:= 0
Local nValorM2		:= 0
Local nVlrVda		:= 0
Local nCustoIpi		:= 0
Local nCustoFrete	:= 0
Local cQry			:= ''
Local cSku			:= ''
Local cRegraME		:= ''
Local cColuna		:= ''
Local cLinha		:= ''
Local aSepara		:= {}
Local aMedidas		:= {}
Local aRegs			:= {}

If nLargura = 0
	MsgStop( "ษ necessแrio informar a Largura do produto","Aten็ใo" )
	RestArea(aArea)
	Return
ElseIf nCompri == 0
	MsgStop( "ษ necessแrio informar o comprimento do produto","Aten็ใo" )
	RestArea(aArea)
	Return
Endif

aRegs4 := {}

DbSelectArea("SB4")
DbSetOrder(1)
DbSeek(xFilial("SB4") + cProduto )
cRegraME := SB4->B4_01REGME
cColuna	 := SB4->B4_COLUNA
cLinha	 := SB4->B4_LINHA

nVlrM2 	 := (nLargura*nCompri)

//Medida Especial nao linear
If cRegraME=="2"
	
	cQry += " SELECT DISTINCT B1_01LNGRD,B1_01CLGRD,BV_DESCRI,B1_01VLRME,B1_01RFGRD,B1_01DREF "
	cQry += " FROM "+RetSqlName("SB1")+" SB1 "
	cQry += " INNER JOIN "+RetSqlName("SBV")+" SBV ON BV_TABELA = '"+SB4->B4_COLUNA+"' AND BV_CHAVE = B1_01CLGRD AND SBV.D_E_L_E_T_ = ' ' "
	cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' "//Eduardo 27/11/2014
	cQry += " WHERE B1_01PRODP = '"+cProduto+"' "
	cQry += " AND B1_01VLRME > 0 "
	cQry += " AND SB1.B1_MSBLQL <> '1' " //#RVC20180416.n 
	cQry += " AND SB1.D_E_L_E_T_ = ' ' "
	cQry += " ORDER BY B1_01RFGRD,B1_01LNGRD,B1_01CLGRD "
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
	(cAlias)->(DbGotop())
	While (cAlias)->(!Eof())
		
		aSepara := Separa( UPPER(Alltrim((cAlias)->BV_DESCRI)) ,"X" )
		
		AAdd( aMedidas , { 	Val(StrTran(aSepara[1],',','.')) * Val(StrTran(aSepara[2],',','.')) ,;
		Alltrim((cAlias)->B1_01RFGRD)+'-'+Alltrim((cAlias)->B1_01DREF),;
		Alltrim((cAlias)->B1_01LNGRD)	,;
		Alltrim((cAlias)->BV_DESCRI)	,;
		(cAlias)->B1_01VLRME 	 	  	})
		
		(cAlias)->(DbsKIP())
	End
	(cAlias)->( dbCloseArea() )
	aSort(aMedidas,,,{ |x,y| y[1] > x[1] } )
	
	//Busca o preco da medida mais proxima.
	For nY := 1 To Len(aMedidas)
		nPos := Ascan( aRegs , {|x| Left(x[2],2)+x[3] == Left(aMedidas[nY,2],2)+aMedidas[nY,3] } )
		If (nVlrM2 <= aMedidas[nY,1]) .And. (nPos==0)
			AAdd(aRegs , { nVlrM2 , aMedidas[nY,2] , aMedidas[nY,3] , Posicione('SBV',1,xFilial('SBV')+cLinha+aMedidas[nY,3],'BV_DESCRI') , aMedidas[nY,5] } )
		Endif
	Next
	
	//Quando Valor do M2 for maior que todas as medidas no sistema, busco o valor da ultima medida.
	If Len(aRegs)==0
		aSort(aMedidas,,,{ |x,y| y[1] > x[1] } )
		For nY := 1 To Len(aMedidas)
			nPos := Ascan( aRegs , {|x| Left(x[2],2)+x[3] == Left(aMedidas[nY,2],2)+aMedidas[nY,3] } )
			If nPos==0
				AAdd(aRegs , { nVlrM2 , aMedidas[nY,2] , aMedidas[nY,3] , Posicione('SBV',1,xFilial('SBV')+cLinha+aMedidas[nY,3],'BV_DESCRI') , aMedidas[nY,5] } )
			Endif
		Next
	Endif
	
	For nY := 1 To Len(aRegs)
		nCusto		:= ( aRegs[nY,1] * aRegs[nY,5] )
		nCustoIpi	:= nCusto*(SB4->B4_IPI/100)
		nCustoFrete	:= (nCusto+nCustoIpi)*(SB4->B4_01VLFRE/100)
		nVlrVda		:= (nCusto+nCustoIpi+SB4->B4_01VLMON+SB4->B4_01VLEMB+nCustoFrete+SB4->B4_01ST) * SB4->B4_01MKP
		AAdd( aRegs4 , {.F.,aRegs[nY,2],aRegs[nY,3],aRegs[nY,4],nVlrVda,"" })
	Next
	
Else
	
	cQry += " SELECT DISTINCT B1_01LNGRD,BV_DESCRI, B1_01VLRM2,B1_01RFGRD,B1_01DREF "
	cQry += " FROM "+RetSqlName("SB1")+" SB1 "
	cQry += " INNER JOIN "+RetSqlName("SBV")+" SBV ON BV_TABELA = '"+SB4->B4_LINHA+"' AND BV_CHAVE = B1_01LNGRD AND SBV.D_E_L_E_T_ = ''
	cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' "//Eduardo 27/11/2014
	cQry += " WHERE B1_01PRODP = '"+cProduto+"' "
	cQry += " AND B1_01VLRM2 > 0 "
	cQry += " AND SB1.B1_MSBLQL <> '1' " //#RVC20180416.n
	cQry += " AND SB1.D_E_L_E_T_ = ' ' "
	cQry += " ORDER BY B1_01RFGRD,B1_01LNGRD
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	While (cAlias)->(!Eof())
		
		nCusto		:= ( nVlrM2 * (cAlias)->B1_01VLRM2 )
		nCustoIpi	:= (cAlias)->B1_01VLRM2 * (SB4->B4_IPI/100)
		nCustoFrete	:= ((cAlias)->B1_01VLRM2+nCustoIpi)*(SB4->B4_01VLFRE/100)
		nVlrVda		:= (nCusto+nCustoIpi+SB4->B4_01VLMON+SB4->B4_01VLEMB+nCustoFrete+SB4->B4_01ST)*SB4->B4_01MKP
		
		AAdd( aRegs4 , {	.F. ,;
		Alltrim((cAlias)->B1_01RFGRD)+'-'+Alltrim((cAlias)->B1_01DREF),;
		Alltrim((cAlias)->B1_01LNGRD),;
		Alltrim((cAlias)->BV_DESCRI),;
		nVlrVda,;
		"" })
		
		(cAlias)->(DbsKIP())
	End
	(cAlias)->( dbCloseArea() )
	
Endif

If Len(aRegs4)==0
	aRegs4 := {{.F.,"","","",0,""}}
Endif

oGetD4:aArray := aClone(aRegs4)
oGetD4:Refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณa103Sair	บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo ao sair da tela principal                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function a103Sair(aRegs2,oGetD2)

Local aArea := GetArea()

oGetD2:aArray := aClone(aRegs2)
oGetD3:aArray := aClone(aRegs3)
oGetD4:aArray := aClone(aRegs4)

LjMsgRun("Por favor aguarde, adicionando itens...",, {|| A103Grava() })

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103Grava	บAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os itens no acols.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103Grava()

Local aArea 	:= GetArea()
Local cProduto 	:= oGetD1:aCols[oGetD1:nAt,1]
Local cRef		:= If(Valtype(cComboR)<>"N",Left(cComboR,nTamRef),'')
Local cTam		:= If(Valtype(cComboM)<>"N",Left(cComboM,nTamCol),'')
Local nX		:= 0
Local lGrava	:= .F.
Local lGravaOK	:= .F.
Local aTemp		:= {}	
Local cTabela  := ""	

//Medidas Padroes
If !Empty(cProduto) .And. !Empty(cTam)
	
	For nX := 1 To Len(oGetD2:aArray)
		If oGetD2:aArray[nX][1]
			lGrava 	 := .T.
			lGravaOK := .T.
			Exit
		EndIF
	Next
	
	If lGrava
		A103IncItens(oGetD2:aArray,cProduto,cRef,cTam)
	EndIF
	
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca a tabela de preco a ser usada - #Ellen 02.06.2018         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aTabela) > 0 
	cTabela := aTabela[1]
Else
	cTabela := '001'//cTabpad // Emergencial para ajuste posterior
Endif
For nX := 1 To Len(aTabela)
	nPos := aScan(aTabela, {|x|x  == cTabela})
	If  nPos > 0 .And. cTabela <> aTabela[nPos]    
		aadd(aTemp,aTabela[nPos])
	Else
		Iif ( Len(aTabela) == nX,cTabela := aTabela[nX],	cTabela := aTabela[nX+1] ) 
	Endif
Next nX
If Len(aTemp) > 0 
	lGrava	 := .F.
	lGravaOK := .F.
	MsgStop( "A็ใo nใo permitida. Produtos de diferentes tabelas de pre็o, selecione um produto por vez","Aten็ใo" )
	Return
Else

	//#CMG20180608.bn
	DbSelectArea("SB4")
	DbSetOrder(1)
	DbSeek(xFilial("SB4") + cProduto )
	
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	
	SA2->(DbSeek(xFilial("SA2")+SB4->B4_PROC+SB4->B4_LOJPROC))
	
	If !Empty(Alltrim(SA2->A2_XTABELA))
		cTabPad := SA2->A2_XTABELA
	Else
		cTabpad  := cTabela //#CMG20180628.n
	EndIf
	//#CMG20180608.en
			
	lGrava	 := .T.
	lGravaOK := .T.
Endif
//Produtos
lGrava	:= .F.
For nX := 1 To Len(oGetD3:aArray)
	If oGetD3:aArray[nX][1]
		lGrava 	 := .T.
		lGravaOK := .T.
		Exit
	EndIF
Next
If lGrava
	A103IncItens(oGetD3:aArray,,,)
EndIF

//Medidas Especiais
lGrava	:= .F.
For nX := 1 To Len(oGetD4:aArray)
	If oGetD4:aArray[nX][1]
		lGrava 	 := .T.
		lGravaOK := .T.
		Exit
	EndIF
Next
If lGrava
	Begin Transaction
	A103NewItens(cProduto,oGetD4:aArray)
	End Transaction
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta para o maior prazo de entrega dos produtos selecionados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//U_A103AJDTENT(0,1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta os valores de frete por data de entrega.				  ณ
//ณSo poderแ existir um valor por data de entrega.				  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lGravaOK
	U_A103AjVlrFre(.T.)
EndIF

If !lGravaOK
	MsgStop("Nใo foi selecionado nenhum item para carregar no atendimento.","Aten็ใo")
Endif

aTabela := {}
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103IncItensบAutor  ณMicrosiga         บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui os itens selecionados no acols.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103IncItens(aItens,cProduto,cRef,cTam)

Local cItem		:= ''
Local cSku		:= ''
Local nAtual	:= 0
Local nColuna	:= 0
Local nCont		:= 0
Local nPItem	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_ITEM"})
Local nPProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nPQtd		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPDtEntre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DTENTRE"})
Local nPPrzEntr	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PE"})
Local nPTabPad	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nPVlrFre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01VALFR"})
Local nPTpEntre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TPENTRE"})
Local nPFilSai 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_FILSAI"})
Local nPForFat 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_XFORFAT"})
Local nPLocal 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_LOCAL"})
Local nMostru 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_MOSTRUA"})
Local n01DESCL 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01DESCL"})
Local n01DESME 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01DESME"})
Local nUB_TES 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TES"})    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ESTAVA TRAZENDO O VALOR UNITARIO ZERADO. FOI FORCADO A GRAVACAO DOS VALORES - LUIZ EDUARDO F.C. - 22.08.2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nUB_VRUNIT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Local nUB_QUANT   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"}) 
Local nUB_VLRITEM := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"}) 
Local nUB_PRCTAB  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"}) 

Local lSomaIt	:= .T.
Local cEstEnt 	:= ""
Local cMunEnt 	:= ""
Local cProd	    := ""
Local cLocal	:= ""
Local cTESCont  := GetMV("KM_TESCONT",,"631")

If Len(aCols) > 0 .And. !Empty(aCols[1][nPProd])
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega o conteudo o ultimo item (Valor)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cItem 	:= aCols[Len(aCols)][nPItem]
	nAtual	:= Len(aCols)
Else
	aCols 	:= {}
	cItem 	:= '00'
	nAtual	:= Len(aCols)
Endif

If !lProspect
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA ))
	cEstEnt := If(!Empty(SA1->A1_ESTE)		,SA1->A1_ESTE		,SA1->A1_EST)
	cMunEnt := If(!Empty(SA1->A1_01MUNEN)	,SA1->A1_01MUNEN	,SA1->A1_COD_MUN)
Else
	SUS->(DbSetOrder(1))
	SUS->(DbSeek(xFilial("SUS") + M->UA_CLIENTE + M->UA_LOJA ))
	cEstEnt := SUS->US_EST
	If SUS->(FieldPos("US_01MUNEN")) > 0
		cMunEnt := SUS->US_01MUNEN
	Else
		cMunEnt := ""
	Endif
Endif

CC2->(DbSetOrder(1))
CC2->(DbSeek(xFilial("CC2") + cEstEnt + cMunEnt ))

For nCont := 1 to Len(aItens)
	
	If aItens[nCont,1]
		
		If Len(aCols) == 0
			
			AADD(aCols,Array(Len(aHeader)+1))
			nAtual++
			
		ElseIf !Empty(aCols[Len(aCols)][nPProd])
			
			AADD(aCols,Array(Len(aHeader)+1))
			nAtual++
		Else
			
			oGetTlv:oBrowse:GoTop()
			oGetTlv:oBrowse:Refresh()
			
			AADD(aCols,Array(Len(aHeader)+1))
			nAtual 				:= Len(aCols)
			oGetTlv:oBrowse:nAT	:= Len(aCols)
			lSomaIt			 	:= .F.
			
		Endif
		
		
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
		
		If !Empty(cProduto)
			
			cSku := Padr(Substr(cProduto,1,nTamPai),nTamPai)	//Pai
			cSku += Substr(aItens[nCont,2],1,nTamLin) 			//Cor
			cSku += Substr(cTam,1,nTamCol)						//Tam
			cSku += Substr(cRef,1,nTamRef)	 					//Ref
			cSku := Padr(cSku,TamSx3("B1_COD")[1])				//SKU
			
			SB1->( DbSetOrder(1) )
			IF !SB1->( DbSeek( xFilial("SB1")+cSku ) )
				Alert('Este SKU nใo existe ['+Alltrim(cSku)+'] na Filial: ' + cFilAnt )
				Loop
			EndIF
			
		Endif                                                            
				
		cProd := If( !Empty(cProduto) , cSku , Padr(aItens[nCont,2],TamSx3("B1_COD")[1]) )
		
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek( xFilial("SB1") + cProd ) )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza o aCols com o acessorio, atualizado o item o produto e a quantidade alem da funcao fiscal ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cItem 			 	  		:= If(lSomaIt,Soma1(cItem,Len(cItem)),cItem)
		aCols[nAtual][nPItem] 		:= cItem
		
		M->UB_PRODUTO	 	  		:= If( !Empty(cProduto) , cSku , cProd )
		aCols[nAtual][nPProd] 		:= If( !Empty(cProduto) , cSku , cProd )
		
		M->UB_QUANT  		 		:= 1
		aCols[nAtual][nPQtd] 		:= M->UB_QUANT
		
		M->UB_TPENTRE				:= '3'
		aCols[nAtual][nPTpEntre]	:= M->UB_TPENTRE
		
		M->UB_01VALFR				:= If(Empty(M->UA_01PEDAN),CC2->CC2_VLRFRE,0) //Caso o campo Pedido Vinculado esteje preenchido nao deve calcular o frete.
		aCols[nAtual][nPVlrFre]		:= M->UB_01VALFR
		
		M->UB_01TABPA				:= If( !Empty(cProduto),cTabPad,If(!Empty(MV_PAR01),MV_PAR01,cTabPad)) //If( !Empty(cProduto),cTabPad,If(aItens[nCont,7]=="S",MV_PAR01,cTabPad))
		aCols[nAtual][nPTabPad]		:= M->UB_01TABPA
		
		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2") + SB4->B4_PROC + SB4->B4_LOJPROC))
		
		M->UB_XFORFAT				:= SA2->A2_XFORFAT
		aCols[nAtual][nPForFat]		:= M->UB_XFORFAT
		
		//Tratamento dos armazens
		If SB4->B4_01PCEXC=="1"
			cLocal := RetLocPcExc(If(M->UB_XFORFAT=="1",cFilAnt,cLocDep))
		Elseif aItens[nCont][7] == 'F' .And. aItens[nCont][9] != '01' // Produto fora de linha com estoque na loja origem da venda
			cLocal := aItens[nCont][9] 
		ElseIf (!Empty(MV_PAR01)) .And. (cTabMost==MV_PAR01)
			If M->UB_XFORFAT=="1"
				cLocal := "02"
			Else
				cLocal := cArmMos
			Endif
		Else
			cLocal := SB1->B1_LOCPAD
		Endif
		
		IF LEN(AITENS[1]) >= 10
			IF !AITENS[nCont,10]
				M->UB_CONDENT				:= RetSalProd(If(M->UB_XFORFAT=="1",cFilAnt,cLocDep),M->UB_PRODUTO,cLocal)
				aCols[nAtual][nPCondEnt]	:= M->UB_CONDENT
			EndIF
		Else
			M->UB_CONDENT					:= RetSalProd(If(M->UB_XFORFAT=="1",cFilAnt,cLocDep),M->UB_PRODUTO,cLocal)
			aCols[nAtual][nPCondEnt]		:= M->UB_CONDENT
		EndIF
		
		M->UB_FILSAI				:= cLocDep
		aCols[nAtual][nPFilSai]		:= M->UB_FILSAI
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ TRATA MEDIDA ESPECIALณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF LEFT(ALLTRIM(AITENS[nCont,6]),2) == "ME"
			aCols[nAtual][n01DESME] := AITENS[nCont,6]
		EndIF
	
		//#CMG20180726.bn	
		If SB1->B1_XACESSO == '1'//SE FOR ACESSORIO 

			aCols[nAtual][n01DESCL]	    := "ESTOQUE PRINCIPAL" 
			aCols[nAtual][nMostru]		:= "4"

		Else
		
			aCols[nAtual][n01DESCL]	    := "ESTOQUE PRINCIPAL"
			aCols[nAtual][nMostru]		:= "1"
		
		EndIf
		//#CMG20180726.en

		M->UB_PE					:= If(M->UB_CONDENT=='1',nVlPrzMe,If(M->UB_CONDENT=="2",SB1->B1_PE,SB1->B1_PE))       `
		aCols[nAtual][nPPrzEntr]	:= M->UB_PE
		
//		M->UB_DTENTRE				:= If(M->UB_CONDENT=="2",(dDatabase+M->UB_PE),Ctod(""))		//#RVC20180711.o
//		M->UB_DTENTRE				:= If(M->UB_CONDENT=="2",(dDatabase+M->UB_PE),dDatabase)	//#RVC20180728.o
		M->UB_DTENTRE				:= If(M->UB_CONDENT=="2",(dDatabase+M->UB_PE),dDatabase+30)	//#RVC20180728.n
		aCols[nAtual][nPDtEntre]	:= M->UB_DTENTRE
		
		//IF !AITENS[nCont,10]
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualizar a variavel n, pois as funcoes fiscais usam ela como referencia                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		n := nAtual
		TKP000A(M->UB_PRODUTO,nAtual,NIL)
		
		n := nAtual
		TKP000B(M->UB_QUANT,nAtual)
		//EndIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza as informacoes do acols em relacao a MatXFis para o novo item. |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MaFisToCols(aHeader,aCols,nAtual,"TK273",.F.)
		Tk273Calcula("UB_PRODUTO",nAtual)
		U_A103Recalc(nAtual,.T.,.T.)

		//#CMG20180726.bn		
		If SB1->B1_XACESSO == '1'//SE FOR ACESSORIO

			M->UB_LOCAL				:= _cSYLocPad
			aCols[nAtual][nPLocal]	:= M->UB_LOCAL
			aCols[nAtual][n01DESCL]	:= "ESTOQUE PRINCIPAL"
		//#CMG20180726.en

		Else
		
			If SB4->B4_01PCEXC=="1"
				M->UB_LOCAL				:= RetLocPcExc(If(M->UB_XFORFAT=="1",cFilAnt,cLocDep))
				aCols[nAtual][nPLocal]	:= M->UB_LOCAL
				aCols[nAtual][n01DESCL]	:= "ESTOQUE PRINCIPAL"
				
			ElseIf ((!Empty(MV_PAR01)) .And. (cTabMost==MV_PAR01))
				If M->UB_XFORFAT=="1"
					M->UB_LOCAL				:= "02"
					aCols[nAtual][nPLocal]	:= M->UB_LOCAL
					aCols[nAtual][n01DESCL]	:= "ESTOQUE PRINCIPAL"
				Else
					If M->UB_CONDENT=="1"
						M->UB_LOCAL				:= cArmMos
						aCols[nAtual][nPLocal]	:= M->UB_LOCAL
						aCols[nAtual][n01DESCL]	:= "ESTOQUE PRINCIPAL"
					Else
						M->UB_LOCAL				:= SB1->B1_LOCPAD
						aCols[nAtual][nPLocal]	:= M->UB_LOCAL
						aCols[nAtual][n01DESCL]	:= "ESTOQUE PRINCIPAL"
					Endif
				Endif
			Endif
			
		EndIf
		
		IF LEN(AITENS[1]) >= 10
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ TRATAMENTO PARA CASO DE PRODUTO DE MOSTRUมRIO ณ
			//ณ CARREGA LOCAL, FILIAL DE SAIDA E QUANTIDADE   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF AITENS[nCont,10]
				cLocal						:= AITENS[nCont,8]
				aCols[nAtual][nPLocal]   	:= AITENS[nCont,8]
				aCols[nAtual][nPFilSai] 	:= AITENS[nCont,9]
				DbSelectArea("NNR")
				NNR->(DbSetOrder(1))
				NNR->(DbSeek(aCols[nAtual][nPFilSai] + aCols[nAtual][nPLocal]))
				aCols[nAtual][n01DESCL]     := NNR->NNR_DESCRI
				aCols[nAtual][nPQtd]    	:= AITENS[nCont,5]
				aCols[nAtual][nPCondEnt]   	:= "1"
				aCols[nAtual][nMostru]		:= "2"
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณRetorna o armazem da loja que realizou a venda nos casos 'fora de linha'|
				//ณ#Ellen 20180608                                                         |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
			Elseif aItens[nCont][7] == 'F' .And. aItens[nCont][9] != '01' 
				aCols[nAtual][nPLocal]   	:= AITENS[nCont,9]    
				aCols[nAtual][nMostru]		:= "2"				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza as informacoes do acols em relacao a MatXFis para o novo item. |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				MaFisToCols(aHeader,aCols,nAtual,"TK273",.F.)
				U_A103Recalc(nAtual,.T.,.T.)
			EndIF
		EndIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ TRATAMENTO PARA CLIENTES FORA DO ESTADA NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.07.2017 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF ALLTRIM(SA1->A1_EST) <> "SP"
			IF SA1->A1_CONTRIB == "2"
				aCols[nAtual][nUB_TES] := cTESCont
			EndIF
		EndIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ TRATAMENTO PARA A GRAVACAO DOS CAMPOS DE VALORES - LUIZ EDUARDO F.C. - 22.08.2017 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		//aCols[nAtual,nUB_VRUNIT]  := aItens[nCont,4]
		//aCols[nAtual,nUB_VLRITEM] := aItens[nCont,4]		
		
	Endif
	
Next nCont

n := nAtual

If Len(aCols) >= 1
	oGetTlv:oBrowse:GoTop()
	oGetTlv:oBrowse:Refresh()
Endif

Eval(bGDRefresh)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103NewItensบAutorณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria produtos para inserir no acols.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103NewItens(cProduto,aItens)

Local aArea 	:= GetArea()
Local cColuna 	:= ''
Local cChave	:= ''
Local cCodigo	:= ''
Local cDescricao:= ''
Local aProdutos	:= {}
Local nCont

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4")+cProduto))
cColuna := SB4->B4_COLUNA

For nCont := 1 To Len(aItens)
	
	If aItens[nCont,1]
		
		cChave  := A103UltChv(cColuna)
		
		cCodigo	:= A103CriaSB1(	cProduto,;
		Left(aItens[nCont,2],nTamRef),;					//Referencia
		Substr(aItens[nCont,2],nTamRef+2,Len(aItens[nCont,2])),;	//Desc Referencia
		aItens[nCont,3],;									//Cor
		cChave,;											//Tamanho
		@cDescricao,;   									//Descricao Produto
		aItens[nCont,5],;
		aItens[nCont,6] )									//Preco de Venda
		
		AAdd( aProdutos , { .T. , cCodigo , cDescricao , aItens[nCont,5]  , 0 , aItens[nCont,6]  })
		
		cDescricao := ''
		
	Endif
	
Next

A103IncItens(aProdutos,,,)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraFotoบAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra fotos dos produtos                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MostraFoto(cProduto,oPainelFoto)

Local cFile	:= MVDirFoto + Alltrim(cProduto) + ".JPG"

oFoto:= TBITMAP():New(0,0,0,0,,,,oPainelFoto,,,.T.,.F.,,,,,.T.)
oFoto:Align 	:= CONTROL_ALIGN_ALLCLIENT
oFoto:lStretch 	:= .T.

IF File(cFile)
	oFoto:Load(,cFile)
	oFoto:Refresh()
Else
	oFoto:Load(,MVDirFoto+"SEMFOTO.JPG")
	oFoto:Refresh()
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103UltChvบAutor  ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca a ultimo registro na tabela de grades.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103UltChv(cColuna)

Local aAreaAtu 	:= GetArea()
Local cNextCod	:= ""
Local cQuery 	:= ""
Local cString	:= ""
Local cChave	:= GetMv("MV_SYCHVME",,"ME")

If nLargura > 0
	cString += Alltrim(Transform(nLargura,PesqPict('SB4','B4_01LARMI')))+"X"
Endif

If nCompri > 0
	cString += Alltrim(Transform(nCompri,PesqPict('SB4','B4_01LARMI')))+"X"
Endif

If nAltura > 0
	cString += Alltrim(Transform(nAltura,PesqPict('SB4','B4_01LARMI')))+"X"
Endif
cString := Substr(cString,1,Len(cString)-1)

cQuery := " SELECT TOP 1 * FROM "+RetSqlName("SBV")+" WHERE BV_TABELA = '"+cChave+"' AND BV_DESCRI LIKE '%"+cString+"%' AND D_E_L_E_T_ = ' ' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSBV",.T.,.T.)

If TMPSBV->( EOF() )
	If SELECT("TMPSBV") > 0
		TMPSBV->(dbCloseArea())
	Endif
	
	cQuery := " SELECT ISNULL(MAX(BV_CHAVE),'01') BV_CHAVE FROM "+RetSqlName("SBV")+" WHERE BV_TABELA = '"+cChave+"' AND D_E_L_E_T_ = ' ' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSBV",.T.,.T.)
	
	While TMPSBV->(!EOF())
		cNextCod := SOMA1(Alltrim(TMPSBV->BV_CHAVE))
		TMPSBV->(dbSkip())
	EndDo
	
	//Realiza a gravacao da medida especial na tabela de colunas do produto selecionado.
	DbSelectArea("SBV")
	RecLock("SBV",.T.)
	SBV->BV_FILIAL := xFilial("SBV")
	SBV->BV_TABELA := cChave //'ME' //cColuna
	SBV->BV_CHAVE  := cNextCod
	SBV->BV_DESCRI := cString
	SBV->BV_TIPO   := '2'
	Msunlock()
	
Else
	
	While TMPSBV->(!EOF())
		cNextCod := TMPSBV->BV_CHAVE
		TMPSBV->(dbSkip())
	EndDo
	
EndIF
TMPSBV->(dbCloseArea())

RestArea(aAreaAtu)

Return cNextCod

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103CriaSB1บAutor ณMicrosiga           บ Data ณ  20/01/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCriacao de produtos novos.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103CriaSB1(cProduto,cRef,cDescRef,cCor,cTam,cDescricao,nPreco,cDescME)

Local aArea		 := GetArea()
Local cCodigo 	 := ''
Local cChave	 := GetMv("MV_SYCHVME",,"ME")
Local aStructSB4 := SB4->(DbStruct())
Local aCampos	 := {}
Local aPrecos	 := {}

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4")+cProduto))

For nY := 1 To Len(aStructSB4)
	Aadd(aCampos,Alltrim(Substr(aStructSB4[nY,1],3,8)))
Next

cCodigo := Padr(Substr(cProduto,1,nTamPai),nTamPai)
cCodigo += SubStr(cCor,1,nTamLin)
cCodigo += Substr(cTam,1,nTamCol)
cCodigo += Substr(cRef,1,nTamRef)
cCodigo := Padr(cCodigo,TamSx3("B1_COD")[1])

DbSelectArea('SB1')
DbSetOrder(1)
IF !DbSeek(xFilial("SB1") + cCodigo)
	RecLock('SB1',.T.)
	B1_FILIAL 	:= xFilial('SB1')
	B1_COD 		:= cCodigo
	B1_GRADE    := 'S'
	B1_CUSTD	:= nPreco / SB4->B4_01MKP
	B1_PE		:= SB4->B4_PE
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Preco de Venda := (Custo + IPI + Montagem + Embalagem + Frete + ST) * Markup   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	B1_PRV1		:= nPreco
Else
	RecLock('SB1',.F.)
EndIF

For nX := 1 to Len(aCampos)
	
	IF aCampos[nX] $ '_FILIAL/_COD/_LINHA/_COLUNA/_STATUS/_PRV1' .Or. ( SB1->(FieldPos("B1" + aCampos[nX])) == 0 .And. !aCampos[nX] $ '_STATUS' )
		Loop
	Elseif aCampos[nX] $ '_MSBLQL'
		SB1->B1_MSBLQL	:= SB4->B4_MSBLQL //IIF( SB4->B4_STATUS == "I" , "1" , "2" )
	Else
		cCampo1 := 'B1' + aCampos[nX]
		cCampo2 := 'SB4->B4' + aCampos[nX]
		Replace &cCampo1 With &cCampo2
		IF cCampo1 == "B1_DESC"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Complementa ou nao a descricao do produto com a Coluna (Tamanho). ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF GetMv("MV_B4COMPL",,.T.)
				cComplemento := ' ' + cDescRef
				cComplemento += ' ' + Alltrim(Posicione("SBV",1,xFilial("SBV")+SB4->B4_LINHA +Alltrim(SubStr(cCor,1,nTamLin)),"BV_DESCRI"))
				cComplemento += ' ' + Alltrim(Posicione("SBV",1,xFilial("SBV")+cChave+Alltrim(Substr(cTam,1,nTamCol)),"BV_DESCRI"))
				cDescricao	 := Alltrim(&cCampo1) + cComplemento
				
				IF !EMPTY(cDescME)
					cComplemento := cComplemento + " // " + cDescME  
					Replace B1_DESC With Alltrim(&cCampo1) + " // " + cDescME
				Else
					Replace B1_DESC With Alltrim(&cCampo1)
				EndIF

			Else
				cDescricao	 := Alltrim(&cCampo1)
				
				IF !EMPTY(cDescME)
					cDescricao := cDescricao + " // " + cDescME
					Replace B1_DESC With Alltrim(&cCampo1) + " // " + cDescME
				Else
					Replace B1_DESC With Alltrim(&cCampo1)
				EndIF
						
			EndIF
		EndIF
	EndIF
	
Next nX
SB1->B1_01PRODP	:= Padr(Substr(cProduto,1,nTamPai),nTamPai)
SB1->B1_01LNGRD	:= SubStr(cCor,1,nTamLin)
SB1->B1_01CLGRD	:= Substr(cTam,1,nTamCol)
SB1->B1_01RFGRD	:= Substr(cRef,1,nTamRef)
SB1->B1_01DREF	:= cDescRef

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza tabela de precos se o produto for de e-commerceณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd( aPrecos , { SB1->B1_COD , SB1->B1_PRV1 } )
U_MA06AtuTab(cTabPad,aPrecos)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza as tabelas SB5 e SBZ                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VA006Fim(SB1->B1_COD,cDescME)

RestArea(aArea)

Return cCodigo

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetSalProdบAutor  ณ SYMM Consultoria   บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o saldo do produto da filial recebida.		  	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RetSalProd(cFilRec,cProduto,cLocal)

Local aArea 	:= GetArea()
Local nRetorno	:= ''
Local nQtdVen	:= 0
Local nQtdPrev	:= 0
Local nPProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nPQtd		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local lQtdPrev	:= .F.
Local lPcExcl	:= .F.

//Tratamento para produtos de mostruario.
If cLocal=="02" .And. cFilRec<>cLocDep
	cFilRec := cFilAnt
Endif

If Len(aCols) > 1
	For nI := 1 To Len(aCols)
		If !aTail( aCols[nI] )
			If nI <> Len(aCols)
				If Alltrim(cProduto)==Alltrim(aCols[nI,nPProd]) .And. aCols[nI,nPCondEnt]=='1'
					nQtdVen  += aCols[nI,nPQtd]
				ElseIf Alltrim(cProduto)==Alltrim(aCols[nI,nPProd]) .And. aCols[nI,nPCondEnt]=='3'
					lQtdPrev := .T.
					nQtdPrev  += aCols[nI,nPQtd]
				Endif
			Endif
		Endif
	Next
Endif

SB2->(DbSetOrder(1))
SB2->(DbSeek(cFilRec + Padr(cProduto,TamSx3("B2_COD")[1]) + cLocal))

If (SB2->B2_QATU - ( nQtdVen  + SB2->B2_QEMP + SB2->B2_RESERVA + SB2->B2_QPEDVEN)) > 0
	nRetorno := '1'
	lPcExcl	 := .T.
Else
	If SB2->B2_01SALPE > 0
		nSaldoEst := SB2->B2_01SALPE - nQtdPrev
		If nSaldoEst > 0
			nRetorno := '3'
		Else
			nRetorno := '2'
		Endif
	Else
		nRetorno := '2'
	Endif
Endif

//Tratamento para pe็a exclusiva
If SB4->B4_01PCEXC=="1" .And. lPcExcl
	nRetorno := '1' //RetLocPcExc(cFilRec)
Endif

RestArea(aArea)

Return nRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103AJDTENTบAutor ณ Eduardo Patriani   บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta para o maior prazo de entrega dos produtos selecionaบฑฑ
ฑฑบDesc.     ณ dos.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A103AJDTENT(nPrazo,cCampo)

Local aArea 	:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local nPPrzEntr	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PE"})
Local nPDtEntre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DTENTRE"})
Local nPCodPro	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nPVlrFre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01VALFR"})
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPrzAtu	:= aCols[n,nPPrzEntr]
Local nDtEntAtu	:= aCols[n,nPDtEntre]
Local aMascara 	:= Separa(GetMv('MV_MASCGRD',,'09,04,02,02'),',')
Local nTamPai  	:= Val(aMascara[1])
Local dDataAtu	:= M->UA_EMISSAO
Local nVlPrzMe  := GetMv("MV_CCPRZME",,10)
Local nVlPrzMa  := GetMv("MV_CCPRZMA",,45)
Local cEstEnt 	:= ""
Local cMunEnt 	:= ""
Local nAtual	:= 0
Local nX		:= 0
Local nPrzOri	:= 0
Local lRet		:= .T.
Local lRetorno	:= .T.
Local lImper	:= .F.

Default nPrazo	:= 0

nAtual := Len(aCols)

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + aCols[n,nPCodPro]))
If aCols[n,nPCondEnt]=='1'
	nPrzOri := nVlPrzMe
Else
	nPrzOri := SB1->B1_PE
Endif

//Servico de Imper nao deve considerar os prazos minimos e maximo
lImper := Left(aCols[n,nPCodPro],nTamPai)=="8010001"

RestArea(aAreaSB1)

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA ))
cEstEnt := If(!Empty(SA1->A1_ESTE)		,SA1->A1_ESTE		,SA1->A1_EST)
cMunEnt := If(!Empty(SA1->A1_01MUNEN)	,SA1->A1_01MUNEN	,SA1->A1_COD_MUN)

CC2->(DbSetOrder(1))
CC2->(DbSeek(xFilial("CC2") + cEstEnt + cMunEnt ))

//Tratamento para valores negativos
If nPrazo < 0
	nPrazo := nPrazo*(-1)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsidera os prazos maximos e minimos na manuten็ใo manual do campoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPrazo > 0 .And. !lImper
	If nPrazo > (nPrzOri + nVlPrzMa) .And. ( M->UA_PEDPEND=='3' .Or. M->UA_PEDPEND=='4' ) //(aCols[n,nPPrzEntr] + nVlPrzMa)
		
		MsgStop( "Prazo Negado !!" )
		lRet := .F. //A103AbSenha()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRetorna o valor original caso nao valide a senha      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lRet
			If Alltrim(cCampo) == "M->UB_PE"
				M->UB_PE		   	:= nPrzAtu
				aCols[n,nPPrzEntr]	:= nPrzAtu
			Else
				M->UB_DTENTRE	   	:= nDtEntAtu
				aCols[n,nPDtEntre]	:= nDtEntAtu
			Endif
		Endif
		
	Elseif nPrazo < nPrzOri //(aCols[n,nPPrzEntr] - nVlPrzMe)
		
		MsgStop( "Prazo Negado !!" )
		lRet := .F. //A103AbSenha()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRetorna o valor original caso nao valide a senha      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lRet
			If Alltrim(cCampo) == "M->UB_PE"
				M->UB_PE		   	:= nPrzAtu
				aCols[n,nPPrzEntr]	:= nPrzAtu
			Else
				M->UB_DTENTRE	   	:= nDtEntAtu
				aCols[n,nPDtEntre]	:= nDtEntAtu
			Endif
		Endif
		
		
	Endif
	
ElseIf nPrazo == 0
	
	MsgStop( "Prazo Negado !!" )
	lRet := .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRetorna o valor original caso nao valide a senha      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lRet
		If Alltrim(cCampo) == "M->UB_PE"
			M->UB_PE		   	:= nPrzAtu
			aCols[n,nPPrzEntr]	:= nPrzAtu
		Else
			M->UB_DTENTRE	   	:= nDtEntAtu
			aCols[n,nPDtEntre]	:= nDtEntAtu
		Endif
	Endif
	
Endif

If lRet
	aCols[n,nPPrzEntr] := nPrazo
	aCols[n,nPDtEntre] := dDataAtu + nPrazo
	aCols[n,nPVlrFre]  := If(Empty(M->UA_01PEDAN),CC2->CC2_VLRFRE,0)
Endif
U_A103AjVlrFre(.T.)

n := nAtual
Eval(bGDRefresh)

RestArea(aArea)

Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103AbSenhaบAutor ณMicrosiga           บ Data ณ  02/13/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAbertura da tela de senha de autorizacao.                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103AbSenha()

Local aUsers	:= {}
Local cBitMap	:= "LOGIN"						// Bitmap utilizado na caixa de dialogo
Local aCodSup	:= LjRetSup(1,"",@aUsers)		// Codigos dos Caixas Superiores
Local cCodSup	:= ""							// Codigo do Caixa Superior escolhido pelo caixa
Local cCaixaAtu	:= cUserName					// Caixa atual
Local cCaixaSup	:= ""
Local cSuperSel := ""
Local nTamUser  := 25                           // Tamanho do campo do usuario
Local nTamPass  := 20                           // Tamanho do campo da senha
Local cSenhaSup	:= Space( nTamPass )			// Senha digitada do supervisor
Local cIDBkp	:= __cUserID					// Guarda o ID do usuario atual
Local cUserBkp	:= cUserName					// Guarda o Nome do usuario atual
Local aRegCx	:= {}
Local lRet		:= .F.

Local oDlgSenha									// Objeto da caixa de dialogo da senha do supervisor
Local oGetSup									// Objeto Get com o nome do superior que informou a senha
Local oGetSenha									// Objeto Get com a senha do superior

PswOrder(1)
If PswSeek(__cUserID)
	aRegCx 	:= PswRet()
	aCodSup := Separa(Alltrim(aRegCx[1][11]),"|",.F.)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona o superior do caixa. Se houver mais de 1 superior,ณ
//ณo caixa seleciona qual superior fara a liberacao            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aCodSup) > 1
	cCodSup	:= A103SelSup( aCodSup , @cSuperSel, aUsers )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houver mais de 1 superior,carrega no MSGET o superior selecionado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aCodSup) > 1
	cCaixaSup := cSuperSel
	
	PswOrder(2)
	PswSeek(cSuperSel)	//Retorna o arquivo de senhas para a posicao original
Else
	cCaixaSup := PadR( cCaixaSup, nTamUser, " " )
	
	PswOrder(1)
	If PswSeek(__cUserID)
		
		aRegCx 	  := PswRet()
		cSuperSel := AllTrim( Left(aRegCx[1][11],6) )
		
		PswOrder(1)
		PswSeek(cSuperSel)	//Retorna o arquivo de senhas para a posicao original
		
		aRegCx 	  := PswRet()
		cCaixaSup := AllTrim( aRegCx[1][2] )
		
	EndIf
	
EndIf

DEFINE DIALOG oDlgSenha TITLE " Autorizacao do Superior " FROM 20, 20 TO 225,310 PIXEL

@ 0, 0 BITMAP oBmp1 RESNAME cBitMap oF oDlgSenha SIZE 50,140 NOBORDER WHEN .F. PIXEL

@ 05,55 SAY "Vendedor Atual"	PIXEL
@ 15,55 MSGET cCaixaAtu WHEN .F. PIXEL SIZE 80,08

@ 30,55 SAY "Superior" PIXEL
@ 40,55 MSGET oGetSup VAR cCaixaSup WHEN .T. PIXEL SIZE 80,08

@ 55,55 SAY "Senha Superior" PIXEL
@ 65,55 MSGET oGetSenha VAR cSenhaSup PASSWORD PIXEL SIZE 40,08 VALID VldSenha(cSenhaSup)

DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION ( IIF( !lRet .OR. Empty(cSenhaSup), lRet := VldSenha(cSenhaSup) , .T. ), oDlgSenha:End() ) ENABLE OF oDlgSenha
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION { || lRet := .F. , oDlgSenha:End() } ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura o ID do usuario atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
__cUserID := cIDBkp
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura o Nome do usuario atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cUserName := cUserBkp

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldSenha  บAutor  ณMicrosiga           บ Data ณ  02/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da senha digitada.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldSenha(cSenhaSup)

lRet := PswName(Alltrim(cSenhaSup))

If !lRet
	MsgStop( "Acesso Negado !!" )
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA103SelSupบAutor  ณ Microsiga          บ Data ณ  14/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSelecao do superior do usuario, quando existir mais de um   บฑฑ
ฑฑบ          ณsuperior cadastrado para o caixa atual                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ ExpA1 - Lista com os codigos dos superiores associados ao  บฑฑ
ฑฑบ          ณ         caixa atual.                                       บฑฑ
ฑฑบ          ณ ExpC2 - Nome do Superior selecionado                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณCodigo do superior escolhido pelo caixa.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function A103SelSup(aSuper,cSuperSel,aUsers)

Local aArea	  		:= GetArea()								// Armazena o posicionamento da tabela atual
Local oDlg			:= NIL										// Objeto da janela
Local oListBox		:= Nil										// Objeto da listbox
Local aListBox 		:= {}										// Array de usuarios superiores da listbox
Local cSuper		:= ""										// Codigo do superior selecionado
Local bOk			:= {||cSuper:=aListBox[oListBox:nAt,1],cSuperSel:=aListBox[oListBox:nAt,2]}	// Codigo executado ao confirmar o superior
Local nX			:= 0										// Auxiliar de loop
Local cReadVarBk	:= ""										// Armazena o conteudo da __readvar
Local aListBox2		:= {}										// Array de usuarios superiores da listbox
Local lCont 		:= .T.										// Se continua com a operacao.
Local nI			:= 0										// Contador

Default aSuper		:= {}
Default cSuperSel	:= ""
Default aUsers      := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Foi inserido abaixo mais uma casa no array aListBox2 ณ
//ณ com o login de Usuแrio do(s) Superior(es)			 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aUsers) > 0
	For nX := 1 to Len(aSuper)
		For nI := 1 to Len(aUsers)
			If aUsers[nI][1][1] == aSuper[nX]
				Aadd(aListBox2,{aUsers[nI][1][1],aUsers[nI][1][2]})
			EndIf
		Next nI
	Next nX
EndIf

If Len(aListBox2) == 0
	RestArea(aArea)
	lCont := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houver apenas 1 superior, nao exibe tela de selecaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lCont
	If Len(aSuper) == 1
		cSuper		:= aSuper[1]
		cSuperSel 	:= aListBox2[1][2]
	Else
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณArmazena o conteudo da variavel publica __ReadVar, modificadaณ
		//ณquando utiliza-se o metodo SetFocus() na ListBox             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Type("__ReadVar") <> "U"
			cReadVarBk := __ReadVar
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTela de selecao de superiorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DEFINE MSDIALOG oDlg TITLE "Sele็ใo de Superior" FROM CRDxTela(0),CRDxTela(0) TO CRDxTela(180),CRDxTela(300) PIXEL	STYLE DS_MODALFRAME STATUS
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDesabilita a saida via ESC ou botao fecharณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oDlg:LESCCLOSE := .F.
		//ฺฤฤฤฤฤฟ
		//ณLabelณ
		//ภฤฤฤฤฤู
		@ CRDxTela(004),CRDxTela(004) TO CRDxTela(90),CRDxTela(115) LABEL "Selecione o superior para libera็ใo:" PIXEL OF oDlg
		//ฺฤฤฤฤฤฤฤฤฟ
		//ณBotao Okณ
		//ภฤฤฤฤฤฤฤฤู
		DEFINE SBUTTON FROM CRDxTela(006),CRDxTela(120) TYPE 1 ENABLE OF oDlg ACTION (Eval(bOk),oDlg:End())
		//ฺฤฤฤฤฤฤฤฟ
		//ณListBoxณ
		//ภฤฤฤฤฤฤฤู
		@ CRDxTela(015),CRDxTela(009) ListBox oListBox Fields HEADER "C๓digo","Nome";
		Size CRDxTela(100),CRDxTela(065) Of oDlg Pixel ColSizes 25,75 ON DblClick(Eval(bOk),oDlg:End())
		
		oListBox:SetArray(aListBox)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณReorganiza o aListBox com as informacoes lidas do SA6ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nX := 1 To Len(aListBox2)
			Aadd(aListBox,{aListBox2[nX][1],aListBox2[nX][2]})
		Next nX
		
		oListBox:bLine := {|| {	aListBox[oListBox:nAT,01],aListBox[oListBox:nAT,02]}}
		oListBox:SetFocus()
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRestaura a __readvarณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(cReadVarBk)
			__readvar := cReadVarBk
		EndIf
		
	EndIf
	
	RestArea(aArea)
EndIf

Return cSuper

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณCRDxTela ณ Autores ณ Vendas Clientes        ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CRDxTela(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

User Function A103AjVlrFre(lProcessa)

Local aArea 	:= GetArea()
Local nPPrzEntr	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PE"})
Local nPValFre	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01VALFR"})
Local nPTpEntre := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TPENTRE"})
Local nPCondEnt	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_CONDENT"})
Local nPFilSai 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_FILSAI"})
Local aDtEntreg := {}
Local nAtual	:= 0
Local nX		:= 0
//Local cCampo	:= ReadVar()
//Local cConteudo := &(ReadVar())
Local lRet		:= .T.

nAtual := Len(aCols)

For nX := 1 To Len(aCols)
	
	If !aTail( aCols[nX] )
		
		If aCols[nX,nPTpEntre]=='1'
			aCols[nX,nPValFre] := 0
			
		ElseIf aCols[nX,nPTpEntre]=='2' //.And. aCols[nX,nPFilSai]==cFilAnt
			aCols[nX,nPValFre] := 0
		Else
			nPos := Ascan( aDtEntreg , aCols[nX,nPPrzEntr] )
			If nPos==0
				AAdd(aDtEntreg , aCols[nX,nPPrzEntr] )
			Else
				aCols[nX,nPValFre] := 0
			Endif
			
		Endif
		
	Endif
	
Next

If lProcessa
	U_A103CALCFRETE(0,'T')
Endif

n := nAtual
Eval(bGDRefresh)

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A103VLD1  บAutor ณ Eduardo Patriani   บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a digitacao das medidas especiais. 				  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103VLD1(nValor,nCondicao)

Local lRet := .T.

If nCondicao==1 .And. nValor > 0
	
	If (nValor < SB4->B4_01LARMI) .And. SB4->B4_01LARMI > 0
		MsgStop( "O valor informado da largura nใo pode ser menor que: "+Transform(SB4->B4_01LARMI,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif (nValor > SB4->B4_01LARMA) .And. SB4->B4_01LARMA > 0
		MsgStop( "O valor informado da largura nใo pode ser maior que: "+Transform(SB4->B4_01LARMA,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif SB4->B4_01LARMI==0 .Or. SB4->B4_01LARMA==0
		MsgStop( "Nใo ้ permitido digitar valores para o campo Largura." ,"Aten็ใo" )
		lRet := .F.
		
	Endif
	
Elseif nCondicao==2 .And. nValor > 0
	
	If (nValor < SB4->B4_01ALTMI) .And. SB4->B4_01ALTMI > 0
		MsgStop( "O valor informado da altura nใo pode ser menor que: "+Transform(SB4->B4_01ALTMI,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif (nValor > SB4->B4_01ALTMA) .And. SB4->B4_01ALTMA > 0
		MsgStop( "O valor informado da altura nใo pode ser maior que: "+Transform(SB4->B4_01ALTMA,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif SB4->B4_01ALTMI==0 .Or. SB4->B4_01ALTMA==0
		MsgStop( "Nใo ้ permitido digitar valores para o campo Altura." ,"Aten็ใo" )
		lRet := .F.
		
	Endif
	
Elseif nCondicao==3 .And. nValor > 0
	
	If (nValor < SB4->B4_01PROMI) .And. SB4->B4_01PROMI > 0
		MsgStop( "O valor informado da profundidade nใo pode ser menor que: "+Transform(SB4->B4_01PROMI,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif (nValor > SB4->B4_01PROMA) .And. SB4->B4_01PROMA > 0
		MsgStop( "O valor informado da profundidade nใo pode ser maior que: "+Transform(SB4->B4_01PROMA,"@E 999.99") ,"Aten็ใo" )
		lRet := .F.
		
	Elseif SB4->B4_01PROMI==0 .Or. SB4->B4_01PROMA==0
		MsgStop( "Nใo ้ permitido digitar valores para o campo Profundidade" ,"Aten็ใo" )
		lRet := .F.
		
	Endif
	
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A103TabelaบAutor ณ Eduardo Patriani   บ Data ณ  25/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os produtos da tabela de preco selecionada.	  	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103Tabela()
MsgRun("Por favor aguarde, Carregando produtos...",, {|| CarregaProd() })
Return

Static Function CarregaProd()
Local cPerg		:= Padr("SYVA103A",10)
Local cQry	 	:= ''
Local cString 	:= ''
Local aHlpPor01 := {"Informe a Tabela de Pre็o da Campanha","",""}
Local aHlpPor02 := {"Informe a Descri็ใo do Produto","",""}
Local aInfo		:= {}
Local cAlias
Local dDataVld  := dDataBase
Local nSaldoSB2	:= 0
Local nSalPrev	:= 0
Local lTabMost	:= .T.
               
//#CMG20180926.bn
Local _nB2QEmp := 0
Local _nB2Rese := 0
Local _nB2QPed := 0
Local _nB2QACl := 0                                         
Local _nB2QAtu := 0
//#CMG20180926.en

PutSx1(cPerg,"01","Tabela de Pre็o"		,"Tabela de Pre็o"	,"Tabela de Pre็o"	,"MV_CH1","C",TamSx3("DA0_CODTAB")[1]	,,,"G","ExistCpo('DA0') .AND. MaVldTabPrc(MV_PAR01,)","DA0",,,"MV_PAR01",,,,CriaVar("DA0_CODTAB",.F.),,,,,,,,,,,,,aHlpPor01,aHlpPor01,aHlpPor01)
PutSx1(cPerg,"02","Descricao Produto"	,"Descricao Produto","Descricao Produto","MV_CH2","C",TamSx3("B1_DESC")[1]		,,,"G",,,,,"MV_PAR02",,,,CriaVar("B1_DESC",.F.),,,,,,,,,,,,,aHlpPor02,aHlpPor02,aHlpPor02)

If !Pergunte(cPerg,.T.)
	Return
Endif

DA0->(DbSetOrder(1))
DA0->(DbSeek(xFilial("DA0") + Mv_Par01 ))
If !Empty(DA0->DA0_FILMOS)
	lTabMost := DA0->DA0_FILMOS==cFilAnt
Endif

If !lTabMost
	MsgStop( "A็ใo nใo permitida. Esta tabela de mostruแrio nใo pertence a esta loja","Aten็ใo" )
	Return
Endif

If !Empty(Mv_Par01)
	
	cQry   := ''
	cAlias := GetNextAlias()
	aRegs3 := {}
	
	If !Empty(Mv_Par02)
		aInfo  := Separa(MV_PAR02,"%",.F.)
		For nI := 1 To Len(aInfo)
			cString += " B1_DESC LIKE '%"+Alltrim(UPPER(aInfo[nI]))+"%' AND"
		Next
		cString := Substr(cString,1,Len(cString)-3)
	Endif
	If Len(aInfo) > 1
		cString := "( "+STRTRAN(cString,"AND","OR")+" )" + CRLF
	Endif
	
	cQry += " SELECT DISTINCT DA1_CODPRO, B1_DESC, DA1_PRCVEN, B1_01FORAL, B1_PROC, B1_LOJPROC, B1_01PRODP, B1_COD, B1_LOCPAD" + CRLF
	cQry += " FROM "+RetSqlName("DA1")+" DA1 " + CRLF
	cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=DA1_CODPRO AND SB1.D_E_L_E_T_ = '' " + CRLF
	cQry += " WHERE DA1_FILIAL = '"+xFilial("DA1")+"' AND" + CRLF
	cQry += " DA1_CODTAB = '"+MV_PAR01+"' AND" + CRLF
	cQry += " ( DA1.DA1_DATVIG <= '"+DtoS(dDataVld)+ "' OR DA1.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND" + CRLF
	If !Empty(Mv_Par02)
		cQry += cString
		cQry += " AND DA1.D_E_L_E_T_ = ' ' " + CRLF
	Else
		cQry += " DA1.D_E_L_E_T_ = ' ' " + CRLF
	Endif
	cQry += " ORDER BY DA1_CODPRO " + CRLF
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
	
	(cAlias)->(DbGotop())
	While (cAlias)->(!Eof())
		
		cLocPad := (cAlias)->B1_LOCPAD //AFD20180601.N
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2") + (cAlias)->B1_PROC + (cAlias)->B1_LOJPROC))
		cFilRec := If(SA2->A2_XFORFAT=="1",xFilial("SUA"),cLocDep)
		
		If (!Empty(MV_PAR01)) .And. (cTabMost==MV_PAR01)
			If SA2->A2_XFORFAT=="1"
				cLocal := "02"
			Else
				cLocal := cArmMos
			Endif
		Else
			cLocal := "01"
		Endif
		
		SB4->(DbSetOrder(1))
		SB4->(DbSeek(xFilial("SB4") + (cAlias)->B1_01PRODP ))
		If SB4->B4_01PCEXC=="1"
			cLocal := RetLocPcExc(cFilRec)
		Endif
		
		If Select("TRB3") > 0
			TRB3->(DbCloseArea())
		EndIf
		
		BeginSql Alias "TRB3"
			SELECT *
			FROM %Table:SB2% SB2
			WHERE
			B2_FILIAL 	= %Exp:cLocDep%
			AND B2_COD 		= %Exp:(cAlias)->B1_COD%
//			AND B2_LOCAL 	= %Exp:cLocPad% //#20181122.o
			AND B2_LOCAL 	= %Exp:_cSYLocPad% //#CMG20181122.b - busca armazem da loja
			AND SB2.%notDel%
		EndSql

		/*//AFD20180601.BO
		IF TRB3->(!Eof())
			nSaldoSB2 := 0 // O saldo somente ficarแ disponํvel apos enderecamento #Ellen 14.05.2018
			nSaldoSB2 := TRB3->B2_QACLASS - ( ((TRB3->B2_QATU+nQtdPrev) - (TRB3->B2_QEMP + TRB3->B2_RESERVA + TRB3->B2_QPEDVEN)) )
			nSaldoSB2 := If( nSaldoSB2 > 0 , nSaldoSB2 , 0)
			nSalPrev  := If( TRB3->B2_01SALPE > 0 , TRB3->B2_01SALPE , 0)
		Else
			nSaldoSB2 := 0
		EndIF
		*///AFD20180601.EO
		//AFD20180601.BN
		IF TRB3->(!Eof())

			_nB2QEmp := IIF((TRB3)->B2_QEMP<0,0,(TRB3)->B2_QEMP)
			_nB2Rese := IIF((TRB3)->B2_RESERVA<0,0,(TRB3)->B2_RESERVA)
			_nB2QPed := fQtdPed((TRB3)->B2_COD,_cSYLocPad)//IIF((TRB3)->B2_QPEDVEN<0,0,(TRB3)->B2_QPEDVEN) - #CMG20181113.n
			_nB2QACl := IIF((TRB3)->B2_QACLASS<0,0,(TRB3)->B2_QACLASS)
			_nB2QAtu := IIF((TRB3)->B2_QATU<0,0,(TRB3)->B2_QATU)	
	
//			nSaldoSB2 := (TRB3->B2_QATU) - (TRB3->B2_QEMP + TRB3->B2_RESERVA + TRB3->B2_QPEDVEN)

    //      SALDO ATUAL - (EMPENHO + RESERVA + QTD.PEDIDO + QTD. A CLASSIFICAR)		
			nSaldoSB2 := _nB2Qatu - (_nB2QEmp+_nB2Rese+_nB2QPed+_nB2QACl)
			nSaldoSB2 := IIF(nSaldoSB2<0,0,nSaldoSB2)
			nSalPrev  := If( TRB3->B2_01SALPE > 0 , TRB3->B2_01SALPE , 0)
		Else
			nSaldoSB2 := 0
		EndIF
		
		nSaldoSB2 := iif(nSaldoSB2 > 0, nSaldoSB2, 0)
		//AFD20180601.EN
		AAdd(aRegs3 ,{.F.,(cAlias)->DA1_CODPRO,(cAlias)->B1_DESC,(cAlias)->DA1_PRCVEN,nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"S",cLocal,.F.})
		
		(cAlias)->(DbsKIP())
	End
	(cAlias)->( dbCloseArea() )
	
	oGetD3:aArray := aClone(aRegs3)
	oGetD3:Refresh()
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A103VLD2  บAutor ณ Eduardo Patriani   บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o estoque de produto de mostruario e fora de linha  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103VLD2(aRegs3,oGetD3)

Local lRet 	 	:= .T.
Local cTabela 	:= If(!Empty(MV_PAR01),MV_PAR01,cTabPad)
Local nLinha  	:= oGetD3:nAt
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSB4 	:= SB4->(GetArea())       
Local _cPRODP   := "" 
Local _nz       := 0
Local nt		:= 0
Local _SdFora	:= 0

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + Padr(aRegs3[nLinha,2],TamSx3("B1_COD")[1]) ))
_cPRODP := AllTrim(SB1->B1_01PRODP)

SB4->(DbSetOrder(1))
SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
                  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ NAO DEIXA SELECIONAR PRODUTOS COM O PRECO DE VENDA ZERADO - LUIZ EDUARDO F.C. - 1/08/2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF aRegs3[nLinha,4] > 0

	For _nz := 1 To Len(oGetD1:aCols)
	   
	   If Alltrim(oGetD1:aCols[_nz,1]) == _cPRODP 
	          
			oGetD1:nAt := _nz
		
		EndIf   
	
	Next _nz

	If (cTabela==cTabPad) .Or. (cTabela<>cTabMost)
		//tratamento efetuado para impedir a sele็ใo de produtos fora de considerando o saldo em mem๓ria
		for nt := 1 to len(aCols)
			if aRegs3[nLinha,2] == aCols[nt][2]
			_SdFora += aCols[nt][5]
			EndIf
		next nt
		//fim do tratamento para impedir a sele็ใo 
		If (aRegs3[nLinha,7]=="F" .And. aRegs3[nLinha,5]-_SdFora==0)
			MsgStop("Produto fora de linha e sem estoque para venda.","Aten็ใo")
			aRegs3[nLinha,1]:=.F.
			
		ElseIf SB4->B4_01PCEXC=="1" .And. aRegs3[nLinha,5]==0
			MsgStop("Pe็a exclusiva e sem estoque para venda.","Aten็ใo")
			aRegs3[nLinha,1]:=.F.
			
		Else
			aRegs3[nLinha,1]:= !aRegs3[nLinha,1]
		Endif
		
		
		
	ElseIf(cTabMost==MV_PAR01)
		
		If( aRegs3[nLinha,5]==0 )
			MsgStop("Produto de mostruแrio e sem estoque para venda.","Aten็ใo")
			aRegs3[nLinha,1]:=.F.
		Else
			aRegs3[nLinha,1]:= !aRegs3[nLinha,1]
		Endif
		
	Else
		aRegs3[nLinha,1]:= !aRegs3[nLinha,1]	
	Endif
Else
	MsgStop("Nใo ้ possivel selecionar produtos sem pre็o de venda, por favor entre em contato com o Depto. de Compras!!!!","Aten็ใo")
	aRegs3[nLinha,1]:=.F.
	lRet := .F.
EndIF

oGetD3:Refresh()

RestArea(aAreaSB1)
RestArea(aAreaSB4)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A103VLD3  บAutor ณ Eduardo Patriani   บ Data ณ  11/08/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o estoque da peca exclusiva.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A103VLD3(aRegs2,oGetD2)

Local lRet 	 	:= .T.
Local nLinha  	:= oGetD2:nAt
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSB4 	:= SB4->(GetArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ NAO DEIXA SELECIONAR PRODUTOS COM O PRECO DE VENDA ZERADO - LUIZ EDUARDO F.C. - 1/08/2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF aRegs2[nLinha,4] > 0
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + Padr(aRegs2[nLinha,7],TamSx3("B1_COD")[1]) ))
	
	SB4->(DbSetOrder(1))
	SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
	
	If (SB1->B1_01FORAL=="F" .And. aRegs2[nLinha,5]==0) .And. lRet
		MsgStop("Produto fora de linha e sem estoque para venda.","Aten็ใo")
		aRegs2[nLinha,1]:=.F.
		lRet := .F.
	Endif
	
	If SB4->B4_01PCEXC=="1" .And. aRegs2[nLinha,5]==0 .And. lRet
		MsgStop("Pe็a exclusiva e sem estoque para venda.","Aten็ใo")
		aRegs2[nLinha,1]:=.F.
		lRet := .F.
	Endif
Else
	MsgStop("Nใo ้ possivel selecionar produtos sem pre็o de venda, por favor entre em contato com o Depto. de Compras!!!!","Aten็ใo")
	aRegs2[nLinha,1]:=.F.
	lRet := .F.
EndIF

If lRet
	aRegs2[nLinha,1]:= !aRegs2[nLinha,1]
Endif
oGetD3:Refresh()

RestArea(aAreaSB1)
RestArea(aAreaSB4)

Return(lRet)

//Retorno o local padrao para Pe็as Exclusiva
Static Function RetLocPcExc(cFilAtu)

Local cLocal := ''

If cFilAtu<>cLocDep		
	cLocal := '02' 
Else
	cLocal := cArmMos
Endif

Return(cLocal)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DIGOBSME  บAutor ณ LUIZ EDUARDO F.C.  บ Data ณ 15/12/2016  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ SOLICITA A OBSERVACAO QUANDO MEDIDA ESPECIAL               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION DIGOBSME()

Local oDlg
Local cOBS := SPACE(100)

DEFINE DIALOG oDlg TITLE "Tipo de Nota Fiscal" FROM 0,0 TO 130,620 PIXEL

@ 005,005 Say "Digite Observa็ใo do Produto de Medida Especial : " Size 150,010 Pixel Of oDlg
@ 020,05 MSGET cOBS	PICTURE PesqPict('SUB','UB_01DESME') OF oDlg PIXEL SIZE 300,010

@ 040,005 BUTTON "&OK"	SIZE 50,15 OF oDlg PIXEL ACTION {|| (oDlg:End())  }

ACTIVATE DIALOG oDlg CENTERED

cOBS := "ME - "+ cOBS

/*IF aRegs4[oGetD4:nAt,1]
	aRegs4[oGetD4:nAt,1] := .F.
Else
	aRegs4[oGetD4:nAt,1] := .T.
	oGetD4:refresh()
EndIF*/

RETURN(cOBS)

Static Function SyLimpaCpo(cProduto,cDescri,oProduto,oDescri)

cProduto := CriaVar("B4_COD"  ,.F.)
oProduto:SetFocus()
oProduto:Refresh()

cDescri	 := CriaVar("B4_DESC" ,.F.)
oDescri:Refresh()

Return

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ VA006Fim ณ Autor ณ Gustavo Kuhl    		ณ Data ณ05/12/2016ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Ponto de Entrada executado apos a Inclusao do SB4          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VA006Fim(cProd,cDescME)

Local cChave 	:= ''
Local B1CodBar 	:= ''
Local B1CodBar1	:= ''
Local cCodBar 	:= ''
Local Ccdescri 	:= ''
Local Cldescri 	:= ''
Local cProduto  := ''
Local cComp 	:= 0
Local nPesoB4	:= 0
Local nPesoM3	:= 0
Local Cdescri 	:= Alltrim(SB4->B4_DESC)
Local cTabela 	:= GetMv("MV_SYCHVME",,"ME")
Local clinha 	:= SB4->B4_LINHA
Local cQE 		:= SB4->B4_01VOLUM
//Local CCodGs1 	:= '78998552'

DbSelectArea("SB1")
DbSetOrder(1)
If SB1->(DbSeek(xFilial("SB1")+AvKey(cProd,"B1_COD")))
	
	DbSelectArea("SB4")
	DbSetOrder(1)
	If DbSeek(xFilial("SB4")+AvKey(SB1->B1_01PRODP,"B4_COD"))
		nPesoB4	:= SB4->B4_PESO
		nPesoM3 := (nAltura * nLargura * nCompri ) * nPesoB4
	Endif
	
	cChave 		:= SB1->B1_01CLGRD
	clin 		:= SB1->B1_01LNGRD
	cB1codbar 	:= SB1->B1_CODBAR
	Cdescref 	:= Alltrim(SB1->B1_01DREF)
	cCodBar 	:= GetMv("MV_XSEQCODBAR")
	
	DbSelectArea("SBV")
	DbSetOrder(1)
	If SBV->(DbSeek(xFilial("SBV")+cTabela+cChave))
		Ccdescri:= Alltrim(SBV->BV_DESCRI)
	endif
	If SBV->(DbSeek(xFilial("SBV")+clinha+clin))
		Cldescri := alltrim(SBV->BV_DESCRI)
	endif
	
	RecLock("SB1",.F.)
	SB1->B1_PESO   	:=  nPesoM3
	SB1->B1_PESBRU 	:=  nPesoM3
	
	IF !EMPTY(cDescME)
		SB1->B1_DESC 	:=  Cdescri + " " + Ccdescri + " " + Cldescri + " " + Cdescref	+ " // " + cDescME
	Else
		SB1->B1_DESC 	:=  Cdescri + " " + Ccdescri + " " + Cldescri + " " + Cdescref
	EndIF
	MsUnlock()

//#RVC20180413.bo	
/*	IF SUBSTR(cB1codbar,1,8) <> '78998552'
		B1CodBar 	:= CCodGs1 + cCodBar
		B1CodBar1 	:= trim(B1CodBar)+eandigito(trim(B1CodBar))
		
		RecLock("SB1",.F.) // .F. = ALTERA
		SB1->B1_CODBAR :=  B1CodBar1
		MsUnlock()
		
		PutMv ("MV_XSEQCODBAR",SOMA1(cCodBar))
	ENDIF */ //#RVC20180413.eo

	U_KMESTX02(cB1codbar) //#RVC20180413.n
	
	//INSERE PRODUTOS NA TABELA DE COMPLEMENTO DE PRODUTO - SB5
	DbSelectArea("SB5")
	DbSetOrder(1)
	If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
		RecLock("SB5",.F.)
		SB5->B5_COMPRLC 	:= nCompri
		SB5->B5_LARGLC 		:= nLargura
		SB5->B5_ALTURLC 	:= nAltura
		SB5->B5_QE1 		:= cQE
		SB5->B5_FATARMA 	:= SB4->B4_FATARMA
		SB5->B5_EMPMAX 		:= SB4->B4_EMPMAX
		SB5->B5_ROTACAO 	:= SB4->B4_ROTACAO
		SB5->B5_EMB1 		:= SB1->B1_UM
		MsUnlock()
	else
		RecLock("SB5",.T.)
		SB5->B5_FILIAL  	:=  xFilial("SB1")
		SB5->B5_COD     	:=  SB1->B1_COD
		SB5->B5_CEME    	:= SB1->B1_DESC
		SB5->B5_COMPRLC 	:= nCompri
		SB5->B5_LARGLC 		:= nLargura
		SB5->B5_ALTURLC 	:= nAltura
		SB5->B5_QE1 		:= cQE
		SB5->B5_FATARMA 	:= SB4->B4_FATARMA
		SB5->B5_EMPMAX 		:= SB4->B4_EMPMAX
		SB5->B5_ROTACAO 	:= SB4->B4_ROTACAO
		SB5->B5_EMB1 		:= SB1->B1_UM
		MsUnlock()
	EndIf
	GRAVASBZ(cProduto)
ENDIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVASBZ บAutor  ณAlfa Consultoria    บ Data ณ  20/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao paraGravar SBZ.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GRAVASBZ(cProduto)

Local aAreaAtu 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSM0 	:= SM0->(GetArea())
Local aLojas 	:= {}
Local cFilAtu	:= cFilAnt
Local nTamFil	:= Len(cFilAnt)
Local cGrupo	:= GetMv("KH_GRPPROD",,"2001|2002") //Grupo de Produtos que nao deverao cadastrar na tabela SBZ
Local nX

DbSelectArea("SM0")
DbSeek(cEmpAnt)
While !EOF() .AND. SM0->M0_CODIGO == cEmpAnt
	AADD(aLojas, AllTrim(SM0->M0_CODFIL))
	DbSkip()
EndDo

For nX:=1 To Len(aLojas)
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + AvKey(cProduto,"B1_COD") ))
	
	cFilAnt := PadR(aLojas[nX],nTamFil)
	
	DbSelectArea("SBZ")
	DbSetOrder(1)
	IF SBZ->(!DbSeek(xFilial("SBZ")+cProduto))
		RecLock("SBZ",.T.) // .T. = INCLUI
		SBZ->BZ_FILIAL 	:= cFilAnt
		SBZ->BZ_COD    	:= cProduto
		SBZ->BZ_LOCPAD 	:= ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cFilAnt))
		SBZ->BZ_LOCALIZ	:= iif( (cFilAnt$alltrim(SUPERGETMV("SY_LOCALIZ"))) .And. !(SB1->B1_GRUPO $ cGrupo)  ,"S","N")
		SBZ->BZ_DTINCLU	:= DDATABASE
		SBZ->BZ_TIPOCQ 	:= 'M'
		SBZ->BZ_CTRWMS 	:= '2'
		MsUnLock()
	EndIF
	
Next nY

cFilAnt := cFilAtu

RestArea(aAreaSM0)
RestArea(aAreaSB1)
RestArea(aAreaAtu)

return
//+------------+---------------+-------+------------------------+------+------------+
//| Fun็ใo:    | KMHTAB001     | Autor | Ellen Santiago         | Data | 02/06/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descri็ใo: | Funcao para retornar todos os produtos da tabela de preco principal|
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+

Static Function KMHTAB001(cCodPro)

Local cQuery := ""
Local aProd := {}

cQuery := "SELECT * " + CRLF
cQuery += "FROM " + RetSQLName("DA1") + " DA1 " + CRLF
cQuery += "INNER JOIN " + RetSQLName("DA0") + " DA0 " + CRLF
cQuery += "ON DA0_CODTAB = DA1_CODTAB " + CRLF 
cQuery += "WHERE DA1_CODTAB = '001' " + CRLF
cQuery += "AND DA0_ATIVO = '1'" + CRLF 
cQuery += "AND DA1_CODPRO = '" + cCodPro + "' " + CRLF
cQuery += "AND DA1.D_E_L_E_T_ = '' " + CRLF
cQuery += "AND DA0.D_E_L_E_T_ = '' " + CRLF

If Select("TempDA1") > 0
	TempDA1->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TempDA1",.F.,.T.)

While !(TempDA1->(EOF()))
	aAdd(aProd,{TempDA1->DA1_CODPRO,TempDA1->DA1_PRCVEN})
	TempDA1->(DBSkip())
EndDo

Return aProd


//+------------+---------------+-------+------------------------+------+------------+
//| Fun็ใo:    | FQTDPED       | Autor | Caio Garcia            | Data | 13/11/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descri็ใo: | Funcao para retornar a quantidade do produto em pedido             |
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+
Static Function fQtdPed(_cCodPro,_cLocal)

Local _cQuery	:= ""
Local _nQtd		:= ""
local _nLbv 	:= ""
Local _cQliber  := ""
Loca _nTVen	:= ""

//Local cLocPad	:= SuperGetMV("SY_LOCPAD",.T.,"01")	//#RVC20181121.n - //#CMG20181122.n

Default _lForal := .F.	//#RVC20181121.n

_cQuery := " SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED "
_cQuery += " FROM " + RetSQLName("SC6") + "(NOLOCK) SC6 "
_cQuery += " WHERE SC6.D_E_L_E_T_ <> '*' "
_cQuery += " AND C6_PRODUTO = '" + _cCodPro + "' " 
_cQuery += " AND C6_NOTA = '' "
_cQuery += " AND C6_BLQ <> 'R' "
_cQuery += " AND C6_QTDEMP = 0 "
_cQuery += " AND C6_QTDVEN > C6_QTDLIB "
_cQuery += " AND C6_CLI <> '000001' "
_cQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"' "
//_cQuery += " AND C6_LOCAL = '01' "//#RVC20181121.o

//#CMG20181122.bn
If _lForal
	_cQuery += " AND C6_LOCAL = '" + Alltrim(_cSYLocPad) + "' "
Else	
	_cQuery += " AND C6_LOCAL = '" + Alltrim(_cLocal) + "' "
EndIf
//#CMG20181122.en

/*/#RVC20181121.bo
if _lForal01
	_cQuery += " AND C6_LOCAL = '" + Alltrim(cLocPad) + "' "
else
	_cQuery += " AND C6_LOCAL = '01' "
endIf
*///#RVC20181121.eo

If Select("_QTDPED_") > 0
	_QTDPED_->(DbCloseArea())
EndIf

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_QTDPED_",.F.,.T.)

_nQtd := _QTDPED_->QTDPED

//tratamento para colocar os produtos para venda, manobra diretoria chamado: 13122

_cQliber := " SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED "
_cQliber += " FROM " + RetSQLName("SC6") + "(NOLOCK) SC6 "
_cQliber += " WHERE SC6.D_E_L_E_T_ <> '*' "
_cQliber += " AND C6_PRODUTO = '" + _cCodPro + "' " 
_cQliber += " AND C6_NOTA = '' "
_cQliber += " AND C6_BLQ <> 'R' "
_cQliber += " AND C6_QTDEMP = 0 "
_cQliber += " AND C6_QTDVEN > C6_QTDLIB "
_cQliber += " AND C6_CLI <> '000001' "
_cQliber += " AND C6_FILIAL = '"+xFilial("SC6")+"' "
_cQliber += " AND C6_XVENDA = '1'"
If _lForal
	_cQliber += " AND C6_LOCAL = '" + Alltrim(_cSYLocPad) + "' "
Else	
	_cQliber += " AND C6_LOCAL = '" + Alltrim(_cLocal) + "' "
EndIf
If Select("_VEDLI_") > 0
	_VEDLI_->(DbCloseArea())
EndIf

_cQliber := ChangeQuery(_cQliber)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQliber),"_VEDLI_",.F.,.T.)

_nLbv := _VEDLI_->QTDPED

_nTVen := _nQtd - _nLbv

Return _nTVen