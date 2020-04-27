#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMCOMR04  ºAutor  ³Caio Garcia           º Data ³  02/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de ORCxPVxSCxPC                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMCOMR04()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria as Celulas que vao ser Apresentadas no Relatorio          ±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oSection  
Local _cPerg := "KMCOMR04" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMCOMR04","Relatorio NF_Entrada",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio NF_Entrada")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio NF_Entrada",{"KMCOMR04"})        

TRCell():New(oSection,"DOC","KMCOMR04","DOC",,9,,,,,,,,,,,,.F.)                  	                      
TRCell():New(oSection,"PEDIDO","KMCOMR04","PEDIDO",,8,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SERIE","KMCOMR04","SERIE",,3,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO","KMCOMR04","TIPO",,2,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FILIAL","KMCOMR04","FILIAL",,5,,,,,,,,,,,,.F.)
TRCell():New(oSection,"LOJA","KMCOMR04","LOJA",,3,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DT_EMISSA","KMCOMR04","DT_EMISSA",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DT_DIGT","KMCOMR04","DT_DIGT",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FORN_CLI","KMCOMR04","FORN/CLI",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CNPJ_CPF","KMCOMR04","CNPJ/CPF",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"RSOCIL_CLI","KMCOMR04","RSOCIL/CLI",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VAL_MERC","KMCOMR04","VAL_MERC",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VENCREA","KMCOMR04","VENCREA",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NATUREZA","KMCOMR04","NATUREZA",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DESC_NAT","KMCOMR04","DESC_NAT",,25,,,,,,,,,,,,.F.)
Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 		Query que alimenta 0 Relatorio                          ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
 
BeginSql alias "KMCOMR04" 
	%noParser%

SELECT 
F1_DOC DOC,
D1_PEDIDO PEDIDO, 
F1_SERIE SERIE,
F1_TIPO TIPO,
F1_FILIAL FILIAL,
F1_LOJA LOJA,
SUBSTRING (F1_EMISSAO,7,2) +'/'+ SUBSTRING(F1_EMISSAO,5,2)+'/'+ SUBSTRING(F1_EMISSAO,1,4)  DT_EMISSA,
SUBSTRING (F1_DTDIGIT,7,2) +'/'+ SUBSTRING(F1_DTDIGIT,5,2)+'/'+ SUBSTRING(F1_DTDIGIT,1,4) DT_DIGT,
CASE WHEN F1_TIPO IN ('B','D') THEN A1_COD ELSE F1_FORNECE END FORN_CLI,
CASE WHEN F1_TIPO IN ('B','D') THEN A1_CGC ELSE A2_CGC END CNPJ_CPF,
CASE WHEN F1_TIPO IN ('B','D') THEN A1_NOME ELSE A2_NOME END RSOCIL_CLI,
F1_VALMERC VAL_MERC,
ED_DESCRIC DESC_NAT
FROM SF1010 SF1 (NOLOCK)
INNER JOIN SA2010 SA2(NOLOCK) ON SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.%notDel%
LEFT JOIN SA1010 SA1 (NOLOCK) ON SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA AND SA1.%notDel%
LEFT JOIN SD1010 SD1 (NOLOCK) ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.%notDel%
LEFT JOIN SE2010 SE2 (NOLOCK) ON SE2.E2_NUM = SF1.F1_DOC AND SE2.E2_FORNECE =  SF1.F1_FORNECE AND SE2.%notDel%
LEFT JOIN SED010 SED (NOLOCK) ON SED.ED_CODIGO = SE2.E2_NATUREZ AND SED.%notDel%
WHERE SF1.%notDel% 
AND F1_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
AND D1_PEDIDO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
AND F1_DOC BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
AND E2_NATUREZ BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
GROUP BY F1_FILIAL,F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA,F1_DOC,D1_PEDIDO, F1_SERIE,F1_TIPO,F1_VALMERC,F1_EMISSAO, F1_DTDIGIT, A1_COD, A1_CGC, A2_CGC,A1_NOME,A2_NOME,ED_DESCRIC
ORDER BY DT_EMISSA

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMCOMR04.sql',oSection:GetQuery())

 oSection:Init()
                oSection:SetHeaderSection(.T.)
DbSelectArea("SE2")
SE2->(DbSetorder(6))
SE2->(Dbgotop())	
                DbSelectArea('KMCOMR04')
                KMCOMR04->(dbGoTop())
                oReport:SetMeter(KMCOMR04->(RecCount()))
                While KMCOMR04->(!Eof())
                               If oReport:Cancel()
                                               Exit
                               EndIf

                               oReport:IncMeter()

                               oSection:Cell("DOC"):SetValue(KMCOMR04->DOC)
                               oSection:Cell("DOC"):SetAlign("CENTER")

                               oSection:Cell("PEDIDO"):SetValue(KMCOMR04->PEDIDO)
                               oSection:Cell("PEDIDO"):SetAlign("CENTER")
                               
                               oSection:Cell("SERIE"):SetValue(KMCOMR04->SERIE)
                               oSection:Cell("SERIE"):SetAlign("CENTER")
                               
                               oSection:Cell("TIPO"):SetValue(KMCOMR04->TIPO)
                               oSection:Cell("TIPO"):SetAlign("CENTER")
                               
                               oSection:Cell("FILIAL"):SetValue(KMCOMR04->FILIAL)
                               oSection:Cell("FILIAL"):SetAlign("CENTER")
                               
                               oSection:Cell("LOJA"):SetValue(KMCOMR04->LOJA)
                               oSection:Cell("LOJA"):SetAlign("CENTER")
                               
                               oSection:Cell("DT_EMISSA"):SetValue(KMCOMR04->DT_EMISSA)
                               oSection:Cell("DT_EMISSA"):SetAlign("CENTER")
                               
                               oSection:Cell("DT_DIGT"):SetValue(KMCOMR04->DT_DIGT)
                               oSection:Cell("DT_DIGT"):SetAlign("CENTER")
                               
                               oSection:Cell("FORN_CLI"):SetValue(KMCOMR04->FORN_CLI)
                               oSection:Cell("FORN_CLI"):SetAlign("CENTER")
                               
                               oSection:Cell("CNPJ_CPF"):SetValue(KMCOMR04->CNPJ_CPF)
                               oSection:Cell("CNPJ_CPF"):SetAlign("CENTER")
                               
                               oSection:Cell("RSOCIL_CLI"):SetValue(KMCOMR04->RSOCIL_CLI)
                               oSection:Cell("RSOCIL_CLI"):SetAlign("CENTER")
                               
                               oSection:Cell("VAL_MERC"):SetValue(KMCOMR04->VAL_MERC)
                               oSection:Cell("VAL_MERC"):SetAlign("CENTER")
                               
                               SE2->(DbGoTop())
                               SE2->(DbSeeK(XFILIAL("SE2")+KMCOMR04->FORN_CLI+KMCOMR04->LOJA+KMCOMR04->SERIE+KMCOMR04->DOC))
                               
                               oSection:Cell("VENCREA"):SetValue(SE2->E2_VENCREA)
                               oSection:Cell("VENCREA"):SetAlign("CENTER")
                               
                               oSection:Cell("NATUREZA"):SetValue(SE2->E2_NATUREZ)
                               oSection:Cell("NATUREZA"):SetAlign("CENTER")
                               
                                 oSection:PrintLine()

                               dbSelectArea("KMCOMR04")
                               KMCOMR04->(dbSkip())
                EndDo
                oSection:Finish()

  
//oSection:Print()   
oReport:SetPortrait()

Return    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ AjustaSX1³ Autor ³ Bruno Gomes           ³ Data ³  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Verifica as perguntas inclu¡ndo-as caso não existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fAjustSX1(_cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := padr(_cPerg,len(SX1->X1_GRUPO))

Aadd(aRegs,{_cPerg,"01","Data De...","MV_CH1"   ,"D",8,0,"G","MV_PAR01","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Até..","MV_CH2"   ,"D",8,0,"G","MV_PAR02","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Pedido de...","MV_CH3" ,"C",6,0,"G","MV_PAR03","SC7","","","","",""})
Aadd(aRegs,{_cPerg,"04","Pedido Até..","MV_CH4" ,"C",6,0,"G","MV_PAR04","SC7","","","","",""})
Aadd(aRegs,{_cPerg,"05","Nota De...","MV_CH5","C",9,0,"G","MV_PAR05","SF1","","","","",""})
Aadd(aRegs,{_cPerg,"06","Nota Até..","MV_CH6","C",9,0,"G","MV_PAR06","SF1","","","","",""})
Aadd(aRegs,{_cPerg,"07","Natureza De...","MV_CH5","C",9,0,"G","MV_PAR07","SED","","","","",""})
Aadd(aRegs,{_cPerg,"08","Natureza Até..","MV_CH7","C",9,0,"G","MV_PAR08","SED","","","","",""})

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
