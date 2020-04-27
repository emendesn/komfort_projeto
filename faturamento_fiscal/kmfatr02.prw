#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFATR02  ºAutor  ³Murilo Zoratti        º Data ³  04/12/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Notas Saida                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMFATR02()

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
Local _cPerg := "KMFATR02" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMFATR02","Relatorio NF_SaidaxEntrada",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio NF_SaidaxEntrada")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio NF_SaidaxEntrada",{"KMFATR02"})        

TRCell():New(oSection,"FILIAL","KMFATR02","FILIAL",,4,,,,,,,,,,,,.F.)                  	                      
TRCell():New(oSection,"ESPECIE","KMFATR02","ESPECIE",,4,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO","KMFATR02","TIPO",,1,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SERIE","KMFATR02","SERIE",,2,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOTA","KMFATR02","NOTA",,9,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DATA","KMFATR02","DATA",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"LOJA","KMFATR02","LOJA",,01,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME","KMFATR02","NOME",,25,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CNPJ_CPF","KMFATR02","CNPJ_CPF",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CNPJ_CPF","KMFATR02","CNPJ/CPF",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CODCLI","KMFATR02","CODCLI/CLI",,8,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VALOR","KMFATR02","VALOR",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VAL_ITEM","KMFATR02","VAL_ITEM",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TES","KMFATR02","TES",,5,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CFOP","KMFATR02","CFOP",,5,,,,,,,,,,,,.F.)
TRCell():New(oSection,"OPERACAO","KMFATR02","OPERACAO",,5,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DUPLIC","KMFATR02","DUPLIC",,9,,,,,,,,,,,,.F.)
TRCell():New(oSection,"BASEICMS","KMFATR02","BASEICMS",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PICMS","KMFATR02","PICMS",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ICMS","KMFATR02","ICMS",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"BASEIPI","KMFATR02","BASEIPI",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"IPI","KMFATR02","IPI",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PIS","KMFATR02","PIS",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CASECOF","KMFATR02","CASECOF",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"COFINS","KMFATR02","COFINS",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO_OP","KMFATR02","TIPO_OP",,7,,,,,,,,,,,,.F.)

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
 
BeginSql alias "KMFATR02" 
	%noParser%

SELECT F2_FILIAL FILIAL,
F2_ESPECIE ESPECIE,
F2_TIPO TIPO,
F2_SERIE SERIE,
F2_DOC NOTA,
SUBSTRING (F2_EMISSAO,7,2) +'/'+ SUBSTRING(F2_EMISSAO,5,2)+'/'+ SUBSTRING(F2_EMISSAO,1,4) DATA,
F2_LOJA LOJA,
CASE WHEN F2_TIPO IN ('B','D') THEN A2_NOME ELSE A1_NOME END NOME,
CASE WHEN F2_TIPO IN ('B','D') THEN A2_CGC ELSE A1_CGC END CNPJ_CPF,
F2_CLIENT CODCLI, 
F2_EST ESTADO, 
F2_VALBRUT VALOR,
D2_VALBRUT VAL_ITEM,
CASE WHEN D2_TES > 500 THEN 'SAIDA' ELSE 'ENTRADA' END TIPO_OP,
D2_TES TES,
F4_CF CFOP,
F4_TEXTO OPERACAO,
F2_DUPL DUPLIC,
F2_BASEICM BASEICMS, 
D2_PICM PICMS, 
D2_VALICM ICMS,
D2_BASEIPI BASEIPI,
D2_IPI IPI,
D2_VALPIS PIS,
D2_BASECOF CASECOF,
D2_VALCOF COFINS
FROM SF2010 SF2
INNER JOIN SD2010 SD2 ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.%notDel% 
INNER JOIN SF4010 SF4 ON SF4.F4_CODIGO = SD2.D2_TES AND SF4.%notDel% 
LEFT JOIN SA2010 SA2(NOLOCK) ON SA2.A2_COD = SF2.F2_CLIENTE AND SA2.A2_LOJA = SF2.F2_LOJA AND SA2.%notDel% 
LEFT JOIN SA1010 SA1 (NOLOCK) ON SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.%notDel% 
WHERE SF2.%notDel% AND F2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
UNION ALL
SELECT F1_FILIAL FILIAL,
F1_ESPECIE ESPECIE,
F1_TIPO TIPO,
F1_SERIE SERIE,
F1_DOC NOTA,
SUBSTRING (F1_EMISSAO,7,2) +'/'+ SUBSTRING(F1_EMISSAO,5,2)+'/'+ SUBSTRING(F1_EMISSAO,1,4) DATA,
F1_LOJA LOJA,
CASE WHEN F1_TIPO IN ('B','D') THEN A1_NOME ELSE A2_NOME END NOME,
CASE WHEN F1_TIPO IN ('B','D') THEN A1_CGC ELSE A2_CGC END CNPJ_CPF,
F1_FORNECE CODCLI, 
F1_EST ESTADO, 
F1_VALBRUT VALOR,
D1_TOTAL VAL_ITEM,
CASE WHEN D1_TES > 500 THEN 'SAIDA' ELSE 'ENTRADA' END TIPO_OP,
D1_TES TES,
F4_CF CFOP,
F4_TEXTO OPERACAO,
F1_DUPL DUPLIC,
F1_BASEICM BASEICMS, 
D1_PICM PICMS, 
D1_VALICM ICMS,
D1_BASEIPI BASEIPI,
D1_IPI IPI,
D1_VALPIS PIS,
D1_BASECOF CASECOF,
D1_VALCOF COFINS
FROM SF1010 SF1
INNER JOIN SD1010 SD1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.%notDel% 
INNER JOIN SF4010 SF4 ON SF4.F4_CODIGO = SD1.D1_TES AND SF4.%notDel% 
LEFT JOIN SA2010 SA2(NOLOCK) ON SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.%notDel% 
LEFT JOIN SA1010 SA1 (NOLOCK) ON SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA AND SA1.%notDel% 
WHERE SF1.%notDel% 
AND F1_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
AND F4_CF BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
ORDER BY TIPO_OP,FILIAL,ESPECIE,TIPO,SERIE,NOTA

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMFATR02.sql',oSection:GetQuery())

oSection:Print()   
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
Aadd(aRegs,{_cPerg,"03","TES de...","MV_CH3" ,"C",6,0,"G","MV_PAR03","SF4","","","","",""})
Aadd(aRegs,{_cPerg,"04","TES Até..","MV_CH4" ,"C",6,0,"G","MV_PAR04","SF4","","","","",""})


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
