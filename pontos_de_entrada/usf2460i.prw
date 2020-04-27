#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ USF2460I ºAutor  ³Microsiga           º Data ³  29/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada apos a gravacao do documento de saida     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I()

Local aArea		:= GetArea()
Local cNota  	:= SF2->F2_DOC                                                    
Local cSerie 	:= SF2->F2_SERIE
Local cCliente  := SF2->F2_CLIENTE
Local cLoja 	:= SF2->F2_LOJA
Local lOk		:= .T.
Local aPedidos	:= {}
local cCarga	:= SF2->F2_CARGA
Local _lAuto    := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VERIFICA SE O PEDIDO E DE TRANSFERENCIA DE MOSTRUARIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//#RVC20180627.bo 
/*
IF SC5->C5_01PEDMO == "1"
	FwMsgRun( ,{|| CRIAPNF() }, , "Criando a pré-nota de entrada , Por Favor Aguarde..." )	
EndIF */
//#RVC20180627.eo

If isInCallStack('U_KMESTF01')
	_lAuto := .T.
	ConOut("-----SF2460I AUTOMATICA------") 
EndIf	

//#RVC20180627.bn
If SC5->C5_01TPOP == '2' .And. !_lAuto
	IF SC5->C5_01PEDMO == "1"
		FwMsgRun( ,{|| CRIAPNF(1) }, , "Criando a pré-nota de entrada na Matriz, Por Favor Aguarde..." )
//		FGerNFE() //#CMG20180830.n
	Else
		FwMsgRun( ,{|| CRIAPNF(2) }, , "Criando a pré-nota de entrada na Loja, Por Favor Aguarde..." )
	EndIF
EndIf
//#RVC20180627.en
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nota Normal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
If (SF2->F2_TIPO <> "N")
	//RestArea(aArea)
	//Return
EndIf   

DbSelectArea("SD2")
DbSetOrder(3)//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
If DbSeek(xFilial("SD2")+cNota+cSerie+cCliente+cLoja)
	While !Eof() .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==xFilial("SD2")+cNota+cSerie+cCliente+cLoja	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVA NOS ITENS DA NOTA FISCAL DE SAIDA (SD2) O NUMERO DO CHAMADO DO SAC TRAZIDO DO PEIDO (SE HOUVER) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5") + SD2->D2_PEDIDO ))
			RecLock("SD2",.F.)
				SD2->D2_01SAC := SC5->C5_01SAC
			MsUnlock()
		EndIf
		
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV ))
			If !Empty(SC6->C6_NUMTMK)
				nPos := Ascan(aPedidos , SC6->C6_NUMTMK ) 
				If nPos==0
					AAdd( aPedidos , SC6->C6_NUMTMK )
				Endif
			Else
				lOk := .F.
			Endif			
		Endif
		
		//ATUALIÇÃO DE STATUS DO PEDIDO TIPO 5 - oSt8 - "BR_CINZA" "Em Entrega" 
		if alltrim(cCarga) <>  ""
			U_SYTMOV15(SD2->D2_PEDIDO,SD2->D2_ITEMPV,SD2->D2_COD ,"5")
		endif
			
		DbSelectArea("SD2")
		DbSkip()
	End 	
Endif

If !lOk
	RestArea(aArea)
	Return
Endif

If Len(aPedidos) > 0
	
	For nI := 1 To Len(aPedidos)
		SUA->( DbSetOrder(1) )
		If SUA->( DbSeek(aPedidos[nI]) )
			If !Empty(SUA->UA_PEDLIN2)
				RecLock("SUA",.F.)
				SUA->UA_EMISNF 	:= dDatabase
				SUA->UA_SERIE	:= cSerie
				SUA->UA_DOC		:= cNota
				MsUnlock()
			Endif
		Endif
	Next
	
Endif   



RestArea(aArea)
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º CRIAPNF  º Autor º LUIZ EDUARDO F.C.  º Data ³  18/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ GERA A PRE-NOTA DE ENTRADA DOS PEDIDOS DE TRANSFERENCIA 	  º±±
±±ºObjetivo  ³ DE MOSTRUARIO                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                             
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                             
STATIC FUNCTION CRIAPNF(nTipo)
//STATIC FUNCTION CRIAPNF()	//#RVC20180627.o

Local aArea		 := GetArea()  
Local aAreaSF1   := SF1->(GetArea())
Local aAreaSD1   := SD1->(GetArea())
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSD2   := SD2->(GetArea())
Local aAreaSA1	 := SA1->(GetArea())	//#RVC20180627.n
Local aAreaSA2   := SA2->(GetArea())
Local cFlBkp     := cFilAnt
Local cESPPNFE   := GETMV("MV_ESPPNFE",,"SPED")
Local cTPPNFE    := GETMV("MV_TPPNFE",,"N")
//Local cFORPNFE   := GETMV("MV_FORPNFE",,"S")	//#RVC20180629.o
Local cFORPNFE   := GETMV("MV_FORPNFE",,"N")	//#RVC20180629.n
Local cLJENTPNF  := GETMV("MV_LJENTPNF",,cFilAnt)
Local cLOCGLP    := GetMV("MV_LOCGLP")																
Local cLocDep	 := GetMv("MV_SYLOCDP",,"0101")
Local cLocLoj	 := ""	//#RVC20180629.n
Local cTESTrf	 := SuperGetMV("KH_TESTRF",.F.,"054")

Local _cAlias    := GetNextAlias()	//#CMG20180626.n
Local _cQuery    := ""				//#CMG20180626.n

//Local cCodFor    := GetMV("KH_FORCDKH",,"00000101") //Codigo do Fornecedor Komfort House CD -- comentado por Deo
// o fornecedor correspondente a filial sera encontrado pelo campo A2_FILTRF

Private aCabec:= {}
Private aItens:= {}
Private aLinha:= {}
Private lMsErroAuto := .F.

Default nTipo := 1

Begin Transaction

//FWLOADSM0()  -- comentado por deo - Nao vi funcionalidade

//////////////////////////////////////////////////////////////////
//Localizarr fornecedor correspondente a esta loja 
//////////////////////////Deo//////10/01/18//////K026//////////////
SA2->(DbOrderNickName("FILTRF2"))
If !SA2->(DbSeek(xFilial("SA2") + cFilAnt)) 
	Aviso("SYTMOB03 - Atenção!!!","Fornecedor correspondente a esta filial "  + cFilAnt +;
	      " nao encontrado. Verifique cadastro/vinculo pelo campo Filial de Transferencia (A2_FILTRF)",{"Ok"})
	DisarmTransaction()	//#RVC20180628.n
    Return
EndIf

//#CMG20180626.bn
_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SD2") + " SD2 "
_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
_cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"' "
_cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"' "
_cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
_cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"' "
_cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
_cQuery += " ORDER BY D2_ITEM "
_cQuery := ChangeQuery(_cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

//#CMG20180626.en

//#RVC20180629.bn
If nTipo <> 1
	cLocLoj := GetAdvFVal("SA1","A1_FILTRF",xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,1,"")
	cLOCGLP := SuperGetMV("SY_LOCPAD",.F.,"01",cLocLoj)
EndIf
//#RVC20180629.en

If (_cAlias)->(!Eof())

aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
				{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
				{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
				{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
				{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
				{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
				{'F1_FORNECE'	,SA2->A2_COD 	    ,NIL},;
				{'F1_LOJA'		,SA2->A2_LOJA   	,NIL}}
                      
/*
{'F1_FORNECE'	,Left(cCodFor,6) 	,NIL},;
{'F1_LOJA'		,Right(cCodFor,2)  	,NIL}}
*///Comentado por Deo - fornecedor correspondente pass a ser localizado pelo campo A2_FILTRF 			                      
                                                    
While (_cAlias)->(!EOF())
	aLinha := {}
	
	aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
				{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
				{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
				{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
				{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
				{'D1_TIPO'		,cTPPNFE 				,NIL},;
				{'D1_LOCAL'		,cLOCGLP	  			,NIL},;
				{'D1_TES'		,cTESTRF				,NIL}}

	aadd(aItens,aLinha)
	(_cAlias)->(DbSkip())

EndDo

//cFilAnt := cLJENTPNF --Comentado por Deo - A filial de entrada é o CD correspondente a loja em cLocDep
//#RVC20180627.bo
/*cFilAnt := cLocDep
LjMsgRun("Aguarde...Criando Documento de Entrada",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)  })
cFilAnt := cFlBkp*/
//#RVC20180627.eo

//#RVC20180627.bn
If nTipo == 1
	cFilAnt := cLocDep
	LjMsgRun("Aguarde...Criando Documento de Entrada",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)  })
	cFilAnt := cFlBkp
Else
	cFilAnt := cLocLoj
	SA1->(DbOrderNickName("FILTRF")) 
	If Empty(cFilAnt) .OR. !SA1->(DbSeek(xFilial("SA1") + cFilAnt )) 
		Aviso("SYTMOB03 - Atenção!!!","A filial correspondente ao Cliente "  + SF2->F2_CLIENTE + "/" + SF2->F2_LOJA +;
		" nao encontrado. Verifique cadastro/vinculo pelo campo Filial de Transferencia (A1_FILTRF)",{"Ok"})
		cFilAnt := cFlBkp
		DisarmTransaction() 
		Return
    EndIf
    
	LjMsgRun("Aguarde...Criando Documento de Entrada",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)  })
	cFilAnt := cFlBkp
EndIf
//#RVC20180627.en

If lMsErroAuto
	mostraerro()
Else	
//	MsgInfo("Pré-nota de entrada criada com sucesso - número : " + SF2->F2_DOC + " / " + SF2->F2_SERIE + "!")	//#RVC20180629.o
	MsgInfo("Pré-nota de entrada criada com sucesso - número : " + SF2->F2_DOC + " / " + SF2->F2_SERIE + " - Loja " + IIF(nTipo==1,Alltrim(FWFilialName(cEmpAnt,cFilAnt,1)),Alltrim(FWFilialName(cEmpAnt,cLocLoj,1)) + "."))	//#RVC20180629.n
EndIf

EndIf

End Transaction  

RestArea(aArea) 
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSA1)	//#RVC20180627.n
RestArea(aAreaSA2)

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  º CRIAPNF  º Autor º Caio Garcia        º Data ³  30/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ GERA NOTA DE ENTRADA DOS PEDIDOS DE TRANSFERENCIA 	      º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FGerNFE()

Local aArea		 := GetArea()
Local aAreaSF1   := SF1->(GetArea())
Local aAreaSD1   := SD1->(GetArea())
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSD2   := SD2->(GetArea())
Local aAreaSA1	 := SA1->(GetArea())
Local aAreaSA2   := SA2->(GetArea())
Local cFlBkp     := cFilAnt
Local cESPPNFE   := GETMV("MV_ESPPNFE",,"SPED")
Local cTPPNFE    := GETMV("MV_TPPNFE",,"N")
Local cFORPNFE   := GETMV("MV_FORPNFE",,"N")
Local cLJENTPNF  := GETMV("MV_LJENTPNF",,cFilAnt)
Local cLOCGLP    := GetMV("MV_LOCGLP")
Local cLocDep	 := GetMv("MV_SYLOCDP",,"0101")
Local cLocLoj	 := ""
Local cTESTrf	 := SuperGetMV("KH_TESTRF",.F.,"054")

Local _cAlias    := GetNextAlias()
Local _cQuery    := ""

Local _cArmMos   := GETMV("MV_LOCGLP",,"03") 

Private aCabec:= {}
Private aItens:= {}
Private aLinha:= {}
Private lMsErroAuto := .F.
                          
DbSelectArea("SA2")
SA2->(DbOrderNickName("FILTRF2"))
SA2->(DbSeek(xFilial("SA2") + cFlBkp))

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SD2") + " SD2 "
_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
_cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"' "
_cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"' "
_cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
_cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"' "
_cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
_cQuery += " ORDER BY D2_ITEM "
_cQuery := ChangeQuery(_cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())
              
cLocLoj := GetAdvFVal("SA1","A1_FILTRF",xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,1,"")
cLOCGLP := SuperGetMV("SY_LOCPAD",.F.,"01",cLocLoj)

If (_cAlias)->(!Eof())
	
	aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
	{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
	{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
	{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
	{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
	{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
	{'F1_COND'	    ,'001'	            ,NIL},;
	{'F1_FORNECE'	,SA2->A2_COD        ,NIL},;
	{'F1_LOJA'		,SA2->A2_LOJA  	    ,NIL}}
	
	While (_cAlias)->(!EOF())
		aLinha := {}
		
		aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
		{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
		{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
		{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
		{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
		{'D1_TIPO'		,cTPPNFE 				,NIL},;
		{'D1_LOCAL'		,_cArmMos	  			,NIL},;
		{'D1_TES'		,cTESTrf				,NIL}}
		
		aadd(aItens,aLinha)
		(_cAlias)->(DbSkip())
		
	EndDo
	
	
	cFilAnt := '0101'    
	PUTMV("MV_DISTMOV", .F.)	
	PUTMV("MV_PCNFE", .F.)
	MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)
	
	If lMsErroAuto
		ConOut("Erro ao incluir NF De Entrada - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )   
		   
		lMsErroAuto := .F.
		
		ConOut("Gera Pre-Nota" )   		
		MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens,3)
		
		If lMsErroAuto
		
			ConOut("Erro ao incluir Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )                       
		
		Else 
		
			ConOut("Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )   
		
		EndIf
				
//		mostraerro()  
	Else
		ConOut("NF ENTRADA - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
	EndIf

	cFilAnt := cFlBkp
	PUTMV("MV_DISTMOV", .T.)
	PUTMV("MV_PCNFE", .T.)	
		
EndIf

RestArea(aArea)
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return()
