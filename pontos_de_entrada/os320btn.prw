#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �OS320BTN  �AUTOR: �Caio Garcia            �DATA: �10/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function OS320BTN()         

Local aButtons 	:= {}	
                                                                                            
AAdd(aButtons ,{ "Vis. Apont."		,	{|| StaticCall(OMSA320,OMS320AP)	}, "Vis. Apont.","Vis. Apont."})	

AAdd(aButtons ,{ "Exclui Apont."		,	{|| u_KMOMSF04()	}, "Exclui Apont.","Exclui. Apont."})	

Return(aButtons)   