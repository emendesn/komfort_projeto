#Include "Protheus.Ch"
#Include "topconn.Ch"
#Include 'TbiConn.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFRA04   �Autor  �Rafael Cruz                �  18/09/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que efetua a atualiza��o do percentual de bloqueio  ���
���          � da pend�ncia financeira do pedido de vendas. 			  ���
�������������������������������������������������������������������������͹��
���Uso       � komfort          										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMFRA06()

Local GrpCred	:= SuperGetMV("MV_KOGRPLB",.F.,"000000")
Local cTipoAt	:= TkGetTipoAte()
Local nValPerLib:= SUA->UA_XPERLIB
Local lRet		:= .F.

If !Empty(SUA->UA_CANC)
	MsgStop("A proposta est� cancelada.","Pend�ncia Financeira")
	Return
EndIf

If SUA->UA_OPER <> "1"
	MsgStop("A proposta � um or�amento.","Pend�ncia Financeira")
	Return
EndIf

If !ProcSl4(SUA->UA_NUM)
	MsgStop("A proposta n�o possui crit�rios p/ bloqueio.","Pend�ncia Financeira")
	Return
EndIf

If cTipoAt == "2"
	If Alltrim(__cUserId) $ GrpCred
		nValPerLib := StaticCall(TMKVPEDI,fPerLib, @nValPerLib)
		if !(nValPerLib == 0)
			lRet := .T.
		endIf
	Else
		MsgStop("Usu�rio sem permiss�o para realizar esta opera��o.","Pend�ncia Financeira")
		Return
	EndIf
Else
	MsgAlert("Op��o dispon�vel apenas no TELEVENDAS.","Pend�ncia Financeira")
	Return
EndIf

If lRet
	RecLock("SUA",.F.)
		SUA->UA_XPERLIB := nValPerLib
		SUA->UA_PEDPEND := "2"
	Msunlock()
	
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	SC5->(dbGoTop())
		
	dbSelectArea("SC6")
	SC6->(dbGoTop())
	
	if SC5->(dbSeek(xFilial("SC5") + SUA->UA_NUMSC5))
		RecLock("SC5",.F.)
			C5_PEDPEND := "2"
			C5_XPERLIB := nValPerLib
		SC5->(MsUnLock())
		SC6->(dbGoTop())
		SC6->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
		While SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA == SC5->C5_FILIAL + SC5->C5_NUM + SC5->C5_CLIENT + SC5->C5_LOJACLI 
			RecLock("SC6",.F.)
				C6_PEDPEND := "2"
			SC6->(MsUnLock())
			SC6->(dbSkip())
		Enddo
		
		//-----------------------------------------------------------------------------
		//Grava��o de log de altera��o da Pendencia Financeira. 
		//N�mero do ticket: 13503
		dbSelectArea("Z35")
		RecLock("Z35", .T.)
		  	Z35_FILIAL := SC5->C5_FILIAL
		   	Z35_PEDIDO := SC5->C5_NUM
		   	Z35_DATA   := dDataBase 
		   	Z35_HORA   := Time()
		   	Z35_STATUS := SC5->C5_PEDPEND
		   	Z35_PERLIB := nValPerLib
		   	Z35_USER   := LogUsername()
		   	Z35_ROTINA := "KMFRA06"
		Z35->(MsUnlock())
		Z35->(dbCloseArea())
		//-------------------------------------------------------------------------------	
	endIf
	SC5->(dbCloseArea())
	SC6->(dbCloseArea())
Else
	MsgAlert("Verifique o percentual digitado.","Percentual Inv�lido")
EndIf

Return

Static Function ProcSl4(cAtende)

	Local _aAreaSL4 := SL4->(GetArea())
	Local lRet		:= .F.
	Local cQuery	:= ""
	Local cForma	:= SuperGetMv("KH_FPAGTO",.F.,"TR|TE|DO|DC")

	SL4->(DbSetOrder(1))
	If SL4->(DbSeek(xFilial("SL4") + cAtende + "SIGATMK" ))
		While SL4->(!Eof()) .And. SL4->L4_FILIAL + SL4->L4_NUM+Alltrim(SL4->L4_ORIGEM) == xFilial("SL4") + cAtende + "SIGATMK"	
			If LEFT(SL4->L4_FORMA,2) $ cForma
				lRet := .T.
				Exit
			Endif
			SL4->(DbSkip())
		Enddo
	Endif

Return lRet