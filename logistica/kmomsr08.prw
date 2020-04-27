//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KMOMSR08
Relatório - Relatorio de CargaxMotorista
@author zReport
@since 11/02/2019
@version 1.0
@example
u_KMOMSR08()
@obs Função gerada pelo zReport()
/*/

User Function KMOMSR08()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Definições da pergunta
	cPerg := "KMOMSR08  "

	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	ELSE
		pergunte(cPerg)
	EndIf

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
	oReport := TReport():New(	"KMOMSR08",;		//Nome do Relatório
	"Relatorio de CargaxMotorista",;		//Título
	cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
	{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
	)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()

	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
	"Dados",;		//Descrição da seção
	{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	//Colunas do relatório
	TRCell():New(oSectDad, "DAI_COD", "QRY_AUX", "Cod. Carga", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DAK_COD", "QRY_AUX", "Cod. Carga", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DAK_DATA", "QRY_AUX", "Data", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DAK_MOTORI", "QRY_AUX", "Motorista", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DA4_NOME", "QRY_AUX", "Motorista", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DA4_NREDUZ", "QRY_AUX", "Nome Reduzid", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DAK_XSERVI", "QRY_AUX", "Srv. Adicion", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_FRETE", "QRY_AUX", "Valor_frete", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_TOTAL", "QRY_AUX", "Valor_total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_FRETE", "QRY_AUX", "Tipo_frete", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CARGA_ENTREGUE", "QRY_AUX", "Carga_entregue", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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

	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)

	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT DAI_COD, DAK_COD,DAK_DATA,DAK_MOTORI,DA4_NOME,DA4_NREDUZ,"		+ STR_PULA
	cQryAux += "DAK_XSERVI,"		+ STR_PULA
	cQryAux += "CASE WHEN DAK_XVALOR > 0 THEN DAK_XVALOR ELSE MAX(DA7_XVALOR) END VALOR_FRETE,"		+ STR_PULA
	cQryAux += "CASE WHEN DAK_XVALOR > 0 THEN 'VALOR NEGOCIADO' ELSE 'VALOR TABELA' END TIPO_FRETE,"		+ STR_PULA
	cQryAux += "CASE WHEN DAK_XVALOR > 0 THEN DAK_XVALOR + DAK_XSERVI  ELSE MAX(DA7_XVALOR) + DAK_XSERVI END VALOR_TOTAL,"		+ STR_PULA
	cQryAux += "CASE WHEN DAK_ACECAR = '1' THEN 'ENTREGUE' ELSE 'NÃO ENTREGUE' END CARGA_ENTREGUE"		+ STR_PULA
	cQryAux += "FROM SF2010 SF2 (NOLOCK)"		+ STR_PULA
	cQryAux += "INNER JOIN SA1010 SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = '' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA"		+ STR_PULA
	cQryAux += "INNER JOIN DA7010 DA7 (NOLOCK) ON DA7.D_E_L_E_T_ = '' AND SUBSTRING(F2_FILIAL,1,2) = DA7_FILIAL AND A1_CEP BETWEEN DA7_CEPDE AND DA7_CEPATE"		+ STR_PULA
	cQryAux += "INNER JOIN DAI010 DAI (NOLOCK) ON DAI.D_E_L_E_T_ = '' AND DAI_FILIAL = F2_FILIAL AND DAI_NFISCA = F2_DOC AND DAI_SERIE = F2_SERIE"		+ STR_PULA
	cQryAux += "INNER JOIN DAK010 DAK (NOLOCK) ON DAK.D_E_L_E_T_ = '' AND DAK_FILIAL = DAI_FILIAL AND DAK_COD = DAI_COD"		+ STR_PULA
	cQryAux += "LEFT JOIN DA4010 DA4 (NOLOCK) ON DA4.D_E_L_E_T_ = '' AND DA4.DA4_COD = DAK_MOTORI AND DA4_FILIAL = SUBSTRING(DAK_FILIAL,1,2)"		+ STR_PULA
	cQryAux += "WHERE SF2.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND DAK_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"		+ STR_PULA
	cQryAux += "GROUP BY DAI_COD, DAK_COD, DAK_DATA, DAK_MOTORI, DA4_NOME, DA4_NREDUZ, DAK_XSERVI, DAK_XVALOR, DAK_ACECAR"		+ STR_PULA
	cQryAux += "ORDER BY DAK_COD"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "DAK_DATA", "D")

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
