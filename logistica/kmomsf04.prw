#include 'protheus.ch'
#include 'parmtype.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �KMOMSF04  �AUTOR: �Caio Garcia            �DATA: �25/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Logistica - Komfort House                                  ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

user function KMOMSF04()

	LOCAL _cCarga:=DAK->DAK_COD

	IF DAK->DAK_ACECAR == '2'

		IF MSGYESNO ("Deseja excluir apontamento da carga "+_cCarga+"?", "APAGA")

			DBSELECTAREA("DAH")
			DAH->(DBSETORDER(1)) //DAH_FILIAL+DAH_CODCAR+DAH_SEQCAR+DAH_SEQUEN                                                                                                                     
			DAH->(DBGOTOP())
			DAH->(DBSEEK(XFILIAL("DAH")+_cCarga))

			WHILE DAH->(!EOF()) .AND. XFILIAL("DAH") == DAH->DAH_FILIAL .AND. _cCarga ==DAH->DAH_CODCAR

			alert("PASSOU")

				RECLOCK("DAH",.F.)

				DAH->(DBDELETE())

				DAH->(MSUNLOCK())

				DAH->(DBSKIP())

			ENDDO 

		ENDIF

	ELSE

		MSGSTOP("Carga ja encerrada", "Aviso")

	ENDIF

return