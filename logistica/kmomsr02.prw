#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Ap5Mail.Ch"
#INCLUDE "xmlxfun.ch"
#INCLUDE "JPEG.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMOMSR02 º AUTOR ³ ELLEN SANTIAGO     º Data ³  29/05/2018 º±±
±±ºDescricao ³ ROMANEIO DE ENTREGA DE PEDIDOS EM TRANSPORTADORA           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION KMOMSR02(cCarga)

Local aPergunta   	:= {}
Local cQuery      	:= ""
Local cSD1        	:= ""
Local cQryZK0     	:= ""
Local cRoma			:= ""
Local lControle		:= .T.
//Local nFim		:= 0
Local dtDe			:= FirstYDate(dDataBase)	//#RVC20180813.n
Local dtAte			:= LastYDate(dDataBase)		//#RVC20180813.n
Private nValor 		:= 0
Private nVlr 		:= 0

Private _cEndImp    := ''
Private _nInic      := 0090
Private _nLimite    := 3150
Private oTrebuø14N	:=	TFont():New("Trebuchet MS",,14,,.T.,,,,,.F.,.F.)
Private oTrebuø7 	:=	TFont():New("Trebuchet MS",,7,,.F.,,,,,.F.,.F.)
Private oTrebuø8N	:=	TFont():New("Trebuchet MS",,8,,.T.,,,,,.F.,.F.)
Private oTrebuø8  	:=	TFont():New("Trebuchet MS",,8,,.F.,,,,,.F.,.F.)
Private oTrebuø9  	:=	TFont():New("Trebuchet MS",,9,,.F.,,,,,.F.,.F.)
Private oTrebuø11N	:=	TFont():New("Trebuchet MS",,11,,.T.,,,,,.F.,.F.)
Private oTrebuø12N	:=	TFont():New("Trebuchet MS",,12,,.T.,,,,,.F.,.F.)
Private oTrebuc28  	:=	TFont():New("Trebuchet MS",,28,,.F.,,,,,.F.,.F.)
Private oTrebuc10N	:=	TFont():New("Trebuchet MS",,10,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("KMOMSR02")
Private cTransp 	:=  GetMv("KM_TRANSPO",,"000001")
Private nLin     	:= 0
Private nTotal		:= 0
Private nTotPeso	:= 0
Private nTotCub		:= 0
Private nNota		:= 0
Private nCont     	:= 1

Aadd(aPergunta,{PadR("KMOMSR02",10),"01","Carga de  ?" 					,"MV_CH1" ,"C",06,00,"G","MV_PAR01",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR02",10),"02","Carga até ?" 					,"MV_CH2" ,"C",06,00,"G","MV_PAR02",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR02",10),"03","Dt. Montagem Carga de ?"			,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR02",10),"04","Dt. Montagem Carga até ?" 		,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR02",10),"05","Pedido de ?" 					,"MV_CH5" ,"C",06,00,"G","MV_PAR05",""    ,""    ,"","","","SC5"})
Aadd(aPergunta,{PadR("KMOMSR02",10),"06","Pedido até ?" 					,"MV_CH6" ,"C",06,00,"G","MV_PAR06",""    ,""    ,"","","","SC5"})

VldSX1(aPergunta)

IF Empty(cCarga)
	If !Pergunte(aPergunta[1,1],.T.)
		Return(Nil)
	EndIf
Else
	MV_PAR01 := cCarga
	MV_PAR02 := cCarga
//	MV_PAR03 := dDataBase
//	MV_PAR04 := dDataBase
	MV_PAR03 := dtDe
	MV_PAR04 := dtAte	
	MV_PAR05 := ""
	MV_PAR06 := "ZZZZZZ"
EndIF

cQuery := " SELECT DAI_COD, DAI_PEDIDO, DAI_CLIENT, DAI_LOJA, A1_NOME, A1_CGC, A1_END, A1_BAIRRO, "
//cQuery += " A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_DDD, A1_TEL2, A1_XTEL3, DA4_NOME, DA3_PLACA, A1_COMPLEM, DAI_NFISCA "
cQuery += " A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_DDD, A1_TEL2, A1_XTEL3, DAK_MOTORI, DAK_CAMINH, A1_COMPLEM, DAI_NFISCA, DAI_SERIE, DAK_DATA, DAK_HORA, DAK_XVALOR, DAI_ROTA AS ROTA, DAK_XSERVI "
cQuery += " FROM " + RETSQLNAME("DAI") + " DAI "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = DAI_CLIENT AND A1_LOJA = DAI_LOJA "
cQuery += " INNER JOIN " + RETSQLNAME("DAK") + " DAK ON DAK_COD = DAI_COD AND DAK_FILIAL = DAI_FILIAL "
cQuery += " WHERE DAI_FILIAL = '" + XFILIAL("DAI") + "'  "
cQuery += " AND DAI.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND DAK.D_E_L_E_T_ = ' ' "
cQuery += " AND DAK_FILIAL = '" + XFILIAL("DAK") + "' "
cQuery += " AND DAI_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND DAI_PEDIDO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND DAI_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " GROUP BY DAI_COD, DAI_PEDIDO, DAI_CLIENT, DAI_LOJA, A1_NOME, A1_CGC, A1_END, A1_BAIRRO,  A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_DDD, A1_TEL2, A1_XTEL3, DAK_MOTORI, DAK_CAMINH, A1_COMPLEM, DAI_NFISCA, DAI_SERIE, DAK_DATA, DAK_HORA, DAK_XVALOR, DAI_ROTA, DAK_XSERVI"
cQuery += " ORDER BY DAI.DAI_NFISCA "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

Count to nFim

oPrinter:Setup()
oPrinter:SetPortrait()
oPrinter:StartPage()

nLin 	:= 0850

DbSelectArea("TRB")
dbGoTop()
cRoma	:= TRB->DAI_COD
cNota	:= TRB->DAI_NFISCA

nValor := iif(TRB->DAK_XVALOR > 0, TRB->DAK_XVALOR , getValDai() )

nVlr := iif(TRB->DAK_XVALOR > 0, TRB->DAK_XVALOR + TRB->DAK_XSERVI, nValor + TRB->DAK_XSERVI)



While TRB->(!EOF())
	If	cRoma <> TRB->DAI_COD
		cRoma := TRB->DAI_COD
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := 850
		lControle:= .T.
		nTotPeso := 0
		nTotal 	 := 0
		nTotCub	 := 0
		LjMsgRun("Processando, aguarde ...",, {|| Relatorio(cRoma, @lControle,cNota) })
		//nNota := 1
	Else
		LjMsgRun("Processando, aguarde ...",, {|| Relatorio(cRoma,@lControle,cNota) })
		//nNota ++
	Endif
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	nCont++
	TRB->(DbSkip())
EndDo

nLin += 100

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FOI MODIFICADO O PROGRAMA PARA QUE NAO PEGUE MAIS NOTA FISCAL E SIM TERMO DE RETIRA - ZK0 - LUIZ EDUARDO F.C. - 29.06.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQryZK0 := " SELECT ZK0_COD, ZK0_PEDORI, ZK0_CLI, ZK0_LJCLI, A1_NOME, ZK0_CARGA, ZK0_PROD, ZK0_DESCRI , ZK0_OBSSAC, ZK0_NUMSAC, "
cQryZK0 += " A1_END, A1_BAIRRO, A1_EST, A1_CEP, A1_MUN, A1_COMPLEM, A1_DDD, A1_TEL, A1_TEL2, A1_XTEL3 "
cQryZK0 += " FROM " + RETSQLNAME("ZK0") + " ZK0 "
cQryZK0 += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = ZK0_CLI  AND A1_LOJA = ZK0_LJCLI "
cQryZK0 += " WHERE ZK0_FILIAL = '" + XFILIAL("ZK0") + "' "
cQryZK0 += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQryZK0 += " AND ZK0.D_E_L_E_T_ = ' ' "
cQryZK0 += " AND SA1.D_E_L_E_T_ = ' ' "
cQryZK0 += " AND ZK0_CARGA BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "

If Select("TRBZK0") > 0
	TRBZK0->(DbCloseArea())
EndIf

cQryZK0 := ChangeQuery(cQryZK0)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryZK0),"TRBZK0",.F.,.T.)

TRBZK0->(DbGoTop())

IF nLin >= _nLimite-50
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ K045 - IMPRIME AS OBSERVACOES - LUIZ EDUARDO F.C. - 02/01/2018 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 75
oPrinter:Say(nLin,070,"Observação",oTrebuc10N,,0)
nLin := nLin + 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA AS INFORMACOES DO CAMPO OBSERVACAO DA CARGA           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
DbSelectArea("DAK")
DAK->(DbSetOrder(1))
DAK->(DbGoTop())
DAK->(DbSeek(xFilial("DAK")+cRoma))

_cObsCar  := MSMM(DAK->DAK_XCODOB,TamSx3("DAK_XCODOB")[1])

aDados := U_IMPMEMO(_cObsCar, 130, "", .F.)

//Percorrendo as linhas geradas
For nAtual := 1 To Len(aDados)
	oPrinter:Say(nLin,0100,aDados[nAtual],oTrebuø9,,0)
	nLin := nLin + 050
	//#CMG20181004.bn
	If nLin >= _nLimite 
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIf
	//#CMG20181004.en
Next
nLin := nLin + 050

IF TRBZK0->(!EOF())
	oPrinter:Say(nLin,0000,Replicate("*",3500),oTrebuc10N,,0)
	nLin := nLin + 75
	oPrinter:Say(nLin,0800,"TERMOS DE RETIRA - CARGA(S)  " +MV_PAR01 + " - " + MV_PAR02,oTrebuø14N,,0)
	nLin := nLin + 75
	oPrinter:Say(nLin,0000,Replicate("*",3500),oTrebuc10N,,0)
EndIF

While TRBZK0->(!EOF())
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	
	nLin := nLin + 100
	
	oPrinter:Say(nLin,0100,"Termo Retira - " 	+ TRBZK0->ZK0_COD											,oTrebuc10N,,0)
	oPrinter:Say(nLin,0600,"Carga - " 			+ TRBZK0->ZK0_CARGA											,oTrebuc10N,,0)
	oPrinter:Say(nLin,1100,"Pedido Original	- " + SUBSTR(TRBZK0->ZK0_PEDORI,5,6)							,oTrebuc10N,,0)
	oPrinter:Say(nLin,1600,"Loja Origem - "		+ FWFilialName(cEmpAnt,SUBSTR(TRBZK0->ZK0_PEDORI,1,4),1)	,oTrebuc10N,,0)
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"Cliente - ( " + TRBZK0->ZK0_CLI + "-" + TRBZK0->ZK0_LJCLI + " ) " + AllTrim(TRBZK0->A1_NOME)+" - Chamado SAC: "+TRBZK0->ZK0_NUMSAC ,oTrebuc10N,,0)
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"Endereço " +  ALLTRIM(TRBZK0->A1_END) + " , " + ALLTRIM(TRBZK0->A1_BAIRRO) + " , " + ALLTRIM(TRBZK0->A1_MUN) + " - " + ALLTRIM(TRBZK0->A1_EST),oTrebuc10N,,0)
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"Complemento " +  TRBZK0->A1_COMPLEM,oTrebuc10N,,0)
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"CEP " +  TRBZK0->A1_CEP,oTrebuc10N,,0)
	oPrinter:Say(nLin,0600,"Telefone (" + TRBZK0->A1_DDD + ")" +  TRBZK0->A1_TEL + " / " +  TRBZK0->A1_TEL2 + " / " +  TRBZK0->A1_XTEL3,oTrebuc10N,,0)  	               '
	nLin := nLin + 75
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"ENTREGA - ",oTrebuc10N,,0)
	nLin := nLin + 75
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"OBS - " + ZK0->ZK0_OBSSAC,oTrebuc10N,,0)
	nLin := nLin + 75
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,"Código",oTrebuc10N,,0)
	oPrinter:Say(nLin,0500,"Descrição",oTrebuc10N,,0)
	oPrinter:Say(nLin,1500,"Peso Bruto",oTrebuc10N,,0)
	oPrinter:Say(nLin,2000,"Cubagem",oTrebuc10N,,0)
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	oPrinter:Say(nLin,0100,TRBZK0->ZK0_PROD,oTrebuc10N,,0)
	oPrinter:Say(nLin,0500,TRBZK0->ZK0_DESCRI,oTrebuc10N,,0)
	oPrinter:Say(nLin,1500,"0,00",oTrebuc10N,,0)
	oPrinter:Say(nLin,2000,"0,00",oTrebuc10N,,0)
	
	nLin := nLin + 50
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
//	oPrinter:Say(nLin,0000,Replicate("_",3500),oTrebuc10N,,0)
	
	TRBZK0->(DbSkip())
EndDo
                             
nLin += 50

IF nLin >= _nLimite-150
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF

oPrinter:Box(nLin,046,nLin+170,300) 

oPrinter:Box(nLin,302,nLin+80,600)
oPrinter:Box(nLin+80,302,nLin+170,600) 

oPrinter:Box(nLin,602,nLin+80,900)
oPrinter:Box(nLin+80,602,nLin+170,900)

oPrinter:Box(nLin,902,nLin+80,1200)
oPrinter:Box(nLin+80,902,nLin+170,1200) 

oPrinter:Box(nLin,1202,nLin+80,1500)
oPrinter:Box(nLin+80,1202,nLin+170,1500)
                 
nLin += 20
oPrinter:Say(nLin,360,"Notas Fiscais" ,oTrebuø11N,,0)  
oPrinter:Say(nLin,670,"Peças" ,oTrebuø11N,,0) 
oPrinter:Say(nLin,950,"Peso Bruto" ,oTrebuø11N,,0) 
oPrinter:Say(nLin,1250,"Cubagem" ,oTrebuø11N,,0) 

nLin += 40
oPrinter:Say(nLin,100,"TOTAIS" ,oTrebuø11N,,0)  

nLin += 30
oPrinter:Say(nLin,450,ALLTRIM(STR(nNota)),oTrebuc10N,,0)
oPrinter:Say(nLin,650,Transform(nTotal,PesqPict('SC6','C6_QTDVEN')),oTrebuc10N,,0)
oPrinter:Say(nLin,910,Transform(nTotPeso,PesqPict('SB1','B1_PESBRU')),oTrebuc10N,,0) 
oPrinter:Say(nLin,1210,Transform(nTotCub,PesqPict('SB1','B1_PESBRU')),oTrebuc10N,,0)

nLin += 500                              
                             
oPrinter:Say(nLin,0438,"Conferente Komfort House",oTrebuc10N,,0)
oPrinter:Say(nLin,1507,"Motorista",oTrebuc10N,,0)
nLin := nLin - 50
oPrinter:Say(nLin,0389,"___________________________",oTrebuc10N,,0)
oPrinter:Say(nLin,1439,"___________________________",oTrebuc10N,,0)
	
oPrinter:EndPage()

oPrinter:Preview()

RETURN()

//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | Cabec         | Autor | Ellen Santiago         | Data | 28/05/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Cabecalho principal do Romaneio                                    |
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+

Static Function Cabec()

Local cImag001 		:= "C:\totvs\logo.png"

DbSelectArea("SA4")
DbSetOrder(1)
SA4->(DbSeek(xFilial("SA4") + cTransp))

oPrinter:SayBitMap(0045,0058,cImag001,0269,0158)
oPrinter:Box(0042,0046,0222,2370)
oPrinter:Say(0095,0513,"Minuta de Entrega de Pedidos em Transportadora - N. " + TRB->DAI_COD + " [CARGA]",oTrebuø14N,,0)
oPrinter:Say(0148,1892,"Data  " + DTOC(STOD(TRB->DAK_DATA)) + " - " + TRB->DAK_HORA,oTrebuø8N,,0)
oPrinter:Say(0184,1892,"Fonte : KMOMSR02",oTrebuø8N,,0)
oPrinter:Box(0240,0046,0351,2370)
oPrinter:Say(0238,0058,"TRANSPORTADORA :     " + SA4->A4_NOME,oTrebuø11N,,0)       
oPrinter:Say(0305,0060,"MOTORISTA :  " + ALLTRIM(POSICIONE("DA4",1,XFILIAL("DA4") +TRB->DAK_MOTORI,"DA4_NREDUZ"))+ ' - ' +  ALLTRIM(POSICIONE("DA4",1,XFILIAL("DA4") +TRB->DAK_MOTORI,"DA4_NOME")),oTrebuø11N,,0)
oPrinter:Say(0240,1894,"PLACA : " + ALLTRIM(POSICIONE("DA3",1,XFILIAL("DA3") +TRB->DAK_CAMINH,"DA3_PLACA")),oTrebuø11N,,0)
//oPrinter:Box(0240,0046,0351,365) 
//oPrinter:Line(0240,0440,0350,0440)// Monta uma linha vertical 
oPrinter:Line(0240,1870,0300,1870)// Monta uma linha vertical 
oPrinter:Line(0300,0046,0300,2370)// Monta uma linha horizontal 
oPrinter:Say(0373,0058,"Endereco : " + ALLTRIM(SA4->A4_END) + " - " + ALLTRIM(SA4->A4_BAIRRO) + " - " + ALLTRIM(SA4->A4_MUN) + " - " + ALLTRIM(SA4->A4_EST),oTrebuø8N,,0)
oPrinter:Say(0418,0058,"Bairro : " + ALLTRIM(SA4->A4_BAIRRO),oTrebuø8N,,0)
oPrinter:Say(0463,0058,"Cidade : " + ALLTRIM(SA4->A4_MUN),oTrebuø8N,,0)
oPrinter:Say(0508,0058,"CNPJ : " + SA4->A4_CGC,oTrebuø8N,,0)
oPrinter:Box(0368,0046,0600,1740) //Box do Endereco 
oPrinter:Box(0368,1750,0600,2370) //Box do Telefone 
oPrinter:Say(0373,1300,"Telefone : (" + ALLTRIM(SA4->A4_DDD) + ") " + SA4->A4_TEL,oTrebuø8N,,0)
oPrinter:Say(0418,1300,"Fax : (" + ALLTRIM(SA4->A4_DDD) + ") " + SA4->A4_TELEX,oTrebuø8N,,0)
oPrinter:Say(0463,1300,"E-mail : " + SA4->A4_EMAIL,oTrebuø8N,,0)
oPrinter:Say(0508,1300,"I.E. : " + SA4->A4_INSEST,oTrebuø8N,,0)
oPrinter:Say(0371,1780,"Carimbo e Assinatura da Transportadora",oTrebuø7,,0)
oPrinter:Say(0406,1765,"A Transportadora se compromete a repassar para",oTrebuø7,,0)
oPrinter:Say(0442,1765,"a empresa a data da entrega dos produtos do cli-",oTrebuø7,,0)
oPrinter:Say(0472,1765,"ente.",oTrebuø7,,0)
oPrinter:Box(0700,0046,0600,2370) //Box do VALOR
oPrinter:Say(0610,0058,"Valor Serv. Adicional :     " + ALLTRIM(TRANSFORM(TRB->DAK_XSERVI, "@E 999,999.99")),oTrebuø11N,,0)
oPrinter:Say(0610,1200,"Valor Frete :     " + ALLTRIM(TRANSFORM(nValor, "@E 999,999.99")),oTrebuø11N,,0)
oPrinter:Say(0610,2000,"Valor Total :     " + ALLTRIM(TRANSFORM(nVlr, "@E 999,999.99")),oTrebuø11N,,0)   

 

Return


Static Function getValDai(cRota)

	Local cQuery :=	""
	Local cAliasDA7 := getNextAlias()
	Local nValor := 0
	
	cQuery := " SELECT TOP 1 (SELECT TOP 1 DA7_XVALOR FROM " + RETSQLNAME("DA7") + " WHERE DA7_ROTA = DAI_ROTA ORDER BY DA7_XVALOR DESC) AS VALOR"
	cQuery += " FROM " + RETSQLNAME("DAI") + " DAI "
	cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = DAI_CLIENT AND A1_LOJA = DAI_LOJA "
	cQuery += " INNER JOIN " + RETSQLNAME("DAK") + " DAK ON DAK_COD = DAI_COD AND DAK_FILIAL = DAI_FILIAL "
	cQuery += " WHERE DAI_FILIAL = '" + XFILIAL("DAI") + "'  "
	cQuery += " AND DAI.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " AND DAK.D_E_L_E_T_ = ' ' "
	cQuery += " AND DAK_FILIAL = '" + XFILIAL("DAK") + "' "
	cQuery += " AND DAI_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND DAI_PEDIDO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND DAI_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery += " GROUP BY DAI_COD, DAI_PEDIDO, DAI_CLIENT, DAI_LOJA, A1_NOME, A1_CGC, A1_END, A1_BAIRRO,  A1_MUN, A1_EST, A1_CEP, A1_TEL, A1_DDD, A1_TEL2, A1_XTEL3, DAK_MOTORI, DAK_CAMINH, A1_COMPLEM, DAI_NFISCA, DAI_SERIE, DAK_DATA, DAK_HORA, DAK_XVALOR, DAI_ROTA "
	cQuery += " ORDER BY VALOR DESC "
	
	plsquery(cQuery, cAliasDA7)
	
	if (cAliasDA7)->(!eof())
		nValor := (cAliasDA7)->VALOR 
	endif

return nValor




//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | Relatorio     | Autor | Ellen Santiago         | Data | 28/05/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Imprime conteudo do relatorio                                      |
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+
Static Function Relatorio(cRoma, lControle, cNota)

Local cQry         	:= ""
Local nPeso       	:= 0
Local nCubagem    	:= 0
Local cUnidade		:= ""
Local nTotQtd		:= 0
Local cMsgNew  		:= ""
Local cMsgTmp  		:= ""
Local _cObsCar      := ""
Local cRestEnt      := ""
Local _cNfAnt       := ""
Local _nLinNf       := ""       

cQry := " SELECT C6_ITEM, C6_LOCALIZ, D2_QUANT, C6_QTDVEN, B1_UM, C6_PRODUTO, C6_DESCRI, B1_PESBRU, C6_ENTREG, B1_DESC, C6_NOTA, "
cQry += " C6_SERIE, C6_MSFIL, D2_DOC, D2_SERIE FROM " + RETSQLNAME("SC6") + " (NOLOCK) SC6 "
cQry += " INNER JOIN " + RETSQLNAME("SB1") + " (NOLOCK) SB1 ON B1_COD = C6_PRODUTO "
cQry += " INNER JOIN " + RETSQLNAME("SD2") + " (NOLOCK) SD2 ON D2_FILIAL = '" + XFILIAL("SD2") + "' "
cQry += " AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SD2.D_E_L_E_T_ <> '*' " 
cQry += " LEFT JOIN " + RETSQLNAME("SF2") + " (NOLOCK) SF2 ON F2_FILIAL = '" + XFILIAL("SF2") + "' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_LOJA = D2_LOJA AND F2_CLIENTE = D2_CLIENTE AND SF2.D_E_L_E_T_ <> '*' "	
cQry += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
cQry += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "
cQry += " AND SC6.D_E_L_E_T_ = ' ' "
cQry += " AND SB1.D_E_L_E_T_ = ' ' "
cQry += " AND C6_NUM = '" + TRB->DAI_PEDIDO + "' "
cQry += " AND C6_CLI = '" + TRB->DAI_CLIENT + "' "
cQry += " AND C6_LOJA = '" + TRB->DAI_LOJA + "' "
cQry += " AND F2_CARGA = '" + cRoma + "' "
//cQry += " AND C6_NOTA = '" + TRB->DAI_NFISCA + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TMP",.F.,.T.)

nLin := nLin-35

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CABECALHO DO PEDIDO                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrinter:Line(nLin-65,0050,nLin-65,2430)// Linha horizontal 
oPrinter:Say(nLin-55,70,"Nota Fiscal   |",oTrebuc10N )
oPrinter:Say(nLin-55,300,"Pedido | ",oTrebuc10N )
oPrinter:Say(nLin-55,450,"Cliente",oTrebuc10N )
oPrinter:Say(nLin-55,1150,"Destino",oTrebuc10N )
oPrinter:Line(nLin-10,0050,nLin-10,2430)// Linha horizontal 
//Numero da NF
//oPrinter:Say(nLin,070,TRB->DAI_NFISCA + " - " + TRB->DAI_SERIE	,oTrebuø9,,0) // Nro. Nota
_cNfAnt := TMP->D2_DOC
_nLinNf := nLin
nNota++
//Numero do Pedido de Venda
oPrinter:Say(nLin,0300,TRB->DAI_PEDIDO,oTrebuø9,,0)
//Cliente
oPrinter:Say(nLin,0450,LEFT(TRB->DAI_CLIENT + "-" + TRB->DAI_LOJA + "  " + TRB->A1_NOME,41) ,oTrebuø9,,0)
//Endereço
_cEndImp := LEFT(ALLTRIM(TRB->A1_END) + " , " + ALLTRIM(TRB->A1_BAIRRO) + " , " + ALLTRIM(TRB->A1_MUN) + " - " + ALLTRIM(TRB->A1_EST),90)+" "+;
LEFT(ALLTRIM(TRB->A1_COMPLEM) + " - CEP: " + TRB->A1_CEP + " - TEL: " + "(" + AllTrim(TRB->A1_DDD) + ")" +  TRB->A1_TEL + " / " +  TRB->A1_TEL2,90)

oPrinter:Say(nLin,1150,SubsTr(_cEndImp,1,75),oTrebuø9,,0)
nLin := nLin + 50
IF nLin >= _nLimite
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF
oPrinter:Say(nLin,01150,SubsTr(_cEndImp,76,75),oTrebuø9,,0)
nLin := nLin + 50
IF nLin >= _nLimite
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF
oPrinter:Say(nLin,01150,SubsTr(_cEndImp,151,75),oTrebuø9,,0)
nLin := nLin + 50
IF nLin >= _nLimite
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF

nLin := nLin + 50
oPrinter:Say(nLin-65,070,"Item",oTrebuc10N,,0)
oPrinter:Say(nLin-65,160,"Código",oTrebuc10N,,0)
oPrinter:Say(nLin-65,0430,"Descrição",oTrebuc10N,,0)
oPrinter:Say(nLin-65,1320,"Qtde.",oTrebuc10N,,0)
oPrinter:Say(nLin-65,1500,"UM",oTrebuc10N,,0)
oPrinter:Say(nLin-65,1600,"Peso Bruto",oTrebuc10N,,0)
oPrinter:Say(nLin-65,1800,"Cubagem",oTrebuc10N,,0)
oPrinter:Say(nLin-65,1950,"Endereço",oTrebuc10N,,0)


nLin 	 := nLin + 50
IF nLin >= _nLimite
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIF

nPeso    := 0
nCubagem := 0

oPrinter:Say(_nLinNF,070,TMP->D2_DOC + " - " + TMP->D2_SERIE	,oTrebuø9,,0) // Nro. Nota

While TMP->(!EOF())
	IncProc()
	
	If _cNfAnt <> TMP->D2_DOC  
		
		_cNfAnt := TMP->D2_DOC 
		nNota++
		_nLinNf+=50
		oPrinter:Say(_nLinNF,070,TMP->D2_DOC + " - " + TMP->D2_SERIE	,oTrebuø9,,0) // Nro. Nota
	
	EndIf
	
	IF nLin >= _nLimite
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIF
	
	oPrinter:Say(nLin-45,070,TMP->C6_ITEM,oTrebuø9,,0)
	oPrinter:Say(nLin-45,0160,TMP->C6_PRODUTO,oTrebuø9,,0)
	oPrinter:Say(nLin-45,0430,TMP->B1_DESC,oTrebuø9,,0)
	oPrinter:Say(nLin-45,1240,Transform(TMP->D2_QUANT,PesqPict('SD2','D2_QUANT')),oTrebuø9,,0)
	oPrinter:Say(nLin-45,1500,TMP->B1_UM,oTrebuø9,,0)
	oPrinter:Say(nLin-45,1560,Transform(TMP->B1_PESBRU,PesqPict('SB1','B1_PESBRU')),oTrebuø9,,0)
	
	nTotal	+= TMP->D2_QUANT
	nTotQtd	+= TMP->D2_QUANT
	nPeso 	:= nPeso + TMP->B1_PESBRU
	cUnidade:= TMP->B1_UM 
	DbSelectArea("SB5")
	SB5->(DbSetOrder(1))
	SB5->(DbSeek(xFilial("SB5") + TMP->C6_PRODUTO))
	nCubagem := nCubagem + (SB5->B5_LARGLC * SB5->B5_COMPRLC * SB5->B5_ALTURLC)
	oPrinter:Say(nLin-45,1750,Transform((SB5->B5_LARGLC * SB5->B5_COMPRLC * SB5->B5_ALTURLC),PesqPict('SB1','B1_PESBRU')),oTrebuø9,,0)
	oPrinter:Say(nLin-45,1950,TMP->C6_LOCALIZ,oTrebuø9,,0)
	
	nLin := nLin + 50 

	TMP->(DbSkip())
			
EndDo

nTotPeso+= nPeso 
nTotCub	+= nCubagem 

oPrinter:Say(nLin,070,"TOTAL DO PEDIDO ........................................................................................",oTrebuc10N,,0)
oPrinter:Say(nLin,1240,Transform(nTotQtd,PesqPict('SC6','C6_QTDVEN')),oTrebuc10N,,0) 
oPrinter:Say(nLin,1500,cUnidade,oTrebuc10N,,0) 
oPrinter:Say(nLin,1560,Transform(nPeso,PesqPict('SB1','B1_PESBRU')),oTrebuc10N,,0) 
oPrinter:Say(nLin,1750,Transform(nCubagem,PesqPict('SB1','B1_PESBRU')),oTrebuc10N,,0)

nTotQtd := 0

if cRoma == TRB->DAI_COD
	If lControle 
		LjMsgRun("Processando, aguarde ...",, {|| Cabec() })
		lControle := .F.
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ K045 - IMPRIME AS OBSERVACOES - LUIZ EDUARDO F.C. - 02/01/2018 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 75
oPrinter:Say(nLin,070,"Observação",oTrebuc10N,,0)
nLin := nLin + 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA AS INFORMACOES DO CAMPO OBSERVACAO DO PEDIDO DE VENDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5") + TRB->DAI_PEDIDO))
cMaMemo  := MSMM(SC5->C5_XCODOBS,TamSx3("C5_XOBS")[1])
cMenNota := SC5->C5_MENNOTA
cRestEnt := SC5->C5_XREGCON

cMaMemoEnt  := MSMM(SC5->C5_XOBSENT,TamSx3("C5_XOBS")[1])


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se no pedido existe algum chamado ref. a troca    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cMsgTmp += "Representante: "+ alltrim( Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME") ) + "| "
cMsgNew += iif(empty(cMsgNew),"","| ") + cMsgTmp
cMsgTmp := ""
if ! empty( SC5->C5_01SAC )
	SUC->( dbSetOrder(1) )
	if SUC->( dbSeek( xFilial("SUC") + SC5->C5_01SAC ) )
		lTroca := .F.
		Z01->( dbSetOrder(1) )
		SUD->( dbSetOrder(1) )
		SUD->( dbSeek( xFilial("SUD") + SUC->UC_CODIGO ) )
		while ! SUD->( EOF() ) .and. xFilial("SUD") + SUD->UD_CODIGO == xFilial("SUC") + SUC->UC_CODIGO
			if SUD->UD_DATA == SC5->C5_EMISSAO .and. ! empty( SUD->UD_01TIPO )
				if Z01->( dbSeek( xFilial("Z01") + SUD->UD_01TIPO ) ) .and. Z01->Z01_TPPEDI=='N' .and. Z01->Z01_TIPO=='1'	
					lTroca := .T.
					if ! alltrim( SUD->UD_OBS ) $ cMsgTmp
						cMsgTmp += iif(empty(cMsgTmp),"","| ") + alltrim( SUD->UD_OBS ) + "| "
					endif
				endif
			endif
			SUD->( dbSkip() )
		end

		if lTroca
			cMsgTmp := "Troca/retorno referente ao pedido: " + SUC->UC_01PED
		endif
	endif
Endif
cMsgNew += iif(empty(cMsgNew),"","| ") + cMsgTmp

aDados := U_IMPMEMO(cMaMemo, 130, "", .F.)

//Percorrendo as linhas geradas
For nAtual := 1 To Len(aDados)
	oPrinter:Say(nLin,0100,aDados[nAtual],oTrebuø9,,0)
	nLin := nLin + 050
	//#CMG20181004.bn
	If nLin >= _nLimite 
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIf
	//#CMG20181004.en
Next
nLin := nLin + 050

//Observações de entrega
//#CMG20181004.bn
If nLin >= _nLimite 
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIf

//Incluida impressão do campo C5_XREGCON  - Restrição de entrega
oPrinter:Say(nLin,070,"Restrições  de Entrega",oTrebuc10N,,0)
nLin := nLin + 50
oPrinter:Say(nLin,0100,cRestEnt,oTrebuø9,,0)
nLin := nLin + 75
//----------------------------------------------------------------

//#CMG20181004.en
oPrinter:Say(nLin,070,"Observações de Entrega",oTrebuc10N,,0)
nLin := nLin + 50

aDados := U_IMPMEMO(cMaMemoEnt, 130, "", .F.)

//Percorrendo as linhas geradas
For nAtual := 1 To Len(aDados)
	oPrinter:Say(nLin,0100,aDados[nAtual],oTrebuø9,,0)
	nLin := nLin + 050
	//#CMG20181004.bn
	If nLin >= _nLimite 
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIf
	//#CMG20181004.en	
Next

nLin := nLin + 050

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA AS INFORMACOES DE OBSERVACAO DO CADASTRO DE CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + TRB->DAI_CLIENT + TRB->DAI_LOJA))
cMaMemo := MSMM(SA1->A1_OBS,TamSx3("A1_VM_OBS")[1])
SA1->(DbCloseArea())

aDados := U_IMPMEMO(cMaMemo, 130, "", .F.)

//Percorrendo as linhas geradas
For nAtual := 1 To Len(aDados)
	oPrinter:Say(nLin,0100,aDados[nAtual],oTrebuø9,,0)
	nLin := nLin + 050
	//#CMG20181004.bn
	If nLin >= _nLimite 
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLin := _nInic
	EndIf
	//#CMG20181004.en	
Next
nLin := nLin + 050
//#CMG20181004.bn
If nLin >= _nLimite 
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLin := _nInic
EndIf
//#CMG20181004.en
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME A MENSAGEM QUE VAI NA NOTA FISCAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !EMPTY(cMenNota)
	oPrinter:Say(nLin,0100,"Mensagem Nota Fiscal",oTrebuc10N,,0)
	nLin := nLin + 060
	oPrinter:Say(nLin,0100,cMenNota,oTrebuc10N,,0)
	nLin := nLin + 075
EndIF

nLin 	:= nLin + 75 
cMsgNew := ""
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  VldSX1  º Autor ³ LUIZ EDUARDO F.C.  º Data ³  05/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDACAO DE PERGUNTAS DO SX1                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
