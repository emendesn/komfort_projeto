//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} KHX007
Relatório - Relatorio
@author zReport
@since 30/09/2019
@version 1.0
	@example
	u_KHX007()
	@obs Função gerada pelo zReport()
/*/

User Function KHX007()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Local cUsers  := SuperGetMv("KH_EXPCLI" , , "001117|001112")
	Private cPerg := ""

	If (RetCodUsr() $ cUsers) .AND. ( Pergunte("KHX007",.T.) )

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

	Else

		Aviso("Erro" , "Usu�rio sem acesso ao relat�rio")

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
	oReport := TReport():New(	"KHX007",;		//Nome do Relatório
								"Relatorio",;		//Título
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
	TRCell():New(oSectDad, "NAME", "QRY_AUX", "Name", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GIVEN_NAME", "QRY_AUX", "Given_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ADDITIONAL_NAME", "QRY_AUX", "Additional_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILY_NAME", "QRY_AUX", "Family_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "YOMI_NAME", "QRY_AUX", "Yomi_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GIVEN_NAME_YOMI", "QRY_AUX", "Given_name_yomi", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ADDITIONAL_NAME_YOMI", "QRY_AUX", "Additional_name_yomi", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILY_NAME_YOMI", "QRY_AUX", "Family_name_yomi", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NAME_PREFIX", "QRY_AUX", "Name_prefix", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NAME_SUFFIX", "QRY_AUX", "Name_suffix", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "INITIALS", "QRY_AUX", "Initials", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NICKNAME", "QRY_AUX", "Nickname", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SHORT_NAME", "QRY_AUX", "Short_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MAIDEN_NAME", "QRY_AUX", "Maiden_name", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BIRTHDAY", "QRY_AUX", "Birthday", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GENDER", "QRY_AUX", "Gender", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOCATION", "QRY_AUX", "Location", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BILLING_INFORMATION", "QRY_AUX", "Billing_information", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIRECTORY_SERVER", "QRY_AUX", "Directory_server", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MILEAGE", "QRY_AUX", "Mileage", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OCCUPATION", "QRY_AUX", "Occupation", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "HOBBY", "QRY_AUX", "Hobby", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SENSITIVITY", "QRY_AUX", "Sensitivity", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRIORITY", "QRY_AUX", "Priority", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SUBJECT", "QRY_AUX", "Subject", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTES", "QRY_AUX", "Notes", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LANGUAGE", "QRY_AUX", "Language", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHOTO", "QRY_AUX", "Photo", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GROUP_MEMBERSHIP", "QRY_AUX", "Group_membership", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE__TYPE", "QRY_AUX", "Phone__type", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE__VALUE", "QRY_AUX", "Phone__value", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_2__TYPE", "QRY_AUX", "Phone_2__type", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_2__VALUE", "QRY_AUX", "Phone_2__value", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_3__TYPE", "QRY_AUX", "Phone_3__type", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_3__VALUE", "QRY_AUX", "Phone_3__value", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_4__TYPE", "QRY_AUX", "Phone_4__type", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PHONE_4__VALUE", "QRY_AUX", "Phone_4__value", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_CUPOM", "QRY_AUX", "TIPO_CUPOM", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_CUPOM", "QRY_AUX", "COD_CUPOM", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	Local aZL7	   := {}
	Local cDataDe  := ""
	Local cDataAte := ""

	cDataDe		:= dToS(MV_PAR01)
	cDataAte	:= dToS(MV_PAR02)

	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)

	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT"		+ STR_PULA
	cQryAux += "  SA1.A1_NOME NAME,"		+ STR_PULA
	cQryAux += "  '' GIVEN_NAME,"		+ STR_PULA
	cQryAux += "  '' ADDITIONAL_NAME,"		+ STR_PULA
	cQryAux += "  '' FAMILY_NAME,"		+ STR_PULA
	cQryAux += "  '' YOMI_NAME,"		+ STR_PULA
	cQryAux += "  '' GIVEN_NAME_YOMI,"		+ STR_PULA
	cQryAux += "  '' ADDITIONAL_NAME_YOMI,"		+ STR_PULA
	cQryAux += "  '' FAMILY_NAME_YOMI,"		+ STR_PULA
	cQryAux += "  '' NAME_PREFIX,"		+ STR_PULA
	cQryAux += "  '' NAME_SUFFIX,"		+ STR_PULA
	cQryAux += "  '' INITIALS,"		+ STR_PULA
	cQryAux += "  '' NICKNAME,"		+ STR_PULA
	cQryAux += "  '' SHORT_NAME,"		+ STR_PULA
	cQryAux += "  '' MAIDEN_NAME,"		+ STR_PULA
	cQryAux += "  '' BIRTHDAY,"		+ STR_PULA
	cQryAux += "  '' GENDER,"		+ STR_PULA
	cQryAux += "  '' LOCATION,"		+ STR_PULA
	cQryAux += "  '' BILLING_INFORMATION,"		+ STR_PULA
	cQryAux += "  '' DIRECTORY_SERVER,"		+ STR_PULA
	cQryAux += "  '' MILEAGE,"		+ STR_PULA
	cQryAux += "  '' OCCUPATION,"		+ STR_PULA
	cQryAux += "  '' HOBBY,"		+ STR_PULA
	cQryAux += "  '' SENSITIVITY,"		+ STR_PULA
	cQryAux += "  '' PRIORITY,"		+ STR_PULA
	cQryAux += "  '' SUBJECT,"		+ STR_PULA
	cQryAux += "  '' NOTES,"		+ STR_PULA
	cQryAux += "  '' LANGUAGE,"		+ STR_PULA
	cQryAux += "  '' PHOTO,"		+ STR_PULA
	cQryAux += "  '' GROUP_MEMBERSHIP,"		+ STR_PULA
	cQryAux += "  'CELULAR' PHONE__TYPE,"		+ STR_PULA
	cQryAux += "  ZL5.ZL5_XTELS1 PHONE__VALUE,"		+ STR_PULA
	cQryAux += "  'CELULAR' PHONE_2__TYPE,"		+ STR_PULA
	cQryAux += "  ZL5.ZL5_XTELS2 PHONE_2__VALUE,"		+ STR_PULA
	cQryAux += "  'CELULAR' PHONE_3__TYPE,"		+ STR_PULA
	cQryAux += "  ZL5.ZL5_XTELS3 PHONE_3__VALUE,"		+ STR_PULA
	cQryAux += "  '' PHONE_4__TYPE,"		+ STR_PULA
	cQryAux += "  '' PHONE_4__VALUE,"		+ STR_PULA		
	cQryAux	+= "  ZL7.R_E_C_N_O_ REGISTRO,"
	cQryAux	+= 		" CASE "
	cQryAux	+=			" WHEN ZL7.ZL7_XTIPO = '2' THEN 'BRINDE' "
	cQryAux	+=		" ELSE 'INFORMATIVO' "
	cQryAux	+=		" END AS TIPO_CUPOM, "
	cQryAux	+= "  ZL7.ZL7_CUPOM COD_CUPOM"
	cQryAux += "FROM"		+ STR_PULA
	cQryAux += "  ZL5010 ZL5  "		+ STR_PULA
	cQryAux += "INNER JOIN SA1010 SA1"		+ STR_PULA
	cQryAux += "ON ZL5.ZL5_CODCLI = SA1.A1_COD "		+ STR_PULA
	cQryAux += "INNER JOIN ZL7010 ZL7 "		+ STR_PULA
	cQryAux += "ON ZL5.ZL5_CODCLI = ZL7.ZL7_CODCLI "		+ STR_PULA
	cQryAux += "AND ZL5.ZL5_LOJA = ZL7.ZL7_LOJA"		+ STR_PULA
	cQryAux += "WHERE "		+ STR_PULA
	cQryAux += "ZL5.ZL5_STATUS = '1' "		+ STR_PULA //Contato efetivo
	cQryAux += "AND ZL7_XTIPO IN ('2' , '3') "		+ STR_PULA //Cupons; 2-Informativo|3-Brinde
	cQryAux += "AND ZL7_DATA BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'"	+ STR_PULA
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

		AADD(aZL7 , QRY_AUX->REGISTRO)

		QRY_AUX->(DbSkip())
	EndDo
	fAtuZL7(aZL7)
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())

	RestArea(aArea)



Return

/*-------------------------------------------------------------------------------*
 | Func:  fAtuZL7                                                                |
 | Desc:  Função que Atualiza a tabela de rastreio de cupons                     |
 *-------------------------------------------------------------------------------*/
Static Function fAtuZL7(aZL7)

	Local aAreaZL7	:= {}
	Local nX		:= 0

	dbSelectArea("ZL7")

	aAreaZL7	:= ZL7->(GetArea())

	For nX := 1 TO Len(aZL7)

		ZL7->(dbGoTo(aZL7[nX]))

		If (RecLock("ZL7" , .F.))

			ZL7->ZL7_WAPP	:= "X"

			ZL7->(MsUnlock())

		EndIf

	Next nX

	RestArea(aAreaZL7)

Return