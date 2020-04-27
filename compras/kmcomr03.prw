#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMCOMR03  ºAutor  ³Caio Garcia           º Data ³  02/08/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de NF Entrada                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMCOMR03()

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
Local _cPerg := "KMCOMR03" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMCOMR03","Relatorio NF Entrada x Pedido Compras",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio NF Entrada x Pedido Compras")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio NF Entrada x Pedido Compras",{"SD1","SF1","SB1","SA2","SC7"})        
                  	                      
TRCell():New(oSection,"PEDIDO","SD1","PEDIDO",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"EMISSAO_PC","SC7","EMISSAO_PC",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FORNECEDOR","SA2","FORNECEDOR",,50,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO","SB1","TIPO",,03,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CODIGO","SD1","CODIGO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DESCRICAO","SB1","DESCRICAO",,40,,,,,,,,,,,,.F.)
TRCell():New(oSection,"QUANT","SD1","QUANT",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VLR_UNIT","SD1","VLR_UNIT",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TOTAL","SD1","TOTAL",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOTA_FISCAL","SD1","NOTA_FISCAL",,09,,,,,,,,,,,,.F.)
TRCell():New(oSection,"EMISSAO_NF","SF1","EMISSAO_NF",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DT_DIGIT","SF1","DT_DIGIT",,12,,,,,,,,,,,,.F.)

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
Local _cOrder  := ""

If MV_PAR11 == '1'
	_cOrder := ' F1_EMISSAO'
Else
	_cOrder := ' F1_DTDIGIT'
EndIf	 
 
BeginSql alias "KMCOMR03" 
	%noParser%
 
SELECT D1_PEDIDO PEDIDO,  
CASE WHEN C7_EMISSAO IS NULL THEN '' ELSE SUBSTRING(C7_EMISSAO,7,2)+'/'+SUBSTRING(C7_EMISSAO,5,2)+'/'+SUBSTRING(C7_EMISSAO,1,4) END  EMISSAO_PC,
 A2_NOME FORNECEDOR,
 B1_TIPO TIPO,
 D1_COD CODIGO,
 B1_DESC DESCRICAO,
 D1_QUANT QUANT, 
 D1_VUNIT VLR_UNIT, 
 D1_TOTAL TOTAL, 
 D1_DOC NOTA_FISCAL,
 SUBSTRING(F1_EMISSAO,7,2)+'/'+SUBSTRING(F1_EMISSAO,5,2)+'/'+SUBSTRING(F1_EMISSAO,1,4) EMISSAO_NF, 
 SUBSTRING(F1_DTDIGIT,7,2)+'/'+SUBSTRING(F1_DTDIGIT,5,2)+'/'+SUBSTRING(F1_DTDIGIT,1,4)  DT_DIGIT
FROM %table:SD1% (NOLOCK) SD1
INNER JOIN %table:SF1% (NOLOCK) SF1 ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND SF1.%notDel%
INNER JOIN %table:SB1% (NOLOCK) SB1 ON B1_COD = D1_COD AND SB1.%notDel%
INNER JOIN %table:SA2% (NOLOCK) SA2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.%notDel%
LEFT JOIN %table:SC7% (NOlOCK) SC7 ON C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC AND SC7.%notDel%
WHERE SD1.%notDel%
AND D1_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
AND F1_DOC BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
AND D1_COD BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
AND F1_FORNECE BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR09%
AND F1_LOJA BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR10%   
AND F1_STATUS = 'A'			//#RVC20181010.n				//Considera apenas as notas fiscais classificadas.
     
EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMCOMR03.sql',oSection:GetQuery())
  
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

Aadd(aRegs,{_cPerg,"01","Data De..."       ,"MV_CH1"   ,"D",8,0,"G","MV_PAR01","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Data Até.."       ,"MV_CH2"   ,"D",8,0,"G","MV_PAR02","","","","","",""})
Aadd(aRegs,{_cPerg,"03","Nota Fiscal De...","MV_CH3" ,"C",9,0,"G","MV_PAR03","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Nota Fiscal Até..","MV_CH4" ,"C",9,0,"G","MV_PAR04","","","","","",""})
Aadd(aRegs,{_cPerg,"05","Produto De..."    ,"MV_CH5","C",15,0,"G","MV_PAR05","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"06","Produto Até.."    ,"MV_CH6","C",15,0,"G","MV_PAR06","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"07","Fornecedor De.."  ,"MV_CH7","C",6,0,"G","MV_PAR07","SA2","","","","",""})
Aadd(aRegs,{_cPerg,"08","Loja De.."        ,"MV_CH8","C",2,0,"G","MV_PAR08","","","","","",""})
Aadd(aRegs,{_cPerg,"09","Fornecedor Até...","MV_CH9","C",6,0,"G","MV_PAR09","SA2","","","","",""})
Aadd(aRegs,{_cPerg,"10","Loja Até..."      ,"MV_CHA","C",2,0,"G","MV_PAR10","","","","","",""})

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
