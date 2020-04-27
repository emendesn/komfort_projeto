// #########################################################################################
// Projeto:CASA CENARIO
// Modulo :CALL CENTER - VALIDACAO DO CAMPO UB_VRUNIT
// Fonte  : A273VLD7
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 04/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
//{Protheus.doc} novo
//Montagem da tela de processamento

//@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
//@version   1.00
//@since     4/06/2014


User Function A273VLD7()

Local aArea 	:= GetArea()
Local nPPrcVen	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Local nPTabela	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01TABPA"})
Local nPProd	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Local nPPrcTab	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRCTAB"})
Local cConteudo	:= &(ReadVar())
Local nPrcTab	:= 0
Local lRet		:= .T.

DA1->( DbSetOrder(1) )
DA1->( DbSeek( xFilial("DA1") + aCols[n,nPTabela] + aCols[n,nPProd] ) )

If cConteudo < DA1->DA1_PRCVEN
	MsgAlert("O preço informado é menor que o preço de tabela.","Atenção")
	lRet := .F.
Endif

If lRet
	aCols[n,nPPrcTab] := DA1->DA1_PRCVEN
	Eval(bGDRefresh)
Endif

RestArea(aArea)

Return(lRet)
