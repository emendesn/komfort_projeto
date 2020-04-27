#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "rwmake.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KMFINR17
Relatório - PEDIDO DE VENDA SEM FINANCEIRO                     
@author zReport - Everton Santos
@since 24/07/2019
@version 1.0
	@example
	u_KMFINR17()
	@obs Função gerada pelo zReport()
/*/
user function KMFINR17()

	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
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
	oReport := TReport():New(	"PEDIDO DE VENDA SEM FINANCEIRO",;		//Nome do Relatório
								"PEDIDO DE VENDA SEM FINANCEIRO",;		//Título
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
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT C5_MSFIL AS FILIAL,C5_NUM AS PEDIDO,C5_LOJACLI AS LOJA,MAX(C5_EMISSAO) AS EMISSAO,MAX(A1_NOME) AS CLIENTE FROM SC5010 C5 (NOLOCK)"		+ STR_PULA
	cQryAux += "INNER JOIN SC6010 C6 (NOLOCK) ON C5_NUM = C6_NUM AND C5_MSFIL = C6_MSFIL AND C5_FILIAL = C6_FILIAL"		+ STR_PULA
	cQryAux += "INNER JOIN SA1010 A1 (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA"		+ STR_PULA
	cQryAux += "WHERE C6_BLQ <> 'R'"		+ STR_PULA
	cQryAux += "AND C6_NOTA = ''"		+ STR_PULA
	cQryAux += "AND C5_CLIENTE <> '000001' "		+ STR_PULA
	cQryAux += "AND C5_TIPOCLI = 'F'"		+ STR_PULA
	cQryAux += "AND C5.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND C6.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND A1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND C5_CLIENTE NOT IN (SELECT E1_CLIENTE FROM SE1010 (NOLOCK) WHERE  D_E_L_E_T_ = '' AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA = C5_LOJACLI GROUP BY E1_CLIENTE)"		+ STR_PULA
	cQryAux += "GROUP BY C5_MSFIL,C5_NUM,C5_LOJACLI"		+ STR_PULA
	cQryAux += "ORDER BY C5_NUM"		+ STR_PULA
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
	
return