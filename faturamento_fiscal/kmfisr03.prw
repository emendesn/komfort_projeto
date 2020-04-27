//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"


	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFISR03  ºAutor  ³Murilo Zoratti        º Data ³  14/02/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Notas MaiorxMenor                                         º±±
±±º          ³  Chamado: P65-LHL-5H66                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KMFISR03
Relatório - Vendas por loja
@author zReport
@since 13/02/2019
@version 1.0
@example
u_KMFISR03()
@obs Função gerada pelo zReport()
/*/

User Function KMFISR03()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	Private cData := MV_PAR01+MV_PAR02

	//Definições da pergunta
	cPerg := "KMFISR03  "

	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	Else
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
	oReport := TReport():New(	"KMFISR03",;		//Nome do Relatório
	"Notas MaiorxMenor",;		//Título
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
	TRCell():New(oSectDad, "F2_LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MAIOR", "QRY_AUX", "Maior", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MENOR", "QRY_AUX", "Menor", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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

	IF MV_PAR03 = 1	//Sintético
		//Montando consulta de dados
		cQryAux := ""
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "	F2_LOJA,"		+ STR_PULA
		cQryAux += "	MAX(SUBSTRING(F2_EMISSAO,1,6)) EMISSAO,"		+ STR_PULA
		cQryAux += "	MAX(F2_DOC) AS MAIOR,"		+ STR_PULA
		cQryAux += "	MIN(F2_DOC) AS MENOR,"		+ STR_PULA
		cQryAux += "	'SAIDA'	AS TIPO"		+ STR_PULA
		cQryAux += "	FROM SF2010"		+ STR_PULA
		cQryAux += "	WHERE SUBSTRING(F2_EMISSAO,1,6) = '" + MV_PAR01  +"" + MV_PAR02  +"'		" + STR_PULA
		cQryAux += "GROUP BY F2_LOJA"		+ STR_PULA
		cQryAux += "ORDER BY F2_LOJA"
		cQryAux := ChangeQuery(cQryAux)

	ElseIF MV_PAR03 = 2
		cQryAux := ""
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "	F1_LOJA,"		+ STR_PULA
		cQryAux += "	MAX(SUBSTRING(F1_EMISSAO,1,6)) EMISSAO,"		+ STR_PULA
		cQryAux += "	MAX(F1_DOC) AS MAIOR,"		+ STR_PULA
		cQryAux += "	MIN(F1_DOC) AS MENOR,"		+ STR_PULA
		cQryAux += "	'ENTRADA'	AS TIPO"		+ STR_PULA
		cQryAux += "	FROM SF1010"		+ STR_PULA
		cQryAux += "	WHERE SUBSTRING(F1_EMISSAO,1,6) = '" + MV_PAR01  +"" + MV_PAR02  +"'		" + STR_PULA
		cQryAux += "GROUP BY F1_LOJA"		+ STR_PULA
		cQryAux += "ORDER BY F1_LOJA"		+ STR_PULA
		cQryAux := ChangeQuery(cQryAux)

	ElseIF MV_PAR03 = 3
		cQryAux := ""
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "	F2_LOJA,"		+ STR_PULA
		cQryAux += "	MAX(SUBSTRING(F2_EMISSAO,1,6)) EMISSAO,"		+ STR_PULA
		cQryAux += "	MAX(F2_DOC) AS MAIOR,"		+ STR_PULA
		cQryAux += "	MIN(F2_DOC) AS MENOR,"		+ STR_PULA
		cQryAux += "	'SAIDA'	AS TIPO"		+ STR_PULA
		cQryAux += "	FROM SF2010"		+ STR_PULA
		cQryAux += "	WHERE SUBSTRING(F2_EMISSAO,1,6) = '" + MV_PAR01  +"" + MV_PAR02  +"'		" + STR_PULA
		cQryAux += "GROUP BY F2_LOJA"		+ STR_PULA
		cQryAux += "UNION ALL" + STR_PULA
		cQryAux += "SELECT "		+ STR_PULA
		cQryAux += "	F1_LOJA,"		+ STR_PULA
		cQryAux += "	MAX(SUBSTRING(F1_EMISSAO,1,6)) EMISSAO,"		+ STR_PULA
		cQryAux += "	MAX(F1_DOC) AS MAIOR,"		+ STR_PULA
		cQryAux += "	MIN(F1_DOC) AS MENOR,"		+ STR_PULA
		cQryAux += "	'ENTRADA'	AS TIPO"		+ STR_PULA
		cQryAux += "	FROM SF1010"		+ STR_PULA
		cQryAux += "	WHERE SUBSTRING(F1_EMISSAO,1,6) = '" + MV_PAR01  +"" + MV_PAR02  +"'		" + STR_PULA
		cQryAux += "GROUP BY F1_LOJA"		+ STR_PULA
		cQryAux += "ORDER BY F2_LOJA"		+ STR_PULA
		cQryAux := ChangeQuery(cQryAux)
	EndIf

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
