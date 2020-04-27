#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ±±
±±³Funcao ³A120PIDF      ³ Autor ³ Marcio Nunes           ³ Data ³01/10/19 ±±
±±ÃÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ±±
±±³Descricao ³ Ponto de Entrada no pedido de compras que filtra as solici- ±±
±±³          ³ tacoes de compras, atraves da funcao startada pela tecla F4.±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±³ Rotina alterada para atender a solicitação de comrpas das lojas e      ±±
±±³ Fábrica - Marcio Nunes   											   ±±
±±³            ³        ³      ³                                           ±±
±±³            ³        ³      ³                                           ±±
±±³            ³        ³      ³                                           ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A120PIDF()

	Local _aFilter := {}
	Local _lFilFab := .F.
	Local _lFilLoj := .F.
	Local _cTit    := "Filtro de solicitações de compras"
	Local _nx      := 0

	Private _aFiltro  := {}
	Private _oDlg     := Nil
	Private _oLbx     := Nil
	Private oOk       := LoadBitmap( GetResources(), "LBOK" )
	Private oNo       := LoadBitmap( GetResources(), "LBNO" )		

	aAdd( _aFiltro, { .T., "Fábrica"} )
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


	If _lFilFab  //Solicitação da Fábrica

		_aFilter := {" C1_XAREA == '1' .and. C1_APROV == 'L' "}//filtra pedidos de compras liberados - Marcio Nunes 23/10/2019 	   

	ElseIf _lFilLoj //Solicitação das Lojas
		                                      
		_aFilter := {" C1_XAREA = '2' "}  	

	EndIf

RETURN(_aFilter)
