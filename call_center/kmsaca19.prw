#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³   º Autor ³ Everton Santos            º Data ³  03/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ INCLUI/ALTERA REGISTROS NA TABELA SX5 ZZ                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#Define CRLF Chr(10)+Chr(13)

USER FUNCTION KMSACA19()

Private cString   := "SX5"
Private cCadastro := "Cadastro de Posição do Chamado"
Private aRotina   := { 	{"Pesquisar" ,"AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir"   ,"U_CADREG(1)",0,3},;
{"Alterar"   ,"U_CADREG(2)",0,4},;
{"Excluir"   ,"AxDeleta",0,5}}

DbSelectArea(cString)
DbSetOrder(1)
DbSetFilter({|| X5_TABELA = 'ZZ'},"X5_TABELA = 'ZZ'")

mBrowse(6,1,22,75,cString)

RETURN()

USER FUNCTION CADREG(nOpc)

Local cDesc    := SPACE(55)
Local cCabec   := "Cadastro de Posição do chamado"
Local aButtons := {}
Local lGrava   := .F.
Local cChave   := ""
Local oFnt, oDesc, oDlg


IF nOpc = 1
	cCabec += "INCLUI"
Else
	cCabec += "ALTERAR"
	cDesc  := SX5->X5_DESCRI
EndIF

DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 120,600 TITLE cCabec Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

@ 040,010 Say "Nome: " Size 040,010 Font oFnt Pixel Of oDlg
@ 038,050 MSGET oDesc VAR cDesc OF oDlg PIXEL NOBORDER  SIZE 240,010 FONT oFnt 

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || IF(!EMPTY(cDesc),(lGrava := .T. , oDlg:End()),MsgAlert("Descrição em branco!!!")) } , { || oDlg:End() },, aButtons)

IF lGrava
	IF nOpc = 1
		If MsgYesNo("Deseja Incluir Este Registro?...") 
			DbSetOrder(1)
			While SX5->(!EOF()) .AND. SX5->X5_TABELA = 'ZZ'
				cChave := SX5->X5_CHAVE
				DbSkip()
			EndDo
			RecLock("SX5",.T.)
			SX5->X5_FILIAL  := xFilial("SX5")
			SX5->X5_TABELA  := 'ZZ'
			SX5->X5_CHAVE   := SOMA1(ALLTRIM(cChave))
			SX5->X5_DESCRI  := cDesc
			SX5->X5_DESCSPA := cDesc
			SX5->X5_DESCENG := cDesc						
			SX5->(MsUnlock())
		EndIF		
	ElseIF nOpc = 2
		If MsgYesNo("Deseja Alterar Este Registro?...")
			RecLock("SX5",.F.)
			SX5->X5_DESCRI  := cDesc
			SX5->X5_DESCSPA := cDesc
			SX5->X5_DESCENG := cDesc						
			SX5->(MsUnlock()) 
		EndIF
	EndIF
EndIF            

RETURN()