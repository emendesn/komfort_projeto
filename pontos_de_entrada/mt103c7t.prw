#INCLUDE "Protheus.ch"                                                       

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �MT103C7T  �AUTOR: �Caio Garcia            �DATA: �10/10/18  ���
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

User Function MT103C7T()

Local nLinIni := PARAMIXB[1,1] // Posicao inicial da linha da janela
Local nColIni := PARAMIXB[1,2] // Posicao inicial da coluna da janela
Local nLinFim := PARAMIXB[1,3] // Posicao final da linha da janela
Local nColFim := PARAMIXB[1,4] // Posicao final da coluna da janela
Local aRet := {}

aRet := {nLinIni,nColIni,nLinFim+300,nColFim+800}

Return aRet