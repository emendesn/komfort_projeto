#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDSX601
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDSX601( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := "ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk
	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDSX601" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDSX601" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Realizada." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não Realizada." )

		EndIf

	Else
		Final( "Atualização não Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'FS_GCTCOT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo Contrato para cotacao'											, ; //X6_DESCRIC
	'Tipo Contrato para cotizacion'											, ; //X6_DSCSPA
	'Contract type for quotation'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'001'																	, ; //X6_CONTEUD
	'001'																	, ; //X6_CONTSPA
	'001'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'001'																	, ; //X6_DEFPOR
	'001'																	, ; //X6_DEFSPA
	'001'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'GL_APRMAIL'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'E-mail aprovador de PV c/ desc. excedente'								, ; //X6_DESCRIC
	'E-mail aprovador de PV c/ desc. excedente'								, ; //X6_DSCSPA
	'E-mail aprovador de PV c/ desc. excedente'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'caio.garcia@komforthouse.com.br'										, ; //X6_CONTEUD
	'vanessa.santos@komforthouse.com.br;luciana.milanelli@komforthouse.com.br;luiz.carmo@komforthouse.com.br', ; //X6_CONTSPA
	'vanessa.santos@komforthouse.com.br;luciana.milanelli@komforthouse.com.br;luiz.carmo@komforthouse.com.br', ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'GL_APRUSER'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do aprovador do workflow de desconto do pedid'					, ; //X6_DESCRIC
	'Nome do aprovador do workflow de desconto do pedid'					, ; //X6_DSCSPA
	'Nome do aprovador do workflow de desconto do pedid'					, ; //X6_DSCENG
	'o de venda'															, ; //X6_DESC1
	'o de venda'															, ; //X6_DSCSPA1
	'o de venda'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'KHALED DARWICH'														, ; //X6_CONTEUD
	'KHALED DARWICH'														, ; //X6_CONTSPA
	'KHALED DARWICH'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'GL_NAOIMPR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Grupos de produtos que nao farao impressao de etiq'					, ; //X6_DESCRIC
	'Grupos de produtos que nao farao impressao de etiq'					, ; //X6_DSCSPA
	'Grupos de produtos que nao farao impressao de etiq'					, ; //X6_DSCENG
	'uetas na entrada nem na saida da mercadoria'							, ; //X6_DESC1
	'uetas na entrada nem na saida da mercadoria'							, ; //X6_DSCSPA1
	'uetas na entrada nem na saida da mercadoria'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2001;2002'																, ; //X6_CONTEUD
	'2001;2002'																, ; //X6_CONTSPA
	'2001;2002'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_01ALGRD'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Altura padrao para medidas especiais'									, ; //X6_DESCRIC
	'Altura padrao para medidas especiais'									, ; //X6_DSCSPA
	'Altura padrao para medidas especiais'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1.10'																	, ; //X6_CONTEUD
	'1.10'																	, ; //X6_CONTSPA
	'1.10'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_01COGRD'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Comprimento padrao para medidas especiais'								, ; //X6_DESCRIC
	'Comprimento padrao para medidas especiais'								, ; //X6_DSCSPA
	'Comprimento padrao para medidas especiais'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1.00'																	, ; //X6_CONTEUD
	'1.00'																	, ; //X6_CONTSPA
	'1.00'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_ACOESTR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Acoes que não entraram no relatorio KMCOMR01'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000050','000040'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_AMBOFIC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nomes do ambientes oficiais'											, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'KOMFORT;'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_APROSAC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do operador do usuário que irá aprovar o wo'					, ; //X6_DESCRIC
	'Codigo do operador do usuário que irá aprovar o wo'					, ; //X6_DSCSPA
	'Codigo do operador do usuário que irá aprovar o wo'					, ; //X6_DSCENG
	'rkflow'																, ; //X6_DESC1
	'rkflow'																, ; //X6_DSCSPA1
	'rkflow'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000494'																, ; //X6_CONTEUD
	'000331'																, ; //X6_CONTSPA
	'000565'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_APWFDES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do aprovador de WF desconto'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000562'																, ; //X6_CONTEUD
	'000565'																, ; //X6_CONTSPA
	'000565'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_ARMZBIP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DESCRIC
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCSPA
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCENG
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DESC1
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCSPA1
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCENG1
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DESC2
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCSPA2
	'ARMAZEM PADRAO PARA PRODUTOS BIPARTIDOS'								, ; //X6_DSCENG2
	'02'																	, ; //X6_CONTEUD
	'02'																	, ; //X6_CONTSPA
	'02'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_BOLITAU'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'341/1608/45451'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_FORCDKH'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do Fornecedor Komfort House CD'									, ; //X6_DESCRIC
	'Codigo do Fornecedor Komfort House CD'									, ; //X6_DSCSPA
	'Codigo do Fornecedor Komfort House CD'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'00000101'																, ; //X6_CONTEUD
	'00000101'																, ; //X6_CONTSPA
	'00000101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_GRPPROD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'GRUPOS DE PRODUTOS QUE NÃO CONTROLAM LOCALIZACAO'						, ; //X6_DESCRIC
	'GRUPOS DE PRODUTOS QUE NÃO CONTROLAM LOCALIZACAO'						, ; //X6_DSCSPA
	'GRUPOS DE PRODUTOS QUE NÃO CONTROLAM LOCALIZACAO'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2001,2002'																, ; //X6_CONTEUD
	'2001,2002'																, ; //X6_CONTSPA
	'2001,2002'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_GRRAPME'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Grupo de aprovação para geracao de pedidos de'							, ; //X6_DESCRIC
	'Grupo de aprovação para geracao de pedidos de'							, ; //X6_DSCSPA
	'Grupo de aprovação para geracao de pedidos de'							, ; //X6_DSCENG
	'compra para medida especial'											, ; //X6_DESC1
	'compra para medida especial'											, ; //X6_DSCSPA1
	'compra para medida especial'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000001'																, ; //X6_CONTEUD
	'000001'																, ; //X6_CONTSPA
	'000001'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_MAILCRE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'caiomgarcia@gmail.com'													, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_MOTBXRA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do motivo de baixa para pagamentos RA'							, ; //X6_DESCRIC
	'Codigo do motivo de baixa para pagamentos RA'							, ; //X6_DSCSPA
	'Codigo do motivo de baixa para pagamentos RA'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'BCC'																	, ; //X6_CONTEUD
	'BCC'																	, ; //X6_CONTSPA
	'BCC'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_MSGOCOR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da Ocorrencia TROCA/RETIRA para impressao'						, ; //X6_DESCRIC
	'Codigo da Ocorrencia TROCA/RETIRA para impressao'						, ; //X6_DSCSPA
	'Codigo da Ocorrencia TROCA/RETIRA para impressao'						, ; //X6_DSCENG
	'no PV'																	, ; //X6_DESC1
	'no PV'																	, ; //X6_DSCSPA1
	'no PV'																	, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000026/000051'															, ; //X6_CONTEUD
	'000026/000051'															, ; //X6_CONTSPA
	'000026/000051'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_PRFXEAN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Prefixo(s) de Código de Barras GTIN-13 (EAN13)'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'78998553'																, ; //X6_CONTEUD
	'78998552|78998553'														, ; //X6_CONTSPA
	'78998552|78998553'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_PRZGARA'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Prazo de garantia fornecido pela Komfort'								, ; //X6_DESCRIC
	'Prazo de garantia fornecido pela Komfort'								, ; //X6_DSCSPA
	'Prazo de garantia fornecido pela Komfort'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'90'																	, ; //X6_CONTEUD
	'90'																	, ; //X6_CONTSPA
	'90'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_TPBOLET'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'BOL/BST'																, ; //X6_CONTEUD
	'BOL/BST'																, ; //X6_CONTSPA
	'BOL/BST'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_USRALTS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuario que podera alterar dados utilizando o prog'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'rama KMFATA01'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000565;000564;000567;000562;'											, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_WFOCORR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigos das ocorrencias que irao gerar workflow'						, ; //X6_DESCRIC
	'Codigos das ocorrencias que irao gerar workflow'						, ; //X6_DSCSPA
	'Codigos das ocorrencias que irao gerar workflow'						, ; //X6_DSCENG
	'a partir do SAC'														, ; //X6_DESC1
	'a partir do SAC'														, ; //X6_DSCSPA1
	'a partir do SAC'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000053/000084/000091/000097/000104/000105/'							, ; //X6_CONTEUD
	'000053/000084/000091/000097/000104/000105/'							, ; //X6_CONTSPA
	'000053/000084/000091/000097/000104/000105/'							, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_WFURL'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define a URL do WorkFLow'												, ; //X6_DESCRIC
	'Define a URL do WorkFLow'												, ; //X6_DSCSPA
	'Define a URL do WorkFLow'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://200.155.65.132:8900/wf/'										, ; //X6_CONTEUD
	'http://200.155.65.132:8900/wf'											, ; //X6_CONTSPA
	'http://200.155.65.132:8900/wf'											, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'KH_XNATRA'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza para preenchimento automatico no titulo d'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'e RA'																	, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'6000003'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01CDENT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Lojas habilitadas como CD para entrega'								, ; //X6_DESCRIC
	'Lojas habilitadas como CD para entrega'								, ; //X6_DSCSPA
	'Lojas habilitadas como CD para entrega'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101;0201'																, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01CODAN'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Gera Codigo Interno Automatico (T) ou (F)'								, ; //X6_DESCRIC
	'Gera Codigo Interno Automatico (T) ou (F)'								, ; //X6_DSCSPA
	'Gera Codigo Interno Automatico (T) ou (F)'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01FILCE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial Centralizadora do Pedido de Compra'								, ; //X6_DESCRIC
	'Filial Centralizadora do Pedido de Compra'								, ; //X6_DSCSPA
	'Filial Centralizadora do Pedido de Compra'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01GPNFE'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Gera Pre-Nota Automatica? Sim ou Nao'									, ; //X6_DESCRIC
	'Gera Pre-Nota Automatica? Sim ou Nao'									, ; //X6_DSCSPA
	'Gera Pre-Nota Automatica? Sim ou Nao'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01IMPET'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Rotina de impressao de etiqueta.'										, ; //X6_DESCRIC
	'Rotina de impressao de etiqueta.'										, ; //X6_DSCSPA
	'Rotina de impressao de etiqueta.'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01IMPRE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Rotina de impressao do pedido de compra.'								, ; //X6_DESCRIC
	'Rotina de impressao do pedido de compra.'								, ; //X6_DSCSPA
	'Rotina de impressao do pedido de compra.'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T_SYVR100()'															, ; //X6_CONTEUD
	'T_SYVR100()'															, ; //X6_CONTSPA
	'T_SYVR100()'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01LCENT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Entrega padrao no pedido de compra'									, ; //X6_DESCRIC
	'Entrega padrao no pedido de compra'									, ; //X6_DSCSPA
	'Entrega padrao no pedido de compra'									, ; //X6_DSCENG
	'C=CD ou F=FILIAL'														, ; //X6_DESC1
	'C=CD ou F=FILIAL'														, ; //X6_DSCSPA1
	'C=CD ou F=FILIAL'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01MKPVD'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Fator de Markup Global'												, ; //X6_DESCRIC
	'Fator de Markup Global'												, ; //X6_DSCSPA
	'Fator de Markup Global'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'2'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01USAPK'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Usa Pack Padrao (T) ou (F)'											, ; //X6_DESCRIC
	'Usa Pack Padrao (T) ou (F)'											, ; //X6_DSCSPA
	'Usa Pack Padrao (T) ou (F)'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_01VLDPZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'"L" = Libera entrada do PC fora do prazo.'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'"B" = Bloqueia a entrada de PC fora do prazo.'							, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'"D" = Desativa validação.'												, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'D'																		, ; //X6_CONTEUD
	'D'																		, ; //X6_CONTSPA
	'D'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_031TOUT'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Tempo para timeout'													, ; //X6_DESCRIC
	'Tempo para timeout'													, ; //X6_DSCSPA
	'Tempo para timeout'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3600'																	, ; //X6_CONTEUD
	'3600'																	, ; //X6_CONTSPA
	'3600'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_031VLTB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Valida o preenchimento das tabelas de precos'							, ; //X6_DESCRIC
	'Valida o preenchimento das tabelas de precos'							, ; //X6_DSCSPA
	'Valida o preenchimento das tabelas de precos'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_AUTCOBA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Cria automaticamente codigo de barras padrao'							, ; //X6_DESCRIC
	'Cria automaticamente codigo de barras padrao'							, ; //X6_DSCSPA
	'Cria automaticamente codigo de barras padrao'							, ; //X6_DSCENG
	'EAN 13'																, ; //X6_DESC1
	'EAN 13'																, ; //X6_DSCSPA1
	'EAN 13'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_B4COMPL'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Completa o produto filho com as Cores e Tamanhos'						, ; //X6_DESCRIC
	'Completa o produto filho com as Cores e Tamanhos'						, ; //X6_DSCSPA
	'Completa o produto filho com as Cores e Tamanhos'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	'T'																		, ; //X6_CONTSPA
	'T'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_B4VLEAN'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Valida EAN13 no cadastro da Grade'										, ; //X6_DESCRIC
	'Valida EAN13 no cadastro da Grade'										, ; //X6_DSCSPA
	'Valida EAN13 no cadastro da Grade'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BLQXML'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'LOCAL AONDE GRAVA O ARQUIVO DE BLOQUEIO DO XML'						, ; //X6_DESCRIC
	'LOCAL AONDE GRAVA O ARQUIVO DE BLOQUEIO DO XML'						, ; //X6_DSCSPA
	'LOCAL AONDE GRAVA O ARQUIVO DE BLOQUEIO DO XML'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'\xml\'																	, ; //X6_CONTEUD
	'\xml\'																	, ; //X6_CONTSPA
	'\xml\'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CADPROD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilizado para informar quais cadastros'								, ; //X6_DESCRIC
	'Utilizado para informar quais cadastros'								, ; //X6_DSCSPA
	'Utilizado para informar quais cadastros'								, ; //X6_DSCENG
	'complementares devem ser apresentados'									, ; //X6_DESC1
	'complementares devem ser apresentados'									, ; //X6_DSCSPA1
	'complementares devem ser apresentados'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SB5'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CCPRZMA'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Prazo maximo de entrega para cliente'									, ; //X6_DESCRIC
	'Prazo maximo de entrega para cliente'									, ; //X6_DSCSPA
	'Prazo maximo de entrega para cliente'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'90'																	, ; //X6_CONTEUD
	'90'																	, ; //X6_CONTSPA
	'90'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CCPRZME'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Prazo medio de entrega de produtos de estoques'						, ; //X6_DESCRIC
	'Prazo medio de entrega de produtos de estoques'						, ; //X6_DSCSPA
	'Prazo medio de entrega de produtos de estoques'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'999'																	, ; //X6_CONTEUD
	'999'																	, ; //X6_CONTSPA
	'999'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_EDEFEIT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Estoque de defeito'													, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'04'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ESPPNFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'ESPECIE DA NOTA FISCAL DE TRANSFERENCIA DE MOSTRUA'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'RIO'																	, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SPED'																	, ; //X6_CONTEUD
	'"SPED"'																, ; //X6_CONTSPA
	'"SPED"'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ESPXML'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'ESPECIE DO DOCUMENTO QUE SERA GERADA NA PRE-NOTA A'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'POS A LIBERACAO DO XML'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SPED'																	, ; //X6_CONTEUD
	'SPED'																	, ; //X6_CONTSPA
	'SPED'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FORMNF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'INDICA SE IRA UTILIZAR FORMULARIO PROPRIO NOS DOCU'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'MENTOS DE PRE-NOTA DE ENTRADA GERADA NA LIBERACAO'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'DO XML'																, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FORPNFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'INDICA SE SERA USADO FORMULARIO PROPIO NAS NOTAS D'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'E ENTRADA DE TRANSFERENCIA DE MOSTRUARIO'								, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'"S"'																	, ; //X6_CONTSPA
	'"S"'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_GRPCOR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	"Nome da tabela de grupo de cores padroes ('00')"						, ; //X6_DESCRIC
	"Nome da tabela de grupo de cores padroes ('00')"						, ; //X6_DSCSPA
	"Nome da tabela de grupo de cores padroes ('00')"						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'00'																	, ; //X6_CONTEUD
	'00'																	, ; //X6_CONTSPA
	'00'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_KOGERTX'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Desconta a taxa administrativa do valor do titulo.'					, ; //X6_DESCRIC
	'Desconta a taxa administrativa do valor do titulo.'					, ; //X6_DSCSPA
	'Desconta a taxa administrativa do valor do titulo.'					, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_KOGRPLB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuario que poderão liberar de orcamento para'							, ; //X6_DESCRIC
	'Usuario que poderão liberar de orcamento para'							, ; //X6_DSCSPA
	'Usuario que poderão liberar de orcamento para'							, ; //X6_DSCENG
	'faturamento no Call Center'											, ; //X6_DESC1
	'faturamento no Call Center'											, ; //X6_DSCSPA1
	'faturamento no Call Center'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000001|000006|000019|000130|'											, ; //X6_CONTEUD
	'000001|000006|000019|000130|'											, ; //X6_CONTSPA
	'000001|000006|000019|000130|'											, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LIBSPED'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DESCRIC
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCSPA
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCENG
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DESC1
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCSPA1
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCENG1
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DESC2
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCSPA2
	'FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO'							, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LJENTPN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'LOJA DE ENTRADA DAS TRANSFERENCIAS DE MOSTRUARIO -'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'LOJA AONDE ESTA O GALPAO DE SALDAO - INICIALMENTE'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'A MATRIZ 0101'															, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'"0101"'																, ; //X6_CONTSPA
	'"0101"'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LOCGLP'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Armazem De Mostruario do Galpao'										, ; //X6_DESCRIC
	'Armazem De Mostruario do Galpao -'										, ; //X6_DSCSPA
	'Armazem De Mostruario do Galpao'										, ; //X6_DSCENG
	'Armazem De Mostruario do Galpao'										, ; //X6_DESC1
	'Armazem De Mostruario do Galpao - SALDAO'								, ; //X6_DSCSPA1
	'Armazem De Mostruario do Galpao'										, ; //X6_DSCENG1
	'Armazem De Mostruario do Galpao -'										, ; //X6_DESC2
	'Armazem De Mostruario do Galpao'										, ; //X6_DSCSPA2
	'Armazem De Mostruario do Galpao'										, ; //X6_DSCENG2
	'03'																	, ; //X6_CONTEUD
	'03'																	, ; //X6_CONTSPA
	'03'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MAILXML'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'CONTA DE EMAIL QUE SERA FEITO O DOWNLOAD DOS XMLS'						, ; //X6_DESCRIC
	'CONTA DE EMAIL QUE SERA FEITO O DOWNLOAD DOS XMLS'						, ; //X6_DSCSPA
	'CONTA DE EMAIL QUE SERA FEITO O DOWNLOAD DOS XMLS'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'mail.komforthouse.com.br'												, ; //X6_CONTEUD
	'recebimento@komforthouse.com.br'										, ; //X6_CONTSPA
	'recebimento@komforthouse.com.br'										, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MSKKFT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'CODIGO PROPIO KOMFORT PARA CADASTRO DE CLIENTE E'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'FORNECEDOR DAS LOJAS'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000001'																, ; //X6_CONTEUD
	'000001'																, ; //X6_CONTSPA
	'000001'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NATCDEB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CARTAO'																, ; //X6_CONTEUD
	'CARTAO'																, ; //X6_CONTSPA
	'CARTAO'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NATNDC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza de Nota Debito Cliente'										, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'"NDC"'																	, ; //X6_CONTEUD
	'"NDC"'																	, ; //X6_CONTSPA
	'"NDC"'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_OCORASS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Códigos das ocorrências que irão gerar o Laudo Téc'					, ; //X6_DESCRIC
	'Códigos das ocorrências que irão gerar o Laudo Téc'					, ; //X6_DSCSPA
	'Códigos das ocorrências que irão gerar o Laudo Téc'					, ; //X6_DSCENG
	'no chamado (PARAM ESPECIF DA TEMPLATE DE MOVEIS)'						, ; //X6_DESC1
	'no chamado (PARAM ESPECIF DA TEMPLATE DE MOVEIS)'						, ; //X6_DSCSPA1
	'no chamado (PARAM ESPECIF DA TEMPLATE DE MOVEIS)'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000041/000050'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_OCORORC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Ocorrencia para gerar orcamento automatico'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000002/000003'															, ; //X6_CONTEUD
	'000002/000003'															, ; //X6_CONTSPA
	'000002/000003'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PATHFOT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Diretorio de fotos'													, ; //X6_DESCRIC
	'Diretorio de fotos'													, ; //X6_DSCSPA
	'Diretorio de fotos'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'\fotos\'																, ; //X6_CONTEUD
	'\fotos\'																, ; //X6_CONTSPA
	'\fotos\'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PATHHTM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Diretorio dos HTML do workflow'										, ; //X6_DESCRIC
	'Diretorio dos HTML do workflow'										, ; //X6_DSCSPA
	'Diretorio dos HTML do workflow'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'\workflow\'															, ; //X6_CONTEUD
	'\workflow\'															, ; //X6_CONTSPA
	'\workflow\'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_PSWXML'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'SENHA PARA ACESSO AO EMAIL QUE ESTA CONFIGURADO PA'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'RA RECEBER OS XML'														, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'komfort01'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SERVWKF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'IP do server do workflow'												, ; //X6_DESCRIC
	'IP do server do workflow'												, ; //X6_DSCSPA
	'IP do server do workflow'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://200.155.65.132:8900/wf/'										, ; //X6_CONTEUD
	'http://200.155.65.133:6592/wf/'										, ; //X6_CONTSPA
	'http://200.155.65.133:6592/wf/'										, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYARMAZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Armazen Sadio para as consultas do GCV.'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYCHVME'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tabela de grade para medidas especiais'								, ; //X6_DESCRIC
	'Tabela de grade para medidas especiais'								, ; //X6_DSCSPA
	'Tabela de grade para medidas especiais'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'ME'																	, ; //X6_CONTEUD
	'ME'																	, ; //X6_CONTSPA
	'ME'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYDIRFO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Diretorio onde se encontra as fotos mapeadas em ca'					, ; //X6_DESCRIC
	'Diretorio onde se encontra as fotos mapeadas em ca'					, ; //X6_DSCSPA
	'Diretorio onde se encontra as fotos mapeadas em ca'					, ; //X6_DSCENG
	'da usuario'															, ; //X6_DESC1
	'da usuario'															, ; //X6_DSCSPA1
	'da usuario'															, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'\fotos\'																, ; //X6_CONTEUD
	'\fotos\'																, ; //X6_CONTSPA
	'\fotos\'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYGRPSV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define grupo de usuario para aplicação de regra de'					, ; //X6_DESCRIC
	'Define grupo para aplicação de regra de RESUMO DE'						, ; //X6_DSCSPA
	'Define grupo para aplicação de regra de RESUMO DE'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYPEDCP'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYQTDDS'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Define numero de dias do RESUMO DE VENDAS'								, ; //X6_DESCRIC
	'Define numero de dias do RESUMO DE VENDAS'								, ; //X6_DSCSPA
	'Define numero de dias do RESUMO DE VENDAS'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYSHOWW'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita tela de digitação do preço no'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'documento de entrada.'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYTABMO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tabela de preco de mostruario'											, ; //X6_DESCRIC
	'Tabela de preco de mostruario'											, ; //X6_DSCSPA
	'Tabela de preco de mostruario'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'001'																	, ; //X6_CONTEUD
	'001'																	, ; //X6_CONTSPA
	'001'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYTABPR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da tabela promocional'											, ; //X6_DESCRIC
	'Codigo da tabela promocional'											, ; //X6_DSCSPA
	'Codigo da tabela promocional'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'001'																	, ; //X6_CONTEUD
	'001'																	, ; //X6_CONTSPA
	'001'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYTM02A'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código de acesso do Cliente MultiCrédito'								, ; //X6_DESCRIC
	'Código de acesso do Cliente MultiCrédito'								, ; //X6_DSCSPA
	'Código de acesso do Cliente MultiCrédito'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'011682'																, ; //X6_CONTEUD
	'011682'																, ; //X6_CONTSPA
	'011682'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYTM02B'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Senha de acesso do Cliente MultiCrédito'								, ; //X6_DESCRIC
	'Senha de acesso do Cliente MultiCrédito'								, ; //X6_DSCSPA
	'Senha de acesso do Cliente MultiCrédito'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'AMZ'																	, ; //X6_CONTEUD
	'AMZ'																	, ; //X6_CONTSPA
	'AMZ'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA021'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Efetiva a mudanca do valor da'											, ; //X6_DESCRIC
	'Efetiva a mudanca do valor da'											, ; //X6_DSCSPA
	'Efetiva a mudanca do valor da'											, ; //X6_DSCENG
	'remarcacao de preco (.90)'												, ; //X6_DESC1
	'remarcacao de preco (.90)'												, ; //X6_DSCSPA1
	'remarcacao de preco (.90)'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA022'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Nao remarcar preco que sao me-'										, ; //X6_DESCRIC
	'Nao remarcar preco que sao me-'										, ; //X6_DSCSPA
	'Nao remarcar preco que sao me-'										, ; //X6_DSCENG
	'nores que o preco praticado'											, ; //X6_DESC1
	'nores que o preco praticado'											, ; //X6_DSCSPA1
	'nores que o preco praticado'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA023'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Efetiva a remarcacao de preco'											, ; //X6_DESCRIC
	'Efetiva a remarcacao de preco'											, ; //X6_DSCSPA
	'Efetiva a remarcacao de preco'											, ; //X6_DSCENG
	'S=SIM ou N=NAO'														, ; //X6_DESC1
	'S=SIM ou N=NAO'														, ; //X6_DSCSPA1
	'S=SIM ou N=NAO'														, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA024'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Numero de dias para efetivar a'										, ; //X6_DESCRIC
	'Numero de dias para efetivar a'										, ; //X6_DSCSPA
	'Numero de dias para efetivar a'										, ; //X6_DSCENG
	'remarcacao de precos'													, ; //X6_DESC1
	'remarcacao de precos'													, ; //X6_DSCSPA1
	'remarcacao de precos'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA025'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Valida se preco da remarcação'											, ; //X6_DESCRIC
	'Valida se preco da remarcação'											, ; //X6_DSCSPA
	'Valida se preco da remarcação'											, ; //X6_DSCENG
	'termina com valor (.90)'												, ; //X6_DESC1
	'termina com valor (.90)'												, ; //X6_DSCSPA1
	'termina com valor (.90)'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA026'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Arredondamento sugerido para preços de venda.'							, ; //X6_DESCRIC
	'Arredondamento sugerido para preços de venda.'							, ; //X6_DSCSPA
	'Arredondamento sugerido para preços de venda.'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0.9'																	, ; //X6_CONTEUD
	'0.9'																	, ; //X6_CONTSPA
	'0.9'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA042'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES de Transferencia Substituicao Tributaria'							, ; //X6_DESCRIC
	'TES de Transferencia Substituicao Tributaria'							, ; //X6_DSCSPA
	'TES de Transferencia Substituicao Tributaria'							, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'537'																	, ; //X6_CONTEUD
	'537'																	, ; //X6_CONTSPA
	'537'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_SYVA043'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES de Transferencia Normal.'											, ; //X6_DESCRIC
	'TES de Transferencia Normal'											, ; //X6_DSCSPA
	'TES de Transferencia Normal'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'505'																	, ; //X6_CONTEUD
	'505'																	, ; //X6_CONTSPA
	'505'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESSDES'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tes da venda para considerar na remarcacao'							, ; //X6_DESCRIC
	'Tes da venda para considerar na remarcacao'							, ; //X6_DSCSPA
	'Tes da venda para considerar na remarcacao'							, ; //X6_DSCENG
	'de precos e nas consultas gerenciais.'									, ; //X6_DESC1
	'de precos e nas consultas gerenciais.'									, ; //X6_DSCSPA1
	'de precos e nas consultas gerenciais.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'600'																	, ; //X6_CONTEUD
	'600'																	, ; //X6_CONTSPA
	'600'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESTRF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES DE SAIDA NA CRIACADO DO PV DE TRANSFERENCIA DE'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'MOSTRUARIO'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'602'																	, ; //X6_CONTEUD
	'602'																	, ; //X6_CONTSPA
	'602'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESTRFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES DE ENTRADA DE NOTA FISCAL DE TRANSFERENCIA DE'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'MOSTRUARIO'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'054'																	, ; //X6_CONTEUD
	'054'																	, ; //X6_CONTSPA
	'054'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TIPONF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TIPO DO DOCUMENTO DA PRE NOTA FISCAL GERADA NA LIB'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ERACAO DO XML'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TPPNFE'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TIPO DA MOTA FISCAL DE ENTRADA DE TRANSFERENCIA DE'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'MOSTRUARIO'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'"N"'																	, ; //X6_CONTSPA
	'"N"'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_URLMSHP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'DEFAULT do endereço do MASHUP'											, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'http://localhost:8055/TOTVSSoa.Host/SOAManager.svc'					, ; //X6_CONTEUD
	'http://localhost:8055/TOTVSSoa.Host/SOAManager.svc'					, ; //X6_CONTSPA
	'http://localhost:8055/TOTVSSoa.Host/SOAManager.svc'					, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_USERXML'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'SENHA DE USUARIO PARA ACESSO AO EMAIL QUE ESTA CON'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'FIGURADO O RECEBIMENTO DOS XML'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'recebimento@komforthouse.com.br'										, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VLDPNF'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'VALIDA SE VAI CRIAR A PRE-NOTA DE ENTRADA NO PROCE'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'SSO DE LIBERACAO DO XML'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_VR100B'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Imprime informacoes de faturamento no PC.'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_WFDIA'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO EM DIA PARA TIMEOUT DO WF'										, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'999'																	, ; //X6_CONTEUD
	'999'																	, ; //X6_CONTSPA
	'999'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_WFHORA'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO EM HORA PARA TIMEOUT DO WF'										, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'72'																	, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_WFMIN'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO EM MINUTOS PARA TIMEOUT DO WF'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLAUTO'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'HABILITA/DESABILITA A VERIFICACAO AUTOMATICA DO XM'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'L NO SITE DA SEFAZ VIA WEBSERVICE'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XMLDIR2'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'DIRETORIO PARA GRAVACAO DA COPIA DO XML'								, ; //X6_DESCRIC
	'DIRETORIO PARA GRAVACAO DA COPIA DO XML'								, ; //X6_DSCSPA
	'DIRETORIO PARA GRAVACAO DA COPIA DO XML'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'C:\Teste_XML\'															, ; //X6_CONTEUD
	'C:\Teste_XML\'															, ; //X6_CONTSPA
	'C:\Teste_XML\'															, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_XSEQCOD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Sequencial de cod de barras'											, ; //X6_DESCRIC
	'Sequencial de cod de barras'											, ; //X6_DSCSPA
	'Sequencial de cod de barras'											, ; //X6_DSCENG
	'Sequencial de cod de barras'											, ; //X6_DESC1
	'Sequencial de cod de barras'											, ; //X6_DSCSPA1
	'Sequencial de cod de barras'											, ; //X6_DSCENG1
	'Sequencial de cod de barras'											, ; //X6_DESC2
	'Sequencial de cod de barras'											, ; //X6_DSCSPA2
	'Sequencial de cod de barras'											, ; //X6_DSCENG2
	'9789'																	, ; //X6_CONTEUD
	'9789'																	, ; //X6_CONTSPA
	'9789'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_CATXPRO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nivel de amarracao categorias x produtos, caso'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'conteudo "0" ira considerar a ultima categoria'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'preenchida no produto.'												, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_DEBUG'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita salvamento das querys do GCV na pasta'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'"\DEBUG\" para analise.'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_ENABFRA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Parametro para habilitar utilizacao de Franquias'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'no Pedido de Compra com Grade.'										, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_ENABROY'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita campos de royalties e franquias no pedido'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de compra com grade.'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_ENABTUN'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita Tunning do Oracle atraves de comandos de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'paralelismo.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_ENVSTS'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita workflow atualizacao de status Ticket de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Defeito.'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_FILINDU'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar Filial Industria onde sera gerado o'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Orcamento de Venda.'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_GERAACU'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se ira gerar a tabela ACU automaticamente.'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_GERAACV'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se ira gerar a tabela ACV automaticamente.'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_GERAORC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Gera orcamento de venda na filial industria a'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'partir do Pedido de Compra.'											, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_GERAROY'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Ativa o processo de cobranca de royalties pela'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'entrada de mercadoria.'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_LBPVAUT'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Gera pedido de venda para franquias ja liberado.'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Parâmetro único para indicar quais filiais irão'						, ; //X6_DESCRIC
	'Parâmetro único para indicar quais filiais irão'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'possuir controle de endereço. Ex. 0101|0102'							, ; //X6_DESC1
	'possuir controle de endereço. Ex. 0101|0102'							, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101|0201'																, ; //X6_CONTEUD
	'0101|0201'																, ; //X6_CONTSPA
	'0101|0201'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_LOCPAD1'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrão para gravacao na SBZ'										, ; //X6_DESCRIC
	'Local padrão para gravacao na SBZ'										, ; //X6_DSCSPA
	'Local padrão para gravacao na SBZ'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_OFFREMA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita remarcacao com consulta Off-line.'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_PERFP'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Informe o Percentual de Fundo de Promocao.'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_PERROY'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Informe o Percentual de Royalties.'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_PRZFORN'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Prazo medio de entraga dos fornecedores'								, ; //X6_DESCRIC
	'Prazo medio de entraga dos fornecedores'								, ; //X6_DSCSPA
	'Prazo medio de entraga dos fornecedores'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'30'																	, ; //X6_CONTEUD
	'30'																	, ; //X6_CONTSPA
	'30'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_QTCAPDI'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Quantidade total da capacidade diaria de'								, ; //X6_DESCRIC
	'Quantidade total da capacidade diaria de'								, ; //X6_DSCSPA
	'Quantidade total da capacidade diaria de'								, ; //X6_DSCENG
	'armazenamento no agendamento de entrega.'								, ; //X6_DESC1
	'armazenamento no agendamento de entrega.'								, ; //X6_DSCSPA1
	'armazenamento no agendamento de entrega.'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'180000'																, ; //X6_CONTEUD
	'180000'																, ; //X6_CONTSPA
	'180000'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_SHOWFRA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita opcoes (incluir, alterar, copiar) para as'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'franquias.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_TABPROD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define se ira amarrar o produto SKU (SB1) ou o'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Produto Pai (SB4).'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'SB1'																	, ; //X6_CONTEUD
	'SB1'																	, ; //X6_CONTSPA
	'SB1'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_TIPOROY'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de Cobranca de Royalties: E=Entrada de'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Compras ou F=Faturamento da Franquia.'									, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'																		, ; //X6_CONTEUD
	'F'																		, ; //X6_CONTSPA
	'F'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_USRFIN'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo de usuário que poderao lancar NCC oU NDC na'					, ; //X6_DESCRIC
	'Codigo de usuário que poderao lancar NCC oU NDC na'					, ; //X6_DSCSPA
	'Codigo de usuário que poderao lancar NCC oU NDC na'					, ; //X6_DSCENG
	'rotina troca e devolucao'												, ; //X6_DESC1
	'rotina troca e devolucao'												, ; //X6_DSCSPA1
	'rotina troca e devolucao'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'000076'																, ; //X6_CONTEUD
	'000076'																, ; //X6_CONTSPA
	'000076'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA002A'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita utilizacao de alcada de aprovacao na'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'remarcacao.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA024A'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nivel de categoria que sera trabalhado com metas.'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA024B'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define no cadastro de metas de categorias, se'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'utilizara cadastro padrao GCV de semanas (.T.)'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'ou sera utilizado regras do cliente (.F.).'							, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA033B'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do Produto para Cobranca de Royalties.'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA033C'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da TES para Cobranca de Royalties.'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA033E'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do Produto para Cobranca de Fundo de'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Promocao.'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA033F'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo da TES para Cobranca de Fundo de Promocao.'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA033OP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo Operacao Pedido de Venda derivado da Cobranca'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'de Royalties.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'99'																	, ; //X6_CONTEUD
	'99'																	, ; //X6_CONTSPA
	'99'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA037A'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial de acesso da Central.'											, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100A'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Bloqueios: 1=Envia um alerta e gera pedido normal;'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'2=Gera pedido normal, mas bloqueia pedido;'							, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'3=Nao inclui pedido de compra'											, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	'0'																		, ; //X6_CONTSPA
	'0'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100B'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Customizado especifico para EVRON, caso .T. sera'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'utilizado data inicio-fim de entrega e .F.'							, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'cadastro de semanas GCV.'												, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100C'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Informe .T. para apenas alertar, caso .F. nao'							, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'deixa passar o Markup abaixo do permitido.'							, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100CO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar Tipo de Operacao da geracao automatica do'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Orcamento de Venda.'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'01'																	, ; //X6_CONTEUD
	'01'																	, ; //X6_CONTSPA
	'01'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100CP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar Tabela de Preco para geracao automatica'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'do Orcamento de Venda.'												, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100CT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informar TES da geracao automatica do Orcamento de'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Venda.'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100D'																, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Casas decimais do Valor de IPI no pedido de compra'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'com grade.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'5'																		, ; //X6_CONTEUD
	'5'																		, ; //X6_CONTSPA
	'5'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VA100E'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Picture do campo Valor do IPI no pedido de compra'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'com grade.'															, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'@E 999,999,999.99999'													, ; //X6_CONTEUD
	'@E 999,999,999.99999'													, ; //X6_CONTSPA
	'@E 999,999,999.99999'													, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'SY_VR100A'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Imprime preco de venda na impressao do pedido de'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'compra.'																, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.F.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'KH_DESMAXI'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'Desconto maximo por produto'											, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'70'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'KH_DESSENH'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define a senha de liberação de desconto'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'kh@2018'																, ; //X6_CONTEUD
	'kh@2018'																, ; //X6_CONTSPA
	'kh@2018'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'KH_DESYORN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Precisa de liberaçao do gestor para desconto super'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'ior ao limite?'														, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'KH_MOSTRUA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita lojas para trabalhar com pedidos de venda'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'PV_BOL_ALT'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DESCRIC
	'ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DSCSPA
	'ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DSCENG
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DESC1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCSPA1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCENG1
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DESC2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCSPA2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCENG2
	'1.40'																	, ; //X6_CONTEUD
	'1.40'																	, ; //X6_CONTSPA
	'1.40'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'PV_BOL_COL'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO D'					, ; //X6_DESCRIC
	'NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO D'					, ; //X6_DSCSPA
	'NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO D'					, ; //X6_DSCENG
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DESC1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCSPA1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCENG1
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DESC2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCSPA2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCENG2
	'1.3'																	, ; //X6_CONTEUD
	'1.3'																	, ; //X6_CONTSPA
	'1.3'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'PV_BOL_LAR'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DESCRIC
	'TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DSCSPA
	'TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO'							, ; //X6_DSCENG
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DESC1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCSPA1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCENG1
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DESC2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCSPA2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCENG2
	'0.0280'																, ; //X6_CONTEUD
	'0.0280'																, ; //X6_CONTSPA
	'0.0280'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'PV_BOL_LI1'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO'					, ; //X6_DESCRIC
	'NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO'					, ; //X6_DSCSPA
	'NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO'					, ; //X6_DSCENG
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DESC1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCSPA1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCENG1
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DESC2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCSPA2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCENG2
	'14.5'																	, ; //X6_CONTEUD
	'14.5'																	, ; //X6_CONTSPA
	'14.5'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0101'																	, ; //X6_FIL
	'PV_BOL_LI2'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	'NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO'						, ; //X6_DESCRIC
	'NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO'						, ; //X6_DSCSPA
	'NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO'						, ; //X6_DSCENG
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DESC1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCSPA1
	'CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER'						, ; //X6_DSCENG1
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DESC2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCSPA2
	'DA IMPRESSORA) - A SER USADO NO BOLETO ITAU.'							, ; //X6_DSCENG2
	'26.1'																	, ; //X6_CONTEUD
	'26.1'																	, ; //X6_CONTSPA
	'26.1'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'KH_DESMAXI'															, ; //X6_VAR
	'N'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'70'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'KH_DESSENH'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'kh@2018'																, ; //X6_CONTEUD
	'kh@2018'																, ; //X6_CONTSPA
	'kh@2018'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'KH_DESYORN'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'KH_MOSTRUA'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Habilita lojas para trabalhar com pedidos de venda'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'do tipo mostruario'													, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0102'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrão da filial.  Este parâmetro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteúdo deve ser o armazém'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20'																	, ; //X6_CONTEUD
	'20'																	, ; //X6_CONTSPA
	'20'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0103'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0103'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0103'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'21'																	, ; //X6_CONTEUD
	'21'																	, ; //X6_CONTSPA
	'21'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0104'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0104'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0104'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'22'																	, ; //X6_CONTEUD
	'22'																	, ; //X6_CONTSPA
	'22'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0105'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0105'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0105'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'23'																	, ; //X6_CONTEUD
	'23'																	, ; //X6_CONTSPA
	'23'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0106'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0106'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0106'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'24'																	, ; //X6_CONTEUD
	'24'																	, ; //X6_CONTSPA
	'24'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0107'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0107'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0107'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'25'																	, ; //X6_CONTEUD
	'25'																	, ; //X6_CONTSPA
	'25'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0108'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0108'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0108'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'26'																	, ; //X6_CONTEUD
	'26'																	, ; //X6_CONTSPA
	'26'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0109'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0109'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0109'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'27'																	, ; //X6_CONTEUD
	'27'																	, ; //X6_CONTSPA
	'27'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0110'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0110'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0110'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'28'																	, ; //X6_CONTEUD
	'28'																	, ; //X6_CONTSPA
	'28'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0111'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0111'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0111'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'29'																	, ; //X6_CONTEUD
	'29'																	, ; //X6_CONTSPA
	'29'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0112'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0112'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0112'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'30'																	, ; //X6_CONTEUD
	'30'																	, ; //X6_CONTSPA
	'30'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0113'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0113'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0113'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'31'																	, ; //X6_CONTEUD
	'31'																	, ; //X6_CONTSPA
	'31'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0114'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0114'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0114'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'32'																	, ; //X6_CONTEUD
	'32'																	, ; //X6_CONTSPA
	'32'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0115'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0115'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0115'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'33'																	, ; //X6_CONTEUD
	'33'																	, ; //X6_CONTSPA
	'33'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0116'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0116'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0116'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'34'																	, ; //X6_CONTEUD
	'34'																	, ; //X6_CONTSPA
	'34'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0117'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0117'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0117'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'35'																	, ; //X6_CONTEUD
	'35'																	, ; //X6_CONTSPA
	'35'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0118'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0118'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0118'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'36'																	, ; //X6_CONTEUD
	'36'																	, ; //X6_CONTSPA
	'36'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0119'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0119'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0119'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'37'																	, ; //X6_CONTEUD
	'37'																	, ; //X6_CONTSPA
	'37'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0120'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0120'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0120'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'38'																	, ; //X6_CONTEUD
	'38'																	, ; //X6_CONTSPA
	'38'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0121'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0121'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0121'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'39'																	, ; //X6_CONTEUD
	'39'																	, ; //X6_CONTSPA
	'39'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0122'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0122'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0122'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'40'																	, ; //X6_CONTEUD
	'40'																	, ; //X6_CONTSPA
	'40'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0123'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0123'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0123'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'41'																	, ; //X6_CONTEUD
	'41'																	, ; //X6_CONTSPA
	'41'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0124'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0124'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0124'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'42'																	, ; //X6_CONTEUD
	'42'																	, ; //X6_CONTSPA
	'42'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0125'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0125'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0125'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'43'																	, ; //X6_CONTEUD
	'43'																	, ; //X6_CONTSPA
	'43'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0126'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0126'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0126'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'46'																	, ; //X6_CONTEUD
	'46'																	, ; //X6_CONTSPA
	'46'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0127'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0127'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0127'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'44'																	, ; //X6_CONTEUD
	'44'																	, ; //X6_CONTSPA
	'44'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0128'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Habilita endereço'														, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0128'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0128'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Local padrao da filial.  Este parametro deve ser'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'criado por filial e o conteudo deve ser o armazem'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'padrao da filial (filial 0108  SY_LOCPAD = 05)'						, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'45'																	, ; //X6_CONTEUD
	'45'																	, ; //X6_CONTSPA
	'45'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0129'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0130'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0101'																	, ; //X6_CONTEUD
	'0101'																	, ; //X6_CONTSPA
	'0101'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'02'																	, ; //X6_FIL
	'MV_ULMES'																, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'Data ultimo fechamento do estoque.'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'20170820'																, ; //X6_CONTEUD
	'20170820'																, ; //X6_CONTSPA
	'20170820'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'CONTROLE DE ENDERECAMENTO SIM OU NAO'									, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0201'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	'DATA DA ULTIMA DEPRECIACAO'											, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0202'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0202'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0202'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0202'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'39'																	, ; //X6_CONTEUD
	'39'																	, ; //X6_CONTSPA
	'39'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0203'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'31'																	, ; //X6_CONTEUD
	'31'																	, ; //X6_CONTSPA
	'31'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0204'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'40'																	, ; //X6_CONTEUD
	'40'																	, ; //X6_CONTSPA
	'40'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0205'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'26'																	, ; //X6_CONTEUD
	'26'																	, ; //X6_CONTSPA
	'26'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0206'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0206'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0206'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0206'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'22'																	, ; //X6_CONTEUD
	'22'																	, ; //X6_CONTSPA
	'22'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0207'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0207'																	, ; //X6_FIL
	'MV_SYLOCDP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Filial da empresa CD'													, ; //X6_DESCRIC
	'Filial da empresa CD'													, ; //X6_DSCSPA
	'Filial da empresa CD'													, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0201'																	, ; //X6_CONTEUD
	'0201'																	, ; //X6_CONTSPA
	'0201'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0207'																	, ; //X6_FIL
	'MV_ULTDEPR'															, ; //X6_VAR
	'D'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'19800101'																, ; //X6_CONTEUD
	'19800101'																, ; //X6_CONTSPA
	'19800101'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0207'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'41'																	, ; //X6_CONTEUD
	'41'																	, ; //X6_CONTSPA
	'41'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0208'																	, ; //X6_FIL
	'MV_LOCALIZ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'N'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0208'																	, ; //X6_FIL
	'SY_LOCPAD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	''																		, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'46'																	, ; //X6_CONTEUD
	'46'																	, ; //X6_CONTSPA
	'46'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )
	Else
		lContinua := .T.
		lReclock  := .F.
		If !StrTran( SX6->X6_CONTEUD, " ", "" ) == StrTran( aSX6[nI][13], " ", "" )

			cMsg := "O parâmetro " + aSX6[nI][2] + " está com o conteúdo" + CRLF + ;
			"[" + RTrim( StrTran( SX6->X6_CONTEUD, " ", "" ) ) + "]" + CRLF + ;
			", que é será substituido pelo NOVO conteúdo " + CRLF + ;
			"[" + RTrim( StrTran( aSX6[nI][13]   , " ", "" ) ) + "]" + CRLF + ;
			"Deseja substituir ? "

			If      lTodosSim
				nOpcA := 1
			ElseIf  lTodosNao
				nOpcA := 2
			Else
				nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX6" )
				lTodosSim := ( nOpcA == 3 )
				lTodosNao := ( nOpcA == 4 )

				If lTodosSim
					nOpcA := 1
					lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX6 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
				EndIf

				If lTodosNao
					nOpcA := 2
					lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX6 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
				EndIf

			EndIf

			lContinua := ( nOpcA == 1 )

			If lContinua
				AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
				AllTrim( SX6->X6_CONTEUD ) + "]" + " para [" + AllTrim( aSX6[nI][13] ) + "]" )
			EndIf

		Else
			lContinua := .F.
		EndIf
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDSX601" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
