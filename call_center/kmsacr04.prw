#Include "TopConn.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMSACR04  ºAutor  ³Murilo Zoratti        º Data ³  19/12/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Notas Saida                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMSACR04()

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
Local _cPerg := "KMSACR04" 
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta e carrega perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))
fAjustSX1(_cPerg)

Pergunte(_cPerg,.T.)
 	 	
oReport:= TReport():New("KMSACR04","Relatório Chamados",_cPerg,{|oReport|PrintReport(oReport)},"Relatório Chamados")
oReport:SetTotalInLine(.f.)
oReport:lParamPage := .f.

oSection := TRSection():New(oReport,"Relatório Chamados",{"KMSACR04"})        

TRCell():New(oSection,"UD_MSFIL","KMSACR04","Filial",,6,,,,,,,,,,,,.F.)                  	//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Filial",1)                      
TRCell():New(oSection,"UC_01FIL","KMSACR04","Loja",,12,,,,,,,,,,,,.F.)						//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Loja",1)
TRCell():New(oSection,"UD_CODIGO","KMSACR04","Número Chamado",,6,,,,,,,,,,,,.F.)         	//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Número Chamado",1)         	                      
TRCell():New(oSection,"UC_DATA","KMSACR04","Dt.Abertura",,12,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.Abertura",1)
TRCell():New(oSection,"UC_OPERADO","KMSACR04","Cod.Operador",,6,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Operador",1)
TRCell():New(oSection,"U7_NREDUZ","KMSACR04","Operador",,25,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Operador",1)
TRCell():New(oSection,"UC_CHAVE","KMSACR04","Cod.Cliente",,6,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Cliente",1)
TRCell():New(oSection,"A1_NOME","KMSACR04","Cliente",,25,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cliente",1)
TRCell():New(oSection,"UD_ASSUNTO","KMSACR04","Cod.Assunto",,20,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Assunto",1)
TRCell():New(oSection,"X5_DESCRI","KMSACR04","Assunto",,30,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Assunto",1) 
TRCell():New(oSection,"UD_OCORREN","KMSACR04","Cod.Ocorrência",,6,,,,,,,,,,,,.F.)			//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Ocorrência",1)
TRCell():New(oSection,"U9_DESC","KMSACR04","Ocorrência",,35,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Ocorrência",1)  
TRCell():New(oSection,"UD_OPERADO","KMSACR04","Cod.Responsável",,8,,,,,,,,,,,,.F.)			//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Responsável",1)
TRCell():New(oSection,"UD_OPERADO","KMSACR04","Responsável",,20,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Responsável",1)
TRCell():New(oSection,"UD_DATA","KMSACR04","Dt.Ação",,12,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Dt.Ação",1) 
TRCell():New(oSection,"UC_STATUS","KMSACR04","Status Chamado",,10,,,,,,,,,,,,.F.)			//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status Chamado",1)
TRCell():New(oSection,"UD_STATUS","KMSACR04","Status Ação",,10,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Status Ação",1)
TRCell():New(oSection,"UD_XUSER","KMSACR04","Log.Usuário",,20,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Log.Usuário",1)
TRCell():New(oSection,"UD_PRODUTO","KMSACR04","Produto",,20,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Produto",1)
TRCell():New(oSection,"UD_ITEM","KMSACR04","Item",,6,,,,,,,,,,,,.F.)						//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Item",1)
TRCell():New(oSection,"UD_XCODNET","KMSACR04","Cod.Produto NETGERA",,6,,,,,,,,,,,,.F.)		//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Produto NETGERA",1)
TRCell():New(oSection,"UD_SOLUCAO","KMSACR04","Cod.Ação",,6,,,,,,,,,,,,.F.)					//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Cod.Ação",1)
TRCell():New(oSection,"UQ_DESC","KMSACR04","Ação",,20,,,,,,,,,,,,.F.)						//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Ação",1)
TRCell():New(oSection,"UC_01PED","KMSACR04","Pedido NETGERA",,6,,,,,,,,,,,,.F.)				//oFWMsExcel:AddColumn("SAC","Resumo Chamados do SAC","Pedido NETGERA",

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
 
		/*SUBSTRING (E2_EMISSAO,7,2) +'/'+ SUBSTRING(E2_EMISSAO,5,2)+'/'+ SUBSTRING(E2_EMISSAO,1,4)  EMISSAO,
		SUBSTRING (E2_EMIS1,7,2) +'/'+ SUBSTRING(E2_EMIS1,5,2)+'/'+ SUBSTRING(E2_EMIS1,1,4) EMISSAO1,
		SUBSTRING (E2_VENCTO,7,2) +'/'+ SUBSTRING(E2_VENCTO,5,2)+'/'+ SUBSTRING(E2_VENCTO,1,4)  VENC,
		SUSTRING (E2_VENCREA,7,2) +'/'+ SUBSTRING(E2_VENCREA,5,2)+'/'+ SUBSTRING(E2_VENCREA,1,4) VENCREA,*/ 
 
BeginSql alias "KMSACR04" 
	Column UD_DATA As Date
	Column UC_DATA As Date
	%noParser%

SELECT 
UD_MSFIL, 
UC_01FIL,
UD_CODIGO
UC_DATA,
UC_OPERADO,
U7_NREDUZ,
UC_CHAVE,
A1_NOME,
UD_ASSUNTO,
X5_DESCRI,
UD_OCORREN,
U9_DESC,
UD_OPERADO,
UD_XUSER,
UD_DATA,
CASE WHEN UC_STATUS = 1 THEN 'Planejada' WHEN UC_STATUS = 2 THEN 'Pendente'  WHEN UC_STATUS = 3 THEN 'Encerrada' END AS UC_STATUS,
CASE WHEN UD_STATUS = 1 THEN 'Pendente' WHEN UD_STATUS = 2 THEN 'Encerrada' END AS UD_STATUS,
UC_TIPO
UC_CODIGO,
UD_PRODUTO,
UD_ITEM,
UD_XCODNET,
UD_SOLUCAO,
UD_ENVWKF,
UD_WFIDENV,
UD_WFIDRET,
UD_OBSWKF,
UC_01PED,
UC_CODCANC,
UQ_DESC
FROM SUD010 SUD 
INNER JOIN SUC010 SUC ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO 
INNER JOIN SU7010 SU7 ON U7_COD = UC_OPERADO 
INNER JOIN SA1010 SA1 ON A1_COD + A1_LOJA = UC_CHAVE 
INNER JOIN SX5010 SX5 ON X5_CHAVE = UD_ASSUNTO 
INNER JOIN SU9010 SU9 ON U9_CODIGO = UD_OCORREN 
LEFT JOIN SUQ010 SUQ ON UQ_SOLUCAO = UD_SOLUCAO
WHERE  
SUD.%notDel% 
AND SUC.%notDel% 
AND SU7.%notDel% 
AND SA1.%notDel% 
AND SX5.%notDel% 
AND SU9.%notDel% 
AND X5_TABELA = 'T1' 
AND UD_OPERADO BETWEEN  %exp:MV_PAR01% AND %exp:MV_PAR02%
AND UD_DATA BETWEEN  %exp:MV_PAR03% AND %exp:MV_PAR04%
GROUP BY UD_MSFIL, UC_01FIL, UD_CODIGO, UC_DATA, UC_OPERADO, U7_NREDUZ, UC_CHAVE, A1_NOME, UD_ASSUNTO, 
X5_DESCRI, UD_OCORREN, U9_DESC, UD_OPERADO, UD_XUSER, UD_DATA, UC_STATUS, UD_STATUS, UC_TIPO, UC_CODIGO, 
UD_PRODUTO, UD_ITEM, UD_XCODNET, UD_SOLUCAO, UD_ENVWKF, UD_WFIDENV, UD_WFIDRET, UD_OBSWKF, UC_01PED,UC_CODCANC,UQ_DESC
ORDER BY  UD_OPERADO, UD_ASSUNTO, UC_DATA

EndSql

oSection:EndQuery()
MemoWrite('\Querys\KMSACR04.sql',oSection:GetQuery())

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

Aadd(aRegs,{_cPerg,"01","Operador de...","MV_CH1" ,"C",6,0,"G","MV_PAR03","SU7","","","","",""})
Aadd(aRegs,{_cPerg,"02","Operador Até..","MV_CH2" ,"C",6,0,"G","MV_PAR04","SU7","","","","",""})
Aadd(aRegs,{_cPerg,"03","Data Abertura de...","MV_CH3" ,"D",8,0,"G","MV_PAR03","","","","","",""})
Aadd(aRegs,{_cPerg,"04","Data Abertura Até..","MV_CH4" ,"D",8,0,"G","MV_PAR04","","","","","",""})


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
