#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMPEDIDO  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  19/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRESSAO DE ORCAMENTO KOMFORT                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMPEDIDO(cPedido,_lMail)

Local cImag001 	:= "C:\totvs\logo.png"
Local cImag002 	:= "C:\totvs\sofas.png"
Local _cSofaF 	:= "\system\SOFA_F.png"
Local _cSofaB 	:= "\system\SOFA_B.png"
Local oPrinter
Local oFnt1	   	:= TFont():New("",,24,,.T.,,,,,.F.,.F.)
Local oFnt2	   	:= TFont():New("",,16,,.F.,,,,,.F.,.F.)
Local oFnt3	   	:= TFont():New("",,14,,.F.,,,,,.F.,.F.)
Local oFnt4	   	:= TFont():New("",,15,,.T.,,,,,.F.,.F.)
Local oFnt5	   	:= TFont():New("",,13,,.T.,,,,,.F.,.F.)
Local oFnt6	   	:= TFont():New("",,09,,.F.,,,,,.F.,.F.)
Local oFnt7	   	:= TFont():New("",,14,,.T.,,,,,.F.,.F.)
Local oFnt8	   	:= TFont():New("",,16,,.T.,,,,,.F.,.F.)
Local oFnt9	   	:= TFont():New("",,15,,.F.,,,,,.F.,.F.)
Local oFnt10   	:= TFont():New("",,13,,.F.,,,,,.F.,.F.)
Local oFnt11	:= TFont():New("",,13,,.T.,,,,,.F.,.F.)
Local oFnt12	:= TFont():New("",,12,,.T.,,,,,.F.,.F.)
Local oFnt13	:= TFont():New("",,10,,.F.,,,,,.F.,.F.)
Local oFnt14	:= TFont():New("",,08,,.F.,,,,,.F.,.F.)
Local oFnt15	:= TFont():New("Arial",,10.5,,.T.,,,,,.F.,.F.)
Local oFnt16	:= TFont():New("",,9.5,,.F.,,,,,.F.,.F.)
Local oFnt17  	:= TFont():New("",,10,,.F.,,,,,.F.,.F.)
Local _cFilBkp  := cFilAnt
Local cDesc     := ""
Local nQTDETOT	:= 0
Local nVLRTOT	:= 0
Local nPESOTOT	:= 0
Local nM3TOT	:= 0
Local cCFOP		:= ""
Local cDESCFOP	:= ""
Local cOBS		:= ""
Local cLocal    := "c:\totvs\"
Local dPREVENT 	:= CTOD("")
Local nLin      := 0
Local nLinAux   := 0
Local aAdm		:= {}
Local cFormaPG	:= ""
Local nQtdChk	:= 0
Local nQtdBol	:= 0
Local nCheck	:= 0
Local nTotBol	:= 0
Local cQuery    := ""
Local nLinha    := 0
Local _nPular   := 30
Local cLinha    := ""
Local cLinha3	:= ""
Local cQuery    := ""
Local nItens    := 0
Local aObserv 	:= {}
Local _cAux     := ""
Local _cCarac   := "*|=|_|;|+|!|#|%|¨"
Local _ny       := 0
Local _nx       := 0
Local _nCont    := 0
Local xArredBol:={}
Local xFormBol
Local xNomCli 
Local xTotVlrBl:=0

Private _dDtBlqFi    := StoD(GetMv("KH_DTBLQFI"))
Private _dDtNoAge    := StoD(GetMv("KH_DTNOAGE"))
Private _nDiasEnt    := GetMv("KH_DIASENT")
Private _dEntreg     := CtoD('//')
Private xForm

Private _cFilial  := ""
Private _cNome    := ""
Private _nLimConf := 85
Private xTotBl    := 0
Private nVlSL4    := 0

Default cPedido		:= SUA->UA_NUMSC5
Default _lmail      := .F.

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5") + cPedido ))

If cFilAnt <> SC5->C5_MSFIL .And. !Empty(AllTrim(SC5->C5_MSFIL))
	
	cFilAnt := SC5->C5_MSFIL
	
EndIf

IF !ExistDir("C:\KMPEDIDO")
	
	MakeDir("C:\KMPEDIDO")
	
EndIF

_cNomeArq:=cPedido+"_"+DtoS(DDataBase)+Subs(Time(),1,2)+Subs(Time(),4,2)+".pdf"

oPrinter := FWMsPrinter():New(_cNomeArq,6,.T., ,.T., , , , ,.F., , .T., )

cQuery := " SELECT COUNT(*) AS ITENS FROM " + RETSQLNAME("SUB")
cQuery += " WHERE UB_FILIAL = '" + xFilial("SUB") + "' "
cQuery += " AND UB_NUM = '" + SUA->UA_NUM + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	nItens := TRB->ITENS
	TRB->(!DbSkip())
EndDo

//Local cORCAMENTO 	:= SUA->UA_NUM

U_FM_Direct( cLocal, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ AS COPIAS DAS IMAGENS DO SERVIDOR PARA A PASTA LOCAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CpyS2T("\system\logo.png",cLocal,.F.)
CpyS2T("\system\sofas.png",cLocal,.F.)

dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilAnt)

dBSelectArea("SUA")
SUA->(DbSetOrder(8))
SUA->(DbSeek(xFilial("SUA") + cPedido ))

dBSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5") + cPedido ))

dBSelectArea("SC6")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC6") + cPedido ))

dBSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
xNomCli:=A1_NOME
_dEntreg := fDiasValid(SC5->C5_EMISSAO,_nDiasEnt)

//oPrinter:Setup()
oPrinter:SetPortrait()
oPrinter:cPathPDF := "C:\KMPEDIDO\"
oPrinter:StartPage()

oPrinter:Box(0050,0050,3000,2375)

oPrinter:Box(0050,0050,0300,2375)
oPrinter:Box(0050,0050,0300,0350)
oPrinter:SayBitMap(0080,080,cImag001,0250,0175)
oPrinter:Say(0140,0700,"KOMFORT HOUSE SOFAS",oFnt1,,0)
oPrinter:Say(0210,0640,"Uma casa só é completa com um bom sofá",oFnt2,,0)

oPrinter:Say(0335,1810,ALLTRIM(SM0->M0_FILIAL),oFnt8,,0)
oPrinter:Box(0050,1800,0300,2372)
oPrinter:Say(0090,1930,"Pedido de Venda",oFnt2,,0)
oPrinter:Say(0145,1970,SC5->C5_NUM,oFnt1,,0)
oPrinter:Say(0200,1880,"Orçamento: " + SC5->C5_NUMTMK,oFnt2,,0)
//oPrinter:Box(0400,0050,0540,2375)
oPrinter:Say(0260,1810,"Emissão:" + DTOC(SC5->C5_EMISSAO)+" - "+SUA->UA_FIM,oFnt10,,0)
oPrinter:Box(0300,0050,0400,2375)
oPrinter:Say(0330,0080,UPPER(AllTrim(SM0->M0_ENDENT)) + " - " +  UPPER(AllTrim(SM0->M0_BAIRENT)) + " - " +  UPPER(AllTrim(SM0->M0_CIDENT)) + " - " + UPPER(AllTrim(SM0->M0_ESTENT)),oFnt10,,0)
oPrinter:Say(0380,0080,"CEP: " + Transform(SM0->M0_CEPENT,"@R 99999-999" ) + " Telefone/Fax " + AllTrim(SM0->M0_TEL) + " - serviraocliente@komforthouse.com.br",oFnt10,,0)//#WRP20190109.n
oPrinter:Say(0360,1600,AllTrim(SM0->M0_FILIAL),oFnt1,,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INFORMACOES DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrinter:Say(0430,0070,"Cliente:",oFnt11,,0)
oPrinter:Say(0430,0250,ALLTRIM(SA1->A1_NOME),oFnt10,,0)

_cFilial := AllTrim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL"))
_cNome   := ALLTRIM(SA1->A1_NOME)

oPrinter:Say(0470,0070,"CPF:",oFnt11,,0)
IF SA1->A1_PESSOA = "F"
	oPrinter:Say(0470,0250,Transform(ALLTRIM(SA1->A1_CGC),"@R 999.999.999-99"),oFnt10,,0)
Else
	oPrinter:Say(0470,0250,Transform(ALLTRIM(SA1->A1_CGC),"@R 99.999.999/9999-99"),oFnt10,,0)
EndIF

oPrinter:Say(0470,0600,"I.E:",oFnt11,,0)
oPrinter:Say(0470,0680,ALLTRIM(SA1->A1_INSCR),oFnt10,,0)

oPrinter:Say(0470,1300,"Cliente Desde:",oFnt11,,0)
oPrinter:Say(0470,1600,DTOC(SA1->A1_DTCAD),oFnt10,,0)

oPrinter:Say(0470,1850,"Última Compra:",oFnt11,,0)
oPrinter:Say(0470,2150,DTOC(SA1->A1_ULTCOM),oFnt10,,0)

oPrinter:Say(0510,0070,"Endereço:",oFnt11,,0)
oPrinter:Say(0510,0250,ALLTRIM(SA1->A1_END),oFnt10,,0)

oPrinter:Say(0550,0070,"Bairro:",oFnt11,,0)
oPrinter:Say(0550,0250,ALLTRIM(SA1->A1_BAIRRO),oFnt10,,0)

oPrinter:Say(0550,1050,"CEP:",oFnt11,,0)
oPrinter:Say(0550,1150,Transform(SA1->A1_CEP,"@R 99999-999" ),oFnt10,,0)

oPrinter:Say(0550,1400,"Cidade:",oFnt11,,0)
oPrinter:Say(0550,1600,ALLTRIM(SA1->A1_MUN),oFnt10,,0)

oPrinter:Say(0550,2100,"UF:",oFnt11,,0)
oPrinter:Say(0550,2220,SA1->A1_EST,oFnt10,,0)

oPrinter:Say(0590,0070,"Telefone:",oFnt11,,0)
oPrinter:Say(0590,0250,"( " + ALLTRIM(SA1->A1_DDD) + " ) " + Transform(AllTrim(SA1->A1_TEL),"@R 99999-9999") + " / " + "( " + ALLTRIM(SA1->A1_DDD) + " ) " + Transform(AllTrim(SA1->A1_TEL2),"@R 99999-9999"),oFnt10,,0)

oPrinter:Say(0590,1400,"Contato:",oFnt11,,0)
oPrinter:Say(0590,1500,ALLTRIM(SA1->A1_CONTATO),oFnt10,,0)

oPrinter:Say(0630,0070,"Transporte:",oFnt11,,0)
oPrinter:Say(0630,0280,POSICIONE("SA4",1,XFILIAL("SA4")+SUA->UA_TRANSP,"A4_NOME") ,oFnt10,,0)

oPrinter:Say(0630,1400,"Vendedor:",oFnt11,,0)
oPrinter:Say(0630,1600,POSICIONE("SA3",1,XFILIAL("SA3")+SUA->UA_VEND,"A3_NOME"),oFnt10,,0)

oPrinter:Say(0670,0070,"E-mail:",oFnt11,,0)
oPrinter:Say(0670,0240,ALLTRIM(SA1->A1_EMAIL) ,oFnt10,,0)


IF nItens < 9
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CABECALHO DAS INFORMACOES DOS ITENS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrinter:Box(0750,0050,1607,0150)
	oPrinter:Say(0770,0060,"Item",oFnt12,,0)
	
	oPrinter:Box(0750,0150,1607,0435)
	oPrinter:Say(0770,0160,"Código",oFnt12,,0)
	
	oPrinter:Box(0750,0435,1607,0505)
	oPrinter:Say(0770,0445,"TP",oFnt12,,0)
	
	oPrinter:Box(0750,0500,1607,1200)
	oPrinter:Say(0770,0510,"Descrição",oFnt12,,0)
	
	oPrinter:Box(0750,1200,1607,1400)
	oPrinter:Say(0770,1210,"Peso Bruto",oFnt12,,0)
	
	oPrinter:Box(0750,1400,1607,1600)
	oPrinter:Say(0770,1410,"Peso Liq.",oFnt12,,0)
	
	oPrinter:Box(0750,1600,1607,1700)
	oPrinter:Say(0770,1610,"Qtde.",oFnt12,,0)
	
	oPrinter:Box(0750,1700,1607,1800)
	oPrinter:Say(0770,1710,"UM",oFnt12,,0)
	
	oPrinter:Box(0750,1800,1607,2000)
	oPrinter:Say(0770,1810,"Vlr.Uniário",oFnt12,,0)
	
	oPrinter:Box(0750,2000,1607,2100)
	oPrinter:Say(0770,2010,"IPI",oFnt12,,0)
	
	oPrinter:Box(0750,2100,1607,2300)
	oPrinter:Say(0770,2110,"Vlr.Total",oFnt12,,0)
	
	oPrinter:Box(0750,2300,1607,2372)
	oPrinter:Say(0770,2302,"ICM",oFnt12,,0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESENHA A LINHA DAS TABELA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrinter:Box(0785,0050,0785,2375) // CABECALHO
	oPrinter:Box(0870,0050,0870,2375) // CABECALHO
	oPrinter:Box(0975,0050,0975,2375) // LINHA 01  -- QUEBRA EM 105
	oPrinter:Box(1080,0050,1080,2375) // LINHA 02  -- QUEBRA EM 135
	oPrinter:Box(1185,0050,1185,2375) // LINHA 03  -- QUEBRA EM 135
	oPrinter:Box(1290,0050,1290,2375) // LINHA 04  -- QUEBRA EM 135
	oPrinter:Box(1395,0050,1395,2375) // LINHA 05  -- QUEBRA EM 135
	oPrinter:Box(1500,0050,1500,2375) // LINHA 06  -- QUEBRA EM 135
	oPrinter:Box(1605,0050,1605,2375) // LINHA 07  -- QUEBRA EM 135
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME OS DADOS DOS PRODUTOS DO PEDIDO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6") + cPEDIDO ))
	nLin := 0805
	
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPEDIDO
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SC6->C6_PRODUTO ))
		
		oPrinter:Say(nLin,0060,SC6->C6_ITEM,oFnt16,,0)
		oPrinter:Say(nLin,0160,SC6->C6_PRODUTO,oFnt16,,0)
		oPrinter:Say(nLin,0445,SB1->B1_TIPO,oFnt16,,0)
		
		oPrinter:Say(nLin,0510,SUBSTR(SC6->C6_DESCRI,1,45),oFnt16,,0)  // QUEBRA EM 35
		nLinAux := nLin + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(SC6->C6_DESCRI,46,45),oFnt16,,0)
		nLinAux := nLinAux + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(SC6->C6_DESCRI,92,45),oFnt16,,0)
		
		oPrinter:Say(nLin,1210,Alltrim(Transform(SB1->B1_PESBRU,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1410,Alltrim(Transform(SB1->B1_PESO,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1610,Alltrim(Transform(SC6->C6_QTDVEN,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1710,SC6->C6_UM,oFnt16,,0)
		oPrinter:Say(nLin,1810,Alltrim(Transform(SC6->C6_PRCVEN,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2010,Alltrim(Transform(SC6->C6_01IPI,"@E 99.99")),oFnt16,,0)
		oPrinter:Say(nLin,2110,Alltrim(Transform(SC6->C6_VALOR,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2302,Alltrim(Transform(SB1->B1_PICM,"@E 99.99")),oFnt16,,0)
		
		If SC6->C6_ENTREG == _dDtBlqFi
			dPREVENT := CtoD('//')
		ElseIf SC6->C6_ENTREG == _dDtNoAge
			dPREVENT := _dEntreg
		Else
			dPREVENT := SC6->C6_ENTREG
		Endif
		
		If Empty(cCFOP)
			cCFOP 		:= SC6->C6_CF
			cDESCFOP 	:= POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_TEXTO")
		Endif
		
		nQTDETOT 	+= SC6->C6_QTDVEN
		nVLRTOT 	+= SC6->C6_PRCVEN*SC6->C6_QTDVEN  
		xTotVlrBl     += SC6->C6_PRCVEN*SC6->C6_QTDVEN  
		nPESOTOT 	+= (SB1->B1_PESBRU * SC6->C6_QTDVEN)
		nM3TOT 		:= 0
		
		/*
		Alterado em 13/07/2017 - Rogério Doms
		Verificado se existe item do orçamento com observação de venda de medida
		especial. Se encontrado um observação informar no campo Obs que existe
		itens com medida especial
		*/
		If !Empty(SC6->C6_01DESME) .And. Empty(cOBS)
			cOBS := "Este pEDIDO contém Item com Medida Especial"+CRLF
		EndIf
		
		nLin := nLin + 105
		
		SC6->(DbSkip())
	Enddo
	
	oPrinter:Say(0710,0070,"CFOP: " + cCFOP + " - " + cDESCFOP,oFnt11,,0)
	
	oPrinter:Say(1625,0060,"Sr(a) Cliente não assinar sem antes conferir todos dados cadastrais e etiqueta que consta a descrição do produto exposto em loja com descrição",oFnt13,,0)
	oPrinter:Say(1655,0060,"do produto neste pedido",oFnt13,,0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INFORMACOES INFERIORES DO PEDIDO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrinter:Box(1670,0050,1870,2375)
	
	cLinha1 := ""
	IF !EMPTY(SA1->A1_ENDENT)
		cLinha1 := ALLTRIM(SA1->A1_ENDENT)
	Else
		cLinha1 := ALLTRIM(SA1->A1_END)
		cLinha3 := "Complemento : " + ALLTRIM(SA1->A1_COMPLEM)
	EndIF
	
	IF !EMPTY(SA1->A1_BAIRROE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_BAIRROE)
	Else
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_BAIRRO)
	EndIF
	
	IF !EMPTY(SA1->A1_MUNE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_MUNE)
	Else
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_MUN)
	EndIF
	
	IF !EMPTY(SA1->A1_ESTE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_ESTE)
	Else
		cLinha1 := cLinha1 + " - " + ALLTRIM(SA1->A1_EST)
	EndIF
	
	cLinha2 := ""
	IF !EMPTY(SA1->A1_CEPE)
		cLinha2 := "CEP: " + Transform(SA1->A1_CEPE,"@R 99999-999" )
	Else
		cLinha2 := "CEP: " + Transform(SA1->A1_CEP,"@R 99999-999" )
	EndIF
	
	oPrinter:Say(1700,0060,"Endereço de Entrega",oFnt11,,0)
	oPrinter:Say(1750,0060,cLinha1,oFnt10,,0)
	oPrinter:Say(1790,0060,cLinha2,oFnt10,,0)
	oPrinter:Say(1830,0060,cLinha3,oFnt10,,0)
	
	oPrinter:Box(1670,1900,1870,2375)
	oPrinter:Say(1720,1910,"Previsão de Entrega",oFnt4,,0)
	oPrinter:Say(1790,2000,DTOC(dPREVENT),oFnt4,,0)
	
	oPrinter:Box(1870,0050,2250,2375)
	oPrinter:Say(1900,0060,"Observações",oFnt11,,0)
	
	cOBS += MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Observacoes do pedido tipo encomenda ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//aObserv := StrToKarr( cOBS , '|')
	
	aObserv := U_IMPMEMO(cOBS, 145, "", .F.)
	
	If  Len(aObserv) > 0
		nLin := 1950
		For _nx := 1 To Len(aObserv)
			oPrinter:Say(nLin,0060,aObserv[_nx],oFnt17,,0)
			nLin += 30
		Next
		
	Else
		
		cOBS := AllTrim(cOBS)
		oPrinter:Say(1950,0060,LEFT(cOBS,155),oFnt17,,0)
		oPrinter:Say(1990,0060,SUBSTR(cOBS,156,155),oFnt17,,0)
		oPrinter:Say(2030,0060,SUBSTR(cOBS,341,155),oFnt17,,0)
		oPrinter:Say(2070,0060,SUBSTR(cOBS,525,155),oFnt17,,0)
		oPrinter:Say(2110,0060,SUBSTR(cOBS,710,155),oFnt17,,0)
		oPrinter:Say(2150,0060,SUBSTR(cOBS,895,155),oFnt17,,0)
		oPrinter:Say(2190,0060,SUBSTR(cOBS,1080,155),oFnt17,,0)
		oPrinter:Say(2230,0060,SUBSTR(cOBS,1265,155),oFnt17,,0)
	Endif
	
	oPrinter:Box(2250,0050,3002,1200)
	oPrinter:Say(2280,0060,"Formas de Pagamento",oFnt11,,0)
	
	aAdm 	:= {}
	nQtdChk	:= RetQtdChk(SUA->UA_NUM,"CH")
	nQtdBol	:= RetQtdChk(SUA->UA_NUM,"BOL")
	nCheck	:= 0
	nTotBol	:= 0
	xTotBl  := 0
	nVlSL4  := 0
	//Carrega as forma de pagamento da venda.
	If Select("TRB1XX") > 0
		TRB1XX->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TRB1XX"
		SELECT *
		FROM %Table:SL4% SL4 (NOLOCK)
		WHERE 	L4_FILIAL = %xFilial:SL4% AND
		L4_NUM 	  = %Exp:SUA->UA_NUM% AND
		L4_ORIGEM = 'SIGATMK' AND
		SL4.%NotDel%
		ORDER BY L4_FILIAL,L4_NUM,L4_FORMA DESC
	EndSql
	
	nLinha := 2310
	While TRB1XX->(!Eof())
		
		If ALLTRIM(TRB1XX->L4_FORMA) == "CH"
			
			If !Empty(TRB1XX->L4_OBS)
				aCheque := Separa(TRB1XX->L4_OBS,"|")
			Endif
			
			If Len(aCheque) > 0
				cCheque:= aCheque[4]
			Else
				cCheque	:= ""
			Endif
			
			nCheck++
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nCheck))+"/"+AllTrim(Str(nQtdChk))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" Nº "+AllTrim(cCheque)+CRLF
			cFormaPG += "Bco. "+Alltrim(aCheque[1])+" Ag. "+Alltrim(aCheque[2])+" CC. "+Alltrim(aCheque[3])+" - CPF "+Alltrim(Transform(cCPF,"@R 999.999.999-99"))+CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nCheck))+"/"+AllTrim(Str(nQtdChk))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" Nº "+AllTrim(cCheque) + "Bco. "+Alltrim(aCheque[1])+" Ag. "+Alltrim(aCheque[2])+" CC. "+Alltrim(aCheque[3])+" - CPF "+Alltrim(Transform(cCPF,"@R 999.999.999-99"))
			
		ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "BOL"
			
			nTotBol++
			
			nVlSL4:=(TRB1XX->L4_VALOR) 
			
			xTotBl+=nVlSL4
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ + CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ
			
			Aadd(xArredBol,{ Alltrim(TRB1XX->L4_FORMA) , AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol)) ,Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) , DTOC(STOD(TRB1XX->L4_DATA)) })
						
		ElseIf Alltrim(TRB1XX->L4_FORMA)=="CC" .Or. Alltrim(TRB1XX->L4_FORMA)=="CD"
			
			nPos := aScan( aAdm , { |x| x[1] + x[2] + x[6] ==  Alltrim(TRB1XX->L4_FORMA) + Alltrim(TRB1XX->L4_ADMINIS) + Alltrim(TRB1XX->L4_AUTORIZ) } )	//#RVC20180602.n
			
			If nPos == 0
				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , Alltrim(TRB1XX->L4_AUTORIZ)  })	//#RVC20180602.n
			Else
				aAdm[nPos][3] += 1
				aAdm[nPos][5] += TRB1XX->L4_VALOR
			EndIf
			
			//#RVC20180602.bn
		ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "R$"
			
			cFormaPG += "Pagto em Espécie no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) + CRLF
			
			cLinha := "Pagto em Espécie no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) + CRLF
			
			//#RVC20180602.en
		Else
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+CRLF
			
		EndIf
		
		cLinha := AllTrim(cLinha)
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha += _nPular
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)
		EndIf
		
		IF !EMPTY(cLinha)
			nLinha += _nPular
		EndIF
		cLinha := ""
		
		xForm:=ALLTRIM(TRB1XX->L4_FORMA)
		
		TRB1XX->(DbSkip())
	EndDo
	
	For nX := 1 To Len(aAdm)
		cFormaPG += aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06] + CRLF
		cLinha   := aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06]
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha += _nPular
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)
		EndIf
		
		nLinha += _nPular
	Next nX
	
	oPrinter:Say(2280,1260,"Qtde. Total:",oFnt7,,0)
	oPrinter:Say(2280,2000,Alltrim(Transform(nQTDETOT 	,"@E 999999999.99")),oFnt3,,0)
	
	oPrinter:Say(2320,1260,"Peso Total:",oFnt7,,0)
	oPrinter:Say(2320,2000,Alltrim(Transform(nPESOTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2360,1260,"Total de ICMS R$:",oFnt7,,0)
	oPrinter:Say(2360,2000,Alltrim(Transform(SUA->UA_VALICM 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2400,1260,"Tipo Frete:",oFnt7,,0)
	oPrinter:Say(2400,2000,If(SC5->C5_TPFRETE=="C","CIF","FOB"),oFnt3,,0)
	
	oPrinter:Say(2440,1260,"Total dos Produtos R$:",oFnt7,,0)
	oPrinter:Say(2440,2000,Alltrim(Transform(nVLRTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2480,1260,"Total do IPI R$:",oFnt7,,0)
	oPrinter:Say(2480,2000,Alltrim(Transform(SUA->UA_VALIPI 	,"@E 999,999,999.99"))     ,oFnt3,,0)
	
	//oPrinter:Say(3040,1240,"Data: " + DTOC(dDataBase),oFnt7,,0)
	oPrinter:Say(2520,1260,"Frete/Seguro/Outras Despesas R$:",oFnt7,,0)
	oPrinter:Say(2520,2000,Alltrim(Transform((SC5->C5_FRETE+SC5->C5_DESPESA) 	,"@E 999,999,999.99")),oFnt7,,0)
	
	oPrinter:Say(2620,1260,"Total R$:",oFnt1,,0)
	oPrinter:Say(2620,2000,Alltrim(Transform((nVLRTOT + SC5->C5_FRETE+SC5->C5_DESPESA) 	,"@E 999,999,999.99")),oFnt1,,0)
	
	oPrinter:Say(2900,1250,"_______________________",oFnt7,,0)
	oPrinter:Say(2940,1310,"Visto do Comprador",oFnt7,,0)
	
	oPrinter:Say(2900,1860,"_______________________",oFnt7,,0)
	oPrinter:Say(2940,2040,"Vendedor",oFnt7,,0)
	
	oPrinter:EndPage()
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CABECALHO DAS INFORMACOES DOS ITENS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrinter:Box(0750,0050,2865,0150)
	oPrinter:Say(0770,0060,"Item",oFnt12,,0)
	
	oPrinter:Box(0750,0150,2865,0435)
	oPrinter:Say(0770,0160,"Código",oFnt12,,0)
	
	oPrinter:Box(0750,0435,2865,0505)
	oPrinter:Say(0770,0445,"TP",oFnt12,,0)
	
	oPrinter:Box(0750,0500,2865,1200)
	oPrinter:Say(0770,0510,"Descrição",oFnt12,,0)
	
	oPrinter:Box(0750,1200,2865,1400)
	oPrinter:Say(0770,1210,"Peso Bruto",oFnt12,,0)
	
	oPrinter:Box(0750,1400,2865,1600)
	oPrinter:Say(0770,1410,"Peso Liq.",oFnt12,,0)
	
	oPrinter:Box(0750,1600,2865,1700)
	oPrinter:Say(0770,1610,"Qtde.",oFnt12,,0)
	
	oPrinter:Box(0750,1700,2865,1800)
	oPrinter:Say(0770,1710,"UM",oFnt12,,0)
	
	oPrinter:Box(0750,1800,2865,2000)
	oPrinter:Say(0770,1810,"Vlr.Uniário",oFnt12,,0)
	
	oPrinter:Box(0750,2000,2865,2100)
	oPrinter:Say(0770,2010,"IPI",oFnt12,,0)
	
	oPrinter:Box(0750,2100,2865,2300)
	oPrinter:Say(0770,2110,"Vlr.Total",oFnt12,,0)
	
	oPrinter:Box(0750,2300,2865,2372)
	oPrinter:Say(0770,2302,"ICM",oFnt12,,0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESENHA A LINHA DAS TABELA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrinter:Box(0785,0050,0785,2375) // CABECALHO
	oPrinter:Box(0870,0050,0870,2375) // CABECALHO
	oPrinter:Box(0975,0050,0975,2375) // LINHA 01  -- QUEBRA EM 105
	oPrinter:Box(1080,0050,1080,2375) // LINHA 02  -- QUEBRA EM 135
	oPrinter:Box(1185,0050,1185,2375) // LINHA 03  -- QUEBRA EM 135
	oPrinter:Box(1290,0050,1290,2375) // LINHA 04  -- QUEBRA EM 135
	oPrinter:Box(1395,0050,1395,2375) // LINHA 05  -- QUEBRA EM 135
	oPrinter:Box(1500,0050,1500,2375) // LINHA 06  -- QUEBRA EM 135
	oPrinter:Box(1605,0050,1605,2375) // LINHA 07  -- QUEBRA EM 135
	
	oPrinter:Box(1710,0050,1710,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(1815,0050,1815,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(1920,0050,1920,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2025,0050,2025,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2130,0050,2130,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2235,0050,2235,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2340,0050,2340,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2445,0050,2445,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2550,0050,2550,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2655,0050,2655,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2760,0050,2760,2375) // LINHA 07  -- QUEBRA EM 135
	oPrinter:Box(2865,0050,2865,2375) // LINHA 07  -- QUEBRA EM 135
	//	oPrinter:Box(2970,0050,2970,2375) // LINHA 07  -- QUEBRA EM 135*/
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME OS DADOS DOS PRODUTOS DO PEDIDO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6") + cPEDIDO ))
	nLin := 0805
	
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPEDIDO
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SC6->C6_PRODUTO ))
		
		oPrinter:Say(nLin,0060,SC6->C6_ITEM,oFnt16,,0)
		oPrinter:Say(nLin,0160,SC6->C6_PRODUTO,oFnt16,,0)
		oPrinter:Say(nLin,0445,SB1->B1_TIPO,oFnt16,,0)
		
		oPrinter:Say(nLin,0510,SUBSTR(SC6->C6_DESCRI,1,45),oFnt16,,0)  // QUEBRA EM 35
		nLinAux := nLin + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(SC6->C6_DESCRI,46,45),oFnt16,,0)
		nLinAux := nLinAux + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(SC6->C6_DESCRI,92,45),oFnt16,,0)
		
		oPrinter:Say(nLin,1210,Alltrim(Transform(SB1->B1_PESBRU,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1410,Alltrim(Transform(SB1->B1_PESO,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1610,Alltrim(Transform(SC6->C6_QTDVEN,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1710,SC6->C6_UM,oFnt16,,0)
		oPrinter:Say(nLin,1810,Alltrim(Transform(SC6->C6_PRCVEN,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2010,Alltrim(Transform(SC6->C6_01IPI,"@E 99.99")),oFnt16,,0)
		oPrinter:Say(nLin,2110,Alltrim(Transform(SC6->C6_VALOR,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2302,Alltrim(Transform(SB1->B1_PICM,"@E 99.99")),oFnt16,,0)
		
		If SC6->C6_ENTREG == _dDtBlqFi
			dPREVENT := CtoD('//')
		ElseIf SC6->C6_ENTREG == _dDtNoAge
			dPREVENT := _dEntreg
		Else
			dPREVENT := SC6->C6_ENTREG
		Endif
		
		If Empty(cCFOP)
			cCFOP 		:= SC6->C6_CF
			cDESCFOP 	:= POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_TEXTO")
		Endif
		
		nQTDETOT 	+= SC6->C6_QTDVEN
		nVLRTOT 	+= SC6->C6_PRCVEN*SC6->C6_QTDVEN
		nPESOTOT 	+= (SB1->B1_PESBRU * SC6->C6_QTDVEN)
		nM3TOT 		:= 0
		
		/*
		Alterado em 13/07/2017 - Rogério Doms
		Verificado se existe item do orçamento com observação de venda de medida
		especial. Se encontrado um observação informar no campo Obs que existe
		itens com medida especial
		*/
		If !Empty(SC6->C6_01DESME) .And. Empty(cOBS)
			cOBS := "Este pEDIDO contém Item com Medida Especial"+CRLF
		EndIf
		
		nLin := nLin + 105
		
		SC6->(DbSkip())
	Enddo
	oPrinter:Say(0720,0070,"CFOP: " + cCFOP + " - " + cDESCFOP,oFnt11,,0)
	
	oPrinter:Say(2920,0060,"Sr(a) Cliente não assinar sem antes conferir todos dados cadastrais e etiqueta que consta a descrição do produto exposto em loja com descrição",oFnt13,,0)
	oPrinter:Say(2950,0060,"do produto neste pedido",oFnt13,,0)
	
	oPrinter:EndPage()
	
	oPrinter:StartPage()
	
	oPrinter:Box(0050,0050,3000,2375)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INFORMACOES INFERIORES DO PEDIDO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrinter:Box(0050,0050,3000,2375)
	
	cLinha1 := ""
	IF !EMPTY(SA1->A1_ENDENT)
		cLinha1 := ALLTRIM(SA1->A1_ENDENT)
	Else
		cLinha1 := ALLTRIM(SA1->A1_END)
		cLinha3 := "Complemento : " + ALLTRIM(SA1->A1_COMPLEM)
	EndIF
	
	IF !EMPTY(SA1->A1_BAIRROE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_BAIRROE)
	Else
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_BAIRRO)
	EndIF
	
	IF !EMPTY(SA1->A1_MUNE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_MUNE)
	Else
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_MUN)
	EndIF
	
	IF !EMPTY(SA1->A1_ESTE)
		cLinha1 := cLinha1 + " , " + ALLTRIM(SA1->A1_ESTE)
	Else
		cLinha1 := cLinha1 + " - " + ALLTRIM(SA1->A1_EST)
	EndIF
	
	cLinha2 := ""
	IF !EMPTY(SA1->A1_CEPE)
		cLinha2 := "CEP: " + Transform(SA1->A1_CEPE,"@R 99999-999" )
	Else
		cLinha2 := "CEP: " + Transform(SA1->A1_CEP,"@R 99999-999" )
	EndIF
	
	oPrinter:Say(0075,0060,"Endereço de Entrega",oFnt11,,0)
	oPrinter:Say(0125,0060,cLinha1,oFnt10,,0)
	oPrinter:Say(0165,0060,cLinha2,oFnt10,,0)
	oPrinter:Say(0205,0060,cLinha3,oFnt10,,0)
	
	oPrinter:Box(0050,1900,0250,2375)
	oPrinter:Say(0100,1910,"Previsão de Entrega",oFnt4,,0)
	oPrinter:Say(0170,2000,DTOC(dPREVENT),oFnt4,,0)
	
	oPrinter:Box(0250,0050,0630,2375)
	oPrinter:Say(0275,0060,"Observações",oFnt11,,0)
	
	cOBS += MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
	
	cObs := AllTrim(cOBS)
	oPrinter:Say(0325,0060,LEFT(cOBS,155),oFnt17,,0)
	oPrinter:Say(0375,0060,SUBSTR(cOBS,156,155),oFnt17,,0)
	oPrinter:Say(0405,0060,SUBSTR(cOBS,341,155),oFnt17,,0)
	oPrinter:Say(0445,0060,SUBSTR(cOBS,525,155),oFnt17,,0)
	oPrinter:Say(0485,0060,SUBSTR(cOBS,710,155),oFnt17,,0)
	oPrinter:Say(0525,0060,SUBSTR(cOBS,895,155),oFnt17,,0)
	oPrinter:Say(0565,0060,SUBSTR(cOBS,1080,155),oFnt17,,0)
	oPrinter:Say(00605,0060,SUBSTR(cOBS,1265,155),oFnt17,,0)
	
	oPrinter:Box(0630,0050,3002,1200)
	oPrinter:Say(0655,0060,"Formas de Pagamento",oFnt11,,0)
	
	aAdm 	:= {}
	nQtdChk	:= RetQtdChk(SUA->UA_NUM,"CH")
	nQtdBol	:= RetQtdChk(SUA->UA_NUM,"BOL")
	nCheck	:= 0
	nTotBol	:= 0
	
	//Carrega as forma de pagamento da venda.
	If Select("TRB1XX") > 0
		TRB1XX->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TRB1XX"
		SELECT *
		FROM %Table:SL4% SL4 (NOLOCK)
		WHERE 	L4_FILIAL = %xFilial:SL4% AND
		L4_NUM 	  = %Exp:SUA->UA_NUM% AND
		L4_ORIGEM = 'SIGATMK' AND
		SL4.%NotDel%
		ORDER BY L4_FILIAL,L4_NUM,L4_FORMA DESC
	EndSql
	
	nLinha := 0690
	While TRB1XX->(!Eof())
		
		If ALLTRIM(TRB1XX->L4_FORMA) == "CH"
			
			If !Empty(TRB1XX->L4_OBS)
				aCheque := Separa(TRB1XX->L4_OBS,"|")
			Endif
			
			If Len(aCheque) > 0
				cCheque:= aCheque[4]
			Else
				cCheque	:= ""
			Endif
			
			nCheck++
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nCheck))+"/"+AllTrim(Str(nQtdChk))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" Nº "+AllTrim(cCheque)+CRLF
			cFormaPG += "Bco. "+Alltrim(aCheque[1])+" Ag. "+Alltrim(aCheque[2])+" CC. "+Alltrim(aCheque[3])+" - CPF "+Alltrim(Transform(cCPF,"@R 999.999.999-99"))+CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nCheck))+"/"+AllTrim(Str(nQtdChk))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" Nº "+AllTrim(cCheque) + "Bco. "+Alltrim(aCheque[1])+" Ag. "+Alltrim(aCheque[2])+" CC. "+Alltrim(aCheque[3])+" - CPF "+Alltrim(Transform(cCPF,"@R 999.999.999-99"))
			
		ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "BOL"
			
			nTotBol++
			
			nVlSL4:=(TRB1XX->L4_VALOR) 
			
			xTotBl+=nVlSL4
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ + CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ
			
			Aadd(xArredBol,{ Alltrim(TRB1XX->L4_FORMA) , AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol)) ,Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) , DTOC(STOD(TRB1XX->L4_DATA)) })
						
		ElseIf Alltrim(TRB1XX->L4_FORMA)=="CC" .Or. Alltrim(TRB1XX->L4_FORMA)=="CD"
			
			//			nPos := aScan( aAdm , { |x| x[1]+x[2] ==  Alltrim(TRB1XX->L4_FORMA)+Alltrim(TRB1XX->L4_ADMINIS) } )												//#RVC20180602.o
			nPos := aScan( aAdm , { |x| x[1] + x[2] + x[6] ==  Alltrim(TRB1XX->L4_FORMA) + Alltrim(TRB1XX->L4_ADMINIS) + Alltrim(TRB1XX->L4_AUTORIZ) } )	//#RVC20180602.n
			
			If nPos == 0
				//				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , TRB1XX->L4_AUTORIZ  })			//#RVC20180602.o
				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , Alltrim(TRB1XX->L4_AUTORIZ)  })	//#RVC20180602.n
			Else
				aAdm[nPos][3] += 1
				aAdm[nPos][5] += TRB1XX->L4_VALOR
			EndIf
			
			//#RVC20180602.bn
		ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "R$"
			
			cFormaPG += "Pagto em Espécie no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) + CRLF
			
			cLinha := "Pagto em Espécie no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99")) + CRLF
			
			//#RVC20180602.en
		Else
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+CRLF
			
		EndIf
		
		
		cLinha := AllTrim(cLinha)
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha += _nPular
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)
		EndIf
		
		IF !EMPTY(cLinha)
			nLinha += _nPular
		EndIF
		cLinha := ""
		xForm:=ALLTRIM(TRB1XX->L4_FORMA)
		TRB1XX->(DbSkip())
	EndDo
	
	For nX := 1 To Len(aAdm)
		cFormaPG += aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06] + CRLF
		cLinha   := aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06]
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha += _nPular
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)
		EndIf
		
		nLinha += _nPular
	Next nX
	
	oPrinter:Say(0660,1260,"Qtde. Total:",oFnt7,,0)
	oPrinter:Say(0660,2000,Alltrim(Transform(nQTDETOT 	,"@E 999999999.99")),oFnt3,,0)
	
	oPrinter:Say(0720,1260,"Peso Total:",oFnt7,,0)
	oPrinter:Say(0720,2000,Alltrim(Transform(nPESOTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0780,1260,"Total de ICMS R$:",oFnt7,,0)
	oPrinter:Say(0780,2000,Alltrim(Transform(SUA->UA_VALICM 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0840,1260,"Tipo Frete:",oFnt7,,0)
	oPrinter:Say(0840,2000,If(SC5->C5_TPFRETE=="C","CIF","FOB"),oFnt3,,0)
	
	oPrinter:Say(0900,1260,"Total dos Produtos R$:",oFnt7,,0)
	oPrinter:Say(0900,2000,Alltrim(Transform(nVLRTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0960,1260,"Total do IPI R$:",oFnt7,,0)
	oPrinter:Say(0960,2000,Alltrim(Transform(SUA->UA_VALIPI 	,"@E 999,999,999.99"))     ,oFnt3,,0)
	
	//oPrinter:Say(3040,1240,"Data: " + DTOC(dDataBase),oFnt7,,0)
	oPrinter:Say(1020,1260,"Frete/Seguro/Outras Despesas R$:",oFnt7,,0)
	oPrinter:Say(1020,2000,Alltrim(Transform((SC5->C5_FRETE+SC5->C5_DESPESA) 	,"@E 999,999,999.99")),oFnt7,,0)
	
	oPrinter:Say(1170,1260,"Total R$:",oFnt1,,0)
	oPrinter:Say(1170,2000,Alltrim(Transform((nVLRTOT + SC5->C5_FRETE+SC5->C5_DESPESA) 	,"@E 999,999,999.99")),oFnt1,,0)
	
	oPrinter:Say(1500,1250,"_______________________",oFnt7,,0)
	oPrinter:Say(1555,1310,"Visto do Comprador",oFnt7,,0)
	
	oPrinter:Say(1500,1880,"_______________________",oFnt7,,0)
	oPrinter:Say(1555,2030,"Vendedor",oFnt7,,0)
	
	oPrinter:EndPage()
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRESSAO DO CONTRATO DO PEDIDO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//PAGINA 1
oPrinter:StartPage()

oPrinter:Box(0050,0050,3000,2375)
oPrinter:Say(0080,0100,"PREZADO CLIENTE, ANTES DE ASSINAR ESTE PEDIDO NÚMERO: " + cPedido + " , LEIA ATENTAMENTE O SEU CONTEÚDO E ASSINE NO FINAL.",oFnt5,,0)

oPrinter:Say(0120,0100,"O cliente / Comprador abaixo declara estar ciente que:",oFnt15,,0)

oPrinter:Say(0150,0065,"1)A mercadoria comprada foi de sua escolha e que conferiu o pedido com a etiqueta do produto comprado na loja.",oFnt15,,0)

oPrinter:Say(0180,0065,"2)O cliente ou pessoa por ele autorizada, desde que maior de 18 anos, deverá estar em casa em horário comercial na data agendada no momento da compra ou que foi acordada via ",oFnt15,,0)
oPrinter:Say(0210,0085,"telefone em caso de produtos por encomendas. Ressaltando que caso não tenha nenhum responsável no local no ato da entrega, o produto retornará e será feito novo contato ",oFnt15,,0)
oPrinter:Say(0240,0085,"para reagendamento, onde haverá cobrança de uma taxa de R$ 150,00.",oFnt15,,0)

oPrinter:Say(0270,0065,"3)Caso não seja autorizada a montagem na data do recebimento e venha ser solicitada posteriormente, será cobrado uma taxa pela visita do profissional de R$ 70,00 (setenta reais).",oFnt15,,0)

oPrinter:Say(0300,0065,"4)A entrega ocorrerá apenas no endereço informado no ato da compra. ",oFnt15,,0)

oPrinter:Say(0330,0065,"5)A Komfort House não se responsabiliza por problemas de colocação dentro do local da entrega, cabendo ao cliente informar no ato da compra a situação de acesso para a montagem do",oFnt15,,0)
oPrinter:Say(0360,0085,"produto,bem como a existência de regras de condomínio, levando em consideração a possível dificuldade de passagem e entrada do produto até a área da montagem e em casos de ",oFnt15,,0)
oPrinter:Say(0390,0085,"entrega onde o local a ser montado o produto for superior a 3 metros de altura o mesmo terá que contratar o serviço de içamento, assumindo a responsabilidade. ",oFnt15,,0)

oPrinter:Say(0420,0065,"6)O prazo de entrega das mercadorias disponíveis em estoque é de 48 horas. Para o caso de produtos de encomenda o cliente concorda com o prazo máximo de entrega de 35 dias uteis, ",oFnt15,,0)
oPrinter:Say(0450,0085,"ou outro estipulado de comum acordo, descrito no campo de observação do pedido de venda. ",oFnt15,,0)

oPrinter:Say(0480,0065,"7)Em caso de identificação de avaria no produto no ato da entrega, o cliente se compromete a notificar a avaria na nota de recebimento, podendo optar pelo retorno do produto com o",oFnt15,,0)
oPrinter:Say(0510,0085,"motorista ou manter o mesmo no local. Nossa Central de Atendimento entrará em contato com o cliente para reagendar a entrega do novo produto e se for o caso, retirar o avariado.",oFnt15,,0)

oPrinter:Say(0540,0065,"8)Se no momento da troca houver vícios diversos dos assinalados no laudo de vistoria, a troca somente será realizada mediante o pagamento de 20% do valor do produto.",oFnt15,,0)

oPrinter:SayBitMap(560,180,_cSofaF,0750,0300)
oPrinter:SayBitMap(560,1450,_cSofaB,0750,0300)

oPrinter:Say(880,0065,"9)Detalhes:________________________________________________________________________________________________________________________________________________________ ",oFnt15,,0)
oPrinter:Say(930,0065,"10)_______________________________________________________________________________________________________________________________________________________________ ",oFnt15,,0)
oPrinter:Say(980,0065,"11)_______________________________________________________________________________________________________________________________________________________________ ",oFnt15,,0)

oPrinter:Say(1010,0065,"12)Para as mercadorias expostas na loja (compra de mostruário) não serão efetuadas trocas por adaptação, sendo que o cliente está ciente que o produto é vendido no estado em que se",oFnt15,,0)
oPrinter:Say(1040,0085,"encontra, conforme apontamento no croqui anexo, não cabendo qualquer responsabilidade à Komfort House nesse sentido. Caso a mercadoria apresente outros defeitos, o fabricante",oFnt15,,0)
oPrinter:Say(1070,0085,"enviará um técnico para avaliação, e caso sejam constatados defeitos diferentes aos apontados abaixo, o produto será retirado para conserto e o frete ficará por conta do",oFnt15,,0)
oPrinter:Say(1100,0085,"cliente/comprador.",oFnt15,,0)

oPrinter:Say(1130,0065,"13)Caso o produto apresente vícios ou defeitos o cliente deverá enviar evidencias através de fotos/vídeo para o SAC da loja onde será avaliado se, trata-se de troca ou conserto, ou ainda a ",oFnt15,,0)
oPrinter:Say(1160,0085,"necessidade de envio do técnico para realizar a vistoria no local indicado, respeitando o prazo determinado pelo Código de Defesa do Consumidor de 30 dias. Caso o conserto esteja",oFnt15,,0)
oPrinter:Say(1190,0085,"fora da garantia, a Komfort House não se responsabilizara pelo mesmo.",oFnt15,,0)

oPrinter:Say(1220,0065,"14)Em caso de impermeabilização do produto, haverá perda da garantia de 90 dias.",oFnt15,,0)

oPrinter:Say(1250,0065,"15)A troca deve ser no valor da compra, mas caso queira outra mercadoria de valor diferente, terá que pagar a diferença para emissão de novo pedido, onde o agendamento para a entrega",oFnt15,,0)
oPrinter:Say(1280,0085,"da troca ocorrerá após a confirmação de pagamento.",oFnt15,,0)

oPrinter:Say(1310,0065,"16)O prazo de garantia dos produtos Komfort House é de 90 (noventa) dias.",oFnt15,,0)

oPrinter:Say(1340,0065,"17)Troca do produto sem defeito de fabricação, será submetido a analise do setor de trocas e caso aprovado é assegurado a Komfort House o direito de cobrar uma taxa de 35% sobre",oFnt15,,0)
oPrinter:Say(1370,0085,"o valor da compra para higienização, mais frete.",oFnt15,,0)

oPrinter:Say(1400,0065,"18)Na entrega fora do estado de São Paulo, a Komfort House se responsabiliza somente até a entrega na transportadora indicada pelo cliente, e a partir daí o comprador assume as",oFnt15,,0)
oPrinter:Say(1430,0085,"responsabilidades, com o pagamento da transportadora, montagem e avarias.",oFnt15,,0)

oPrinter:Say(1460,0065,"19)A mercadoria que for destinada a localidades que não possuam assistência técnica, caso seja necessário realizar troca ou conserto, as despesas do transporte serão responsabilidade",oFnt15,,0)
oPrinter:Say(1490,0085,"do cliente / comprador.",oFnt15,,0)

oPrinter:Say(1520,0065,"20)Nos casos em que o cliente solicitar modificação no produto, tais como redução de medidas ou qualquer tipo de alteração na estrutura original, caso venha apresentar vícios dentro",oFnt15,,0)
oPrinter:Say(1550,0085,"do prazo de garantia de 90 dias, o mesmo não será substituído, sendo realizado o reparo a fim de sanar o vício.",oFnt15,,0)

oPrinter:Say(1580,0065,"21)Nos casos em que o cliente necessite que os produtos fiquem guardados no estoque, a komfort House se responsabiliza pela guarda dos mesmos pelo prazo máximo de 6 (seis) meses.",oFnt15,,0)
oPrinter:Say(1610,0085,"Após esse período, sem que haja contato do cliente para agendar a entrega, o produto será comercializado, ficando o valor pago pelo cliente, como crédito para escolha de outro ",oFnt15,,0)
oPrinter:Say(1640,0085,"produto na loja.",oFnt15,,0)

oPrinter:Say(1670,0065,"22)Em caso de sinistro com o produto ocorrido durante o trajeto da entrega, a empresa Komfort House entrará em contado com o cliente notificando-o do ocorrido e fará o reagendamento",oFnt15,,0)
oPrinter:Say(1700,0085,"da entrega do produto. Ressaltando que se o produto for objeto de encomenda, o prazo de entrega permanecerá de 30 dias a contar da data do sinistro.",oFnt15,,0)

oPrinter:Say(1730,0065,"23)Em caso de Cancelamento imotivado da venda, o processo será submetido a analise da Komfort House, e caso aprovado é assegurado a Komfort House o direito de cobrar uma taxa de",oFnt15,,0)
oPrinter:Say(1760,0085,"20% sobre o valor da compra mais frete, inclusive abater no valor que será devolvido.",oFnt15,,0)

oPrinter:Say(1790,0065,"24)Na compra a vista com pagamento em cheque, a eventual devolução do cheque autoriza a Komfort House cancelar a venda unilateralmente. Caso a mercadoria ainda não tenha sido ",oFnt15,,0)
oPrinter:Say(1820,0085,"entregue, a Komfort House poderá inclusive cobrar ou debitar dos valores já pagos uma taxa administrativa no valor correspondente a 20% do valor do pedido.",oFnt15,,0)

oPrinter:Say(1850,0065,"25)O cliente / comprador declara não sustar / frustrar o pagamento dos cheques ou das faturas de cartões de credito sem previa autorização da Komfort House, e se isto ocorrer fica ciente",oFnt15,,0)
oPrinter:Say(1880,0085,"que pagará uma multa de até 20% do valor das compras efetuadas e ainda terá os cheques protestados.",oFnt15,,0)

oPrinter:Say(1910,0065,"26)Na compra por encomenda com medidas especiais, cor, detalhes de sua necessidade ou preferencia e a Komfort House for mera executora do projeto desenvolvido pelo cliente, após a ",oFnt15,,0)
oPrinter:Say(1940,0085,"efetivação do pedido, não há possibilidade de cancelamento ou troca por adaptação ou arrependimento.",oFnt15,,0)

oPrinter:Say(1970,0065,"27)O cliente / comprador está ciente de todos os termos e condições do contrato de compra e venda aqui firmado e caso ocorra inadimplência a Komfort House poderá valer–se de todos os ",oFnt15,,0)
oPrinter:Say(2000,0085,"meios de cobrança possíveis, inclusive a inscrição dos seus dados perante o SERASA e SPC.",oFnt15,,0)

oPrinter:Say(2030,0065,"28)Na compra com pagamento em cheque à vista ou boleto, a entrega só será agendada após a confirmação da compensação do cheque, e se for a prazo, o agendamento será feito somente",oFnt15,,0)
oPrinter:Say(2060,0085,"após aprovação do crédito. ",oFnt15,,0)

oPrinter:Say(2090,0065,"29)A falta de aprovação do credito autoriza a Komfort House cancelar a venda unilateralmente sem ônus para ambas as partes. ",oFnt15,,0)

oPrinter:Say(2120,0065,"30)Autorizo a KOMFORT HOUSE a ceder, transferir, empenhar, alienar, dispor dos direitos e garantias decorrentes deste contrato, independentemente de prévia comunicação.",oFnt15,,0)

oPrinter:Say(2150,0065,"31)Autorizo a Cessionária a registrar as informações decorrentes deste contrato e de minha responsabilidade junto ao Sistema de Informações de Crédito (SCR) do Banco Central ",oFnt15,,0)
oPrinter:Say(2180,0085,"do Brasil (BACEN), para fins de supervisão do risco de crédito e intercâmbio de informações com outras instituições financeiras. Estou ciente de que a consulta ao SCR pela ",oFnt15,,0)
oPrinter:Say(2210,0085,"Cessionária depende dessa prévia autorização e que poderei ter acesso aos dados do SCR pelos meios colocados à minha disposição pelo BACEN, sendo que eventuais pedidos de ",oFnt15,,0)
oPrinter:Say(2240,0085,"correções, exclusões, registros de medidas judiciais e de manifestações de discordância sobre as informações inseridas no SCR deverão ser efetuados por escrito, acompanhados,",oFnt15,,0)
oPrinter:Say(2270,0085,"se necessário, de documentos. Ainda, autorizo (i) a fornecer e compartilhar as informações cadastrais, financeiras e de operações ativas e passivas e serviços prestados junto a ",oFnt15,,0)
oPrinter:Say(2300,0085,"outras instituições pertencentes ao Conglomerado da Cessionária, ficando todas autorizadas a examinar e utilizar, no Brasil e no exterior, tais informações, inclusive para ofertas",oFnt15,,0)
oPrinter:Say(2330,0085,"de produtos e serviços; (ii) a informar aos órgãos de proteção ao crédito, tais como SERASA e SPC, os dados relativos à falta de pagamento de obrigações assumidas e (iii) a ",oFnt15,,0)
oPrinter:Say(2360,0085,"compartilhar informações cadastrais com outras instituições financeiras e a contatar-me por meio de Cartas, e-mails, Short Message Service (SMS) e telefone, inclusive para ofertar",oFnt15,,0)
oPrinter:Say(2390,0085,"produtos e serviços. ",oFnt15,,0)

oPrinter:Say(2420,0065,"32)Se o pagamento for feito mediante débito automático em conta corrente, desde já autoriza o banco indicado a acolher a solicitação de débito que vier a ser apresentada.",oFnt15,,0)

oPrinter:Say(2450,0065,"33)A quitação das parcelas pagas por cheque ou boleto bancário somente ocorrerá após a efetiva compensação e disponibilização do recurso ao credor. ",oFnt15,,0)

oPrinter:Say(2480,0065,"34)Estou ciente de que se eu atrasar o pagamento, sobre o valor da obrigação vencida incidirão encargos calculados sobre o valor da obrigação vencida acrescida da multa. ",oFnt15,,0)

oPrinter:Say(2510,0065,"35)As informações prestadas pelo cliente / comprador são verdadeiras e o mesmo assume todas as responsabilidades civil e penal. ",oFnt15,,0)

oPrinter:Say(2650,0100,"São Paulo _____ de _________________________ de 20_____",oFnt2,,0)

oPrinter:Say(2800,0100,"_______________________________",oFnt2,,0)
oPrinter:Say(2850,0100,"Assinatura do cliente comprador",oFnt2,,0)

oPrinter:Say(2800,1200,"_____________________________________________",oFnt2,,0)
oPrinter:Say(2850,1200,"Representante Komfort House Sofás LTDA - EPP",oFnt2,,0)

oPrinter:EndPage()

//Taratamento para chamada da função que imprime a declaração - Ticket 8274

If !Empty(xArredBol)
	
	oPrinter:StartPage()
	
	oPrinter:SayBitMap(0140,1100,cImag001,0250,0175)
	oPrinter:Say(0380,0740,"Uma casa só é completa com um bom sofá",oFnt2,,0)
	
	oPrinter:Say(0410,0620,"______________________________ ",oFnt1,,0)
	oPrinter:Say(0490,0990,"Declaração",oFnt1,,0)
	
	
	oPrinter:Say(0690,0140, "Retirei  na  data  de  hoje  junto  à Komfort  House  Sofás,  Filial " + Alltrim(SM0->M0_FILIAL),oFnt2,,0 )
	oPrinter:Say(0790,0140, "os boletos  bancários  abaixo  relacionados  no  valor   total de R$  " + Alltrim(Transform(xTotBl,"@E 999,999,999.99")) +","  ,oFnt2,,0)
	oPrinter:Say(0890,0140, "referente ao Pedido de Vendas nr.: " +cPedido ,oFnt2,,0)
	
	nLinha:=1000
	
	
	For nX := 1 To Len(xArredBol)
		cLinha   := " -  Parcelas: " + xArredBol[nX][2] +" - Vencimento: "+ xArredBol[nX][4] +" - Valor (R$)  "+ Alltrim(xArredBol[nX][3])
		
		oPrinter:Say(nLinha,0140,cLinha,oFnt2,,0)
		nLinha += _nPular
		nLinha += _nPular
	Next nX
	
	oPrinter:Say(1900,0140,"Local :______________________________________________ Data: _____/____ /_____",oFnt2,,0)
	
	oPrinter:Say(2100,0140,"_____________________________________________",oFnt2,,0)
	oPrinter:Say(2150,0140,"Assinatura",oFnt2,,0)
	
	oPrinter:Say(2300,0140,"_____________________________________________",oFnt2,,0)
	oPrinter:Say(2350,0140,"Sr.(a)  " + xNomCli,oFnt2,,0)
	
	oPrinter:Say(2500,0140,"_____________________________________________",oFnt2,,0)
	oPrinter:Say(2550,0140,"E-mail",oFnt2,,0)
	
	
	oPrinter:EndPage()
	
	cFilAnt := _cFilBkp
Endif
oPrinter:Preview()

cFilAnt := _cFilBkp

RETURN()

/*/{Protheus.doc} RetQtdChk
Retorna quantidade de cheques selecionados na forma de pagamento.

@author André Lanzieri
@since 27/12/2016
@version 1.0
/*/
Static Function RetQtdChk(cORCAMENTO,cForma)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local _nRec		:= 0

cQuery += " SELECT SL4.L4_FORMA FROM "+RetSqlName("SL4")+" SL4					"

cQuery += " WHERE SL4.L4_FILIAL = '"+xFilial("SL4")+"' 							"
cQuery += "	AND SL4.L4_NUM 		= '"+Padr(cORCAMENTO,TamSx3("L4_NUM")[1])+"' 	"
cQuery += "	AND SL4.L4_FORMA 	= '"+Padr(cForma,TamSx3("L4_FORMA")[1])+"' 		"
cQuery += " AND SL4.D_E_L_E_T_ 	= ' '											"

TCQUERY cQuery NEW ALIAS (cAlias)

Count to _nRec //quantidade registros

(cAlias)->(DbCloseArea())

Return(_nRec)

/*
+===========================================================================+
|===========================================================================|
|Programa: fEnvMail     | Tipo: Função                |  Data: 13/05/2014   |
|===========================================================================|
|Programador: Caio Garcia - Komfort                                         |
|===========================================================================|
|Utilidade: Enviar e-mail com anexo.                                        |
|                                                                           |
|===========================================================================|
+===========================================================================+
*/

Static Function fEnvMail(cEnvia,cAssunto,cAnexos,cMensagem)

cServer     := GETMV('MV_RELSERV')
cAccount    := GETMV('MV_RELACNT')
cPassword   := GETMV('MV_RELAPSW')

//cEnvia := "caio@globalgcs.com.br"
//cAnexos := "\rpedcom\pedido_compra000054.pdf"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conecta no Servidor SMTP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lConectou:=MailSmtpOn(cServer, cAccount, cPassword )

If !lConectou
	Alert("Não conectou SMTP")
Endif

MailAuth(cAccount,cPassword)

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
Send Mail From cAccount To cEnvia SubJect cAssunto BODY cMensagem ATTACHMENT cAnexos RESULT lEnviado

If !lEnviado
	cErro := ""
	Get Mail Error cErro
	
	Alert(cErro)
	
Else
	
	//	Alert("E-mail Enviado com Sucesso!!")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desconecta do Servidor SMTP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Disconnect SMTP SERVER Result lDesConectou

If !lDesconectou
	Alert("Não Desconectou SMTP")
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDiasValid  º Autor ³ Caio Garcia     º Data ³  20/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula dias uteis                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fDiasValid(_dData,_nDias)

Local _dRet := _dData
Local _nz   := 0
Local _lSai := .F.
Local _nRet := 0

While !_lSai
	
	_dRet := _dRet+1
	
	If DateWorkDay( _dData, _dRet ) >= _nDias
		
		_lSai := .T.
		
	EndIf
	
EndDo

Return _dRet
