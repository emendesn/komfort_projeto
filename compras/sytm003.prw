#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SYVA006.CH"
#INCLUDE "TOTVS.CH"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "JPEG.CH"

#DEFINE GD_INSERT 1
#DEFINE GD_UPDATE 2
#DEFINE GD_DELETE 4

#DEFINE COL_TAM 6
#Define MAXGETDAD 9999

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ SYTM003  ³ Autor ³   Alexandro Dias      ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Grade de Produtos                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SYTM003()

Local aCores := {}

Private cCadastro 	:= STR0001 // "Grade de Produtos"
Private aRotina  	:= MenuDef()

//#CMG20181203.bn
Private _nPVen := 0
Private _nPTra := 0
Private _lSai  := .F.
Private _nBiPar := 1
Private _nPerso := 1
Private _nEnco := 2
Static oDlg
//#CMG20181203.en

Aadd( aCores, { "B4_STATUS = 'A' " , "BR_VERDE" } )
Aadd( aCores, { "B4_STATUS = 'I' " , "BR_VERMELHO" } )

DbSelectArea("SB4")
DbSetOrder(1)

mBrowse(6,1,22,75,"SB4",,,,,,aCores)

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³COMA06MTA ³ Autor ³   Alexandro Dias      ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Vis/Inc/Alt/Exclusao de produtos. #FOLDER GRADE³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function COMA06MTA(cAlias,nReg,nOpcRet)

Local aMascara 	:= Separa(GetMv('MV_MASCGRD',,'09,04,02,02'),',')
Local aDeleAux	:= {}
Local aButtons 	:= {}
Local aCposVis 	:= {}
Local aCposAlt 	:= {}
Local cProduto  := ""
Local nOpca    	:= 0
Local nLinhas   := 0
Local nColunas 	:= 0
Local lInclui	:= INCLUI
Local lColumn	:= Iif(	GetVersao(.F.) == "P10",.F.,.T.)
Local oDlg
Local oLayer
Local oEnchoice
Local nCont
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}
Local nGetLin  	:= 0
//Local lLicensaOK:= U_XyVldTemplate()

Local bSavKeyF4  	:= SetKey(VK_F4,Nil)
Local bSavKeyF5  	:= SetKey(VK_F5,Nil)
Local bSavKeyF6  	:= SetKey(VK_F6,Nil)
//Local bSavKeyF7  	:= SetKey(VK_F7,Nil)

Local bMovProd 	:= {|| T_SYVC003(M->B4_COD) }
Local bCateg	:= {|| T_CarregaEstrutura() }
Local bFotos	:= {|| IIF(lInclui,Help(Nil,Nil,cCadastro,,STR0002, 1, 5),U_SYTM006A(M->B4_COD)) } // "Necessário finalizar a inclusão do produto!"
Local bManPrc	:= {|| IIF(lInclui,Help(Nil,Nil,cCadastro,,STR0002, 1, 5),U_SYVA140(M->B4_COD)) } // "Necessário finalizar a inclusão do produto!"
Local cPerg		:= Padr("SYTM003",10)


Private nTamCod 	:= TamSX3('B1_COD')[1] // para obter corretamente o tamanho do codigo do produto no dicionario
Private nOpc		:= nOpcRet
Private nTamPai 	:= Val(aMascara[1])
Private nTamLin 	:= Val(aMascara[2])
Private nTamCol 	:= Val(aMascara[3])
Private nTamRef 	:= IIF(Len(aMascara)==4,Val(aMascara[4]),0)
Private aCampos 	:= {}
Private aAlter  	:= {}
Private aAlterBar 	:= {}
Private aAlterCar 	:= {}
Private aDeleta 	:= {}
Private cLinha  	:= ''
Private cGrpCor 	:= GetMv('MV_GRPCOR',,'00') 				//Nome da tabela de grupo de cores padroes ('00')
Private cColuna 	:= ''
Private aRef		:= {}
Private nCodRef		:= 0
Private nCol_Tam	:= COL_TAM
Private cConsultas	:= '000001'
Private cTabPad		:= GetMv("MV_TABPAD")
Private cCodUsrT	:= SuperGetMV("KH_ALTTAB",.F.,"000000")

Private aTELA[0][0]
Private aGETS[0]
Private oFolder
Private oGetGrade
Private aHeaderGrd
Private aColsGrd

Private aHeaderBar := {}
Private aColsBar   := {}
Private oGetBarras

Private oGetCaract
Private aHeaderCar
Private aColsCar

Private oGetMedida
Private aHeaderMed
Private aColsMed
Private aAlterMed

Private aCaract   := {} // Contem o nome dos campos de caracteristica contidos na grade

Private lVA006Exc := ExistBlock("VA006Exc") // Ponto de entrada criado para validar exclusao do produto ou de item da grade     

Private nTotLin := 0
Private aColsOri := {}

//IF !lLicensaOK
//Final(STR0003) // "Sem Permissão"
//EndIF

DA0->(DbSetOrder(1))
If !DA0->(DbSeek(xFilial("DA0") + Padr(cTabPad,TAMSX3("DA0_CODTAB")[1]) ))

	Aviso(STR0028,"Tabela de Preco não cadastrada: "+cTabPad,{"Ok"})//"Atencao"//"Tabela de Preco não cadastrada: "
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna o Backup das Teclas de Funcoes.     	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetKey(VK_F4,bSavKeyF4)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	//SetKey(VK_F7,bSavKeyF7)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da janela                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea(cAlias)
	Return (nOpcA == 1)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o grupo de perguntas somente no caso de alteracao³
//³ para melhoria de performance - #Ellen 28.03.2018      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcRet == 4
	CriaPerg(cPerg)
	While .T.
		IF !Pergunte(cPerg,.T.)
			Return
		Else
			/*
			If Empty(MV_PAR01)
				Aviso("","Favor informar o codigo interno",{"OK"})
			Else
				Exit
			EndIF
			*/
			Exit
		EndIF
	EndDO
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de cores padroes.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaGrpCor()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento dos Campos Alteraveis.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCposVis,"NOUSER")

SX3->(DbSetOrder(1))
SX3->(DbSeek('SB4'))

While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'SB4'
	IF ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		IF nOpc != 3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao permite Alteracao dos Campos abaixo quando ALTERACAO. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !( Alltrim(SX3->X3_CAMPO) $ 'B4_PRV1/B4_01CAT1/B4_01CAT2/B4_01CAT3/B4_01CAT4/B4_01CAT5' )
				Aadd(aCposAlt,SX3->X3_CAMPO)
			EndIF
		Else
			Aadd(aCposAlt,SX3->X3_CAMPO)
		EndIF
		Aadd(aCposVis,SX3->X3_CAMPO)
	EndIF
	SX3->(DbSkip())
EndDo

RegToMemory("SB4",IIF(nOpc==3,.T.,.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obriga usuario entrar com a especie/codigo denovo, caso copia. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DO CASE
	CASE nOpc == 6
		//M->B4_01CAT4	:= CriaVar('B4_01CAT4',.F.)
		M->B4_COD 		:= IIF( FindFunction("U_GERACOD()"), U_GERACOD(.T.), Space(nTamPai) ) //CriaVar('B4_COD',.F.)
	CASE nOpc == 3
		M->B4_COD 		:= Space(nTamPai) //CriaVar('B4_COD',.F.)
ENDCASE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader e aCols                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MA06MTGRD(M->B4_LINHA,M->B4_COLUNA,M->B4_COD)

Aadd(aButtons,{'LINE' 		,{|| Eval(bMovProd) }	, STR0004 } ) // "Movimentação de Produto [F4]"
aadd(aButtons,{'SDUSTRUCT'	,{|| Eval(bCateg) }		, STR0005 } ) // "Categoria [F5]"
AAdd(aButtons,{	''			,{|| Eval(bFotos) }		, STR0006 } ) // "Manutenção de Fotos [F6]"
//AAdd(aButtons,{	''			,{|| Eval(bManPrc) }	, STR0007 } ) // "Manutenção de Preços [F7]"

SetKey( VK_F4 , { || Eval(bMovProd) } )
SetKey( VK_F5 , { || Eval(bCateg) } )
SetKey( VK_F6 , { || Eval(bFotos) } )
//SetKey( VK_F7 , { || Eval(bManPrc) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosObj[1][3] := 230

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estancia Objeto FWLayer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer := FWLayer():new()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o objeto com a janela que ele pertencera. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:init(oDlg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Linha do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addLine('Lin01',90,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria a coluna do Layer. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addCollumn('Col01',100,.F.,'Lin01')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona Janelas as suas respectivas Colunas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oLayer:addWindow('Col01','L1_Win01','',60,.T.,.F.,,'Lin01',)
	oLayer:addWindow('Col01','L2_Win01','',40,.T.,.F.,,'Lin01',)

	If (oApp:cVersion == "P10")
		EnChoice("SB4",,nOpc,,,,,aPosObj[1],aCposAlt,3,,,,)
	Else
		oMsMGet:=MsMGet():New("SB4",,nOpc,,,,aCposVis,aPosObj[1],aCposAlt,,,,,oLayer:getWinPanel('Col01','L1_Win01','Lin01'),,.F.,.T.)
		oMsMGet:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	Endif

	oFolder:=TFolder():New(0,0,{STR0008,STR0009,STR0010,STR0063},,oLayer:getWinPanel('Col01','L2_Win01','Lin01'),,,,.T.,.F.,0,0) // "Grade" # "SKU" # "Características"
	oFolder:Align := CONTROL_ALIGN_ALLCLIENT
	
	// ABA GRADE
	oGetGrade:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(INCLUI .OR. ALTERA .OR. (nOpc==6),GD_INSERT+GD_UPDATE+GD_DELETE,0),"U_MA06LinOk()","U_MA06TudOk","MAREF",aAlter,,MAXGETDAD,,,,oFolder:aDialogs[1],@aHeaderGrd,@aColsGrd)
	oGetGrade:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetGrade:lDelete := .F.
	oGetGrade:lActive := IIF( M->B4_01UTGRD == 'S' , .T. , .F. )
	oGetGrade:GoTop()          
	
	nTotLin := Len(aColsGrd) // Armazena a quantidade de linhas para verificar o ultimo produto gravado na aConls - Marcio Nunes
    aColsOri :=  aClone(aColsGrd) //Clone do aColsGrd para verificar se houve inclusão de novos preços

	// ABA SKU
	oGetBarras:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(ALTERA,GD_INSERT+GD_UPDATE+GD_DELETE,0),,,"",aAlterBar,,,,,,oFolder:aDialogs[2],@aHeaderBar,@aColsBar)
	oGetBarras:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetBarras:lDelete := .F.
	oGetBarras:GoTop()
	
	// 	ABA CARACTERISTICAS
	oGetCaract:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(INCLUI .OR. ALTERA .OR. (nOpc==6),GD_INSERT+GD_UPDATE+GD_DELETE,0),"U_VldCaracteristica()",,,,,,,,,oFolder:aDialogs[3],@aHeaderCar,@aColsCar)
	oGetCaract:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetCaract:GoTop()	
	
	// ABA MEDIDAS ESPECIAIS
	oGetMedida:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(INCLUI .OR. ALTERA .OR. (nOpc==6),GD_UPDATE,0),,,,aAlterMed,,,,,,oFolder:aDialogs[4],@aHeaderMed,@aColsMed)
	oGetMedida:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetMedida:oBrowse:Refresh()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| IIF( (Obrigatorio(aGets,aTela) .And. a006Sair() ) , (nOpca := 1 , oDlg:End() ) , .F. ) } , {|| oDlg:End() },,aButtons)

IF nOpcA == 1 

	IF __lSx8
		ConfirmSx8()
		EvalTrigger()
	Else
		RollBackSx8()
	EndIF

//	IF MA06Digit() //--> Nao vejo necessidade dessa analise, pois so olha coluna da grade #Ellen 21.03.2018
		BEGIN TRANSACTION

			PROCESSA( {|| COMA06GRV(cAlias,IIF(nOpc==3.Or.nOpc==6,.T.,.F.)) }, STR0011) // "Aguarde, Gravando Dados..."

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratameto de exclusao do produto da grade.  	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF nOpc == 5
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratameto de exclusao do pack primario.		  	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    COMA06DEL(oGetGrade)
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama a tela de manutencao de precos na inclusao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//If (nOpc==3) .Or. (nOpc==4) .Or. (nOpc==6) // Inclusao, alteracao e copia
			//	If MsgYesno(STR0012,cCadastro) // "Deseja realizar a manutenção de preços neste momento ? "
			//		U_SYVA140(SB4->B4_COD)
			//	EndIf
			//Endif

			EvalTrigger()

		END TRANSACTION

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF ExistBlock("VA006Fim")
			ExecBlock("VA006Fim",.F.,.F.,{SB4->B4_COD,nOpc})
		EndIF
	//EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna o Backup das Teclas de Funcoes.     	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
//SetKey(VK_F7,bSavKeyF7)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)

Return (nOpcA == 1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  a006Sair ³ Autor ³  Eduardo Patriani  ³ Data ³  29/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida saida da rotina do cadastro.                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function a006Sair()

Local lOk := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada antes da gravacao do produto - DRASTOSA.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("VA006DIG")
	lOk := ExecBlock("VA006DIG" , .F. , .F. )
EndIF

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA06MTGRD ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta acols e aheader,conforme digitado na getdados em     ³±±
±±³          ³ linha e coluna                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06MTGRD(cLinha,cColuna,cProdPai)

Local lRet


lRet := MontaGrd(cLinha,cColuna,cProdPai,@aHeaderGrd,@aColsGrd)
lRet := MontaCarac(cProdPai,"AY5")
IF nOpc <> 6
	lRet := MontaBarra(cLinha,cColuna,cProdPai)
Else
	lRet := MontaBarra(cLinha,cColuna,Space(nTamPai))
EndIF
lRet := MontaMed(cLinha,cColuna,cProdPai,@aHeaderMed,@aColsMed)

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaGrd  ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a grade dos Packs	- Aba #Grade                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaGrd(cLinha,cColuna,cProdPai,aHeaderGrd,aColsGrd)

Local aArea		:= GetArea()
Local nCont 	:= 0
Local nY 		:= 0
Local xAliasSB1:= {}
Local cDescri	:= ""

cProdPai := Padr(Substr(cProdPai,1,nTamPai),nTamPai)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o AHEADER.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderGrd	:= {}
aColsGrd 	:= {}
aAlter		:= {}
cIniCpos	:= ""

Aadd(aHeaderGrd,{STR0013  		,'MAREF'	,'@S30'	,TAMSX3("B1_01DREF")[1]		,0,'U_MAVDREF()'	,'û','C','_ZY'		,'' } ) // "Referência"
IF nTamRef > 0
	Aadd(aAlter,aHeaderGrd[Len(aHeaderGrd),2])
EndIF

Aadd(aHeaderGrd,{STR0014		,'MACOR'	,'@!'	,nTamLin  	   	  			,0,'U_MAVDCOR1()'	,'û','C','SBVCOR'	,'' } ) // "Cor"
Aadd(aAlter,aHeaderGrd[Len(aHeaderGrd),2])

Aadd(aHeaderGrd,{STR0015		,'MADES'	,'@!'	,15		   					,0,'.F.'			,'û','C',''			,'' } ) // "Descrição"

IF GetMv('MV_01UTGRC',,.F.)
	Aadd(aHeaderGrd,{STR0016		,'MAGRPCOR'	,'@!'	,TAMSX3("BV_01DESGR")[1]	,0,'.F.'			,'û','C',''			,'' } ) // "Grupo Cores"
EndIF

Aadd(aHeaderGrd,{RetTitle('B1_01CODFO')	,'MACODFOR'	,'@!'	,TAMSX3("B1_01CODFO")[1]	,0,'.T.'			,'û','C',''			,'' } )
Aadd(aAlter,aHeaderGrd[Len(aHeaderGrd),2])

AY3->(dbSetOrder(1))
AY3->(dbSeek(xFilial("AY3")))
While AY3->(!Eof())

	IF AY3->AY3_TIPO == '2'
		Aadd(aHeaderGrd,{Alltrim(AY3->AY3_DESCRI),'C_'+AllTrim(AY3->AY3_CODIGO),'@!',TAMSX3("AY3_CODIGO")[1],0,;
		'IIF(EMPTY(M->C_'+AY3->AY3_CODIGO+'),.T.,ExistCpo("AY4","'+AY3->AY3_CODIGO+'"+M->C_'+AY3->AY3_CODIGO+',1))','û','C','AY4_2',''})

		Aadd(aAlter,'C_'+AllTrim(AY3->AY3_CODIGO))
		Aadd(aCaract,'C_'+AllTrim(AY3->AY3_CODIGO))
	EndIF

	AY3->(DbSkip())
EndDo

Aadd(aHeaderGrd,{STR0017 ,'MAPACK'	,'@!',TAMSX3("B1_01PACKS")[1]	,0,'ExistCpo("AY7")','û','C','AY7PAK'	,'' } ) // "Packs"
Aadd(aAlter,aHeaderGrd[Len(aHeaderGrd),2])

nCol_Tam := Len(aHeaderGrd)

SBV->(DbOrderNickName('SYMMSBV03')) // BV_FILIAL+BV_TABELA+BV_01SEQ+BV_CHAVE
SBV->(DbSeek(xFilial('SBV')+cColuna))
While SBV->(!Eof()) .And. (SBV->BV_TABELA == cColuna)
	Aadd(aHeaderGrd,{'-'+Alltrim(SBV->BV_DESCRI)+'-','_'+Substr(SBV->BV_CHAVE,1,nTamCol),PesqPict('SB1','B1_CUSTD'),TamSx3("B1_CUSTD")[1],X3Decimal("B1_CUSTD"),'U_SyA550Valid()','û','N','',''})
	Aadd(aAlter,'_'+Substr(SBV->BV_CHAVE,1,ntamCol))
	SBV->(DbSkip())
EndDo

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1')+cProdPai))



While SB1->(!Eof()) .And. SB1->B1_FILIAL+Padr(Substr(SB1->B1_COD,1,nTamPai),nTamPai) == xFilial("SB1")+cProdPai

		//nPos := Ascan(aColsGrd,{|x| x[1]+x[2] == SB1->B1_01DREF+SB1->B1_01LNGRD } )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca pela referencia        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		IF !Empty(MV_PAR02) .And.  ( ALLTRIM(MV_PAR02) $ ALLTRIM(SB1->B1_01DREF) ) //.And. (Empty(MV_PAR01) )   		
			nPos := Ascan(aColsGrd,{|x| x[1]+x[2] == SB1->B1_01DREF+SB1->B1_01LNGRD } )
			IF nPos == 0
				Aadd(aColsGrd,Array(Len(aHeaderGrd)+1))
				nPos := Len(aColsGrd)
		
				For nY := 1 To Len(aHeaderGrd)
					If aHeaderGrd[nY,8] == 'N'
						aColsGrd[nPos,nY] := 0
					Else
						aColsGrd[nPos,nY] := Space(aHeaderGrd[nY,4]+aHeaderGrd[nY,5])
					Endif
				Next
				aColsGrd[Len(aColsGrd)][Len(aHeaderGrd)+1] := .F.
			EndIF
		
			IF nTamRef > 0
				nCodRef := aScan(aRef, {|x| x[1] == AllTrim(SB1->B1_01DREF)})
				IF  nCodRef == 0
					aAdd(aRef, {AllTrim(SB1->B1_01DREF), AllTrim(SB1->B1_01RFGRD)})
				EndIF
			EndIF
		
			For nY := 1 To Len(aHeaderGrd)
		
				IF aHeaderGrd[nY,2] == 'MAREF'
					aColsGrd[nPos,nY] := SB1->B1_01DREF
				ElseIF aHeaderGrd[nY,2] == 'MACOR'
					aColsGrd[nPos,nY] := SB1->B1_01LNGRD
				ElseIF aHeaderGrd[nY,2] == 'MADES'
					aColsGrd[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_DESCRI')
				ElseIF aHeaderGrd[nY,2] == 'MAGRPCOR'
					aColsGrd[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_01DESGR')
				ElseIF aHeaderGrd[nY,2]== 'MACODFOR'
					aColsGrd[nPos,nY] := SB1->B1_01CODFO
				ElseIF aHeaderGrd[nY,2]== 'MAPACK'
					aColsGrd[nPos,nY] := SB1->B1_01PACKS
				ElseIF Substr(aHeaderGrd[nY,2],1,2) == "C_"
					aColsGrd[nPos,nY] := POSICIONE("AY5",3,xFilial("AY5")+Substr(aHeaderGrd[nY,2],3,TAMSX3("AY3_CODIGO")[1])+;
					PADR(cProdPai,TAMSX3("AY5_CODPRO")[1])+SB1->B1_01RFGRD+SB1->B1_01LNGRD,"AY5_SEQ")
				ElseIF Alltrim(SB1->B1_01CLGRD) == Alltrim(Substr(aHeaderGrd[nY,2],2,nTamCol)) .AND. Substr(aHeaderGrd[nY,2],1,2) <> "C_"
					aColsGrd[nPos,nY] := SB1->B1_CUSTD //'X'
				EndIF
			Next
			aColsGrd[Len(aColsGrd)][Len(aHeaderGrd)+1] := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ sem filtro retornando tudo   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		Elseif Empty(MV_PAR01) .And. Empty(MV_PAR02) 
			nPos := Ascan(aColsGrd,{|x| x[1]+x[2] == SB1->B1_01DREF+SB1->B1_01LNGRD } )
			IF nPos == 0
				Aadd(aColsGrd,Array(Len(aHeaderGrd)+1))
				nPos := Len(aColsGrd)
		
				For nY := 1 To Len(aHeaderGrd)
					If aHeaderGrd[nY,8] == 'N'
						aColsGrd[nPos,nY] := 0
					Else
						aColsGrd[nPos,nY] := Space(aHeaderGrd[nY,4]+aHeaderGrd[nY,5])
					Endif
				Next
				aColsGrd[Len(aColsGrd)][Len(aHeaderGrd)+1] := .F.
			EndIF
		
			IF nTamRef > 0
				nCodRef := aScan(aRef, {|x| x[1] == AllTrim(SB1->B1_01DREF)})
				IF  nCodRef == 0
					aAdd(aRef, {AllTrim(SB1->B1_01DREF), AllTrim(SB1->B1_01RFGRD)})
				EndIF
			EndIF
		
			For nY := 1 To Len(aHeaderGrd)
		
				IF aHeaderGrd[nY,2] == 'MAREF'
					aColsGrd[nPos,nY] := SB1->B1_01DREF
				ElseIF aHeaderGrd[nY,2] == 'MACOR'
					aColsGrd[nPos,nY] := SB1->B1_01LNGRD
				ElseIF aHeaderGrd[nY,2] == 'MADES'
					aColsGrd[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_DESCRI')
				ElseIF aHeaderGrd[nY,2] == 'MAGRPCOR'
					aColsGrd[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_01DESGR')
				ElseIF aHeaderGrd[nY,2]== 'MACODFOR'
					aColsGrd[nPos,nY] := SB1->B1_01CODFO
				ElseIF aHeaderGrd[nY,2]== 'MAPACK'
					aColsGrd[nPos,nY] := SB1->B1_01PACKS
				ElseIF Substr(aHeaderGrd[nY,2],1,2) == "C_"
					aColsGrd[nPos,nY] := POSICIONE("AY5",3,xFilial("AY5")+Substr(aHeaderGrd[nY,2],3,TAMSX3("AY3_CODIGO")[1])+;
					PADR(cProdPai,TAMSX3("AY5_CODPRO")[1])+SB1->B1_01RFGRD+SB1->B1_01LNGRD,"AY5_SEQ")
				ElseIF Alltrim(SB1->B1_01CLGRD) == Alltrim(Substr(aHeaderGrd[nY,2],2,nTamCol)) .AND. Substr(aHeaderGrd[nY,2],1,2) <> "C_"
					aColsGrd[nPos,nY] := SB1->B1_CUSTD //'X'
				EndIF
			Next
			aColsGrd[Len(aColsGrd)][Len(aHeaderGrd)+1] := .F.
		Endif
SB1->(DbSkip())
EndDo


IF Len(aColsGrd) == 0
	Aadd(aColsGrd,Array(Len(aHeaderGrd)+1))
	For nY := 1 To Len(aHeaderGrd)
		IF aHeaderGrd[nY,8] == 'C'
			aColsGrd[Len(aColsGrd)][nY]:= Space(aHeaderGrd[nY,4])
		ElseIF aHeaderGrd[nY,8] == 'N'
			aColsGrd[Len(aColsGrd)][nY]:= 0
		EndIF
	Next
	aColsGrd[Len(aColsGrd)][Len(aHeaderGrd)+1] := .F.
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena coluna da descricao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aColsGrd,,,{ |x,y| y[1]+y[2] > x[1]+x[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena array de referencias. Necessario para garantir que a   ³
//³ ultima referencia do array e a maior, para geracao das novas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aRef,,,{ |x,y| y[2] > x[2] } )

IF Type('oGetGrade') == 'O'
	oGetGrade:= MsNewGetDados():New(0,0,0,0,IIF(INCLUI .OR. ALTERA .OR. (nOpc==6),GD_INSERT+GD_UPDATE+GD_DELETE,0),'U_MA06LinOk()','U_MA06TudOk',"MAREF",aAlter,,,,,,oFolder:aDialogs[1],@aHeaderGrd,@aColsGrd)
	oGetGrade:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetGrade:oBrowse:Refresh()
EndIF

RestArea(aArea)

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaBarra³ Autor ³    Alexandro Dias     ³ Data ³ 18/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela para cadastro do codigo de barras do produto. Aba #SKU³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaBarra(cLinha,cColuna,cProdPai)

Local nCont 	:= 0
Local nY 		:= 0
Local cProduto 	:= ""
Local cCor		:= ""
Local xAliasSB1 := {}

cProdPai := Padr(Substr(cProdPai,1,nTamPai),nTamPai)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o AHEADER.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderBar := {}
aColsBar   := {}
Aadd(aHeaderBar,{STR0018,"MACOD"	,"@!",15,0,""				,"","C",""," " } ) // "Código"
Aadd(aHeaderBar,{STR0019,"MADES"	,"@!",35,0,""				,"","C",""," " } ) // "Descrição"
Aadd(aHeaderBar,{STR0020,"MAREF"	,"@!",20,0,""				,"","C",""," " } ) // "Referencia"
Aadd(aHeaderBar,{STR0021,"MACOR"	,"@!",17,0,""				,"","C",""," " } ) // "Cor"
Aadd(aHeaderBar,{STR0022,"MATAM"	,"@!",10,0,""				,"","C",""," " } ) // "Tamanho"
//Aadd(aHeaderBar,{STR0023,"MABAR"	,"@R 9999999999999"	,15,0,"ExistChav('SB1', M->MABAR, 5)","","C",""," " } ) // "Código Barra"	//#RVC20180417.o
Aadd(aHeaderBar,{STR0023,"MABAR"	,"@R 9999999999999"	,15,0,"VAZIO().OR.ExistChav('SB1', M->MABAR, 5)","","C",""," " } ) // "Código Barra"	//#RVC20180417.n
Aadd(aHeaderBar,{STR0024,"CODCL"	,"@!",10,0,""				,"","C",""," " } ) // "Código Interno"
Aadd(aHeaderBar,{STR0064,"PRCVEN"	,PesqPict('SB1','B1_PRV1'),TamSx3("B1_PRV1")[1],X3Decimal("B1_PRV1"),"","","N",""," " } ) // "Preco de Venda"
Aadd(aHeaderBar,{STR0065,"M2TECIDO"	,PesqPict('SB1','B1_IPI'),05,2,"","","N",""," " } ) // "Tecido M²"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZER NA ABA DE SKU AS INFORMACOES SOBRE BIPARTIDO E LOCAL PADRAO DO PRODUTO - LUIZ EDUARDO .F.C - 05.12.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aHeaderBar,{"Armazem"		,""	,"@!",10,0,""				,"","C",""," " } ) // "Armazem"
Aadd(aHeaderBar,{"Bipartido?"	,""	,"@!",10,0,""				,"","C",""," " } ) // "Bipartido"
Aadd(aHeaderBar,{"","VAZIO"	,"@!",01,0,"","","C",""," " } )
Aadd(aAlterBar,aHeaderBar[6,2])
Aadd(aAlterBar,aHeaderBar[7,2])
If __cUserID $ cCodUsrT
	Aadd(aAlterBar,aHeaderBar[8,2]) // Rafael V. Cruz - Criação: 2018.02.23
EndIf	
Aadd(aAlterBar,aHeaderBar[9,2])

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProdPai))
While SB1->(!Eof()) .And. SB1->B1_FILIAL+Padr(Substr(SB1->B1_COD,1,nTamPai),nTamPai) == xFilial("SB1")+cProdPai

	//IncProc("Processando, aguarde..." )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Produto com Grade                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Ascan(aColsBar,{|x| x[1] == SB1->B1_COD } ) == 0
			If !Empty(MV_PAR01)  .And. (ALLTRIM(MV_PAR01) $ ALLTRIM(SB1->B1_CODANT))  // .And. (Empty(MV_PAR02)  ) //--> Filtra pelo codigo interno
				Aadd(aColsBar,Array(Len(aHeaderBar)+1))
				aColsBar[Len(aColsBar)][1]	:= SB1->B1_COD
				aColsBar[Len(aColsBar)][2]	:= SB1->B1_DESC
				aColsBar[Len(aColsBar)][3]	:= AllTrim(SB1->B1_01RFGRD) + ' / ' + SB1->B1_01DREF
				aColsBar[Len(aColsBar)][4]	:= AllTrim(SB1->B1_01LNGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cLinha+SB1->B1_01LNGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][5]	:= AllTrim(SB1->B1_01CLGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cColuna+SB1->B1_01CLGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][6]	:= SB1->B1_CODBAR
				aColsBar[Len(aColsBar)][7]	:= SB1->B1_CODANT
				//Preco de venda deve vir da tabela de preco por Fornecedor (DA1) 
				aColsBar[Len(aColsBar)][8]	:= SYTTAB001(SB1->B1_COD) 
				aColsBar[Len(aColsBar)][9]	:= SB1->B1_01TECM2                                                             
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TRAZER NA ABA DE SKU AS INFORMACOES SOBRE BIPARTIDO E LOCAL PADRAO DO PRODUTO - LUIZ EDUARDO .F.C - 05.12.2017 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aColsBar[Len(aColsBar)][10]	:= SB1->B1_LOCPAD
				aColsBar[Len(aColsBar)][11]	:= IIF(SB1->B1_01BIPAR=="1","SIM","NAO")
				aColsBar[Len(aColsBar)][12]	:= ''
				aColsBar[Len(aColsBar)][Len(aHeaderBar)+1] := .F.				
			Elseif	!Empty(MV_PAR02) .And. ( ALLTRIM(MV_PAR02) $ ALLTRIM(SB1->B1_01DREF) ) //  .And. Empty(MV_PAR01)
				Aadd(aColsBar,Array(Len(aHeaderBar)+1))
				aColsBar[Len(aColsBar)][1]	:= SB1->B1_COD
				aColsBar[Len(aColsBar)][2]	:= SB1->B1_DESC
				aColsBar[Len(aColsBar)][3]	:= AllTrim(SB1->B1_01RFGRD) + ' / ' + SB1->B1_01DREF
				aColsBar[Len(aColsBar)][4]	:= AllTrim(SB1->B1_01LNGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cLinha+SB1->B1_01LNGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][5]	:= AllTrim(SB1->B1_01CLGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cColuna+SB1->B1_01CLGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][6]	:= SB1->B1_CODBAR
				aColsBar[Len(aColsBar)][7]	:= SB1->B1_CODANT  
				//Preco de venda deve vir da tabela de preco por Fornecedor (DA1)
				aColsBar[Len(aColsBar)][8]	:= SYTTAB001(SB1->B1_COD) 
				aColsBar[Len(aColsBar)][9]	:= SB1->B1_01TECM2                                                             
				aColsBar[Len(aColsBar)][10]	:= SB1->B1_LOCPAD
				aColsBar[Len(aColsBar)][11]	:= IIF(SB1->B1_01BIPAR=="1","SIM","NAO")
				aColsBar[Len(aColsBar)][12]	:= ''
				aColsBar[Len(aColsBar)][Len(aHeaderBar)+1] := .F.
			Elseif ( Empty(MV_PAR01) .And. Empty(MV_PAR02) ) 
				Aadd(aColsBar,Array(Len(aHeaderBar)+1))
				aColsBar[Len(aColsBar)][1]	:= SB1->B1_COD
				aColsBar[Len(aColsBar)][2]	:= SB1->B1_DESC
				aColsBar[Len(aColsBar)][3]	:= AllTrim(SB1->B1_01RFGRD) + ' / ' + SB1->B1_01DREF
				aColsBar[Len(aColsBar)][4]	:= AllTrim(SB1->B1_01LNGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cLinha+SB1->B1_01LNGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][5]	:= AllTrim(SB1->B1_01CLGRD) + ' / ' + Posicione("SBV",1,xFilial("SBV")+cColuna+SB1->B1_01CLGRD,"BV_DESCRI")
				aColsBar[Len(aColsBar)][6]	:= SB1->B1_CODBAR
				aColsBar[Len(aColsBar)][7]	:= SB1->B1_CODANT
				//Preco de venda deve vir da tabela de preco por Fornecedor (DA1)   
				aColsBar[Len(aColsBar)][8]	:= SYTTAB001(SB1->B1_COD)
				aColsBar[Len(aColsBar)][9]	:= SB1->B1_01TECM2                                                             
				aColsBar[Len(aColsBar)][10]	:= SB1->B1_LOCPAD
				aColsBar[Len(aColsBar)][11]	:= IIF(SB1->B1_01BIPAR=="1","SIM","NAO")
				aColsBar[Len(aColsBar)][12]	:= ''
				aColsBar[Len(aColsBar)][Len(aHeaderBar)+1] := .F.
			Endif
	EndIF
			
	SB1->(DbSkip())
EndDo

IF Len(aColsBar) == 0
	Aadd(aColsBar,Array(Len(aHeaderBar)+1))
	aColsBar[Len(aColsBar)][1]	:= ''
	aColsBar[Len(aColsBar)][2]	:= ''
	aColsBar[Len(aColsBar)][3]	:= ''
	aColsBar[Len(aColsBar)][4]	:= ''
	aColsBar[Len(aColsBar)][5]	:= ''
	aColsBar[Len(aColsBar)][6]	:= ''
	aColsBar[Len(aColsBar)][7]	:= ''
	aColsBar[Len(aColsBar)][8]	:= 0
	aColsBar[Len(aColsBar)][9]	:= 0
	aColsBar[Len(aColsBar)][10]	:= ''
	aColsBar[Len(aColsBar)][Len(aHeaderBar)+1] := .F.
EndIF


Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaCarac³ Autor ³  Totvs - Microsiga    ³ Data ³ 18/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela para cadastro das caracteristicas do produto.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaCarac(cProdPai,cAlias)

Local nCont 	:= 0
Local nY 		:= 0
Local nUsado	:= 0
Local cProduto 	:= ""
Local cCor		:= ""
Local xAliasSB1 := {}
Local nPosCod	:= 0
Local nPosDesc  := 0
Local nPosSeq	:= 0
Local nPosVlr	:= 0
Local nPosStatec:= 0
Local nPosEnv	:= 0
Local nPosOper  := 0
Local nPosStat	:= 0

cProdPai 	:= Padr(Substr(cProdPai,1,nTamPai),nTamPai)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o AHEADER.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderCar := {}
aColsCar   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek(cAlias)
While !Eof() .And. (X3_ARQUIVO == cAlias)

	IF X3Uso(X3_USADO) .And. (cNivel >= X3_NIVEL) .And. !AllTrim(X3_CAMPO)$"AY5_CODPRO"
		nUsado++
		Aadd(aHeaderCar, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})

		If X3_VISUAL == 'A'
			Aadd(aAlterCar,SX3->X3_CAMPO)
		EndIf
	EndIF

	SX3->(DbSkip())
EndDo

// Posiciona Colunas
nPosCod	  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_CODIGO"	})
nPosDesc  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_DESCRI"	})
nPosSeq	  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_SEQ"		})
nPosVlr	  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_VALOR"	})
nPosStatec:= aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_STATEC"	})
nPosEnv	  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_ENVECO"	})
nPosOper  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_OPER"		})
nPosStat  := aScan(aHeaderCar,{|x| Alltrim(x[2]) == "AY5_STATUS"	})

DbSelectArea("AY5")
DbSetOrder(2)
DbSeek(xFilial("AY5")+cProdPai)
While !Eof() .AND. AY5->AY5_FILIAL+Padr(Substr(AY5->AY5_CODPRO,1,nTamPai),nTamPai) == xFilial("AY5")+cProdPai

	IF EMPTY(AY5->AY5_REFGRD) .AND. EMPTY(AY5->AY5_LINGRD)

		Aadd(aColsCar,Array(Len(aHeaderCar)+1))
		aColsCar[Len(aColsCar)][nPosCod]    := AY5->AY5_CODIGO
		aColsCar[Len(aColsCar)][nPosDesc]   := Posicione("AY3",1,xFilial("AY3")+AY5->AY5_CODIGO,"AY3_DESCRI")
		aColsCar[Len(aColsCar)][nPosSeq]    := AY5->AY5_SEQ
		aColsCar[Len(aColsCar)][nPosVlr]    := Posicione("AY4",1,xFilial("AY4")+AY5->AY5_CODIGO+AY5->AY5_SEQ,"AY4_VALOR")

		If nPosStatec > 0
			aColsCar[Len(aColsCar)][nPosStatec] := AY5->AY5_STATEC
		EndIf

		If nPosEnv > 0
			aColsCar[Len(aColsCar)][nPosEnv] := AY5->AY5_ENVECO
		EndIf

		If nPosOper > 0
			aColsCar[Len(aColsCar)][nPosOper] := AY5->AY5_OPER
		EndIf

		If nPosStat > 0
			aColsCar[Len(aColsCar)][nPosStat] := AY5->AY5_STATUS
		EndIF

		aColsCar[Len(aColsCar)][Len(aHeaderCar)+1] := .F.
	EndIF

	DbSelectArea("AY5")
	DbSkip()
EndDo

IF Len(aColsCar) == 0
	Aadd(aColsCar,Array(Len(aHeaderCar)+1))
	aColsCar[Len(aColsCar)][nPosCod] 		:= CriaVar("AY5_CODIGO",.F.)
	aColsCar[Len(aColsCar)][nPosDesc]		:= CriaVar("AY5_DESCRI",.F.)
	aColsCar[Len(aColsCar)][nPosSeq] 		:= CriaVar("AY5_SEQ",.F.)
	aColsCar[Len(aColsCar)][nPosVlr] 		:= CriaVar("AY5_VALOR",.F.)
	aColsCar[Len(aColsCar)][Len(aHeaderCar)+1] := .F.

	If nPosStatec > 0
		aColsCar[Len(aColsCar)][nPosStatec] := CriaVar("AY5_STATEC",.T.)
	EndIf

	If nPosEnv > 0
		aColsCar[Len(aColsCar)][nPosEnv] := CriaVar("AY5_ENVECO",.T.)
	EndIf

	If nPosOper > 0
		aColsCar[Len(aColsCar)][nPosOper] := CriaVar("AY5_OPER",.T.)
	EndIf

	If nPosStat > 0
		aColsCar[Len(aColsCar)][nPosStat] := CriaVar("AY5_STATUS",.T.)
	EndIF
EndIF

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaGrd  ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a grade dos Packs - Aba #Medidas Especiais           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaMed(cLinha,cColuna,cProdPai,aHeaderMed,aColsMed)

Local aArea		:= GetArea()
Local nCont 	:= 0
Local nY 		:= 0
Local xAliasSB1:= {}

cProdPai := Padr(Substr(cProdPai,1,nTamPai),nTamPai)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o AHEADER.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderMed	:= {}
aColsMed 	:= {}
aAlterMed	:= {}
cIniCpos	:= ""

Aadd(aHeaderMed,{STR0013  				,'MAREF'	,'@S30'			,TAMSX3("B1_01DREF")[1]		,0,'U_MAVDREF()'	,'û','C',''			,'' } ) // "Referência"
Aadd(aHeaderMed,{STR0014				,'MACOR'	,'@!'			,nTamLin  	   	  			,0,'U_MAVDCOR1()'	,'û','C','SBVCOR'	,'' } ) // "Cor"
Aadd(aHeaderMed,{STR0015				,'MADES'	,'@!'			,15		   					,0,'.F.'			,'û','C',''			,'' } ) // "Descrição"
Aadd(aHeaderMed,{"Preco M²" 			,'PRCM2'	,PesqPict('SB1','B1_PRV1'),12				,2,''				,'û','N',''			,'' } ) // "Preco m2"

AAdd(aAlterMed , aHeaderMed[Len(aHeaderMed),2] )

nCol_Tam := Len(aHeaderMed)

SBV->(DbOrderNickName('SYMMSBV03')) // BV_FILIAL+BV_TABELA+BV_01SEQ+BV_CHAVE
SBV->(DbSeek(xFilial('SBV')+cColuna))
While SBV->(!Eof()) .And. (SBV->BV_TABELA == cColuna)
	Aadd(aHeaderMed,{'-'+Alltrim(SBV->BV_DESCRI)+'-','_'+Substr(SBV->BV_CHAVE,1,nTamCol),PesqPict('SB1','B1_CUSTD'),TamSx3("B1_CUSTD")[1],X3Decimal("B1_CUSTD"),'U_SyA006Valid()','û','N','',''})
	Aadd(aAlterMed,'_'+Substr(SBV->BV_CHAVE,1,ntamCol))
	SBV->(DbSkip())
EndDo

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1')+cProdPai)) 

While SB1->(!Eof()) .And. SB1->B1_FILIAL+Padr(Substr(SB1->B1_COD,1,nTamPai),nTamPai) == xFilial("SB1")+cProdPai

	nPos := Ascan(aColsMed,{|x| x[1]+x[2] == SB1->B1_01DREF+SB1->B1_01LNGRD } )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca pela Referencia        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !Empty(MV_PAR02)  .And. (ALLTRIM(MV_PAR02) $ ALLTRIM(SB1->B1_01DREF) ) // .And. (Empty(MV_PAR01) ) 
	
		IF nPos == 0 
			Aadd(aColsMed,Array(Len(aHeaderMed)+1))
			nPos := Len(aColsMed) 
			ProcRegua(Len(aColsMed))
			
			For nY := 1 To Len(aHeaderMed)
				IncProc()
				If aHeaderMed[nY,8] == 'N'
					aColsMed[nPos,nY] := 0
				ElseIF aHeaderMed[nY,2] == 'MAREF'
					aColsMed[nPos,nY] := SB1->B1_01DREF
				ElseIF aHeaderMed[nY,2] == 'MACOR'
					aColsMed[nPos,nY] := SB1->B1_01LNGRD
				ElseIF aHeaderMed[nY,2] == 'MADES'
					aColsMed[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_DESCRI')
				ElseIf aHeaderMed[nY,2] == 'PRCM2'
					aColsMed[nPos,nY] := If(aColsMed[nPos,nY]==0,SB1->B1_01VLRM2,aColsMed[nPos,nY])
				ElseIF Substr(aHeaderMed[nY,2],1,2) == "C_"
					aColsMed[nPos,nY] := POSICIONE("AY5",3,xFilial("AY5")+Substr(aHeaderMed[nY,2],3,TAMSX3("AY3_CODIGO")[1])+;
					PADR(cProdPai,TAMSX3("AY5_CODPRO")[1])+SB1->B1_01RFGRD+SB1->B1_01LNGRD,"AY5_SEQ")
				ElseIF Alltrim(SB1->B1_01CLGRD) == Alltrim(Substr(aHeaderMed[nY,2],2,nTamCol)) .AND. Substr(aHeaderMed[nY,2],1,2) <> "C_"
					aColsMed[nPos,nY] := SB1->B1_01VLRME	
				Else
					aColsMed[nPos,nY] := Space(aHeaderMed[nY,4]+aHeaderMed[nY,5])
				Endif
			Next
			aColsMed[Len(aColsMed)][Len(aHeaderMed)+1] := .F.
		EndIF

	Elseif Empty(MV_PAR01) .And. Empty(MV_PAR02) 
		
		IF nPos == 0 
			Aadd(aColsMed,Array(Len(aHeaderMed)+1))
			nPos := Len(aColsMed)
			ProcRegua(Len(aColsMed))
			
			For nY := 1 To Len(aHeaderMed)
				IncProc()
				If aHeaderMed[nY,8] == 'N'
					aColsMed[nPos,nY] := 0
				ElseIF aHeaderMed[nY,2] == 'MAREF'
					aColsMed[nPos,nY] := SB1->B1_01DREF
				ElseIF aHeaderMed[nY,2] == 'MACOR'
					aColsMed[nPos,nY] := SB1->B1_01LNGRD
				ElseIF aHeaderMed[nY,2] == 'MADES'
					aColsMed[nPos,nY] := Posicione('SBV',1,xFilial('SBV')+cLinha+SB1->B1_01LNGRD,'BV_DESCRI')
				ElseIf aHeaderMed[nY,2] == 'PRCM2'
					aColsMed[nPos,nY] := If(aColsMed[nPos,nY]==0,SB1->B1_01VLRM2,aColsMed[nPos,nY])
				ElseIF Substr(aHeaderMed[nY,2],1,2) == "C_"
					aColsMed[nPos,nY] := POSICIONE("AY5",3,xFilial("AY5")+Substr(aHeaderMed[nY,2],3,TAMSX3("AY3_CODIGO")[1])+;
					PADR(cProdPai,TAMSX3("AY5_CODPRO")[1])+SB1->B1_01RFGRD+SB1->B1_01LNGRD,"AY5_SEQ")
				ElseIF Alltrim(SB1->B1_01CLGRD) == Alltrim(Substr(aHeaderMed[nY,2],2,nTamCol)) .AND. Substr(aHeaderMed[nY,2],1,2) <> "C_"
					aColsMed[nPos,nY] := SB1->B1_01VLRME	
				Else
					aColsMed[nPos,nY] := Space(aHeaderMed[nY,4]+aHeaderMed[nY,5])
				Endif
			Next
			aColsMed[Len(aColsMed)][Len(aHeaderMed)+1] := .F.
		EndIF
		
	Endif
	
	IF nTamRef > 0
		nCodRef := aScan(aRef, {|x| x[1] == AllTrim(SB1->B1_01DREF)})
		IF  nCodRef == 0
			aAdd(aRef, {AllTrim(SB1->B1_01DREF), AllTrim(SB1->B1_01RFGRD)})
		EndIF
	EndIF

	SB1->(DbSkip())

EndDo

IF Len(aColsMed) == 0
	Aadd(aColsMed,Array(Len(aHeaderMed)+1))
	For nY := 1 To Len(aHeaderMed)
		IF aHeaderMed[nY,8] == 'C'
			aColsMed[Len(aColsMed)][nY]:= Space(aHeaderMed[nY,4])
		ElseIF aHeaderMed[nY,8] == 'N'
			aColsMed[Len(aColsMed)][nY]:= 0
		EndIF
	Next
	aColsMed[Len(aColsMed)][Len(aHeaderMed)+1] := .F.
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena coluna da descricao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aColsMed,,,{ |x,y| y[1]+y[2] > x[1]+x[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena array de referencias. Necessario para garantir que a   ³
//³ ultima referencia do array e a maior, para geracao das novas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aRef,,,{ |x,y| y[2] > x[2] } )

IF Type('oGetMedida') == 'O'
	oGetMedida:= MsNewGetDados():New(0,0,0,0,IIF(INCLUI .OR. ALTERA .OR. (nOpc==6),GD_UPDATE,0),,,,aAlterMed,,,,,,oFolder:aDialogs[4],@aHeaderMed,@aColsMed)
	oGetMedida:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetMedida:oBrowse:Refresh()
EndIF

RestArea(aArea)

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA06LinOk ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica se a linha digitada esta' Ok                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06LinOk() //ELLEN

Local nPosRef	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local lRet 		:= .T.
Local aAuxDel	:= {}
Local nLinhas	:= 0
Local nColunas	:= 0
Local i			:= 0
Local lExisteX 	:= .F.
Local nZ        := 0

For nZ := nCol_Tam To Len(oGetGrade:aCols[oGetGrade:nAt])
	IF !Empty(oGetGrade:aCols[oGetGrade:nAt,nZ])
		lExisteX := .T.
		Exit
	EndIF
Next nZ

IF Empty(oGetGrade:aCols[oGetGrade:nAt,nPosRef]) .And. (nTamRef > 0)
	MsgAlert(STR0025) // "Referência não informada."
	Return .F.
ElseIF Empty(oGetGrade:aCols[oGetGrade:nAt,nPosLin])
	MsgAlert(STR0026) // "Cor não informada."
	Return .F.
ElseIF INCLUI .And. ( M->B4_01UTGRD == 'S' ) .And. !lExisteX
	MsgAlert(STR0027) // "Informe os dados da Grade."
	Return .F.
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIFica se a linha foi deletada   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF oGetGrade:aCols[oGetGrade:nAt][Len(oGetGrade:aCols[oGetGrade:nAt])]

	For nColunas := nCol_Tam to Len(oGetGrade:aHeader)

		cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
		cProduto += SubStr(oGetGrade:aCols[oGetGrade:nAt][nPosLin],1,nTamLin)
		cProduto += Substr(oGetGrade:aHeader[nColunas][2],2,nTamCol)

		IF nTamRef > 0
			nCodRef:= aScan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[oGetGrade:nAt,nPosRef])})
			IF (nCodRef > 0)
				cProduto += AllTrim(aRef[nCodRef,2])
			EndIF
		EndIF

		cProduto := Padr(cProduto,TamSx3("B1_COD")[1])

		IF oGetGrade:aCols[oGetGrade:nAt][nColunas] == 'X'
			lRet:=a006Prod(cProduto)
			IF !lRet
				Exit
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena os produtos desta linha que pode ser excluidos        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AADD(aAuxDel,cProduto)
			EndIF
		EndIF
	Next nColunas

	IF !lRet
		oGetGrade:aCols[oGetGrade:nAt][Len(oGetGrade:aCols[oGetGrade:nAt])] := .F.
		o:RefreshCurrent()
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se todos os produtos desta linha podem ser excluidos, entao    ³
		//³ sao armazenados no array que controla os produtos a serem      ³
		//³ excluidos apos a confirmacao dos dados                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 to Len(aAuxDel)
			AADD(aDeleta,aAuxDel[i])
		Next
	EndIF
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem tabela de preço para o forncedor   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := SYTMTAB(M->B4_PROC, M->B4_LOJPROC)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VerIFica se existe pelo menos um campo preenchido  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet 
		For nColunas := nCol_Tam to Len(oGetGrade:aHeader)
			For nLinhas := 1 to Len(oGetGrade:aCols)
				IF !Empty(oGetGrade:aCols[nLinhas][nColunas] )
					lRet:=.T.
					Exit
				EndIF
			Next nLinhas
			IF lRet
				Exit
			EndIF
		Next nColunas
		IF !lRet .And. Empty(M->B4_COD)
			lRet:=.T.
		EndIF
	Else	
		Aviso(STR0028,"Não existe tabela de preço para esse fornecedor, favor providenciar cadastro.",{"Ok"})
	Endif
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA06Digit ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ VerIFica se tem algum ponto de grade preenchido            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MA06Digit()

Local nLinhas	:= 0
Local nColunas	:= 0
Local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida os produtos que nao possuem grade.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF M->B4_01UTGRD == "N"
	lRet :=.T.
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIFica se existe pelo menos um campo preenchido  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nColunas := nCol_Tam To Len(oGetGrade:aHeader)

	For nLinhas:=1 to Len(oGetGrade:aCols)
		IF !Empty(oGetGrade:aCols[nLinhas][nColunas] )
			lRet := .T.
			Exit
		EndIF
	Next nLinhas

	IF lRet
		Exit
	EndIF
Next nColunas

IF !lRet .And. Empty(M->B4_COD)
	lRet:=.T.
EndIF

IF !lRet
	Help(" ",1,"EXCTODREF")
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³COMA06GRV ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o Arquivo de Grades de Produtos                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function COMA06GRV(cAlias,lInclui)

Local aStructSB4	:= SB4->(DbStruct())
Local cCodNew   	:= M->B4_COD
Local cProdPai 		:= Padr(M->B4_COD,nTamPai)
Local nPosRef		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local nPosForn		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACODFOR"})
Local nPosPack		:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAPACK"})
Local nPosCodBar	:= Ascan(oGetBarras:aHeader,{|x| AllTrim(Upper(x[2])) == "MABAR"})
Local nPosTecM2		:= Ascan(oGetBarras:aHeader,{|x| AllTrim(Upper(x[2])) == "M2TECIDO"})
Local nPosCODIN		:= Ascan(oGetBarras:aHeader,{|x| AllTrim(Upper(x[2])) == "CODCL"})
/* --Em desuso
Local nPosOper		:= Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_OPER"})
Local nPosCar		:= Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_CODIGO"})
Local nPosSeq		:= Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_SEQ"})
*/
Local nPosPrcM2	:= Ascan(oGetMedida:aHeader,{|x| AllTrim(Upper(x[2])) == "PRCM2"})

Local nPosPrcven	:= Ascan(oGetBarras:aHeader,{|x| AllTrim(Upper(x[2])) == "PRCVEN"})
Local nPosMacod		:= Ascan(oGetBarras:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOD"}) 
Local cComplemento	:= ''
Local cMay      	:= ''
Local cFilAtu		:= ''
Local nTamFil		:= Len(cFilAnt)
Local nx        	:= 0
Local nXz			:= 0
Local nPos			:= 0
Local nAchou    	:= 0
Local nCustoIpi		:= 0
Local nCustoFrete	:= 0
Local aDescCol	 	:= {}
Local aPrecos		:= {}
Local aLojas		:= {}
Local nY
Local lStatus		:= .F.
Local lOk			:= .F.
Local nColunas 		:= 0
Local nLinhas 		:= 0
Local nX1			:= 0
Local aAreaSM0 		:= {}
Local lContinua		:= .F.
Local _lNew         := .F.//#CMG20181203.n
Local _aPrcNew      := {}//#CMG20181203.n
Local lGravaB1		:= .F.


For nY := 1 To Len(aStructSB4)
	Aadd(aCampos,Alltrim(Substr(aStructSB4[nY,1],3,8)))
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VerIFica se o codigo ja nao está sendo usado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF INCLUI .OR. nOpc == 6
	If SuperGetMV("MV_SYPRODU",,.F.) // Caso codigo do produto deve ser unico entre todas as filiais independente do compartilhamento da tabela SB4
		While ValCodProd(cCodNew)
			cCodNew := PadR(Soma1(Alltrim(cCodNew)),TamSX3('B4_COD')[1])
			LOOP
		EndDo
	Else
		DbSelectArea("SB4")
		DbSetOrder(1)
		While DbSeek(xFilial("SB4")+cCodNew)
			cCodNew := PadR(Soma1(Alltrim(cCodNew)),TamSX3('B4_COD')[1])
			LOOP
		EndDo
	EndIf

	IF Alltrim(M->B4_COD) <> Alltrim(cCodNew)
		Help("",1,STR0028,,STR0029 + Alltrim(M->B4_COD) + STR0030 + CRLF + STR0031 + cCodNew ,1, 1 ) // "Atenção" # "Este código de Produtos [" # "] ja existe." # " O novo código será: "
		M->B4_COD	:= Padr(cCodNew,TamSX3('B4_COD')[1])
		cProdPai	:= Padr(M->B4_COD,nTamPai)
	EndIF
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe tabela de preço para o fornecedor  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF nOpc == 3 .Or. nOpc == 4 
	If !Empty(M->B4_PROC)
		lContinua := SYTMTAB(M->B4_PROC, M->B4_LOJPROC)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza dados SB4    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua
	DbSelectArea('SB4')
	RecLock('SB4',lInclui)
	If SB4->B4_STATUS <> M->B4_STATUS
		lStatus := .T.
	EndIf
	For nX := 1 to fCount()
		If FieldName(nX) # 'B4_FILIAL/B4_STATUS'
			FieldPut(nX, &('M->' + FieldName(nX)))
		EndIF
	Next nX
	SB4->B4_FILIAL := xFilial('SB4')
	SB4->(MsUnLock())
Endif

/*
IF SB4->(FieldPos("B4_STATECO")) > 0 .AND. SB4->(FieldPos("B4_OPER")) > 0 .AND.;
SB4->(FieldPos("B4_ENVECO")) > 0 .AND. SB4->(FieldPos("B4_CATECO")) > 0

SB4->B4_STATECO := "2"  //Sempre com a String 2 que se trata como pendente para envio e-Commerce.
SB4->B4_OPER    := "1"  //Identificar se o campo B4_OPER estiver vazio preencher com “1” , caso contrario se for alteração preencher com “2”
SB4->B4_ENVECO  := "1"  //Preencher sempre com “1”
SB4->B4_CATECO  := "1"  //Preencher sempre com “1”
EndIF
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os dados do produto COM GRADE na SB1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lContinua

		nCol_Tam := COL_TAM
		
		IF M->B4_01UTGRD == "S"
		
			ProcRegua(Len(oGetGrade:aCols))
			For nLinhas := 1 to Len(oGetGrade:aCols)
		
				IncProc()
		
				IF nTamRef > 0
					nCodRef := aScan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[nLinhas,nPosRef])})
					IF  nCodRef == 0
						aAdd(aRef, {AllTrim(oGetGrade:aCols[nLinhas,nPosRef]), IIF(EMPTY(aRef),StrZero(1,nTamRef),SOMA1(aRef[Len(aRef),2],2)) })
					EndIF
				EndIF
		
				For nColunas := nCol_Tam to Len(oGetGrade:aHeader)
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ verIFica se esta com X e se a linha nao esta deletada  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
					IF ( oGetGrade:aCols[nLinhas, nColunas] > 0 .And. !oGetGrade:aCols[nLinhas,Len(oGetGrade:aHeader)+1] )
		
						cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
						cProduto += SubStr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)
						cProduto += Substr(oGetGrade:aHeader[nColunas,2],2,nTamCol)
						IF nTamRef > 0
							cProduto += IIF(nCodRef<>0,aRef[nCodRef,2],aRef[Len(aRef),2])
						EndIF
						cProduto := Padr(cProduto,TamSx3("B1_COD")[1])		                		              		              
		                
						//Valida os ultimos produtos que foram incluídos, para evitar a inclusão de produtos que ja existem na lista - Marcio Nunes  - Chamado: 7862
						If !INCLUI
							If (nLinhas > nTotLin) .Or. aColsOri [nLinhas, nColunas] ==0 //Condição .Or.  valida se a posição estava vazia e foi alimentada para permitir a inclusão de um novo produto   
			                	lGravaB1 := .T. 
			                EndIf
		                EndIf 
		               
						DbSelectArea('SB1')
						DbSetOrder(1)
						IF !DbSeek(xFilial("SB1") + cProduto) .And. lGravaB1 //Valida os ultimos produtos que foram incluídos, para evitar a inclusão de produtos que ja existem na lista - Marcio Nunes  - Chamado: 7862
							
							_lNew := .T.//#CMG20181203.n
					
							RecLock('SB1',.T.)                                   
							SB1->B1_FILIAL 	:= xFilial('SB1')
							SB1->B1_COD 		:= cProduto
							SB1->B1_GRADE    := 'S'
							If (!Empty(oGetGrade:aCols[nLinhas,nColunas])) //Atualiza apenas caso o campo seja diferente de vazio
								SB1->B1_CUSTD	:= oGetGrade:aCols[nLinhas,nColunas]
								SB1->B1_01CUSTO	:= oGetGrade:aCols[nLinhas,nColunas]
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Preco de Venda := (Custo + IPI + Montagem + Embalagem + Frete + ST) * Markup   ³ // (Custo + IPI) * Markup
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nCustoIpi	:= oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100)
							nCustoFrete	:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * (M->B4_01VLFRE/100)
							/*						
							#ES04062018 - Se o preco for atualizado nesse momento, o preco ficará zerado para
							todos os produtos devido nao ter % de Markup
							*/
							//B1_PRV1		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * M->B4_01MKP
							//B1_PRV1		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi+M->B4_01VLMON+M->B4_01VLEMB+nCustoFrete+M->B4_01ST) * M->B4_01MKP
						ElseIf DbSeek(xFilial("SB1") + cProduto) 
							RecLock('SB1',.F.)                              
					    Else
					    	Loop          
						EndIF
		
						For nX := 1 to Len(aCampos)
		
							IF aCampos[nX] $ '_FILIAL/_COD/_LINHA/_COLUNA/_STATUS/_PRV1' .Or. ( SB1->(FieldPos("B1" + aCampos[nX])) == 0 .And. !aCampos[nX] $ '_STATUS' )
								Loop
							Elseif aCampos[nX] $ '_MSBLQL'
								SB1->B1_MSBLQL	:= SB4->B4_MSBLQL //IIF( SB4->B4_STATUS == "I" , "1" , "2" )
							Else
								cCampo1 := 'B1' + aCampos[nX]
								cCampo2 := 'M->B4' + aCampos[nX]
								Replace &cCampo1 With &cCampo2
								IF cCampo1 == "B1_DESC"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Complementa ou nao a descricao do produto com a Coluna (Tamanho). ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									IF GetMv("MV_B4COMPL",,.T.)
										cComplemento := ' ' + Alltrim(oGetGrade:aCols[nLinhas,nPosRef])
		
										If GetMv("MV_01CODFO",,.F.)
											cComplemento += ' ' + If(!Empty(oGetGrade:aCols[nLinhas,nPosForn]) , Alltrim(oGetGrade:aCols[nLinhas,nPosForn]) , Alltrim(Posicione("SBV",1,xFilial("SBV")+M->B4_LINHA+Alltrim(SubStr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)),"BV_DESCRI")) )
										Else
											cComplemento += ' ' + Alltrim(Posicione("SBV",1,xFilial("SBV")+M->B4_LINHA+Alltrim(SubStr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)),"BV_DESCRI"))
										Endif
										cComplemento += ' ' + Alltrim(Posicione("SBV",1,xFilial("SBV")+M->B4_COLUNA+Alltrim(Substr(oGetGrade:aHeader[nColunas][2],2,nTamCol)),"BV_DESCRI"))
		
										Replace B1_DESC With Alltrim(&cCampo1) + cComplemento
									Else
										Replace B1_DESC With Alltrim(&cCampo1)
									EndIF
								EndIF
							EndIF
		
						Next nX 
							
						//#CMG20181203.bn	
						If _lNew	
														
							fTelaPre(AllTrim(cProduto)+" - "+AllTrim(SB1->B1_DESC))
							
							If DbSeek(xFilial("SB1") + cProduto)
							
								If ValType(_nPerso) == 'C'
								
									_nPerso := Val(SubsTr(_nPerso,1,1))
																	
								EndIf

								If ValType(_nBiPar) == 'C'
								
									_nBiPar := Val(SubsTr(_nBiPar,1,1))
								
								EndIf
								
								If ValType(_nEnco) == 'C'
								
									_nEnco := Val(SubsTr(_nEnco,1,1))
								
								EndIf															
							
								RecLock('SB1',.F.)
									SB1->B1_PRV1 	:= _nPTra
									SB1->B1_XPERSO  := IIF(_nPerso==1,"1","2")
									SB1->B1_01BIPAR := IIF(_nBiPar==1,"1","2")
									SB1->B1_XENCOME := IIF(_nEnco==1,"1","2")
								SB1->(MsUnLock())
								
								AAdd( _aPrcNew , {SB1->B1_COD , _nPVen } )
								fAtuPreco(_aPrcNew)
								_aPrcNew := {}
																
							EndIf
							
							_nPVen := 0
							_nPTra := 0
							_lSai  := .F.
							_lNew := .F.
							
						EndIf	
						//#CMG20181203.en
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ VERIFICA SE O PRODUTO E BI-PARTIDO E SETA O ARMAZEM PADRAO PARA ESTE PRODUTO - LUIZ EDUARDO F.C. - 05.12.2017 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF Posicione("SBV",1,xFilial("SBV")+M->B4_COLUNA+Alltrim(Substr(oGetGrade:aHeader[nColunas][2],2,nTamCol)),"BV_01BIPAR") == "1"
							SB1->B1_LOCPAD  := GetMv("KH_ARMZBIP")   
							SB1->B1_01BIPAR := "1"
						EndIF
		
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Cria codigo de Barras padra EAN 13.			³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF GetMv("MV_AUTCOBA",,.T.) .And. Empty(SB1->B1_CODBAR)
		//					SB1->B1_CODBAR	:= U_RetPCodBar()	//#RVC20180416.o
							SB1->B1_CODBAR	:= U_KMESTX02()		//#RVC20180416.n
						EndIF
		
						IF Empty(SB1->B1_CODANT)
							IF GetMv("MV_01CODAN",,.T.)
								SB1->B1_CODANT 	:= SubStr(SB1->B1_CODBAR,1,12)
							Else
								SB1->B1_CODANT 	:= ""
							EndIF
						EndIF
		
						nCustoIpi		:= oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100)
						nCustoFrete		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * (M->B4_01VLFRE/100)      
						//SB1->B1_PRV1	:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi+M->B4_01VLMON+M->B4_01VLEMB+nCustoFrete+M->B4_01ST) * M->B4_01MKP
						If (!Empty(oGetGrade:aCols[nLinhas,nColunas])) //Atualiza apenas caso o campo seja diferente de vazio
							SB1->B1_CUSTD	:= oGetGrade:aCols[nLinhas,nColunas]//#CMG20180719.n - Solicitado pelo Dionei a gravar o campo de custo - antes estava comentado
							SB1->B1_01CUSTO	:= oGetGrade:aCols[nLinhas,nColunas]                                 
						EndIf
						SB1->B1_01PRODP	:= Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
						SB1->B1_01LNGRD	:= SubStr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)
						SB1->B1_01CLGRD	:= Substr(oGetGrade:aHeader[nColunas][2],2,nTamCol)
		
						IF !Empty(SB1->B1_01PACKS)
							SB1->B1_01PACKS	:= oGetGrade:aCols[nLinhas,nPosPack]
						Endif
						IF !Empty(SB1->B1_01CODFO)
							SB1->B1_01CODFO	:= oGetGrade:aCols[nLinhas,nPosForn]
						Endif
		
						IF nTamRef > 0
							IF !EMPTY(aRef)
								SB1->B1_01RFGRD	:= IIF(nCodRef<>0,aRef[nCodRef,2],aRef[Len(aRef),2])
								SB1->B1_01DREF	:= oGetGrade:aCols[nLinhas,nPosRef]
							EndIF
						EndIF
						SB1->(MsUnLock())
		
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Armazeno os precos dos produtos para atualizacao da tabela de preco.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AAdd( aPrecos , {SB1->B1_COD , SB1->B1_PRV1 } ) // Esse preço eh de Custo e nao de venda
		
					ElseIF ( oGetGrade:aCols[nLinhas,nColunas] = 0 .Or. oGetGrade:aCols[nLinhas,Len(oGetGrade:aHeader)+1] )
		
						cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
						cProduto += Substr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)
						cProduto += Substr(oGetGrade:aHeader[nColunas,2],2,nTamCol)
						IF nTamRef > 0
							cProduto += IIF(nCodRef<>0,aRef[nCodRef,2],aRef[Len(aRef),2])
						EndIF
						cProduto := Padr(cProduto,TamSx3("B1_COD")[1])
						
						DbSelectArea('SB1')
						DbSetOrder(1)
						IF DbSeek(xFilial("SB1") + cProduto)
							RecLock('SB1',.F.)
							B1_FILIAL 	:= xFilial('SB1')
							B1_COD 		:= cProduto
							B1_GRADE    := 'S'
							If (!Empty(oGetGrade:aCols[nLinhas,nColunas])) //Atualiza apenas caso o campo seja diferente de vazio
								B1_CUSTD	:= oGetGrade:aCols[nLinhas,nColunas] //#CMG20180719.n - Solicitado pelo Dionei a gravar o campo de custo - antes estava comentado
								B1_01CUSTO	:= oGetGrade:aCols[nLinhas,nColunas]
							EndIf
							nCustoIpi	:= oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100)
							nCustoFrete	:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * (M->B4_01VLFRE/100)
							//B1_PRV1		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * M->B4_01MKP
							//B1_PRV1		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi+M->B4_01VLMON+M->B4_01VLEMB+nCustoFrete+M->B4_01ST) * M->B4_01MKP
							SB1->(MsUnlock())
						Endif
						
						/*	
						SB1->( DbSetOrder(1) )
						IF SB1->( DbSeek( xFilial("SB1") + cProduto ) )
							a550Del(cProduto)
						EndIF
		
						DA1->( DbSetOrder(1) )
						IF DA1->( DbSeek( xFilial("DA1") + cTabPad + cProduto ) )
							RecLock("DA1",.F.,.T.)
							DA1->( DbDelete() )
							MsUnLock()
						EndIF
						
						DbSelectArea("SB5")
						DbSetOrder(1)
						IF DbSeek(xFilial("SB5")+cProduto)
							RecLock("SB5",.F.,.T.)
							DbDelete()
							MsUnLock()
						EndIF
						
						aAreaSM0 := SM0->(GetArea())
						aLojas	 := {}
						SM0->(DbSeek(cEmpAnt))
						While SM0->(!EOF()) .AND. SM0->M0_CODIGO == cEmpAnt
							Aadd(aLojas,AllTrim(SM0->M0_CODFIL))
							SM0->(DbSkip())
						EndDo
						SM0->(RestArea(aAreaSM0))
						
						cFilAtu := cFilAnt								
						For nXz := 1 To Len(aLojas)
		
							cFilAnt := Padr(aLojas[nXz],nTamFil)
						
							DbSelectArea("SBZ")
							DbSetOrder(1)
							IF DbSeek(xFilial("SBZ")+cProduto)
								RecLock("SBZ",.F.,.T.)
								DbDelete()
								MsUnLock()
							EndIF
							
						Next nXz
						cFilAnt := cFilAtu
						*/
						
					EndIF
				Next nColunas
		
			Next nLinhas
		//Else
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento para Produto SEM GRADE.                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProduto := Padr(M->B4_COD,TamSx3("B1_COD")[1])
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inclui / Altera Produto. 							   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF INCLUI .OR. ALTERA
		
			DbSelectArea('SB1')
			DbSetOrder(1)
			IF !DbSeek(xFilial("SB1") + cProduto)
			RecLock('SB1',.T.)
			B1_FILIAL 	:= xFilial('SB1')
			B1_COD 		:= cProduto
			B1_GRADE    := 'S' // Deve ser sim pois utiliza a SB4, dessa forma nao ocorrera problemas com o pedido de compra padrao
			B1_CUSTD	:= oGetGrade:aCols[nLinhas, nColunas]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Preco de Venda := Custo + IPI + Montagem + Embalagem + Frete + ST   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//B1_PRV1		:= oGetGrade:aCols[nLinhas, nColunas]+(oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100))+M->B4_01VLMON+M->B4_01VLEMB+M->B4_01VLFRE+M->B4_01ST
			nCustoIpi		:= oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100)
			nCustoFrete		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * (M->B4_01VLFRE/100)
			B1_PRV1			:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi+M->B4_01VLMON+M->B4_01VLEMB+nCustoFrete+M->B4_01ST) * M->B4_01MKP
			Else
			RecLock('SB1',.F.)
			EndIF
		
			For nX := 1 to Len(aCampos)
		
			IF aCampos[nX] $ '_FILIAL/_COD/_LINHA/_COLUNA' .Or. ( SB1->(FieldPos("B1" + aCampos[nX])) == 0 .And. !aCampos[nX] $ '_STATUS' )
			Loop
			Elseif aCampos[nX] $ '_MSBLQL'
			SB1->B1_MSBLQL	:= SB4->B4_MSBLQL //IIF( SB4->B4_STATUS == "I" , "1" , "2" )
			Else
			cCampo1 := 'B1' + aCampos[nX]
			cCampo2 := 'M->B4' + aCampos[nX]
			Replace &cCampo1 With &cCampo2
			EndIF
			Next nX
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria codigo de Barras padra EAN 13.			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF GetMv("MV_AUTCOBA",,.T.) .And. Empty(B1_CODBAR)
			SB1->B1_CODBAR	:= U_RetPCodBar()
			EndIF
		
			IF Empty(SB1->B1_CODANT)
			IF GetMv("MV_01CODANT",,.T.)
			SB1->B1_CODANT 	:= SubStr(SB1->B1_CODBAR,1,12)
			Else
			SB1->B1_CODANT 	:= ""
			EndIF
			EndIF
		
			SB1->B1_01PRODP	:= Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
			SB1->B1_01LNGRD	:= ""
			SB1->B1_01CLGRD	:= ""
			SB1->B1_01RFGRD	:= ""
			//SB1->B1_01DREF	:= ""
			SB1->B1_01CODFO	:= ""
			SB1->B1_01PACKS	:= ""
			SB1->B1_CUSTD	:= oGetGrade:aCols[nLinhas,nColunas]
			//SB1->B1_PRV1	:= oGetGrade:aCols[nLinhas,nColunas]+(oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100))+M->B4_01VLMON+M->B4_01VLEMB+M->B4_01VLFRE+M->B4_01ST
			nCustoIpi		:= oGetGrade:aCols[nLinhas,nColunas] * (M->B4_IPI/100)
			nCustoFrete		:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi) * (M->B4_01VLFRE/100)
			B1_PRV1			:= (oGetGrade:aCols[nLinhas,nColunas]+nCustoIpi+M->B4_01VLMON+M->B4_01VLEMB+nCustoFrete+M->B4_01ST) * M->B4_01MKP
			MsUnLock()
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazeno os precos dos produtos para atualizacao da tabela de preco.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AAdd( aPrecos , {SB1->B1_COD , SB1->B1_PRV1 } )
		
			Else
			SB1->( DbSetOrder(1) )
			IF SB1->( DbSeek( xFilial("SB1") + cProduto ) )
			a550Del(cProduto)
			EndIF
		
			SB0->( DbSetOrder(1) )
			IF SB0->( DbSeek( xFilial("SB0") + cProduto ) )
			RecLock("SB0",.F.)
			SB0->( DbDelete() )
			MsUnLock()
			EndIF
		
			DA1->( DbSetOrder(1) )
			IF DA1->( DbSeek( xFilial("DA1") + cTabPad + cProduto ) )
			RecLock("DA1",.F.,.T.)
			DA1->( DbDelete() )
			MsUnLock()
			EndIF
			EndIF
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ SIGAPAF - Responsavel em enviar os dados do produto para integracao. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//LJ110AltOk()
			*/
		EndIF
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza codigo de barras dos produtos. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ALTERA .And. lContinua
	For nLinhas := 1 to Len(oGetBarras:aCols)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o preenchimento do M2 do Tecido fornecido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "FORNECIDO" $ oGetBarras:aCols[nLinhas,3] .And. oGetBarras:aCols[nLinhas,nPosTecM2] = 0
			lOk := .T.
		Endif

		DbSelectArea("SB1")
		DbSetOrder(1)
		IF DbSeek(xFilial("SB1")+oGetBarras:aCols[nLinhas,1])
			RecLock("SB1",.F.)
			B1_CODBAR 	:= oGetBarras:aCols[nLinhas,nPosCodBar]
			B1_01TECM2 	:= oGetBarras:aCols[nLinhas,nPosTecM2]
			B1_CODANT   := oGetBarras:aCols[nLinhas,nPosCODIN]
			MsUnLock()
		EndIF
	Next nLinhas
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza as caracteristicas do produto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
IF nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 6
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VerIFica se e alteração ou inclusao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nX:= 1 To Len(oGetCaract:aCols)

IF Empty(oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_CODIGO"})])
Loop
EndIF

IF oGetCaract:aCols[nX][Len(oGetCaract:aHeader)+1]

AY5->( dbSetOrder(1) )
IF AY5->(dbSeek(xFilial("AY5") + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_CODIGO"})] + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_SEQ"})] + Padr(cProdPai,TamSX3('AY5_CODPRO')[1]) ) )
RecLock("AY5",.F.)
AY5->(dbDelete())
AY5->(MsUnLock())
AY5->( MsUnLock() )
Loop
EndIF

Else

AY5->( dbSetOrder(1) )
IF !AY5->(dbSeek(xFilial("AY5") + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_CODIGO"})] + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_SEQ"})] + Padr(cProdPai,TamSX3('AY5_CODPRO')[1]) ) )

RecLock("AY5",.T.)

AY5->AY5_FILIAL	:= xFilial("AY5")
AY5->AY5_CODPRO := cProdPai
For nY:= 1 To Len(oGetCaract:aHeader)
If !Alltrim(oGetCaract:aHeader[nY][2]) $ "AY5_STATEC/AY5_ENVECO/AY5_OPER"
AY5->(FieldPut(FieldPos(Alltrim(oGetCaract:aHeader[nY][2])),oGetCaract:aCols[nX][nY]))
EndIf
Next nY

AY5->( MsUnLock() )

IF AY5->(FieldPos("AY5_STATEC")) > 0 .AND. AY5->(FieldPos("AY5_ENVECO")) > 0 .AND. AY5->(FieldPos("AY5_OPER")) > 0
AY5->AY5_STATEC := "2"
AY5->AY5_ENVECO := "1"
AY5->AY5_OPER	:= "1"
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza AY3. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF AY3->(FieldPos("AY3_STATEC")) > 0 .AND. AY3->(FieldPos("AY3_ENVECO")) > 0 .AND. AY3->(FieldPos("AY3_OPER")) > 0
UpdAy3(oGetCaract:aCols[nX][nPosCar])
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza AY3. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF AY4->(FieldPos("AY4_STATEC")) > 0 .AND. AY4->(FieldPos("AY4_ENVECO")) > 0 .AND. AY4->(FieldPos("AY4_OPER")) > 0
UpdAy4(oGetCaract:aCols[nX][nPosCar],oGetCaract:aCols[nX][nPosSeq] )
EndIF
EndIF

EndIF

Next nX

ElseIf nOpc== 5
For nX:= 1 To Len(oGetCaract:aCols)
AY5->( dbSetOrder(1) )
If AY5->(dbSeek(xFilial("AY5") + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_CODIGO"})] + oGetCaract:aCols[nX][Ascan(oGetCaract:aHeader,{|x| AllTrim(Upper(x[2])) == "AY5_SEQ"})] + cProdPai ) )
RecLock("AY5",.F.,.T.)
AY5->(dbDelete())
AY5->(MsUnLock())
EndIf
Next nX
EndIf
*/
IF ALTERA .And. lContinua
	For nLinhas := 1 to Len(oGetMedida:aCols)   

		IF nTamRef > 0
			nCodRef := aScan(aRef, {|x| x[1] == AllTrim(oGetMedida:aCols[nLinhas,nPosRef])})
			IF  nCodRef == 0
				aAdd(aRef, {AllTrim(oGetMedida:aCols[nLinhas,nPosRef]), IIF(EMPTY(aRef),StrZero(1,nTamRef),SOMA1(aRef[Len(aRef),2],2)) })
			EndIF
		EndIF

		For nColunas := 5 to Len(oGetMedida:aHeader)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ verIFica se esta com X e se a linha na esta deletada   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF oGetMedida:aCols[nLinhas, nColunas] > 0

				cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
				cProduto += SubStr(oGetMedida:aCols[nLinhas,nPosLin],1,nTamLin)
				cProduto += Substr(oGetMedida:aHeader[nColunas][2],2,nTamCol)
				IF nTamRef > 0
					cProduto += IIF(nCodRef<>0,aRef[nCodRef,2],aRef[Len(aRef),2])
				EndIF
				cProduto := Padr(cProduto,TamSx3("B1_COD")[1])

				DbSelectArea('SB1')
				DbSetOrder(1)
				IF DbSeek(xFilial("SB1") + cProduto)
					RecLock('SB1',.F.)
					B1_01VLRME := oGetMedida:aCols[nLinhas,nColunas]
					MsUnLock()
				EndIF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza preço dos produtos - #Ellen 2.03.2018 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*
				IF DbSeek(xFilial("SB1") + oGetBarras:aCols[nLinhas][nPosMacod])
					If oGetBarras:aCols[nLinhas][nPosprcven] > 0 
						RecLock('SB1',.F.)
						SB1->B1_PRV1 := oGetBarras:aCols[nLinhas][nPosprcven] 
						MsUnLock()
					EndIF
				Endif
				*/
			EndIF

		Next nColunas

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o preco do metro quadrado.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cProduto := Padr(Substr(M->B4_COD,1,nTamPai),TamSx3("B1_01PRODP")[1])
		IF nTamRef > 0
			cProduto += Padr(IIF(nCodRef<>0,aRef[nCodRef,2],aRef[Len(aRef),2]),TamSx3("B1_01RFGRD")[1])
		EndIF
		cProduto += Padr(SubStr(oGetMedida:aCols[nLinhas,nPosLin],1,nTamLin),TamSx3("B1_01LNGRD")[1])

		DbSelectArea('SB1')
		DbSetOrder(11)
		IF DbSeek(xFilial("SB1") + cProduto)
			If oGetMedida:aCols[nLinhas,nPosPrcM2] > 0 
				RecLock('SB1',.F.)
				B1_01VLRM2 := oGetMedida:aCols[nLinhas,nPosPrcM2]
				MsUnLock()
			EndIF
		EndIF

	Next nLinhas
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza tabela de precos se o produto for de e-commerce ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// SEM E-COOMERCE POR ENQUANTO - #Ellen
/*
IF nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 6
	LjMsgRun("Por favor aguarde, atualizando tabela de preço...",, {|| U_MA06AtuTab(cTabPad,aPrecos) })
Endif
*/

IF ( nOpc == 3 .Or. nOpc == 4 ) .And. lContinua
	LjMsgRun("Por favor aguarde, atualizando tabela de preço...",, {|| U_MA06AtuTab(aPrecos) })
Endif

If lOk
	Aviso(STR0028,"Por favor, preencher a metragem do tecido fornecido.",{"Ok"})
Endif

If !lContinua
	Aviso(STR0028,"Não existe tabela de preço para esse fornecedor, favor providenciar cadastro.",{"Ok"})
Else
	
Endif

//If SB4->(FieldPos("B4_USAECO")) > 0
//	If nOpc == 4 .And. SB4->B4_USAECO == '1'
//		u_SYATUTAB(SubStr(cProduto,1,nTamPai),SB4->B4_PRV1)
//	EndIf
//Endif

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ma06Lgd  ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Legenda.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Ma06Lgd()

Local  aLegenda := {}

aAdd( aLegenda, { "BR_VERDE" 	, STR0032 } ) // "Ativo"
aAdd( aLegenda, { "BR_VERMELHO"	, STR0033 } ) // "Inativo"

BrwLegenda(cCadastro,STR0034,aLegenda) // "Legenda"

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA06TudOk ³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA06TudOk()
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  MAVDREF ³ Autor ³    Alexandro Dias     ³ Data ³ 04/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a referencia do produto.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAVDREF()

Local lRet		:= .T.
Local nPosRef	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local nPosPack	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAPACK"})
Local nPosForn	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACODFOR"})
Local nPosCodRef:= Ascan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[oGetGrade:nAt,nPosRef])})
Local nPosCarac
Local cChave
Local nX

IF !INCLUI
	cChave := PADR(M->B4_COD,TAMSX3("B1_01PRODP")[1])
	cChave += PADR(oGetGrade:aCols[oGetGrade:nAt][nPosLin],TAMSX3("B1_01LNGRD")[1])
	IF nPosCodRef > 0
		cChave += AllTrim(aRef[nPosCodRef,2])
	EndIF

	SB1->(DbOrderNickName("SYMMSB101"))
	IF SB1->(dbSeek(xFilial("SB1")+cChave))
		MsgAlert(STR0035) // "Não é possivel a alteração de cor e referência de produto cadastrado anteriormente."
		lRet := .F.
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Replicacoes dos campos da penultima linha para a proxima. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRet .AND. oGetGrade:nAt<>1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica caracteristicas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aCaract)
		nPosCarac := Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == AllTrim(Upper(aCaract[nX])) })
		IF nPosCarac > 0
			oGetGrade:aCols[oGetGrade:nAt][nPosCarac] := oGetGrade:aCols[oGetGrade:nAt-1][nPosCarac]
		EndIF
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica campo Cod.Fornecedor. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !GetMv("MV_01CODFO",,.F.)
		oGetGrade:aCols[oGetGrade:nAt][nPosForn] := oGetGrade:aCols[oGetGrade:nAt-1][nPosForn]
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica campo Pack. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetGrade:aCols[oGetGrade:nAt][nPosPack] := oGetGrade:aCols[oGetGrade:nAt-1][nPosPack]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica tamanhos marcados. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=nCol_Tam to Len(oGetGrade:aHeader)
		oGetGrade:aCols[oGetGrade:nAt][nX] := oGetGrade:aCols[oGetGrade:nAt-1][nX]
	Next nX
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA06VLDCOR³ Autor ³    Alexandro Dias     ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a cor do produto.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAVDCOR1(nTipo)

Local lRet		:= .T.
Local nPosRef	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local nPosDescri:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'MADES'})
Local nPosGrpCor:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == 'MAGRPCOR'})
Local nPosPack	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAPACK"})
Local nPosForn	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACODFOR"})
Local nPosCodRef:= aScan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[oGetGrade:nAt,nPosRef])})
Local nPosCarac
Local cChave
Local nX

IF !INCLUI
	cChave := PADR(M->B4_COD,TAMSX3("B1_01PRODP")[1])
	cChave += PADR(oGetGrade:aCols[oGetGrade:nAt][nPosLin],TAMSX3("B1_01LNGRD")[1])
	IF nPosCodRef > 0
		cChave += AllTrim(aRef[nPosCodRef,2])
	EndIF

	SB1->(DbOrderNickName("SYMMSB101"))
	IF SB1->(dbSeek(xFilial("SB1")+cChave)) .And. !Empty(oGetGrade:aCols[oGetGrade:nAt,nPosLin])
		MsgAlert(STR0035) // "Não é possivel a alteração de cor e referência de produto cadastrado anteriormente."
		lRet := .F.
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao permite digitar a mesma cor para a mesma referencia 2 x no aCols. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRet
	nPos := Ascan( oGetGrade:aCols , {|x| x[nPosRef]+AllTrim(x[nPosLin]) == oGetGrade:aCols[oGetGrade:nAt][nPosRef]+AllTrim(M->MACOR) } )
	IF ( nPos > 0 .And. ( nPos != oGetGrade:nAt) )
		MsgAlert(STR0036) // "Cor já está cadastrada para está referência."
		lRet := .F.
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAR BLOQUEIO DE GRADES DE COR QUE ESTEJAM BLOQUEADAS - LUIZ EDUARDO F.C. - 04.12.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
IF lRet
	lRet := ExistCpo('SBV',M->B4_LINHA+M->MACOR,1)
	IF lRet                                                                                                              
		IF Posicione('SBV',1,xFilial('SBV')+M->B4_LINHA+M->MACOR,'BV_01BLOQ') == "1"
			lRet := .F.
			MsgAlert("Tecido Bloqueado na Grade. Não é possivel criar produto utilizando o mesmo!!!")		
		Else	
			oGetGrade:aCols[oGetGrade:nAt,nPosDescri] := Posicione('SBV',1,xFilial('SBV')+M->B4_LINHA+M->MACOR,'BV_DESCRI')
			IF nPosGrpCor > 0
				oGetGrade:aCols[oGetGrade:nAt,nPosGrpCor] := Posicione('SBV',1,xFilial('SBV')+M->B4_LINHA+M->MACOR,'BV_01DESGR')
			EndIF
		EndIF
	EndIF
EndIF

/* TRECHO ANTIGO DO PROGRAMA ANTES DA CUSTOMIZACAO ACIMA
IF lRet
	lRet := ExistCpo('SBV',M->B4_LINHA+M->MACOR,1)
	IF lRet
		oGetGrade:aCols[oGetGrade:nAt,nPosDescri] := Posicione('SBV',1,xFilial('SBV')+M->B4_LINHA+M->MACOR,'BV_DESCRI')
		IF nPosGrpCor > 0
			oGetGrade:aCols[oGetGrade:nAt,nPosGrpCor] := Posicione('SBV',1,xFilial('SBV')+M->B4_LINHA+M->MACOR,'BV_01DESGR')
		EndIF
	EndIF
EndIF
*/    



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Replicacoes dos campos da penultima linha para a proxima. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRet .AND. oGetGrade:nAt<>1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica caracteristicas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aCaract)
		nPosCarac := Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == AllTrim(Upper(aCaract[nX])) })
		IF nPosCarac > 0
			oGetGrade:aCols[oGetGrade:nAt][nPosCarac] := oGetGrade:aCols[oGetGrade:nAt-1][nPosCarac]
		EndIF
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica campo Cod.Fornecedor. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !GetMv("MV_01CODFO",,.F.)
		oGetGrade:aCols[oGetGrade:nAt][nPosForn] := oGetGrade:aCols[oGetGrade:nAt-1][nPosForn]
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica campo Pack. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetGrade:aCols[oGetGrade:nAt][nPosPack] := oGetGrade:aCols[oGetGrade:nAt-1][nPosPack]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Replica tamanhos marcados. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=nCol_Tam to Len(oGetGrade:aHeader)
		oGetGrade:aCols[oGetGrade:nAt][nX] := oGetGrade:aCols[oGetGrade:nAt-1][nX]
	Next nX
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MAVLDBAR ³ Autor ³ Alexandro Dias        ³ Data ³ 28/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida codigo de barras.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAVLDBAR()

Local lRet 		:= .T.
Local nPos		:= 0
Local lVldEan	:= GetMv("MV_B4VLEAN",,.F.)
Local nPosCodBar:= aScan(aHeaderBar,{|x| Alltrim(x[2]) == "MABAR"	})

IF !Empty(Alltrim(M->MABAR))

	IF lVldEan
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida codigo de barras via EAN13.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Len(Alltrim(M->MABAR)) == 12
			M->MABAR := Alltrim(M->MABAR) + EanDigito(M->MABAR)
		EndIF

		lRet := ( Alltrim(M->MABAR) == Alltrim( Left(M->MABAR,12) + EanDigito(Left(M->MABAR,12)) ) )
		IF !lRet
			MsgAlert(STR0037) // "Digito Verificador inválido. Código de Barras Incorreto."
		EndIF

	EndIF

	IF lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida existencia do codigo de barras em todos cadastros. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := LjxValCBar( oGetBarras:aCols[oGetBarras:nAt,1] , M->MABAR )
	EndIF

	IF lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao permite digitar codigo de barras 2 x no aCols.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPos := Ascan( oGetBarras:aCols , {|x| Alltrim(x[nPosCodBar]) == Alltrim(M->MABAR) } )
		IF ( nPos > 0 .And. ( nPos != oGetBarras:nAt) )
			MsgAlert(STR0038) // "Código de Barras já Cadastrado."
			lRet := .F.
		EndIF
    EndIF

EndIF

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetPCodBarºAutor  ³Mauro Paladini      º Data ³  05/27/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna proxima sequencia de codigo de barras nao sequencialº±±
±±º          ³disponivel                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RetPCodBar()

Local aAreaAtu 	:= GetArea()
Local cCodPai	:= Padr(AllTrim(M->B4_COD),nTamPai)
Local cQuery 	:= ""
Local cProxNum	:= StrZero(0,12-nTamPai)
Local cCodBarra	:= ""

//Alterado por Allan pois estava com erro quando o Pai possui mais que 12 caracteres
IF nTamPai < 12
	cQuery := " SELECT MAX(SUBSTRING(SB1.B1_CODBAR,"+StrZero(nTamPai+1,2)+","+StrZero(12-nTamPai,2)+")) AS ULTCOD "+CRLF
	cQuery += " FROM "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery += " WHERE "+CRLF
	cQuery += " 	SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery += " 	AND SB1.B1_01PRODP = '"+cCodPai+"' "+CRLF
	cQuery += " 	AND SB1.D_E_L_E_T_ = '' "+CRLF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa Query gerada  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSB1",.T.,.T.)

	While TMPSB1->(!EOF())
		cProxNum := SOMA1(TMPSB1->ULTCOD)

		TMPSB1->(dbSkip())
	EndDo

	TMPSB1->(dbCloseArea())

	cCodBarra 	:= cCodPai+cProxNum
	cCodBarra 	+= EanDigito(cCodBarra)
Else
	cCodBarra 	:= Space(12)
EndIF

RestArea(aAreaAtu)

Return cCodBarra

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SyA550Valid³ Autor ³   Alexandro Dias    ³ Data ³ 24/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Grade de Produtos                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SyA550Valid()

Local aArea		:= GetArea()
Local cConteudo	:= &(ReadVar())
Local cVar		:= ReadVar()
Local nPosRef	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local lRet		:= .T.
Local cProduto	:= ''
Local i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na Coluna Correta ³
//³ para verIFicar conteudo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := nCol_Tam to Len(oGetGrade:aHeader)
	IF Alltrim(oGetGrade:aHeader[i][2]) == Alltrim(Substr(ReadVar(),4) )
		Exit
	EndIF
Next i

IF cConteudo > 0 				//.And. !(cConteudo $ 'X')
	aCols[n][i]	:= cConteudo 	//'X'
	&cVar		:= cConteudo 	//'X'
EndIF

IF !Inclui

	IF oGetGrade:aCols[oGetGrade:nAt,i] > 0 .And. (cConteudo == 0 )

		cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
		cProduto += Substr(oGetGrade:aCols[oGetGrade:nAt,nPosLin],1,nTamLin)
		cProduto += Substr(oGetGrade:aHeader[oGetGrade:oBrowse:ColPos,2],2,nTamCol)

        IF nTamRef > 0
			nCodRef:= aScan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[oGetGrade:nAt,nPosRef])})
			IF (nCodRef > 0)
				cProduto += AllTrim(aRef[nCodRef,2])
			EndIF
    	EndIF

		cProduto := Padr(cProduto,TamSx3("B1_COD")[1])

		SB1->(DbSetOrder(1))
		IF SB1->( DbSeek(xFilial('SB1')+cProduto) )
			lRet := a006Prod(cProduto) .AND. IIF(lVA006Exc,ExecBlock("VA006Exc",.F.,.F.,{1,cProduto}),.T.)
			If lRet
				If SB1->(FieldPos("B1_ENVECO")) > 0 .AND. SB1->(FieldPos("B1_STATECO")) > 0
					If SB1->B1_ENVECO == "2" .And. SB1->B1_STATECO == "1"
						Help("",1,"NODELETA",,"Produto integrado ao e-Commerce.",2,0 ) // "NODELETA" # "Produto integrado ao e-Commerce."
						lRet := .F.
					Endif
				EndIf
			EndIf
			IF lRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena os produtos que devem ser excluidos apos a confirmacao³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Aadd(aDeleta,cProduto)
			EndIF
		EndIF
	EndIF
EndIF

RestArea(aArea)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³COMA06DEL	³ Autor ³ Totvs - Microsiga     ³ Data ³ 03/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratameto de exclusao dos pack's 		      			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function COMA06DEL()

Local aAreaSM0 	:= SM0->(GetArea())
Local cFilAtu 	:= cFilAnt
Local cProduto	:= ""
Local nLinhas	:= 0
Local nColunas	:= 0
Local lRet      := .F.
Local nTamFil	:= Len(cFilAnt)
Local aLojas	:= {}
Local aDeleAux  := {}
Local nPosRef	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MAREF"})
Local nPosLin	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == "MACOR"})
Local nX, nY

If lVA006Exc
	If !ExecBlock("VA006Exc",.F.,.F.,{2,M->B4_COD})
		Return
	EndIf
EndIf

SM0->(DbSeek(cEmpAnt))
While SM0->(!EOF()) .AND. SM0->M0_CODIGO == cEmpAnt
	Aadd(aLojas,AllTrim(SM0->M0_CODFIL))
	SM0->(DbSkip())
EndDo
SM0->(RestArea(aAreaSM0))

IF (M->B4_01UTGRD == "S") //Usa Grade
	For nLinhas := 1 to Len(oGetGrade:aCols)

		For nColunas := nCol_Tam to Len(oGetGrade:aHeader)

			IF oGetGrade:aCols[nLinhas][nColunas] > 0

				cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)
				cProduto += SubStr(oGetGrade:aCols[nLinhas,nPosLin],1,nTamLin)
				cProduto += Substr(oGetGrade:aHeader[nColunas,2],2,nTamCol)

				IF nTamRef > 0
					nCodRef:= aScan(aRef, {|x| x[1] == AllTrim(oGetGrade:aCols[nLinhas,nPosRef])})
					IF (nCodRef > 0)
						cProduto += AllTrim(aRef[nCodRef,2])
					EndIF
				EndIF

				cProduto := Padr(cProduto,TamSx3("B1_COD")[1])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ verIFica se algum produto nao pode ser deletado        ³
				//³ por estar sendo usado em outro arquivo do sistema      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet := a006Prod(cProduto)

				IF !lRet
					Exit
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Armazena os produtos que serao deletados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aDeleAux,cProduto)
				EndIF

			EndIF

		Next nColunas

		IF !lRet
			Exit
		EndIF

	Next nLinhas
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena o produto sem grade que serao deletados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProduto := Padr(Substr(M->B4_COD,1,nTamPai),nTamPai)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ verIFica se algum produto nao pode ser deletado        ³
	//³ por estar sendo usado em outro arquivo do sistema      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := a006Prod(cProduto)

	IF lRet
		AADD(aDeleAux,cProduto)
	EndIF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se todos os produtos desta referencia podem ser        ³
//³ deletados, entao sera apagado os registros do arquivo  ³
//³ SB1(Cadastro de Produtos) e SB4(Cadastro de Referencias³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRet
	BEGIN TRANSACTION
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valdia se Template de e-Commerce foi implantado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SB4->( FieldPos("B4_USAECO")) > 0 .AND. SB4->(FieldPos("B4_ECONOME")) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se Produto já foi integrado ao e-Commerce.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MsgRun("Aguarde... Validando produto no e-Commerce.",,{ || lVldEco := u_SyLisPrdEc(	SB4->B4_COD,SB4->B4_01CODMA,; // "Aguarde... Validando produto no e-Commerce."
																									SB4->B4_ECONOME,SB4->B4_STATUS,;
																									SB4->B4_TIPOPRO) })
			If lVldEco
				If !u_SyDelPrdEc(SB4->B4_COD)
					Help("",1,STR0042,,STR0043 + Alltrim(M->B4_COD) + STR0044 + CRLF + STR0045 ,1, 1 ) // "Atenção" # "Este produto [" # "] não poderá ser deletado." # " Problema ao deletar produto no e-Commerce."
					Return
				EndIf
			Endif

		EndIf

		DbSelectArea("SB4")
		RecLock("SB4",.F.,.T.)
		DbDelete()
		For nX := 1 To Len(aLojas)
			For nY := 1 to Len(aDeleAux)

				cFilAnt := Padr(aLojas[nX],nTamFil)

				DbSelectArea("SB1")
				IF DbSeek(xFilial("SB1")+aDeleAux[nY])
					RecLock("SB1",.F.,.T.)
					DbDelete()
					MsUnLock()
				EndIF

				DbSelectArea("SB0")
				DbSetOrder(1)
				IF DbSeek(xFilial("SB0")+aDeleAux[nY])
					RecLock("SB0",.F.,.T.)
					DbDelete()
					MsUnLock()
				EndIF
/*
#WRP20180813.BO
				DA1->( DbSetOrder(1) )
				IF DA1->( DbSeek( xFilial("DA1") + cTabPad + cProduto ) )
					RecLock("DA1",.F.,.T.)
					DA1->( DbDelete() )
					MsUnLock()
				EndIF
#WRP20180813.BE
*/			
				DbSelectArea("SB5")
				DbSetOrder(1)
				IF DbSeek(xFilial("SB5")+aDeleAux[nY])
					RecLock("SB5",.F.,.T.)
					DbDelete()
					MsUnLock()
				EndIF
				
				DbSelectArea("SBZ")
				DbSetOrder(1)
				IF DbSeek(xFilial("SBZ")+aDeleAux[nY])
					RecLock("SBZ",.F.,.T.)
					DbDelete()
					MsUnLock()
				EndIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SIGAPAF - Responsavel em enviar os dados do produto para integracao. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//LJ110AltOk()
			Next nY
		Next nX
		MsUnLock()

	END TRANSACTION
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna para filial logada. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cFilAtu

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VldCaracteristica ³ Autor ³ Eduardo Patriani	     ³ Data ³26.01.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida os fornecedores do contrato                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VldCaracteristica()

Local nI
Local lRepetido 	:= .F.
Local lRet 			:= .T.
Local nPosCaract 	:= Ascan( aHeaderCar, {|x| AllTrim(x[2])  == "AY5_CODIGO"})
Local nPosSequen 	:= Ascan( aHeaderCar, {|x| AllTrim(x[2])  == "AY5_SEQ"})
Local nPos 			:= oGetCaract:nAt
Local nX			:= 0

IF nPos > 0 .And. nPosCaract > 0 .And. nPosSequen > 0

	IF !Empty(oGetCaract:aCols[nPos,nPosCaract]) .And. !Empty(oGetCaract:aCols[nPos,nPosSequen])

		IF lRet .And. Len( oGetCaract:aCols ) > 1 .And. !oGetCaract:aCols[nPos][len( aHeaderCar ) + 1]

			For nI := 1 To Len( oGetCaract:aCols )
				IF ( nI != nPos ) .and. !oGetCaract:aCols[nI][len( aHeaderCar ) + 1]
					IF oGetCaract:aCols[nI,nPosCaract] == oGetCaract:aCols[nPos,nPosCaract] .And. oGetCaract:aCols[nI,nPosSequen] == oGetCaract:aCols[nPos,nPosSequen]
						lRepetido := .T.
						Exit
					EndIF
				EndIF
			Next nI

			IF lRepetido
				lRet:=.F.
				Help("",1,"JAGRAVADO")
			End
		EndIF
	EndIF
EndIF

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CriaGrpCor ³ Autor³ Eduardo Patriani	    ³ Data ³26.01.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cria a tabela de grupo de cores padroes.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaGrpCor(cGrpCor)

Local aArea := GetArea()
Local nX	:= 0
Local aCores:= {	STR0047,; // "BRANCO"
					STR0048,; // "PRETO"
					STR0049,; // "AMARELO"
					STR0050,; // "VERMELHO"
					STR0051	} // "AZUL"

DEFAULT cGrpCor	:= GetMv('MV_GRPCOR',,'00')

DbSelectArea('SBV')
DbOrderNickName('SYMMSBV03')
IF !DbSeek(xFilial('SBV')+cGrpCor)
	For nX := 1 To Len(aCores)
		RecLock('SBV',.T.)
		BV_FILIAL 	:= xFilial('SBV')
		BV_TABELA 	:= cGrpCor
		BV_DESCTAB	:= STR0046 // "Grupo Cores Padroes"
		BV_CHAVE	:= StrZero(nX,nTamLin)
		BV_DESCRI	:= aCores[nX]
		BV_TIPO		:= '1'
		BV_01SEQ	:= StrZero(nX,2)
		MsUnLock()
	Next
EndIF

RestArea(aArea)

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RETCARAC ºAutor  ³ SYMM Consultoria   º Data ³  26/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna caracteristica ativa para a filtragem da consulta. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SYVA006                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RETCARAC()

Local cCampo	:= ReadVar()

IF SubStr(cCampo,4,2) == "C_"
	cConsultas := SubStr(cCampo,6,TAMSX3("AY3_CODIGO")[1])
EndIF

Return cConsultas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CaractSKU ºAutor  ³ SYMM Consultoria   º Data ³  26/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava as caracteristicas.                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CaractSKU(cProdPai,cCodRef,cCodLin,cCodCaract,cConteudo,nOpc, nX, nPosOper)

DbSelectArea("AY5")
DbSetOrder(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza as caracteristicas do produto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF nOpc == 3 .Or. nOpc == 4

	IF !Empty(cCodRef)

		IF AY5->(dbSeek(xFilial("AY5")+cCodCaract+cProdPai+cCodRef+cCodLin))
			lAppend := .F.
		Else
			lAppend := .T.
		EndIF

		IF lAppend .AND. Empty(cConteudo)
			Return .F.
		EndIF

		RecLock("AY5",lAppend)
			AY5->AY5_FILIAL	:= xFilial("AY5")
			AY5->AY5_CODPRO	:= cProdPai
			AY5->AY5_REFGRD	:= cCodRef
			AY5->AY5_LINGRD	:= cCodLin
			AY5->AY5_CODIGO	:= cCodCaract
			AY5->AY5_SEQ 	:= cConteudo

			IF AY5->(FieldPos("AY5_STATEC")) > 0 .AND. AY5->(FieldPos("AY5_ENVECO")) > 0 .AND. nPosOper > 0
				AY5->AY5_STATEC := "2"
				AY5->AY5_ENVECO := "1"
				AY5->AY5_OPER	:= Iif(Empty(oGetCaract:aCols[nX][nPosOper]),"1",Iif(nOpc == 3,"1","2") )
			EndIF

		AY5->( MsUnLock() )
	EndIF

ElseIF nOpc== 5
	IF AY5->(dbSeek(xFilial("AY5")+cCodCaract+cProdPai+cCodRef+cCodLin))
		RecLock("AY5",.F.)
		AY5->(dbDelete())
		AY5->(MsUnLock())
	EndIF
EndIF

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SY550VerIF³ Autor ³ Rosane L. Chene       ³ Data ³ 07/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao na alteracao, caso o usuario troque o numero     ³±±
±±³          ³ da tabela que indica linha ou coluna, verIFica se ja nao   ³±±
±±³          ³ existe movimentacoes com a tabela antiga                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SY550VerIF()

Local aArea		:= GetArea()
Local cProduto	:=""
Local aColunas	:={}
Local lRet    	:=.T.
Local i		  	:=0

Local cReadVar:= ReadVar()

IF cReadVar == "M->B4_LINHA"
	cTipo := "1"
ElseIF cReadVar == "M->B4_COLUNA"
	cTipo := "2"
Else
	cTipo := " "
EndIF

IF ! A551VldTab(&cReadVar, cTipo)
	RestArea(aArea)
	Return(.F.)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta funcao so e' valida no caso de alteracao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Altera
	dbSelectArea("SB4")
	dbSetOrder(1)
	IF dbSeek(xFilial("SB4")+M->B4_COD)

		dbSelectArea("SBV")
		dbSetOrder(1)
		dbSeek(xFilial("SBV")+SB4->B4_COLUNA)
		aColunas:={}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazena todas as colunas no array,do codigo da tabela  ³
		//³ referente a coluna que ja esta gravado                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !EOF() .And. (bv_tabela == SB4->B4_COLUNA)
			AADD(aColunas,Substr(bv_chave,1,nTamCol))
			dbSkip()
		End

		For i:=1 to Len(aColunas)
			dbSelectArea("SBV")
			dbSeek(xFilial("SBV")+SB4->B4_LINHA)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ VerIFica se o produto (referencia + coluna +linha) ja   ³
			//³ foi movimentado,se positivo nao deixa alterar o codigo  ³
			//³ da tabela ou da coluna                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While SBV->(!EOF()) .And. (SBV->BV_TABELA == SB4->B4_LINHA)

				IF nTamRef > 0
					cProduto := Substr(SB4->B4_COD,1,nTamRef) +Substr(SBV->BV_CHAVE,1,nTamLin)+ aColunas[i]
				Else
					cProduto := Substr(SBV->BV_CHAVE,1,nTamLin)+ aColunas[i]
				EndIF

				cProduto := cProduto + Space(nTamCod - Len(cProduto) )
				lRet     := a006Prod(cProduto)

				IF !lRet
					Exit
				Else
					IF Type("aProdDel") <> "U"
						IF ( M->B4_LINHA <> SB4->B4_LINHA ) .Or. ( M->B4_COLUNA <> SB4->B4_COLUNA )
							IF Ascan(aProdDel,cProduto) == 0
								AADD(aProdDel,cProduto)
							EndIF
						EndIF
					EndIF
				EndIF
				SBV->(dbSkip())
			End
			IF !lRet
				Exit
			EndIF
		Next
	EndIF
EndIF

IF !lRet .And. ( Type("aProdDel") <> "U" .And. Len( aProdDel ) > 0 )
	aProdDel := {}
EndIF

RestArea(aArea)

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UpdAy3 	ºAutor  ³Bernard M. Margaridoº Data ³  10/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza tabela de caracteristicas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UpdAy3(cCodCar)

Local aAreaAy3	:= GetArea()

AY3->( dbSetOrder(1) )
If AY3->( dbSeek(xFilial("AY3") + cCodCar) )
	RecLock("AY3",.F.)
	AY3->AY3_ENVECO	:= "1"
	AY3->AY3_OPER	:= Iif(AY3->AY3_STATEC == "2","1","2")
	AY3->AY3_STATEC	:= "2"
	AY3->( MsUnLock() )
Endif

RestArea(aAreaAy3)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UpdAy3 	ºAutor  ³Bernard M. Margaridoº Data ³  10/25/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza tabela de caracteristicas                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UpdAy4(cCodCar,cSeq)

Local aAreaAy4	:= GetArea()

AY4->( dbSetOrder(1) )
If AY4->( dbSeek(xFilial("AY4") + cCodCar + cSeq) )
	RecLock("AY4",.F.)
	AY4->AY4_ENVECO	:= "1"
	AY4->AY4_OPER	:= Iif(AY4->AY4_STATEC == "2","1","2")
	AY4->AY4_STATEC	:= "2"
	AY4->( MsUnLock() )
Endif

RestArea(aAreaAy4)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValCodProdºAutor  ³ SYMM Consultoria   º Data ³  24/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se codigo existe em alguma das filiais            º±±
±±º		     ³ independente do compartilhamento da tabela SB4.            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValCodProd(cProdPai)

Local lRet	 := .F.
Local cQuery := ""
Local cAlias := CriaTrab(,.F.)

cQuery := " SELECT COUNT(1) NUMREG "+ CRLF
cQuery += " FROM "+RetSqlName("SB4")+" SB4 "+ CRLF
cQuery += " WHERE "+ CRLF
cQuery += " 	SB4.B4_COD = '"+cProdPai+"' "+ CRLF
cQuery += " 	AND SB4.D_E_L_E_T_ <> '*' "+ CRLF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa Query gerada  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

If (cAlias)->(!EOF()) .AND. (cAlias)->NUMREG > 0
	lRet := .T.
EndIf

(cAlias)->(dbCloseArea())

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³SYMM Consultoria    º Data ³  18/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Botoes no menu do browse.                                   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MenuDef()

Private aRotina := {}

AADD( aRotina, {STR0052,"AxPesqui"  				,0,01}) // "Pesquisar"
AADD( aRotina, {STR0053,"U_COMA06MTA"				,0,02}) // "Visualizar"
AADD( aRotina, {STR0054,"U_COMA06MTA"				,0,03}) // "Incluir"
AADD( aRotina, {STR0055,"U_COMA06MTA"				,0,04}) // "Alterar"
AADD( aRotina, {STR0056,"U_COMA06MTA"				,0,05}) // "Excluir"
AADD( aRotina, {STR0057,"U_COMA06MTA"				,0,06}) // "Copiar"
//AADD( aRotina, {STR0058,"U_SYVA140(SB4->B4_COD)"	,0,06}) // "Manutenção de Preços"
AADD( aRotina, {STR0059,"U_SYVC003(SB4->B4_COD)"	,0,07}) // "Movimentação de Produto"
AADD( aRotina, {STR0060,"U_SYTM006A(SB4->B4_COD)"	,0,08}) // "Manutenção de Fotos"
AADD( aRotina, {STR0061,"U_SYTM006B()"				,0,09}) // "Painel de Fotos"

AADD( aRotina, {STR0062,"U_Ma06Lgd"					,0,10}) // "Legenda"

AADD( aRotina, {"Reajuste de Preços","U_CAREC001"					,0,10}) // "Legenda"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE utilizado para inserir novas opcoes no array aRotina. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("VA006MNU")
	ExecBlock("VA006MNU",.F.,.F.)
EndIf

Return aRotina

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuTabPad  ºAutor  ³ SYMM				    º Data ³ 11/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizacao da tabela de preco padrao.               		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA06AtuTab(aPrecos)

Local cItem := ''
Local nX

dbSelectArea("SA2")
SA2->(DbSetOrder(1))	
If SA2->(DbSeek(xFilial("SA2") + M->B4_PROC + M->B4_LOJPROC ))
	
	For nX := 1 To Len(aPrecos)
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1") + aPrecos[nX,1]))
	
		dbSelectArea("DA1")
		dbSetOrder(1)
		If !DA1->(dbSeek(xFilial("DA1")+SA2->A2_XTABELA+PADR(SB1->B1_COD,TAMSX3("DA1_CODPRO")[1])))
	
			cItem := UltmItem(SA2->A2_XTABELA,xFilial("DA1"))
			cItem := Soma1(cItem)
	
			RecLock("DA1", .T.)
			Replace DA1_FILIAL  With xFilial("DA1")
			Replace DA1_ITEM	With cItem
			Replace DA1_CODTAB  With SA2->A2_XTABELA
			Replace DA1_CODPRO	With SB1->B1_COD
			Replace DA1_REFGRD	With SB1->B1_01PRODP
//			Replace DA1_PRCVEN	With aPrecos[nX,2] // Regra nao definida para calculo do preco
//			Replace DA1_GRUPO	With SB1->B1_GRUPO //#AFD20180601
			Replace DA1_PERDES	With 1
			Replace DA1_QTDLOT	With 999999.99
			Replace DA1_ATIVO	With "1"
			Replace DA1_TPOPER	With "4"
			Replace DA1_MOEDA	With 1
			Replace DA1_DATVIG	With dDatabase
		Endif
		MsUnLock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta tambem a tabela principal        ³
		//³___________________________________________³
		If !DA1->(dbSeek(xFilial("DA1")+'001'+PADR(SB1->B1_COD,TAMSX3("DA1_CODPRO")[1])))
	
			cItem := UltmItem('001',xFilial("DA1"))
			cItem := Soma1(cItem)
	
			RecLock("DA1", .T.)
			Replace DA1_FILIAL  With xFilial("DA1")
			Replace DA1_ITEM	With cItem
			Replace DA1_CODTAB  With '001'
			Replace DA1_CODPRO	With SB1->B1_COD
			Replace DA1_REFGRD	With SB1->B1_01PRODP
//			Replace DA1_PRCVEN	With aPrecos[nX,2] // Regra nao definida para calculo do preco
//			Replace DA1_GRUPO	With SB1->B1_GRUPO //#AFD20180601
			Replace DA1_PERDES	With 1
			Replace DA1_QTDLOT	With 999999.99
			Replace DA1_ATIVO	With "1"
			Replace DA1_TPOPER	With "4"
			Replace DA1_MOEDA	With 1
			Replace DA1_DATVIG	With dDatabase
		Endif
		MsUnLock()
	
	Next nX
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UltmItem   ºAutor  ³ SYMM				  º Data ³ 22/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o numero do ultimo item da tabela de preco  		  º±±
±±º          ³ informada.												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SYMM                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UltmItem(cTabPad,cFil)

Local aAreaAtu 	:= GetArea()
Local cAlias	:= CriaTrab(,.F.)
Local cRet		:= StrZero(0,TAMSX3("DA1_ITEM")[1])

cQuery := " SELECT ISNULL(MAX(DA1_ITEM),'0000') ULTMITEM "+ CRLF
cQuery += " FROM "+RetSQLName("DA1")+" DA1 "+ CRLF
cQuery += " WHERE "+ CRLF
cQuery += "		DA1.DA1_FILIAL 		= '"+cFil+"' "+ CRLF
cQuery += "		AND DA1.DA1_CODTAB 	= '"+cTabPad+"' "+ CRLF
cQuery += "		AND DA1.D_E_L_E_T_ 	<> '*' "+ CRLF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa Query gerada  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAlias,.T.,.T.)

While (cAlias)->(!EOF())
	cRet := (cAlias)->ULTMITEM
	(cAlias)->(dbSkip())
EndDo

(cAlias)->(dbCloseArea())

RestArea(aAreaAtu)

Return cRet

User Function SyA006Valid()

Local lRet 	  	:= .T.
Local nPosCol	:= Ascan(oGetGrade:aHeader,{|x| AllTrim(Upper(x[2])) == oGetMedida:AHEADER[oGetMedida:OBROWSE:COLPOS,2]})
Local nConteudo	:= &(ReadVar())

If nConteudo > 0 .And. oGetGrade:aCols[oGetMedida:NAT,nPosCol]==0
	Aviso(STR0028,"Não é possivel preencher este campo, porque na pasta GRADE esta medida está sem valor de custo.",{"Ok"},2)
	lRet := .F.
Endif

Return(lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a006Prod  ³ Autor ³ Eduardo Patriani      ³ Data ³ 24/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se Pode excluir o produto                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Codigo do produto a ser excluido                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a006Prod(cCod)


Local aArea		:= GetArea()
Local cAliasAA3  := ""
Local cAliasAA4  := ""
Local cAliasADB  := ""
Local lErro 	 := .F.
Local lFantasma := .F.
Local nRecnoSM0 := SM0->(RecNo())
Local aSM0CodFil:= {}
Local aFiliais  := {}
Local nBusca	:= 0
Local lRet := .T.
#IFNDEF TOP
	Local nIndex     := 0
	Local cArqInd    := ""
	Local cQuery     := ""
#ELSE
	Local cAliasDTC  := ""
	Local cAliasDE5  := ""
	Local cAliasCNB  := ""
#ENDIF

// Preenche um array com as filiais
dbSelectArea("SM0")
dbGoTop()
do While ! Eof()
	If SM0->M0_CODIGO == cEmpAnt
		Aadd(aSM0CodFil, Alltrim(SM0->M0_CODFIL))
	Endif
	dbSkip()
Enddo
dbGoto(nRecnoSM0)

dbSelectArea("SB2")      // saldos fisico e financeiro
dbSetOrder(1)
aFiliais := If(! Empty(xFilial("SB2")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SB2")})
For nBusca := 1 to Len(aFiliais)
	dbSeek(aFiliais[nBusca]+cCod)
	While !EOF() .And. aFiliais[nBusca]+cCod == B2_FILIAL+B2_COD
		If B2_QATU != 0
			lErro := .T.
			Exit
		EndIf
		dbSkip()
	EndDo
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Especifica SIGAEIC - AVERAGE                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lErro := If(!lErro,!MTA010OK(),lErro)
If lErro
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Especifica SIGAMDT - NG INFORMATICA                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If FindFunction("MdtValESb1")
		lErro := MdtValESb1(cCod)
	EndIF
	If lErro
		lRet := .F.
	EndIf
EndIf

If lRet
	dbSelectArea("SB9")      // Saldos Iniciais
	dbSetOrder(1)
	aFiliais := If(! Empty(xFilial("SB9")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SB9")})
	For nBusca := 1 to Len(aFiliais)
		If dbSeek(aFiliais[nBusca]+cCod)
			If (lFantasma := (SB1->B1_FANTASM == "S"))
				lErro := .F.
				While !Eof() .And. !lErro .And. aFiliais[nBusca]+cCod==B9_FILIAL+B9_COD
					lErro := (B9_QINI # 0)
					dbSkip()
				End
				If lErro
					Exit
				Endif
			EndIf
		Endif
	Next
	If lErro
		lRet := .F.
	Endif
EndIf

If lRet
	dbSelectArea("SC1")      // solicitacoes de compra
	aFiliais := If(! Empty(xFilial("SC1")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC1")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SC2")      // ordens de producao
	aFiliais := If(! Empty(xFilial("SC2")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC2")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SC4")      // previsoes de vendas
	aFiliais := If(! Empty(xFilial("SC4")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC4")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SC6")      // itens dos pedidos de vendas
	aFiliais := If(! Empty(xFilial("SC6")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC6")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SC7")      // pedido de compra
	aFiliais := If(! Empty(xFilial("SC7")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC7")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SC3")      	// Autorizacao de Entrega
	aFiliais := If(! Empty(xFilial("SC3")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SC3")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(3)  				// seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  				// retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SD1")      // itens das notas fiscais de entrada
	aFiliais := If(! Empty(xFilial("SD1")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SD1")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SD2")      // itens das notas fiscais de saida
	aFiliais := If(! Empty(xFilial("SD2")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SD2")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		dbSeek(aFiliais[nBusca]+cCod)
		#IFDEF SHELL
			If Found() .AND. SD1->D1_CANCEL != "S"
				lRet := .F.
				Exit
			EndIf
		#ELSE
			If Found()
				lRet := .F.
				Exit
			EndIf
		#ENDIF
	Next
EndIf

If lRet
	dbSelectArea("SD3")      // movimentacoes internas
	aFiliais := If(! Empty(xFilial("SD3")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SD3")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(3)  // seleciona o indice por produto
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SG1")      // estruturas dos produtos
	aFiliais := If(! Empty(xFilial("SG1")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SG1")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	// Uso o mesmo aFiliais pois se trata (ainda) do mesmo arquivo
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(2)  // seleciona o indice por componente
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)  // retorna ao indice principal do arquivo
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SG2")      // roteiro de fabricacao
	aFiliais := If(! Empty(xFilial("SG2")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SG2")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SBG")      // Sugestao de Or‡amento
	dbSetOrder(1)
	aFiliais := If(! Empty(xFilial("SBG")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SBG")})
	For nBusca := 1 to Len(aFiliais)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SBH")      // Sugestao de Or‡amento
	dbSetOrder(1)
	aFiliais := If(! Empty(xFilial("SBH")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SBH")})
	For nBusca := 1 to Len(aFiliais)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SCK")      // Sugestao de Or‡amento
	aFiliais := If(! Empty(xFilial("SCK")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SCK")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(3)
		dbSeek(aFiliais[nBusca]+cCod)
		dbSetOrder(1)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	dbSelectArea("SCP")      // Solicitacao ao Armazem
	dbSetOrder(2)
	aFiliais := If(! Empty(xFilial("SCP")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SCP")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		If dbSeek(aFiliais[nBusca]+cCod)
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe algum contrato de direito autoral com o produto selecionado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("AH1")      // Contrato de Direito Autoral
	aFiliais := If(! Empty(xFilial("AH1")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("AH1")})
	For nBusca := 1 to Len(aFiliais)
		dbSetOrder(1)
		dbSeek(aFiliais[nBusca]+cCod)
		If Found()
			lRet := .F.
			Exit
		EndIf
	Next
EndIf

/*
If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe algum indicador do produto cadastrado                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SBZ")      // Indicador de Produtos
	dbSetOrder(1)
	aFiliais := If(! Empty(xFilial("SBZ")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("SBZ")})
	For nBusca := 1 to Len(aFiliais)
		If dbSeek(aFiliais[nBusca]+cCod)
			lRet := .F.
			Exit
		EndIf
	Next
EndIf
*/

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe Base Instalada                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		cAliasAA3 := GetNextAlias()
		cQuery    := ""

		cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "AA3" ) + " "
		cQuery += "WHERE "
		cQuery += "AA3_FILIAL='" + xFilial( "AA3" ) + "' AND "
		cQuery += "AA3_CODPRO='" + cCod             + "' AND "
		cQuery += "D_E_L_E_T_=' '"

		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAA3,.F.,.T. )

		If (cAliasAA3)->QTDBASE > 0
			lRet := .F.
		Endif

		dbSelectArea(cAliasAA3)
		dbCloseArea()
		dbSelectArea("AA3")
	#ELSE
		cAliasAA3 := "AA3"
		cQuery    := ""

		cQuery := "AA3_FILIAL=='" + xFilial( "AA3" ) + "' .And. "
		cQuery += "AA3_CODPRO=='" + cCod             + "'"

		cArqInd   := CriaTrab(NIL,.F.)
		IndRegua(cAliasAA3,cArqInd,"AA3_FILIAL+AA3_CODPRO",,cQuery) //"Selecionando Registros ..."

		nIndex := RetIndex("AA3")
		dbSetIndex(cArqInd+OrdBagExT())
		dbSetOrder(nIndex+1)
		dbGotop()

		If (cAliasAA3)->(!Eof())
			lRet := .F.
		Endif

		dbSelectArea(cAliasAA3)
		dbClearFilter()
		RetIndex("AA3")
		FErase(cArqInd+OrdBagExt())
	#ENDIF
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe Acessorio da Base Instalada            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		cAliasAA4 := GetNextAlias()
		cQuery    := ""

		cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "AA4" ) + " "
		cQuery += "WHERE "
		cQuery += "AA4_FILIAL='" + xFilial( "AA4" ) + "' AND "
		cQuery += "AA4_PRODAC='" + cCod             + "' AND "
		cQuery += "D_E_L_E_T_=' '"

		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAA4,.F.,.T. )

		If (cAliasAA4)->QTDBASE > 0
			lRet := .F.
		EndIf

		dbSelectArea(cAliasAA4)
		dbCloseArea()
		dbSelectArea("AA4")
	#ELSE
		cAliasAA4 := "AA4"
		cArqInd   := CriaTrab(NIL,.F.)

		cQuery := "AA4_FILIAL=='" + xFilial( "AA4" ) + "' .And. "
		cQuery += "AA4_PRODAC=='" + cCod             + "'"

		IndRegua(cAliasAA4,cArqInd,"AA4_FILIAL+AA4_PRODAC",,cQuery) //"Selecionando Registros ..."

		nIndex := RetIndex("AA4")
		dbSetIndex(cArqInd+OrdBagExT())
		dbSetOrder(nIndex+1)
		dbGotop()

		If (cAliasAA4)->(!Eof())
			lRet := .F.
		EndIf

		dbSelectArea(cAliasAA4)
		dbClearFilter()
		RetIndex("AA4")
		FErase(cArqInd+OrdBagExt())
	#ENDIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe Tabela de precos                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If lRet
	DA1->(dbSetOrder(2))
	If DA1->(MsSeek(xFilial("DA1")+cCod))
		lRet := .F.
	Endif
EndIf*/

If lRet
	dbSelectArea("ADB")
	aFiliais := If(! Empty(xFilial("ADB")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("ADB")})
	For nBusca := 1 to Len(aFiliais)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe contrato de parceria ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			cAliasADB := GetNextAlias()
			cQuery    := ""

			cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "ADB" ) + " "
			cQuery += "WHERE "
			cQuery += "ADB_FILIAL='" + aFiliais[nBusca] + "' AND "
			cQuery += "ADB_CODPRO='" + cCod             + "' AND "
			cQuery += "D_E_L_E_T_=' '"

			cQuery := ChangeQuery( cQuery )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasADB,.F.,.T. )

			If (cAliasADB)->QTDBASE > 0
				lRet := .F.
			Endif

			dbSelectArea(cAliasADB)
			dbCloseArea()
		#ELSE
			cAliasADB := "ADB"
			cQuery    := ""

			cQuery := "ADB_FILIAL=='" + aFiliais[nBusca] + "' .And. "
			cQuery += "ADB_CODPRO=='" + cCod             + "'"

			cArqInd   := CriaTrab(NIL,.F.)
			IndRegua(cAliasADB,cArqInd,"ADB_FILIAL+ADB_CODPRO",,cQuery) //"Selecionando Registros ..."

			nIndex := RetIndex("ADB")
			dbSetIndex(cArqInd+OrdBagExT())
			dbSetOrder(nIndex+1)
			dbGotop()

			If (cAliasADB)->(!Eof())
				lRet := .F.
			Endif

			dbSelectArea(cAliasADB)
			dbClearFilter()
			RetIndex("ADB")
			FErase(cArqInd+OrdBagExt())
		#ENDIF
	Next nBusca
EndIf

If lRet
	#IFDEF TOP
		dbSelectArea("CNB")
		aFiliais := If(! Empty(xFilial("CNB")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("CNB")})
		For nBusca := 1 to Len(aFiliais)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe planilha de contrato - Gestao de Contratos ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cAliasCNB := GetNextAlias()
			cQuery    := ""

			cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "CNB" ) + " CNB "
			cQuery += "WHERE "
			cQuery += "CNB_FILIAL='" + aFiliais[nBusca] + "' AND "
			cQuery += "CNB_PRODUT='" + cCod             + "' AND "
			cQuery += "D_E_L_E_T_=' '"

			cQuery := ChangeQuery( cQuery )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNB,.F.,.T. )

			If (cAliasCNB)->QTDBASE > 0
				lRet := .F.
			Endif

			dbSelectArea(cAliasCNB)
			dbCloseArea()
		Next nBusca
	#ENDIF
EndIf

If lRet
	If IntTMS() //Validacao de exclusao do produto - ambiente SIGATMS
		#IFDEF TOP
			dbSelectArea("DTC")
			aFiliais := Iif(! Empty(xFilial("DTC")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("DTC")})
			For nBusca := 1 To Len(aFiliais)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe nota fiscal          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAliasDTC := GetNextAlias()
				cQuery    := ""

				cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "DTC" ) + " "
				cQuery += "WHERE "
				cQuery += "DTC_FILIAL='" + aFiliais[nBusca] + "' AND "
				cQuery += "DTC_CODPRO='" + cCod             + "' AND "
				cQuery += "D_E_L_E_T_=' '"

				cQuery := ChangeQuery( cQuery )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC,.F.,.T. )

				If (cAliasDTC)->QTDBASE > 0
					lRet := .F.
				EndIf

				dbSelectArea(cAliasDTC)
				dbCloseArea()

				If !lRet
					Exit
				EndIf

			Next nBusca

			If lRet
				dbSelectArea("DE5")
				aFiliais := Iif(! Empty(xFilial("DE5")) .and. Empty(xFilial("SB1")), aClone(aSM0CodFil), {xFilial("DE5")})
				For nBusca := 1 To Len(aFiliais)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se existe nota fiscal de EDI   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasDE5 := GetNextAlias()
					cQuery    := ""

					cQuery += "SELECT COUNT(*) QTDBASE FROM " + RetSqlName( "DE5" ) + " "
					cQuery += "WHERE "
					cQuery += "DE5_FILIAL='" + aFiliais[nBusca] + "' AND "
					cQuery += "DE5_CODPRO='" + cCod             + "' AND "
					cQuery += "D_E_L_E_T_=' '"

					cQuery := ChangeQuery( cQuery )
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDE5,.F.,.T. )

					If (cAliasDE5)->QTDBASE > 0
						lRet := .F.
					Endif

					dbSelectArea(cAliasDE5)
					dbCloseArea()

					If !lRet
						Exit
					EndIf

				Next nBusca
		    Endif
		#ENDIF
	EndIf
EndIf

If !lRet
	Help(" ",1,"A550NODEL")
EndIf

RestArea( aArea )

Return lRet


//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | CriaPerg      | Autor | Ellen Santiago         | Data | 22/03/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Rotina para criar o grupo de perguntas                             |
//+------------+--------------------------------------------------------------------+
//|                               KOMFORTHOUSE                                      |
//+---------------------------------------------------------------------------------+

Static Function CriaPerg( cPerg )

Local aPerg := {}
Local aHelp := {}

AADD( aHelp,{'01',{"Informe o codigo interno (Codigo NetGera). Ex: GRAARE003552 para Consultar. []Todas Deixe Em Branco "} })
AADD( aHelp,{'02',{"Informe a referencia do produto. Para buscar [Todos] Deixe em Branco "} })
//AADD( aHelp,{'03',{"Informe a descricao da aba grade. para  [Todos] Deixe em Branco "} })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com as perguntas (aPerg)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AaDd( aPerg ,{'01','Codigo Interno SKU :','Codigo Interno SKU :','Codigo Interno SKU :'	,'MV_CH1','C',TAMSX3("B1_CODANT")[1],0,1,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''}) 
AaDd( aPerg ,{'02','Referencia :','Referencia :','Referencia :','MV_CH2','C',TamSX3("B1_01DREF"  )[1],,,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''}) 
//AaDd( aPerg ,{'03','Descricao da Grade :','Descricao da Grade :','Descricao da Grade :','MV_CH3','C',TamSX3("BV_DESCRI"  )[1],,,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''}) 

AjustaSX1( cPerg, aPerg, aHelp )

Return NIL

//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | AjustaSX1     | Autor | Ellen Santiago         | Data | 22/03/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Função responsável por criar as perguntas recebidas por paramêtros |
//+------------+--------------------------------------------------------------------+
//|                               KOMFORTHOUSE                                      |
//+---------------------------------------------------------------------------------+

Static Function AjustaSX1( cPerg, aPerg, aHelp )

Local aArea := GetArea()
Local aCpoPerg := {}
Local nX := 0
Local nY := 0

// DEFINE ESTRUTUA DO ARRAY DAS PERGUNTAS COM AS PRINCIPAIS INFORMACOES
//AADD( aCpoPerg, 'X1_GRUPO' )
AADD( aCpoPerg, 'X1_ORDEM' )
AADD( aCpoPerg, 'X1_PERGUNT' )
AADD( aCpoPerg, 'X1_PERSPA' )
AADD( aCpoPerg, 'X1_PERENG' )
AADD( aCpoPerg, 'X1_VARIAVL' )
AADD( aCpoPerg, 'X1_TIPO' )
AADD( aCpoPerg, 'X1_TAMANHO' )
AADD( aCpoPerg, 'X1_DECIMAL' )
AADD( aCpoPerg, 'X1_PRESEL' )
AADD( aCpoPerg, 'X1_GSC' )
AADD( aCpoPerg, 'X1_VALID' )
AADD( aCpoPerg, 'X1_VAR01' )
AADD( aCpoPerg, 'X1_DEF01' )
AADD( aCpoPerg, 'X1_DEFSPA1' )
AADD( aCpoPerg, 'X1_DEFENG1' )
AADD( aCpoPerg, 'X1_CNT01' )
AADD( aCpoPerg, 'X1_VAR02' )
AADD( aCpoPerg, 'X1_DEF02' )
AADD( aCpoPerg, 'X1_DEFSPA2' )
AADD( aCpoPerg, 'X1_DEFENG2' )
AADD( aCpoPerg, 'X1_CNT02' )
AADD( aCpoPerg, 'X1_VAR03' )
AADD( aCpoPerg, 'X1_DEF03' )
AADD( aCpoPerg, 'X1_DEFSPA3' )
AADD( aCpoPerg, 'X1_DEFENG3' )
AADD( aCpoPerg, 'X1_CNT03' )
AADD( aCpoPerg, 'X1_VAR04' )
AADD( aCpoPerg, 'X1_DEF04' )
AADD( aCpoPerg, 'X1_DEFSPA4' )
AADD( aCpoPerg, 'X1_DEFENG4' )
AADD( aCpoPerg, 'X1_CNT04' )
AADD( aCpoPerg, 'X1_VAR05' )
AADD( aCpoPerg, 'X1_DEF05' )
AADD( aCpoPerg, 'X1_DEFSPA5' )
AADD( aCpoPerg, 'X1_DEFENG5' )
AADD( aCpoPerg, 'X1_CNT05' )
AADD( aCpoPerg, 'X1_F3' )
AADD( aCpoPerg, 'X1_PYME' )
AADD( aCpoPerg, 'X1_GRPSXG' )
AADD( aCpoPerg, 'X1_HELP' )
AADD( aCpoPerg, 'X1_PICTURE' )
AADD( aCpoPerg, 'X1_IDFIL' )

DBSelectArea( "SX1" )
DBSetOrder( 1 )
For nX := 1 To Len( aPerg )
	IF !DBSeek( PADR(cPerg,10) + aPerg[nX][1] )
		RecLock( "SX1", .T. ) // Inclui
	Else
		RecLock( "SX1", .F. ) // Altera
	Endif
	 // Grava informacoes dos campos da SX1
	 For nY := 1 To Len( aPerg[nX] )  // A contagem comeca no [X1_ORDEM]
	 	If aPerg[nX][nY] <> NIL 
	 		SX1->( &( aCpoPerg[nY] ) ) := aPerg[nX][nY]
	 	EndIf
	 Next
	SX1->X1_GRUPO := PADR(cPerg,10)
	MsUnlock() // Libera Registro
	// Verifica se campo possui Help
	_nPosHelp := aScan(aHelp,{|x| x[1] == aPerg[nX][1]}) 	
 
	 IF (_nPosHelp > 0)
	  	cNome := "P."+TRIM(cPerg)+ aHelp[_nPosHelp][1]+"."
	  	PutSX1Help(cNome,aHelp[_nPosHelp][2],{},{},.T.)
	 Else
	 // Apaga help ja existente.
	 	cNome := "P."+TRIM(cPerg)+ aPerg[nX][1]+"."
	 	PutSX1Help(cNome,{" "},{},{},.T.)
	 Endif
Next

// Apaga perguntas nao definidas no array
DBSEEK(cPerg,.T.)

DO WHILE SX1->(!Eof()) .And. SX1->X1_GRUPO == cPerg
	IF ASCAN(aPerg,{|Y| Y[1] == SX1->X1_ORDEM}) == 0
		Reclock("SX1", .F.)
		SX1->(DBDELETE())
		Msunlock()
	ENDIF
SX1->(DBSKIP())
ENDDO

RestArea( aArea )
	
	
Return



//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | AjustaSX1     | Autor | Ellen Santiago         | Data | 22/03/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: |Verifica se existe tabela de preço para o fornecedor em questao     |
//+------------+--------------------------------------------------------------------+
//|                               KOMFORTHOUSE                                      |
//+---------------------------------------------------------------------------------+

Static Function SYTMTAB(cCodFor,cLoja)

Local cTabela := ""
Local lContinua := .F.

SA2->(DbSetOrder(1))	
If SA2->(DbSeek(xFilial("SA2") + cCodFor + cLoja ))
	lContinua := Iif(Empty(SA2->A2_XTABELA),.F.,.T.)
Endif
	
Return lContinua 



//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | SYTTAB001     | Autor | Ellen Santiago         | Data | 11/06/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Retorna o preco do produto da tabela de preco do Fornecedor atual  |
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+

Static Function SYTTAB001(cCodPro)

Local cQuery	:= "" 
Local cTabela	:= ""

cTabela := Posicione("SA2",1,xFilial("SA2")+M->B4_PROC+M->B4_LOJPROC,"A2_XTABELA") 

cQuery := "SELECT * " + CRLF
cQuery += "FROM " + RetSQLName("DA1") + " DA1 " + CRLF
cQuery += "INNER JOIN " + RetSQLName("DA0") + " DA0 " + CRLF
cQuery += "ON DA0_CODTAB = DA1_CODTAB " + CRLF 
cQuery += "WHERE DA0_CODTAB = '"+cTabela+"' "+CRLF
cQuery += "AND DA0_ATIVO = '1'" + CRLF 
cQuery += "AND DA1_CODPRO = '" + cCodPro + "' " + CRLF
cQuery += "AND DA1.D_E_L_E_T_ = '' " + CRLF
cQuery += "AND DA0.D_E_L_E_T_ = '' " + CRLF

If Select("TABDA1") > 0
	TABDA1->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TABDA1",.F.,.T.)

Return TABDA1->DA1_PRCVEN

//--------------------------------------------------------------
/*/{Protheus.doc} fTelaPre
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Caio Garcia                                              
@since 30/11/2018                                                   
/*/                                                             
//--------------------------------------------------------------
Static Function fTelaPre(_cDescPrd)  
                      
Local oBitmap1
Local oButton1
Local oGet1
Local cGet1 := _cDescPrd
Local oGet2
Local oGet3
Local oSay1
Local oSay2
Local oSay3
Local oComboBo1
Local oComboBo2
Local oComboBo3
Local oSay4
Local oSay5
Local oSay6

  DEFINE MSDIALOG oDlg TITLE "Produto Novo - Digitação de Preços" FROM 000, 000  TO 250, 450 COLORS 0, 16777215 PIXEL

    @ 083, 002 BITMAP oBitmap1 SIZE 069, 038 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
    @ 009, 001 SAY oSay1 PROMPT "Produto:" SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 028 MSGET oGet1 VAR cGet1 SIZE 195, 010 OF oDlg When .T. COLORS 0, 16777215 PIXEL
    @ 026, 001 SAY oSay2 PROMPT "Preço Venda:" SIZE 044, 012 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 001 SAY oSay3 PROMPT "Preço Transf.:" SIZE 041, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 025, 044 MSGET oGet2 VAR _nPVen Picture "@E 999,999,999.99" SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 039, 044 MSGET oGet3 VAR _nPTra Picture "@E 999,999,999.99" SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 097, 159 BUTTON oButton1 PROMPT "Confirma" SIZE 059, 022 OF oDlg ACTION FValidVal(_nPVen, _nPTra) PIXEL

    @ 030, 177 MSCOMBOBOX oComboBo1 VAR _nPerso ITEMS {"1 - Sim","2 - Não"} SIZE 042, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 177 MSCOMBOBOX oComboBo2 VAR _nBiPar ITEMS {"1 - Sim","2 - Não"} SIZE 042, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 160 MSCOMBOBOX oComboBo3 VAR _nEnco ITEMS {"1 - Giro","2 - Encomenda"} SIZE 059, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 031, 136 SAY oSay4 PROMPT "Med. Especial?" SIZE 036, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 136 SAY oSay5 PROMPT "Bi-Partido?" SIZE 037, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 055, 136 SAY oSay6 PROMPT "Tipo?" SIZE 029, 009 OF oDlg COLORS 0, 16777215 PIXEL
  
	ACTIVATE MSDIALOG oDlg CENTERED     
  	 

Return

//--------------------------------------------------------------
/*/{Protheus.doc} FValidVal
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Caio Garcia                                              
@since 30/11/2018                                                   
/*/                                                             
//--------------------------------------------------------------
Static Function FValidVal(_nPVen, _nPTra)

	If _nPVen < 0
	
		Alert("O preço de venda não pode ser menor que zero!")
		Return _lSai

	ElseIf _nPTra < 0
	
		Alert("O preço de transferência não pode ser menor que zero!")
		Return _lSai
		
	EndIf	                           
	
	_lSai := MsgYesNo("Confirma o preço de venda "+Alltrim(Transform(_nPVen,"@E 999,999,999.99"))+" e o de transferência "+Alltrim(Transform(_nPTra,"@E 999,999,999.99"))+" ?","PREÇOS")
    
	If _lSai
		
		 oDlg:End()
		 
	EndIf	 

Return _lSai


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAtuPreco  ºAutor  ³ SYMM				    º Data ³ 11/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizacao da tabela de preco padrao.               		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fAtuPreco(aPrecos)

Local cItem := ''
Local nX

dbSelectArea("SA2")
SA2->(DbSetOrder(1))	
If SA2->(DbSeek(xFilial("SA2") + M->B4_PROC + M->B4_LOJPROC ))
	
	For nX := 1 To Len(aPrecos)
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1") + aPrecos[nX,1]))
	
		dbSelectArea("DA1")
		dbSetOrder(1)
		If !DA1->(dbSeek(xFilial("DA1")+SA2->A2_XTABELA+PADR(SB1->B1_COD,TAMSX3("DA1_CODPRO")[1])))
	
			cItem := UltmItem(SA2->A2_XTABELA,xFilial("DA1"))
			cItem := Soma1(cItem)
	
			RecLock("DA1", .T.)
			Replace DA1_FILIAL  With xFilial("DA1")
			Replace DA1_ITEM	With cItem
			Replace DA1_CODTAB  With SA2->A2_XTABELA
			Replace DA1_CODPRO	With SB1->B1_COD
			Replace DA1_REFGRD	With SB1->B1_01PRODP
			Replace DA1_PRCVEN	With aPrecos[nX,2] // Regra nao definida para calculo do preco
//			Replace DA1_GRUPO	With SB1->B1_GRUPO //#AFD20180601
			Replace DA1_PERDES	With 1
			Replace DA1_QTDLOT	With 999999.99
			Replace DA1_ATIVO	With "1"
			Replace DA1_TPOPER	With "4"
			Replace DA1_MOEDA	With 1
			Replace DA1_DATVIG	With dDatabase
		Endif
		MsUnLock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alimenta tambem a tabela principal        ³
		//³___________________________________________³
		If !DA1->(dbSeek(xFilial("DA1")+'001'+PADR(SB1->B1_COD,TAMSX3("DA1_CODPRO")[1])))
	
			cItem := UltmItem('001',xFilial("DA1"))
			cItem := Soma1(cItem)
	
			RecLock("DA1", .T.)
			Replace DA1_FILIAL  With xFilial("DA1")
			Replace DA1_ITEM	With cItem
			Replace DA1_CODTAB  With '001'
			Replace DA1_CODPRO	With SB1->B1_COD
			Replace DA1_REFGRD	With SB1->B1_01PRODP
			Replace DA1_PRCVEN	With aPrecos[nX,2] // Regra nao definida para calculo do preco
//			Replace DA1_GRUPO	With SB1->B1_GRUPO //#AFD20180601
			Replace DA1_PERDES	With 1
			Replace DA1_QTDLOT	With 999999.99
			Replace DA1_ATIVO	With "1"
			Replace DA1_TPOPER	With "4"
			Replace DA1_MOEDA	With 1
			Replace DA1_DATVIG	With dDatabase
		Endif
		MsUnLock()
	
	Next nX
Endif

Return

