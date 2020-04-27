#Include "Protheus.ch"
         
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �KMOMSF02  �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMOMSF02()   

Local aArea		:= GetArea()
Local oBitmap1
Local oButton1
Local oGet1
Local _cObs := ''
Local oSay1
Static _oDlg

_cObs := MSMM(DAK->DAK_XCODOB,TamSx3("DAK_XCODOB")[1],,,3)

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("OBSERVA��O DA CARGA - "+DAK->DAK_COD) FROM 000, 000  TO 330, 365 COLORS 0, 16777215 PIXEL

@ 004, 032 SAY oSay1 PROMPT "OBSERVA��O DA CARGA - "+DAK->DAK_COD SIZE 117, 010 OF _oDlg COLORS 0, 16777215 PIXEL
@ 018, 006 GET oGet1 VAR _cObs MEMO SIZE 170, 091 OF _oDlg COLORS 0, 16777215 PIXEL

@ 112, 005 BITMAP oBitmap1 SIZE 067, 047 OF _oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
@ 124, 108 BUTTON oButton1 PROMPT "OK" SIZE 065, 027 OF _oDlg ACTION (fGrava(_cObs),_oDlg:End()) PIXEL

ACTIVATE MSDIALOG _oDlg CENTERED

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

Return
