#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMSACR05  ºAutor  ³Wellington Raul       º Data ³  10/01/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de PESQUISA DE SATISFAÇÃO                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function KHPOSR001()

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
Local _cPerg := "KHPOSR001" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KHPOSR001","Relatorio de Pesquisa de satisfação",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio de Pesquisa de satisfação")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio de Pesquisa de satisfação",{"ZKA"})        
                  	                      
TRCell():New(oSection,"CHAMADO","ZKA","CHAMADO",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"COD_CLIENTE","ZKA","COD_CLIENTE",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME","SU5","NOME",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FILIAL","SUC","FILIAL",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ATEND_LOJA","ZKA","ATEND_LOJA",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ATEND_GERENTE","ZKA","ATEND_GERENTE",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ATEND_VENDEDOR","ZKA","ATEND_VENDEDOR",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"OPR_COMPRA","ZKA","OPR_COMPRA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"APRO_CREDITO","ZKA","APRO_CREDITO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ATEN_SAC","ZKA","ATEN_SAC",,18,,,,,,,,,,,,.F.)
TRCell():New(oSection,"AGEND_ENREGA","ZKA","AGEND_ENREGA",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"AVAR_ENTREGA","ZKA","AVAR_ENTREGA",,20,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PRZO_ENTREGA","ZKA","PRZO_ENTREGA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ACOM_CLIENTE","ZKA","ACOM_CLIENTE",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"QUALI_PRODUTO","ZKA","QUALI_PRODUTO",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TROCA","ZKA","TROCA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CUSTO_BENEFICIO","ZKA","CUSTO_BENEFICIO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"GERAL","ZKA","GERAL",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"OBS","ZKA","OBS",,10,,,,,,,,,,,,.F.)



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
 
BeginSql alias "KHPOSR001" 
	%noParser%


SELECT 
ZKA_CHAMAD AS CHAMADO,
ZKA_CODCLI AS COD_CLIENTE,
SU5.U5_CONTAT AS NOME,
SUC.UC_XFILIAL AS FILIAL,
CASE
WHEN ZKA_ATELOJ = '1' THEN 'Satisfeito' WHEN ZKA_ATELOJ = '2' THEN 'Regular' WHEN ZKA_ATELOJ = '3' THEN 'Insatisfeito' WHEN ZKA_ATELOJ = '4' THEN 'ND'
END ATEND_LOJA, 
CASE
WHEN ZKA_ATENGE = '1' THEN 'Satisfeito' WHEN ZKA_ATENGE = '2' THEN 'Regular' WHEN ZKA_ATENGE = '3' THEN 'Insatisfeito' WHEN ZKA_ATENGE = '4' THEN 'ND'
END ATEND_GERENTE, 
CASE
WHEN ZKA_ATENVE = '1' THEN 'Satisfeito' WHEN ZKA_ATENVE = '2' THEN 'Regular' WHEN ZKA_ATENVE = '3' THEN 'Insatisfeito' WHEN ZKA_ATENVE = '4' THEN 'ND'
END ATEND_VENDEDOR, 
CASE
WHEN ZKA_OPOCOM = '1' THEN 'Satisfeito' WHEN ZKA_OPOCOM = '2' THEN 'Regular' WHEN ZKA_OPOCOM = '3' THEN 'Insatisfeito' WHEN ZKA_OPOCOM = '4' THEN 'ND'
END OPR_COMPRA, 
CASE
WHEN ZKA_APROCR = '1' THEN 'Satisfeito' WHEN ZKA_APROCR = '2' THEN 'Regular' WHEN ZKA_APROCR = '3' THEN 'Insatisfeito' WHEN ZKA_APROCR = '4' THEN 'ND'
END APRO_CREDITO, 
CASE
WHEN ZKA_ATESAC = '1' THEN 'Satisfeito' WHEN ZKA_ATESAC = '2' THEN 'Regular' WHEN ZKA_ATESAC = '3' THEN 'Insatisfeito' WHEN ZKA_ATESAC = '4' THEN 'ND'
END ATEN_SAC, 
CASE
WHEN ZKA_AGEENT = '1' THEN 'Satisfeito' WHEN ZKA_AGEENT = '2' THEN 'Regular' WHEN ZKA_AGEENT = '3' THEN 'Insatisfeito' WHEN ZKA_AGEENT = '4' THEN 'ND'
END AGEND_ENREGA, 
CASE
WHEN ZKA_AVAENT = '1' THEN 'Satisfeito' WHEN ZKA_AVAENT = '2' THEN 'Regular' WHEN ZKA_AVAENT = '3' THEN 'Insatisfeito' WHEN ZKA_AVAENT = '4' THEN 'ND'
END AVAR_ENTREGA, 
CASE
WHEN ZKA_PRZENT = '1' THEN 'Satisfeito' WHEN ZKA_PRZENT = '2' THEN 'Regular' WHEN ZKA_PRZENT = '3' THEN 'Insatisfeito' WHEN ZKA_PRZENT = '4' THEN 'ND'
END PRZO_ENTREGA, 
CASE
WHEN ZKA_ACOCLI = '1' THEN 'Satisfeito' WHEN ZKA_ACOCLI = '2' THEN 'Regular' WHEN ZKA_ACOCLI = '3' THEN 'Insatisfeito' WHEN ZKA_ACOCLI = '4' THEN 'ND'
END ACOM_CLIENTE, 
CASE
WHEN ZKA_QUAPRO = '1' THEN 'Satisfeito' WHEN ZKA_QUAPRO = '2' THEN 'Regular' WHEN ZKA_QUAPRO = '3' THEN 'Insatisfeito' WHEN ZKA_QUAPRO = '4' THEN 'ND'
END QUALI_PRODUTO, 
CASE
WHEN ZKA_TROCA = '1' THEN 'Satisfeito' WHEN ZKA_TROCA = '2' THEN 'Regular' WHEN ZKA_TROCA = '3' THEN 'Insatisfeito' WHEN ZKA_TROCA = '4' THEN 'ND'
END TROCA, 
CASE
WHEN ZKA_CUSBEN = '1' THEN 'Satisfeito' WHEN ZKA_CUSBEN = '2' THEN 'Regular' WHEN ZKA_CUSBEN = '3' THEN 'Insatisfeito' WHEN ZKA_CUSBEN = '4' THEN 'ND'
END CUSTO_BENEFICIO, 
CASE
WHEN ZKA_GERAL = '1' THEN 'Satisfeito' WHEN ZKA_GERAL = '2' THEN 'Regular' WHEN ZKA_GERAL = '3' THEN 'Insatisfeito' WHEN ZKA_GERAL = '4' THEN 'ND'
END GERAL,
ISNULL(CAST(CAST(ZKA_OBSERV AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS
FROM ZKA010(NOLOCK) ZKA
INNER JOIN SU5010 (NOLOCK)SU5
ON SU5.U5_CODCONT = ZKA.ZKA_CODCLI
INNER JOIN SUC010(NOLOCK) SUC
ON SUC.UC_CODIGO = ZKA.ZKA_CHAMAD


EndSql

oSection:EndQuery()
MemoWrite('\Querys\KHPOSR001.sql',oSection:GetQuery())
  
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


	
