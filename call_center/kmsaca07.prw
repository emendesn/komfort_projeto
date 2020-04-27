#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA07 � Autor � LUIZ EDUARDO F.C.  � Data �  23/05/17   ���
�������������������������������������������������������������������������͹��
���Descricao � PESQUISA SE TEM CHAMADOS EM ABERTO DO CLIENTE SELECONADO   ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA07()

Local aButtons  := {}
Local aChamados := {}
Local cQuery    := ""
Local oDlg, oFnt, oLogo

Private cCadastro := ""

cQuery := " SELECT UC_CODIGO, UC_DATA, UC_01FIL FROM SUC010 "
cQuery += " WHERE UC_FILIAL = ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND UC_CHAVE = '" + M->UC_CHAVE + "' "
cQuery += " AND UC_01PED = '" + M->UC_01PED + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())                                                                                                      

While TMP->(!EOF())
	aAdd( aChamados , { TMP->UC_CODIGO, TMP->UC_DATA, TMP->UC_01FIL } )
	TMP->(dBSkip())
EndDo                                                                                                           
                                                                                                          
IF Len(aChamados) > 0
	//�������������������������������������������������������������������Ŀ
	//� MONTA A TELA COM AS INFORMACOES DETALHADAS DO PRODUTO SELECIONADO �
	//���������������������������������������������������������������������
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oDlg FROM 0,0 TO 400,420 TITLE "CHAMADOS PARA O PEDIDO INFORMADO - KMSACA07" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	
	// TRAZ O LOGO DA KOMFORT
	@ 035,010 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.   
	
	@ 080,008 SAY "Chamados existentes com o mesmo pedido" SIZE 200,010 OF oDlg PIXEL  
	
	oBrw:= TWBrowse():New(100,008,200,090,,{"Chamado","Data Abertura","Filial"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aChamados)
	oBrw:bLine := {|| {	aChamados[oBrw:nAt,01]	,; 	
						DTOC(STOD(aChamados[oBrw:nAt,02])) ,;
						aChamados[oBrw:nAt,03] }}
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End() } , { || oDlg:End() },, aButtons)
	
EndIF

RETURN(.T.)
