#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF
#INCLUDE 'FILEIO.CH'

#DEFINE pCRLF     CHR(13)+CHR(10)

STATIC oTransfer

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � KMHTRAN  � Autor � Marcos V. Ferreira    � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Transferencia de estrutura                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � KMHTRAN			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function _KMHTRAN( oProcess )          

Local cQuery
Local cAlias 		:= getNextAlias()
Local cAliaStru     := getnextAlias()
Local nRegistros  	:= 0
Local nReg			:= 0
Local nCount		:= 1
Local nCount0		:= 1
Local nRetry        := 0


	BEGIN SEQUENCE

		While !( LockByName("KMHTRAN",.F.,.F.,.T.) )
			MsAguarde({||Inkey(3)}, "", "A rotina encontra-se bloqueada por outro usuaro..." , .T.)
			if nRetry++ >= 1000
				UnLockByName("KMHTRAN",.F.,.F.,.T.)
			Endif
		EndDo

		// oTransfer := Transferencias():New()
		oTransfer := EnvMovimento():New()
	
		//Seleciona o PA � partir da OP selecionada
		cQuery := "SELECT SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, SB1.B1_DESC, SC2.C2_QUANT, " + pCRLF
		cQuery += "       SC2.C2_QUJE, SC2.C2_UM, SC2.C2_SEGUM, SC2.C2_EMISSAO, SB1.B1_TIPO, SC2.C2_LOCAL," + pCRLF
		cQuery += "       SC2.C2_PEDIDO, SC2.C2_XTRANOP, SC2.C2_XTRAUSR" + pCRLF
		cQuery += "  FROM " + RetSqlName("SC2") + " (NOLOCK) SC2 " + pCRLF
		cQuery += " INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.B1_FILIAL = '"+ xFilial("SB1") +"'" + pCRLF
		cQuery += "                                                      AND SB1.B1_COD = SC2.C2_PRODUTO" + pCRLF
		cQuery += " WHERE SC2.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "       AND SB1.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "       AND SB1.B1_TIPO IN ('PA','PI')" + pCRLF
		cQuery += "       AND SC2.C2_FILIAL = '"+ xFilial("SC2") +"'" + pCRLF
		// cQuery += "       AND SC2.C2_NUM = '"+ SC2->C2_NUM +"'" + pCRLF
		cQuery += "       AND SC2.C2_SEQUEN = '001'" + pCRLF
		cQuery += "       AND SC2.C2_XTRANOP <> '1'" + pCRLF
		
		PlsQuery(cQuery, cAlias)
		
		BEGIN TRANSACTION
		
		    nRegistros := 0
			(cAlias)->(dbEval({|| nRegistros++}))
			(cAlias)->(DbGotop())
			
			//Procregua(nRegistros)
			oProcess:SetRegua1( nRegistros ) //Preenche a regua com a quantidade de registros encontrados
			
			While ! (cAlias)->( Eof() )
				
				oProcess:IncRegua1("Selecionando MP para Transfer�ncia... " + cValtoChar(nCount++) + " de " + cValtoChar(nRegistros))

				//Seleciona os produtos de MP para trnasferencia autom�tica de armazem
				cQuery  := " WITH ESTRUT( FILIAL, CODIGO, COD_PI, COD_MP, NECESSIDADE, PERDA, DTINI, DTFIM, NIVEL, NIV, NIVINV, FIXVAR, REVDIM, DESCRICAO, CORPI, LINHA, TECIDO, TIPO, RECNO, QTDCOMP ) AS " + pCRLF
				cQuery  += " ( SELECT SG1.G1_FILIAL, SG1.G1_COD PAI, SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SG1.G1_PERDA, SG1.G1_INI, SG1.G1_FIM, 1 AS NIVEL, SG1.G1_NIV, SG1.G1_NIVINV, SG1.G1_FIXVAR, SG1.G1_REVFIM, SB1.B1_DESC, SB1.B1_01COR, SB1.B1_01LINHA, SB1.B1_01TECID, SB1.B1_TIPO, SG1.R_E_C_N_O_, SG1.G1_QUANT" + pCRLF
				cQuery  += "    FROM " + RetSqlName("SG1") + " (NOLOCK) SG1 " + pCRLF
				cQuery  += "   INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.B1_FILIAL = '"+ xFilial("SB1") +"'" + pCRLF
				cQuery  += "                                                        AND SB1.B1_COD = SG1.G1_COMP" + pCRLF
				cQuery  += "   WHERE SG1.D_E_L_E_T_ = '' " + pCRLF
				cQuery  += "         AND SB1.D_E_L_E_T_ = '' " + pCRLF
				cQuery  += "         AND SG1.G1_FILIAL = '"+ xFilial("SG1") +"'" + pCRLF
				cQuery  += "   UNION ALL " + pCRLF                                                    //Quantidade da OP, pois a mesma pode ter mais de uma quantidade a ser produzida
				cQuery  += "   SELECT SG1.G1_FILIAL, CODIGO, SG1.G1_COD, SG1.G1_COMP, (NECESSIDADE * SG1.G1_QUANT), SG1.G1_PERDA, SG1.G1_INI, SG1.G1_FIM, NIVEL + 1, SG1.G1_NIV, SG1.G1_NIVINV, SG1.G1_FIXVAR, SG1.G1_REVFIM, SB1.B1_DESC, SB1.B1_01COR, SB1.B1_01LINHA, SB1.B1_01TECID, SB1.B1_TIPO, SG1.R_E_C_N_O_, SG1.G1_QUANT " + pCRLF
				//	cQuery += "   SELECT G1_FILIAL, CODIGO, G1_COD, G1_COMP, (NECESSIDADE * G1_QUANT) * "+(cAlias)->C2_QUANT+", B2_QATU, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1, G1_NIV, G1_NIVINV, G1_FIXVAR, G1_REVFIM, B1_DESC, B1_01COR, B1_01LINHA, B1_01TECID, SB1.B1_TIPO, SG1.R_E_C_N_O_ " + pCRLF
				cQuery  += "   FROM " + RetSqlName("SG1") + " (NOLOCK) SG1 " + pCRLF
				cQuery  += "   INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.B1_FILIAL = '"+ xFilial("SB1") +"'" + pCRLF
				cQuery  += "                                                        AND SB1.B1_COD = SG1.G1_COMP" + pCRLF
				cQuery  += "   INNER JOIN ESTRUT EST ON SG1.G1_COD = COD_MP " + pCRLF
				cQuery  += "   WHERE SG1.D_E_L_E_T_ = '' " + pCRLF
				cQuery  += "         AND SB1.D_E_L_E_T_ = '' " + pCRLF
				cQuery  += "         AND SG1.G1_FILIAL = '"+ xFilial("SG1") +"'" + pCRLF
				cQuery  += " ) " + pCRLF
				cQuery  += " SELECT E1.COD_PI, E1.COD_MP, E1.NECESSIDADE, E1.LINHA, E1.RECNO, E1.QTDCOMP, E1.TIPO " + pCRLF
				cQuery  += " FROM ESTRUT E1 " + pCRLF
				cQuery  += " WHERE E1.CODIGO = '"+ (cAlias)->C2_PRODUTO +"' " + pCRLF  //PA para listagem da estrutura
				cQuery  += " AND E1.TIPO = 'MP'" + pCRLF
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAliaStru, .F., .T.)
				
				nReg    := 0
				nCount0 := 1
				(cAliaStru)->(dbEval({|| nReg++}))
				(cAliaStru)->(DbGotop())
				
				oProcess:SetRegua2( nReg ) //Preenche a regua com a quantidade de registros encontrados
				
				// Montagem dos dados para Envio de email para o usuario
				oTransfer:cNumOp    := (cAlias)->C2_NUM
				oTransfer:cEnvDest  := GetMV("MV_KHBXAUT")
				oTransfer:cEnvCopia := GetMV("KH_KHBXAPO")
				oTransfer:cAssunto  := "Divergencias na geracao da Ordem de Produ��o: " +  (cAlias)->C2_NUM

				// Adiciona o Cabecario no relatorio de Envio
				oTransfer:AddHeader("ERRO")
				oTransfer:AddHeader("MATERIA PRIMA")
				oTransfer:AddHeader("PRODUTO INTEREDIARIO")
				oTransfer:AddHeader("NECESSIDADE")
				oTransfer:AddHeader("REQ. DA OP")
				oTransfer:AddHeader("ARMAZEM ORIGEM")
				oTransfer:AddHeader("ENDERECO ORIGEM")
				oTransfer:AddHeader("ARMAZEM DESTINO")
				oTransfer:AddHeader("ENDERECO DESTINO")


				//Inicia o processamento da estrutura do Produto
				While ! (cAliaStru)->( Eof() )
					
					oProcess:IncRegua2("Gerando Transfer�ncia de Armazem... " + cValtoChar(nCount0++) + " de " + cValtoChar(nReg) )
					
					//Chama a fun��o de transferencia de armazem por produto - Marcio                         //Quantidade informada na OP
					U_GRVTRAN((cAliaStru)->COD_MP, ;
				              (cAliaStru)->COD_PI, ;
				              (cAliaStru)->QTDCOMP, ;
				              (cAlias)->C2_NUM, ;
				              (cAlias)->C2_QUANT )
					
					(cAliaStru)->(DbSkip())
				EndDo
				
				//Envia o relatorio caso seja encontradas divergencias
				//oTransfer:SendError()
				oTransfer:Send()				
				
				//Gravar campo na SC2 para que seja poss�vel imprimir os relat�rios
				DbSelectArea("SC2")
				If SC2->(DbSetOrder(1),DbSeek(xFilial("SC2")+(cAlias)->C2_NUM) )
					While SC2->C2_FILIAL == xFilial("SC2") .AND. SC2->C2_NUM == (cAlias)->C2_NUM .AND. ;
					! SC2->( EOF() )

					BEGIN TRANSACTION
						RecLock("SC2",.F.)
						SC2->C2_XTRANOP	:= "1"                       //Informa que o saldo foi transferido para que seja poss�vel imprimir o relat�rio
						SC2->C2_XTRAUSR	:= UsrRetName(RetCodUsr())  //Permite a gravacao do nome do usuario reponsavel pela geracao da OP.
						SC2->(MsUnLock())
					END TRANSACTION					

					SC2->( DBSkip() )

					EndDo
				EndIf      //marcio 18/12/2019
					
				// Realiza o fechameento do arquivo temporario
				(cAliaStru)->(dbCloseArea())
				
				// Proximo registos
				(cAlias)->(DbSkip())
			EndDo
			
		END TRANSACTION
		
		// Realiza o fechamento do arquivo temporario
		(cAlias)->(dbCloseArea())

		// Realiza o fechameento do arquivo temporario
		UnLockByName("KMHTRAN",.F.,.F.,.T.)
		
	END SEQUENCE
			
Return    


#DEFINE pMATERIA_PRIMA    1
#DEFINE pLOTE             2
#DEFINE pVALIDADE         3
#DEFINE pNECESSIDADE      4

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GRVTRAN  � Autor � Marcos V. Ferreira    � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Transferencia de estrutura                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GRVTRAN			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function _GRVTRAN(cCodMP, cCodPI, nQuant, cCodOP, nQuantOp )

Local cArmOri          := '90'
Local cEndOri          := 'PXA.AA.90'
Local cArmDest         := '95'
Local cEndDest         := 'PXA.AA.A1'
Local cDocumen         := Criavar("D3_DOC")
Local aLinha           := {}
Local aAuto            := {}
Local nOpcAuto         := 3
Local lRetValue        := .T.
Local aTemp            := {}
Local cErro            := ''

Local nPos
Local cQuery
Local cAliasSB8        := getNextAlias()
Local cAliasDocument
Local lContinue        := .T.
Local cMatPrima        := Alltrim(cCodMP)
Local nTotRecno        := 0
Local nNecessidade     := nQuant * nQuantOp
Local nTotNecess       := nNecessidade
Local aStruProd        := {}

//Vari�veis de controle do ExecAuto
Private lMSHelpAuto    := .T.
Private lAutoErrNoFile := .T.
Private lMsErroAuto    := .F.


	BEGIN SEQUENCE
	
		//Seleciona o lote na tabela SB8
		cQuery := " SELECT SB8.B8_SALDO as SALDO, SB8.B8_LOTECTL as LOTE, SB8.B8_DTVALID as VALIDADE " + pCRLF
		cQuery += "   FROM " + RetSqlName("SB8") + " (NOLOCK) SB8 " + pCRLF
		cQuery += "  WHERE SB8.D_E_L_E_T_ = ''" + pCRLF
		cQuery += "        AND SB8.B8_FILIAL = '"+ xFilial("SB8") +"'" + pCRLF
		cQuery += "        AND SB8.B8_PRODUTO = '"+ cMatPrima +"'" + pCRLF
		cQuery += "        AND SB8.B8_LOCAL = '"+ cArmOri +"'" + pCRLF
		cQuery += " ORDER BY SB8.B8_DATA, SB8.B8_LOTECTL" + pCRLF
		
		PlsQuery(cQuery, cAliasSB8)
		
		(cAliasSB8)->(dbEval({|| nTotRecno++}))
		(cAliasSB8)->(dbGoTop())
		
		IF nTotRecno > 0
			while ! (cAliasSB8)->( eof() ) .AND. nNecessidade > 0
				if nNecessidade <= (cAliasSB8)->SALDO
					aadd( aStruProd, { cMatPrima, (cAliasSB8)->LOTE, (cAliasSB8)->VALIDADE, nNecessidade } )
				Else
					aadd( aStruProd, { cMatPrima, (cAliasSB8)->LOTE, (cAliasSB8)->VALIDADE, (cAliasSB8)->SALDO } )
				Endif
				nNecessidade -= (cAliasSB8)->SALDO
				(cAliasSB8)->(DbSkip())
			enddo
		Else
			aadd( aStruProd, { cMatPrima, "", "", nNecessidade })
		Endif
		

        // Identifica se foi preenchido corretamente o Array para a ExecAuto
		if len( aStruProd ) > 0
			
			for nPos := 1 to len( aStruProd )
				
				//Reserva o numero do documento para movimentacao
				While lContinue
				    cAliasDocument := getNextAlias()
					cDocumen       := GetSxeNum("SD3","D3_DOC")

					//Identifica se o documento ja foi utilizado anteriormente
					cQuery := "SELECT SD3.D3_DOC D3_DOC" + pCRLF
					cQuery += "  FROM " + RetSqlName("SD3") + " (NOLOCK) SD3 " + pCRLF
					cQuery += " WHERE SD3.D_E_L_E_T_ = ''" + pCRLF
					cQuery += "       AND SD3.D3_FILIAL = '"+ xFilial("SD3") +"'" + pCRLF
					cQuery += "       AND SD3.D3_DOC = '"+ cDocumen +"'" + pCRLF
					cQuery += "       AND SD3.D3_ESTORNO = ''" + pCRLF

					PlsQuery(cQuery, cAliasDocument)

					if (cAliasDocument)->( EOF() )
						lContinue := .F.
					Endif

					(cAliasDocument)->( DBCloseArea() )

				Enddo

				//Cabecalho da Incluir
				aadd(aAuto,{ cDocumen, dDataBase}) //Cabecalho		
				
				aLinha := {}
				//Origem
				SB1->(DbSeek(xFilial("SB1")+PadR( aStruProd[ nPos ][ pMATERIA_PRIMA ], TamSX3('D3_COD')[1])))
				aadd(aLinha,{"ITEM",'00'+cValtoChar( nPos ),Nil})
				aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
				aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
				aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
				aadd(aLinha,{"D3_LOCAL", cArmOri, Nil}) //armazem origem
				aadd(aLinha,{"D3_LOCALIZ", PadR(cEndOri, TamSX3('D3_LOCALIZ')[1]),Nil}) //Informar endere�o origem
				
				//Destino
				SB1->(DbSeek(xFilial("SB1")+PadR( aStruProd[ nPos ][ pMATERIA_PRIMA ], TamSX3('D3_COD')[1])))
				aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
				aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
				aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
				aadd(aLinha,{"D3_LOCAL", cArmDest, Nil}) //armazem destino
				aadd(aLinha,{"D3_LOCALIZ", PadR(cEndDest, TamSX3('D3_LOCALIZ')[1]),Nil}) //Informar endere�o destino
				
				aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
				aadd(aLinha,{"D3_LOTECTL", aStruProd[ nPos ][ pLOTE ], Nil}) //Lote Origem
				aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
                aadd(aLinha,{"D3_DTVALID", CTOD(aStruProd[ nPos ][ pVALIDADE ]), Nil}) //data validade				

				aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
				aadd(aLinha,{"D3_QUANT", aStruProd[ nPos ][ pNECESSIDADE ], Nil}) //Quantidade da SG1 * Quantidade informada na OP para transferir a quantidade atual
				aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
				aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
				aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
				
				aadd(aLinha,{"D3_LOTECTL", aStruProd[ nPos ][ pLOTE ], Nil}) //Lote destino
				aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
				aadd(aLinha,{"D3_DTVALID", CTOD(aStruProd[ nPos ][ pVALIDADE ]), Nil}) //validade lote destino
				aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
				
				aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
				aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
				
				aAdd(aAuto,aLinha)
				
			Next
			
			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			
			If lMSErroAuto
				
				aTemp := GetAutoGRLog()
				cErro := alltrim( substr(aTemp[1],at(":", aTemp[1])+1, len(aTemp[1])) )
				
				// oTransfer:AddErro(cErro, cCodMp, cCodPi, nNecessidade, nTotNecess, cArmOri, cEndOri, cArmDest, cEndDest )
				
				lRetValue := .F.
				
				// RollBack no SXENum
				RollbackSx8()
				
			Else
				
				//Grava campos customizados
				DbSelectArea("SD3")
				If SD3->( DbSetOrder(9), DbSeek(xFilial("SD3") + cDocumen ) )
					While SD3->D3_FILIAL == xFilial("SD3") .AND. SD3->D3_DOC == cDocumen .AND. ;
						! SD3->( EOF() )
						
						BEGIN TRANSACTION
							RecLock("SD3",.F.)
							SD3->D3_OBS         := "TRANSF.AUT.(KMHTRAN)-" + oTransfer:cNumOp
							SD3->D3_01OP 		:= oTransfer:cNumOp
							SD3->D3_01QUANT		:= nTotNecess
							SD3->D3_01SOLI		:= "MTA650I"
							SD3->D3_01DTT		:= dDataBase
							SD3->(MsUnLock())
						END TRANSACTION
						
						SD3->(DbSkip())
						
					EndDo
				EndIf
				
				// Confirma no SXENum
				ConfirmSx8()
				
			Endif

			// Adiciona informacao do registro processado
			oTransfer:AddConteudo( "ERRO", cErro)
			oTransfer:AddConteudo( "MATERIA PRIMA", cCodMp)
			oTransfer:AddConteudo( "PRODUTO INTEREDIARIO", cCodPi)
			oTransfer:AddConteudo( "NECESSIDADE", TRANSFORM( nNecessidade, "@E 999999.999999"))
			oTransfer:AddConteudo( "REQ. DA OP", TRANSFORM( nTotNecess, "@E 999999.999999"))
			oTransfer:AddConteudo( "ARMAZEM ORIGEM", cArmOri)
			oTransfer:AddConteudo( "ENDERECO ORIGEM", cEndOri)
			oTransfer:AddConteudo( "ARMAZEM DESTINO", cArmDest)
			oTransfer:AddConteudo( "ENDERECO DESTINO", cEndDest)
			oTransfer:ConteudoCommmit()

		Endif
	
	END SEQUENCE
			
Return lRetValue