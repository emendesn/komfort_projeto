//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KHAUDR2
Relatório - Relatorio de RA em Aberto
@author zReport
@since 17/02/2020
@version 1.0
	@example
	u_KHAUDR2()
	@obs Função gerada pelo zReport()
/*/

User Function KHAUDR2()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Cria as definições do relatório
	oReport := fReportDef()

	If (Pergunte("KHAUDR002" , .T.))

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
	Local oBreak   := Nil

	//Criação do componente de impressão
	oReport := TReport():New(	"KHAUDR2",;		//Nome do Relatório
								"Relatorio RA em Aberto",;		//Título
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
	TRCell():New(oSectDad, "COD_LOJA", "QRY_AUX", "Cod. Loja", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL",   "QRY_AUX", "FILIAL", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO",  "QRY_AUX", "EMISSAO", /*Picture*/, 8, /*lPixel*/,{|| dData := fConvData(QRY_AUX->EMISSAO)},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO",   "QRY_AUX", "TITULO", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR",    "QRY_AUX", "VALOR", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE",  "QRY_AUX", "CLIENTE", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR", "QRY_AUX", "VENDEDOR", /*Picture*/,40 , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	
	
	cQryAux += " SELECT E1_MSFIL COD_LOJA, E1_XDESCFI FILIAL, E1_EMISSAO EMISSAO, E1_NUM TITULO, E1_VALOR VALOR,E1_NOMCLI CLIENTE, A3_NOME VENDEDOR" + STR_PULA
	cQryAux += " FROM SE1010 SE1 (NOLOCK) "	+ STR_PULA
	cQryAux += " INNER JOIN SA3010(NOLOCK) SA3 ON SA3.A3_COD = SE1.E1_VEND1 " + STR_PULA
	cQryAux += " WHERE SE1.D_E_L_E_T_ <> '*' " + STR_PULA
	cQryAux += " AND SA3.D_E_L_E_T_ = '' "	   + STR_PULA
	cQryAux += " AND SE1.E1_STATUS = 'A' "	   + STR_PULA
	cQryAux += " AND SE1.E1_TIPO = 'RA' "	   + STR_PULA
	cQryAux += " AND SE1.E1_SALDO > 0 "		+ STR_PULA
	cQryAux += " AND SE1.E1_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "	+ STR_PULA
	cQryAux += " ORDER BY E1_MSFIL,E1_EMISSAO "		+ STR_PULA	

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


/*-------------------------------------------------------------------------------*
 | Func:  fConvData                                                              |
 | Desc:  Função que converte a data para impressao                              |
 *-------------------------------------------------------------------------------*/
Static Function fConvData(cData)

Return sToD(cData)