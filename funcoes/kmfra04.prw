#Include "Protheus.Ch"
#Include "topconn.Ch"
#Include 'TbiConn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KMFRA04   ºAutor  ³Rafael Cruz                ³  11/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que efetua a atualização do campo pendência         º±±
±±º          ³ financeira do pedido de vendas. 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ komfort          										  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function KMFRA04()

Local lGrpCrd 	:= IIF(__cUserID $ SuperGetMv("KH_KMFRA04",.F.,"000000"),.T.,.F.)
Local _aArea  	:= GetArea()
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6 := SC6->(GetArea())
 
If !lGrpCrd
	Msgstop("Seu usuário não possui acesso p/ realizar esta operação.","Acesso Negado")
	Return
EndIf 

If C5_NOTA <> ' '
	Msgstop("O pedido " + SC5->C5_NUM + " já foi finalizado.")
	Return
EndIf

If C5_PEDPEND <> "2"
	If Aviso("Bloqueio de Pedido","Confirma a inclusão da pendência financeira no PV n.° " + SC5->C5_NUM + " ?",{"Sim","Não"},1) == 1
		RecLock("SC5",.F.)
			C5_PEDPEND := "2"
		SC5->(MsUnLock())
		SC6->(dbGoTop())
		SC6->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
		While SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA == SC5->C5_FILIAL + SC5->C5_NUM + SC5->C5_CLIENT + SC5->C5_LOJACLI 
			RecLock("SC6",.F.)
				C6_PEDPEND := "2"
			SC6->(MsUnLock())
			SC6->(dbSkip())
		Enddo
		MsgInfo("Registro atualizado com sucesso!","Término")
	EndIf
Else
	If Aviso("Desbloqueio de Pedido","Confirma a liberação da pendência financeira do PV n.° " + SC5->C5_NUM + " ?",{"Sim","Não"},1) == 1
		If C5_XCONPED == "1"		
			RecLock("SC5",.F.)
				C5_PEDPEND := "3"
			SC5->(MsUnLock())
			SC6->(dbGoTop())
			SC6->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
			While SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA == SC5->C5_FILIAL + SC5->C5_NUM + SC5->C5_CLIENT + SC5->C5_LOJACLI 
				RecLock("SC6",.F.)
					C6_PEDPEND := "3"
				SC6->(MsUnLock())
				SC6->(dbSkip())
			Enddo
			MsgInfo("Registro atualizado com sucesso!","Término")
		Else
			RecLock("SC5",.F.)
				C5_PEDPEND := "4"
			SC5->(MsUnLock())
			SC6->(dbGoTop())
			SC6->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
			While SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA == SC5->C5_FILIAL + SC5->C5_NUM + SC5->C5_CLIENT + SC5->C5_LOJACLI 
				RecLock("SC6",.F.)
					C6_PEDPEND := "4"
				SC6->(MsUnLock())
				SC6->(dbSkip())
			Enddo
			MsgInfo("Registro atualizado com sucesso!","Término")		
		EndIf
	EndIf
EndIf

MsUnLockAll()
RestArea(_aArea)
RestArea(_aAreaSC5)
RestArea(_aAreaSC6)

Return