#include "TOTVS.CH"
#include "PROTHEUS.CH"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFATA01  �Autor  �Caio Garcia         � Data �  18/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para alterar par�metros do desconto               ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������ʹ��
��� Programador            � Data   � Chamado � Motivo da Alteracao       ���
�������������������������������������������������������������������������ʹ��
���                        �        �         �                           ���
���                        �        �         �                           ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMFATA01()
                     
Local _cCodUsr   := AllTrim(RetCodUsr())
Local _cPermi   := GetMv("KH_USRALTS")
Local _cYesNo := GETNEWPAR("KH_DESYORN", 'S')
Local _cSenh  := GETNEWPAR("KH_DESSENH", 'kh@2018')
Local _lMostr := GETNEWPAR("KH_MOSTRUA", .T.)
Private _cFilial := ''
Private _aOptions:={'Exigir senha desconto','Alterar senha de desconto loja','Exigir senha mostruario'}
Private _oDlg, _oRadio, _oBitmap1, _nRadio:=1
Private _lSai := .F. 

If !(_cCodUsr $ _cPermi)
		MsgStop("Voc� nao tem permissao para acessar essa rotina!", "NOPERMISSA")
		Return()
Endif                 

_cFilial := AllTrim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL"))

DEFINE MSDIALOG _oDlg FROM 0,0 TO 250,400 PIXEL TITLE "PAR�METROS SENHA DE DESCONTO - "+_cFilial
@ 8,6 Say OemToAnsi("Selecione a op��o que deseja alterar:") Size 125,13
@ 18,6 To 80,130
_oRadio:= tRadMenu():New(25,10,_aOptions,;
{|u|if(PCount()>0,_nRadio:=u,_nRadio)},;
_oDlg,,,,,,,,100,20,,,,.T.)
@ 85,10 BITMAP _oBitmap1 SIZE 075, 057 OF _oDlg FILENAME "\system\logo.png" NOBORDER PIXEL Of _oDlg
@ 18,140 BUTTON OemToAnsi("Confirma") Size 46,24 ACTION Vai(_nRadio)
@ 63,144 BUTTON OemToAnsi("Sair") Size 36,16 ACTION Cancela()

If _lSai == .F.
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
Else
	
	Close(_oDlg)
	
EndIf

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cancela   �Autor  �Caio Garcia         � Data �  22/01/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o a Dialog pode ser finalizada.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Cancela()

_lSai := .T.

Close(_oDlg)

Return( _lSai )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vai       �Autor  �Caio Garcia         � Data �  22/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o usu�rio digitou a senha correta              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Vai(_nRadio)

If _nRadio == 1 //necessidade senha
	
	_lSai := fAltNec()
	                 
	If _lSai
	
		Close(_oDlg)
		
	EndIf	
	
ElseIf _nRadio == 2 //Trocar Senha
	
	_lSai := fAltSen()
   
	If _lSai
	
		Close(_oDlg)
		
	EndIf	                      
	
ElseIf _nRadio == 3 //Exigir senha mostruario	
	                              
	_lSai := fAltMos()
   
	If _lSai
	
		Close(_oDlg)
		
	EndIf	                      
	
EndIf

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fConfirma   Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fAltNec()
                            
Local _lRet         := .F.
Private _aCombo	    := {}
Private _cCombo     := ""
Private _oCombo, _oDlg2

DEFINE MSDIALOG _oDlg2 TITLE "ALTERA NECESSIDADE SENHA - "+_cFilial FROM 0,0 TO 130,400 pixel

aAdd( _aCombo, "1 - Sim" )
aAdd( _aCombo, "2 - N�o" )

@ 8,8 Say OemToAnsi("Existe necessidade senha de desconto para a loja "+_cFilial+"?")
@ 20,8 COMBOBOX _oCombo VAR _cCombo ITEMS _aCombo SIZE 120,10 PIXEL OF _oDlg2
@ 40,8 BmpButton Type 1 Action _lRet := fConfNec()
@ 40,60 BmpButton Type 2 Action _oDlg2:End()

ACTIVATE MSDIALOG _oDlg2 CENTER

Return _lRet

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fConfNec    Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fConfNec()

Local _cOpc := SubsTr(AllTrim(_cCombo),1,1)

If _cOpc == "1"

	PUTMV("KH_DESYORN", "S")	
	
ElseIf _cOpc == "2"             

	PUTMV("KH_DESYORN", "N")	

EndIf

Close(_oDlg2)
_oDlg2:End()

Return .T.                  
  
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fAltSen   Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fAltSen()//

Local _lRet  := .F.
Local  _cSenha  := Space(20)

@ 125,81 To 280,500 Dialog _oDlg3 Title OemToAnsi("ALTERA SENHA LOJA "+_cFilial)
@ 8,6 To 68,151
@ 24,13 Say OemToAnsi("Informe a nova senha de libera��o de desconto:") Size 125,13
@ 39,13 Get _cSenha Picture PASSWORD Size 80,14
@ 15,162 Button OemToAnsi("Confirma") Size 36,16 Action _lRet := fAlter(AllTrim(_cSenha))
@ 45,162 Button OemToAnsi("Ver Senha") Size 36,16 Action MsgInfo(AllTrim(_cSenha),"VERSENHA")

Activate Dialog _oDlg3 CENTER
    
Return _lRet
                                                                 
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fAlter      Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fAlter(_cSenha)

PUTMV("KH_DESSENH", _cSenha)	

Close(_oDlg3)
_oDlg3:End()

Return .T.                  

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fAltMos   Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fAltMos()
                            
Local _lRet         := .F.
Private _aCombo	    := {}
Private _cCombo     := ""
Private _oCombo, _oDlg4

DEFINE MSDIALOG _oDlg4 TITLE "EXIGI SENHA MOSTRUARIO - "+_cFilial FROM 0,0 TO 130,400 pixel

aAdd( _aCombo, "1 - Sim" )
aAdd( _aCombo, "2 - N�o" )

@ 8,8 Say OemToAnsi("Existe necessidade senha de mostruario para a loja "+_cFilial+"?")
@ 20,8 COMBOBOX _oCombo VAR _cCombo ITEMS _aCombo SIZE 120,10 PIXEL OF _oDlg4
@ 40,8 BmpButton Type 1 Action _lRet := fConfMOS()
@ 40,60 BmpButton Type 2 Action _oDlg4:End()

ACTIVATE MSDIALOG _oDlg4 CENTER

Return _lRet

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � fConfMOS    Autor � Caio Garcia          � Data � 24-03-2017 ���
���������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function fConfMOS()

Local _cOpc := SubsTr(AllTrim(_cCombo),1,1)

If _cOpc == "1"

	PUTMV("KH_MOSTRUA", .T.)	
	
ElseIf _cOpc == "2"             

	PUTMV("KH_MOSTRUA", .F.)	

EndIf

Close(_oDlg4)
_oDlg4:End()

Return .T.                  
