//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} KMCOMR07
Relatório - Import GS1 EAN                
@author Marcio Nunes - Chamado:8443
@since 20/03/2019
@version 1.0
	@example
	u_KMCOMR07()
	@obs Função gerada para disponibilizar os códigos de produtos a serem importados no site do GS1.
	Serão impressos somente os produtos que ainda não foram importados.                    
	Este relatório atualizad os campos no cadastro de produto para que os mesmos não sejam gerados novamente.
	Caso seja necessário gerar novamente, efetue a limpeza dos campos B1_XEANIM e B1_XEANDT
/*/
	
User Function KMCOMR07()
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
	oReport := TReport():New(	"KMCOMR07",;		//Nome do Relatório
								"Import GS1 EAN",;		//Título
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
	TRCell():New(oSectDad, "STATUS_GETIN", "QRY_AUX", "Copie o conteúdo ", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GETIN", "QRY_AUX", "abaixo e ", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MARCA", "QRY_AUX", "COLE ", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_MODELO", "QRY_AUX", "no Excel Oficial ", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRICAO_PRODUTO", "QRY_AUX", "disponível no site ", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_LANCAMENTO", "QRY_AUX", "https://cnp.gs1br.org, ", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NCM", "QRY_AUX", "em seguida ", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CEST", "QRY_AUX", " importe selecionando ", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SEGMENTO_PRODUTO", "QRY_AUX", "Tipo de código: GTIN-13 ", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILIA_PRODUTO", "QRY_AUX", " e Tipo de arquivo: Excel.", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLASSE_PRODUTO", "QRY_AUX", "", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SUB_CLASSE_PRODUTO", "QRY_AUX", "", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_IDENTIFICACAO_1", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGENCIA_REGULADORA_1", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_IDENTIFICACAO_2", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGENCIA_REGULADORA_2", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_IDENTIFICACAO_3", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGENCIA_REGULADORA_3", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_IDENTIFICACAO_4", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGENCIA_REGULADORA_4", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUMERO_IDENTIFICACAO_5", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "AGENCIA_REGULADORA_5", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PAIS_MERCADO_DESTINO", "QRY_AUX", "", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PAIS_ORIGEM", "QRY_AUX", "", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ESTADO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALTURA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALTURA_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LARGURA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LARGURA_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PROFUNDIDADE", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PROFUNDIDADE_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONTEUDO_LIQUIDO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONT_LIQ_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PESO_BRUTO", "QRY_AUX", "", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PESO_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PESO_LIQUIDO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PESO_LIQ_UN_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEMPO_MINIMO_VIDA_UTIL", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COMPARTILHA_DADOS", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBSERVACAO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_PRODUTO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_PALLET", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FATOR_EMPILHAMENTO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_POR_PALLET", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_UNICA_CAMADA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_CAMADA_COMPLETA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_ITEM_COMERCIAL", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "GTIN_INFERIOR", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQUOTA_DE_IMPOSTOS_IPI", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_URL_1", "QRY_AUX", "", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "URL_1", "QRY_AUX", "", /*Picture*/, 73, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_URL", "QRY_AUX", "", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_URL_2", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "URL_2", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_DE_URL_2", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME_URL_3", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "URL_3", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_DE_URL_3", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ITEM_COMERCIAL", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE_DE_MEDIDA_PEDIDO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MULTIPLO_QUANTIDADE_PEDIDO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_MINIMA_PEDIDO", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO_DA_EMBALAGEM", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEMPERATURA_MINIMA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE_DE_MEDIDA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TEMPERATURA_MAXIMA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE_DE_MEDIDA_TEMPERATURA", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "INDICADOR_MERCADORIAS", "QRY_AUX", "", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local cQryUpd  := ""	
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT TOP (1000)"		+ STR_PULA
	cQryAux += "	(CASE WHEN B1_MSBLQL = '1' THEN 'CANCELADO' ELSE 'ATIVO' END) AS STATUS_GETIN,"		+ STR_PULA
	cQryAux += "	B1_CODBAR AS GETIN,"		+ STR_PULA
	cQryAux += "	'KOMFORT' AS MARCA,"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_MODELO,"		+ STR_PULA
	cQryAux += "	B1_DESC AS DESCRICAO_PRODUTO,"		+ STR_PULA
	cQryAux += "	'' AS DATA_LANCAMENTO,"		+ STR_PULA
	cQryAux += "	SUBSTRING(B1_POSIPI,1,4) + '.' + SUBSTRING(B1_POSIPI,5,2) + '.' + SUBSTRING(B1_POSIPI,7,2) AS NCM,"		+ STR_PULA
	cQryAux += "	'' AS CEST,"		+ STR_PULA
	cQryAux += "	'75000000' AS SEGMENTO_PRODUTO,"		+ STR_PULA
	cQryAux += "	'75010000' AS FAMILIA_PRODUTO,"		+ STR_PULA
	cQryAux += "	'75010200' AS CLASSE_PRODUTO,"		+ STR_PULA
	cQryAux += "	'10002195' AS SUB_CLASSE_PRODUTO,"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_IDENTIFICACAO_1,"		+ STR_PULA
	cQryAux += "	'' AS AGENCIA_REGULADORA_1,	"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_IDENTIFICACAO_2,	"		+ STR_PULA
	cQryAux += "	'' AS AGENCIA_REGULADORA_2,	"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_IDENTIFICACAO_3,	"		+ STR_PULA
	cQryAux += "	'' AS AGENCIA_REGULADORA_3,	"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_IDENTIFICACAO_4,	"		+ STR_PULA
	cQryAux += "	'' AS AGENCIA_REGULADORA_4,	"		+ STR_PULA
	cQryAux += "	'' AS NUMERO_IDENTIFICACAO_5,	"		+ STR_PULA
	cQryAux += "	'' AS AGENCIA_REGULADORA_5,	"		+ STR_PULA
	cQryAux += "	'76' AS PAIS_MERCADO_DESTINO,"		+ STR_PULA
	cQryAux += "	'76' AS PAIS_ORIGEM,"		+ STR_PULA
	cQryAux += "	'' AS ESTADO,	"		+ STR_PULA
	cQryAux += "	'' AS ALTURA,	"		+ STR_PULA
	cQryAux += "	'' AS ALTURA_UN_MEDIDA,	"		+ STR_PULA
	cQryAux += "	'' AS LARGURA,	"		+ STR_PULA
	cQryAux += "	'' AS LARGURA_UN_MEDIDA,	"		+ STR_PULA
	cQryAux += "	'' AS PROFUNDIDADE,	"		+ STR_PULA
	cQryAux += "	'' AS PROFUNDIDADE_UN_MEDIDA,	"		+ STR_PULA
	cQryAux += "	'' AS CONTEUDO_LIQUIDO,	"		+ STR_PULA
	cQryAux += "	'' AS CONT_LIQ_UN_MEDIDA,"		+ STR_PULA
	cQryAux += "	B1_PESBRU AS PESO_BRUTO,"		+ STR_PULA
	cQryAux += "	'KG' AS PESO_UN_MEDIDA,"		+ STR_PULA
	cQryAux += "	'' AS PESO_LIQUIDO,	"		+ STR_PULA             
	cQryAux += "	'' AS PESO_LIQ_UN_MEDIDA,	"		+ STR_PULA
	cQryAux += "	'' AS TEMPO_MINIMO_VIDA_UTIL,"		+ STR_PULA
	cQryAux += "	'' AS COMPARTILHA_DADOS,"		+ STR_PULA
	cQryAux += "	'' AS OBSERVACAO,	"		+ STR_PULA
	cQryAux += "	'' AS TIPO_PRODUTO,	"		+ STR_PULA
	cQryAux += "	'' AS TIPO_PALLET,	"		+ STR_PULA
	cQryAux += "	'' AS FATOR_EMPILHAMENTO,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE_POR_PALLET,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE_UNICA_CAMADA,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE_CAMADA_COMPLETA,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE_ITEM_COMERCIAL,	"		+ STR_PULA
	cQryAux += "	'' AS GTIN_INFERIOR,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE,	"		+ STR_PULA
	cQryAux += "	'' AS ALIQUOTA_DE_IMPOSTOS_IPI,"		+ STR_PULA
	cQryAux += "	B1_DESC AS NOME_URL_1,"		+ STR_PULA
	cQryAux += "	'HTTPS://WWW.KOMFORTHOUSE.COM.BR/WP-CONTENT/UPLOADS/LOGO-TOPO-STICKY-2.PNG' AS URL_1,"		+ STR_PULA
	cQryAux += "	'Foto' AS TIPO_URL,"		+ STR_PULA
	cQryAux += "	'' AS NOME_URL_2,"		+ STR_PULA
	cQryAux += "	'' AS URL_2,"		+ STR_PULA
	cQryAux += "	'' AS TIPO_DE_URL_2,"		+ STR_PULA
	cQryAux += "	'' AS NOME_URL_3,"		+ STR_PULA
	cQryAux += "	'' AS URL_3,"		+ STR_PULA
	cQryAux += "	'' AS TIPO_DE_URL_3,"		+ STR_PULA
	cQryAux += "	'' AS ITEM_COMERCIAL,"		+ STR_PULA
	cQryAux += "	'' AS UNIDADE_DE_MEDIDA_PEDIDO,	"		+ STR_PULA
	cQryAux += "	'' AS MULTIPLO_QUANTIDADE_PEDIDO,	"		+ STR_PULA
	cQryAux += "	'' AS QUANTIDADE_MINIMA_PEDIDO,	"		+ STR_PULA
	cQryAux += "	'' AS TIPO_DA_EMBALAGEM,	"		+ STR_PULA
	cQryAux += "	'' AS TEMPERATURA_MINIMA,"		+ STR_PULA
	cQryAux += "	'' AS UNIDADE_DE_MEDIDA,"		+ STR_PULA
	cQryAux += "	'' AS TEMPERATURA_MAXIMA,"		+ STR_PULA
	cQryAux += "	'' AS UNIDADE_DE_MEDIDA_TEMPERATURA,"		+ STR_PULA
	cQryAux += "	'' AS INDICADOR_MERCADORIAS,"		+ STR_PULA
	cQryAux += "	B1_XEANIM AS B1_XEANIM,"		+ STR_PULA
	cQryAux += "	B1_XEANDT AS B1_XEANDT,"		+ STR_PULA	
	cQryAux += "	B1_COD AS B1_COD"		+ STR_PULA		
	cQryAux += " FROM SB1010 "		+ STR_PULA
	cQryAux += " WHERE B1_XEANIM = '' AND B1_CODBAR <> '' AND D_E_L_E_T_ =''"		+ STR_PULA
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
	
	TCQuery cQryAux New Alias "QRY_UPD"	
	DbSelectArea("SB1")
	DbSetOrder(1)   
	dbSelectArea("QRY_UPD")
	QRY_UPD->(DbGoTop())
	While ! QRY_UPD->(Eof())          
 		//Atualiza produtos para informar que os mesmos foram impressos e importados no site do GS1  
 		//A função abaixo Print deleta o Alias impedindo gravar corretamente
		If SB1->(DbSeek(xFilial("SB1")+QRY_UPD->B1_COD))			
			Reclock("SB1",.F.)
				SB1->B1_XEANIM 	:= 'S' 
				SB1->B1_XEANDT 	:= Date() 
			SB1->(Msunlock())	  
		EndIf
		QRY_UPD->(DbSkip())		
	EndDo                                           
	QRY_UPD->(DbCloseArea())
	 			
			
	RestArea(aArea)
Return
