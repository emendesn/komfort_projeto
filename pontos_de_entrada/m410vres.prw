#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410VRES  ºAutor  ³ Cristiam Rossi     º Data ³  23/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E.executado após a confirmação da eliminação de residuos º±±
±±º          ³ do PV e antes do inicio da transação.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL / KOMFORTHOUSE                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410VRES

	Local _cNumPv := SC5->C5_NUM

	u_PPpv(_cNumPv)
	
	//Valida se todos os itens do pv foram eliminado residuo, para estornar a baixa dos Titulos
	vldElimRes(_cNumPv)

Return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} vldElimRes
Description //Validação antes da elininação de residuo
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/12/2018 /*/
//--------------------------------------------------------------
Static Function vldElimRes(_cNumPV)

	Local aArea    := getArea()
	Local aAreaSC5 := SC5->(getArea())
	Local aAreaSC6 := SC6->(getArea())
	Local nQtdPed := 0
	Local nQtdblq := 0

	SC5->( dbSetOrder(1))
	SC5->( dbSeek(xFilial("SC5") + _cNumPV))
	
	SC6->(dbSetOrder(1))			// atualizando o campo C6_XQTD
	SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM, .T. ) )
	while ! SC6->(eof()) .and. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)
		
		if SC6->C6_QTDEMP == 0
			nQtdblq := nQtdblq + 1
		endif

		nQtdPed := nQtdPed + 1
		
		SC6->( dbSkip() )
	end

	if !IsInCallStack('TMKA271')
		if nQtdPed == nQtdblq
			if msgYesNo("Deseja estornar os titulos vinculados ao pedido: "+ SC5->C5_NUM +" ?","Atenção")
				FwMsgRun( ,{|| staticCall(M410STTS,cancBx,SC5->C5_NUM) }, , "Realizando Cancelamento da baixa dos titulos..." )
				MtvCanc(SC5->C5_NUM)
			else
				MtvCanc(SC5->C5_NUM)
			endif
		else
			MsgAlert("Não foi possivel eliminar residuo de todos os itens do Pv: " + SC5->C5_NUM + ".","Atenção")
		endif
	else
		MtvCanc(SC5->C5_NUM)
	endif
	
	restArea(aArea)
	restArea(aAreaSC5)
	restArea(aAreaSC6)

return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} MtvCanc
Description //Rotina para informar o motivo do cancelamento/eliminação de residuo
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/12/2018 /*/
//--------------------------------------------------------------
Static Function MtvCanc(_Pedido)

	Local lok := .T.
	Local oBtnCanc
	Local oBtnConfirm
	Local oCombo
	Local nCombo := 1
	Local oSay
	Local aMotivos := {}
	
	Static oDlgMtvCanc

	dbSelectArea("Z05")
	Z05->(dbSetOrder(1))//Z05_FILIAL, Z05_COD, Z05_DESCRI, R_E_C_N_O_, D_E_L_E_T_
	Z05->(dbGoTop())

	aAdd(aMotivos,"")

	while !eof()

		aAdd(aMotivos,Z05->Z05_DESCRI)

		Z05->(dbSkip())
	end

	Z05->(dbCloseArea())

  	DEFINE MSDIALOG oDlgMtvCanc TITLE "Motivos de cancelamento" FROM 000, 000  TO 120, 400 COLORS 0, 16777215 PIXEL STYLE 128 // STYLE 128 -> Remove o botão [X] da tela

    @ 007, 004 SAY oSay PROMPT "Informe o motivo do cancelamento" SIZE 191, 007 OF oDlgMtvCanc COLORS 0, 16777215 PIXEL
    @ 018, 004 MSCOMBOBOX oCombo VAR nCombo ITEMS aMotivos SIZE 191, 010 OF oDlgMtvCanc COLORS 0, 16777215 PIXEL
    @ 044, 158 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 037, 012 OF oDlgMtvCanc ACTION {|| lOk := GrvMtvCanc(_Pedido,aMotivos[oCombo:nat]) } PIXEL

	oDlgMtvCanc:lEscClose := .F. // Desabilita a tecla ESC do teclado

  	ACTIVATE MSDIALOG oDlgMtvCanc CENTERED

	if !lok
		MtvCanc(SC5->C5_NUM)
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} GrvMtvCanc
Description //Gravação das informações no cabeçalho do pedido de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/12/2018 /*/
//--------------------------------------------------------------
Static Function GrvMtvCanc(_Pedido,cMotivo)

	Local aArea := getArea()
	Local lRet := .F.
	Local cCod := RetCodUsr() //Retorna o Codigo do Usuario
	Local cUser := UsrRetName(cCod)//Retorna o nome do usuario.	
	
	if empty(alltrim(cMotivo))
		alert("Motivo do cancelamento não informado!!!")
		oDlgMtvCanc:end()
		Return lRet
	endif

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))

	dbSelectArea("SC6")
	dbSetOrder(1)//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

	if SC5->(dbSeek(xFilial()+_Pedido))
		recLock("SC5",.F.)
			SC5->C5_XMTVCAN := cMotivo
			SC5->C5_XUSRCAN := cUser
			SC5->C5_XDTCAN := date()
		SC5->(msUnlock())
		
		SC6->(dbSeek( xFilial("SC6") + _Pedido ) )
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == SC5->C5_NUM
			cPV := SC6->C6_NUM
			cProdPV := SC6->C6_PRODUTO
			StaticCall(MYTMKA15, FindPC, cPV, cProdPV)//Limpa o campo C7_01NUMPV, se existir vinculo entre PV e PC.
		SC6->(dbSkip())
		EndDo

		oDlgMtvCanc:end()
		lRet := .T.
	endif
		
	restArea(aArea)

Return lRet