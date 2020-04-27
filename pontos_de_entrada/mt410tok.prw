#Include "Protheus.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT410TOK  บAutor  ณMicrosiga           บ Data ณ  12/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada executado ao pressionar o botao ok do pedi-บฑฑ
ฑฑบ          ณdo de venda.                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MT410TOK()

Local nOpcA		:= ParamIXB[1]
Local lRet		:= .T.
Local nX		:= 0
Local nPosDtAge	:= GdFieldPos("C6_DTAGEND")
Local nPosDtMon	:= GdFieldPos("C6_DTMONTA")
Local nPosBloq	:= GdFieldPos("C6_BLQ")   
Local nPosQtdli	:= GdFieldPos("C6_QTDLIB")
Local nPosLocal	:= GdFieldPos("C6_LOCALIZ")  
Local nPosArm	:= GdFieldPos("C6_LOCAL")  
Local nPosProd	:= GdFieldPos("C6_PRODUTO")  
Local aInfSM0 	:= FWLoadSM0()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso seja visualizacao tela nao sera exibidaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpca <> 3 .And. nOpca <> 4
	Return(lRet)
EndIf

For nX:= 1 To Len(aCols)
	
	If !aTail( aCols[nX] )
		//Retorno de mostruario chamado: 14710 #Wellington Raul -> inicio
		If M->C5_CLIENTE == '000001'
			if INCLUI
				if ! cFilant == '0101'					
					lRet := fValSaldo(aCols[nX][nPosArm],aCols[nX][nPosProd])
					iF ! lRet
						MSGALERT("O Produto: "+aCols[nX][nPosProd]+" Nao possui saldo para efetuar a transferencia, Acione o departamento de Logistica","Sem Saldo")	
					EndIf
				EndIf
			EndIf
		EndIf
		//Retorno de mostruario chamado: 14710 #Wellington Raul -> fim
		If SC5->(FieldPos("C5_01MOTOR")) >0 .And. !Empty(aCols[nX][nPosDtAge]) .And. Empty(M->C5_01MOTOR)
			If Alltrim(aCols[nX][nPosBloq])=="R"
				//MsgInfo("Pedido Cancelado! Agendamento nใo permitido.","Aten็ใo")
				//lRet := .F.
				//Exit
			Endif
		Endif
		
		If !Empty(aCols[nX][nPosDtMon]) .And. Empty(M->C5_CODUSR)
			If Alltrim(aCols[nX][nPosBloq])=="R"
				MsgInfo("Pedido Cancelado! Montagem nใo permitida.","Aten็ใo")
				lRet := .F.
				Exit
			Endif
		Endif
		
		If nOpca == 4 .And. !ISINCALLSTACK('U_KMESTF02') .And. !ISINCALLSTACK('FALTPED')//Valida็ใo somente na altera็ใo - Marcio Nunes   
		        //        C6_QTDLIB	                        C6_LOCALIZ
			If Empty(aCols[nX][nPosQtdli]) .And. !Empty(aCols[nX][nPosLocal])
				MSGALERT("O Endere็o deve ser limpo pois a quantidade liberada do pedido estแ 0 (Zero). Aten็ใo! O Pedido nใo serแ salvo.","Endere็o Invแlido")	
				lRet := .F.             
			EndIf
			    //        C6_QTDLIB	                        C6_LOCALIZ
			If !Empty(aCols[nX][nPosQtdli]) .And. Empty(aCols[nX][nPosLocal])
				MSGALERT("O Endere็o deve ser preenchido pois a quantidade liberada do pedido estแ maior que 0 (Zero). Aten็ใo! O Pedido nใo serแ salvo.","Endere็o Invแlido")	
				lRet := .F.                
			EndIf
			 
		EndIf
	
	Endif
	
Next nX

If lRet
	
	SA1->(DbSetOrder(1))
	If SA1->(Dbseek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI ))
		If SA1->A1_01PEDFI=="1"
			MsgStop("Cliente possui pendencias financeiras. Contate o financeiro.","Aten็ใo")
			lRet := .F.
		Endif
	Endif
		
Endif
//-----------------------------------------------------------------------------
//Grava็ใo de log de altera็ใo da Pendencia Financeira. 
//N๚mero do ticket: 13503
dbSelectArea("Z35")
RecLock("Z35", .T.)
  	Z35_FILIAL := SC5->C5_FILIAL
   	Z35_PEDIDO := SC5->C5_NUM
   	Z35_DATA   := dDataBase
   	Z35_HORA   := Time()
   	Z35_STANT  := SC5->C5_PEDPEND
   	Z35_PERANT := SC5->C5_XPERLIB
   	Z35_STATUS := M->C5_PEDPEND
   	Z35_PERLIB := M->C5_XPERLIB
   	Z35_USER   := LogUsername()
   	Z35_ROTINA := "MATA410"
Z35->(MsUnlock())
Z35->(dbCloseArea())	
//-------------------------------------------------------------------------------	  

//Verifica se o CNPJ do Cliente ้ o mesmo da Filial logada, para evitar pedido de vendas para mesma filial
//4U4-B74-B3WM (N๚mero do ticket: 13775) - Jussara - Marcio Nunes - 18/02/2020
If lRet
            
	For nX :=1 to Len(aInfSM0)                       
		//Encontra o CNPJ da Filial logada para comparar com o CNPJ do Cliente Informado
		If Alltrim(aInfSM0[nX][2]) == Alltrim(cFilAnt)
		
			SA1->(DbSetOrder(1))
			If SA1->(Dbseek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI ))
		 		If Alltrim(SA1->A1_CGC) == Alltrim(aInfSM0[nX][18])
		 			MsgStop("O CNPJ do Cliente nใo pode ser o mesmo CNPJ da Filial selecionada. D๚vidas acione a equipe Fiscal.","Aten็ใo")
					lRet := .F. 
		 		EndIf         
			EndIf	
			
		EndIf	
	
	Next nX

EndIf

Return(lRet)

/*/{Protheus.doc} fValSaldo
//Autor: Wellington Raul Pinto
//Programa:fValSaldo
//Objetivo: Valida o saldo do produto para pedidos de transferencia 
/*/
Static Function fValSaldo(_cLocal, _cProdto)

LOCAL cQuery := ""
LOCAL cAliasl :=  GetNextAlias()
LOCAL _lRetSa := .F.
LOCAL _aProd := {}

cQuery := CRLF + "SELECT  B2_COD FROM "+RetSqlName("SB2")+"(NOLOCK) B2 "
cQuery += CRLF + "INNER JOIN "+RetSqlName("SB1")+" (NOLOCK) B1 ON B1_COD = B2_COD  "
cQuery += CRLF + "WHERE (B2_QATU -B2_QEMP - B2_RESERVA) > 0 "
cQuery += CRLF + "AND B2_LOCAL = '"+_cLocal+"' "
cQuery += CRLF + "AND B2.D_E_L_E_T_ = '' "
cQuery += CRLF + "AND B1.D_E_L_E_T_ = '' "
cQuery += CRLF + "AND B2_COD = '"+_cProdto+"' "
cQuery += CRLF + "AND B2_FILIAL = '"+cFilAnt+"' "

Plsquery(cQuery,cAliasl)

WHILE (cAliasl)->(!EOF())
AADD( _aProd, {(cAliasl)->(B2_COD)} )
(cAliasl)->(DBSKIP())
ENDDO

If LEN(_aProd) > 0
 	_lRetSa := .T.
EndIf

Return  _lRetSa
