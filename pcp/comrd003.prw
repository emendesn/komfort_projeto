#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF
#INCLUDE "TBICONN.CH"
#include "TBICODE.CH"
#include "TOPCONN.CH"
#Include 'APWEBEX.CH'
#include "PRTOPDEF.CH"

#DEFINE pCRLF     CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRD003  บAutor  ณEDILSON Mendes      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia WorkFlow de Aprovacao de Solicitacao de Compras      บฑฑ
ฑฑฬออออออออออุออออออออออออัออออออัอออออออออัออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Nome		  ณ Tipo ณ Tamanho ณ Titulo                       บฑฑ
ฑฑบ          ณ C1_XCODAPR ณ C    ณ  6      ณ Cod Aprovador                บฑฑ
ฑฑบ          ณ C1_XIDAPRO ณ C    ณ 20      ณ ID do HTML de Aprovacao      บฑฑ
ฑฑบ          ณ C1_XIDPROC ณ C    ณ 20      ณ ID do HTML de Relatorio de   บฑฑ
ฑฑบ          ณ            ณ      ณ         ณ Produto                      บฑฑ
ฑฑศออออออออออฯออออออออออออฯออออออฯอออออออออฯออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMRD003( cNumSC )

Local cDirHtml
Local cDirWF
Local cServer
Local cCodAprov
Local cAprovador
Local oProcess
Local cIDProcess
Local lHabilitaWF := iif( GetMv("MV__ENVPOP" ,,"S") == "S", .T., .F. )

	DEFAULT cNumSC := SC1->C1_NUM
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__AMRPRO para amarracao por produto                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__ENVPOP") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__ENVPOP"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "N"
		SX6->X6_CONTENG := "N"
		SX6->X6_CONTSPA := "N"
		SX6->X6_DESCRIC	:= "DEFINE SE REALIZA O ENVIO DO WF POR PONTO DE PEDIDO"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__TIMESC para definir o periodo de vigencia da solictacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__TIMESC") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__TIMESC"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "0305"
		SX6->X6_CONTENG := "0305"
		SX6->X6_CONTSPA := "0305"
		SX6->X6_DESCRIC	:= "DEFINE TEMPO EM DIAS DE TIMEOUT DA APROVACAO DE SO"
		SX6->X6_DESC1	:= "LICITACAO DE COMPRAS - EX: AVISO EM 3 DIAS E EXCLU"
		SX6->X6_DESC2	:= "SAO EM 5 DIAS = 0305                              "
		SX6->(MsUnlock())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__APRPAD para definir o codigo do aprovador padrao       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__APRPAD") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__APRPAD"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "000013"
		SX6->X6_CONTENG := "000013"
		SX6->X6_CONTSPA := "000013"
		SX6->X6_DESCRIC	:= "DEFINE O CODIGO DO APROVADOR PADRAO"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__AMRPRO para amarracao por produto                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__AMRPRO") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__AMRPRO"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "1"
		SX6->X6_CONTENG := "1"
		SX6->X6_CONTSPA := "1"
		SX6->X6_DESCRIC	:= "DEFINE SE OS AMARRACAO POR PRODUTO"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__DIRHTM Caminho definindo o                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__DIRHTM") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__DIRHTM"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "\workflow\html"
		SX6->X6_CONTENG := "\workflow\html"
		SX6->X6_CONTSPA := "\workflow\html"
		SX6->X6_DESCRIC	:= "DEFINE SE O CAMINHO ONDE SAO ARMAZENADOS O HTML"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__DIRHTM Caminho definindo o                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__DIR_WF") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__DIR_WF"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "\workflow\http\messager\confirmacao"
		SX6->X6_CONTENG := "\workflow\http\messager\confirmacao"
		SX6->X6_CONTSPA := "\workflow\http\messager\confirmacao"
		SX6->X6_DESCRIC	:= "DEFINE O CAMINHO ONDE SERAO GRAVADOS OS WORKFLOWS"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a Existencia de Parametro MV__DIRHTM Caminho definindo o                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If .NOT. SX6->( DBSeek("    "+"MV__SRV_WF") )
		RecLock("SX6",.T.)
		SX6->X6_VAR    	:= "MV__DIR_WF"
		SX6->X6_TIPO 	:= "C"
		SX6->X6_CONTEUD := "200.155.65.133:6592"
		SX6->X6_CONTENG := "200.155.65.133:6592"
		SX6->X6_CONTSPA := "200.155.65.133:6592"
		SX6->X6_DESCRIC	:= "DEFINE O ENDERECO DO SERVIDOR PARA ACESSO AOS WORKFLOWS"
		SX6->X6_DESC1	:= ""
		SX6->X6_DESC2	:= ""
		SX6->(MsUnlock())
	EndIf
	
	// Verifica a existencia da solicitacao de compra
	// e com o parametro de envio de workflow habilitado.
	IF SC1->( DBSetOrder(1) ,DBSeek( xFilial("SC1") + cNumSc )) .AND. lHabilitaWF
		
		cCodAprov  := GetMv("MV__APRPAD" ,,"000013")
		
		cIDAprova  := U_COMWF001( cCodAprov )
		
		cIDProcess := U_COMWF002()

		//Grava o codigo do Aprovador
		if empty( SC1->C1_CODAPRO )
			RecLock("SC1",.F.)
			SC1->C1_CODAPRO := cCodAprov
			SC1->C1_ID_APRO := cIDAprova
			SC1->C1_ID_PROC := cIDProcess
			SC1->(MsUnlock())
		endif
		
		IF ! EMPTY( cIDAprova ) .AND. ! EMPTY( cIDProcess )
			
			cDirHtml   := GetMv("MV__DIRHTM")
			cDirWF     := GetMv("MV__DIR_WF")
			cServer    := GetMv("MV__SRV_WF")
			
			cAprovador := Posicione("SAK",1,xFilial("SAK")+SC1->C1_CODAPRO,"AK_NOME")
			
			oProcess          := TWFProcess():New("000004","Solicitacao de Compra - Link")
			oProcess:NewTask("Solicitacao", cDirHtml + "\wfsc000.htm")
			oProcess:cTo      := UsrRetMail(Posicione("SAK",1,xFilial("SAK")+SC1->C1_CODAPRO,"AK_USER"))
			oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
			oProcess:cSubject := "Aprova็ใo de Solicitacao de Compra: "+ SC1->C1_CODAPRO + " - Aprovador(a): " + cAprovador
			
			oProcess:ohtml:valbyname("Aprovador",cAprovador)
			oProcess:ohtml:valbyname("pedido",SC1->C1_NUM)
			oProcess:ohtml:valbyname("abertura",DtoC(SC1->C1_EMISSAO))
			oProcess:ohtml:valbyname("solicitante",SC1->C1_SOLICIT)
			oProcess:ohtml:valbyname("cLink","http://"+cServer+"/http/messager/confirmacao/"+AllTrim(cIDProcess)+".htm")
			oProcess:ohtml:valbyname("cLnkAprov","http://"+cServer+"/http/messager/confirmacao/"+AllTrim(cIDAprova)+".htm")
			oProcess:start()
			oProcess:Free()
			
		ENDIF
		
	 ENDIF
	
/*	If .NOT. Empty(cSuperior)
		RecLock("SC1",.F.)
		SC1->C1_CODAPRO := cSuperior
		MsUnlock()
		/*	If mv_par04 == 1 //Aprovacao por ITEM
		U_COMWF002()
		ElseIf SC1->C1_ITEM == cTotItem //Aprovacao por SOLICITACAO
		U_COMWF001()
		EndIf
		*/
		// ED --- U_COMWF002() //Envio dos Detalhes da Solicitacao
		
		// If SC1->C1_ITEM == cTotItem
			// ED --- U_COMWF001(cSuperior) //Envido do Resumo da Solicitacao
		// EndIf
		
	// EndIf */
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF001  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de Aprovacao de Solicitacao de Compras      บฑฑ
ฑฑบ          ณ Para quando a aprovacao e feita por SOLICITACAO            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF001(cAprov)

Local cQuery
Local cAlias   := getNextAlias()
Local cMvAtt   := GetMv("MV_WFHTML")
Local cMailSup := UsrRetMail(cAprov)
Local cDiasA   := SubStr(GetMv("MV__TIMESC"),1,2) //TIMEOUT Dias para Avisar Aprovador
Local cDiasE   := SubStr(GetMv("MV__TIMESC"),3,2) //TIMEOUT Dias para Excluir a Solicitacao
Local cDirWF   := GetMv("MV__DIR_WF")
Local cDirHtml := GetMv("MV__DIRHTM")
Local oProcess

	BEGIN SEQUENCE

		cQuery := " SELECT SC1.C1_NUM, SC1.C1_EMISSAO, SC1.C1_SOLICIT, SC1.C1_ITEM, SC1.C1_PRODUTO," + pCRLF
		cQuery := "        SC1.C1_DESCRI, SC1.C1_UM, SC1.C1_QUANT, SC1.C1_DATPRF, SC1.C1_OBS, SC1.C1_CC," + pCRLF
		cQuery := "        SC1.C1_CODAPRO, SC1.C1_USER" + pCRLF
		cQuery += "   FROM " + RetSqlName("SC1") + " (NOLOCK) SC1" + pCRLF
		cQuery += "  WHERE SC1.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "        AND SC1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
		cQuery += "        AND SC1.C1_NUM = '" + SC1->C1_NUM + "'" + pCRLF

		MemoWrit("COMWF001.sql",cQuery)
		dbUseArea( .T.,"TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
		
		TcSetField( cAlias, "C1_EMISSAO", "D")
		TcSetField( cAlias, "C1_DATPRF"," D")
		

		//(cAlias)->(dbEval({|| nRegistros++}))
		(cAlias)->(DbGotop())

		// COUNT TO nRec
		//CASO TENHA DADOS
		//  If nRec > 0
		While ! (cAlias)->( Eof() )
			
			dbSelectArea("TRB")
			TRB->( dbGoTop() )
			
			cNumSc		:= TRB->C1_NUM
			cSolicit	:= TRB->C1_SOLICIT
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณMuda o parametro para enviar no corpo do e-mailณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			PutMv("MV_WFHTML","T")
			
			oProcess := TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
			oProcess:NewTask('Inicio',cDirHtml + "\wfsc001.htm")

			oProcess:oHtml:ValByName("diasA",      cDiasA)
			oProcess:oHtml:ValByName("diasE",      cDiasE)
			oProcess:oHtml:ValByName("cNUM",       TRB->C1_NUM)
			oProcess:oHtml:ValByName("cEMISSAO",   DTOC(TRB->C1_EMISSAO))
			oProcess:oHtml:ValByName("cSOLICIT",   TRB->C1_SOLICIT)
			oProcess:oHtml:ValByName("cCODUSR",    TRB->C1_USER)
			oProcess:oHtml:ValByName("cAPROV",     "")
			oProcess:oHtml:ValByName("cMOTIVO",    "")
			oProcess:oHtml:ValByName("it.ITEM",    {})
			oProcess:oHtml:ValByName("it.PRODUTO", {})
			oProcess:oHtml:ValByName("it.DESCRI",  {})
			oProcess:oHtml:ValByName("it.UM",      {})
			oProcess:oHtml:ValByName("it.QUANT",   {})
			oProcess:oHtml:ValByName("it.DATPRF",  {})
			oProcess:oHtml:ValByName("it.OBS",     {})
			oProcess:oHtml:ValByName("it.CC",      {})
			
			dbSelectArea("TRB")
			TRB->(dbGoTop())
			While TRB->(!EOF())
				aadd(oProcess:oHtml:ValByName("it.ITEM"),   TRB->C1_ITEM                              ) //Item Cotacao
				aadd(oProcess:oHtml:ValByName("it.PRODUTO"),TRB->C1_PRODUTO                           ) //Cod Produto
				aadd(oProcess:oHtml:ValByName("it.DESCRI"), TRB->C1_DESCRI                            ) //Descricao Produto
				aadd(oProcess:oHtml:ValByName("it.UM"),     TRB->C1_UM                                ) //Unidade Medida
				aadd(oProcess:oHtml:ValByName("it.QUANT"),  TRANSFORM( TRB->C1_QUANT,'@E 999,999.99' )) //Quantidade Solicitada
				aadd(oProcess:oHtml:ValByName("it.DATPRF"), DTOC(TRB->C1_DATPRF)                      ) //Data da Necessidade
				aadd(oProcess:oHtml:ValByName("it.OBS"),    TRB->C1_OBS                               ) //Observacao
				aadd(oProcess:oHtml:ValByName("it.CC"),     TRB->C1_CC                                ) //Centro de Custo
				TRB->( DBSkip() )
			End
			
			//envia o e-mail
			cUser 				:= Subs(cUsuario,7,15)
			oProcess:ClientName(cUser)
			oProcess:cTo    	:= cMailSup
			// oProcess:cBCC     	:= "edilson.nascimento@komforthouse.com.br"
			oProcess:cSubject  	:= "Aprova็ใo de SC - "+cNumSc+" - De: "+cSolicit
			oProcess:cBody    	:= ""
			oProcess:bReturn  	:= "U_COMWF01a()"
			//oProcess:bTimeOut := {{"U_COMWF01b()", 0 , 0, 3 },{"U_COMWF01c()", 0 , 0, 6 }}
			oProcess:bTimeOut := {{"U_COMWF01b()", Val(cDiasA) , 0, 0 },{"U_COMWF01c()", Val(cDiasE) , 0, 0 }}
			oProcess:Start( cDirWF )
			//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
			RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004","1001","ENVIO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
			oProcess:Free()

			PutMv("MV_WFHTML",cMvAtt)
			
			TRB->(dbCloseArea())
			
			WFSendMail({"01","01"})

			(cAlias)->( DBSkip() )

		enddo
			
		/*Else
			TRB->(dbCloseArea())
			MsgStop("Problemas no Envio do E-Mail de Aprova็ใo!","ATENวรO!")
		EndIf */

	END SEQUENCE
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF01a  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retor Workflow de Aprovacao de Solicitacao de Compras      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF01a(oProcess)

Local cMvAtt := GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cAprov	:= oProcess:oHtml:RetByName("cAPROV")
Local cMotivo	:= oProcess:oHtml:RetByName("cMOTIVO")
Local cCodSol	:= oProcess:oHtml:RetByName("cCODUSR")
Local cMailSol 	:= UsrRetMail(cCodSol)

Private oHtml

	ConOut("Aprovando SC: "+cNumSc)
	
	cQuery := " UPDATE " + RetSqlName("SC1") + " C1" + pCRLF
	cQuery += "    SET C1.C1_APROV = '" + cAprov + "'" + pCRLF
	cQuery += "  WHERE C1.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1.C1_NUM = '" + cNumSc + "'" + pCRLF
	
	MemoWrit("COMWF01a.sql",cQuery)
	TcSqlExec(cQuery)
	TCREFRESH(RetSqlName("SC1"))
	
	
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1002',"RETOR DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia Envio de Mensagem de Avisoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	If cAprov == "L" //Verifica se foi aprovado
		oProcess:NewTask('Inicio',"\workflow\solicit_wf_005.htm")
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		oProcess:NewTask('Inicio',"\workflow\solicit_wf_006.htm")
	EndIf
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("Motivo"   , cMotivo)
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	
	cQuery2 := " SELECT C1.C1_ITEM, C1.C1_PRODUTO, C1.C1_DESCRI" + pCRLF
	cQuery2 += "   FROM " + RetSqlName("SC1") + " (NOLOCK) C1" + pCRLF
	cQuery2 += "  WHERE C1.D_E_L_E_T_ = ''" + pCRLF
	cQuery2 += "        AND C1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery2 += "        AND C1.C1_NUM = '" + cNumSc + "'" + pCRLF

	
	MemoWrit("COMWF01a.sql",cQuery2)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery2),"TRB", .F., .T.)
	
	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0
		
		dbSelectArea("TRB")
		dbGoTop()
		
		While !EOF()
			aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
			aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
			aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
			dbSkip()
		End
		
	EndIf
	TRB->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	//oProcess:cTo	  := "edilson.nascimento@komforthouse.com.br"
	CONOUT("e-MAIL: "+cMailSol)
	CONOUT("USERCOD "+cCodSol)
	oProcess:cTo	  := cMailSol
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	If cAprov == "L" //Verifica se foi aprovado
		oProcess:cSubject := "SC Nฐ: "+cNumSc+" - Aprovada"
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		oProcess:cSubject := "SC Nฐ: "+cNumSc+" - Reprovada"
	EndIf
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	If cAprov == "L" //Verifica se foi aprovado
		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1005',"APROVACAO DE WORKFLOW DE SC",cUsername)
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1006',"REJEICAO DE WORKFLOW DE SC",cUsername)
	EndIf
	
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF01b  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia um Aviso para Aprovador apos periodo de TIMEOUT      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF01b(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Private oHtml

	ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Solicitante:"+cSolicit)
	
	oProcess:Free()
	oProcess:= Nil
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia Envio de Mensagem de Avisoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\workflow\solicit_wf_003.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("diasA"   	, cDiasA)
	oHtml:valbyname("diasE"   	, Val(cDiasE)-Val(cDiasA))
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	
	cQuery := " SELECT C1.C1_ITEM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_CODAPRO" + pCRLF
	cQuery += "   FROM  " + RetSqlName("SC1") + " (NOLOCK) C1" + pCRLF
	cQuery += "  WHERE C1.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1.C1_NUM = '" + cNumSc + "'" + pCRLF

	MemoWrit("COMWF01b.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0
		
		dbSelectArea("TRB")
		TRB->( dbGoTop() )
		cMailSup := UsrRetMail(TRB->C1_CODAPRO)
		While TRB->( .NOT. EOF() )
			aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
			aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
			aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
			TRB->( dbSkip() )
		End
		
	EndIf
	TRB->(dbCloseArea())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	oProcess:cSubject := "Aviso de TimeOut de SC Nฐ: "+cNumSc+" - De: "+cSolicit
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1003',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF01c  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui a solicitacao apos um periodo de TIMEOUT            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF01c(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCodSol	:= RetCodUsr(cSolicit)
Local cMailSol 	:= UsrRetMail(cCodSol)
Local aCab := {}
Local aItem:= {}
Private oHtml

	ConOut("EXCLUSAO POR TIMEOUT SC:"+cNumSc+" Solicitante:"+cSolicit)
	
	cQuery := " SELECT C1.C1_ITEM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_CODAPRO" + pCRLF
	cQuery += "   FROM " + RetSqlName("SC1") + " (NOLOCK) C1" + pCRLF
	cQuery += "  WHERE C1.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1.C1_NUM = '" + cNumSc + "'" + pCRLF

	
	MemoWrit("COMWF01b.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicia MsExecAuto da Exclusaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("TRB")
		TRB->( dbGoTop() )
		cMailSup := UsrRetMail(TRB->C1_CODAPRO)
		While TRB->( .NOT. EOF() )
			lMsErroAuto := .F.
			aCab:= {		{"C1_NUM",cNumSc,NIL}}
			Aadd(aItem, {	{"C1_ITEM",TRB->C1_ITEM,NIL}})
			
			Begin Transaction
			MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,5) //Exclusao
			End Transaction
			
			TRB->( dbSkip() )
		End
		
		oProcess:Finish()
		oProcess:Free()
		oProcess:= Nil
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicia Envio de Mensagem de Avisoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		PutMv("MV_WFHTML","T")
		
		oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
		oProcess:NewTask('Inicio',"\workflow\solicit_wf_004.htm")
		oHtml   := oProcess:oHtml
		
		oHtml:valbyname("Num"		, cNumSc)
		oHtml:valbyname("Req"    	, cSolicit)
		oHtml:valbyname("Emissao"   , cEmissao)
		oHtml:valbyname("diasE"		, cDiasE)
		oHtml:valbyname("it.Item"   , {})
		oHtml:valbyname("it.Cod"  	, {})
		oHtml:valbyname("it.Desc"   , {})
		
		dbSelectArea("TRB")
		dbGoTop()
		
		While !EOF()
			aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
			aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
			aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
			dbSkip()
		End
		
	EndIf
	TRB->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup+";"+cMailSol
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	oProcess:cSubject := "Exclusใo por TimeOut - SC Nฐ: "+cNumSc+" - De: "+cSolicit
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1004',"TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF002  บAutor  ณTHIAGO COMELLI      บ Data ณ  06/22/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de Aprovacao de Solicitacao de Compras      บฑฑ
ฑฑบ          ณ Para quando a aprovacao e feita por ITEM                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

#DEFINE pMESES   { "Jan","Fev","Mar","Abr","Mai","Jun",;
                   "Jul","Ago","Set","Out","Nov","Dez" }

User Function COMWF002()

Local cMvAtt     := GetMv("MV_WFHTML")
Local cAprov     := PswRet()[1][11]
Local cMailSup   := UsrRetMail(cAprov)
Local cDiasA     := SubStr(GetMv("MV__TIMESC"),1,2) //TIMEOUT Dias para Avisar Aprovador
Local cDiasE     := SubStr(GetMv("MV__TIMESC"),3,2) //TIMEOUT Dias para Excluir a Solicitacao
Local cDirHtml   := GetMv("MV__DIRHTM")
Local cDirWF     := GetMv("MV__DIR_WF")
Local cMeses
Local nPos
Local cVarMes
Local aMeses     := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}

Local cIdProcess := ""
Local oProcess

	// Private oHtml
	
	cQuery := " SELECT C1.C1_FILIAL, C1.C1_NUM, C1.C1_EMISSAO, C1.C1_SOLICIT, C1.C1_ITEM, C1.C1_PRODUTO," + pCRLF
	cQuery += "        C1.C1_DESCRI, C1.C1_UM, C1.C1_QUANT, C1.C1_DATPRF, C1.C1_OBS, C1.C1_CC, C1.C1_CODAPRO," + pCRLF
	cQuery += "        C1.C1_QUJE, C1.C1_LOCAL, B2.B2_QATU, B1_EMIN, B1.B1_QE, B1.B1_UPRC" + pCRLF
	cQuery += "   FROM " + RetSqlName("SC1") + " (NOLOCK) C1" + pCRLF
	cQuery += "  INNER JOIN " + RetSqlName("SB2") + " (NOLOCK) B2 ON B2.B2_FILIAL = '"+ xFilial("SB2") + "'" + pCRLF
	cQuery += "                                                      AND C1.C1_PRODUTO = B2.B2_COD" + pCRLF
    cQuery += "                                                      AND C1.C1_LOCAL = B2.B2_LOCAL" + pCRLF
	cQuery += "                                                      AND B2.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "  INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) B1 ON B1.B1_FILIAL = '"+ xFilial("SB1") + "'" + pCRLF
	cQuery += "                                                      AND C1.C1_PRODUTO = B1.B1_COD" + pCRLF
	cQuery += "                                                      AND B1.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "  WHERE C1.D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1.C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1.C1_NUM = '" + SC1->C1_NUM + "'" + pCRLF
	cQuery += "        AND C1.C1_ITEM = '" + SC1->C1_ITEM + "'" + pCRLF

	
	MemoWrit("COMWF002.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	TcSetField("TRB","C1_EMISSAO","D")
	TcSetField("TRB","C1_DATPRF","D")
	
	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0
		
		// Pesquisa o email do Aprovador
		if SAK->(DBSetOrder(1),DBSeek(xFilial("SAK")+SC1->C1_CODAPRO))
			cAprov   := SAK->AK_USER
			cMailSup := UsrRetMail(cAprov)
		endif
		
		dbSelectArea("TRB")
		TRB->(dbGoTop())
		
		cNumSc   := TRB->C1_NUM
		cSolicit := TRB->C1_SOLICIT
		cItem    := TRB->C1_ITEM
		
		oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
		oProcess:NewTask('Inicio', cDirHtml + "\wfsc002.htm")
		// oHtml   := oProcess:oHtml
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDados do Cabecalhoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess:oHtml:ValByName("diasA",   cDiasA                )
		oProcess:oHtml:ValByName("diasE",   cDiasE                )
		oProcess:oHtml:ValByName("Num",     TRB->C1_NUM           ) //Numero da Cotacao
		oProcess:oHtml:ValByName("Item1",   TRB->C1_ITEM          ) //Item Cotacao
		oProcess:oHtml:ValByName("CC",      TRB->C1_CC            ) //Centro de Custo
		// oProcess:oHtml:ValByName("DescCC", TRB->Z2_NOME        ) //Descricao Centro de Custo
		oProcess:oHtml:ValByName("Req",     TRB->C1_SOLICIT       ) //Nome Requisitante
		oProcess:oHtml:ValByName("Emissao", DTOC(TRB->C1_EMISSAO) ) //Data de Emissao Solicitacao
		oProcess:oHtml:ValByName("cAPROV",  ""                    ) //Variavel que Retorna "Aprovado / Rejeitado"
		oProcess:oHtml:ValByName("cMOTIVO", ""                    ) //Variavel que Retorna o Motivo da Rejeicao
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSaldos em Estoqueณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess:oHtml:ValByName("Item",     TRB->C1_ITEM                                                                       ) //Item Cotacao
		oProcess:oHtml:ValByName("CodProd",  TRB->C1_PRODUTO                                                                    ) //Cod Produto
		oProcess:oHtml:ValByName("Desc",     TRB->C1_DESCRI                                                                     ) //Descricao Produto
		oProcess:oHtml:ValByName("SaldoAtu", TRANSFORM(TRB->B2_QATU,                             PesqPict("SB2","B2_QATU" ,12))	) //Saldo Atual Estoque
		oProcess:oHtml:ValByName("EstMin",   TRANSFORM(TRB->B1_EMIN,                             PesqPict("SB1","B1_EMIN" ,12))	) //Ponto de Pedido
		oProcess:oHtml:ValByName("QuantSol", TRANSFORM(TRB->C1_QUANT - TRB->C1_QUJE ,            PesqPict("SC1","C1_QUANT",12)) ) //Saldo da Solicitacao
		oProcess:oHtml:ValByName("UM",       TRANSFORM(TRB->C1_UM,                               PesqPict("SC1","C1_UM"))       ) //Unidade de Medida
		oProcess:oHtml:ValByName("Local",    TRANSFORM(TRB->C1_LOCAL,                            PesqPict("SC1","C1_LOCAL"))    ) //Armazem da Solicitacao
		oProcess:oHtml:ValByName("QuantEmb", TRANSFORM(TRB->B1_QE,                               PesqPict("SB1","B1_QE"   ,09)) ) //Quantidade Por Embalagem
		oProcess:oHtml:ValByName("UPRC",     TRANSFORM(TRB->B1_UPRC,                             PesqPict("SB1","B1_UPRC",12))  ) //Ultimo Preco de Compra
		oProcess:oHtml:ValByName("Lead",     TRANSFORM(CalcPrazo(TRB->C1_PRODUTO,TRB->C1_QUANT), "999")                         ) //Lead Time
		oProcess:oHtml:ValByName("DataNec",  IIf(Empty(TRB->C1_DATPRF),TRB->C1_EMISSAO,TRB->C1_DATPRF)                          ) //Data da Necessidade
		oProcess:oHtml:ValByName("DataCom",  SomaPrazo(IIf(Empty(TRB->C1_DATPRF),TRB->C1_EMISSAO,TRB->C1_DATPRF), -CalcPrazo(TRB->C1_PRODUTO,TRB->C1_QUANT)))// Data para Comprar
		oProcess:oHtml:ValByName("Obs",      TRANSFORM(TRB->C1_OBS,                              "@!")                          ) //Observacao da Cotacao
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณOrdens de Produ็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess:oHtml:ValByName("op1.OP",    {}) //Coloca em Branco para
		oProcess:oHtml:ValByName("op1.Prod",  {}) //caso nao tenha nenhuma OP
		oProcess:oHtml:ValByName("op1.Ini",   {})
		oProcess:oHtml:ValByName("op1.QtdOp", {})
		oProcess:oHtml:ValByName("op2.OP",    {})
		oProcess:oHtml:ValByName("op2.Prod",  {})
		oProcess:oHtml:ValByName("op2.Ini",   {})
		oProcess:oHtml:ValByName("op2.QtdOp", {})
		oProcess:oHtml:ValByName("op3.OP",    {})
		oProcess:oHtml:ValByName("op3.Prod",  {})
		oProcess:oHtml:ValByName("op3.Ini",   {})
		oProcess:oHtml:ValByName("op3.QtdOp", {})
		
		//Query busca as OPs do produto
		cQuery1 := " SELECT D4.D4_OP, D4.D4_DATA, D4.D4_QUANT, C2.C2_PRODUTO" + pCRLF
		cQuery1 += "   FROM " + RetSqlName("SD4") + " (NOLOCK) D4" + pCRLF
		cQuery1 += "  INNER JOIN " + RetSqlName("SC2") + " (NOLOCK) C2 ON C2.C2_FILIAL = '"+ xFilial("SC2") + "'" + pCRLF
		cQuery1 += "                                                      AND SUBSTRING(D4.D4_OP,1,6) = C2.C2_NUM" + pCRLF
		cQuery1 += "                                                      AND SUBSTRING(D4.D4_OP,7,2) = C2.C2_ITEM" + pCRLF
		cQuery1 += "                                                      AND SUBSTRING(D4.D4_OP,9,3) = C2.C2_SEQUEN" + pCRLF
		cQuery1 += "                                                      AND C2.D_E_L_E_T_ = ''" + pCRLF
		cQuery1 += "  WHERE D4.D_E_L_E_T_ = ''" + pCRLF
		cQuery1 += "        AND D4.D4_FILIAL = '"+ xFilial("SD4") + "'" + pCRLF
		cQuery1 += "        AND D4.D4_COD = '" + TRB->C1_PRODUTO + "'" + pCRLF
		cQuery1 += "        AND D4.D4_QUANT > 0" + pCRLF
		cQuery1 += " ORDER BY D4.D4_DATA" + pCRLF

		MemoWrit("COMWF002a.sql",cQuery1)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery1),"TRB1", .F., .T.)
		
		TcSetField("TRB1","D4_DATA","D")
		
		COUNT TO nRec1
		//CASO TENHA DADOS
		If nRec1 > 0
			
			DBSelectArea("TRB1")
			TRB1->( DBGoTop() )
			While TRB1->( !EOF() )
				aadd( oProcess:oHtml:ValByName("op1.OP"),    TRB1->D4_OP			                                   ) //Numero da OP 1
				aadd( oProcess:oHtml:ValByName("op1.Prod"),  TRB1->C2_PRODUTO		                                   ) //Produto a Ser Produzido OP 1
				aadd( oProcess:oHtml:ValByName("op1.Ini"),   DTOC(TRB1->D4_DATA)	                                   ) //Data da OP 1
				aadd( oProcess:oHtml:ValByName("op1.QtdOp"), TRANSFORM(TRB1->D4_QUANT , PesqPict("SD4","D4_QUANT",12)) ) //Quantidade OP 1
				TRB1->(dbSkip())
				aadd( oProcess:oHtml:ValByName("op2.OP"),    TRB1->D4_OP                                               ) //Numero da OP 2
				aadd( oProcess:oHtml:ValByName("op2.Prod"),  TRB1->C2_PRODUTO                                          ) //Produto a Ser Produzido OP 2
				aadd( oProcess:oHtml:ValByName("op2.Ini"),   DTOC(TRB1->D4_DATA)                                       ) //Data da OP 2
				aadd( oProcess:oHtml:ValByName("op2.QtdOp"), TRANSFORM(TRB1->D4_QUANT , PesqPict("SD4","D4_QUANT",12)) ) //Quantidade OP 2
				TRB1->(dbSkip())
				aadd( oProcess:oHtml:ValByName("op3.OP"),    TRB1->D4_OP                                               ) //Numero da OP 3
				aadd( oProcess:oHtml:ValByName("op3.Prod"),  TRB1->C2_PRODUTO                                          ) //Produto a Ser Produzido OP 3
				aadd( oProcess:oHtml:ValByName("op3.Ini"),   DTOC(TRB1->D4_DATA)                                       ) //Data da OP 3
				aadd( oProcess:oHtml:ValByName("op3.QtdOp"), TRANSFORM(TRB1->D4_QUANT , PesqPict("SD4","D4_QUANT",12)) ) //Quantidade OP 3
				TRB1->(dbSkip())
			End
			
		Else
			
			aadd(oProcess:oHtml:ValByName("op1.OP"),    "")
			aadd(oProcess:oHtml:ValByName("op1.Prod"),  "")
			aadd(oProcess:oHtml:ValByName("op1.Ini"),   "")
			aadd(oProcess:oHtml:ValByName("op1.QtdOp"), "")
			aadd(oProcess:oHtml:ValByName("op2.OP"),    "")
			aadd(oProcess:oHtml:ValByName("op2.Prod"),  "")
			aadd(oProcess:oHtml:ValByName("op2.Ini"),   "")
			aadd(oProcess:oHtml:ValByName("op2.QtdOp"), "")
			aadd(oProcess:oHtml:ValByName("op3.OP"),    "")
			aadd(oProcess:oHtml:ValByName("op3.Prod"),  "")
			aadd(oProcess:oHtml:ValByName("op3.Ini"),   "")
			aadd(oProcess:oHtml:ValByName("op3.QtdOp"), "")
		EndIf
		TRB1->(dbCloseArea())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConsumo Ultimos 12 Mesesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//Query busca Consumo do produto
		cQuery2 := " SELECT B3.*" + pCRLF
		cQuery2 += "   FROM " + RetSqlName("SB3") + " (NOLOCK) B3" + pCRLF
		cQuery2 += "  WHERE B3.D_E_L_E_T_ = ''" + pCRLF
		cQuery2 += "        AND B3.B3_FILIAL = '"+ xFilial("SB3") + "'" + pCRLF
		cQuery2 += "        AND B3.B3_COD = '" + TRB->C1_PRODUTO + "'" + pCRLF
		
		MemoWrit("COMWF002b.sql",cQuery2)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery2),"TRB2", .F., .T.)
		
		COUNT TO nRec2
		//CASO TENHA DADOS
		If nRec2 > 0
			
			dbSelectArea("TRB2")
			TRB2->(dbGoTop())
			
			cMeses := Space(5)
			nAno   := YEAR(dDataBase)
			nMes   := MONTH(dDataBase)
			aOrdem := {}
			
			For nPos := nMes To 1 Step -1 //Preenche Meses Anteriores do Ano Atual
				//cMeses += aMeses[ nPos ]+"/"+Substr(Str(nAno,4),3,2)
				cMeses += pMESES[ nPos ]+"/"+Substr(Str(nAno,4),3,2)
				AADD( aOrdem, nPos )
			Next
			
			nAno-- //Volta para Ano Anterior
			
			For nPos := 12 To nMes+1 Step -1 //Preenche Meses Finais do Ano Anterior
				// cMeses += aMeses[ nPos ]+"/"+Substr(Str(nAno,4),3,2)
				cMeses += pMESES[ nPos ]+"/"+Substr(Str(nAno,4),3,2)
				AADD( aOrdem, nPos )
			Next
			
			For nPos :=1 to 12 //Preenche as variaveis do HTML
				cVarMes := "Mes"+AllTrim(Str( nPos ))
				oProcess:oHtml:ValByName( cVarMes, SubStr(cMeses,( nPos*6),6)) // Meses de Consumo
			Next
			
			For nPos := 1 To Len(aOrdem)
				cMes    := StrZero(aOrdem[ nPos ],2)
				cCampos := "TRB2->B3_Q"+cMes
				oProcess:oHtml:ValByName("CMes"+AllTrim(Str( nPos )), TRANSFORM(&cCampos , PesqPict("SB3","B3_Q01",9))) //Valor de Consumo nos Meses
			Next
			
			oProcess:oHtml:ValByName("MedC", TRANSFORM(TRB2->B3_MEDIA, PesqPict("SB3","B3_MEDIA",8))) //Media de Consumo
			
		Else //Caso nao tenha dados
			
			oProcess:oHtml:ValByName("MedC", "")
			For nPos := 1 To 12
				oProcess:oHtml:ValByName("CMes"+AllTrim(Str( nPos )), "")
				oProcess:oHtml:ValByName("Mes"+AllTrim(Str( nPos )),  "")
			Next
		EndIf
		TRB2->(dbCloseArea())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณUltimos Pedidos de Compra ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess:oHtml:ValByName("it.NumP",     {})
		oProcess:oHtml:ValByName("it.ItemP",    {})
		oProcess:oHtml:ValByName("it.CodP",     {})
		oProcess:oHtml:ValByName("it.LjP",      {})
		oProcess:oHtml:ValByName("it.NomeP",    {})
		oProcess:oHtml:ValByName("it.QtdeP",    {})
		oProcess:oHtml:ValByName("it.UMP",      {})
		oProcess:oHtml:ValByName("it.VlrUnP",   {})
		oProcess:oHtml:ValByName("it.VlrTotP",  {})
		oProcess:oHtml:ValByName("it.EmiP",     {})
		oProcess:oHtml:ValByName("it.NecP",     {})
		oProcess:oHtml:ValByName("it.PraP",     {})
		oProcess:oHtml:ValByName("it.CondP",    {})
		oProcess:oHtml:ValByName("it.QtdeEntP", {})
		oProcess:oHtml:ValByName("it.SalP",     {})
		oProcess:oHtml:ValByName("it.EliP",     {})
		
		//Query busca Pedidos do Produto
		cQuery3 := " SELECT C7.C7_NUM, C7.C7_ITEM, C7.C7_FORNECE, C7.C7_LOJA, A2.A2_NOME," + pCRLF
		cQuery3 += "        C7.C7_QUANT, C7.C7_UM,C7.C7_PRECO, C7.C7_TOTAL, C7.C7_EMISSAO," + pCRLF
		cQuery3 += "        C7.C7_DATPRF, C7.C7_COND, C7.C7_QUJE, C7.C7_RESIDUO" + pCRLF
		cQuery3 += "   FROM " + RetSqlName("SC7") + " (NOLOCK) C7" + pCRLF
		cQuery3 += "  INNER JOIN " + RetSqlName("SA2") + " (NOLOCK) A2 ON A2.A2_COD = '"+ xFilial("SA2") + "'" + pCRLF
		cQuery3 += "                                                      AND A2.A2_COD = C7.C7_FORNECE" + pCRLF
		cQuery3 += "                                                      AND A2.A2_LOJA = C7.C7_LOJA" + pCRLF
		cQuery3 += "                                                      AND A2.D_E_L_E_T_ = ''" + pCRLF
		cQuery3 += "  WHERE C7.D_E_L_E_T_ = ''" + pCRLF
		cQuery3 += "        AND C7.C7_FILIAL = '" + TRB->C1_FILIAL + "'" + pCRLF
		cQuery3 += "        AND C7.C7_PRODUTO = '" + TRB->C1_PRODUTO + "'" + pCRLF
		cQuery3 += " ORDER BY C7.C7_EMISSAO DESC" + pCRLF
		
		MemoWrit("COMWF002c.sql",cQuery3)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery3),"TRB3", .F., .T.)
		
		TcSetField("TRB3","C7_EMISSAO","D")
		TcSetField("TRB3","C7_DATPRF","D")
		
		COUNT TO nRec3
		//CASO TENHA DADOS
		If nRec3 > 0
			
			dbSelectArea("TRB3")
			TRB3->(dbGoTop())
			
			nContador := 0
			
			While !TRB3->(EOF())
				
				nContador++
				If nContador > 03 //Numero de Pedidos
					Exit
				EndIf
				
				aadd(oProcess:oHtml:ValByName("it.NumP"),     TRB3->C7_NUM                                                             )
				aadd(oProcess:oHtml:ValByName("it.ItemP"),    TRB3->C7_ITEM                                                            )
				aadd(oProcess:oHtml:ValByName("it.CodP"),     TRB3->C7_FORNECE                                                         )
				aadd(oProcess:oHtml:ValByName("it.LjP"),      TRB3->C7_LOJA                                                            )
				aadd(oProcess:oHtml:ValByName("it.NomeP"),    TRB3->A2_NOME                                                            )
				aadd(oProcess:oHtml:ValByName("it.QtdeP"),    TRANSFORM(TRB3->C7_QUANT , PesqPict("SC7","C7_QUANT",14))	               )
				aadd(oProcess:oHtml:ValByName("it.UMP"),      TRB3->C7_UM                                                              )
				aadd(oProcess:oHtml:ValByName("it.VlrUnP"),   TRANSFORM(TRB3->C7_PRECO, PesqPict("SC7","c7_preco",14))                 )
				aadd(oProcess:oHtml:ValByName("it.VlrTotP"),  TRANSFORM(TRB3->C7_TOTAL, PesqPict("SC7","c7_total",14))                 )
				aadd(oProcess:oHtml:ValByName("it.EmiP"),     DTOC(TRB3->C7_EMISSAO)                                                   )
				aadd(oProcess:oHtml:ValByName("it.NecP"),     DTOC(TRB3->C7_DATPRF)                                                    )
				aadd(oProcess:oHtml:ValByName("it.PraP"),     TRANSFORM(Val(DTOC(TRB3->C7_DATPRF))-Val(DTOC(TRB3->C7_EMISSAO)), "999") )
				aadd(oProcess:oHtml:ValByName("it.CondP"),    TRB3->C7_COND                                                            )
				aadd(oProcess:oHtml:ValByName("it.QtdeEntP"), TRANSFORM(TRB3->C7_QUJE, PesqPict("SC7","C7_QUJE",14))                   )
				aadd(oProcess:oHtml:ValByName("it.SalP"),     TRANSFORM(IIf(Empty(TRB3->C7_RESIDUO),TRB3->C7_QUANT-TRB3->C7_QUJE,0), PesqPict("SC7","C7_QUJE",14)))
				aadd(oProcess:oHtml:ValByName("it.EliP"),     IIf(Empty(TRB3->C7_RESIDUO),'Nใo','Sim')                                 )
				
				TRB3->(dbSkip())
			End
			
		Else //Caso nao tenha dados
			
			aadd(oProcess:oHtml:ValByName("it.NumP"),     "")
			aadd(oProcess:oHtml:ValByName("it.ItemP"),    "")
			aadd(oProcess:oHtml:ValByName("it.CodP"),     "")
			aadd(oProcess:oHtml:ValByName("it.LjP"),      "")
			aadd(oProcess:oHtml:ValByName("it.NomeP"),    "")
			aadd(oProcess:oHtml:ValByName("it.QtdeP"),    "")
			aadd(oProcess:oHtml:ValByName("it.UMP"),      "")
			aadd(oProcess:oHtml:ValByName("it.VlrUnP"),   "")
			aadd(oProcess:oHtml:ValByName("it.VlrTotP"),  "")
			aadd(oProcess:oHtml:ValByName("it.EmiP"),     "")
			aadd(oProcess:oHtml:ValByName("it.NecP"),     "")
			aadd(oProcess:oHtml:ValByName("it.PraP"),     "")
			aadd(oProcess:oHtml:ValByName("it.CondP"),    "")
			aadd(oProcess:oHtml:ValByName("it.QtdeEntP"), "")
			aadd(oProcess:oHtml:ValByName("it.SalP"),     "")
			aadd(oProcess:oHtml:ValByName("it.EliP"),     "")
			
		EndIf
		TRB3->(dbCloseArea())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณUltimos Fornecedoresณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		oProcess:oHtml:ValByName("it1.CodF",    {})
		oProcess:oHtml:ValByName("it1.LjF",     {})
		oProcess:oHtml:ValByName("it1.NomeF",   {})
		oProcess:oHtml:ValByName("it1.TelF",    {})
		oProcess:oHtml:ValByName("it1.ContF",   {})
		oProcess:oHtml:ValByName("it1.FaxF",    {})
		oProcess:oHtml:ValByName("it1.UlComF",  {})
		oProcess:oHtml:ValByName("it1.MunicF",  {})
		oProcess:oHtml:ValByName("it1.UFF",     {})
		oProcess:oHtml:ValByName("it1.RisF",    {})
		oProcess:oHtml:ValByName("it1.CodForF", {})
		
		If GetMv("MV__AMRPRO" ,, "0" ) == "1" // Amarracao por Produto
			
			//Query busca Fornecedores do Produto
			cQuery4 := " SELECT A5.A5_FORNECE, A5.A5_LOJA, A2.A2_NOME, A2.A2_TEL, A2.A2_CONTATO, A2.A2_FAX," + pCRLF
			cQuery4 += "        A2.A2_ULTCOM, A2.A2_MUN, A2.A2_EST, A2.A2_RISCO, A5.A5_CODPRF" + pCRLF
			cQuery4 += "   FROM " + RetSqlName("SA5") + " (NOLOCK) A5" + pCRLF
			cQuery4 += "  INNER JOIN " + RetSqlName("SA2") + " (NOLOCK) A2 ON A2.A2_FILIAL = '"+ xFilial("SA2") + "'" + pCRLF
			cQuery4 += "                                                      AND A5.A5_FORNECE = A2.A2_COD" + pCRLF
			cQuery4 += "                                                      AND A5.A5_LOJA = A2.A2_LOJA" + pCRLF
			cQuery4 += "                                                      AND A2.D_E_L_E_T_ = ''" + pCRLF
			cQuery4 += "  WHERE A5.D_E_L_E_T_ = ''" + pCRLF
			cQuery4 += "        AND A5.A5_FILIAL = '" + xFilial("SA5") + "'" + pCRLF
			cQuery4 += "        AND A5.A5_PRODUTO = '" + TRB->C1_PRODUTO + "'" + pCRLF
			cQuery4 += " ORDER BY A2.A2_ULTCOM DESC" + pCRLF
			
			MemoWrit("COMWF002d.sql",cQuery4)
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery4),"TRB4", .F., .T.)
			
			TcSetField("TRB4","A2_ULTCOM","D")
			
			COUNT TO nRec4
			//CASO TENHA DADOS
			If nRec4 > 0
				
				dbSelectArea("TRB4")
				TRB4->(dbGoTop())
				
				nContador := 0
				
				While !TRB4->(EOF())
					
					nContador++
					If nContador > 03 //Numero de Fornecedores
						Exit
					EndIf
					
					aadd(oProcess:oHtml:ValByName("it1.CodF"),    TRB4->A5_FORNECE      ) //Codigo do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.LjF"),     TRB4->A5_LOJA         ) //Codigo da Loja
					aadd(oProcess:oHtml:ValByName("it1.NomeF"),   TRB4->A2_NOME         ) //Nome do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.TelF"),    TRB4->A2_TEL          ) //Telefone do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.ContF"),   TRB4->A2_CONTATO      ) //Contato no Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.FaxF"),    TRB4->A2_FAX          ) //Fax no Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.UlComF"),  DTOC(TRB4->A2_ULTCOM) ) //Ultima Compra com o Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.MunicF"),  TRB4->A2_MUN          ) //Municipio do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.UFF"),     TRB4->A2_EST          ) //Estado do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.RisF"),    TRB4->A2_RISCO        ) //Risco do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.CodForF"), TRB4->A5_CODPRF       ) //Codigo no Forncedor
					
					TRB4->(dbSkip())
				End
				
			Else //Caso nao tenha dados
				
				aadd(oProcess:oHtml:ValByName("it1.CodF"),    "" ) //Codigo do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.LjF"),     "" ) //Codigo da Loja
				aadd(oProcess:oHtml:ValByName("it1.NomeF"),   "" ) //Nome do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.TelF"),    "" ) //Telefone do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.ContF"),   "" ) //Contato no Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.FaxF"),    "" ) //Fax no Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.UlComF"),  "" ) //Ultima Compra com o Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.MunicF"),  "" ) //Municipio do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.UFF"),     "" ) //Estado do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.RisF"),    "" ) //Risco do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.CodForF"), "" ) //Codigo no Forncedor
				
			EndIf
			TRB4->(dbCloseArea())
			
		Else
			
			//Query busca Fornecedores do Grupo de Produtos
			cQuery4 := " SELECT AD.AD_FORNECE, AD.AD_LOJA, A2.A2_NOME, A2.A2_TEL, A2.A2_CONTATO, A2.A2_FAX," + pCRLF
			cQuery4 += "         A2.A2_ULTCOM,A2.A2_MUN, A2.A2_EST, A2.A2_RISCO" + pCRLF
			cQuery4 += "   FROM  " + RetSqlName("SB1") + " (NOLOCK) B1" + pCRLF
			cQuery4 += "  INNER JOIN " + RetSqlName("SAD") + " (NOLOCK) AD ON AD.AD_FILIAL = '"+ xFilial("SAD") + "'" + pCRLF
			cQuery4 += "                                                      AND B1.B1_GRUPO = AD.AD_GRUPO" + pCRLF
			cQuery4 += "                                                      AND AD.D_E_L_E_T_ = ''" + pCRLF
			cQuery4 += "  INNER JOIN " + RetSqlName("SA2") + " (NOLOCK) A2 ON A2.A2_FILIAL = '"+ xFilial("SA2") + "'" + pCRLF
			cQuery4 += "                                                      AND AD.AD_FORNECE = A2.A2_COD" + pCRLF
			cQuery4 += "                                                      AND AD.AD_LOJA = A2.A2_LOJA" + pCRLF
			cQuery4 += "                                                      AND A2.D_E_L_E_T_ = ''" + pCRLF
			cQuery4 += "  WHERE B1.D_E_L_E_T_ = ''" + pCRLF
			cQuery4 += "        AND B1.B1_FILIAL = '"+ xFilial("SB1") + "'" + pCRLF
			cQuery4 += "        AND B1.B1_COD = '" + TRB->C1_PRODUTO + "'" + pCRLF
			cQuery4 += " ORDER BY A2.A2_ULTCOM DESC" + pCRLF
			
			MemoWrit("COMWF002d.sql",cQuery4)
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery4),"TRB4", .F., .T.)
			
			TcSetField("TRB4","A2_ULTCOM","D")
			
			COUNT TO nRec4
			//CASO TENHA DADOS
			If nRec4 > 0
				
				dbSelectArea("TRB4")
				TRB4->(dbGoTop())
				
				nContador := 0
				
				While !TRB4->(EOF())
					
					nContador++
					If nContador > 03 //Numero de Fornecedores
						Exit
					EndIf
					
					aadd(oProcess:oHtml:ValByName("it1.CodF"),    TRB4->AD_FORNECE      ) //Codigo do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.LjF"),     TRB4->AD_LOJA         ) //Codigo da Loja
					aadd(oProcess:oHtml:ValByName("it1.NomeF"),   TRB4->A2_NOME         ) //Nome do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.TelF"),    TRB4->A2_TEL          ) //Telefone do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.ContF"),   TRB4->A2_CONTATO      ) //Contato no Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.FaxF"),    TRB4->A2_FAX          ) //Fax no Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.UlComF"),  DTOC(TRB4->A2_ULTCOM) ) //Ultima Compra com o Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.MunicF"),  TRB4->A2_MUN          ) //Municipio do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.UFF"),     TRB4->A2_EST          ) //Estado do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.RisF"),    TRB4->A2_RISCO        ) //Risco do Fornecedor
					aadd(oProcess:oHtml:ValByName("it1.CodForF"), ""                    ) //Codigo no Forncedor
					TRB4->(dbSkip())
				End
				
			Else //Caso nao tenha dados
				
				aadd(oProcess:oHtml:ValByName("it1.CodF"),    "" ) //Codigo do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.LjF"),     "" ) //Codigo da Loja
				aadd(oProcess:oHtml:ValByName("it1.NomeF"),   "" ) //Nome do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.TelF"),    "" ) //Telefone do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.ContF"),   "" ) //Contato no Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.FaxF"),    "" ) //Fax no Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.UlComF"),  "" ) //Ultima Compra com o Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.MunicF"),  "" ) //Municipio do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.UFF"),     "" ) //Estado do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.RisF"),    "" ) //Risco do Fornecedor
				aadd(oProcess:oHtml:ValByName("it1.CodForF"), "" ) //Codigo no Forncedor
				
			EndIf
			TRB4->(dbCloseArea())
			
		EndIf
		
		oProcess:fDesc := "Solicitacao de Compras No "+ cNumSc
		cIdProcess := oProcess:start( cDirWF )
		
	Else
		MsgStop("Foi encontrado um problema na Gera็ใo do E-Mail de Aprova็ใo. Favor avisar o Depto de Informแtica. NREC =","ATENวรO!")
	EndIf
	
	TRB->(dbCloseArea())
		
Return( cIdProcess )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF02a  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retor Workflow de Aprovacao de Solicitacao de Compras      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF02a(oProcess)

Local cMvAtt := GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Local cAprov	:= oProcess:oHtml:RetByName("cAPROV")
Local cMotivo	:= oProcess:oHtml:RetByName("cMOTIVO")

Private oHtml

	ConOut("Atualizando SC:"+cNumSc+" Item:"+cItemSc)
	
	cQuery := " UPDATE " + RetSqlName("SC1") + pCRLF
	cQuery += "    SET C1_APROV = '" + cAprov + "'"  + pCRLF
	cQuery += "  WHERE D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1_NUM = '" + cNumSc + "'" + pCRLF
	cQuery += "        AND C1_ITEM = '" + cItemSc + "'" + pCRLF
	
	MemoWrit("COMWF02a.sql",cQuery)
	TcSqlExec(cQuery)
	TCREFRESH(RetSqlName("SC1"))
	
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1002',"RETOR DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia Envio de Mensagem de Avisoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	If cAprov == "L" //Verifica se foi aprovado
		oProcess:NewTask('Inicio',"\workflow\solicit_wf_005.htm")
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		oProcess:NewTask('Inicio',"\workflow\solicit_wf_006.htm")
	EndIf
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("Motivo"   , cMotivo)
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	aadd(oHtml:ValByName("it.Item")		, cItemSc)
	aadd(oHtml:ValByName("it.Cod")		, cCod)
	aadd(oHtml:ValByName("it.Desc")		, cDesc)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	
	If cAprov == "L" //Verifica se foi aprovado
		oProcess:cSubject := "SC Nฐ: "+cNumSc+" - Item: "+cItemSc+" - Aprovada"
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		oProcess:cSubject := "SC Nฐ: "+cNumSc+" - Item: "+cItemSc+" - Reprovada"
	EndIf
	
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	If cAprov == "L" //Verifica se foi aprovado
		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1005',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	ElseIf cAprov == "R" //Verifica se foi rejeitado
		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1006',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	EndIf
	
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF02b  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia um Aviso para Aprovador apos periodo de TIMEOUT      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF02b(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Private oHtml

	ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Item:"+cItemSc+" Solicitante:"+cSolicit)
	
	oProcess:Free()
	oProcess:= Nil
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia Envio de Mensagem de Avisoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\workflow\solicit_wf_003.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("diasA"   	, cDiasA)
	oHtml:valbyname("diasE"   	, Val(cDiasE)-Val(cDiasA))
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	aadd(oHtml:ValByName("it.Item")		, cItemSc)
	aadd(oHtml:ValByName("it.Cod")		, cCod)
	aadd(oHtml:ValByName("it.Desc")		, cDesc)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	oProcess:cSubject := "Aviso de TimeOut de SC Nฐ: "+cNumSc+" Item: "+cItemSc+" - De: "+cSolicit
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1003',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMWF02c  บAutor  ณEDILSON MENDES      บ Data ณ  12/12/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui a solicitacao apos um periodo de TIMEOUT            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function COMWF02c(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Local cCodSol	:= RetCodUsr(cSolicit)
Local cMailSol 	:= UsrRetMail(cCodSol)
Private oHtml

	ConOut("EXCLUSAO POR TIMEOUT SC:"+cNumSc+" Item:"+cItemSc+" Solicitante:"+cSolicit)
	
	cQuery := " UPDATE " + RetSqlName("SC1") + pCRLF
	cQuery += "    SET D_E_L_E_T_ = '*'" + pCRLF
	cQuery += "  WHERE D_E_L_E_T_ = ''" + pCRLF
	cQuery += "        AND C1_FILIAL = '"+ xFilial("SC1") + "'" + pCRLF
	cQuery += "        AND C1_NUM = '" + cNumSc + "'" + pCRLF
	cQuery += "        AND C1_ITEM = '" + cItemSc + "'" + pCRLF
	
	MemoWrit("COMWF02c.sql",cQuery)
	TcSqlExec(cQuery)
	TCREFRESH(RetSqlName("SC1"))
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia Envio de Mensagem de Avisoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\workflow\solicit_wf_004.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("diasE"		, cDiasE)
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	aadd(oHtml:ValByName("it.Item")		, cItemSc)
	aadd(oHtml:ValByName("it.Cod")		, cCod)
	aadd(oHtml:ValByName("it.Desc")		, cDesc)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncoes para Envio do Workflowณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//envia o e-mail
	cUser 			  := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup+";"+cMailSol
	oProcess:cBCC     := "edilson.nascimento@komforthouse.com.br"
	oProcess:cSubject := "Exclusใo por TimeOut - SC Nฐ: "+cNumSc+" Item: "+cItemSc+" - De: "+cSolicit
	oProcess:cBody    := ""
	oProcess:bReturn  := ""
	oProcess:Start()
	//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1004',"TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	WFSendMail({"01","01"})
	
Return