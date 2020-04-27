//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} XKOMF001
Relat�rio - PEDIDOS EM ABERTO COM STATUS  
@author zReport
@since 16/03/2020
@version 1.0
	@example
	u_XKOMF001()
	@obs Fun��o gerada pelo zReport()
/*/
	
User Function KMCOMR09()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	//Defini��es da pergunta                       
	cPerg := Padr("XMTR120",10)
	AdjSx1()
	Pergunte(cPerg,.T.)

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
	oReport := TReport():New(	"XKOMF001",;		//Nome do Relat�rio
								"PEDIDOS EM ABERTO COM STATUS",;		//T�tulo
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
									{"QRY_AUX1"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX1", "FILIAL", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO", "QRY_AUX1", "NUMERO", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMSC", "QRY_AUX1", "NUMSC", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX1", "FORNECEDOR", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX1", "NOME", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX1", "PRODUTO", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX1", "DESCRICAO", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOCAL", "QRY_AUX1", "LOCAL", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ITEM", "QRY_AUX1", "ITEM", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE", "QRY_AUX1", "UNIDADE", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTD", "QRY_AUX1", "QTD", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRECO", "QRY_AUX1", "PRECO", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "_TOTAL", "QRY_AUX1", "_TOTAL", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX1", "EMISSAO", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DTENTREGA", "QRY_AUX1", "DTENTREGA", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDENTREGUE", "QRY_AUX1", "QTDENTREGUE", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DTDIFERENCA", "QRY_AUX1", "DTDIFERENCA", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS", "QRY_AUX1", "STATUS", /*Picture*/, 19, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual1  := 0
	Local nTotal1   := 0
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT C7.C7_FILIAL AS 'FILIAL', C7.C7_NUM AS 'NUMERO', C7.C7_NUMSC AS 'NUMSC', C7.C7_FORNECE AS 'FORNECEDOR', A2.A2_NOME AS 'NOME',  C7.C7_PRODUTO AS 'PRODUTO', C7.C7_DESCRI AS 'DESCRICAO', C7.C7_LOCAL AS 'LOCAL', C7.C7_ITEM AS 'ITEM', C7.C7_UM AS 'UNIDADE', C7.C7_QUANT AS 'QTD', C7_QUJE AS 'QTDENTREGUE', C7.C7_PRECO AS 'PRECO',  C7.C7_TOTAL AS '_TOTAL',   C7.C7_EMISSAO AS 'EMISSAO',  C7.C7_DATPRF AS 'DTENTREGA', DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) AS 'DTDIFERENCA',"		+ STR_PULA
	cQryAux += "'STATUS' = CASE"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) <= 20 AND   C7.C7_FORNECE = '000022' THEN 'NO PRAZO'"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) > 20 AND   C7.C7_FORNECE = '000022' THEN 'ATRASADO'"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) <= 30 AND  C7.C7_FORNECE = '000024' THEN 'NO PRAZO'"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) > 30 AND  C7.C7_FORNECE = '000024' THEN 'ATRASADO'"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) <= 30 AND  C7.C7_FORNECE = '000026' THEN ' NO PRAZO'"		+ STR_PULA
	cQryAux += " WHEN DATEDIFF(DAY, C7.C7_EMISSAO, C7.C7_DATPRF) > 30 AND  C7.C7_FORNECE = '000026' THEN ' ATRASADO'"		+ STR_PULA
	cQryAux += " ELSE 'FORNECEDOR INVALIDO'"		+ STR_PULA
	cQryAux += " END "		+ STR_PULA
	cQryAux += "FROM SC7010 (NOLOCK)  C7 INNER JOIN SA2010 (NOLOCK) A2 ON A2.A2_COD =  C7.C7_FORNECE " + STR_PULA
	cQryAux += "WHERE C7.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = ''  AND C7.C7_FORNECE = '000022'" + STR_PULA
	cQryAux += " and C7_QUANT != C7_QUJE " + STR_PULA
	cQryAux += " and C7.C7_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"  + STR_PULA
	cQryAux += " and C7.C7_EMISSAO BETWEEN  '" + DTOS(mv_par03) + "'  and '" + DTOS(mv_par04) + "'" + STR_PULA
    cQryAux += " and C7.C7_DATPRF BETWEEN '" + DTOS(mv_par05) + "' and '" + DTOS(mv_par06) + "'" + STR_PULA
    cQryAux += " and C7.C7_NUM BETWEEN '" + mv_par07 + "' and '" + mv_par08 + "'"  + STR_PULA 
    cQryAux += " OR  C7.C7_FORNECE = '000026'" + STR_PULA 
	cQryAux += " and C7_QUANT != C7_QUJE " + STR_PULA
	cQryAux += " and C7.C7_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"  + STR_PULA
	cQryAux += " and C7.C7_EMISSAO BETWEEN  '" + DTOS(mv_par03) + "'  and '" + DTOS(mv_par04) + "'" + STR_PULA
    cQryAux += " and C7.C7_DATPRF BETWEEN '" + DTOS(mv_par05) + "' and '" + DTOS(mv_par06) + "'" + STR_PULA
    cQryAux += " and C7.C7_NUM BETWEEN '" + mv_par07 + "' and '" + mv_par08 + "'"  + STR_PULA 
	cQryAux += " OR  C7.C7_FORNECE = '000024'" + STR_PULA 
	cQryAux += " and C7_QUANT != C7_QUJE " + STR_PULA
	cQryAux += " and C7.C7_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"  + STR_PULA
	cQryAux += " and C7.C7_EMISSAO BETWEEN  '" + DTOS(mv_par03) + "'  and '" + DTOS(mv_par04) + "'" + STR_PULA
    cQryAux += " and C7.C7_DATPRF BETWEEN '" + DTOS(mv_par05) + "' and '" + DTOS(mv_par06) + "'" + STR_PULA
    cQryAux += " and C7.C7_NUM BETWEEN '" + mv_par07 + "' and '" + mv_par08 + "'"  + STR_PULA 
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX1" 

	DbSelectArea('QRY_AUX1')
	QRY_AUX1->(dbEval({|| nTotal1++}))
	
	//Count to nTotal
	oReport:SetMeter(nTotal1)

	//TCSetField("QRY_AUX", "C7_EMISSAO", "D")
	//TCSetField("QRY_AUX", "C7_DATPRF", "D")
	
	//Enquanto houver dados
	oSectDad:Init()
	
	QRY_AUX1->(DbGoTop())
	While ! QRY_AUX1->(Eof())
		//Incrementando a r�gua
		nAtual1++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual1)+" de "+cValToChar(nTotal1)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX1->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX1->(DbCloseArea())
	
	RestArea(aArea)
Return

//cria as perguntas do relatorio
Static Function AdjSx1()

Local _aPerg  := {}
Local _ni

Aadd(_aPerg,{"Produto de ?","mv_ch1","C",15,0,"G","","mv_par01","","","","SC7",""})
Aadd(_aPerg,{"Produto ate ?","mv_ch2","C",15,0,"G","","mv_par02","","","","SC7",""})
Aadd(_aPerg,{"Data Emissao de ?","mv_ch3","D",08,0,"G","","mv_par3","","","","",""})
Aadd(_aPerg,{"Data Emissao at� ?","mv_ch4","D",08,0,"G","","mv_par04","","","","",""})
Aadd(_aPerg,{"Data Entrega de ?","mv_ch5","D",08,0,"G","","mv_par5","","","","",""})
Aadd(_aPerg,{"Data Entrega at� ?","mv_ch6","D",08,0,"G","","mv_par06","","","","",""})
Aadd(_aPerg,{"Numero Inicial ? ","mv_ch7","C",06,0,"G","","mv_par07","","","","",""})
Aadd(_aPerg,{"Numero Final ? ","mv_ch8","C",06,0,"G","","mv_par08","","","","",""})


dbSelectArea("SX1")
For _ni := 1 To Len(_aPerg)
	If !dbSeek(cPerg+StrZero(_ni,2))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO    := cPerg
		SX1->X1_ORDEM    := StrZero(_ni,2)
		SX1->X1_PERGUNT  := _aPerg[_ni][1]
		SX1->X1_PERSPA   := _aPerg[_ni][1]
		SX1->X1_PERENG   := _aPerg[_ni][1]
		SX1->X1_VARIAVL  := _aPerg[_ni][2]
		SX1->X1_TIPO     := _aPerg[_ni][3]
		SX1->X1_TAMANHO  := _aPerg[_ni][4]
		SX1->X1_DECIMAL  := _aPerg[_ni][5]
		SX1->X1_GSC      := _aPerg[_ni][6]
		SX1->X1_VALID	 := _aPerg[_ni][7]
		SX1->X1_VAR01    := _aPerg[_ni][8]
		SX1->X1_DEF01    := _aPerg[_ni][9]
		SX1->X1_DEFSPA1  := _aPerg[_ni][9]
		SX1->X1_DEFENG1  := _aPerg[_ni][9]
		SX1->X1_DEF02    := _aPerg[_ni][10]
		SX1->X1_DEFSPA2  := _aPerg[_ni][10]
		SX1->X1_DEFENG2  := _aPerg[_ni][10]
		SX1->X1_DEF03    := _aPerg[_ni][11]
		SX1->X1_DEFSPA3  := _aPerg[_ni][11]
		SX1->X1_DEFENG3  := _aPerg[_ni][11]
		SX1->X1_F3       := _aPerg[_ni][12]
		SX1->X1_CNT01    := _aPerg[_ni][13]
		MsUnLock()
	EndIf
Next _ni

Return 