#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �	TMKCPG  �Autor  � SYMM CONSULTORIA   � Data �  10/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado antes da abertura da tela de     ���
���          �condi��o de pagamento.	                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKVCP(	 cCodTransp	, oCodTransp	, cTransp	, oTransp,;
						 cCob		, oCob			, cEnt		, oEnt,;
						 cCidadeC	, oCidadeC		, cCepC		, oCepC,;
						 cUfC		, oUfC			, cBairroE	, oBairroE,;
						 cBairroC	, oBairroC		, cCidadeE	, oCidadeE,;
						 cCepE		, oCepE			, cUfE		, oUfE,;
						 nOpc		, cNumTlv		, cCliente	, cLoja,;
						 cCodPagto	, aParcelas)
						 
Local aArea := GetArea() 

If __cCondPg <> cCodPagto

	MsgStop("Como foi modificado a condi��o de pagamento inicial, os descontos ser�o zerados.","Aten��o")

	U_A273VLD2()

Endif

__cCondPg := Nil

RestArea(aArea)						 

Return