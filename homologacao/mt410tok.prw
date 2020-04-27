#Include "Protheus.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK  �Autor  �Microsiga           � Data �  12/15/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado ao pressionar o botao ok do pedi-���
���          �do de venda.                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT410TOK()

Local nOpcA		:= ParamIXB[1]
Local lRet		:= .T.
Local nX		:= 0
Local nPosDtAge	:= GdFieldPos("C6_DTAGEND")
Local nPosDtMon	:= GdFieldPos("C6_DTMONTA")
Local nPosBloq	:= GdFieldPos("C6_BLQ")   
Local nPosQtdli	:= GdFieldPos("C6_QTDLIB")
Local nPosLocal	:= GdFieldPos("C6_LOCALIZ")  
Local nPosArm   := GdFieldPos("C6_LOCAL")
Local nPosProd  := GdFieldPos("C6_PRODUTO")  
Local aInfSM0 	:= FWLoadSM0()

//��������������������������������������������Ŀ
//�Caso seja visualizacao tela nao sera exibida�
//����������������������������������������������
If nOpca <> 3 .And. nOpca <> 4
	Return(lRet)
EndIf


For nX:= 1 To Len(aCols)
	
	If !aTail( aCols[nX] )
		
		If M->C5_CLIENTE == '000001'
			lRet := fValSaldo(aCols[nX][nPosArm],aCols[nX][nPosProd])
			iF ! lRet
				MSGALERT("O Produto: "+aCols[nX][nPosProd]+" Nao possui saldo para efetuar a transferencia","Sem Saldo")	
			EndIf
		EndIf
		
		If SC5->(FieldPos("C5_01MOTOR")) >0 .And. !Empty(aCols[nX][nPosDtAge]) .And. Empty(M->C5_01MOTOR)
			If Alltrim(aCols[nX][nPosBloq])=="R"
				//MsgInfo("Pedido Cancelado! Agendamento n�o permitido.","Aten��o")
				//lRet := .F.
				//Exit
			Endif
		Endif
		
		If !Empty(aCols[nX][nPosDtMon]) .And. Empty(M->C5_CODUSR)
			If Alltrim(aCols[nX][nPosBloq])=="R"
				MsgInfo("Pedido Cancelado! Montagem não permitida.","Atenção")
				lRet := .F.
				Exit
			Endif
		Endif
		
		If nOpca == 4 .And. !ISINCALLSTACK('U_KMESTF02') .And. !ISINCALLSTACK('FALTPED')//Valida��o somente na altera��o - Marcio Nunes   
		        //        C6_QTDLIB	                        C6_LOCALIZ
			If Empty(aCols[nX][nPosQtdli]) .And. !Empty(aCols[nX][nPosLocal])
				MSGALERT("O Endereço deve ser limpo pois a quantidade liberada do pedido está 0 (Zero). Atenção! O Pedido não será salvo.","Endereço Inválido")	
				lRet := .F.             
			EndIf
			    //        C6_QTDLIB	                        C6_LOCALIZ
			If !Empty(aCols[nX][nPosQtdli]) .And. Empty(aCols[nX][nPosLocal])
				MSGALERT("O Endereço deve ser preenchido pois a quantidade liberada do pedido está maior que 0 (Zero). Atenção! O Pedido não será salvo.","Endereço Inválido")	
				lRet := .F.                
			EndIf
			 
		EndIf
	
	Endif
	
Next nX

If lRet
	
	SA1->(DbSetOrder(1))
	If SA1->(Dbseek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI ))
		If SA1->A1_01PEDFI=="1"
			MsgStop("Cliente possui pendencias financeiras. Contate o financeiro.","Atenção")
			lRet := .F.
		Endif
	Endif
		
Endif
//-----------------------------------------------------------------------------
//Grava��o de log de altera��o da Pendencia Financeira. 
//N�mero do ticket: 13503
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

//Verifica se o CNPJ do Cliente � o mesmo da Filial logada, para evitar pedido de vendas para mesma filial
//4U4-B74-B3WM (N�mero do ticket: 13775) - Jussara - Marcio Nunes - 18/02/2020
If lRet
            
	For nX :=1 to Len(aInfSM0)                       
		//Encontra o CNPJ da Filial logada para comparar com o CNPJ do Cliente Informado
		If Alltrim(aInfSM0[nX][2]) == Alltrim(cFilAnt)
		
			SA1->(DbSetOrder(1))
			If SA1->(Dbseek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI ))
		 		If Alltrim(SA1->A1_CGC) == Alltrim(aInfSM0[nX][18])
		 			MsgStop("O CNPJ do Cliente não pode ser o mesmo CNPJ da Filial selecionada. Dúvidas acione a equipe Fiscal.","Atenção")
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

Plsquery(cQuery,cAliasl)

WHILE (cAliasl)->(!EOF())
AADD( _aProd, {(cAliasl)->(B2_COD)} )
(cAliasl)->(DBSKIP())
ENDDO

If LEN(_aProd) > 0
 	_lRetSa := .T.
EndIf

Return  _lRetSa