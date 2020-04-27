//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHPOSR01
Relat�rio - Relatorio                     
@author zReport
@since 06/05/2019
@version 1.0
	@example
	u_KHPOSR01()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function KHPOSR01()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	
	//Defini��es da pergunta
	cPerg := "KHPOSR001 "
	
	//Se a pergunta n�o existir, zera a vari�vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	ELSE
		pergunte(cPerg)
	EndIf
	//Cria as defini��es do relat�rio
	oReport := fReportDef()
	
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
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun��o que monta a defini��o do relat�rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"KHPOSR01",;		//Nome do Relat�rio
								"Relatorio",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;			//Objeto TReport que a se��o pertence
									"Dados",;			//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad, "CHAMADO", "QRY_AUX", "Chamado", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS_CH", "QRY_AUX", "Status_ch", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_CLIENTE", "QRY_AUX", "Cod_cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMIISAO_CH", "QRY_AUX", "Emiisao_ch", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO_PV", "QRY_AUX", "Emissao_pv", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR", "QRY_AUX", "Vendedor", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ANALISTA", "QRY_AUX", "Analista", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ATEND_LOJA", "QRY_AUX", "Atend_loja", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ATEN_GERENTE", "QRY_AUX", "Aten_gerente", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ATEN_VENDEDOR", "QRY_AUX", "Aten_vendedor", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OPR_COMPRA", "QRY_AUX", "Opr_compra", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "APRO_CREDITO", "QRY_AUX", "Apro_credito", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ATEN_SAC", "QRY_AUX", "Aten_sac", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGEND_ENREGA", "QRY_AUX", "Agend_enrega", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AVAR_ENTREGA", "QRY_AUX", "Avar_entrega", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRZO_ENTREGA", "QRY_AUX", "Przo_entrega", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ACOM_CLIENTE", "QRY_AUX", "Acom_cliente", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUALI_PRODUTO", "QRY_AUX", "Quali_produto", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TROCA", "QRY_AUX", "Troca", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CUSTO_BENEFICIO", "QRY_AUX", "Custo_beneficio", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GERAL", "QRY_AUX", "Geral", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 8000, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT "		+ STR_PULA
	cQryAux += "ZKA_CHAMAD AS CHAMADO,"		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN SUC.UC_STATUS = '1' THEN 'PLANEJADA' WHEN SUC.UC_STATUS = '2' THEN 'PENDENTE' WHEN SUC.UC_STATUS = '3' THEN 'ENCERRADO' WHEN SUC.UC_STATUS = '4' THEN 'EM ANDAMENTO'"		+ STR_PULA
	cQryAux += "WHEN SUC.UC_STATUS = '5' THEN 'VISITA TEC' WHEN SUC.UC_STATUS = '6' THEN 'DEVOLUCAO' WHEN SUC.UC_STATUS = '7' THEN 'RETORNO' WHEN SUC.UC_STATUS = '8' THEN 'TROCA AUT'"		+ STR_PULA
	cQryAux += "WHEN SUC.UC_STATUS = '9' THEN 'EMAIL FAB' WHEN SUC.UC_STATUS = '10' THEN 'CANCELADO'"		+ STR_PULA
	cQryAux += "END STATUS_CH, "		+ STR_PULA
	cQryAux += "ZKA_CODCLI AS COD_CLIENTE,"		+ STR_PULA
	cQryAux += "SU5.U5_CONTAT AS NOME,"		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN SM0.FILIAL IS NULL  THEN 'N�O INFORMADO' "		+ STR_PULA
	cQryAux += "ELSE SM0.FILIAL"		+ STR_PULA
	cQryAux += "END FILIAL,"		+ STR_PULA
	cQryAux += "SUC.UC_DATA AS EMIISAO_CH,"		+ STR_PULA
	cQryAux += "SC5.C5_NUM AS PEDIDO,"		+ STR_PULA
	cQryAux += "SC5.C5_EMISSAO AS EMISSAO_PV,"		+ STR_PULA
	cQryAux += "SA3.A3_NOME AS VENDEDOR,"		+ STR_PULA
	cQryAux += "SU7.U7_NOME AS ANALISTA,"		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_ATELOJ = '1' THEN 'SATISFEITO' WHEN ZKA_ATELOJ = '2' THEN 'REGULAR' WHEN ZKA_ATELOJ = '3' THEN 'INSATISFEITO' WHEN ZKA_ATELOJ = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END ATEND_LOJA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_ATENGE = '1' THEN 'SATISFEITO' WHEN ZKA_ATENGE = '2' THEN 'REGULAR' WHEN ZKA_ATENGE = '3' THEN 'INSATISFEITO' WHEN ZKA_ATENGE = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END ATEN_GERENTE, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_ATENVE = '1' THEN 'SATISFEITO' WHEN ZKA_ATENVE = '2' THEN 'REGULAR' WHEN ZKA_ATENVE = '3' THEN 'INSATISFEITO' WHEN ZKA_ATENVE = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END ATEN_VENDEDOR, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_OPOCOM = '1' THEN 'SATISFEITO' WHEN ZKA_OPOCOM = '2' THEN 'REGULAR' WHEN ZKA_OPOCOM = '3' THEN 'INSATISFEITO' WHEN ZKA_OPOCOM = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END OPR_COMPRA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_APROCR = '1' THEN 'SATISFEITO' WHEN ZKA_APROCR = '2' THEN 'REGULAR' WHEN ZKA_APROCR = '3' THEN 'INSATISFEITO' WHEN ZKA_APROCR = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END APRO_CREDITO, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_ATESAC = '1' THEN 'SATISFEITO' WHEN ZKA_ATESAC = '2' THEN 'REGULAR' WHEN ZKA_ATESAC = '3' THEN 'INSATISFEITO' WHEN ZKA_ATESAC = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END ATEN_SAC, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_AGEENT = '1' THEN 'SATISFEITO' WHEN ZKA_AGEENT = '2' THEN 'REGULAR' WHEN ZKA_AGEENT = '3' THEN 'INSATISFEITO' WHEN ZKA_AGEENT = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END AGEND_ENREGA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_AVAENT = '1' THEN 'SATISFEITO' WHEN ZKA_AVAENT = '2' THEN 'REGULAR' WHEN ZKA_AVAENT = '3' THEN 'INSATISFEITO' WHEN ZKA_AVAENT = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END AVAR_ENTREGA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_PRZENT = '1' THEN 'SATISFEITO' WHEN ZKA_PRZENT = '2' THEN 'REGULAR' WHEN ZKA_PRZENT = '3' THEN 'INSATISFEITO' WHEN ZKA_PRZENT = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END PRZO_ENTREGA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_ACOCLI = '1' THEN 'SATISFEITO' WHEN ZKA_ACOCLI = '2' THEN 'REGULAR' WHEN ZKA_ACOCLI = '3' THEN 'INSATISFEITO' WHEN ZKA_ACOCLI = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END ACOM_CLIENTE, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_QUAPRO = '1' THEN 'SATISFEITO' WHEN ZKA_QUAPRO = '2' THEN 'REGULAR' WHEN ZKA_QUAPRO = '3' THEN 'INSATISFEITO' WHEN ZKA_QUAPRO = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END QUALI_PRODUTO, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_TROCA = '1' THEN 'SATISFEITO' WHEN ZKA_TROCA = '2' THEN 'REGULAR' WHEN ZKA_TROCA = '3' THEN 'INSATISFEITO' WHEN ZKA_TROCA = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END TROCA, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_CUSBEN = '1' THEN 'SATISFEITO' WHEN ZKA_CUSBEN = '2' THEN 'REGULAR' WHEN ZKA_CUSBEN = '3' THEN 'INSATISFEITO' WHEN ZKA_CUSBEN = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END CUSTO_BENEFICIO, "		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN ZKA_GERAL = '1' THEN 'SATISFEITO' WHEN ZKA_GERAL = '2' THEN 'REGULAR' WHEN ZKA_GERAL = '3' THEN 'INSATISFEITO' WHEN ZKA_GERAL = '4' THEN 'ND'"		+ STR_PULA
	cQryAux += "END GERAL,"		+ STR_PULA
	cQryAux += "ISNULL(CAST(CAST(ZKA_OBSERV AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS"		+ STR_PULA
	cQryAux += "FROM ZKA010(NOLOCK) ZKA"		+ STR_PULA
	cQryAux += "INNER JOIN SU5010 (NOLOCK)SU5"		+ STR_PULA
	cQryAux += "ON SU5.U5_CODCONT = ZKA.ZKA_CODCLI"		+ STR_PULA
	cQryAux += "INNER JOIN SUC010(NOLOCK) SUC"		+ STR_PULA
	cQryAux += "ON SUC.UC_CODIGO = ZKA.ZKA_CHAMAD"		+ STR_PULA
	cQryAux += "INNER JOIN SC5010 (NOLOCK) SC5 "		+ STR_PULA
	cQryAux += "ON C5_NUM = RIGHT(RTRIM(UC_01PED),6)"		+ STR_PULA
	cQryAux += "INNER JOIN SU7010 (NOLOCK) SU7 "		+ STR_PULA
	cQryAux += "ON U7_COD = UC_OPERADO "		+ STR_PULA
	cQryAux += "INNER JOIN SA3010(NOLOCK) SA3"		+ STR_PULA
	cQryAux += "ON A3_COD = C5_VEND1"		+ STR_PULA
	cQryAux += "LEFT JOIN SM0010(NOLOCK) SM0"		+ STR_PULA
	cQryAux += "ON  SM0.FILFULL = UC_XFILIAL"		+ STR_PULA
	cQryAux += "WHERE SUC.UC_DATA BETWEEN  '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r�gua
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
