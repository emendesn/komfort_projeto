//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHAUDRA
Relatório - Chamados de Assistencia       
@author zReport
@since 30/10/2019
@version 1.0
	@example
	u_KHAUDRA()
	@obs Função gerada pelo zReport()
/*/
	
User Function KHAUDRA()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KHAUDRA   "
	
	Pergunte("KHAUDRA   ")
	
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
	oReport := TReport():New(	"KHAUDRA",;		//Nome do Relatório
								"Chamados de Assistencia",;		//Título
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
	TRCell():New(oSectDad, "CHAMADO",  "QRY_AUX", "Chamado", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL",   "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO",  "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OPERADOR", "QRY_AUX", "Operador", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO",  "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
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
	cQryAux += "SELECT UC_CODIGO CHAMADO, FILIAL, UC_DATA EMISSAO ,U7_NOME OPERADOR, UD_PRODUTO PRODUTO   FROM SUC010(NOLOCK) UC" + STR_PULA
	cQryAux += "INNER JOIN SUD010(NOLOCK) UD ON UC_CODIGO = UD_CODIGO"		+ STR_PULA
	cQryAux += "INNER JOIN SM0010(NOLOCK) SM0 ON UC_MSFIL = SM0.FILFULL"	+ STR_PULA
	cQryAux += "INNER JOIN SU7010(NOLOCK) U7 ON U7_COD = UC_OPERADO"		+ STR_PULA
	cQryAux += "WHERE UD_ASSUNTO = '000002'" + STR_PULA
	cQryAux += "AND UD_PRODUTO <> ''"		+ STR_PULA
	cQryAux += "AND UC.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND UD.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND U7.D_E_L_E_T_ = ''"		+ STR_PULA
	
	cQryAux += "AND FILFULL   BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"'" + STR_PULA
	cQryAux += "AND UC_DATA   BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"'" + STR_PULA
	
	If MV_PAR05 == 1
		cQryAux += "AND UC_STATUS <> '3'" + STR_PULA
	EndIf
	
	If MV_PAR05 == 2
		cQryAux += "AND UC_STATUS = '3'" + STR_PULA
	EndIf
	
	If MV_PAR05 == 3
		cQryAux += "AND UC_STATUS BETWEEN '' AND 'ZZZ'" + STR_PULA
	EndIf	
	
	cQryAux += "GROUP BY UC_CODIGO,UC_DATA, FILIAL,UD_PRODUTO,U7_NOME" + STR_PULA
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
