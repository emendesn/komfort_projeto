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
ฑฑบPrograma  ณ SYVA109  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de percentuais de comissoes.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVA109()

Local aArea			:= GetArea()

Private cCadastro  	:= "Cadastro de percentuais de comiss๕es"
Private aRotina		:= MenuDef()
			
DbSelectArea('SZ4')
DbSetOrder(1)
mBrowse( 6, 1,22,75,"SZ4",,,,,,,,,,,,,,)

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณ SYMM CONSULTORIA   บ Data ณ  28/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Utilizacao de menu Funcional                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()     
Return( a109MtMenu() )  

Static Function a109MtMenu()
Local aRotina := {}
Aadd(aRotina,{"Pesquisar"	,"PesqBrw"   	, 0, 1, 0, .F. }) 
Aadd(aRotina,{"Visualizar"	,"U_a109Manut"	, 0, 2, 0, Nil }) 
Aadd(aRotina,{"Incluir"		,"U_a109Manut"	, 0, 3, 0, Nil })
Aadd(aRotina,{"Alterar"		,"U_a109Manut"	, 0, 4, 6, Nil })
Aadd(aRotina,{"Excluir"		,"U_a109Manut"	, 0, 5, 7, Nil })
Return(aRotina)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณa109Manut ณ Autor ณ SYMM CONSULTORIAi     ณ Data ณ 06/05/14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de Vis/Inc/Alt/Exclusao do Cadastro de Comissoes. ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function A109Manut(cAlias,nReg,nOpc)

Local aButtons 		:= {}
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aPosGet   	:= {}
Local aInfo     	:= {}
Local nOpcA			:= 0
Local nI			:= 0
Local nStyle 	   	:= GD_INSERT+GD_UPDATE

Private oFolder
Private aTELA[0][0]
Private aGETS[0]

Private aHeadP1
Private aColsP1
Private aAltP1
Private oGetP1

Private oDlg
Private oEnchoice
Private oPanelGet      
Private oTipo
     	
If nOpc == 3
	MsgRun("Por favor, aguarde ...",, {|| FiltraSZ4(@aHeadP1,@aColsP1,"SZ4","Z4_ORDEM|Z4_TIPO|Z4_COND|Z4_PERCEN",1,nOpc,,{"Z4_TIPO","Z4_ORDEM"},,) })
	
	If Len(aColsP1)==0
		Aviso(cCadastro,"Nใo existem registros para essa consulta.",{"OK"})
		Return
	EndIF
Else
	MsgRun("Por favor aguarde, filtrando produtos...",, {|| FiltraSZ4(@aHeadP1,@aColsP1,"SZ4","Z4_ORDEM|Z4_TIPO|Z4_COND|Z4_PERCEN",1,nOpc,"SZ4.Z4_TIPO = '"+SZ4->Z4_TIPO+"'",{"Z4_TIPO","Z4_ORDEM"},,) })
EndiF

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
oLayer:addWindow('Col01','L1_Win01','Comiss๕es',100,.T.,.F.,,'Lin01',)

oPanel1:= oLayer:GetWinPanel("Col01","L1_Win01","Lin01")

oGetP1:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"AlwaysTrue","AlwaysTrue","Z4_TIPO"+"+Z4_ORDEM",{"Z4_TIPO","Z4_COND","Z4_PERCEN"},,MAXGETDAD,,,,oPanel1,@aHeadP1,@aColsP1)
oGetP1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP1:Refresh()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| IIF( Obrigatorio(aGets,aTela) , (nOpca := 1 , oDlg:End() ) , .F. ) } , {|| oDlg:End() },,aButtons)

IF nOpcA == 1
		
	Begin Transaction  
	
	aColsP1 := aClone(oGetP1:aCols)
		
	A109Grava(nOpc)
	
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
ฑฑบPrograma  ณFiltraSZ4 บAutor  ณMicrosiga           บ Data ณ  07/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra registros das notas fiscais de entrada.             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                           

Static Function FiltraSZ4(aHeader1,aCols1,cAlias,cCampos,nFolder,nOpc,cWhere,aOrder,cFilQry,cFilSeg)
				
Local cQuery	:= ""
Local nUsado 	:= 0
Local nCntFor

aHeader1 := {}
aCols1	 := {}
aAlter1	 := {}
aNoFields:= {}

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
ฑฑบPrograma  ณA109Grava บAutor  ณ SYMM CONSULTORIA   บ Data ณ  06/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a gravacao.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A109Grava(nOpc) 

Local cFilSZ4 := xFilial("SZ4")
Local cChave  := If(INCLUI,"",SZ4->Z4_TIPO)
Local nCntFor := 0
Local nUsado  := 0
Local lRet	  := .T.
Local nCntFor2
Local nX, nY

Do Case
	
	Case nOpc == 3  //Incluir
		
		//Atualiza Itens da remarcacao.
		nUsado := Len(aHeadP1)
		For nCntFor := 1 To Len(aColsP1)
			If ( !aColsP1[nCntFor][nUsado+1] )
				dbSelectArea("SZ4")
				Reclock("SZ4",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeadP1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeadP1[nCntFor2][2]),aColsP1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				SZ4->Z4_FILIAL	:= cFilSZ4
				MsUnlock()
			EndIf
		Next
		SZ4->(FKCommit())
						
	Case nOpc == 4  //Atualizar
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณItens da Remarcacao.						                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aRecNo:={}
		dbSelectArea("SZ4")
		dbSetOrder(1)
		DbSeek(xFilial("SZ4")+cChave)
		While ( !Eof() .And. xFilial("SZ4") == SZ4->Z4_FILIAL .And. cChave == SZ4->Z4_TIPO )
			aadd(aRecNo,RecNo())
			dbSelectArea("SZ4")
			dbSkip()
		EndDo
		
		nUsado := Len(aHeadP1)
		For nX := 1 To Len(aColsP1)
			lTravou := .F.
			If nX <= Len(aRecNo)
				dbSelectArea("SZ4")
				dbGoto(aRecNo[nX])
				RecLock("SZ4")
				lTravou := .T.
			EndIf
			If ( !aColsP1[nX][nUsado+1] )
				If !lTravou
					RecLock("SZ4",.T.)
				EndIf
				For nY := 1 to Len(aHeadP1)
					If aHeadP1[nY][10] <> "V"
						SZ4->(FieldPut(FieldPos(aHeadP1[nY][2]),aColsP1[nX][nY]))
					EndIf
				Next nY
				SZ4->Z4_FILIAL	:= cFilSZ4
				MsUnLock()
				lGravou := .T.
			Else
				If lTravou
					SZ4->(dbDelete())
				EndIf
			EndIf
			MsUnLock()
		Next nX
		
	Case nOpc == 5  //Exclusao
					
		dbSelectArea("SZ4")
		dbSetOrder(1)
		If DbSeek(cFilSZ4+cChave)
			While ( !Eof() .And. xFilial("SZ4") == SZ4->Z4_FILIAL .And. cChave == SZ4->Z4_TIPO )
				RecLock("SZ4", .F.)
				dbDelete()
				MsUnLock()
				dbSelectArea("SZ4")
				dbSkip()
			EndDo
		Endif
		SZ4->(FKCommit())
			
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
cQuery += cAlias+"."+"Z4_FILIAL = '"+xFilial(cAlias)+"' AND "
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
	If Alltrim(aHeader1[nCntFor][2])=="Z4_ORDEM"
		aCols1[Len(aCols1)][nCntFor] := "01"		
	ElseIf aHeader1[nCntFor][8] == "C"
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

User Function A109VLD1()

Local lRet   	:= .T.
Local nPos 	 	:= oGetP1:nAt
Local nPosOrd	:= Ascan(aHeadP1,{|x|Alltrim(x[2])=="Z4_ORDEM"})
Local nPosCond	:= Ascan(aHeadP1,{|x|Alltrim(x[2])=="Z4_COND"})
Local nOrdem 	:= Val(oGetP1:aCols[n,nPosOrd])

If nOrdem > 1
	If M->Z4_COND < oGetP1:aCols[nPos-1,nPosCond]
		MsgStop("O valor informado nใo poderแ ser menor que o valor do registro acima.","Aten็ใo")		
		lRet := .F.		
	Endif	
Endif

Return(lRet)