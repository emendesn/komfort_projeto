
#Include "Protheus.ch"
#Include "TopConn.ch"
	

#Define STR_PULA		Chr(13)+Chr(10)
//Relatorio de saldo ecommerce 	
//Autor Wellington Raul 
//Uso Painel ecomerce KHECOM01()
User Function kHECOM05()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	oReport := fReportDef()
	
	
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 
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
	
	oReport := TReport():New(	"kHECOM05",;		
								"Relatorio",;		
								cPerg,;		
								{|oReport| fRepPrint(oReport)},;		
								)		
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) 
	oReport:SetPortrait()
	
	oSectDad := TRSection():New(	oReport,;			
									"Dados",;			
									{"QRY_AUX"})		
	oSectDad:SetTotalInLine(.F.)  
	
	TRCell():New(oSectDad, "B2_COD", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC", "QRY_AUX", "Descricao", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALDO", "QRY_AUX", "Saldo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 51, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	

	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	
	oSectDad := oReport:Section(1)
	
	
	cQryAux := ""
	cQryAux += "	SELECT B2_COD,B1_DESC, (B2_QATU - B2_RESERVA - B2_QACLASS) AS SALDO, 'SALDO É IGUAL A QUANTIDADE EM ESTOQUE MENOS EMPENHO' AS OBS  FROM " + RetSqlName('SB2') + "(NOLOCK) B2" + STR_PULA
	cQryAux += "	INNER JOIN " + RetSqlname('SB1') + "(NOLOCK) B1 ON B1_COD = B2_COD  "		+ STR_PULA
	cQryAux += "	WHERE B2_LOCAL = '15'"		+ STR_PULA
	cQryAux += "	AND B2.D_E_L_E_T_ = ' '  "		+ STR_PULA
	cQryAux += "	AND B1.D_E_L_E_T_ = ' '  "		+ STR_PULA
	cQryAux += "	AND (B2.B2_QATU - (B2.B2_QEMP + B2.B2_RESERVA + B2.B2_QPEDVEN + B2.B2_QACLASS)) > 0 "		+ STR_PULA
	cQryAux += "	AND B2_QATU > 0"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	
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
