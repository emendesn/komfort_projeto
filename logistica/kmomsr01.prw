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
±±ºPrograma  ³ KMOMSR01 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  24/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ROMANEIO DE SEPARACAO ESTOQUE                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMOMSR01(cCarga)

Local aPergunta     := {}
Local aAreaSDB		:= SDB->(getArea())	//#RVC20180927.n
Local aAreaSDC		:= SDC->(getArea())	//#RVC20180927.n
Local aAreaSD2		:= SD2->(GetArea())	//#CMG20181003.n
Local cQuery        := ""
Local cQry          := ""
Local cEnder		:= "R??-P??-A??"
Local nPag          := 1
Local nLin          := 0
Local nVol          := 0
Local cMaMemo       := ""
Local cMenNota      := ""
Local aDados        := {}
Local dtDe			:= FirstYDate(dDataBase)	//#RVC20180813.n
Local dtAte			:= LastYDate(dDataBase)		//#RVC20180813.n

Private	cImag001	:=	"C:\totvs\logo.png"
Private oTrebuø12N	:=	TFont():New("Trebuchet MS",,12,,.T.,,,,,.F.,.F.)
Private oTrebuø8N	:=	TFont():New("Trebuchet MS",,8,,.T.,,,,,.F.,.F.)
Private oTrebuø10N	:=	TFont():New("Trebuchet MS",,9,,.T.,,,,,.F.,.F.)
Private oPrinter  	:=	tAvPrinter():New("KMOMSR01")

Default cCarga := ''

Aadd(aPergunta,{PadR("KMOMSR01",10),"01","Carga de  ?" 					,"MV_CH1" ,"C",06,00,"G","MV_PAR01",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR01",10),"02","Carga até ?" 					,"MV_CH2" ,"C",06,00,"G","MV_PAR02",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR01",10),"03","Dt. Montagem Carga de ?"			,"MV_CH3" ,"D",08,00,"G","MV_PAR03",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR01",10),"04","Dt. Montagem Carga até ?" 		,"MV_CH4" ,"D",08,00,"G","MV_PAR04",""    ,""    ,"","","",""   })
Aadd(aPergunta,{PadR("KMOMSR01",10),"05","Pedido de ?" 					,"MV_CH5" ,"C",06,00,"G","MV_PAR05",""    ,""    ,"","","","SC5"})
Aadd(aPergunta,{PadR("KMOMSR01",10),"06","Pedido até ?" 					,"MV_CH6" ,"C",06,00,"G","MV_PAR06",""    ,""    ,"","","","SC5"})

VldSX1(aPergunta)

//#RVC20180813.bn
IF Empty(AllTrim(cCarga))
	If !Pergunte(aPergunta[1,1],.T.)
		Return(Nil)
	EndIf
Else
	MV_PAR01 := cCarga
	MV_PAR02 := cCarga
	MV_PAR03 := dtDe
	MV_PAR04 := dtAte
	MV_PAR05 := ""
	MV_PAR06 := "ZZZZZZ"
EndIF
//#RVC20180813.en

cQuery := " SELECT DAI_COD, DAI_PEDIDO, DAI_CLIENT, DAI_LOJA, A1_NOME, A1_CGC, A1_END, A1_BAIRRO, A1_MUN, A1_EST,
cQuery += " A1_CEP, A1_TEL, A1_DDD, A1_TEL2, DAI_NFISCA "
cQuery += " FROM " + RETSQLNAME("DAI") + " DAI"
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON A1_COD = DAI_CLIENT "
cQuery += " AND A1_LOJA = DAI_LOJA "
cQuery += " WHERE DAI_FILIAL = '" + XFILIAL("DAI") + "' "
cQuery += " AND DAI.D_E_L_E_T_ = ' ' "
cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " AND DAI_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND DAI_PEDIDO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND DAI_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " ORDER BY DAI_COD, DAI_PEDIDO "

MemoWrite('\Querys\KMOMSR01A.sql',cQuery)

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

oPrinter:Setup()

While TRB->(!EOF())
	oPrinter:StartPage()
	oPrinter:SayBitMap(0057,0067,cImag001,0269,0158)
	oPrinter:Box(0044,0046,0226,2370)
	//	oPrinter:Say(0091,1162,"KOMFORT",oTrebuø12N,,0)
	oPrinter:Say(0091,0513,"Romaneio/Separação de Mercadoria(s)",oTrebuø12N,,0)
	oPrinter:Say(0148,1064,"KOMFORT HOUSE SOFAS LTDA",oTrebuø8N,,0)
	oPrinter:Say(0055,2039,"Pag: " + ALLTRIM(STR(nPag)),oTrebuø8N,,0)
	oPrinter:Say(0100,2041,DTOC(dDataBase) + " - " + time(),oTrebuø8N,,0)
	oPrinter:Say(0145,2041," Fonte : KMOMSR01",oTrebuø8N,,0)
	oPrinter:Box(0238,0046,0275,2370)
	oPrinter:Say(0237,0058,"Romaneio : " + TRB->DAI_COD + "     -     Pedido : " + TRB->DAI_PEDIDO,oTrebuø10N,,0)
	oPrinter:Say(0237,2016,"Emissao: " + DTOC(dDataBase),oTrebuø10N,,0)
	oPrinter:Box(0286,0046,0444,2370)
	oPrinter:Say(0288,0058,"Cliente : " + ALLTRIM(TRB->A1_NOME),oTrebuø10N,,0)
	oPrinter:Say(0286,1838,"CPF / CNPJ : " + ALLTRIM(TRB->A1_CGC),oTrebuø10N,,0)
	oPrinter:Say(0342,0058,"Endereco : " + ALLTRIM(TRB->A1_END) + " - " + ALLTRIM(TRB->A1_BAIRRO) + " - " + ALLTRIM(TRB->A1_MUN) + " - " + ALLTRIM(TRB->A1_EST) + " - CEP " + ALLTRIM(TRB->A1_CEP),oTrebuø10N,,0)
	oPrinter:Say(0395,0058,"Fone/Fax : (" + ALLTRIM(TRB->A1_DDD) + ") " + ALLTRIM(TRB->A1_TEL) + "   (" + ALLTRIM(TRB->A1_DDD) + ") " + ALLTRIM(TRB->A1_TEL2),oTrebuø10N,,0)
	oPrinter:Say(0457,0050, "Endereço"			,oTrebuø10N,,0)
	oPrinter:Say(0457,0400, "Item"   			,oTrebuø10N,,0)
	oPrinter:Say(0457,0550, "Qtde."   		,oTrebuø10N,,0)
	oPrinter:Say(0457,0750, "U.M."	,oTrebuø10N,,0)
	oPrinter:Say(0457,0950, "Código Produto"	,oTrebuø10N,,0)
	oPrinter:Say(0457,1300, "Descrição produto"	,oTrebuø10N,,0)
	oPrinter:Say(0457,2100, "Peso Bruto"     	,oTrebuø10N,,0)
	oPrinter:Box(0460,0046,0504,2370)
	
	cQry := " SELECT C6_NUM, C6_ITEM, C6_LOCAL, C6_LOCALIZ, D2_QUANT, B1_UM, C6_PRODUTO, C6_DESCRI, B1_PESBRU, "
	cQry += " C6_ENTREG, C6_CLI, C6_LOJA, C6_NOTA, C6_SERIE "
	cQry += " FROM " + RETSQLNAME("SC6") + " (NOLOCK) SC6 "
	cQry += " INNER JOIN " + RETSQLNAME("SB1") + " (NOLOCK) SB1 ON B1_COD = C6_PRODUTO " 
	cQry += " INNER JOIN " + RETSQLNAME("SD2") + " (NOLOCK) SD2 ON D2_FILIAL = '" + XFILIAL("SD2") + "' "
	cQry += " AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SD2.D_E_L_E_T_ <> '*' " 	
	cQry += " LEFT JOIN " + RETSQLNAME("SF2") + " (NOLOCK) SF2 ON F2_FILIAL = '" + XFILIAL("SF2") + "' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_LOJA = D2_LOJA AND F2_CLIENTE = D2_CLIENTE AND SF2.D_E_L_E_T_ <> '*' "
	cQry += " WHERE C6_FILIAL = '" + XFILIAL("SC6") + "' "
	cQry += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "
	cQry += " AND SC6.D_E_L_E_T_ = ' ' "
	cQry += " AND SB1.D_E_L_E_T_ = ' ' "
	cQry += " AND C6_NUM = '" + TRB->DAI_PEDIDO  + "' "
	cQry += " AND C6_CLI = '" + TRB->DAI_CLIENT  + "' "
	cQry += " AND C6_LOJA = '" + TRB->DAI_LOJA   + "' "
	cQry += " AND F2_CARGA = '" + TRB->DAI_COD   + "' "
	//cQry += " AND C6_NOTA = '" + TRB->DAI_NFISCA + "' "	
	
	//MemoWrite('\Querys\KMOMSR01B.sql',cQuery)
	MemoWrite('\Querys\KMOMSR01C.sql',cQry)
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TMP",.F.,.T.)
	
	oPrinter:Say(0237,0991,"Previsao de Entrega : " + DTOC(STOD(TMP->C6_ENTREG)),oTrebuø10N,,0)
	
	nLin := 520
	nVol := 0
	While TMP->(!EOF())
		
		//#CMG20181003.bn
		cEnder	:= "R??-P??-A??"
		
		If Empty(AllTrim(TMP->C6_NOTA))//Se ainda não tem nota fiscal
			
			If !Empty(AllTrim(TMP->C6_LOCALIZ))
				cEnder := TMP->C6_LOCALIZ
			EndIf
			
		Else//se tem nota fiscal
						
			DbSelectArea("SDB")
			SDB->(DbSetOrder(1))//DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
			SDB->(DbGoTop())
			
			DbSelectArea("SDC")
			SDC->(DbSetOrder(1))//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
			SDC->(DbGoTop())
			
			DbSelectArea("SD2")
			SD2->(DbSetOrder(8))//D2_FILIAL+D2_PEDIDO+D2_ITEMPV
			SD2->(DbGoTop())
			SD2->(DbSeek(xFilial("SD2")+TMP->C6_NUM+TMP->C6_ITEM))
			
			If SDB->(DbSeek(xFilial("SDB") + SD2->D2_COD + SD2->D2_LOCAL + SD2->D2_NUMSEQ + SD2->D2_DOC + SD2->D2_SERIE +;
				SD2->D2_CLIENTE + SD2->D2_LOJA))
				cEnder := SDB->DB_LOCALIZ
			ElseIf SDC->(DbSeek(xFilial("SDC") + TMP->C6_PRODUTO + TMP->C6_LOCAL + "SC6" + TMP->C6_NUM + TMP->C6_ITEM))
				cEnder := SDC->DC_LOCALIZ
			EndIf
			
		EndIf
		
		oPrinter:Say(nLin,0050, cEnder	,oTrebuø10N,,0)
		
		//#CMG20181003.en
		
		oPrinter:Say(nLin,0400, TMP->C6_ITEM   												,oTrebuø10N,,0)
		oPrinter:Say(nLin,0550, Transform(TMP->D2_QUANT,PesqPict('SD2','D2_QUANT'))   	,oTrebuø10N,,0)
		oPrinter:Say(nLin,0750, TMP->B1_UM   												,oTrebuø10N,,0)
		oPrinter:Say(nLin,0950, TMP->C6_PRODUTO												,oTrebuø10N,,0)
		oPrinter:Say(nLin,2100, Transform(TMP->B1_PESBRU,PesqPict('SB1','B1_PESBRU'))		,oTrebuø10N,,0)
		nLin := nLin + 050
		oPrinter:Say(nLin,0950, ALLTRIM(TMP->C6_DESCRI)									,oTrebuø10N,,0)
		nLin := nLin + 080
		nVol := nVol + 1
		TMP->(DbSkip())
	EndDo
	nLin := nLin + 120
	oPrinter:Say(nLin,0602,"Totais -> " + ALLTRIM(STR(nVol)) + " Qtde.                                    " + ALLTRIM(STR(nVol)) + " VOLUMES",oTrebuø10N,,0)
	nLin := nLin + 80
	oPrinter:Box(nLin,0046,3000,2370)
	nLin := nLin + 5
	oPrinter:Say(nLin,1180,"Observacoes",oTrebuø10N,,0)
	nLin := nLin + 080
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PEGA AS INFORMACOES DO CAMPO OBSERVACAO DO PEDIDO DE VENDA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") + TRB->DAI_PEDIDO))
	cMaMemo  := MSMM(SC5->C5_XCODOBS,TamSx3("C5_XOBS")[1]) +CHR(13)+CHR(10)+CHR(13)+CHR(10)
	cMaMemo  += "OBSERVAÇÕES DE ENTREGA **" + CHR(13)+CHR(10) + replicate("-",130) + CHR(13)+CHR(10)
	cMaMemo  += MSMM(SC5->C5_XOBSENT,TamSx3("C5_XOBS")[1])
	cMenNota := SC5->C5_MENNOTA
	SC5->(DbCloseArea())
	
	aDados := U_IMPMEMO(cMaMemo, 130, "", .F.)
	
	//Percorrendo as linhas geradas
	For nAtual := 1 To Len(aDados)
		oPrinter:Say(nLin,0058,aDados[nAtual],oTrebuø10N,,0)
		nLin := nLin + 060
	Next
	nLin := nLin + 060
	
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
		oPrinter:Say(nLin,0058,aDados[nAtual],oTrebuø10N,,0)
		nLin := nLin + 060
	Next
	nLin := nLin + 060
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME A MENSAGEM QUE VAI NA NOTA FISCAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !EMPTY(cMenNota)
		oPrinter:Say(nLin,0058,"Mensagem Nota Fiscal",oTrebuø10N,,0)
		nLin := nLin + 060
		oPrinter:Say(nLin,0058,cMenNota,oTrebuø10N,,0)
	EndIF
	
	nLin := 3350
	
	oPrinter:Say(nLin,0438,"Separador Komfort House",oTrebuø10N,,0)
	oPrinter:Say(nLin,1507,"Separador Komfort House",oTrebuø10N,,0)
	nLin := nLin - 50
	oPrinter:Say(nLin,0389,"___________________________",oTrebuø10N,,0)
	oPrinter:Say(nLin,1439,"___________________________",oTrebuø10N,,0)
	oPrinter:EndPage()
	
	TRB->(DbSkip())
	nPag++
	cMaMemo := ""
EndDo
oPrinter:Preview()

restArea(aAreaSDB)
restArea(aAreaSDC)
RestArea(aAreaSD2)

RETURN()
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
