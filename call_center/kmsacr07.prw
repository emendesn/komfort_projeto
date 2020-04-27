//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMSACR07
Relatório - Relatorio NCC                 
@author zReport
@since 24/01/2019
@version 1.0
	@example
	u_KMSACR07()
	@obs Função gerada pelo zReport()
/*/
	
User Function KMSACR07()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "KMSACR07  "
	
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
	oReport := TReport():New(	"KMSACR07",;		//Nome do Relatório
								"Relatorio NCC",;		//Título
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
	TRCell():New(oSectDad, "COD_CLI", "QRY_AUX", "Cod_cli", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FIL_PEDORIL", "QRY_AUX", "Fil_pedoril", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PED_ORI", "QRY_AUX", "Ped_ori", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_PEDORI", "QRY_AUX", "Valor_pedori", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_NCC", "QRY_AUX", "Valor_ncc", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSA", "QRY_AUX", "Emissa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FIL_PEDNV", "QRY_AUX", "Fil_pednv", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PED_NOVO", "QRY_AUX", "Ped_novo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_PED", "QRY_AUX", "Valor_ped", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIF", "QRY_AUX", "Diferença", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DT_LIBE", "QRY_AUX", "Dt_libe", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "USUARIO", "QRY_AUX", "Usuario", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "E1_CLIENTE COD_CLI,"		+ STR_PULA
	cQryAux += "A1_NOME NOME,"		+ STR_PULA
	cQryAux += "M0X.FILIAL FIL_PEDORIL,"		+ STR_PULA
	cQryAux += "CASE WHEN LEN(E1_XPEDORI) < 6 THEN 'NETGERA' ELSE E1_XPEDORI END PED_ORI,"		+ STR_PULA
	cQryAux += "C5X.C5_EMISSAO EMISSAO,"		+ STR_PULA
	cQryAux += "SUM(C6X.C6_VALOR + C5X.C5_FRETE + C5X.C5_DESPESA) AS VALOR_PEDORI,"		+ STR_PULA
	cQryAux += "M0.FILIAL FIL_PEDNV,"		+ STR_PULA
	cQryAux += "C5.C5_EMISSAO EMISSA,"		+ STR_PULA
	cQryAux += "E1_PEDIDO PED_NOVO,"		+ STR_PULA
	cQryAux += "SUM(C6.C6_VALOR + C5.C5_FRETE + C5.C5_DESPESA) AS VALOR_PED,"		+ STR_PULA
	cQryAux += "E1_NUM TITULO,"		+ STR_PULA
	cQryAux += "E1_EMISSAO EMISSAO,"		+ STR_PULA
	cQryAux += "E1_XCONFDT DT_LIBE,"		+ STR_PULA
	cQryAux += "E1_VALOR AS VALOR_NCC,"		+ STR_PULA
	cQryAux += "(SUM(C6.C6_VALOR + C5.C5_FRETE + C5.C5_DESPESA) - E1_VALOR) AS DIF,"		+ STR_PULA
	cQryAux += "E1_XCONFUS USUARIO"		+ STR_PULA
	cQryAux += "FROM SE1010 SE (NOLOCK)"		+ STR_PULA
	cQryAux += "INNER JOIN SA1010 A1 (NOLOCK) ON A1.D_E_L_E_T_ <> '*' AND A1.A1_COD = SE.E1_CLIENTE AND A1_LOJA = SE.E1_LOJA"		+ STR_PULA
	cQryAux += "LEFT JOIN SC5010 C5 (NOLOCK)ON C5.C5_NUM = SE.E1_PEDIDO"		+ STR_PULA
	cQryAux += "LEFT JOIN (SELECT C6_FILIAL, C6_NUM, SUM(C6_VALOR) C6_VALOR FROM SC6010 AUX (NOLOCK) WHERE AUX.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "GROUP BY C6_FILIAL, C6_NUM) C6 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM"		+ STR_PULA
	cQryAux += "LEFT JOIN SM0010 M0 ON M0.FILFULL = C5.C5_MSFIL"		+ STR_PULA
	cQryAux += "LEFT JOIN SC5010 C5X (NOLOCK)ON C5X.C5_NUM = SE.E1_XPEDORI"		+ STR_PULA
	cQryAux += "LEFT JOIN (SELECT C6_FILIAL, C6_NUM, SUM(C6_VALOR) C6_VALOR FROM SC6010 AUX (NOLOCK) WHERE AUX.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "GROUP BY C6_FILIAL, C6_NUM) C6X ON C6X.C6_FILIAL = C5X.C5_FILIAL AND C6X.C6_NUM = C5X.C5_NUM"		+ STR_PULA
	cQryAux += "LEFT JOIN SM0010 M0X ON M0X.FILFULL = C5X.C5_MSFIL"		+ STR_PULA
	cQryAux += "WHERE E1_XCONFSC = 'S'"		+ STR_PULA
	cQryAux += "AND E1_XCONFUS <> ''"		+ STR_PULA
	cQryAux += "AND E1_XCONFDT <> ''"		+ STR_PULA
	cQryAux += "AND SE.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"		+ STR_PULA
	
			If MV_PAR01 == 2
				cQryAux += "AND E1_PEDIDO = ''"		+ STR_PULA
			ElseIf MV_PAR01 == 3
				cQryAux += "AND E1_PEDIDO <> ''"		+ STR_PULA
			EndIf
			
	cQryAux += "GROUP BY E1_CLIENTE ,A1_NOME , E1_XPEDORI , E1_PEDIDO , E1_EMISSAO , E1_XCONFDT , E1_NUM, E1_VALOR , E1_XCONFUS,M0.FILIAL,M0X.FILIAL,C5X.C5_EMISSAO,C5.C5_EMISSAO"		+ STR_PULA
	cQryAux += "ORDER BY E1_PEDIDO"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	TCSetField("QRY_AUX", "EMISSAO", "D")
	TCSetField("QRY_AUX", "EMISSA", "D")
	TCSetField("QRY_AUX", "DT_LIBE", "D")
	
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
