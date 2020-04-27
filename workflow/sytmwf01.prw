#include "protheus.ch"        // iadncluido pelo assistente de conversao do AP5 IDE em 20/03/00
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE CRLF CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYTMWF01  บAutor  ณMicrosiga           บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WF de aprovacao de chamados do SAC                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณCaio Garcia    ณ11/01/18ณAjuste para apresentar historico do WF        ณฑฑ
ฑฑณ#CMG20180111   ณ        ณ                                              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณ               ณ        ณ                                              ณฑฑ
ฑฑณ               ณ        ณ                                              ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER function SYTMWF01( nOpcao , oProcess )
U_SYTMWF10( nOpcao , oProcess )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYTMWF10  บAutor  ณMicrosiga           บ Data ณ  01/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para geracao do WF de aprovacao de chamados do SAC  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYTMWF10( nOpcao , oProcess , nFolder )

// Inicialmente, os parโmetros nOpcao e oProcess estarใo com valores iguais a NIL.
// se nOpcao for NIL, terแ o seu valor inicial igual a 0 (zero).
default nOpcao 	:= 0
Default nFolder := 1

If oProcess == NIL
	oProcess := TWFProcess():New( "SAC", "SAC - Chamado" )
EndIf

Do Case
	Case nOpcao == 0
		U_SYTMWF02(nFolder,.F.)
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
ฑฑบPrograma  ณSPCRetornoบAutor  ณ SYMM Consultoria   บ Data ณ  27/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno do Webservice                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MV_WFWEBEX para .F.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SPCRetorno( oProcess )

Local cBody 		:= ''
Local cTo   		:= ""
Local cNomeUser 	:= ""
Local lOk			:= .F.
Local cEmailAdm		:= GetMv("KH_RETMAIL",,"isaias.gomes@komforthouse.com.br")//email adicional para retorno do workFlow
Local cUserInc 		:= ""
Local cCodLojCli 	:= ""
Local cNameCli		:= ""

Default oProcess 	:= Nil

Conout("-------------------------------------------------------------------------------")
Conout("["+DToC(Date())+" "+Time()+"] INICIADO O RECEBIMENTO DO WORKFLOW - SYTMWF01 ")

cOpc     	:= oProcess:oHtml:RetByName("Aprovacao")
cObs     	:= oProcess:oHtml:RetByName('lbmotivo')
cNumero 	:= oProcess:oHtml:RetByName('cChamado')
cChave  	:= oProcess:aParams[1]
cUsuario	:= oProcess:aParams[2]
cWFID   	:= oProcess:fProcessId

cCodLojCli := Posicione("SUC",1,xFilial("SUC")+cNumero,"UC_CHAVE")
Conout("CHAVE ----> "+cCodLojCli)

cNameCli := Posicione('SA1',1,xFilial('SA1')+cCodLojCli,'A1_NOME')
Conout("NOME CLIENTE ----> "+cNameCli)

//Procura dados do operador que originou o chamado.
PswOrder(1)
IF PswSeek(cUsuario,.T.)
	aInfo   	:= PswRet(1)
	cTo 		:= Alltrim(aInfo[1,14])
	cNomeUser 	:= aInfo[1,2]
ENDIF

IF cOpc=="S"
	
	lOk := .T.
	Conout("["+DToC(Date())+" "+Time()+"] SAC - CHAMADO APROVADO	:"+cNumero)
	Conout("["+DToC(Date())+" "+Time()+"] CHAVE DE PESQUISA		:"+cChave)
	
	DbselectArea("SUD")
	DBSetOrder(1)
	If DBSeek(cChave)
		While !Eof() .and. SUD->UD_FILIAL+SUD->UD_CODIGO == cChave
			
			If Alltrim(SUD->UD_WFID) == Alltrim(cWFID)
				
				Conout("["+DToC(Date())+" "+Time()+"] ATUALIZANDO CHAMADO: "+SUD->UD_FILIAL+SUD->UD_CODIGO)
				
				if empty(cUserInc)
					//Usuario que incluiu a linha no chamado
					cUserInc := U_EmailUsr(alltrim(SUD->UD_XUSER))
				else
					cEmailRet := U_EmailUsr(alltrim(SUD->UD_XUSER))					
					if cUserInc <> cEmailRet
						if cto <> cEmailRet .and. cEmailAdm <> cEmailRet
							cUserInc += ";"+ cEmailRet
						endif
					endif
				endif				
				
				Reclock("SUD",.F.)
					Replace SUD->UD_ENVWKF  With "2"			// Status 2 - Aprovado
					Replace SUD->UD_STATUS With "2"
					Replace SUD->UD_WFIDRET With dDatabase
					Replace SUD->UD_OBSWKF  With cObs
				MSUnlock()
				lOk := .T.
			EndiF
			
			DbselectArea("SUD")
			dbSkip()
		End
		
		if cEmailAdm == cto
			cEmailAdm := ""
		endif

		if cUserInc == cto
			cUserInc := ""
		endif

		//Envia E-mail
		oProcess:=TWFProcess():New("000001","SAC - Chamado Aprovado")
		oProcess:cSubject := "SAC - CHAMADO APROVADO: "+cNumero
		oProcess:NewTask("SAC - Chamado Aprovado","\workflow\reprovacao.htm")
		oProcess:cTo:=cTo + ";" + cUserInc + ";" + cEmailAdm
		oProcess:cBody:=cBody
		oHTML:=oProcess:oHTML
		ohtml:ValByName("STATUS"	,"APROVADO")
		oHtml:ValByName("CCHAMADO"	,cNumero )
		oHtml:ValByName("CMOTIVO"	,cObs )
		oHtml:ValByName("CCLIENTE"	,alltrim(cNameCli))
		oProcess:Start()
		
	Endif
Else
	lOk := .T.
	Conout("["+DToC(Date())+" "+Time()+"] SAC - CHAMADO REPROVADO	: "+cNumero)
	Conout("["+DToC(Date())+" "+Time()+"] CHAVE DE PESQUISA		: "+cChave)
	
	DbselectArea("SUD")
	DBSetOrder(1)
	If DBSeek(cChave)
		While !Eof() .and. SUD->UD_FILIAL+SUD->UD_CODIGO == cChave
			
			If Alltrim(SUD->UD_WFID) == Alltrim(cWFID)
				Conout("["+DToC(Date())+" "+Time()+"] ATUALIZANDO CHAMADO: "+SUD->UD_FILIAL+SUD->UD_CODIGO)
				
				if empty(cUserInc)
					//Usuario que incluiu a linha no chamado
					cUserInc := U_EmailUsr(alltrim(SUD->UD_XUSER))
				else
					cEmailRet := U_EmailUsr(alltrim(SUD->UD_XUSER))					
					if cUserInc <> cEmailRet
						if cto <> cEmailRet .and. cEmailAdm <> cEmailRet
							cUserInc += ";"+ cEmailRet
						endif
					endif
				endif
				
				Reclock("SUD",.F.)
					Replace SUD->UD_ENVWKF  With "3"			// Status 3 - Reprovado
					Replace SUD->UD_STATUS With "1"
					Replace SUD->UD_WFIDRET With dDatabase
					Replace SUD->UD_OBSWKF  With cObs
				MSUnlock()
				lOk := .T.
			EndIF
			DbselectArea("SUD")
			dbSkip()
		End
		
		if cEmailAdm == cto
			cEmailAdm := ""
		endif

		if cUserInc == cto
			cUserInc := ""
		endif

		//Envia E-mail
		oProcess:=TWFProcess():New("000001","SAC - Chamado Reprovado")
		oProcess:cSubject := "SAC - CHAMADO REPROVADO: "+cNumero
		oProcess:NewTask("SAC - Chamado Reprovado","\workflow\reprovacao.htm")
		oProcess:cTo:=cTo + ";" + cUserInc + ";" + cEmailAdm
		oProcess:cBody:=cBody
		oHTML:=oProcess:oHTML
		ohtml:ValByName("STATUS"	,"REPROVADO")
		oHtml:ValByName("CCHAMADO"	,cNumero )
		oHtml:ValByName("CMOTIVO"	,cObs )
		oHtml:ValByName("CCLIENTE"	,alltrim(cNameCli))
		oProcess:Start()
	Endif
EndIf

If lOk
	Conout("["+DToC(Date())+" "+Time()+"] FINALIZADO O PROCESSO")
	oProcess:Finish() //Finaliza processo
EndIF

Conout("["+DToC(Date())+" "+Time()+"] FINALIZADO O RECEBIMENTO DO WORKFLOW - SYTMWF01 ")
Conout("-------------------------------------------------------------------------------")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSPCIniciarบAutor  ณ SYMM CONSULTORIA   บ Data ณ  27/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio do Workflow.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYTMWF02(nFolder,lReenvio) //SPCIniciar(nFolder,lReenvio)

Local aArea		 := GetArea()
Local cPastaLink := "aprovasac"
Local nDias		 := GetMv("MV_WFDIA"	,,1)
Local nHoras	 := GetMv("MV_WFHORA"	,,0)
Local nMinutos	 := GetMv("MV_WFMIN"	,,0)
Local cPathHTML	 := GetMV("MV_PATHHTM",,"\workflow\")
Local cServWKF   := GetMV("MV_SERVWKF",,"http://177.190.192.187:83/wf/") + "emp" + SM0->M0_CODIGO
Local cOcorrencia:= GETMV("KH_WFOCORR",,"000002/000005")
Local nPrazo	 := GETMV("KH_PRZGARA",,90)
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
Local aOcorrencia:= Separa(cOcorrencia,"/")
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto, cEndFor
Local oProcess
Local oHtml
Local _cStatus := "" //#CMG20170111.n
Local _aDadosH := {}

Default lReenvio := .F.

For nX := 1 To Len(aOcorrencia)
	cString += "'"+Alltrim(aOcorrencia[nX])+"',"
Next
cString:= Substr(cString,1,Len(cString)-1)

If Select("TRB1") > 0
	TRB1->(DbCloseArea())
EndIf

cQuery := "SELECT * FROM "+RetSqlName("SUD")+" WHERE UD_FILIAL = '"+xFilial("SUD")+"' AND UD_OCORREN IN ("+cString+") AND D_E_L_E_T_ = ' ' AND UD_CODIGO = '"+SUC->UC_CODIGO+"' AND UD_STATUS <> '2' "

DbUseArea(.T.,"TOPCONN",TcGenQry(Nil,Nil,cQuery),"TRB1",.T.,.T.)

If TRB1->( EOF() )
	Return
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDA PARA A ROTINA SO SER CHAMADA DO FOLDER DO SAC ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nFolder <> 1
	MsgAlert("Esta rotina deve ser acessada somente no SAC.","Aten็ใo")
	AAdd(aReturn,"")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCodigo do operador que ira aprovar o chamado							 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCodAprov 	:= GetMv("KH_APROSAC",,"000007")
cChamado	:= Padr(Alltrim(SUC->UC_CODIGO),6)
cChave 		:= xFilial("SUC")+cChamado

If Empty(cCodAprov)
	cTitle  := "Administrador do Workflow : NOTIFICACAO"
	aMsg 	:= {}
	
	AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
	AADD(aMsg, "Ocorreu um ERRO no envio da mensagem :")
	AADD(aMsg, "SAC - Chamado: " + cChamado + " Filial : " + cFilAnt )
	AADD(aMsg, "Nใo existe nenhuma Operador cadastrado para aprova็ใo dos chamados. Contate o Administrador do Sistema." )
	U_NotifyAdm(cTitle, aMsg)
	
	AAdd(aReturn,"")
	Return
Endif

SU7->(dbSetOrder(1))
SU7->(dbSeek(xFilial("SU7")+cCodAprov))
If SU7->U7_XAUSENT =="1"
	cCodOpera := SU7->U7_XOPESUB
Else
	cCodOpera := SU7->U7_CODUSU
Endif

//Procura dados do operador que fara aprova็ใo dos chamados.
PswOrder(1)
IF PswSeek(cCodOpera,.T.)
	aInfo := PswRet(1)
	cTo   := Alltrim(aInfo[1,14])
ENDIF

If Empty(cTo)
	cTitle  := "Administrador do Workflow : NOTIFICACAO"
	aMsg 	:= {}
	
	AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
	AADD(aMsg, "Ocorreu um ERRO no envio da mensagem :")
	AADD(aMsg, "SAC - Chamado: " + cChamado + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(cCodOpera) )
	AADD(aMsg, "Nใo existe e-mail cadastrado do Operador que farแ a aprova็ใo dos chamados. Contate o Administrador do Sistema." )
	U_NotifyAdm(cTitle, aMsg)
	
	AAdd(aReturn,"")
	Return
Endif

SUC->(dbSetOrder(1))
SUC->(dbSeek(xFilial("SUC")+cChamado))

SU5->(dbSetOrder(1))
SU5->(dbSeek(xFilial("SU5")+SUC->UC_CODCONT))

SU7->(dbSetOrder(1))
SU7->(dbSeek(xFilial("SU7")+SUC->UC_OPERADO))

cOperador := SU7->U7_NOME
cObs 	  := MSMM(SUC->UC_CODOBS,TamSx3("UC_OBS")[1])
    
//#CMG20180111.bn
cObs := StrTran( cObs, '-------------------------------------------------------------------','<p>',1,1 ) 
cObs := StrTran( cObs, '-------------------------------------------------------------------','</p><p>' )
cObs := cObs+'</p>'
//#CMG20180111.en
     
SUD->( dbSetOrder(1) )
SUD->( dbSeek(xFilial('SUD') + cChamado ))
While SUD->( !Eof() ) .and. SUD->UD_FILIAL+SUD->UD_CODIGO == xFilial("SUD")+cChamado
	       	                                                                     
	If (SUD->UD_OCORREN $ cOcorrencia) .And. (SUD->UD_ENVWKF <> '2' .And. SUD->UD_ENVWKF <> '3')
		//Posiciona no cadastro de ocorrencias
		dbSelectArea('SU9')
		dbSetOrder(2)
		dbSeek(xFilial('SU9')+SUD->UD_OCORREN)
		cDescOcorr := Alltrim(SU9->U9_DESC)
	Endif
	
	SUD->( DbSkip() )
	
EndDo

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SUC->UC_CHAVE))

// C๓digo extraํdo do cadastro de processos.
cCodProcesso := cPastaLink

// Arquivo html template utilizado para montagem da aprova็ใo
cHtmlModelo := "\workflow\aprovacao.htm"

// Assunto da mensagem
cAssunto := IF(lReenvio,"(REENVIO) SAC - "+AllTrim(cDescOcorr)+" DO CHAMADO: "+cChamado,"SAC - "+AllTrim(cDescOcorr)+" DO CHAMADO: "+cChamado)

// Inicialize a classe TWFProcess e assinale a variแvel objeto oProcess:
oProcess := TWFProcess():New(cCodProcesso, cAssunto)

// Crie uma tarefa.
oProcess:NewTask(cAssunto, cHtmlModelo)

//Usuario do totvs
cUsuarioProtheus  	:= SU7->U7_CODUSU
oProcess:UserSiga	:= SU7->U7_CODUSU
oProcess:fDesc 		:= "SAC - Aprovacao do chamado"+ cChamado

conout("["+DToC(Date())+" "+Time()+"](INICIO|APROVASAC)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )
        
cDescOcorr := ""

oHtml :=oProcess:oHtml
                                       
oHtml:valbyname("t2.item"   , {})
oHtml:valbyname("t2.obs"   , {})
oHtml:valbyname("t2.status"   , {})        
oHtml:valbyname("t2.dtenv"   , {})        
oHtml:valbyname("t2.dtret"   , {})        
oHtml:valbyname("t2.hist"   , {})        
               
oHtml:valbyname("it.assunto"   , {})
oHtml:valbyname("it.prod"   , {})
oHtml:valbyname("it.desc"   , {})        
oHtml:valbyname("it.ocorrencia"   , {})        
oHtml:valbyname("it.qtde"   , {})        
oHtml:valbyname("it.prcpv"   , {})        
oHtml:valbyname("it.total"   , {})        
oHtml:valbyname("it.defeito"   , {})        
oHtml:valbyname("it.entrega"   , {})        
oHtml:valbyname("it.recbmto"   , {})        
oHtml:valbyname("it.garantia"   , {})        

/*** Preenche os dados do cabecalho ***/
oHtml:ValByName( "cChamado"		, cChamado )
oHtml:ValByName( "cFilial"		, POSICIONE("SM0",1,cEmpAnt+CFILANT,"M0_FILIAL") )
oHtml:ValByName( "cCliente"		, SA1->A1_NOME )
oHtml:ValByName( "cContato"		, SU5->U5_CONTAT )
oHtml:ValByName( "cOperador"	, UPPER(cOperador) )
oHtml:ValByName( "dData"		, SUC->UC_DATA )
oHtml:ValByName( "cCidade"		, ALLTRIM(SA1->A1_MUN) )
oHtml:ValByName( "cEstado"		, SA1->A1_EST )
oHtml:ValByName( "cObs"			, UPPER(cObs) )   

SUD->( dbSetOrder(1) )
SUD->( dbSeek(xFilial('SUD') + cChamado ))
While SUD->( !Eof() ) .and. SUD->UD_FILIAL+SUD->UD_CODIGO == xFilial("SUD")+cChamado
	       	                                                                     
	If (SUD->UD_OCORREN $ cOcorrencia) .And. (SUD->UD_ENVWKF <> '2' .And. SUD->UD_ENVWKF <> '3')
		
		RecLock("SUD",.F.)
		SUD->UD_WFID 	:= oProcess:fProcessID
		SUD->UD_ENVWKF 	:= "1"
		SUD->UD_WFIDENV	:= dDatabase
		SUD->UD_WFIDRET	:= Ctod("")
		SUD->UD_OBSWKF	:= ""
		SUD->UD_QTDENVP	:= SUD->UD_QTDENVP + 1
		SUD->UD_01APWKF := UsrRetName(cCodOpera)
		MsUnlock()
		
		nQuant += SUD->UD_01QTDVE
		nValor += SUD->UD_01VLPED
		
		//Posiciona no cadastro de produtos
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+SUD->UD_PRODUTO)
		
		//Posiciona no cadastro de ocorrencias
		dbSelectArea('SU9')
		dbSetOrder(2)
		dbSeek(xFilial('SU9')+SUD->UD_OCORREN)
		cDescOcorr += Alltrim(SU9->U9_DESC)+"/"
		
		//Posiciona no cadastro de tabelas do sistema
		dbSelectArea('SX5')
		dbSetOrder(1)
		dbSeek(xFilial('SX5')+'T1'+SUD->UD_ASSUNTO)
		
		If !Empty(SUD->UD_01DTENT)
			cGarantia := IF( ((SUD->UD_01DTENT+nPrazo) - DDATABASE) > nPrazo,"NAO","SIM")
		Else
			cGarantia := "NAO"
		Endif
		
		AAdd( (oHtml:ValByName( "it.assunto" 		)),SX5->X5_DESCRI )
		AAdd( (oHtml:ValByName( "it.prod" 			)),SB1->B1_COD )
		AAdd( (oHtml:ValByName( "it.desc" 			)),SB1->B1_DESC )
		AAdd( (oHtml:ValByName( "it.ocorrencia" 	)),SU9->U9_DESC )
		AAdd( (oHtml:ValByName( "it.qtde" 			)),TRANSFORM( SUD->UD_01QTDVE , '@E 999999.99'	) )
		AAdd( (oHtml:ValByName( "it.prcpv" 			)),TRANSFORM( SUD->UD_01PRCVE ,	'@E 999,999.99'	) )
		AAdd( (oHtml:ValByName( "it.total" 			)),TRANSFORM( SUD->UD_01VLPED ,	'@E 999,999.99'	) )
		AAdd( (oHtml:ValByName( "it.defeito" 		)),SUD->UD_01DESDE )
		AAdd( (oHtml:ValByName( "it.entrega"	 	)),SUD->UD_01DTENT )
		AAdd( (oHtml:ValByName( "it.recbmto" 		)),"" )
		AAdd( (oHtml:ValByName( "it.garantia" 		)),cGarantia )
		
		
	Endif
	
	SUD->( DbSkip() )
	
EndDo
                                       
SUD->( dbSetOrder(1) )
SUD->( dbSeek(xFilial('SUD') + cChamado ))
While SUD->( !Eof() ) .and. SUD->UD_FILIAL+SUD->UD_CODIGO == xFilial("SUD")+cChamado
	
	//#CMG20170111.bn
	
	If (SUD->UD_OCORREN $ cOcorrencia)
		
		//	oHtml:ValByName("HIST","Historico WorkFlow")
		
		//0=Nao Enviado;1=Enviado;2=Aprovado;3=Reprovado
		If AllTrim(SUD->UD_ENVWKF) == '0'
			_cStatus := 'Enviado'
		ElseIf AllTrim(SUD->UD_ENVWKF) == '1'
			_cStatus := 'Enviado'
		ElseIf AllTrim(SUD->UD_ENVWKF) == '2'
			_cStatus := 'Aprovado'
		ElseIf AllTrim(SUD->UD_ENVWKF) == '3'
			_cStatus := 'Reprovado'
		EndIf
		
		AADD( (oHtml:ValByName( "t2.item" 		)),SUD->UD_ITEM )
		AADD( (oHtml:ValByName( "t2.obs" 		)),AllTrim(SUD->UD_OBS))
		AADD( (oHtml:ValByName( "t2.status" 	)),AllTrim(_cStatus) )
		AADD( (oHtml:ValByName( "t2.dtenv" 	    )),IIF(Empty(SUD->UD_WFIDENV),DtoC(Date()),DtoC(SUD->UD_WFIDENV)) )
		AADD( (oHtml:ValByName( "t2.dtret" 		)),DtoC(SUD->UD_WFIDRET) )
		AADD( (oHtml:ValByName( "t2.hist" 		)),AllTrim(SUD->UD_OBSWKF) )
		           
		AADD(_aDadosH,{SUD->UD_ITEM,AllTrim(SUD->UD_OBS),DtoC(SUD->UD_WFIDRET),AllTrim(SUD->UD_OBSWKF)})
		
	EndIf
	
	//#CMG20170111.en
	
	SUD->( DbSkip() )
	
EndDo

oHtml:ValByName( "nQtdeTotal" 	,TRANSFORM( nQuant,	'@E 999999.99' ) )
oHtml:ValByName( "nVlrTotal" 	,TRANSFORM( nValor,	'@E 999,999.99' ) )

oProcess:ClientName( Substr(cUsuario,7,15) )

oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')

// Repasse o texto do assunto criado para a propriedade especifica do processo.
oProcess:cSubject := cAssunto

// Informe o endere็o eletr๔nico do destinatแrio.
oProcess:cTo := "aprovasac;"

// Informe o nome da fun็ใo de retorno a ser executada quando a mensagem de
// respostas retornarem ao Workflow:
oProcess:bReturn  := "U_SYTMWF01( 1 )"

// Informe o nome da fun็ใo do tipo timeout que serแ executada se houver um timeout
// ocorrido para esse processo. Neste exemplo, serแ executada 5 minutos ap๓s o envio
// do e-mail para o destinatแrio. Caso queira-se aumentar ou diminuir o tempo, altere
// os valores das variแveis: nDias, nHoras e nMinutos.
oProcess:bTimeOut := {{"U_SYTMWF01( 2 )", nDias, nHoras, nMinutos}}

AAdd(aReturn			, oProcess:fProcessId)
AAdd(oProcess:aParams	, cChave)
AAdd(oProcess:aParams	, cUsuarioProtheus)

cMailID := oProcess:Start()

cHtmlModelo := cPathHTML + "pvlink.htm"

oProcess:NewTask(cAssunto, cHtmlModelo)
conout("["+DToC(Date())+" "+Time()+"](INICIO|OCLINK)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

// Repasse o texto do assunto criado para a propriedade especifica do processo.
oProcess:cSubject := cAssunto

// Informe o endere็o eletr๔nico do destinatแrio.
oProcess:cTo := cTo

oHtml:valbyname("t3.item"   , {})
oHtml:valbyname("t3.obs"   , {})
oHtml:valbyname("t3.dtret"   , {})        
oHtml:valbyname("t3.hist"   , {})        
                            
For _nx := 1 To Len(_aDadosH)
	
	AADD( (oHtml:ValByName( "t3.item" 		)),_aDadosH[_nx,1])
	AADD( (oHtml:ValByName( "t3.obs" 		)),_aDadosH[_nx,2])
	AADD( (oHtml:ValByName( "t3.dtret" 		)),_aDadosH[_nx,3])
	AADD( (oHtml:ValByName( "t3.hist" 		)),_aDadosH[_nx,4])
	
Next _nx
               
//informe o nome do destinatario.
oProcess:ohtml:ValByName("cObs_1"	, UPPER(cObs))
cDescOcorr:= Substr(cDescOcorr,1,Len(cDescOcorr)-1)
oProcess:ohtml:ValByName("cChamado"		, cChamado 		)
oProcess:ohtml:ValByName("cOcorrencia"	, cDescOcorr 	)

// http://localhost/ --> representa: "c:\mp10\apdata\workflow"
// abaixo da pasta ..\workflow, havera uma subpasta chamada "messenger" criado automaticamente quando informa algum nome de pasta
// na propriedade op:cto := "nome_da_pasta"
// neste exemplo, voce tera que informar no nome "\workflow" na aba chamada "messenger" no campo "caminho:" no cadastro de parametro do workflow.
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
ฑฑบPrograma  ณSPCTimeOutบAutor  ณ SYMM Consultoria   บ Data ณ  04/11/16   บฑฑ
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
cTexto := "3.0 (SAC) - Chamado: "+oProcess:oHtml:RetByName('cChamado')
conout(cTexto)

//Obtenho a chave de pesquisa
cChave := oProcess:aParams[1]
cTexto := "4.0 Chave de pesquisa: "+cChave
conout(cTexto)

Dbselectarea("SUC")
DBSetOrder(1)
If DBSeek(cChave)
	
	cTexto := "5.0 Criando novo processo..."
	conout(cTexto)
	
	U_SYTMWF02(1,.T.)
	
EndIF

Conout("["+DToC(Date())+" "+Time()+"] Finalizando TIMEOUT/REENVIO... ")
Conout("-------------------------------------------------------------------------------")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNotifyAdm ณ Autor ณ  Alexandro Dias    ณ Data ณ  03/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณUtilizado para enviar qualquer notificacao ao administrador.บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NotifyAdm(cTitle, aMsg,cErroMail)

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