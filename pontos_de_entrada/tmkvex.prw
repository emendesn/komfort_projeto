#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TMKVEX   ณ Autor ณ  Eduardo Patriani  ณ Data ณ  28/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui o Pedido de Venda ao Canecelar o Atendimento.       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ 21/04/18  ณ #RVC20180421 - Tratamento para exclusใo do PV SAC		   ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TMKVEX()

Local lRet  := .F.

	msgstop("Exclusใo permitida apenas na rotina de TELEVENDAS.","Exclusใo nใo permitida")

Return (lRet)

//#RVC20180911.bo
/*
User Function TMKVEX()

Local aAreaSC5	:= SC5->(GetArea())
Local aArea 	:= GetArea()
Local lRet  	:= .T.
Private _lBaixaE1 := .F. //#CMG20180713.n
Private _lBaixaE2 := .F. //#CMG20180713.n

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSomente operacao 1=Faturamento.                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF SUA->UA_OPER <> "1"
	Return(lRet)
EndIF

//#RVC20180613.bn
dbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(dbGoTop())
If !EMPTY(SUA->UA_NUMSC5)
	If SC5->(DbSeek(xFilial("SC5") + Alltrim(SUA->UA_NUMSC5)))
		If (dDataBase <> SC5->C5_EMISSAO) .And. lRet
			MsgStop("Somente ้ permitido o cancelamento da venda, no mesmo dia em que foi realizada.","Aten็ใo")
			lRet := .F.
		Endif
	EndIf
Else
	lRet := .F.
EndIF

If lRet 
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe nao tiver sido faturado ou tiver a NF cancelada entao pode-se cancelar o pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SUA->UA_STATUS == "NF."
		Help(" ",1,"NF.EMITIDA")
		Return(.F.)
	Endif
	
	//ฺฤLocalizacoesฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe no tiver sido REMITITDO ou tiver a RM cancelado entao pode-se cancelar o pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SUA->UA_STATUS == "RM."
		Help(" ",1,"RM.ENVIADA")
		Return(.F.)
	Endif

	If fVldBord()
		Help(" ",1,"TITBORDERO", NIL,NIL, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Tํtulo(s) jแ estแ em border๔. Acione o depto. cr้dito"})
		Return(.F.)
	EndIf	
	
	ValidaE1()//#CMG20180713.n
	
	//#RVC201800619.bn
	If ValidaE2()	
		Help(" ",1,"TITBAIXADO", NIL,NIL, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Tํtulo(s) jแ processado(s). Acione o Financeiro (C.Pagar)"})
		Return(.F.)
	EndIf								
	//#RVC201800619.en	
	
	Begin TRANSACTION
		
	FwMsgRun( ,{|| lRet := ValidaC1(SUA->UA_NUMSC5) }, , "Por favor, Aguarde... Verificando solicita็๕es em aberto." )
	If !lRet //Retornou Erro
		DisarmTransaction()
		Return lRet
	EndIf	
	If _lBaixaE1
		FwMsgRun( ,{|| lRet := fCancBxE1(SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA) }, , "Por favor, Aguarde... Cancelando Baixas do a Receber" )	
	EndIf	
	If !lRet //Retornou Erro
		DisarmTransaction()	
		Return lRet
	EndIf
	FwMsgRun( ,{|| lRet := fDeletaFIN(SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA) }, , "Por favor, Aguarde... Excluindo tํtulos em aberto." )
	If !lRet //Retornou Erro
		DisarmTransaction()	
		Return lRet
	EndIf	
	FwMsgRun( ,{|| lRet := fDeletaRA(SUA->UA_NUMSC5) }, , "Por favor, Aguarde... Estornando tํtulos financeiros do tipo (RA)." )
	If !lRet //Retornou Erro
		DisarmTransaction()	
		Return lRet
	EndIf	
	FwMsgRun( ,{|| lRet := DeletaSE2(SUA->UA_NUMSC5)  }, , "Por favor, Aguarde... Estornando tํtulos financeiros ref. taxas." )	//#RVC20180619.n
	If !lRet //Retornou Erro
		DisarmTransaction()	
		Return lRet
	EndIf	
		
	END TRANSACTION
	
Endif

RestArea(aAreaSC5)	//#RVC20180613.n
RestArea(aArea)

Return(lRet)
*/
//#RVC20180911.eo
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fVldBord บAutor  ณ Caio garcia        บ Data ณ  29/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fVldBord()

Local cQuery 	:= ""
Local cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aRotAuto 	:= {}
Local aBaixa   	:= {}
               
If INCLUI .OR. ALTERA 	
	Return(lOk)
EndIf

cQuery += " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
cQuery += " E1_FILORIG 		= '"+ Alltrim(cFilAnt) +"' "	
cQuery += " AND E1_NUMSUA 	= '"+SUA->UA_NUM+"' "			
cQuery += " AND E1_CLIENTE 	= '"+SUA->UA_CLIENTE+"' " 		
cQuery += " AND E1_LOJA    	= '"+SUA->UA_LOJA+"' "			
cQuery += " AND E1_NUMBOR <> ' ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())

If (cAlias)->(Eof())
	lOk := .F.
Endif
(cAlias)->( dbCloseArea() )

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaC1 บAutor  ณ Caio Garcia     บ Data ณ  13/07/18      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida e exclui socilita็ใo de compra se tiver             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidaC1(_cPed)

Local cQuery 	:= ""
Local cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aCab 	:= {}
Local aItens   	:= {}
Local _cFilBkp := cFilAnt 
               
If INCLUI .OR. ALTERA //If INCLUI //#RVC20180613.n	
	Return(lOk)
EndIf

cQuery += " SELECT * "
cQuery += " FROM "+RetSqlName("SC1")+" SC1 "
cQuery += " WHERE C1_PEDRES = '"+_cPed+"' "	
cQuery += " AND SC1.D_E_L_E_T_ <> '*' "
cQuery += " AND C1_PEDIDO = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

cFilAnt := Subs(cFilAnt,1,2)+"01"

(cAlias)->(DbGotop())     

While (cAlias)->(!Eof())

	lMsErroAuto := .F.
	aCab    := {}
	aItens  := {}
	
	
	aAdd(aCab ,{"C1_NUM"    ,(cAlias)->C1_NUM		,Nil})

	aAdd( aItens, {{"C1_NUM"	     ,(cAlias)->C1_NUM	            ,Nil },;
                  {"C1_ITEM"	 ,(cAlias)->C1_ITEM             ,Nil },; 
                  {"C1_PRODUTO"	 ,(cAlias)->C1_PRODUTO          ,Nil} } )
                  
   	MSExecAuto({|x,y,z| MATA110(x,y,z)},aCab,aItens,5)	//EXCLUSAO

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lOk := .F.
	Endif
						
   	(cAlias)->(DbSkip()) 			
   		
EndDo

cFilAnt := _cFilBkp                                  

(cAlias)->( dbCloseArea() )

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaE1 บAutor  ณ SYMM CONSULTORIA   บ Data ณ  29/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a exclusao do titulos financeiros gerado pelo       บฑฑ
ฑฑบ          ณ orcamento de vendas.	                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TELEVENDAS - CALL CENTER                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidaE1()

Local cQuery 	:= ""
Local cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aRotAuto 	:= {}
Local aBaixa   	:= {}
               
//#RVC20180611.bn
If INCLUI .OR. ALTERA //If INCLUI //#RVC20180613.n	
	Return(lOk)
EndIf
//#RVC20180611.en

cQuery += " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
cQuery += " E1_FILORIG 		= '"+ Alltrim(cFilAnt) +"' "	//#RVC20180610.n
cQuery += " AND E1_NUMSUA 	= '"+SUA->UA_NUM+"' "			//#RVC20180610.n
cQuery += " AND E1_CLIENTE 	= '"+SUA->UA_CLIENTE+"' " 		//#RVC20180610.n
cQuery += " AND E1_LOJA    	= '"+SUA->UA_LOJA+"' "			//#RVC20180610.n
cQuery += " AND E1_BAIXA <> ' ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())

//If (cAlias)->(!Eof())
If (cAlias)->(Eof())
	lOk := .F.
Else
	_lBaixaE1 := .T. //#CMG20180713.n	
Endif
(cAlias)->( dbCloseArea() )

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaE2 บAutor  ณ Rafael Cruz        บ Data ณ  19/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a exclusao do titulos financeiros gerado pelo       บฑฑ
ฑฑบ          ณ orcamento de vendas.	                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TELEVENDAS - CALL CENTER                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidaE2()

Local cQuery 	:= ""
Local cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aTipo		:= SuperGetMv("KH_FRMTX",,"CC/CD/BOL/BST")
               
If INCLUI .OR. ALTERA	
	Return(lOk)
EndIf

cQuery += " SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ "
cQuery += " FROM "+RetSqlName("SE2")+" SE2 "
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  " 
cQuery += " AND E2_TIPO IN " + FormatIn(aTipo,"/")
cQuery += " AND E2_MSFIL = '" + Alltrim(cFilAnt) + "' "	
cQuery += " AND E2_HIST = '" + Alltrim(SUA->UA_NUMSC5) + "' "	
cQuery += " AND E2_BAIXA <> ' ' "
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())

If (cAlias)->(Eof())
	lOk := .F.
Else
	_lBaixaE2 := .T. //#CMG20180713.n
Endif
(cAlias)->( dbCloseArea() )

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDeletaFIN ณ Autor ณ  Eduardo Patriani  ณ Data ณ  28/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui os titulos financeiros.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fDeletaFIN(cOrcamento,cCliente,cLoja)

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local aSE1	 	:= {}
Local lOk	 	:= .T.
               
cQuery += " SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_BAIXA, SE1.R_E_C_N_O_ RECSE1 "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE E1_NUMSUA = '"+cOrcamento+"' "
cQuery += " AND E1_CLIENTE = '"+cCliente+"' "
cQuery += " AND E1_LOJA    = '"+cLoja+"' "
cQuery += " AND E1_FILORIG	= '"+ Alltrim(cFilAnt) +"' "	//#RVC20180619.n
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY E1_BAIXA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
   
DbSelectArea("SE1")
SE1->(DbSetOrder(1))
SE1->(DbGoTop()) 
 
(cAlias)->(DbGotop())
While (cAlias)->(!EOF())
	AAdd( aSE1 , { (cAlias)->E1_FILIAL,(cAlias)->E1_PREFIXO,(cAlias)->E1_NUM,(cAlias)->E1_PARCELA,(cAlias)->E1_TIPO,(cAlias)->E1_CLIENTE,(cAlias)->E1_LOJA,(cAlias)->E1_BAIXA,(cAlias)->RECSE1 } )
	
	//#CMG20180717.bn - Necessแrio alterar a origem para poder excluir o tํtulo pelo ExecAuto
	SE1->(DbGoTo((cAlias)->RECSE1)) 
	RecLock("SE1",.F.)
		SE1->E1_ORIGEM := 'FINA040'	
	SE1->(MsUnLock())
	//#CMG20180717.en
		
	(cAlias)->(dbSkip())
EndDo
(cAlias)->( dbCloseArea() )

For nI := 1 To Len(aSE1)
		
		lMsErroAuto := .F.
		aBaixa := {}
		
		AADD(aBaixa , {"E1_FILIAL"		,aSE1[nI,1]	,NIL})
		AADD(aBaixa , {"E1_PREFIXO"		,aSE1[nI,2]	,NIL})
		AADD(aBaixa , {"E1_NUM"			,aSE1[nI,3]	,NIL})
		AADD(aBaixa , {"E1_PARCELA"		,aSE1[nI,4]	,NIL})
		AADD(aBaixa , {"E1_TIPO"		,aSE1[nI,5]	,NIL})
		AADD(aBaixa , {"E1_CLIENTE"		,aSE1[nI,6]	,NIL})
		AADD(aBaixa , {"E1_LOJA"		,aSE1[nI,7]	,NIL})
		
//		MsExecAuto({|x,y,z| FINA040(x,y,z)}, aBaixa,,5)
		MSExecAuto({|x,y| FINA040(x,y)},aBaixa,5) //Exclusao
		
		If  lMsErroAuto
			MostraErro()
			DisarmTransaction()
			lOk := .F.			
		EndIf
			
Next

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCancBxE1ณ Autor ณ  Eduardo Patriani  ณ Data ณ  28/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui os titulos financeiros.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fCancBxE1(cOrcamento,cCliente,cLoja)

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local aSE1	 	:= {}
Local lOk	 	:= .T.
               
cQuery += " SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_BAIXA, SE1.R_E_C_N_O_ RECSE1 "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE E1_NUMSUA = '"+cOrcamento+"' "
cQuery += " AND E1_CLIENTE = '"+cCliente+"' "
cQuery += " AND E1_LOJA    = '"+cLoja+"' "
cQuery += " AND E1_FILORIG	= '"+ Alltrim(cFilAnt) +"' "	//#RVC20180619.n
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
cQuery += " AND E1_BAIXA <> ' ' "
cQuery += " ORDER BY E1_BAIXA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
 
(cAlias)->(DbGotop())
While (cAlias)->(!EOF()) //1                 2                         3              4                        5             6                      7                 8             9
	AAdd( aSE1 , { (cAlias)->E1_FILIAL,(cAlias)->E1_PREFIXO,(cAlias)->E1_NUM,(cAlias)->E1_PARCELA,(cAlias)->E1_TIPO,(cAlias)->E1_CLIENTE,(cAlias)->E1_LOJA,(cAlias)->E1_BAIXA,(cAlias)->RECSE1 } )
	(cAlias)->(dbSkip())
EndDo
(cAlias)->( dbCloseArea() )

For nI := 1 To Len(aSE1)
		
	lMsErroAuto := .F.
	aBaixa := {}
		
	AADD(aBaixa , {"E1_FILIAL"		,aSE1[nI,1]	,NIL})
	AADD(aBaixa , {"E1_PREFIXO"		,aSE1[nI,2]	,NIL})
	AADD(aBaixa , {"E1_NUM"			,aSE1[nI,3]	,NIL})
	AADD(aBaixa , {"E1_PARCELA"		,aSE1[nI,4]	,NIL})
	AADD(aBaixa , {"E1_TIPO"		,aSE1[nI,5]	,NIL})
	AADD(aBaixa , {"E1_CLIENTE"		,aSE1[nI,6]	,NIL})
	AADD(aBaixa , {"E1_LOJA"		,aSE1[nI,7]	,NIL})
		
	MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 5)	
		
	If  lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lOk := .F.
	EndIf
		
Next

Return(lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDeletaRA  ณ Autor ณ Eduardo Patriani  ณ Data ณ  30/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui os titulos financeiros do tipo "RA"                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDeletaRA(cPedido)

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local aSE5	 	:= {}
Local lOk	 	:= .T.
               
//cQuery += "SELECT * FROM "+RetSqlName("SE5")+" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_HISTOR LIKE '%"+cPedido+"%' AND E5_TIPO = 'RA' AND E5_TIPODOC = 'BA' AND D_E_L_E_T_ = ' ' ORDER BY E5_PREFIXO,E5_NUMERO,E5_PARCELA "	//#RVC20180611.o
cQuery += "SELECT * FROM "+RetSqlName("SE5")+" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_HISTOR LIKE '%"+cPedido+"%' AND E5_TIPO IN ('RA','NCC') AND E5_TIPODOC = 'BA' AND D_E_L_E_T_ = ' ' ORDER BY E5_PREFIXO,E5_NUMERO,E5_PARCELA "	//#RVC20180611.n
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!EOF())
	AAdd( aSE5 , { (cAlias)->E5_FILIAL,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMero,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA } )
	(cAlias)->(dbSkip())
EndDo
(cAlias)->( dbCloseArea() )

For nI := 1 To Len(aSE5)
			
	lMsErroAuto := .F.
	aBaixa := {}
		
	AADD(aBaixa , {"E1_FILIAL"		,aSE5[nI,1]	,NIL})
	AADD(aBaixa , {"E1_PREFIXO"		,aSE5[nI,2]	,NIL})
	AADD(aBaixa , {"E1_NUM"			,aSE5[nI,3]	,NIL})
	AADD(aBaixa , {"E1_PARCELA"		,aSE5[nI,4]	,NIL})
	AADD(aBaixa , {"E1_TIPO"		,aSE5[nI,5]	,NIL})
	AADD(aBaixa , {"E1_CLIENTE"		,aSE5[nI,6]	,NIL})
	AADD(aBaixa , {"E1_LOJA"		,aSE5[nI,7]	,NIL})
		
//	MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 6)	//#RVC20180611.o
	MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 5)	//#RVC20180611.n
		
	If  lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lOk := .F.
	Endif
	
Next

Return(lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDeletaSE2 ณ Autor ณ  Rafael Cruz       ณ Data ณ  19/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui os titulos financeiros ref. taxas adm               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function DeletaSE2(cPedido)

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local aVetor 	:= {}
Local aSE2		:= {}
Local lOk	 	:= .T.
Local cPrfx		:= SuperGetMv("KH_PREFSE2",.F.,"TXA")//SuperGetMv("KM_PREFIXO",.F.,"ADM")
Local aTipo		:= SuperGetMv("KH_FRMTX",,"CC/CD/BOL/BST")
               
cQuery += "SELECT SE2.R_E_C_N_O_ RECSE2, * FROM " + RetSqlName("SE2") + " SE2" 
cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "'  " 
cQuery += "AND E2_TIPO IN " + FormatIn(aTipo,"/")
cQuery += "AND E2_HIST LIKE '%" + cPedido        + "%' "
cQuery += "AND E2_PREFIXO = '"  + cPrfx          + "'  "
cQuery += "AND SE2.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY E2_PREFIXO,E2_NUM,E2_PARCELA "	
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
SE2->(DbGoTop()) 

(cAlias)->(DbGotop())
While (cAlias)->(!EOF())
	AAdd( aSE2 , { (cAlias)->E2_FILIAL,(cAlias)->E2_PREFIXO,(cAlias)->E2_NUM,(cAlias)->E2_PARCELA,(cAlias)->E2_TIPO,(cAlias)->E2_NATUREZ } )	
	
	//#CMG20180717.bn - Necessแrio alterar a origem para poder excluir o tํtulo pelo ExecAuto
	SE2->(DbGoTo((cAlias)->RECSE2)) 
	RecLock("SE2",.F.)
		SE2->E2_ORIGEM := 'FINA050'	
	SE2->(MsUnLock())
	//#CMG20180717.en
	
	(cAlias)->(dbSkip())
	
EndDo
(cAlias)->( dbCloseArea() )

For nI := 1 To Len(aSE2)
			
	lMsErroAuto := .F.
	aVetor := {}
		
	aVetor :={	{"E2_PREFIXO"	,aSE2[nI][2],Nil},;
				{"E2_NUM"		,aSE2[nI][3],Nil},;
				{"E2_PARCELA"	,aSE2[nI][4],Nil},;
				{"E2_TIPO"		,aSE2[nI][5],Nil},;			
				{"E2_NATUREZ"	,aSE2[nI][6],Nil}}

	MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5) //Exclusao		
	If  lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lOk := .F.
	Endif
	
Next

Return(lOk)