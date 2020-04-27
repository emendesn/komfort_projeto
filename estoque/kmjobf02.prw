#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  KMJOBF02  ³ Autor ³ Caio Garcia         ³ Data ³ 19/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa irá classificar notas de transferência            ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ OBPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function KMJOBF02()

	Private aCabec:= {}
	Private aItens:= {}
	Private aLinha:= {}
	Private lMsErroAuto := .F.
	Private _aErros := {}
	Processa( {|| fNfEnt() }, "Executando entrada das Notas", "Aguarde...", .F.)
	
Return

Static Function fNfEnt()	

	Local _cQuery := ""
	Local _cFilial := ""
	Local _cEmp := "01"
	Local _cFil := "0101"
	Local _cNfe  := ""
	Local _cSer  := ""
	Local _cFor  := ""
	Local _cLoj  := ""
	Local _cOri  := ""

	ConOut("-----------------------------------------")
	ConOut("Inicio da rotina KMJOBF02: " +DToC(Date())+" - "+Time())
	ConOut("-----------------------------------------")

	If cFilAnt == '0101'

		//PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES 'SA1,SC6,SC5,SC9,SF2,SD2,SE4,SF4,SB2,SB1' MODULO 'EST'

		_cQuery := " SELECT DISTINCT D2_FILIAL+D2_DOC+D2_SERIE NOTAS "
		_cQuery += " FROM " + RETSQLNAME("SUB") + " (NOLOCK) SUB "
		_cQuery += " INNER JOIN " + RETSQLNAME("SC6") + " (NOLOCK) SC6 ON C6_XCHVTRA = UB_FILIAL+UB_NUM+UB_ITEM AND SC6.D_E_L_E_T_ <> '*' "
		_cQuery += " INNER JOIN " + RETSQLNAME("SD2") + " (NOLOCK) SD2 ON D2_DOC = C6_NOTA AND D2_SERIE = C6_SERIE AND D2_CLIENTE = C6_CLI AND D2_LOJA = C6_LOJA "
		_cQuery += " AND D2_PEDIDO = C6_NUM AND C6_ITEM = D2_ITEMPV AND SD2.D_E_L_E_T_ <> '*' "
		_cQuery += " WHERE SUB.D_E_L_E_T_ <> '*' AND C6_XCHVTRA <> '' "
		_cQuery += " AND D2_FILIAL+D2_DOC+D2_SERIE NOT IN "
		_cQuery += " ( "
		_cQuery += " SELECT DISTINCT C6_MSFIL+D1_DOC+D1_SERIE NF_SD1 "
		_cQuery += " FROM " + RETSQLNAME("SUB") + " (NOLOCK) SUB  "
		_cQuery += " INNER JOIN " + RETSQLNAME("SC6") + " (NOLOCK) SC6 ON C6_XCHVTRA = UB_FILIAL+UB_NUM+UB_ITEM AND SC6.D_E_L_E_T_ <> '*'  AND C6_XCHVTRA <> '' "
		_cQuery += " INNER JOIN " + RETSQLNAME("SD1") + " (NOLOCK) SD1 ON D1_DOC = C6_NOTA AND D1_SERIE = C6_SERIE AND D1_COD = C6_PRODUTO AND C6_ITEM = RIGHT(D1_ITEM,2) "
		_cQuery += " INNER JOIN " + RETSQLNAME("SF1") + " (NOLOCK) SF1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE "
		_cQuery += " AND F1_LOJA = D1_LOJA AND SF1.D_E_L_E_T_ <> '*' "
		_cQuery += " AND D1_FORNECE = (SELECT A2_COD FROM " + RETSQLNAME("SA2") + " (NOLOCK)  SA2 WHERE SA2.D_E_L_E_T_ <> '*' AND A2_FILTRF = C6_MSFIL) "
		_cQuery += " AND D1_LOJA = (SELECT A2_LOJA FROM " + RETSQLNAME("SA2") + " (NOLOCK)  SA2B WHERE SA2B.D_E_L_E_T_ <> '*' AND A2_FILTRF = C6_MSFIL) "
		_cQuery += " AND D1_FILIAL = '0101' AND SD1.D_E_L_E_T_ <> '*' "
		_cQuery += " ) "
		_cQuery := ChangeQuery(_cQuery)

		_cAlias   := GetNextAlias()

		DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )

		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())
		
		ProcRegua((_cAlias)->(RecCount()))
		(_cAlias)->(DbGoTop())
		
		If (_cAlias)->(!Eof())

			While (_cAlias)->(!Eof())
					
				_cOri  := SubsTr((_cAlias)->NOTAS,1,4)
				_cNfe  := SubsTr((_cAlias)->NOTAS,5,9)
				_cSer  := SubsTr((_cAlias)->NOTAS,14,3)

				IncProc("Processando nota "+_cOri+" "+_cNfe+" "+_cSer)
				
				lMsErroAuto := .F.
				FGerNFE( _cOri,_cNfe,_cSer )

				(_cAlias)->(DbSkip())

			EndDo

		Else

			ConOut("Não há notas a classificar")

		EndIf

		(_cAlias)->(DbCloseArea())

		//RESET ENVIRONMENT

	Else

		Alert("Essa rotina só pode ser executada na Matriz(0101)")

	EndIf
	
	If Len(_aErros) > 0
	
		For _nx := 1 To Len(_aErros)
		
			AutoGrLog(_aErros[_nx])
		
		Next _nx
	
		MostraErro()
		
	EndIf

	ConOut("-----------------------------------------")
	ConOut("Fim da rotina KMJOBF02: " +Time())
	ConOut("-----------------------------------------")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º CRIAPNF  º Autor º Caio Garcia        º Data ³  30/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ GERA NOTA DE ENTRADA DOS PEDIDOS DE TRANSFERENCIA 	      º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FGerNFE( _cOri,_cNfe,_cSer )

	Local cESPPNFE   := GETMV("MV_ESPPNFE",,"SPED")
	Local cTPPNFE    := GETMV("MV_TPPNFE",,"N")
	Local cFORPNFE   := GETMV("MV_FORPNFE",,"N")
	Local cLOCGLP    := GetMV("MV_LOCGLP")
	Local cLocDep	 := GetMv("MV_SYLOCDP",,"0101")
	Local cLocLoj	 := ""
	Local cTESTrf	 := SuperGetMV("KH_TESTRF",.F.,"054")
	Local _cChvNfe   := ""
	Local _cDbTSS    := AllTrim(UPPER(GetMv("KH_DBTSS",,"TSS")))
	Local _cAlias    := GetNextAlias()
	Local _cQuery    := ""

	Local _cArmMos   := GETMV("MV_LOCGLP",,"03")

	Local _lPreNf    := .F.

	ConOut("-----------------------------------------")
	ConOut(AllTrim(cFilAnt)+" - Inicio da rotina FGERNFE: " +Time())
	ConOut("-----------------------------------------")

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	SF2->(DbSeek(_cOri+_cNfe+_cSer))

	DbSelectArea("SD2")
	SD2->(DbSetOrder(1))
	SD2->(DbGoTop())
	SD2->(DbSeek(_cOri+_cNfe+_cSer))

	If !Empty(AllTrim(SF2->F2_CHVNFE))

		_cChvNfe := AllTrim(SF2->F2_CHVNFE)

	Else

		cIdEnt := fIdEnt(_cOri)

		DBSelectarea("SM0")
		SM0-> (DbSetorder(1))
		SM0-> (DbSeek(cEmpAnt + cFilAnt))

		If !Empty(AllTrim(cIdEnt))

			_cQuery := " SELECT NFE_CHV CHAVE "
			_cQuery += " FROM "+_cDbTSS+".dbo.SPED054 "
			_cQuery += " WHERE D_E_L_E_T_ <> '*' "
			_cQuery += " AND ID_ENT = '"+cIdEnt+"' "
			_cQuery += " AND NFE_ID = '"+SF2->F2_SERIE+SF2->F2_DOC+"' "

			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_CHVTMP_",.F.,.T.)

			MemoWrite('\Querys\KMESTF01_CHV.sql',_cQuery)

			DbSelectArea("_CHVTMP_")
			_CHVTMP_->(DbGoTop())

			If !Empty(AllTrim(_CHVTMP_->CHAVE))

				_cChvNfe := _CHVTMP_->CHAVE
				_CHVTMP_->(DbCloseArea())
				ConOut("Chave "+_cChvNfe)

			Else

				_lPreNf := .T.
				_CHVTMP_->(DbCloseArea())

			EndIf

		Else

			_lPreNf := .T.
			ConOut("Não achou Ident" )

		EndIf


	EndIf

	DbSelectArea("SA2")
	SA2->(DbOrderNickName("FILTRF2"))
	SA2->(DbGoTop())
	SA2->(DbSeek(xFilial("SA2") + _cOri))

	_cQuery := " SELECT * "
	_cQuery += " FROM " + RETSQLNAME("SD2") + " SD2 "
	_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
	_cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"' "
	_cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"' "
	_cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
	_cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"' "
	_cQuery += " AND D2_FILIAL = '"+SF2->F2_FILIAL+"' "
	_cQuery += " ORDER BY D2_ITEM "
	_cQuery := ChangeQuery(_cQuery)

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())

	cLocLoj := GetAdvFVal("SA1","A1_FILTRF",xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,1,"")
	cLOCGLP := SuperGetMV("SY_LOCPAD",.F.,"01",cLocLoj)

	If .F.//_lPreNf //Gerar Pre-Nota desabilitei a opção de gerar pre nota

		If (_cAlias)->(!Eof())

			ConOut("Gera Pre-Nota" )

			aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
			{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
			{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
			{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
			{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
			{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
			{'F1_COND'	    ,'001'	            ,NIL},;
			{'F1_FORNECE'	,SA2->A2_COD        ,NIL},;
			{'F1_LOJA'		,SA2->A2_LOJA  	    ,NIL}}

			While (_cAlias)->(!EOF())
				aLinha := {}

				aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
				{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
				{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
				{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
				{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
				{'D1_TIPO'		,cTPPNFE 				,NIL},;
				{'D1_LOCAL'		,_cArmMos	  			,NIL},;
				{'D1_TES'		,cTESTrf				,NIL}}

				aadd(aItens,aLinha)
				(_cAlias)->(DbSkip())

			EndDo

			PUTMV("MV_DISTMOV", .F.)
			PUTMV("MV_PCNFE", .F.)
			//		MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens,3)


			If lMsErroAuto

				ConOut("Erro ao incluir Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )

			Else

				ConOut("Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )

			EndIf

			PUTMV("MV_DISTMOV", .T.)
			PUTMV("MV_PCNFE", .T.)

		EndIf

	Else

		If !Empty(AllTrim(_cChvNfe))

			If (_cAlias)->(!Eof())

				aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
				{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
				{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
				{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
				{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
				{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
				{'F1_COND'	    ,'001'	            ,NIL},;
				{'F1_FORNECE'	,SA2->A2_COD        ,NIL},;
				{'F1_CHVNFE'	,_cChvNfe           ,NIL},;
				{'F1_LOJA'		,SA2->A2_LOJA  	    ,NIL}}

				aItens:= {}                       

				While (_cAlias)->(!EOF())
					aLinha := {}

					aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
					{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
					{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
					{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
					{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
					{'D1_TIPO'		,cTPPNFE 				,NIL},;
					{'D1_LOCAL'		,_cArmMos	  			,NIL},;
					{'D1_TES'		,cTESTrf				,NIL}}

					aadd(aItens,aLinha)
					(_cAlias)->(DbSkip())

				EndDo

				lMsErroAuto := .F.
				PUTMV("MV_DISTMOV", .F.)
				PUTMV("MV_PCNFE", .F.)
				MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)

				If lMsErroAuto
					Alert("Erro ao incluir NF De Entrada - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE+" "+_cOri )

					//MostraErro()

					lMsErroAuto := .F.

					ConOut("Gera Pre-Nota" )
					/*/MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens,3)

					If lMsErroAuto

						ConOut("Erro ao incluir Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )

					Else

						ConOut("Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )

					EndIf*/

					Mostraerro()
					
				Else
					ConOut("NF ENTRADA - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
				EndIf

				PUTMV("MV_DISTMOV", .T.)
				PUTMV("MV_PCNFE", .T.)

			EndIf

		Else
		
			AADD(_aErros,"Nota Fiscal Sem Chave : " + SF2->F2_DOC + " " + SF2->F2_SERIE+" "+_cOri)	

		EndIf

	EndIf

Return()

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fIdEnt    ³ Autor ³Caio Garcia            ³ Data ³23.10.2018³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fIdEnt(_cFil)

	Local _aArea		 := GetArea()
	Local _cId := ""
	Local _cDbTSS    := AllTrim(UPPER(GetMv("KH_DBTSS",,"TSS")))
	Local _cQuery    := ""
	Local _cCNPJ     := ""

	DBSelectarea("SM0")
	SM0-> (DbSetorder(1))
	SM0-> (DbSeek(cEmpAnt + _cFil))

	_cCNPJ := SM0->M0_CGC

	_cQuery := " SELECT ID_ENT "
	_cQuery += " FROM "+_cDbTSS+".dbo.SPED001 "
	_cQuery += " WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND CNPJ = '"+_cCNPJ+"' "
	_cQuery += " ORDER BY ID_ENT DESC "

	MemoWrite('\Querys\KMESTF01_ID.sql',_cQuery)

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_TMPID_",.F.,.T.)

	_cId := _TMPID_->ID_ENT

	If Empty(AllTrim(_cId))

		ConOut("Não achou ID_ENT")

	EndIf

	_TMPID_->(DbCloseArea())

	RestArea(_aArea)

Return(_cId)
