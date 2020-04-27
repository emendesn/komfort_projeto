//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"


	/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFISR03  �Autor  �Murilo Zoratti        � Data �  14/02/19 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Notas MaiorxMenor                                         ���
���          �  Chamado: P65-LHL-5H66                                     ���
�������������������������������������������������������������������������͹��
���Uso       � komfort                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KMFISR03
Relat�rio - Vendas por loja
@author zReport
@since 13/02/2019
@version 1.0
@example
u_KMFISR03()
@obs Fun��o gerada pelo zReport()
/*/

User Function KMFISR03()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	Private cData := MV_PAR01+MV_PAR02

	//Defini��es da pergunta
	cPerg := "KMFISR03  "

	//Se a pergunta n�o existir, zera a vari�vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	Else
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
	oReport := TReport():New(	"KMFISR03",;		//Nome do Relat�rio
	"Notas MaiorxMenor",;		//T�tulo
	cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
	{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
	)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()

	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
	"Dados",;		//Descri��o da se��o
	{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	//Colunas do relat�rio
	TRCell():New(oSectDad, "F2_LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MAIOR", "QRY_AUX", "Maior", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MENOR", "QRY_AUX", "Menor", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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

	IF MV_PAR03 = 1	//Sint�tico
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
