#Include "Protheus.ch"
#Include "FWPrintSetup.ch"

#Define CRLF Chr(13)+Chr(10)
#Define DMPAPER_A4 9
#Define IMP_PDF 6
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYXMLA04 บAutor  ณ LUIZ EDUARDO F.C.  บ Data ณ  08/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a chave do XML recebido pela central de             บฑฑ
ฑฑบ          ณ recebimentos                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GESTOR DE XML                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObservacoes:                                                             ณ
//ณ- Para o funcionamento dessa rotina, e necessario que o servico de TSS   ณ
//ณ  esteja sendo executando.                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function SYXMLA04(cChave, oXML, cNomeXml)

Local oWSConsulta
Local aArea			:= SM0->(GetArea())
Local cURL		    := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cIdEnt	    := ""
Local cCodRet		:= ""
Local cMsgRet  		:= ""
Local cDigVal  		:= ""
Local cProtocolo	:= ""
Local cHoraRec		:= ""
Local aRet			:= {.F., ""}

SM0->(DbGoTop())

While SM0->(!EOF())
	IF ALLTRIM(SM0->M0_CODFIL) == ALLTRIM(cFilAnt)
		cIdEnt	:= RetIdEnti()
	EndIF
	SM0->(DbSkip())
EndDo

oWSConsulta:= WsNFeSBra():New()
oWSConsulta:cUserToken	:= "TOTVS"
oWSConsulta:cID_ENT		:= cIdEnt
oWSConsulta:cCHVNFE		:= cChave
oWSConsulta:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama o webservice para consultar o status da chave e ณ
//ณretorna infomacoes para compor o PDF                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If oWSConsulta:ConsultaChaveNFE()
	
	cCodRet		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CCODRETNFE
	cDigVal		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CDIGVAL
	cMsgRet		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CMSGRETNFE
	cProtocolo	:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CPROTOCOLO
	dDataRec	:= oWSConsulta:oWSCONSULTACHAVENFERESULT:DRECBTO
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuto esse webservice para trazer o horario que a chaveณ
	//ณfoi autorizada ou cancelada na sefaz pelo fornecedor     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oWSConsulta:CONSULTADTCHAVENFE()
		cHoraRec := oWSConsulta:OWSCONSULTADTCHAVENFERESULT:CRECBTOTM
	EndIf
	
	If !Empty(cCodRet)
		If AllTrim(cCodRet) == "100"
			aRet := {.T., "AUTORIZADA"}
		ElseIf AllTrim(cCodRet) == "101"
			aRet := {.F., "CANCELADA"}
		Else
			aRet := {.F., ""}
		EndIf
	Else
		MsgInfo(cCodRet + "    -    " + cMsgRet + "    -    " + cChave)
	EndIf
Else
	aRet := {.F., ""}
	MsgInfo("Nใo Foi Possivel Estabelecer Comunica็ใo com a SEFAZ!")
EndIf

/*IF oWSConsulta:RetornaFX()
	nItens := Len( oWsNFeSBRA:oWsRetornaFxResult:oWsNotas:oWsNFES3 )
	
	For nItem := 1 To nItens
		XMLNFe := WsNFeSBRA:oWsRetornaFxResult:oWsNotas:oWsNFES3[nItem]:oWsNFE:cXML
		Exit
		
	Next nItem
EndIF*/

RestArea(aArea)

Return(aRet)