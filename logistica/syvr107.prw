#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR107  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SYVR107()
Local oReport := ReportDef()

oReport:PrintDialog()

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR107  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportDef()
Local oBreak,oBreak1, oCell, oReport, oSection 
Local cPerg	  := "SYVR107"
Local cReport := "SYVR107"
Local cTitulo := "Relatorio de pagamentos dos montadores"
Local cDescri := "Este programa irแ emitir a rela็ใo de pagamentos dos montadores."

oReport := TReport():New("SYVR107","Relatorio de pagamentos dos montadores",,{|oReport| ReportPrint(oReport)},"Rela็ใo de pagamentos dos montadores.")

If !SYPERGUNTA() 
	Return(.T.)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Sessao 1 (oSection1)                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       
oSection1 := TRSection():New(oReport, "Rela็ใo de pagamentos dos montadores", {"SC5","SC6","SB4"}, {"Por Montador"} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao da celulas da secao do relatorio                      ณ
//ณ                                                              ณ
//ณTRCell():New                                                  ณ
//ณExpO1 : Objeto TSection que a secao pertence                  ณ
//ณExpC2 : Nome da celula do relat๓rio. O SX3 serแ consultado    ณ
//ณExpC3 : Nome da tabela de referencia da celula                ณ
//ณExpC4 : Titulo da celula                                      ณ
//ณ        Default : X3Titulo()                                  ณ
//ณExpC5 : Picture                                               ณ
//ณ        Default : X3_PICTURE                                  ณ
//ณExpC6 : Tamanho                                               ณ
//ณ        Default : X3_TAMANHO                                  ณ
//ณExpL7 : Informe se o tamanho esta em pixel                    ณ
//ณ        Default : False                                       ณ
//ณExpB8 : Bloco de c๓digo para impressao.                       ณ
//ณ        Default : ExpC2                                       ณ
//ณ                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TRCell():New(oSection1,"C5_FILIAL" 		,,RetTitle("C5_FILIAL") 	,,TamSX3("C5_FILIAL")[1])
TRCell():New(oSection1,"C5_NUM"   		,,RetTitle("C5_NUM")   		,,TamSX3("C5_NUM")[1])
TRCell():New(oSection1,"C5_CODUSR"   	,,RetTitle("C5_CODUSR")   	,,TamSX3("C5_CODUSR")[1])
TRCell():New(oSection1,"C5_NOMEMON"		,,RetTitle("C5_NOMEMON")	,,TamSX3("C5_NOMEMON")[1])
TRCell():New(oSection1,"C6_ITEM"   		,,RetTitle("C6_ITEM")   	,,TamSX3("C6_ITEM")[1])
TRCell():New(oSection1,"C6_PRODUTO"   	,,RetTitle("C6_PRODUTO")   	,,TamSX3("C6_PRODUTO")[1])
TRCell():New(oSection1,"B1_DESC"		,,RetTitle("B1_DESC")		,,TamSX3("B1_DESC")[1])
TRCell():New(oSection1,"C6_DTMONTA" 	,,RetTitle("C6_DTMONTA") 	,,TamSX3("C6_DTMONTA")[1])
TRCell():New(oSection1,"C6_QTDVEN" 		,,RetTitle("C6_QTDVEN") 	,,TamSX3("C6_QTDVEN")[1])
TRCell():New(oSection1,"VLR_PAGAR"		,,RetTitle("B4_01VLMON")	,PesqPict("SD2","D2_QUANT"),TamSX3("B4_01VLMON")[1])
TRCell():New(oSection1,"TOT_PAGAR"		,,"Vlr. Pagar"				,PesqPict("SD2","D2_QUANT"),TamSX3("B4_01VLMON")[1])

oSection1:Cell("C6_QTDVEN"):SetHeaderAlign("RIGHT")
oSection1:Cell("VLR_PAGAR"):SetHeaderAlign("RIGHT")
oSection1:Cell("TOT_PAGAR"):SetHeaderAlign("RIGHT")
                                  
oBreak := TRBreak():New(oSection1,oSection1:Cell("C5_CODUSR"),"Totais por Montador")

TRFunction():New(oSection1:Cell("TOT_PAGAR"),/*cID*/,"SUM",oBreak,,PesqPict("SD2","D2_QUANT"),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)

oReport:SetTotalInLine(.F.)
oReport:SetLandscape()

Return( oReport )
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR107  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportPrint( oReport )
Local cQuery       	:= ""
Local cAlias       	:= GetNextAlias()
Local oSection1 	:= oReport:Section(1)
Local oSectionPed  	:= oSection1:Section(1)
Local nQtdSld      	:= 0
Local cDesTipo     	:= ""
Local nOrdem 	   	:= oSection1:GetOrder()

cQuery := "SELECT C5_FILIAL,C5_NUM,C5_CODUSR,C5_NOMEMON,C6_ITEM,C6_PRODUTO,B1_DESC,C6_QTDVEN, C6_DTMONTA, B4_01VLMON " + CRLF
cQuery += "FROM "+RetSqlName("SC6")+" SC6 " + CRLF
cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_NUM=C6_NUM AND SC5.D_E_L_E_T_ <> '*' " + CRLF
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD=C6_PRODUTO AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <> '*' " + CRLF
cQuery += "INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_COD=B1_01PRODP AND B4_FILIAL = '"+xFilial("SB4")+"' AND SB4.D_E_L_E_T_ <> '*' " + CRLF
cQuery += "WHERE " + CRLF
cQuery += "		C5_FILIAL=C6_FILIAL " + CRLF
cQuery += "AND 	C5_CODUSR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" + CRLF
cQuery += "AND 	C6_DTMONTA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' " + CRLF
cQuery += "AND 	C5_CODUSR  <> ' ' " + CRLF
cQuery += "AND 	C6_DTMONTA <> ' ' " + CRLF
cQuery += "AND 	SC6.D_E_L_E_T_ <> '*' " + CRLF
cQuery += "ORDER BY C5_CODUSR,C5_FILIAL,C6_ITEM " + CRLF	

DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

TCSetField(cAlias,"B4_01VLMON","N",TamSx3("B4_01VLMON" )[1], TamSx3("B4_01VLMON")[2])
TCSetField(cAlias,"C6_DTMONTA","D",8)

oReport:SetMeter( 1 )
oSection1:Init()

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )
	oReport:IncMeter()
	
	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf
		
	oSection1:Cell("C5_FILIAL"  	):SetBlock( { || (cAlias)->C5_FILIAL	} )
	oSection1:Cell("C5_NUM"    		):SetBlock( { || (cAlias)->C5_NUM		} )
	oSection1:Cell("C5_CODUSR"  	):SetBlock( { || (cAlias)->C5_CODUSR	} )
	oSection1:Cell("C5_NOMEMON" 	):SetBlock( { || (cAlias)->C5_NOMEMON	} )
	oSection1:Cell("C6_ITEM"    	):SetBlock( { || (cAlias)->C6_ITEM		} )
	oSection1:Cell("C6_PRODUTO" 	):SetBlock( { || (cAlias)->C6_PRODUTO	} )
	oSection1:Cell("B1_DESC" 		):SetBlock( { || (cAlias)->B1_DESC		} )
	oSection1:Cell("C6_DTMONTA"		):SetBlock( { || (cAlias)->C6_DTMONTA	} )
	oSection1:Cell("C6_QTDVEN" 		):SetBlock( { || (cAlias)->C6_QTDVEN	} )	
	oSection1:Cell("VLR_PAGAR"		):SetBlock( { || (cAlias)->B4_01VLMON	} )
	oSection1:Cell("TOT_PAGAR"		):SetBlock( { || (cAlias)->C6_QTDVEN * (cAlias)->B4_01VLMON	} )
					
	oSection1:PrintLine()

	(cAlias)->( dbSkip() )
EndDo

oSection1:Finish()

(cAlias)->( dbCloseArea() )

Return( oReport )
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYPERGUNTAบAutor  ณMicrosiga           บ Data ณ  25/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SYPERGUNTA()

Local aBoxParam  := {}
Local aRetParam  := {}

Aadd(aBoxParam,{1,"Do Montador"			,CriaVar("C5_CODUSR",.F.)					,PesqPict("SC5","C5_CODUSR"),"","SZ5","",50,.F.})
Aadd(aBoxParam,{1,"Ate Montador"	   	,Replicate("Z",TamSx3("C5_CODUSR")[1])		,PesqPict("SC5","C5_CODUSR"),"","SZ5","",50,.F.})
Aadd(aBoxParam,{1,"Dt.Montagem De"		,FirstDay(dDatabase)						,PesqPict("SC6","C6_DTMONTA"),"","","",50,.F.})
Aadd(aBoxParam,{1,"Dt.Montagem Ate"		,LastDay(dDatabase)							,PesqPict("SC6","C6_DTMONTA"),"","","",50,.F.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

Mv_par01   := aRetParam[1]
Mv_par02   := aRetParam[2]
Mv_par03   := Iif(empty(aRetParam[03]),ctod(''),aRetParam[03])
Mv_par04   := Iif(empty(aRetParam[04]),ctod(''),aRetParam[04])

Return(.T.)