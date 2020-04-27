#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออัออออออออออออออออออออออหออออออัออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ  SYTM005 บ Autor  ณ  Eduardo Patriani    บ Data ณ  27/10/16            บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de acompanhamentos das devolucoes.                            	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function SYTM005()

Local cQuery   := ""
Local aSize    := MsAdvSize()
Local oSt1     := LoadBitmap(GetResources(),'BR_AMARELO')
Local oSt2     := LoadBitmap(GetResources(),'BR_VERMELHO')
Local aButtons := {}
Local aPerg := { PADR("SYTM005",10) }
Local oBmpA
Local oBmpV

Private aRotina := {}
Private aSUC    := {}
Private oTela, oPanel, oBrwSUC, oGetDados, oPnlSup

AjustaSX1(aPerg)
Pergunte(aPerg[1],.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FILTRA O CABECALHO DOS PEDIDOS NO SC5 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT "
cQuery += "		F1_FILIAL "
cQuery += "		,F1_01SAC "
cQuery += "		,F1_DOC "
cQuery += "		,F1_SERIE "
cQuery += "		,F1_FORNECE "
cQuery += "		,F1_LOJA "
cQuery += "		,A1_NOME "
cQuery += "		,F1_RECBMTO "
cQuery += "		,F1_MOTIVO "
cQuery += "		,X5_DESCRI "
cQuery += "		,F1_01OBS "
cQuery += "		,(CASE WHEN UC_STATUS='3' THEN 'ENCERRADO' ELSE 'EM ATENDIMENTO' END) STATUS "
cQuery += "		,SF1.R_E_C_N_O_ AS SF1REC "
cQuery += "FROM "+RetSqlName("SF1")+" SF1 (NOLOCK) "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND SA1.D_E_L_E_T_ =  ' ' "
cQuery += "INNER JOIN "+RetSqlName("SUC")+" SUC ON UC_CODIGO=F1_01SAC AND SUC.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN "+RetSqlName("SX5")+" SX5 ON X5_FILIAL = '"+xFilial("SX5")+"' AND X5_TABELA='O1' AND X5_CHAVE=F1_MOTIVO AND SX5.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery += "			SF1.D_E_L_E_T_ =  ' ' AND "
cQuery += "			F1_FILIAL 	= '"+xFilial("SF1")+"' AND "
cQuery += "			F1_TIPO 	= 'D' AND "
cQuery += "			F1_01SAC 	<> '' AND "
cQuery += "			F1_RECBMTO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
If Mv_PAR03 == 1
	cQuery += "	UC_STATUS IN ('1','2') "
ElseIf Mv_PAR03 == 2
	cQuery += "	UC_STATUS = '3' " 
Else
	cQuery += "	UC_STATUS IN ('1','2','3') "
Endif
cQuery += "ORDER BY "
cQuery += "		F1_01SAC "

If Select("TRB01") > 0
	TRB01->(DbCloseArea())
EndIf
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB01",.F.,.T.)

TRB01->(DbGoTop())
While TRB01->(!EOF())
	aAdd( aSUC , { 	TRB01->F1_FILIAL 		,; 
					TRB01->F1_01SAC 		,; 
					TRB01->F1_DOC 			,; 
					TRB01->F1_SERIE 		,; 
					TRB01->F1_FORNECE 		,; 
					TRB01->F1_LOJA 			,; 
					TRB01->A1_NOME 			,; 
					STOD(TRB01->F1_RECBMTO)	,; 
					TRB01->F1_MOTIVO 		,; 
					TRB01->X5_DESCRI 		,; 
					TRB01->F1_01OBS 		,; 
					TRB01->STATUS 			})
	TRB01->(DbSkip())
EndDo
TRB01->(DbCloseArea())

IF Len(aSUC) >0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MONTA A TELA  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Acompanhamento de Retorno de Entregas" Of oMainWnd PIXEL
	
	oPanel:= TPanel():New(000,000,,oTela, NIL, .T., .F., NIL, NIL,000,000, .T., .F. )
	oPanel:Align:=CONTROL_ALIGN_ALLCLIENT
	oPanel:NCLRPANE := 14803406
	
	oPnlSup:= TPanel():New(000,000,,oPanel, NIL, .T., .F., NIL, NIL,200,250, .T., .F. )
	oPnlSup:Align:=CONTROL_ALIGN_TOP
	oPnlSup:NCLRPANE := 14803406
	
	oBrwSUC:= TwBrowse():New(005, 005, 200, 250,, {'','Filial','Nr Chamado','Nota Fiscal','Serie','Cliente','Loja','Nome do Cliente','Data de Recebimento','Codigo do Motivo','Descri็ใo','Observa็ใo'},,oPnlSup,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oBrwSUC:SetArray(aSUC)
	oBrwSUC:bLine      := {|| {  IF(	aSUC[oBrwSUC:nAt,12] == 'EM ATENDIMENTO',oSt1,oSt2) ,; 
										Alltrim(Posicione("SM0",1,cEmpAnt+aSUC[oBrwSUC:nAt,01],"M0_FILIAL")) ,; 
										Alltrim(aSUC[oBrwSUC:nAt,02]) ,;
										Alltrim(aSUC[oBrwSUC:nAt,03]) ,; 
										Alltrim(aSUC[oBrwSUC:nAt,04]) ,; 
										Alltrim(aSUC[oBrwSUC:nAt,05]) ,;
										Alltrim(aSUC[oBrwSUC:nAt,06]) ,; 
										Alltrim(aSUC[oBrwSUC:nAt,07]) ,; 
										aSUC[oBrwSUC:nAt,08] 		   ,; 
										Alltrim(aSUC[oBrwSUC:nAt,09]) ,;
										Alltrim(aSUC[oBrwSUC:nAt,10]) ,;
										Alltrim(aSUC[oBrwSUC:nAt,11]) }}
										
	oBrwSUC:bLDblClick := {|| MsgRun("Aguarde...",,{|| VisualNF( aSUC[oBrwSUC:nAt,03] , aSUC[oBrwSUC:nAt,04] , aSUC[oBrwSUC:nAt,05] , aSUC[oBrwSUC:nAt,06] ) }) }
	oBrwSUC:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ 258,005 BITMAP oBmpA ResName "BR_AMARELO" OF oPanel Size 10,10 NoBorder When .F. Pixel
	@ 258,015 SAY "Em atendimento" OF oPanel Color CLR_BLUE,CLR_WHITE PIXEL

	@ 258,095 BITMAP oBmpV ResName "BR_VERMELHO_OCEAN" OF oPanel Size 10,10 NoBorder When .F. Pixel
	@ 258,105 SAY "Encerradas" OF oPanel Color CLR_RED,CLR_WHITE PIXEL
	
	ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End() } , { || oTela:End() },, aButtons)
Else
	MsgInfo("Nรo existem documentos para acompanhamento.","Aten็ใo")
EndIF

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSx1 บAutor  ณSymm Consultoria    บ Data ณ  16/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria paremtros do relatorio                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(aPerg)

Local aHelp01
Local aHelp02
Local aHelp03

aHelp01 := {"Selecione a data de recebimento inicial.",""}
aHelp02 := {"Selecione a data de recebimento final.",""}
aHelp03 := {"Selecione o status.",""}

PutSx1(aPerg[1],"01","Da Data de Recebimento"	,"Da Data de Recebimento"	,"Da Data de Recebimento"	,"mv_ch1","D",TAMSX3("F1_EMISSAO")[1]	,TAMSX3("F1_EMISSAO")[2]	,0,"G","NaoVazio()"	,"","","","mv_par01","","","","","","","","","","","",""," ","","","",aHelp01,aHelp01,aHelp01)
PutSx1(aPerg[1],"02","Ate Data de Recebimento"	,"Ate Data de Recebimento"	,"Ate Data de Recebimento"	,"mv_ch2","D",TAMSX3("F1_EMISSAO")[1]	,TAMSX3("F1_EMISSAO")[2]	,0,"G","NaoVazio()"	,"","","","mv_par02","","","","","","","","","","","",""," ","","","",aHelp02,aHelp02,aHelp02)
PutSx1(aPerg[1],"03","Status" 					,"Status"					,"Status"  					,"mv_ch3","N",1,0,1,"C","","","","","mv_par03"	,"Em atendimento","Em atendimento","Em atendimento",,"Encerrado","Encerrado","Encerrado","Todos","Todos","Todos","","","","","","",aHelp03,aHelp03,aHelp03)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisualNF  บAutor  ณSymm Consultoria    บ Data ณ  28/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Vizualiza documento de entrada.                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VisualNF(cDocumento,cSerie,cFornece,cLoja)

	aRotina:= {}
	aAdd(aRotina,{"Pesquisar"	, "AxPesqui"   , 0 , 1, 0, .F.}) 	
	aAdd(aRotina,{"Visualizar"	, "A103NFiscal", 0 , 2, 0, nil}) 	
	aAdd(aRotina,{"Incluir"		, "A103NFiscal", 0 , 3, 0, nil}) 	
	aAdd(aRotina,{"Classificar"	, "A103NFiscal", 0 , 4, 0, nil}) 
	aAdd(aRotina,{"Retornar"	, "A103Devol"  , 0 , 3, 0, nil})	
	aAdd(aRotina,{"Excluir"		, "A103NFiscal", 3 , 5, 0, nil})		
	aAdd(aRotina,{"Imprimir"	, "A103Impri"  , 0 , 4, 0, nil})	
	aAdd(aRotina,{"Legenda"		, "A103Legenda", 0 , 2, 0, .F.})		

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+cDocumento+cSerie+cFornece+cLoja,.T.)

	A103NFiscal("SF1",SF1->(Recno()),2)
	
Return