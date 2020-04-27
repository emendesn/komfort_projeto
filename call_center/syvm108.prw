// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : SYVM108
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 12/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     12/06/2014
/*/
//------------------------------------------------------------------------------------------
User Function SYVM108()

Local aArea 		:= GetArea()
Local cAlias   		:= GetNextAlias()
Local cQuery 		:= ""
Local nPProd		:= 0
Local cProduto		:= ""
Local cDescricao	:= ""
Local cLocal		:= ""
Local aHead1		:= {}
Local aCols1		:= {}
Local aPosObj  		:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aInfo     	:= {}
Local nQtdPrev		:= 0

Local oGetD1
Local oDlg
Local nSaldoPed := 0 //Quantidade de itens em pedidos de venda em aberto

DbSelectArea("SB2") 

//#AFD20180620.BN
If nFolder == 2
	nPProd	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
	cProduto := aCols[n,nPProd]
else                                                              
	nPProd	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UD_PRODUTO"})
	cProduto := aCols[n,nPProd]
endif
//#AFD20180620.EN

Aadd(aHead1,{RetTitle('B2_FILIAL')	,'FILIAL'		,PesqPict('SB2','B2_FILIAL')	,TamSx3('B2_FILIAL' )[1]	,X3Decimal('B2_FILIAL' )	,'','','C','','',''})
Aadd(aHead1,{RetTitle('B2_COD')		,'CODIGO'		,PesqPict('SB2','B2_COD')		,TamSx3('B2_COD' )[1]		,X3Decimal('B2_COD' )		,'','','C','','',''})
Aadd(aHead1,{RetTitle('B1_DESC')	,'DESCRICAO'	,PesqPict('SB1','B1_DESC')		,50 /*TamSx3('B1_DESC' )[1]*/	,X3Decimal('B1_DESC' )	,'','','C','','',''})
Aadd(aHead1,{RetTitle('B1_01FORAL')	,'FORA_LINHA'	,PesqPict('SB1','B1_01FORAL')	,TamSx3('B1_01FORAL' )[1]	,X3Decimal('B1_01FORAL' )	,'','','C','','',''})
Aadd(aHead1,{RetTitle('B2_LOCAL')	,'LOCAL'		,PesqPict('SB2','B2_LOCAL')		,TamSx3('B2_LOCAL' )[1]	,X3Decimal('B2_LOCAL' )	,'','','C','','',''})
Aadd(aHead1,{RetTitle('B2_QATU')	,'ESTOQUE'		,PesqPict('SB2','B2_QATU')		,TamSx3('B2_QATU' )[1]	,X3Decimal('B2_QATU' )	,'','','N','','',''})
Aadd(aHead1,{''						,''				,PesqPict('SB1','B1_DESC')		,TamSx3('B1_DESC' )[1]	,X3Decimal('B1_DESC' )	,'','','C','','',''})

cQuery += " SELECT SB2.B2_FILIAL FILIAL, SB2.B2_COD CODIGO,SB1.B1_DESC DESCRICAO,SB2.B2_LOCAL LOCAL, "
cQuery += " CASE WHEN B1_01FORAL = 'F' THEN 'SIM' ELSE 'NÃO' END AS FORA_DE_LINHA, "
//cQuery += " (SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + SB2.B2_QPEDVEN)) AS ESTOQUE " //#AFD20181010.O
cQuery += " (SB2.B2_QATU) AS ESTOQUE"// - (SB2.B2_QEMP + SB2.B2_RESERVA)) AS ESTOQUE " //#AFD20181010.N
cQuery += " FROM "+RetSqlName("SB2")+" SB2 " 
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SB2.B2_COD AND SB1.D_E_L_E_T_ = '' " 
cQuery += " WHERE SB1.B1_COD = '"+cProduto+"' "
//cQuery += " AND SB2.B2_LOCAL = '01' "
cQuery += " AND SB2.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY B2_FILIAL,B2_COD,B2_LOCAL "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
		
	Aadd(aCols1,Array(Len(aHead1)+1))
	nPos := Len(aCols1)
	
	nQtdPrev := 0 //U_A273VLDE(PADR((cAlias)->CODIGO,TAMSX3("B1_COD")[1]))
		
	aCols1[nPos,1] := (cAlias)->FILIAL+"-"+POSICIONE("SM0",1,cEmpAnt+(cAlias)->FILIAL,"M0_FILIAL")
	aCols1[nPos,2] := (cAlias)->CODIGO
	aCols1[nPos,3] := alltrim((cAlias)->DESCRICAO)
	aCols1[nPos,4] := (cAlias)->FORA_DE_LINHA
	aCols1[nPos,5] := (cAlias)->LOCAL
	//aCols1[nPos,5] := If( ((cAlias)->ESTOQUE+nQtdPrev) > 0,(cAlias)->ESTOQUE+nQtdPrev , 0 )
	
	nSaldoPed := fPedidos((cAlias)->CODIGO,(cAlias)->LOCAL)
	
	if nSaldoPed >= (cAlias)->ESTOQUE
		aCols1[nPos,6] := 0
	else
		aCols1[nPos,6] := (cAlias)->ESTOQUE - nSaldoPed
	endif
	
	aCols1[nPos,7] := ""

	aCols1[nPos,Len(aHead1)+1] := .F.		
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

If Len(aCols1)==0
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + cProduto))
	AAdd(aCols1 ,{xFilial("SUA"),cProduto,SB1->B1_DESC,SB1->B1_LOCPAD,0,.F.} )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 070, 100, .F., .T. } )
AAdd( aObjects, { 100, 015, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialogo.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE "Consulta de Estoque(s)" FROM 0,0 TO 320,1050 OF oMainWnd PIXEL

oFwLayerRes:= FwLayer():New()
oFwLayerRes:Init(oDlg,.T.)
oFwLayerRes:addLine("CONSULTA",095,.F.)
oFwLayerRes:addCollumn( "COL1",100,.T.,"CONSULTA")
oFWLayerRes:addWindow ( "COL1", "WIN1","Produto(s)",100,.T.,.F.,,"CONSULTA")

oPanel2:= oFwLayerRes:GetWinPanel("COL1","WIN1","CONSULTA")

oGetD1:=MsNewGetDados():New(0,0,0,0,0,"Allwaystrue","AllWaysTrue","",,,Len(aCols1),,,,oPanel2,@aHead1,@aCols1)
oGetD1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| oDlg:End() }, {||  oDlg:End() },,) )

RestArea(aArea)

Return

//Consulta pedidos de vendas em aberto
Static Function fPedidos(cProduto,cLocal)

	Local cQuery := ""
	Local cAliasSaldo := GetNextAlias()
	Local nSaldo := 0

	cQuery := "SELECT (CASE WHEN SUM(C6_QTDVEN) IS NULL THEN 0 ELSE SUM(C6_QTDVEN) END) AS PEDIDOS_VENDA"
	cQuery += "FROM "+ retSqlName("SC6")
	cQuery += "WHERE C6_PRODUTO = '"+cProduto+"'"
	cQuery += "AND C6_LOCAL = '"+cLocal+"'"
	cQuery += "AND C6_CLI != '000001'"
	cQuery += "AND C6_NOTA = ''"
	cQuery += "AND C6_BLQ = ''"
	cQuery += "AND D_E_L_E_T_ = ' '"

	plsQuery(cQuery,cAliasSaldo)	
		
	if (cAliasSaldo)->(!eof())
		if (cAliasSaldo)->PEDIDOS_VENDA > 0 
			nSaldo := (cAliasSaldo)->PEDIDOS_VENDA
		else
			nSaldo := 0
		endif
	endif

	(cAliasSaldo)->(dbCloseArea())

Return nSaldo