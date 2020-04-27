//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMHROP4A
Relatório - Rel Apontamento OP Diario     
@author zReport
@since 16/12/2019
@version 1.0
	@example
	u_KMHROP()
	@obs Função gerada pelo zReport()
/*/
	                                                                     
User Function KMHROP4A()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta                       
	cPerg := Padr("XMAT2502",10)
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
	oReport := TReport():New(	"KMHROP4A",;		//Nome do Relatório
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
									"Dados1",;			//Descrição da seção
									{"QRY_AUX1"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "ORDEM_DE_PRODUCAO", "QRY_AUX1", "Ordem_de_producao", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX1", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO", "QRY_AUX1", "Descricao", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UN_MEDIDA", "QRY_AUX1", "Unidade_Medida", /*Picture*/, 02, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX1", "Tipo", /*Picture*/, 02, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX1", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "LOCAL", "QRY_AUX1", "Local", /*Picture*/, 02, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "NECESSIDADE", "QRY_AUX1", "Necessidade", /*Picture*/, 08, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux1  := "" 
	//Local cAlias       	:= GetNextAlias()	
	Local oSectDad := Nil
	//Local oSectDad1 := Nil
	Local nAtual1:= 0
	Local nTotal1:= 0
	
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux1 := "SELECT  D4.D4_OP AS 'ORDEM_DE_PRODUCAO', D4.D4_COD AS 'PRODUTO', B1.B1_DESC AS 'DESCRICAO', B1_UM AS 'UN_MEDIDA', B1.B1_TIPO AS 'TIPO', " +  STR_PULA	 
	cQryAux1 += "D4.D4_QTDEORI AS 'QUANTIDADE', D4.D4_LOCAL AS 'LOCAL', D4.D4_DATA 'NECESSIDADE'"+  STR_PULA
	cQryAux1 += "  FROM  SB1010 AS B1 (NOLOCK)  INNER JOIN SD4010 D4 (NOLOCK) ON D4.D4_COD = B1.B1_COD "+  STR_PULA
	cQryAux1 += "  AND D4_OP >= '"+ mv_par01 +  "' " + STR_PULA
	cQryAux1 += "  AND  D4_OP <= '" + mv_par02 + "' " + STR_PULA
	cQryAux1 += "  AND D4_DATA >= '" + DTOS(MV_PAR03) +  "' " + STR_PULA      
	cQryAux1 += "  AND D4_DATA <= '"+ DTOS(MV_PAR04) + "' " + STR_PULA                             
	cQryAux1 += "  AND B1.D_E_L_E_T_ = '' " 
	cQryAux1 += "  AND D4.D_E_L_E_T_ = '' "
	
	//DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryAux), cAlias, .F., .T.)                   
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux1 New Alias "QRY_AUX1"
	DbSelectArea('QRY_AUX1')
	QRY_AUX1->(dbEval({|| nTotal1++}))
	//Count to nTotal
	oReport:SetMeter(nTotal1)
	
	//Enquanto houver dados
	oSectDad:Init()            
	
	QRY_AUX1->(DbGoTop())
	While ! QRY_AUX1->(Eof())
		//Incrementando a régua
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

Aadd(_aPerg,{"AP inicial ?","mv_ch1","C",14,0,"G","","mv_par01","","","","SD4",""})
Aadd(_aPerg,{"AP final ?","mv_ch2","C",14,0,"G","","mv_par02","","","","SD4",""})
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