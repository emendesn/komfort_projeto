#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function KHRPED003()


Local oReport
Private cPerg := "KHRPE03"
Private cNomeProg 	:= "KHRPED003"
Private cTitulo 	:= "Conferencia Emissao Pedidos"
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
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de Pedido por Código de Município"



DbSelectArea("SM0")
DbSetOrder(1)

oReport	:=	TReport():New("KHPROCPED","Pedidos por Código de Municipio",, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)
oSection := TRSection():New(oReport,OemToAnsi(cNomeProg),{_cAlias}) 
oReport:oPage:nPaperSize := 9 
oReport:SetLandscape()



TRCell():New(oSection, "M0_CODMUN"				   	  		      										, 	, "Codigo Municipio"	     						,							,08)
TRCell():New(oSection, "M0_CIDCOB"				   	  		      										, 	, "Municipio da Loja"	     						,							,08)
TRCell():New(oSection, "M0_FILIAL"					    										   		, 	, "Nome Emp.Reduzido"		   				,							,06)
TRCell():New(oSection, "Filial"	  				   										   				, 	, "Filial"		   	   				,							,20)
TRCell():New(oSection, "Emissao_Pedido"	  	     	   								   					, 	, "Emissao do Pedido"		   				,							,06)
TRCell():New(oSection, "Num_Pedido"			    											   			, 	, "Numero do Pedido"							,							,40)
TRCell():New(oSection, "Nota"				    								   		   				, 	, "Nota"							,							,40)
TRCell():New(oSection, "Serie"			    															, 	, "Serie da Nota"							,							,10)
TRCell():New(oSection, "Total_Nota"			    														, 	, "Total da Nota"							,							,10)
TRCell():New(oSection, "Municipio"			    								   		   				, 	, "Municipio Cliente"							,							,40)
TRCell():New(oSection, "Codigo_Municipio"			    									   			, 	, "Codigo Municipio do Cliente"							,							,10)


Return oReport


Static Function PrintReport(oReport)

Local oSection
Local xFilCor := ""

             
oSection:=oReport:Section(1) //Inicializa a primeira sessao do treport

MsgMeter({|	oMeter, oText, oDlg, lEnd | xGerTrb(oMeter, oText, oDlg, lEnd,oSection)},"Aguarde...")

oSection:Cell("M0_CODMUN"  	   		):SetBlock({ || Substr(Posicione("SM0",1,cEmpant+(_cAlias)->Filial_Pedido,"M0_CODMUN"),3,7)}) 
oSection:Cell("M0_CIDCOB"  	   		):SetBlock({ || Posicione("SM0",1,cEmpant+(_cAlias)->Filial_Pedido,"M0_CIDCOB") 	})
oSection:Cell("M0_FILIAL"  	   		):SetBlock({ || Posicione("SM0",1,cEmpant+(_cAlias)->Filial_Pedido,"M0_FILIAL") 	})
oSection:Cell("Filial"		   		):SetBlock({ || (_cAlias)->Filial  									})
oSection:Cell("Emissao_Pedido" 		):SetBlock({ || (_cAlias)->Emissao_Pedido  							})
oSection:Cell("Num_Pedido" 	   		):SetBlock({ || (_cAlias)->Num_Pedido   							})
oSection:Cell("Nota"   		   		):SetBlock({ || (_cAlias)->Nota    									})
oSection:Cell("Serie"		   		):SetBlock({ || (_cAlias)->Serie   									})
oSection:Cell("Total_Nota" 	   		):SetBlock({ || (_cAlias)->Total_Nota  								})
oSection:Cell("Municipio"  			):SetBlock({ || (_cAlias)->Municipio 								})
oSection:Cell("Codigo_Municipio"	):SetBlock({ || (_cAlias)->Codigo_Municipio    						})

oSection:Print()

(_cAlias)->( dbCloseArea() )

Return


Static Function  xGerTrb(oMeter, oText, oDlg, lEnd,oSection)
Local nOrdem := oSection:GetOrder()
Local cQuery := ""

 
BEGINSQL ALIAS _cAlias

		%NoParser%
		SELECT FILFULL Filial,
		C5_EMISSAO Emissao_Pedido,
		C5_MSFIL Filial_Pedido,
		C5_NUM Num_Pedido,
		C5_NOTA Nota,
		C5_SERIE Serie,
		F2_VALBRUT Total_Nota,
		C5_CLIENTE,
		A1_COD Cod_Cliente,
		C5_LOJACLI Loja,
		A1_NOME Nome,
		A1_MUN Municipio,
		A1_COD_MUN Codigo_Municipio
		FROM SM0010 (NOLOCK) SM0
		JOIN SC5010 (NOLOCK) SC5 ON SM0.FILFULL=SC5.C5_MSFIL
		JOIN SA1010 (NOLOCK) SA1 ON SC5.C5_CLIENTE=SA1.A1_COD AND SC5.C5_LOJACLI=SA1.A1_LOJA
		JOIN SF2010 (NOLOCK) SF2 ON SC5.C5_MSFIL=SF2.F2_FILIAL AND SC5.C5_NOTA=SF2.F2_DOC AND SC5.C5_SERIE=SF2.F2_SERIE
		WHERE SC5.C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND SC5.D_E_L_E_T_='' AND SA1.D_E_L_E_T_=''
		AND SC5.C5_NOTA <>'' AND SC5.C5_TIPO NOT IN ('D','B')
	
		ORDER BY SM0.FILFULL
ENDSQL
        

dbSelectArea(_cAlias)

Return


Static Function AjustaSX1()
Local aPerg := {}

putSx1(cPerg, "01", "Data Em. Ped Ini.?"	  	, "", "", "mv_ch1", "D", tamSx3("C5_EMISSAO")[1], 0, 0, "G", "", "SC5", "", "", "mv_par01")
putSx1(cPerg, "02", "Data Em. Ped Fim?"	  		, "", "", "mv_ch2", "D", tamSx3("C5_EMISSAO")[1], 0, 0, "G", "", "SC5", "", "", "mv_par02")

Return