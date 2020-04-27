#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 06/02/2019
/*/
//--------------------------------------------------------------
User Function KMOMSF05()

	Private nServico :=  DAK->DAK_XSERVI
	Private nFrete := DAK->DAK_XVALOR
	Private _cCarga := DAK->DAK_COD
	
	Private cAcesso := superGetmv("KH_BLQFRET",.T.,"000001|000455|000038")
	Private lAcesso := .F.
	Private oButton1
	Private oGet1
	Private oGet2
	Private oGet3
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4

	Private oDlg

If __cuserid $ cAcesso
	
	lAcesso := .T.

EndIf

	DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 300, 470 COLORS 0, 16777215 PIXEL

	@ 016, 086 SAY oSay1 PROMPT "Serviço Adicional " SIZE 049, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 042, 025 SAY oSay2 PROMPT "Valor Serviço Adicional " SIZE 066, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 042, 151 SAY oSay3 PROMPT "Valor Frete Negociado" SIZE 066, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 056, 025 MSGET oGet1 VAR nServico PICTURE "@E 999.99" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 056, 151 MSGET oGet2 VAR nFrete PICTURE "@E 999.99" SIZE 060, 010 WHEN lAcesso OF oDlg  COLORS 0, 16777215 PIXEL
	//oGet2:desable := lAcesso
	@ 096, 096 BUTTON oButton1 PROMPT "Salvar" SIZE 037, 012 OF oDlg ACTION (Vai(nServico,_cCarga),oDlg:End())PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³Vai       ³AUTOR: ³Murilo Zoratti         ³DATA: ³06/02/19  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Estoque/Custos - Komfort House                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Vai(nServico,_cCarga)

	Local _lProcessa := .T.
	Local lSai := .F.

	_lProcessa := fVldCarga(_cCarga)

	If _lProcessa

		If nServico > 0

			lSai := MsgYesNo("Confirma a inclusão do valor de Serviço Adicional + "+AllTrim(Str(nServico))+" na carga "+AllTrim(_cCarga)+ "?")
			If lSai

				DbSelectArea("DAK")
				DAK->(DbSetOrder(1))
				DAK->(DbGoTop())

				DAK->(DbSeek(xFilial("DAK")+_cCarga))

				RecLock("DAK",.F.)
				DAK->DAK_XSERVI := nServico
				DAK->(MsUnLock())

			EndIf
		EndIf

		If nFrete > 0

			lSai := MsgYesNo("Confirma a inclusão do valor de Frete + "+AllTrim(Str(nFrete))+" na carga "+AllTrim(_cCarga)+ "?")
			If lSai

				DbSelectArea("DAK")
				DAK->(DbSetOrder(1))
				DAK->(DbGoTop())

				DAK->(DbSeek(xFilial("DAK")+_cCarga))

				RecLock("DAK",.F.)
				DAK->DAK_XVALOR := nFrete
				DAK->(MsUnLock())

			EndIf
		Endif

	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³fVldCarga  ³AUTOR: ³Caio Garcia           ³DATA: ³08/10/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Estoque/Custos - Komfort House                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVldCarga(_cCarga)

	Local _lRet := .T.
	Local lBlqCar   := ( DAK->(FieldPos("DAK_BLQCAR")) > 0 )
	Local cCplInt   := SuperGetMv("MV_CPLINT",.F.,"2")
	Local lBloqueio := .F.

	DbSelectArea("DAK")
	DAK->(DbSetOrder(1))

	If DAK->(DbSeek(xFilial("DAK")+_cCarga))

		lBloqueio := OsBlqExec(DAK->DAK_COD, DAK->DAK_SEQCAR)
		//Integração OMSxCPL
		If DAK->(ColumnPos("DAK_VIAROT")) > 0
			If !Empty(DAK->DAK_VIAROT) .And. cCplInt == '1'
				Help(" ",1,"OMS200MNTCPL")//Carga gerada pela integração com o Cockpit Logístico, manutenção não permitida.
				_lRet := .F.
			EndIf
		EndIf

		If	GetMV("MV_MANCARG") == "N" .And. DAK->DAK_FEZNF == "1"
			Help(" ",1,"OMS200CFAT") //Esta carga já se encontra faturada.
			_lRet := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Primeiro verifica se a carga selecionada ainda pode ser edit.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(DAK->DAK_JUNTOU) .And. DAK->DAK_JUNTOU != "JUNTOU" .And. DAK->DAK_JUNTOU != "MANUAL" .And. DAK->DAK_JUNTOU != "ASSOCI"
			Help(" ",1,"DS2602141") //A carga selecionada está indisponível para manipulaçães.
			_lRet := .F.
		EndIf

		If DAK->DAK_ACECAR == "1"
			Help(" ",1,"DS2602143") //Retorno de Cargas já realizado, não é possível a ManipulaçÆo desta Carga.
			_lRet := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se existe o campo e se esta bloqueada                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( lBlqCar .And. DAK->DAK_BLQCAR == '1' ) .Or. lBloqueio
			_lRet := .F.
			Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com serviço em execução.
		EndIf

	EndIf

Return _lRet