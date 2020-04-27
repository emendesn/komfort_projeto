#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

#Define GD_INSERT  1
#Define GD_UPDATE  2
#Define GD_DELETE  4

#Define MAXGETDAD 99999
#DEFINE CRLF	   CHR(10)+CHR(13)

STATIC nSel01 := 1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVA108  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Cotas e Comissoes.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVA108()

Local aArea			:= GetArea()
Local aFixos        := {}

Private cCadastro  	:= "Cadastro de Cotas"
Private aRotina		:= MenuDef()
			             
DbSelectArea('SZ3')
DbSetOrder(1)
mBrowse( 6, 1,22,75,"SZ3",aFixos,,,,,,,,,,,,,)

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณ SYMM CONSULTORIA   บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Utilizacao de menu Funcional                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()     
Return( a108MtMenu() )  

Static Function a108MtMenu()
Local aRotina := {}
Aadd(aRotina,{"Pesquisar"	,"PesqBrw"   	, 0, 1, 0, .F. }) 
Aadd(aRotina,{"Visualizar"	,"U_a108Manut"	, 0, 2, 0, Nil }) 
Aadd(aRotina,{"Incluir"		,"U_a108Manut"	, 0, 3, 0, Nil })
Aadd(aRotina,{"Alterar"		,"U_a108Manut"	, 0, 4, 6, Nil })
Aadd(aRotina,{"Excluir"		,"U_a108Manut"	, 0, 5, 7, Nil })
Return(aRotina)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณa108Manut ณ Autor ณ SYMM CONSULTORIAi     ณ Data ณ 05/05/14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de Vis/Inc/Alt/Exclusao do Cadastro de Cotas.     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function A108Manut(cAlias,nReg,nOpc)

Local aButtons 		:= {}
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aPosGet   	:= {}
Local aInfo     	:= {}
Local nOpcA			:= 0
Local nI			:= 0
Local nStyle 	   	:= GD_INSERT+GD_UPDATE+GD_DELETE

Private oFolder
Private aTELA[0][0]
Private aGETS[0]

Private aHeadP1
Private aColsP1
Private aAltP1
Private oGetP1

Private aHeadP2
Private aColsP2
Private aAltP2
Private oGetP2

Private oDlg
Private oEnchoice
Private oPanelGet      
Private oVlrCota
Private oCodComp

Private cCodComp := ""
Private nVlrCota := 0
     	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega as variaveia da Enchoice.               	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RegToMemory("SZ3",IIF(nOpc==3,.T.,.F.))

If nOpc == 3
	MsgRun("Por favor, aguarde carregando usuแrios...",, {|| FiltraSZ3(@aHeadP1,@aColsP1,"SZ3","Z3_CODVEND|Z3_NOMEVEN|Z3_TIPOUSR|Z3_COTAUSR"	,1,nOpc,"SZ3.Z3_CODCOMP = '"+M->Z3_CODCOMP+"'",{"Z3_CODCOMP"},,) })
	MsgRun("Por favor, aguarde carregando produtos...",, {|| FiltraSZ3(@aHeadP2,@aColsP2,"SZ3","Z3_CODPRO|Z3_DESC|Z3_PERCVEN|Z3_PERCGER"		,2,nOpc,"SZ3.Z3_CODCOMP = '"+M->Z3_CODCOMP+"'",{"Z3_CODCOMP"},,) })
	
	If Len(aColsP1)==0
		Aviso(cCadastro,"Nใo existem registros para essa consulta.",{"OK"})
		Return
	EndIF
Else
	MsgRun("Por favor, aguarde carregando usuแrios...",, {|| FiltraSZ3(@aHeadP1,@aColsP1,"SZ3","Z3_CODVEND|Z3_NOMEVEN|Z3_TIPOUSR|Z3_COTAUSR"	,1,nOpc,"SZ3.Z3_CODCOMP = '"+M->Z3_CODCOMP+"' AND SZ3.Z3_CODVEND <> '' ",{"Z3_CODCOMP"},,) })
	MsgRun("Por favor, aguarde carregando produtos...",, {|| FiltraSZ3(@aHeadP2,@aColsP2,"SZ3","Z3_CODPRO|Z3_DESC|Z3_PERCVEN|Z3_PERCGER"	 	,2,nOpc,"SZ3.Z3_CODCOMP = '"+M->Z3_CODCOMP+"' AND SZ3.Z3_CODVEND =  '' ",{"Z3_CODCOMP"},,) })
EndiF

cCodComp := If(!INCLUI,M->Z3_CODCOMP,CriaVar("Z3_CODCOMP"))
nVlrCota := If(!INCLUI,M->Z3_COTALJ,0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE FONT oFntBut NAME "Arial" SIZE 0, -20

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estancia Objeto FWLayer. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLayer := FWLayer():new()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa o objeto com a janela que ele pertencera. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLayer:init(oDlg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Linha do Layer. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLayer:addLine('Lin01',97,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria a coluna do Layer. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLayer:addCollumn('Col01',100,.F.,'Lin01')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Adiciona Janelas as suas respectivas Colunas. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLayer:addWindow('Col01','L1_Win01',''	,014,.T.,.F.,,'Lin01',)
oLayer:addWindow('Col01','L1_Win02',''	,083,.T.,.F.,,'Lin01',)

oPanel1:= oLayer:GetWinPanel("Col01","L1_Win01","Lin01")

@ 005,010 SAY "Competencia" 	OF oPanel1 PIXEL SIZE 038,010
@ 004,045 MSGET oCodComp Var cCodComp PICTURE PesqPict('SZ3','Z3_CODCOMP')	 	WHEN If(INCLUI,.T.,.F.) VALID NaoVazio() F3 "SZ6" OF oPanel1 PIXEL SIZE 031,010 HASBUTTON
oCodComp:bLostFocus	:= {|| 	U_A108VLD4() }

@ 005,100 SAY "Valor Cota R$" 	OF oPanel1 PIXEL SIZE 038,010
@ 004,135 MSGET oVlrCota Var nVlrCota  PICTURE PesqPict('SZ3','Z3_COTALJ') 		WHEN .F. VALID positivo() OF oPanel1 PIXEL SIZE 120,010 HASBUTTON

oPanel2:= oLayer:GetWinPanel("Col01","L1_Win02","Lin01")

oFolder:=TFolder():New(0,0,{"Usuแrios","Produtos"},,oPanel2,,,,.T.,.F.,0,0)
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

oGetP1:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"U_A108VLD1()","AlwaysTrue","",{"Z3_CODVEND","Z3_NOMEVEN","Z3_TIPOUSR","Z3_COTAUSR"},,MAXGETDAD,,,,oFolder:aDialogs[1],@aHeadP1,@aColsP1)
oGetP1:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
oGetP1:bDelOk 			:= {|| U_A108VLD3(1) }
oGetP1:Refresh()

oGetP2:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"U_A108VLD2()","AlwaysTrue","",{"Z3_CODPRO","Z3_DESC","Z3_PERCVEN","Z3_PERCGER"},,MAXGETDAD,,,,oFolder:aDialogs[2],@aHeadP2,@aColsP2)
oGetP2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP2:Refresh()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| IIF( Obrigatorio(aGets,aTela) , (nOpca := 1 , oDlg:End() ) , .F. ) } , {|| oDlg:End() },,aButtons)

IF nOpcA == 1
		
	Begin Transaction  
	
	aColsP1 := aClone(oGetP1:aCols)
	aColsP2 := aClone(oGetP2:aCols)
		
	A108Grava(nOpc)
	
	End Transaction	

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a integridade da janela                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea(cAlias)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltraSZ3 บAutor  ณMicrosiga           บ Data ณ  07/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra registros das notas fiscais de entrada.             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                           

Static Function FiltraSZ3(aHeader1,aCols1,cAlias,cCampos,nFolder,nOpc,cWhere,aOrder,cFilQry,cFilSeg)
				
Local cQuery	:= ""
Local nUsado 	:= 0
Local nCntFor

aHeader1 := {}
aCols1	 := {}
aAlter1	 := {} 
If nFolder == 1 
	aNoFields:= {"Z3_CODCOMP","Z3_COTALJ","Z3_CODPRO","Z3_DESC","Z3_PERCVEN","Z3_PERCGER"}
Else
	aNoFields:= {"Z3_CODCOMP","Z3_COTALJ","Z3_CODVEND","Z3_NOMEVEN","Z3_TIPOUSR","Z3_COTAUSR"}
Endif

DbSelectArea(cAlias)
DbSetOrder(1)

If nOpc <> 3
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega Dados da Tabela especifica.              	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CarregaDados(@aHeader1,@aCols1,cAlias,cWhere,aOrder,aNoFields,nOpc)
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aHeader a partir dos campos do SX3         	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SX3")
	DbSetorder(1)
	MsSeek(cAlias)
	While !Eof() .And. (X3_ARQUIVO == cAlias)
		IF AllTrim(X3_CAMPO)$cCampos
			nUsado++
			Aadd(aHeader1, {	AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT,;
			SX3->X3_CBOX,;
			SX3->X3_RELACAO,;
			".T."	} )
		EndIF
		SX3->(DbSkip())
	EndDo
		
	CarregaItens(@aHeader1,@aCols1)
	
Endif
						
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA108Grava บAutor  ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a gravacao.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A108Grava(nOpc) 

Local cFilSZ3 		:= xFilial("SZ3")
Local cCompetencia 	:= M->Z3_CODCOMP
Local nCntFor 		:= 0
Local nUsado  		:= 0
Local lRet	  		:= .T.
Local nCntFor2
Local nX, nY

Do Case
	
	Case nOpc == 3  //Incluir
		
		nUsado := Len(aHeadP1)
		For nCntFor := 1 To Len(aColsP1)
			If ( !aColsP1[nCntFor][nUsado+1] )
				dbSelectArea("SZ3")
				Reclock("SZ3",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeadP1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeadP1[nCntFor2][2]),aColsP1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				SZ3->Z3_FILIAL	:= cFilSZ3
				SZ3->Z3_CODCOMP	:= cCodComp
				SZ3->Z3_COTALJ	:= nVlrCota
				MsUnlock()
			EndIf
		Next
		SZ3->(FKCommit())
		
		nUsado := Len(aHeadP2)
		For nCntFor := 1 To Len(aColsP2)
			If ( !aColsP2[nCntFor][nUsado+1] )
				dbSelectArea("SZ3")
				Reclock("SZ3",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeadP2[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeadP2[nCntFor2][2]),aColsP2[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				SZ3->Z3_FILIAL	:= cFilSZ3
				SZ3->Z3_CODCOMP	:= cCodComp
				SZ3->Z3_COTALJ	:= nVlrCota
				MsUnlock()
			EndIf
		Next
		SZ3->(FKCommit())

						
	Case nOpc == 4  //Atualizar
		//Folder 01 (Usuarios)
		aRecNo:={}
		dbSelectArea("SZ3")
		dbSetOrder(1)
		DbSeek(xFilial("SZ3")+cCompetencia)
		While ( !Eof() .And. xFilial("SZ3") == SZ3->Z3_FILIAL .And. cCompetencia == SZ3->Z3_CODCOMP )
			If !Empty(SZ3->Z3_CODVEND)
				aadd(aRecNo,RecNo())
			Endif
			dbSelectArea("SZ3")
			dbSkip()
		EndDo
		
		nUsado := Len(aHeadP1)
		For nX := 1 To Len(aColsP1)
			lTravou := .F.
			If nX <= Len(aRecNo)
				dbSelectArea("SZ3")
				dbGoto(aRecNo[nX])
				RecLock("SZ3")
				lTravou := .T.
			EndIf
			If ( !aColsP1[nX][nUsado+1] )
				If !lTravou
					RecLock("SZ3",.T.)
				EndIf
				For nY := 1 to Len(aHeadP1)
					If aHeadP1[nY][10] <> "V"
						SZ3->(FieldPut(FieldPos(aHeadP1[nY][2]),aColsP1[nX][nY]))
					EndIf
				Next nY
				SZ3->Z3_FILIAL	:= cFilSZ3
				SZ3->Z3_CODCOMP	:= cCodComp
				SZ3->Z3_COTALJ	:= nVlrCota
				MsUnLock()
				lGravou := .T.
			Else
				If lTravou
					SZ3->(dbDelete())
				EndIf
			EndIf
			MsUnLock()
		Next nX
		
		//Folder 02 (Produtos)		
		aRecNo:={}
		dbSelectArea("SZ3")
		dbSetOrder(1)
		DbSeek(xFilial("SZ3")+cCompetencia)
		While ( !Eof() .And. xFilial("SZ3") == SZ3->Z3_FILIAL .And. cCompetencia == SZ3->Z3_CODCOMP )
			If Empty(SZ3->Z3_CODVEND)
				aadd(aRecNo,RecNo())
			Endif
			dbSelectArea("SZ3")
			dbSkip()
		EndDo
		
		nUsado := Len(aHeadP2)
		For nX := 1 To Len(aColsP2)
			lTravou := .F.
			If nX <= Len(aRecNo)
				dbSelectArea("SZ3")
				dbGoto(aRecNo[nX])
				RecLock("SZ3")
				lTravou := .T.
			EndIf
			If ( !aColsP2[nX][nUsado+1] )
				If !lTravou
					RecLock("SZ3",.T.)
				EndIf
				For nY := 1 to Len(aHeadP2)
					If aHeadP2[nY][10] <> "V"
						SZ3->(FieldPut(FieldPos(aHeadP2[nY][2]),aColsP2[nX][nY]))
					EndIf
				Next nY
				SZ3->Z3_FILIAL	:= cFilSZ3
				SZ3->Z3_CODCOMP	:= cCodComp
				SZ3->Z3_COTALJ	:= nVlrCota
				MsUnLock()
				lGravou := .T.
			Else
				If lTravou
					SZ3->(dbDelete())
				EndIf
			EndIf
			MsUnLock()
		Next nX
		
	Case nOpc == 5  //Exclusao
					
		dbSelectArea("SZ3")
		dbSetOrder(1)
		If DbSeek(cFilSZ3+cCompetencia)
			While ( !Eof() .And. cFilSZ3 == SZ3->Z3_FILIAL .And. cCompetencia == SZ3->Z3_CODCOMP )
				RecLock("SZ3", .F.)
				dbDelete()
				MsUnLock()
				dbSelectArea("SZ3")
				dbSkip()
			EndDo
		Endif
		SZ1->(FKCommit())
			
EndCase

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaDadosบAutor  ณ Eduardo Patriani บ Data ณ  28/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega dados da tabela especifica.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaDados(aHeader1,aCols1,cAlias,cWhere,aOrder,aNoFields,nOpc)

Local cOrder := ""
Local cQuery := ""
Local nI,nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Query  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " (NOLOCK) WHERE "
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtra filial ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += cAlias+"."+"Z3_FILIAL = '"+xFilial(cAlias)+"' AND "
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica condicao Where ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cWhere)
	cQuery += cWhere + " AND "
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtra refistros deletados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += cAlias+".D_E_L_E_T_ <> '*' "
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta ordem dos registros  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aOrder) > 0
	For nX:=1 to len(aOrder)
		cOrder += aOrder[nX]+","
	next
	cQuery += "ORDER BY "+cAlias+"."+"R_E_C_N_O_"
EndIf
cQuery := ChangeQuery(cQuery)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FillGetDados(nOpc,cAlias,1,,,{|| .T. },aNoFields,,,cQuery,,,If(len(aHeader1)>0,NIL,aHeader1),aCols1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaItensบAutor  ณ Eduardo Patriani บ Data ณ  14/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega itens no aCols. 									  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CarregaItens(aHeader1,aCols1)

Local nUsado 	:= 0
Local nCntFor

nUsado := Len(aHeader1)
AAdd(aCols1,Array(nUsado+1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializa as variaveis da aCols (tratamento para    ณ
//ณcampos criados pelo usu rio)							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nCntFor := 1 To nUsado	
	If aHeader1[nCntFor][8] == "C"
		aCols1[Len(aCols1)][nCntFor] := Space(aHeader1[nCntFor][4])		
	ElseIf aHeader1[nCntFor][8] == "D"
		aCols1[Len(aCols1)][nCntFor] := dDatabase		
	ElseIf aHeader1[nCntFor][8] == "M"
		aCols1[Len(aCols1)][nCntFor] := ""		
	ElseIf aHeader1[nCntFor][8] == "N"
		aCols1[Len(aCols1)][nCntFor] := 0		
	Else
		aCols1[Len(aCols1)][nCntFor] := CriaVar(aHeader1[nCntFor,2])
	Endif
Next
aCols1[Len(aCols1)][nUsado+1] := .F.

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A108VLD1  บAutor ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da linha da getdados do objeto oGetP1            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function A108VLD1()

Local lRet 			:= .T.
Local nPosVend 		:= Ascan(aHeadP1,{|x|x[2]=="Z3_CODVEND"})
Local nPos 			:= oGetP1:nAt
Local nI, nX, nY

For nI:= 1 To Len( oGetP1:aCols )
	If ( nI != nPos ) .and. !oGetP1:aCols[nI][Len( oGetP1:aHeader ) + 1]
		If Alltrim(oGetP1:aCols[nI,nPosVend]) == Alltrim(oGetP1:aCols[nPos,nPosVend])
			Help(Nil,Nil,ProcName(),,"Usuแrio jแ informado.", 1, 5)
			lRet := .F.
			Exit
		Endif
	Endif
Next nI

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A108VLD2  บAutor ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da linha da getdados do objeto oGetP2             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function A108VLD2()

Local lRet 			:= .T.
Local nPosProd 		:= Ascan(aHeadP2,{|x| Alltrim(x[2])=="Z3_CODPRO"})
Local nPos 			:= oGetP2:nAt
Local nI, nX, nY

For nI:= 1 To Len( oGetP2:aCols )
	If ( nI != nPos ) .and. !oGetP2:aCols[nI][Len( oGetP2:aHeader ) + 1]
		If Alltrim(oGetP2:aCols[nI,nPosProd]) == Alltrim(oGetP2:aCols[nPos,nPosProd])
			Help(Nil,Nil,ProcName(),,"Produto jแ informado.", 1, 5)
			lRet := .F.
			Exit
		Endif
	Endif
Next nI

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A108VLD3  บAutor ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenchimento automatica do valor da cota na loja.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function A108VLD3(nOpcao)

Local lRet   		:= .T.
Local nPosVlrCota 	:= Ascan(aHeadP1,{|x|x[2]=="Z3_COTAUSR"})
Local nPosTipo		:= Ascan(aHeadP1,{|x|x[2]=="Z3_TIPOUSR"})
Local nPos 			:= oGetP1:nAt
Local nVlrAtu		:= If(nOpcao==1,oGetP1:aCols[nPos,nPosVlrCota],M->Z3_COTAUSR)
Local nValor 		:= If(oGetP1:aCols[nPos,nPosTipo]=='1',nVlrAtu,0)
Local nUsado 		:= Len(aHeadP1)
Local nI                

Default nOpcao 		:= 0

nVlrCota := 0

For nI := 1 To Len(oGetP1:aCols)
	If ( !oGetP1:aCols[nI][nUsado+1] )
		If oGetP1:aCols[nI,nPosTipo]=='1'
			If nI <> nPos
				nValor += oGetP1:aCols[nI,nPosVlrCota]
			Endif
		Endif
	Endif
Next

If nOpcao==1 .And. oGetP1:aCols[nPos][nPosTipo]=='1' .And. !oGetP1:aCols[nPos][nUsado+1]
	nValor	:= nValor - nVlrAtu
Endif

nVlrCota := nValor
oVlrCota:Refresh()

Return(lRet)

User Function A108VLD4()

Local lRet := ExistCpo("SZ6")

If !lRet
	oCodComp:SetFocus()
	oCodComp:Refresh()	
Endif

Return(.T.)