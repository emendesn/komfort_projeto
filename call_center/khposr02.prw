#include 'parmtype.ch'
#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KHPOSR002  ºAutor  ³Wellington Raul       º Data ³  10/01/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Data visita técnica                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function KHPOSR02()

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
Local _cPerg := "KHPOSR002" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KHPOSR002","Relatorio de Follow",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio de Follow")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio de Follow",{"SUD"})        
                  	                      
TRCell():New(oSection,"STATUS_CHAMADO","SUC","STATUS_CHAMADO",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"CHAMADO","SUD","CHAMADO",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME_CLIENTE","SA1","NOME_CLIENTE",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DEPARTAMENTO","SX5","DEPARTAMENTO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"OCORRENCIA","SU9","OCORRENCIA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"USUARIO","SUD","USUARIO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME_OPERADOR","SU7","NOME_OPERADOR",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"TIPO_ERRO","SUC","TIPO_ERRO",,18,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FOLLLOW","SUC","FOLLLOW",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DT_ABERTURA","SC5","DT_ABERTURA",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PEDIDO","SC5","PEDIDO",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOME_VENDEDOR","SA3","NOME_VENDEDOR",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SATISFACAO","SUC","SATISFACAO",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"STATUS_PV","SUC","STATUS_PV",,15,,,,,,,,,,,,.F.)



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
 
BeginSql alias "KHPOSR002" 
	%noParser%

  SELECT DISTINCT 
  UC_STATUS AS STATUS_CHAMADO,
  UD_CODIGO AS CHAMADO,
  A1_NOME AS NOME_CLIENTE,
  X5_DESCRI AS DEPARTAMENTO,
  U9_DESC AS OCORRENCIA,
  UD_XUSER AS USUARIO,
  U7_NOME AS NOME_OPERADOR,
  UC_XTPERRO AS TIPO_ERRO,
  SUBSTRING(UC_XFOLLOW ,7,2)+'/'+SUBSTRING(UC_XFOLLOW,5,2)+'/'+SUBSTRING(UC_XFOLLOW ,1,4) AS FOLLLOW,
  SUBSTRING(C5_EMISSAO ,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO ,1,4) AS DT_ABERTURA,
  C5_NUM AS PEDIDO,
  A3_NOME AS NOME_VENDEDOR,
  CASE
  WHEN UC_XSATISF = '1' THEN 'OTIMO'
  WHEN UC_XSATISF = '2' THEN 'BOM'
  WHEN UC_XSATISF = '3' THEN 'REGULAR'
  WHEN UC_XSATISF = '4' THEN 'RUIM'
  ELSE ''
  END 
  SATISFACAO,
  UC_XSTATUS AS STATUS_PV
  FROM  SUD010 SUD
  INNER JOIN SUC010 SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO 
  INNER JOIN SC5010 SC5 ON SUBSTRING(UC_01PED,5,10) = C5_NUM 
  INNER JOIN SUA010 SUA ON UA_NUM = C5_NUM  
  INNER JOIN SA3010 SA3 ON A3_COD = UA_VEND  
  INNER JOIN SU7010 SU7 ON U7_COD = UC_OPERADO  
  INNER JOIN SA1010 SA1 ON A1_COD + A1_LOJA = UC_CHAVE  
  INNER JOIN SX5010 SX5 ON X5_CHAVE = UD_ASSUNTO  
  INNER JOIN SU9010 SU9 ON U9_CODIGO = UD_OCORREN  
  WHERE UD_FILIAL = '' 
  AND UC_FILIAL = '' 
  AND U7_FILIAL = '    ' 
  AND A1_FILIAL = '    ' 
  AND X5_FILIAL = '01  ' 
  AND U9_FILIAL = '    ' 
  AND UC_STATUS <> '3 ' 
  AND SUD.D_E_L_E_T_ = ' ' 
  AND SUC.D_E_L_E_T_ = ' ' 
  AND SU7.D_E_L_E_T_ = ' ' 
  AND SA1.D_E_L_E_T_ = ' ' 
  AND SX5.D_E_L_E_T_ = ' ' 
  AND SU9.D_E_L_E_T_ = ' ' 
  AND X5_TABELA = 'T1' 
  AND UD_ASSUNTO IN ('000008', '000010') 
  AND UC_XFOLLOW BETWEEN %exp:MV_PAR01% AND  %exp:MV_PAR02%

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KHPOSR002.sql',oSection:GetQuery())
  
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


	
