#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA410MNU � Autor � Eduardo Patriani   � Data �  20/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada disparado antes da abertura do Browse na  ���
���          � rotina de pedidos de venda.                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA410MNU()

Local aArea := GetArea()

AAdd(aRotina,{'Confirmar Entrega'	,'U_SYVA104()'  	, 0 , 6 , 0 , Nil	})   
AAdd(aRotina,{'Reenvio de e-mail'	,"U_AtraWorkflow()"	, 0 , 4	, 0	, NIL 	})
AAdd(aRotina,{'Alterar Pend�ncia'	,"U_KMFRA04()"		, 0 , 4 , 0 , NIL   })   
AAdd(aRotina,{'Ajusta Filial'	    ,"U_KMFATF03()"		, 0 , 4 , 0 , NIL   })   //#CMG20181108.n
AAdd(aRotina,{'Prioridade'	        ,"U_KHFAT001()"		, 0 , 4 , 0 , NIL   })

RestArea(aArea)

Return
