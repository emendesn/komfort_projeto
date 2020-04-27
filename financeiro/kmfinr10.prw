//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMFINR10
Relatório - Relatório Conta a Pagar       
@author zReport
@since 06/02/2019
@version 1.0
	@example
	u_KMFINR10()
	@obs Função gerada pelo zReport()
/*/
	
User Function KMFINR10()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMFINR10  "
	
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
	oReport := TReport():New(	"KMFINR10",;		//Nome do Relatório
								"Relatório Conta a Pagar",;		//Título
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
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO", "QRY_AUX", "Numero", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "HISTORICO", "QRY_AUX", "Historico", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NSU", "QRY_AUX", "Cód Ass Jur", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PARCNSU", "QRY_AUX", "Parcnsu", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PARCELA", "QRY_AUX", "Parcela", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCNAT", "QRY_AUX", "Descnat", /*Picture*/, 150, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR", "QRY_AUX", "Valor", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NCART", "QRY_AUX", "Ncart", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO1", "QRY_AUX", "Emissao1", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENC", "QRY_AUX", "Venc", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENCREA", "QRY_AUX", "Vencrea", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CARTAO", "QRY_AUX", "Cartao", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIXA", "QRY_AUX", "Baixa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PORTADO", "QRY_AUX", "Portado", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_BAIXA", "QRY_AUX", "Tipo_baixa", /*Picture*/, 11, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMDEV", "QRY_AUX", "NF Devolucao", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo Doc", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	TRCell():New(oSectDad, "MOTBAIXA", "QRY_AUX", "Mot. Baixa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)		
	TRCell():New(oSectDad, "VLRCOMPENSA", "QRY_AUX", "Vlr Compen.", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)		

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
	cQryAux += "SELECT"		+ STR_PULA
	cQryAux += "		E2_MSFIL FILIAL,"		+ STR_PULA
	cQryAux += "		E2_NUM NUMERO, "		+ STR_PULA
	cQryAux += "		E2_TIPO TIPO, "		+ STR_PULA
	cQryAux += "		E2_NOMFOR NOME,"		+ STR_PULA
	cQryAux += "		E2_HIST HISTORICO,"		+ STR_PULA
	cQryAux += "		E2_XNSUTEF NSU, "		+ STR_PULA
	cQryAux += "		E2_XPARNSU PARCNSU,"		+ STR_PULA
	cQryAux += "		E2_PARCELA PARCELA,"		+ STR_PULA
	cQryAux += "		ED_DESCRIC DESCNAT, "		+ STR_PULA
	cQryAux += "		E2_VALOR VALOR, "		+ STR_PULA
	cQryAux += "		E2_XNCART4 NCART, "		+ STR_PULA
	cQryAux += "		E2_EMISSAO EMISSAO,"		+ STR_PULA
	cQryAux += "		E2_EMIS1 EMISSAO1,"		+ STR_PULA
	cQryAux += "		E2_VENCTO  VENC,"		+ STR_PULA
	cQryAux += "		E2_VENCREA VENCREA,"		+ STR_PULA
	cQryAux += "		E2_XFLAG CARTAO,"		+ STR_PULA
	cQryAux += "		E2_BAIXA BAIXA,"		+ STR_PULA
	cQryAux += "		E2_PORTADO PORTADO,"		+ STR_PULA
	cQryAux += "		CASE  "		+ STR_PULA
	cQryAux += "		WHEN E2_PORTADO = ''  AND  E2_BAIXA = ''   THEN 'EM ABERTO'"		+ STR_PULA
	cQryAux += "		WHEN E2_PORTADO <> ''  AND  E2_BAIXA = ''   THEN 'EM ABERTO'"		+ STR_PULA
	cQryAux += "	    WHEN E2_PORTADO <>''  AND  E2_BAIXA <> ''  THEN 'NORMAL'"		+ STR_PULA
	cQryAux += "	    WHEN E2_PORTADO = '' AND  E2_BAIXA <> '' AND E2_TIPO ='PA' THEN 'NORMAL'"		+ STR_PULA
	cQryAux += "	    WHEN E2_PORTADO = '' AND  E2_BAIXA <> '' THEN 'DACAO'"		+ STR_PULA
	cQryAux += "        END  TIPO_BAIXA, "		+ STR_PULA
	cQryAux += "        E5_NUMERO NUMDEV, E5_TIPODOC TIPO, E5_MOTBX MOTBAIXA, E5_VALOR VLRCOMPENSA " + STR_PULA
	cQryAux += "FROM SE2010(NOLOCK) E2 "		+ STR_PULA
	cQryAux += "INNER JOIN SED010 ED ON ED.ED_CODIGO = E2.E2_NATUREZ AND ED.D_E_L_E_T_ = '' "		+ STR_PULA              
	cQryAux += "LEFT JOIN SE5010 E5 ON (E5.E5_CLIFOR = E2.E2_FORNECE AND E5.E5_LOJA = E2.E2_LOJA AND E2.E2_PARCELA = E5.E5_PARCELA AND E5.E5_DOCUMEN LIKE '%'+E2.E2_NUM+'%') " + STR_PULA              	
	cQryAux += "WHERE E2.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"		+ STR_PULA
	cQryAux += "AND E2_MSFIL BETWEEN '"+MV_PAR03+"'AND '"+MV_PAR04+"'"		+ STR_PULA
	cQryAux += "AND E2_TIPO BETWEEN '"+MV_PAR05+"'AND '"+MV_PAR06+"'"		+ STR_PULA
	cQryAux += "AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'"		+ STR_PULA
	cQryAux += "ORDER BY E2_MSFIL, E2_NUM, E2_PARCELA, E2_TIPO, E2_XPARNSU"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "EMISSAO", "D")
	TCSetField("QRY_AUX", "EMISSAO1", "D")
	TCSetField("QRY_AUX", "VENC", "D")
	TCSetField("QRY_AUX", "VENCREA", "D")
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
