/*-------------------------------------------------------------------------------*
 | Func:  KHX007RA                                                               |
 | Desc:  Relatorio de acompanhamento de relacionamento.                         |
 | A finalidade deste relatorio, e' gerar uma planilha, demonstrando o status    |
 | dos atendimentos realizados. Informa:                                         |
 | - Se o contato foi ate' a loja e utilizou o cupom;                            |
 | - Se houve alguma compra apos o atendimento realizado;                        |
 | - Se o suspect entrou em contato com a loja;                                  |
 *-------------------------------------------------------------------------------*/

*/
//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} xRelat
Relatório - Relatorio
@author zReport
@since 14/10/2019
@version 1.0
	@example
	u_xRelat()
	@obs Função gerada pelo zReport()
/*/

User Function KHX007RA()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Local cUsers  := SuperGetMv("KH_007RA" , , "001117|001112")
	Private cPerg := ""

	If (RetCodUsr() $ cUsers) .AND. ( Pergunte("KHX007RA",.T.) )

		//Cria as definições do relatório
		oReport := fReportDef()

		//Será enviado por e-Mail?
		If lEmail
			oReport:nRemoteType := NO_REMOTE
			oReport:cEmail := cPara
			oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
			oReport:SetPreview(.F.)
			oReport:Print(.F., "", .T.)
		//Senão, mostra a tela
		Else
			oReport:PrintDialog()
		EndIf

		RestArea(aArea)

	Else

		Aviso("Erro" , "Usuario sem acesso ao relatorio")

	EndIf

Return

/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/

Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil

	//Criação do componente de impressão
	oReport := TReport():New(	"KHX007RA",;		//Nome do Relatório
								"Relatorio",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
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

	//Colunas do relatório
	TRCell():New(oSectDad, "ZL7_CODOPE", "QRY_AUX", "Nome Oper.", /*Picture*/, 30, /*lPixel*/,{|| fRetOpe(QRY_AUX->ZL7_CODOPE)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZL7_DATA", "QRY_AUX", "Dt. Atend.", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZL7_CUPOM", "QRY_AUX", "Cod. Cupom", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_NUM", "QRY_AUX", "Num. PV", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_LOJACLI", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_VALOR", "QRY_AUX", "Vlr.Total", /*Picture*/, 15, /*lPixel*/,{|| fSumPV(QRY_AUX->C5_NUM)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZL7_CODCLI", "QRY_AUX", "Cod. Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UTILIZADO_LOJA", "QRY_AUX", "Cupom reg. na loja?", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZL7_XTIPO", "QRY_AUX", "Suspect", /*Picture*/, 1, /*lPixel*/,{|| fRetTipo(QRY_AUX->ZL7_XTIPO)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_VEND", "QRY_AUX", "Vendedor", /*Picture*/, 6, /*lPixel*/,{|| fRetVend(QRY_AUX->UA_VEND) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE_NOVO", "", "Cliente Novo ?", /*Picture*/, 6, /*lPixel*/,{|| fVldData(QRY_AUX->C5_EMISSAO,QRY_AUX->ZL7_DATA) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "INDICACAO", "", "Indicacao ?", /*Picture*/, 6, /*lPixel*/,{|| fVldIndic(QRY_AUX->ACH_TEL , QRY_AUX->ZL7_DATA) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport

/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/

Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cDataDe  := ""
	Local cDataAte := ""

	cDataDe		:= dToS(MV_PAR01)
	cDataAte	:= dToS(MV_PAR02)

	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)

	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT ZL7.ZL7_CODOPE,"		+ STR_PULA
	cQryAux += "ZL7.ZL7_DATA,"		+ STR_PULA
	cQryAux +=	" CASE "		+ STR_PULA
	cQryAux += 		" WHEN SUA.UA_XCUPOM <> ' ' "		+ STR_PULA
	cQryAux += 			" THEN 'Sim'  "		+ STR_PULA
	cQryAux += 			" ELSE 'Nao'  "		+ STR_PULA
	cQryAux += " END AS UTILIZADO_LOJA,"		+ STR_PULA
	cQryAux += "ZL7.ZL7_CODCLI,"		+ STR_PULA
	cQryAux += "ZL7.ZL7_CUPOM,"		+ STR_PULA
	cQryAux += "ZL7.ZL7_XTIPO,"		+ STR_PULA
	cQryAux += "ZL7.ZL7_DATA,"		+ STR_PULA

	cQryAux += "SC5.C5_NUM,"		+ STR_PULA
	cQryAux += "SC5.C5_LOJACLI,"		+ STR_PULA
	cQryAux += "SC5.C5_EMISSAO,"		+ STR_PULA
	cQryAux += "SC5.C5_CLIENTE,"		+ STR_PULA

	cQryAux += "SC6.C6_VALOR,"		+ STR_PULA

	cQryAux += "ACH.ACH_XCUPOM,"	+ STR_PULA
	cQryAux += "ACH.ACH_TEL,"		+ STR_PULA

	cQryAux += "SUA.UA_NUMSC5,"		+ STR_PULA
	cQryAux += "SUA.UA_OPER,"		+ STR_PULA
	cQryAux += "SUA.UA_VEND"		+ STR_PULA

	cQryAux += "FROM ZL7010 ZL7 "		+ STR_PULA

	cQryAux += "LEFT JOIN ACH010 ACH"		+ STR_PULA
	cQryAux += "ON"		+ STR_PULA
	cQryAux += "ACH.D_E_L_E_T_ = ' ' AND"		+ STR_PULA
	cQryAux += "ZL7.ZL7_CUPOM = ACH.ACH_XCUPOM"		+ STR_PULA

	cQryAux += "LEFT JOIN SUA010 SUA "		+ STR_PULA
	cQryAux += "ON"		+ STR_PULA
	cQryAux += "SUA.D_E_L_E_T_ = ' ' AND"		+ STR_PULA
	cQryAux += "ZL7.ZL7_CUPOM = SUA.UA_XCUPOM"		+ STR_PULA

	cQryAux += "LEFT JOIN SC5010 SC5 "		+ STR_PULA
	cQryAux += "ON"		+ STR_PULA
	cQryAux += "SC5.D_E_L_E_T_ = ' ' AND "		+ STR_PULA
	cQryAux += "SUA.UA_CLIENTE = SC5.C5_CLIENTE"		+ STR_PULA
	cQryAux += "AND SUA.UA_LOJA = SC5.C5_LOJACLI"		+ STR_PULA
	cQryAux += "AND SUA.UA_NUMSC5 = SC5.C5_NUM"		+ STR_PULA

	cQryAux += "LEFT JOIN SC6010 SC6"		+ STR_PULA
	cQryAux += "ON SC6.D_E_L_E_T_ = ' ' AND"		+ STR_PULA
	cQryAux += "SC5.C5_MSFIL = SC6.C6_MSFIL"		+ STR_PULA
	cQryAux += "AND SC5.C5_NUM = SC6.C6_NUM"		+ STR_PULA

	cQryAux += "WHERE ZL7.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND ZL7.ZL7_XTIPO <> '2'"		+ STR_PULA //Suspect ou cupom informativo (Nao gera para brinde)
	cQryAux += "AND ZL7_DATA BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'"	+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "ZL7_DATA", "D")
	TCSetField("QRY_AUX", "C5_EMISSAO", "D")

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
 | Func:  fRetOpe                                                                |
 | Desc:  Esta funcao retorna o nome do operador, atraves do codigo de usuario.  |
 *-------------------------------------------------------------------------------*/
Static Function fRetOpe(cConteudo)
Return AllTrim(UsrRetName(cConteudo))

/*-------------------------------------------------------------------------------*
 | Func:  fSumPV                                                                  |
 | Desc:  Esta funcao retorna o valor total do PV								  |
 *-------------------------------------------------------------------------------*/
Static Function fSumPV(cConteudo)

	Local cQuery	:= ""
	Local nRet		:= 0

	If !(Empty(cConteudo))

		cQuery	:=	" SELECT "
		cQuery	+=		" SUM(SC6.C6_VALOR) VALOR "
		cQuery	+=	" FROM "
		cQuery	+=		RetSqlName("SC6") + " SC6 "
		cQuery	+=	" WHERE "
		cQuery	+=		" SC6.D_E_L_E_T_ = '' AND "
		cQuery	+=		" SC6.C6_NUM = '" + cConteudo + "'"

		cQuery	:= StrTran(cQuery , Space(2) , Space(1) )

		If (Select("TMP01") > 0 )

			TMP01->(dbCloseArea())

		EndIf

		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , "TMP01" , .T. , .F.)

		nRet	:= TMP01->VALOR

	EndIf

Return nRet

/*-------------------------------------------------------------------------------*
 | Func:  fVldData                                                               |
 | Desc:  Esta funcao verifica se a data da compra e' superior a data de atendi- |
 | mento.				  														 |
 *-------------------------------------------------------------------------------*/
Static Function fVldData(dDtCompra , dDtAtend)

Return IIf(dToS(dDtCompra) > dtoS(dDtAtend) , "Sim" , "Nao")


/*-------------------------------------------------------------------------------*
 | Func:  fRetTipo                                                               |
 | Desc:  Esta funcao verifica se o cupom e' (ou nao) de um suspect.             |
 *-------------------------------------------------------------------------------*/
Static Function fRetTipo(cTipo)

Return IIf(cTipo == "1" , "Sim" , "Nao")


/*-------------------------------------------------------------------------------*
 | Func:  fRetVend                                                               |
 | Desc:  Esta funcao retorna o nome do vendedor.                                |
 *-------------------------------------------------------------------------------*/
Static Function fRetVend(cCodigo)

Return Posicione("SA3" , 1 , xFilial("SA3") + cCodigo , "A3_NOME")


/*-------------------------------------------------------------------------------*
 | Func:  fVldIndic                                                              |
 | Desc:  Esta funcao verifica se e' um cliente de indicacao                     |
 *-------------------------------------------------------------------------------*/
Static Function fVldIndic(cTelefone , dDtAtend)

	Local cQuery	:= ""
	Local cRet		:= ""
	Local nPosAt	:= 0

	If !(Empty(AllTrim(cTelefone)))

		If ( (nPosAt	:= AT(")" , cTelefone) ) > 0 )
		
			cTelefone	:= AllTrim(SubStr(cTelefone , nPosAt + 1 , Len(cTelefone) ))		
		
		EndIf
		
		cQuery	:=	" SELECT "
		cQuery	+=		" SA1.A1_DTCAD DTCAD "
		cQuery	+=	" FROM "
		cQuery	+=		RetSqlName("SA1") + " SA1 "
		cQuery	+=	" WHERE "
		cQuery	+=		" SA1.A1_TEL+SA1.A1_TEL2+SA1.A1_XTEL3 LIKE '%" + cTelefone + "%'" //cTelefone '%963359558%'

		If (Select("TMP01") > 0)

			TMP01->(dbCloseArea())

		EndIf

		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , "TMP01" , .T. , .F.)

		cRet	:= IIF( (TMP01->(!EOF())) .AND. (TMP01->DTCAD > dToS(dDtAtend)) , "Sim" , "Nao" )
		
		TMP01->(dbCloseArea())

	Else

		cRet	:= "Nao"

	EndIf

Return cRet