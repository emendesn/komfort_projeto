#Include "Protheus.Ch"
#Include "topconn.Ch"
#Include 'TbiConn.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFRA04   �Autor  �Rafael Cruz                �  11/09/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que efetua a atualiza��o do campo pend�ncia         ���
���          � financeira do pedido de vendas. 							  ���
�������������������������������������������������������������������������͹��
���Uso       � komfort          										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMFRA04()

Local lGrpCrd 	:= IIF(__cUserID $ SuperGetMv("KH_KMFRA04",.F.,"000000"),.T.,.F.)
Local _aArea  	:= GetArea()
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6 := SC6->(GetArea())
 
If !lGrpCrd
	Msgstop("Seu usu�rio n�o possui acesso p/ realizar esta opera��o.","Acesso Negado")
	Return
EndIf 

If C5_NOTA <> ' '
	Msgstop("O pedido " + SC5->C5_NUM + " j� foi finalizado.")
	Return
EndIf

If C5_PEDPEND <> "2"
	If Aviso("Bloqueio de Pedido","Confirma a inclus�o da pend�ncia financeira no PV n.� " + SC5->C5_NUM + " ?",{"Sim","N�o"},1) == 1
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
		MsgInfo("Registro atualizado com sucesso!","T�rmino")
	EndIf
Else
	If Aviso("Desbloqueio de Pedido","Confirma a libera��o da pend�ncia financeira do PV n.� " + SC5->C5_NUM + " ?",{"Sim","N�o"},1) == 1
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
			MsgInfo("Registro atualizado com sucesso!","T�rmino")
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
			MsgInfo("Registro atualizado com sucesso!","T�rmino")		
		EndIf
	EndIf
EndIf

MsUnLockAll()
RestArea(_aArea)
RestArea(_aAreaSC5)
RestArea(_aAreaSC6)

Return