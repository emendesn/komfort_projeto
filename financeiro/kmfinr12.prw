#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

#DEFINE CRLF CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMFINR12  บ Autor ณ AP6 IDE           บ Data ณ  05/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rel. Resumo por Tipo de Pagamento/Recebimento              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

// 02/07/2019 - Everton Santos
// Atualizado relatorio para trazer o status de entrega dos pedidos e efetuado ajuste nas queries para filtrar os pedidos com o campo C5_PEDPEND <> 2.

User Function KMFINR12()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg 	:= PadR("KMFINR12", Len(SX1->X1_GRUPO))
Local aPergunta	:= {}
Private oReport	:= Nil
Private oSecCab	:= Nil
Private oSecPed	:= Nil
Private oSecIte	:= Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao e apresentacao das perguntas      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aPergunta,{cPerg,"01","Loja de  ?" 				,"MV_CH1" ,"C",04,00,"G","MV_PAR01","SM0"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"02","Loja at้ ?" 				,"MV_CH2" ,"C",04,00,"G","MV_PAR02","SM0"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"03","Emissใo de ?"			    ,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"04","Emissใo at้?" 			    ,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"05","Venc. de ?"			    	,"MV_CH5" ,"D",08,00,"G","MV_PAR05",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"06","Venc. at้?" 			    ,"MV_CH6" ,"D",08,00,"G","MV_PAR06",""         ,"","","","",""})
Aadd(aPergunta,{cPerg,"07","Cliente de?" 				,"MV_CH7" ,"C",06,00,"G","MV_PAR07","SA1"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"08","cliente at้?" 				,"MV_CH9" ,"C",06,00,"G","MV_PAR09","SA1"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"09","Loja de ?"	 				,"MV_CH8" ,"C",02,00,"G","MV_PAR08",""	 	   ,"","","","",""})
Aadd(aPergunta,{cPerg,"10","Loja at้ ?" 				,"MV_CHA" ,"C",02,00,"G","MV_PAR10",""	       ,"","","","",""})
Aadd(aPergunta,{cPerg,"11","Pedido de?" 				,"MV_CHB" ,"C",06,00,"G","MV_PAR11","SC5"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"12","Pedido at้?" 				,"MV_CHC" ,"C",06,00,"G","MV_PAR12","SC5"      ,"","","","",""})
Aadd(aPergunta,{cPerg,"13","Pendencia Financeira?" 		,"MV_CHD" ,"C",01,00,"C","MV_PAR13","SIM","NAO","","","",""})
VldSX1(aPergunta)

If !Pergunte(cPerg,.T.)
	Return(Nil)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicoes/preparacao para impressao      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ReportDef()

oReport:PrintDialog()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Vinํcius Moreira   บ Data ณ 12/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Defini็ใo da estrutura do relat๓rio.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

Local cPerg 	:= PadR("KMFINR12", Len(SX1->X1_GRUPO))
Local cTexto	:= "Vencimento entre " + DtoC(MV_PAR05) + " e " + DtoC(MV_PAR06) + "."

oReport := TReport():New(cPerg,"Rel. Pedidos com Pend๊ncia Financeira",cPerg,{|oReport| PrintReport(oReport)},"Impressใo dos Tํtulos.")
//oReport:SetLandscape()

oSecCab := TRSection():New( oReport , "Perํodo")
TRCell():New(oSecCab,cTexto,,"",,Len(cTexto),,{|| cTexto})

oSecPed := TRSection():New( oReport   , "Pedido")
TRCell():New( oSecPed, "C5_NUM" 	  , "SC5")
TRCell():New( oSecPed, "A1_NOME" 	  , "SC5")
TRCell():New( oSecPed, "C5_EMISSAO"	  , "SC5")
TRCell():New( oSecPed, "VLRTOTAL"	  ,,"Vlr Total R$",PesqPict("SE1","E1_VALOR"))	//TRCell():New( oSecPed,"VLRTOTAL"	  ,    "","Vlr Total R$","@!",15,.F.,{||aTab[1]})
TRCell():New( oSecPed, "VLRMENOR"	  ,,"Vlr Mํnimo R$",PesqPict("SE1","E1_VALOR"))	//TRCell():New( oSecPed, "Vlr Mํnimo R$", "SC5",,PesqPict("SE1","E1_VALOR"))
TRCell():New( oSecPed, "PERPEND"	  ,,"%Pend๊ncia",PesqPict("SE1","E1_PORCJUR"))	//TRCell():New( oSecPed, "%Pend๊ncia"   , "SC5")
TRCell():New( oSecPed, "VLRPAGO"	  ,,"Vlr Pago R$",PesqPict("SE1","E1_VALOR"))	//TRCell():New( oSecPed, "Vlr Pago R$"  , "SC5",,PesqPict("SE1","E1_VALOR"))
TRCell():New( oSecPed, "PORCENTAGEM"  ,,"%Atingido",PesqPict("SE1","E1_PORCJUR"))	//TRCell():New( oSecPed, "%Atingido"    , "SC5")
TRCell():New( oSecPed, "STATUS"    	  ,,"Status","@!",30)
TRCell():New( oSecPed, "DAH_XDESCR"   ,"DAH","Entrega do Pedido","@!",50)

oSecIte := TRSection():New( oReport , "Titulos")
TRCell():New( oSecIte, "E1_PREFIXO" , "SE1")
TRCell():New( oSecIte, "E1_NUM" 	, "SE1")
TRCell():New( oSecIte, "E1_PARCELA"	, "SE1")
TRCell():New( oSecIte, "E1_TIPO"	, "SE1")
TRCell():New( oSecIte, "E1_VENCREA"	, "SE1")
TRCell():New( oSecIte, "E1_VALOR"	, "SE1")
TRCell():New( oSecIte, "E1_SALDO"	, "SE1")
TRCell():New( oSecIte, "STATUS2"	,,"Status","@!",30)

oBreak := TRBreak():New(oSecIte,oSecPed:Cell("C5_NUM"),,.F.)

TRFunction():New(oSecIte:Cell("E1_VALOR"),"","SUM",,,,,.F.,.T.)	
/*     
//Aqui, farei uma quebra  por se็ใo
oSecPed:SetPageBreak(.T.)
oSecPed:SetTotalText(" ")
*/
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR01   บAutor  ณ Vinํcius Moreira   บ Data ณ 12/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)

Local cQry		:= ""
Local cPerg		:= PadR("KMFINR12", Len(SX1->X1_GRUPO))
Local cPedido	:= ""

Pergunte(cPerg,.F.)

//cQry := " SELECT * FROM " + RETSQLNAME("SC5") + " (NOLOCK) C5"	+ CRLF
cQry := " SELECT C5_MSFIL, C5_NUM, C5_CLIENT, C5_LOJACLI, "	+ CRLF
cQry += " A1_NOME, C5_EMISSAO, C5_NOTA,DAH_XDESCR "			+ CRLF 
cQry += " FROM " + RETSQLNAME("SC5") + " (NOLOCK) C5"		+ CRLF

cQry += " LEFT JOIN " + RETSQLNAME("DAI") + " (NOLOCK) DAI"		+ CRLF
cQry += " ON DAI_CLIENT = C5_CLIENTE AND C5_NUM = DAI_PEDIDO"	+ CRLF
cQry += " AND DAI.D_E_L_E_T_ = ' '" 							+ CRLF
cQry += " LEFT JOIN " + RETSQLNAME("DAH") + " (NOLOCK) DAH"		+ CRLF
cQry += " ON DAH_CODCAR = DAI_COD AND DAI_CLIENT = DAH_CODCLI"	+ CRLF
cQry += " AND DAH.D_E_L_E_T_ = ' '" 							+ CRLF

cQry += " LEFT JOIN " + RETSQLNAME("SE1") + " (NOLOCK) E1"		+ CRLF
cQry += " ON E1_FILIAL = '" + XFILIAL("SE1") + "'"				+ CRLF
cQry += " AND E1_PEDIDO = C5_NUM"								+ CRLF
cQry += " AND E1_CLIENTE = C5_CLIENT" 							+ CRLF
cQry += " AND E1_LOJA = C5_LOJACLI" 							+ CRLF
cQry += " AND E1.D_E_L_E_T_ = ' '" 								+ CRLF

cQry += " LEFT JOIN  " + RETSQLNAME("SA1") + " (NOLOCK) A1" 	+ CRLF
cQry += " ON A1_FILIAL = '" + XFILIAL("SA1") + "'" 				+ CRLF
cQry += " AND A1_COD = C5_CLIENT"  								+ CRLF
cQry += " AND A1_LOJA = C5_LOJACLI			" 					+ CRLF
cQry += " AND A1.D_E_L_E_T_ = ' '			" 					+ CRLF

cQry += " WHERE C5_FILIAL = '" + XFILIAL("SC5") + "'"			+ CRLF
cQry += " AND C5_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 				+ CRLF
cQry += " AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'"	+ CRLF
cQry += " AND E1_VENCREA BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "'"	+ CRLF
cQry += " AND C5_CLIENT BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR09 + "'"				+ CRLF
cQry += " AND C5_LOJACLI BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR10 + "'"				+ CRLF
cQry += " AND C5_NUM BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "'"					+ CRLF

If MV_PAR13 = 1 
	cQry += " AND C5_PEDPEND = '2' " 													+ CRLF
EndIF
If MV_PAR13 = 2
	cQry += " AND C5_PEDPEND <> '2' " 													+ CRLF
EndIf	
cQry += " AND C5.D_E_L_E_T_ = ' '" 														+ CRLF
cQry += " GROUP BY C5_MSFIL, C5_NUM, C5_CLIENT, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_NOTA,DAH_XDESCR"+ CRLF

cQry := ChangeQuery(cQry)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQry New Alias "QRY"

dbSelectArea("QRY")
QRY->(dbGoTop())

oReport:SetMeter(QRY->(LastRec()))

//inicializo a PRIMEIRA se็ใo
oSecCab:Init()	
oSecCab:Printline()

While QRY->(!Eof())
	
	cPedido := QRY->C5_NUM

	If oReport:Cancel()
		Exit
	EndIf

	//inicializo a SEGUNDA se็ใo
	oSecPed:init()
	  
	oReport:IncMeter()		
	
	cQry := " SELECT "																+ CRLF
	cQry += " UA_NUMSC5,UA_VLRLIQ,UA_XPERLIB," 										+ CRLF
	cQry += " (UA_VLRLIQ/100) * UA_XPERLIB AS VALOR_MINIMO," 						+ CRLF
	cQry += " (SELECT"																+ CRLF
	cQry += " CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR"	+ CRLF
	cQry += " FROM " + RETSQLNAME("SE1") + " (NOLOCK)"								+ CRLF
	cQry += " WHERE E1_MSFIL = '"+ QRY->C5_MSFIL +"'"								+ CRLF
	cQry += " AND E1_PEDIDO = '" + QRY->C5_NUM + "'"								+ CRLF
	cQry += " AND E1_CLIENTE = '" + QRY->C5_CLIENT + "'"							+ CRLF
	cQry += " AND E1_LOJA = '" + QRY->C5_LOJACLI + "'"								+ CRLF
	cQry += " AND E1_TIPO NOT IN ('BOL','CHK','RA') "								+ CRLF
	cQry += " AND D_E_L_E_T_ = ' ') "												+ CRLF
	cQry += " + "																	+ CRLF
	cQry += " (SELECT" 																+ CRLF
	cQry += " CASE WHEN SUM(E1_VALOR) IS NULL THEN 0 ELSE SUM(E1_VALOR) END VALOR"	+ CRLF
	cQry += " FROM " + RETSQLNAME("SE1") + " (NOLOCK)"								+ CRLF
	cQry += " WHERE E1_MSFIL = '"+ QRY->C5_MSFIL +"'"								+ CRLF
	cQry += " AND E1_PEDIDO = '" + QRY->C5_NUM + "'"								+ CRLF
	cQry += " AND E1_CLIENTE = '" + QRY->C5_CLIENT + "'"							+ CRLF
	cQry += " AND E1_LOJA = '" + QRY->C5_LOJACLI + "'"								+ CRLF
	cQry += " AND E1_TIPO IN ('BOL','CHK') AND E1_STATUS = 'B'"						+ CRLF
	cQry += " AND D_E_L_E_T_ = ' ') AS RECEBIDO"									+ CRLF
	cQry += " FROM " + RETSQLNAME("SUA") + " (NOLOCK)"								+ CRLF
	cQry += " WHERE UA_FILIAL = '"+ QRY->C5_MSFIL +"'"								+ CRLF
	cQry += " AND UA_NUMSC5 = '" + QRY->C5_NUM + "'"								+ CRLF
	cQry += " AND D_E_L_E_T_ = ' '"													+ CRLF
		
	If Select("QR2") > 0
		Dbselectarea("QR2")
		QR2->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QR2"
	
	dbSelectArea("QR2")
	QR2->(dbGoTop())
	
	oSecPed:Cell("C5_NUM"):SetValue(QRY->C5_NUM)
	oSecPed:Cell("A1_NOME"):SetValue(QRY->A1_NOME)
	oSecPed:Cell("C5_EMISSAO"):SetValue(STOD(QRY->C5_EMISSAO))
	oSecPed:Cell("VLRTOTAL"):SetValue(QR2->UA_VLRLIQ)
	oSecPed:Cell("VLRMENOR"):SetValue(QR2->VALOR_MINIMO)
	oSecPed:Cell("PERPEND"):SetValue(QR2->UA_XPERLIB)
	oSecPed:Cell("VLRPAGO"):SetValue(QR2->RECEBIDO)
	oSecPed:Cell("PORCENTAGEM"):SetValue(NOROUND((QR2->RECEBIDO/QR2->UA_VLRLIQ) * 100,2))
	oSecPed:Cell("STATUS"):SetValue(IIF(EMPTY(QRY->C5_NOTA),"Bloqueado",IIF(QRY->C5_NOTA == Repl("X",Len(QRY->C5_NOTA)),"Cancelado","Faturado")))
	oSecPed:Cell("DAH_XDESCR"):SetValue(QRY->DAH_XDESCR)  
	
	oSecPed:PrintLine()

	cQry := " SELECT * FROM " + RETSQLNAME("SC5") + " (NOLOCK) C5"	+ CRLF
	
	cQry += " LEFT JOIN " + RETSQLNAME("DAI") + " (NOLOCK) DAI"		+ CRLF
	cQry += " ON DAI_CLIENT = C5_CLIENTE AND C5_NUM = DAI_PEDIDO"	+ CRLF
	cQry += " AND DAI.D_E_L_E_T_ = ' '" 							+ CRLF
	cQry += " LEFT JOIN " + RETSQLNAME("DAH") + " (NOLOCK) DAH"		+ CRLF
	cQry += " ON DAH_CODCAR = DAI_COD AND DAI_CLIENT = DAH_CODCLI"	+ CRLF
	cQry += " AND DAH.D_E_L_E_T_ = ' '" 							+ CRLF
	cQry += " LEFT JOIN " + RETSQLNAME("SE1") + " (NOLOCK) E1"		+ CRLF
	cQry += " ON E1_FILIAL = '" + XFILIAL("SE1") + "'"				+ CRLF
	cQry += " AND E1_PEDIDO = C5_NUM"								+ CRLF
	cQry += " AND E1_CLIENTE = C5_CLIENT" 							+ CRLF
	cQry += " AND E1_LOJA = C5_LOJACLI" 							+ CRLF
	cQry += " AND E1.D_E_L_E_T_ = ' '" 								+ CRLF
	cQry += " LEFT JOIN  " + RETSQLNAME("SA1") + " (NOLOCK) A1" 	+ CRLF
	cQry += " ON A1_FILIAL = '" + XFILIAL("SA1") + "'" 				+ CRLF
	cQry += " AND A1_COD = C5_CLIENT"  								+ CRLF
	cQry += " AND A1_LOJA = C5_LOJACLI			" 					+ CRLF
	cQry += " AND A1.D_E_L_E_T_ = ' '			" 					+ CRLF
	cQry += " WHERE C5_FILIAL = '" + XFILIAL("SC5") + "'"			+ CRLF
	cQry += " AND C5_MSFIL BETWEEN '" + QRY->C5_MSFIL + "' AND '" + QRY->C5_MSFIL + "' "	+ CRLF
	cQry += " AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "'"	+ CRLF
	cQry += " AND E1_VENCREA BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "'"	+ CRLF
	cQry += " AND C5_CLIENT BETWEEN '" + QRY->C5_CLIENT + "' AND '" + QRY->C5_CLIENT + "'"	+ CRLF
	cQry += " AND C5_LOJACLI BETWEEN '" + QRY->C5_LOJACLI + "' AND '" + QRY->C5_LOJACLI +"'"+ CRLF
	cQry += " AND C5_NUM BETWEEN '" + QRY->C5_NUM + "' AND '" + QRY->C5_NUM + "'"			+ CRLF
	If MV_PAR13 = 1 
		cQry += " AND C5_PEDPEND = '2' " 													+ CRLF
	EndIF
	If MV_PAR13 = 2
		cQry += " AND C5_PEDPEND <> '2' " 													+ CRLF
	EndIf	
	cQry += " AND C5.D_E_L_E_T_ = ' '" 														+ CRLF
	cQry += " ORDER BY C5_MSFIL, C5_NUM" + CRLF
	
	cQry := ChangeQuery(cQry)

	If Select("QR3") > 0
		Dbselectarea("QR3")
		QR3->(DbClosearea())
	EndIf
	
	TcQuery cQry New Alias "QR3"
	
	dbSelectArea("QR3")
	QR3->(dbGoTop())

	//inicializo a TERCEIRA se็ใo
	oSecIte:init()
	
	While QR3->(!Eof())
	
		oSecIte:Cell("E1_PREFIXO"):SetValue(QR3->E1_PREFIXO)
		oSecIte:Cell("E1_NUM"):SetValue(QR3->E1_NUM)
		oSecIte:Cell("E1_PARCELA"):SetValue(QR3->E1_PARCELA)
		oSecIte:Cell("E1_TIPO"):SetValue(QR3->E1_TIPO)
		oSecIte:Cell("E1_VENCREA"):SetValue(STOD(QR3->E1_VENCREA))
		oSecIte:Cell("E1_VALOR"):SetValue(QR3->E1_VALOR)
		oSecIte:Cell("E1_SALDO"):SetValue(QR3->E1_SALDO)
		oSecIte:Cell("STATUS2"):SetValue(IIF(QR3->E1_STATUS=="B","Baixado",IIF(QR3->E1_STATUS<>"B" .AND. (STOD(QR3->E1_VENCREA)) <= dDatabase,"Vencido","Em Aberto")))
		oSecIte:PrintLine()
			
		QR3->(dbSkip()) 
	EndDo
	//finalizo a TERCEIRA se็ใo
	oSecIte:Finish()
	
	//finalizo a SEGUNDA se็ใo
	oSecPed:Finish()
	
	//imprimo uma linha para separar um PV de outro
	oReport:ThinLine()


	QRY->(dbSkip())

EndDo

//imprimo uma linha para separar uma NCM de outra
//oReport:ThinLine()

//finalizo a PRIMEIRA se็ใo
oSecCab:Finish() 	

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  05/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DE PERGUNTAS DO SX1                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VldSX1(aRegs)

Local _i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

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
Next i

RestArea(aAreaBKP)

Return(Nil)