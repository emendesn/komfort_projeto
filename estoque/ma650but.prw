/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA650BUT  �Autor  �Vanito Rocha        � Data �  19/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Incluir chamado para impress�o de relatorios epecifico    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA650BUT()
 
Aadd(aRotina,{"Imp..OP..Excel","U_KMHR225", 0 , 7})
Aadd(aRotina,{"Impress OP.","U_KMHR820", 0 , 7})                      
Aadd(aRotina,{"Transf. Saldo","U_KMHTRAN", 0 , 7})               
Aadd(aRotina,{"Impress. Req. Estoq.","U_KMHREL01", 0 , 7}) 
Aadd(aRotina,{"Imp. Req. PI por �rea.","U_KMHREL03", 0 , 7})       
                                                                           
Return aRotina