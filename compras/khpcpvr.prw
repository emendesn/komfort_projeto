#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

user function KHPCPVR()

Local aArea   := GetArea()
Local oReport
Local lEmail  := .F.
Local cPara   := ""
Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KHPCPVR   "
	Pergunte("KHPCPVR   ")
	
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
	oReport := TReport():New(	"Necessidade de Pedido de Compra",;		//Nome do Relatório
								"Necessidade de Pedido de Compra",;		//Título
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
	TRCell():New(oSectDad, "C6_MSFIL",   "QRY_AUX", "Filial", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_NUM",     "QRY_AUX", "Numero", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC",    "QRY_AUX", "Descricao", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_ITEM",    "QRY_AUX", "Item", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_QTDVEN",  "QRY_AUX", "Qnt Venda", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_LOCAL",   "QRY_AUX", "Armazem", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_PROC",    "QRY_AUX", "Fornecedor", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NECESSIDADE","QRY_AUX", "Necessidade PC", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT C6_MSFIL,C5_EMISSAO,C5_NUM,C6_PRODUTO,B1_DESC,C6_ITEM,C6_QTDVEN,C6_LOCAL,B1_PROC,"		+ STR_PULA
	cQryAux += "((SELECT COUNT(C6_NUM)"		+ STR_PULA
	cQryAux += "FROM SC6010(NOLOCK) SC6"		+ STR_PULA
	cQryAux += "INNER JOIN SC5010(NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC5.C5_NUM = SC6.C6_NUM"		+ STR_PULA
	cQryAux += "LEFT JOIN  SC9010(NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010(NOLOCK) SB1 ON SC6.C6_PRODUTO = SB1.B1_COD"		+ STR_PULA
	cQryAux += "WHERE SC6.D_E_L_E_T_ = ' '	"		+ STR_PULA
	cQryAux += "AND SC5.D_E_L_E_T_ = ' '	"		+ STR_PULA
	cQryAux += "AND C6_BLQ <> 'R'"		+ STR_PULA
	cQryAux += "AND C6_RESERVA = ' '"		+ STR_PULA
	cQryAux += "AND C5_NOTA = ' '"		+ STR_PULA
	cQryAux += "AND C6_NOTA = ' '"		+ STR_PULA
	cQryAux += "AND ISNULL(C9_BLEST,'XX') <> ''"		+ STR_PULA
	cQryAux += "AND (SELECT (B2_QATU-B2_RESERVA) AS SALDO FROM " + RetSqlName("SB2")+ " (NOLOCK) WHERE B2_COD = C6_PRODUTO AND B2_FILIAL = '0101' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' ') = 0"		+ STR_PULA
	cQryAux += "AND B1_XENCOME = '2'"		+ STR_PULA
	cQryAux += "AND C6_PRODUTO = S26.C6_PRODUTO"		+ STR_PULA
	cQryAux += "AND C6_NUM NOT IN (SELECT C7_01NUMPV FROM SC7010 WHERE C7_01NUMPV = C6_NUM AND C6_PRODUTO=C7_PRODUTO AND D_E_L_E_T_ = ' ' AND C7_RESIDUO <> 'S' ))"		+ STR_PULA
	cQryAux += "-"		+ STR_PULA
	cQryAux += "(SELECT COUNT(C7_NUM) "		+ STR_PULA
	cQryAux += "FROM SC7010(NOLOCK) SC7"		+ STR_PULA
	cQryAux += "INNER JOIN  SB1010 SB1 ON SC7.C7_PRODUTO = SB1.B1_COD"		+ STR_PULA
	cQryAux += "WHERE (C7_01NUMPV = '000000' OR C7_01NUMPV = '')"		+ STR_PULA
	cQryAux += "AND SC7.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND SB1.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND C7_RESIDUO <> 'S'"		+ STR_PULA
	cQryAux += "AND C7_QUJE = 0"		+ STR_PULA
	cQryAux += "AND B1_XENCOME = '2'"		+ STR_PULA
	cQryAux += "AND B1_TIPO = 'ME'"		+ STR_PULA
	cQryAux += "AND C7_PRODUTO = S26.C6_PRODUTO)) NECESSIDADE "		+ STR_PULA
	cQryAux += "FROM SC6010(NOLOCK) S26"		+ STR_PULA
	cQryAux += "INNER JOIN SC5010(NOLOCK) SC5 ON SC5.C5_MSFIL = S26.C6_MSFIL AND SC5.C5_NUM = S26.C6_NUM"		+ STR_PULA
	cQryAux += "LEFT JOIN  SC9010(NOLOCK) SC9 ON S26.C6_NUM = SC9.C9_PEDIDO AND S26.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010(NOLOCK) SB1 ON S26.C6_PRODUTO = SB1.B1_COD"		+ STR_PULA
	cQryAux += "WHERE S26.D_E_L_E_T_ = ' '	"		+ STR_PULA
	cQryAux += "AND SC5.D_E_L_E_T_ = ' '	"		+ STR_PULA
	cQryAux += "AND C6_BLQ <> 'R'"		+ STR_PULA
	cQryAux += "AND C6_RESERVA = ' '"		+ STR_PULA
	cQryAux += "AND C6_TES <> '602'"		+ STR_PULA
	cQryAux += "AND C5_NOTA = ' '"		+ STR_PULA
	cQryAux += "AND C6_NOTA = ' '"		+ STR_PULA
	cQryAux += "AND ISNULL(C9_BLEST,'XX') <> ''"		+ STR_PULA
	cQryAux += "AND (SELECT (B2_QATU-B2_RESERVA) AS SALDO FROM " + RetSqlName("SB2") + "(NOLOCK) WHERE B2_COD = C6_PRODUTO AND B2_FILIAL = '0101' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' ') = 0" + STR_PULA
	cQryAux += "AND B1_XENCOME = '2'"		+ STR_PULA
	cQryAux += "AND C6_NUM NOT IN (SELECT C7_01NUMPV FROM SC7010 WHERE C7_01NUMPV = C6_NUM AND C6_PRODUTO=C7_PRODUTO AND D_E_L_E_T_ = ' ' AND C7_RESIDUO <> 'S' )" 	+ STR_PULA
	
	cQryAux += "AND B1_PROC BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'" + STR_PULA
	
	cQryAux += "ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM" + STR_PULA
	
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	TCSetField("QRY_AUX", "C5_EMISSAO",  "D")
	
	
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
return