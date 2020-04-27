#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF
#INCLUDE 'FILEIO.CH'

// Constante para final de linha
#define pEOL                             CHR(13)+CHR(10)

#xtranslate ToLog( <cHeader>, <xData> )  => { <cHeader>, <xData>}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Microsiga           º Data ³  02/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TudoOk do cadastro de produtos                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º                          ALTERAÇÕES                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º Mário - ERPLUS ³ Inclusão das validações para o código EAN.           º±±
±±º 12/02/2014     ³                                                      º±±
±±º                ³                                                      º±±
±±º                ³                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A010TOK()
Local aArea		:= GetArea()
Local lRet		:= .T.
Local cTipo		:= SuperGetMv("KH_TPPROD",.F.,"ME")
Local oEAN
Local cPfxGS1	:= SuperGetMV("KH_PRFXEAN",.F.,"78998552") //#RVC20180413.n

// Projeto de validação do EAN.
If lRet
	If Alltrim(M->B1_TIPO) $ cTipo
		If Empty(M->B1_CODBAR)
			If AVISO("Código EAN","Atenção!!! EAN em branco, deseja prosseguir assim mesmo???",{"Sim","Não"},2) == 1
				lRet := .T.
			Else
				If AVISO("Código EAN","Verificar novo código EAN disponível???",{"Sim","Não"},1) == 1			
					oEAN := KMESTX01():New( M->B1_COD ,  ,  ,  ,  ,  )
					If oEAN:lCaldSeq()
						If oEAN:lCalcDV()
							M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
						Else
							lRet := .F.
							Alert(oEAN:cMsgErro)
						Endif 
					Else	//#RVC20180416.bn
						oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
						If oEAN:lCaldSeq()
							If oEAN:lCalcDV()
								M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
							Else
								Alert(oEAN:cMsgErro)
							Endif 
						Else
							Alert(oEAN:cMsgErro)
						EndIf	//#RVC20180416.en
//						Alert(oEAN:cMsgErro)	//#RVC20180416.o
					Endif		
				Endif
				lRet := .F.
			Endif
		Else
			
//			Se não for um código Komfort
//			If SUBSTR(M->B1_CODBAR,1,8) == "78998552"	//#RVC20180413.o
			If SUBSTR(M->B1_CODBAR,1,8) $ cPfxGS1		//#RVC20180413.n
				If Len(Alltrim(M->B1_CODBAR)) == 13
					oEAN := KMESTX01():New( M->B1_COD , SUBSTR(M->B1_CODBAR,1,3) , SUBSTR(M->B1_CODBAR,4,5) , SUBSTR(M->B1_CODBAR,9,4) , SUBSTR(M->B1_CODBAR,13,1) ,  )
					If oEAN:lValidDV()
						lRet := .T.
					Else
						lRet := .F.
						Alert(oEAN:cMsgErro)
					Endif
				ElseIf Len(Alltrim(M->B1_CODBAR)) == 12
					oEAN := KMESTX01():New( M->B1_COD , SUBSTR(M->B1_CODBAR,1,3) , SUBSTR(M->B1_CODBAR,4,5) , SUBSTR(M->B1_CODBAR,9,4) ,  ,  )
					If oEAN:lCalcDV()
						M->B1_CODBAR := ALLTRIM(M->B1_CODBAR)+oEAN:cDigVerif
						lRet := .T.
					Else
						lRet := .F.
						Alert(oEAN:cMsgErro)
					Endif
				Else
					lRet := .F.
					Alert("Quantidade de dígitos informada não é válida. O código EAN deve ter 12 dígitos (ocorrerá o cálculo do DV) ou 13 dígitos (não efetuará o cálculo do DV).")
				Endif
				
				If lRet		
					If oEAN:lVldSeq()
						If oEAN:lVldDupli( M->B1_CODBAR )
							lRet := .T.
						Else
							If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR CÓDIGO EAN DUPLICADO ?")
								lRet := .T.
							Else
								lRet := .F.
								If AVISO("Código EAN","Verificar novo código EAN disponível???",{"Sim","Não"},1) == 1
									If oEAN:lCaldSeq()
										If oEAN:lCalcDV()
											M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
										Else
											Alert(oEAN:cMsgErro)
										Endif 
									Else
										oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
										If oEAN:lCaldSeq()
											If oEAN:lCalcDV()
												M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
											Else
												Alert(oEAN:cMsgErro)
											Endif 
										Else
											Alert(oEAN:cMsgErro)
										EndIf	//#RVC20180416.en
//										Alert(oEAN:cMsgErro)	//#RVC20180416.o
									Endif
								Endif
							Endif
						Endif
					Else					
						If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR CÓDIGO EAN DUPLICADO ?")
							lRet := .T.
						Else						
							If AVISO("Código EAN","Verificar novo código EAN disponível???",{"Sim","Não"},1) == 1
								If oEAN:lCaldSeq()
									If oEAN:lCalcDV()
										M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
									Else
										Alert(oEAN:cMsgErro)
									Endif 
								Else
									oEAN := KMESTX01():New( M->B1_COD , "790" , "94870" ,  ,  ,  )
									If oEAN:lCaldSeq()
										If oEAN:lCalcDV()
											M->B1_CODBAR := Alltrim(oEAN:cCodPais) + Alltrim(oEAN:cEmpresa) + Alltrim(oEAN:cSequenc) + Alltrim(oEAN:cDigVerif)			
										Else
											Alert(oEAN:cMsgErro)
										Endif 
									Else
										Alert(oEAN:cMsgErro)
									EndIf	//#RVC20180416.en
//									Alert(oEAN:cMsgErro)	//#RVC20180416.o
								Endif
							Endif
						Endif
					Endif
				Endif
			Else
				oEAN := KMESTX01():New( M->B1_COD ,  ,  ,  ,  ,  )
				If oEAN:lVldDupli( M->B1_CODBAR )
					lRet := .T.
				Else					
					If MSGNOYES(oEAN:cMsgErro +". Prosseguir desta forma?","PERMITIR CÓDIGO EAN DUPLICADO ?")
						lRet := .T.
					Else
						lRet := .F.
					Endif
				Endif
			Endif
		Endif
	Else
		lRet := .T.
	Endif
Endif
// Fim - Projeto de validação do EAN.

// Geracao e gravacao do log de Inclusao e alteracao
If isInCallStack('A010INCLUI') .or. isInCallStack('A010ALTERA')

	BEGIN SEQUENCE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Data: 12/03/2018                                           ³
		//³ Armazenando LOG de Processamento                           ³
		//³ Criar uma pasta \logs\logestoque\                          ³
		//³ Montar o array com os dados a serem gravados no LOG        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³ O arquivo gerado pode ser lido na rotina MA010BUT          ³
		//³ Gerado com a seguinte estrutura:                           ³
		//³ - PRODUTO                                                  ³
		//³ - DESCRICAO                                                ³
		//³ - UNIDADE MEDIDA                                           ³
		//³ - SEGUNDA UNIDADE MEDIDA                                   ³
		//³ - FATOR CONVERSAO                                          ³
		//³ - TIPO DE CONVERSAO                                        ³
		//³ - CONTROLA RASTRO                                          ³
		//³ - CONTROLA ENDERECO                                        ³
		//³ - OPERACAO                                                 ³
		//³ - DATA                                                     ³
		//³ - TIME                                                     ³
		//³ - USUARIO                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If INCLUI
			cOperacao := "INCLUIR"
		ElseIf ALTERA
			cOperacao := "ALTERAR"
		endif

		aLogString := {}
		AADD(aLogString, ToLog( "PRODUTO", PADL(Upper(M->B1_COD), TamSX3("B1_COD")[1], "" ) ) )                     //PRODUTO
		AADD(aLogString, ToLog( "DESCRICAO", PADR(AllTrim(M->B1_DESC), TamSX3("B1_DESC")[1], "" ) ) )               //DESCRICAO
		AADD(aLogString, ToLog( "UNIDADE_MEDIDA", PADR(AllTrim(M->B1_UM), TamSX3("B1_UM")[1], "" ) ) )              //UNIDADE MEDIDA
		AADD(aLogString, ToLog( "SEGUNDA_UNIDADE_MEDIDA", PADR(AllTrim(M->B1_UM), TamSX3("B1_SEGUM")[1], "" ) ) )        //SEGUNDA UNIDADE MEDIDA
		AADD(aLogString, ToLog( "FATOR_CONVERSAO", PADL(Str(M->B1_CONV), TamSX3("B1_CONV")[1], "" ) ) )             //FATOR CONVERSAO
		AADD(aLogString, ToLog( "TIPO_DE_CONVERSAO", PADL(AllTrim(M->B1_TIPCONV), TamSX3("B1_TIPCONV")[1], "" ) ) ) //TIPO DE CONVERSAO
		AADD(aLogString, ToLog( "CONTROLA_RASTRO", PADL(AllTrim(M->B1_RASTRO), TamSX3("B1_RASTRO")[1], "" ) ) )     //CONTROLA RASTRO
		AADD(aLogString, ToLog( "CONTROLA_ENDERECO", PADL(AllTrim(M->B1_LOCALIZ), TamSX3("B1_LOCALIZ")[1], "" ) ) ) //CONTROLA ENDERECO

		AADD(aLogString, ToLog( "OPERACAO", PADL(cOperacao, 7, "") ) )                                              //OPERACAO
		AADD(aLogString, ToLog( "DATA", PADL(DTOS(DATE()), 8, "") ) )                                               //DATA
		AADD(aLogString, ToLog( "HORA", PADL(TIME(), 8, "") ) )                                                     //HORA
		AADD(aLogString, ToLog( "USUARIO", upper(ALLTRIM(SUBSTR(cUsuario,7,15))) ) )                                //USUARIO

		GrvLog( aLogString )

	END SEQUENCE

EndIf

RestArea(aArea)

Return(lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ GrvLog	³ Autor ³ Edilson Mendes        ³ Data ³ 10/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina utilizada para a gravacao do log dos registros       ³±± 
±±³          ³alterados no modulo de estoque.                             ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Modulo Estoque/Custo                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Paramet  ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC PROCEDURE GrvLog(aLogString)

LOCAL cPasta  := "\logs\logestoque"
LOCAL nHandle
LOCAL cNomLog
LOCAL nPos
LOCAL cHeader
LOCAL cString


	BEGIN SEQUENCE

		if ExistDirectory( cPasta ) == 0

			cPasta  := iif( right( alltrim(cPasta), 1 ) == '\', right( alltrim(cPasta), -1 ), alltrim(cPasta) )
			cNomLog := cPasta + "\log-est-" + DTOS( DATE() ) + ".log"
			
			//Realiza a gravacao das informacoes no arquivo de log
			If .NOT. FILE( cNomLog )
				nHandle := FCreate( cNomLog, FC_NORMAL )

				cHeader := ''
				FOR nPos := 1 TO LEN(aLogString)
					cHeader += "<" + aLogString[ nPos ][1] + pEOL
				Next

				FWrite( nHandle, cHeader, len(cHeader + pEOL ) )

			Else
				nHandle := FOPEN( cNomLog, FO_READWRITE + FO_SHARED )
				nLength := FSEEK( nHandle, FS_SET, FS_END)
			Endif
			
			if nHandle > 0

				cString :=  '>'
				FOR nPos := 1 TO LEN(aLogString)
					cString += aLogString[ nPos ][2] + "|"
				Next
				
				FWrite( nHandle, cString + pEOL, len(cString + pEOL ) )
				FClose( nHandle )
			Endif
			
		ENDIF

	END SEQUENCE
			
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ExistDirectory³ Autor ³ Edilson Mendes    ³ Data ³ 10/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina para checar e criar o diretorio caso nao exista.     ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Paramet  ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION ExistDirectory( cPath )

LOCAL nRetValue := 0
LOCAL aDirTemp
LOCAL cString   := ""
LOCAL nPos
LOCAL nPointer

	BEGIN SEQUENCE

		IF .NOT. EMPTY( cPath )
			
			FOR nPos := 1 to LEN( ALLTRIM( cPath ) )
				
				cString += SUBSTR( ALLTRIM( cPath ), nPos, 1 )
				IF SUBSTR( ALLTRIM( cPath ), nPos, 1 ) == "\" .AND. nPos <= LEN( ALLTRIM( cPath ) )
					aDirTemp := Directory( cString + "*.", "D" )
					IF ( nPointer := ASCAN( aDirTemp,{|x| x[5] == "D"})) == 0
						IF ( nRetValue := MakeDir( cString ) ) > 0
							EXIT
						ENDIF
					ENDIF
				ENDIF
				
			NEXT
			
		ENDIF

	END SEQUENCE
		
RETURN( nRetValue )