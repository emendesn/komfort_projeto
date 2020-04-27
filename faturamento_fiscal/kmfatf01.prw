#include "protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE CRLF CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFATF01  บAutor  ณCaio Garcia         บ Data ณ  18/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WF de aprovacao de desconto de pedidos                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑณ Programador            ณ Data   ณ Chamado ณ Motivo da Alteracao       ณฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออดฑฑ
ฑฑณ                        ณ        ณ         ณ                           ณฑฑ
ฑฑณ                        ณ        ณ         ณ                           ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function KMFATF01( nOpcao , oProcess )

	// Inicialmente, os parโmetros nOpcao e oProcess estarใo com valores iguais a NIL.
	// se nOpcao for NIL, terแ o seu valor inicial igual a 0 (zero).
	Private _lAmbOfic	:= IIF(Alltrim(Upper(GetEnvServer())) $ Alltrim(Upper(GetMv("KH_AMBOFIC"))),.T.,.F.)

	default nOpcao 	:= 0

	If oProcess == NIL
		oProcess := TWFProcess():New( "FAT", "Aprova็ใo de Desconto" )
	EndIf

	Do Case
		Case nOpcao == 1
		SPCRetorno( oProcess )
		Case nOpcao == 2
		SPCTimeOut( oProcess )
	EndCase

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPCRetornoบAutor  ณ Caio Garcia        บ Data ณ  18/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno do Webservice                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SPCRetorno( oProcess )

	Local cBody 		:= ''
	Local cTo   		:= ""
	Local cNomeUser 	:= ""
	Local lOk			:= .F.

	Default oProcess 	:= Nil

	Conout("-------------------------------------------------------------------------------")
	Conout("["+DToC(Date())+" "+Time()+"] INICIADO O RECEBIMENTO DO WORKFLOW - KMFATF01 ")

	cOpc     	:= oProcess:oHtml:RetByName("Aprovacao")
	cObs     	:= oProcess:oHtml:RetByName('lbmotivo')
	cChave  	:= oProcess:aParams[1]
	cUsuario	:= oProcess:aParams[2]
	cWFID   	:= oProcess:fProcessId

	//Procura dados do operador que originou o chamado.
	PswOrder(1)
	If PswSeek(cUsuario,.T.)
		aInfo   	:= PswRet(1)
		cTo 		:= Alltrim(aInfo[1,14])
		cNomeUser 	:= aInfo[1,2]
	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(cChave))

		_cPedido := SC5->C5_NUM

		If !Empty(AllTrim(SC5->C5_VEND1))

			DbSelectArea("SA3")
			SA3->(DbSetOrder(1))
			If SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))

				If !Empty(AllTrim(SA3->A3_CODUSR))
					cTo := IIF(Empty(AllTrim(cTo)),"",cTo+";")+AllTrim(UsrRetMail(SA3->A3_CODUSR))
				EndIf

				//Supervisor
				If !Empty(SA3->A3_GRPREP)

					DbSelectArea("ACA")
					ACA->(DbSetOrder(1))
					If ACA->(DbSeek(xFilial("ACA")+SA3->A3_GRPREP))
						If !Empty(AllTrim(UsrRetMail(ACA->ACA_USRESP)))
							cTo := IIF(Empty(AllTrim(cTo)),"",cTo+";")+AllTrim(UsrRetMail(ACA->ACA_USRESP))
						EndIf

						If !Empty(AllTrim(ACA->ACA_GRPSUP))

							If ACA->(DbSeek(xFilial("ACA")+ACA->ACA_GRPSUP))

								If !Empty(AllTrim(UsrRetMail(ACA->ACA_USRESP)))
									cTo := IIF(Empty(AllTrim(cTo)),"",cTo+";")+AllTrim(UsrRetMail(ACA->ACA_USRESP))
								EndIf

							EndIf

						EndIf

					EndIf 

				EndIf    

			EndIf

		EndIf

	EndIf

	IF cOpc=="S"

		lOk := .T.
		Conout("["+DToC(Date())+" "+Time()+"] FAT - DESCONTO APROVADO	:"+_cPedido)
		Conout("["+DToC(Date())+" "+Time()+"] CHAVE DE PESQUISA		:"+cChave)

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(cChave))

			RecLock("SC5",.F.)
			Replace	SC5->C5_XLIBER  With "L"
			Replace	SC5->C5_XLIBDH  With DtoC(Date())+" "+Time()
			Replace	SC5->C5_XLIBUSR With cUsuario
			Replace	SC5->C5_XLIBOBS With cObs
			SC5->(MsUnLock())

		EndIf

		DbselectArea("SC6")
		SC6->(DBSetOrder(1))
		If SC6->(DBSeek(cChave))
			While SC6->(!Eof()) .and. AllTrim(SC6->C6_FILIAL+SC6->C6_NUM) == Alltrim(cChave)

				If Alltrim(SC6->C6_XWFID) == Alltrim(cWFID)
					Conout("["+DToC(Date())+" "+Time()+"] ATUALIZANDO PEDIDO: "+cChave+SC6->C6_FILIAL)
					Reclock("SC6",.F.)
					Replace SC6->C6_XWFSTAT With "2"			// Status 2 - Aprovado
					Replace SC6->C6_XWFDTRE With dDatabase
					Replace SC6->C6_XWFOBS  With cObs
					SC6->(MSUnlock())
					lOk := .T.
				EndiF

				SC6->(DbSkip())

			EndDo

			//Envia E-mail
			oProcess:=TWFProcess():New("000001","FAT - Desconto Aprovado")
			oProcess:cSubject := "FAT - DESCONTO APROVADO: "+_cPedido
			oProcess:NewTask("FAT - Desconto Aprovado","\workflow\descreprov.htm")
			oProcess:cTo:=cTo
			oProcess:cBody:=cBody
			oHTML:=oProcess:oHTML                               
			If !_lAmbOfic
				oHtml:ValByName("MSG_TESTE","ATENวรO! Processo executado em ambiente de testes. Nใo tem valor oficial.")
			EndIf
			ohtml:ValByName("STATUS"	,"APROVADO")
			oHtml:ValByName("CPEDIDO"	,_cPedido )
			oHtml:ValByName("CMOTIVO"	,cObs )
			oProcess:Start()

		Endif
	Else
		lOk := .T.
		Conout("["+DToC(Date())+" "+Time()+"] FAT - DESCONTO REPROVADO	: "+_cPedido)
		Conout("["+DToC(Date())+" "+Time()+"] CHAVE DE PESQUISA		: "+cChave)

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(cChave))

			RecLock("SC5",.F.)
			Replace	SC5->C5_XLIBER  With "B"
			Replace	SC5->C5_XLIBDH  With DtoC(Date())+" "+Time()
			Replace	SC5->C5_XLIBUSR With cUsuario
			Replace	SC5->C5_XLIBOBS With cObs
			SC5->(MsUnLock())

		EndIf

		DbselectArea("SC6")
		SC6->(DBSetOrder(1))
		If SC6->(DBSeek(cChave))
			While SC6->(!Eof()) .and. AllTrim(SC6->C6_FILIAL+SC6->C6_NUM) == Alltrim(cChave)

				If Alltrim(SC6->C6_XWFID) == Alltrim(cWFID)
					Conout("["+DToC(Date())+" "+Time()+"] ATUALIZANDO PEDIDO: "+cChave+SC6->C6_FILIAL)
					Reclock("SC6",.F.)
					Replace SC6->C6_XWFSTAT With "3"			// Status 3 - Reprovado
					Replace SC6->C6_XWFDTRE With dDatabase
					Replace SC6->C6_XWFOBS  With cObs
					SC6->(MSUnlock())
					lOk := .T.
				EndIf

				SC6->(DbSkip())

			EndDo

			//Envia E-mail
			oProcess:=TWFProcess():New("000001","FAT - Desconto Reprovado")
			oProcess:cSubject := "FAT - DESCONTO REPROVADO: "+_cPedido
			oProcess:NewTask("FAT - Desconto Reprovado","\workflow\descreprov.htm")
			oProcess:cTo:=cTo
			oProcess:cBody:=cBody
			oHTML:=oProcess:oHTML
			ohtml:ValByName("STATUS"	,"REPROVADO")
			oHtml:ValByName("CPEDIDO"	,_cPedido )
			oHtml:ValByName("CMOTIVO"	,cObs )
			oProcess:Start()
		Endif
	EndIf

	If lOk
		Conout("["+DToC(Date())+" "+Time()+"] FINALIZADO O PROCESSO")
		oProcess:Finish() //Finaliza processo
	EndIF

	Conout("["+DToC(Date())+" "+Time()+"] FINALIZADO O RECEBIMENTO DO WORKFLOW - KMFATF01 ")
	Conout("-------------------------------------------------------------------------------")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMFATF02 บAutor  ณ Caio Garcia        บ Data ณ  18/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio do Workflow.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function KMFATF02(lReenvio,_cPedido,_lLimite) //SPCIniciar(nFolder,lReenvio)

	Local aArea		 := GetArea()
	Local cPastaLink := "aprovades"
	Local nDias		 := GetMv("MV_WFDIA"	,,1)
	Local nHoras	 := GetMv("MV_WFHORA"	,,0)
	Local nMinutos	 := GetMv("MV_WFMIN"	,,0)
	Local cPathHTML	 := GetMV("MV_PATHHTM",,"\workflow\")
	Local cServWKF   := GetMV("MV_SERVWKF",,"http://177.190.192.187:83/wf/") + "emp" + SM0->M0_CODIGO
	Local nMAXdesc := GetMV("KH_DESMAXI")
	Local cCodOpera	 := ""
	Local cCodAprov	 := ""
	Local cObs		 := ""
	Local cGarantia	 := ""
	Local cString	 := ""
	Local cQuery 	 :=	""
	Local cDescOcorr := ""
	Local cTo		 := ""
	Local nX	     := 0
	Local nY         := 0
	Local nValor	 := 0
	Local nQuant	 := 0
	Local aReturn 	 := {}
	Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
	Local _cCodUsr, cCodProduto, cTexto, cAssunto, cEndFor
	Local oProcess
	Local oHtml
	Local _cStatus := "" //#CMG20170111.n
	Local _nPrcTot := 0
	Local _nQtdTot := 0
	Local _nDesTot := 0
	Local aAdm		:= {}
	Local cFormaPG	:= ""
	Local nQtdChk	:= 0
	Local nQtdBol	:= 0
	Local nCheck	:= 0
	Local nTotBol	:= 0
	Private _lAmbOfic	:= IIF(Alltrim(Upper(GetEnvServer())) $ Alltrim(Upper(GetMv("KH_AMBOFIC"))),.T.,.F.)

	Default lReenvio := .F.

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	SC5->(DbSeek(xFilial("SC5")+_cPedido))

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	SC6->(DbSeek(xFilial("SC6")+_cPedido))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbGoTop())
	SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	SUA->(DbSeek(xFilial("SUA")+SC5->C5_NUMTMK))

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCodigo do operador que ira aprovar o chamado							 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCodAprov 	:= GetMv("KH_APWFDES",,"000008")
	cChave 		:= xFilial("SC5")+_cPedido

	If Empty(cCodAprov)
		cTitle  := "Administrador do Workflow : NOTIFICACAO"
		aMsg 	:= {}

		AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(aMsg, "Ocorreu um ERRO no envio da mensagem :")
		AADD(aMsg, "FAT - Pedido: " + _cPedido + " Filial : " + cFilAnt )
		AADD(aMsg, "Nenhum usuแrio foi informado no parโmetro GL_APRMAIL para aprova็ใo do desconto. Contate o Administrador do Sistema." )
		fMailAdm(cTitle, aMsg)

		AAdd(aReturn,"")
		Return
	Endif

	//Procura dados do operador que fara aprova็ใo dos chamados.
	PswOrder(1)
	IF PswSeek(cCodAprov,.T.)
		aInfo := PswRet(1)
		cTo   := Alltrim(aInfo[1,14])
	ENDIF

	If Empty(cTo)
		cTitle  := "Administrador do Workflow : NOTIFICACAO"
		aMsg 	:= {}

		AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
		AADD(aMsg, "Ocorreu um ERRO no envio da mensagem :")
		AADD(aMsg, "FAT - Pedido: " + _cPedido + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(cCodAprov) )
		AADD(aMsg, "Nใo existe e-mail cadastrado do Operador que farแ a aprova็ใo dos chamados. Contate o Administrador do Sistema." )
		fMailAdm(cTitle, aMsg)

		AAdd(aReturn,"")
		Return
	Endif

	// C๓digo extraํdo do cadastro de processos.
	cCodProcesso := cPastaLink

	// Arquivo html template utilizado para montagem da aprova็ใo
	cHtmlModelo := "\workflow\aprovPV.htm"

	// Assunto da mensagem
	If _lLimite
		cAssunto := IF(lReenvio,"(REENVIO) FAT - aprovacao de desconto: "+_cPedido,"FAT - aprovacao de desconto(acima do limite ";
		+AllTrim(Str(SC6->C6_XDESMAX))+"%): "+_cPedido)
	Else
		cAssunto := IF(lReenvio,"(REENVIO) FAT - aprovacao de desconto: "+_cPedido,"FAT - aprovacao de desconto(condi็ใo pagamento ";
		+AllTrim(Str(SC6->C6_XDESMAX))+"%): "+_cPedido)
	EndIf


	// Inicialize a classe TWFProcess e assinale a variแvel objeto oProcess:
	oProcess := TWFProcess():New(cCodProcesso, cAssunto)

	// Crie uma tarefa.
	oProcess:NewTask(cAssunto, cHtmlModelo)

	//Usuario do totvs
	_cCodUsr  	:= RetCodUsr()
	_cNomeUsr := UsrRetName(_cCodUsr)
	oProcess:UserSiga	:= _cCodUsr 
	If _lLimite
		oProcess:fDesc 		:= "FAT - Aprovacao de desconto(acima do limite):"+ _cPedido
	Else
		oProcess:fDesc 		:= "FAT - Aprovacao de desconto(condi็ใo pagamento):"+ _cPedido
	EndIf	

	conout("["+DToC(Date())+" "+Time()+"](INICIO|APROVADES)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

	oHtml :=oProcess:oHtml

	aAreaSM0 := SM0->(GetArea())
	SM0->(DbSetOrder(1))
	If SM0->(DbSeek(cEmpAnt+cFilAnt))
		oHtml:ValByName( "cLOJA", SM0->M0_FILIAL )
	EndIf
	SM0->(RestArea(aAreaSM0))

	If !_lAmbOfic
		oHtml:ValByName("MSG_TESTE","ATENวรO! Processo executado em ambiente de testes. Nใo tem valor oficial.")
	EndIf

	If _lLimite
		oHtml:ValByName( "cCABEC",  "*** Pedido "+_cPEDIDO+" bloqueado por desconto maior que o limite de "+cValToChar(nMAXdesc)+"% ***" )
	Else
		oHtml:ValByName( "cCABEC",  "*** Pedido "+_cPEDIDO+" bloqueado por desconto imcompativel com condi็ใo de pagamento ***" )
	EndIf               

	//#CMG20180108.bn

	aAdm 	:= {}
	nQtdChk	:= RetQtdC(SUA->UA_FILIAL,SUA->UA_NUM,"CH")
	nTotChk	:= RetTotC(SUA->UA_FILIAL,SUA->UA_NUM,"CH")
	nQtdBol	:= RetQtdC(SUA->UA_FILIAL,SUA->UA_NUM,"BOL")
	nTotBol	:= RetTotC(SUA->UA_FILIAL,SUA->UA_NUM,"BOL")	
	nCheck	:= 0

	//Carrega as forma de pagamento da venda.
	If Select("TRB1XX") > 0
		TRB1XX->(DbCloseArea())
	EndIf

	BeginSql Alias "TRB1XX"
		SELECT *
		FROM %Table:SL4% SL4 (NOLOCK)
		WHERE 	L4_FILIAL = %Exp:SUA->UA_FILIAL% AND
		L4_NUM 	  = %Exp:SUA->UA_NUM% AND
		L4_ORIGEM = 'SIGATMK' AND
		SL4.%NotDel%
		ORDER BY L4_FILIAL,L4_NUM,L4_FORMA DESC
	EndSql

	While TRB1XX->(!Eof())

		If Alltrim(TRB1XX->L4_FORMA)=="CC" .Or. Alltrim(TRB1XX->L4_FORMA)=="CD"

			nPos := aScan( aAdm , { |x| x[1] + x[2] + x[6] ==  Alltrim(TRB1XX->L4_FORMA) + Alltrim(TRB1XX->L4_ADMINIS) + Alltrim(TRB1XX->L4_AUTORIZ) } )	//#RVC20180602.n

			If nPos == 0
				Aadd(aAdm,{ Alltrim(TRB1XX->L4_FORMA) , Alltrim(TRB1XX->L4_ADMINIS) , 1 , TRB1XX->L4_VALOR , TRB1XX->L4_VALOR , Alltrim(TRB1XX->L4_AUTORIZ)  })	//#RVC20180602.n
			Else
				aAdm[nPos][3] += 1
				aAdm[nPos][5] += TRB1XX->L4_VALOR
			EndIf

			//#RVC20180602.bn
		ElseIf ALLTRIM(TRB1XX->L4_FORMA) == "R$"

			cFormaPG += "| R$ no Valor "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" |"+ CRLF

			//#RVC20180602.en

		ElseIf !(Alltrim(TRB1XX->L4_FORMA)=="BOL" .Or. Alltrim(TRB1XX->L4_FORMA)=="CH")

			cFormaPG += "| "+ALLTRIM(TRB1XX->L4_FORMA) +" no Valor "+Alltrim(Transform(TRB1XX->L4_VALOR,"@E 9,999,999,999,999.99"))+" |" +CRLF

		EndIf

		TRB1XX->(DbSkip())

	EndDo

	For nX := 1 To Len(aAdm)
		cFormaPG += "| "+aAdm[nX][01] +" "+ StrZero(aAdm[nX][03],3)+ " parcelas " +" - Total: "+ Alltrim(Transform(aAdm[nX][05],"@E 999,999,999.99"))+" |"  + CRLF
	Next nX

	If nQtdChk > 0
		cFormaPG += "| CH "+ StrZero(nQtdChk,3)+ " parcelas " +" - Total: "+ Alltrim(Transform(nTotChk,"@E 999,999,999.99"))+" |"  + CRLF
	EndIf

	If nQtdBol > 0
		cFormaPG += "| BOL "+ StrZero(nQtdBol,3)+ " parcelas " +" - Total: "+ Alltrim(Transform(nTotBol,"@E 999,999,999.99"))+" |"  + CRLF	
	EndIf

	//#CMG20180108.en

	//oHtml:ValByName( "cFPGTO",  AllTrim(SUA->UA_FORMPG)+" - "+cValToChar(SUA->UA_PARCELA)+" parcela"+IIF(SUA->UA_PARCELA>1, "s", "" ) )
	oHtml:ValByName( "cFPGTO",  AllTrim(cFormaPG))
	oHtml:ValByName( "cOBSCOM", AllTrim( StrTran(SUA->UA_OBSFOLL , CRLF, "<br />" ) ) )

	oHtml:ValByName( "cORCA"  ,  AllTrim(SC5->C5_ORCRES)+" / "+SC5->C5_NUM )
	oHtml:ValByName( "cPedido",  SC5->C5_NUM )
	oHtml:ValByName( "cCLIENTE", AllTrim(SA1->A1_NOME) )
	oHtml:ValByName( "cCNPJ",    Transform( SA1->A1_CGC, IIF(Len(AllTrim(SA1->A1_CGC))< 14 ,"@R 999.999.999-99", "@R99.999.999/9999-99") ) )
	oHtml:ValByName( "cDTVEN",   DtoC( SC5->C5_EMISSAO ) )
	oHtml:ValByName( "cOBSPV",  MSMM(SC5->C5_XCODOBS,43) )

	oHtml:ValByName( "cVendedor",  "Vendedor: " )
	oHtml:ValByName( "cVENDE",  AllTrim(IIF(!Empty(SA3->A3_NOME),SA3->A3_NOME,SA3->A3_NREDUZ)))

	cSuper := SA3->A3_GRPREP // SA3->A3_SUPER
	cGeren := SA3->A3_GEREN
	If !Empty( cSuper )

		DbSelectArea("ACA")
		ACA->(DbSetOrder(1))
		If ACA->(DbSeek( xFilial("ACA")+cSuper))
			cSuper := ACA->ACA_USRESP
			cGeren := ACA->ACA_GRPSUP
		EndIf

		If !Empty(ALlTrim(cGeren))

			oHtml:ValByName( "cGERENTE",  "Gerente: " )	
			oHtml:ValByName( "cGEREN",  UsrFullName(cSuper) )

		EndIf	

		If Empty(cGeren)
			cGeren := cSuper // SA3->A3_SUPER
		EndIf
	EndIf

	If !Empty(cGeren)
		ACA->(DbSetOrder(1) )
		If ACA->(DbSeek(xFilial("ACA")+ cGeren))
			cGeren := ACA->ACA_USRESP
		EndIf

		oHtml:ValByName( "cSUPERVISOR",  "Supervisor: " )	
		oHtml:ValByName( "cSUPER",  UsrFullName(cGeren) )

	EndIf


	oHtml:valbyname("it.Prod"   , {})
	oHtml:valbyname("it.Desc"   , {})
	oHtml:valbyname("it.Qtde"   , {})
	oHtml:valbyname("it.PrcTab"   , {})
	oHtml:valbyname("it.ValDes"   , {})
	oHtml:valbyname("it.PrcDes"   , {})
	oHtml:valbyname("it.Descon"   , {})
	oHtml:valbyname("it.DtEnt"   , {})
	oHtml:valbyname("it.TpPrd"   , {})

	DbSelectArea("SUB")
	SUB->(DbSetOrder(1))//UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO
	SUB->(DbGoTop())

	SC6->( dbSetOrder(1) )
	SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM ), .T. ) )
	While !SC6->(EOF()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)

		RecLock("SC6",.F.)
		SC6->C6_XWFID 	:= oProcess:fProcessID
		SC6->C6_XWFDTEN	:= dDatabase
		SC6->C6_XWFAPRO := UsrRetName(cCodOpera)
		SC6->(MsUnlock())

		SUB->(DbGoTop())
		If !Empty(AllTrim(SC6->C6_XCHVSUB)) .And. SUB->(DbSeek(SC6->C6_XCHVSUB+SC6->C6_PRODUTO))

			AAdd( (oHtml:ValByName( "it.Prod" 		    )),SC6->C6_PRODUTO )
			AAdd( (oHtml:ValByName( "it.Desc" 			)),SC6->C6_DESCRI )
			AAdd( (oHtml:ValByName( "it.Qtde" 			)),cValToChar(SC6->C6_QTDVEN) )
			AAdd( (oHtml:ValByName( "it.PrcTab" 		)),transform(SUB->UB_PRCTAB,  "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.ValDes"			)),transform(SUB->UB_VALDESC, "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.PrcDes" 		)),transform(SUB->UB_VLRITEM,  "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.Descon" 		)),transform(SUB->UB_DESC, "@E 9,999.99")+'%')
			AAdd( (oHtml:ValByName( "it.DtEnt" 			)),DtoC(SC6->C6_ENTREG) )
			AAdd( (oHtml:ValByName( "it.TpPrd" 			)),iif(SC6->C6_MOSTRUA=="1", "Novo", "Mostruแrio") )

			_nPrcTot += SUB->UB_VLRITEM
			_nQtdTot += SC6->C6_QTDVEN
			_nDesTot += SUB->UB_VALDESC

		Else

			AAdd( (oHtml:ValByName( "it.Prod" 		    )),SC6->C6_PRODUTO )
			AAdd( (oHtml:ValByName( "it.Desc" 			)),SC6->C6_DESCRI )
			AAdd( (oHtml:ValByName( "it.Qtde" 			)),cValToChar(SC6->C6_QTDVEN) )
			AAdd( (oHtml:ValByName( "it.PrcTab" 		)),transform(SC6->C6_XPRTBKP,  "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.ValDes"			)),transform(SC6->C6_XVDSBKP, "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.PrcDes" 		)),transform(SC6->C6_PRUNIT,  "@E 999,999,999,999.99") )
			AAdd( (oHtml:ValByName( "it.Descon" 		)),transform(SC6->C6_XPDSBKP, "@E 9,999.99")+'%')
			AAdd( (oHtml:ValByName( "it.DtEnt" 			)),DtoC(SC6->C6_ENTREG) )
			AAdd( (oHtml:ValByName( "it.TpPrd" 			)),iif(SC6->C6_MOSTRUA=="1", "Novo", "Mostruแrio") )

			_nPrcTot += SC6->C6_PRCVEN
			_nQtdTot += SC6->C6_QTDVEN
			_nDesTot += SC6->C6_XVDSBKP

		EndIf

		SC6->(DbSkip())

	EndDo

	oHtml:ValByName( "cQTDTOT" 	,TRANSFORM( _nQtdTot,	'@E 999999.99' ) )
	oHtml:ValByName( "cDESTOT" 	,TRANSFORM( _nDesTot,	'@E 999,999,999.99' ) )
	oHtml:ValByName( "cTOTPED" 	,TRANSFORM( _nPrcTot,	'@E 999,999,999.99' ) )

	oProcess:ClientName( Substr(cUsuario,7,15) )

	oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')

	// Repasse o texto do assunto criado para a propriedade especifica do processo.
	oProcess:cSubject := cAssunto

	// Nesse local se define a pasta onde irแ ser salvo o arquivo
	oProcess:cTo := "aprovades;"

	// Informe o nome da fun็ใo de retorno a ser executada quando a mensagem de
	// respostas retornarem ao Workflow:
	oProcess:bReturn  := "U_KMFATF01( 1 )"

	// Informe o nome da fun็ใo do tipo timeout que serแ executada se houver um timeout
	// ocorrido para esse processo. Neste exemplo, serแ executada 5 minutos ap๓s o envio
	// do e-mail para o destinatแrio. Caso queira-se aumentar ou diminuir o tempo, altere
	// os valores das variแveis: nDias, nHoras e nMinutos.
	oProcess:bTimeOut := {{"U_KMFATF01( 2 )", nDias, nHoras, nMinutos}}

	AAdd(aReturn			, oProcess:fProcessId)
	AAdd(oProcess:aParams	, cChave)
	AAdd(oProcess:aParams	, _cCodUsr)

	//cMailID := oProcess:Start("\messenger\emp" + cEmpAnt + "\aprovades\")

	cMailID := oProcess:Start()

	cHtmlModelo := cPathHTML + "linkdesc.htm"

	oProcess:NewTask(cAssunto, cHtmlModelo)
	conout("["+DToC(Date())+" "+Time()+"](INICIO|OCLINK)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

	// Repasse o texto do assunto criado para a propriedade especifica do processo.
	oProcess:cSubject := cAssunto

	// Informe o endere็o eletr๔nico do destinatแrio.
	oProcess:cTo := cTo                                                                                         
	oHtml:ValByName("cPedido",_cPedido) 
	If _lLimite
		oHtml:ValByName("cOcorrencia","Pedido com o desconto maior que o limite permitido necessita de aprova็ใo")
	Else
		oHtml:ValByName("cOcorrencia","Pedido com o desconto maior que o permitido para a condi็ใo de pagamento escolhida.")
	EndIf	


	// http://localhost/ --> representa: "c:\mp10\apdata\workflow"
	// abaixo da pasta ..\workflow, havera uma subpasta chamada "messenger" criado automaticamente quando informa algum nome de pasta
	// na propriedade op:cto := "nome_da_pasta"
	// neste exemplo, voce tera que informar no nome "\workflow" na aba chamada "messenger" no campo "caminho:" no cadastro de parametro do workflow.
	If !_lAmbOfic
		oHtml:ValByName("MSG_TESTE","ATENวรO! Processo executado em ambiente de testes. Nใo tem valor oficial.")
	EndIf
	oProcess:oHtml:ValByName("proc_link", cServWKF + "/" + cPastaLink + "/" + cMailID + ".htm")

	// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
	// a ser executado o m้todo Start() para se gerado todo processo e enviar a mensagem
	// ao destinatแrio.
	oProcess:Start()

	MsgInfo("Workflow processado com sucesso.","Atenc็ใo")
	conout("Workflow processado com sucesso.")

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPCTimeOut    บAutor  ณ Caio Garcia    บ Data ณ  18/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTime out do Workflow.						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SPCTimeOut( oProcess )

	Local cTexto
	Local cChave

	Conout("-------------------------------------------------------------------------------")
	Conout("["+DToC(Date())+" "+Time()+"] Executando TIMEOUT/REENVIO... ")

	// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "1.0 Executando TIMEOUT..."
	conout(cTexto)

	//Finalize a tarefa anterior para nใo ficar pendente.
	cTexto := "2.0 Finalizando a tarefa anterior....."
	conout(cTexto)
	oProcess:Finish()

	//Obtenho o chamado a partir do html
	cTexto := "3.0 (FAT) - Pedido: "+oProcess:oHtml:RetByName('cPedido')
	conout(cTexto)

	_cPedido := oProcess:oHtml:RetByName('cPedido')

	//Obtenho a chave de pesquisa
	cChave := oProcess:aParams[1]
	cTexto := "4.0 Chave de pesquisa: "+cChave
	conout(cTexto)

	Dbselectarea("SC5")
	SC5->(DBSetOrder(1))
	If SC5->(DBSeek(cChave))

		cTexto := "5.0 Criando novo processo..."
		conout(cTexto)

		U_KMFATF02(.T.,_cPedido)

	EndIF

	Conout("["+DToC(Date())+" "+Time()+"] Finalizando TIMEOUT/REENVIO... ")
	Conout("-------------------------------------------------------------------------------")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMailAdm    ณ Autor ณ Caio Garcia     ณ Data ณ  18/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณUtilizado para enviar qualquer notificacao ao administrador.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMailAdm(cTitle, aMsg,cErroMail)

	Local oWf, nInd, cBody, aFiles

	Local cTo := cErroMail

	IF aMsg == Nil
		aMsg := {}
		Aadd(aMsg,"")
	EndIf

	cBody := ''
	cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
	cBody += 'size=2><STRONG>Ap7 Workflow - Servi็o Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
	For nInd := 1 TO Len(aMsg)
		cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
	Next

	WFNotifyAdmin( cTo, cTitle , cBody, aFiles )

Return


/*/{Protheus.doc} RetQtdChk
Retorna quantidade de cheques selecionados na forma de pagamento.
@author Andr้ Lanzieri
@since 27/12/2016
@version 1.0
/*/
Static Function RetQtdC(cFil,cORCAMENTO,cForma)

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local _nRec		:= 0

	_cQuery := " SELECT SL4.L4_FORMA FROM "+RetSqlName("SL4")+" SL4					 "
	_cQuery += " WHERE SL4.L4_FILIAL = '"+cFil+"' 						 "
	_cQuery += " AND SL4.L4_NUM 		= '"+Padr(cORCAMENTO,TamSx3("L4_NUM")[1])+"' "
	_cQuery += " AND SL4.L4_FORMA 	= '"+Padr(cForma,TamSx3("L4_FORMA")[1])+"' 		 "
	_cQuery += " AND SL4.D_E_L_E_T_ 	= ' '										 "

	TcQuery _cQuery NEW ALIAS (cAlias)

	Count to _nRec //quantidade registros

	(cAlias)->(DbCloseArea())

Return(_nRec)



/*/{Protheus.doc} RetQtdChk
Retorna quantidade de cheques selecionados na forma de pagamento.
@author Andr้ Lanzieri
@since 27/12/2016
@version 1.0
/*/
Static Function RetTotC(cFil,cORCAMENTO,cForma)

	Local _cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local _nTot     := 0

	_cQuery := " SELECT SUM(L4_VALOR) VALOR FROM "+RetSqlName("SL4")+" SL4					 "
	_cQuery += " WHERE SL4.L4_FILIAL = '"+cFil+"' 						 "
	_cQuery += " AND SL4.L4_NUM 		= '"+Padr(cORCAMENTO,TamSx3("L4_NUM")[1])+"' "
	_cQuery += " AND SL4.L4_FORMA 	= '"+Padr(cForma,TamSx3("L4_FORMA")[1])+"' 		 "
	_cQuery += " AND SL4.D_E_L_E_T_ 	= ' '										 "

	TcQuery _cQuery NEW ALIAS (cAlias)

	_nTot := (cAlias)->VALOR

	(cAlias)->(DbCloseArea())

Return(_nTot)