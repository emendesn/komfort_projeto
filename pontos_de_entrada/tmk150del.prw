#include "totvs.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMK150DEL  บ Autor ณ AP6 IDE           บ Data ณ  19/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Antes da grava็ใo do atendimento na rotina de Televendas   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑณ Programador ณ Data   ณ Chamado ณ Motivo da Alteracao                  ณฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑ              ณ        ณ         ณ                                      ณฑฑ
ฑฑ              ณ        ณ         ณ                                      ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/

User Function TMK150DEL()

	Local _lE1        := .F.
	Local _lE2        := .F.
	Local _lC1        := .F.
	Local _lC6        := .F.
	Local _lRA        := .F.
	Local _lFin       := .F.
	Local lRet  	  := .T.
	
	Local _cPedido := SC5->C5_NUM
	
	Local _cMsg       := "Problema nas rotinas:"

	Private _dEmissao := SC5->C5_EMISSAO
	Private _lBaixaE1 := .F. //#CMG20180713.n
	Private lExistRa := .F.

	FwMsgRun( ,{|| lRet := fDeletaRA(_cPedido) }, , "Por favor, Aguarde... Estornando as Baixas dos tํtulos do tipo (RA)..." )
	If !lRet //Retornou Erro
		_lRa := .T.	
		_cMsg += " |Exclusใo de Baixas dos RA's'| "
	EndIf	
	
	//valida se existe algum tituto com baixa
	ValidaE1() //#CMG20180713.n

	if !lExistRa
		If _lBaixaE1
			FwMsgRun( ,{|| lRet := fCancBxE1(SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_FILIAL) }, , "Por favor, Aguarde... Cancelando Baixas do a Receber..." )	
		EndIf	
		If !lRet //Retornou Erro
			_lE1 := .T.
			_cMsg += " |Estorno de Baixas do Contas a Receber| "		
		EndIf
	endif

	if !lExistRa
		FwMsgRun( ,{|| lRet := fDeletaFIN(SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_FILIAL) }, , "Por favor, Aguarde... Excluindo tํtulos em aberto..." )
		If !lRet //Retornou Erro
			_lFin := .T.	
			_cMsg += " |Exclusใo do Contas a Receber| "
		EndIf	
	endif

	if !lExistRa
		FwMsgRun( ,{|| lRet := DeletaSE2(_cPedido)  }, , "Por favor, Aguarde... Estornando tํtulos financeiros ref. taxas..." )	//#RVC20180619.n
		If !lRet //Retornou Erro
			_lE2 := .T.	
			_cMsg += " |Exclusใo do Contas a Pagar| "		
		EndIf	
	endif

	FwMsgRun( ,{|| lRet := ValidaC1(_cPedido) }, , "Por favor, Aguarde... Verificando solicita็๕es em aberto." )
	If !lRet //Retornou Erro
		_lC1 := .T.
		_cMsg += " |Exclusใo de Solicita็ใo de Compras| "
	EndIf

	If _lC1 .Or. _lE1 .Or. _lFin .Or. _lRa .Or. _lE2

		MsgStop(_cMsg,"ERRO")

	EndIf

Return


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
	Local _cAlias 	:= GetNextAlias()
	Local lOk	 	:= .T.
	Local aCab 	:= {}
	Local _aItens   	:= {}
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
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	cFilAnt := Subs(cFilAnt,1,2)+"01"

	(_cAlias)->(DbGotop())     

	While (_cAlias)->(!Eof())

		lMsErroAuto := .F.
		aCab    := {}
		_aItens  := {}

		aAdd(aCab ,{"C1_NUM"	,(_cAlias)->C1_NUM	,Nil})

		aAdd(_aItens, {;
						{"C1_NUM"	   	,(_cAlias)->C1_NUM	            ,Nil },;
						{"C1_ITEM"	 	,(_cAlias)->C1_ITEM             ,Nil },; 
						{"C1_PRODUTO"	,(_cAlias)->C1_PRODUTO          ,Nil} } )

		MSExecAuto({|x,y,z| MATA110(x,y,z)},aCab,_aItens,5)	//EXCLUSAO

		If lMsErroAuto
			MostraErro()
			lOk := .F.
		Endif

		(_cAlias)->(DbSkip()) 			

	EndDo

	cFilAnt := _cFilBkp                                  

	(_cAlias)->( dbCloseArea() )

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
	Local _cAlias 	:= GetNextAlias()
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
	cQuery += " E1_FILORIG 		= '"+SUA->UA_FILIAL+"' "		//#RVC20180610.n
	cQuery += " AND E1_NUMSUA 	= '"+SUA->UA_NUM+"' "			//#RVC20180610.n
	cQuery += " AND E1_CLIENTE 	= '"+SUA->UA_CLIENTE+"' " 		//#RVC20180610.n
	cQuery += " AND E1_LOJA    	= '"+SUA->UA_LOJA+"' "			//#RVC20180610.n
	cQuery += " AND E1_BAIXA <> ' ' "
	cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	(_cAlias)->(DbGotop())

	//If (_cAlias)->(!Eof())
	If (_cAlias)->(Eof())
		_lBaixaE1 := .F.
	Else
		_lBaixaE1 := .T. //#CMG20180713.n	
	Endif
	(_cAlias)->( dbCloseArea() )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDeletaFIN ณ Autor ณ  Eduardo Patriani  ณ Data ณ  28/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exclui os titulos financeiros.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fDeletaFIN(cOrcamento,cCliente,cLoja,cFil)

	Local _cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local aSE1	 	:= {}
	Local lOk	 	:= .T.

	cQuery += " SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_BAIXA, SE1.R_E_C_N_O_ RECSE1 "
	cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += " WHERE E1_NUMSUA = '"+cOrcamento+"' "
	cQuery += " AND E1_CLIENTE = '"+cCliente+"' "
	cQuery += " AND E1_LOJA    = '"+cLoja+"' "
	cQuery += " AND E1_FILORIG	= '"+cFil+"' "
	cQuery += " AND E1_EMISSAO = '"+ dtos(_dEmissao) +"'"
	cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY E1_BAIXA "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))
	SE1->(DbGoTop()) 

	(_cAlias)->(DbGotop())
	While (_cAlias)->(!EOF())
		AAdd( aSE1 , { (_cAlias)->E1_FILIAL,(_cAlias)->E1_PREFIXO,(_cAlias)->E1_NUM,(_cAlias)->E1_PARCELA,(_cAlias)->E1_TIPO,(_cAlias)->E1_CLIENTE,(_cAlias)->E1_LOJA,(_cAlias)->E1_BAIXA,(_cAlias)->RECSE1 } )

		//#CMG20180717.bn - Necessแrio alterar a origem para poder excluir o tํtulo pelo ExecAuto
		SE1->(DbGoTo((_cAlias)->RECSE1)) 
		RecLock("SE1",.F.)
		SE1->E1_ORIGEM := 'FINA040'	
		SE1->(MsUnLock())
		//#CMG20180717.en

		(_cAlias)->(dbSkip())
	EndDo
	(_cAlias)->( dbCloseArea() )

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

		//MsExecAuto({|x,y,z| FINA040(x,y,z)}, aBaixa,,5)
		MSExecAuto({|x,y| FINA040(x,y)},aBaixa,5) //Exclusao

		If  lMsErroAuto
			MostraErro()
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
Static Function fCancBxE1(cOrcamento,cCliente,cLoja,cFil)

	Local _cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local aSE1	 	:= {}
	Local lOk	 	:= .T.

	cQuery += " SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_BAIXA,E1_EMISSAO, SE1.R_E_C_N_O_ RECSE1 "
	cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += " WHERE E1_NUMSUA = '"+cOrcamento+"' "
	cQuery += " AND E1_CLIENTE = '"+cCliente+"' "
	cQuery += " AND E1_LOJA    = '"+cLoja+"' "
	cQuery += " AND E1_FILORIG	= '"+cFil+"' "
	cQuery += " AND E1_BAIXA <> ' ' "
	cQuery += " AND E1_TIPO NOT IN ('RA','NCC')"
	cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY E1_BAIXA "

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	(_cAlias)->(DbGotop())
	While (_cAlias)->(!EOF())
		
		if empty(_dEmissao)
			_dEmissao := (_cAlias)->E1_EMISSAO
		endif
		
		AAdd( aSE1 , {;
						(_cAlias)->E1_FILIAL,;
						(_cAlias)->E1_PREFIXO,;
						(_cAlias)->E1_NUM,;
						(_cAlias)->E1_PARCELA,;
						(_cAlias)->E1_TIPO,;
						(_cAlias)->E1_CLIENTE,;
						(_cAlias)->E1_LOJA,;
						(_cAlias)->E1_BAIXA,;
						(_cAlias)->RECSE1;
					} )
		
		(_cAlias)->(dbSkip())
	EndDo
	
	(_cAlias)->( dbCloseArea() )

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

		//3 - Baixa de Tํtulo
		//5 - Cancelamento de baixa
		//6 - Exclusใo de Baixa
		MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 5)	

		If  lMsErroAuto
			MostraErro()
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

	Local _cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local aSE5	 	:= {}
	Local lOk	 	:= .T.

	cQuery += "SELECT * FROM " +RetSqlName("SE5")+		" 
	cQuery += "WHERE E5_FILIAL = '"+xFilial("SE5")+"'	" 
	cQuery += "AND SUBSTRING(E5_HISTOR,4,6) = '"+ cPedido +"' "
	cQuery += "AND E5_TIPO IN ('RA','NCC') 				"
	cQuery += "AND E5_TIPODOC = 'BA' 					"
	cQuery += "AND E5_SITUACA <> 'C' 					" //#RVC20180919.n
	cQuery += "AND D_E_L_E_T_ = ' ' 					"
	cQuery += "ORDER BY E5_PREFIXO,E5_NUMERO,E5_PARCELA "
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
		
	If (_cAlias)->(!EOF())	//#RVC20180919.n
		(_cAlias)->(DbGotop())
		While (_cAlias)->(!EOF())

			lExistRa := .T.

			AAdd( aSE5 , {;
							(_cAlias)->E5_FILIAL,;
							(_cAlias)->E5_PREFIXO,;
							(_cAlias)->E5_NUMERO,;
							(_cAlias)->E5_PARCELA,;
							(_cAlias)->E5_TIPO,;
							(_cAlias)->E5_CLIFOR,;
							(_cAlias)->E5_LOJA,;
							(_cAlias)->E5_DATA;
						 } )
			(_cAlias)->(dbSkip())
		EndDo
		(_cAlias)->( dbCloseArea() )
	Else
		
		Return(lOk)
	
	EndIf
	//#RVC20180919.en
	
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

		//	3 - Baixa de Tํtulo
		//  5 - Cancelamento de baixa
		//  6 - Exclusใo de Baixa
		MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 5)	//#RVC20180611.n

		If lMsErroAuto
			MostraErro()
			lOk := .F.
		Else
			//Data da Baixa
			_dEmissao := aSE5[nI,8]
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

	Local _cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local aVetor 	:= {}
	Local aSE2		:= {}
	Local lOk	 	:= .T.
	Local cPrfx		:= SuperGetMv("KH_PREFSE2",.F.,"TXA")//SuperGetMv("KM_PREFIXO",.F.,"ADM")
	Local aTipo		:= SuperGetMv("KH_FRMTX",,"CC/CD/BOL/BST")

	cQuery += "SELECT SE2.R_E_C_N_O_ RECSE2, * FROM " + RetSqlName("SE2") + " SE2" 
	cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "'  " 
	cQuery += "AND E2_TIPO IN " + FormatIn(aTipo,"/")
	cQuery += "AND E2_HIST = '"+ cPedido +"' "
	cQuery += "AND E2_PREFIXO = '"  + cPrfx + "'  "
	cQuery += "AND E2_EMISSAO = '"+ dtos(_dEmissao) +"' "
	cQuery += "AND SE2.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY E2_PREFIXO,E2_NUM,E2_PARCELA "	
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	SE2->(DbGoTop()) 

	(_cAlias)->(DbGotop())
	While (_cAlias)->(!EOF())
//		Add( aSE2 , { (_cAlias)->E2_FILIAL,(_cAlias)->E2_PREFIXO,(_cAlias)->E2_NUM,(_cAlias)->E2_PARCELA,(_cAlias)->E2_TIPO,(_cAlias)->E2_NATUREZ})						//#RVC20180926.o
		aAdd( aSE2 , {;
						(_cAlias)->E2_FILIAL,;
						(_cAlias)->E2_PREFIXO,;
						(_cAlias)->E2_NUM,;
						(_cAlias)->E2_PARCELA,;
						(_cAlias)->E2_TIPO,;
						(_cAlias)->E2_NATUREZ,;
						(_cAlias)->RECSE2;
					})	//#RVC20180926.n
		(_cAlias)->(dbSkip())
	EndDo
	(_cAlias)->( dbCloseArea() )

	For nI := 1 To Len(aSE2)

		//#CMG20180717.bn - Necessแrio alterar a origem para poder excluir o tํtulo pelo ExecAuto
//		SE2->(DbGoTo((_cAlias)->RECSE2))	//#RVC20180926.o
		SE2->(DbGoTo(aSE2[nI][7]))			//#RVC20180926.n 

		RecLock("SE2",.F.)
			SE2->E2_ORIGEM := 'FINA050'	
		SE2->(MsUnLock())
		//#CMG20180717.en

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
Static Function DeletaSC6(_cPedido)

	Local _cAlias 	:= GetNextAlias()
	Local cQuery 	:= ""
	Local lOk	 	:= .T.
	Local _aCabec   := {}
	Local _aItens   := {}
	Local _aLinha   := {}

	lMsErroAuto := .F.

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop()) 

	If SC5->(DbSeek(xFilial("SC5")+_cPedido))//Se nใo excluiu
		lOk := .F.
	Else
		lOk := .T.
	EndIf	

	cQuery += "SELECT SC6.R_E_C_N_O_ RECSC6, * FROM " + RetSqlName("SC6") + " SC6" 
	cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "'  " 
	cQuery += "AND C6_NUM = '"  + _cPedido          + "'  "
	cQuery += "AND SC6.D_E_L_E_T_ <> '*' "
	//If lOk
	//	cQuery += "AND C6_BLQ = 'R' "
	//EndIf

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	If !lOk

		_aCabec := {}
		_aItens := {}
		aadd(_aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
		aadd(_aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
		aadd(_aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
		aadd(_aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
		aadd(_aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
		aadd(_aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})

		_aLinha := {}

		(_cAlias)->(DbGotop())
		While (_cAlias)->(!EOF())


			aadd(_aLinha,{"LINPOS","C6_ITEM",(_cAlias)->C6_ITEM})
			aadd(_aLinha,{"AUTDELETA","N",Nil})
			aadd(_aLinha,{"C6_PRODUTO",(_cAlias)->C6_PRODUTO,Nil})
			aadd(_aLinha,{"C6_QTDVEN",(_cAlias)->C6_QTDVEN,Nil})
			aadd(_aLinha,{"C6_PRCVEN",(_cAlias)->C6_PRCVEN,Nil})
			aadd(_aLinha,{"C6_PRUNIT",(_cAlias)->C6_PRUNIT,Nil})
			aadd(_aLinha,{"C6_VALOR",(_cAlias)->C6_VALOR,Nil})
			aadd(_aLinha,{"C6_TES",(_cAlias)->C6_TES,Nil})
			aadd(_aItens,_aLinha)

			(_cAlias)->(dbSkip())

		EndDo

		MATA410(_aCabec,_aItens,5)

		If lMsErroAuto
			lOk := .F.
		Else
			lOk := .T.
		EndIf

	Else

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbGoTop())

		(_cAlias)->(DbGotop())
		While (_cAlias)->(!EOF())

			SC6->(DbGoTo((_cAlias)->RECSC6))

			RecLock("SC6",.F.)

			SC6->(DbDelete())

			SC6->(MsUnLock())

			(_cAlias)->(dbSkip())

		EndDo


	EndIf

	(_cAlias)->( dbCloseArea() )


Return(lOk)
