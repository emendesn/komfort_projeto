/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT015TOK �Autor  � Vanito Rocha       � Data � 18/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueia usuarios nas altera��o do Status do Endere�o      ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT015TOK()

Local lRet:=.T.
Local xUser:=CUSERNAME
Local xAltEnd:=SuperGetMv("KH_USRALEN",.F.)


If SBE->BE_MSBLQL <> FwFldGet("BE_MSBLQL")
	If ! xUser $ xAltEnd 
		MsgAlert("Voce nao possui autorizacao para alterar o Status do Endereco", "Atencao")
		lRet:=.F.
	Endif
Endif
Return lRet
