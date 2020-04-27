#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG  �Autor  �Microsiga           � Data �  02/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada adiciona cores a legenda                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Template eCommerce                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410LEG()
Local aCoresB	:= {}

//���������������Ŀ
//�Padr�o Protheus�
//����������������� 
aAdd(aCoresB, { "ENABLE"		,"Pedido em Aberto" 				})	//Pedido em Aberto
aAdd(aCoresB, { "DISABLE"		,"Pedido encerrado"					})	//Pedido Encerrado
aAdd(aCoresB, { "BR_AMARELO"	,"Pedido Liberado"					})	//Pedido Liberado
aAdd(aCoresB, { "BR_AZUL"		,"Pedido Bloquedo por regra" 		})	//Pedido Bloquedo por regra
aAdd(aCoresB, { "BR_LARANJA"	,"Pedido Bloquedo por verba"		})	//Pedido Bloquedo por verba
aAdd(aCoresB, { 'BR_PINK'		,"Pedido Parcialmente Entregue"		})	//Pedido Parcialmente Entregue
aAdd(aCoresB, { "BR_PRETO"		,"Pedido Totalmente Entregue"		})	//Pedido Totalmente Entregue
aAdd(aCoresB, { "BR_MARRON"		,"Pedido em Aberto com Entrega(s)"	})	//Pedido Aberto com Entrega
aAdd(aCoresB, { "BR_VIOLETA"	,"Pedido com Bloqueio Financeiro"	})	//Pedido com Bloqueio Financeiro
aAdd(aCoresB, { "BR_BRANCO"	    ,"Pedido com Elimina��o de Residuo"	})	//Pedido com Elimina��o de Residuo

Return(aCoresB)
