#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ENTER CHR(13)+CHR(10)

//--------------------------------------------------------------
/*/{Protheus.doc} MTA265I
Description //MTA265I - Grava arquivos ou campos do usuário, complementando a inclusão
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/11/2018 /*/
//--------------------------------------------------------------
User Function MTA265I()

Local aArea   	:= GetArea()

Local lPe := supergetmv("KH_MTA265", .F., .F.)
//Private nQuantSDB := SDB->DB_QUANT

if lPe
	if SDA->DA_LOCAL == '01'
		fpriori(SDA->DA_DOC, SDA->DA_PRODUTO)
		fFila(SDA->DA_DOC, SDA->DA_PRODUTO)
	endif
endif

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
Static Function fPriori(cDocEntrada, cProduto)

Local cQuery := ""
Local lRet := .F.
Local nQuantSDB:=SDB->DB_QUANT

Default cDocEntrada := "XXXXXXXXX"

//Verifica Fila de pedidos Prioridade
cQuery := "SELECT SC6.R_E_C_N_O_ AS RECSC6 " + ENTER
cQuery += " FROM SC6010 SC6" + ENTER
cQuery += " INNER JOIN SC5010 SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL " + ENTER
cQuery += "	AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
cQuery += "	LEFT JOIN SC9010 SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND C5_XPRIORI = '1'" + ENTER
cQuery += "	AND C5_NOTA = ''" + ENTER
//	cQuery += "	AND C5_CLIENTE NOT IN ('000001')" + ENTER // TODO - SOLICITAÇÃO VIA CHAMADO - DISPONIBILIZAR TODOS OS PEDIDOS NA FILA
cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
cQuery += "	AND C6_BLQ <> 'R'" + ENTER
cQuery += "	AND C6_NOTA = ''" + ENTER
cQuery += "	AND C6_LOCAL = '01'" + ENTER
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
	SC6->C6_LOCALIZ := SDB->DB_LOCALIZ
	msUnlock()
	
	//Liberação do pedido de venda
	FwMsgRun( ,{|| lRet := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,nQuantSDB,.F.) }, , "Realizando liberação do pedido de vendas "+ SC6->C6_NUM +", Por Favor Aguarde..." )
	
	If lRet
		nQuantSDB := (nQuantSDB - SC6->C6_QTDVEN)
		
		MemoWrite( "\PED_LIB\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
		"Pedido:"+SC6->C6_NUM+;
		" Produto:"+SC6->C6_PRODUTO+;
		" Item:"+SC6->C6_ITEM+;
		" Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
		" Endereço:"+ SDB->DB_LOCALIZ)
		
		fGravaZK2(cDocEntrada,SC6->C6_NUM,SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_QTDVEN,SDB->DB_LOCALIZ)
		
	Else
		recLock("SC6",.F.)
		SC6->C6_LOCALIZ := ""
		msUnlock()
		
		MemoWrite( "\PED_NAO_LIB\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
		"Pedido:"+SC6->C6_NUM+;
		" Produto:"+SC6->C6_PRODUTO+;
		" Item:"+SC6->C6_ITEM+;
		" Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
		" Endereço:"+ SDB->DB_LOCALIZ)
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
Static Function fFila(cDocEntrada, cProduto)

Local cQuery := ""
Local lRet := .F.
Local nQuantSDB:=SDB->DB_QUANT


Default cDocEntrada := "XXXXXXXXX"

//Verifica Fila de pedidos de venda, liberação dos pedidos que estão sem liberação.
cQuery := "SELECT SC6.R_E_C_N_O_ AS RECSC6 " + ENTER
cQuery += " FROM SC6010 SC6" + ENTER
cQuery += " INNER JOIN SC5010 SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL " + ENTER
cQuery += "	AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
cQuery += "	LEFT JOIN SC9010 SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_PRODUTO = SC9.C9_PRODUTO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''" + ENTER
cQuery += "	WHERE SC6.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND C5_XPRIORI <> '1'" + ENTER
cQuery += "	AND C5_NOTA = ''" + ENTER
//cQuery += "	AND C5_CLIENTE NOT IN ('000001')" + ENTER // TODO - SOLICITAÇÃO VIA CHAMADO - DISPONIBILIZAR TODOS OS PEDIDOS NA FILA
cQuery += "	AND SC5.D_E_L_E_T_ = ' '" + ENTER
cQuery += "	AND (CASE WHEN C9_BLEST IS NULL THEN 'NAO-LIB' ELSE 'LIB' END) = 'NAO-LIB'" + ENTER
cQuery += "	AND C6_BLQ <> 'R'" + ENTER
cQuery += "	AND C6_NOTA = ''" + ENTER
cQuery += "	AND C6_LOCAL = '01'" + ENTER
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
	SC6->C6_LOCALIZ := SDB->DB_LOCALIZ
	msUnlock()
	
	//Liberação do pedido de venda
	FwMsgRun( ,{|| lRet := u_LibEst(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN,nQuantSDB,.F.) }, , "Realizando liberação do pedido de vendas "+ SC6->C6_NUM +", Por Favor Aguarde..." )
	
	If lRet
		nQuantSDB := (nQuantSDB - SC6->C6_QTDVEN)
		
		MemoWrite( "\PED_LIB\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
		"Pedido:"+SC6->C6_NUM+;
		" Produto:"+SC6->C6_PRODUTO+;
		" Item:"+SC6->C6_ITEM+;
		" Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
		" Endereço:"+ SDB->DB_LOCALIZ)
		
		fGravaZK2(cDocEntrada,SC6->C6_NUM,SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_QTDVEN,SDB->DB_LOCALIZ)
	Else
		recLock("SC6",.F.)
		SC6->C6_LOCALIZ := ""
		msUnlock()
		
		nQuantSDB:=0 //Alterado para que se não conseguir liberar o pedido a quantidade seja zerada para sair fora do laço da SC6, nessa parte
		//do ponto de entrada estamos no SDB que contem um registro e a SC6 possui as vezes 20 e nesse caso vai gerar 20 registros
		//de LOG na pasta porque a variável nquantsdb só é atualizada se o sistema conseguir fazer a reserva.
		
		MemoWrite( "\PED_NAO_LIB\"+cDocEntrada+"_"+SC6->C6_NUM+"_"+SC6->C6_ITEM+".txt",;
		"Pedido:"+SC6->C6_NUM+;
		" Produto:"+SC6->C6_PRODUTO+;
		" Item:"+SC6->C6_ITEM+;
		" Quant:"+cvaltochar(SC6->C6_QTDVEN)+;
		" Endereço:"+ SDB->DB_LOCALIZ)
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
