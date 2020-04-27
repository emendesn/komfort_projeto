#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M440STTS  �Autor  �Gilberto            � Data �  09/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na liberacao de pedido.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
���Obs.      � Compatibilizado por: Rafael Cruz - Komfort House           ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function M440STTS()
	Local _aArea	:= GetArea()
	Local _aArSC5	:= SC5->(GetArea())
	Local _aArSC6	:= SC6->(GetArea())
	Local _aArSC9	:= SC9->(GetArea())
	
	If cEmpAnt $ SuperGetMV("KH_440STTS",.T.,"01|02")
		If SC6->( FieldPos("C6_XPRTBKP") > 0 .And. FieldPos("C6_XPDSBKP") > 0 .And.FieldPos("C6_XVDSBKP") > 0)
			PL195G()
		Else
			ConOut("M440STTS - KH_440STTS - Os campos C6_XPRTBKP, C6_XPDSBKP e C6_XVDSBKP nao existem")
		EndIf
	EndIf

	RestArea(_aArSC9)
	RestArea(_aArSC6)
	RestArea(_aArSC5)
	RestArea(_aArea)

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PL195G    �Autor  �Rafael Rosa da Silva� Data �  12/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que grava os campos de percentual e valor do desconto���
���          �e pre�o de tabela em campos de backup para depois zer�-los  ���
�������������������������������������������������������������������������͹��
���Uso       � DOVAC - Tratamento de Desconto para a DANFE				  ���
�������������������������������������������������������������������������ͼ��
���Obs.      � Compatibilizado por: Rafael Cruz - Komfort House			  ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PL195G()

	Local _aArea	:= GetArea()
	Local _aAreaSC6	:= SC6->( GetArea() )

	dbSelectarea("SC6")
	dbSetOrder(1)	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
		While !SC6->( Eof() ) .And. xFilial("SC6") + SC5->C5_NUM == SC6->C6_FILIAL + SC6->C6_NUM .And. SC6->C6_XPRTBKP == 0
			RecLock("SC6",.F.)
			SC6->C6_XPRTBKP	:= SC6->C6_PRUNIT
			SC6->C6_XPDSBKP	:= SC6->C6_DESCONT
			SC6->C6_XVDSBKP	:= SC6->C6_VALDESC
			SC6->C6_DESCONT	:= 0
			SC6->C6_VALDESC	:= 0
			SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
			SC6->( MsUnLock() )
			SC6->( dbSkip() )
		End
	EndIf

	RecLock("SC5",.F.)
	SC5->C5_XSTATUS	:= "4"
	SC5->( MsUnLock() )

	RestArea(_aArea)
	RestArea(_aAreaSC6)

Return

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)

	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor

	Do Case
		Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
		Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
		OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	EndCase

	If "MP8" $ oApp:cVersion
		//���������������������������Ŀ
		//�Tratamento para tema "Flat"�
		//�����������������������������
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf

Return Int(nTam)