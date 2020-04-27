#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function KHRNF01()


Local oReport
Private cPerg := "KHRNF01"
Private cNomeProg 	:= "KHRNF01"
Private cTitulo 	:= "Conferencia Entrada de Notas"
Private nCount		:= _nTOTGER := 0
Private _cFilial	:= ""
Private cFilBkp		:= cFilAnt
Private cRecPagAnt 	:= ""
Private aSelFil 	:= {}
Private bCond1 		:= {},bCond2 := {}
Private aOrd := {}
Private dEmissINI
Private dEmissFIM
Private dEmisMonth
Private dEmisUltM1
Private dEmisUltM2
Private dEmisUltM3
Private _dDataBase
Private _cAlias		:= GetNextAlias()

AjustaSX1(cPerg)

Pergunte(cPerg,.T.)

oReport:=ReportDef()
oReport:PrintDialog()


Return


Static Function ReportDef()
Local oReport
Local oSection
Local oReport
Local oSection
Local oBreak1,oBreak2
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de Entrada de Notas"



DbSelectArea("SM0")
DbSetOrder(1)

oReport	:=	TReport():New("KHPROCNF","Documentos de Entrada",, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)
oSection := TRSection():New(oReport,OemToAnsi(cNomeProg),{_cAlias})
oReport:oPage:nPaperSize := 9
oReport:SetLandscape()


TRCell():New(oSection, "M0_CGC"				   	  		      									   		, 	, "CNPJ Destinatário"	     						,							,08)
TRCell():New(oSection, "M0_NOMECOM"				   	  		      										, 	, "Razão Social_Destinatário"	     						,							,08)
TRCell():New(oSection, "Filial"	  				   										   				, 	, "Filial"		   	   				,							,20)
TRCell():New(oSection, "Num_Nota"	  	     	   								   						, 	, "Nº da Nota"		   				,							,06)
TRCell():New(oSection, "Emissao"	  	     	   								   						, 	, "Emissao"		   				,							,06)
TRCell():New(oSection, "Descricao"		    											   				, 	, "Descr. Prod."							,							,40)
TRCell():New(oSection, "Cod_do_item"				    								   		   		, 	, "Cod do item"							,							,40)
TRCell():New(oSection, "Cod_Interno_Cliente"			    											, 	, "Cod Interno Cliente"							,							,10)
TRCell():New(oSection, "Pedido"			    												  			, 	, "Nº do Pedido"							,							,10)
TRCell():New(oSection, "Valor_Unitario"			    								   		   			, 	, "Valor Unitario"							,							,40)
TRCell():New(oSection, "Quantidade"			    									   					, 	, "Quantidade"							,							,10)
TRCell():New(oSection, "Valor_Total_Prodt"			    								   		   		, 	, "Valor Total Prodt"							,							,40)
TRCell():New(oSection, "Origem"						    									   			, 	, "Origem"							,							,10)
TRCell():New(oSection, "Cfop"			    								   		   					, 	, "Cfop"							,							,40)
TRCell():New(oSection, "Natureza_Opera"				    									   			, 	, "Natureza Operação"							,							,10)
TRCell():New(oSection, "CNPJ_Emitente"				    									   			, 	, "CNPJ Emitente"							,							,10)
TRCell():New(oSection, "Razao_Social_Emitente"			    								   		   	, 	, "Razão Social Emitente"							,							,40)


Return oReport


Static Function PrintReport(oReport)

Local oSection
Local xFilCor := ""


oSection:=oReport:Section(1) //Inicializa a primeira sessao do treport

MsgMeter({|	oMeter, oText, oDlg, lEnd | xGerTrb(oMeter, oText, oDlg, lEnd,oSection)},"Aguarde...")

oSection:Cell("M0_CGC"  	   		):SetBlock({ || Posicione("SM0",1,cEmpant+(_cAlias)->Filial,"M0_CGC")})
oSection:Cell("M0_NOMECOM"  	   	):SetBlock({ || Posicione("SM0",1,cEmpant+(_cAlias)->Filial,"M0_NOMECOM") 	})
oSection:Cell("Filial"  	   		):SetBlock({ || (_cAlias)->Filial  											})
oSection:Cell("Num_Nota"  	   		):SetBlock({ || (_cAlias)->Num_Nota  											})
oSection:Cell("Emissao"		   		):SetBlock({ || (_cAlias)->Emissao  											})
oSection:Cell("Cod_do_item" 		):SetBlock({ || (_cAlias)->Cod_do_item				  							})
oSection:Cell("Descricao" 	   		):SetBlock({ || (_cAlias)->Descricao				   							})
oSection:Cell("Cod_Interno_Cliente" ):SetBlock({ || (_cAlias)->Cod_Interno_Cliente 									})
oSection:Cell("Pedido"		   		):SetBlock({ || (_cAlias)->Pedido			   									})
oSection:Cell("Valor_Unitario" 	   	):SetBlock({ || (_cAlias)->Valor_Unitario		  								})
oSection:Cell("Quantidade"  		):SetBlock({ || (_cAlias)->Quantidade 											})
oSection:Cell("Valor_Total_Prodt"	):SetBlock({ || (_cAlias)->Valor_Total_Prodt		    						})
oSection:Cell("Origem"		   		):SetBlock({ || (_cAlias)->Origem			  									})
oSection:Cell("Cfop" 				):SetBlock({ || (_cAlias)->Cfop						  							})
oSection:Cell("Natureza_Opera" 		):SetBlock({ || (_cAlias)->Natureza_Opera			   							})
oSection:Cell("CNPJ_Emitente"  		):SetBlock({ || (_cAlias)->CNPJ_Emitente										})
oSection:Cell("Razao_Social_Emitente"):SetBlock({ || (_cAlias)->Razao_Social_Emitente								})
oSection:Print()

(_cAlias)->( dbCloseArea() )

Return


Static Function  xGerTrb(oMeter, oText, oDlg, lEnd,oSection)
Local nOrdem := oSection:GetOrder()
Local cQuery := ""


BEGINSQL ALIAS _cAlias
	
	%NoParser%
	SELECT
	D1_DOC Num_Nota,
	D1_FILIAL Filial,
	B1_DESC Descricao,
	D1_COD Cod_do_item,
	A5_CODPRF Cod_Interno_Cliente,
	D1_PEDIDO Pedido,
	D1_VUNIT Valor_Unitario,
	D1_QUANT Quantidade,
	D1_TOTAL Valor_Total_Prodt,
	D1_ORIGEM Origem,
	D1_CF Cfop,
	F4_TEXTO Natureza_Opera,
	A2_CGC CNPJ_Emitente,
	A2_NOME Razao_Social_Emitente,
	D1_EMISSAO Emissao
	FROM SD1010 (NOLOCK) SD1 JOIN SB1010 (NOLOCK) SB1
	ON SD1.D1_COD=SB1.B1_COD JOIN SA5010 (NOLOCK) SA5
	ON SD1.D1_COD=SA5.A5_PRODUTO AND SD1.D1_FORNECE=SA5.A5_FORNECE  AND SD1.D1_LOJA=SA5.A5_LOJA JOIN SF4010 (NOLOCK) SF4
	ON SD1.D1_TES=SF4.F4_CODIGO JOIN SA2010 (NOLOCK) SA2
	ON SD1.D1_FORNECE=SA2.A2_COD AND SD1.D1_LOJA=SA2.A2_LOJA
	WHERE D1_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND SD1.D_E_L_E_T_=''
	AND SB1.D_E_L_E_T_=''
	AND SA5.D_E_L_E_T_=''
	AND SA2.D_E_L_E_T_=''
	AND SF4.D_E_L_E_T_=''
ENDSQL


dbSelectArea(_cAlias)

Return


Static Function AjustaSX1()
Local aPerg := {}

putSx1(cPerg, "01", "Data Em. Ini.?"	  	, "", "", "mv_ch1", "D", tamSx3("D1_EMISSAO")[1], 0, 0, "G", "", "SC5", "", "", "mv_par01")
putSx1(cPerg, "02", "Data Em. Fim?"	  		, "", "", "mv_ch2", "D", tamSx3("D1_EMISSAO")[1], 0, 0, "G", "", "SC5", "", "", "mv_par02")

Return
