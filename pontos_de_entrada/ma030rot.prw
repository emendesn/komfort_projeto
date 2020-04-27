#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA410MNU � Autor � Eduardo Patriani   � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada disparado antes da abertura do Browse na  ���
���          � rotina de Cadastro de Cliente.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
��������������������������������������������������������������������������*/

User Function MA030ROT()

Local _aArea	:= GetArea()
Local aRetorno	:= {}

AAdd(aRetorno,	{'Alterar Pend�ncia'	,"U_KMFRA05()"		, 0 , 4 , 0 , NIL   })

If nModulo==6
	
	AAdd(aRetorno,	{'Hist. Financeiro'		,"U_KHHISFIN()"		, 0 , 4 , 0 , NIL   })
	
Endif

RestArea(_aArea)

Return( aRetorno )
