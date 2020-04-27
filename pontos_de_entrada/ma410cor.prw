#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410COR  �Autor  �Microsiga           � Data �  02/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada adiciona novas cores na legenda dos pedidos���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Template eCommerce                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410COR()

Local aCoresB := {}   

//���������������Ŀ
//�Padr�o Protheus�
//����������������� 

aAdd(aCoresB, { "C5_STATENT == '1' .And. Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"			,'BR_MARRON'	, "Pedido em Aberto c/ Entrega Parcial" 	})		//Pedido em Aberto c/ Entrega Parcial
aAdd(aCoresB, { "C5_STATENT == '1' .And. !Empty(C5_NOTA) "													,'BR_PINK'  	, "Pedido c/ NF Parcialmente Entregue"		})		//Pedido c/ NF Parcialmente Entregue
aAdd(aCoresB, { "C5_STATENT == '2' .And. !Empty(C5_NOTA) "													,'BR_PRETO'		, "Pedido c/ NF Totalmente Entregue"		})		//Pedido c/ NF Totalmente Entregue
aAdd(aCoresB, { "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. C5_STATENT == ' ' .and. C5_PEDPEND <> '2' "			,'ENABLE' 		, "Pedido em Aberto"	})		//Pedido em Aberto
aAdd(aCoresB, { "C5_NOTA=='XXXXXXXXX' .And. C5_LIBEROK=='S' .And. C5_BLQ==' ' .And. C5_STATENT==' ' "		,'BR_BRANCO'	, "Pedido com Elimina��o de Residuo"	})		//Pedido com Elimina��o de Residuo
aAdd(aCoresB, { "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ) .And. C5_STATENT == ' ' " 			,'DISABLE'		, "Pedido Encerrado"	})		//Pedido Encerrado
aAdd(aCoresB, { "C5_PEDPEND == '2' "																		,'BR_VIOLETA'	, "Pedido com Bloqueio Financeiro"	})		//Pedido com Bloqueio Financeiro
aAdd(aCoresB, { "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ) .And. C5_STATENT == ' ' "			,'BR_AMARELO'	, "Pedido Liberado"		})		//Pedido Liberado
aAdd(aCoresB, { "C5_BLQ == '1' .And. C5_STATENT == ' ' "													,'BR_AZUL'		, "Pedido Bloquedo por regra"	})		//Pedido Bloquedo por regra
aAdd(aCoresB, { "C5_BLQ == '2' .And. C5_STATENT == ' ' "													,'BR_LARANJA'	, "Pedido Bloquedo por verba"	})		//Pedido Bloquedo por verba

	
Return(aCoresB)