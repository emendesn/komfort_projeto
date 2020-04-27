//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHPEDLOJ
Relatório - Pedidos por Loja              
@author zReport
@since 31/10/2019
@version 1.0
	@example
	u_KHPEDLOJ()
	@obs Função gerada pelo zReport()
/*/
	
User Function KHPEDLOJ()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KHPEDLOJ   "
	
	Pergunte("KHPEDLOJ   ")
	
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
	oReport := TReport():New(	"KHPEDLOJ",;		//Nome do Relatório
								"Pedidos por Loja",;		//Título
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
	TRCell():New(oSectDad, "CODLOJA",     "QRY_AUX", "Cod.Loja", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL",      "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO",      "QRY_AUX", "Pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CODVEND",     "QRY_AUX", "Cod.Vendedor", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR",    "QRY_AUX", "Vendedor", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO",     "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
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
	cQryAux += "SELECT C5_MSFIL CODLOJA,FILIAL,C5_NUM PEDIDO,A3_COD CODVEND,A3_NREDUZ VENDEDOR,C5_EMISSAO EMISSAO" + STR_PULA
	cQryAux += "FROM SC5010 SC5" + STR_PULA
	cQryAux += "INNER JOIN SM0010(NOLOCK) ON C5_MSFIL = FILFULL" + STR_PULA
	cQryAux += "INNER JOIN SUA010(NOLOCK) SUA ON C5_NUMTMK = UA_NUM AND C5_MSFIL = UA_FILIAL" + STR_PULA
	cQryAux += "INNER JOIN SE1010(NOLOCK) SE1 ON C5_MSFIL = E1_MSFIL AND (C5_NUM = E1_NUM AND C5_01SAC='' OR (C5_NUM = E1_PEDIDO AND C5_01SAC='')) AND C5_CLIENTE = E1_CLIENTE AND C5_LOJACLI = E1_LOJA" + STR_PULA
	cQryAux += "INNER JOIN SA3010(NOLOCK) SA3 ON C5_VEND1 = A3_COD"	+ STR_PULA
	cQryAux += "WHERE C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"'"	+ STR_PULA
	cQryAux += "AND SC5.D_E_L_E_T_ = ''" + STR_PULA
	cQryAux += "AND SE1.D_E_L_E_T_ = ''" + STR_PULA
	cQryAux += "AND SUA.D_E_L_E_T_ = ''" + STR_PULA
	cQryAux += "AND SA3.D_E_L_E_T_ = ''" + STR_PULA
	cQryAux += "GROUP BY C5_MSFIL,FILIAL,C5_NUM,A3_COD,A3_NREDUZ,C5_EMISSAO" + STR_PULA
	cQryAux += "ORDER BY 1" + STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	TCSetField("QRY_AUX", "EMISSAO", "D")
		
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
