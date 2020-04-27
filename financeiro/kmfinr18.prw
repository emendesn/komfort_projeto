#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	

User Function KMFINR18()
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
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	
	oReport := TReport():New(	"KMFINR18",;		
								"Relatorio",;		
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
	
	
	TRCell():New(oSectDad, "CHAMADO", "QRY_AUX", "Chamado", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FILIAL", "QRY_AUX", "Filial", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_CLIENTE", "QRY_AUX", "Cod_cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CREDITO", "QRY_AUX", "Credito", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BAIXA", "QRY_AUX", "Baixa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 |                                    
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	

	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "   SELECT DISTINCT UC_CODIGO AS CHAMADO, E1_NUM AS TITULO,UC_MSFIL AS COD_FILIAL,FILIAL,A1_COD AS COD_CLIENTE,A1_NOME AS CLIENTE, E1_EMISSAO AS EMISSAO , E1_SALDO AS CREDITO, E1_BAIXA AS BAIXA,E1_HIST AS OBS"		+ STR_PULA
	cQryAux += "   FROM SUD010(NOLOCK)  SUD "		+ STR_PULA
	cQryAux += "   INNER JOIN SUC010(NOLOCK)  SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "		+ STR_PULA
	cQryAux += "   INNER JOIN SE1010(NOLOCK) SE1 ON UC_CODIGO = E1_01SAC AND E1_XPEDORI = RIGHT(RTRIM(UC_01PED),6)"		+ STR_PULA
	cQryAux += "   INNER JOIN SC5010(NOLOCK) SC5 ON RIGHT(RTRIM(UC_01PED),6) = C5_NUM "		+ STR_PULA
	cQryAux += "   INNER JOIN SA1010(NOLOCK)  SA1 ON A1_COD + A1_LOJA = UC_CHAVE"		+ STR_PULA
	cQryAux += "   INNER JOIN SM0010(NOLOCK) SM0 ON FILFULL = UC_MSFIL"		+ STR_PULA
	cQryAux += "   WHERE UD_FILIAL = '' "		+ STR_PULA
	cQryAux += "   AND E1_BAIXA <> ''"		+ STR_PULA
	cQryAux += "   AND E1_HIST = 'BX AUTOMATICA 45DIAS' "		+ STR_PULA
	cQryAux += "   AND UC_FILIAL = '' "		+ STR_PULA
	cQryAux += "   AND SUD.D_E_L_E_T_ = ' ' "		+ STR_PULA
	cQryAux += "   AND SUC.D_E_L_E_T_ = ' ' "		+ STR_PULA
	cQryAux += "   AND SE1.D_E_L_E_T_ = ' ' "		+ STR_PULA
	cQryAux += "   AND UD_ASSUNTO = '000009'"		+ STR_PULA
	cQryAux += "   AND UD_SOLUCAO IN ('000145','000146')"		+ STR_PULA
	cQryAux += "   ORDER BY UC_MSFIL"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())

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
