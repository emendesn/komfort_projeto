#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF

STATIC oEstorno

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTA650AE ³ Autor ³ Edilson Nascimento    ³ Data ³ 07/01/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estorno da movimentacao no momento da exclusao da OP.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ponto de Entrada                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MTA650E()

Local lRetValue := .T.

Local aArea     := GetArea()
Local oProcess
Local nRetry    := 0

	// Realiza o travamento da rotina para evitar conflito
	While !( LockByName("MTA650E",.F.,.F.,.T.) )
		MsAguarde({||Inkey(3)}, "", "A rotina encontra-se bloqueada por outro usuaro..." , .T.)
		if nRetry++ >= 1000
			UnLockByName("MTA650E",.F.,.F.,.T.)
		Endif
	EndDo


	// Inicia o processamento da rotina
	oProcess := MsNewProcess():New( { || Estorna( SC2->C2_NUM, oProcess ) } , "Estornando movimentacao..." , "Aguarde..." , .F. )
	oProcess:Activate()

	// Realiza o fechameento do arquivo temporario
	UnLockByName("MTA650E",.F.,.F.,.T.)

	RestArea( aArea )

Return lRetValue


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ESTORNA  ³ Autor ³ Edilson Nascimento    ³ Data ³ 07/01/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estorno da movimentacao no momento da exclusao da OP.      ³±±
±±³          ³ cNum  - Numero da Ordem de Producao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ponto de Entrada                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION ESTORNA( cNum, oProcess )

Local cQuery
Local cAlias     := getNextAlias()
Local cAliaSe    := getnextAlias()
Local nRegistros := 0
Local nReg		 := 0
Local nCount	 := 1
Local nCount0	 := 1  
Local lRetValue  := .T.


	BEGIN SEQUENCE

		// oEstorno   := EstornoTrans():New()
		oEstorno   := EnvMovimento():New()
	
		//Seleciona o PA à partir da OP selecionada
		cQuery := " SELECT SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, SB1.B1_DESC, SC2.C2_QUANT, " + CRLF
		cQuery += "        SC2.C2_QUJE, SC2.C2_UM, SC2.C2_SEGUM, SC2.C2_EMISSAO, SB1.B1_TIPO, SC2.C2_LOCAL," + CRLF
		cQuery += "        SC2.C2_PEDIDO, SC2.C2_XTRANOP, SC2.C2_XTRAUSR" + CRLF
		cQuery += "   FROM " + RetSqlName("SC2") + " (NOLOCK) SC2 " + CRLF
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.B1_FILIAL = '"+ xFilial("SB1") +"'" + CRLF
		cQuery += "                                                       AND SB1.B1_COD = SC2.C2_PRODUTO" + CRLF
		cQuery += "  WHERE SC2.D_E_L_E_T_ = ''" + CRLF
		cQuery += "        AND SB1.D_E_L_E_T_ = ''" + CRLF
		cQuery += "        AND SB1.B1_TIPO IN ('PA','PI')" + CRLF
		cQuery += "        AND SC2.C2_FILIAL = '"+ xFilial("SC2") +"'" + CRLF
		cQuery += "        AND SC2.C2_NUM = '"+ cNum +"'" + CRLF
		cQuery += "        AND SC2.C2_SEQUEN = '001'" + CRLF
		cQuery += "        AND SC2.C2_XTRANOP = '1'" + CRLF
		
		PlsQuery(cQuery, cAlias)
		
	 	BEGIN TRANSACTION

            nRegistros := 0
			(cAlias)->(dbEval({|| nRegistros++}))
			(cAlias)->(DbGotop())
			
			// Procregua(nRegistros)
			oProcess:SetRegua1( nRegistros ) //Preenche a regua com a quantidade de registros encontrados
			
			While ! (cAlias)->(Eof()) .AND. lRetValue
				
				oProcess:IncRegua1("Selecionando MP para Estorno..." + cValtoChar(nCount++) + " de " + cValtoChar(nRegistros))
				
				//Seleciona os produtos de MP para trnasferencia automática de armazem
				cQuery := "SELECT SD3.D3_COD as CODIGO, SD3.D3_QUANT as QUANT, SD3.D3_LOTECTL as LOTE, SD3.D3_DTVALID as VALIDADE, SD3.D3_DOC as DOC, SD3.D3_CF, SD3.D3_TM" + CRLF
				cQuery += "  FROM " + RetSqlName("SD3") + " (NOLOCK) SD3 " + CRLF
				cQuery += " WHERE SD3.D_E_L_E_T_ = '' " + CRLF
				cQuery += "       AND SD3.D3_FILIAL = '"+ xFilial("SD3") +"'" + CRLF
				cQuery += "       AND SD3.D3_01OP = '"+ (cAlias)->C2_NUM +"'" + CRLF
				cQuery += "       AND SD3.D3_CF = 'RE4'" + CRLF
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAliaSe, .F., .T.)

				nReg    := 0
				nCount0 := 1
				(cAliaSe)->(dbEval({|| nReg++}))
				(cAliaSe)->(DbGotop())

				oProcess:SetRegua2( nReg ) //Preenche a regua com a quantidade de registros encontrados				

				// Montagem dos dados para Envio de email para o usuario
				oEstorno:cNumOp    := (cAlias)->C2_NUM
				oEstorno:cEnvDest  := GetMV("MV_KHBXAUT")
				oEstorno:cEnvCopia := GetMV("KH_KHBXAPO")
				oEstorno:cAssunto  := "Divergencias na exclusao da Ordem de Produção: " +  (cAlias)->C2_NUM					

				// Adiciona o Cabecario no relatorio de Envio
				oEstorno:AddHeader("ERRO")
				oEstorno:AddHeader("MATERIA PRIMA")
				oEstorno:AddHeader("PRODUTO INTEREDIARIO")
				oEstorno:AddHeader("NECESSIDADE")
				oEstorno:AddHeader("ARMAZEM ORIGEM")
				oEstorno:AddHeader("ENDERECO ORIGEM")
				oEstorno:AddHeader("ARMAZEM DESTINO")
				oEstorno:AddHeader("ENDERECO DESTINO")


				// Processa os registros da tabela Temporaria
				While ! (cAliaSe)->(Eof()) .AND. lRetValue

					oProcess:IncRegua2("estornando... " + cValtoChar(nCount0++) + " de " + cValtoChar(nReg) )				

					//Chama a função de transferencia de armazem por produto
					lRetValue := GRVESTR( (cAliaSe)->CODIGO,   ;
                                          (cAliaSe)->QUANT,    ;
                                          (cAliaSe)->LOTE,     ;
                                          (cAliaSe)->VALIDADE, ;
                                          (cAliaSe)->DOC )
					
					(cAliaSe)->(DbSkip())
				EndDo

				//Envia o relatorio caso seja encontradas divergencias
				oEstorno:Send()
				
				// Fecha a tabela Temporaria
				(cAliaSe)->(dbCloseArea())
				
				(cAlias)->(DbSkip())
			EndDo
			
		END TRANSACTION
			
		// Fecha a tabela Temporaria
		(cAlias)->(dbCloseArea())
		
	END SEQUENCE
						
Return( lRetValue )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GRVESTR  ³ Autor ³ Edilson Nascimento    ³ Data ³ 07/01/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Transferencia de estrutura                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GRVTRAN			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION GRVESTR( cCodigo, nQuantidade, cLote, cValidade, cDoc )

Local cArmOri          := '95'
Local cEndOri          := 'PXA.AA.A1'
Local cArmDest         := '90'
Local cEndDest         := 'PXA.AA.90'
Local aLinha           := {}
Local aAuto            := {}
Local nOpcAuto         := 3   
Local lRetValue        := .T.
Local aTemp            := {}
Local cErro            := ''
Local cAliasDocument   := getNextAlias()
Local lContinue        := .T.

//Variáveis de controle do ExecAuto
Private lMSHelpAuto    := .T.
Private lAutoErrNoFile := .T.
Private lMsErroAuto    := .F.


	BEGIN SEQUENCE

		//Reserva o numero do documento para movimentacao
		While lContinue
			cDocumen := GetSxeNum("SD3","D3_DOC")

			//Identifica se o documento ja foi utilizado anteriormente
			cQuery := "SELECT SD3.D3_DOC D3_DOC" + CRLF
			cQuery += "  FROM " + RetSqlName("SD3") + " (NOLOCK) SD3 " + CRLF
			cQuery += " WHERE SD3.D_E_L_E_T_ = ''" + CRLF
			cQuery += "       AND SD3.D3_FILIAL = '"+ xFilial("SD3") +"'" + CRLF
			cQuery += "       AND SD3.D3_DOC = '"+ cDocumen +"'" + CRLF
			cQuery += "       AND SD3.D3_ESTORNO = ''" + CRLF

			PlsQuery(cQuery, cAliasDocument)

			if (cAliasDocument)->( EOF() )
				lContinue := .F.
			Endif

			(cAliasDocument)->( DBCloseArea() )

		Enddo	
	
		//Cabecalho a Incluir
		cDocumen := GetSxeNum("SD3","D3_DOC")
		aadd(aAuto,{ cDocumen, dDataBase}) //Cabecalho
		
		//Origem
		SB1->(DbSeek(xFilial("SB1") + PADR( cCodigo, TamSX3('D3_COD')[1])))
		aadd(aLinha,{"ITEM", '001',Nil})
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
		aadd(aLinha,{"D3_LOCAL", cArmOri, Nil}) //armazem origem
		aadd(aLinha,{"D3_LOCALIZ", PADR(cEndOri, TamSX3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
		
		//Destino
		SB1->(DbSeek(xFilial("SB1")+PADR( cCodigo, TamSX3('D3_COD')[1])))
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
		aadd(aLinha,{"D3_LOCAL", cArmDest, Nil}) //armazem destino
		aadd(aLinha,{"D3_LOCALIZ", PADR(cEndDest, TamSX3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino
		
		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", cLote, Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", CTOD( cValidade ), Nil}) //data validade
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", nQuantidade, Nil}) //Quantidade da SG1 * Quantidade informada na OP para transferir a quantidade atual
		aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
		
		aadd(aLinha,{"D3_LOTECTL", cLote, Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
		aadd(aLinha,{"D3_DTVALID", CTOD( cValidade ), Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
		
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
		
		aAdd(aAuto,aLinha)
			
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
		
		If lMsErroAuto

			aTemp := GetAutoGRLog()
			cErro := alltrim( substr(aTemp[1],at(":", aTemp[1])+1, len(aTemp[1])) )

			// RollBack no SXENum
			RollbackSx8()
			
			lRetValue := .F.
			
		Else

			//Grava campos customizados
			DbSelectArea("SD3")
			If SD3->( DbSetOrder(9), DbSeek(xFilial("SD3") + cDocumen ) )
				While SD3->D3_FILIAL == xFilial("SD3") .AND. SD3->D3_DOC == cDocumen .AND. ;
					! SD3->( EOF() )
					
					BEGIN TRANSACTION
						RecLock("SD3",.F.)
						SD3->D3_OBS     := "EXCL.TRANSF.AUT.(KMHTRAN)-" + oEstorno:cNumOp
						SD3->D3_01QUANT := nQuantidade
						SD3->D3_01SOLI  := "MTA650E"
						SD3->D3_01DTT   := dDataBase
						SD3->D3_XDOCANT := cDoc
						SD3->(MsUnLock())
					END TRANSACTION
					
					SD3->(DbSkip())
					
				EndDo
			EndIf
			
			// Confirma no SXENum
			ConfirmSx8()
			
		Endif

		// Adiciona informacao do registro processado
		oEstorno:AddConteudo( "ERRO", cErro )
		oEstorno:AddConteudo( "MATERIA PRIMA", cCodigo)
		oEstorno:AddConteudo( "PRODUTO INTEREDIARIO", "")
		oEstorno:AddConteudo( "NECESSIDADE", TRANSFORM( nQuantidade, "@E 999999.999999"))
		oEstorno:AddConteudo( "ARMAZEM ORIGEM", cArmOri)
		oEstorno:AddConteudo( "ENDERECO ORIGEM", cEndOri)
		oEstorno:AddConteudo( "ARMAZEM DESTINO", cArmDest)
		oEstorno:AddConteudo( "ENDERECO DESTINO", cEndDest)
		oEstorno:ConteudoCommmit()
		
	END SEQUENCE
		
Return( lRetValue )