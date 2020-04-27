//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMFINR20
Relatório - Pedidos c\ Pendencia não liber
@author zReport
@since 21/12/2019
@version 1.0
	@example
	u_KMFINR20()
	@obs Função gerada pelo zReport()
/*/
	
User Function KMFINR20()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMFINR20  "
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
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
	oReport := TReport():New(	"KMFINR20",;		//Nome do Relatório
								"Pedidos c\ Pendencia não liber",;		//Título
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
	TRCell():New(oSectDad, "UA_NUMSC5", "QRY_AUX", "Ped SIGAFAT", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_NOME", "QRY_AUX", "Nome", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_XPERLIB", "QRY_AUX", "Perc. Liber", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_MINIMO", "QRY_AUX", "Valor_minimo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "RECEBIDO", "QRY_AUX", "Recebido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT UA_NUMSC5,C5_EMISSAO,A1_NOME,FILIAL,UA_XPERLIB, (UA_VLRLIQ/100)*UA_XPERLIB AS VALOR_MINIMO,"		+ STR_PULA
	cQryAux += "(SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ') "		+ STR_PULA
	cQryAux += "+ "		+ STR_PULA
	cQryAux += "(SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') AS RECEBIDO"		+ STR_PULA
	cQryAux += "FROM SUA010(NOLOCK) SUA"		+ STR_PULA
	cQryAux += "INNER JOIN SC5010(NOLOCK) SC5 ON SC5.C5_NUM = SUA.UA_NUMSC5 AND SUA.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "INNER JOIN SA1010(NOLOCK) SA1 ON SUA.UA_CLIENTE = SA1.A1_COD AND SA1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SM0010(NOLOCK) SM0 ON SM0.FILFULL = SUA.UA_FILIAL"		+ STR_PULA
	cQryAux += "WHERE SC5.C5_PEDPEND = '2'"		+ STR_PULA
	cQryAux += "AND (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO NOT IN ('BOL','CHK','RA') AND D_E_L_E_T_ = ' ') + (SELECT CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR FROM SE1010(NOLOCK) WHERE E1_MSFIL = SUA.UA_FILIAL AND E1_PEDIDO = SUA.UA_NUMSC5 AND E1_CLIENTE = SUA.UA_CLIENTE AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B' AND D_E_L_E_T_ = ' ') >= (UA_VLRLIQ/100)*UA_XPERLIB"		+ STR_PULA
	cQryAux += "AND C5_NOTA = ''"		+ STR_PULA
	cQryAux += "AND SC5.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "ORDER BY C5_EMISSAO"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "C5_EMISSAO", "D")
	
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
