#Include "Protheus.Ch"
#Include "topconn.Ch"
#Include 'TbiConn.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �KMFRA05   �Autor  �Rafael Cruz                �  11/09/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que efetua a atualiza��o do campo pend�ncia         ���
���          � financeira do cadastro do cliente.						  ���
�������������������������������������������������������������������������͹��
���Uso       � komfort          										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMFRA05()

Local lGrpCrd := IIF(__cUserID $ SuperGetMv("KH_KMFRA05",.F.,"000000"),.T.,.F.)

If !lGrpCrd
	Msgstop("Seu usu�rio n�o possui acesso p/ realizar esta opera��o.","Acesso Negado")
	Return
EndIf 

//#RVC20180912.bo
/*If A1_01PEDFI <> "1"
	Msgstop("O Cliente " + SA1->A1_COD + "/" + SA1->A1_LOJA + " n�o possui pend�ncia financeira.","Pend�ncia Financeira")
	Return
EndIF*/
//#RVC20180912.eo

//#RVC20180912.bn
If A1_MSBLQL == "1"
	Msgstop("O Cliente " + SA1->A1_COD + "/" + SA1->A1_LOJA + " est� bloqueado.","A1_MSBLQL")
	Return
EndIF
//#RVC20180912.en

If Aviso("Pend�ncia Financeira","Confirma a atualiza��o do Cliente n.� " + SA1->A1_COD +"/" + SA1->A1_LOJA + " ?",{"Sim","N�o"},1) == 1
	If A1_01PEDFI <> "1"
		RecLock("SA1",.F.)
			A1_01PEDFI := "1"
		SA1->(MsUnLock())
		MsgInfo("Registro atualizado com sucesso!","T�rmino")
	Else
		RecLock("SA1",.F.)
			A1_01PEDFI := "2"
		SA1->(MsUnLock())
		MsgInfo("Registro atualizado com sucesso!","T�rmino")	
	EndIf
EndIf

Return