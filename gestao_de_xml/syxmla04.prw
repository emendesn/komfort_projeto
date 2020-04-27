#Include "Protheus.ch"
#Include "FWPrintSetup.ch"

#Define CRLF Chr(13)+Chr(10)
#Define DMPAPER_A4 9
#Define IMP_PDF 6
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYXMLA04 �Autor  � LUIZ EDUARDO F.C.  � Data �  08/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a chave do XML recebido pela central de             ���
���          � recebimentos                                               ���
�������������������������������������������������������������������������͹��
���Uso       � GESTOR DE XML                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
//�������������������������������������������������������������������������Ŀ
//�Observacoes:                                                             �
//�- Para o funcionamento dessa rotina, e necessario que o servico de TSS   �
//�  esteja sendo executando.                                               �
//���������������������������������������������������������������������������
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

//������������������������������������������������������Ŀ
//�Chama o webservice para consultar o status da chave e �
//�retorna infomacoes para compor o PDF                  �
//��������������������������������������������������������
If oWSConsulta:ConsultaChaveNFE()
	
	cCodRet		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CCODRETNFE
	cDigVal		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CDIGVAL
	cMsgRet		:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CMSGRETNFE
	cProtocolo	:= oWSConsulta:oWSCONSULTACHAVENFERESULT:CPROTOCOLO
	dDataRec	:= oWSConsulta:oWSCONSULTACHAVENFERESULT:DRECBTO
	
	//���������������������������������������������������������Ŀ
	//�Executo esse webservice para trazer o horario que a chave�
	//�foi autorizada ou cancelada na sefaz pelo fornecedor     �
	//�����������������������������������������������������������
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
	MsgInfo("N�o Foi Possivel Estabelecer Comunica��o com a SEFAZ!")
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