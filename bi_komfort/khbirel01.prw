//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KHBIREL01
Relatório - Verificação de NF [4BIS ->precompra.php]
@author Luis Artuso
@since 23/10/2019
@version 1.0
	@example
	u_KHBIREL01()
	@obs Função gerada pelo zReport()
/*/

User Function KHBIREL01()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Local cUsers	:= SuperGetMv("KH_BIREL01" , NIL , "000000")
	Private cPerg := ""

	If (Pergunte('KHBIREL01 ' , .T.))

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

	Else

		MsgAlert("Usuario sem acesso ao relatorio")

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
	oReport := TReport():New(	"KHBIREL01",;		//Nome do Relatório
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
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMNOTA", "QRY_AUX", "Nota", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATAREF", "QRY_AUX", "Entrada", /*Picture*/, 8, /*lPixel*/,{|| dToC(sToD(QRY_AUX->DATAREF))},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Valor Nota", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TABELA", "QRY_AUX", "Custo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONDICAO", "QRY_AUX", "Condicao", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SITUACAO", "QRY_AUX", "Situacao", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT A2_NREDUZ FORNECEDOR, D1_COD PRODUTO, B1_DESC DESCRICAO, D1_DOC NUMNOTA, D1_DTDIGIT DATAREF, "		+ STR_PULA
	cQryAux += "	D1_VUNIT NOTA, B1_CUSTD TABELA, E4_COND CONDICAO,"		+ STR_PULA
	cQryAux += "	CASE "		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000022' AND E4_COND = '15,30' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000024' AND E4_COND = '30' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000025' AND E4_COND = '15,30' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000026' AND E4_COND = '30,60' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000040' AND E4_COND = '30' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000082' AND E4_COND = '15,30' THEN 'OK'"		+ STR_PULA
	cQryAux += "	WHEN A2_COD = '000379' AND E4_COND = '30,60' THEN 'OK'"		+ STR_PULA
	cQryAux += "	ELSE 'ERRO'"		+ STR_PULA
	cQryAux += "	END SITUACAO"		+ STR_PULA
	cQryAux += "FROM SD1010 SD1 (NOLOCK)"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND D1_COD = B1_COD"		+ STR_PULA
	cQryAux += "INNER JOIN SF4010 SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = '' AND D1_TES = F4_CODIGO AND F4_DUPLIC = 'S'"		+ STR_PULA
	cQryAux += "INNER JOIN SF1010 SF1 (NOLOCK) ON SF1.D_E_L_E_T_ = '' AND D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA"		+ STR_PULA
	cQryAux += "INNER JOIN SE4010 SE4 (NOLOCK) ON SE4.D_E_L_E_T_ = '' AND F1_COND = E4_CODIGO"		+ STR_PULA
	cQryAux += "INNER JOIN SA2010 SA2 (NOLOCK) ON SA2.D_E_L_E_T_ = '' AND F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA"		+ STR_PULA
	cQryAux += "WHERE SD1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "	AND D1_TIPO = 'N'"		+ STR_PULA
	cQryAux += "	AND D1_DTDIGIT BETWEEN '" + dToS(MV_PAR01) + "' AND '" + dToS(MV_PAR02)	+ "'" + STR_PULA
	cQryAux += "	AND B1_TIPO = 'ME'"		+ STR_PULA
	cQryAux += "	AND ROUND(D1_VUNIT,2) <> ROUND(B1_CUSTD,2)"		+ STR_PULA
	cQryAux += "	AND ( (ROUND(D1_VUNIT,2) - ROUND(B1_CUSTD,2)) > 0.01 OR (ROUND(D1_VUNIT,2) - ROUND(B1_CUSTD,2)) < -0.01 )"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)

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
