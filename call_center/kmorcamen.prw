#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMORCAMEN º Autor ³ LUIZ EDUARDO F.C.  º Data ³  19/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRESSAO DE ORCAMENTO KOMFORT                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMORCAMEN(cORCAMENTO,_lMail,_cFil)

Local cImag001 	:= "C:\totvs\logo.png"
Local cImag002 	:= "C:\totvs\sofas.png"
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
Local oFnt15	:= TFont():New("",,10,,.F.,,,,,.F.,.F.)
Local oFnt16	:= TFont():New("",,9.5,,.F.,,,,,.F.,.F.)
Local oFnt17	:= TFont():New("",,10,,.F.,,,,,.F.,.F.)
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
Local _nPula     := 30
Local cLinha    := ""
Local cLinha3	:= ""
Local cQuery    := ""
Local nItens    := 0 
Local _cFilBkp  := cFilAnt 
Private _cFilial  := ""
Private _cNome    := ""       
Private _nLimConf := 85

Default cORCAMENTO		:= SUA->UA_NUM
Default _lmail      := .F.   
Default _cFil      := cFilAnt   
                          
If cFilAnt <> _cFil .And. !Empty(AllTrim(_cFil))
     
	cFilAnt := _cFil

EndIf

IF !ExistDir("C:\KMORCAMENTO")
	
	MakeDir("C:\KMORCAMENTO")
	
EndIF                    

_cNomeArq:=cOrcamento+"_"+DtoS(DDataBase)+Subs(Time(),1,2)+Subs(Time(),4,2)+".pdf"
               
//oPrinter := tAvPrinter():New(_cNomeArq)
oPrinter := FWMsPrinter():New(_cNomeArq,6,.T., ,.T., , , , ,.F., , .T., )
                             
cQuery := " SELECT COUNT(*) AS ITENS FROM " + RETSQLNAME("SUB")
cQuery += " WHERE UB_FILIAL = '" + xFilial("SUB") + "' "
cQuery += " AND UB_NUM = '" + cORCAMENTO + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	nItens := TRB->ITENS
	TRB->(!DbSkip())
EndDo

U_FM_Direct( cLocal, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ AS COPIAS DAS IMAGENS DO SERVIDOR PARA A PASTA LOCAL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CpyS2T("\system\logo.png",cLocal,.F.)      

dbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt+cFilAnt))
               
dBSelectArea("SUA")
SUA->(DbSetOrder(1))
SUA->(DbSeek(xFilial("SUA") + cOrcamento ))

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA))

//oPrinter:Setup()
oPrinter:SetPortrait()
oPrinter:cPathPDF := "C:\KMORCAMENTO\"
oPrinter:StartPage()

oPrinter:Box(0050,0050,3000,2375)

oPrinter:Box(0050,0050,0300,2375)
oPrinter:Box(0050,0050,0300,0350)
oPrinter:SayBitMap(0080,080,cImag001,0250,0175)
oPrinter:Say(0140,0700,"KOMFORT HOUSE SOFAS",oFnt1,,0)
oPrinter:Say(0210,0640,"Uma casa só é completa com um bom sofá",oFnt2,,0)

oPrinter:Say(0335,1810,ALLTRIM(SM0->M0_FILIAL),oFnt8,,0)
oPrinter:Box(0050,1800,0300,2372)
oPrinter:Say(0090,1930,"Orçamento",oFnt2,,0)     
oPrinter:Say(0160,1970,cOrcamento,oFnt1,,0)              
oPrinter:Say(0250,1870,"Emissão: " + DTOC(SUA->UA_EMISSAO),oFnt8,,0)
oPrinter:Box(0300,0050,0400,2375)
oPrinter:Say(0330,0080,UPPER(AllTrim(SM0->M0_ENDENT)) + " - " +  UPPER(AllTrim(SM0->M0_BAIRENT)) + " - " +  UPPER(AllTrim(SM0->M0_CIDENT)) + " - " + UPPER(AllTrim(SM0->M0_ESTENT)),oFnt10,,0)
oPrinter:Say(0380,0080,"CEP: " + Transform(SM0->M0_CEPENT,"@R 99999-999" ) + " Telefone/Fax (11) " + AllTrim(SM0->M0_TEL) + " - fiscal@komforthouse.com.br",oFnt10,,0)
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
	nLin := 0805
	
	SUB->(DbSetOrder(1))
	SUB->(DbSeek(xFilial("SUB") + cORCAMENTO ))
	While !Eof() .And. SUB->UB_FILIAL + SUB->UB_NUM == xFilial("SUB") + cORCAMENTO
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SUB->UB_PRODUTO ))
		
		IF !EMPTY(SUB->UB_DESCPER)
			cDesc := ALLTRIM(SB1->B1_DESC) + " // " + ALLTRIM(SUB->UB_DESCPER)
		Else
			cDesc := ALLTRIM(SB1->B1_DESC)
		EndIF
					
		oPrinter:Say(nLin,0060,SUB->UB_ITEM,oFnt16,,0)
		oPrinter:Say(nLin,0160,SUB->UB_PRODUTO,oFnt16,,0)
		oPrinter:Say(nLin,0445,SB1->B1_TIPO,oFnt16,,0)
		
		oPrinter:Say(nLin,0510,SUBSTR(cDesc,1,45),oFnt16,,0)  // QUEBRA EM 35
		nLinAux := nLin + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(cDesc,46,45),oFnt16,,0)
		nLinAux := nLinAux + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(cDesc,92,45),oFnt16,,0)
		
		oPrinter:Say(nLin,1210,Alltrim(Transform(SB1->B1_PESBRU,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1410,Alltrim(Transform(SB1->B1_PESO,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1610,Alltrim(Transform(SUB->UB_QUANT,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1710,SUB->UB_UM,oFnt16,,0)
		oPrinter:Say(nLin,1810,Alltrim(Transform(SUB->UB_VRUNIT,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2010,Alltrim(Transform(SB1->B1_IPI,"@E 99.99")),oFnt16,,0)
		oPrinter:Say(nLin,2110,Alltrim(Transform(SUB->UB_VLRITEM,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2302,Alltrim(Transform(SB1->B1_PICM,"@E 99.99")),oFnt16,,0)  
	
		If SUB->UB_DTENTRE >= dPREVENT
			dPREVENT := SUB->UB_DTENTRE
		Endif
	
		If Empty(cCFOP)
			cCFOP 		:= SUB->UB_CF 
			cDESCFOP 	:= POSICIONE("SF4",1,xFilial("SF4")+SUB->UB_TES,"F4_TEXTO")
		Endif	
				
		nQTDETOT 	+= SUB->UB_QUANT
		nVLRTOT 	+= SUB->UB_VLRITEM
		nPESOTOT 	+= (SB1->B1_PESBRU * SUB->UB_QUANT)
		nM3TOT 		:= 0
		
		/*
		Alterado em 13/07/2017 - Rogério Doms
		Verificado se existe item do orçamento com observação de venda de medida
		especial. Se encontrado um observação informar no campo Obs que existe
		itens com medida especial
		*/
		If ! Empty(SUB->UB_01DESME) .And. Empty(cOBS)
			cOBS := "Este Orçamento contém Item com Medida Especial"+CRLF
		EndIf
		
		nLin := nLin + 105
		
		SUB->(DbSkip())
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
	
	oPrinter:Say(1950,0060,LEFT(cOBS,185),oFnt17,,0)
	oPrinter:Say(1990,0060,SUBSTR(cOBS,186,185),oFnt17,,0)
	oPrinter:Say(2030,0060,SUBSTR(cOBS,371,185),oFnt17,,0)
	oPrinter:Say(2070,0060,SUBSTR(cOBS,555,185),oFnt17,,0)
	oPrinter:Say(2110,0060,SUBSTR(cOBS,740,185),oFnt17,,0)
	oPrinter:Say(2150,0060,SUBSTR(cOBS,925,185),oFnt17,,0)
	oPrinter:Say(2190,0060,SUBSTR(cOBS,1110,185),oFnt17,,0)
	oPrinter:Say(2230,0060,SUBSTR(cOBS,1295,185),oFnt17,,0)
	
	oPrinter:Box(2250,0050,3002,1200)
	oPrinter:Say(2280,0060,"Formas de Pagamento",oFnt11,,0)
	
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
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ + CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ
			
		ElseIf Alltrim(TRB1XX->L4_FORMA)=="CC" .Or. Alltrim(TRB1XX->L4_FORMA)=="CD"
			
//			nPos := aScan( aAdm , { |x| x[1]+x[2] ==  Alltrim(TRB1XX->L4_FORMA)+Alltrim(TRB1XX->L4_ADMINIS) } )												//#RVC20180602.o
			nPos := aScan( aAdm , { |x| x[1] + x[2] + x[6] ==  Alltrim(TRB1XX->L4_FORMA) + Alltrim(TRB1XX->L4_ADMINIS) + Alltrim(TRB1XX->L4_AUTORIZ) } )	//#RVC20180602.n
			
			If nPos == 0
//				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , TRB1XX->L4_AUTORIZ  })			//#RVC20180602.o
				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , Alltrim(TRB1XX->L4_AUTORIZ)  }) //#RVC20180602.n
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
			nLinha += _nPula
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)											
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)                                                 
		EndIf
				
		IF !EMPTY(cLinha)
			nLinha += _nPula
		EndIF
		cLinha := ""
		
		TRB1XX->(DbSkip())
	EndDo
	
	For nX := 1 To Len(aAdm)
		cFormaPG += aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06] + CRLF
		cLinha   := aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06]
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha += _nPula
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)											
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)                                                 
		EndIf
		
		nLinha += _nPula
	Next nX
	
	oPrinter:Say(2280,1260,"Qtde. Total:",oFnt7,,0)
	oPrinter:Say(2280,2000,Alltrim(Transform(nQTDETOT 	,"@E 999999999.99")),oFnt3,,0)
	
	oPrinter:Say(2320,1260,"Peso Total:",oFnt7,,0)
	oPrinter:Say(2320,2000,Alltrim(Transform(nPESOTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2360,1260,"Total de ICMS R$:",oFnt7,,0)
	oPrinter:Say(2360,2000,Alltrim(Transform(SUA->UA_VALICM 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2400,1260,"Tipo Frete:",oFnt7,,0)
	oPrinter:Say(2400,2000,If(SUA->UA_TPFRETE=="C","CIF","FOB"),oFnt3,,0)
	
	oPrinter:Say(2440,1260,"Total dos Produtos R$:",oFnt7,,0)
	oPrinter:Say(2440,2000,Alltrim(Transform(nVLRTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(2480,1260,"Total do IPI R$:",oFnt7,,0)
	oPrinter:Say(2480,2000,Alltrim(Transform(SUA->UA_VALIPI 	,"@E 999,999,999.99"))     ,oFnt3,,0)
	
	//oPrinter:Say(3040,1240,"Data: " + DTOC(dDataBase),oFnt7,,0)
	oPrinter:Say(2520,1260,"Frete/Seguro/Outras Despesas R$:",oFnt7,,0)
	oPrinter:Say(2520,2000,Alltrim(Transform((SUA->UA_FRETE+SUA->UA_DESPESA) 	,"@E 999,999,999.99")),oFnt7,,0)
	
	oPrinter:Say(2620,1260,"Total R$:",oFnt1,,0)
	oPrinter:Say(2620,2000,Alltrim(Transform((nVLRTOT + SUA->UA_FRETE+SUA->UA_DESPESA) 	,"@E 999,999,999.99")),oFnt1,,0)
	
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME OS DADOS DOS PRODUTOS DO PEDIDO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin := 0805

	SUB->(DbSetOrder(1))
	SUB->(DbSeek(xFilial("SUB") + cORCAMENTO ))
	While !Eof() .And. SUB->UB_FILIAL + SUB->UB_NUM == xFilial("SUB") + cORCAMENTO
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1') + SUB->UB_PRODUTO ))
		
		IF !EMPTY(SUB->UB_DESCPER)
			cDesc := ALLTRIM(SB1->B1_DESC) + " // " + ALLTRIM(SUB->UB_DESCPER)
		Else
			cDesc := ALLTRIM(SB1->B1_DESC)
		EndIF

				
		oPrinter:Say(nLin,0060,SUB->UB_ITEM,oFnt16,,0)
		oPrinter:Say(nLin,0160,SUB->UB_PRODUTO,oFnt16,,0)
		oPrinter:Say(nLin,0445,SB1->B1_TIPO,oFnt16,,0)
		
		oPrinter:Say(nLin,0510,SUBSTR(cDesc,1,45),oFnt16,,0)  // QUEBRA EM 35
		nLinAux := nLin + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(cDesc,46,45),oFnt16,,0)
		nLinAux := nLinAux + 35
		oPrinter:Say(nLinAux,0510,SUBSTR(cDesc,92,45),oFnt16,,0)
		
		oPrinter:Say(nLin,1210,Alltrim(Transform(SB1->B1_PESBRU,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1410,Alltrim(Transform(SB1->B1_PESO,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1610,Alltrim(Transform(SUB->UB_QUANT,"@E 999.99")),oFnt16,,0)
		oPrinter:Say(nLin,1710,SUB->UB_UM,oFnt16,,0)
		oPrinter:Say(nLin,1810,Alltrim(Transform(SUB->UB_VRUNIT,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2010,Alltrim(Transform(SB1->B1_IPI,"@E 99.99")),oFnt16,,0)
		oPrinter:Say(nLin,2110,Alltrim(Transform(SUB->UB_VLRITEM,"@E 999,999,999.99")),oFnt16,,0)
		oPrinter:Say(nLin,2302,Alltrim(Transform(SB1->B1_PICM,"@E 99.99")),oFnt16,,0)  
	
		If SUB->UB_DTENTRE >= dPREVENT
			dPREVENT := SUB->UB_DTENTRE
		Endif
	
		If Empty(cCFOP)
			cCFOP 		:= SUB->UB_CF 
			cDESCFOP 	:= POSICIONE("SF4",1,xFilial("SF4")+SUB->UB_TES,"F4_TEXTO")
		Endif	
				
		nQTDETOT 	+= SUB->UB_QUANT
		nVLRTOT 	+= SUB->UB_VLRITEM
		nPESOTOT 	+= (SB1->B1_PESBRU * SUB->UB_QUANT)
		nM3TOT 		:= 0
		
		/*
		Alterado em 13/07/2017 - Rogério Doms
		Verificado se existe item do orçamento com observação de venda de medida
		especial. Se encontrado um observação informar no campo Obs que existe
		itens com medida especial
		*/
		If ! Empty(SUB->UB_01DESME) .And. Empty(cOBS)
			cOBS := "Este Orçamento contém Item com Medida Especial"+CRLF
		EndIf
		
		nLin := nLin + 105
		
		SUB->(DbSkip())
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
	
	oPrinter:Say(0325,0060,LEFT(cOBS,185),oFnt17,,0)
	oPrinter:Say(0375,0060,SUBSTR(cOBS,186,185),oFnt17,,0)
	oPrinter:Say(0405,0060,SUBSTR(cOBS,371,185),oFnt17,,0)
	oPrinter:Say(0445,0060,SUBSTR(cOBS,555,185),oFnt17,,0)
	oPrinter:Say(0485,0060,SUBSTR(cOBS,740,185),oFnt17,,0)
	oPrinter:Say(0525,0060,SUBSTR(cOBS,925,185),oFnt17,,0)
	oPrinter:Say(0565,0060,SUBSTR(cOBS,1110,185),oFnt17,,0)
	oPrinter:Say(00605,0060,SUBSTR(cOBS,1295,185),oFnt17,,0)
	
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
			
			cFormaPG += ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ + CRLF
			
			cLinha := ALLTRIM(TRB1XX->L4_FORMA) +" ("+AllTrim(Str(nTotBol))+"/"+AllTrim(Str(nQtdBol))+") no Valor R$ "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" com vencimento em: "+DTOC(STOD(TRB1XX->L4_DATA))+" - Aut. "+TRB1XX->L4_AUTORIZ
			
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
			nLinha+=_nPula
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)											
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)                                                 
		EndIf
		
		
		IF !EMPTY(cLinha)
			nLinha+=_nPula
		EndIF
		cLinha := ""
		
		TRB1XX->(DbSkip())
	EndDo
	
	For nX := 1 To Len(aAdm)
		cFormaPG += aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06] + CRLF
		cLinha   := aAdm[nX][01] + " - " + aAdm[nX][02] + " - Total Parcelas: " + StrZero(aAdm[nX][03],3) +" - Vlr. Parcela: "+ Alltrim(Transform(aAdm[nX][04],"@E 999,999,999.99")) +" - Valor Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99")) +"- NSU "+aAdm[nX][06]
		
		If Len(cLinha) > _nLimConf
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,1,_nLimConf),oFnt6,,0)
			nLinha+=_nPula
			oPrinter:Say(nLinha,0060,SubsTr(cLinha,_nLimConf+1,100),oFnt6,,0)											
		Else
			oPrinter:Say(nLinha,0060,cLinha,oFnt6,,0)                                                 
		EndIf
			nLinha+=_nPula
	Next nX
	
	oPrinter:Say(0660,1260,"Qtde. Total:",oFnt7,,0)
	oPrinter:Say(0660,2000,Alltrim(Transform(nQTDETOT 	,"@E 999999999.99")),oFnt3,,0)
	
	oPrinter:Say(0720,1260,"Peso Total:",oFnt7,,0)
	oPrinter:Say(0720,2000,Alltrim(Transform(nPESOTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0780,1260,"Total de ICMS R$:",oFnt7,,0)
	oPrinter:Say(0780,2000,Alltrim(Transform(SUA->UA_VALICM 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0840,1260,"Tipo Frete:",oFnt7,,0)
	oPrinter:Say(0840,2000,If(SUA->UA_TPFRETE=="C","CIF","FOB"),oFnt3,,0)
	
	oPrinter:Say(0900,1260,"Total dos Produtos R$:",oFnt7,,0)
	oPrinter:Say(0900,2000,Alltrim(Transform(nVLRTOT 	,"@E 999,999,999.99")),oFnt3,,0)
	
	oPrinter:Say(0960,1260,"Total do IPI R$:",oFnt7,,0)
	oPrinter:Say(0960,2000,Alltrim(Transform(SUA->UA_VALIPI 	,"@E 999,999,999.99"))     ,oFnt3,,0)
	
	//oPrinter:Say(3040,1240,"Data: " + DTOC(dDataBase),oFnt7,,0)
	oPrinter:Say(1020,1260,"Frete/Seguro/Outras Despesas R$:",oFnt7,,0)
	oPrinter:Say(1020,2000,Alltrim(Transform((SUA->UA_FRETE+SUA->UA_DESPESA) 	,"@E 999,999,999.99")),oFnt7,,0)
	
	oPrinter:Say(1170,1260,"Total R$:",oFnt1,,0)
	oPrinter:Say(1170,2000,Alltrim(Transform((nVLRTOT + SUA->UA_FRETE+SUA->UA_DESPESA) 	,"@E 999,999,999.99")),oFnt1,,0)
	
	oPrinter:Say(1500,1250,"_______________________",oFnt7,,0)
	oPrinter:Say(1555,1310,"Visto do Comprador",oFnt7,,0)
	
	oPrinter:Say(1500,1880,"_______________________",oFnt7,,0)
	oPrinter:Say(1555,2030,"Vendedor",oFnt7,,0)
	
	oPrinter:EndPage()
EndIF       
                                 
/*If _lMail // Por solicitação da Tatiane o envio de e-mail foi desabilitado. O bloco foi comentado caso necessite ser habilitado novamente. Marcio Nunes - Chamado:9871

	_cEMail      := GETMV('KH_MAILCRE')
	
	oPrinter:Preview()
	
	CpyT2S("C:\KMORCAMENTO\"+_cNomeArq,"\KMORCAMENTO")
	
	cMensagem := "Aos cuidados do departamento de analise de crédito da Komfort House,"+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Segue em anexo orçamento que tem como pagamento a condição de cheque ou boleto."+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Caso o(a) senhor(a) não seja o destinatário correto desta mensagem, por favor nos informar."+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Atenciosamente,"+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Por favor não responder esse e-mail!"+chr(13)+chr(10)+chr(13)+chr(10)

			
	Processa( {|| fEnvMail(_cEmail,"LOJA "+_cFilial+" - "+_cNome+" - ORC: "+cOrcamento,"\KMORCAMENTO\"+AllTrim(_cNomeArq),cMensagem)},"Enviando pedido para a area de credito...")        	
	                                      
Else*/
	
	oPrinter:Preview()
	
//EndIf
      
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
|Programa: fEnvMail     | Tipo: Função                |  Data: 20/03/2018   | 
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
