#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMESTR05  ºAutor  ³Caio Garcia           º Data ³  02/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de ORCxPVxSCxPC                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMESTR05()

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
Local _cPerg := "KMESTR05" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMESTR05","Relatorio PC x NF_Entrada",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio PC x NF_Entrada")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio PC x NF_Entrada",{"SC7","SB1","SD1","SA2"})        
                  	                      
TRCell():New(oSection,"PEDIDO","SD1","PEDIDO",,8,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ITEM","SD1","ITEM",,3,,,,,,,,,,,,.F.)
TRCell():New(oSection,"COD_ITEM","SD1","COD_ITEM",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DESCR","SB1","DESC",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NF_ENT","SD1","NF_ENT",,9,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SERIE","SD1","SERIE",,3,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FORNECEDOR","SD1","FORNECEDOR",,6,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME","SA2","NOME",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"EMISSAO","SC7","EMISSAO",,10,,,,,,,,,,,,.F.)

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
 
BeginSql alias "KMESTR05" 
	%noParser%


SELECT D1_PEDIDO PEDIDO,
D1_ITEMPC ITEM, 
D1_COD COD_ITEM,
B1_DESC DESCR, 
D1_DOC NF_ENT,
D1_SERIE SERIE,
D1_FORNECE FORNECEDOR,
A2_NOME NOME,
SUBSTRING(C7_EMISSAO,7,2)+'/'+
SUBSTRING(C7_EMISSAO,5,2)+'/'+
SUBSTRING(C7_EMISSAO,1,4) EMISSAO
FROM SD1010 
INNER JOIN SC7010 ON SC7010.C7_NUM =SD1010.D1_PEDIDO AND SC7010.C7_ITEM = SD1010.D1_ITEMPC
INNER JOIN SB1010 ON SB1010.B1_COD = D1_COD AND SB1010.%notDel%
INNER JOIN SA2010 ON SA2010.A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA
WHERE
C7_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
AND C7_NUM BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
AND D1_DOC BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
ORDER BY D1_PEDIDO, D1_ITEMPC

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMESTR05.sql',oSection:GetQuery())
  
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
Aadd(aRegs,{_cPerg,"03","Pedido de...","MV_CH3" ,"C",6,0,"G","MV_PAR03","SC7","","","","",""})
Aadd(aRegs,{_cPerg,"04","Pedido Até..","MV_CH4" ,"C",6,0,"G","MV_PAR04","SC7","","","","",""})
Aadd(aRegs,{_cPerg,"05","Nota De...","MV_CH5","C",9,0,"G","MV_PAR05","SF1","","","","",""})
Aadd(aRegs,{_cPerg,"06","Nota Até..","MV_CH6","C",9,0,"G","MV_PAR06","SF1","","","","",""})

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
