#include 'protheus.ch'
#include 'parmtype.ch'

user function KMSACG04(_cCHamado)

	Private _cRet := ''
	Private _cPed :=''

	Private _cTit      := "Selecione Um Produto do Chamado: "+_cChamado
	Private _aPrds  := {}
	Private _oDlg    := Nil
	Private _oLbx    := Nil
	Private oOk      := LoadBitmap( GetResources(), "LBOK" )
	Private oNo      := LoadBitmap( GetResources(), "LBNO" )

	Dbselectarea("SUC")
	SUC->(Dbsetorder(1)) //UC_FILIAL+UC_CODIGO
	SUC->(Dbgotop())

	IF SUC->(Dbseek(XFILIAL("SUC")+_cChamado))
		Dbselectarea("SU5")
		SU5->(Dbsetorder(1)) //U5_FILIAL+U5_CODCONT+U5_IDEXC                                                                                                                                             
		SU5->(Dbgotop())

		SU5->(Dbseek(XFILIAL("SU5")+SUC->UC_CODCONT))

		_cPed := STRZERO(VAL(SUBSTR(ALLTRIM(SUC->UC_01PED),LEN(ALLTRIM(SUC->UC_01PED))-5,6)),6)
		M->ZK4_CLI := SU5->U5_CONTAT
		M->ZK4_PED := _cPed
		M->ZK4_CEP  := SU5->U5_CEP
		M->ZK4_REGIAO := fRetCep(SU5->U5_CEP)

		Dbselectarea("SC5")
		SC5->(Dbsetorder(1))
		SC5->(Dbgotop())
		SC5->(Dbseek(XFILIAL("SC5")+_cPed))

		dbSelectArea("SM0")
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+SC5->C5_MSFIL))

		M->ZK4_LOJA := ALLTRIM(SM0->M0_FILIAL)

		//monta tela com produtos
		DbSelectArea("SUD")
		SUD->(DbSetOrder(1))//UD_FILIAL+UD_CODIGO+UD_ITEM
		SUD->(DbGoTop())

		SUD->(DbSeek(xFilial("SUD")+_cChamado))

		While SUD->(!Eof()) .And. AllTrim(SUD->UD_CODIGO) == AllTrim(_cChamado)

			aAdd( _aPrds, { .F., _cChamado, SUD->UD_ITEM, SUD->UD_PRODUTO,AllTrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_DESC"))} )

			SUD->(DbSkip())

		EndDo

		DEFINE MSDIALOG _oDlg TITLE _cTit FROM 0,0 TO 240,500 PIXEL

		@ 10,10 LISTBOX _oLbx FIELDS HEADER " ", "Chamado", "Item", "Produto", "Descrição", "Loja" SIZE 230,095 OF _oDlg PIXEL ON dblClick(_aPrds[_oLbx:nAt,1] := !_aPrds[_oLbx:nAt,1],_oLbx:Refresh())
		_oLbx:SetArray( _aPrds )
		_oLbx:bLine := {|| {Iif(_aPrds[_oLbx:nAt,1],oOk,oNo),;
		_aPrds[_oLbx:nAt,2],;  //Codigo Chamado
		_aPrds[_oLbx:nAt,3],;  //Item
		_aPrds[_oLbx:nAt,4],;  //Produto
		_aPrds[_oLbx:nAt,5]}}  //Descrição

		DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (fVerPrd(_aPrds),_oDlg:End()) ENABLE OF _oDlg
		ACTIVATE MSDIALOG _oDlg CENTER

	ELSE

		Alert("Chamado não encontrado!")

	ENDIF

return _cChamado

Static Function fVerPrd(_aPrds)

	Local _nx := 0

	For _nx := 1 To Len(_aPrds)

		If _aPrds[_nx,1]

			M->ZK4_PROD   := _aPrds[_nx,4]
			M->ZK4_DESCPR := _aPrds[_nx,5]

		EndIf
	Next _nx

Return

static function fRetCep(_cCep)

	Local cAlias := getNextAlias()
	Local cQuery := ""
	Local cReg := ''

	cQuery := "SELECT * FROM DA7010 WHERE DA7_CEPDE <= '"+_cCep+"' AND DA7_CEPATE >= '"+_cCep+"'"

	PLSQuery(cQuery, cAlias)
	Dbselectarea(cAlias)
	(cAlias)->(Dbgotop())

	if (cAlias)->(!eof())
		cReg := (cAlias)->DA7_PERCUR
	endif

	(cAlias)->(dbCloseArea())

Return(cReg)
