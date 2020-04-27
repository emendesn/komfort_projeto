//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMFINR15
Relatório - Relatorio Credito - Boleto    
@author zReport
@since 05/02/2019
@version 1.0
	@example
	u_KMFINR15()
	@obs Função gerada pelo zReport()
/*/
	
User Function KMFINR15()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMFINR15  "
	
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
	oReport := TReport():New(	"KMFINR15",;		//Nome do Relatório
								"Relatorio Credito - Boleto",;		//Título
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
	TRCell():New(oSectDad, "UA_NUM", "QRY_AUX", "Atendimento", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_EMISSAO", "QRY_AUX", "Emissão", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XDTENV", "QRY_AUX", "Dt Env Cred", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_01FILIA", "QRY_AUX", "Loja", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_NOME", "QRY_AUX", "Nome", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_VLRLIQ", "QRY_AUX", "Vlr.Bruto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTRADA", "QRY_AUX", "Entrada", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_VALOR", "QRY_AUX", "Vlr.Financiado", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_PARCELA", "QRY_AUX", "Parcelas", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XPERLIB", "QRY_AUX", "Bloqueio", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XSTATUS", "QRY_AUX", "Status Cred", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_NUMSC5", "QRY_AUX", "Ped SIGAFAT", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XATCRED", "QRY_AUX", "Analista", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_STATUS", "QRY_AUX", "Cancelado", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XHRAPRO", "QRY_AUX", "Hora Aprov", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E1_DOCTEF", "QRY_AUX", "Cod.Aprov", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DELETADO", "QRY_AUX", "Deletado", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

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
	cQryAux += "SELECT"																							+ STR_PULA
	cQryAux += "UA_NUM,"																						+ STR_PULA
	cQryAux += "UA_EMISSAO,"																					+ STR_PULA
	cQryAux += "UA_XDTENV,"																				    	+ STR_PULA
	cQryAux += "UA_01FILIA,"																					+ STR_PULA
	cQryAux += "A1_NOME,"																						+ STR_PULA
	cQryAux += "UA_VLRLIQ, "																					+ STR_PULA
	cQryAux += "ISNULL((UA_VLRLIQ - E1_VALOR),0)  AS ENTRADA,"													+ STR_PULA
	cQryAux += "ISNULL(E1_VALOR,0) E1_VALOR,"																    + STR_PULA
	cQryAux += "ISNULL(E1_PARCELA,0) E1_PARCELA,"					                                            + STR_PULA
	cQryAux += "UA_XPERLIB,"					                                                                + STR_PULA
	cQryAux += "CASE WHEN UA_XSTATUS = '1' THEN 'EM ABERTO'"													+ STR_PULA
	cQryAux += "	 WHEN UA_XSTATUS = '2' THEN 'EM ATENDIMENTO'"												+ STR_PULA
	cQryAux += "	 WHEN UA_XSTATUS = '3' THEN 'APROVADO'"														+ STR_PULA
	cQryAux += "	 WHEN UA_XSTATUS = '4' THEN 'SUGERIDO'"														+ STR_PULA
	cQryAux += "	 WHEN UA_XSTATUS = '5' THEN 'REANALISE'"													+ STR_PULA
	cQryAux += "	 ELSE '' END UA_XSTATUS,"																	+ STR_PULA
	cQryAux += "UA_NUMSC5,"	                                                                                    + STR_PULA
	cQryAux += "UA_XATCRED,"																                    + STR_PULA
	cQryAux += "(CASE WHEN UA_STATUS = 'CAN' THEN 'SIM' ELSE 'NÃO' END) AS UA_STATUS,"							+ STR_PULA
	cQryAux += "UA_XHRAPRO, "																                    + STR_PULA
	cQryAux += "E1_DOCTEF,"																                        + STR_PULA
	cQryAux += "CASE  WHEN UA.D_E_L_E_T_ = '*' THEN 'SIM' ELSE '' END DELETADO "								+ STR_PULA
	cQryAux += "FROM SUA010 UA(NOLOCK)"																			+ STR_PULA
	cQryAux += "INNER JOIN SA1010 A1 (NOLOCK) ON A1.A1_COD = UA_CLIENTE AND A1.D_E_L_E_T_ <> '*'"				+ STR_PULA
	cQryAux += "LEFT JOIN ("																				    + STR_PULA
	cQryAux += "SELECT E1_NUM,E1_PEDIDO,COUNT(E1_PARCELA) E1_PARCELA,E1_MSFIL, SUM(E1_VALOR) E1_VALOR, E1_TIPO,E1_FORMREC,E1_DOCTEF "					+ STR_PULA
	cQryAux += "FROM  SE1010 E1(NOLOCK) "																		+ STR_PULA
	cQryAux += "WHERE E1.E1_TIPO IN ('BOL','CHK') AND E1.D_E_L_E_T_ = '' AND E1.E1_PEDIDO = E1_NUM "			+ STR_PULA
	cQryAux += "GROUP BY E1_NUM,E1_PEDIDO, E1_MSFIL, E1_TIPO,E1_FORMREC,E1_DOCTEF"								+ STR_PULA
	cQryAux += ") E1 ON E1.E1_PEDIDO = UA.UA_NUMSC5 AND E1.E1_MSFIL = UA.UA_FILIAL"								+ STR_PULA
	cQryAux += "WHERE  UA_XDTENV BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"							+ STR_PULA
	cQryAux += "GROUP BY UA_NUM,UA_EMISSAO,UA_XDTENV,UA_01FILIA,A1_NOME,E1_TIPO,UA_VLRLIQ,E1_PARCELA,E1_VALOR,UA_XPERLIB,UA_XSTATUS,UA_NUMSC5,E1_PEDIDO,UA_XATCRED,UA_STATUS,UA_XHRAPRO,E1_DOCTEF,UA.D_E_L_E_T_ "		+ STR_PULA
	cQryAux += "ORDER BY E1_PEDIDO" + STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "UA_EMISSAO", "D")
	TCSetField("QRY_AUX", "UA_XDTENV", "D")
	TCSetField("QRY_AUX", "UA_XDTAPRO", "D")
	
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
