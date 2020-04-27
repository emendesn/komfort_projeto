#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"  

#Define CRLF Chr(10)+Chr(13)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA01 � Autor � LUIZ EDUARDO F.C.  � Data �  08/03/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � ATUALIZA O CAMPO OBSERVACAO DO ATENDIMENTO DO SAC          ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ�� 
��������������������������������������������������������������������������ٱ�
���Caio Garcia    �19/02/18�Gravar data e depois nome                     ���
���#CMG20180219   �        �                                              ���
��������������������������������������������������������������������������ٱ�
���               �        �                                              ���
���               �        �                                              ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA01() 

Local aButtons  := {}   
Local cObsAnt   := ""
Local cObsNew   := ""  
Local lGrava    := .F.
Local oDlg, oLogo, oFnt, oBrw, oObsAnt, oObsNew  
Local cGrpLib	:= GetMv("MV_KOGRPLB")

Private cCadastro := ""

If nFolder == 1 //SAC
	cObsAnt := M->UC_OBS
	cCadastro := "OBSERVA��O ATENDIMENTO SAC"	
else //TELEVENDAS
	cObsAnt := M->UA_XOBSCRD
	cCadastro := "OBSERVA��O TELEVENDAS"
Endif

//�������������������������������������������������������������������Ŀ
//� MONTA A TELA COM AS INFORMACOES DETALHADAS DO PRODUTO SELECIONADO �
//���������������������������������������������������������������������
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
	if nFolder == 1 //SAC
		//M->UC_OBS := cObsAnt + CRLF + REPLICATE("-",067) + CRLF + ALLTRIM(cUserName) + " - " + 	DTOC(dDataBase) + " - " + Time() + CRLF + 	cObsNew #CMG20180219.o
		M->UC_OBS := cObsAnt + CRLF + REPLICATE("-",067)+ CRLF +DTOC(dDataBase) + " - " + Time() + " - " + ALLTRIM(cUserName) + CRLF + cObsNew //#CMG20180219.n	 
	else //TELEVENDAS
		M->UA_XOBSCRD := cObsAnt + CRLF + REPLICATE("-",067)+ CRLF +DTOC(dDataBase) + " - " + Time() + " - " + ALLTRIM(cUserName) + CRLF + cObsNew
	endif
EndIF

RETURN()
