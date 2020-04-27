//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMRFAT04
Relatório - NF à Faturar por Filial       
@author zReport
@since 04/06/2019
@version 1.0
	@example
	u_KMRFAT04()
	@obs Função gerada pelo zReport()
/*/
	
User Function KMRFAT04()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMRFAT04  "
	
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
	oReport := TReport():New(	"KMRFAT04",;		//Nome do Relatório
								"NF à Faturar por Filial",;		//Título
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
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT C5_MSFIL AS FILIAL, C5_NUM AS PEDIDO, C5_NOTA AS NOTA, C5_CLIENTE AS CLIENTE, C5_LOJACLI AS LOJA FROM SC5010 SC5"		+ STR_PULA
	cQryAux += "INNER JOIN SC6010 SC6 ON SC5.C5_MSFIL = SC6.C6_MSFIL AND SC6.C6_NUM = SC5.C5_NUM"		+ STR_PULA
	cQryAux += "INNER JOIN SC9010 SC9 ON SC9.C9_MSFIL = SC6.C6_MSFIL AND SC9.C9_PRODUTO = SC6.C6_PRODUTO AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC6.C6_ITEM = SC9.C9_ITEM   "		+ STR_PULA
	cQryAux += "INNER JOIN SFT010 SFT ON SFT.FT_FILIAL = SC5.C5_MSFIL AND SFT.FT_NFISCAL = SC5.C5_NOTA AND SFT.FT_CLIEFOR = SC5.C5_CLIENTE AND SFT.FT_LOJA = SC5.C5_LOJAENT   "		+ STR_PULA
	cQryAux += "WHERE "											+ STR_PULA
	cQryAux += "SC5.D_E_L_E_T_ ='' AND "						+ STR_PULA
	cQryAux += "SC5.C5_SERIE ='1' AND"							+ STR_PULA
	cQryAux += "SC5.C5_MSFIL <>'0101' AND"						+ STR_PULA
	cQryAux += "SFT.FT_CHVNFE = '' AND"							+ STR_PULA
	cQryAux += "SFT.D_E_L_E_T_ = '' AND"						+ STR_PULA
	cQryAux += "SFT.FT_DTCANC = '' AND"							+ STR_PULA
	cQryAux += "SC6.C6_ENTREG  >= '"+DTOS(MV_PAR01)+"' AND"		+ STR_PULA
	cQryAux += "SC6.C6_ENTREG  <= '"+DTOS(MV_PAR02)+"' AND"		+ STR_PULA
	cQryAux += "SC6.D_E_L_E_T_ ='' AND    				"		+ STR_PULA
	cQryAux += "SC9.C9_NFISCAL = ' ' AND"						+ STR_PULA
	cQryAux += "SC9.C9_BLEST = '' AND"							+ STR_PULA
	cQryAux += "SC9.C9_BLCRED = '' AND"							+ STR_PULA
	cQryAux += "SC9.C9_QTDLIB > 0 AND"							+ STR_PULA
	cQryAux += "SC9.D_E_L_E_T_ =''"								+ STR_PULA
	cQryAux += "GROUP BY C5_MSFIL, C5_NUM, C5_NOTA, C5_CLIENTE, C5_LOJACLI"		+ STR_PULA
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
