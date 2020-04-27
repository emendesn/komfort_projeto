#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMFINR01 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  05/01/17   บฑฑ                                           
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE TITULOS A RECEBER                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ                                      
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณCaio Garcia    ณ22/01/18ณMostrar total de parcelas.                    ณฑฑ
ฑฑณ#CMG20180122   ณ        ณ                                              ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION KMFINR01()
                                                                                                                       
Local aSize    := MsAdvSize()
Local oTela, oPnlInfo, oLogo, oFnt

Private aDados    := {} 
Private aFrmTotal := {} 
Private oBrw

FwMsgRun( ,{|| FILDADOS()  }, , "Filtrando dados , por favor aguarde..." )

IF Len(aDados) > 0
	            
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de tํtulo a receber" Of oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MONTA PAINEL COM AS INFORMACOES GERAIS ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPnlInfo:= TPanel():New(000,000, "",oTela, NIL, .T., .F., NIL, NIL,aSize[6],080, .T., .F. )
	oPnlInfo:Align:=CONTROL_ALIGN_TOP            
	
	// TRAZ O LOGO DA KOMFORT HOSUE
	@ 005,005 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oPnlInfo PIXEL NOBORDER
	oLogo:LAUTOSIZE    := .F.
	oLogo:LSTRETCH     := .T.   
	
	// CRIA OS BOTOES DA ROTINA
	@ 055,005 BUTTON  "&Sair" 	SIZE 050,020 PIXEL OF oPnlInfo ACTION ( oTela:End() )
	@ 055,070 BUTTON  "&Excel" 	SIZE 050,020 PIXEL OF oPnlInfo ACTION ( LjMsgRun("Aguarde, Exportando para Excel...",,{|| ProcExcel() }) )  
	
	//EXBIBE AS CONFIGURACOES DO FILTRO
	@ 005,100 Say "Filtros Utilizados" Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlInfo
	@ 020,100 Say "Loja de : " + MV_PAR01 + "   /   Loja at้ : " + MV_PAR02 Size 200,010 Font oFnt Pixel Of oPnlInfo
	@ 035,100 Say "Vendedor de : " + MV_PAR03 + "   /   Vendedor at้ : " + MV_PAR04 Size 200,010 Font oFnt Pixel Of oPnlInfo
	
	@ 020,300 Say "Pedido de : " + MV_PAR05 + "   /   Pedido at้ : " + MV_PAR06 Size 200,010 Font oFnt Pixel Of oPnlInfo
	@ 035,300 Say "Cliente de : " + MV_PAR07 + "   /   Cliente at้ : " + MV_PAR08 Size 150,010 Font oFnt Pixel Of oPnlInfo
	
	@ 020,500 Say "Data de : " + DTOC(MV_PAR09) + "   /   Data at้ : " + DTOC(MV_PAR10) Size 200,010 Font oFnt Pixel Of oPnlInfo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MONTA O BROWSE COM AS INFORMACOES ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oBrw:= TWBrowse():New(000,000,000,000,,{"Loja","Vendedor","Pedido/Titulo","Cliente","Nome Cliente","CPF","Forma Pagamento","Operadora","Rede","Parcela","Num_NSU","Parcela_NSU","Data Venda",;
	                                        "Data Vencimento","Mes Vencimento","Dias Decorridos","Dias Decorridos Ponderados","Valor Bruto","Taxa %","Taxa R$","Valor Liquido","Multa\Bol.","Status",;
	                                        "Data Baixa","Tํtulo Financeiro","Prefixo","Adm x Parcela","Tipo Baixa","Atendente Cred."},,oTela,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aDados)
	oBrw:bLine := {|| {		ALLTRIM(aDados[oBrw:nAt,01]) + " - " + ALLTRIM(aDados[oBrw:nAt,02])				,;	// LOJA 						- E1_MSFIL + FILIAL
	ALLTRIM(aDados[oBrw:nAt,03]) + " - " + ALLTRIM(aDados[oBrw:nAt,04])										,;	// VENDEDOR						- C5_VEND1 + A3_NOME
	aDados[oBrw:nAt,05] 																					,;	// NUMERO DO PEDIDO DE VENDA	- E1_PEDIDO
	aDados[oBrw:nAt,06] + " - " + aDados[oBrw:nAt,07]														,;	// CLIENTE						- E1_CLIENTE + E1_LOJA
	ALLTRIM(aDados[oBrw:nAt,08]) 																			,;	// NOME DO CLIENTE				- A1_NOME
	aDados[oBrw:nAt,09] 																					,;	// CPF DO CLIENTE				- A1_CGC
	aDados[oBrw:nAt,10]								 								   						,;	// FORMA DE PAGAMENTO			- E1_TIPO
	ALLTRIM(aDados[oBrw:nAt,12])	 																		,;	// OPERADORA					- E1_01NOOPE
	ALLTRIM(aDados[oBrw:nAt,13]) 																			,;	// REDE							- E1_01NORED
	aDados[oBrw:nAt,14] 																					,;	// PARCELA						- E1_PARCELA
	aDados[oBrw:nAt,32] 																					,;	// NUM_NSU						- E1_NSUTEF	 //#MZ20181017.N
	aDados[oBrw:nAt,31] 																					,;	// PARCELA_NSU					- E1_XPARNSU //#MZ20181016.N
	DTOC(STOD(aDados[oBrw:nAt,19]))																			,;	// DATA DA VENDA				- C5_EMISSAO
	DTOC(STOD(aDados[oBrw:nAt,20]))																			,;	// DATA DE RECEBIMENTO			- E1_VENCTO
	RIGHT(DTOC(STOD(aDados[oBrw:nAt,20])) ,7)																,;	// MES_CREDITO					- XXXXXXXXXX
	STOD(aDados[oBrw:nAt,20]) -  STOD(aDados[oBrw:nAt,19])													,;	// DIAS_DECORRIDOS				- XXXXXXXXXX
	aDados[oBrw:nAt,23] 																					,;	// DIAS_DECORRIDOS_PONDERADOS	- XXXXXXXXXX
	Transform(aDados[oBrw:nAt,24],PesqPict('SE1','E1_01VLBRU'))												,;	// VALOR BRUTO					- E1_01VLBRU
	Transform(aDados[oBrw:nAt,25],PesqPict('SE1','E1_01TAXA'))												,;	// TAXA REDE					- E1_01TAXA
	Transform(aDados[oBrw:nAt,34],PesqPict('SE2','E2_VALOR'))												,;
	Transform(aDados[oBrw:nAt,26],PesqPict('SE1','E1_VALOR')) 												,;	// VALOR DO TITULO				- E1_VALOR
	aDados[oBrw:nAt,36] ,;
	IF(EMPTY(aDados[oBrw:nAt,28]),"ABERTO","BAIXADO")														,;	// STATUS						- XXXXXXXXXX
	DTOC(STOD(aDados[oBrw:nAt,28]))																			,;	// DATA BAIXA					- E1_BAIXA  
	aDados[oBrw:nAt,29] 																					,;	// TITULO						- E1_NUM
	aDados[oBrw:nAt,30] 														 						    ,;	// PREFIXO						- E1_PREFIXO
	aDados[oBrw:nAt,33]															  							,;  // adm x parcela
	aDados[oBrw:nAt,11]                                                                                     ,;
	aDados[oBrw:nAt,35]					                                                                    }}
	oBrw:Align:=CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oTela CENTERED    
Else
	MsgInfo("Nใo existe dados para o filtro selecionado!","Aten็ใo")
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILDADOS บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  05/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA AS INFORMACOES QUE IRAM CONTER NO RELATORIO         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILDADOS()

Local cQuery    := ""
Local aPergunta := {}
Local _cParc  := "" //#CMG20180222.n

Aadd(aPergunta,{PadR("KMFINR01",10),"01","Loja de  ?" 					,"MV_CH1" ,"C",04,00,"G","MV_PAR01",""    ,""    ,"","","","SM0"})
Aadd(aPergunta,{PadR("KMFINR01",10),"02","Loja at้ ?" 					,"MV_CH2" ,"C",04,00,"G","MV_PAR02",""    ,""    ,"","","","SM0"})
Aadd(aPergunta,{PadR("KMFINR01",10),"03","Vendedor de ?" 				,"MV_CH3" ,"C",06,00,"G","MV_PAR03",""    ,""    ,"","","","SA3"})
Aadd(aPergunta,{PadR("KMFINR01",10),"04","Vendedor at้ ?" 				,"MV_CH4" ,"C",06,00,"G","MV_PAR04",""    ,""    ,"","","","SA3"})
Aadd(aPergunta,{PadR("KMFINR01",10),"05","Titulo de ?" 					,"MV_CH5" ,"C",06,00,"G","MV_PAR05",""    ,""    ,"","","","SE1"})
Aadd(aPergunta,{PadR("KMFINR01",10),"06","Titulo at้ ?" 				,"MV_CH6" ,"C",06,00,"G","MV_PAR06",""    ,""    ,"","","","SE1"})
Aadd(aPergunta,{PadR("KMFINR01",10),"07","Cliente de ?" 				,"MV_CH7" ,"C",06,00,"G","MV_PAR07",""    ,""    ,"","","","SA1"})
Aadd(aPergunta,{PadR("KMFINR01",10),"08","Cliente at้ ?" 				,"MV_CH8" ,"C",06,00,"G","MV_PAR08",""    ,""    ,"","","","SA1"})
Aadd(aPergunta,{PadR("KMFINR01",10),"09","Data Emissใo de ?" 		    ,"MV_CH9" ,"D",08,00,"G","MV_PAR09",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR01",10),"10","Data Emissใo at้ ?" 		    ,"MV_CH10","D",08,00,"G","MV_PAR10",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR01",10),"11","Data Vencimento de ?" 	    ,"MV_CH11","D",08,00,"G","MV_PAR11",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR01",10),"12","Data Vencimento at้ ?"	    ,"MV_CH12","D",08,00,"G","MV_PAR12",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMFINR01",10),"13","Forma de Pagamento de ?"	    ,"MV_CH13","C",03,00,"G","MV_PAR13",""    ,""    ,"","","","SAE"})
Aadd(aPergunta,{PadR("KMFINR01",10),"14","Forma de Pagamento at้ ?" 	,"MV_CH14","C",03,00,"G","MV_PAR14",""    ,""    ,"","","","SAE"})


VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf 

//FwMsgRun( ,{|| CALCTOTAL() }, , "Filtrando dados , por favor aguarde..." )

cQuery := " SELECT E1_MSFIL , FILIAL, C5_VEND1, E1_VEND1, A3_NOME, E1_NUM, E1_CLIENTE, E1_LOJA, A1_NOME, A1_CGC, E1_TIPO, E1_NATUREZ, E1_01NOOPE, E1_01NORED,"
cQuery += "'' BANCO, '' AGENCIA , E1_NSUTEF, E1_EMISSAO,"
cQuery += " E1_XPARNSU, E1_PARCELA, "
cQuery += " '' CONTA_CORRENTE , '' CHEQUE, C5_EMISSAO, E1_VENCREA, '' MES_CREDITO, '' DIAS_DECORRIDOS, '' DIAS_DECORRIDOS_PONDERADOS, E1_VALOR, '' STS, E1_BAIXA, E1_PREFIXO, E1_01OPER, E1_01QPARC,"
cQuery += " CASE WHEN E1_01VLBRU = 0 THEN E1_VALOR END AS E1_01VLBRU,"	//#RVC20181119.n
cQuery += " ISNULL(E1_VALOR - E2_VALOR,E1_VALOR) AS VALLIQ,"			//#RVC20181203.n
cQuery += " E1_01TAXA AS E1_01TAXA, CASE WHEN E1_TIPO='BOL' AND E1_01TAXA=0 THEN 'BOLETO KOMFORT' WHEN E1_TIPO='CC' AND E1_01TAXA=0 THEN 'CREDITO CONTA' WHEN E1_TIPO='RA' AND E1_01TAXA=0 THEN 'RECEBIMENTO ANTECIPADO' WHEN E1_TIPO IN('R$') AND E1_01TAXA=0 THEN 'ESPECIE' WHEN E1_TIPO IN('NCC') AND E1_01TAXA=0 THEN 'NOTA CREDITO' ELSE E1_XDSCADM END AS E1_XDSCADM, "						//#RVC20181119.n
cQuery += " E2_VALOR, "
cQuery += " CASE WHEN E1_JUROS = 0 THEN E1_MULTA ELSE E1_JUROS END AS E1_JUROS, "
cQuery += "	CASE  "	
cQuery += "	WHEN E1_PORTADO = ''  AND  E1_BAIXA = ''   THEN 'EM ABERTO'"
cQuery += "	WHEN E1_PORTADO <> ''  AND  E1_BAIXA = ''   THEN 'EM ABERTO'"
cQuery += "	WHEN E1_PORTADO <>''  AND  E1_BAIXA <> ''  THEN 'NORMAL'"	
cQuery += "	WHEN E1_PORTADO = '' AND  E1_BAIXA <> '' AND E2_TIPO ='PA' THEN 'NORMAL'"
cQuery += "	WHEN E1_PORTADO = '' AND  E1_BAIXA <> '' THEN 'DACAO'"
cQuery += " END  TIPO_BAIXA, "                                    //#RVC20181119.n
cQuery += " UA_XATCRED	"													
cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "

cQuery += " LEFT JOIN " + RETSQLNAME("SUA") + " SUA ON E1_CLIENTE = UA_CLIENTE AND E1_MSFIL = UA_FILIAL AND E1_NUMSUA = UA_NUM AND SUA.D_E_L_E_T_ = ''"

cQuery += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "

cQuery += " LEFT JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_NUM = E1_PEDIDO AND SC5.D_E_L_E_T_ = '' "
cQuery += " AND C5_MSFIL = E1_MSFIL "

cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " SA3 ON A3_COD = E1_VEND1 AND SA3.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = E1_CLIENTE  AND SA1.D_E_L_E_T_= '' "
cQuery += " AND A1_LOJA = E1_LOJA "

cQuery += " LEFT JOIN SE2010 (NOLOCK) SE2 ON E2_MSFIL = E1_MSFIL "
cQuery += " AND E2_NUM = E1_NUM	"
cQuery += " AND E2_PARCELA = E1_PARCELA "
cQuery += " AND E2_TIPO = E1_TIPO "
cQuery += " AND E2_PREFIXO = 'TXA' "
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "

cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_MSFIL   BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
cQuery += " AND E1_VEND1   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
cQuery += " AND E1_NUM     BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "                           

cQuery += " AND E1_CLIENTE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  "
cQuery += " AND E1_EMISSAO BETWEEN '" + DTOS(MV_PAR09) + "' AND '" + DTOS(MV_PAR10) + "'  "
cQuery += " AND E1_VENCREA BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "'  "    
cQuery += " AND E1_01OPER  BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "'  "
cQuery += " AND E1_TIPO    BETWEEN '" + MV_PAR15 + "' AND '" + MV_PAR16 + "'  "
cQuery += " AND E1_STATUS  BETWEEN '" + MV_PAR17 + "' AND '" + MV_PAR18 + "'  "

cQuery += " GROUP BY E1_MSFIL , FILIAL, C5_VEND1, E1_VEND1, A3_NOME, E1_NUM, E1_CLIENTE, E1_LOJA, A1_NOME, A1_CGC, E1_TIPO, E1_NATUREZ, E1_01NOOPE, E1_01NORED,E1_PORTADO,E2_TIPO, " 
cQuery += " E1_NSUTEF, E1_EMISSAO, E1_XPARNSU, E1_PARCELA, C5_EMISSAO, E1_VENCREA, E1_VALOR,E1_BAIXA, E1_PREFIXO, E1_01OPER, E1_01QPARC, E1_01VLBRU,E1_01TAXA, E1_XDSCADM, E2_VALOR,E1_JUROS,E1_MULTA,UA_XATCRED " 
cQuery += " ORDER BY E1_NUM, E1_TIPO, E1_PARCELA, E1_NSUTEF"

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
MemoWrite('\Querys\KMFINR01.sql',cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())	                      
	IF TRB->E1_TIPO $ "CH"  
		DbSelectArea("SEF")
		SEF->(DbSetOrder(3)) 
		SEF->(DbSeek(xFilial("SEF") + TRB->E1_PREFIXO + TRB->E1_NUM))
	    cBanco     := SEF->EF_BANCO
	    cAgencia   := SEF->EF_AGENCIA
	    CCCorrente := SEF->EF_CONTA
	    cCheque    := SEF->EF_NUM             
	Else
	    cBanco     := "" 
	    cAgencia   := ""
	    CCCorrente := ""
	    cCheque    := ""         
    EndIF
              
	//#CMG20180222.bn
	If TRB->E1_01QPARC > 0
	                                    
		if ALLTRIM(TRB->E1_TIPO) $ "CC|CD"
	
			_cParc := ' '+AllTrim(cValtoChar(u_RetParc(TRB->E1_XPARNSU)))+'/'+AllTrim(cValToChar(TRB->E1_01QPARC))
	
		else
	
			_cParc := ' '+AllTrim(cValtoChar(u_RetParc(TRB->E1_PARCELA)))+'/'+AllTrim(cValToChar(TRB->E1_01QPARC))
		endIf
	Else 
	
		_cParc := ' ' + AllTrim(cValToChar(u_RetParc(TRB->E1_PARCELA)))
		
		if ALLTRIM(TRB->E1_TIPO) $ "RA|R$|NCC|NDC|NF"
	
			_cParc := ' 1/1'
	
		endIf
	EndIf
	//#CMG20180222.en	

	aAdd( aDados, { TRB->E1_MSFIL,; 						//01
					TRB->FILIAL,; 							//02
					TRB->E1_VEND1,; 						//03	//					TRB->C5_VEND1,; 						//03
					TRB->A3_NOME,; 							//04
					TRB->E1_NUM,; 							//05
					TRB->E1_CLIENTE,; 						//06
					TRB->E1_LOJA,; 							//07
					TRB->A1_NOME,; 							//08
					TRB->A1_CGC,; 							//09
					TRB->E1_TIPO,; 							//10
					TRB->TIPO_BAIXA,; 						//11
					TRB->E1_01NOOPE,;						//12
					TRB->E1_01NORED,; 						//13
					_cParc,; 								//14
					cBanco,; 								//15
					cAgencia ,; 							//16
					CCCorrente ,; 							//17
					cCheque,; 								//18
					TRB->E1_EMISSAO,;						//19	//					TRB->C5_EMISSAO,;		//19
					TRB->E1_VENCREA,; 						//20
					TRB->MES_CREDITO,; 						//21
					TRB->DIAS_DECORRIDOS,;					//22	
					TRB->DIAS_DECORRIDOS_PONDERADOS,;		//23 
					TRB->E1_VALOR,;							//24	//					TRB->E1_01VLBRU,; 		//24
					TRB->E1_01TAXA,; 						//25
					TRB->VALLIQ,;							//26	//					TRB->E1_VALOR,; 		//26
					TRB->STS,; 								//27
					TRB->E1_BAIXA,; 						//28
					TRB->E1_NUM,; 							//29
					TRB->E1_PREFIXO,; 						//30
					cValToChar(U_RetParc(TRB->E1_XPARNSU)),;//31	//					TRB->E1_XPARNSU,; 					//31
					TRB->E1_NSUTEF,;	//})//				//32
					TRB->E1_XDSCADM,;	//})//				//33
					TRB->E2_VALOR,;                         //34  
					TRB->UA_XATCRED,;						//35
					TRB->E1_JUROS })	                    //36
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  05/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DE PERGUNTAS DO SX1                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VldSX1(aPergunta)

Local i
Local aAreaBKP := GetArea()

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
	SX1->X1_GRUPO 		:= aPergunta[i,1]
	SX1->X1_ORDEM		:= aPergunta[i,2]
	SX1->X1_PERGUNT		:= aPergunta[i,3]
	SX1->X1_VARIAVL		:= aPergunta[i,4]
	SX1->X1_TIPO		:= aPergunta[i,5]
	SX1->X1_TAMANHO		:= aPergunta[i,6]
	SX1->X1_DECIMAL		:= aPergunta[i,7]
	SX1->X1_GSC			:= aPergunta[i,8]
	SX1->X1_VAR01		:= aPergunta[i,9]
	SX1->X1_DEF01		:= aPergunta[i,10]
	SX1->X1_DEF02		:= aPergunta[i,11]
	SX1->X1_DEF03		:= aPergunta[i,12]
	SX1->X1_DEF04		:= aPergunta[i,13]
	SX1->X1_DEF05		:= aPergunta[i,14]
	SX1->X1_F3			:= aPergunta[i,15]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcExcel บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  09/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DE PERGUNTAS DO SX1                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION ProcExcel()

Local cDirDocs   := MsDocPath()
Local aStru	     := {}
Local aDados     := {}
Local cArquivo   := CriaTrab(,.F.)
Local cPath		 := AllTrim(GetTempPath())
Local cCrLf 	 := Chr(13) + Chr(10)
Local oExcelApp
Local nHandle
Local nX    
Local cGrp1 := cGrp2 := cGrp3 := cGrp4 := "" 

aStru := {	{"Loja"	    					, "C",30,0},; //01
			{"Vendedor"						, "C",50,0},; //02
			{"Pedido/Titulo"				, "C",10,0},; //03
			{"Cliente"						, "C",30,0},; //04
			{"Nome Cliente"					, "C",60,0},; //05
			{"CPF"							, "C",20,0},; //06
			{"Forma Pagamento"				, "C",10,0},; //07
			{"Operadora"					, "C",10,0},; //08
			{"Rede"							, "C",30,0},; //09
			{"Parcela"						, "C",10,0},; //10
			{"Num_NSU"						, "C",10,0},; //11
			{"Parcela_NSU"					, "C",10,0},; //12
			{"Data Venda"					, "C",10,0},; //13
			{"Data Vencimento"				, "C",10,0},; //14
			{"Mes Vencimento"				, "C",10,0},; //15
			{"Dias Decorridos"				, "C",10,0},; //16
			{"Dias Decorridos Ponderados"	, "C",10,0},; //17																														
			{"Valor Bruto"					, "N",10,2},; //18
			{"Taxa %"						, "N",10,2},; //19
			{"Valor Taxa"					, "N",10,2},; //20
			{"Valor Liquido"				, "N",10,2},; //21
			{"Multa\Bol."                   , "N",10,2},; //22
			{"Status"						, "C",10,0},; //23
			{"Tipo de Baixa"				, "C",10,0},; //24  
			{"Data Baixa"					, "C",10,0},; //25 
			{"Tํtulo Financeiro"			, "C",10,0},; //26 
			{"Prefixo"						, "C",10,0},; //27
			{"Parcela ADM"					, "C",30,0},; //28
			{"Atendente Cred."				, "C",40,0}}  //29
ProcRegua(Len(aDados)+2)

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") // "Aguarde! Gerando arquivo de integra็ใo com Excel..."
	aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	For nX := 1 to Len(oBrw:AARRAY)
		IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...") // "Aguarde! Gerando arquivo de integra็ใo com Excel..."
			
		fWrite(nHandle, ALLTRIM(oBrw:AARRAY[nX,01]) + " - " + ALLTRIM(oBrw:AARRAY[nX,02]) + ";" )	//01
		fWrite(nHandle, ALLTRIM(oBrw:AARRAY[nX,03]) + " - " + ALLTRIM(oBrw:AARRAY[nX,04]) + ";")	//02
		fWrite(nHandle, "'"+oBrw:AARRAY[nX,05]  + ";")												//03
		fWrite(nHandle, oBrw:AARRAY[nX,06] + " - " + oBrw:AARRAY[nX,07]	 + ";")						//04
		fWrite(nHandle, ALLTRIM(oBrw:AARRAY[nX,08]) + ";")											//05
		fWrite(nHandle, oBrw:AARRAY[nX,09] + ";")													//06
		fWrite(nHandle, oBrw:AARRAY[nX,10] + ";")													//07
		fWrite(nHandle, ALLTRIM(oBrw:AARRAY[nX,12]) + ";")											//08
		fWrite(nHandle, ALLTRIM(oBrw:AARRAY[nX,13]) + ";")											//09
		fWrite(nHandle, oBrw:AARRAY[nX,14] + ";")                                                   //10
		fWrite(nHandle, oBrw:AARRAY[nX,32] + ";")													//11
		fWrite(nHandle, cvaltochar(oBrw:AARRAY[nX,31]) + ";")										//12	
		fWrite(nHandle, DTOC(STOD(oBrw:AARRAY[nX,19])) + ";")										//13
		fWrite(nHandle, DTOC(STOD(oBrw:AARRAY[nX,20])) + ";")										//14
		fWrite(nHandle, RIGHT(DTOC(STOD(oBrw:AARRAY[nX,20])) ,7) + ";")								//15
		fWrite(nHandle, Transform(STOD(oBrw:AARRAY[nX,20]) - STOD(oBrw:AARRAY[nX,19]), "@E 999,999" ) + ";")//16
		fWrite(nHandle, oBrw:AARRAY[nX,23] + ";")	                                                //17
		fWrite(nHandle, Transform(oBrw:AARRAY[nX,24],PesqPict('SE1','E1_01VLBRU')) + ";")			//18
		fWrite(nHandle, Transform(oBrw:AARRAY[nX,25],PesqPict('SE1','E1_01TAXA')) + ";")			//19
		fWrite(nHandle, Transform(oBrw:AARRAY[nX,34],PesqPict('SE1','E1_01TAXA')) + ";")			//20
		fWrite(nHandle, Transform(oBrw:AARRAY[nX,26],PesqPict('SE1','E1_VALOR')) + ";")			    //21
		fWrite(nHandle, Transform(oBrw:AARRAY[nX,36],PesqPict('SE1','E1_JUROS')) + ";") 			//22
		fWrite(nHandle, IF(EMPTY(oBrw:AARRAY[nX,28]),"ABERTO","BAIXADO") + ";")                     //23
		fWrite(nHandle, oBrw:AARRAY[nX,11] + ";")						                            //24
		fWrite(nHandle, DTOC(STOD(oBrw:AARRAY[nX,28])) + ";")										//25
		fWrite(nHandle, oBrw:AARRAY[nX,29] + ";")										            //26
		fWrite(nHandle, oBrw:AARRAY[nX,30] + ";")													//27
		fWrite(nHandle, oBrw:AARRAY[nX,33] + ";")													//28
		fWrite(nHandle, oBrw:AARRAY[nX,35] + ";")													//29
		fWrite(nHandle, cCrLf ) // Pula linha		 				
	Next
	
	IncProc("Aguarde! Abrindo o arquivo..." ) //"Aguarde! Abrindo o arquivo..."
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' ) //'MsExcel nao instalado'
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert( "Falha na cria็ใo do arquivo" ) // "Falha na cria็ใo do arquivo"
Endif

RETURN()                           
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALCTOTAL บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  09/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DE PERGUNTAS DO SX1                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
/*STATIC FUNCTION CALCTOTAL()

Local cQuery := ""

cQuery := " SELECT E1_01OPER, SUM(E1_VALOR) AS VALOR FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " INNER JOIN SM0010 SM0 ON FILFULL = E1_MSFIL "
//cQuery += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_NUM = E1_NUM "	//
cQuery += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_NUM = E1_PEDIDO "
cQuery += " AND C5_MSFIL = E1_MSFIL "
cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON A3_COD = C5_VEND1 "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = E1_CLIENTE "
cQuery += " AND A1_LOJA = E1_LOJA "
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' "
cQuery += " AND A3_FILIAL = '" + XFILIAL("SA3") + "' "
cQuery += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_MSFIL   BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
cQuery += " AND C5_VEND1   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
cQuery += " AND C5_NUM     BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "                           
cQuery += " AND E1_CLIENTE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'  "
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR09) + "' AND '" + DTOS(MV_PAR10) + "'  "
cQuery += " AND E1_VENCTO  BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "'  "    
cQuery += " AND E1_01OPER  BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "'  " 
cQuery += " GROUP BY E1_01OPER "          

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())	                      
	aAdd( aFrmTotal, { 	TRB->E1_01OPER , TRB->VALOR} )
	TRB->(DbSkip())
EndDo

RETURN()
*/