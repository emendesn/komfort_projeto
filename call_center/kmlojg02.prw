#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � KMLOJG02 � Autor � LUIZ EDUARDO F.C.  � Data �  11/08/2017 罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � GATILHO NO CAMPO UB_MOSTRUA - IRA FAZER O TRATAMENTO PARA  罕�
北�          � ITENS PERSONALIZADOS                                       罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � KOMFORT HOUSE - LOJA                                       罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
USER FUNCTION KMLOJG02()

Local nPosAtu2 := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "UB_XAGEND"})//#afd27062018.n
Local nDESCPER := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DESCPER"})
Local nPRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local cXPERSO  := POSICIONE("SB1",1,XFILIAL("SB1")+aCols[n,nPRODUTO],"B1_XPERSO") 
Local cOBS     := SPACE(100)   
Local lRet     := .T.       
Local oDlg      

IF M->UB_MOSTRUA == "3"	
	IF cXPERSO == "1"
		DEFINE DIALOG oDlg TITLE "Descri玢o - PRODUTO PERSONALIZADO" FROM 0,0 TO 130,620 PIXEL
		
		@ 005,005 Say "Digite Observa玢o do Produto Personalizado : " Size 150,010 Pixel Of oDlg
		@ 020,05 MSGET cOBS	PICTURE PesqPict('SUB','UB_DESCRI') OF oDlg PIXEL SIZE 300,010
		
		@ 040,005 BUTTON "&OK"	SIZE 50,15 OF oDlg PIXEL ACTION {|| (oDlg:End())  }
		
		ACTIVATE DIALOG oDlg CENTERED                                         
		
		aCols[n,nDESCPER] := cOBS
	Else
		MsgInfo("Este produto n鉶 est� liberado para personaliza玢o! Entre em contato com o DEPTO. de COMPRAS!")
		lRet := .F.	
	EndIF
Else
	aCols[n,nDESCPER] := ""
EndIF 

//#AFD27062018.BN
if M->UB_MOSTRUA == '2'  
	aCols[oGetTLV:oBrowse:nAt][nPosAtu2] := "2"
endif
//#AFD27062018.EN
//#WRP27062018.BN
if M->UB_MOSTRUA == '5'  
	aCols[oGetTLV:oBrowse:nAt][nPosAtu2] := "2"
endif
//#WRP27062018.EN

RETURN(lRet)
