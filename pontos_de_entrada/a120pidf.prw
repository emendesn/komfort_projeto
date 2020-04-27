#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ı�
���Funcao �A120PIDF      � Autor � Marcio Nunes           � Data �01/10/19 ��
��������������������������������������������������������������������������ı�
���Descricao � Ponto de Entrada no pedido de compras que filtra as solici- ��
���          � tacoes de compras, atraves da funcao startada pela tecla F4.��
��������������������������������������������������������������������������ı�
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.              ��
��������������������������������������������������������������������������ı�
���Programador � Data   � BOPS �  Motivo da Alteracao                      ��
��������������������������������������������������������������������������ı�
��� Rotina alterada para atender a solicita��o de comrpas das lojas e      ��
��� F�brica - Marcio Nunes   											   ��
���            �        �      �                                           ��
���            �        �      �                                           ��
���            �        �      �                                           ��
��������������������������������������������������������������������������ı�
���������������������������������������������������������������������������*/
User Function A120PIDF()

	Local _aFilter := {}
	Local _lFilFab := .F.
	Local _lFilLoj := .F.
	Local _cTit    := "Filtro de solicita��es de compras"
	Local _nx      := 0

	Private _aFiltro  := {}
	Private _oDlg     := Nil
	Private _oLbx     := Nil
	Private oOk       := LoadBitmap( GetResources(), "LBOK" )
	Private oNo       := LoadBitmap( GetResources(), "LBNO" )		

	aAdd( _aFiltro, { .T., "F�brica"} )
	aAdd( _aFiltro, { .F., "Lojas"} )
	
	DEFINE MSDIALOG _oDlg TITLE _cTit FROM 0,0 TO 240,500 PIXEL

	@ 10,10 LISTBOX _oLbx FIELDS HEADER " ","Filtro" SIZE 230,095 OF _oDlg PIXEL ;
	ON dblClick(_aFiltro[_oLbx:nAt,1] := !_aFiltro[_oLbx:nAt,1],_oLbx:Refresh())
	_oLbx:SetArray( _aFiltro )
	_oLbx:bLine := {|| {Iif(_aFiltro[_oLbx:nAt,1],oOk,oNo),;
	_aFiltro[_oLbx:nAt,2] }}  

	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION _oDlg:End() ENABLE OF _oDlg
	ACTIVATE MSDIALOG _oDlg CENTER

	_aFilter := {" C1_QUJE <> C1_QUANT ",+;
	" C1_QUJE <> C1_QUANT "}

	For _nx := 1 To Len(_aFiltro)

		If _aFiltro[_nx,1]

			If _nx == 1	
				_lFilFab := .T.
			ElseIf _nx == 2
				_lFilLoj := .T.			
			EndIf

		EndIf

	Next _nx


	If _lFilFab  //Solicita��o da F�brica

		_aFilter := {" C1_XAREA == '1' .and. C1_APROV == 'L' "}//filtra pedidos de compras liberados - Marcio Nunes 23/10/2019 	   

	ElseIf _lFilLoj //Solicita��o das Lojas
		                                      
		_aFilter := {" C1_XAREA = '2' "}  	

	EndIf

RETURN(_aFilter)
