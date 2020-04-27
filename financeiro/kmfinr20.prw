//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMFINR20
Relat�rio - Pedidos c\ Pendencia n�o liber
@author zReport
@since 21/12/2019
@version 1.0
	@example
	u_KMFINR20()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function KMFINR20()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "KMFINR20  "
	
	//Se a pergunta n�o existir, zera a vari�vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
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
	oReport := TReport():New(	"KMFINR20",;		//Nome do Relat�rio
								"Pedidos c\ Pendencia n�o liber",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;			//Objeto TReport que a se��o pertence
									"Dados",;			//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
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
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "C5_EMISSAO", "D")
	
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
