#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWMVCDEF.CH"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "fileio.ch"

/*
=====================================================================================
Programa.:              DRGCLA
Autor....:              Luis Artuso
Data.....:              04/02/2017
Descricao / Objetivo:
Doc. Origem:            INSTANCIA DA CLASSE DRGCLA
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/

/*
//INICIO DA CLASSE 'DRGCLA'

	CLASS DRGCLA

		Method CheckDupl()

	ENDCLASS

	//############################################################################
	//## Method CheckDupl Class DRGCLA
	//############################################################################
	Method CheckDupl(cAlias) Class DRGCLA//Arquivo Origem (Arquivo que sera' aberto para leitura)

		Local aStru		:=	{}
		Local cQuery	:=	""
		Local nX		:=	0
		Local cFields	:=	""
		Local cAliasTMP	:=	""
		Local oMngQRY	:= MNGQRY():NEW()

		If !(Empty(cAlias))

			aStru	:= (cAlias)->(dbStruct())

			cAliasTMP	:= oMngQRY:CheckTmp()

			cQuery	:=	"WITH " + cAliasTMP + "("

			For nX	:= 1 TO Len(aStru)

				cFields	+=	aStru[nX , 1]	+	","

			Next nX

			cQuery	+=	cFields

			cQuery	+=	"QTD"

			cQuery	+= ")"

			cQuery	+=	" AS ("

			cQuery	+=	" SELECT " + cFields + "COUNT(*) AS QTD FROM " + RetSqlName(cAlias)

			cQuery	+=	" GROUP BY " + SubStr(cFields , 1 , RAT("," , cFields) - 1) + ")"

			cQuery	+=	" SELECT * FROM " + cAliasTMP + " WHERE QTD > 1 "


			//with tmp01 (RD_FILIAL, RD_MAT, QTD)
			//AS( SELECT RD_FILial,RD_MAT, COUNT(*) AS QTD FROM SRD010 GROUP BY RD_FILIAL,RD_MAT)
			//SELECT * FROM TMP01 WHERE QTD > 1

		EndIf

	Return cQuery

//FIM DA CLASSE 'DRGCLA'
*/

/*
=====================================================================================
Programa.:              CLASSE MNGTXT
Autor....:              Luis Artuso
Data.....:              04/02/2017
Descricao / Objetivo:
Doc. Origem:            Esta classe possui metodos para manipulacao de arquivo texto
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
	//############################################################################
	//## Instancia da classe 'MNGTXT'
	//############################################################################
	CLASS MNGTXT

		Data nHandle
		Data cErro
		Data aTXT
		Data nLength
		Data nByte
		Data cRestoTXT
		Data lContou
		Data nTotReg
		Data nRegIni
		Data lCargaIni
		Data nLidos
		Data nSeek
		Data nLastByte
		Data cString

		Method New() CONSTRUCTOR

		Method CriaTXT() //Permite a criacao de um arquivo texto

		Method LeTxt() //Permite a leitura de um arquivo texto

		Method ImpTxt() //Permite a importacao de um arquivo texto

		Method ContaReg() //Permite a contagem de registros do arquivo texto

		Method AbreTXT() //Permite a abertura do arquivo texto

		Method GravaTXT() //Efetua a gravacao em um arquivo texto

		Method FechaTXT() //Fecha o arquivo texto

		Method AtuTmpDB()

		Method TrataTXT()

	ENDCLASS

	//############################################################################
	Method New() CLASS MNGTXT

		::nHandle	:= 0
		::cErro		:= ""
		::aTXT		:= {}
		::nLength	:= 0
		::cRestoTXT	:= ""
		::lContou	:= .F.
		::nTotReg	:= 0
		::nRegIni	:= 0
		::lCargaIni	:= .F.
		::nLidos	:= 0
		::nSeek		:= 0
		::nLastByte	:= 0
		::cString	:= 0

	Return Self

	//############################################################################
	Method CriaTXT(cArqDest) Class MNGTXT

		Local lRet	:= .F.

		If !(Empty(cArqDest))

			::nHandle 	:= fCreate(cArqDest,FO_READWRITE + FO_COMPAT)

			If (::nHandle < 0)

				::cErro	:= "Nao foi possivel criar o arquivo. Motivo:  " + AllTrim(Str(fError()))

			Else

				lRet		:= .T.

			EndIf

		Else

			cRet	:= "Nao foi informado o arquivo a ser criado"

		EndIf

	Return lRet

	//############################################################################
	Method AbreTXT(cArqDest) Class MNGTXT

		Local lRet	:= .F.

		If !(Empty(cArqDest))

			::nHandle 	:= fOpen(cArqDest,FO_READWRITE + FO_EXCLUSIVE)

			If (::nHandle < 0)

				::cErro	:= "Nao foi possivel Abrir o arquivo. Motivo: " + AllTrim(Str(fError()))

			Else

				lRet		:= .T.

			EndIf

		Else

			cRet	:= "Nao foi informado o arquivo a ser Aberto"

		EndIf

	Return lRet

	//############################################################################
	//## Method LeTxt Class MNGTXT
	//############################################################################
	Method LeTxt	(cArqOri	,;	//Arquivo Origem (Arquivo que sera' aberto para leitura)
					nQuant) CLASS MNGTXT

		Local lRet	:= .F.

		If !(::lContou)//Se nao efetuou a contagem dos registros

			::ContaReg(cArqOri)//Efetua a contagem de quantos registros tem no arquivo texto e altera a propriedade 'lContou' para .T.

			lRet	:= .T.
			
			::TrataTXT(cArqOri)

		Else

			::TrataTXT(cArqOri)

			lRet	:= Len(::aTXT) > 0

		EndIf

	Return lRet

	//############################################################################
	Method GravaTXT(lAppend , cString) Class MNGTXT

		Local cEol	:= Chr(13)+Chr(10)

		DEFAULT lAppend	:= .F.

		If (::nHandle >= 0) .AND. (ValType(cString) == "C")

			If (lAppend)

				fSeek(::nHandle ,0 , FS_END)

			EndIf

			fWrite(::nHandle , cString + cEol )

		Else

			::cErro		:= "TIPO DE DADO INVALIDO PARA GRAVACAO"

		EndIf

	Return

	//############################################################################
	//## Method FechaTXT Class MNGTXT
	//############################################################################
	Method FechaTXT() Class MNGTXT

		fClose(::nHandle)

		::nHandle	:= 0

	Return

	//############################################################################
	Method ContaReg(cArquivo) CLASS MNGTXT
	//############################################################################

		::TrataTXT(cArquivo)

		::lContou	:= .T.

		::nSeek		:= 0 //A propriedade 'nSeek' sera zerada para que a funcao 'fSeek' posicione o ponteiro no inicio do arquivo texto

	Return .T.

	//############################################################################
	Method AtuTmpDB(cAliasTMP) CLASS MNGTXT
	//############################################################################
	/*
		O metodo executa a gravacao do array coletado do arquivo texto em uma tabela temporaria, criada pelo metodo 'CriaTMP'. Para gravação, devem ser observadas as seguintes instrucoes:
		1) Sera executado o metodo GravaData
			1.1) Para gravacao, o metodo espera um array com o seguinte formato: nx,1 -> Campo | nx,2 ->Dado


	*/
		Local nX		:= 0
		Local nY		:= 0
		Local oMngData	:= MNGDATA():NEW()
		Local oCarga	:= CARGADADOS():NEW()
		Local aCabec	:= {}
		Local aDados	:= {}

		aCabec		:= aClone(::aTXT[1])

		For nX	:= 2 TO Len(::aTXT)

			aDados		:= aClone(::aTXT[nX])

			oCarga:PrepArray(aCabec , aDados)

			oMNGData:GravaData(cAliasTMP , .T. , oCarga:aRotAut)

		Next nX

	Return

	//############################################################################
	Method TrataTXT(cArqOri) CLASS MNGTXT
	//############################################################################
		Local cString		:= ""
		Local nMaxChr		:= 0
		Local nPosL			:= 0
		Local cChrQuebra	:= CHR(13) + CHR(10)
		Local cStrTMP		:= ""
		Local lFim			:= .F.
		Local nLoop			:= 0

		::aTXT		:= {}

		Do While (IIF(!::lContou , !lFim , nLoop == 0 ))

			If (Empty(::cString))

				If (::AbreTXT(cArqOri)) //Efetua a abertura do arquivo

					FSeek(::nHandle , IIF(::nSeek == 0 , 0 , ::nSeek )) //posiciona o ponteiro para efetuar a leitura do arquivo

					FRead(::nHandle , @cString , 4096) // efetua a leitura de 4 em 4 k

					::cString		:= SubStr(cString , 1 , nMaxChr	:= (MIN(RAT( CHR(13) , cString) , RAT( CHR(10) , cString) ))) // Armazena na variavel o conteudo ate o ultimo separador encontrado
					
					If ((nMaxChr == 0) .AND. (Len(cString) > 0)) //Caso seja a ultima linha, armazena o resto da string
					
						::cString		:= cString
						
						::nSeek			+= Len(::cString)
						
					Else
					
						::nSeek			+= nMaxChr
					
					EndIf					

					::FechaTxt()

				Else

					::cErro			:=	"Não foi possível acesso ao arquivo"

				EndIf

			EndIf

			If (Empty(::cString))

				lFim	:= .T.

			Else

				nPosL		:= 1

				Do While (SubStr(::cString , nPosL , 1) $ cChrQuebra) .AND. (++nPosL < Len(cString))//Posiciona no primeiro caracter diferente de quebra de linha

				EndDo

				::cString		:= SubStr(::cString , nPosL , Len(::cString))

				If ( (nMaxAT 	:= MAX( AT(CHR(13), ::cString) , AT(CHR(10) , ::cString) )) > 0 ) //Verifica a primeira quebra de linha (a esquerda)

					cStrTmp		:= SubStr(::cString , 1 , nMaxAt)

					::cString	:= SubStr(::cString , nMaxAt , Len(::cString))

				Else

					cStrTmp		:= SubStr(::cString , 1 , Len(::cString))

					::cString	:= ""

				EndIf

				cStrTmp		:= StrTran(cStrTmp , CHR(13) , '')

				cStrTmp		:= StrTran(cStrTmp , CHR(10) , '')

				If !(Empty(cStrTmp))

					If !(::lContou)

						++::nTotReg

					Else

						If (AT(";" , cStrTMP) > 0)

							AADD(::aTXT , StrToKarr2(cStrTMP  , ";" , .T.))

						Else

							AADD(::aTXT , cStrTMP)

						EndIf

					EndIf

				Else

					If (Empty(AllTrim(::cString)))
					
						::cString	:= ""
						
					EndIf

				EndIf

			EndIf

			If (::lContou)

				If (Len(::aTXT) > 0 .OR. (lFim))

					++nLoop					

				EndIf

			EndIf

		EndDo

	Return Len(::aTXT) > 0
//FIM DA CLASSE 'MNGTXT'

// INICIO DA CLASSE 'MNGFILE'

	CLASS MNGFILE

		Data cType
		Data cTitulo
		Data nMascPad
		Data cDirIni
		Data lSalvar
		Data cArquivo
		Data lArvore
		Data lKeepCase

		Method New() CONSTRUCTOR

		Method Interface()

	ENDCLASS

	Method New() CLASS MNGFILE

		::cType		:= "Todos Arquivos|*.*|Arquivo TXT|*.TXT"	// Indica os arquivos que podem ser filtrados
		::cTitulo	:= "Selecione o arquivo"					// Titulo da janela
		::nMascPad	:= 0										// Mascara Padrao
		::cDirIni	:= "C:\"									// Diretorio inicial
		::lSalvar	:= .T.										// Informa para a rotina se permite apenas a seleção ou salva em um determinado local. '.T.' -> Abre , '.F.' -> Salva
		::lArvore	:= .T.										// Arquivo Retorno
		::lKeepcase	:= .T.										// Indica se, verdadeiro (.T.), apresenta o árvore do servidor; caso contrário, falso (.F.).
		::cArquivo	:= ""										// Indica se, verdadeiro (.T.), mantém o case original; caso contrário, falso (.F.).

	Return Self

	Method Interface() CLASS MNGFILE

		::cArquivo	:= 	cGetFile(::cType,;
								::cTitulo,;
								::nMascPad,;
								::cDirIni,;
								::lSalvar,;
								GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY,;
								::lArvore,;
								::lKeepCase)

	Return


		USER FUNCTION MNGFILE()

			MNGfile01()

		RETURN

		Static Function MNGfile01

			Local oObj	:= MNGFILE():NEW()

			Local aFile	:= {}

			oObj:Interface()

			aFile	:= oObj:LeTxt(oObj:cArquivo)

		return


// FIM DA CLASSE MNGFILE

// INICIO DA CLASSE MNGQRY

	CLASS MNGQRY

		Data nTotReg
		Data cAliasTMP
		Data cAlias
		Data cClose
		Data cQuery
		Data cError
		Data lCloseArea
		Data aHeader
		Data aData
		Data lArray
		Data lView
		Data aStruSX3
		Data aStruTMP

		Method New() CONSTRUCTOR

		Method ExecQry()

		Method CheckTmp()

		Method CriaTMP()

	ENDCLASS

	Method New() CLASS MNGQRY

		::nTotReg		:= 0
		::cAliasTMP		:= ""
		::cClose		:= ""
		::cQuery		:= ""
		::cError		:= ""
		::lCloseArea	:= .F.
		::aHeader		:= {}
		::aData			:= {}
		::lArray		:= .T.
		::lView			:= .F.
		::aStruSX3		:= {}
		::aStruTMP		:= {}
		::cAlias		:= ""

	Return Self

	//############################################################################
	//## Method ExecQry Class DRGCLA
	//############################################################################
	Method ExecQry() CLASS MNGQRY

		Local nX		:= 0
		Local aTMP		:= {}
		Local lRet		:= 0
		Local cAliasBKP	:= ""

		If !(Empty(::cQuery))

			If (::CheckTMP())

				If (::lView)

					cQuery	:= "DROP VIEW " + ::cAliasTMP

					TcSqlExec(cQuery)

					cQuery	:= "CREATE VIEW " + ::cAliasTMP + " AS " + ::cQuery

					TcSqlExec(cQuery)

					cQuery	:= "SELECT COUNT(*) TOTREG FROM " + ::cAliasTMP

					dbUseArea(.F. , "TOPCONN" , TcGenQry(,,cQuery) , "VIEW" , .T. , .F.)

					::nTotReg	:= VIEW->(TOTREG)

					lRet		:= ::nTotReg > 0

					VIEW->(dbCloseArea())

					TcSqlExec("DROP VIEW " + ::cAliasTMP)

				Else

					(::cAliasTMP)->(dbGoTop())

					Do While (::cAliasTMP)->(!EOF())

						(::cAliasTMP)->(dbSkip(1000))

						If (::cAliasTMP)->(!EOF())

							::nTotReg	+= 1000

						Else

							(::cAliasTMP)->(dbGoTop())

							If (::nTotReg > 0)

								(::cAliasTMP)->(dbSkip(::nTotReg))

							EndIf

							Do While (::cAliasTMP)->(!EOF())

								++::nTotReg

								(::cAliasTMP)->(dbSkip())

							Enddo

						EndIf

					EndDo

					(::cAliasTMP)->(dbGoTop())

					If ( (::lArray) .AND.  ( (::cAliasTMP)->(!EOF()) .OR. (::nTotReg < nLoop0) ) )

						If ( (::nTotReg < nLoop0) )

							//Prevencao de limitacao de dados. Nao e' possivel afirmar que um array armazene quantidade superior a 100.000 itens sem acarretar problemas de memória.

							For nX := 1 TO (::cAliasTMP)->(fCount())

								AADD(::aHeader , (::cAliasTMP)->(FieldName(nX)))

							Next nX

							Do While (::cAliasTMP)->(!EOF())

								For nX := 1 TO (::cAliasTMP)->(fCount())

									AADD(aTMP , (::cAliasTMP)->(FieldGet(nX)))

								Next nX

								AADD(::aData , aClone(aTMP))

								aTMP	:= {}

								(::cAliasTMP)->(dbSkip())

							EndDo

							(::cAliasTMP)->(dbGoTop())

						EndIf

					EndIf

					lRet	:= !Empty( (::cAliasTMP)->(!EOF()) )

				EndIf

				dbUseArea(.F. , "TOPCONN" , TcGenQry(,,::cQuery) , ::cAliasTMP , .T. , .F.)

			Else

				::cError 	:= "Nao foi possível abrir o alias temporario [Excedeu a quantidade de tabelas abertas(255)]"

			EndIf

		Else

			::cError :=		"Nao foi informada a query (Atributo ::cQuery vazio)"

		EndIf

	Return lRet

	//############################################################################
	//## Method CheckTmp Class MNGQRY
	//############################################################################
	Method CheckTmp() CLASS MNGQRY

		Local nSelect	:= 0
		Local lOpen		:= .F.
		Local cAlias	:= Iif (!Empty(::cClose) , ::cClose , ::cAliasTMP ) //Verifica se fecha o ultimo alias utilizado ou fecha o alias informado no atributo 'cClose'

		If (::lCloseArea)

			If (!Empty(cAlias)) .AND. (Select(cAlias) > 0)

				(cAlias)->(dbCloseArea()) //Fecha o Alias Ativo

			EndIf

			::lCloseArea	:= .F. //Inibe o Fechamento do próximo Alias. So' sera encerrado caso o atributo seja preenchido novamente.

			::cClose		:= ""

		EndIf

		Do While !(lOpen) .AND. (++nSelect < 255) // Verifica quantos alias ja' estao abertos. Nao e' possivel abrir mais do que 254 'alias'.

			::cAliasTMP	:= AllTrim(StrZero(Randomize(1,1000),4)) + AllTrim(StrZero(Randomize(1,1000),4)) + AllTrim(StrZero(Randomize(1,10),2))
			//::cAliasTMP	:= "TMP" + StrZero(nSelect , 3)

			lOpen	:= (Select(::cAliasTMP) == 0)

		EndDo

	Return lOpen

	//############################################################################
	Method CriaTMP(cAliasTMP) Class MNGQRY
	//############################################################################
		Local nX			:= 0
		Local aStruTMP		:= {}
		Local aSX3			:= {}
		Local oTempTable 	:= FWTemporaryTable():New(cAliasTMP)

		If (Len(::aStruSX3) > 0)

			For nX	:= 1 TO Len(::aStruSX3)

				aSX3 := TamSX3(AllTrim(::aStruSX3[nX]))

				// Estrutura do array para criacao da tabela temporaria{"DESCR","C",30,0}
				//aSX3 -> 1->Tamanho/2->Decimal/3->Tipo de um Campo

				If (Len(aSX3) > 0)

					AADD(aStruTMP , {::aStruSX3[nX] /*Nome do Campo*/,;
									aSX3[3] /*Tipo do campo*/,;
									aSX3[1] /*Tamanho*/,;
									aSX3[2]/*Casas Decimais*/})

				EndIf

			Next nX

		Else

			aStruTMP	:= aClone(::aStruTMP)

		EndIf

		oTemptable:SetFields(aStruTMP)
		oTempTable:Create(cAliasTMP)

		::cAlias	:= cAliasTMP

	Return

	user function MNGQRY

		MNGQRY01()

	return

	Static Function MNGQRY01()

		Local cQuery	:= ""
		Local oObjGEN	:= MNGENV():NEW()
		Local oObjQRY	:= MNGQRY():NEW()
		Local nTotReg	:= 0
		Local xyz		:= 0

		oObjGEN:PrepareEnv("01","01")

		oObjQRY:cQuery	:= "SELECT SRA.* FROM SRA010 SRA"

		If (oObjQRY:ExecQry())

			xyz	:= 0

		EndIf

	Return

// FIM DA CLASSE MNGQRY

// INICIO DA CLASSE MNGDATA

	CLASS MNGDATA

		Data cAliasS // cAliasSeek
		Data cAliasP // cAliasPut (Alias para gravacao)
		Data aFound
		Data aReturn
		Data aStru

		Method New(	cAliasS	,;	//Atributo que sera utilizado para armazenar o alias em verificacao (funcao dbseek)
				cAliasP		,;
				aFound		,;
				aReturn		,;
				aStru		;
				) CONSTRUCTOR

		Method BuscaData()

		Method GravaData()

		Method RetReg()

	ENDCLASS

	Method New(	cAliasS		,;	//Atributo que sera utilizado para armazenar o alias em verificacao (funcao dbseek)
				cAliasP		,;
				aFound		,;
				aReturn		,;
				aStru		;
				) CLASS MNGDATA

		::cAliasS	:= ""
		::cAliasP	:= ""
		::aFound	:= {}
		::aReturn	:= {}
		::aStru		:= {}

	Return Self

	//############################################################################
	//## Method BuscaData Class MNGDATA
	//############################################################################
	Method BuscaData(cAlias , cChave , nOrder , aFields ) CLASS MNGDATA

		Local nPosSeek	:= 0
		Local nX		:= 0
		Local lFound	:= .F.
		Local lRet		:= .F.
		Local aArea		:= {}

		DEFAULT aFields	:= {}

		If !(Empty(cAlias))

			If !(cAlias == ::cAliasS)

				::aFound	:= {}
				::cAlias	:= cAlias

			EndIf

			nPosSeek	:= Ascan(::aFound , {|X| X[1] == cChave})

			aArea		:= (cAlias)->(GetArea())

			If (nPosSeek) == 0

				DEFAULT nOrder	:= 1

				(cAlias)->(dbSetOrder(nOrder))

				lFound	:= (cAlias)->(dbSeek(cChave))

				If (lFound)

					AADD( ::aFound , {cChave , (cAlias)->(RECNO())} )

					aSort(::aFound)

				EndIf

			Else

				(cAlias)->(dbGoTo(::aFound[nPosSeek , 2]))

			EndIf

			If ( (Len(aFields) > 0) .AND. ((nPosSeek > 0) .OR. (lFound)) )

				::aReturn	:= {}

				lRet		:= .T.

				For nX	:= 1 TO Len(aFields)

					AADD(::aReturn , (cAlias)->(FieldGet(FieldPos(aFields[nX]))))

				Next nX

			EndIf

			RestArea(aArea)

		EndIf

	Return lRet

	//############################################################################
	//## Method RetData Class MNGDATA
	//############################################################################
	Method RetReg	(cArquivo	,;	//Arquivo Origem (Arquivo que sera' aberto para leitura)
					 lMemoria	;	//Se grava o registro da memoria ou registro fisico
					) CLASS MNGDATA


		Local aRet		:= {}
		Local nX		:= 0
		Local nLen		:= 0
		Local xDado

		DEFAULT lMemoria	:= .F.

		::aReturn	:= {}

		If (!Empty(cArquivo))

			nLen	:= (cArquivo)->(fCount())

			For nX	:= 1 TO nLen

				If (lMemoria)

					If !( "R_E_C_" $ (cArquivo)->(FieldName(nX)) )

						xDado	:= "M->" + (cArquivo)->(FieldName(nX)) // Pega o nome do campo (contido na variavel de memoria). Ex.: M->RA_NOME

						xDado	:= &xDado // Executa a 'Macrosubstituição' para retornar o conteudo do campo (ex.: M->RA_NOME = 'JOSE SILVA')

					Else

						xDado	:= ""

					EndIf

				Else

					xDado	:= (cArquivo)->(FieldGet(nX)) // Pega o nome do campo (contido na variavel de memoria). Ex.: SRA->RA_NOME

				EndIf

				Do Case

					Case (ValType(xDado) == "C")

						If !(Empty(xDado))

							//xDado	:= "'" + xDado + "'"
							xDado	:= xDado

						EndIf

					Case (ValType(xDado) == "N")

						//xDado	:= "'" + AllTrim(Str(xDado)) + "'"
						xDado	:= xDado

					Case (ValType(xDado) == "D")

						//xDado	:= "'" + dToS(xDado) + "'"
						xDado	:= dToS(xDado)

				EndCase

				AADD(::aReturn , { 	(cArquivo)->(FieldName(nX)) ,;	//Retorna a posicao do campo
									xDado						; 	//Retorna o conteu'do
								};
					)

			Next nX

		EndIf

	Return

	//############################################################################
	//## Method GravaData Class MNGDATA
	//############################################################################
	Method GravaData(cAlias , lAppend , aGravar ) CLASS MNGDATA

		Local nX		:= 0
		Local nLenHead	:= 0
		Local xDado
		Local nPos		:= 0
		Local nPosField	:= 1
		Local cField	:= ""
		Local aGrava	:= {}
		Local cValType	:= ""

		DEFAULT aGravar	:= {}
		DEFAULT lAppend	:= .T.

		If !(cAlias == ::cAliasP)

			::aStru		:= (cAlias)->(dbStruct())

			::cAliasP	:= cAlias

		EndIf

		If ( Len(aGravar) > 0 )

			aGrava	:= aClone(aGravar)

		Else

			If (Len(::aReturn) > 0)

				aGrava	:= aClone(::aReturn)

			EndIf

		EndIf

		If (Len(aGrava) > 0)

			//dbSelectArea(cAlias)
			BEGIN TRANSACTION

				If (RecLock(cAlias , lAppend))

					nLenHead	:= Len(aGrava)

					For nX	:= 1 TO nLenHead

						cField	:= aGrava[nX , 1]

						xDado	:= aGrava[nX , 2]

						nPos	:= Ascan(::aStru , {|x| AllTrim(x[nPosField]) == cField } )

						If ( nPos > 0 )

							If !(::aStru[nPos , 2] == "C")

								Do Case

									Case (::aStru[nPos , 2] == "N") //Valida se o tipo do dado e' numerico

										xDado	:= Val(xDado)

									Case (::aStru[nPos , 2] == "D") //Valida se o tipo do dado e' 'Data'.

										If (ValType(xDado) == "C")

											If (AT("/" , xDado) > 0)

												xDado	:= cToD(xDado)

											Else

												xDado	:= sToD(xDado)

											EndIf

										EndIf

								EndCase

							EndIf

							(cAlias)->(FieldPut(nPos , xDado))

						EndIf

					Next nX

					(cAlias)->(MsUnlock())

				EndIf

			END TRANSACTION

		EndIf

	Return
/*
		user function DRGCLA

			DRGCLA01()

		Return

		Static function DRGCLA01()

			Local oObjData	:= MNGDATA():NEW()
			Local oObjCla	:= MNGENV():NEW()
			Local cChave	:= ""
			Local aFields	:= {}

			oObjCla:PrepareEnv("01","01")

			cChave		:= xFilial("SRA") + "000059"
			aFields		:= {"RA_NOME" , "RA_NOMECMP" , "RA_CIC"}

			cChave		:= xFilial("SRA") + "000100"
			oObjData:BuscaData("SRA" , cChave , aFields)

			cChave		:= xFilial("SRA") + "000059"
			oObjData:BuscaData("SRA" , cChave , aFields)

			aFields		:= {"RV_FILIAL" , "RV_COD"}

			cChave		:= xFilial("SRV") + "101"
			oObjData:BuscaData("SRV" , cChave , aFields)

			cChave		:= xFilial("SRV") + "101"
			oObjData:BuscaData("SRV" , cChave , aFields)



			Do While SRA->(!EOF())

				oObjData:RetReg("SRA")

				SRA->(dbSkip())

				FreeObj(oObjData)

				oObjData	:= MNGDATA():NEW()

			EndDo

			/*
			nPosMat	:= Ascan(oObjData:aReturn , {|x| AllTrim(x[1]) == "RA_MAT"})

			If nPosMat > 0

				oObjData:aReturn[nPosMat , 2] := "666666"

			EndIf

			oObjData:GravaData("SRA" , .T.)
			*/

		return
*/

// FIM DA CLASSE MNGDATA

// INICIO DA CLASSE MNGENV(ENVIRONMENT)

	CLASS MNGENV

		Method New() CONSTRUCTOR

		Method PrepareEnv()

		Method ResetEnv()

	ENDCLASS

	//############################################################################
	//## Method New Class MNGENV
	//############################################################################
	Method New() CLASS MNGENV
	Return Self

	//############################################################################
	//## Method PrepareEnv Class MNGENV
	//############################################################################
	Method PrepareEnv(cEmp , cFil) Class MNGENV

		Default cEmp	:= "99"
		Default cFil	:= "01"

		RpcSetType(3)
		//RpcSetEnv( cEmp , cFil )
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil

	Return

	//############################################################################
	//## Method ResetEnv Class MNGENV
	//############################################################################
	Method ResetEnv() Class MNGENV

		RESET ENVIRONMENT

	Return

// FIM DA CLASSE MNGENV

// INICIO DA CLASSE MNGFTP

	CLASS MNGFTP

		Data cServidor
		Data cLogin
		Data cSenha
		Data cArqDest
		Data cPathFTP
		Data cPathDL
		Data nPorta
		Data nOp

		Method NEW() CONSTRUCTOR

		Method Valid() //Efetua a validacao da conexao *Nao deve ser utilizado. Metodo de uso interno*

		Method Conecta() //Efetua a conexao de acordo com as configuracoes passadas nos atributos. *NAO DEVE SER UTILIZADO. METODO DE USO INTERNO*

		Method Upload() // Metodo chamado a partir da classe instanciada. Efetua o Upload dos arquivos no FTP destino.

		Method DownLoad() // Metodo chamado a partir da classe instanciada. Efetua o Download dos arquivos no FTP origem.

		Method Desconecta() // Desconecta do servidor. *METODO DE USO INTERNO, NAO DEVE SER UTILIZADO*

		Method Apaga()

	ENDCLASS


	//############################################################################
	//##Method New() CLASS MNGFTP
	//############################################################################
	Method New() CLASS MNGFTP
		::cServidor	:= ""
		::cLogin	:= ""
		::cSenha	:= ""
		::cArqDest	:= ""
		::cPathFTP	:= ""
		::cPathDL	:= ""
		::nPorta	:= 0
		::nOp		:= 0

	Return Self

	//############################################################################
	//## Method Valid Class MNGFTP
	//############################################################################
	Method Valid() CLASS MNGFTP

		Local aMsg	:= {}
		Local nX	:= 0
		Local cMsg	:= ""
		Local lRet	:= .F.

		IF (Empty(::cServidor))

			AADD(aMsg , "Endereco do FTP nao informado")

		EndIf

		IF (Empty(::cLogin))

			AADD(aMsg , "Login nao informado")

		EndIf

		IF (Empty(::cSenha))

			AADD(aMsg , "Senha nao informada")

		EndIf

		Do Case

			Case (::nOp == 1) //P/ Upload, verifica se a pasta destino foi preenchida

				If (Empty((::cArqDest)))

					AADD(aMsg , "Pasta destino [Upload] nao informada")

				EndIf

			Case (::nOp == 2)

				If (Empty(::cPathFTP))

					AADD(aMsg , "Pasta para Download nao informada.")

				ElseIf (":" $ ::cPathFTP)

					AADD(aMsg , "Para download dos arquivos, nao e permitido informar o disco local. A pasta deve estar na estrutura do 'Rootpath' do Protheus")

				EndIf

		End Case

		IF (Empty(::cSenha))

			AADD(aMsg , "Senha nao informada")

		EndIf

		For nX := 1 TO Len(aMsg)

			cMsg	+=	aMsg[nX] + CHR(13) + CHR(10)

		Next nX

		If !(Empty(cMsg))

			Aviso("Dados Nao Informados" , cMsg)

		Else

			lRet	:= .T.

		EndIf

	Return lRet

	//############################################################################
	//## Method Conecta Class MNGFTP
	//############################################################################
	Method Conecta() CLASS MNGFTP

		Local lRet			:= .F.

		If (::nPorta) == 0

			::nPorta	:= 21

		EndIf

		If !(lRet	:=  FTPCONNECT( ::cServidor , ::nPorta , ::cLogin, ::cSenha ))

			Aviso("Erro na conexao" , "Nao foi possivel conectar ao endereco informado")

		EndIf

	Return lRet

	//############################################################################
	//## Method Desconecta Class MNGFTP
	//############################################################################
	Method Desconecta() CLASS MNGFTP

		FTPDisconnect()

	Return

	//############################################################################
	//## Method Upload Class MNGFTP
	//############################################################################
	Method Upload() CLASS MNGFTP

		Local lRet	:= .F.

		::DESCONECTA()

		::nOp	:= 1

		If ((::Valid()) .AND. (::Conecta())) //Valida os atributos de conexao e se conectou ao servidor

			If !( FTPUPLOAD( ::cArqDest , ::cPathFTP ) ) //Verifica se carregou o arquivo

				Aviso("Erro no Envio" , "Nao foi possivel enviar o arquivo para o FTP destino")

			Else

				lRet	:= .T.

			EndIf

			::DESCONECTA()

		EndIf

	Return lRet

	//############################################################################
	//## Method Download Class MNGFTP
	//############################################################################
	Method Download() CLASS MNGFTP

		Local lRet		:= .F.
		Local aRetDir 	:= {}
		Local nX		:= 0
		Local cMsg		:= ""
		Local aMsg		:= {}

		::nOp	:= 2

		If ((::Valid()) .AND. (::Conecta())) //Valida os atributos de conexao e se conectou ao servidor

			If !(FTPDIRCHANGE( ::cPathFTP )) //Informa a pasta origem para download dos arquivos

				AADD(aMsg , "Nao foi possível modificar diretório!!")

			EndIf

			//Retorna apenas os arquivos contidos no local
			aRetDir := FTPDIRECTORY( "*.*" , )

			If (Empty( aRetDir ))

				AADD(aMsg , "Nao ha arquivos para baixar")

			Else

				For nX := 1 TO Len(aRetDir)

					//Tenta realizar o download de um item qualquer no array
					//Armazena no local indicado pela constante PATH
					If !(FTPDOWNLOAD( ::cPathDl + aRetDir[nX][1] , aRetDir[nX][1]))

						AADD(aMsg , "Nao foi possível realizar o download do arquivo: " + aRetDir[1][1])

					EndIf

				Next nX

			EndIf

			For nX := 1 TO Len(aMsg)

				cMsg	+=	aMsg[nX] + CHR(13) + CHR(10)

			Next nX

			If !(Empty(cMsg))

				Aviso("Erros na processo de download : " , cMsg)

			Else

				//Aviso("OK" , "Arquivos baixados com sucesso!")

				::Apaga(aRetDir)

			EndIf

			::DESCONECTA()

		EndIf

	Return

	//############################################################################
	//## Method Apaga Class MNGFTP
	//############################################################################
	Method Apaga(aRetDir) CLASS MNGFTP

		Local nX		:= 0

		For nX := 1 TO Len(aRetDir)

			FTPERASE(aRetDir[nX , 1])

		Next nX

	Return

// FIM DA CLASSE MNGFTP

// Inicio da classe MNGCONN

	CLASS MNGCONN

		Data nHandle
		Data cLink
		Data aErros

		Method New() Constructor
		Method Conecta()
		Method Desconecta()

	ENDCLASS

	Method New() Class MNGCONN

		::nHandle	:= 0
		::cLink		:= ""
		::aErros	:= {}

	Return Self

	//############################################################################
	//## Method Conecta Class MNGCONN
	//############################################################################
	Method Conecta() CLASS MNGCONN

		Local aDadosCon		:= {}
		Local lRet			:= .F.

		Do Case

			Case (Empty(::cLink))

				AADD(::aErros , "Link de conexão ao banco não informado")

			Case ( AT(":" , ::cLink) == 0 )

				AADD(::aErros , "Link de conexão ao banco informado incorretamente. Informe no seguinte formato: <instancia/nome do banco>:<Servidor>:<Porta>")

			OtherWise

				aDadosCon	:= StrToKarr(::cLink , ":")

		EndCase

		If (Len(aDadosCon) > 0)

			If ( AT("/" , aDadosCon[1]) == 0 )

				AADD(::aErros , "A instancia do banco não foi informada corretamente. Informe no formato: <Instancia>/<Nome do Banco>" )

			Else

				::nHandle	:= TcLink(	aDadosCon[1],;
										aDadosCon[2],;
										Val(aDadosCon[3]))

				If ( ::nHandle >= 0 )

					lRet	:= .T.

				EndIf

			EndIf

		EndIf

	Return lRet

	//############################################################################
	//## Method Desconecta Class MNGCONN
	//############################################################################
	Method Desconecta() CLASS MNGCONN

		Local lRet		:= .F.

		If (::nHandle >= 0)

			lRet	:= TcUnlink(::nHandle)

		EndIf

	Return lRet

// Fim da classe MNGCONN

// Inicio da classe MNGEXP (Metodos para geracao de relatorio e/ou exportacao de arquivo)

	CLASS MNGEXP

		Data cNomePlan
		Data cTitPlan
		Data cFileDest
		Data cPathTXT
		Data cFileTXT
		Data cFileLog
		Data aTitulo
		Data aLinha
		Data aTxt

		Method New() CONSTRUCTOR

		Method ExpExcel()

		Method ExpTXT()

	ENDCLASS

	//############################################################################
	Method New() CLASS MNGEXP
	//############################################################################

		::cNomePlan		:= "Plan1"
		::cPathTXT		:= SuperGetMv("FS_DIRDEST" , NIL , "C:\RELXML\")
		::cTitPlan		:= "Titulo1"
		::cFileDest		:= SuperGetMv("FS_FILELOG" , NIL , "PLAN1.XML")
		::cFileLog		:= "ERROS_DETALHADOS.TXT"
		::cFileTXT		:= "LOG_ATUPROD.TXT"
		::aTXT			:= {}
		::aTitulo		:= {}
		::aLinha		:= {}

	Return Self

	//############################################################################
	Method ExpExcel() CLASS MNGEXP
	//############################################################################
		Local oExcel	:= FWMSEXCEL():New()
		Local nX		:= 0
		Local nY		:= 0
		Local nTamDados	:= 0
		Local nLenTit	:= 0
		Local oMNGTXT	:= MNGTXT():NEW()
		Local aImpTMP	:= {}

		oExcel:AddworkSheet(::cNomePlan)
		oExcel:AddTable (::cNomePlan,::cTitPlan)

		nLenTit	:= Len(::aTitulo)

		For nX	:= 1 TO nLenTit

			oExcel:AddColumn(::cNomePlan,::cTitPlan, ::aTitulo[nX],1,1)

		Next nX

		nTamDados	:= Len(::aLinha)

		For nX	:= 1 TO Len(::aLinha[nTamDados])

			If ((ValType(::aLinha[nTamDados,nX]) == "N") .AND. (::aLinha[nTamDados,nX] == 0))

				::aLinha[nTamDados,nX] := ''

			EndIf

		Next nX

		For nX	:= 1 TO Len(::aLinha)

			If (ValType(::aLinha[nX]) == "A")

				aImpTMP	:= aClone(::aLinha[nX])

				If Len(aImpTMP) > 0

					oExcel:AddRow(::cNomePlan,::cTitPlan,aImpTMP)

				EndIf

			Else

				If (Len(::aLinha[nX]) > 0)

					oExcel:AddRow(::cNomePlan,::cTitPlan,::aLinha)

				EndIf

			EndIf

		Next nX

		oExcel:Activate()

		oExcel:GetXMLFile(::cPathTXT+::cFileDest)

		oExcel:Deactivate()

		ShellExecute("Open" , ::cFileDest , "" , ::cPathTXT , 1 )

	Return

	//############################################################################
	Method ExpTXT() CLASS MNGEXP
	//############################################################################

		Local oMngTXT
		Local nX		:= 0
		Local nY		:= 0
		Local nLen		:= 0
		Local aImpTMP	:= {}

		If (Len(::aTXT) > 0)

			oMngTXT	:= MNGTXT():NEW()

			If (File(::cPathTXT+::cFileTXT))

				fErase(::cPathTXT + ::cFileTXT)

				oMNGTXT:CriaTXT(::cPathTXT + ::cFileTXT)

			Else

				oMngTXT:CriaTXT(::cPathTXT + ::cFileTXT)

			EndIf

			For nX	:= 1 TO Len(::aTXT)

				If (ValType(::aTXT[nX]) == "A")

					aImpTMP	:= aClone(::aTXT[nX])

					For nY	:= 1 TO Len(aImpTMP)

						oMNGTXT:GravaTXT(aImpTMP[nY])

					Next nY

				Else

					oMNGTXT:GravaTXT(.F.,::aTXT[nX])

				EndIf

			Next nX

			oMNGTXT:FechaTXT()

			ShellExecute("Open",  ::cFileTXT , "" , ::cPathTXT , 1 )

		EndIf

	Return

// Fim da classe MNGEXP

//Inicio da classe MNGBOX

	CLASS MNGBOX

		Data aItens
		Data nTipoPerg
		Data aMsGet
		Data aCombo
		Data aRadio
		Data cTxtRadio
		Data cTitulo
		Data aRet
		Data aOpcoes
		Data aOrdem

		Method New() CONSTRUCTOR

		Method ParamBox()

	ENDCLASS

	//############################################################################
	Method New() CLASS MNGBOX
	//############################################################################

		::aItens		:= {}
		::aMsGet		:= {}
		::aCombo		:= {}
		::aRadio		:= {}
		::cTxtRadio		:= ""
		::cTitulo		:= ""
		::aRet			:= {}
		::aOpcoes		:= {"MSGET",;
							"COMBO",;
							"RADIO",;
							"CHECKBOX_SAY ",;
							"CHECKBOX_LINHA",;
							"FILE",;
							"FILTRO",;
							"MSGET_PASSWORD",;
							"MSGET_SAY",;
							"RANGE",;
							"MULTIGET",;
							"FILTRO_ROTINA";
							}
		::aOrdem		:= {}

	Return Self

	//############################################################################
	Method ParamBox() CLASS MNGBOX
	//############################################################################

		Local aPergs	:= {}
		Local aRet		:= {}
		Local nX		:= 0
		Local nY		:= 0
		Local nZ		:= 0
		Local nPosArray	:= 0
		Local lRet		:= .F.
		Local nAdd		:= 0

		If (Len(::aOrdem) == 0)

			::aOrdem	:= aClone(::aOpcoes)

		EndIf

		For nX	:= 1 TO Len(::aOrdem)

			Do Case

				Case (::aOrdem[nX] == "MSGET")

					nAdd	:= nX

					If (Len(::aMsGet) > 0)

						For nY	:= 1 TO Len(::aMsGet)

							AADD(aPergs , {1})

							For nZ := 1  TO Len(::aMsGet[nY])

								AADD(aPergs[nAdd] , ::aMsGet[nY , nZ])

							Next nZ

							++nAdd

						Next nY

					EndIf

				Case (::aOrdem[nX] == "COMBO")

					If (Len(::aCombo) > 0)

						AADD(aPergs , {2})

						For nY	:= 1 TO Len(::aCombo)

							If (nY == 3)
								// De acordo com documentacao do ParamBox, o 4. parametro informado no array 'aPerg' deve ser um array com as opcoes de escolha ('sim','nao', etc...)
								// a comparacao foi feita com a constante '3', em virtude da adicao da constante '2' no array 'aPergs'

								AADD(aPergs[Len(aPergs)] , aClone(::aItens))
								AADD(aPergs[Len(aPergs)] , ::aCombo[nY])

							Else

								AADD(aPergs[Len(aPergs)] , ::aCombo[nY])

							EndIf

						Next nY

					EndIf

				Case (::aOrdem[nX] == "RADIO")

					If (Len(::aRadio) > 0)

						aAdd( aPergs , {3, ::cTxtRadio , 1 , ::aRadio , 50, '.T.' , .T. })

					EndIf

				OtherWise

			EndCase

		Next nX

		If (ParamBox(@aPergs,;
					::cTitulo,;
					aRet;
					);
			)

			lRet	:= .T.

			::aRet	:= aClone(aRet)

		EndIf

	Return lRet

	/*

		Local oMngEnv	:= MNGENV():NEW()
		Local aPergs := {}
		Local cCodRec := space(08)
		Local aRet := {}
		Local lRet
		aAdd( aPergs ,{1,"Recurso : ",cCodRec,"@!",'.T.',,'.T.',40,.F.})
		aAdd( aPergs ,{2,"Recurso Para",1, {"Projeto", "Tarefa"}, 50,'.T.',.T.})
		aAdd( aPergs ,{3,"Considera Sabado/Domingo",1, {"Sim", "Nao"}, 50,'.T.',.T.})
		aAdd( aPergs ,{4,"Enviar e-mail",.T., "usuario@totvs.com.br", 80,'.T.',.T.})
		aAdd( aPergs ,{5,"Recurso Bloqueado",.T., 90,'.T.',.T.})

		oMngENV:PrepareEnv()

		If ParamBox(aPergs ,"Parametros ",@aRet)
			Alert("Pressionado OK")
			lRet := .T.
		Else
			Alert("Pressionado Cancel")
			lRet := .F.
		EndIf
	*/

//Fim da classe MNGBOX

//Inicio da classe MNGVIEW
//############################################################################
CLASS MNGVIEW
//############################################################################

	Data aArray
	Data cAliasView

	Method New() CONSTRUCTOR
	Method CriaView()
	Method GravaView()
	Method DelView()

	ENDCLASS

	//############################################################################
	Method New() Class MNGVIEW
	//############################################################################

		::aArray		:= {}
		::cAliasView	:= ""

	Return Self

	//############################################################################
	Method CriaView() Class MNGVIEW
	//############################################################################
		Local oMngQry	:= MNGQRY():NEW()
		Local cQuery	:= ""

		::cAliasView	:= oMNGQRY:CheckTMP()

		cQuery	:= "CREATE VIEW " + ::cAliasView + " AS " + ::cQuery

		TcSqlExec(cQuery)

	Return

	//############################################################################
	Method GravaView() Class MNGVIEW
	//############################################################################
		Local cQuery	:= ""

		If (!Empty(::cAliasView))

			cQuery	:= "CREATE VIEW " + ::cAliasView + " AS " + ::cQuery

		EndIf

		TcSqlExec(cQuery)

	Return

	//############################################################################
	Method DelView() Class MNGVIEW
	//############################################################################

		If (!Empty(::cAliasView))

			cQuery	:= "DROP VIEW " + ::cAliasView

			TcSqlExec(cQuery)

		EndIf

	Return

//Fim da classe MNGVIEW

//Inicio da classe MNGDIC
//############################################################################
	CLASS MNGDIC
//############################################################################

		Data aRet

		METHOD NEW() CONSTRUCTOR
		METHOD GERAPLAN()

	ENDCLASS

	Method New() CLASS MNGDIC

		::aRet	:= {}

	Return Self

	METHOD GERAPLAN(cAlias) CLASS MNGDIC

		Local aStru		:= {}
		Local nX		:= 0
		Local nY		:= 0
		Local aTamSX3	:= {}
		Local aAreaSX3	:= {}
		Local aObrigat	:= {}
		Local aNObrigat	:= {}

		If !(Empty(cAlias))

			aAreaSX3	:= SX3->(GetArea())

			aStru		:= (cAlias)->(dbStruct())

			AADD(::aRet , Array(Len(aStru)))

			For nX := 1 TO Len(aStru)

				If (X3Obrigat(aStru[nX , 1]))

					::aRet[Len(::aRet) , nX]	:= "*CAMPO OBRIGATORIO*"

				Else

					::aRet[Len(::aRet) , nX]	:= ""

				EndIf

			Next nX

			AADD(::aRet , Array(Len(aStru)))

			For nX := 1 TO Len(aStru)

				::aRet[Len(::aRet) , nX]	:= aStru[nX , 1] + "(" + AllTrim(Posicione('SX3' , 2 , aStru[nX , 1] , "X3_DESCRIC")) + ")"

			Next nX

			AADD(::aRet , Array(Len(aStru)))

			For nX := 1 TO Len(aStru)

				aTamSX3		:= TAMSX3(aStru[nX , 1])

				::aRet[Len(::aRet) , nX] := "Tipo : " + aTamSX3[3] + " Tamanho : " +;
					 IIF(ValType(aTamSX3[1]) == "N" , AllTrim(Str(aTamSX3[1])) ,  aTamSX3[1]) +;
					 IIF(aTamSX3[3] == "N" , " Casas Decimais : " +;
					 	IIF(ValType(aTamSX3[2]) == "N" ,;
					 		AllTrim(Str(aTamSX3[2])) ,;
					 aTamSX3[2]) , "")

			Next nX

			RestArea(aAreaSX3)

			For nX	:= 1 TO Len(::aRet[1])

				If ("OBRIGAT" $ ::aRet[1 , nX])

					AADD(aObrigat , {::aRet[1,nX] , ::aRet[2,nX] , ::aRet[3,nX]} )

				Else

					AADD(aNObrigat , {::aRet[1,nX] , ::aRet[2,nX] , ::aRet[3,nX] })

				EndIf

			Next nX

			::aRet		:= {}

			For nX	:= 1 TO Len(aObrigat)

				AADD(::aRet , aClone(aObrigat[nX]))

			Next nX

			For nX	:= 1 TO Len(aNObrigat)

				AADD(::aRet , aClone(aNObrigat[nX]))

			Next nX

		EndIf

	Return Self

//Fim da classe MNGDIC

//Inicio da classe MNGTHREAD
//############################################################################
	CLASS MNGTHREAD
//############################################################################

	METHOD NEW() CONSTRUCTOR

		METHOD LIBERA()

	ENDCLASS

	Method New() CLASS MNGTHREAD

	Return Self

	METHOD LIBERA(cNomeFun , nThreads) CLASS MNGTHREAD

		Local lLibera		:= .F.
		Local aRotAtiva		:= {}
		Local nQtAtiva		:= 0
		Local nX			:= 0
		Local aRet			:= {}

		aRotAtiva		:= GetUserInfoArray()

		nQtAtiva		:= 0

		For nX := 1 TO Len(aRotAtiva)

			If (cNomeFun $ aRotAtiva[nX , 5])

				++nQtAtiva

			EndIf

		Next nX

		If (nQtAtiva < nThreads)

			lLibera		:= .T.

		EndIf

		aRet	:= {lLibera , nQtAtiva}

	Return aRet
//Fim da classe MNGTHREAD


user function MyFunction

	ALERT('EXECUCAO DO SCHEDULE')

Return

//Inicio da classe MNGMAIL
//############################################################################
	CLASS MNGMAIL
//############################################################################

		Data cDe
		Data cPara
		Data cCC
		Data cConta
		Data cAnexo
		Data cAssunto
		Data cMensagem
		Data cSenha
		Data cSMTP
		Data nPorta
		Data lAuth
		Data lSSL
		Data lTLS

		Method NEW() CONSTRUCTOR
		Method Processa()
		Method Valida()
		Method Envia()

	EndClass

	//############################################################################
	Method New() CLASS MNGMAIL
	//############################################################################

		::cDe			:= ""
		::cPara			:= ""
		::cCC			:= ""
		::cAnexo		:= ""
		::cAssunto		:= ""
		::cMensagem		:= ""
		::cSenha		:= ""
		::cSMTP			:= ""
		::nPorta		:= 0
		::lSSL			:= .F.
		::lTLS			:= .F.
		::lAuth			:= .F.

	Return Self

	//############################################################################
	Method Processa() CLASS MNGMAIL
	//############################################################################

		Local oMail		:= TMailManager():New()
		Local oMessage	:= TMailMessage():New()
		Local lContinua	:= .F.
		Local aMsg		:= {}
		Local cAnexo	:= ""
		Local lCopiou	:= .F.
		Local lRet		:= .F.

		oMail:SetUseSSL( ::lSSL )
		oMail:SetUseTLS( ::lTLS )

		oMail:Init("", ::cSMTP , ::cDe , ::cSenha , 0 , ::nPorta)

		If (oMail:SMTPConnect() == 0)

			If !(oMail:SMTPAuth(SubStr(::cDe , 1 , AT("@" , ::cDe) - 1) , ::cSenha) == 0)

				nConnect := (oMail:SMTPAuth(AllTrim(::cDe) , ::cSenha))

				If !( nConnect == 0)

					AADD(aMsg , oMail:GetErrorString(nConnect))

				Else

					lContinua	:= .T.

				EndIf

			Else

				lContinua	:= .T.

			EndIf

		Else

			lContinua	:= .T.

		EndIf

		If !(Empty(::cAnexo))

			If ( ":\" $ ::cAnexo )

				// Copia arquivos do remote local para o servidor, compactando antes de transmitir
				CpyT2S( ::cAnexo , "\SYSTEM" )

				If (fError() == 0)

					lCopiou	:= .T.

					cAnexo	:= "\SYSTEM\" + SubStr( ::cAnexo , (RAT("\" , ::cAnexo) + 1 ) , Len(AllTrim(::cAnexo)) )

					If !( oMessage:AttachFile( cAnexo ) == 0 )

						AADD(aMsg , "O E-mail será enviado, porém, não foi possível anexar o arquivo: " + cAnexo + " Verifique! ")

					EndIf

				Else

					AADD(aMsg , "O arquivo: " + cAnexo + " Não pôde ser salvo na pasta '\SYSTEM' e não será como anexo. Verifique ! ")

				EndIf

			EndIf

		EndIf

		If (lContinua)

			oMessage:cDate		:= cValToChar( Date() )
			oMessage:cFrom		:= ::cDe
			oMessage:cTo		:= ::cPara
			oMessage:cCc		:= ::cCC
			oMessage:cSubject	:= ::cAssunto
			oMessage:cBody 		:= ::cMensagem

			If !( (nRet := oMessage:Send(oMail)) == 0)

				AADD(aMsg , oMail:GetErrorString( nRet ))

			Else

				lRet	:= .T.

			EndIf

			oMail:SmtpDisconnect()

		EndIf

		If !(lRet) //Indica que nao foi possivel enviar a mensagem com a classe TMailManager. Então, tenta com a funcao CONNECT SMTP.

			CONNECT SMTP SERVER ::cSMTP ACCOUNT ::cDe PASSWORD ::cSenha RESULT lResulConn

				///////////////
				// erro conexao
				If !(lResulConn)

					GET MAIL ERROR cError

					AADD(aMsg , "E-mail : Falha na conexão " + cError)

				Else

					//AUTENTICACAO DE E-MAIL

					If (!MailAuth(::cDe , ::cSenha))

						AADD(aMsg , "E-mail : Falha na conexão: Nao autenticou a conta " + ::cDe)

					EndIf

					SEND MAIL FROM ::cDe;
					TO ::cPara;
					SUBJECT ::cAssunto;
					BODY ::cMensagem;
					ATTACHMENT cAnexo;
					RESULT lOk

					If !(lOk)

						GET MAIL ERROR cError

						AADD(aMsg , cError)

					Else

						lRet	:= .T.

					EndIf

				Endif

			DISCONNECT SMTP SERVER

		EndIf

		If (lCopiou)

			fErase(cAnexo)

			If !(fError() == 0)

				AADD(aMsg , " Não foi possível excluir o arquivo " + cAnexo + " Verifique. ")

			EndIf

		EndIf


	Return lRet

	//############################################################################
	Method Valida() CLASS MNGMAIL //Valida as propriedades de conexao da conta
	//############################################################################

		Local aMsg		:= {}
		Local nX		:= 0
		Local cMsg		:= ""
		Local lRet		:= .F.

		If (Empty(::cDe))

			AADD(aMsg , "Nao foi informado o remetente da conta. Preencha a propriedade: 'cDe'. ")

		EndIf

		If (Empty(::cPara)) .AND. (Empty(::cCC))

			AADD(aMsg , "O destinatario nao foi informado. Preencha uma das propriedades: 'cPara' ou 'cCC'. ")

		EndIf

		If (Empty(::cDe))

			AADD(aMsg , "A conta de autenticacao nao foi informada. Preencha a propriedade 'cConta'. ")

		EndIf

		If (Empty(::cSenha))

			AADD(aMsg , "A senha de autenticacao nao foi informada. Preencha a propriedade 'cSenha'. ")

		EndIf

		If !(Empty(cMsg))

			For nX := 1 TO Len(aMsg)

				cMsg	+= aMsg[nX] + CHR(10) + CHR(13)

			Next nX

			Aviso("Erros nos dados de conexao" , cMsg)

		Else

			lRet	:= .T.

		EndIf

	Return lRet

	//############################################################################
	Method Envia() CLASS MNGMAIL
	//############################################################################

		Local lRet	:= (::Valida() .AND. ::Processa())

	Return lRet

//Fim da classe MNGMAIL
*/