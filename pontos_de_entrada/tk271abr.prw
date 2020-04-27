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
			msgAlert("N�o � possivel alterar or�amento com pedido gerado.","Aten��o")
			Return .F.
		endif

		if SUA->UA_CANC == "S" .OR. SUA->UA_STATUS == "CAN"
			msgAlert("N�o � possivel alterar or�amento Cancelado.","Aten��o")
			Return .F.
		endif

		if empty(alltrim(SUA->UA_XATCRED)) .and. Alltrim(__cUserId) $ GrpCred
			RecLock("SUA",.F.)
				SUA->UA_XATCRED := usrRetName(__cUserId)
				SUA->UA_XSTATUS := "2" //EM ATENDIMENTO
			SUA->(Msunlock())
			MsUnlockAll()
		endif

		//Se o Status for 5- Reanalise qualquer usuario do credito pode assumir o Or�amento
		if SUA->UA_XSTATUS == "5" .and. Alltrim(__cUserId) $ GrpCred
			if MsgYesNo("O or�amento Ja Encontra-se em atendimento por Usuario."+ CRLF;
						+ "Usuario responsavel: "+alltrim(UA_XATCRED)+"."+ CRLF;
						+ "Deseja Assumir o atendimento do or�amento ?","Aten��o")

//				RecLock("SUA",.F.) // Realizado comentario conforme solicita��o ( 7T7-AAG-A7RQ (N�mero do ticket: 8085))
//					SUA->UA_XATCRED := usrRetName(__cUserId)
//				SUA->(Msunlock())
				MsUnlockAll()
			else
				Return .F.
			endif
		endif
		//Se o usuario logado for igual ao atendente responsavel pelo or�amento	
		if Alltrim(usrRetName(__cUserId)) == alltrim(SUA->UA_XATCRED)
			Return .T.
		endif
		//Se o usuario logado N�o for igual ao atendente responsavel pelo or�amento e for do Credito
		//if !Alltrim(usrRetName(__cUserId)) == alltrim(UA_XATCRED) .and. Alltrim(__cUserId) $ GrpCred
		//	msgAlert("O or�amento Ja Encontra-se em atendimento."+ CRLF;
		//				+ "Atendente responsavel: "+alltrim(UA_XATCRED)+".","Aten��o")
		//	Return .F.
		//endif
		//Se For vendedor, pode alterar o or�amento
		If !Empty(SUA->UA_XSTATUS) .and. ! Alltrim(__cUserId) $ GrpCred	
			If SUA->UA_XSTATUS =='4' 
				Return .T.
			else
				cMsg:="Apenas Propostas com Status Sugerido podem ser alterada."+ CRLF;
				 		+"Solicite libera��o do Departamento de Cr�dito!"
				 		Aviso("Sistemas Protheus",cMsg,{"Fechar"},2,"Departamento de Cr�dito",,,.F.,5000)
				Return .F.			
		    EndIf
		EndIf
	endif

Return
