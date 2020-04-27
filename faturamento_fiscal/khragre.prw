//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHRAGRE
Relat�rio - Relat de Agregados a Faturar  
@author zReport
@since 06/05/2019 - Marcio Nunes
@version 1.0
	@example
	u_KHRAGRE()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function KHRAGRE()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
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
	oReport := TReport():New(	"KHRAGRE",;		//Nome do Relat�rio
								"Relat de Agregados a Faturar",;		//T�tulo
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
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UA_NUMSC5", "QRY_AUX", "Ped SIGAFAT", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VLRITENS", "QRY_AUX", "Vlritens", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT SUA.UA_FILIAL FILIAL, SUA.UA_NUMSC5, SUM(SC6.C6_VALOR) AS VLRITENS"		+ STR_PULA
	cQryAux += "FROM SUA010 SUA (NOLOCK) "		+ STR_PULA
	cQryAux += "INNER JOIN SC5010 SC5 (NOLOCK) ON SC5.C5_MSFIL = SUA.UA_FILIAL AND SC5.C5_NUM = SUA.UA_NUMSC5 AND SC5.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "INNER JOIN SC6010 SC6 (NOLOCK) ON SC6.C6_MSFIL=SC5.C5_MSFIL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ <>'*' "		+ STR_PULA
	cQryAux += "WHERE SUA.D_E_L_E_T_ <> '*' "		+ STR_PULA
	cQryAux += "AND SB1.B1_XACESSO ='1'"		+ STR_PULA
	cQryAux += "AND SUA.UA_NUMSC5 <> '' "		+ STR_PULA
	cQryAux += "AND SUA.UA_STATUS <> 'CAN' "		+ STR_PULA 
	cQryAux += "AND SUA.UA_CANC <> 'S' "		+ STR_PULA
	cQryAux += "AND SUA.UA_EMISSAO >= '20190520'"		+ STR_PULA //Data inicial ap�s a ultima auditoria de lojas com ajuste de estoque
	cQryAux += "AND SUA.UA_DOC =''"		+ STR_PULA
	cQryAux += "AND SUA.UA_FILIAL <> '0101'"		+ STR_PULA
	cQryAux += "AND (SC5.C5_PEDPEND IN (' ','3','4') OR ((SELECT SUM(SE1.E1_VALOR-SE1.E1_SALDO) FROM SE1010 SE1 WHERE E1_NUM = SUA.UA_NUMSC5 AND E1_BAIXA > 0 AND D_E_L_E_T_ <> '*' GROUP BY E1_NUM) >= SC6.C6_VALOR AND C6_BLQ <> 'R'))"		+ STR_PULA
	cQryAux += "AND SC6.C6_NOTA = '' "		+ STR_PULA
	cQryAux += "GROUP BY SUA.UA_NUMSC5, SUA.UA_FILIAL"		+ STR_PULA
	cQryAux += "ORDER BY SUA.UA_FILIAL"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
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
