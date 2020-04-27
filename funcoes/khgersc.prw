#INCLUDE 'PROTHEUS.CH'

#DEFINE ENTER CHR(13)+CHR(10)
//--------------------------------------------------------------|
//	Function - KHGERSC() -> //Gera solicitação de compras..	   	| 
//  Param - Array(Pedido,Produto,Item,Qtd Venda)                |
//	Uso - Komfort House										   	|
//  By Alexis Duarte - 15/10/2018  								|
//--------------------------------------------------------------|

User Function KHGERSC(_aItensPed,aGerados)

    Local aAreaSC5 := getArea("SC5")
    Local aAreaSC6 := getArea("SC6")
    Local aAreaSB1 := getArea("SB1")
    
    Local cNumSC := ""
    Local aCab := {}
    Local aItens := {}
    Local _cPerso := ''
    Local _cPrdEsp := ''
    Local _aItemC1 := {}
    Local cBkpFil := cFilAnt
    Local cNumPV := ""
	
    private lMsErroAuto := .F.
	
	Default aGerados := {}

    cFilAnt:= '0101' 

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))

    DbSelectArea("SC6")
    SC6->(DbSetOrder(1))

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))

    for nx := 1 to len(_aItensPed)
		
        cNumPV := _aItensPed[nx][1]//Numero do PV

		lMsErroAuto := .F.
		aCab := {}
		aItens := {}
		_aItemC1 := {}
		
		cNumSC := NextNumero ("SC1",1, "C1_NUM", .T.)
		
		aAdd(aCab ,{"C1_NUM"    ,cNumSC		,Nil})
		aAdd(aCab ,{"C1_SOLICIT",UsrRetName(RetCodUsr()) ,Nil})
		aAdd(aCab ,{"C1_EMISSAO",dDataBase	,Nil})
		aAdd(aCab ,{"C1_TPOP"   ,"F" 	   	,Nil})
		aAdd(aCab ,{"C1_UNIDREQ",""        	,Nil})
		aAdd(aCab ,{"C1_CODCOMP",""       	,Nil})
		aAdd(aCab ,{"C1_FILENT",cFilAnt    	,Nil})
        
        // itens _aItensPed(Pedido,Produto,Item,Qtd Venda)
        
        //C5_FILIAL, C5_NUM, R_E_C_N_O_, D_E_L_E_T_
        SC5->(DbSeek(xFilial("SC5")+_aItensPed[nx][1]))
        
        //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
        SC6->(DbSeek(xFilial("SC6")+_aItensPed[nx][1]+_aItensPed[nx][3]+_aItensPed[nx][2]))
        
		//B1_FILIAL, B1_COD, R_E_C_N_O_, D_E_L_E_T_
        SB1->(DbSeek(xFilial("SB1")+_aItensPed[nx][2]))
		
        If SB1->B1_XPERSO == '1'
			_cPerso := '1'
		Else
			_cPerso := '2'
		EndIf

		If Empty(AllTrim(SB1->B1_XCODORI))
			_cPrdEsp := ''
		Else
			_cPrdEsp := SB1->B1_XCODORI
		EndIf
        
        aAdd(_aItemC1,{"C1_NUM"	    ,cNumSC	            ,Nil })
//		aAdd(_aItemC1,{"C1_ITEM"	,SC6->C6_ITEM       ,Nil })
		aAdd(_aItemC1,{"C1_ITEM"	,STRZERO(VAL(SC6->C6_ITEM),TAMSX3("C1_ITEM")[1]),Nil })
		aAdd(_aItemC1,{"C1_PRODUTO"	,SC6->C6_PRODUTO    ,Nil })
		aAdd(_aItemC1,{"C1_UM"		,SC6->C6_UM		    ,Nil })
		aAdd(_aItemC1,{"C1_DESCRI"	,SB1->B1_DESC		,Nil })
		aAdd(_aItemC1,{"C1_QUANT"	,SC6->C6_QTDVEN		,Nil })
		aAdd(_aItemC1,{"C1_DATPRF"	,SC6->C6_ENTREG    	,Nil })
		aAdd(_aItemC1,{"C1_FORNECE"	,SB1->B1_PROC    	,Nil })
		aAdd(_aItemC1,{"C1_LOJA"	,SB1->B1_LOJPROC 	,Nil })
		aAdd(_aItemC1,{"C1_XDESCFI"	,SC5->C5_XDESCFI 	,Nil })
		aAdd(_aItemC1,{"C1_XPERSO"	,_cPerso            ,Nil })
		
        If !Empty(AllTrim(_cPrdEsp))
			aAdd(_aItemC1,{"C1_XPRDORI"	,_cPrdEsp       ,Nil })
		EndIf
		
        aAdd(_aItemC1,{"C1_GRUPCOM"	,"" 				,Nil})
		aAdd(_aItemC1,{"C1_PEDRES"	, cNumPV            ,Nil})
		
		aAdd( aItens, aClone(_aItemC1))
		
		MSExecAuto({|x,y,z| MATA110(x,y,z)},aCab,aItens,3)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Vincular a solicitaçao criada ao item do pedido para posteriormente  ³
		//³utilizar na rotina de Entrada de Documentos para liberar o pedido    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If !lMsErroAuto
			
            //Solicitações geradas
            aAdd(aGerados,{cNumSC})

            If SC6->(DbSeek(xFilial("SC6")+_aItensPed[nx][1]+_aItensPed[nx][3]+_aItensPed[nx][2]))
				RecLock("SC6",.F.)
                    SC6->C6_XNUMSC := cNumSC
                    SC6->C6_XITEMSC  := Padl(_aItensPed[nx][3],TAMSX3("C6_ITEM")[1],'0')
				SC6->(MsUnlock())
			Endif
			            
			ConfirmSX8()
			
		Else
			
    		RollBackSx8()
            MostraErro()			

		EndIf
		
	next nx

    //Retorna para filial logada
    cFilAnt := cBkpFil
	
	restArea(aAreaSC5)
    restArea(aAreaSC6)
    restArea(aAreaSB1)

Return