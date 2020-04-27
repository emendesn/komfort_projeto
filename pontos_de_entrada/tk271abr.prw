#Include "protheus.ch"
#Include "topconn.ch"
#Include "totvs.ch"

User Function TK271ABR()

	Local GrpCred	:= SuperGetMV("MV_KOGRPLB",.F.,"000000")
	Local cTipoAt	:= TkGetTipoAte()

	if ALTERA .and. cTipoAt == "2" 
		
		//#CMG20181311.bn
		 //If !Alltrim(__cUserId) $ GrpCred
			//SUA->UA_PEDPEND := "4"
		 // EndIf
		//#CMG20181311.en
				
		if !empty(alltrim(SUA->UA_NUMSC5))
			msgAlert("Não é possivel alterar orçamento com pedido gerado.","Atenção")
			Return .F.
		endif

		if SUA->UA_CANC == "S" .OR. SUA->UA_STATUS == "CAN"
			msgAlert("Não é possivel alterar orçamento Cancelado.","Atenção")
			Return .F.
		endif

		if empty(alltrim(SUA->UA_XATCRED)) .and. Alltrim(__cUserId) $ GrpCred
			RecLock("SUA",.F.)
				SUA->UA_XATCRED := usrRetName(__cUserId)
				SUA->UA_XSTATUS := "2" //EM ATENDIMENTO
			SUA->(Msunlock())
			MsUnlockAll()
		endif

		//Se o Status for 5- Reanalise qualquer usuario do credito pode assumir o Orçamento
		if SUA->UA_XSTATUS == "5" .and. Alltrim(__cUserId) $ GrpCred
			if MsgYesNo("O orçamento Ja Encontra-se em atendimento por Usuario."+ CRLF;
						+ "Usuario responsavel: "+alltrim(UA_XATCRED)+"."+ CRLF;
						+ "Deseja Assumir o atendimento do orçamento ?","Atenção")

//				RecLock("SUA",.F.) // Realizado comentario conforme solicitação ( 7T7-AAG-A7RQ (Número do ticket: 8085))
//					SUA->UA_XATCRED := usrRetName(__cUserId)
//				SUA->(Msunlock())
				MsUnlockAll()
			else
				Return .F.
			endif
		endif
		//Se o usuario logado for igual ao atendente responsavel pelo orçamento	
		if Alltrim(usrRetName(__cUserId)) == alltrim(SUA->UA_XATCRED)
			Return .T.
		endif
		//Se o usuario logado Não for igual ao atendente responsavel pelo orçamento e for do Credito
		//if !Alltrim(usrRetName(__cUserId)) == alltrim(UA_XATCRED) .and. Alltrim(__cUserId) $ GrpCred
		//	msgAlert("O orçamento Ja Encontra-se em atendimento."+ CRLF;
		//				+ "Atendente responsavel: "+alltrim(UA_XATCRED)+".","Atenção")
		//	Return .F.
		//endif
		//Se For vendedor, pode alterar o orçamento
		If !Empty(SUA->UA_XSTATUS) .and. ! Alltrim(__cUserId) $ GrpCred	
			If SUA->UA_XSTATUS =='4' 
				Return .T.
			else
				cMsg:="Apenas Propostas com Status Sugerido podem ser alterada."+ CRLF;
				 		+"Solicite liberação do Departamento de Crédito!"
				 		Aviso("Sistemas Protheus",cMsg,{"Fechar"},2,"Departamento de Crédito",,,.F.,5000)
				Return .F.			
		    EndIf
		EndIf
	endif

Return
