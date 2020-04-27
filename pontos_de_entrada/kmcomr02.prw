#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMCOMR02  ºAutor  ³Caio Garcia           º Data ³  02/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de ORCxPVxSCxPC                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Regatta                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMCOMR02()

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
Local _cPerg := "KMCOMR02" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMCOMR02","Relatorio de Vendas x Solicitações",_cPerg,{|oReport|PrintReport(oReport)},"Relatorio de Vendas x Solicitações")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatorio de Vendas x Solicitações",{"SC5","SM0","SC6","SB1","SC1","SC7"})        
                  	                      
TRCell():New(oSection,"FILIAL","SC5","FILIAL",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DESC_FIL","SC5","DESC_FIL",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ORCAMENTO","SC6","ORCAMENTO",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PEDIDO_VENDA","SC5","PEDIDO_VENDA",,03,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FORNE","SUB","FORNE",,03,,,,,,,,,,,,.F.)
TRCell():New(oSection,"COD_PROTHEUS","SC6","COD_PROTHEUS",,08,,,,,,,,,,,,.F.)
TRCell():New(oSection,"COD_NETGERA","SB1","COD_NETGERA",,15,,,,,,,,,,,,.F.)
TRCell():New(oSection,"DESCRICAO","SB1","DESCRICAO",,02,,,,,,,,,,,,.F.)
TRCell():New(oSection,"QUANTIDADE","SC6","QUANTIDADE",,10,,,,,,,,,,,,.F.)
TRCell():New(oSection,"NOTA","SC6","NOTA",,09,,,,,,,,,,,,.F.)
TRCell():New(oSection,"FORALINHA","SB1","FORALINHA",,03,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ENCOMENDA","SB1","ENCOMENDA",,12,,,,,,,,,,,,.F.)
TRCell():New(oSection,"EMISSAO","SC5","EMISSAO",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"SOCILITACAO","SC1","SOCILITACAO",,08,,,,,,,,,,,,.F.)
TRCell():New(oSection,"PEDIDO_COMPRAS","SC7","PEDIDO_COMPRAS",,06,,,,,,,,,,,,.F.)
TRCell():New(oSection,"ENTREGA","SC7","ENTREGA",,06,,,,,,,,,,,,.F.)


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
 
BeginSql alias "KMCOMR02" 
	%noParser%

/*
SELECT C5_MSFIL FILIAL, 
       FILIAL DESC_FIL, 
       C6_NUM ORCAMENTO, 
          C5_NUM PEDIDO_VENDA, 
          SUBSTRING(C6_PRODUTO,1,3) FORNE,
          C6_PRODUTO COD_PROTHEUS, 
          B1_CODANT COD_NETGERA, 
          B1_DESC DESCRICAO,
          C6_QTDVEN QUANTIDADE,
          C6_NOTA + ' ' + C6_SERIE NOTAFISCAL, 
          CASE WHEN B1_01FORAL = 'F' THEN 'FL' ELSE '' END FORALINHA,
          CASE WHEN B1_XENCOME = '2' AND B1_01FORAL = 'F' THEN 'FL ENCOMENDA' WHEN B1_XENCOME = '2' AND B1_01FORAL <> 'F' THEN 'ENCOMENDA' ELSE 'GIRO' END  ENCOMENDA, 
          SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) EMISSAO,
          CASE WHEN C1_NUM IS NULL THEN '' ELSE C1_NUM END SOCILITACAO,
          CASE WHEN C7_NUM IS NULL THEN '' ELSE C7_NUM END PEDIDO_COMPRAS
FROM SC6010 SC6 (NOLOCK) 
INNER JOIN SC5010 SC5 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM
INNER JOIN SB1010 SB1 (NOLOCK) ON B1_COD = C6_PRODUTO
INNER JOIN SM0010 SM0 (NOLOCK) ON C5_MSFIL = FILFULL 
LEFT JOIN SC1010 SC1 (NOLOCK) ON C1_PEDRES = C5_NUM AND SC1.D_E_L_E_T_ <> '*' AND C1_PRODUTO = C6_PRODUTO
LEFT JOIN SC7010 SC7 (NOLOCK) ON C7_01NUMPV = C5_NUM AND C7_PRODUTO = C6_PRODUTO AND SC7.D_E_L_E_T_ <> '*'
WHERE SC6.D_E_L_E_T_ <> '*'
AND SC5.D_E_L_E_T_ <> '*'
AND SB1.D_E_L_E_T_ <> '*'
AND C5_NUM <> ''
AND C6_BLQ <> 'R'
AND C5_EMISSAO BETWEEN '20180101' AND '20181231'
AND C5_FILIAL BETWEEN '' AND 'ZZZZ'
AND C6_PRODUTO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
ORDER BY C5_EMISSAO 

*/	

//#WRP20180813.BO	
       
SELECT C5_MSFIL FILIAL, 
       FILIAL DESC_FIL, 
       C6_NUM ORCAMENTO,
       C5_NUM PEDIDO_VENDA, 
       SUBSTRING(C6_PRODUTO,1,3) FORNE,
       C6_PRODUTO COD_PROTHEUS, 
       B1_CODANT COD_NETGERA, 
       B1_DESC DESCRICAO,
       C6_QTDVEN QUANTIDADE,
       C6_NOTA + ' ' + C6_SERIE NOTAFISCAL,
	   CASE WHEN B1_01FORAL = 'F' THEN 'FL' ELSE '' END FORALINHA,
	   CASE WHEN B1_XENCOME = '2' AND B1_01FORAL = 'F' THEN 'FL ENCOMENDA' WHEN B1_XENCOME = '2' AND B1_01FORAL <> 'F' THEN 'ENCOMENDA' ELSE 'GIRO' END  ENCOMENDA, 
	   SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) EMISSAO,
	   CASE WHEN C1_NUM IS NULL THEN '' ELSE C1_NUM END SOCILITACAO,
	   CASE WHEN C7_NUM IS NULL THEN '' ELSE C7_NUM END PEDIDO_COMPRAS,
	   SUBSTRING(C7_DATPRF,7,2)+'/'+SUBSTRING(C7_DATPRF,5,2)+'/'+SUBSTRING(C7_DATPRF,1,4) ENTREGA
FROM %table:SC6% SC6 (NOLOCK) 
INNER JOIN %table:SC5% SC5 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM
INNER JOIN %table:SB1% SB1 (NOLOCK) ON B1_COD = C6_PRODUTO
INNER JOIN SM0010 ON C5_MSFIL = FILFULL 
LEFT JOIN %table:SC1% SC1 (NOLOCK) ON C1_PEDRES = C5_NUM AND SC1.%notDel% AND C1_PRODUTO = C6_PRODUTO
LEFT JOIN %table:SC7% SC7 (NOLOCK) ON C7_01NUMPV = C5_NUM AND C7_PRODUTO = C6_PRODUTO AND SC7.%notDel%
WHERE SC6.%notDel%
AND SC5.%notDel%
AND SB1.%notDel%
AND C5_NUM <> ''
AND C5_CLIENT <> '000001'
AND C5_01TPOP <> '2'
AND C6_BLQ <> 'R'
AND C5_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
AND C5_FILIAL BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
AND C6_PRODUTO BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
ORDER BY C5_EMISSAO 
     
EndSql

//#WRP20180813.BE

oSection:EndQuery()
MemoWrite('\Querys\KMCOMR02.sql',oSection:GetQuery())
  
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
Aadd(aRegs,{_cPerg,"03","Filial De...","MV_CH3" ,"C",4,0,"G","MV_PAR03","SM0","","","","",""})
Aadd(aRegs,{_cPerg,"04","Filial Até..","MV_CH4" ,"C",4,0,"G","MV_PAR04","SM0","","","","",""})
Aadd(aRegs,{_cPerg,"05","Produto De...","MV_CH5","C",15,0,"G","MV_PAR05","SB1","","","","",""})
Aadd(aRegs,{_cPerg,"06","Produto Até..","MV_CH6","C",15,0,"G","MV_PAR06","SB1","","","","",""})

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
