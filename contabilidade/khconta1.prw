//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KHCONTA1                 
@author zReport
@since 27/12/2019
@version 1.0
	@example
	u_KHCONTA1()
/*/
	
User Function KHCONTA1()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	oReport := fReportDef()
	
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	oReport := TReport():New(	"KHCONTA1",;	
								"Contabilidade",;		
								cPerg,;		
								{|oReport| fRepPrint(oReport)},;		
								)	
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	oSectDad := TRSection():New(	oReport,;			
									"Dados",;			
									{"QRY_AUX"})		
	oSectDad:SetTotalInLine(.F.) 
	
	TRCell():New(oSectDad, "ANO", "QRY_AUX", "Ano", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MES", "QRY_AUX", "Data", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CODIGO", "QRY_AUX", "Codigo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_NCM", "QRY_AUX", "Cod_ncm", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE_UNIT", "QRY_AUX", "Qtde_unit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNI", "QRY_AUX", "Uni", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "V_UNIT", "QRY_AUX", "V_unit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_ICM", "QRY_AUX", "Aliq_icm", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ITEM", "QRY_AUX", "Vl_item", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	oSectDad := oReport:Section(1)
	
	cQryAux := ""
	cQryAux += "SELECT DATENAME(YEAR, GETDATE()) AS ANO, DATENAME(MONTH, GETDATE()) AS MES,B2_COD AS CODIGO,B1_DESC AS DESCRICAO,B1_POSIPI AS COD_NCM ,SUM(B2_QATU) AS QTDE_UNIT,B1_UM AS UNI,B1_CUSTD AS V_UNIT,"		+ STR_PULA
	cQryAux += " CASE"		+ STR_PULA
	cQryAux += " WHEN B1_XACESSO = '1' THEN '18%'"		+ STR_PULA
	cQryAux += " WHEN B1_XACESSO <> ''  THEN '12%'"		+ STR_PULA
	cQryAux += " END ALIQ_ICM, "		+ STR_PULA
	cQryAux += " (  B1_CUSTD * SUM(B2_QATU)) AS VL_ITEM"		+ STR_PULA
	cQryAux += "  FROM " + RetSqlName('SB2') +"(NOLOCK) B2"		+ STR_PULA
	cQryAux += " INNER JOIN SB1010 (NOLOCK) B1 ON B1.B1_COD = B2.B2_COD "		+ STR_PULA
	cQryAux += " WHERE B2_COD <> '' "		+ STR_PULA
	cQryAux += " AND B2.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += " AND B1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += " AND B2_QATU > 0"		+ STR_PULA
	cQryAux += " AND B1_TIPO = 'ME'"		+ STR_PULA
	cQryAux += " GROUP BY B2_COD,B1_DESC,B1_UM,B1_CUSTD,B1_POSIPI,B1_XACESSO"		+ STR_PULA
	cQryAux += " ORDER BY  B1_XACESSO DESC"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "MES", "D")
	
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
