//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KHAUDR1
Relatório - Relatorio de Cancela Substitui
@author zReport
@since 14/02/2020
@version 1.0
	@example
	u_KHAUDR1()
	@obs Função gerada pelo zReport()
/*/

User Function KHAUDR1()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	If Pergunte("KHAUDR001" , .T.)
	
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
	oReport := TReport():New(	"KHAUDR1",;		//Nome do Relatório
								"Relatorio de Cancela Substitui",;		//Título
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
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA", "QRY_AUX", "Data", /*Picture*/, 8, /*lPixel*/,{|| dData := fConvData(QRY_AUX->DATA) },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido Cancelado", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CODIGO", "QRY_AUX", "Codigo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR", "QRY_AUX", "Valor", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "Vendedor", "QRY_AUX", "Vendedor", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO_NOVO", "QRY_AUX", "Pedido Novo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

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
	cQryAux += "SELECT SM0.FILIAL FILIAL,"
	cQryAux += "SC5.C5_EMISSAO DATA,"
	cQryAux += "SC5.C5_NUM PEDIDO,"
	cQryAux += "SA1.A1_NOME CLIENTE,"
	cQryAux += "SB1.B1_COD CODIGO,"
	cQryAux += "SB1.B1_DESC DESCRICAO,"
	cQryAux += "SC6.C6_VALOR VALOR,"
	cQryAux += "SA3.A3_NOME Vendedor, "
	cQryAux += "(SELECT TOP 1 C5_NUM FROM SC5010(NOLOCK) C5 INNER JOIN SUC010(NOLOCK) SUC ON C5_01SAC = UC_CODIGO WHERE SUC.D_E_L_E_T_ = '' AND UC_01PED = Z16.Z16_XFILIA + Z16.Z16_NUMPV ) PEDIDO_NOVO "

	cQryAux += "FROM Z16010 Z16 "

	cQryAux += "INNER JOIN SC5010 SC5 "
	cQryAux += "ON SC5.C5_MSFIL = Z16.Z16_XFILIA "
	cQryAux += "AND SC5.C5_NUM = Z16.Z16_NUMPV "

	cQryAux += "INNER JOIN SC6010 SC6 "
	cQryAux += "ON SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQryAux += "AND SC5.C5_NUM = SC6.C6_NUM "

	cQryAux += "INNER JOIN SA1010 SA1 "
	cQryAux += "ON SA1.A1_FILIAL = '" + xFilial('SA1') + "' "
	cQryAux += "AND SC5.C5_CLIENT = SA1.A1_COD "
	cQryAux += "AND SC5.C5_LOJACLI = SA1.A1_LOJA "

	cQryAux += "INNER JOIN SA3010 SA3 "
	cQryAux += "ON SA3.A3_FILIAL = '" + xFilial("SA3")  + "' "
	cQryAux += "AND SA3.A3_COD = SC5.C5_VEND1 "

	cQryAux += "INNER JOIN SB1010 SB1 "
	cQryAux += "ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQryAux += "AND SB1.B1_COD = SC6.C6_PRODUTO "

	cQryAux += "INNER JOIN SM0010 SM0 "
	cQryAux += "ON Z16.Z16_XFILIA = SM0.FILFULL "

	cQryAux += "AND SC5.D_E_L_E_T_ = ' ' "
	cQryAux += "AND SC6.D_E_L_E_T_ = ' ' "
	cQryAux += "AND SA1.D_E_L_E_T_ = ' ' "
	cQryAux += "AND SA3.D_E_L_E_T_ = ' ' "
	cQryAux += "AND Z16.Z16_XFILIA BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
	cQryAux += "AND Z16.Z16_EMISSA BETWEEN '" + dToS(MV_PAR03) + "' AND '" + dToS(MV_PAR04) + "'"	
	cQryAux += "GROUP BY FILIAL, C5_EMISSAO,C5_NUM,A1_NOME,B1_COD,B1_DESC,C6_VALOR,A3_NOME,Z16_XFILIA,Z16_NUMPV "
	cQryAux += "ORDER BY FILIAL, C5_NUM "

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

/*-------------------------------------------------------------------------------*
 | Func:  fConvData                                                              |
 | Desc:  Função que converte a data para impressao                              |
 *-------------------------------------------------------------------------------*/
Static Function fConvData(cData)	

Return sToD(cData)