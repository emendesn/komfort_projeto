#Include "RwMake.ch"
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
���Programa  � SYTMOV06 �Autor  � Luiz Eduardo F.C.  � Data � 04/11/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � BUSCA DE CLIENTES PARA A TELA DE MONITOR DE PEDIDOS        ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION SYTMOV06()

Private oSearch
Private cCodCli  := SPACE(06)
Private cLjCli   := SPACE(02)
Private cCPFCli  := SPACE(14)
Private cNomCli  := SPACE(80)
Private cFoneCli := SPACE(08)
Private cPedCli  := SPACE(06)

DEFINE MSDIALOG oSearch FROM 0,0 TO 240,260 TITLE "Informe o Cliente" Of oMainWnd PIXEL

@ 005, 005 Say "C�digo : " Size 100,010 Pixel Of oSearch
@ 004, 050 MSGET cCodCli PICTURE PesqPict("SA1","A1_COD")  F3 "SA1" SIZE 040,010 PIXEL OF oSearch VALID(cLjCli := SA1->A1_LOJA )
@ 004, 100 MSGET cLjCli  PICTURE PesqPict("SA1","A1_LOJA")          SIZE 020,010 PIXEL OF oSearch WHEN .F.

@ 020, 005 Say "CPF  : " Size 100,010 Pixel Of oSearch
@ 019, 050 MSGET cCPFCli  PICTURE "@R 999.999.999-99" SIZE 070,010 PIXEL OF oSearch

@ 035, 005 Say "Nome : " Size 100,010 Pixel Of oSearch
@ 034, 050 MSGET cNomCli  PICTURE "@!" SIZE 070,010 PIXEL OF oSearch

@ 050, 005 Say "Telefone : " Size 100,010 Pixel Of oSearch
@ 049, 050 MSGET cFoneCli  PICTURE PesqPict("SA1","A1_TEL")  SIZE 070,010 PIXEL OF oSearch

@ 065, 005 Say "Pedido : " Size 100,010 Pixel Of oSearch
@ 064, 050 MSGET cPedCli  PICTURE PesqPict("SC5","C5_NUM") F3 "SC5" SIZE 070,010 PIXEL OF oSearch

@ 090, 005 BUTTON "&Ok"			SIZE 50,15 OF oSearch PIXEL ACTION {|| FwMsgRun( ,{|| VLDCLI() }, , "Por favor, aguarde filtrando o cliente..." )  }
@ 090, 070 BUTTON "&CANCELAR" 	SIZE 50,15 OF oSearch PIXEL ACTION {|| oSearch:End() }

ACTIVATE DIALOG oSearch CENTERED

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VLDCLI   � Autor � LUIZ EDUARDO F.C.  � Data � 04/11/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � VALIDA AS INFORMACOES DO FILTRO DE CLIENTES                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
STATIC FUNCTION VLDCLI()

Local lRet   := .F.
Local cQuery := ""
Local oOk	 := LoadBitMap(GetResources(), "LBOK")
Local oNo	 := LoadBitMap(GetResources(), "LBNO")

Private oDlgCli, oBrwCli
Private aNome  := {}

DbSelectArea("SA1")

IF !EMPTY(cCodCli)
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	IF SA1->(DbSeek(xFilial("SA1") + cCodCli + cLjCli))
		lRet := .T.
	EndIF
ElseIF !EMPTY(cCPFCli)
	SA1->(DbSetOrder(3))
	SA1->(DbGoTop())
	IF SA1->(DbSeek(xFilial("SA1") + cCPFCli))
		lRet := .T.
	EndIF
ElseIF !EMPTY(cNomCli)  .OR. !EMPTY(cFoneCli)
	cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_TEL FROM " + RETSQLNAME("SA1")
	cQuery += " WHERE A1_FILIAL = '" + XFILIAL("SA1") + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	IF !EMPTY(cNomCli)
		cQuery += " AND A1_NOME LIKE '%" + ALLTRIM(cNomCli) + "%' "
	Else
		cQuery += " AND A1_TEL LIKE '%" + ALLTRIM(cFoneCli) + "%' "
	EndIF
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	While TRB->(!EOF())
		aAdd( aNome, { .F. , TRB->A1_COD, TRB->A1_LOJA, TRB->A1_NOME, TRB->A1_CGC, TRB->A1_TEL } )
		TRB->(DbSkip())
	EndDo
	
	IF Len(aNome) > 0
		
		lRet := .T.
		
		DEFINE MSDIALOG oDlgCli FROM 0,0 TO 250,700 TITLE "Selecione o cliente correto!" Of oMainWnd PIXEL
		
		oBrwCli:= TWBrowse():New(010,005,340,080,,{"","C�digo","Loja","Nome","CPF","Telefone"},,oDlgCli,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oBrwCli:SetArray(aNome)
		oBrwCli:bLine := {|| { 	If(aNome[oBrwCli:nAt,01],oOK,oNO)		,;	// CHECK BOX
		aNome[oBrwCli:nAt,02] 											,;	// CODIGO DO CLIENTE
		aNome[oBrwCli:nAt,03] 											,;	// LOJA DO CLIENTE
		aNome[oBrwCli:nAt,04] 											,;	// NOME
		TRANSFORM( aNome[oBrwCli:nAt,05], "@R 999.999.999-99")   		,;	// CPF
		TRANSFORM( aNome[oBrwCli:nAt,06], "@R 9999-9999")  				,;	// TELEFONE
		}}
		
		oBrwCli:bLDblClick := {|| ( VLDCHK() , oBrwCli:Refresh() ) }
		
		@ 100, 005 BUTTON "&Ok"			SIZE 50,15 OF oDlgCli PIXEL ACTION {|| IF(VLDEXIT(),oDlgCli:End(),MsgInfo("Nrnhum cliene selecionado!")) }
		@ 100, 070 BUTTON "&CANCELAR" 	SIZE 50,15 OF oDlgCli PIXEL ACTION {|| lRet := .F. , oDlgCli:End() }
		
		ACTIVATE DIALOG oDlgCli CENTERED
	EndIF
	
ElseIF !EMPTY(cPedCli)
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	IF SC5->(DbSeek(xFilial("SC5") + cPedCli))
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		IF SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
			lRet := .T.
		EndIF
	EndIF
EndIF

IF lRet
	IF MsgYesno("Cliente localizado : " + ALLTRIM(SA1->A1_NOME))
		oSearch:End()
		U_SYTMOV07(SA1->A1_COD,SA1->A1_LOJA)
	Else
		cCodCli := SPACE(06)
		cLjCli  := SPACE(02)
		oSearch:Refresh()
	EndIF
Else
	MsgAlert("Cliente n�o localizado!!!!")
	cCodCli := SPACE(06)
	cLjCli  := SPACE(02)
	oSearch:Refresh()
EndIF

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VLDCHK   � Autor � LUIZ EDUARDO F.C.  � Data � 04/11/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � VALIDA CHECK BOX                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
STATIC FUNCTION VLDCHK()

For nX := 1 To Len(oBrwCli:AARRAY)
	oBrwCli:AARRAY[nX,1] := .F.
	aNome[nX,1] := .F.
Next

oBrwCli:AARRAY[oBrwCli:nAt,1] := .T.
aNome[oBrwCli:nAt,1] := .T.
oBrwCli:Refresh()

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VLDCHK   � Autor � LUIZ EDUARDO F.C.  � Data � 04/11/2016  ���
�������������������������������������������������������������������������͹��
���Descri��o � VALIDA CHECK BOX                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
STATIC FUNCTION VLDEXIT()

Local lVLDEXIT := .F.

For nX := 1 To Len(oBrwCli:AARRAY)
	IF oBrwCli:AARRAY[nX,1]
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		IF SA1->(DbSeek(xFilial("SA1") + oBrwCli:AARRAY[nX,2] + oBrwCli:AARRAY[nX,3]))
			lVLDEXIT := .T.
		EndIF
		Exit
	EndIF
Next

RETURN(lVLDEXIT)
