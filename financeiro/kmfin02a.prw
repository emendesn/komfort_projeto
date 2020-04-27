#Include 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
//Tel. Contato Kevin 2373-1527

/*
=====================================================================================
Programa.:              KMFIN02A
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            ROTINA PARA EXECUTAR A CONCILIACAO BANCARIA
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
User Function KMFIN02A()

	//*IMPORTANTE* Caso a chamada seja feita atraves do menu, deve-se usar esta User function. Caso a chamada seja feita por um 'batch', utilizar a User Function KMFINBAT

	KMFIN02A01(.T.)

Return

/*
=====================================================================================
Programa.:              KMFINBAT
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            User function criada para preparacao do ambiente + chamada da funcao responsavel pela execucao da conciliacao automatica (chamada via batch)
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
User Function KMFINBAT()

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

	KMFIN02A01(.F.)

	RESET ENVIRONMENT

Return

/*
=====================================================================================
Programa.:              KMFIN02A01
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A01(lInterface)

	Local oProcess

	If !(lInterface) //Nao ha interface com o usuario

		KMFIN02A02() //Descarrega os arquivos do FTP

		KMFIN02A03(.F.) //Efetua a leitura do(s) arquivos texto

	Else

		FWMsgRun( , {||KMFIN02A02() }, "Atualizando arquivos", "Baixando os arquivos de baixa do servidor FTP")

		oProcess := MsNewProcess():New({|| KMFIN02A03(.T. , oProcess) },"Baixando Titulos","Aguarde a baixa automatica dos titulos",.T.)

		oProcess:Activate()

	EndIf

Return

/*
=====================================================================================
Programa.:              KMFIN02A02
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            Descarrega os arquivos do FTP
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A02()

	Local oFTP		:= MNGFTP():NEW()

	oFTP:cServidor	:= "ftp2.ainstec.com"
	oFTP:cLogin		:= "komforthouse.ftp"
	oFTP:cSenha		:= "#@$FTPCLI"
	oFTP:cPathDL	:= "\SYSTEM\FTP_DOWNLOAD\CONCILIACAO\"
	oFTP:cPathFTP	:= "/SAIDA/RETORNOS_CONCIL/"

	oFTP:DOWNLOAD()

Return

/*
=====================================================================================
Programa.:              KMFIN02A03
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            Efetua a leitura dos arquivos .txt
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A03(lInterface , oProcess)

	Local oTXT
	Local nX			:= 0
	Local nY			:= 0
	Local nZ			:= 0
	Local cPathOri		:= "\SYSTEM\FTP_DOWNLOAD\CONCILIACAO\"
	Local cArquivo		:= ""
	Local nPosLanc		:= 0
	Local nPosParc		:= 0
	Local nPosTran		:= 0
	Local nPosAut		:= 0
	Local nPosDtPag		:= 0
	Local nPosValor		:= 0
	Local nPosTaxa		:= 0
	Local nPosStatus	:= 0
	Local nPosDtVen		:= 0
	Local nPosBand		:= 0
	Local nPosCart		:= 0
	Local nPosBco		:= 0
	Local nPosAge		:= 0
	Local nPosConta		:= 0
	Local nPosTrack		:= 0
	Local nPosChave		:= 0
	Local nPosFilOri	:= 0
	Local nPosEstab		:= 0
	Local nPosDesc		:= 0
	Local nPosAdqui		:= 0
	Local nPosNSU		:= 0
	Local nPosREFER1	:= 0
	Local nPosREFER2	:= 0
	Local nPosAntec		:= 0
	Local nPosDescAnt	:= 0
	Local nPosTID		:= 0
	Local nPosTerm		:= 0
	Local nPosRO		:= 0
	Local nPosAjuste	:= 0
	Local nPosArq		:= 0
	Local nPosMarkup	:= 0
	Local nPosScheme	:= 0
	Local nPosInter		:= 0
	Local nPosCom		:= 0
	Local aTXT			:= {}
	Local aHeadTMP		:= {}
	Local lCredito		:= .F.
	Local nProc			:= 0
	Local cQryVwTit		:= ""
	Local aTitulo		:= ""
	Local aAreaSE1		:= SE1->(GetArea())
	Local aAreaSE2		:= SE2->(GetArea())
	Local aErros		:= {}
	Local aImp			:= {}
	Local aLog			:= {}
	Local aFiles		:= {}
	Local lErro			:= .F.
	Local lProcessa		:= .T.
	Local nArqProc		:= 0
	Local nValBxa		:= 0
	Local nTotProc		:= 0
	Local nBaixado		:= 0
	Local nJaBaixa		:= 0
	Local nJaBaixaSE2	:= 0
	Local nErros		:= 0
	Local nBxSE2		:= 0
	Local nNotBxSE2		:= 0
	Local aTotais		:= {}
	Local cStatus		:= ""
	Local aGravar		:= {}
	Local oGrava		:= MNGDATA():NEW()
	Local nErrInFile	:= 0
	Local lContinua		:= .F.
	Local oProcTXT		:= MNGTXT():NEW()
	Local cTimeIni		:= Time()
	Local aTMP			:= {}
	Local aView			:= {}
	Local nParcelas		:= {}
	Local lIncBarra		:= .F.
	Local cArqTMP		:= ""
	Private lAutoErrNoFile  := .T.

	oProcTXT:CriaTXT("\SYSTEM\PROC_CONCIL.TXT")

	oProcTXT:FechaTXT()

	aSizes	:= {}

	ADir(cPathOri + "*.*", aFiles, aSizes)

	If (Len(aFiles) > 0)

		If (lInterface)

			oProcess:SetRegua1(Len(aFiles))

		EndIf

		For nX := 1 To Len(aFiles)

			If ("PAGAMENTO" $ aFiles[nX]) .AND. !("BAIXADO" $ aFiles[nX])

				++nTotProc

			EndIf

		Next nX

		aAreaSE2	:= SE2->(GetArea())

		For nZ := 1 TO Len(aFiles)

			lContinua	:= IIF(lInterface , !(oProcess:lEnd) , .T.)

			IF (lContinua)

				cArquivo	:= cPathOri + aFiles[nZ]

				nProc		:= 0

				If !("BAIXADO" $ cArquivo) .AND. ;//Desconsidera arquivos baixados anteriormente.
					("PAGAMENTO" $ cArquivo) //Somente processa os arquivos referente confirmacao de pagamentos. Na pasta(FTP), constam arquivos de retornos de vendas.

					nErrInFile	:= 0 //Conta a quantidade de erros no arquivo. Caso nao encontre nenhum erro, o arquivo nao sera mais processado

					oTXT		:= MNGTXT():NEW()

					lIncBarra	:= .F. //Inicializa o contador da barra de progresso

					Do While (IIF(lInterface ,;
							lProcessa :=  !(oProcess:lEnd) .AND. oTXT:LeTXT(cArquivo) ,;
							lProcessa := oTXT:LeTXT(cArquivo)))//Efetua a leitura coletando 1 registro por iteracao. O Metodo [LeTxt()] esta no fonte KHCLAFUN

						//Se a chamada da rotina foi efetuada atraves do menu, a propriedade 'lEnd' permite que a execucao seja encerrada.
						//Caso contrario, a chamada e efetuada atraves de um 'job' e, como nao ha interface, nao e possivel interromper a execucao.

						If (!lIncBarra)

							lIncBarra	:= .T.

							If (lInterface) //Caso a rotina seja disparada pelo menu, exibe a barra de progresso

								oProcess:SetRegua2(oTXT:nTotReg)

								oProcess:IncRegua1("Processando arquivo : " + AllTrim(Str(++nArqProc)) + " De : " + AllTrim(Str(nTotProc)))

							Else

								++nArqProc

							EndIf

						EndIf

						++nProc

						aTXT	:= aClone(oTXT:aTXT)

						nX		:= 1

						Do Case

							Case (aTXT[nX , 1] == "C01") //Indica para as variaveis aonde estao as colunas

								aHeadTMP		:= aClone(aTXT[nX])

								nPosLanc		:= Ascan(aHeadTMP , "TIPO_LANCAMENTO" )
								nPosParc		:= Ascan(aHeadTMP , "NRO_PARCELA" )
								nPosTran		:= Ascan(aHeadTMP , "TIPO_TRANSACAO" )
								nPosAut			:= Ascan(aHeadTMP , "AUTORIZACAO" )
								nPosDtPag		:= Ascan(aHeadTMP , "DT_PAGAMENTO" )
								nPosValor		:= Ascan(aHeadTMP , "VLR_PAGO" )
								nPosTaxa		:= Ascan(aHeadTMP , "TAXA" )
								nPosStatus		:= Ascan(aHeadTMP , "STATUS" )
								nPosDtVen		:= Ascan(aHeadTMP , "DT_VENDA" )
								nPosBand		:= Ascan(aHeadTMP , "BANDEIRA" )
								nPosCart		:= Ascan(aHeadTMP , "MASC_CARTAO" )
								nPosBco			:= Ascan(aHeadTMP , "NRO_BANCO" )
								nPosAge			:= Ascan(aHeadTMP , "NRO_AGENCIA" )
								nPosConta		:= Ascan(aHeadTMP , "NRO_CONTA" )
								nPosTrack		:= Ascan(aHeadTMP , "TRACKING_ID" )
								nPosChave		:= Ascan(aHeadTMP , "COD_ERP" )
								nPosFilOri		:= Ascan(aHeadTMP , "LOJA_FIL" )
								nPosEstab		:= Ascan(aHeadTMP , "ESTABELECIMENTO" )
								nPosDesc		:= Ascan(aHeadTMP , "DESCRICAO" )
								nPosAdqui		:= Ascan(aHeadTMP , "ADQUIRENTE" )
								nPosNSU			:= Ascan(aHeadTMP , "NSU" )
								nPosREFER1		:= Ascan(aHeadTMP , "REFER1")
								nPosREFER2		:= Ascan(aHeadTMP , "REFER2")
								nPosAntec		:= Ascan(aHeadTMP , "NRO_ANTECIPACAO")
								nPosDescAnt		:= Ascan(aHeadTMP , "VLR_DESC_ANTECIP")
								nPosTID			:= Ascan(aHeadTMP , "TID")
								nPosTerm		:= Ascan(aHeadTMP , "TERMINAL")
								nPosRO			:= Ascan(aHeadTMP , "NR_RO")
								nPosAjuste		:= Ascan(aHeadTMP , "NR_RO_AJUSTE")
								nPosArq			:= Ascan(aHeadTMP , "NOME_ARQUIVO")
								nPosMarkup		:= Ascan(aHeadTMP , "VALOR_MARKUP")
								nPosScheme		:= Ascan(aHeadTMP , "VALOR_SCHEMEFEE")
								nPosInter		:= Ascan(aHeadTMP , "VALOR_INTERCHANGE")
								nPosCom			:= Ascan(aHeadTMP , "VALOR_COMISSAO")

							Case (aTXT[nX , 1] == "C02")

								If (aTXT[nX , nPosStatus] == "1") ; //Somente processa as linhas quando linha iniciar com 'C02' E Status conciliado (Status = 1)
								.AND. (aTXT[nX , nPosLanc] == "PCV") // E Tipo de lancamento 'PCV'

									If !(IsNumeric(aTXT[nX , nPosAut]))
										//Verifica se o conteudo do campo NAO e numerico. Nem todas as autorizacoes sao informadas no formato numerico e quando isto ocorrer:
										//1) O campo vem informado neste formato -> "000LVGQ3C";
										//2) Os campos que armazenam esta informaçao sao de livre digitaçao, portanto, é possível que o campo esteja informado como "LVGQ3C". Com isto, impede que
										// Os registros sejam localizados na query que gera a view;
										//3) Para garantir que os registros sejam localizados, retiram-se os '0' a esquerda, desta forma, localiza-se o conteudo "LVGQ3C" no campo E1_DOCTEF ou E1_NSUTEF

										cNSU		:= aTXT[nX , nPosAut]

										nY			:= 0

										Do While ( SubStr(cNSU , ++nY , 1) == "0")//Posiciona o cursor na primeira ocorrencia diferente de '0'

										EndDo

										cNSU		:= SubStr(aTXT[nX , nPosAut] , nY , Len(aTXT[nX , nPosAut]) )

									Else

										cNSU		:= ALLTRIM(STR(VAL(aTXT[nX , nPosAut])))

									EndIf

									//Cria uma query para que os campos E1_DOCTEF e E1_NSUTEF sejam preenchidos com '0' a esquerda do campo.
									//Isto foi feito pois o campo NSU tem a digitacao livre e nao e' garantido que usar a funcao 'like' permita a correta localizacao do NSU(campo autorizacao no arquivo texto).

									cQryVwTit	:= " SELECT SE1.R_E_C_N_O_ REGISTRO, SE1.E1_PREFIXO PREFIXO , SE1.E1_NUM NUM , REPLICATE('0', DATALENGTH(SE1.E1_PARCELA) - LEN(SE1.E1_PARCELA)) + SE1.E1_PARCELA PARCELA , "
									cQryVwTit	+= " SE1.E1_TIPO TIPO , SE1.E1_EMISSAO EMISSAO, SE1.E1_VENCREA VENCREA, SE1.E1_XNCART4 FINAL_CARTAO, SE1.E1_XDSCADM BANDEIRAADM, E1_XFLAG BANDEIRAFLAG,"
									cQryVwTit	+= " REPLICATE('0', DATALENGTH(E1_DOCTEF) - LEN(SE1.E1_DOCTEF)) + RTRIM(SE1.E1_DOCTEF) DOCTEF, "
									cQryVwTit	+= " REPLICATE('0', DATALENGTH(E1_NSUTEF) - LEN(SE1.E1_NSUTEF)) + RTRIM(SE1.E1_NSUTEF) NSUTEF "
									cQryVwTit	+= " FROM SE1010 SE1 (NOLOCK)"
									cQryVwTit	+= " WHERE SE1.D_E_L_E_T_ = '' "
									cQryVwTit	+=		" AND RIGHT(RTRIM(SE1.E1_NSUTEF) , " + AllTrim(Str(Len(cNSU))) + ") = '" + cNSU + "'"

									If ( "CREDITO" $ aTXT[nX , nPosTran] )

										lCredito	:= .T.

										cQryVwTit	+=		" AND SE1.E1_TIPO = 'CC' "

									Else

										lCredito	:= .F.

										cQryVwTit	+=		" AND SE1.E1_TIPO = 'CD' " //Se pago em cartao de debito, retorna o tipo 'CD'

									EndIf

									cQryVwTit	+=		" AND RTRIM(SE1.E1_XNCART4) = '" + Right(AllTrim(aTXT[nX , nPosCart]) , 4) + "'"

									cQryVwTit	+= " ORDER BY E1_FILIAL , E1_VENCREA , E1_NOMCLI , E1_PREFIXO , E1_NUM , E1_PARCELA "

									cQryVwTit	:= StrTran(cQryVwTit , Space(2) , Space(1))

									If (Select("TMP02") > 0)

										TMP02->(dbCloseArea())

									EndIf

									dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQryVwTit) , "TMP02" , .F. , .T.)

									If (TMP02->(!EOF()))

										aView	:= {}

										If (lCredito)

											TMP02->(dbGoTop())

											nParcelas	:= 0

											Do While TMP02->(!EOF())

												aTMP	:= Array(TMP02->(fCount()) + 1) //Adiciono mais um item para salvar o numero da parcela no ultimo item do array

												For nY := 1 To TMP02->(fCount()) + 1

													If (nY == Len(aTMP))

														aTMP[nY]	:= StrZero(++nParcelas , 2)

													Else

														aTMP[nY]	:= TMP02->(FieldGet(nY))

													EndIf

												Next nY

												TMP02->(dbSkip())

												AADD(aView , aClone(aTMP))

											EndDo

											nY			:= 0

											nRegistro	:= 0

											Do While (nRegistro == 0) .AND. (++nY <= Len(aView))

												If (AllTrim(aView[nY , TMP02->(FieldPos("DOCTEF"))]) == StrTran(PadL(AllTrim(aTXT[nX , nPosAut]) , TamSX3("E1_DOCTEF")[1]) , Space(1) , '0')) .OR.;
													(AllTrim(aView[nY , TMP02->(FieldPos("NSUTEF"))]) == StrTran(PadL(AllTrim(aTXT[nX , nPosAut]) , TamSX3("E1_NSUTEF")[1]) , Space(1) , '0'))

													If (nY == Val(Left(aTXT[nX , nPosParc],2))) //Percorre as parcelas até que o contador(nY) seja igual a parcela informada no arquivo retorno

														nRegistro	:= aView[nY , TMP02->(FieldPos("REGISTRO"))]

													EndIf

												EndIf

											EndDo

										Else

											nRegistro	:=	FieldGet(TMP02->(FIELDPOS("REGISTRO")))

										EndIf

										aErros		:= {}

										aAreaSE1	:= SA1->(GetArea())

										SE1->(dbGoTop())

										SE1->(dbGoTo(nRegistro))

										cStatus		:= ""

										If (SE1->E1_SALDO > 0) //Executa a baixa apenas para titulos com saldo

											dVencAnt	:= cToD(aTXT[nX , nPosDtPag]) - 5

											dVencPos	:= cToD(aTXT[nX , nPosDtPag]) + 5

											If ( ((SE1->E1_VENCREA >= dVencAnt ) ) .AND. ((SE1->E1_VENCREA) <= dVencPos) )
												//Trava solicitada pelo Mohammed para avaliar a data de vencimento do título. Somente baixa se a data estiver no periodo compreendido entre 5 dias antes ou depois do vencimento

												aTitulo		:= {SE1->E1_FILIAL		,;
																SE1->E1_PREFIXO		,;
																SE1->E1_NUM			,;
																SE1->E1_PARCELA		,;
																SE1->E1_TIPO		,;
																SE1->E1_CLIENTE		,;
																SE1->E1_LOJA		,;
																"NOR"				,;
																SE1->E1_VALOR		,;	//Val(aTXT[nX , nPosValor ]) / 100,;
																cToD(aTXT[nX , nPosDtPag]),;
																"C01"				,;
																"00001"				,;
																"0000000001"		,;
																dDataBase			,;
																SE1->E1_PORTADO		,;
																"Bx. Aut. Concil"	;
																}

												RestArea(aAreaSE1)

												If !(KMFIN02A04(aTitulo)) //Executa a baixa automatica do titulo

													aLog 	:= GetAutoGRLog()

													lErro	:= .T.

													nY		:= 0

													Do While (lErro) .AND. (++nY <= Len(aLog))

														lErro	:= !(aLog[nY]) $ "BAIXADO"

													EndDo

													If !(lErro) // Informa erro na execucao da baixa, caso o erro seja diferente de 'TITULO JA BAIXADO'

														For nY := 1 TO Len(aLog)

															AADD(aErros , aLog[nY])

														Next nY

														cStatus		:= aLog[nY]

													Else

														//Atualiza o campo customizado para informar que a baixa foi executada atraves da rotina de conciliacao.

														cStatus		:= "Título a receber já baixado"

														SE1->(dbGoTo(nRegistro))

													EndIf

												Else

													cStatus		:= "Título a receber baixado"

													++nBaixado

												EndIf

												SE1->(dbGoTo(nRegistro))

												If (SE1->(!EOF())) .AND. (RecLock("SE1" , .F.))

													SE1->E1_XBXDESC	:= 'Bx. Aut. Concil_' + dToS(dDataBase) + "_"+ AllTrim(Str(nRegistro))

													SE1->E1_XTRCID	:= aTXT[nX , nPosTrack]

													SE1->(MsUnlock())

												EndIf

												nValBxa		:= 0

												SE2->(dbSetOrder(1))

												If (SE2->(dbSeek(xFilial("SE2") + SE1->("TXA" + E1_NUM + E1_PARCELA + E1_TIPO) ))) //Posiciona no titulo a pagar

													If (SE2->E2_SALDO > 0)

														nValBxa		:= SE2->E2_SALDO + Val(aTXT[nX , nPosValor ]) / 100

													Else

														++nJaBaixaSE2

														cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar já baixado "

													EndIf

												Else

													nValBXA		:= -1

												EndIf

												If (nValBxa > 0) //Encontrou o titulo a pagar

													aTitulo		:= {SE2->E2_PREFIXO		,;
																	SE2->E2_NUM			,;
																	SE2->E2_PARCELA		,;
																	SE2->E2_TIPO		,;
																	SE2->E2_FORNECE		,;
																	SE2->E2_LOJA		,;
																	SE2->E2_PORTADO		,;
																	"NOR"				,;
																	dDataBase			,;
																	"Bx. Aut. Concil"	,;
																	SE2->E2_SALDO		,;
																	}

													If !(KMFIN02A06 (aTitulo))//Ocorreu algum erro na rotina automatica. Neste caso, e' gerado log com a ocorrencia

														aLog 	:= GetAutoGRLog()

														lErro	:= .T.

														nY		:= 0

														Do While (lErro) .AND. (++nY <= Len(aLog))

															lErro	:= !(aLog[nY]) $ "BAIXADO"

														EndDo

														If !(lErro)

															For nY := 1 TO Len(aLog)

																AADD(aErros , aLog[nY])

															Next nY

															cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Erro na baixa do título a pagar : " + aLog[nY]

														Else

															++nJaBaixaSE2 //Incrementa a quantidade de titulos baixados anteriormente

															cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar já baixado "

														EndIf

													Else

														++nBxSE2 //Incrementa a quantidade de títulos baixados

														cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar baixado "

													EndIf

												Else

													If (nValBxa == -1)

														cMsg		:= "Titulo a pagar nao localizado"

														AADD(aErros , cMsg)

														If (Ascan( aImp , {|x| x[1] == aTxt[nX , nPosAut] .AND. x[2] == Right(AllTrim(aTXT[nX , nPosCart]) , 4)} ) == 0 )
															//Se a inconsistencia nao for localizada no array aimp, grava.
															//Para casos em que o mesmo registro de baixa seja gerado em mais de um arquivo.

															++nNotBxSE2

															++nErrInFile

															AADD(aImp , {aTxt[nX , nPosAut] , Right(AllTrim(aTXT[nX , nPosCart]) , 4) , cMsg})

														EndIf

														cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar nao localizado "

													EndIf

												EndIf

											Else

												If (Ascan( aImp , {|x| x[1] == aTxt[nX , nPosAut] .AND. x[2] == Right(AllTrim(aTXT[nX , nPosCart]) , 4)} ) == 0 )

													aErros	:= {}

													AADD(aErros , "Título fora do prazo de 5 dias")

													cMsg	:= ""

													For nY := 1 TO Len(aErros)

														cMsg	+= aErros[nY]

													Next nY

													//Se a inconsistencia nao for localizada no array aimp, grava.
													//Para casos em que o mesmo registro de baixa seja gerado em mais de um arquivo.

													++nErros

													++nErrInFile

													AADD(aImp , {aTxt[nX , nPosAut] , Right(AllTrim(aTXT[nX , nPosCart]) , 4) , cMsg})

												EndIf

												cStatus		:= "Título com vencimento fora do prazo de 5 dias"

											EndIf

										Else

											cStatus		:= "Título a receber já baixado"

											SE1->(dbGoTo(nRegistro))

											If (SE1->(!EOF())) .AND. (RecLock("SE1" , .F.))

												//Por algum motivo desconhecido, na execucao da rotina automatica, alguns registros nao foram localizados pelo 'dbGoTo'. Entao, verifico se o ponteiro nao esta no final do arquivo.
												//Se nao estiver, atualiza o campo customizado para informar que a baixa foi executada atraves da rotina de conciliacao.

												++nJaBaixa

												SE1->E1_XBXDESC	:= 'Bx. Aut. Concil_' + dToS(dDataBase) + "_"+ AllTrim(Str(nRegistro))

												SE1->E1_XTRCID	:= aTXT[nX , nPosTrack]

												SE1->(MsUnlock())

											EndIf

											nValBxa		:= 0

											SE2->(dbSetOrder(1))

											If (SE2->(dbSeek(xFilial("SE2") + SE1->("TXA" + E1_NUM + E1_PARCELA + E1_TIPO) ))) //Posiciona no titulo a pagar

												If (SE2->E2_SALDO > 0)

													nValBxa		:= SE2->E2_SALDO + Val(aTXT[nX , nPosValor ]) / 100

												Else

													++nJaBaixaSE2

													cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar já baixado "

												EndIf

											Else

												nValBXA		:= -1

											EndIf

											If (nValBxa > 0) //Encontrou o titulo a pagar

												aTitulo		:= {SE2->E2_PREFIXO		,;
																SE2->E2_NUM			,;
																SE2->E2_PARCELA		,;
																SE2->E2_TIPO		,;
																SE2->E2_FORNECE		,;
																SE2->E2_LOJA		,;
																SE2->E2_PORTADO		,;
																"NOR"				,;
																dDataBase			,;
																"Bx. Aut. Concil"	,;
																SE2->E2_SALDO		,;
																}

												If !(KMFIN02A06 (aTitulo))//Ocorreu algum erro na rotina automatica. Neste caso, e' gerado log com a ocorrencia

													aLog 	:= GetAutoGRLog()

													lErro	:= .T.

													nY		:= 0

													Do While (lErro) .AND. (++nY <= Len(aLog))

														lErro	:= !(aLog[nY]) $ "BAIXADO"

													EndDo

													If !(lErro)

														For nY := 1 TO Len(aLog)

															AADD(aErros , aLog[nY])

														Next nY

														cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Erro na baixa do título a pagar : " + aLog[nY]

													Else

														++nJaBaixaSE2 //Incrementa a quantidade de titulos baixados anteriormente

														cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar já baixado "

													EndIf

												Else

													++nBxSE2 //Incrementa a quantidade de títulos baixados

													cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar baixado "

												EndIf

											Else

												If (nValBxa == -1)

													cMsg		:= "Titulo a pagar nao localizado"

													AADD(aErros , cMsg)

													If (Ascan( aImp , {|x| x[1] == aTxt[nX , nPosAut] .AND. x[2] == Right(AllTrim(aTXT[nX , nPosCart]) , 4)} ) == 0 )
														//Se a inconsistencia nao for localizada no array aimp, grava.
														//Para casos em que o mesmo registro de baixa seja gerado em mais de um arquivo.

														++nNotBxSE2

														++nErrInFile

														AADD(aImp , {aTxt[nX , nPosAut] , Right(AllTrim(aTXT[nX , nPosCart]) , 4) , cMsg})

													EndIf

													cStatus		+= IIF(!Empty(cStatus) , " | " , "" ) + "Título a pagar nao localizado "

												EndIf

											EndIf

										EndIf

										aTitulo		:= {}

										If (lInterface)

											oProcess:IncRegua2("Registros Processados : " + AllTrim(Str(nProc)) + " De : " + AllTrim(Str(oTXT:nTotReg)))

										Else

											oProcTXT:AbreTXT("\SYSTEM\PROC_CONCIL.TXT")

											oProcTXT:GravaTXT(.F. , "Processando arquivo : " + AllTrim(Str(nArqProc)) + " De : " + AllTrim(Str(nTotProc)) + CHR(13) + CHR(10) + ;
											"Registros Processados : " + AllTrim(Str(nProc)) + " De : " + AllTrim(Str(oTXT:nTotReg)))

											oProcTXT:FechaTXT()

										EndIf

									Else

										aErros	:= {}

										cQryVwTit	:= " SELECT E1_NSUTEF , E1_XNCART4 "
										cQryVwTit	+= " FROM SE1010 SE1 (NOLOCK)"
										cQryVwTit	+= " WHERE SE1.D_E_L_E_T_ = '' "
										cQryVwTit	+=		" AND RIGHT(RTRIM(SE1.E1_NSUTEF) , " + AllTrim(Str(Len(cNSU))) + ") = '" + cNSU + "'"
										cQryVwTit	:= StrTran(cQryVwTit , Space(2) , Space(1))

										If (Select("TMP02") > 0)

											TMP02->(dbCloseArea())

										EndIf

										dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQryVwTit) , "TMP02" , .F. , .T.)

										Do Case

											Case (TMP02->(EOF()))

												AADD(aErros , " Nao foi localizado o código da autorizacao[NSU]")

												cStatus		:= "Título a receber nao encontrado"

											OtherWise

												AADD(aErros , " O final do cartao(arquivo conciliaçao) : " + Right(AllTrim(aTXT[nX , nPosCart]) , 4) + " está diferente do final do cartao cadastrado no título : " +  TMP02->E1_XNCART4)

												cStatus		:= aErros[1]

										EndCase

										cMsg	:= aErros[1]

										If (Ascan( aImp , {|x| x[1] == aTxt[nX , nPosAut] .AND. x[2] == Right(AllTrim(aTXT[nX , nPosCart]) , 4)} ) == 0 )

											//Se a inconsistencia nao for localizada no array aimp, grava.
											//Para casos em que o mesmo registro de baixa seja gerado em mais de um arquivo.

											++nErros

											++nErrInFile

											AADD(aImp , {aTxt[nX , nPosAut] , Right(AllTrim(aTXT[nX , nPosCart]) , 4) , cMsg})

										EndIf

									EndIf

									aGravar		:=	{;
														{"ZK3_FILIAL" 	, cEmpAnt},;
														{"ZK3_TPREG"	, "C01"},;
														{"ZK3_CHAVE"	, aTXT[nX , nPosChave]},;
														{"ZK3_FILORI"	, aTXT[nX , nPosFilOri]},;
														{"ZK3_ESTAB"	, aTXT[nX , nPosEstab]},;
														{"ZK3_TPLAN"	, aTXT[nX , nPosLanc]},;
														{"ZK3_DESC"		, aTXT[nX , nPosDesc]},;
														{"ZK3_PARC"		, aTXT[nX , nPosParc]},;
														{"ZK3_ADQU"		, aTXT[nX , nPosAdqui]},;
														{"ZK3_BAND"		, aTXT[nX , nPosBand]},;
														{"ZK3_TPTRAN"	, IIF(aTXT[nX , nPosTran] == "C" , "1" , "2")},;
														{"ZK3_NSU"		, aTXT[nX , nPosNSU]},;
														{"ZK3_AUTORI"	, aTXT[nX , nPosAut]},;
														{"ZK3_DTPGTO"	, aTXT[nX , nPosDtPag]},;
														{"ZK3_VLRPAG"	, AllTrim(Str(Val(aTXT[nX , nPosValor]) / 100 , 2))},;
														{"ZK3_TAXA"		, AllTrim(Str(Val(aTXT[nX , nPosTaxa]) / 100 , 2))},;
														{"ZK3_STATUS"	, aTXT[nX , nPosStatus]},;
														{"ZK3_REF1"		, aTXT[nX , nPosREFER1]},;
														{"ZK3_REF2"		, aTXT[nX , nPosREFER2]},;
														{"ZK3_NRANT"	, aTXT[nX , nPosAntec]},;
														{"ZK3_VLRANT"	, AllTrim(Str(Val(aTXT[nX , nPosDescAnt]) / 100 , 2))},;
														{"ZK3_BANCO"	, aTXT[nX , nPosBco]},;
														{"ZK3_AGENC"	, aTXT[nX , nPosAge]},;
														{"ZK3_CONTA"	, aTXT[nX , nPosConta]},;
														{"ZK3_TID"		, aTXT[nX , nPosTID]},;
														{"ZK3_TERMIN"	, aTXT[nX , nPosTerm]},;
														{"ZK3_DTVEN"	, aTXT[nX , nPosDtVen]},;
														{"ZK3_MASCCD"	, aTXT[nX , nPosCart]},;
														{"ZK3_FILE"		, SubStr(cArquivo , Rat("\" , cArquivo ) + 1 , Len(cArquivo))},;
														{"ZK3_OBS"		, cStatus},;
														{"ZK3_DTBX"		, dDataBase};
												}

									oGrava:GravaData(	"ZK3" 	,; 	//Alias
														.T. 	,; 	//'.T.' para novo registro. '.F.' para atualizaçao
														aGravar) 	// Array com os campos/conteúdos para gravaçao.


								EndIf

						EndCase					

					EndDo

					oTXT:FechaTXT()

					If (nErrInFile == 0)
					
						cArqTMP	:= aFiles[nZ]

						__CopyFile(cArquivo , cPathOri + "BAIXADOS\" + dToS(dDataBase) + "_BAIXADO_" + cArqTMP)
						//Nao existem mais titulos a baixar. Neste caso, cria uma copia do arquivo e renomeia, inserindo a data da baixa + "baixado", para impedir que o arquivo seja utilizado para baixa novamente.

						fErase(cArquivo)

					EndIf

					FreeObj(oTXT)

				EndIf

			Endif

		Next nZ

		For nX := 1 TO Len(aFiles)

			cArquivo	:= cPathOri + aFiles[nX]

			If ('VENDA' $ cArquivo)

				If (__CopyFile(cArquivo , cPathOri + "BAIXADOS\" + dToS(dDataBase) + "_BAIXADO_" + aFiles[nX]))

					fErase(cArquivo)

				EndIf

			EndIf

		Next nX

		oProcTXT:AbreTXT("\SYSTEM\PROC_CONCIL.TXT")

		oProcTXT:GravaTXT(.T. , "Tempo total de processamento: " + ElapTime(cTimeIni , Time()))

		oProcTXT:FechaTXT()

		AADD(aTotais , {"Quantidade de títulos a receber baixados: " , nBaixado})
		AADD(aTotais , {"Quantidade de títulos a receber baixados anteriormente: " , nJaBaixa})
		AADD(aTotais , {"Quantidade de títulos a receber nao baixados: " , nErros})
		AADD(aTotais , {"Quantidade de títulos a pagar baixados: " , nBxSE2})
		AADD(aTotais , {"Quantidade de títulos a pagar baixados anteriormente: " , nJaBaixaSE2})
		AADD(aTotais , {"Quantidade de títulos a pagar nao baixados: " , nNotBxSE2})

		If (Len(aImp)) //Se forem encontrados erros durante o processamento

			KMFIN02A05(aImp , aTotais) //Envia o e-mail anexando planilha com os erros encontrados durante o processamento.

		Else

			KMFIN02A07("" , aTotais) // Envia o e-mail sem a planilha, uma vez que nao foram encontrados erros durante o processamento.

			fErase("\SYSTEM\ERROS_FINA070.XML")

		EndIf

		RestArea(aAreaSE1)

		RestArea(aAreaSE2)

		oProcTXT:FechaTXT()

	EndIf

Return

/*
=====================================================================================
Programa.:              KMFIN02A04
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            Efetua a baixa do titulo
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A04(aTitulo)

	Local aBaixa 			:= {}
	Local cFilOld			:= cFilAnt
	Local lRet				:= .T.
	Local nX				:= 0

	Private lMSHelpAuto		:= .T.
	Private lMsErroAuto 	:= .F.

	/* o Array 'aBaixa' esta ordenado de acordo com o array 'aTitulo' passado por parametro, chamado pela funcao KMFIN02A03. */

	cFilAnt 	:= 	IIF(!Empty(  aTitulo[++nX]) ,  aTitulo[nX] , cFilAnt )
	AAdd(aBaixa,{"E1_PREFIXO"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_NUM"    	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_PARCELA"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_TIPO"   	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_CLIENTE"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_LOJA"   	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTMOTBX"  	,aTitulo[++nX]  , Nil})
	aAdd(aBaixa,{"AUTVALREC"    ,aTitulo[++nX]  , Nil})
	AAdd(aBaixa,{"AUTDTBAIXA"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTBANCO"		,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTAGENCIA"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTCONTA"		,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTDTCREDITO"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_PORTADO"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E1_XBXDESC"	,aTitulo[++nX]	, Nil})

	lMsErroAuto	:= .F.

	MsExecAuto({|x,y|FINA070(x,y)},aBaixa,3)
	//MsExecAuto({|x,y|FINA070(x,y)},aBaixa,5)

	IF (lMsErroAuto)
		MostraErro("\SYSTEM\" , "KMFINA02A_ERROS_CONTAS_A_RECEBER.TXT")
		lRet := .F.
	EndIF

	cFilAnt := cFilOld

Return lRet

/*
=====================================================================================
Programa.:              KMFIN02A05
Autor....:              Luis Artuso
Data.....:              08/11/2019
Descricao / Objetivo:
Doc. Origem:            Executa a impressao do relatorio
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A05(aImp , aTotais)

	Local aCab		:= {}
	Local nX		:= 0
	Local oExcel	:= FwMsExcel():New()
	Local cArqErro	:= GetTempPath() + "\ERROS_FINA070.xml"

	oExcel:AddworkSheet("Inconsistencias")

	oExcel:AddTable ("Inconsistencias","Titulo")

	aCab	:= {"NSU",;
				"Final_Cartao",;
				"Inconsistencia(s)"}

	For nX := 1 TO Len(aCab)

		oExcel:AddColumn("Inconsistencias" , "Titulo" , aCab[nX])

	Next nX

	For nX := 1 TO Len(aImp)

		oExcel:AddRow("Inconsistencias" , "Titulo" , aImp[nX])

	Next nX

	oExcel:Activate()
	oExcel:GetXMLFile(cArqErro)

	KMFIN02A07(cArqErro , aTotais)

Return

/*
=====================================================================================
Programa.:              KMFIN02A06
Autor....:              Luis Artuso
Data.....:              19/11/2019
Descricao / Objetivo:
Doc. Origem:            Executa a baixa automatica do titulo a pagar
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A06 (aTitulo)

	Local nX			:= 0
	Local aBaixa		:= {}
	Local lRet			:= .F.
	Private lMsErroAuto	:= .F.

	AAdd(aBaixa,{"E2_PREFIXO"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_NUM"    	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_PARCELA"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_TIPO"   	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_FORNECE"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_LOJA"   	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"E2_PORTADO"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTMOTBX"  	,aTitulo[++nX]  , Nil})
	AAdd(aBaixa,{"AUTDTBAIXA"	,aTitulo[++nX]	, Nil})
	AAdd(aBaixa,{"AUTHIST"		,aTitulo[++nX]	, Nil})
	aAdd(aBaixa,{"AUTVALREC"    ,aTitulo[++nX]  , Nil})

	MsExecAuto({|x,y| Fina080(x,y)} , aBaixa , 3)
	//MsExecAuto({|x,y| Fina080(x,y)} , aBaixa , 5)

	IF (lMsErroAuto)

		MostraErro("\SYSTEM\" , "KMFINA02A_ERROS_CONTAS_A_PAGAR.TXT")

	Else

		lRet	:= .T.

	EndIf

Return lRet

/*
=====================================================================================
Programa.:              KMFIN02A07
Autor....:              Luis Artuso
Data.....:              19/11/2019
Descricao / Objetivo:
Doc. Origem:            Envia o e-mail com os erros apurados durante o processamento
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
Static Function KMFIN02A07(cArqErro , aTotais)

	Local oMail		:= MNGMAIL():NEW()
	Local nX		:= 0
	Local cHtml		:= ""

	oMail:cDe		:= SuperGetMv("MV_RELFROM" , NIL , "")
	oMail:cPara		:= SuperGetMv("KH_ENDCONCIL" , , 'luis.artuso@komforthouse.com.br;mohammed.sinno@komforthouse.com.br')
	//oMail:cPara		:= 'luis.artuso@komforthouse.com.br'
	oMail:cSenha	:= SuperGetMv("MV_RELPSW" , , "")
	oMail:cAssunto	:= 'Conciliaçao Bancária - Resumo de processamento'

	cHtml 	:= "<html>"

	cHtml 	+= "<div><span class=610203920-12022004><FONT face=Verdana color=#ff0000 size=2>"

	cHtml 	+= "<strong>Conciliaçao Bancária - Resumo de processamento</strong></font></span></div><hr>"

	For nX := 1 To Len(aTotais)

		cHtml   	+= "<div><font face='Verdana' color='#000080' size='2'><span class=216593018-10022004>" + aTotais[nX , 1] + AllTrim(Str(aTotais[nX , 2])) +"</span></font></div>"

		cHtml		+= "<br>"

	Next nX

	cHtml += "</html>"

	oMail:cMensagem	:= cHtml

	oMail:cSMTP		:= SuperGetMv("MV_RELSERV" , , "") // Informa o SMTP para conexao

	If !(Empty(cArqErro)) //Se foram encontrados erros, anexa o arquivo

		oMail:cAnexo	:= cArqErro

	EndIf

	oMail:lTLS		:= .T.

	oMail:Envia()

Return