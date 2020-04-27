#Include "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATA650I  �Autor  �EDILSON MENDES      � Data �  16/12/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada � chamado nas func��es: A650Inclui   ���
���          � (Inclus�o de OP's) A650GeraC2 (Gera Op para                ���
���          � Produto/Quantidade Informados nos par�metros).             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MTA650I()

Local aGetArea 	:= GetArea()              
Local lSC5		:= .F.
Local aEmpenho
Local lEmpenha
Local nPos


	//comentada a trava por solicita��o do F�bio e Arnaldo para ajustar o processo de produ��o - 29/10/2019 - 	ZE9-81N-TGX9 (N�mero do ticket: 12788)
	If SA2->(dbSeek(Xfilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC))
		
		//Tratamento para consistir o estoque
		DbSelectArea("SX6")
		if SX6->( DbSetOrder(1), DbSeek(xFilial()+"MV_CONSEST") ) .AND. SX6->X6_CONTEUD <> "N"
			Reclock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MSUnLock()
		Endif
		
		// Reposiciona no cabecario do Pedido
		DbSelectArea("SC5")
		If SC5->(DbSetOrder(1), DbSeek(Xfilial("SC5")+SC6->C6_NUM))
			
			//
			// Verifica o saldo disponivel em estoque
			//
			aEmpenho := {}
			if SC6->(DBsetOrder(1), DBSeek(xFilial("SC6")+SC5->C5_NUM))
				while SC6->C6_FILIAL == xFilial("SC6") .and. ;
					SC6->C6_NUM == SC5->C5_NUM .and. ;
					SC6->( .NOT. EOF() )
					if SB1->( DbSetOrder(1), DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
						dbSelectArea("SB2")
						if SB2->(DBSetOrder(1), DBSeek(xFilial("SB2") + SB1->B1_COD + SB1->B1_LOCPAD ) )
							if SaldoSb2( .T., .T. ) > 0 .and. SB1->B1_TIPO == "PA"
								AADD( aEmpenho, { SC6->C6_NUM, ;
								                  SC6->C6_ITEM,; //ITEM
								                  SC6->C6_PRODUTO,; //PRODUTO
								                  SC6->C6_LOCAL,; //LOCAL
								                  SC6->C6_QTDVEN}) //QUANTIDADE DE VENDA
							Endif
						endif
					Endif
					SC6->(DBSkip())
				Enddo
			endif
			
			// Caso tenha disponivel em estoque, empenha o produto
			if len( aEmpenho ) > 0
				for nPos := 1 to len( aEmpenho )

					Alert("Nao existe a ncessidade de geracao de OP para o produto: " + aEmpenho[ nPos ][ pC6_PRODUTO ] )

					lEmpenha := U_fSBF(aEmpenho[ nPos ][ pC6_NUM  ],    ;
					                   aEmpenho[ nPos ][ pC6_ITEM ],    ;
					                   aEmpenho[ nPos ][ pC6_PRODUTO ], ;
					                   aEmpenho[ nPos ][ pC6_LOCAL ],   ;
					                   aEmpenho[ nPos ][ pC6_QTDVEN ]   )
					
					// Caso nao seja possivel realizar o empenho do produto
					if .not. lEmpenha
						Alert("Nao foi possivel realizar o empenho do produto: " + aEmpenho[ nPos ][ pC6_PRODUTO ] )
					endif
				Next
			else
				
				//Para o tratamento de prazo de entrega konfort foi retirado o valid sistema dos campos abaixo: 
				//C2_DATPRI - A650DatPri()
				//C2_DATPRF - A650DatPrf()
				
				//Atualiza o campo SC2 com proazo de entrega e prazo de in�cio previsto � partir do pedido
				SC2->C2_DATPRI  := Datavalida(DaySum(cTod(Substr(dTos(SC5->C5_EMISSAO),7,2)+"/"+Substr(dTos(SC5->C5_EMISSAO),5,2)+"/"+Substr(dTos(SC5->C5_EMISSAO),1,4)),2)) // Prazo in�cio, emiss�o do pedido + 5 dias �teis (cancela Substitui)
				SC2->C2_DATPRF := Datavalida(DaySum(cTod(Substr(dTos(SC5->C5_EMISSAO),7,2)+"/"+Substr(dTos(SC5->C5_EMISSAO),5,2)+"/"+Substr(dTos(SC5->C5_EMISSAO),1,4)),28))// Prazo de entrega, emiss�o do pedido + 5 dias �teis
				//FIXAR O ARMAZEM 95 NA ABERTURA DA op POR pEDIDO  - MARCIO NUNES - 12994 - 05/11/2019
				SC2->C2_LOCAL := "95"// Prazo de entrega, emiss�o do pedido + 5 dias �teis
				//SC2->C2_TPOP := "P"// Abre a OP como Prevista � partir do Pedido de Vendas
				lSC5 := .T.
				
			Endif
		EndIf
		                                                  
	EndIf
	
	/*If !lSC5     
		//Tratamento para consumir os PI's apontados na abertura da ordem de produ��o - Vanito - 02/10/2019
		If SC2->C2_TPOP="P" .OR. SC2->C2_TPOP="F"
			If SC2->C2_SEQUEN="001"
				If !MsgYesNo("Deseja consumir o saldo dos PI�s j� apontados?", "Consumo de Saldos")
					
					If SB1->B1_TIPO='PA'
						MsgAlert("N�o � permitido abrir ordem de produ��o para Produto Acabado sem consumir os saldos dos PI�s","Aten��o")
						Return
					Endif
					
					DbSelectArea("SX6")
					DbSetOrder(1)
					DbSeek(xFilial()+"MV_CONSEST")
					Reclock("SX6",.F.)
					SX6->X6_CONTEUD := "N"
					MSUnLock()
				Else
					DbSelectArea("SX6")
					DbSetOrder(1)
					DbSeek(xFilial()+"MV_CONSEST")
					Reclock("SX6",.F.)
					SX6->X6_CONTEUD := "S"
					MSUnLock()
					
				Endif
			Endif
		Endif   
	EndIf               */
	
	RestArea(aGetArea)  

Return
