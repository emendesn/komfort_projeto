#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

user function KHTMK003(cResumo)

Local aButtons  := {}   
Local cObsAnt   := ""
Local cObsNew   := ""  
Local lGrava    := .F.
Local oDlg, oLogo, oFnt, oBrw, oObsAnt, oObsNew  
Local cGrpLib	:= GetMv("MV_KOGRPLB")
Private cCadastro := "Observações de Crédito"
Default cResumo  := ''

cObsAnt := M->A1_XHISTCR
cObsNew := cResumo

DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 500,590 TITLE cCadastro Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

// TRAZ O LOGO DA KOMFORT
@ 035,010 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.    

@ 075, 005 GET oObsAnt VAR cObsAnt MEMO SIZE 140,170  PIXEL OF oDlg When .F.
@ 075, 150 GET oObsNew VAR cObsNew MEMO SIZE 140,170  PIXEL OF oDlg 

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || lGrava := .T. , oDlg:End() } , { || lGrava := .F. , oDlg:End() },, aButtons)

IF lGrava
	If !Empty(cObsNew)
		M->A1_XHISTCR :=  REPLICATE("-",063) + CRLF + DTOC(dDataBase) + " - " + Time() + " - " + ALLTRIM(cUserName) + CRLF + cObsNew + CRLF + cObsAnt + CRLF
	EndIf		 
EndIF

return