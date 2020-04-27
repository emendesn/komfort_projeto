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
/*/{Protheus.doc} UPDSX701
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDSX701( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPDSX701" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDSX701" )
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
			// Atualiza o dicionário SX7
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7()

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
/*/{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX7()
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX7" + CRLF )

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo A1_01MUNEN
//
aAdd( aSX7, { ;
	'A1_01MUNEN'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CC2->CC2_MUN'															, ; //X7_REGRA
	'A1_MUNE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CC2'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	"xFilial('CC2')+M->A1_ESTE+M->A1_01MUNEN"								, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_CGC
//
aAdd( aSX7, { ;
	'A1_CGC'																, ; //X7_CAMPO
	'012'																	, ; //X7_SEQUENC
	'IIF(M->A1_PESSOA=="F","2",M->A1_CONTRIB)'								, ; //X7_REGRA
	'A1_CONTRIB'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_CGC'																, ; //X7_CAMPO
	'013'																	, ; //X7_SEQUENC
	'IIF(M->A1_PESSOA=="F","2",M->A1_SIMPLES)'								, ; //X7_REGRA
	'A1_SIMPLES'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_INSCR
//
aAdd( aSX7, { ;
	'A1_INSCR'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'IIF(M->A1_PESSOA=="J".AND.M->A1_INSCRI<>"","1",M->A1_CONTRIB)'			, ; //X7_REGRA
	'A1_CONTRIB'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_NOME
//
aAdd( aSX7, { ;
	'A1_NOME'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->A1_NOME'															, ; //X7_REGRA
	'A1_NREDUZ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_PESSOA
//
aAdd( aSX7, { ;
	'A1_PESSOA'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'IIF(M->A1_PESSOA=="F","2",M->A1_SIMPLES)'								, ; //X7_REGRA
	'A1_SIMPLES'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A1_ULTENDE
//
aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->A1_CEP'																, ; //X7_REGRA
	'A1_CEPE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->A1_END'																, ; //X7_REGRA
	'A1_ENDENT'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->A1_EST'																, ; //X7_REGRA
	'A1_ESTE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'M->A1_MUN'																, ; //X7_REGRA
	'A1_MUNE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'M->A1_COD_MUN'															, ; //X7_REGRA
	'A1_01MUNEN'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'006'																	, ; //X7_SEQUENC
	'M->A1_BAIRRO'															, ; //X7_REGRA
	'A1_BAIRROE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A1_ULTENDE'															, ; //X7_CAMPO
	'007'																	, ; //X7_SEQUENC
	'M->A1_COMPLEM'															, ; //X7_REGRA
	'A1_COMPENT'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A1_ULTENDE=="1"'													} ) //X7_CONDIC

//
// Campo AB6_CODCLI
//
aAdd( aSX7, { ;
	'AB6_CODCLI'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'SA1->A1_NOME'															, ; //X7_REGRA
	'AB6_NOMCLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SA1")+M->AB6_CODCLI+M->AB6_LOJA'								, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AB6_CODCLI'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'"001"'																	, ; //X7_REGRA
	'AB6_CONPAG'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'!EMPTY(M->AB6_CODCLI)'													} ) //X7_CONDIC

//
// Campo AB7_CODPRB
//
aAdd( aSX7, { ;
	'AB7_CODPRB'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'AAG->AAG_DESCRI'														, ; //X7_REGRA
	'AB7_DESOCO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'AAG'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("AAG")+M->AB7_CODPRB'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AB7_CODPRO
//
aAdd( aSX7, { ;
	'AB7_CODPRO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'AB7_DESPRO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->AB7_CODPRO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo ACH_RAZAO
//
aAdd( aSX7, { ;
	'ACH_RAZAO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->ACH_RAZAO'															, ; //X7_REGRA
	'ACH_NFANT'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX0_CAT
//
aAdd( aSX7, { ;
	'AX0_CAT'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AX0_CAT,"AY0_DESC")'				, ; //X7_REGRA
	'AX0_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX0_CAT'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AX0_CAT,"AY0_TIPO")'				, ; //X7_REGRA
	'AX0_NIVEL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX1_CODCAT
//
aAdd( aSX7, { ;
	'AX1_CODCAT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AX1_CODCAT,"AY0_DESC")'			, ; //X7_REGRA
	'AX1_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX1_CODCAT'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AX1_CODCAT,"AY0_TIPO")'			, ; //X7_REGRA
	'AX1_NIVEL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX3_CLIENT
//
aAdd( aSX7, { ;
	'AX3_CLIENT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SA1",1,xFilial("SA1")+M->(AX3_CLIENT+AX3_LOJCLI),"A1_01TPLOJ")'	, ; //X7_REGRA
	'AX3_TPCLI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX3_CONPAG
//
aAdd( aSX7, { ;
	'AX3_CONPAG'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SE4",1,xFilial("SE4")+M->AX3_CONPAG,"E4_DESCRI")'			, ; //X7_REGRA
	'AX3_DESCCP'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX3_LOJCLI
//
aAdd( aSX7, { ;
	'AX3_LOJCLI'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SA1",1,xFilial("SA1")+M->(AX3_CLIENT+AX3_LOJCLI),"A1_01TPLOJ")'	, ; //X7_REGRA
	'AX3_TPCLI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_CLIENT
//
aAdd( aSX7, { ;
	'AX6_CLIENT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SA1",1,xFilial("SA1")+M->AX6_CLIENT,"A1_NOME")'				, ; //X7_REGRA
	'AX6_NOMCLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_LOJCLI
//
aAdd( aSX7, { ;
	'AX6_LOJCLI'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SA1",1,xFilial("SA1")+M->AX6_CLIENT+M->AX6_LOJCLI,"A1_NOME")'	, ; //X7_REGRA
	'AX6_NOMCLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_PRODUT
//
aAdd( aSX7, { ;
	'AX6_PRODUT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SB1",1,xFilial("SB1")+M->AX6_PRODUT,"B1_DESC")'				, ; //X7_REGRA
	'AX6_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_SERIE
//
aAdd( aSX7, { ;
	'AX6_SERIE'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SF1",1,xFilial("SF1")+M->AX6_DOC+M->AX6_SERIE,"F1_DTDIGIT")'	, ; //X7_REGRA
	'AX6_DTDIGI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX6_SERIE'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'POSICIONE("SF1",1,xFilial("SF1")+M->AX6_DOC+M->AX6_SERIE,"F1_FORNECE")'	, ; //X7_REGRA
	'AX6_FORNEC'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX6_SERIE'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'POSICIONE("SF1",1,xFilial("SF1")+M->AX6_DOC+M->AX6_SERIE,"F1_LOJA")'		, ; //X7_REGRA
	'AX6_LOJFOR'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX6_SERIE'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'POSICIONE("SA2",1,xFilial("SA2")+M->AX6_FORNEC+M->AX6_LOJFOR,"A2_NOME")'	, ; //X7_REGRA
	'AX6_NOMFOR'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_STATUS
//
aAdd( aSX7, { ;
	'AX6_STATUS'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AX9",1,XFILIAL("AX9")+AX6_STATUS,"AX9_DESC")'				, ; //X7_REGRA
	'AX6_DESCST'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_TIPO
//
aAdd( aSX7, { ;
	'AX6_TIPO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	"IIF(M->AX6_TIPO=='1',M->AX6_CLIENT,'')"								, ; //X7_REGRA
	'AX6_CLIENT'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX6_TIPO'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	"IIF(M->AX6_TIPO=='1',M->AX6_LOJCLI,'')"								, ; //X7_REGRA
	'AX6_LOJCLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AX6_TIPO'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	"IIF(M->AX6_TIPO=='1',M->AX6_NOMCLI,'')"								, ; //X7_REGRA
	'AX6_NOMCLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AX6_TPDEFE
//
aAdd( aSX7, { ;
	'AX6_TPDEFE'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AX8",1,XFILIAL("AX8")+AX6_TPDEFE,"AX8_DESC")'				, ; //X7_REGRA
	'AX6_DESCDF'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AXB_USER
//
aAdd( aSX7, { ;
	'AXB_USER'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'UsrRetName(AXB_USER)'													, ; //X7_REGRA
	'AXB_IDUSER'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AXB_USER'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'UsrFullName(AXB_USER)'													, ; //X7_REGRA
	'AXB_NOME'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AXB_USER'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'UsrRetMail(AXB_USER)'													, ; //X7_REGRA
	'AXB_EMAIL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AYZ_CODCAT
//
aAdd( aSX7, { ;
	'AYZ_CODCAT'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AYZ_CODCAT,"AY0_DESC")'			, ; //X7_REGRA
	'AYZ_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'AYZ_CODCAT'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->AYZ_CODCAT,"AY0_TIPO")'			, ; //X7_REGRA
	'AYZ_NIVEL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo AYZ_CODFIL
//
aAdd( aSX7, { ;
	'AYZ_CODFIL'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SM0",1,cEmpAnt+M->AYZ_CODFIL,"M0_FILIAL")'					, ; //X7_REGRA
	'AYZ_NOMFIL'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B1_GRUPO
//
aAdd( aSX7, { ;
	'B1_GRUPO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'U_KMGCVG01(M->B1_GRUPO)'												, ; //X7_REGRA
	'B1_POSIPI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_GRUPO'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'IIF(M->B1_GRUPO==( "1001","1002") , "001", "")'						, ; //X7_REGRA
	'B1_XFORM'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_GRUPO'																, ; //X7_CAMPO
	'101'																	, ; //X7_SEQUENC
	'SBM->BM_XGRAPROV'														, ; //X7_REGRA
	'B1_XGRAPRO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	'SBM'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SBM")+M->B1_GRUPO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B1_TIPO
//
aAdd( aSX7, { ;
	'B1_TIPO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'IIF(M->B1_TIPO=="ME", "2", "1")'										, ; //X7_REGRA
	'B1_MSBLQL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_TIPO'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'IIF(M->B1_TIPO==( "ME") , "600", "")'									, ; //X7_REGRA
	'B1_TS'																	, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_TIPO'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'IIF(M->B1_TIPO==( "ME") , "800", "")'									, ; //X7_REGRA
	'B1_TSESPEC'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_TIPO'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'U_KMESTA01()'															, ; //X7_REGRA
	'B1_CODBAR'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01CAT1
//
aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->B4_01CAT1,"AY0_DESC")'				, ; //X7_REGRA
	'B4_01DCAT1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT2'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT3'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT4'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT5'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT1'																, ; //X7_CAMPO
	'006'																	, ; //X7_SEQUENC
	'IIF(M->B4_01CAT1==' + SIMPLES + '0000000020' + SIMPLES + ',' + DUPLAS  + '06' + DUPLAS  + ',M->B4_LOCPAD)', ; //X7_REGRA
	'B4_LOCPAD'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01CAT2
//
aAdd( aSX7, { ;
	'B4_01CAT2'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->B4_01CAT2,"AY0_DESC")'				, ; //X7_REGRA
	'B4_01DCAT2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT2'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT3'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT2'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT4'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT2'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT5'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01CAT3
//
aAdd( aSX7, { ;
	'B4_01CAT3'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->B4_01CAT3,"AY0_DESC")'				, ; //X7_REGRA
	'B4_01DCAT3'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT3'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT4'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01CAT4
//
aAdd( aSX7, { ;
	'B4_01CAT4'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->B4_01CAT4,"AY0_DESC")'				, ; //X7_REGRA
	'B4_01DCAT4'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01CAT4'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'""'																	, ; //X7_REGRA
	'B4_01CAT5'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01CAT5
//
aAdd( aSX7, { ;
	'B4_01CAT5'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("AY0",1,xFilial("AY0")+M->B4_01CAT5,"AY0_DESC")'				, ; //X7_REGRA
	'B4_01DCAT5'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_01COLEC
//
aAdd( aSX7, { ;
	'B4_01COLEC'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'U_GERCOD()'															, ; //X7_REGRA
	'B4_COD'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_01COLEC'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'U_DESCRI()'															, ; //X7_REGRA
	'B4_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B4_GRUPO
//
aAdd( aSX7, { ;
	'B4_GRUPO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'U_KMGCVG01(M->B4_GRUPO)'												, ; //X7_REGRA
	'B4_POSIPI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_GRUPO'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'IIF(M->B4_GRUPO=="1001".OR.M->B4_GRUPO=="1002".OR.M->B4_GRUPO=="1003",5,M->B4_IPI)', ; //X7_REGRA
	'B4_IPI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_GRUPO'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'IIF(M->B4_GRUPO=="1001".OR.M->B4_GRUPO=="1002".OR.M->B4_GRUPO=="1003",12,M->B4_PICM)', ; //X7_REGRA
	'B4_PICM'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_GRUPO'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'IIF(M->B4_GRUPO=="2004","","050")'										, ; //X7_REGRA
	'B4_TE'																	, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B4_GRUPO'																, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'IF(M->B4_GRUPO=="1001".OR.M->B4_GRUPO=="1002".OR.M->B4_GRUPO=="1003","S",M->B4_LICALIZ)', ; //X7_REGRA
	'B4_LOCALIZ'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B9_COD
//
aAdd( aSX7, { ;
	'B9_COD'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'B9_01DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->B9_COD'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C1_CC
//
aAdd( aSX7, { ;
	'C1_CC'																	, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C1_XCCDESC'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C1_CC'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C1_CC'																	, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C1_XCCDESC'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C1_CC'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C1_PRODUTO
//
aAdd( aSX7, { ;
	'C1_PRODUTO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'DBK->DBK_CC'															, ; //X7_REGRA
	'C1_CC'																	, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'DBK'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("DBK")+__cUserid'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C1_PRODUTO'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C1_XCCDESC'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C1_CC'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C5_01MOTOR
//
aAdd( aSX7, { ;
	'C5_01MOTOR'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'DA4->DA4_NOME'															, ; //X7_REGRA
	'C5_01NMOTO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'DA4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("DA4")+M->C5_01MOTOR'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C5_02MOTOR
//
aAdd( aSX7, { ;
	'C5_02MOTOR'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'DA4->DA4_NOME'															, ; //X7_REGRA
	'C5_02NMOTO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'DA4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("DA4")+M->C5_02MOTOR'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C5_CLIENTE
//
aAdd( aSX7, { ;
	'C5_CLIENTE'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SA1->A1_NOME'															, ; //X7_REGRA
	'C5_NOMECLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI'							, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_CLIENTE'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'IIF(M->C5_TIPO=="N","000001",M->C5_TRANSP)'							, ; //X7_REGRA
	'C5_TRANSP'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_CLIENTE'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'IIF(M->C5_TIPO=="N","001",M->C5_CONDPAG)'								, ; //X7_REGRA
	'C5_CONDPAG'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C5_CONTRA
//
aAdd( aSX7, { ;
	'C5_CONTRA'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'IIF(M->C5_CONTRA=="000",M->C5_VEND1,"000251")'							, ; //X7_REGRA
	'C5_VEND1'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C6_PRCVEN
//
aAdd( aSX7, { ;
	'C6_PRCVEN'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'"800"'																	, ; //X7_REGRA
	'C6_TES'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C6_PRODUTO
//
aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'011'																	, ; //X7_SEQUENC
	'SB1->B1_CODANT'														, ; //X7_REGRA
	'C6_XCODNET'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C6_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'012'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'C6_XDESCR'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C6_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C7_CC
//
aAdd( aSX7, { ;
	'C7_CC'																	, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C7_01DCUST'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C7_CC'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C7_PRODUTO
//
aAdd( aSX7, { ;
	'C7_PRODUTO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->C7_DATPFR := ddatabase+SB1->B1_PE'									, ; //X7_REGRA
	'C7_DATPRF'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_PRODUTO'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->C7_PRECO := SB1->B1_CUSTD'											, ; //X7_REGRA
	'C7_PRECO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_PRODUTO'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C7_01DCUST'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C7_CC'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_PRODUTO'															, ; //X7_CAMPO
	'101'																	, ; //X7_SEQUENC
	'SB1->B1_XGRAPRO'														, ; //X7_REGRA
	'C7_APROV'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_APROV'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C7_QUANT
//
aAdd( aSX7, { ;
	'C7_QUANT'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'M->C7_PRECO := SB1->B1_CUSTD'											, ; //X7_REGRA
	'C7_PRECO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_QUANT'																, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'M->C7_TOTAL := NoRound(M->C7_PRECO*M->C7_QUANT,TamSX3("C7_TOTAL")[2])'		, ; //X7_REGRA
	'C7_TOTAL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C7_TOTAL
//
aAdd( aSX7, { ;
	'C7_TOTAL'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->C7_PRECO'															, ; //X7_REGRA
	'C7_PRECO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C7_XCODNET
//
aAdd( aSX7, { ;
	'C7_XCODNET'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SB1->B1_COD'															, ; //X7_REGRA
	'C7_PRODUTO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	12																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_XCODNET'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_XCODNET'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'C7_DESCRI'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	12																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_XCODNET'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_XCODNET'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->C7_DATPFR := ddatabase+SB1->B1_PE'									, ; //X7_REGRA
	'C7_DATPRF'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	12																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_XCODNET'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C7_XCODNET'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'M->C7_PRECO := SB1->B1_CUSTD'											, ; //X7_REGRA
	'C7_PRECO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	12																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->C7_XCODNET'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C8_PRECO
//
aAdd( aSX7, { ;
	'C8_PRECO'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->C8_QUANT * M->C8_PRECO'												, ; //X7_REGRA
	'C8_TOTAL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo D1_QUANT
//
aAdd( aSX7, { ;
	'D1_QUANT'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->D1_TOTAL := ROUND(M->D1_QUANT * M->D1_VUNIT,2)'						, ; //X7_REGRA
	'D1_TOTAL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_QUANT'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CFILANT'																, ; //X7_REGRA
	'D1_01FILDE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_QUANT'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'CFILANT'																, ; //X7_REGRA
	'D1_01FILDE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo D1_VUNIT
//
aAdd( aSX7, { ;
	'D1_VUNIT'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->D1_TOTAL:=M->D1_VUNIT*M->D1_QUANT'									, ; //X7_REGRA
	'D1_TOTAL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_VUNIT'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->D1_TOTAL := ROUND(M->D1_QUANT * M->D1_VUNIT,2)'						, ; //X7_REGRA
	'D1_TOTAL'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_VUNIT'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CFILANT'																, ; //X7_REGRA
	'D1_01FILDE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo DA1_PRCVEN
//
aAdd( aSX7, { ;
	'DA1_PRCVEN'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'IIF(M->DA1_PRCBAS==0,M->DA1_PRCVEN,M->DA1_PRCBAS)'						, ; //X7_REGRA
	'DA1_PRCBAS'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo DAH_XCODMO
//
aAdd( aSX7, { ;
	'DAH_XCODMO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Posicione("SX5",1,xFilial("SX5")+"ZV"+M->DAH_XCODMO,"X5_DESCRI")'		, ; //X7_REGRA
	'DAH_XDESCR'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SX5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SX5")+"ZV"+M->DAH_XCODMO'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo E2_FORMPAG
//
aAdd( aSX7, { ;
	'E2_FORMPAG'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'U_XGATCTA("BANCO")'													, ; //X7_REGRA
	'E2_FORBCO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'E2_FORMPAG'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'U_XGATCTA("AGENCIA")'													, ; //X7_REGRA
	'E2_FORAGE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'E2_FORMPAG'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'U_XGATCTA("DGAGENCIA")'												, ; //X7_REGRA
	'E2_FAGEDV'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'E2_FORMPAG'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'U_XGATCTA("CONTA")'													, ; //X7_REGRA
	'E2_FORCTA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'E2_FORMPAG'															, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'U_XGATCTA("DGCONTA")'													, ; //X7_REGRA
	'E2_FCTADV'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo E2_LINDIG
//
aAdd( aSX7, { ;
	'E2_LINDIG'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'EXECBLOCK("CONVLD",.T.)'												, ; //X7_REGRA
	'E2_CODBAR'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'.F.'																	} ) //X7_CONDIC

//
// Campo UA_CLIENTE
//
aAdd( aSX7, { ;
	'UA_CLIENTE'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU7->U7_CODVEN'														, ; //X7_REGRA
	'UA_VEND'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU7'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SU7")+M->UA_OPERADO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UA_CLIENTE'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'SA3->A3_NOME'															, ; //X7_REGRA
	'UA_DESCVEN'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA3'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SA3")+M->UA_VEND'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UA_CLIENTE'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'U_SYTMOV13()'															, ; //X7_REGRA
	'UA_CLIENTE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UA_CODCONT
//
aAdd( aSX7, { ;
	'UA_CODCONT'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SU7->U7_CODVEN'														, ; //X7_REGRA
	'UA_VEND'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SU7'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SU7")+M->UA_OPERADO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UA_VEND1
//
aAdd( aSX7, { ;
	'UA_VEND1'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SA3->A3_NOME'															, ; //X7_REGRA
	'UA_DESVEN1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA3'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SA3")+M->UA_VEND1'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UB_PRODUTO
//
aAdd( aSX7, { ;
	'UB_PRODUTO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'LEFT(M->UB_PRODUTO,6)'													, ; //X7_REGRA
	'UB_01PRODP'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UC_OPERACA
//
aAdd( aSX7, { ;
	'UC_OPERACA'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->UC_DESCNT'															, ; //X7_REGRA
	'UC_DESCNT1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UC_OPERACA'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->UC_DESCCHA'															, ; //X7_REGRA
	'UC_DESCCH1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UD_PRODUTO
//
aAdd( aSX7, { ;
	'UD_PRODUTO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->UD_01PRCVE := DA1->DA1_PRCVEN'										, ; //X7_REGRA
	'UD_01PRCVE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'DA1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("DA1")+AvKey(GetMv("MV_TABPAD"),"DA1_CODTAB")+M->UD_PRODUTO'		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UD_PRODUTO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->UD_01QTDVE := 1'													, ; //X7_REGRA
	'UD_01QTDVE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UD_PRODUTO'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->UD_01VLPED := ROUND(M->UD_01QTDVE * M->UD_01PRCVE,2)'				, ; //X7_REGRA
	'UD_01VLPED'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UD_PRODUTO'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'SB1->B1_UM'															, ; //X7_REGRA
	'UD_01UM'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->UD_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'UD_PRODUTO'															, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'SB1->B1_LOCPAD'														, ; //X7_REGRA
	'UD_01LOCAL'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->UD_PRODUTO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UD_XDEFEI2
//
aAdd( aSX7, { ;
	'UD_XDEFEI2'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'X5DESCRI()'															, ; //X7_REGRA
	'UD_XDESDE2'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SX5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("SX5")+ "Z1" + M->UD_XDEFEI2'									, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UD_XDEFEI3
//
aAdd( aSX7, { ;
	'UD_XDEFEI3'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'X5DESCRI()'															, ; //X7_REGRA
	'UD_XDESDE3'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SX5'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("SX5") + "Z1" + M->UD_XDEFEI3'									, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo UF_PRODUTO
//
aAdd( aSX7, { ;
	'UF_PRODUTO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'U_KMTMKG01()'															, ; //X7_REGRA
	'UB_VRUNIT'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo US_01MUNEN
//
aAdd( aSX7, { ;
	'US_01MUNEN'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CC2->CC2_MUN'															, ; //X7_REGRA
	'US_MUN'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CC2'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	"xFilial('CC2')+M->US_EST+M->US_01MUNEN"								, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo US_NOME
//
aAdd( aSX7, { ;
	'US_NOME'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->US_NOME'															, ; //X7_REGRA
	'US_NREDUZ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo Z1_CONDPG
//
aAdd( aSX7, { ;
	'Z1_CONDPG'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SE4->E4_DESCRI'														, ; //X7_REGRA
	'Z1_CONDICA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SE4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SE4")+M->Z1_CONDPG'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo Z2_CODTAB
//
aAdd( aSX7, { ;
	'Z2_CODTAB'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'DA0->DA0_DESCRI'														, ; //X7_REGRA
	'Z2_DESCTAB'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'DA0'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("DA0")+M->Z2_CODTAB'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo Z3_CODPRO
//
aAdd( aSX7, { ;
	'Z3_CODPRO'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'Z3_DESC'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SB1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SB1")+M->Z3_CODPRO'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo Z3_CODVEND
//
aAdd( aSX7, { ;
	'Z3_CODVEND'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SA3->A3_NOME'															, ; //X7_REGRA
	'Z3_NOMEVEN'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA3'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SA3")+M->Z3_CODVEND'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi incluído o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
		EndIf

		RecLock( "SX7", .T. )
	Else

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
		EndIf

		RecLock( "SX7", .F. )
	EndIf

	For nJ := 1 To Len( aSX7[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
		EndIf
	Next nJ

	dbCommit()
	MsUnLock()

	If SX3->( dbSeek( SX7->X7_CAMPO ) )
		RecLock( "SX3", .F. )
		SX3->X3_TRIGGER := "S"
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

RestArea( aAreaSX3 )

AutoGrLog( CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

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
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDSX701" ) ) ) ;
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
