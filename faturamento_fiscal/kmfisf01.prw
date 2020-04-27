#include "protheus.ch"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMFISF01 ºAutor  ³ Adriano Oliveira   º Data ³  03/21/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de exportacao de XML                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KomfortHouse                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFISF01()

	Processa( { || _oKMFISF01() } )

Return


Static Function _oKMFISF01()

	Local _nHdl			:= 0
	Local _aParam		:= {}
	Local _aRetPar		:= {}
	Local _cDirFile		:= ""
	Local _cQuery		:= ""
	Local _cNomeArq		:= ""
	Local _cHtml		:= ""
	Local _cDoctoDe		:= ""
	Local _cDoctoAte	:= ""
	Local _cDbTSS       := AllTrim(UPPER(GetMv("KH_DBTSS",,"TSS"))) //#CMG20181218.n

	// Var para limitacao de campos do XML. ATENCAO: Tem que limitar em 07 para nao estourar erro na query qdo a execucao for no Protheus.
	Local _nLimite		:= 07

	AAdd( _aParam, { 1, "Data Inicial"	, dDataBase							, "", "", "", "", 50, .T. } )
	AAdd( _aParam, { 1, "Data Final"	, dDataBase							, "", "", "", "", 50, .T. } )
	AAdd( _aParam, { 1, "Série do Docto", Space( TamSX3( "F1_SERIE" )[1] )	, "", "", "", "", 20, .T. } )	// Necessita da Serie para compor o campo NFE_ID
	AAdd( _aParam, { 1, "Documento De"	, Space( TamSX3( "F1_DOC" 	)[1] )	, "", "", "", "", 40, .T. } )
	AAdd( _aParam, { 1, "Documento Ate"	, Space( TamSX3( "F1_DOC" 	)[1] )	, "", "", "", "", 40, .T. } )
	AAdd( _aParam, { 1, "CNPJ De"		, Space( TamSX3( "A2_CGC" 	)[1] )	, "", "", "", "", 50, .F. } )
	AAdd( _aParam, { 1, "CNPJ Ate"		, Space( TamSX3( "A2_CGC" 	)[1] )	, "", "", "", "", 50, .F. } )

	If ! ParamBox( _aParam, "Parâmetros Exportação XML", @_aRetPar )
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha o arquivo de Trabalho caso exista em alguma area ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select( "TRB" ) # 0
		TRB->( DbCloseArea() )
	EndIf

	// Monta o Numero do Docto De e Ate contendo a Serie no Inicio para igualar a informacao do campo NFE_ID
	_cDoctoDe	:= cValToChar( _aRetPar[3] ) + cValToChar( _aRetPar[4] )
	_cDoctoAte	:= cValToChar( _aRetPar[3] ) + cValToChar( _aRetPar[5] )

	_cDirFile := cGetFile("Diretório XML|*.xml",OemToAnsi("Selecione o diretório para gravaçao dos XML"),1,"C:\",.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY,.F.)

	_cQuery	:= "SELECT A.NFE_ID, A.DATE_NFE, A.TIME_NFE, A.NFE_PROT, A.DOC_CHV, A.CNPJDEST, B.CSTAT_SEFR, " + CRLF

	_nLimite := 07 	// ATENCAO: Tem que limitar em 07 para nao estourar erro na query qdo a execucao for no Protheus.

	For _ni := 0 To _nLimite
		_cQuery += "        CAST(SUBSTRING(CAST(CAST(A.XML_ERP  as VARBINARY(MAX)) AS VARCHAR(MAX))," + Str(((_ni*4000)+1),0) + ",4000) AS VARCHAR(4000)) XML_TXT" + StrZero(_ni,2) + "," + CRLF
		_cQuery += "        CAST(SUBSTRING(CAST(CAST(B.XML_PROT as VARBINARY(MAX)) AS VARCHAR(MAX))," + Str(((_ni*4000)+1),0) + ",4000) AS VARCHAR(4000)) XML_PRO" + StrZero(_ni,2) + "," + Iif( _ni < _nLimite, CRLF, "" )
	Next _ni

	_cQuery := SubStr( _cQuery, 1, Len( _cQuery ) - 1 ) + " " + CRLF

	_cQuery += "  FROM "+_cDbTSS+"..SPED050 A (NOLOCK) " 																					+ CRLF
	_cQuery += "       LEFT OUTER JOIN "+_cDbTSS+"..SPED054 B (NOLOCK) ON A.ID_ENT = B.ID_ENT AND A.NFE_ID = B.NFE_ID " 					+ CRLF
	_cQuery += "       LEFT OUTER JOIN "+_cDbTSS+"..SPED001 C (NOLOCK) ON A.ID_ENT = C.ID_ENT " 				 							+ CRLF
	_cQuery += " WHERE A.DATE_NFE BETWEEN '" 	+ DtoS( _aRetPar[1] ) 	+ "' AND '" + DtoS( _aRetPar[2] ) 	+ "' " 						+ CRLF
	_cQuery += "   AND A.NFE_ID BETWEEN '" 		+ _cDoctoDe 			+ "' AND '" + _cDoctoAte 			+ "' " 						+ CRLF
	_cQuery += "   AND A.AMBIENTE = '1' " 																								+ CRLF
	_cQuery += "   AND A.MODALIDADE = '1' " 																							+ CRLF
	_cQuery += "   AND ISNULL(C.CNPJ,'XXX') BETWEEN '" + _aRetPar[6] + " ' AND '" + _aRetPar[7] + " ' "								+ CRLF

	// Gera XML somente para Transmitidas, inutilizadas e canceladas
	_cQuery += "   AND (A.STATUS = '6' OR (A.STATUS = '7' AND B.CSTAT_SEFR = '101') OR (A.STATUS = '7' AND B.CSTAT_SEFR = '102') ) " 	+ CRLF

	dbUseArea( .T., "TOPCONN", TCGenQry( , , _cQuery ), "TRB", .F., .T. )

	TcSetField( "TRB", "DATE_NFE", "N", 08, 0 )

	dbSelectArea( "TRB" )
	dbGoTop()

	ProcRegua( RecCount() )

	While ! Eof()

		IncProc( "Processando...." )

		// Monta nome do arquivo XML
		_cNomeArq := _cDirFile + AllTrim( TRB->NFE_ID ) + "_" + StrTran( TRB->TIME_NFE, ":", "" ) + "_" + AllTrim( TRB->CNPJDEST )

		// Completa com informacao de cancelado ou inutilizado
		If TRB->CSTAT_SEFR == '101'
			_cNomeArq += "_canc"
		ElseIf TRB->CSTAT_SEFR == '102'
			_cNomeArq += "_inut"
		EndIf

		//Completa com informação do CFOP - Alberto Simplicio 25/08/2016
		_cNomeArq += "_" + SubStr(TRB->XML_TXT00,At("CFOP",TRB->XML_TXT00)+5,4)

		// Completa com a extensao
		_cNomeArq += ".XML"

		// Cria e abre o arquivo para gravacao
		_nHdl := fCreate( _cNomeArq )

		If _nHdl == -1
			MsgAlert( "O arquivo de nome " + _cNomeArq + " não pode ser executado! Verifique os parâmetros.", "Atenção!!!" )
			Return
		Else
			_cHtml := '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="3.10">'

			For _ni := 0 To _nLimite
				_cHtml += AllTrim( &( "TRB->XML_TXT" + StrZero( _ni, 2 ) ) )
			Next _ni

			For _ni := 0 To _nLimite
				_cHtml += AllTrim( &( "TRB->XML_PRO" + StrZero( _ni, 2 ) ) )
			Next _ni

			_cHtml += '</nfeProc>'

			fWrite( _nHdl, _cHtml, Len( _cHtml ) )
			fClose( _nHdl )
		EndIf
		dbSelectArea( "TRB" )
		dbSkip()
	EndDo

	ShellExecute( "open", _cDirFile, "", "", 5 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha o arquivo de Trabalho caso exista em alguma area ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select( "TRB" ) # 0
		TRB->( DbCloseArea() )
	EndIf

Return
