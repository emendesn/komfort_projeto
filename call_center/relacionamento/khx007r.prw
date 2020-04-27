//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} xRelat
Relatório - Relatorio
@author zReport
@since 09/10/2019
@version 1.0
	@example
	u_xRelat()
	@obs Função gerada pelo zReport()
/*/

User Function KHX007R()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Local cUsers  := SuperGetMv("KH_ANAAR" , , "001117") //joao.moreira
	Local nTipoRel:= ""
	Private cPerg := ""

	If (RetCodUsr() $ cUsers) .AND. ( Pergunte("KHX007A",.T.) )

		nTipoRel	:= MV_PAR05

		//Defini��es da pergunta
		cPerg := "khx007a   "

		//Se a pergunta n�o existir, zera a vari�vel
		DbSelectArea("SX1")
		SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
		If ! SX1->(DbSeek(cPerg))
			cPerg := Nil
		EndIf

		//Cria as defini��es do relat�rio
		oReport := fReportDef(nTipoRel)

		//Ser� enviado por e-Mail?
		If lEmail
			oReport:nRemoteType := NO_REMOTE
			oReport:cEmail := cPara
			oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
			oReport:SetPreview(.F.)
			oReport:Print(.F., "", .T.)
		//Sen�o, mostra a tela
		Else
			oReport:PrintDialog()
		EndIf
		
	Else
	
		Aviso("Erro" , "Usuario sem acesso ao relatorio")

	EndIf

	RestArea(aArea)

Return

/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/

Static Function fReportDef(nTipoRel)
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil

	//Criação do componente de impressão
	oReport := TReport():New(	"KHX007A",;		//Nome do Relatório
								"Relatorio",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport , nTipoRel)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()

	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;			//Objeto TReport que a seção pertence
									"Dados",;			//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	If (nTipoRel == 1) //Analitico

		//Colunas do relatório
		TRCell():New(oSectDad, "ZL5_CODCLI", "QRY_AUX", "Cod. Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_DTCON", "QRY_AUX", "Dt. Contato", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_DTAGEN", "QRY_AUX", "Dt. Agend.", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_HRINI", "QRY_AUX", "Hr. Ini. Ate", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_HRFIM", "QRY_AUX", "Hr. Fim Ate", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_CODOPE", "QRY_AUX", "Cod. Oper", /*Picture*/, 6, /*lPixel*/,{|| fRetOpe(QRY_AUX->ZL5_CODOPE)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota Satisfa", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_STATUS", "QRY_AUX", "Status Cto.", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL5_STATUS" , QRY_AUX->ZL5_STATUS)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_NIVEL", "QRY_AUX", "Niv. Satisf.", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL5_NIVEL" , QRY_AUX->ZL5_NIVEL)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_PEND", "QRY_AUX", "Pend. Contat", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL5_PEND" , QRY_AUX->ZL5_PEND)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_WAPP", "QRY_AUX", "Status wzapp", /*Picture*/, 1, /*lPixel*/,{|| fRetWApp(QRY_AUX->ZL5_CODCLI) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_BRINDE", "QRY_AUX", "Tp. Brinde", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL5_BRINDE" , QRY_AUX->ZL5_BRINDE)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL5_PERC", "QRY_AUX", "Perc. Desc.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 1024, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	Else //Sintetico

		//Colunas do relatório
		TRCell():New(oSectDad, "ZL6_CODCLI", "QRY_AUX", "Cod. Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_DTCON", "QRY_AUX", "Dt. Contato", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_DTAGEN", "QRY_AUX", "Dt. Agend.", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_HRINI", "QRY_AUX", "Hr. Ini. Ate", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_HRFIM", "QRY_AUX", "Hr. Fim Aten", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_CODOP", "QRY_AUX", "Cod. Oper.", /*Picture*/, 6, /*lPixel*/,{|| fRetOpe(QRY_AUX->ZL6_CODOP)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_STATUS", "QRY_AUX", "Status Cto.", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL6_STATUS" , QRY_AUX->ZL6_STATUS)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota. Satisf", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)		
		TRCell():New(oSectDad, "ZL6_NIVEL", "QRY_AUX", "Niv. Satisf.", /*Picture*/, 1, /*lPixel*/,{|| fRetSX3("ZL6_NIVEL" , QRY_AUX->ZL6_NIVEL)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_PEND", "QRY_AUX", "Pend. Contat", /*Picture*/, 2, /*lPixel*/,{|| fRetSX3("ZL6_PEND" , QRY_AUX->ZL6_PEND)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_WAPP", "QRY_AUX", "Status wpp", /*Picture*/, 1, /*lPixel*/,{|| fRetWApp(QRY_AUX->ZL6_CODCLI) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_BRINDE", "QRY_AUX", "Tp. Brinde", /*Picture*/, 2, /*lPixel*/,{|| fRetSX3("ZL6_BRINDE" , QRY_AUX->ZL6_BRINDE)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "ZL6_PERC", "QRY_AUX", "Perc. Desc.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
		TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 1024, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	EndIf
Return oReport

/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/

Static Function fRepPrint(oReport , nTipoRel)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cDataDe	:= dToS(MV_PAR01)
	Local cDataAte	:= dToS(MV_PAR02)
	Local cCliDe	:= MV_PAR03
	Local cCliAte	:= MV_PAR04

	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)

	If (nTipoRel == 1) //Analitico
		//Montando consulta de dados
		cQryAux := ""
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "ZL5_CODCLI ,"		+ STR_PULA
		cQryAux += "ZL5_LOJA , "		+ STR_PULA
		cQryAux += "ZL5_DTCAD , "		+ STR_PULA
		cQryAux += "ZL5_STATUS , "		+ STR_PULA
		cQryAux += "ISNULL(CAST(CAST(ZL5_OBS AS VARBINARY(1024)) AS VARCHAR(1024)),'')  OBS , "		+ STR_PULA
		cQryAux += "ZL5_NIVEL , "		+ STR_PULA
		cQryAux += "ZL5_CHAMAD , "		+ STR_PULA
		cQryAux += "ZL5_PEND, "		+ STR_PULA
		cQryAux += "ZL5_WAPP , "		+ STR_PULA
		cQryAux += "ZL5_BRINDE , "		+ STR_PULA
		cQryAux += "ZL5_PERC , "		+ STR_PULA
		cQryAux += "ZL5_NOTA NOTA, "	+ STR_PULA
		cQryAux += "ZL5_CODOPE," 		+ STR_PULA
		cQryAux += "ZL5_DTAGEN , "		+ STR_PULA
		cQryAux += "ZL5_DTCON , "		+ STR_PULA
		cQryAux += "ZL5_HRINI , "		+ STR_PULA
		cQryAux += "ZL5_HRFIM , "		+ STR_PULA
		cQryAux += "ZL5_XTELS1 , "		+ STR_PULA
		cQryAux += "ZL5_XTELS2 , "		+ STR_PULA
		cQryAux += "ZL5_XTELS3  "		+ STR_PULA
		cQryAux += "FROM ZL5010 ZL5 "

		cQryAux += "WHERE ZL5.D_E_L_E_T_ = ' ' "		+ STR_PULA
		cQryAux += "AND ZL5_DTCON BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'"	+ STR_PULA
		cQryAux += "AND ZL5_CODCLI BETWEEN '" + cCliDe + "' AND '" + cCliAte + "'"	+ STR_PULA
		
		cQryAux	+= " ORDER BY ZL5_DTCON , ZL5_CODCLI "

	Else //Sintetico

		//Montando consulta de dados
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "ISNULL(CAST(CAST(ZL5_OBS AS VARBINARY(1024)) AS VARCHAR(1024)),'')  OBS , "		+ STR_PULA
		cQryAux += "ZL6_CODCLI,"		+ STR_PULA
		cQryAux += "ZL6_CODOP,"		+ STR_PULA
		cQryAux += "ZL6_DTAGEN,"		+ STR_PULA
		cQryAux += "ZL6_DTCON,"		+ STR_PULA
		cQryAux += "ZL6_FILIAL,"		+ STR_PULA
		cQryAux += "ZL6_HRFIM,"		+ STR_PULA
		cQryAux += "ZL6_HRINI,"		+ STR_PULA
		cQryAux += "ZL6_LOJA,"		+ STR_PULA
		cQryAux += "ZL6_NIVEL,"		+ STR_PULA
		cQryAux += "ZL6_NOTA NOTA,"		+ STR_PULA
		cQryAux += "ZL6_PEND,"		+ STR_PULA
		cQryAux += "ZL6_PERC,"		+ STR_PULA
		cQryAux += "ZL6_STATUS,"		+ STR_PULA
		cQryAux += "ZL6_WAPP,"		+ STR_PULA
		cQryAux += "ZL6_BRINDE"		+ STR_PULA
		cQryAux += "FROM ZL5010 ZL5 "
		cQryAux += "INNER JOIN ZL6010 ZL6 "	+ STR_PULA
		cQryAux += "ON ZL6.D_E_L_E_T_ = ' ' "	+ STR_PULA
		cQryAux += "AND ZL5_CODCLI = ZL6_CODCLI "	+ STR_PULA
		cQryAux += "AND ZL5_LOJA = ZL6_LOJA "		+ STR_PULA
		
		cQryAux += "WHERE ZL5.D_E_L_E_T_ = ' ' "		+ STR_PULA
		cQryAux += "AND ZL6_DTCON BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'"	+ STR_PULA		
		cQryAux += "AND ZL6_CODCLI BETWEEN '" + cCliDe + "' AND '" + cCliAte + "'"	+ STR_PULA
		
		cQryAux	+= " ORDER BY ZL6_DTCON , ZL6_CODCLI "

	EndIf

	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)

	If (nTipoRel = 1)

		TCSetField("QRY_AUX", "ZL5_DTCAD", "D")
		TCSetField("QRY_AUX", "ZL5_DTAGEN", "D")
		TCSetField("QRY_AUX", "ZL5_DTCON", "D")

	Else

		TCSetField("QRY_AUX", "ZL6_DTCAD", "D")
		TCSetField("QRY_AUX", "ZL6_DTAGEN", "D")
		TCSetField("QRY_AUX", "ZL6_DTCON", "D")

	EndIf

	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()

		//Imprimindo a linha atual
		oSectDad:PrintLine()

		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())

	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fRetSX3                                                                |
 | Desc:  Função que retorna o item referente ao cBox do campo                   |
 *-------------------------------------------------------------------------------*/
Static Function fRetSX3(cCampo , cConteudo)

	Local cFieldGet	:= ""
	Local cRet		:= ""
	Local aRetSX3	:= {}
	Local nPos		:= 0

	aRetSX3 := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

	If (Len(aRetSX3) > 0)

		nPos	:=	Ascan(aRetSX3 , {|x| x[2] == AllTrim(cConteudo)})

		If (nPos > 0)

			cRet	:= AllTrim(aRetSX3[nPos , 3])

		EndIf

	EndIf

Return cRet

/*-------------------------------------------------------------------------------*
 | Func:  fRetOpe                                                                |
 | Desc:  Esta funcao retorna o nome do operador, atraves do codigo de usuario.  |
 *-------------------------------------------------------------------------------*/
Static Function fRetOpe(cConteudo)
Return AllTrim(UsrRetName(cConteudo))


/*-------------------------------------------------------------------------------*
 | Func:  fRetWApp                                                                |
 | Desc:  Esta funcao informa se a arte foi enviada via Whats					  |
 *-------------------------------------------------------------------------------*/
Static Function fRetWApp(cConteudo)

	Local cQuery	:= ""
	Local cRet		:= ""

	cQuery	:= 	" SELECT "
	cQuery	+=		" ZL7.ZL7_WAPP WAPP "
	cQuery	+=	" FROM "
	cQuery	+=		RetSqlName("ZL5") + " ZL5 "
	cQuery	+=	" INNER JOIN "
	cQuery	+=		RetSqlName("ZL7") + " ZL7 "
	cQuery	+=	" ON "
	cQuery	+=		" ZL7.D_E_L_E_T_ = ' ' "
	cQuery	+=		" AND ZL5.ZL5_CODCLI = ZL7.ZL7_CODCLI "
	cQuery	+=		" AND ZL5.ZL5_LOJA = ZL7.ZL7_LOJA "
	cQuery	+=	" WHERE "
	cQuery	+=		" ZL5.D_E_L_E_T_ = ' ' "
	//cQuery	+=		" AND ZL5.ZL5_CODCLI = '" + cConteudo + "'"
	cQuery	+=		" AND ZL7.R_E_C_N_O_= "
	cQuery	+=			" (SELECT MAX(ZL7.R_E_C_N_O_) FROM ZL7010 ZL7 WHERE ZL7.D_E_L_E_T_ = '' AND ZL7.ZL7_CODCLI = '" + cConteudo + "' ) "

	cQuery	:= StrTran(cQuery , Space(2) , Space(1))

	If (Select("TMP01") > 0)

		TMP01->(dbCloseArea())

	EndIf

	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , "TMP01" , .T. , .F.)

	cRet	:= IIF(!Empty(TMP01->WAPP ) , "Sim" , "Nao" )

	TMP01->(dbCloseArea())

Return cRet