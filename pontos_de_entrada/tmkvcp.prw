#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ	TMKCPG  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada executado antes da abertura da tela de     บฑฑ
ฑฑบ          ณcondi็ใo de pagamento.	                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	MsgStop("Como foi modificado a condi็ใo de pagamento inicial, os descontos serใo zerados.","Aten็ใo")

	U_A273VLD2()

Endif

__cCondPg := Nil

RestArea(aArea)						 

Return