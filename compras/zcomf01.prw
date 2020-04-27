#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ZCOMF01     ³ Autor ³ Caio Garcia        ³ Data ³ 20.06.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina alteração de data de entrega                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Komfort House                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ZCOMF01()


Local _cPerg := "ZCOMF01"
Local _cPC        := SC7->C7_NUM
Local _cAlias     := GetNextAlias()
Local _cTitulo    := "Selecione os itens para alterar a data"
Local lMark       := .F.
Local lChk        := .F.
Local _dDataAtu   := Date()

Private oDlg,oLbx
Private _aVetor   := {}
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )
Private _lRet     := .F.

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

FCRIASX1(_cPerg)
If Pergunte(_cPerg,.T.)
	
	If !(MV_PAR01 < _dDataAtu)
		
		_cQuery := " SELECT * FROM "
		_cQuery += RetSQLName("SC7")
		_cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND  "
		_cQuery += " C7_NUM = '"+_cPC+"' AND C7_ENCER = ' ' AND"
		_cQuery += " D_E_L_E_T_ <> '*'"
		_cQuery := ChangeQuery(_cQuery)
		
		If (Select(_cAlias) <> 0)
			DbSelectArea(_cAlias)
			(_cAlias)->(DbCloseArea())
		Endif
		dbUseArea( .T.,"TOPCONN", TCGENQRY(,,_cQuery),_cAlias, .F.)
		
		MEMOWRITE("ZCOMF01.sql",_cQuery)
		
		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())
		
		While (_cAlias)->(!Eof())
			
			aAdd( _aVetor,  {.F.,(_cAlias)->C7_NUM, (_cAlias)->C7_ITEM, (_cAlias)->C7_PRODUTO,SubsTr((_cAlias)->C7_DESCRI,1,20),(_cAlias)->C7_QUANT,;
			(_cAlias)->C7_PRECO,(_cAlias)->C7_TOTAL,DtoC(StoD((_cAlias)->C7_DATPRF)),(_cAlias)->C7_01NUMPV}) //#WRP20180810.n
			
			(_cAlias)->(DbSkip())
			
		EndDo
		
		If Len(_aVetor) > 0
			
			DEFINE MSDIALOG oDlg TITLE _cTitulo FROM 0,0 TO 500,900 PIXEL
			
			@ 020,005 LISTBOX oLbx VAR cVar FIELDS HEADER ;
			" ", "Pedido", "Item","Produto", "Descrição", "Quant.","Preço","Total","Data Entrega";
			SIZE 430,210 OF oDlg PIXEL ON dblClick(_aVetor[oLbx:nAt,1] := !_aVetor[oLbx:nAt,1],oLbx:Refresh())
			
			oLbx:SetArray(_aVetor )
			oLbx:bLine := {|| {Iif(_aVetor[oLbx:nAt,1],oOk,oNo),;
			_aVetor[oLbx:nAt,2],; //Pedido
			_aVetor[oLbx:nAt,3],; //Item
			_aVetor[oLbx:nAt,4],; //Cod
			_aVetor[oLbx:nAt,5],; //Desc
			Transform(_aVetor[oLbx:nAt,6], "@E 999,999.9999"),; //Qtd
			Transform(_aVetor[oLbx:nAt,7], "@E 999,999.99"),; //Preço
			Transform(_aVetor[oLbx:nAt,8], "@E 999,999.99"),; //Total
			_aVetor[oLbx:nAt,9]}}//Data
			
			
			@ 233,320 BmpButton Type 1 Action fAltera()
			@ 233,370 BmpButton Type 2 Action Cancela()			
			@ 233,280 BUTTON oButton4 PROMPT "Inverte"  SIZE 025, 013 ACTION Inverte() PIXEL Of oDlg			

			Activate Dialog oDlg CENTER valid Cancela()
			
			If !_lRet
				
				Close(oDlg)
				
			EndIf
			
			(_cAlias)->(DbCloseArea())
			
		EndIf
		
	Else
		
		MsgStop("Data informada não pode ser menor que a data atual!","DATA MENOR")
		
	EndIf
	
Else
	
	Alert("Rotina cancelada pelo usuário")
	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Marca       ³ Autor ³ Caio Garcia        ³ Data ³ 08.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Marca(lMarca)

Local i := 0

For i := 1 To Len(_aVetor)
	
	_aVetor[i][1] := lMarca
	
Next i

oLbx:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fEstorna    ³ Autor ³ Caio Garcia        ³ Data ³ 08.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAltera()

Local _lC   :=.F.
Local _lSel := .F.
//#WRP20180810.bn
DbSelectArea("SC6")
SC6->(DbSetOrder(2))//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM                                                                                                                             
SC6->(DBGoTop())
//#WRP20180810.en
DbSelectArea("SC7")
SC7->(DbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
SC7->(DbGoTop())

For _n:=1 To Len(_aVetor)
	
	If _aVetor[_n,1]
		
		_lSel := .T.
		_lRet :=.T.
		
		If SC7->(DbSeek(xFilial("SC7")+_aVetor[_n,2]+_aVetor[_n,3]+Space(4)))
			
			RecLock("SC7",.F.)
			
			SC7->C7_DATPRF := MV_PAR01
			
			SC7->(MsUnLock())
			
		EndIf
		//#WRP20180810.bn
		If (!empty(AllTrim(_aVetor[_n, 10])))
			
		If SC6->(DbSeek(xFilial("SC6")+_aVetor[_n,4]+_aVetor[_n,10]))
			RecLock("SC6",.F.)
			SC6->C6_XDTFORN := MV_PAR01
			SC6->(MsUnlock())
		EndIf
		
		
		EndIf
		//#WRP20180810.en
		
	EndIf
	
Next _n

If _lSel
	
	Close(oDlg)
	
Else
	
	MsgStop("Nenhum item foi selecionado, selecione ao menos um item!","ITEM PC NÃO SELECIONADO!!")
	
EndIf


SC7->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Cancela     ³ Autor ³ Caio Garcia        ³ Data ³ 08.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cancela()

If !_lRet
	
	If MsgYesNo("Confirma o cancelamento da rotina?","ATENÇÃO!!")
		
		Close(oDlg)
		
		_lRet := .T.
		
	EndIf
	
EndIf

Return(_lRet)
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Inverte     ³ Autor ³ Caio Garcia        ³ Data ³ 08.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Inverte()

Local _nx := 0

For _nx := 1 To Len(_aVetor)
    
    If _aVetor[_nx,1] 
    
	    _aVetor[_nx,1] := .F.
	    
	Else 
	
		_aVetor[_nx,1] := .T.
	
	EndIf	    
        
Next _nx

oLbx:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1  ³ Autor ³Katia Cilene Cruz Bugov³ Data ³ 16/10/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CtpEst08                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FCRIASX1(_cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{_cPerg,"01","Inf. a Data Entrega Desejada","MV_CH1","D",8,0,"G","MV_PAR01","","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 To Len(aRegs)
	
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with aRegs[_i,01]
		Replace X1_ORDEM   with aRegs[_i,02]
		Replace X1_PERGUNT with aRegs[_i,03]
		Replace X1_VARIAVL with aRegs[_i,04]
		Replace X1_TIPO    with aRegs[_i,05]
		Replace X1_TAMANHO with aRegs[_i,06]
		Replace X1_PRESEL  with aRegs[_i,07]
		Replace X1_GSC     with aRegs[_i,08]
		Replace X1_VAR01   with aRegs[_i,09]
		Replace X1_F3      with aRegs[_i,10]
		Replace X1_DEF01   with aRegs[_i,11]
		Replace X1_DEF02   with aRegs[_i,12]
		Replace X1_DEF03   with aRegs[_i,13]
		Replace X1_DEF04   with aRegs[_i,14]
		Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
	
Next _i

RestArea(_aArea)

Return
