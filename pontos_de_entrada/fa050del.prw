/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050DeL  �Autor  �Vanito Rocha        � Data �  14/03/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail de exclus�o de t�tulos	 ���
���          � Administrador                                              ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050Del()
Local lRet:=.T.
Local xAssunto:="Exclus�o de T�tulos contas a pagar"
Local  xMail:="marcio.nunes@komforthouse.com.br;vanito.rocha@hotmail.com;mohammed.sinno@komforthouse.com.br"
Local xMsg:={"O t�tulo de Prefixo:  "  +  E2_PREFIXO  +  "  Numero:   " +  E2_NUM + "   Valor:   R$  " + Str(E2_VALOR,16,2) + "  foi excluido por  " + cUserName }

If nModulo == 06
   If FunName() == "'FINA050" .OR. FunName() == "'FINA040"
			u_MailNotify(xMail,"",xAssunto,xMsg,{},.T.)
	Endif
Endif
Return lRet
