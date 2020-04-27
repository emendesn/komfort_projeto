#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT240TOK  �Autor  �Vanito Rocha        � Data �  12/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado para validar usuarios que       ���
���          � podem movimentar o armazem 95                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Mt240TOk()

Local _lRet := .T.
Local xUser:=SuperGetMv("KH_USRMVIN",.F.)

If !l240Auto //Verifica se nao e rotina automatica
	If M->D3_LOCAL="95" .AND. !cUsername $ xUser
		If SB1->B1_TIPO <> "PA"
			MsgStop('Voc� n�o possui autoriza��o para movimentar esse armazem, procure o gestor do PCP', "Atencao")
			_lRet := .F.
		EndIf
	Endif
EndIf

Return _lRet
