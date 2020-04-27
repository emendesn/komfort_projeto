#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#DEFINE CRLF	   CHR(10)+CHR(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYTMOV01 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  31/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA PARA AGENDAMENTOS DE PEDIDOS                          บฑฑ
ฑฑบ          ณ 29.12.2017 - FIZ TESTES E SIMULACOES REFERENTE AO ID K007  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYTMOV01()

Local cQuery    := ""
Local aSize     := MsAdvSize()
Local aButtons  := {}
Local aLojas    := {}                                                                              
Local cPedido   := SPACE(06)                                                                       
Local aPergunta := {}   
Local lF12      := .F.
Local cPesqPed  := SPACE(06)

Private aPedidos := {}
Private aItens   := {}
Private oSt1     := LoadBitmap(GetResources(),'BR_VERDE')
Private oSt2     := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oTela, oBrwPedido, oBrwItens

Private aTerRet := {}
Private _cAtend := ""
Private aTermAgend := {}
Private dDataAgTerm := dDataBase

DbSelectArea("SM0")
aLojas := {}
SM0->(DbGoTop())
While SM0->(!EOF())
	aAdd( aLojas , { ALLTRIM(SM0->M0_CODFIL) , ALLTRIM(SM0->M0_FILIAL)} )
	SM0->(DbSkip())
EndDo                                                                                      

AAdd(aButtons,{"S4WB016N",{||IIF (MsgYesno("Deseja Fazer Nova Pesquisa?"),(oTela:End() , lF12 := .T. ),)},"Nova Pesquisa <F12>","Nova Pesquisa <F12>",,})	//"Help"
SetKey( VK_F12 , { || IIF (MsgYesno("Deseja Fazer Nova Pesquisa?"),(oTela:End() , lF12 := .T. ),)} )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ RETIRAR DA QUERY TODO O RELACIONAMENTO  COM O SC9 - LUIZ EDUARDO F.C. - 28.08.2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_MSFIL FROM " + RETSQLNAME("SC5") + " SC5 "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = C5_CLIENTE "
cQuery += " AND A1_LOJA = C5_LOJACLI "
cQuery += " INNER JOIN " + RETSQLNAME("SC9") + " SC9 ON C9_PEDIDO = C5_NUM "
cQuery += " AND C9_CLIENTE = C5_CLIENTE "
cQuery += " AND C9_LOJA = C5_LOJACLI "
cQuery += " INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL "
cQuery += " AND C6_NUM = C5_NUM
cQuery += " AND C6_CLI = C5_CLIENTE
cQuery += " AND C6_LOJA = C5_LOJACLI
cQuery += " WHERE C5_FILIAL <> ' ' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND SC9.D_E_L_E_T_ = ' ' "
cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND A1_01PEDFI <> '1' "
cQuery += " AND C6_NOTA = ' '
cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO,  C5_MSFIL*/

Aadd(aPergunta,{PadR("SYTMOV01",10),"01","Filial de  ?" 			,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","","SM0",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"02","Filial at้  ?" 			,"MV_CH02" ,"C",004,00,"G","MV_PAR02",""     ,""      ,""			,"","","SM0",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"03","Data Abertura de ?"		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("SYTMOV01",10),"04","Data Abertura at้ ?"		,"MV_CH04" ,"D",008,00,"G","MV_PAR04",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("SYTMOV01",10),"05","Cliente de  ?" 			,"MV_CH05" ,"C",006,00,"G","MV_PAR05",""     ,""      ,""			,"","","SA1",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"06","Loja Cliente de  ?"		,"MV_CH06" ,"C",002,00,"G","MV_PAR06",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"07","Cliente at้  ?" 			,"MV_CH07" ,"C",006,00,"G","MV_PAR07",""     ,""      ,""			,"","","SA1",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"08","Loja Cliente at้  ?"		,"MV_CH08" ,"C",002,00,"G","MV_PAR08",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"09","CPF/CNPJ Cliente de ?" 	,"MV_CH09" ,"C",014,00,"G","MV_PAR09",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"10","CPF/CNPJ Cliente at้ ?" 	,"MV_CH10" ,"C",014,00,"G","MV_PAR10",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"11","Pedido de  ?" 			,"MV_CH11" ,"C",006,00,"G","MV_PAR11",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"12","Pedido at้  ?" 			,"MV_CH12" ,"C",006,00,"G","MV_PAR12",""     ,""      ,""			,"","","",""			})
Aadd(aPergunta,{PadR("SYTMOV01",10),"13","Data Entrega de ?"		,"MV_CH13" ,"D",008,00,"G","MV_PAR13",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("SYTMOV01",10),"14","Data Entrega at้ ?"		,"MV_CH14" ,"D",008,00,"G","MV_PAR14",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPergunta,{PadR("SYTMOV01",10),"15","Agendado ?"				,"MV_CH15" ,"N",001,00,"C","MV_PAR15","TODOS"     ,"SIM"      ,"NAO"			,"","",""	,""   		})

VldSX1(aPergunta)
If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C5_MSFIL, C5_01SAC FROM " + RETSQLNAME("SC5") + " SC5 " +CRLF
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = C5_CLIENTE " +CRLF
cQuery += " AND A1_LOJA = C5_LOJACLI " +CRLF
cQuery += " INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL " +CRLF
cQuery += " AND C6_NUM = C5_NUM "+CRLF 
cQuery += " AND C6_CLI = C5_CLIENTE "+CRLF
cQuery += " AND C6_LOJA = C5_LOJACLI "+CRLF
cQuery += " WHERE C5_FILIAL <> ' ' " +CRLF
cQuery += " AND SC5.D_E_L_E_T_ = ' ' " +CRLF
cQuery += " AND SA1.D_E_L_E_T_ = ' ' " +CRLF
cQuery += " AND SC6.D_E_L_E_T_ = ' ' " +CRLF
cQuery += " AND A1_01PEDFI <> '1' " +CRLF
cQuery += " AND C5_PEDPEND <> '2'" +CRLF	//#AFD20180413.n
cQuery += " AND C6_NOTA = ' '"  +CRLF  
cQuery += " AND C6_BLQ <> 'R'"+CRLF
cQuery += " AND C5_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " +CRLF
cQuery += " AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' " +CRLF
cQuery += " AND C5_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' " +CRLF
cQuery += " AND C5_LOJACLI BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR08 + "' " +CRLF
cQuery += " AND A1_CGC BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' " +CRLF
cQuery += " AND C5_NUM BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' " +CRLF   
If !Empty(MV_PAR13) .OR. !Empty(MV_PAR14)  
	cQuery += " AND C6_ENTREG BETWEEN '" + DTOS(MV_PAR13) + "' AND '" + DTOS(MV_PAR14) + "' "  +CRLF
Endif
If MV_PAR15 <> 1
	Iif ( MV_PAR15 == 2, cQuery += " AND C6_01AGEND = '1' ",  cQuery += " AND C6_01AGEND = '2' " )   	
Endif 
cQuery += " AND C5_XCONPED = '1' " +CRLF // TRAZ SOMENTE OS PEDIDOS CONFERIDOS - LUIZ EDUARDO F.C. - 01.02.2018  
cQuery += " GROUP BY C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO,  C5_MSFIL, C5_01SAC" +CRLF

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

TRB->(DbGoTop())
While TRB->(!EOF())
	aAdd( aPedidos , { '' ,;
						TRB->C5_NUM,;
						TRB->C5_CLIENTE,;
						TRB->C5_LOJACLI,;
						TRB->A1_NOME,;
						aLojas[Ascan(aLojas,{|x| Alltrim(x[1]) == TRB->C5_MSFIL}),2],;
						TRB->C5_EMISSAO,;
						TRB->C5_MSFIL,;
						iif(fTerRetPed(TRB->C5_01SAC),"SIM","NรO"),;
						TRB->C5_01SAC } )
	TRB->(DbSkip())
EndDo

If Len(aPedidos)==0
	MsgInfo("Nใo existem pedidos para serem agendados.","Aten็ใo")
	RETURN()
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA A TELA PRINCIPAL DE AGENDAMENTO DE PEDIDOS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Agendamento de Pedidos" Of oMainWnd PIXEL

oPanel:= TPanel():New(000,000,,oTela, NIL, .T., .F., NIL, NIL,000,000, .T., .F. )
oPanel:Align:=CONTROL_ALIGN_ALLCLIENT

oPnlSup:= TPanel():New(000,000,,oPanel, NIL, .T., .F., NIL, NIL,600,140, .T., .F. )
oPnlInf:= TPanel():New(150,000,,oPanel, NIL, .T., .F., NIL, NIL,600,122, .T., .F. )

oBrwPedido:= TwBrowse():New(005, 005, 200, 150,, {'Pedido','Cod.Cliente','Cliente','Loja Origem','Dt.Emissใo','Troca'},,oPnlSup,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
oBrwPedido:SetArray(aPedidos)
oBrwPedido:bLine      := {|| {  aPedidos[oBrwPedido:nAt,02] ,;
aPedidos[oBrwPedido:nAt,03] + " - " + aPedidos[oBrwPedido:nAt,04] ,;
aPedidos[oBrwPedido:nAt,05] ,;
aPedidos[oBrwPedido:nAt,06] ,;
DTOC(STOD(aPedidos[oBrwPedido:nAt,07])),;
aPedidos[oBrwPedido:nAt,09]  }}
oBrwPedido:bChange    := {|| FILITENS(aPedidos[oBrwPedido:nAt]) }
oBrwPedido:bLDblClick := {|| TELMANU(aPedidos[oBrwPedido:nAt])  }
oBrwPedido:Align      := CONTROL_ALIGN_ALLCLIENT

oBrwItens:= TwBrowse():New(005, 005, 200, 150,, {'','Item','Codigo','Descri็ใo','Quantidade','Armazem','Dt.Entrega','Qtd.Estoque','Itens Liberados Estoque','Tipo Produto','Termo Retira'},,oPnlInf,,,,,,,,,,,, .F.,, .T.,, .T.,,,)//#AFD27062018.N
oBrwItens:SetArray(aItens)
oBrwItens:bLine := {|| { 	IF(	aItens[oBrwItens:nAt,01] == "1",oSt1,oSt2) ,;
aItens[oBrwItens:nAt,02] ,;
aItens[oBrwItens:nAt,03] ,;
aItens[oBrwItens:nAt,04] ,;
Transform(aItens[oBrwItens:nAt,05],PesqPict('SC6','C6_QTDVEN')) ,;
aItens[oBrwItens:nAt,06] ,;
aItens[oBrwItens:nAt,07] ,;
Transform(aItens[oBrwItens:nAt,08],PesqPict('SB2','B2_QATU')) ,;
aItens[oBrwItens:nAt,09] ,;
aItens[oBrwItens:nAt,10] ,;
aItens[oBrwItens:nAt,11]}}//#AFD27062018.N
oBrwItens:Align:= CONTROL_ALIGN_ALLCLIENT
oBrwItens:bLDblClick := {|| iif(oBrwItens:ColPos==11,fTerRet(_cAtend, aTerRet),AGENDITEM(aItens[oBrwItens:nAt]))  }


// CARREGA AS LEGENDAS DO BROWSE DE CHAMADOS DO SAC

@ 160,605 BITMAP oBmpPed1 ResName "BR_VERDE" OF oPanel Size 10,10 NoBorder When .F. Pixel
@ 160,615 SAY "Produto Agendado" OF oPanel PIXEL

@ 170,605 BITMAP oBmpPed1 ResName "BR_VERMELHO" OF oPanel Size 10,10 NoBorder When .F. Pixel
@ 170,615 SAY "Produto nใo Agendado" OF oPanel PIXEL

// Botao removido temporariamente 05.06.2018
//@ 005,605 BUTTON "&Libera Estoque" SIZE 50,15 OF oPanel PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Agendamento de Entrega - KOMFORT HOUSE - Libera Estoque" , LibEstoque(oBrwItens) }, , "Analisando item , por favor aguarde..." )  }

@ 035,605 MSGET cPesqPed PICTURE PesqPict('SC5','C5_NUM') OF oPanel PIXEL SIZE 050,015
@ 055,605 BUTTON "&Pesquisar Pedido" SIZE 50,15 OF oPanel PIXEL ACTION {|| PesqPed(cPesqPed)  }   

@ 085,605 BUTTON "&Itens Agendados" SIZE 50,15 OF oPanel PIXEL ACTION {|| ITAGEND()  }   

//@ 030,605 MSGET cPedido SIZE 50,10  OF oPanel PIXEL When .T.
//@ 050,605 BUTTON "&Pesquisar Pedido" SIZE 50,15 OF oPanel PIXEL ACTION {|| FwMsgRun( ,{|| cCadastro := "Agendamento de Entrega - KOMFORT HOUSE - Libera Estoque" , LibEstoque(oBrwItens) }, , "Analisando item , por favor aguarde..." )  }

FILITENS(aPedidos[oBrwPedido:nAt])

ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || IIF(Confirma(),oTela:End(),Msgstop("Nao ้ possํvel finalizar o agendamento do tipo bipartido incompleto")) } , { || oTela:End() },, aButtons)

IF lF12  	
		U_SYTMOV01()                                                
	//EndIF
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILITENS บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  01/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza o painel que exibe os detalhes do pedido          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILITENS(aDados)

Local cQuery  	:= ""
Local cEstoque 	:= ""
Local cArmazem  := ""
Local nEstoque  := 0
Local cFilOld   := cFilAnt

IF Left(aDados[8],2) == "01"
	cArmazem := GetMv("KM_ARMZCD1")
ElseIF Left(aDados[8],2) == "02"
	cArmazem := GetMv("KM_ARMZCD3")
Else
	cArmazem := "0101"
EndIF

aItens := {}

/*cQuery := " SELECT
cQuery += " 		C6_ITEM"
cQuery += " 		,C6_PRODUTO"
cQuery += " 		,C6_DESCRI"
cQuery += " 		,C6_QTDVEN"
cQuery += " 		,C6_LOCAL"
cQuery += " 		,C6_PRCVEN"
cQuery += " 		,C6_VALOR"
cQuery += " 		,C6_ENTREG"
cQuery += " 		,C6_SALDO"
cQuery += " 		,C6_NUM"
cQuery += " 		,C6_NUMTMK"
cQuery += " 		,C6_01AGEND"
cQuery += " 		,MAX(C9_SEQUEN) C9_SEQUEN"
cQuery += " 		,C9_PEDIDO"
cQuery += " 		,B2_QATU"
cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 "

cQuery += " INNER JOIN  " + RETSQLNAME("SC9") + " SC9 (NOLOCK) ON C9_FILIAL = C6_FILIAL "
cQuery += " 	AND C9_PEDIDO 		= C6_NUM "
cQuery += " 	AND C9_ITEM 		= C6_ITEM "
cQuery += " 	AND C9_PRODUTO 		= C6_PRODUTO "
cQuery += " 	AND C9_CLIENTE 		= C6_CLI "
cQuery += " 	AND C9_LOJA 		= C6_LOJA "
cQuery += " 	AND SC9.D_E_L_E_T_ 	= ' ' "

cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON B1_FILIAL = '"+XFILIAL("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "

cQuery += " LEFT JOIN " +  RETSQLNAME("SB2") + " SB2 (NOLOCK) ON B2_FILIAL='0101' AND B2_COD=C6_PRODUTO AND B2_LOCAL=B1_LOCPAD AND SB2.D_E_L_E_T_ =  ' ' "

cQuery += " WHERE
cQuery += " 	C6_FILIAL 		= '" + XFILIAL("SC6") + "' AND "
cQuery += " 	C9_FILIAL 		= '" + XFILIAL("SC9") + "' AND "
cQuery += " 	C6_NUM 			= '" + aDados[2] + "' AND "
cQuery += " 	C6_CLI 			= '" + aDados[3] + "' AND "
cQuery += " 	C6_LOJA 		= '" + aDados[4] + "' AND "
cQuery += " 	C6_NOTA 		= ' ' AND "
cQuery += " 	SC6.D_E_L_E_T_ 	= ' '

cQuery += " GROUP BY "
cQuery += "		C6_ITEM "
cQuery += "		,C6_PRODUTO "
cQuery += "		,C6_DESCRI "
cQuery += "		,C6_QTDVEN "
cQuery += "		,C6_LOCAL "
cQuery += "		,C6_PRCVEN "
cQuery += "		,C6_VALOR "
cQuery += "		,C6_ENTREG "
cQuery += "		,C6_SALDO "
cQuery += "		,C6_NUM "
cQuery += "		,C6_NUMTMK "
cQuery += "		,C6_01AGEND "
cQuery += " 	,C9_PEDIDO "
cQuery += " 	,B2_QATU"

cQuery += " ORDER BY C6_ENTREG "  */

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ RETIRAR TODO RELCIONAMENTO COM A TABELA SC9 - LUIZ EDUARDO F.C. - 28.08.2017 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*cQuery := " SELECT C6_ITEM , C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_SALDO, C6_ENTREG, C6_SALDO, "
cQuery += " C6_NUM, C6_NUMTMK, C6_01AGEND, MAX(C9_SEQUEN) C9_SEQUEN, C9_PEDIDO, B2_QATU "
cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " INNER JOIN " + RETSQLNAME("SC9") + " SC9 (NOLOCK) ON C9_FILIAL = C6_FILIAL "
cQuery += " AND C9_PEDIDO 		= C6_NUM  "
cQuery += " AND C9_ITEM 		= C6_ITEM "
cQuery += " AND C9_PRODUTO 		= C6_PRODUTO "
cQuery += " AND C9_CLIENTE 		= C6_CLI "
cQuery += " AND C9_LOJA 		= C6_LOJA "
cQuery += " AND SC9.D_E_L_E_T_ 	= ' ' "
cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON B1_FILIAL = '  ' "
cQuery += " AND B1_COD = C6_PRODUTO "
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " LEFT JOIN " + RETSQLNAME("SB2") + " SB2 (NOLOCK) ON B2_FILIAL='" + cArmazem + "' "
cQuery += " AND B2_COD=C6_PRODUTO "
cQuery += " AND B2_LOCAL=B1_LOCPAD "
cQuery += " AND SB2.D_E_L_E_T_ =  ' ' "
cQuery += " WHERE C6_FILIAL <> ' ' "
cQuery += " AND C9_FILIAL <> ' ' "
cQuery += " AND C6_NUM = '" + aDados[2] + "' "
cQuery += " AND C6_CLI = '" + aDados[3] + "' "
cQuery += " AND C6_LOJA = '" + aDados[4] + "' "
cQuery += " AND C6_NOTA = ' ' "
cQuery += " AND SC6.D_E_L_E_T_ 	= ' ' "
cQuery += " GROUP BY C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_SALDO, C6_NUM, C6_NUMTMK, "
cQuery += " C6_01AGEND, C9_PEDIDO, B2_QATU "*/

//cQuery := " SELECT C6_ITEM , C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_SALDO, C6_NUM, C6_01AGEND, B2_LOCAL, B2_QATU "
//cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 "
//cQuery += " INNER JOIN " + RETSQLNAME("SB2") + " SB2 ON B2_COD = C6_PRODUTO "
//cQuery += " AND B2_LOCAL = C6_LOCAL "
//cQuery += " AND B2_FILIAL = '" + cArmazem + "' "
//cQuery += " WHERE C6_FILIAL <> ' ' "
//cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
//cQuery += " AND SB2.D_E_L_E_T_ =  ' ' "
//cQuery += " AND C6_NOTA = ' ' "
//cQuery += " AND C6_NUM = '" + aDados[2] + "' "
//cQuery += " AND C6_CLI = '" + aDados[3] + "' "
//cQuery += " AND C6_LOJA = '" + aDados[4] + "' "

cQuery := " SELECT C6_ITEM , C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_SALDO, C6_NUM, C6_01AGEND, C6_FILIAL, C6_CLI, C6_LOJA, C6_NUM, C6_NUMTMK, C6_MSFIL, C6_XNUMSC"//#AFD27062018.N
cQuery += " FROM " + RETSQLNAME("SC6")
cQuery += " WHERE C6_FILIAL <> ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND C6_BLQ <> 'R'"
cQuery += " AND C6_NOTA = ' ' "
cQuery += " AND C6_NUM = '" + aDados[2] + "' "
cQuery += " AND C6_CLI = '" + aDados[3] + "' "
cQuery += " AND C6_LOJA = '" + aDados[4] + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())
While TMP->(!EOF())
	
	cEstoque := ""
	cTipoProd := ""
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ BUSCA SALDO DO PRODUTO NO SB2 - LUIZ EDUARDO F.C. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	IF SB2->(DbSeek(cArmazem + TMP->C6_PRODUTO + TMP->C6_LOCAL ))
		//nEstoque := SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QPEDVEN)//#AFD27062018.O
		nEstoque := SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QEMP + SB2->B2_QACLASS) //#AFD27062018.N
	Else		
		cFilAnt  := cArmazem		
		CRIASB2(TMP->C6_PRODUTO, TMP->C6_LOCAL)		
		cFilAnt  := cFilOld	
		nEstoque := 0	
	EndIF
	
	DbSelectArea("SC9")
	SC9->(DbSetOrder(2))
	if SC9->(DbSeek(TMP->C6_FILIAL+TMP->C6_CLI+TMP->C6_LOJA+TMP->C6_NUM+TMP->C6_ITEM))
		cEstoque := iif(Empty(alltrim(SC9->C9_BLEST)),"SIM","NAO")	
	endif

	//#AFD27062018.BN
	dbselectArea("SUB")
	SUB->(dbsetorder(1))
	if SUB->(dbseek(TMP->C6_MSFIL+alltrim(substr(TMP->C6_NUMTMK,5,10))+TMP->C6_ITEM+TMP->C6_PRODUTO))
		cTipoProd := SUB->UB_MOSTRUA
	else
		cTipoProd := '0'
	endif

	Do Case
		case cTipoProd == '1'
			cDescTipo := "Pe็a Nova Loja"
		case cTipoProd == '2' 
			cDescTipo := "Mostruario"
		case cTipoProd == '3'
			cDescTipo := "Personalizado"
		case cTipoProd == '4'  	
			cDescTipo := "Acess๓rio"
		case cTipoProd == '5'  	//WRP20181107 INCLUSรO SALDรO
			 cDescTipo := "Saldใo"
		otherwise
			cDescTipo := ""		
	endcase
	//#AFD27062018.EN
    
	cQuery := "SELECT ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_CLI, ZK0_LJCLI, ZK0_DTAGEN FROM "+retSqlName("ZK0")+" ZK0"
	cQuery += " INNER JOIN "+retSqlName("SUC")+" UC ON ZK0.ZK0_NUMSAC = UC.UC_CODIGO"
	cQuery += " AND UC_CODIGO = '"+aDados[10]+"'"
	cQuery += " AND ZK0.ZK0_CARGA = ''"
	cQuery += " AND ZK0.D_E_L_E_T_ = ' '"
	cQuery += " AND UC.D_E_L_E_T_ = ' '"
	
	cAlias := getNextAlias()
	plsQuery(cQuery,cAlias)
	
	aTerRet := {}
	_cAtend := aDados[10] // Numero do Atendimento SAC
			
	while (cAlias)->(!eof())
		
		aAdd(aTerRet,{;
						(cAlias)->ZK0_COD,;
						(cAlias)->ZK0_PROD,;
						(cAlias)->ZK0_DESCRI,;
						(cAlias)->ZK0_NUMSAC,;
						(cAlias)->ZK0_CLI,;
						(cAlias)->ZK0_LJCLI,;
						(cAlias)->ZK0_DTAGEN})

	(cAlias)->(dbSkip())
	end
    
	(cAlias)->(dbCloseArea())
	
	if len(aTerRet) > 0
		cTermo := "SIM"
	else
		cTermo := "NรO"	
	endif
	
	aAdd( aItens , { TMP->C6_01AGEND ,;
					 TMP->C6_ITEM,;
					 TMP->C6_PRODUTO,;
					 Alltrim(TMP->C6_DESCRI),;
					 TMP->C6_QTDVEN,;
					 TMP->C6_LOCAL,;
					 STOD(TMP->C6_ENTREG),;
					 nEstoque,;
					 cEstoque,;
					 cDescTipo,;
					 cTermo} )//#AFD27062018.N

	
	TMP->(DbSkip())
EndDo

oBrwItens:AARRAY:= aItens
oBrwItens:REFRESH()
oTela:REFRESH()

RETURN()   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILITENS บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  01/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza o painel que exibe os detalhes do pedido          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION AGENDITEM(aDados)

Local oDlgItem
Local dDataAgend := dDataBase
Local lGrava     := .F.

// P.E. p/ bloquear o agendamento - Cristiam Rossi em 07/04/2017
if existBlock("SYTM01BLQ") .and. ExecBlock("SYTM01BLQ",.F.,.F.,{ xFilial("SC6"), aPedidos[oBrwPedido:nAt][2], aDados[2],aDados[3] })
	return nil
endif

IF aDados[9] == "SIM"
	
	//Selecionar os itens de termo retira que serใo agendados na mesma data
	fViewTerRe(_cAtend, aTerRet)
	
	if len(aTermAgend) == 0
		if !msgYesNo("Nenhum Termo foi seleciona, deseja prosseguir com o agendamento?","ATENวรO")
			Return
		endif
	endif
	
	DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
	DEFINE MSDIALOG oDlgItem FROM 0,0 TO 180 , 350 TITLE "Agendar Item" Of oMainWnd PIXEL
	
	@ 005, 005 Say "Cod.Produto : " + ALLTRIM(aDados[3]) Size 200,010 FONT oFnt Pixel Of oDlgItem
	@ 025, 005 Say "Descri็ใo : "   + ALLTRIM(aDados[4]) Size 200,010 FONT oFnt Pixel Of oDlgItem
	
	@ 045, 005 Say "Data Agendamento de Entrega : " Size 100,010 Pixel Of oDlgItem
	@ 043, 100 MSGET dDataAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 065,010 PIXEL OF oDlgItem VALID !EMPTY(dDataAgend)
	
	@ 065,005 BUTTON  "&Confirma" 		SIZE 040,015 PIXEL OF oDlgItem ACTION ( lGrava := .T. ,(oTela:REFRESH(),oBrwPedido:REFRESH(),oBrwItens:REFRESH(),oDlgItem:End()) )
	@ 065,100 BUTTON  "&Sair" 			SIZE 040,015 PIXEL OF oDlgItem ACTION ( lGrava := .F. , oDlgItem:End() )
	
	ACTIVATE DIALOG oDlgItem CENTERED
Else
	MsgAlert("Produto com Bloqueio de Estoque! Antes de agendar fa็a a libera็ใo do mesmo!","Aten็ใo")
EndIF

IF lGrava
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6") + aPedidos[oBrwPedido:nAt][2] + aDados[2] + aDados[3])
	
	RecLock("SC6",.F.)
	SC6->C6_ENTREG  := dDataAgend
	SC6->C6_01AGEND := "1"
	aItens[oBrwItens:nAt,1] := "1" // Agendado 1=SIM,2=NAO;                                                                                                                    
	aItens[oBrwItens:nAt,7] := dDataAgend
	MsUnlock()
	                   
	oTela:REFRESH()	               
	oBrwPedido:REFRESH()
	oBrwItens:REFRESH()
	
	U_SYTMOV15(aPedidos[oBrwPedido:nAt][2],aDados[2],aDados[3],"3")
	
	dDataAgTerm := dDataAgend
	AlterDtAgend()
	
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ  TELMANU บ Autor บ LUIZ EDUARDO F.C.  บ Data ณ  05/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบObjetivo  ณ TELA DE MANUTENCAO DO CABECALHO DO PEDIDO DE VENDA (SC5)   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                              `
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION TELMANU(aCols)

Local oDlg, oBtnOK, oBtnSair, oBtnSIM
Local dDataAgend := dDataBase
Local cCliente   := aCols[3]
Local cLoja      := aCols[4]
Local lGrava     := .F.
Local cMsg		  := ""
Local oMsg
Local nCont		:= 0

// P.E. p/ bloquear o agendamento - Cristiam Rossi em 07/04/2017
if existBlock("SYTM01BLQ") .and. ExecBlock("SYTM01BLQ",.F.,.F.,{ xFilial("SC5"), aCols[2] })
	return nil
endif

DBSELECTAREA("SUA")
DBSETORDER(8)

IF DBSEEK(aCols[8]+aCols[2])
	cMsg := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
ENDIF

Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_CONTATO","A1_EMAIL","A1_COMPLEM" }
Private cCadastro := "Cadastro de Clientes - Altera็ใo de Endere็os"

DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 0,0 TO 550 , 270 TITLE "Manuten็ใo Cabe็alho" Of oMainWnd PIXEL

@ 005, 005 Say "Agendar Todos os Itens Disponiveis?" Size 200,010 FONT oFnt Pixel Of oDlg

@ 020, 005 Say "Data Agendamento : " Size 100,010 Pixel Of oDlg
@ 018, 065 MSGET dDataAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 065,010 PIXEL OF oDlg VALID !EMPTY(dDataAgend)

oBtnOK:= TButton():New( 038,005, "OK" , oDlg , {||},050,010, , , , .T. , , , , { ||})
oBtnOK:BLCLICKED:= {|| lGrava := .T. , (oTela:REFRESH(),oBrwPedido:REFRESH(),oBrwItens:REFRESH(),oDlg:End())  }

oBrwItens:REFRESH()
oTela:REFRESH()                                                                      

@ 050, 000 SAY REPLICATE("-",160) SIZE 200,005 PIXEL OF oDlg

@ 060, 005 Say "Endere็o de Entrega" Size 200,010 FONT oFnt Pixel Of oDlg

@ 075, 005 Say "Rua: " 		+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END") 		Size 100,020 Pixel Of oDlg
@ 095, 005 Say "Bairro: "	+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO") 	Size 100,010 Pixel Of oDlg
@ 105, 005 Say "Cidade: " 	+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")	 	Size 100,010 Pixel Of oDlg
@ 115, 005 Say "Estado: " 	+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST") 		Size 100,010 Pixel Of oDlg
@ 125, 005 Say "CEP: " 		+ Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP") 		Size 100,010 Pixel Of oDlg

@ 140, 005 Say "Observa็๕es de Entrega" Size 200,010 FONT oFnt Pixel Of oDlg

@ 150, 005 GET oMsg VAR cMsg MEMO SIZE 130,060 PIXEL OF oDlg

@ 210, 005 Say "Deseja Alterar o Endere็o de Entrega ?" Size 200,010 FONT oFnt  Pixel Of oDlg

oBtnSIM:= TButton():New( 225,005, "SIM" , oDlg , {||},050,010, , , , .T. , , , , { ||})
oBtnSIM:BLCLICKED:= {|| AxAltera("SA1",SA1->(Recno()),4,,aCpos) }

@ 235, 000 SAY REPLICATE("-",170) SIZE 200,005 PIXEL OF oDlg

oBtnSair:= TButton():New( 245,033, "Sair" , oDlg , {||},070,025, , , , .T. , , , , { ||})
oBtnSair:BLCLICKED:= {|| oDlg:End() }

ACTIVATE DIALOG oDlg CENTERED

IF lGrava
	
	fGravaAll()
	
	DBSELECTAREA("SUA")
	SUA->(DBSETORDER(8))
	
	if SUA->(DBSEEK(aCols[8]+aCols[2]))
		//cMsg := cMsg + MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
		MSMM(,TamSx3("UA_CODOBS")[1],,cMsg,1,,,"SUA","UA_CODOBS")
	endif
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") + aCols[2]))
	MSMM(,TamSx3("C5_XCODOBS")[1],,cMsg,1,,,"SC5","C5_XCODOBS")       
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	For nX := 1 To Len(aItens)
		If SC6->(DbSeek(xFilial("SC6") + aCols[2] + aItens[nX][2] + aItens[nX][3])) //Pedido + Item + Produto
			If aItens[nX][8] > 0 // Verifica se tem estoque
				RecLock("SC6",.F.)
					SC6->C6_ENTREG  := dDataAgend
					SC6->C6_01AGEND := "1"
					aItens[nX,1] := "1" 
					aItens[nX,7] := dDataAgend //#CMG20180528.n
				MsUnlock()
				U_SYTMOV15(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,"3") // Ellen
				dDataAgTerm := dDataAgend
			Else
				nCont++
			Endif
		Endif
	Next nX                                                                                     
	
	AlterDtAgend()
	
	oTela:REFRESH()
	oBrwPedido:REFRESH()
	oBrwItens:REFRESH()
	
EndIF

If nCont > 0
	MsgAlert("Existem produtos nesse pedido com bloqueio de estoque, o agendamento ocorrerแ somente nos itens com saldo","Aten็ใo")
Endif


oBrwItens:REFRESH()
oTela:REFRESH()

RETURN()

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 06/06/2017
@Hora: 15:12:24
@Versใo:
@Descri็ใo: Botใo para liberacao de estoque
--------------------------------------------*/
Static Function LibEstoque(oBrwItens)

Local nLinCab 	:= oBrwPedido:nAt
Local nLinIt	:= oBrwItens:nAt
Local cPedido 	:= oBrwPedido:aArray[nLinCab][2]
Local cItem		:= oBrwItens:aArray[nLinIt][2]
Local cProduto	:= oBrwItens:aArray[nLinIt][3]
Local nQuant	:= oBrwItens:aArray[nLinIt][5]
Local nQtdEst	:= oBrwItens:aArray[nLinIt][8]
Local cFilBkp	:= cFilAnt

Local nQtdLib	:= 0

Local lAvalCre 	:= .T.	// Avaliacao de Credito
Local lBloqCre 	:= .F. 	// Bloqueio de Credito
Local lAvalEst	:= .T.	// Avaliacao de Estoque
Local lBloqEst	:= .T.	// Bloqueio de Estoque

Begin Transaction

If nQtdEst >= nQuant
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6") + AvKey(cPedido,"C6_NUM") + AvKey(cItem,"C6_ITEM") + AvKey(cProduto,"C6_PRODUTO") ))
		
		cFilAnt := SC6->C6_MSFIL
		SC9->(DbSetOrder(1))
		If SC9->(DbSeek(xFilial("SC9") + AvKey(cPedido,"C9_NUM") + AvKey(cItem,"C9_ITEM") ))
			//-- Estorna a Libera็ใo do Pedido por meio da rotina padrใo de estorno.
			A460Estorna()
		EndIF
		cFilAnt := cFilBkp
		
		cFilAnt := "0101"
		
		RecLock("SC6",.F.)
		SC6->C6_QTDLIB := nQuant
		MsUnlock()
		
		nQtdLib := MaLibDoFat(SC6->(RecNo()),nQuant,@lBloqCre,@lBloqEst,lAvalCre,lAvalEst,.F.,.F.,NIL,NIL,NIL,NIL,NIL,0)
		
		If nQtdLib > 0
			Sleep(1500) //Sleep de 2 segundo
			SC6->(MaLiberOk({cPedido},.F.))
			MsgInfo("Produto: "+Alltrim(SC6->C6_PRODUTO)+" liberado estoque com sucesso!","Aten็ใo")
			oBrwItens:aArray[nLinIt][9] := "SIM"
			oBrwItens:REFRESH()
			oTela:REFRESH()
		Else
			MsgInfo("Saldo insuficiente para efetuar a libera็ใo.","Aten็ใo")
		Endif
	Endif
	
Else
	MsgInfo("Este item nใo possui quantidade suficiente para ser liberado, selecione outro item.","Aten็ใo")
Endif

End Transaction

cFilAnt := cFilBkp

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 06/06/2017  บฑฑ
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
ฑฑบPrograma  ณ  PesqPed บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 25/10/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PESQUISA PEDIDO NO BROWSE                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PesqPed(cPesqPed)
        
Local nPos := 0

nPos := aScan(aPedidos ,{|x|x[2] == cPesqPed }) 

If nPos > 0
	oBrwPedido:nAt := nPos
	oBrwPedido:REFRESH()
	
	FILITENS(aPedidos[oBrwPedido:nAt])	
EndIF

Return()               
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ITAGEND  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ 25/10/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MOSTRA OS TOTAIS DE ITENS AGENDADOS                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ITAGEND()

Local aPerg  	:= {}
Local aButtons  := {}
Local aItens 	:= {}  
Local oTelIT, oBrwIT

Aadd(aPerg,{PadR("ITAGEND",10),"01","Empresa  ?" 			,"MV_CH01" ,"C",004,00,"G","MV_PAR01",""     ,""      ,""			,"","","SM0EMP",""			})
Aadd(aPerg,{PadR("ITAGEND",10),"02","Empresa  ?" 			,"MV_CH02" ,"C",004,00,"G","MV_PAR02",""     ,""      ,""			,"","","SM0EMP",""			})
Aadd(aPerg,{PadR("ITAGEND",10),"03","Data Entrega de ?"		,"MV_CH03" ,"D",008,00,"G","MV_PAR03",""     ,""      ,""			,"","",""	,""   		})
Aadd(aPerg,{PadR("ITAGEND",10),"04","Data Entrega at้ ?"	,"MV_CH04" ,"D",008,00,"G","MV_PAR04",""     ,""      ,""			,"","",""	,""   		})

VldSX1(aPerg)

If !Pergunte(aPerg[1,1],.T.)
	Return(Nil)
EndIf                            

cQuery := " SELECT SUM(C6_QTDVEN) QTDE, C6_ENTREG  FROM " + RETSQLNAME("SC6") + " SC6 "
cQuery += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL "
cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_COD = C6_PRODUTO " //#AFD26072018.N
cQuery += " AND C5_MSFIL = C6_MSFIL "
cQuery += " AND C5_NUM = C6_NUM "
cQuery += " AND C5_CLIENTE = C6_CLI "
cQuery += " AND C5_LOJACLI = C6_LOJA "
cQuery += " WHERE C6_FILIAL <> ' ' "
cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "   
cQuery += " AND SB1.B1_XACESSO <> '1' " //#AFD26072018.N
cQuery += " AND C6_ENTREG  BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " AND C6_MSFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND C6_01AGEND = '1' "
cQuery += " AND C6_BLQ <> 'R'"                           
cQuery += " GROUP BY C6_ENTREG "    
cQuery += " ORDER BY C6_ENTREG "

If Select("TRB") > 0                                                                       '
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	aAdd( aItens , { TRB->QTDE, TRB->C6_ENTREG } )
	TRB->(DbSkip())
EndDo   

IF Len(aItens) > 0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MONTA A TELA PRINCIPAL DE AGENDAMENTO DE PEDIDOS ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oTelIT FROM 0,0 TO 400,600 TITLE "Itens Agendados" Of oMainWnd PIXEL 
	
	oBrwIT:= TwBrowse():New(005, 005, 200, 150,, {'Quantidade','Dt.Entrega'},,oTelIT,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
	oBrwIT:SetArray(aItens)
	oBrwIT:bLine      := {|| {  	Transform(aItens[oBrwIT:nAt,01],PesqPict('SC6','C6_QTDVEN')) ,;
									DTOC(STOD(aItens[oBrwIT:nAt,02])) }}
	
	oBrwIT:bLDblClick := {|| ITAGEND2(aItens[oBrwIT:nAt,02]) } 
	
	oBrwIT:Align      := CONTROL_ALIGN_ALLCLIENT 
	
	ACTIVATE MSDIALOG oTelIT ON INIT EnchoiceBar( oTelIT, { || oTelIT:End() } , { || oTelIT:End() },, aButtons)

Else
	MsgInfo("Sem dados localizados, por favor reveja os parametros")
EnDIF	

Return()

//--------------------------------------------------------------
/*/{Protheus.doc} ITAGEND2
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function ITAGEND2(_cData)
	
	Local oGet
	Local cGet := space(6)
	Local oSay1
	Static oTelIT2
	
	DEFINE MSDIALOG oTelIT2 TITLE "Itens Agendados" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL

    @ 005, 006 MSGET oGet VAR cGet SIZE 049, 010 OF oTelIT2 COLORS 0, 16777215 PIXEL
    fNewAgend2(_cData)
	@ 005, 059 BUTTON oButton PROMPT "Pesquisar" SIZE 037, 012 OF oTelIT2 ACTION { || findPedido(cGet) } PIXEL

 	ACTIVATE MSDIALOG oTelIT2 CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fNewAgend2
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function fNewAgend2(_cData)

	Local nX
	Local aHeader := {}
	Local aCols := {}
	Local aFieldFill := {}
	Local aFields := {"C5_XDESCFI ","C5_NUM ","C6_QTDVEN","C5_NOTA","C6_ENTREG"}
	Local aAlterFields := {}
    Local cQuery := ""
    
	Static oNewAgend2

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
	    	Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX
	
	cQuery := "SELECT FILIAL, C5_NUM AS PEDIDO, SUM(C6_QTDVEN) AS QTD, C5_NOTA AS NOTA ,C6_ENTREG ,SC5.R_E_C_N_O_"
	cQuery += " FROM "+retSqlName("SC6")+" SC6"
	cQuery += " INNER JOIN "+retSqlName("SC5")+" SC5 ON C5_FILIAL = C6_FILIAL"
	cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_COD = C6_PRODUTO " //#AFD26072018.N
	cQuery += " INNER JOIN SM0010 SM0 ON SM0.FILFULL = SC6.C6_MSFIL"
	cQuery += " AND C5_MSFIL = C6_MSFIL"
	cQuery += " AND C5_NUM = C6_NUM"
	cQuery += " AND C5_CLIENTE = C6_CLI "
	cQuery += " AND C5_LOJACLI = C6_LOJA"
	cQuery += " WHERE C6_FILIAL <> ' '"
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.B1_XACESSO <> '1' " //#AFD26072018.N
	cQuery += " AND C6_ENTREG = '"+ _cData +"'"
	cQuery += " AND C6_01AGEND = '1'  "
	cQuery += " AND C6_BLQ <> 'R'"
	cQuery += " GROUP BY FILIAL, C5_NUM, C5_NOTA, C6_ENTREG, SC5.R_E_C_N_O_"
	cQuery += " ORDER BY PEDIDO"

	If Select("TRB") > 0                                                                     
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	While TRB->(!EOF())
		aAdd( aCols , { TRB->FILIAL,;
						 TRB->PEDIDO,;
						 TRB->QTD,;
						 TRB->NOTA,;
						 dtoc(stod(TRB->C6_ENTREG)),;
						 .F. } )
		TRB->(DbSkip())
	EndDo   

	oNewAgend2 := MsNewGetDados():New( 019, 004, 196, 396, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oTelIT2, aHeader, aCols)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} findPedido
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/07/2018
/*/
//--------------------------------------------------------------
Static Function findPedido(_cPedido)
	
	Local nPos := 0

	nPos := aScan(oNewAgend2:acols ,{|x|x[2] == _cPedido }) 
	
	if nPos > 0
		oNewAgend2:nAt := nPos
		oNewAgend2:REFRESH()
	else
		MsgAlert("Pedido nใo encontrado..","ATENวรO")
	endif
	
Return


/*---------------------------------------------------------------------*
 | Func:  Confirma                                                     |
 | Autor: Ellen                                               			|
 | Data:  08/02/2018                                                   |
 | Desc:  Verifica se possui produto bipartido confirmando no final		|
 *---------------------------------------------------------------------*/
Static Function Confirma()

Local cProdPai	:= ""//Padr(aItens[1,3],11)
Local cPedido	:= aPedidos[oBrwPedido:nAt][2]
Local aBipart	:= {}
Local nX		:= 0
Local lRet		:= .T.
Local cPaiComp := ""
Local nPos		:= 0


DbSelectArea("SC6")
SC6->(DbSetOrder(1))

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Busca todos os produtos do tipo bipartido sem agendamento    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 To Len(aItens)		
	If SB1->(DbSeek(xFilial('SB1') + aItens[nX,3] ))
		If SB1->B1_01BIPAR == '1' .And. aItens[nX,1] == '2' 
			aBipart := aClone(aItens)
		Endif
	Endif	
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica o filho do tipo bipartido se estah agendado         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i:= 1 To Len(aItens) 
	cProdPai := Padr(aItens[i,3],11)
	cPaiComp := aItens[i,3] // Codigo do Pai Completo 
	For nX := 1 To Len(aBipart)
		If cProdPai == Padr(aBipart[nX,3],11) .And. aBipart[nX,1] == '2' 
		
			nPos := aScan(aItens,{|x| x[3] == cPaiComp})
			SC6->(DbSeek(xFilial("SC6") + cPedido + aItens[nPos,2] + aItens[nPos,3]))
			
			RecLock("SC6",.F.)
				SC6->C6_ENTREG  := CtoD("")
				SC6->C6_01AGEND := "2"
				aItens[nPos,1] := "2" // Agendado 1=SIM,2=NAO;                                                                                                                    
			MsUnlock()
			
			oBrwItens:REFRESH()
			oTela:REFRESH()
	
			lRet := .F.
		Endif
	Next nX
Next i

SC6->(DbCloseArea())
SB1->(DbcloseArea())

Return(lRet)


//--------------------------------------------------------------
/*/{Protheus.doc} fTerRet
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------

Static Function fTerRet(_cAtend, aTermos)

	Local cAtend := _cAtend
	Local oSay1
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Rela็ใo de Termos Retira" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

		@ 009, 008 SAY oSay1 PROMPT "Atendimento:" SIZE 030, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
		@ 008, 050 MSGET cAtend VAR cAtend SIZE 062, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		if len(aTermos) > 0                                                       
			fNewTerRet(aTermos)
        else
			msgAlert("Nใo existe termo retira para esse Pedido.","ATENวรO..")
			Return
        endif
        
	ACTIVATE MSDIALOG oDlg CENTERED

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fNewTerRet
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------

Static Function fNewTerRet(aTermos)

	Local nX
	Local aHeader := {}
	Local aCols := {}
	Local aFieldFill := {}
	Local aFields := {"ZK0_COD","ZK0_PROD","ZK0_DESCRI","ZK0_NUMSAC","ZK0_CLI","ZK0_LJCLI","ZK0_DTAGEN"}
	Local aAlterFields := {}
	Static oMSTerRet

	  // Define field properties
	  DbSelectArea("SX3")
	  SX3->(DbSetOrder(2))
	  For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
		  Aadd(aHeader, {AllTrim(X3Titulo()),;
		  					SX3->X3_CAMPO,;
		  					SX3->X3_PICTURE,;
		  					SX3->X3_TAMANHO,;
		  					SX3->X3_DECIMAL,;
		  					SX3->X3_VALID,;
						   	SX3->X3_USADO,;
						   	SX3->X3_TIPO,;
						   	SX3->X3_F3,;
						   	SX3->X3_CONTEXT,;
						   	SX3->X3_CBOX,;
						   	SX3->X3_RELACAO})
		Endif
	  Next nX

	  // Define field values
	  For nX := 1 to Len(aTermos)
		
		  Aadd(aCols,{;
						aTermos[nX][1],;
						aTermos[nX][2],;
						aTermos[nX][3],;
						aTermos[nX][4],;
						aTermos[nX][5],;
						aTermos[nX][6],; 
						aTermos[nX][7],;
						.F.})
		
	  Next nX
	  
	  oMSTerRet := MsNewGetDados():New( 021, 003, 245, 245, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeader, aCols)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fViewTerRe
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fViewTerRe(_cAtend, aTermos)
	
	Local cAtend := _cAtend
	Local oButton1
	Local oSay1
	Local oText
	
	Static oDlg1

	DEFINE MSDIALOG oDlg1 TITLE "Termos Retira" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    @ 010, 006 SAY oSay1 PROMPT "Atendimento:" SIZE 030, 007 OF oDlg1 COLORS 16711680, 16777215 PIXEL
    @ 009, 050 MSGET cAtend VAR cAtend SIZE 062, 010 OF oDlg1 COLORS 0, 16777215 PIXEL

	if len(aTermos) > 0 
		fSelectTer(aTermos)
    else
		Return
	endif
	
	@ 024, 004 SAY oText PROMPT "Selecione os Termos Retira que serใo agendados." SIZE 130, 014 OF oDlg1 COLORS 255, 15658734 PIXEL
    @ 024, 193 BUTTON oButton1 PROMPT "Gravar Itens" SIZE 051, 013 OF oDlg1 ACTION {|| 	fGravaTerm(), oDlg1:end() } PIXEL

	ACTIVATE MSDIALOG oDlg1 CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSelectTer
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fSelectTer(aTermos)

	Local nX
	Local aHeader := {}
	Local aCols := {}
	Local aFields := {"ZK0_COD","ZK0_PROD","ZK0_DESCRI","ZK0_NUMSAC","ZK0_CLI","ZK0_LJCLI","ZK0_DTAGEN"}
	Local aAlterFields := {}

	Static oMSNew1

	Aadd(aHeader,{"","FLAG","@BMP",1,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
	  
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeader, {AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT,;
								SX3->X3_CBOX,;
								SX3->X3_RELACAO})
		Endif
	Next nX

	For nX := 1 to Len(aTermos)
		
		Aadd(aCols,{;
					"LBNO",;
					aTermos[nX][1],;
					aTermos[nX][2],;
					aTermos[nX][3],;
					aTermos[nX][4],;
					aTermos[nX][5],;
					aTermos[nX][6],; 
					aTermos[nX][7],;
					.F.})
		
	Next nX

	oMSNew1 := MsNewGetDados():New( 040, 003, 238, 246, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aHeader, aCols)
	
	oMSNew1:oBrowse:bLDblClick := {|| fMarcOne(oMSNew1:nat) }
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fMarcOne
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
//fMarcOne: Marca o checkbox da linha posicionada
Static Function fMarcOne(nLin) 

	Local nPFlag := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	
	if oMSNew1:aCols[nLin,nPFlag] == "LBTIK"
		oMSNew1:aCols[nLin,nPFlag] := "LBNO"
	else
		oMSNew1:aCols[nLin,nPFlag] := "LBTIK"
	endif
	
	oMSNew1:Refresh()
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fGravaTerm
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fGravaTerm()
	
	Local nPFlag := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="FLAG"}) 
	Local nPCod := Ascan(oMSNew1:aHeader,{|x|AllTrim(x[2])=="ZK0_COD"})
	
	aTermAgend := {}
		
	for nx := 1 to len(oMSNew1:aCols)
		if oMSNew1:aCols[nx,nPFlag] == "LBTIK"
			aAdd(aTermAgend,{oMSNew1:aCols[nx,nPCod]})	
		endif
	next nx
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fGravaAll
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function fGravaAll()
	
	aTermAgend := {}
		
	for nx := 1 to len(aTerRet)
		aAdd(aTermAgend,{aTerRet[nx][1]})	
	next nx
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} AlterDtAgend
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 16/07/2018
/*/
//--------------------------------------------------------------
Static Function AlterDtAgend()
	
	Local aArea := getArea()
	
	dbSelectArea("ZK0")
	ZK0->(dbSetOrder(1))

	for nx := 1 to len(aTermAgend)
		if ZK0->(dbSeek(xFilial("ZK0")+aTermAgend[nx][1]))
			RecLock("ZK0",.F.)
				ZK0->ZK0_DTAGEN := dDataAgTerm	
			msUnLock()
		endif
	next nx
	
	restArea(aArea)
		
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fTerRetPed
Description                                                     
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/07/2018
/*/
//--------------------------------------------------------------
Static Function fTerRetPed(_CodSac)
	
	Local lRet := .F.
	Local cQuery := ""
	Local cAlias := ""
	
	cQuery := "SELECT ZK0_COD, ZK0_PROD, ZK0_DESCRI, ZK0_NUMSAC, ZK0_CLI, ZK0_LJCLI, ZK0_DTAGEN FROM "+retSqlName("ZK0")+" ZK0"
	cQuery += " INNER JOIN "+retSqlName("SUC")+" UC ON ZK0.ZK0_NUMSAC = UC.UC_CODIGO"
	cQuery += " AND UC_CODIGO = '"+_CodSac+"'"
	cQuery += " AND ZK0.ZK0_CARGA = ''"
	cQuery += " AND ZK0.D_E_L_E_T_ = ' '"
	cQuery += " AND UC.D_E_L_E_T_ = ' '"
    
	cAlias := getNextAlias()
	plsQuery(cQuery,cAlias)
			
	while (cAlias)->(!eof())
		lRet := .T.	
	(cAlias)->(dbSkip())
	end

Return lRet
