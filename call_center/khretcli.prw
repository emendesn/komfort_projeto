#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function KHRETCLI()


Local oReport
Private cPerg := "KHRETCL"
Private cNomeProg 	:= "KHRETCLI"
Private cTitulo 	:= "Relatorio de Retorno de Cliente"
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

fAjustSX1(cPerg)

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
Local cDescricao	:=	"Este programa tem como objetivo imprimir relatorio de Retorno de Clientes"



DbSelectArea("SM0")
DbSetOrder(1)

oReport	:=	TReport():New("KHPROCLI","Relatorio de Retorno de Clientes",, {|oReport| PrintReport(@oReport)}, cDescricao, .T.)
oSection := TRSection():New(oReport,OemToAnsi(cNomeProg),{_cAlias}) 
oReport:oPage:nPaperSize := 9 
oReport:SetLandscape()



TRCell():New(oSection, "Atendimento"				, 	, "Atendimento"	     				, ,08)
TRCell():New(oSection, "Data_Atendimento"			, 	, "Data Atendimento"	     		, ,08)
TRCell():New(oSection, "Responsavel"				, 	, "Responsavel"	       				, ,20)
TRCell():New(oSection, "Data_Pedido"				, 	, "Data Pedido"	       				, ,08)
TRCell():New(oSection, "Entidade"				    , 	, "Entidade"		   				, ,06)
TRCell():New(oSection, "Codigo_Contato"	  			, 	, "Codigo Contato"		   	   		, ,20)
TRCell():New(oSection, "Nome_Contato"	  		    , 	, "Nome Contato"		   			, ,06)
TRCell():New(oSection, "Filial"			            , 	, "Filial"							, ,40)
TRCell():New(oSection, "Filial_Pedido"				, 	, "Filial Pedido"					, ,40)
TRCell():New(oSection, "Nome_Filial"				, 	, "Nome Filial"						, ,40)
TRCell():New(oSection, "Codigo_Operador"	   		, 	, "Codigo Operador"					, ,40)
TRCell():New(oSection, "Numero_Pedido"				, 	, "Numero Pedido"					, ,10)
TRCell():New(oSection, "Codigo_Vendedor"			, 	, "Codigo Vendedor"					, ,10)
TRCell():New(oSection, "Nome_Vendedor_Reduzido"		, 	, "Nome Vendedor Reduzido"			, ,40)
TRCell():New(oSection, "Status_Atendimento"		    , 	, "Status Atendimento"				, ,10)
TRCell():New(oSection, "Descricao_Status"		    , 	, "Descricao Status"				, ,10)
TRCell():New(oSection, "Tipo_Retorno"			    , 	, "Tipo Retorno"		    		, ,10)
TRCell():New(oSection, "Retorno_Cliente"		    , 	, "Retorno Cliente"		     		, ,10)


Return oReport


Static Function PrintReport(oReport)

Local oSection
Local xFilCor := ""

             
oSection:=oReport:Section(1) //Inicializa a primeira sessao do treport

MsgMeter({|	oMeter, oText, oDlg, lEnd | xGerTrb(oMeter, oText, oDlg, lEnd,oSection)},"Aguarde...")

oSection:Cell("Atendimento"		   		):SetBlock({ || (_cAlias)->Atendimento  									})
oSection:Cell("Data Atendimento" 		):SetBlock({ || (_cAlias)->Data_Atendimento		  							})
oSection:Cell("Responsavel" 			):SetBlock({ || (_cAlias)->Responsavel			  							})
oSection:Cell("Data_Pedido" 			):SetBlock({ || (_cAlias)->Data_Pedido			  							})
oSection:Cell("Entidade" 	   			):SetBlock({ || (_cAlias)->Entidade				   						    })
oSection:Cell("Codigo Contato"   		):SetBlock({ || (_cAlias)->Codigo_Contato						   			})
oSection:Cell("Nome Contato"		   	):SetBlock({ || (_cAlias)->Nome_Contato   									})
oSection:Cell("Filial" 			   		):SetBlock({ || (_cAlias)->Filial			  								})
oSection:Cell("Filial Pedido" 			):SetBlock({ || (_cAlias)->Filial_Pedido	  								})
oSection:Cell("Nome Filial" 			):SetBlock({ || (_cAlias)->Nome_Filial		  								})
oSection:Cell("Codigo Operador"  		):SetBlock({ || (_cAlias)->Codigo_Operador									})
oSection:Cell("Numero Pedido"			):SetBlock({ || (_cAlias)->Numero_Pedido		    						})
oSection:Cell("Codigo Vendedor"   		):SetBlock({ || (_cAlias)->Codigo_Vendedor 									})
oSection:Cell("Nome Vendedor Reduzido"	):SetBlock({ || (_cAlias)->Nome_Vendedor_Reduzido							})
oSection:Cell("Status Atendimento" 	   	):SetBlock({ || (_cAlias)->Status_Atendimento  								})
oSection:Cell("Descricao Status"  		):SetBlock({ || (_cAlias)->Descricao_Status 								})
oSection:Cell("Tipo Retorno"			):SetBlock({ || (_cAlias)->Tipo_Retorno			    						})
oSection:Cell("Retorno Cliente"			):SetBlock({ || (_cAlias)->Retorno_Cliente		    						})

oSection:Print()

(_cAlias)->( dbCloseArea() )

Return


Static Function  xGerTrb(oMeter, oText, oDlg, lEnd,oSection)
Local nOrdem := oSection:GetOrder()
Local cQuery := ""

 
BEGINSQL ALIAS _cAlias
		%NoParser%
		SELECT UC_CODIGO Atendimento, 
		UC_DATA Data_Atendimento,
		UL_DESC Responsavel,
		C5_EMISSAO Data_Pedido,
		C5_MSFIL Filial_Pedido, 
		SM0.FILIAL Nome_Filial, 
		UC_ENTIDAD Entidade, 
		UC_CODCONT Codigo_Contato, 
		U5_CONTAT Nome_Contato, 
		UC_01FIL Filial, 
		UC_OPERADO Codigo_Operador, 
		C5_NUM Numero_Pedido,
		C5_VEND1 Codigo_Vendedor,
		A3_NREDUZ Nome_Vendedor_Reduzido, 
		UC_STATUS Status_Atendimento,
        CASE WHEN UC_STATUS=3 THEN 'ENCERRADA' WHEN UC_STATUS=2 THEN 'PENDENTE' WHEN UC_STATUS=10 THEN 'FOTO' WHEN UC_STATUS=9 THEN 'EMAIL FAB' WHEN UC_STATUS=1 THEN 'PLANEJADA' WHEN UC_STATUS=4 THEN 'ANDAMENTO' END  Descricao_Status,
		UC_XRETCLI Tipo_Retorno,
		CASE WHEN UC_XRETCLI=2 THEN 'NAO' WHEN UC_XRETCLI=1 THEN 'SIM' WHEN UC_XRETCLI='' THEN 'NAO AVALIADO' END  Retorno_Cliente
		FROM SUC010 (NOLOCK) SUC 
		LEFT JOIN SU5010 (NOLOCK) SU5 ON SUC.UC_FILIAL=SU5.U5_FILIAL AND SUC.UC_CODCONT=SU5.U5_CODCONT 
		LEFT JOIN SC5010 (NOLOCK) SC5 ON SUBSTRING(SUC.UC_01PED,5,10)=SC5.C5_NUM
		LEFT JOIN SUL010 (NOLOCK) SUL ON UC_TIPO = UL_TPCOMUN AND SUL.D_E_L_E_T_ = '' 
		JOIN SA3010 SA3 ON SC5.C5_VEND1=SA3.A3_COD AND SC5.D_E_L_E_T_='' 
		JOIN SM0010 (NOLOCK) SM0 ON SC5.C5_MSFIL=SM0.FILFULL 
		WHERE SUC.D_E_L_E_T_='' 
		AND SU5.D_E_L_E_T_='' 
		AND SUC.UC_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SA3.A3_NREDUZ <>'' 
		AND SA3.A3_NREDUZ <>'KOMFORT HOUSE' 
		ORDER BY SUC.UC_CODIGO 
ENDSQL
        

DbSelectArea(_cAlias)

Return


Static Function fAjustSX1(cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := padr(cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de...","MV_CH1" ,"D",15,0,"G","MV_PAR01","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Até..","MV_CH2" ,"D",15,0,"G","MV_PAR02","","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For _i := 1 To Len(aRegs)
	
	If  !DbSeek(aRegs[_i,1]+aRegs[_i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with aRegs[_i,01]
		Replace X1_ORDEM   with aRegs[_i,02]
		Replace X1_PERGUNT with aRegs[_i,03]
		Replace X1_VARIAVL with aRegs[_i,04]
		Replace X1_TIPO    with aRegs[_i,05]
		Replace X1_TAMANHO with aRegs[_i,06]
		Replace X1_PRESEL  with aRegs[_i,07]
		Replace X1_GSC     with aRegs[_i,08]
		Replace X1_VAR01   with aRegs[_i,09]
		Replace X1_F3      with aRegs[_i,10]
		Replace X1_DEF01   with aRegs[_i,11]
		Replace X1_DEF02   with aRegs[_i,12]
		Replace X1_DEF03   with aRegs[_i,13]
		Replace X1_DEF04   with aRegs[_i,14]
		Replace X1_DEF05   with aRegs[_i,15]
		MsUnlock()
	EndIf
	
Next _i

RestArea(_aArea)

Return