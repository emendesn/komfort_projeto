#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKMCOMA06  บAutor  ณDeo                 บ Data ณ  23/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ No endere็amento do produto, deve ser feito o empenho      บฑฑ
ฑฑบ          ณ automatico dos pedidos de vendas com bloqueio de           บฑฑ
ฑฑบ          ณ estoque e posteriormente a liberacao do mesmo              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function KMCOMA06(cProduto,cDoc,cSerie)

MsAguarde({|| KMHEmp(cProduto,cDoc,cSerie)},"Por favor aguarde","Processando...")

Return


//+------------+---------------+-------+------------------------+------+------------+
//| Fun็ใo:    | KMHEmp        | Autor | Ellen Santiago         | Data | 11/05/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descri็ใo: | Realiza empenho dos produtos bloqueados com pedido de venda gerado |
//+------------+--------------------------------------------------------------------+
//| Uso:       | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+
 
Static Function KMHEmp (cProduto,cDoc,cSerie) 

Local cAliasx 		:= GetNextAlias()
Local aAreaSC9    	:= SC9->(GetArea())
Local aAreaSC6    	:= SC6->(GetArea())
Local aArea 		:= GetArea()// Armazena ultima area utilizada
Local cObs			:= ""		// Observacao na reserva
Local nDtlimit		:= 0		// Numero de dias para calculo da data limite da reserva	
Local aOperacao		:= {}		// Array com os dados de envio para a rotina a430Reserv
Local aHeaderAux	:= {}		// Simulacao do aHeader para a rotina a430Reserv
Local aColsAux 		:= {}		// Simulacao do aCols para a rotina a430Reserv			
Local cNumRes 		:= ""		// Gera Numero de Reserva Sequencial 
Local nUso			:= 0		// Contador auxiliar para montagem do aHeader
Local aLote			:= {"","","",""} // Array com os dados do lote para a rotina a430Reserv	
Local cQuery		:= ""
Local lReserva		:= .F.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta array com aHeader e aCols somente 		    ณ
//ณ com os dados necessarios para a rotina de reserva ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeaderAux := {}
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("C0_VALIDA ")
		nUso++
		AADD(aHeaderAux,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT }	)
Endif

// Numero de dias para calculo da data limite da reserva
nDtlimit	:= SuperGetMV("MV_DTLIMIT",,0)

aColsAux := Array(nUso+1)
aColsAux[1] := dDataBase+nDtlimit
aColsAux[nUso+1] := .F.

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SC9")
dbSetOrder(1)
			
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Busca todos os pedidos bloqueados por falta de estoque                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := "SELECT 	SC9.R_E_C_N_O_ SC9RECNO, SC6.R_E_C_N_O_ SC6RECNO, SC9.C9_FILIAL, SC9.C9_MSFIL, SC9.C9_PEDIDO, C9_PRODUTO, SC9.C9_ITEM,SC9.C9_BLCRED, " +CRLF
cQuery += "			SC5.C5_TIPLIB, C6_UM, C9_QTDLIB, B1_PROC, B1_LOJPROC, B1_DESC, " +CRLF 
cQuery += "			C6_ENTREG, C6_LOCAL,C6_QTDVEN  " +CRLF
cQuery += "FROM "+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += "JOIN " + RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL  = C6_FILIAL " +CRLF
cQuery += "		AND SC5.C5_NUM     = C6_NUM " +CRLF
cQuery += "JOIN " + RetSqlName("SB1")+" SB1 ON C6_PRODUTO = B1_COD "+CRLF
cQuery += "		AND B1_FILIAL = '" + xFilial("SB1") + "' " +CRLF
cQuery += "JOIN " + RetSqlName("SC9")+" SC9 ON SC6.C6_FILIAL  = C9_FILIAL " +CRLF
cQuery += "		AND SC6.C6_NUM     = SC9.C9_PEDIDO " +CRLF
cQuery += "		AND SC6.C6_ITEM    = SC9.C9_ITEM " +CRLF
cQuery += "		AND SC6.C6_PRODUTO = SC9.C9_PRODUTO " +CRLF	 
cQuery += "WHERE SC6.C6_FILIAL = '" + xFilial("SC6") + "'  " +CRLF
cQuery += "		AND SC9.C9_BLEST IN ('02','03') "		// Bloqueado e Bloqueado Manualmente
cQuery += "		AND SB1.B1_01FORAL <> 'F' " 	+CRLF 	// Produto nao estah fora de linha
cQuery += "		AND SC6.C6_BLQ <> 'R' " 		+CRLF  	// Produto nao baixados por residuos
cQuery += "		AND SC6.C6_NOTA = ' ' " 		+CRLF  	// Produto nao faturados 
cQuery += "		AND SC6.C6_QTDRESE = 0 " 		+CRLF 	// Produto nao reservado 
cQuery += "		AND C6_QTDENT < C6_QTDVEN"  	+CRLF  
cQuery += "		AND C9_PRODUTO = '" +  cProduto + "'" 	+CRLF  
cQuery += "		AND SC5.D_E_L_E_T_ <> '*' " 	+CRLF
cQuery += "		AND SC6.D_E_L_E_T_ <> '*' " 	+CRLF
cQuery += "		AND SC9.D_E_L_E_T_ <> '*' " 	+CRLF
cQuery += "		AND SB1.D_E_L_E_T_ <> '*' "	+CRLF 
cQuery += "ORDER BY C5_EMISSAO DESC " +CRLF

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasx, .T., .T.)

(cAliasx)->(dbGoTop())	
dbSelectArea(cAliasx)
 			
While !(cAliasx)->(Eof())

		cObs := "Reserva automatica ap๓s endere็amento para o PV " + (cAliasx)->C9_PEDIDO + " DOC: " + cDoc +" - "+ cSerie

		aOperacao := {	1		,;	// Operacao : 1 Inclui,2 Altera,3 Exclui
		"PD"					,;	// Tipo da Reserva : PD - Pedido
		(cAliasx)->C9_PEDIDO	,;	// Documento que originou a Reserva 
		UsrRetName(RetCodUsr())	,;	// Solicitante
		(cAliasx)->C9_MSFIL		,;	// Filial
		cObs		} 				// Observacao 	
				
		cNumRes := GetSx8Num("SC0","C0_NUM") 	
		lReserv := A430Reserv (aOPERACAO,cNumRes,cProduto,(cAliasx)->C6_LOCAL, (cAliasx)->C6_QTDVEN,aLOTE,aHeaderAux,aColsAux,NIL,.F.) 	//-->ณEfetua a Reserva 	 
		SC0->( MsUnLock() )  //-->ณLibera a tabela SC0 para confirmar reservaณ
		If !lReserv
			cNumRes	 := ""
			AutoGrLog("------------------------------ RESERVA ----------------------------")
			AutoGrLog("---------------- Nใo foi possivel realizar a reserva -----------------")
			AutoGrLog("----------------------------------------------------------------------------")
			RollBackSx8()		
		Else
			AutoGrLog(" RESERVA " + cNumRes + " REALIZADA COM SUCESSO.")
			AutoGrLog("-----------------------------------------------------------------------")
			lReserva := .T.
			ConfirmSX8()
			
			SC6->(DbGoTo((cAliasx)->SC6RECNO))
			RecLock("SC6",.F.)
				SC6->C6_RESERVA := cNumRes
				SC6->C6_QTDRESE := (cAliasx)->C6_QTDVEN
			MsUnlock("SC6")
						
			SC9->(DbGoTo((cAliasx)->SC9RECNO))
			RecLock("SC9",.F.)
				SC9->C9_RESERVA := cNumRes
				SC9->C9_QTDRESE := (cAliasx)->C6_QTDVEN
			MsUnlock("SC9")
			
		EndIf						
   	(cAliasx)->(DbSkip()) 			 		
EndDo

If lReserva
	MostraErro()
Endif


RestArea(aArea)
RestArea(aAreaSC9)
RestArea(aAreaSC6)

Return
