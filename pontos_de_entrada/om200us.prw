#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM200US   �Autor  �Microsiga           � Data �  05/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �  PONTO DE ENTRADA PARA ADICIONAR DADOS NO AROTINA          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function OM200US()

AAdd( aRotina, { "Associa NF x Carga", "U_KMOMSF01()", 0, 2 } )
AAdd( aRotina, { "Observa��o Carga"  , "U_KMOMSF02()", 0, 2 } )
AAdd( aRotina, { "Termo Retira x Carga", "U_KMOMSF03()", 0, 2 } )
AAdd( aRotina, { "Acrescenta Serv/Frete", "U_KMOMSF05()", 0, 2 } )

Return(aRotina)     