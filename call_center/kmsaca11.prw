#include 'protheus.ch'
#include 'parmtype.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA11� Autor � Wellington         � Data �  01/11/18    ���
�������������������������������������������������������������������������͹��
���cadastro de comiss�o vendedores                                        ���
�������������������������������������������������������������������������͹��
���Uso       � 															  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

user function KMSACA11()
	Local cAlias := "ZK1"
	Local cTitulo := "Cadastro - Comiss�o"
	Local cVldExc := ".T."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)
	
return 