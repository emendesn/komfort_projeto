#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFATG02   �Autor  �Caio Garcia         � Data �  17/01/18  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa valida o desconto dado no pedido e pede senha     ���
���          � de autoriza��o.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KMFATG02(_cCampo,_lPorc)

Local _nPRUNIT := 0
Local _nVALOR  := 0
Private _lSai    := .F.
Private _cSenha  := Space(20) 
Private _lMostr := GETNEWPAR("KH_MOSTRUA", .T.)
Private _cYesNo   := GETNEWPAR("KH_DESYORN",'S')
Private _cSenSup  := GETNEWPAR("KH_DESSENH",'kh@2018')
Private _nDescMax := GETNEWPAR("KH_DESMAXI",70)
Private _nDescPor := 0
Private _nDescVal := 0
Private _lSenha  := .F.
Private _lValida := .F.
Static oDlg, oBitmap1

If !_cCampo $ 'SC5|SUA'
	
	If _cYesNo == 'S'
		
		_lValida := .T.
		
	EndIf
	
	If _lPorc//Campo Porcentagem
		
		If &(M->(_cCampo)) > 0
			
			_nDescPor := &(M->(_cCampo))
			
		EndIf
		
	Else
		
		_nPos := Ascan(aHeader,{|x|Alltrim(X[2])==_cCampo})
		
		_nDescPor := Acols[n,_nPos]
		
	EndIf
	
	If !(_nDescPor > _nDescMax) //Desconto maximo vai para WF
		
		_lValida := .F.
		
	EndIf
	
EndIf

If _lValida
	
	//���������������������������������������������������������������������Ŀ
	//� Criacao da Interface                                                �
	//�����������������������������������������������������������������������
	@ 125,81 To 322,504 Dialog oDlg Title OemToAnsi("LIBERA��O DE DESCONTO")
	@ 8,6 To 88,151
	@ 14,13 Say OemToAnsi("Digite a senha para libera��o do desconto:") Size 125,13
	@ 29,13 Get _cSenha PASSWORD Size 80,14
	@ 18,158 Button OemToAnsi("Confirma") Size 46,24 Action Vai(_cSenha)
	@ 63,162 Button OemToAnsi("Sair") Size 36,16 Action Cancela()
	@ 47,13 BITMAP oBitmap1 SIZE 075, 057 OF oDlg FILENAME "\system\logo.png" NOBORDER PIXEL Of oDlg
	
	If _lSai == .F.
		
		Activate Dialog oDlg CENTER //valid Cancela()
		
	Else
		
		Close(oDlg)
		
	EndIf
	
Else
	
	_lSenha := .T.
	
EndIf

Return(_lSenha)
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cancela   �Autor  �Global GCS          � Data �  07/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o a Dialog pode ser finalizada.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Invel                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Cancela()

_lSai := .T.

Close(oDlg)

Return( _lSai )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vai       �Autor  �Global GCS          � Data �  07/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o usu�rio digitou os n�meros                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Invel                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Vai(_cSenha)

If AllTrim(_cSenha) == ""
	
	MsgInfo("Nenhuma senha foi digitada","NOSENHA")
	
	_lSai := .T.
	
	Close(oDlg)
	
Else
	
	If AllTrim(_cSenSup) == AllTrim(_cSenha)
		
		_lSai := .T.
		
		_lSenha := .T.
		
		//		MsgInfo("Desconto Liberado!","OKSENHA")
		
		If _lSai == .T.
			
			Close(oDlg)
			
		EndIf
		
	Else
		
		MsgStop("Senha incorreta!","ERROSENHA")
		
	EndIf
	
EndIf

Return
