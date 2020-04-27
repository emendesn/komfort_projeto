//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KHAUDR3
Relat�rio - Relatorio de Pedido de compra de Material de Limpeza
@author zReport
@since 18/02/2020
@version 1.0
	@example
	u_KHAUDR3()
	@obs Fun��o gerada pelo zReport()
/*/

User Function KHAUDR3()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Defini��es da pergunta
	cPerg := "KHAUDR003"
	Pergunte(cPerg, .T.)

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
	oReport := TReport():New(	"KHAUDR3",;		//Nome do Relat�rio
								"Relatorio PC de Material de Limpeza.",;		//T�tulo
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
	TRCell():New(oSectDad, "NUM_PEDIDO", "QRY_AUX", "Num_pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_PRODUTO", "QRY_AUX", "Cod_produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESC_PRODUTO", "QRY_AUX", "Desc_produto", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_EMISSAO", "QRY_AUX", "DATA_EMISSAO", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C7_QUANT", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C7_TOTAL", "QRY_AUX", "Vlr.Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT"		+ STR_PULA
	cQryAux += "  SC7.C7_NUM NUM_PEDIDO,"		+ STR_PULA
	cQryAux += "  SM0.FILIAL FILIAL,"		+ STR_PULA
	cQryAux += "  SB1.B1_COD COD_PRODUTO,"		+ STR_PULA
	cQryAux += "  SB1.B1_DESC DESC_PRODUTO,"		+ STR_PULA
	cQryAux += "  SC7.C7_EMISSAO DATA_EMISSAO,"		+ STR_PULA
	cQryAux += "  SC7.C7_QUANT,"		+ STR_PULA
	cQryAux += "  SC7.C7_TOTAL"		+ STR_PULA
	cQryAux += "FROM SC7010 SC7"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 SB1"		+ STR_PULA
	cQryAux += "  ON SB1.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "  AND SC7.C7_PRODUTO = B1_COD"		+ STR_PULA
	cQryAux += "INNER JOIN SM0010 SM0"		+ STR_PULA
	cQryAux += "  ON SC7.C7_FILIAL = SM0.FILFULL"		+ STR_PULA
	cQryAux += "WHERE B1_TIPO = 'MC'"		+ STR_PULA
	cQryAux += " AND SB1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += " AND SC7.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += " AND SB1.B1_MSBLQL <> '1'"		+ STR_PULA	
	cQryAux += " AND SC7.C7_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
	cQryAux += " AND SB1.B1_GRUPO = '" + MV_PAR03 + "'"
	cQryAux += " AND SC7.C7_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "'"
	cQryAux += " AND SC7.C7_NUM BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'"
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
