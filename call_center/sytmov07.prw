#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYTMOV07 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA DE MONITOR DE CLIENTES                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYTMOV07(cCliente,cLjCli)

Local aButtons  := {}
Local aSize     := MsAdvSize()
Local oFnt , oLogo
Local oPnlCliente, oPnlPedido, oPnlSAC, oPnlFinan, oPnlCredito
Local oPnlSup1, oPnlSup2, oPnlSup3, oPnlSup4
Local oBrwPedido, oBrwSAC, oBrwFinan, oBrwCredito
Local oBmpPed1 , oBmpPed2 , oBmpPed3
Local oScroll, oPnlScroll
Local nRecno	:= 0	   
Local lF12      := .F.							// Registro da entidade a ser manipulado

Private oTela
Private cCadastro := "Monitor de Clientes - KOMFORT HOUSE"
Private aPedidos  := {{"1" , "" , "", 0, 0 , "", "", "", "" , "", "", "","","",""}}
Private aSAC      := {{"1" , "" , "", "", "", "", "", ""}}
Private aFinan    := {{"1" , "" , "", 0, "", ""}}
Private aCredito  := {{"1" , "" , 0 , 0 , "" , "" , "" , "" , "", "", "", "" , "", ""}}
Private oSt1   	  := LoadBitmap(GetResources(),'BR_VERDE')
Private oSt2      := LoadBitmap(GetResources(),'BR_AMARELO')
Private oSt3      := LoadBitmap(GetResources(),'BR_VERMELHO') 
Private aRotina   := {}              
                                                                                                   
                                                                                                   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ADICIONADO A OPวรO DE BUSCAR UM NOVO CLIENTE SEM SAIR DA TELA [ITEM 289] - LUIZ EDUARDO F.C. - 06.10.2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd(aButtons,{"S4WB016N",{||IIF (MsgYesno("Deseja Pesquisar um novo cliente?"),(oTela:End() , lF12 := .T. ),)},"Filtra Novo Cliente <F12>","Filtra Novo Cliente <F12>",,})	//"Help"

SetKey( VK_F12 , { || IIF (MsgYesno("Deseja Pesquisar um novo cliente?"),(oTela:End() , lF12 := .T. ),)} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA PRINCIPAL DO MONITORAMENTO DE CLIENTE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Monitoramento de Clientes" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTela:lEscClose := .F.

oScroll := TScrollArea():New(oTela,000,000,000,000,.T.,.T.,.T.)
oScroll:Align := CONTROL_ALIGN_ALLCLIENT

//@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 2150,2150 //#AFD201800601.O
@ 000,000 MSPANEL oPnlScroll OF oScroll SIZE 600,430 //#AFD201800601.N
oScroll:SetFrame( oPnlScroll )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ POSICIONA NO CLIENTE INFORMADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cCliente + cLjCli))

aRotAuto := Nil
l030Auto := .F.
nRecno	 := SA1->(Recno())
ALTERA	 := .T.
INCLUI	 := .F.//#AFD20180601.n
EXCLUI	 := .F.//#AFD20180601.n
aRotina  := { 	{"","AxPesqui",0,1} ,;                            
				{"","AxVisual",0,2} ,;
				{"","AxInclui",0,3} ,;
				{"","AxAltera",0,4} ,;
				{"","AxDeleta",0,5} }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES DO CLIENTE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlCliente:= TPanel():New(005,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,655,045, .T., .F. )
oPnlCliente:NCLRPANE:=RGB(220,220,220)

@ 005,005 Say "Informa็๕es do Cliente" 									Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlCliente
@ 015,005 Say "Nome : " + ALLTRIM(SA1->A1_NOME) 						Size 200,010 Font oFnt 					Pixel Of oPnlCliente
@ 015,210 Say "Telefone : " + TRANSFORM(SA1->A1_TEL, "@R 9999-9999")  	Size 100,010 Font oFnt 					Pixel Of oPnlCliente
@ 015,300 Say "CPF : " + TRANSFORM(SA1->A1_CGC, "@R 999.999.999-99")  	Size 100,010 Font oFnt 					Pixel Of oPnlCliente
@ 015,390 Say "Cliente Desde : " + DTOC(SA1->A1_DTCAD)  				Size 100,010 Font oFnt 					Pixel Of oPnlCliente
// ANALISA SE O CLIENTE TEM PENDENCIA FINANCEIRA
IF ALLTRIM(SA1->A1_01PEDFI) == "1"
	@ 015,480 Say "Pendencia Financeira : SIM" 				  			Size 100,010 Font oFnt 	Color CLR_RED	Pixel Of oPnlCliente
Else
	@ 015,480 Say "Pendencia Financeira : NรO" 				  			Size 100,010 Font oFnt 	Color CLR_BLUE	Pixel Of oPnlCliente
EndIF
@ 025,005 Say "Endere็o : " + ALLTRIM(SA1->A1_END) + " , " + ALLTRIM(SA1->A1_BAIRRO) + " , " + ALLTRIM(SA1->A1_MUN) + " , " + ALLTRIM(SA1->A1_ESTADO) + " CEP : " + ALLTRIM(SA1->A1_CEP) Size 600,020 Font oFnt 					Pixel Of oPnlCliente
// TRAZ O LOGO DA KOMFORT HOSUE
@ 005,590 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oPnlCliente PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA OS BOTOES DA TELA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 055, 005 BUTTON "&PEDIDOS"			SIZE 75,25 OF oPnlScroll PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - PEDIDOS" , U_SYTMOV11(cCliente,cLjCli) }, , "Filtrando os pedidos , por favor aguarde..." )  }
@ 055, 150 BUTTON "&SAC" 				SIZE 75,25 OF oPnlScroll PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - CHAMADOS SAC" , U_SYTMOV08(cCliente,cLjCli) }, , "Filtrando os chamados do SAC , por favor aguarde..." )  }
@ 055, 295 BUTTON "&FINANCEIRO" 		SIZE 75,25 OF oPnlScroll PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - FINANCEIRO" , U_SYTMOV09(cCliente,cLjCli) }, , "Filtrando os dados financeiros dos pedidos , por favor aguarde..." )  }
@ 055, 440 BUTTON "&CREDITOS" 			SIZE 75,25 OF oPnlScroll PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - CRษDITOS" , U_SYTMOV10(cCliente,cLjCli) }, , "Filtrando os creditos do cliente , por favor aguarde..." ) }
@ 055, 585 BUTTON "CADAS&TRO" 			SIZE 75,25 OF oPnlScroll PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Cadastro de Clientes - ALTERAวรO" , A030Altera("SA1",nRecno,4) }, , "Abrindo tela de cadastro de clientes , por favor aguarde..." )  }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES DOS PEDIDOS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlPedido:= TPanel():New(085,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,080, .T., .F. )

oPnlSup1:= TPanel():New(0, 0, "Pedidos",oPnlPedido,oFnt, .F., .F., CLR_WHITE, NIL, 0,08, .F., .T. )
oPnlSup1:Align:= CONTROL_ALIGN_TOP
oPnlSup1:nClrPane:=RGB(0,0,0)

// FILTRA OS PEDIDOS DO CLIENTE SELECIONADO
FwMsgRun( ,{|| FILPED(5) }, , "Filtrando pedidos , por favor aguarde..." )

oBrwPedido:= TWBrowse():New(000,000,000,000,,{"","Pedido","Num.TMK","Valor","Quantidade","Loja Origem","Vendedor","Dt.Emissใo","Dt.Entrega","SAC","Ordem_Producao","Dt_Entrega_OP","Produto_OP"},,oPnlPedido,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwPedido:SetArray(aPedidos)
oBrwPedido:bLine := {|| { IF(aPedidos[oBrwPedido:nAt,01] == "1",oSt1,IF(aPedidos[oBrwPedido:nAt,01] == "2",oSt2,oSt3))							,;	// LEGENDA
							 aPedidos[oBrwPedido:nAt,02] 													,;	// PEDIDO
							 aPedidos[oBrwPedido:nAt,03] 													,;	// NUMERO ORCAMENTO TELEVENDAS
							 Transform(aPedidos[oBrwPedido:nAt,04] ,PesqPict('SC6','C6_VALOR'))				,;	// VALOR TOTAL DOS ITENS
							 Transform(aPedidos[oBrwPedido:nAt,05] ,PesqPict('SC6','C6_QTDVEN'))			,;	// QUANTIDADE TOTAL DOS ITENS
							 aPedidos[oBrwPedido:nAt,06] + " - "+ ALLTRIM(aPedidos[oBrwPedido:nAt,12])		,;	// LOJA DE ORIGEM
							 aPedidos[oBrwPedido:nAt,07] + " - "+ ALLTRIM(aPedidos[oBrwPedido:nAt,11])		,;	// VENDEDOR - CODIGO + NOME
							 DTOC(STOD(aPedidos[oBrwPedido:nAt,08]))										,;	// DATA DA EMISSAO DO PEDIDO
							 DTOC(STOD(aPedidos[oBrwPedido:nAt,09]))										,;	// DATA DA ENTREGA DO PEDIDO          
							 aPedidos[oBrwPedido:nAt,10] 													,;	// NUMERO DO ATENDIMENTO NO SAC   
							 aPedidos[oBrwPedido:nAt,13] 													,;	// NUMERO DA OP
							 DTOC(STOD(aPedidos[oBrwPedido:nAt,14]))										,;	// DATA ENTREGA OP  
							 aPedidos[oBrwPedido:nAt,15]										   			,;	// PRODUTO OP             
}}
oBrwPedido:Align:=CONTROL_ALIGN_ALLCLIENT
oBrwPedido:bLDblClick := {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - PEDIDOS" , DETPEDIDO(aPedidos[oBrwPedido:nAt]) }, , "Aguarde, obtendo detalhes do item selecionado" ) }
                                                                                
// CARREGA AS LEGENDAS DO BROWSE DE PEDIDOS
@ 095,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 095,595 SAY "Em aberto" OF oPnlScroll Font oFnt  PIXEL

@ 115,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel       
@ 115,595 SAY "Em processamento" OF oPnlScroll Font oFnt PIXEL

@ 135,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 135,595 SAY "Finalizado" OF oPnlScroll Font oFnt PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES DOS CHAMADOS DO SAC ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlSAC:= TPanel():New(175,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,080, .T., .F. )

oPnlSup2:= TPanel():New(0, 0, "Chamados - SAC",oPnlSAC,oFnt, .F., .F., CLR_WHITE, NIL, 0,08, .F., .T. )
oPnlSup2:Align:= CONTROL_ALIGN_TOP
oPnlSup2:nClrPane:=RGB(0,0,0)

// FILTRA OS PEDIDOS DO CLIENTE SELECIONADO
FwMsgRun( ,{|| FILSAC(5) }, , "Filtrando os chamados do SAC , por favor aguarde..." )

oBrwSAC:= TWBrowse():New(000,000,000,000,,{"","Atendimento","Operador","Nome","Dt.Abertura","Hr.Abertura","Pedido","Loja de Origem do Pedido"},,oPnlSAC,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwSAC:SetArray(aSAC)
oBrwSAC:bLine := {|| { 	 IF(aSAC[oBrwSAC:nAt,01] == "1",oSt1,IF(	aSAC[oBrwSAC:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aSAC[oBrwSAC:nAt,02] 													,;	// ATENDIMENTO
aSAC[oBrwSAC:nAt,03] 													,;	// CODIGO OPERADOR
aSAC[oBrwSAC:nAt,04]													,;	// NOME DO OPERADOR
DTOC(STOD(aSAC[oBrwSAC:nAt,05]))										,;	// DATA DA ABERTURA DO CHAMADO
aSAC[oBrwSAC:nAt,06]													,;	// H DA ORAENTREGA DO PEDIDO
aSAC[oBrwSAC:nAt,07] 													,;	// NUMERO DO PEDIDO
aSAC[oBrwSAC:nAt,08] 													,;	// LOJA DE ORIGEM DO PEDIDO
}}
oBrwSAC:Align:=CONTROL_ALIGN_ALLCLIENT
oBrwSAC:bLDblClick := {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - CHAMADOS SAC" , DETSAC(aSAC[oBrwSAC:nAt]) }, , "Aguarde, obtendo detalhes do item selecionado" ) }

// CARREGA AS LEGENDAS DO BROWSE DE PEDIDOS
@ 180,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 180,595 SAY "Em aberto" OF oPnlScroll Font oFnt  PIXEL

@ 200,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 200,595 SAY "Em processamento" OF oPnlScroll Font oFnt PIXEL

@ 220,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 220,595 SAY "Finalizado" OF oPnlScroll Font oFnt PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES DOS STATUS FINANCEIRO DOS PEDIDOS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlFinan:= TPanel():New(255,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,080, .T., .F. )

oPnlSup3:= TPanel():New(0, 0, "Status Financeiro dos Pedidos",oPnlFinan,oFnt, .F., .F., CLR_WHITE, NIL, 0,08, .F., .T. )
oPnlSup3:Align:= CONTROL_ALIGN_TOP
oPnlSup3:nClrPane:=RGB(0,0,0)

// FILTRA OS PEDIDOS DO CLIENTE SELECIONADO
FwMsgRun( ,{|| FILFIN(5) }, , "Filtrando status financeiro dos pedidos , por favor aguarde..." )

oBrwFinan:= TWBrowse():New(000,000,000,000,,{"","Pedido","Dt.Emissใo","Valor","Loja Origem"},,oPnlFinan,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwFinan:SetArray(aFinan)
oBrwFinan:bLine := {|| { IF(aFinan[oBrwFinan:nAt,01] == "1",oSt1,IF(aFinan[oBrwFinan:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aFinan[oBrwFinan:nAt,02] 													,;	// PEDIDO
DTOC(STOD(aFinan[oBrwFinan:nAt,03]))										,;	// DATA DE EMISSAO DO PEDIDO
Transform(aFinan[oBrwFinan:nAt,04] ,PesqPict('SC6','C6_VALOR'))			,;	// VALOR TOTAL DO PEDIDO
aFinan[oBrwFinan:nAt,05]  + " - " + ALLTRIM(aFinan[oBrwFinan:nAt,06]) 		,;	// LOJA DE ORIGEM
}}
oBrwFinan:Align:=CONTROL_ALIGN_ALLCLIENT
oBrwFinan:bLDblClick := {|| FwMsgRun( ,{|| cCadastro := "Monitor de Clientes - KOMFORT HOUSE - FINANCEIRO" , DETFINAN(aFinan[oBrwFinan:nAt]) }, , "Aguarde, obtendo detalhes do item selecionado" ) }

// CARREGA AS LEGENDAS DO BROWSE DE PEDIDOS
@ 265,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 265,595 SAY "Pago" OF oPnlScroll Font oFnt  PIXEL

@ 285,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 285,595 SAY "A pagar" OF oPnlScroll Font oFnt PIXEL

@ 305,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 305,595 SAY "Vencido" OF oPnlScroll Font oFnt PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA PAINEL COM AS INFORMACOES DOS CREDITOS DO CLIENTE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPnlCredito:= TPanel():New(340,005, "",oPnlScroll, NIL, .T., .F., NIL, NIL,575,080, .T., .F. )

oPnlSup4:= TPanel():New(0, 0, "Cr้ditos do Cliente",oPnlCredito,oFnt, .F., .F., CLR_WHITE, NIL, 0,08, .F., .T. )
oPnlSup4:Align:= CONTROL_ALIGN_TOP
oPnlSup4:nClrPane:=RGB(0,0,0)

// FILTRA OS PEDIDOS DO CLIENTE SELECIONADO
FwMsgRun( ,{|| FILCRED(5) }, , "Filtrando cr้ditos , por favor aguarde..." )

oBrwCredito:= TWBrowse():New(000,000,000,000,,{"","Tipo","Valor","Saldo","Num.Tํtulo","Dt.Emissใo","Pedido","Forma de Pagamento","Loja de Origem","Usuแrio","SAC","Tipo NCC"},,oPnlCredito,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwCredito:SetArray(aCredito)
oBrwCredito:bLine := {|| { 	IF(aCredito[oBrwCredito:nAt,01] == "1",oSt1,IF(aCredito[oBrwCredito:nAt,01] == "2",oSt2,oSt3))						,;	// LEGENDA
aCredito[oBrwCredito:nAt,02] 													,;	// TIPO DO CREDITO
Transform(aCredito[oBrwCredito:nAt,03] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR
Transform(aCredito[oBrwCredito:nAt,04] ,PesqPict('SC6','C6_VALOR')) 			,;	// SALDO
aCredito[oBrwCredito:nAt,05] 													,;	// NUMERO TITULO - FINANCEIRO
DTOC(STOD(aCredito[oBrwCredito:nAt,06]))										,;	// DATA DE EMISSAO
aCredito[oBrwCredito:nAt,07] 													,;	// NUMERO DO PEDIDO QUE UTILIZOU O CREDITO
aCredito[oBrwCredito:nAt,08] 													,;	// FORMA DE PAGAMENTO [NOS CASOS DE RA]
aCredito[oBrwCredito:nAt,09] + " - " + ALLTRIM(aCredito[oBrwCredito:nAt,13])	,;	// LOJA DE ORIGEM
ALLTRIM(aCredito[oBrwCredito:nAt,10] )											,;	// USUARIO QUE FEZ O LANCAMENTO DO CREDITO
aCredito[oBrwCredito:nAt,11] 													,;	// NUMERO DO SAC
aCredito[oBrwCredito:nAt,12] + " - " + ALLTRIM(aCredito[oBrwCredito:nAt,14])	,;	// TIPO NCC
}}
oBrwCredito:Align:=CONTROL_ALIGN_ALLCLIENT

// CARREGA AS LEGENDAS DO BROWSE DE PEDIDOS
@ 350,585 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 350,595 SAY "Em aberto" OF oPnlScroll Font oFnt  PIXEL

@ 370,585 BITMAP oBmpPed2 ResName "BR_AMARELO" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 370,595 SAY "Parcialmente usado" OF oPnlScroll Font oFnt PIXEL

@ 390,585 BITMAP oBmpPed3 ResName "BR_VERMELHO_OCEAN" OF oPnlScroll Size 10,10 NoBorder When .F. Pixel
@ 390,595 SAY "Utilizados" OF oPnlScroll Font oFnt PIXEL

ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End() } , { || oTela:End() },, aButtons) 

IF lF12  
	
		U_SYTMOV06()                                                
	//EndIF
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILPED บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  14/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS PEDIDOS DO CLIENTE							    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILPED(nVezes)

Local cQuery  := ""
Local nLoop   := 1
Local cStatus := ""
Local cVlrTot := 0
Local cQuant  := 0

cQuery := " SELECT '' AS STS , C5_NUM, C5_NUMTMK, '' AS VALOR , '' AS QTDE, C5_MSFIL, C5_VEND1, C5_EMISSAO, C5_FECENT , C5_01SAC, A3_NOME, FILIAL, C2_NUM AS ORDEM_PRODUCAO, C2_DATPRF AS ENTREGA_OP, C2_PRODUTO AS PRODUTO_OP "
cQuery += " FROM " + RETSQLNAME("SC5") + " SC5 (NOLOCK)"
cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " SA3 (NOLOCK) ON A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN SM0010 SM0 (NOLOCK) ON FILFULL = C5_MSFIL "
cQuery += " LEFT JOIN " + RETSQLNAME("SC2") + " SC2 (NOLOCK) ON C2_PEDIDO = C5_NUM AND C2_SEQUEN='001' AND SC2.D_E_L_E_T_='' " //VERIFICA SE TEM ORDEM DE PRODUวรO E DEMONSTRA A ENTREGA
cQuery += " WHERE C5_FILIAL = '" + XFILIAL("SC5") + "' "
cQuery += " AND C5_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND C5_LOJACLI = '" + SA1->A1_LOJA + "' "  
//cQuery += " AND C2_ITEM ='01' " //CONSIDETA O ITEM 1 APENAS PARA EVITAR DUPLICIDADE DE LINHAS 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "

/*cQuery := " SELECT C6_01STATU, C6_NUM , C6_NUMTMK, SUM(C6_VALOR) AS VALOR, SUM(C6_QTDVEN) AS QTDE , C6_MSFIL, C5_VEND1, C5_EMISSAO, C5_FECENT , C5_01SAC, A3_NOME, FILIAL FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL "
cQuery += " AND C5_NUM = C6_NUM "
cQuery += " AND C5_CLIENTE = C6_CLI "
cQuery += " AND C5_LOJACLI = C6_LOJA "
cQuery += " LEFT JOIN " + RETSQLNAME("SA3") + " SA3 ON A3_COD = C5_VEND1 "
cQuery += " LEFT JOIN SM0010 SM0 ON FILFULL = C5_MSFIL "
cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
cQuery += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' "
cQuery += " AND C5_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND C5_LOJACLI = '" + SA1->A1_LOJA + "' "
cQuery += " AND C6_CLI = '" + SA1->A1_COD + "' "
cQuery += " AND C6_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SA3.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY C6_01STATU, C6_NUM , C6_NUMTMK, C6_MSFIL, C5_VEND1, C5_EMISSAO, C5_FECENT , C5_01SAC, A3_NOME, FILIAL "
cQuery += " ORDER BY C5_EMISSAO DESC "*/

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aPedidos[1,2])
		aPedidos := {}
	EndIF
	
	IF nLoop <= nVezes  //  1              2             3             4         5             6              7               8                 9              10            11             12             13                 14               15
		aAdd( aPedidos, { TRB->STS , TRB->C5_NUM , TRB->C5_NUMTMK, TRB->VALOR, TRB->QTDE , TRB->C5_MSFIL, TRB->C5_VEND1, TRB->C5_EMISSAO, TRB->C5_FECENT , TRB->C5_01SAC, TRB->A3_NOME, TRB->FILIAL, TRB->ORDEM_PRODUCAO, TRB->ENTREGA_OP, TRB->PRODUTO_OP } )
		nLoop++
	EndIF
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0                                                                                                                                                        
	TRB->(DbCloseArea())
EndIf

For nX:=1 To Len(aPedidos)
	cQuery := ""
	cQuery := " SELECT * FROM " + RETSQLNAME("SC6")
	cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") +  "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_NUM = '" + aPedidos[nX,2] + "' "
	cQuery += " AND C6_CLI = '" + SA1->A1_COD + "' "
	cQuery += " AND C6_LOJA = '" + SA1->A1_LOJA + "' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	While TRB->(!EOF())  
		
		IF TRB->C6_01STATU <> "1"
			cStatus := "2" 
		Else
			cStatus := "1"
		EndIF
	              
		cVlrTot := cVlrTot + TRB->C6_VALOR
		cQuant  := cQuant + TRB->C6_QTDVEN
	
		TRB->(DbSkip())
	EndDo  
	                     
	aPedidos[nX,1] := cStatus
	aPedidos[nX,4] := cVlrTot
	aPedidos[nX,5] := cQuant 
		              
	cVlrTot := 0
	cQuant  := 0
	cStatus := ""
		
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFILCRED บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  14/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS CREDITOS DO CLIENTE						    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILCRED(nVezes)

Local cQuery  := ""
Local cStatus := ""
Local nLoop   := 1

cQuery := " SELECT E1_TIPO, E1_VALOR, E1_SALDO, E1_NUM, E1_EMISSAO, '' AS PEDIDO, E1_FORMREC, E1_MSFIL, E1_USRNAME, E1_01SAC, E1_01MOTIV, FILIAL, X5_DESCRI FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " LEFT JOIN SM0010 ON FILFULL = E1_MSFIL "
cQuery += " INNER JOIN " + RETSQLNAME("SX5") + " SX5 ON X5_CHAVE = E1_01MOTIV "
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND X5_FILIAL = '" + XFILIAL("SX5") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_TIPO IN ('NCC','RA') "
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " AND SX5.D_E_L_E_T_ = ' ' "
cQuery += " AND X5_TABELA = 'O1' "
cQuery += " ORDER BY E1_EMISSAO DESC "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aCredito[1,2])
		aCredito := {}
	EndIF
	
	IF nLoop <= nVezes
		IF TRB->E1_SALDO = 0
			cStatus := "3"
		ELSEIF TRB->E1_SALDO = TRB->E1_VALOR
			cStatus := "1"
		Else
			cStatus := "2"
		EndIF
		aAdd( aCredito, { cStatus , TRB->E1_TIPO, TRB->E1_VALOR, TRB->E1_SALDO, TRB->E1_NUM, TRB->E1_EMISSAO, TRB->PEDIDO, TRB->E1_FORMREC, TRB->E1_MSFIL, TRB->E1_USRNAME, TRB->E1_01SAC, TRB->E1_01MOTIV, TRB->FILIAL, TRB->X5_DESCRI } )
		nLoop++
	EndIF
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILSAC บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  14/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS CHAMADOS NO SAC DO CLIENTE					    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILSAC(nVezes)

Local cQuery  := ""
Local nLoop   := 1
Local cStatus := ""

cQuery := " SELECT UC_STATUS, UC_CODIGO, UC_OPERADO, U7_NOME, UC_DATA, UC_INICIO, UC_01PED, UC_01FIL FROM " + RETSQLNAME("SUC") + " SUC "
cQuery += " INNER JOIN " + RETSQLNAME("SU7") + " SU7 ON U7_COD = UC_OPERADO "
cQuery += " WHERE SUC.UC_FILIAL = '" + XFILIAL("SUC") + "' "
cQuery += " AND SUC.D_E_L_E_T_ = ' ' "
cQuery += " AND SU7.D_E_L_E_T_ = ' ' "
cQuery += " AND UC_CHAVE = '" + SA1->A1_COD + SA1->A1_LOJA + "' "
cQuery += " ORDER BY UC_DATA DESC "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aSAC[1,2])
		aSAC := {}
	EndIF
	
	IF nLoop <= nVezes
		aAdd( aSAC, { IF(ALLTRIM(TRB->UC_STATUS)=="2","1","3"), TRB->UC_CODIGO, TRB->UC_OPERADO, TRB->U7_NOME, TRB->UC_DATA, TRB->UC_INICIO, RIGHT(TRB->UC_01PED,6) , TRB->UC_01FIL } )
		nLoop++
	EndIF
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VERIFICANDO OS DADOS SELECIONADOS PARA ATUALIZAR OS STATUS DO MESMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX:=1 To Len(aSAC)
	IF aSAC[nX,1] == "1"
		cQuery := ""
		cQuery := " SELECT UD_STATUS FROM " + RETSQLNAME("SUD")
		cQuery += " WHERE UD_FILIAL = '" + XFILIAL("SUD") + "' "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery += " AND UD_CODIGO = '" + aSAC[nX,2] + "' "
		
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
		
		While TMP->(!EOF())
			IF TMP->UD_STATUS == "1"
				cStatus := "1"
			ElseIF TMP->UD_STATUS == "2"
				cStatus := "2"
				Exit
			EndIF
			TMP->(DbSkip())
		EndDo
		
		aSAC[nX,1]   := cStatus
		cStatus 	 := ""
		
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
	EndIF
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILFIN บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  14/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ FILTRA OS DADOS FINANCEIROS DOS PEDIDOS				    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILFIN(nVezes)

Local cQuery  := ""
Local nLoop   := 1
Local cStatus := "1"

cQuery := " SELECT E1_PEDIDO, E1_EMISSAO, SUM(E1_VALOR) AS VALOR , E1_MSFIL, FILIAL FROM " + RETSQLNAME("SE1") + " SE1 "
cQuery += " LEFT JOIN SM0010 ON FILFULL = E1_MSFIL "
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_PEDIDO <> ' '  "
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " GROUP BY E1_PEDIDO, E1_EMISSAO, E1_MSFIL, FILIAL "
cQuery += " ORDER BY E1_EMISSAO DESC "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	IF EMPTY(aFinan[1,2])
		aFinan := {}
	EndIF
	
	IF nLoop <= nVezes
		aAdd( aFinan, { "1" , TRB->E1_PEDIDO, TRB->E1_EMISSAO, TRB->VALOR , TRB->E1_MSFIL, TRB->FILIAL } )
		nLoop++
	EndIF
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VERIFICANDO OS DADOS SELECIONADOS PARA ATUALIZAR OS STATUS DO MESMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX:=1 To Len(aFinan)
	cQuery := ""
	cQuery := " SELECT (CASE WHEN E1_SALDO = 0 THEN '1' ELSE "
	cQuery += " CASE WHEN E1_VENCREA >= '" + DtoS(dDataBase) + "' THEN '2' ELSE  "
	cQuery += " CASE WHEN  E1_VENCREA < '" + DtoS(dDataBase) + "' AND E1_SALDO <> 0 THEN '3' "
	cQuery += " END END END) AS SITUACAO "
	cQuery += " FROM" + RETSQLNAME("SE1")
	cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " AND E1_PEDIDO = '" + aFinan[nX,2] + "'
	cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
	cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	
	While TMP->(!EOF())
		IF TMP->SITUACAO == "1" .AND. cStatus = "1"
			cStatus := "1"
		ElseIF TMP->SITUACAO == "2" .AND. cStatus <> "2"
			cStatus := "2"
		ElseIF TMP->SITUACAO == "3"
			cStatus := "3"
			Exit
		EndIF
		TMP->(DbSkip())
	EndDo
	
	aFinan[nX,1] := cStatus
	cStatus 	 := "1"
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
Next

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  DETFINAN  บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  16/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ MOSTRA O DETALHE FINANCEIRO DO ITEM SELECIONADO		        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                 `
STATIC FUNCTION DETFINAN(aDados)

Local cQuery    := ""
Local aButtons  := {}
Local aInfo     := {{"","","","","","","","",0}}
Local oDlg, oPanel, oLogo, oFnt, oBrw

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FILTRA OS DADOS NO SE1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT E1_NUM, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_EMISSAO, E1_VENCREA, E1_VALOR, "
cQuery += " (CASE WHEN E1_SALDO = 0 THEN '1' ELSE "
cQuery += " CASE WHEN E1_VENCREA >= '" + DtoS(dDataBase) + "' THEN '2' ELSE  "
cQuery += " CASE WHEN  E1_VENCREA < '" + DtoS(dDataBase) + "' AND E1_SALDO <> 0 THEN '3' "
cQuery += " END END END) AS SITUACAO "
cQuery += " FROM" + RETSQLNAME("SE1")
cQuery += " WHERE E1_FILIAL = '" + XFILIAL("SE1") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND E1_PEDIDO = '" + aDados[2] + "'
cQuery += " AND E1_CLIENTE = '" + SA1->A1_COD + "' "
cQuery += " AND E1_LOJA = '" + SA1->A1_LOJA + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

While TMP->(!EOF())
	IF EMPTY(aInfo[1,2])
		aInfo := {}
	EndIF
	
	aAdd( aInfo , { TMP->SITUACAO, TMP->E1_NUM, TMP->E1_PREFIXO, TMP->E1_PARCELA, TMP->E1_TIPO, TMP->E1_NATUREZ, TMP->E1_EMISSAO, TMP->E1_VENCREA, TMP->E1_VALOR } )
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA COM AS INFORMACOES DETALHADAS DO PEDIDO SELECIONADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 600,800 TITLE "Detalhes do Cr้dito do Cliente" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

// TRAZ O LOGO DA KOMFORT
@ 035,340 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

// MONTA O PAINEL COM AS INFORMACOES DO CABECALHO
oPanel:= TPanel():New(035,005, "",oDlg, NIL, .T., .F., NIL, NIL,330,040, .T., .F. )
oPanel:NCLRPANE:=RGB(220,220,220)

@ 005,005 Say "Detalhes Financeiros do pedido : " + aDados[2] 							Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPanel
@ 020,005 Say "Data de Emissใo : " + DTOC(STOD(aDados[3]))	 							Size 100,010 Font oFnt 					Pixel Of oPanel
@ 020,100 Say "Valor Total : " + Transform(aDados[4] ,PesqPict('SC6','C6_VALOR')) 		Size 100,010 Font oFnt 					Pixel Of oPanel
@ 020,190 Say "Loja de Origem : " + ALLTRIM(aDados[5]) + " - " + ALLTRIM(aDados[6])	Size 100,010 Font oFnt 					Pixel Of oPanel

// MONTA O BROWSE COM OS DETALHES DO PEDIDO - FINANCEIRO
oBrw:= TWBrowse():New(090,005,390,200,,{"","N๚mero","Prefixo","Parcela","Tipo","Natureza","Dt.Emissใo","Dt.Vencimento Real","Valor"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(aInfo)
oBrw:bLine := {|| { IF(aInfo[oBrw:nAt,01] == "1",oSt1,IF(aInfo[oBrw:nAt,01] == "2",oSt2,oSt3)) 							,;	// LEGENDA
aInfo[oBrw:nAt,02] 													,;	// NUMERO DO TITULO
aInfo[oBrw:nAt,03] 													,;	// PREFIXO
aInfo[oBrw:nAt,04] 													,;	// PARCELA
aInfo[oBrw:nAt,05] 													,;	// TIPO
aInfo[oBrw:nAt,06] 													,;	// NATUREZA
DTOC(STOD(aInfo[oBrw:nAt,07]))										,;	// DATA DE EMISSAO
DTOC(STOD(aInfo[oBrw:nAt,08]))										,;	// DATA VENCIMENTO REAL
Transform(aInfo[oBrw:nAt,09] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR
}}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End() } , { || oDlg:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ   DETSAC   บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  16/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ MOSTRA O DETALHE DO CHAMADO (SAC) SELECIONADO		        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                 `
STATIC FUNCTION DETSAC(aDados)

Local cQuery    := ""
Local cDescAss  := ""
Local cDescProd := ""
Local cDescOcor := ""
Local cDescTpAc := ""
Local cNomeOper := ""
Local aButtons  := {}
Local aInfo     := {{"1","","","","","",0,0,"","","","","","","","","",""}}
Local oDlg, oPanel, oLogo, oFnt, oBrw

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FILTRA OS DADOS NO SUD ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT UD_STATUS, UD_ASSUNTO, '' AS DESC_ASSUNTO, UD_PRODUTO, '' AS DESC_PRODUTO, UD_01PEDID, UD_01QTDVE, UD_01PRCVE, UD_OCORREN, '' AS DESC_OCORREN, "
cQuery += " UD_01TIPO, '' AS DESC_TIPO, UD_01DEFEI, UD_01DESDE, UD_OPERADO, '' AS DESC_OPERADO, UD_OBSWKF, UD_DATA  FROM " + RETSQLNAME("SUD")
cQuery += " WHERE UD_FILIAL = '" + XFILIAL("SUD") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND UD_CODIGO ='" + aDados[2] + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

While TMP->(!EOF())
	IF EMPTY(aInfo[1,2])
		aInfo := {}
	EndIF
	
	cDescAss  := POSICIONE("SX5",1,XFILIAL("SX5") + "T1" + TMP->UD_ASSUNTO,"X5_DESCRI")
	cDescProd := POSICIONE("SB1",1,XFILIAL("SB1") + TMP->UD_PRODUTO,"B1_DESC")
	cDescOcor := POSICIONE("SU9",1,XFILIAL("SU9") + TMP->UD_ASSUNTO + TMP->UD_OCORREN,"U9_DESC")
	cDescTpAc := POSICIONE("Z01",1,XFILIAL("Z01") + TMP->UD_01TIPO,"Z01_DESC")
	cNomeOper := POSICIONE("SU7",1,XFILIAL("Z01") + TMP->UD_OPERADO,"U7_NOME")
	
	aAdd( aInfo , { TMP->UD_STATUS, TMP->UD_ASSUNTO, cDescAss, TMP->UD_PRODUTO, cDescProd, TMP->UD_01PEDID, TMP->UD_01QTDVE, TMP->UD_01PRCVE, TMP->UD_OCORREN, cDescOcor, TMP->UD_01TIPO, cDescTpAc, TMP->UD_01DEFEI, TMP->UD_01DESDE, TMP->UD_OPERADO, cNomeOper, TMP->UD_OBSWKF, TMP->UD_DATA} )
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA COM AS INFORMACOES DETALHADAS DO PEDIDO SELECIONADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 600,800 TITLE "Detalhes do Chamado SAC" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

// TRAZ O LOGO DA KOMFORT
@ 035,340 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

// MONTA O PAINEL COM AS INFORMACOES DO CABECALHO
oPanel:= TPanel():New(035,005, "",oDlg, NIL, .T., .F., NIL, NIL,330,040, .T., .F. )
oPanel:NCLRPANE:=RGB(220,220,220)

@ 005,005 Say "Detalhes do Chamado [SAC] : " + aDados[2] 		Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPanel
@ 015,005 Say "Data de Abertura : " + DTOC(STOD(aDados[5]))	Size 100,010 Font oFnt 					Pixel Of oPanel
@ 015,100 Say "Hora de Abertura : " + aDados[6] 				Size 100,010 Font oFnt 					Pixel Of oPanel
@ 015,190 Say "Loja de Origem : " + aDados[8]					Size 100,010 Font oFnt 					Pixel Of oPanel
@ 025,005 Say "Operador : " + aDados[3] + " - " + ALLTRIM(aDados[4])	Size 200,010 Font oFnt 					Pixel Of oPanel

// MONTA O BROWSE COM OS DETALHES DO PEDIDO - FINANCEIRO
oBrw:= TWBrowse():New(090,005,390,200,,{"","Assunto","Produto","Pedido Original","Qtde.Vendida","Pre็o","Ocorrencia","Tipo A็ใo","Defeito","Responsแvel","OBS WorkFlow","Data Abertura"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(aInfo)
oBrw:bLine := {|| { IF(aInfo[oBrw:nAt,01] == "1",oSt1,oSt3) 							,;	// LEGENDA
ALLTRIM(aInfo[oBrw:nAt,02]) + " - " + ALLTRIM(aInfo[oBrw:nAt,03])	,;	// ASSUNTO - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,04]) + " - " + ALLTRIM(aInfo[oBrw:nAt,05])	,;	// PRODUTO - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,06]) 										,;	// PEDIDO ORIGINAL
Transform(aInfo[oBrw:nAt,07] ,PesqPict('SC6','C6_QTDVEN')) 		,;	// QUANTIDADE VENDIDA NO PEDIDO ORIGINAL
Transform(aInfo[oBrw:nAt,08] ,PesqPict('SC6','C6_VALOR')) 			,;	// PRECO DE VENDA NO PEDIDO ORIGINAL
ALLTRIM(aInfo[oBrw:nAt,09]) + " - " + ALLTRIM(aInfo[oBrw:nAt,10])	,;	// OCORRENCIA - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,11]) + " - " + ALLTRIM(aInfo[oBrw:nAt,12])	,;	// TIPO DE ACAO - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,13]) + " - " + ALLTRIM(aInfo[oBrw:nAt,14])	,;	// DEFEITO - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,15]) + " - " + ALLTRIM(aInfo[oBrw:nAt,16])	,;	// OPERADOR - CODIGO + DESCRICAO
ALLTRIM(aInfo[oBrw:nAt,17]) 										,;	// OBSERVACAO DO WORKFLOW
DTOC(STOD(aInfo[oBrw:nAt,18])) 									,;	// DATA DE ABERTURA DO ITEM NO CHAMADO
}}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End() } , { || oDlg:End() },, aButtons)

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DETPEDIDO  บ Autor ณ Luiz Eduardo F.C.  บ Data ณ  16/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ MOSTRA O DETALHE DO PEDIDO SELECIONADO		                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                 `
STATIC FUNCTION DETPEDIDO(aDados)
                                   
Local cQuery    := ""
Local cDescAss  := ""
Local cDescProd := ""
Local cDescOcor := ""
Local cDescTpAc := ""
Local cNomeOper := ""
Local aButtons  := {}
Local aInfo     := {{"","","","",0,"",0,0,"",""}}
Local aArea		:= GetArea()  
Local aAreaSC5  := SC5->(GetArea())
Local oDlg, oPanel, oLogo, oFnt, oBrw 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ POSICIONA NO PEDIDO SELECIONADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbGoTop())
SC5->(DbSeek(XFilial("SC5") + aDados[2]))   

AAdd(aButtons,{	'',{|| U_SYTMOV12(SC5->(RecNo())) }, "Visualizar Pedido <F6>"} )
AAdd(aButtons,{	'',{|| VisualSUC(aDados[10])  }, "Visualizar Chamado SAC <F7>"} )   

SetKey( VK_F6 , { || U_SYTMOV12(SC5->(RecNo())) } )
SetKey( VK_F7 , { || VisualSUC(aDados[10]) } )

cQuery := " SELECT DISTINCT C6_01STATU, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_LOCAL, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_ENTREG, '' AS DT_ENTREGA_FOR, "
cQuery += " C2_NUM AS ORDEM_PRODUCAO,C2_DATPRF AS ENTREGA_OP " 
cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " LEFT JOIN SC2010 SC2  ON C2_PEDIDO = C6_NUM AND SC2.D_E_L_E_T_='' "
cQuery += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
cQuery += " AND SC6.D_E_L_E_T_ = '  ' "
cQuery += " AND C6_CLI = '" + SA1->A1_COD + "' "
cQuery += " AND C6_LOJA = '" + SA1->A1_LOJA + "' "
cQuery += " AND C6_NUM = '" + aDados[2] + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
                                                                                                                     
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

While TMP->(!EOF())
	IF EMPTY(aInfo[1,2])
		aInfo := {}
	EndIF
	              //  1                  2                3                4            5              6                  7             8            9                     10                 11                   12
	aAdd( aInfo , { TMP->C6_01STATU, TMP->C6_ITEM, TMP->C6_PRODUTO, TMP->C6_DESCRI, TMP->C6_LOCAL, TMP->C6_QTDVEN, TMP->C6_PRCVEN, TMP->C6_VALOR, TMP->C6_ENTREG, TMP->DT_ENTREGA_FOR, TMP->ORDEM_PRODUCAO, TMP->ENTREGA_OP} )
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA COM AS INFORMACOES DETALHADAS DO PEDIDO SELECIONADO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 600,800 TITLE "Detalhes dos itens do pedido" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

// TRAZ O LOGO DA KOMFORT
@ 035,340 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oDlg PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

// MONTA O PAINEL COM AS INFORMACOES DO CABECALHO
oPanel:= TPanel():New(035,005, "",oDlg, NIL, .T., .F., NIL, NIL,330,040, .T., .F. )
oPanel:NCLRPANE:=RGB(220,220,220)

@ 005,005 Say "Pedido : " + aDados[2] 		Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPanel
@ 015,005 Say "Data de Emissใo : " + DTOC(STOD(aDados[8]))	Size 100,010 Font oFnt 					Pixel Of oPanel
@ 015,100 Say "Valor Total : " + Transform(aDados[4] ,PesqPict('SC6','C6_VALOR')) 				Size 100,010 Font oFnt 					Pixel Of oPanel
@ 015,190 Say "Loja de Origem : " + aDados[6] + " - " + ALLTRIM(aDados[12])					Size 100,010 Font oFnt 					Pixel Of oPanel
@ 025,005 Say "Vendedor : " + aDados[7] + " - " + ALLTRIM(aDados[11])	Size 200,010 Font oFnt 					Pixel Of oPanel

// MONTA O BROWSE COM OS DETALHES DO PEDIDO
oBrw:= TWBrowse():New(090,005,390,200,,{"","Item","C๓digo","Descri็ใo","Qtde","Armazem","Valor Unitแrio","Valor Total","Data Prevista Entrega Cliente","Data Prevista Entrega Fornecedor","Ordem_Producao","Dt_Entrega_OP"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(aInfo)
oBrw:bLine := {|| { IF(aInfo[oBrw:nAt,01] == "1",oSt1,oSt3) 		,;	// LEGENDA
ALLTRIM(aInfo[oBrw:nAt,02]) 										,;	// ITEM DO PEDIDO DE VENDA        
ALLTRIM(aInfo[oBrw:nAt,03]) 										,;	// CODIGO DO PRODUTO
ALLTRIM(aInfo[oBrw:nAt,04]) 										,;	// DESCRICAO
Transform(aInfo[oBrw:nAt,06] ,PesqPict('SC6','C6_QTDVEN')) 			,;	// QUANTIDADE VENDIDA
ALLTRIM(aInfo[oBrw:nAt,05]) 										,;	// ARMAZEM DE SAIDA              
Transform(aInfo[oBrw:nAt,07] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR UNITARIO
Transform(aInfo[oBrw:nAt,08] ,PesqPict('SC6','C6_VALOR')) 			,;	// VALOR TOTAL
DTOC(STOD(aInfo[oBrw:nAt,09])) 										,;	// DATA ENTREGA CLIENTE
DTOC(STOD(aInfo[oBrw:nAt,10])) 										,;	// DATA ENTREGA FORNECEDOR
ALLTRIM(aInfo[oBrw:nAt,11])											,;	// NUMERO DA OP
DTOC(STOD(aInfo[oBrw:nAt,12]))										,;	// DATA ENTREGA OP  
}}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End() } , { || oDlg:End() },, aButtons)    

RestArea(aArea) 
RestArea(aAreaSC5)

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VisualSUC  บ Autor ณ Eduardo Patriani   บ Data ณ  05/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ VISUALIZA O CHAMADO DO PEDIDO.         		                บฑฑ      
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                 
Static Function VisualSUC(cNumSAC)

Local nRecno := 0

If Empty(cNumSAC)
	MsgInfo("Este pedido nใo possui nenhum chamado vinculado.","Aten็ใo")
	Return
EndIF

INCLUI := .F.

DbSelectArea("SUC")
DbSetOrder(1)
DbSeek(xFilial("SUC") + cNumSAC )
nRecno := SUC->(Recno())

TK271CallCenter("SUC",nRecno,2)

Return