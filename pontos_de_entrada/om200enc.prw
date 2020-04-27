#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS200ENC  �Autor  �ALFA	             � Data �  03/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no encerramento da carga, allterar status ���
���          � do pedido de vendas                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OM200ENC()

Local aArea		:= GetArea()
Local oBitmap1
Local oButton1
Local oGet1
Local _cObs := ''
Local oSay1
Static _oDlg

fSXEDAK()  //Arruma a sequencia numerica - #CMG20181029.n


If MsgYesNo("Deseja informar alguma observa��o para a carga?","INFOCARGA")
	
	
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("OBSERVA��O DA CARGA - "+DAK->DAK_COD) FROM 000, 000  TO 330, 365 COLORS 0, 16777215 PIXEL
	
	@ 004, 032 SAY oSay1 PROMPT "OBSERVA��O DA CARGA - "+DAK->DAK_COD SIZE 117, 010 OF _oDlg COLORS 0, 16777215 PIXEL
	@ 018, 006 GET oGet1 VAR _cObs MEMO SIZE 170, 091 OF _oDlg COLORS 0, 16777215 PIXEL
	
	@ 112, 005 BITMAP oBitmap1 SIZE 067, 047 OF _oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
	@ 124, 108 BUTTON oButton1 PROMPT "OK" SIZE 065, 027 OF _oDlg ACTION (fGrava(_cObs),_oDlg:End()) PIXEL
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
EndIf

DbSelectArea("SC9")
DBSETORDER(5)

DBSEEK(XFILIAL("SC9")+DAK->DAK_COD+DAK->DAK_SEQCAR)
While SC9->C9_FILIAL == XFILIAL("SC9") .AND. SC9->C9_CARGA == DAK->DAK_COD .AND. SC9->C9_SEQCAR == DAK->DAK_SEQCAR
	//ATUALI��O DE STATUS DO PEDIDO - TIPO 7 - oSt7 - "BR_AMARELO" "Em separa��o"
	U_SYTMOV15(SC9->C9_PEDIDO, SC9->C9_ITEM,SC9->C9_PRODUTO ,"7")
	
	DbSelectArea("SC9")
	DbSkip()
EndDo

RestArea(aArea)

RETURN()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �fGrava    �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fGrava(_cObs)

MSMM(,TamSx3("DAK_XCODOB")[1],,_cObs,1,,,"DAK","DAK_XCODOB")

Return

/*��������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMOMSF05  � Autor � Caio Garcia        � Data �  29/10/18   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera n�mero sequencial de inclus�o                         ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ʹ��
��� Programador � Data   � Chamado � Motivo da Alteracao                  ���
�������������������������������������������������������������������������ʹ��
���             �        �         �                                      ���
���             �        �         �                                      ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fSXEDAK()

Local _cNum := ''
Local _cAlias       := GetNextAlias()
Local _cQuery := ''
Local _lSai         := .T.
Local _cCodSXE      := ""
Local _cFil         := Subs(cFilAnt,1,2)+"01"
Local _cFilBkp      := cFilAnt

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("DAK") + " DAK "
_cQuery += " WHERE DAK.D_E_L_E_T_ <> '*' "
_cQuery += " ORDER BY DAK_COD DESC "

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

_cNum := Soma1((_cAlias)->DAK_COD)

(_cAlias)->(DbCloseArea())

cFilAnt := _cFil

_cCodSXE := GetSxeNum("DAK","DAK_COD")

While _lSai
	
	If (_cCodSXE > _cNum)
		
		_lSai := .F.
		
	Else
		
		If (_cCodSXE == _cNum)
			
			_lSai := .F.
			
		Else
			
			ConfirmSx8()
			_cCodSXE := GetSxeNum("DAK","DAK_COD")
			
		EndIf
		
	EndIf
	
EndDo

cFilAnt := _cFilBkp

Return()
