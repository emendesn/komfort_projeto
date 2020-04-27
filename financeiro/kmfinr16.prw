#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFINR16  ºAutor  ³Everton Santos        º Data ³  28/05/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Contas a receber por cliente.                º±±
±±º          ³  Filtra apenas por tipo Boleto.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMFINR16
Relatório - Contas a Receber por Cliente  
@author zReport
@since 31/05/2019
@version 1.0
	@example
	u_KMFINR16()
	@obs Função gerada pelo zReport()
/*/	
User Function KMFINR16()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMFINR16  "
	
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
	oReport := TReport():New(	"KMFINR16",;		//Nome do Relatório
								"Contas a Receber por Cliente",;		//Título
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
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS_PEDIDO", "QRY_AUX", "Status  Pedido", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_CLIENTE", "QRY_AUX", "Nome Cliente", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CPF", "QRY_AUX", "CPF", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_PAGTO", "QRY_AUX", "Tipo Pagto", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NATUREZA", "QRY_AUX", "Natureza", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PARCELA", "QRY_AUX", "Parcela", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PARC_VENCIDAS", "QRY_AUX", "Parcelas Vencidas","@E 99", 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUM_NSU", "QRY_AUX", "Num Nsu", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENCIMENTO", "QRY_AUX", "Vencimento", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL_VENCIDO", "QRY_AUX", "Total Vencido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR", "QRY_AUX", "Valor Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS", "QRY_AUX", "Status", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIXA", "QRY_AUX", "Baixa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENDERECO", "QRY_AUX", "Endereco", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIRRO", "QRY_AUX", "Bairro", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CEP", "QRY_AUX", "Cep", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DDD", "QRY_AUX", "DDD.", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEL1", "QRY_AUX", "Tel1", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEL2", "QRY_AUX", "Tel2", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEL3", "QRY_AUX", "Tel3", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMAIL", "QRY_AUX", "Email", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
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
	
	cQryAux += "SELECT DISTINCT"		+ STR_PULA
	cQryAux += "E1_NUM AS TITULO, "		+ STR_PULA
	cQryAux += "CASE WHEN E1_PEDIDO = '' THEN E1_XPEDORI ELSE E1_PEDIDO END PEDIDO,"	+ STR_PULA
	cQryAux += "E1_XDESCFI AS FILIAL, "		+ STR_PULA
	cQryAux += "ISNULL(DAH_XDESCR,'SEM REGISTRO') AS STATUS_PEDIDO, "		+ STR_PULA
	cQryAux += "A1_NOME AS NOME_CLIENTE, "		+ STR_PULA
	cQryAux += "A1_CGC AS CPF, "		+ STR_PULA
	cQryAux += "E1_TIPO AS TIPO_PAGTO, "		+ STR_PULA
	cQryAux += "E1_NATUREZ AS NATUREZA, "		+ STR_PULA
	cQryAux += "E1_PARCELA AS PARCELA, "		+ STR_PULA
	cQryAux += "(SELECT COUNT(E1_PARCELA) FROM SE1010 SE1 WHERE E1_STATUS = 'A' AND SE1.E1_NUM = E1.E1_NUM AND SE1.E1_TIPO = 'BOL' AND E1_VENCREA < GETDATE() AND D_E_L_E_T_ = '') AS PARC_VENCIDAS,"	+ STR_PULA
	cQryAux += "E1_NSUTEF AS NUM_NSU, "		+ STR_PULA
	cQryAux += "E1_EMISSAO AS EMISSAO, "		+ STR_PULA
	cQryAux += "E1_VENCREA AS VENCIMENTO, "		+ STR_PULA
	cQryAux += "(SELECT ISNULL(SUM(E1_VALOR + 35),0) FROM SE1010 SE1 WHERE E1_STATUS = 'A' AND SE1.E1_NUM = E1.E1_NUM AND SE1.E1_TIPO = 'BOL' AND E1_VENCREA < GETDATE() AND D_E_L_E_T_ = '') AS TOTAL_VENCIDO,"	+ STR_PULA
	cQryAux += "E1_VALOR AS VALOR,"		+ STR_PULA
	cQryAux += "CASE"		+ STR_PULA
	cQryAux += "WHEN E1_STATUS = 'B' THEN 'BAIXADO'"		+ STR_PULA
	cQryAux += "WHEN E1_STATUS = 'A' THEN 'EM ABERTO'"		+ STR_PULA
	cQryAux += "END AS STATUS, "		+ STR_PULA
	cQryAux += "E1_BAIXA AS BAIXA, "		+ STR_PULA
	cQryAux += "A1_END AS ENDERECO, "		+ STR_PULA
	cQryAux += "A1_BAIRRO AS BAIRRO, "		+ STR_PULA
	cQryAux += "A1_CEP AS CEP,"		+ STR_PULA
	cQryAux += "A1_DDD AS DDD, "		+ STR_PULA
	cQryAux += "A1_TEL AS TEL1, "		+ STR_PULA
	cQryAux += "A1_TEL2 AS TEL2, "		+ STR_PULA
	cQryAux += "A1_CONTATO AS TEL3, "		+ STR_PULA
	cQryAux += "A1_EMAIL AS EMAIL    "		+ STR_PULA
	cQryAux += "FROM SE1010(NOLOCK) E1 "		+ STR_PULA
	cQryAux += "INNER JOIN SA1010(NOLOCK) A1  ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND E1_FILIAL = A1_FILIAL "	+ STR_PULA
	cQryAux += "INNER JOIN SC6010(NOLOCK) C6 ON C6.C6_CLI = E1.E1_CLIENTE "	+ STR_PULA
    cQryAux += "INNER JOIN SC5010(NOLOCK) C5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "	+ STR_PULA
    cQryAux += "LEFT JOIN SD2010 D2 (NOLOCK) ON D2.D_E_L_E_T_ = '' AND SUBSTRING(C5_FILIAL,1,2) = SUBSTRING(D2_FILIAL,1,2) AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV "	+ STR_PULA
    cQryAux += "LEFT JOIN SD1010 D1 (NOLOCK) ON D1.D_E_L_E_T_ = '' AND D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA AND D2_ITEM = D1_ITEMORI "	+ STR_PULA
	cQryAux += "LEFT JOIN DAI010(NOLOCK) DAI ON DAI_PEDIDO = E1_PEDIDO AND DAI_CLIENT = E1_CLIENTE "+ STR_PULA
	cQryAux += "LEFT JOIN DAH010(NOLOCK) DAH ON DAH_CODCAR = DAI_COD AND DAI_CLIENT = DAH_CODCLI AND DAI_SEQUEN = DAH_SEQUEN AND DAH.D_E_L_E_T_ = '' "	+ STR_PULA
	cQryAux += "WHERE E1_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"'"		+ STR_PULA
	cQryAux += "AND E1_VENCREA BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"'"		+ STR_PULA
	cQryAux += "AND E1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"		+ STR_PULA
	cQryAux += "AND A1_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"		+ STR_PULA
	cQryAux += "AND E1_STATUS BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"	+ STR_PULA
	cQryAux += "AND E1_TIPO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"		+ STR_PULA
	cQryAux += "AND E1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND A1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "GROUP BY E1_NUM, E1_PEDIDO, E1_XPEDORI, E1_XDESCFI, DAH_XDESCR, A1_NOME, A1_CGC, E1_TIPO, E1_NATUREZ,E1_PARCELA, E1_STATUS, E1_NSUTEF, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_BAIXA, A1_END, A1_BAIRRO, A1_CEP, A1_DDD, A1_TEL, A1_TEL2, A1_CONTATO, A1_EMAIL"	+ STR_PULA
	cQryAux += "ORDER BY E1_NUM, E1_PARCELA" + STR_PULA
	
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "EMISSAO", "D")
	TCSetField("QRY_AUX", "VENCIMENTO", "D")
	TCSetField("QRY_AUX", "BAIXA", "D")
	
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
