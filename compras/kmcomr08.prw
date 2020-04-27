#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMCOMR08  ºAutor  ³Everton Santos        º Data ³  14/05/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Documento de Saida Por CFOP                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function KMCOMR08()

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
Local _cPerg := "KMCOMR08" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMCOMR08","Relatorio de Documento de Saida Por CFOP",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio de Documento de Saida Por CFOP")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio de Documento de Saida Por CFOP",{"SF2","SD2"})        
                  	                      
TRCell():New(oSection,"DOCUMENTO","SF2","DOCUMENTO",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SERIE","SF2","SERIE",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CODCLIENTE","SF2","CODCLIENTE",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"LOJA","SF2","LOJA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"EMISSAO","SF2","EMISSAO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"VALORBRUTO","SF2","VALORBRUTO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CODPRODUTO","SD2","CODPRODUTO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"QUANTIDADE","SD2","QUANTIDADE",,18,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PRECOVENDA","SD2","PRECOVENDA",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"IPI","SD2","IPI",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TOTAL","SD2","TOTAL",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ICM","SD2","ICM",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO","SD2","TIPO",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TES","SD2","TES",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TP","SD2","TP",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"GRUPO","SD2","GRUPO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CUSTO","SD2","CUSTO",,15,,,,,,,,,,,,.F.)

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ 		Query que alimenta o Relatorio                           ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
 
BeginSql alias "KMCOMR08" 
	%noParser%

SELECT F2_DOC AS DOCUMENTO,
F2_SERIE AS SERIE,
F2_CLIENTE AS CODCLIENTE,
F2_LOJA AS LOJA,
SUBSTRING(F2_EMISSAO,7,2) + '/' + SUBSTRING(F2_EMISSAO,5,2) + '/' + SUBSTRING(F2_EMISSAO,1,4) AS EMISSAO,
F2_VALBRUT AS VALORBRUTO,
D2_COD AS CODPRODUTO,
D2_QUANT AS QUANTIDADE,
D2_PRCVEN AS PRECOVENDA,
D2_IPI AS IPI,
D2_TOTAL AS TOTAL,
D2_PICM AS ICM,
D2_TIPO AS TIPO,
D2_TES AS TES,
D2_TP AS TP,
D2_GRUPO AS GRUPO,
D2_CUSTO1 AS CUSTO
FROM SF2010 F2
INNER JOIN SD2010 D2 ON F2_DOC = D2_DOC 
AND F2.F2_SERIE = D2.D2_SERIE 
AND F2.F2_CLIENTE = D2.D2_CLIENTE
AND F2.F2_LOJA = D2.D2_LOJA
WHERE D2_CF = %exp:MV_PAR03%
AND F2_EMISSAO BETWEEN %exp:MV_PAR01% AND  %exp:MV_PAR02%
AND F2.%notDel%
AND D2.%notDel%
ENDSQL

oSection:EndQuery()
MemoWrite('\Querys\KMCOMR08.sql',oSection:GetQuery())
  
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
Aadd(aRegs,{_cPerg,"03","CFOP......","MV_CH3"   ,"C",4,0,"G","MV_PAR03","","","","","",""})

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
