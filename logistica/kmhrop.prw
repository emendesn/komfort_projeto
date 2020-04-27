//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMHROP
Relatório - Rel Apontamento OP Diario     
@author zReport
@since 16/12/2019
@version 1.0
	@example
	u_KMHROP()
	@obs Função gerada pelo zReport()
/*/
	                                                                     
User Function KMHROP()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta                       
	cPerg := Padr("XMAT2501",10)
	AdjSx1()
	Pergunte(cPerg,.T.)
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
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
	oReport := TReport():New(	"KMHROP",;		//Nome do Relatório
								"Rel Apontamento OP Diario",;		//Título
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
	TRCell():New(oSectDad, "ORDEM_DE_PRODUCAO", "QRY_AUX", "Ordem_de_producao", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX", "Descricao", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_APONTAMENTO", "QRY_AUX", "Data_apontamento", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := "" 
	//Local cAlias       	:= GetNextAlias()	
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT  D3.D3_OP AS 'ORDEM_DE_PRODUCAO', D3.D3_COD AS 'PRODUTO', B1.B1_DESC AS 'DESCRICAO', " +  STR_PULA	 
	cQryAux += "D3.D3_QUANT AS 'QUANTIDADE', D3.D3_CF AS 'TIPO', "
	cQryAux += " convert(varchar, day(D3.D3_EMISSAO)) + '/' + convert(varchar, month(D3.D3_EMISSAO)) + '/' + convert(varchar, year(D3.D3_EMISSAO)) 'DATA_APONTAMENTO', "+  STR_PULA
	cQryAux += " D3.D3_PARCTOT AS 'TIPO' "+  STR_PULA
	cQryAux += "  FROM  SB1010 AS B1 (NOLOCK)  INNER JOIN SD3010 D3 (NOLOCK) ON D3.D3_COD = B1.B1_COD "+  STR_PULA
	cQryAux += "  AND B1.B1_TIPO = 'PA' AND D3.D3_CF = 'PR0' "+  STR_PULA
	cQryAux += "  AND D3_OP >= '"+ mv_par01 +  "' " + STR_PULA
	cQryAux += "  AND D3.D3_OP <= '" + mv_par02 + "' " + STR_PULA              
	cQryAux += "  AND D3.D3_EMISSAO >= '" + DTOS(MV_PAR03) +  "' " + STR_PULA       
	cQryAux += "  AND D3_EMISSAO <= '"+ DTOS(MV_PAR04) + "' " + STR_PULA 
	cQryAux += "  AND D3.D3_ESTORNO = '' " + STR_PULA                            
	cQryAux += "  AND B1.D_E_L_E_T_ = '' " + STR_PULA 
	cQryAux += "  AND D3.D_E_L_E_T_ = '' " + STR_PULA
	
	//DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryAux), cAlias, .F., .T.)                   
	
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

//cria as perguntas do relatorio
Static Function AdjSx1()

Local _aPerg  := {}
Local _ni

Aadd(_aPerg,{"AP inicial ?","mv_ch1","C",14,0,"G","","mv_par01","","","","SD3",""})
Aadd(_aPerg,{"AP final ?","mv_ch2","C",14,0,"G","","mv_par02","","","","SD3",""})
Aadd(_aPerg,{"Da Data de Aponta?","mv_ch3","D",08,0,"G","","mv_par3","","","","",""})
Aadd(_aPerg,{"Ate a Data de Aponta?","mv_ch4","D",08,0,"G","","mv_par04","","","","",""})

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