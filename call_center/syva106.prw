#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYVA106  � Autor � SYMM CONSULTORIA   � Data �  08/04/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Amarra��o Tabela de Preco x CPC.                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SYVA106()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ2"

dbSelectArea("SZ2")
dbSetOrder(1)

AxCadastro(cString,"Amarra��o Tabela de Preco x CPC",cVldExc,cVldAlt)

Return