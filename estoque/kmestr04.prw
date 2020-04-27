#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMESTR04  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function KMESTR04()
Local oReport := ReportDef()

oReport:PrintDialog()

Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMESTR04  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de pagamento dos montadores                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Casa Cenario                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportDef()
Local oBreak,oBreak1, oCell, oReport, oSection 
Local cPerg	  := "KMESTR04"
Local cReport := "KMESTR04"
Local cTitulo := "Relatorio Total de estoque e valor"
Local cDescri := "Este programa irแ emitir a rela็ใo produtos e valor nos estoque 01, 04, 81, 46."

oReport := TReport():New("KMESTR04","Relatorio de produtos e valores.",,{|oReport| ReportPrint(oReport)},"Relatorio de produtos e valores.")

/*
If !SYPERGUNTA() 
	Return(.T.)
Endif
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Sessao 1 (oSection1)                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                       
oSection1 := TRSection():New(oReport, "Relatorio de produtos e valores.", {"SB1","SB2"}, {"Por estoque"} )

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
TRCell():New(oSection1,"CODIGO" 		,,"CODIGO" 	,,TamSX3("B2_COD")[1])
TRCell():New(oSection1,"DESCRICAO"   		,,"DESCRICAO"   		,,TamSX3("B1_DESC")[1])
TRCell():New(oSection1,"Estoque_01"   	,,"Estoque_01"  	,,TamSX3("B2_QATU")[1])
TRCell():New(oSection1,"Estoque_04"		,,"Estoque_04"	,,TamSX3("B2_QATU")[1])
TRCell():New(oSection1,"Estoque_81"   		,,"Estoque_81"    	,,TamSX3("B2_QATU")[1])
TRCell():New(oSection1,"Estoque_46"   	,,"Estoque_46"    	,,TamSX3("B2_QATU")[1])
TRCell():New(oSection1,"QATU_ESTOQUE"		,,"QATU_ESTOQUE"		,,TamSX3("B2_QATU")[1])
TRCell():New(oSection1,"VALOR_ESTOQUE" 	,,"VALOR_ESTOQUE" 	,,TamSX3("B2_VATU1")[1])
                                  
//oBreak := TRBreak():New(oSection1,oSection1:Cell("C5_CODUSR"),"Totais por Montador")

//TRFunction():New(oSection1:Cell("TOT_PAGAR"),/*cID*/,"SUM",oBreak,,PesqPict("SD2","D2_QUANT"),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)

oReport:SetTotalInLine(.F.)
oReport:SetLandscape()

Return( oReport )
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMESTR04  บ Autor ณ AP6 IDE            บ Data ณ  24/10/12   บฑฑ
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

cQuery := " SELECT O.CODIGO, ISNULL (B1_DESC, '') DESCRICAO, O.Estoque_01, O.Estoque_04, O.Estoque_46, O.Estoque_81, O.QATU_ESTOQUE, O.VALOR_ESTOQUE FROM ( "
cQuery += " SELECT DISTINCT ISNULL(F.B2_COD, '_TOTAL') AS CODIGO," + CRLF
cQuery += " CASE WHEN SUM(F.[01]) IS NULL THEN '0' ELSE SUM(F.[01]) END  Estoque_01, " + CRLF
cQuery += " CASE WHEN SUM(F.[04] ) IS NULL THEN '0' ELSE SUM(F.[04] ) END AS Estoque_04, " + CRLF
cQuery += " CASE WHEN SUM(F.[81]) IS NULL THEN '0' ELSE SUM(F.[81]) END AS Estoque_81, " + CRLF
cQuery += " CASE WHEN SUM(F.[46]) IS NULL THEN '0' ELSE SUM(F.[46]) END AS Estoque_46, " + CRLF 
cQuery += " SUM(F.B2_QATU) AS QATU_ESTOQUE, " + CRLF
cQuery += " SUM(F.VALOR) AS VALOR_ESTOQUE " + CRLF
cQuery += " FROM( SELECT * FROM " + CRLF
cQuery += " (SELECT B2_COD, B2_LOCAL, B2_QATU AS QUANTIDADE, B2_VATU1 AS VALOR , B1_DESC,B2_QATU FROM "+RetSqlName("SB2")+" SB2 " + CRLF
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = B2_COD AND SB1.D_E_L_E_T_ = '' " + CRLF
cQuery += " WHERE B2_LOCAL IN ('01','04','81','46') AND B2_FILIAL = '"+xFilial("SB2")+"'  AND SB2.D_E_L_E_T_ = '' AND B2_QATU  <> 0 " + CRLF
cQuery += " ) C PIVOT ( SUM(QUANTIDADE) " + CRLF
cQuery += " FOR B2_LOCAL IN ([01],[04],[81],[46])) AS P) AS F " + CRLF
cQuery += " GROUP BY B2_COD WITH ROLLUP) O " + CRLF
cQuery += " LEFT OUTER JOIN SB1010 ON O.CODIGO = B1_COD AND D_E_L_E_T_ <> '*' ORDER BY O.CODIGO "

		     
/*

TCSetField(cAlias,"B4_01VLMON","N",TamSx3("B4_01VLMON" )[1], TamSx3("B4_01VLMON")[2])
TCSetField(cAlias,"C6_DTMONTA","D",8)

*/

//DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.) 
MemoWrite('\Querys\KMESTR04.sql',cQuery)

plsQuery(cQuery,cAlias)


oReport:SetMeter( 1 )
oSection1:Init()

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )
	oReport:IncMeter()
	
	//-- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf
		
	oSection1:Cell("CODIGO"  	):SetBlock( { || (cAlias)->CODIGO	} )
	oSection1:Cell("DESCRICAO"  ):SetBlock( { || (cAlias)->DESCRICAO		} )
	oSection1:Cell("Estoque_01"  	):SetBlock( { || (cAlias)->Estoque_01	} )
	oSection1:Cell("Estoque_04" 	):SetBlock( { || (cAlias)->Estoque_04	} )
	oSection1:Cell("Estoque_81"    	):SetBlock( { || (cAlias)->Estoque_81		} )
	oSection1:Cell("Estoque_46" 	):SetBlock( { || (cAlias)->Estoque_46	} )
	oSection1:Cell("QATU_ESTOQUE" 		):SetBlock( { || (cAlias)->QATU_ESTOQUE		} )
	oSection1:Cell("VALOR_ESTOQUE"		):SetBlock( { || (cAlias)->VALOR_ESTOQUE	} )
						
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
/*
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

*/
Return(.T.)