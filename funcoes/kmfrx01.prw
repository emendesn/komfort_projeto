#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FwBrowse.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบ Programa ณ KMFRX01  บ Autor ณ Murilo Swistlski   บ Data ณ  13/05/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao complementar da rotina dvfra01, que retorna uma       บฑฑ
ฑฑบ          ณ expressao SQL ou Advpl conforme ultimo parametro.            บฑฑ
ฑฑบ          ณ Utilizada para clausula WHERE com os filtros da tabela Z04   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cEntAl  - Alias do cabecalho                                 บฑฑ
ฑฑบ          ณ cChave  - Conteudo da chave primaria                         บฑฑ
ฑฑบ          ณ cGridAl - Alias do grid (tabela a ser filtrada)              บฑฑ
ฑฑบ          ณ lAdvpl  - .T. retorna expressao Advpl | .F. retorna SQL      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ferramentas DOVAC - TI                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRX01( _cEntAl , _cChave , _cGridAl , _lAdvpl, _cField) //u_KMFRX01( "QAA" , "0101002220" , "SB1" , .T. )
	Local aArea      := GetArea()
	Local aAreaSX3   := (dbSelectArea("SX3"),SX3->(getArea()))
	Local _cFiltro	 := ""
	Local _cQuery	 := ""
	Local _cAlias	 := GetNextAlias()
	Local _nAux		 := 0
	Local _cConteudo := ""
	Local aField     := {}
	Local nx,nxt,aTam

	Private cField
	Default	_lAdvpl		:= .F.

	if !Empty(__cUserId)
		_cQuery := " SELECT Z04_FIELD, Z04_CONTEU "
		_cQuery += " FROM " + RetSqlName("Z04")
		_cQuery += " WHERE D_E_L_E_T_ <> '*'"
		_cQuery += "   AND Z04_FILIAL  = '" + xFilial("Z04") + "'"
		_cQuery += "   AND Z04_ENTFIL  = '" + xFilial( Alltrim( _cEntAl  )) + "'"
		_cQuery += "   AND Z04_FILGRD  = '" + xFilial( Alltrim( _cGridAl )) + "'"
		_cQuery += "   AND Z04_ENTALI = '" +    Padr( _cEntAl , TamSx3("Z04_ENTALI")[1]) + "'"
		_cQuery += "   AND Z04_ALIAS   = '" +    Padr( _cGridAl, TamSx3("Z04_ALIAS")[1]  ) + "'"
		_cQuery += "   AND Z04_ENTPK   = '" +    Padr( _cChave , TamSx3("Z04_ENTPK")[1]  ) + "'"		
		if !Empty(_cField)
			_cQuery += " AND TRIM(Z04_FIELD) = '"+ UPPER( ALLTRIM( _cField ) ) +"'"
		endif
		_cQuery += " ORDER BY Z04_FIELD "
		
		MEMOWRITE("KMFRX01_01.SQL",_cQuery)
		
 		dbUseArea( .T. , "TOPCONN" , TCGENQRY(,, _cQuery ) , _cAlias , .F. , .T. )
			
		while !(_cAlias)->(eof())			
			cField := padr((_cAlias)->Z04_FIELD,10)
			nx := aScan( aField, {|x| x[1] == cField } )			
			if nx > 0				
				aTam := TamSx3(cField)				
				if ValType(aTam) == "A"
					aField[nx,2] += "|"+padr((_cAlias)->Z04_CONTEU,aTam[1])
				endif				
			else				
				aTam := TamSx3(cField)
				if ValType(aTam) == "A"
					aadd(aField, { cField, padr((_cAlias)->Z04_CONTEU,aTam[1]) })
				endif				
			endif		
			(_cAlias)->(dbSkip())
		enddo	
		dbCloseArea(_cAlias)

		dbSelectArea('SX3')
		dbSetOrder(2)

		_cFiltro	:= ""

		nxt := Len(aField)	
		for nx := 1 to nxt	
			If SX3->( dbSeek( aField[nx,1] ))				
				If _nAux > 0
					_cFiltro += IIF( _lAdvpl , " .AND. " , "  AND  " )
				EndIf				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Conteudo			ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cConteudo := aField[nx,2]

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Campo   			ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cCampo := Alltrim( aField[nx,1] )				
				If _lAdvpl
					If SX3->X3_TIPO == "N"
						_cCampo := " cValToChar(" + _cGridAl + "->" + _cCampo + ") "
					EndIf
					If SX3->X3_TIPO == "D"
						_cCampo := " DTOS(" + _cGridAl + "->" + _cCampo + ") "
					EndIf
				else
					If SX3->X3_TIPO == "N"
						_cCampo := " to_char("+_cCampo+") "
					EndIf
				EndIf				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Retorno de Filtroณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cFiltro += _cCampo
				_cFiltro += IIF( _lAdvpl , " $ " , " IN (" ) + "'"
				_cFiltro += IIF( _lAdvpl , _cConteudo , Replace( _cConteudo , "|", "','" ))
				_cFiltro += IIF( _lAdvpl , "'" , "')" )				
				_nAux++				
			EndIf			
		next		
	endif
	if Empty(__cUserId)
		If _lAdvpl
			_cFiltro := " .T. "
		Else
			_cFiltro := " 1 = 1 "
		EndIf
	ElseIf Empty(_cFiltro)
		If _lAdvpl
			_cFiltro := " .F. "
		Else
			_cFiltro := " 1 = 2 "
		EndIf
	EndIf		
	RestArea(aAreaSX3)
	RestArea(aArea)		
Return _cFiltro

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบ Programa ณ KMFRX01B บ Autor ณ Murilo Swistalski  บ Data ณ   15/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Consulta especifica com filtro para o Campo C7_PRODUTO		   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - Se usuario escolheu ou nao o produto na consulta especบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ferramentas DOVAC - TI										      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRX01B()
	Local cQuery	:= ""
	Local cFiltro	:= "" //Filtro principal
	Local cFiltro1	:= "" //Filtro Produto x Usuarios ( SB1 x QAA )
	Local cFiltro2	:= "" //Filtro Produto x Pedidos  ( SB1 x SZD )
	Local lRet		:= .F.

	cFiltro1 := u_KMFRX01( "QAA" , POSICIONE( "QAA" , 6 , Upper(cUserName) , "QAA_MAT" ) , "SB1" , .T. )

	if FUNNAME()$"MATA121/MATA122" .AND. INCLUI
		cTpPedOK := U_DV02P04G("cTpPed")
	elseif FUNNAME()$"MATA121/MATA122" .AND. !INCLUI
		cTpPedOK := U_DV02A03G("cTpPed")
	endif

	if Type("cTpPedOK") = "C" .AND. !Empty(cTpPedOK)
		cFiltro2 := u_KMFRX01( "SZD" , /*IIF( INCLUI ,*/ cTpPedOK /*, SC7->C7_TPPED )*/, "SB1" , .T. )
	else
		cFiltro2 := ".T."
	endif

	If !Empty(cFiltro1)
		cFiltro += cFiltro1
	EndIf
	If !Empty(cFiltro2)
		If Empty(cFiltro)
			cFiltro += cFiltro2
		Else
			cFiltro += " .AND. " + cFiltro2
		EndIf
	EndIf
	//Se o usuario nao tiver um dos filtros cadastrados, nao permitir utilizar (Solicitado pelo Wilson - 19/05/2014)
	If Empty(cFiltro1) .or. Empty(cFiltro2)
		lRet := .F.
		MsgStop( OemToAnsi("Usuแrio sem filtro cadastrado - " + IIF( Empty(cFiltro1) , "'Produto'" , "'Pedido'" )) , "Acesso Negado" )
		SB1->( dbGoto(-1) )
	Else
		lRet := u_KMFRX01C( "SB1" , cFiltro )
	EndIf		
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบ Programa ณ KMFRX01C บ Autor ณ Murilo Swistalski  บ Data ณ   17/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao da Consulta especifica 							       	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ferramentas DOVAC - TI										      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRX01C( cAlias , cFiltro )
	Local oDlgB1Z04
	Local oBrowse
	Local oColumn
	Local aColumn := {}
	Private lRet := .F.

	SX3->( dbSetOrder(1) ) //X3_ARQUIVO+X3_ORDEM
	SX3->( dbGoTop() )
	SX3->( dbSeek(cAlias + "01") )	
	While !SX3->( EOF() ) .and. SX3->X3_ARQUIVO == cAlias		
		If SX3->X3_BROWSE == 'S' .AND. SX3->X3_CONTEXT == "R"
			aAdd ( aColumn , { SX3->X3_CAMPO , SX3->X3_TITULO , SX3->X3_TAMANHO } )
		EndIf		
		SX3->( dbSkip() )
	End

	DEFINE MSDIALOG oDlgB1Z04 FROM 0,0 TO 600,900 PIXEL			 // Define a janela do Browse
	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS cAlias OF oDlgB1Z04  // Define o Browse

	For i := 1 to Len( aColumn ) //IIF( Len( aColumn ) > 10 , 10 , Len( aColumn ) )
		ADD COLUMN oColumn DATA &( "{ || " + aColumn[i][1] + " } ") TITLE aColumn[i][2] SIZE aColumn[i][3] OF oBrowse
	Next

	dbSelectArea( cAlias )

	oBrowse:SetFilterDefault( cFiltro ) //oBrowse:SetUseFilter()
	oBrowse:DisableConfig()
	oBrowse:DisableReport()
	oBrowse:SetDoubleClick({|| oDlgB1Z04:End() , lRet := .T. })

	ACTIVATE FWBROWSE oBrowse	// Ativa็ใo do Browse
	ACTIVATE MSDIALOG oDlgB1Z04 CENTERED // Ativa็ใo do janela

	//RestArea(aArea)
Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบ Programa ณ KMFRX01C บ Autor ณ Murilo Swistalski  บ Data ณ   16/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao para o campo C7_PRODUTO respeitando a Restricao    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ferramentas DOVAC - TI                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRX01D(cProd)
	Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cQuery	:= ""
	Local cFiltro	:= "" //Filtro principal
	Local cFiltro1	:= "" //Filtro Produto x Usuarios ( SB1 x QAA )
	Local cFiltro2	:= "" //Filtro Produto x Pedidos  ( SB1 x SZD )
	Local lRet		:= .F.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe executar pela Solicitacao de Compras                 ณ
	//ณ nao deve validar a filtro de Usuario x Produto x Pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ProcName() == "MATA110" .or. ProcName() == "MATA130" .or. ProcName() == "MATA160"
		RestArea(aArea)
		Return .T.
	EndIf	
	cFiltro1 := u_KMFRX01( "QAA" , POSICIONE( "QAA" , 6 , Upper(cUserName) , "QAA_MAT" ) , "SB1" , .F. )	
	if FUNNAME()$"MATA121/MATA122" .AND. INCLUI
		cTpPedOK := U_DV02P04G("cTpPed")
	elseif FUNNAME()$"MATA121/MATA122" .AND. !INCLUI
		cTpPedOK := U_DV02A03G("cTpPed")
	endif	
	If "EIC" == substr(FUNNAME(),1,3) .OR. ((Type("cTpPedOK") = "C" .AND. Empty(cTpPedOK))) .or. Type("cTpPedOK") <> "C"
		cFiltro2 := " 1 = 1 "
	Else
		cFiltro2 := u_KMFRX01( "SZD" , /*IIF( INCLUI ,*/ cTpPedOK /*, SC7->C7_TPPED )*/, "SB1" , .F. )
	EndIf

	If !Empty(cFiltro1)
		cFiltro += cFiltro1
	EndIf

	If !Empty(cFiltro2)
		If Empty(cFiltro)
			cFiltro += cFiltro2
		Else
			cFiltro += " AND " + cFiltro2
		EndIf
	EndIf	
	//Se o usuario nao tiver um dos filtros cadastrados, nao permitir utilizar (Solicitado pelo Wilson - 19/05/2014)
	If Empty(cFiltro1) .or. Empty(cFiltro2)		
		lRet := .F.
		MsgStop( OemToAnsi("Usuแrio sem filtro cadastrado - " + IIF( Empty(cFiltro1) , "'Produto'" , "'Pedido'" )) , "Acesso Negado" )	
	Else		
		If !Empty(cProd)			
			cQuery := " SELECT COUNT(*) QUANT"
			cQuery += " FROM " + RetSqlName("SB1")
			cQuery += " WHERE D_E_L_E_T_ <> '*'"
			cQuery += "   AND B1_COD = '" + cProd + "'"			
			If !Empty(cFiltro)
				cQuery += "   AND " + cFiltro
			EndIf
			MEMOWRITE("KMFRX01_02.SQL",cQuery)
			
			/////////cQuery := ChangeQuery( cQuery )
			dbUseArea( .T. , "TOPCONN" , TCGENQRY(,, cQuery ) , cAlias , .F. , .T. )			
			lRet := (cAlias)->QUANT > 0
			If !lRet
				MsgStop( OemToAnsi("Restri็ใo do Usuแrio por Tipo de Pedido x Produto.") , ProcName() + " - Acesso Negado" )
			EndIf			
			(cAlias)->( dbCloseArea() )			
		EndIf		
	EndIf
	RestArea(aArea)	
Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบ Programa ณ KMFRX01E  บ Autor ณ Alexis Duarte     บ Data ณ  14/07/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao complementar da rotina dvfra01, que retorna uma       บฑฑ
ฑฑบ          ณ expressao SQL ou Advpl conforme ultimo parametro.            บฑฑ
ฑฑบ          ณ Utilizada para clausula WHERE com os filtros da tabela PH3   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cEntAl  - Alias do cabecalho                                 บฑฑ
ฑฑบ          ณ cChave  - Conteudo da chave primaria                         บฑฑ
ฑฑบ          ณ cGridAl - Alias do grid (tabela a ser filtrada)              บฑฑ
ฑฑบ          ณ lAdvpl  - .T. retorna expressao Advpl | .F. retorna SQL      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ferramentas DOVAC - TI                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMFRX01E( _cEntAl , _cChave , _cGridAl, cAlias , _lAdvpl, _cField) //u_KMFRX01E( "QAA" , "0101002220" , "PH3" , .T. )
	Local aArea      := GetArea()
	Local aAreaSX3   := (dbSelectArea("SX3"),SX3->(getArea()))
	Local _cFiltro	 := ""
	Local _cQuery	 := ""
	Local _cAlias	 := GetNextAlias()
	Local _nAux		 := 0
	Local _cConteudo := ""
	Local aField     := {}
	Local nx,nxt,aTam

	Private cField
	Default	_lAdvpl		:= .F.

	if !Empty(__cUserId)
		_cQuery := " SELECT PH3_FIELD, PH3_CONTUD "
		_cQuery += " FROM " + RetSqlName("PH3")
		_cQuery += " WHERE D_E_L_E_T_ <> '*'"
		_cQuery += "   AND PH3_FILIAL  = '" + xFilial("PH3") + "'"
		_cQuery += "   AND PH3_ENTFIL  = '" + xFilial( Alltrim( _cEntAl  )) + "'"
		_cQuery += "   AND PH3_FILGRD  = '" + xFilial( Alltrim( _cGridAl )) + "'"
		_cQuery += "   AND PH3_ENTALI = '" +    Padr( _cEntAl , TamSx3("PH3_ENTALI")[1]) + "'"
		_cQuery += "   AND PH3_ALIAS   = '" +    Padr( cAlias, TamSx3("PH3_ALIAS")[1]  ) + "'"
		_cQuery += "   AND PH3_ENTPK   = '" +    Padr( _cChave , TamSx3("PH3_ENTPK")[1]  ) + "'"		
		if !Empty(_cField)
			_cQuery += " AND TRIM(PH3_FIELD) = '"+ UPPER( ALLTRIM( _cField ) ) +"'"
		endif
		_cQuery += " ORDER BY PH3_FIELD "
		
		MEMOWRITE("KMFRX01E_01.SQL",_cQuery)
		
 		dbUseArea( .T. , "TOPCONN" , TCGENQRY(,, _cQuery ) , _cAlias , .F. , .T. )
			
		while !(_cAlias)->(eof())			
			cField := padr((_cAlias)->PH3_FIELD,10)
			nx := aScan( aField, {|x| x[1] == cField } )			
			if nx > 0				
				aTam := TamSx3(cField)				
				if ValType(aTam) == "A"
					aField[nx,2] += "|"+padr((_cAlias)->PH3_CONTUD,aTam[1])
				endif				
			else				
				aTam := TamSx3(cField)
				if ValType(aTam) == "A"
					aadd(aField, { cField, padr((_cAlias)->PH3_CONTUD,aTam[1]) })
				endif				
			endif		
			(_cAlias)->(dbSkip())
		enddo	
		dbCloseArea(_cAlias)

		dbSelectArea('SX3')
		dbSetOrder(2)

		_cFiltro	:= ""

		nxt := Len(aField)	
		for nx := 1 to nxt	
			If SX3->( dbSeek( aField[nx,1] ))				
				If _nAux > 0
					_cFiltro += IIF( _lAdvpl , " .AND. " , "  AND  " )
				EndIf				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Conteudo			ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cConteudo := aField[nx,2]

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Campo   			ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cCampo := Alltrim( aField[nx,1] )				
				If _lAdvpl
					If SX3->X3_TIPO == "N"
						_cCampo := " cValToChar(" + _cGridAl + "->" + _cCampo + ") "
					EndIf
					If SX3->X3_TIPO == "D"
						_cCampo := " DTOS(" + _cGridAl + "->" + _cCampo + ") "
					EndIf
				else
					If SX3->X3_TIPO == "N"
						_cCampo := " to_char("+_cCampo+") "
					EndIf
				EndIf				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento para variavel de Retorno de Filtroณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cFiltro += _cCampo
				_cFiltro += IIF( _lAdvpl , " $ " , " IN (" ) + "'"
				_cFiltro += IIF( _lAdvpl , _cConteudo , Replace( _cConteudo , "|", "','" ))
				_cFiltro += IIF( _lAdvpl , "'" , "')" )				
				_nAux++				
			EndIf			
		next		
	endif
	if Empty(__cUserId)
		If _lAdvpl
			_cFiltro := " .T. "
		Else
			_cFiltro := " 1 = 1 "
		EndIf
	ElseIf Empty(_cFiltro)
		If _lAdvpl
			_cFiltro := " .F. "
		Else
			_cFiltro := " 1 = 2 "
		EndIf
	EndIf		
	RestArea(aAreaSX3)
	RestArea(aArea)		
Return _cFiltro