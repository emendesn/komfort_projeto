#include "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CRLF CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKVPEDI  บ Autor ณ AP6 IDE            บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ P.E. antes  da substituicao da gravacao do SC5 e SC6.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CALL CENTER - TELEVENDAS                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณCaio Garcia    ณ28/03/18ณGerar or็amento                               ณฑฑ
ฑฑณ#CMG20180328   ณ        ณ                                              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TMKVPEDI(cARQLOG)

	Local aArea 	:= GetArea()
	Local cAtende   := SUA->UA_NUM
	Local cForma	:= SuperGetMv("KH_FPAGTO",.F.,"TR|TE|DO|DC")
	//Local cMsg		:= "Pedido Bloqueado. Esta forma de pagamento somente o cr้dito/financeiro poderแ fazer a libera็ใo."
	Local cMsg     	:= ""
	Local cUserId	:= __cUserID
	Local cGrpLib	:= GetMv("MV_KOGRPLB") //Usuario que poderใo liberar de orcamento para faturamento no Call Center
	Local cQuery	:= ""
	Local _cAliasCr := GetNextAlias()
	Local _lBlq		:= .F.
	Local _lUsrCred := .F. //#CMG20180927.n
	Local _lCR		:= .F. //#RVC20181207.n

//	Private lSai := .F.        //#CMG20180927.n	//#RVC20181003.o
//	Public _cPerlib := Space(2)//#CMG20180927.n	//#RVC20181003.o
	
	SL4->(DbSetOrder(1))
	If SL4->(DbSeek(xFilial("SL4") + cAtende + "SIGATMK" ))
		While SL4->(!Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM+Alltrim(SL4->L4_ORIGEM)==xFilial("SL4") + cAtende + "SIGATMK"	
			If LEFT(SL4->L4_FORMA,2) $ cForma
				_lBlq := .T.
				Exit
			//#RVC20181207.bn
			ElseIf LEFT(SL4->L4_FORMA,2) $ "CR" 
				_lCR := .T.
			//#RVC20181207.en
			EndIf
			SL4->(DbSkip())
		EndDo
	EndIf

	//#RVC20181207.bn
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tratamento p/ bloqueio do PV p/ RA proveniente de BOL/CH/OUTROS 	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !_lBlq .AND. _lCR
		
		cQuery := " SELECT E1_PREFIXO, E1_NUM FROM " + RetSqlName("SE1") + " SE1 (NOLOCK) "	+ CRLF
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "				+ CRLF
		cQuery += " AND E1_CLIENTE = '" + SUA->UA_CLIENTE + "' "				+ CRLF
		cQuery += " AND E1_LOJA = '" + SUA->UA_LOJA + "' " 						+ CRLF
		cQuery += " AND E1_STATUS = 'A' "										+ CRLF
		cQuery += " AND E1_TIPO IN ('RA') "										+ CRLF	 
		cQuery += " AND E1_SALDO > 0 "											+ CRLF
		cQuery += " AND D_E_L_E_T_ <> '*'  "									+ CRLF	
	
		cQuery := ChangeQuery(cQuery)

		If Select(_cAliasCr) > 0
			Dbselectarea(_cAliasCr)
			(_cAliasCr)->(dbCloseArea())
		EndIf
		
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),(_cAliasCr),.F.,.T.)
		
		dbSelectArea(_cAliasCr)
		(_cAliasCr)->(dbGoTop())
		
		dbSelectArea("SE1")
		SE1->(dbSetOrder(1))
		SE1->(dbGoTop())
		
		While (_cAliasCr)->(!EOF())
			
			If SE1->(dbSeek(xFilial("SE1") + (_cAliasCr)->E1_PREFIXO + (_cAliasCr)->E1_NUM))
			
				If Alltrim(SE1->E1_TIPO) $ cForma
			
					_lBlq := .T.
			
				EndIf
			
			EndIf
			
			RecLock("SE1",.F.)
				SE1->E1_NUMSUA := cAtende
			MsUnLock()
			
			(_cAliasCr)->(dbSkip())		
		EndDo
		
		RecLock("SUA",.F.)
		
			SUA->UA_FORMPG := "RA"
		
		MsUnLock()
	
	EndIf
	//#RVC20181207.en
	
	//#CMG20180927.bn     
	If Alltrim(cUserId) $ cGrpLib

		_lUsrCred := .T.
		
	EndIf     

	If _lBlq //Se tiver bloqueio

		If SUA->UA_OPER=='1' .And. !_lUsrCred

			cStatus := ""

			cMsg     	:= MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
			cMsg        += " | Pedido Bloqueado. Esta forma de pagamento somente o cr้dito/financeiro poderแ fazer a libera็ใo."

			if empty(alltrim(SUA->UA_XSTATUS))
				cStatus := "1" //EM ABERTO
			endif

			if alltrim(SUA->UA_XSTATUS) == "4"
				cStatus := "5" //REANALISE
			endIf
			
			RecLock("SUA",.F.)
				SUA->UA_OPER	:= "2"	
				SUA->UA_PEDPEND := "2"
				SUA->UA_XSTATUS := iif(empty(alltrim(cStatus)),SUA->UA_XSTATUS,cStatus) //STATUS DO ATENDIMENTO
				SUA->UA_XDTENV := dDataBase //DATA DO ENVIO PARA O CREDITO
				SUA->UA_XHRENV := time() // HORA DE ENVIO PARA O CREDITO
				MSMM(,TamSx3("UA_CODOBS")[1],,cMsg,1,,,"SUA","UA_CODOBS")
			SUA->(Msunlock())

			if !_lUsrCred
				LjWriteLog( cARQLOG, "0.01 - PEDIDO BLOQUEADO, ESTA FORMA DE PAGAMENTO SOMENTE O DEPARTAMENTO DE ANALISE DE CRษDITO PODERม FAZER A LIBERAวรO" )	

				MsgStop("Pedido Bloqueado. Esta forma de pagamento somente o cr้dito/financeiro poderแ fazer a libera็ใo.","Aten็ใo")

				U_KMORCAMEN(SUA->UA_NUM,.T.,xFilial("SUA")) //#CMG20180328.n
			endif
			//Executa a liberacao de orcamento para faturamento no Call Center
		ElseIf SUA->UA_PEDPEND=="2" .And. SUA->UA_OPER=='1' .And. _lUsrCred

			cMsg     	:= MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
			cMsg        := StrTran( cMsg, " | Pedido Bloqueado. Esta forma de pagamento somente o cr้dito/financeiro poderแ fazer a libera็ใo.", " " )

			cMsgCred := MSMM(SUA->UA_XOBSCRD,TamSx3("UA_OBS")[1],,,3) //OBS CREDITO

			_lBlq := .F.	

			//#AFD20180412.bn
			//Informa que o pedido de venda serแ gerado com Pendencia de Cr้dito
			nValPerLib := 0
			nValPerLib := fPerLib(@nValPerLib)

			RecLock("SUA",.F.)
				SUA->UA_OPER	:= "1"	
				SUA->UA_PEDPEND := "4"       
				SUA->UA_XPERLIB := nValPerLib
				SUA->UA_XSTATUS := "3" //APROVADO
				SUA->UA_XDTAPRO := dDataBase //DATA DA APROVAวรO
				SUA->UA_XHRAPRO := time() //HORA DA APROVAวรO
				MSMM(,TamSx3("UA_XOBSCRD")[1],,cMsgCred,1,,,"SUA","UA_XOBSCRD")//OBS DO CREDITO
				MSMM(,TamSx3("UA_CODOBS")[1],,cMsg,1,,,"SUA","UA_CODOBS")
			SUA->(Msunlock())

			LjWriteLog( cARQLOG, "0.01 - PEDIDO LIBERADO PELO DEPARTAMENTO ANALISE DE CRษDITO." )	
			MsgInfo("Pedido Liberado pelo departamento de analise de cr้dito!","Aten็ใo")
			//#AFD20180412.en

		EndIf

	EndIf

	MsUnlockAll()//#CMG20180625.n                                                 
	SB2->(DbCloseArea())//#CMG20180625.n 
	RestArea(aArea)

Return(_lBlq) 

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPerLib   บ Autor ณ AP6 IDE            บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function fPerLib(nValPerLib)
	
	Local lSai 		:= .F.      //#RVC20181003.n
	Local _cPerlib	:= Space(2) //#RVC20181003.n
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Criacao da Interface                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DEFINE MSDIALOG oDlg TITLE "PENDENCIA DO CRษDITO" FROM 000, 000  TO 060, 270 COLORS 0, 16777215 PIXEL

	@ 002, 001 SAY oSay PROMPT "Digite o percentual para o bloqueio do pedido de venda" SIZE 133, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 015, 051 MSGET oGet VAR _cPerlib SIZE 042, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 098 BUTTON oButton PROMPT "Confirma" SIZE 028, 012 OF oDlg ACTION { || Vai(_cPerlib,@nValPerLib) } PIXEL

	If !lSai 
		ACTIVATE MSDIALOG oDlg CENTERED VALID  {|| Cancela(lSai)}
	Else
		Close(oDlg)
	EndIf

Return nValPerLib

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCANCELA   บ Autor ณ AP6 IDE            บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function Cancela(lSai)

	If !lSai 
		Alert("Por favor, digite a % para o bloqueio do pedido de venda." )
	EndIf	

Return( lSai )

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVAI       บ Autor ณ AP6 IDE            บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function Vai(_cPerlib,nValPerLib)

	If AllTrim(_cPerlib) == ""
		Alert("Por favor, digite a % para o bloqueio do pedido de venda." )
		lSai:= .F.
	Else 		
		lSai := MsgYesNo("O Percentual digitado foi "+AllTrim(_cPerlib)+". Confirma?")
		If lSai 
			nValPerLib := Val(_cPerlib)
			Close(oDlg)
		EndIf
	EndIf

Return
