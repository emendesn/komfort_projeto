#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMOMSR04  º Autor ³ Caio Garcia        º Data ³  02/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRESSAO DE TERMO RETIRA                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMOMSR04(_cDado)

Local _cLogo 	:= "\system\LOGO_REL.png"
Local oPrint
Local oFnt14	   	:= TFont():New("Times New Roman",,14,,.F.,,,,,.F.,.F.)
Local oFnt14s	   	:= TFont():New("Times New Roman",,14,,.F.,,,,,.T.,.F.)
Local oFnt14n	   	:= TFont():New("Times New Roman",,14,,.T.,,,,,.F.,.F.)
Local oFnt15	   	:= TFont():New("Times New Roman",,15,,.F.,,,,,.F.,.F.)
Local oFnt15n	   	:= TFont():New("Times New Roman",,15,,.T.,,,,,.F.,.F.)
Local oFnt16	   	:= TFont():New("Times New Roman",,16,,.F.,,,,,.F.,.F.)
Local oFnt16n	   	:= TFont():New("Times New Roman",,16,,.T.,,,,,.F.,.F.)
Local oFnt22	   	:= TFont():New("Times New Roman",,22,,.F.,,,,,.F.,.F.)
Local oFnt22n	   	:= TFont():New("Times New Roman",,22,,.T.,,,,,.F.,.F.)
Local oFnt20u	   	:= TFont():New("Times New Roman",,20,,.T.,,,,,.T.,.F.)
Local oFnt24	   	:= TFont():New("Times New Roman",,24,,.F.,,,,,.F.,.F.)
Local oFnt24n	   	:= TFont():New("Times New Roman",,24,,.T.,,,,,.F.,.F.)
Local oFnt28n	   	:= TFont():New("Times New Roman",,28,,.T.,,,,,.F.,.F.)
Local oFnt32n	   	:= TFont():New("Times New Roman",,32,,.T.,,,,,.F.,.F.)
Local oBrush1
Local _nLin         := 0
Local _nAdc         := 0
Local _nx           := 0
Local _lDireto     := .F.

Local _lOk       := .F.
Local _lChama    := .T.
Local _cTit      := "Secione os termos a serem impressos"
Private _aTermo  := {}
Private _oDlg    := Nil
Private _oLbx    := Nil
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )

If ValType(_cDado) == 'C'
	
	_cCodigo := _cDado
		
Else
	
	_lDireto := .T.
	DbSelectArea("ZK0")
	ZK0->(DbSetOrder(1))
	ZK0->(DbGoTo(_cDado))
	
	_cCodigo := ZK0->ZK0_NUMSAC
		
	DbSelectArea("SUD")
	SUD->(DbSetOrder(1))//UD_FILIAL+UD_CODIGO+UD_ITEM
	SUD->(DbGoTop())
	SUD->(DbSeek(xFilial("SUD")+_cCodigo))
	
	aAdd(_aTermo,{.T., SUD->UD_01RETIR, SUD->UD_CODIGO, SUD->UD_ITEM, SUD->UD_PRODUTO,AllTrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_DESC"))} )
	
EndIf

If !_lDireto
	
	DbSelectArea("SUD")
	SUD->(DbSetOrder(1))//UD_FILIAL+UD_CODIGO+UD_ITEM
	SUD->(DbGoTop())
	If !(SUD->(DbSeek(xFilial("SUD")+_cCodigo)))
		Return Nil
	EndIf
	
	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao |
	//+-------------------------------------+
	While SUD->(!Eof()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == _cCodigo
		
		If !Empty(AllTrim(SUD->UD_01RETIR))
			
			aAdd( _aTermo, { .F., SUD->UD_01RETIR, SUD->UD_CODIGO, SUD->UD_ITEM, SUD->UD_PRODUTO,AllTrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_DESC"))} )
			
		EndIf
		
		SUD->(DbSkip())
		
	EndDo
	
	If Len( _aTermo ) == 0
		Aviso( _cTit, "Nao existe dados a consultar", {"Ok"} )
		Return Nil
	Endif
	
	If Len(_aTermo) == 1
		
		_aTermo[1,1] := .T.
		_lChama := .F.
		
	EndIf
	
	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	
	If _lChama
		
		DEFINE MSDIALOG _oDlg TITLE _cTit FROM 0,0 TO 240,500 PIXEL
		
		@ 10,10 LISTBOX _oLbx FIELDS HEADER " ","Nº Termo", "Chamado", "Item", "Produto", "Descrição" SIZE 230,095 OF _oDlg PIXEL ;
		ON dblClick(_aTermo[_oLbx:nAt,1] := !_aTermo[_oLbx:nAt,1],_oLbx:Refresh())
		_oLbx:SetArray( _aTermo )
		_oLbx:bLine := {|| {Iif(_aTermo[_oLbx:nAt,1],oOk,oNo),;
		_aTermo[_oLbx:nAt,2],; //Termo
		_aTermo[_oLbx:nAt,3],;  //Codigo Chamado
		_aTermo[_oLbx:nAt,4],;  //Item
		_aTermo[_oLbx:nAt,5],;  //Produto
		_aTermo[_oLbx:nAt,6]}}  //Descrição
		
		DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION _oDlg:End() ENABLE OF _oDlg
		ACTIVATE MSDIALOG _oDlg CENTER
		
	EndIf
	
EndIf

For _nx := 1 To Len(_aTermo)
	
	If _aTermo[_nx,1]
		
		_lOk := .T.
		
		DbSelectArea("SUC")
		SUC->(DbSetOrder(1))//UC_FILIAL+UC_CODIGO
		SUC->(DbGoTop())
		SUC->(DbSeek(xFilial("SUC")+_cCodigo))
		
		IF!_lDireto
		
   		DbSelectArea("ZK0")
		ZK0->(DbSetOrder(1))//ZK0_FILIAL+ZK0_COD
		ZK0->(DbGoTop())
		ZK0->(DbSeek(xFilial("ZK0")+AllTrim(_aTermo[_nx,2])))
		
		endif
		
		_cPedido := ALLTRIM(ZK0->ZK0_PEDORI)
		
		_cPedido  := SUBSTR(_cPedido,Len(_cPedido)-5,6)
		_cCliente := ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1") + SUC->UC_CHAVE,"A1_NOME"))
		_cCliente += " - CPF/CNPJ: " + ALLTRIM(POSICIONE("SA1",1,XFILIAL("SA1") + SUC->UC_CHAVE,"A1_CGC"))
		_cTermo   := "Num. - " + AllTrim(ZK0->ZK0_COD) + "     Num.Chamado SAC - " + _cCodigo
		_dData    := dDataBase
		_cProduto := "Cod. " + AllTrim(_aTermo[_nx,5]) + " - " + AllTrim(_aTermo[_nx,6])
		_cDefeito := ALLTRIM(ZK0->ZK0_DEFEIT)
		_cObs     := "Autorizado Por: "+ alltrim(ZK0->ZK0_AUTPOR) + " - " + ALLTRIM(ZK0->ZK0_OBSSAC)
		_cOpc     := ALLTRIM(ZK0->ZK0_OPCTP)
		_cDevo    := ALLTRIM(ZK0->ZK0_TPDEV)
		_nLin         := 0
		_nAdc         := 0
		
		If !ExistDir("C:\TERMO_RETIRA")
			
			MakeDir("C:\TERMO_RETIRA")
			
		EndIf
		
		_cDtHr := DToS(DDataBase)+Subs(Time(),1,2)+Subs(Time(),4,2)+Subs(Time(),7,2)
		
		_cNomeArq:="TERMO_RETIRA_"+AllTrim(_aTermo[_nx,2])+_cDtHr+".pdf"
		oPrint:= FWMsPrinter():New(_cNomeArq,6,.T., ,.T., , , , ,.F., , .T., )
		oPrint:SetPortrait()
		oPrint:cPathPDF := "C:\TERMO_RETIRA\"
		oPrint:StartPage()
		
		oBrush1 := TBrush():New( , CLR_BLACK )
		
		oPrint:SayBitMap(0030,1000,_cLogo,0500,0200)
		
		oPrint:FillRect( {250, 150, 260, 2300}, oBrush1 )
		
		oPrint:Say(0380+_nLin,0770,"TERMO DE RETIRADA",oFnt32n,,0)
		
		_nLin := 40
		
		oPrint:Say(0480+_nLin,0150,_cTermo,oFnt16n,,0)
		
		If _cOpc == "1"
			oPrint:Say(0620+_nLin,0150,"TROCA(X)   CANCELAMENTO( )    CONSERTO( )     TJ/PROCON( )",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO( )",oFnt24n,,0)
		ElseIf _cOpc == "2"
			oPrint:Say(0620+_nLin,0150,"TROCA( )   CANCELAMENTO(X)    CONSERTO( )     TJ/PROCON( )",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO( )",oFnt24n,,0)
		ElseIf _cOpc == "3"
			oPrint:Say(0620+_nLin,0150,"TROCA( )   CANCELAMENTO( )    CONSERTO(X)     TJ/PROCON( )",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO( )",oFnt24n,,0)
		ElseIf _cOpc == "4"
			oPrint:Say(0620+_nLin,0150,"TROCA( )   CANCELAMENTO( )    CONSERTO( )     TJ/PROCON(X)",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO( )",oFnt24n,,0)
		ElseIf _cOpc == "5"
			oPrint:Say(0620+_nLin,0150,"TROCA( )   CANCELAMENTO( )    CONSERTO( )     TJ/PROCON( )",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO(X)",oFnt24n,,0)
		Else
			oPrint:Say(0620+_nLin,0150,"TROCA( )   CANCELAMENTO( )    CONSERTO( )     TJ/PROCON( )",oFnt24n,,0)
			oPrint:Say(0700+_nLin,0150,"                                                   EMPRESTIMO( )",oFnt24n,,0)
		EndIf
		
		oPrint:Box(0860+_nLin,0150,1640+_nLin,2300)
		
		_nAdc+=130
		oPrint:Box(0860+_nLin+_nAdc,0150,0860+_nLin+_nAdc,2300)//LINHA
		oPrint:Say(0820+_nLin+_nAdc,160,"PEDIDO Nº.:",oFnt16n,,0)
		oPrint:Say(0820+_nLin+_nAdc,420,_cPedido,oFnt16,,0)
		
		_nAdc+=130
		
		oPrint:Box(0860+_nLin+_nAdc,0150,0860+_nLin+_nAdc,2300)//LINHA
		If _cDevo == "1"
			oPrint:Say(0820+_nLin+_nAdc,160,"DEVOLUÇÃO TOTAL (X)             DEVOLUÇÃO PARCIAL ( )",oFnt16n,,0)
		ElseIf _cDevo == "2"
			oPrint:Say(0820+_nLin+_nAdc,160,"DEVOLUÇÃO TOTAL ( )             DEVOLUÇÃO PARCIAL (X)",oFnt16n,,0)
		Else
			oPrint:Say(0820+_nLin+_nAdc,160,"DEVOLUÇÃO TOTAL ( )             DEVOLUÇÃO PARCIAL ( )",oFnt16n,,0)
		EndIf
		
		_nAdc+=130
		oPrint:Box(0860+_nLin+_nAdc,0150,0860+_nLin+_nAdc,2300)//LINHA
		oPrint:Say(0820+_nLin+_nAdc,160,"CLIENTE:",oFnt16n,,0)
		oPrint:Say(0820+_nLin+_nAdc,380,_cCliente,oFnt15,,0)
		
		_nAdc+=130
		oPrint:Box(0860+_nLin+_nAdc,0150,0860+_nLin+_nAdc,2300)//LINHA
		oPrint:Say(0820+_nLin+_nAdc,160,"PRODUTO:",oFnt16n,,0)
		oPrint:Say(0820+_nLin+_nAdc,400,_cProduto,oFnt15,,0)
		
		_nAdc+=130
		oPrint:Box(0860+_nLin+_nAdc,0150,0860+_nLin+_nAdc,2300)//LINHA
		oPrint:Say(0820+_nLin+_nAdc,160,"MOTIVO:",oFnt16n,,0)
		oPrint:Say(0820+_nLin+_nAdc,370,_cDefeito,oFnt15,,0)
		
		_nAdc+=130
		oPrint:Say(0820+_nLin+_nAdc,160,"OBS:",oFnt16n,,0)
		oPrint:Say(0820+_nLin+_nAdc,280,_cObs,oFnt15,,0)
		
		_nLin := 0
		
		oPrint:Say(1850+_nLin,0950,"*** LEVAR EMBALAGEM ***",oFnt16n,,0)
		
		oPrint:Say(2050+_nLin,0150,"MOTORISTA: RETORNAR COM ESTA VIA ASSINADA E DATADA PELO CLIENTE.",oFnt20u,,0)
		
		oPrint:Say(2450+_nLin,0150,"Data:______________________________________  Ass.:______________________________________________________",oFnt16n,,0)
		
		oPrint:FillRect( {2820, 150, 2830, 2300}, oBrush1 )
		
		oPrint:Say(2890+_nLin,990,"Komfort House Sofás Ltda",oFnt14,,0)
		oPrint:Say(2930+_nLin,890,"Estrada Yae Massumoto, 440 - Cooperativa.",oFnt14,,0)
		oPrint:Say(2970+_nLin,930,"09842-160 - São Bernardo do Campo",oFnt14,,0)
		
		oPrint:EndPage()
		oPrint:Preview()
		
	EndIf
	
Next _nx

If .F.
	
	oPrint:Preview()
	
EndIf


Return Nil