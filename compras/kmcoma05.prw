#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF	   CHR(10)+CHR(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KMCOMA05 บ Autor ณ DEOSDETE           บ Data ณ  26/12/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ao termino de cada dia, gerar solicitacao de compras para  บฑฑ
ฑฑบ          ณ a carteira de vendas e trocas que estao sem estoque. K023  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ KOMFORT HOUSE                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User function KMCOMA05(cNumPV,cMsfil)

If !IsBlind() .And. Upper(Alltrim(FunName())) <> "SYVM107"
//	Processa({|| KHCOMA05(cNumPV,cMsfil)},"Aguarde...")   //FUNวรO COMENTADA POIS NรO ษ GERADA SOLICITAวรO DE COMPRAS PARA MATERIAIS DE REVENDA - Marcio Nunes - 30/09/2019
Else
//	KHCOMA05(cNumPV,cMsfil) 
Endif

Return


/*---------------------------------------------------------------------*
| Func:  KHCOMA05                                                     |
| Autor: Deosdete                                                     |
| Data:  26/12/2017                                                   |
| Desc:  Processa rotina para gerar solicitacao de compras            |
*---------------------------------------------------------------------*/

Static Function KHCOMA05(cNumPV,cMsfil)

Local cNumSC      := ""
Local nCnt        := 0
Local cMVLOCSC    := SuperGetMV("KH_LOCGSC",.F.,"04,01")
Local cAliasSC6   := GetNextAlias()
Local aCab        := {}
Local aItens      := {}
Local nCntErro    := 0
Local cFilAtu 	  := cFilAnt
Local _cPerso     := ''
Local _cPrdEsp    := ''
Local _aItemC1 := {}

AutoGrLog("--------------------------------------------------------")
AutoGrLog("-------- GERACAO DE SCs PARA PEDIDOS BLOQUEADOS ---------")
AutoGrLog("--------------------------------------------------------")
AutoGrLog("DATA: "+DToC(dDataBase)+"                               ")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Busca todos os pedidos por falta de estoque onde o tipo ้ de encomenda ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SC5")
SC5->(dbSetOrder(1))

dbSelectArea("SC6")
SC6->(dbSetOrder(1))

cQuery := "SELECT B1_01FORAL, SC6.C6_FILIAL,SC6.C6_NUM, C6_PRODUTO, SC6.C6_ITEM,SC5.C5_TIPLIB, " +CRLF
cQuery += "SC6.R_E_C_N_O_ SC6RECNO, C6_UM, C6_QTDVEN, B1_PROC, B1_LOJPROC, B1_DESC, C6_ENTREG, SC5.C5_XDESCFI, B1_XPERSO, B1_XCODORI " +CRLF //#CMG20180702.n
cQuery += "FROM "+RetSqlName("SC6")+" SC6 " +CRLF

cQuery += "JOIN " + RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL  = C6_FILIAL " +CRLF
cQuery += "AND SC5.C5_NUM     = C6_NUM " +CRLF
cQuery += "AND SC5.D_E_L_E_T_ <> '*' " +CRLF

cQuery += "INNER JOIN " + RetSqlName("SB1")+" SB1 ON C6_PRODUTO = B1_COD "+CRLF
cQuery += "AND B1_FILIAL = '" + xFilial("SB1") + "' " +CRLF
cQuery += "AND B1_XENCOME = '2' " +CRLF // Produtos do tipo Encomenda
cQuery += "AND SB1.D_E_L_E_T_ <> '*' "	+CRLF

cQuery += "WHERE SC6.C6_FILIAL = '" + xFilial("SC6") + "'  " +CRLF
cQuery += "AND C6_XNUMSC  = '' " +CRLF  //Pegar os pedidos que ainda nao tem SC gerada
cQuery += "AND C6_XITEMSC  = '' " +CRLF
cQuery += "AND C6_LOCAL  IN " + CriaLista(cMVLOCSC) + " " +CRLF
cQuery += "AND SC6.D_E_L_E_T_ <> '*' " +CRLF
cQuery += "AND SC6.C6_CLI <> '000001' " +CRLF
cQuery += "AND SC5.C5_NUM = '"+ cNumPV +"' "+ CRLF

cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))
cQuery := ChangeQuery(cQuery)
                                     
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSC6, .T., .T.)

DbSelectArea(cAliasSC6)

(cAliasSC6)->(dbGoTop())
While !(cAliasSC6)->(Eof())
	
	If	(cAliasSC6)->B1_01FORAL <> 'F'
		
		If (cAliasSC6)->B1_XPERSO == '1'
			_cPerso     := '1'
		Else
			_cPerso     := '2'
		EndIf
		
		If Empty(AllTrim((cAliasSC6)->B1_XCODORI))
			_cPrdEsp    := ''
		Else
			_cPrdEsp    := (cAliasSC6)->B1_XCODORI
		EndIf
		
		lMsErroAuto := .F.
		aCab     := {}
		aItens   := {}
		_aItemC1 := {}
		
		cFilAnt:= '0101' //--> Por definicao de processo as solicitacoes serao sempre da filial 0101
		cNumSC := NextNumero ("SC1",1, "C1_NUM", .T.)
		
		aAdd(aCab ,{"C1_NUM"    ,cNumSC		,Nil})
		aAdd(aCab ,{"C1_SOLICIT",UsrRetName(RetCodUsr()) ,Nil})
		aAdd(aCab ,{"C1_EMISSAO",dDataBase	,Nil})
		aAdd(aCab ,{"C1_TPOP"   ,"F" 	   	,Nil})
		aAdd(aCab ,{"C1_UNIDREQ",""        	,Nil})
		aAdd(aCab ,{"C1_CODCOMP",""       	,Nil})
		aAdd(aCab ,{"C1_FILENT",cFilAtu    	,Nil})
		
		AADD(_aItemC1,{"C1_NUM"	    ,cNumSC	             		,Nil })
		AADD(_aItemC1,{"C1_ITEM"	,Padl((cAliasSC6)->C6_ITEM ,TAMSX3("C1_ITEM")[1],'0') ,Nil })
		AADD(_aItemC1,{"C1_PRODUTO"	,(cAliasSC6)->C6_PRODUTO    ,Nil })
		AADD(_aItemC1,{"C1_UM"		,(cAliasSC6)->C6_UM		    ,Nil })
		AADD(_aItemC1,{"C1_DESCRI"	,(cAliasSC6)->B1_DESC		,Nil })
		AADD(_aItemC1,{"C1_QUANT"	,(cAliasSC6)->C6_QTDVEN		,Nil })
		AADD(_aItemC1,{"C1_DATPRF"	,(cAliasSC6)->C6_ENTREG    	,Nil})
		AADD(_aItemC1,{"C1_FORNECE"	,(cAliasSC6)->B1_PROC    	,Nil})
		AADD(_aItemC1,{"C1_LOJA"	,(cAliasSC6)->B1_LOJPROC 	,Nil})
		AADD(_aItemC1,{"C1_XDESCFI"	,(cAliasSC6)->C5_XDESCFI 	,Nil})
		AADD(_aItemC1,{"C1_XPERSO"	,_cPerso                    ,Nil})
		If !Empty(AllTrim(_cPrdEsp))
			AADD(_aItemC1,{"C1_XPRDORI"	,_cPrdEsp                   ,Nil})
		EndIf
		AADD(_aItemC1,{"C1_GRUPCOM"	,"" 						,Nil})
		AADD(_aItemC1,{"C1_PEDRES"	, cNumPV                    ,Nil})
		
		aAdd( aItens, aClone(_aItemC1))
		
		MSExecAuto({|x,y,z| MATA110(x,y,z)},aCab,aItens,3)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVincular a solicita็ao criada ao item do pedido para posteriormente  ณ
		//ณutilizar na rotina de Entrada de Documentos para liberar o pedido    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If !lMsErroAuto
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			If SC6->(DbSeek(xFilial("SC6")+(cAliasSC6)->C6_NUM+(cAliasSC6)->C6_ITEM))
				RecLock("SC6",.F.)
				C6_XNUMSC  = cNumSC
				C6_XITEMSC  = Padl((cAliasSC6)->C6_ITEM ,TAMSX3("C6_ITEM")[1],'0')
				SC6->(MsUnlock())
			Endif
			
			//Soma(cNumSC)
			nCnt++
			AutoGrLog("Pedido: " + SC6->C6_NUM  + " Produto: "+ SC6->C6_PRODUTO + "-->Sc nro "+cNumSC+" Gerada com sucesso ")
			ConfirmSX8()
			
		Else
			
			AutoGrLog("Pedido: " + SC6->C6_NUM  + " Produto: "+ SC6->C6_PRODUTO + " ** Erro ao tentar gerar a SC ")
			nCntErro++
			RollBackSx8()
			
		EndIf
		
	EndIf
	
	(cAliasSC6)->(DbSkip())
	
EndDo

AutoGrLog("--------------------------Pocesso finalizado---------------------------")
AutoGrLog("-----------------------------------------------------------------------")
AutoGrLog(" "+AllTrim(Str(nCnt))+" SCs geradas")
AutoGrLog(" "+AllTrim(Str(nCntErro))+" SCs nใo geradas ")
AutoGrLog("-----------------------------------------------------------------------")

If IsBlind()
	MostraErro( "\LOG", "log_process_KMCOMA05" + DtoS( dDatabase ) +"_"+ StrTran( Time(),":","" ) + ".log" )
Elseif Upper(Alltrim(FunName())) <> "SYVM107"
	MostraErro()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Retorna para filial logada. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFilAnt := cFilAtu

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSFATR10  บAutor  ณDeosdete Deo        บ Data ณ  03/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta a lista para lista sql                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaLista(cLista)

Local aListaSql := {}
Local cListaSql := ""
Local nI        := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณA lista deve estar separa por virgulaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ',' $ cLista
	aListaSql := StrToKarr(cLista,",")
ElseIf '/' $ cLista
	aListaSql := StrToKarr(cLista,"/")
Else
	cListaSql := "('" + cLista + "'"
EndIf

For nI := 1 To Len(aListaSql)
	If Empty(cListaSql)
		cListaSql += "('"+AllTrim(aListaSql[nI])+"'"
	Else
		cListaSql += ",'"+AllTrim(aListaSql[nI])+"'"
	EndIF
Next nI

cListaSql += ")"


Return cListaSql


/*---------------------------------------------------------------------*
| Func:  Scheddef                                                     |
| Autor: Deosdete                                                     |
| Data:  26/12/2017                                                   |
| Desc:  Funcao de preparacao para scheduler            |
*---------------------------------------------------------------------*/

Static Function Scheddef()

Local aOrd   := {}
Local aParam := {}

aParam := {;
"P",;
"PARAMDEF",;
"",;
aOrd;
}

Return aParam


