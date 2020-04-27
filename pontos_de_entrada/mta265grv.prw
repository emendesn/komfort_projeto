#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ENTER CHR(13)+CHR(10)

User Function MTA265GRV()
Local cQuery:=""
Local aArea   	:= GetArea()
Local _cAlias
Local _dbDoc:=SDB->DB_DOC
Local _dbSerie:=SDB->DB_SERIE


//Pega todos os produto do documento que foi ender~çado
cQuery := " SELECT DB_DOC, DB_LOCAL, DB_PRODUTO, DB_LOCALIZ, DB_QUANT " + ENTER
cQuery += " FROM SDB010 (NOLOCK) WHERE D_E_L_E_T_ = ' ' AND DB_ESTORNO='' " + ENTER
cQuery += "	AND DB_DOC = '"+ _dbDoc +"' AND DB_SERIE = '"+ _dbSerie +"'" + ENTER


_cAlias := getNextAlias()

PLSQuery(cQuery, _cAlias)

If SDB->DB_LOCAL='01'
	(_cAlias)->(DbGoTop())
	While (_cAlias)->(!eof())	
		fpriori((_cAlias)->DB_DOC, (_cAlias)->DB_PRODUTO, (_cAlias)->DB_LOCALIZ)
		fFila((_cAlias)->DB_DOC, (_cAlias)->DB_PRODUTO, (_cAlias)->DB_LOCALIZ)
		(_cAlias)->(dbSkip())
	End
	(_cAlias)->(dbCloseArea())
	
Else
	
	(_cAlias)->(dbCloseArea())
	
Endif

RestArea(aArea)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} FPRIORI
Description //Verifica fila de pedido prioridade
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/11/2018 /*/
//--------------------------------------------------------------
Static Function fPriori(cDocEntrada, cProduto, cLocaliz)

Local cQuery := ""
Local lRet := .F.
Local nQuantSDB:=SDB->DB_QUANT
Local cEnder:=cLocaliz


Default cDocEntrada := "XXXXXXXXX"

//Verifica Fila de pedidos Prioridade
cQuery := " SELECT SC6.R_E_C_N_O_ AS RECSC6, C6_NUM, C6_ITEM,C6_PRODUTO,C6_QTDVEN " + ENTER
cQuery += " FROM SC6010 (NOLOCK) SC6" + ENTER
cQuery += " INNER JOIN SC5010 (NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL " + ENTER
cQuery += "	AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
cQuery += "	LEFT JOIN SC9010 (NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND C5_XPRIORI = '1'" + ENTER
cQuery += "	AND C5_NOTA = ''" + ENTER
cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
cQuery += "	AND C6_BLQ <> 'R'" + ENTER
cQuery += "	AND C6_NOTA = ''" + ENTER
cQuery += "	AND C6_LOCAL = '01'" + ENTER
cQuery += " AND C6_LOCALIZ = '' " + ENTER
cQuery += "	AND C6_PRODUTO = '"+ cProduto +"'" + ENTER
cQuery += "	ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM" + ENTER

//MemoWrite( "C:\spool\mta265i.txt", cQuery )

cAlias := getNextAlias()

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof()) .and. nQuantSDB > 0
	
	lRet := .F.
	
	dbSelectArea("SC6")
	SC6->(dbGoTo((cAlias)->RECSC6))
	
	recLock("SC6",.F.)
	SC6->C6_LOCALIZ := cEnder
	msUnlock()
	
	//Liberação do pedido de venda
	FwMsgRun( ,{|| lRet := u_LibEst((cAlias)->C6_NUM,(cAlias)->C6_ITEM,(cAlias)->C6_PRODUTO,(cAlias)->C6_QTDVEN,nQuantSDB,.F.) }, , "Realizando liberação do pedido de vendas "+ SC6->C6_NUM +", Por Favor Aguarde..." )
	
	If lRet
		nQuantSDB := (nQuantSDB - (cAlias)->C6_QTDVEN)
		
		MemoWrite( "\PED_LIB\"+cDocEntrada+"_"+(cAlias)->C6_NUM+"_"+(cAlias)->C6_ITEM+".txt",;
		"Pedido:"+(cAlias)->C6_NUM+;
		" Produto:"+(cAlias)->C6_PRODUTO+;
		" Item:"+SC6->C6_ITEM+;
		" Quant:"+cvaltochar((cAlias)->C6_QTDVEN)+;
		" Endereço:"+ cEnder)
		
		fGravaZK2(cDocEntrada,(cAlias)->C6_NUM,(cAlias)->C6_PRODUTO,(cAlias)->C6_ITEM,(cAlias)->C6_QTDVEN,cEnder)
		
	Else
		recLock("SC6",.F.)
		SC6->C6_LOCALIZ := ""
		msUnlock()
		
		MemoWrite( "\PED_NAO_LIB\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
		"Pedido:"+(cAlias)->C6_NUM+;
		" Produto:"+(cAlias)->C6_PRODUTO+;
		" Item:"+(cAlias)->C6_ITEM+;
		" Quant:"+cvaltochar((cAlias)->C6_QTDVEN)+;
		" Endereço:"+ cEnder)
		
		nQuantSDB:=0 //Alterado para que se não conseguir liberar o pedido a quantidade seja zerada para sair fora do laço da SC6, nessa parte
		//do ponto de entrada estamos no SDB que contem um registro e a SC6 possui as vezes 20 e nesse caso vai gerar 20 registros
		//de LOG na pasta porque a variável nquantsdb só é atualizada se o sistema conseguir fazer a reserva.
	Endif
	
	(cAlias)->(dbSkip())
end

(cAlias)->(dbCloseArea())

Return

//--------------------------------------------------------------
/*/{Protheus.doc} ffila
Description //Verifica fila de pedido
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/11/2018 /*/
//--------------------------------------------------------------
Static Function fFila(cDocEntrada, cProduto, cLocaliz)

Local cQuery := ""
Local lRet := .F.
Local nQuantSDB:=SDB->DB_QUANT
Local cEnder:=cLocaliz


Default cDocEntrada := "XXXXXXXXX"

//Verifica Fila de pedidos de venda, liberação dos pedidos que estão sem liberação.
cQuery := " SELECT SC6.R_E_C_N_O_ AS RECSC6, C6_NUM, C6_ITEM,C6_PRODUTO,C6_QTDVEN " + ENTER
cQuery += " FROM SC6010 (NOLOCK) SC6" + ENTER
cQuery += " INNER JOIN SC5010 (NOLOCK) SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL " + ENTER
cQuery += "	AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
cQuery += "	LEFT JOIN SC9010 (NOLOCK) SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND C5_XPRIORI <> '1'" + ENTER
cQuery += "	AND C5_NOTA = ''" + ENTER
cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
cQuery += "	AND C6_BLQ <> 'R'" + ENTER
cQuery += "	AND C6_NOTA = ''" + ENTER
cQuery += "	AND C6_LOCAL = '01'" + ENTER
cQuery += " AND C6_LOCALIZ = '' " + ENTER
cQuery += "	AND C6_PRODUTO = '"+ cProduto +"'" + ENTER
cQuery += "	ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM" + ENTER

//MemoWrite( "C:\spool\mta265i.txt", cQuery )

cAlias := getNextAlias()

PLSQuery(cQuery, cAlias)

While (cAlias)->(!eof()) .and. nQuantSDB > 0
	
	lRet := .F.
	
	dbSelectArea("SC6")
	SC6->(dbGoTo((cAlias)->RECSC6))
	
	recLock("SC6",.F.)
	SC6->C6_LOCALIZ := cEnder
	msUnlock()
	
	//Liberação do pedido de venda
	FwMsgRun( ,{|| lRet := u_LibEst((cAlias)->C6_NUM,(cAlias)->C6_ITEM,(cAlias)->C6_PRODUTO,(cAlias)->C6_QTDVEN,nQuantSDB,.F.) }, , "Realizando liberação do pedido de vendas "+ SC6->C6_NUM +", Por Favor Aguarde..." )
	
	If lRet
		nQuantSDB := (nQuantSDB - (cAlias)->C6_QTDVEN)
		
		MemoWrite( "\PED_LIB\"+cDocEntrada+"_"+(cAlias)->C6_NUM+"_"+(cAlias)->C6_ITEM+".txt",;
		"Pedido:"+(cAlias)->C6_NUM+;
		" Produto:"+(cAlias)->C6_PRODUTO+;
		" Item:"+(cAlias)->C6_ITEM+;
		" Quant:"+cvaltochar((cAlias)->C6_QTDVEN)+;
		" Endereço:"+ cEnder)
		
		fGravaZK2(cDocEntrada,(cAlias)->C6_NUM,(cAlias)->C6_PRODUTO,(cAlias)->C6_ITEM,(cAlias)->C6_QTDVEN,cEnder)
	Else
		recLock("SC6",.F.)
		SC6->C6_LOCALIZ := ""
		msUnlock()
		
		nQuantSDB:=0 //Alterado para que se não conseguir liberar o pedido a quantidade seja zerada para sair fora do laço da SC6, nessa parte
		//do ponto de entrada estamos no SDB que contem um registro e a SC6 possui as vezes 20 e nesse caso vai gerar 20 registros
		//de LOG na pasta porque a variável nquantsdb só é atualizada se o sistema conseguir fazer a reserva.
		
		MemoWrite( "\PED_NAO_LIB\"+cDocEntrada+"_"+(cAlias)->C6_NUM+"_"+(cAlias)->C6_ITEM+".txt",;
		"Pedido:"+(cAlias)->C6_NUM+;
		" Produto:"+(cAlias)->C6_PRODUTO+;
		" Item:"+(cAlias)->C6_ITEM+;
		" Quant:"+cvaltochar((cAlias)->C6_QTDVEN)+;
		" Endereço:"+ cEnder)
	Endif
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGravaZK2
Description //Grava os registros na tabela ZK2
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 03/12/2018 /*/
//--------------------------------------------------------------
Static Function fGravaZK2(cDocE,cPedido,cProduto,cItem,nQuant,cEndereco)

dbSelectArea("ZK2")
ZK2->(dbSetOrder(1))

if ZK2->(dbSeek(Xfilial("ZK2")+cDocE+cPedido+cProduto+cItem))
	
	recLock("ZK2",.F.)
	ZK2->ZK2_DOCENT := cDocE
	ZK2->ZK2_PEDIDO := cPedido
	ZK2->ZK2_PROD := cProduto
	ZK2->ZK2_ITEM := cItem
	ZK2->ZK2_QUANT := nQuant
	ZK2->ZK2_LOCALI := cEndereco
	ZK2->ZK2_DTENT := ddatabase
	ZK2->(msUnlock())
	
else
	
	recLock("ZK2",.T.)
	ZK2->ZK2_DOCENT := cDocE
	ZK2->ZK2_PEDIDO := cPedido
	ZK2->ZK2_PROD := cProduto
	ZK2->ZK2_ITEM := cItem
	ZK2->ZK2_QUANT := nQuant
	ZK2->ZK2_LOCALI := cEndereco
	ZK2->ZK2_DTENT := ddatabase
	ZK2->(msUnlock())
	
endif

ZK2->(dbCloseArea())

Return
