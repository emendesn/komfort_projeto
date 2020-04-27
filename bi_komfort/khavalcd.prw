//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHAVALCD
Relatório - Relatorio                     
@author zReport
@since 17/10/2019
@version 1.0
	@example
	u_KHAVALCD()
	@obs Função gerada pelo zReport()
/*/
//Everton Santos - 17/10/2019	
User Function KHAVALCD()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Pergunte 
	cPerg := "KHAVALCD"
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
	else
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
	oReport := TReport():New(	"Avaliação CD",;		//Nome do Relatório
								"Avaliação CD",;		//Título
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
	TRCell():New(oSectDad, "DEPARTAMENTO", "QRY_AUX", "Departamento", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FUNCIONARIO", "QRY_AUX", "Funcionario", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA", "QRY_AUX", "Nota", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 16, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "  DEPARTAMENTO,"		+ STR_PULA
	cQryAux += "  FUNCIONARIO,"		+ STR_PULA
	cQryAux += "  (NOTA / TOTAVAL) NOTA,"		+ STR_PULA
	cQryAux += "  CASE"		+ STR_PULA
	cQryAux += "    WHEN SITUACAO <> '' THEN SITUACAO"		+ STR_PULA
	cQryAux += "    WHEN (NOTA / TOTAVAL) >= 9 THEN 'OTIMO'"		+ STR_PULA
	cQryAux += "    WHEN (NOTA / TOTAVAL) BETWEEN 8 AND 8.99 THEN 'BOM'"		+ STR_PULA
	cQryAux += "    WHEN (NOTA / TOTAVAL) BETWEEN 7 AND 7.99 THEN 'REGULAR'"		+ STR_PULA
	cQryAux += "    WHEN (NOTA / TOTAVAL) BETWEEN 6 AND 6.99 THEN 'A MELHORAR'"		+ STR_PULA
	cQryAux += "    WHEN (NOTA / TOTAVAL) BETWEEN 0.01 AND 5.99 THEN 'PONTO DE ATENCAO'"		+ STR_PULA
	cQryAux += "    ELSE ''"		+ STR_PULA
	cQryAux += "  END OBS"		+ STR_PULA
	cQryAux += "FROM (SELECT"		+ STR_PULA
	cQryAux += "      ZKF_NOMAVA DEPARTAMENTO,"		+ STR_PULA
	cQryAux += "      ZKF_NOADOR FUNCIONARIO,"		+ STR_PULA
	cQryAux += "      SUM(ZKF_TOTAL * ZKF_PESO) NOTA,"		+ STR_PULA
	cQryAux += "      SUM(ZKF_PESO) TOTAVAL,"		+ STR_PULA
	cQryAux += "      MAX(CASE"		+ STR_PULA
	cQryAux += "      WHEN ZKF_FERIAS = 'E' THEN 'EXPERIENCIA'"		+ STR_PULA
	cQryAux += "      WHEN ZKF_FERIAS = 'F' THEN 'FERIAS'"		+ STR_PULA
	cQryAux += "      WHEN ZKF_FERIAS = 'A' THEN 'AFASTADO'"		+ STR_PULA
	cQryAux += "      ELSE ''"		+ STR_PULA
	cQryAux += "      END) SITUACAO"		+ STR_PULA
	cQryAux += "FROM ZKF010(NOLOCK) ZKF"		+ STR_PULA
	cQryAux += "WHERE ZKF.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND ZKF_PESO > 0"		+ STR_PULA
	cQryAux += "AND ZKF_DTINCL BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"		+ STR_PULA
	cQryAux += "AND ZKF_CODAVA IN ('000088', '000087', '000085', '000086', '000082', '000083', '000010', '000011', '000009', '000012', '000090', '000089', '000079', '000084', '000091', '000080', '000081')"		+ STR_PULA
	cQryAux += "GROUP BY ZKF_NOMAVA,"		+ STR_PULA
	cQryAux += "         ZKF_NOADOR) AS W1"		+ STR_PULA
	cQryAux += "ORDER BY DEPARTAMENTO, FUNCIONARIO"		+ STR_PULA
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
