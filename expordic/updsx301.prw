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
/*/{Protheus.doc} UPDSX301
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDSX301( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPDSX301" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDSX301" )
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
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

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
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

//
// --- ATENÇÃO ---
// Coloque .F. na 2a. posição de cada elemento do array, para os dados do SX3
// que não serão atualizados quando o campo já existir.
//

//
// Campos Tabela AC8
//
aAdd( aSX3, { ;
	{ 'AC8'																	, .F. }, ; //X3_ARQUIVO
	{ '15'																	, .F. }, ; //X3_ORDEM
	{ 'AC8_XORIGE'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Origem Info'															, .F. }, ; //X3_TITULO
	{ 'Origem Info'															, .F. }, ; //X3_TITSPA
	{ 'Origem Info'															, .F. }, ; //X3_TITENG
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCRIC
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCSPA
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'AC8'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'AC8_XDTIMP'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt.Importa'															, .F. }, ; //X3_TITULO
	{ 'Dt.Importa'															, .F. }, ; //X3_TITSPA
	{ 'Dt.Importa'															, .F. }, ; //X3_TITENG
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCRIC
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCSPA
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela AY1
//
aAdd( aSX3, { ;
	{ 'AY1'																	, .F. }, ; //X3_ARQUIVO
	{ '09'																	, .F. }, ; //X3_ORDEM
	{ 'AY1_XSBCLA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Sub.Clas CNP'														, .F. }, ; //X3_TITULO
	{ 'Sub.Clas CNP'														, .F. }, ; //X3_TITSPA
	{ 'Sub.Clas CNP'														, .F. }, ; //X3_TITENG
	{ 'Subclasse Produto CNP'												, .F. }, ; //X3_DESCRIC
	{ 'Subclasse Produto CNP'												, .F. }, ; //X3_DESCSPA
	{ 'Subclasse Produto CNP'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ '_ZX'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela BVV
//
aAdd( aSX3, { ;
	{ 'BVV'																	, .F. }, ; //X3_ARQUIVO
	{ '05'																	, .F. }, ; //X3_ORDEM
	{ 'BVV_XSD'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XSDs Versao'															, .F. }, ; //X3_TITULO
	{ 'XSD Version'															, .F. }, ; //X3_TITSPA
	{ 'Version XSDs'														, .F. }, ; //X3_TITENG
	{ 'Nome arqiuvos XSDs TISS'												, .F. }, ; //X3_DESCRIC
	{ 'Nombre archivos XSD TISS'											, .F. }, ; //X3_DESCSPA
	{ 'TISS XSD file name'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'N'																	, .F. }} ) //X3_PYME

//
// Campos Tabela CC0
//
aAdd( aSX3, { ;
	{ 'CC0'																	, .F. }, ; //X3_ARQUIVO
	{ '14'																	, .F. }, ; //X3_ORDEM
	{ 'CC0_XMLMDF'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML MDFe'															, .F. }, ; //X3_TITULO
	{ 'XML MDFe'															, .F. }, ; //X3_TITSPA
	{ 'MDFe XML'															, .F. }, ; //X3_TITENG
	{ 'XML do MDFe'															, .F. }, ; //X3_DESCRIC
	{ 'XML del MDFe'														, .F. }, ; //X3_DESCSPA
	{ 'MDFe XML'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela CDQ
//
aAdd( aSX3, { ;
	{ 'CDQ'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'CDQ_XMLENV'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Xml Envio'															, .F. }, ; //X3_TITULO
	{ 'Xml Envio'															, .F. }, ; //X3_TITSPA
	{ 'Send Xml'															, .F. }, ; //X3_TITENG
	{ 'Xml de Envio'														, .F. }, ; //X3_DESCRIC
	{ 'Xml de Envio'														, .F. }, ; //X3_DESCSPA
	{ 'Send Xml'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'CDQ'																	, .F. }, ; //X3_ARQUIVO
	{ '12'																	, .F. }, ; //X3_ORDEM
	{ 'CDQ_XMLRET'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Xml Ret'																, .F. }, ; //X3_TITULO
	{ 'Xml Ret'																, .F. }, ; //X3_TITSPA
	{ 'Xml Ret'																, .F. }, ; //X3_TITENG
	{ 'Xml de Retorno'														, .F. }, ; //X3_DESCRIC
	{ 'Xml de Retorno'														, .F. }, ; //X3_DESCSPA
	{ 'XML Return'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela CKO
//
aAdd( aSX3, { ;
	{ 'CKO'																	, .F. }, ; //X3_ARQUIVO
	{ '05'																	, .F. }, ; //X3_ORDEM
	{ 'CKO_XMLENV'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Envio'															, .F. }, ; //X3_TITULO
	{ 'XML Envio'															, .F. }, ; //X3_TITSPA
	{ 'XML Send'															, .F. }, ; //X3_TITENG
	{ 'XML de envio para NeoGrid'											, .F. }, ; //X3_DESCRIC
	{ 'XML de envio para NeoGrid'											, .F. }, ; //X3_DESCSPA
	{ 'XML send to NeoGrid'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'CKO'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'CKO_XMLRET'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Retorno'															, .F. }, ; //X3_TITULO
	{ 'XML Retorno'															, .F. }, ; //X3_TITSPA
	{ 'XML Return'															, .F. }, ; //X3_TITENG
	{ 'XML de retorno da NeoGrid'											, .F. }, ; //X3_DESCRIC
	{ 'XML respuesta de NeoGrid'											, .F. }, ; //X3_DESCSPA
	{ 'XML return from Neogrid'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela CU0
//
aAdd( aSX3, { ;
	{ 'CU0'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'CU0_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Reg.'															, .F. }, ; //X3_TITULO
	{ 'XML Reg.'															, .F. }, ; //X3_TITSPA
	{ 'Rec.XML'																, .F. }, ; //X3_TITENG
	{ 'XML do Registro Incons.'												, .F. }, ; //X3_DESCRIC
	{ 'XML del registro incons.'											, .F. }, ; //X3_DESCSPA
	{ 'Incons Record XML'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela DAH
//
aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '13'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XCODMO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod Motivo'															, .F. }, ; //X3_TITULO
	{ 'Cod Motivo'															, .F. }, ; //X3_TITSPA
	{ 'Cod Motivo'															, .F. }, ; //X3_TITENG
	{ 'Codigo Motivo Apontamento'											, .F. }, ; //X3_DESCRIC
	{ 'Codigo Motivo Apontamento'											, .F. }, ; //X3_DESCSPA
	{ 'Codigo Motivo Apontamento'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'ZV'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ "Vazio() .Or. ExistCpo('SX5','ZV'+M->DAH_XCODMO)"						, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '14'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XDESCR'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descr Aponta'														, .F. }, ; //X3_TITULO
	{ 'Descr Aponta'														, .F. }, ; //X3_TITSPA
	{ 'Descr Aponta'														, .F. }, ; //X3_TITENG
	{ 'Descricao Mot Apontamento'											, .F. }, ; //X3_DESCRIC
	{ 'Descricao Mot Apontamento'											, .F. }, ; //X3_DESCSPA
	{ 'Descricao Mot Apontamento'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '15'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XRG'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 12																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'RG Recebedor'														, .F. }, ; //X3_TITULO
	{ 'RG Recebedor'														, .F. }, ; //X3_TITSPA
	{ 'RG Recebedor'														, .F. }, ; //X3_TITENG
	{ 'RG Recebedor'														, .F. }, ; //X3_DESCRIC
	{ 'RG Recebedor'														, .F. }, ; //X3_DESCSPA
	{ 'RG Recebedor'														, .F. }, ; //X3_DESCENG
	{ '@R 99.999.999-9'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XRECEB'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nome Recebec'														, .F. }, ; //X3_TITULO
	{ 'Nome Recebec'														, .F. }, ; //X3_TITSPA
	{ 'Nome Recebec'														, .F. }, ; //X3_TITENG
	{ 'Nome do Recebedor'													, .F. }, ; //X3_DESCRIC
	{ 'Nome do Recebedor'													, .F. }, ; //X3_DESCSPA
	{ 'Nome do Recebedor'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '17'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XOBSER'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 150																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacao'															, .F. }, ; //X3_TITULO
	{ 'Observacao'															, .F. }, ; //X3_TITSPA
	{ 'Observacao'															, .F. }, ; //X3_TITENG
	{ 'Observacao'															, .F. }, ; //X3_DESCRIC
	{ 'Observacao'															, .F. }, ; //X3_DESCSPA
	{ 'Observacao'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '18'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XDTENT'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Data Entrega'														, .F. }, ; //X3_TITULO
	{ 'Data Entrega'														, .F. }, ; //X3_TITSPA
	{ 'Data Entrega'														, .F. }, ; //X3_TITENG
	{ 'Data de Entrega'														, .F. }, ; //X3_DESCRIC
	{ 'Data de Entrega'														, .F. }, ; //X3_DESCSPA
	{ 'Data de Entrega'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'DAH'																	, .F. }, ; //X3_ARQUIVO
	{ '19'																	, .F. }, ; //X3_ORDEM
	{ 'DAH_XNRSAC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Numero SAC'															, .F. }, ; //X3_TITULO
	{ 'Numero SAC'															, .F. }, ; //X3_TITSPA
	{ 'Numero SAC'															, .F. }, ; //X3_TITENG
	{ 'Nr.Atendimento CallCenter'											, .F. }, ; //X3_DESCRIC
	{ 'Nr.Atendimento CallCenter'											, .F. }, ; //X3_DESCSPA
	{ 'Nr.Atendimento CallCenter'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela DAK
//
aAdd( aSX3, { ;
	{ 'DAK'																	, .F. }, ; //X3_ARQUIVO
	{ '32'																	, .F. }, ; //X3_ORDEM
	{ 'DAK_XIMP'															, .F. }, ; //X3_CAMPO
	{ 'L'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mapa Entrega'														, .F. }, ; //X3_TITULO
	{ 'Mapa Entrega'														, .F. }, ; //X3_TITSPA
	{ 'Mapa Entrega'														, .F. }, ; //X3_TITENG
	{ 'Informa se ja foi impress'											, .F. }, ; //X3_DESCRIC
	{ 'Informa se ja foi impress'											, .F. }, ; //X3_DESCSPA
	{ 'Informa se ja foi impress'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '.F.'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ '.F.'																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela DBU
//
aAdd( aSX3, { ;
	{ 'DBU'																	, .F. }, ; //X3_ARQUIVO
	{ '12'																	, .F. }, ; //X3_ORDEM
	{ 'DBU_X'																, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Eixo X'																, .F. }, ; //X3_TITULO
	{ 'Eje X'																, .F. }, ; //X3_TITSPA
	{ 'Axle X'																, .F. }, ; //X3_TITENG
	{ 'Posição no eixo X'													, .F. }, ; //X3_DESCRIC
	{ 'Posicion en el eje X'												, .F. }, ; //X3_DESCSPA
	{ 'Axle X position'														, .F. }, ; //X3_DESCENG
	{ '@E 9,999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela EWQ
//
aAdd( aSX3, { ;
	{ 'EWQ'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'EWQ_XCONT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 200																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conteúdo'															, .F. }, ; //X3_TITULO
	{ 'Contenido'															, .F. }, ; //X3_TITSPA
	{ 'Content'																, .F. }, ; //X3_TITENG
	{ 'Conteúdo'															, .F. }, ; //X3_DESCRIC
	{ 'Contenido'															, .F. }, ; //X3_DESCSPA
	{ 'Content'																, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'N'																	, .F. }} ) //X3_PYME

//
// Campos Tabela EYP
//
aAdd( aSX3, { ;
	{ 'EYP'																	, .F. }, ; //X3_ARQUIVO
	{ '14'																	, .F. }, ; //X3_ORDEM
	{ 'EYP_XML'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Arq. XML'															, .F. }, ; //X3_TITULO
	{ 'Arch. XML'															, .F. }, ; //X3_TITSPA
	{ 'XML File'															, .F. }, ; //X3_TITENG
	{ 'Arquivo XML'															, .F. }, ; //X3_DESCRIC
	{ 'Archivo XML'															, .F. }, ; //X3_DESCSPA
	{ 'XML File'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(144) + Chr(128) + Chr(192) + ;
	Chr(128) + Chr(128) + Chr(192) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(150) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela GC7
//
aAdd( aSX3, { ;
	{ 'GC7'																	, .F. }, ; //X3_ARQUIVO
	{ '13'																	, .F. }, ; //X3_ORDEM
	{ 'GC7_XLOGO'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 2																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Coordenada X'														, .F. }, ; //X3_TITULO
	{ 'Coordenada X'														, .F. }, ; //X3_TITSPA
	{ 'X coordinate'														, .F. }, ; //X3_TITENG
	{ 'Eixo x'																, .F. }, ; //X3_DESCRIC
	{ 'Eje x'																, .F. }, ; //X3_DESCSPA
	{ 'X axis'																, .F. }, ; //X3_DESCENG
	{ '99'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela MF6
//
aAdd( aSX3, { ;
	{ 'MF6'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'MF6_XFILIA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Filial Estoq'														, .F. }, ; //X3_TITULO
	{ 'Suc. Stock'															, .F. }, ; //X3_TITSPA
	{ 'Stock Branch'														, .F. }, ; //X3_TITENG
	{ 'Filial de reserva de estq'											, .F. }, ; //X3_DESCRIC
	{ 'Sucursal reserva de stock'											, .F. }, ; //X3_DESCSPA
	{ 'Stock reservation branch'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(133) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ '033'																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'S'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela MGM
//
aAdd( aSX3, { ;
	{ 'MGM'																	, .F. }, ; //X3_ARQUIVO
	{ '08'																	, .F. }, ; //X3_ORDEM
	{ 'MGM_XMLENV'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Envio'															, .F. }, ; //X3_TITULO
	{ 'XML Envio'															, .F. }, ; //X3_TITSPA
	{ 'XML Sending'															, .F. }, ; //X3_TITENG
	{ 'XML Envio'															, .F. }, ; //X3_DESCRIC
	{ 'XML Envio'															, .F. }, ; //X3_DESCSPA
	{ 'XML Sending'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'S'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'MGM'																	, .F. }, ; //X3_ARQUIVO
	{ '09'																	, .F. }, ; //X3_ORDEM
	{ 'MGM_XMLRET'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Retorno'															, .F. }, ; //X3_TITULO
	{ 'XML Retorno'															, .F. }, ; //X3_TITSPA
	{ 'XML Return'															, .F. }, ; //X3_TITENG
	{ 'XML Retorno'															, .F. }, ; //X3_DESCRIC
	{ 'XML Retorno'															, .F. }, ; //X3_DESCSPA
	{ 'SML Return'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'S'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela MH2
//
aAdd( aSX3, { ;
	{ 'MH2'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'MH2_XMLENV'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Envio'															, .F. }, ; //X3_TITULO
	{ 'XML Envío'															, .F. }, ; //X3_TITSPA
	{ 'XML Submit'															, .F. }, ; //X3_TITENG
	{ 'XML de Envio'														, .F. }, ; //X3_DESCRIC
	{ 'XML de envío'														, .F. }, ; //X3_DESCSPA
	{ 'Submit XML'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'MH2'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'MH2_XMLRET'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Retorno'															, .F. }, ; //X3_TITULO
	{ 'XML Dev.'															, .F. }, ; //X3_TITSPA
	{ 'XML Return'															, .F. }, ; //X3_TITENG
	{ 'XML de Retorno'														, .F. }, ; //X3_DESCRIC
	{ 'XML de devolución'													, .F. }, ; //X3_DESCSPA
	{ 'Return XML'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela NWT
//
aAdd( aSX3, { ;
	{ 'NWT'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'NWT_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Envio'															, .F. }, ; //X3_TITULO
	{ 'XML Envio'															, .F. }, ; //X3_TITSPA
	{ 'Send XML'															, .F. }, ; //X3_TITENG
	{ 'XML Envio'															, .F. }, ; //X3_DESCRIC
	{ 'XML Envio'															, .F. }, ; //X3_DESCSPA
	{ 'Sending XML'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela NX3
//
aAdd( aSX3, { ;
	{ 'NX3'																	, .F. }, ; //X3_ARQUIVO
	{ '08'																	, .F. }, ; //X3_ORDEM
	{ 'NX3_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML Layout'															, .F. }, ; //X3_TITULO
	{ 'XML Layout'															, .F. }, ; //X3_TITSPA
	{ 'XML Layout'															, .F. }, ; //X3_TITENG
	{ 'XML Layout'															, .F. }, ; //X3_DESCRIC
	{ 'XML Layout'															, .F. }, ; //X3_DESCSPA
	{ 'XML Layout'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela O09
//
aAdd( aSX3, { ;
	{ 'O09'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'O09_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML'																	, .F. }, ; //X3_TITULO
	{ 'XML'																	, .F. }, ; //X3_TITSPA
	{ 'XML'																	, .F. }, ; //X3_TITENG
	{ 'XML enviado ao TAF'													, .F. }, ; //X3_DESCRIC
	{ 'XML enviado al TAF'													, .F. }, ; //X3_DESCSPA
	{ 'XML sent to TAF'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'N'																	, .F. }} ) //X3_PYME

//
// Campos Tabela QK9
//
aAdd( aSX3, { ;
	{ 'QK9'																	, .F. }, ; //X3_ARQUIVO
	{ '10'																	, .F. }, ; //X3_ORDEM
	{ 'QK9_XBB'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 13																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'X Med. Med.'															, .F. }, ; //X3_TITULO
	{ 'X Promed.Med'														, .F. }, ; //X3_TITSPA
	{ 'Average X'															, .F. }, ; //X3_TITENG
	{ 'X Medio da Media'													, .F. }, ; //X3_DESCRIC
	{ 'X Promedio de Media'													, .F. }, ; //X3_DESCSPA
	{ 'Average X'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(132) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(194) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA1
//
aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ '15'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XNUMEND'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Numero ender'														, .F. }, ; //X3_TITULO
	{ 'Numero ender'														, .F. }, ; //X3_TITSPA
	{ 'Numero ender'														, .F. }, ; //X3_TITENG
	{ 'Numero do endereco princi'											, .F. }, ; //X3_DESCRIC
	{ 'Numero do endereco princi'											, .F. }, ; //X3_DESCSPA
	{ 'Numero do endereco princi'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ '27'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XTEL3'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tel.Conta3'															, .F. }, ; //X3_TITULO
	{ 'Tel.Conta3'															, .F. }, ; //X3_TITSPA
	{ 'Tel.Conta3'															, .F. }, ; //X3_TITENG
	{ 'Telefone de Contato 3'												, .F. }, ; //X3_DESCRIC
	{ 'Telefone de Contato 3'												, .F. }, ; //X3_DESCSPA
	{ 'Telefone de Contato 3'												, .F. }, ; //X3_DESCENG
	{ '@R 9999999999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ 'Q7'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XORIGEM'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Origem Info'															, .F. }, ; //X3_TITULO
	{ 'Origem Info'															, .F. }, ; //X3_TITSPA
	{ 'Origem Info'															, .F. }, ; //X3_TITENG
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCRIC
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCSPA
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ 'Q8'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XDTIMP'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt.Importa'															, .F. }, ; //X3_TITULO
	{ 'Dt.Importa'															, .F. }, ; //X3_TITSPA
	{ 'Dt.Importa'															, .F. }, ; //X3_TITENG
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCRIC
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCSPA
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA2
//
aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'M9'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XFORFAT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tp Fornecedo'														, .F. }, ; //X3_TITULO
	{ 'Tp Fornecedo'														, .F. }, ; //X3_TITSPA
	{ 'Tipo Fornece'														, .F. }, ; //X3_TITENG
	{ 'Tipo Fornecedor'														, .F. }, ; //X3_DESCRIC
	{ 'Tipo Fornecedor'														, .F. }, ; //X3_DESCSPA
	{ 'Tipo Fornecedor'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Normal'															, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N0'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XAGCONT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'AG.CONTA'															, .F. }, ; //X3_TITULO
	{ 'AG.CONTA'															, .F. }, ; //X3_TITSPA
	{ 'AG.CONTA'															, .F. }, ; //X3_TITENG
	{ 'AG.CONTA SISPAG'														, .F. }, ; //X3_DESCRIC
	{ 'AG.CONTA SISPAG'														, .F. }, ; //X3_DESCSPA
	{ 'AG.CONTA SISPAG'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA5
//
aAdd( aSX3, { ;
	{ 'SA5'																	, .F. }, ; //X3_ARQUIVO
	{ 'B7'																	, .F. }, ; //X3_ORDEM
	{ 'A5_XLIBGQ'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Liberado G.Q'														, .F. }, ; //X3_TITULO
	{ 'Liberado G.Q'														, .F. }, ; //X3_TITSPA
	{ 'Liberado G.Q'														, .F. }, ; //X3_TITENG
	{ 'Liberado G. Qualidade'												, .F. }, ; //X3_DESCRIC
	{ 'Liberado G. Qualidade'												, .F. }, ; //X3_DESCSPA
	{ 'Liberado G. Qualidade'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("12")'														, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOX
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOXSPA
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA6
//
aAdd( aSX3, { ;
	{ 'SA6'																	, .F. }, ; //X3_ARQUIVO
	{ '73'																	, .F. }, ; //X3_ORDEM
	{ 'A6_XTXMLBL'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Tx da Multa'															, .F. }, ; //X3_TITULO
	{ 'Tx da Multa'															, .F. }, ; //X3_TITSPA
	{ 'Tx da Multa'															, .F. }, ; //X3_TITENG
	{ 'Tx da Multa'															, .F. }, ; //X3_DESCRIC
	{ 'Tx da Multa'															, .F. }, ; //X3_DESCSPA
	{ 'Tx da Multa'															, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Positivo()'															, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA6'																	, .F. }, ; //X3_ARQUIVO
	{ '74'																	, .F. }, ; //X3_ORDEM
	{ 'A6_XTXMOBL'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Tx Mora Diar'														, .F. }, ; //X3_TITULO
	{ 'Tx Mora Diar'														, .F. }, ; //X3_TITSPA
	{ 'Tx Mora Diar'														, .F. }, ; //X3_TITENG
	{ 'Taxa de Mora Diaria'													, .F. }, ; //X3_DESCRIC
	{ 'Taxa de Mora Diaria'													, .F. }, ; //X3_DESCSPA
	{ 'Taxa de Mora Diaria'													, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Positivo()'															, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SAE
//
aAdd( aSX3, { ;
	{ 'SAE'																	, .F. }, ; //X3_ARQUIVO
	{ '31'																	, .F. }, ; //X3_ORDEM
	{ 'AE_XPARINI'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Par Ini Base'														, .F. }, ; //X3_TITULO
	{ '.'																	, .F. }, ; //X3_TITSPA
	{ '.'																	, .F. }, ; //X3_TITENG
	{ 'Parcela inicial de Base'												, .F. }, ; //X3_DESCRIC
	{ 'Parcela inicial de Base'												, .F. }, ; //X3_DESCSPA
	{ 'Parcela inicial de Base'												, .F. }, ; //X3_DESCENG
	{ '@E 999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SAE'																	, .F. }, ; //X3_ARQUIVO
	{ '34'																	, .F. }, ; //X3_ORDEM
	{ 'AE_XPORTAD'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Portador'															, .F. }, ; //X3_TITULO
	{ 'Portador'															, .F. }, ; //X3_TITSPA
	{ 'Portador'															, .F. }, ; //X3_TITENG
	{ 'Cod Portador transitorio'											, .F. }, ; //X3_DESCRIC
	{ 'Cod Portador transitorio'											, .F. }, ; //X3_DESCSPA
	{ 'Cod Portador transitorio'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'BCO'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SAE'																	, .F. }, ; //X3_ARQUIVO
	{ '38'																	, .F. }, ; //X3_ORDEM
	{ 'AE_XDESMAX'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITULO
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITSPA
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITENG
	{ 'Desconto Maximo'														, .F. }, ; //X3_DESCRIC
	{ 'Desconto Maximo'														, .F. }, ; //X3_DESCSPA
	{ 'Desconto Maximo'														, .F. }, ; //X3_DESCENG
	{ '@E 99.99 %'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SAE'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'AE_XFORTX'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fornece TX'															, .F. }, ; //X3_TITULO
	{ 'Fornece TX'															, .F. }, ; //X3_TITSPA
	{ 'Fornece TX'															, .F. }, ; //X3_TITENG
	{ 'Fornecedor Taxa'														, .F. }, ; //X3_DESCRIC
	{ 'Fornecedor Taxa'														, .F. }, ; //X3_DESCSPA
	{ 'Fornecedor Taxa'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SA2'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SAE'																	, .F. }, ; //X3_ARQUIVO
	{ '40'																	, .F. }, ; //X3_ORDEM
	{ 'AE_XLJTX'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 2																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Lj.For TX'															, .F. }, ; //X3_TITULO
	{ 'Lj.For TX'															, .F. }, ; //X3_TITSPA
	{ 'Lj.For TX'															, .F. }, ; //X3_TITENG
	{ 'Loja do Fornecedor Taxa'												, .F. }, ; //X3_DESCRIC
	{ 'Loja do Fornecedor Taxa'												, .F. }, ; //X3_DESCSPA
	{ 'Loja do Fornecedor Taxa'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SB1
//
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'V3'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XFORM'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fórmula'																, .F. }, ; //X3_TITULO
	{ 'formula'																, .F. }, ; //X3_TITSPA
	{ 'formula'																, .F. }, ; //X3_TITENG
	{ 'formula'																, .F. }, ; //X3_DESCRIC
	{ 'formula'																, .F. }, ; //X3_DESCSPA
	{ 'formula'																, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SM4'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'V4'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XPERSO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Personalizad'														, .F. }, ; //X3_TITULO
	{ 'Personalizad'														, .F. }, ; //X3_TITSPA
	{ 'Personalizad'														, .F. }, ; //X3_TITENG
	{ 'Item Personalizado'													, .F. }, ; //X3_DESCRIC
	{ 'Item Personalizado'													, .F. }, ; //X3_DESCSPA
	{ 'Item Personalizado'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOX
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXSPA
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'V7'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XGRAPRO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'G Aprov Com'															, .F. }, ; //X3_TITULO
	{ 'G Aprov Com'															, .F. }, ; //X3_TITSPA
	{ 'G Aprov Com'															, .F. }, ; //X3_TITENG
	{ 'Gr de Aprov de Compras'												, .F. }, ; //X3_DESCRIC
	{ 'Gr de Aprov de Compras'												, .F. }, ; //X3_DESCSPA
	{ 'Gr de Aprov de Compras'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SB2
//
aAdd( aSX3, { ;
	{ 'SB2'																	, .F. }, ; //X3_ARQUIVO
	{ '87'																	, .F. }, ; //X3_ORDEM
	{ 'B2_XDTINI'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fch. Inicial'														, .F. }, ; //X3_TITULO
	{ 'Cierre Inic'															, .F. }, ; //X3_TITSPA
	{ 'St Closing'															, .F. }, ; //X3_TITENG
	{ 'Fechamento inicial'													, .F. }, ; //X3_DESCRIC
	{ 'Cierre inicial'														, .F. }, ; //X3_DESCSPA
	{ 'Start Closing'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(128) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB2'																	, .F. }, ; //X3_ARQUIVO
	{ '88'																	, .F. }, ; //X3_ORDEM
	{ 'B2_XDTFIN'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fch. Final'															, .F. }, ; //X3_TITULO
	{ 'Cierre final'														, .F. }, ; //X3_TITSPA
	{ 'End Closing'															, .F. }, ; //X3_TITENG
	{ 'Fechamento Final'													, .F. }, ; //X3_DESCRIC
	{ 'Cierre final'														, .F. }, ; //X3_DESCSPA
	{ 'End Closing'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(128) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SB4
//
aAdd( aSX3, { ;
	{ 'SB4'																	, .F. }, ; //X3_ARQUIVO
	{ '99'																	, .F. }, ; //X3_ORDEM
	{ 'B4_XGRAPRO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Gr. Apro.Com'														, .F. }, ; //X3_TITULO
	{ 'Gr. Apro.Com'														, .F. }, ; //X3_TITSPA
	{ 'Gr. Apro.Com'														, .F. }, ; //X3_TITENG
	{ 'Gr. Aprovação de Compras'											, .F. }, ; //X3_DESCRIC
	{ 'Gr. Aprovação de Compras'											, .F. }, ; //X3_DESCSPA
	{ 'Gr. Aprovação de Compras'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"000002"'															, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SBM
//
aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '28'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XGRAPRO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Gr.Aprov Com'														, .F. }, ; //X3_TITULO
	{ 'Gr.Aprov Com'														, .F. }, ; //X3_TITSPA
	{ 'Gr.Aprov Com'														, .F. }, ; //X3_TITENG
	{ 'Gr. Aprov de Compras.'												, .F. }, ; //X3_DESCRIC
	{ 'Gr. Aprov de Compras.'												, .F. }, ; //X3_DESCSPA
	{ 'Gr. Aprov de Compras.'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC1
//
aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XCCDESC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descricao CC'														, .F. }, ; //X3_TITULO
	{ 'Descricao CC'														, .F. }, ; //X3_TITSPA
	{ 'Descricao CC'														, .F. }, ; //X3_TITENG
	{ 'Descricao Centro de Custo'											, .F. }, ; //X3_DESCRIC
	{ 'Descricao Centro de Custo'											, .F. }, ; //X3_DESCSPA
	{ 'Descricao Centro de Custo'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC5
//
aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'E8'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XCODOBS'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Codigo OBS'															, .F. }, ; //X3_TITULO
	{ 'Codigo OBS'															, .F. }, ; //X3_TITSPA
	{ 'Codigo OBS'															, .F. }, ; //X3_TITENG
	{ 'Codigo OBS'															, .F. }, ; //X3_DESCRIC
	{ 'Codigo OBS'															, .F. }, ; //X3_DESCSPA
	{ 'Codigo OBS'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'E9'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XOBS'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 35																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacao'															, .F. }, ; //X3_TITULO
	{ 'Observacao'															, .F. }, ; //X3_TITSPA
	{ 'Observacao'															, .F. }, ; //X3_TITENG
	{ 'Observacao'															, .F. }, ; //X3_DESCRIC
	{ 'Observacao'															, .F. }, ; //X3_DESCSPA
	{ 'Observacao'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(!INCLUI,MSMM(SC5->C5_XCODOBS,43),"")'							, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F0'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XMENROM'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mensagem.Rom'														, .F. }, ; //X3_TITULO
	{ 'Mensagem.Rom'														, .F. }, ; //X3_TITSPA
	{ 'Mensagem.Rom'														, .F. }, ; //X3_TITENG
	{ 'Mensagem Romaneio'													, .F. }, ; //X3_DESCRIC
	{ 'Mensagem Romaneio'													, .F. }, ; //X3_DESCSPA
	{ 'Mensagem Romaneio'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F3'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XLIBER'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Status Bloq.'														, .F. }, ; //X3_TITULO
	{ 'Status Bloq.'														, .F. }, ; //X3_TITSPA
	{ 'Status Bloq.'														, .F. }, ; //X3_TITENG
	{ 'Status Bloqueio Desconto'											, .F. }, ; //X3_DESCRIC
	{ 'Status Bloqueio Desconto'											, .F. }, ; //X3_DESCSPA
	{ 'Status Bloqueio Desconto'											, .F. }, ; //X3_DESCENG
	{ '!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ 'L=Liberado;B=Bloqueado'												, .F. }, ; //X3_CBOX
	{ 'L=Liberado;B=Bloqueado'												, .F. }, ; //X3_CBOXSPA
	{ 'L=Liberado;B=Bloqueado'												, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F4'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XLIBDH'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt Hr Liber.'														, .F. }, ; //X3_TITULO
	{ 'Dt Hr Liber.'														, .F. }, ; //X3_TITSPA
	{ 'Dt Hr Liber.'														, .F. }, ; //X3_TITENG
	{ 'Dt Hr Liberacao'														, .F. }, ; //X3_DESCRIC
	{ 'Dt Hr Liberacao'														, .F. }, ; //X3_DESCSPA
	{ 'Dt Hr Liberacao'														, .F. }, ; //X3_DESCENG
	{ '@X'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F5'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XLIBUSR'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'User Aprov.'															, .F. }, ; //X3_TITULO
	{ 'User Aprov.'															, .F. }, ; //X3_TITSPA
	{ 'User Aprov.'															, .F. }, ; //X3_TITENG
	{ 'User Aprovador'														, .F. }, ; //X3_DESCRIC
	{ 'User Aprovador'														, .F. }, ; //X3_DESCSPA
	{ 'User Aprovador'														, .F. }, ; //X3_DESCENG
	{ '@X'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F6'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XLIBOBS'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Obs Aprovadr'														, .F. }, ; //X3_TITULO
	{ 'Obs Aprovadr'														, .F. }, ; //X3_TITSPA
	{ 'Obs Aprovadr'														, .F. }, ; //X3_TITENG
	{ 'Obs do Aprovador'													, .F. }, ; //X3_DESCRIC
	{ 'Obs do Aprovador'													, .F. }, ; //X3_DESCSPA
	{ 'Obs do Aprovador'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'F8'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XDESCFI'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc Filial'															, .F. }, ; //X3_TITULO
	{ 'Desc Filial'															, .F. }, ; //X3_TITSPA
	{ 'Desc Filial'															, .F. }, ; //X3_TITENG
	{ 'Descr Filial origem'													, .F. }, ; //X3_DESCRIC
	{ 'Descr Filial origem'													, .F. }, ; //X3_DESCSPA
	{ 'Descr Filial origem'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(INCLUI,FWFILIALNAME(CEMPANT,CFILANT,1),)'						, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'H2'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XCONPED'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Ped.Confere?'														, .F. }, ; //X3_TITULO
	{ 'Ped.Confere?'														, .F. }, ; //X3_TITSPA
	{ 'Ped.Confere?'														, .F. }, ; //X3_TITENG
	{ 'Informa se o pedido foi c'											, .F. }, ; //X3_DESCRIC
	{ 'Informa se o pedido foi c'											, .F. }, ; //X3_DESCSPA
	{ 'Informa se o pedido foi c'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOX
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXSPA
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'H3'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XCONDMA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Pagto Maior'															, .F. }, ; //X3_TITULO
	{ 'Pagto Maior'															, .F. }, ; //X3_TITSPA
	{ 'Pagto Maior'															, .F. }, ; //X3_TITENG
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCRIC
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCSPA
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC6
//
aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XCODNET'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod.Net.Gera'														, .F. }, ; //X3_TITULO
	{ 'Cod.Net.Gera'														, .F. }, ; //X3_TITSPA
	{ 'Cod.Net.Gera'														, .F. }, ; //X3_TITENG
	{ 'Cod Prod Net Gera'													, .F. }, ; //X3_DESCRIC
	{ 'Cod Prod Net Gera'													, .F. }, ; //X3_DESCSPA
	{ 'Cod Prod Net Gera'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'NETGER'																, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ '05'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XDESCR'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descricao'															, .F. }, ; //X3_TITULO
	{ 'Descricao'															, .F. }, ; //X3_TITSPA
	{ 'Descricao'															, .F. }, ; //X3_TITENG
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCRIC
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCSPA
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'J6'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XQTD'																, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Qtde.Con.Med'														, .F. }, ; //X3_TITULO
	{ 'Qtde.Con.Med'														, .F. }, ; //X3_TITSPA
	{ 'Qtde.Con.Med'														, .F. }, ; //X3_TITENG
	{ 'Quantidade de Consumo Med'											, .F. }, ; //X3_DESCRIC
	{ 'Quantidade de Consumo Med'											, .F. }, ; //X3_DESCSPA
	{ 'Quantidade de Consumo Med'											, .F. }, ; //X3_DESCENG
	{ '@E 999,999.99'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'K5'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XNUMSC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Numero SC'															, .F. }, ; //X3_TITULO
	{ 'Numero SC'															, .F. }, ; //X3_TITSPA
	{ 'PR number'															, .F. }, ; //X3_TITENG
	{ 'Num. da SC gerada por PV'											, .F. }, ; //X3_DESCRIC
	{ 'Nº de SC generada por PV'											, .F. }, ; //X3_DESCSPA
	{ 'PR  nbr. generated by SO'											, .F. }, ; //X3_DESCENG
	{ '@x'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(148) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'K6'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XITEMSC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Item SC K'															, .F. }, ; //X3_TITULO
	{ 'Item SC K'															, .F. }, ; //X3_TITSPA
	{ 'PR Item K'															, .F. }, ; //X3_TITENG
	{ 'Item da SC gerada por PV'											, .F. }, ; //X3_DESCRIC
	{ 'Item de SC gener. por PV'											, .F. }, ; //X3_DESCSPA
	{ 'PR item generated by SO'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(148) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'K7'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFID'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Id WorkFlow'															, .F. }, ; //X3_TITULO
	{ 'Id WorkFlow'															, .F. }, ; //X3_TITSPA
	{ 'Id WorkFlow'															, .F. }, ; //X3_TITENG
	{ 'Id WorkFlow'															, .F. }, ; //X3_DESCRIC
	{ 'Id WorkFlow'															, .F. }, ; //X3_DESCSPA
	{ 'Id WorkFlow'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'K8'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFAPRO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Aprovador WF'														, .F. }, ; //X3_TITULO
	{ 'Aprovador WF'														, .F. }, ; //X3_TITSPA
	{ 'Aprovador WF'														, .F. }, ; //X3_TITENG
	{ 'Aprovador WF'														, .F. }, ; //X3_DESCRIC
	{ 'Aprovador WF'														, .F. }, ; //X3_DESCSPA
	{ 'Aprovador WF'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'K9'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFDTEN'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt Envio WF'															, .F. }, ; //X3_TITULO
	{ 'Dt Envio WF'															, .F. }, ; //X3_TITSPA
	{ 'Dt Envio WF'															, .F. }, ; //X3_TITENG
	{ 'Dt Envio WF'															, .F. }, ; //X3_DESCRIC
	{ 'Dt Envio WF'															, .F. }, ; //X3_DESCSPA
	{ 'Dt Envio WF'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'L0'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFDTRE'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt Retorn WF'														, .F. }, ; //X3_TITULO
	{ 'Dt Retorn WF'														, .F. }, ; //X3_TITSPA
	{ 'Dt Retorn WF'														, .F. }, ; //X3_TITENG
	{ 'Dt Retorn WF'														, .F. }, ; //X3_DESCRIC
	{ 'Dt Retorn WF'														, .F. }, ; //X3_DESCSPA
	{ 'Dt Retorn WF'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'L1'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFSTAT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'WF Status'															, .F. }, ; //X3_TITULO
	{ 'WF Status'															, .F. }, ; //X3_TITSPA
	{ 'WF Status'															, .F. }, ; //X3_TITENG
	{ 'WF Status'															, .F. }, ; //X3_DESCRIC
	{ 'WF Status'															, .F. }, ; //X3_DESCSPA
	{ 'WF Status'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"0"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '0=Nao Enviado;1=Enviado;2=Aprovado;3=Reprovado'						, .F. }, ; //X3_CBOX
	{ '0=Nao Enviado;1=Enviado;2=Aprovado;3=Reprovado'						, .F. }, ; //X3_CBOXSPA
	{ '0=Nao Enviado;1=Enviado;2=Aprovado;3=Reprovado'						, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'L2'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XWFOBS'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 200																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Obs WF'																, .F. }, ; //X3_TITULO
	{ 'Obs WF'																, .F. }, ; //X3_TITSPA
	{ 'Obs WF'																, .F. }, ; //X3_TITENG
	{ 'Obs WF'																, .F. }, ; //X3_DESCRIC
	{ 'Obs WF'																, .F. }, ; //X3_DESCSPA
	{ 'Obs WF'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'L3'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XLIBDES'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_TITULO
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_TITSPA
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_TITENG
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_DESCRIC
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_DESCSPA
	{ 'Dt Lib. Desc'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'L4'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XDESMAX'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITULO
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITSPA
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITENG
	{ 'Desc. Maximo'														, .F. }, ; //X3_DESCRIC
	{ 'Desc. Maximo'														, .F. }, ; //X3_DESCSPA
	{ 'Desc. Maximo'														, .F. }, ; //X3_DESCENG
	{ '@E 99.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC7
//
aAdd( aSX3, { ;
	{ 'SC7'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'C7_XCODNET'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITULO
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITSPA
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITENG
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCRIC
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCSPA
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'NETGER'																, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC7'																	, .F. }, ; //X3_ARQUIVO
	{ 'M2'																	, .F. }, ; //X3_ORDEM
	{ 'C7_XNOMFOR'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fornecedor'															, .F. }, ; //X3_TITULO
	{ 'Fornecedor'															, .F. }, ; //X3_TITSPA
	{ 'Fornecedor'															, .F. }, ; //X3_TITENG
	{ 'Fornecedor'															, .F. }, ; //X3_DESCRIC
	{ 'Fornecedor'															, .F. }, ; //X3_DESCSPA
	{ 'Fornecedor'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE,"A2_NOME")'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_NOME")'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD1
//
aAdd( aSX3, { ;
	{ 'SD1'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'D1_XDESCRI'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descrição'															, .F. }, ; //X3_TITULO
	{ 'Descricao'															, .F. }, ; //X3_TITSPA
	{ 'Descricao'															, .F. }, ; //X3_TITENG
	{ 'Descrição do Produto'												, .F. }, ; //X3_DESCRIC
	{ 'Descrição do Produto'												, .F. }, ; //X3_DESCSPA
	{ 'Descrição do Produto'												, .F. }, ; //X3_DESCENG
	{ '@S30!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD2
//
aAdd( aSX3, { ;
	{ 'SD2'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'D2_XDESCRI'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descrição'															, .F. }, ; //X3_TITULO
	{ 'Descrição'															, .F. }, ; //X3_TITSPA
	{ 'Descrição'															, .F. }, ; //X3_TITENG
	{ 'Descrição do produto'												, .F. }, ; //X3_DESCRIC
	{ 'Descrição do Produto'												, .F. }, ; //X3_DESCSPA
	{ 'Descrição do Produto'												, .F. }, ; //X3_DESCENG
	{ '@S30!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD6
//
aAdd( aSX3, { ;
	{ 'SD6'																	, .F. }, ; //X3_ARQUIVO
	{ '69'																	, .F. }, ; //X3_ORDEM
	{ 'D6_X_ANTEC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Antecip Imp.'														, .F. }, ; //X3_TITULO
	{ 'Anticip Imp.'														, .F. }, ; //X3_TITSPA
	{ 'Adv Taxes'															, .F. }, ; //X3_TITENG
	{ 'Antecipa Impostos'													, .F. }, ; //X3_DESCRIC
	{ 'Anticipa impuestos'													, .F. }, ; //X3_DESCSPA
	{ 'Advances Tax'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ "'1'"																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ "Pertence('12')"														, .F. }, ; //X3_VLDUSER
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOX
	{ '1=SI;2=NO'															, .F. }, ; //X3_CBOXSPA
	{ '1=YES;2=NO'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SD6'																	, .F. }, ; //X3_ARQUIVO
	{ '72'																	, .F. }, ; //X3_ORDEM
	{ 'D6_X_IMPX'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Imposto X'															, .F. }, ; //X3_TITULO
	{ 'Impuesto X'															, .F. }, ; //X3_TITSPA
	{ 'Tax X'																, .F. }, ; //X3_TITENG
	{ 'Imposto X'															, .F. }, ; //X3_DESCRIC
	{ 'Impuesto X'															, .F. }, ; //X3_DESCSPA
	{ 'Tax X'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SDT
//
aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '10'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLICST'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'ICMS ST XML'															, .F. }, ; //X3_TITULO
	{ 'ICMS ST XML'															, .F. }, ; //X3_TITSPA
	{ 'XML ST ICMS'															, .F. }, ; //X3_TITENG
	{ 'Valor do ICMS do XML'												, .F. }, ; //X3_DESCRIC
	{ 'Valor del ICMS del XML'												, .F. }, ; //X3_DESCSPA
	{ 'Value of XML ICMS'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '36'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLIPI'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. IPI XML'														, .F. }, ; //X3_TITULO
	{ 'Val. IPI XML'														, .F. }, ; //X3_TITSPA
	{ 'XML IPI Vl.'															, .F. }, ; //X3_TITENG
	{ 'IPI importado do XML'												, .F. }, ; //X3_DESCRIC
	{ 'IPI importado del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML imported IPI'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '37'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLICM'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. ICMS XM'														, .F. }, ; //X3_TITULO
	{ 'Val. ICMS XM'														, .F. }, ; //X3_TITSPA
	{ 'XML ICMS Vl.'														, .F. }, ; //X3_TITENG
	{ 'ICMS importado do XML'												, .F. }, ; //X3_DESCRIC
	{ 'ICMS importado del XML'												, .F. }, ; //X3_DESCSPA
	{ 'ICMS imported COFINS'												, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '38'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLISS'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. ISS XML'														, .F. }, ; //X3_TITULO
	{ 'Val. ISS XML'														, .F. }, ; //X3_TITSPA
	{ 'XML ISS Vl.'															, .F. }, ; //X3_TITENG
	{ 'ISS importado do XML'												, .F. }, ; //X3_DESCRIC
	{ 'ISS importado del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML imported ISS'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLPIS'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. PIS XML'														, .F. }, ; //X3_TITULO
	{ 'Val. PIS XML'														, .F. }, ; //X3_TITSPA
	{ 'XML PIS Vl.'															, .F. }, ; //X3_TITENG
	{ 'PIS importado do XML'												, .F. }, ; //X3_DESCRIC
	{ 'PIS importado del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML imported PIS'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '40'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XMLCOF'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. COF XML'														, .F. }, ; //X3_TITULO
	{ 'Val. COF XML'														, .F. }, ; //X3_TITSPA
	{ 'XML COF Vl.'															, .F. }, ; //X3_TITENG
	{ 'COFINS importado do XML'												, .F. }, ; //X3_DESCRIC
	{ 'COFINS importado del XML'											, .F. }, ; //X3_DESCSPA
	{ 'XML imported COFINS'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '46'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALQIPI'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Alq. IPI XML'														, .F. }, ; //X3_TITULO
	{ 'Ali. IPI XML'														, .F. }, ; //X3_TITSPA
	{ 'XML IPI Alq.'														, .F. }, ; //X3_TITENG
	{ 'Aliquota IPI do XML'													, .F. }, ; //X3_DESCRIC
	{ 'Alicuota IPI del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML IPI Aliquot'														, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '47'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALQICM'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Alq. ICM XML'														, .F. }, ; //X3_TITULO
	{ 'Ali. ICM XML'														, .F. }, ; //X3_TITSPA
	{ 'XML ICM Alq.'														, .F. }, ; //X3_TITENG
	{ 'Aliquota ICMS do XML'												, .F. }, ; //X3_DESCRIC
	{ 'Alicuota ICMS del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML ICMS Aliquot'													, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '48'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALQISS'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Alq. ISS XML'														, .F. }, ; //X3_TITULO
	{ 'Ali. ISS XML'														, .F. }, ; //X3_TITSPA
	{ 'XML ISS Alq.'														, .F. }, ; //X3_TITENG
	{ 'Aliquota ISS do XML'													, .F. }, ; //X3_DESCRIC
	{ 'Alicuota ISS del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML ISS Aliquot'														, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '49'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALQPIS'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Alq. PIS XML'														, .F. }, ; //X3_TITULO
	{ 'Ali. PIS XML'														, .F. }, ; //X3_TITSPA
	{ 'XML PIS Alq.'														, .F. }, ; //X3_TITENG
	{ 'Aliquota PIS do XML'													, .F. }, ; //X3_DESCRIC
	{ 'Alicuota PIS del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML PIS Aliquot'														, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '50'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALQCOF'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Alq. COF XML'														, .F. }, ; //X3_TITULO
	{ 'Ali. COF XML'														, .F. }, ; //X3_TITSPA
	{ 'XML COF Alq.'														, .F. }, ; //X3_TITENG
	{ 'Aliquota COFINS do XML'												, .F. }, ; //X3_DESCRIC
	{ 'Alicuota COFINS del XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML COFINS Aliquot'													, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SDT'																	, .F. }, ; //X3_ARQUIVO
	{ '60'																	, .F. }, ; //X3_ORDEM
	{ 'DT_XALICST'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Al. IC ST XM'														, .F. }, ; //X3_TITULO
	{ 'Al. IC ST XM'														, .F. }, ; //X3_TITSPA
	{ 'IC ST XML Rt'														, .F. }, ; //X3_TITENG
	{ 'Aliquota do ICMS do XML'												, .F. }, ; //X3_DESCRIC
	{ 'Alícuota del ICMS del XML'											, .F. }, ; //X3_DESCSPA
	{ 'ICMS rate of XML'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE1
//
aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ 'R9'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XDESCFI'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Filial'															, .F. }, ; //X3_TITULO
	{ 'Desc.Filial'															, .F. }, ; //X3_TITSPA
	{ 'Desc.Filial'															, .F. }, ; //X3_TITENG
	{ 'Descricao da Filial Orige'											, .F. }, ; //X3_DESCRIC
	{ 'Descricao da Filial Orige'											, .F. }, ; //X3_DESCSPA
	{ 'Descricao da Filial Orige'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(INCLUI,FWFILIALNAME(cEmpAnt,cFilAnt,1),)'						, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE2
//
aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N7'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCODRET'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod.Receita'															, .F. }, ; //X3_TITULO
	{ 'Cod.Receita'															, .F. }, ; //X3_TITSPA
	{ 'Cod.Receita'															, .F. }, ; //X3_TITENG
	{ 'Codigo da Receita'													, .F. }, ; //X3_DESCRIC
	{ 'Codigo da Receita'													, .F. }, ; //X3_DESCSPA
	{ 'Codigo da Receita'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N8'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDTREF'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'DT.Ref.Trib'															, .F. }, ; //X3_TITULO
	{ 'DT.Ref.Trib'															, .F. }, ; //X3_TITSPA
	{ 'DT.Ref.Trib'															, .F. }, ; //X3_TITENG
	{ 'Data Referencia Tributo'												, .F. }, ; //X3_DESCRIC
	{ 'Data Referencia Tributo'												, .F. }, ; //X3_DESCSPA
	{ 'Data Referencia Tributo'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N9'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XVLROUT'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 16																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr.Out.Ent.'														, .F. }, ; //X3_TITULO
	{ 'Vlr.Out.Ent.'														, .F. }, ; //X3_TITSPA
	{ 'Vlr.Out.Ent.'														, .F. }, ; //X3_TITENG
	{ 'Valor Outra Entidades'												, .F. }, ; //X3_DESCRIC
	{ 'Valor Outra Entidades'												, .F. }, ; //X3_DESCSPA
	{ 'Valor Outra Entidades'												, .F. }, ; //X3_DESCENG
	{ '@E 9,999,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'O0'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XNUMREF'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Num.Ref.'															, .F. }, ; //X3_TITULO
	{ 'Num.Ref.'															, .F. }, ; //X3_TITSPA
	{ 'Num.Ref.'															, .F. }, ; //X3_TITENG
	{ 'Numero de Referencia Trib'											, .F. }, ; //X3_DESCRIC
	{ 'Numero de Referencia Trib'											, .F. }, ; //X3_DESCSPA
	{ 'Numero de Referencia Trib'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'O1'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XMULTA'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 16																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Multa Cnab'															, .F. }, ; //X3_TITULO
	{ 'Multa Cnab'															, .F. }, ; //X3_TITSPA
	{ 'Multa Cnab'															, .F. }, ; //X3_TITENG
	{ 'Valor da Multa Tributo'												, .F. }, ; //X3_DESCRIC
	{ 'Valor da Multa Tributo'												, .F. }, ; //X3_DESCSPA
	{ 'Valor da Multa Tributo'												, .F. }, ; //X3_DESCENG
	{ '@E 9,999,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'O2'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XJUROS'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 16																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr.Juros'															, .F. }, ; //X3_TITULO
	{ 'Vlr.Juros'															, .F. }, ; //X3_TITSPA
	{ 'Vlr.Juros'															, .F. }, ; //X3_TITENG
	{ 'Valor Juros Tributos'												, .F. }, ; //X3_DESCRIC
	{ 'Valor Juros Tributos'												, .F. }, ; //X3_DESCSPA
	{ 'Valor Juros Tributos'												, .F. }, ; //X3_DESCENG
	{ '@E 9,999,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'O6'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDESCFI'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Filial'															, .F. }, ; //X3_TITULO
	{ 'Desc.Filial'															, .F. }, ; //X3_TITSPA
	{ 'Desc.Filial'															, .F. }, ; //X3_TITENG
	{ 'Desc.Filial de Origem'												, .F. }, ; //X3_DESCRIC
	{ 'Desc.Filial de Origem'												, .F. }, ; //X3_DESCSPA
	{ 'Desc.Filial de Origem'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(INCLUI,FWFILIALNAME(cEmpAnt,cFilAnt,1),)'						, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'P2'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XTPPAG'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tp.Titulo PG'														, .F. }, ; //X3_TITULO
	{ 'Tp.Titulo PG'														, .F. }, ; //X3_TITSPA
	{ 'Tp.Titulo PG'														, .F. }, ; //X3_TITENG
	{ 'Tipo de Titulo Pagamento'											, .F. }, ; //X3_DESCRIC
	{ 'Tipo de Titulo Pagamento'											, .F. }, ; //X3_DESCSPA
	{ 'Tipo de Titulo Pagamento'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SX558'																, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'P3'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDESCCC'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.CC'																, .F. }, ; //X3_TITULO
	{ 'Desc.CC'																, .F. }, ; //X3_TITSPA
	{ 'Desc.CC'																, .F. }, ; //X3_TITENG
	{ 'Descricao do Centro de Cu'											, .F. }, ; //X3_DESCRIC
	{ 'Descricao do Centro de Cu'											, .F. }, ; //X3_DESCSPA
	{ 'Descricao do Centro de Cu'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE5
//
aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ 'A5'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XTITULO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Titulo Cons.'														, .F. }, ; //X3_TITULO
	{ 'Titulo Cons.'														, .F. }, ; //X3_TITSPA
	{ 'Titulo Cons.'														, .F. }, ; //X3_TITENG
	{ 'Titulo Cons.'														, .F. }, ; //X3_DESCRIC
	{ 'Titulo Cons.'														, .F. }, ; //X3_DESCSPA
	{ 'Titulo Cons.'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'SE5->E5_NUMERO'														, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SEF
//
aAdd( aSX3, { ;
	{ 'SEF'																	, .F. }, ; //X3_ARQUIVO
	{ '58'																	, .F. }, ; //X3_ORDEM
	{ 'EF_XDESCNA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 150																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Naturez'														, .F. }, ; //X3_TITULO
	{ 'Desc.Naturez'														, .F. }, ; //X3_TITSPA
	{ 'Desc.Naturez'														, .F. }, ; //X3_TITENG
	{ 'Descricao da Natureza'												, .F. }, ; //X3_DESCRIC
	{ 'Descricao da Natureza'												, .F. }, ; //X3_DESCSPA
	{ 'Descricao da Natureza'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SF1
//
aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ 'I5'																	, .F. }, ; //X3_ORDEM
	{ 'F1_XCARGA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Carga'																, .F. }, ; //X3_TITULO
	{ 'Carga'																, .F. }, ; //X3_TITSPA
	{ 'Carga'																, .F. }, ; //X3_TITENG
	{ 'Carga'																, .F. }, ; //X3_DESCRIC
	{ 'Carga'																, .F. }, ; //X3_DESCSPA
	{ 'Carga'																, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SF6
//
aAdd( aSX3, { ;
	{ 'SF6'																	, .F. }, ; //X3_ARQUIVO
	{ '52'																	, .F. }, ; //X3_ORDEM
	{ 'F6_XMLENV'															, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'XML'																	, .F. }, ; //X3_TITULO
	{ 'XML'																	, .F. }, ; //X3_TITSPA
	{ 'XML'																	, .F. }, ; //X3_TITENG
	{ 'XML'																	, .F. }, ; //X3_DESCRIC
	{ 'XML'																	, .F. }, ; //X3_DESCSPA
	{ 'XML'																	, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SL4
//
aAdd( aSX3, { ;
	{ 'SL4'																	, .F. }, ; //X3_ARQUIVO
	{ '53'																	, .F. }, ; //X3_ORDEM
	{ 'L4_XFORFAT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Linha Produt'														, .F. }, ; //X3_TITULO
	{ 'Linha Produt'														, .F. }, ; //X3_TITSPA
	{ 'Linha Produt'														, .F. }, ; //X3_TITENG
	{ 'Linha Produto'														, .F. }, ; //X3_DESCRIC
	{ 'Linha Produto'														, .F. }, ; //X3_DESCSPA
	{ 'Linha Produto'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Praia e Campo;2=Urbano'											, .F. }, ; //X3_CBOX
	{ '1=Praia e Campo;2=Urbano'											, .F. }, ; //X3_CBOXSPA
	{ '1=Praia e Campo;2=Urbano'											, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SOF
//
aAdd( aSX3, { ;
	{ 'SOF'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'OF_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conteúdo'															, .F. }, ; //X3_TITULO
	{ 'Contenido'															, .F. }, ; //X3_TITSPA
	{ 'Content'																, .F. }, ; //X3_TITENG
	{ 'Conteúdo XML'														, .F. }, ; //X3_DESCRIC
	{ 'Contenido XML'														, .F. }, ; //X3_DESCSPA
	{ 'XML Content'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SOG
//
aAdd( aSX3, { ;
	{ 'SOG'																	, .F. }, ; //X3_ARQUIVO
	{ '17'																	, .F. }, ; //X3_ORDEM
	{ 'OG_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 999																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conteúdo'															, .F. }, ; //X3_TITULO
	{ 'Contenido'															, .F. }, ; //X3_TITSPA
	{ 'Content'																, .F. }, ; //X3_TITENG
	{ 'Conteúdo XML'														, .F. }, ; //X3_DESCRIC
	{ 'Contenido XML'														, .F. }, ; //X3_DESCSPA
	{ 'Content XML'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SQH
//
aAdd( aSX3, { ;
	{ 'SQH'																	, .F. }, ; //X3_ARQUIVO
	{ '02'																	, .F. }, ; //X3_ORDEM
	{ 'QH_XML'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Campo - XML'															, .F. }, ; //X3_TITULO
	{ 'Campo - XML'															, .F. }, ; //X3_TITSPA
	{ 'Field - XML'															, .F. }, ; //X3_TITENG
	{ 'Campo do Arquivo XML'												, .F. }, ; //X3_DESCRIC
	{ 'Campo de Archivo XML'												, .F. }, ; //X3_DESCSPA
	{ 'XML File Field'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(129) + Chr(128) + Chr(130) + Chr(132) + Chr(128) + ;
	Chr(132) + Chr(128) + Chr(128) + Chr(132) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(160) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(146) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SU5
//
aAdd( aSX3, { ;
	{ 'SU5'																	, .F. }, ; //X3_ARQUIVO
	{ '75'																	, .F. }, ; //X3_ORDEM
	{ 'U5_XORIGEM'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Origem Info'															, .F. }, ; //X3_TITULO
	{ 'Origem Info'															, .F. }, ; //X3_TITSPA
	{ 'Origem Info'															, .F. }, ; //X3_TITENG
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCRIC
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCSPA
	{ 'Origem do Cadastro do Cli'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SU5'																	, .F. }, ; //X3_ARQUIVO
	{ '76'																	, .F. }, ; //X3_ORDEM
	{ 'U5_XDTIMP'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt.Importa'															, .F. }, ; //X3_TITULO
	{ 'Dt.Importa'															, .F. }, ; //X3_TITSPA
	{ 'Dt.Importa'															, .F. }, ; //X3_TITENG
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCRIC
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCSPA
	{ 'Dt.Importacao do Cliente'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SU7
//
aAdd( aSX3, { ;
	{ 'SU7'																	, .F. }, ; //X3_ARQUIVO
	{ '36'																	, .F. }, ; //X3_ORDEM
	{ 'U7_XAUSENT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Ausente S/N?'														, .F. }, ; //X3_TITULO
	{ 'Ausente S/N?'														, .F. }, ; //X3_TITSPA
	{ 'Ausente S/N?'														, .F. }, ; //X3_TITENG
	{ 'Ausente S/N?'														, .F. }, ; //X3_DESCRIC
	{ 'Ausente S/N?'														, .F. }, ; //X3_DESCSPA
	{ 'Ausente S/N?'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("12")'														, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '2'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SU7'																	, .F. }, ; //X3_ARQUIVO
	{ '37'																	, .F. }, ; //X3_ORDEM
	{ 'U7_XOPESUB'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Oper.Substit'														, .F. }, ; //X3_TITULO
	{ 'Oper.Substit'														, .F. }, ; //X3_TITSPA
	{ 'Oper.Substit'														, .F. }, ; //X3_TITENG
	{ 'Operador Substituto'													, .F. }, ; //X3_DESCRIC
	{ 'Operador Substituto'													, .F. }, ; //X3_DESCSPA
	{ 'Operador Substituto'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'US1'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUA
//
aAdd( aSX3, { ;
	{ 'SUA'																	, .F. }, ; //X3_ARQUIVO
	{ 'B3'																	, .F. }, ; //X3_ORDEM
	{ 'UA_XCONDMA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Pagto Maior'															, .F. }, ; //X3_TITULO
	{ 'Pagto Maior'															, .F. }, ; //X3_TITSPA
	{ 'Pagto Maior'															, .F. }, ; //X3_TITENG
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCRIC
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCSPA
	{ 'Condicao Pagamento Maior'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUB
//
aAdd( aSX3, { ;
	{ 'SUB'																	, .F. }, ; //X3_ARQUIVO
	{ '23'																	, .F. }, ; //X3_ORDEM
	{ 'UB_XFORFAT'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Linha'																, .F. }, ; //X3_TITULO
	{ 'Linha'																, .F. }, ; //X3_TITSPA
	{ 'Linha'																, .F. }, ; //X3_TITENG
	{ 'Linha'																, .F. }, ; //X3_DESCRIC
	{ 'Linha'																, .F. }, ; //X3_DESCSPA
	{ 'Linha'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("1")'														, .F. }, ; //X3_VLDUSER
	{ '1=Normal'															, .F. }, ; //X3_CBOX
	{ '1=Normal'															, .F. }, ; //X3_CBOXSPA
	{ '1=Normal'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUB'																	, .F. }, ; //X3_ARQUIVO
	{ '43'																	, .F. }, ; //X3_ORDEM
	{ 'UB_XFILPED'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Loja Pedido'															, .F. }, ; //X3_TITULO
	{ 'Loja Pedido'															, .F. }, ; //X3_TITSPA
	{ 'Loja Pedido'															, .F. }, ; //X3_TITENG
	{ 'Filial do PedVen Gerado'												, .F. }, ; //X3_DESCRIC
	{ 'Filial do PedVen Gerado'												, .F. }, ; //X3_DESCSPA
	{ 'Filial do PedVen Gerado'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUB'																	, .F. }, ; //X3_ARQUIVO
	{ '53'																	, .F. }, ; //X3_ORDEM
	{ 'UB_XLIBDES'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_TITULO
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_TITSPA
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_TITENG
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_DESCRIC
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_DESCSPA
	{ 'Dt. Lib. Des'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUB'																	, .F. }, ; //X3_ARQUIVO
	{ '54'																	, .F. }, ; //X3_ORDEM
	{ 'UB_XDESMAX'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITULO
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITSPA
	{ 'Desc. Maximo'														, .F. }, ; //X3_TITENG
	{ 'Desc. Maximo permitido'												, .F. }, ; //X3_DESCRIC
	{ 'Desc. Maximo permitido'												, .F. }, ; //X3_DESCSPA
	{ 'Desc. Maximo permitido'												, .F. }, ; //X3_DESCENG
	{ '@E 99.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUC
//
aAdd( aSX3, { ;
	{ 'SUC'																	, .F. }, ; //X3_ARQUIVO
	{ '46'																	, .F. }, ; //X3_ORDEM
	{ 'UC_XCODOBS'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod. OBS K'															, .F. }, ; //X3_TITULO
	{ 'Cod. OBS K'															, .F. }, ; //X3_TITSPA
	{ 'Cod. OBS K'															, .F. }, ; //X3_TITENG
	{ 'Cod. OBS KOMFORT'													, .F. }, ; //X3_DESCRIC
	{ 'Cod. OBS KOMFORT'													, .F. }, ; //X3_DESCSPA
	{ 'Cod. OBS KOMFORT'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUC'																	, .F. }, ; //X3_ARQUIVO
	{ '47'																	, .F. }, ; //X3_ORDEM
	{ 'UC_XOBS'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log.Alteraco'														, .F. }, ; //X3_TITULO
	{ 'Log.Alteraco'														, .F. }, ; //X3_TITSPA
	{ 'Log.Alteraco'														, .F. }, ; //X3_TITENG
	{ 'Log.Alteracoes'														, .F. }, ; //X3_DESCRIC
	{ 'Log.Alteracoes'														, .F. }, ; //X3_DESCSPA
	{ 'Log.Alteracoes'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(!INCLUI,MSMM(SUC->UC_XCODOBS,100),"")'							, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUD
//
aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XCODNET'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITULO
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITSPA
	{ 'Cod.NetGera'															, .F. }, ; //X3_TITENG
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCRIC
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCSPA
	{ 'Codigo do Prod. NetGera'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'NETGER'																, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'U_KMSACA05()'														, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '22'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XDEFEI2'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Defeito 2'															, .F. }, ; //X3_TITULO
	{ 'Defeito 2'															, .F. }, ; //X3_TITSPA
	{ 'Defeito 2'															, .F. }, ; //X3_TITENG
	{ 'Defeito 2'															, .F. }, ; //X3_DESCRIC
	{ 'Defeito'																, .F. }, ; //X3_DESCSPA
	{ 'Defeito 2'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SX5Z1'																, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '23'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XDESDE2'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Def. 2'															, .F. }, ; //X3_TITULO
	{ 'Desc.Def. 2'															, .F. }, ; //X3_TITSPA
	{ 'Desc.Def. 2'															, .F. }, ; //X3_TITENG
	{ 'Descrição do defeito 2'												, .F. }, ; //X3_DESCRIC
	{ 'Descrição do defeito 2'												, .F. }, ; //X3_DESCSPA
	{ 'Descrição do defeito 2'												, .F. }, ; //X3_DESCENG
	{ '@S30!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '24'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XDEFEI3'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Defeito 3'															, .F. }, ; //X3_TITULO
	{ 'Defeito 3'															, .F. }, ; //X3_TITSPA
	{ 'Defeito 3'															, .F. }, ; //X3_TITENG
	{ 'Defeito 3'															, .F. }, ; //X3_DESCRIC
	{ 'Defeito 3'															, .F. }, ; //X3_DESCSPA
	{ 'Defeito 3'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SX5Z1'																, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '25'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XDESDE3'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Def.3'															, .F. }, ; //X3_TITULO
	{ 'Desc.Def.3'															, .F. }, ; //X3_TITSPA
	{ 'Desc.Def.3'															, .F. }, ; //X3_TITENG
	{ 'Descrição do defeito 3'												, .F. }, ; //X3_DESCRIC
	{ 'Descrição do defeito 3'												, .F. }, ; //X3_DESCSPA
	{ 'Descrição do defeito 3'												, .F. }, ; //X3_DESCENG
	{ '@S30!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '27'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XIMPLAU'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Imp. Laudo'															, .F. }, ; //X3_TITULO
	{ 'Imp. Laudo'															, .F. }, ; //X3_TITSPA
	{ 'Imp. Laudo'															, .F. }, ; //X3_TITENG
	{ 'Imprime Laudo Tecnico'												, .F. }, ; //X3_DESCRIC
	{ 'Imprime Laudo Tecnico'												, .F. }, ; //X3_DESCSPA
	{ 'Imprime Laudo Tecnico'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOX
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXSPA
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '47'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XUSER'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log.Usuario'															, .F. }, ; //X3_TITULO
	{ 'Log.Usuario'															, .F. }, ; //X3_TITSPA
	{ 'Log.Usuario'															, .F. }, ; //X3_TITENG
	{ 'Usuario Incluiu Linha'												, .F. }, ; //X3_DESCRIC
	{ 'Usuario Incluiu Linha'												, .F. }, ; //X3_DESCSPA
	{ 'Usuario Incluiu Linha'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'CUSERNAME'															, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '48'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XDATA'															, .F. }, ; //X3_CAMPO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log.Data'															, .F. }, ; //X3_TITULO
	{ 'Log.Data'															, .F. }, ; //X3_TITSPA
	{ 'Log.Data'															, .F. }, ; //X3_TITENG
	{ 'Data Inclusao Linha'													, .F. }, ; //X3_DESCRIC
	{ 'Data Inclusao Linha'													, .F. }, ; //X3_DESCSPA
	{ 'Data Inclusao Linha'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'DDATABASE'															, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUD'																	, .F. }, ; //X3_ARQUIVO
	{ '49'																	, .F. }, ; //X3_ORDEM
	{ 'UD_XHORA'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log.Hora'															, .F. }, ; //X3_TITULO
	{ 'Log.Hora'															, .F. }, ; //X3_TITSPA
	{ 'Log.Hora'															, .F. }, ; //X3_TITENG
	{ 'Hora Inclusao Linha'													, .F. }, ; //X3_DESCRIC
	{ 'Hora Inclusao Linha'													, .F. }, ; //X3_DESCSPA
	{ 'Hora Inclusao Linha'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'TIME()'																, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUQ
//
aAdd( aSX3, { ;
	{ 'SUQ'																	, .F. }, ; //X3_ARQUIVO
	{ '28'																	, .F. }, ; //X3_ORDEM
	{ 'UQ_XLIBVND'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Liber.Vendas'														, .F. }, ; //X3_TITULO
	{ 'Liber.Vendas'														, .F. }, ; //X3_TITSPA
	{ 'Liber.Vendas'														, .F. }, ; //X3_TITENG
	{ 'Libera Acao Dpto.Vendas'												, .F. }, ; //X3_DESCRIC
	{ 'Libera Acao Dpto.Vendas'												, .F. }, ; //X3_DESCSPA
	{ 'Libera Acao Dpto.Vendas'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOX
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXSPA
	{ '1=SIM;2=NAO'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SUS
//
aAdd( aSX3, { ;
	{ 'SUS'																	, .F. }, ; //X3_ARQUIVO
	{ 'A5'																	, .F. }, ; //X3_ORDEM
	{ 'US_XMODELO'															, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Modelo'																, .F. }, ; //X3_TITULO
	{ 'Modelo'																, .F. }, ; //X3_TITSPA
	{ 'Modelo'																, .F. }, ; //X3_TITENG
	{ 'Modelo de interesse'													, .F. }, ; //X3_DESCRIC
	{ 'Modelo de interesse'													, .F. }, ; //X3_DESCSPA
	{ 'Modelo de interesse'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUS'																	, .F. }, ; //X3_ARQUIVO
	{ 'A6'																	, .F. }, ; //X3_ORDEM
	{ 'US_XVALOR'															, .F. }, ; //X3_CAMPO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Valor'																, .F. }, ; //X3_TITULO
	{ 'Valor'																, .F. }, ; //X3_TITSPA
	{ 'Valor'																, .F. }, ; //X3_TITENG
	{ 'Valor cotado'														, .F. }, ; //X3_DESCRIC
	{ 'Valor cotado'														, .F. }, ; //X3_DESCSPA
	{ 'Valor cotado'														, .F. }, ; //X3_DESCENG
	{ '@E 9,999,999.99'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SUS'																	, .F. }, ; //X3_ARQUIVO
	{ 'A7'																	, .F. }, ; //X3_ORDEM
	{ 'US_XOBS'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacao'															, .F. }, ; //X3_TITULO
	{ 'Observacao'															, .F. }, ; //X3_TITSPA
	{ 'Observacao'															, .F. }, ; //X3_TITENG
	{ 'Observacao'															, .F. }, ; //X3_DESCRIC
	{ 'Observacao'															, .F. }, ; //X3_DESCSPA
	{ 'Observacao'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela T47
//
aAdd( aSX3, { ;
	{ 'T47'																	, .F. }, ; //X3_ARQUIVO
	{ '09'																	, .F. }, ; //X3_ORDEM
	{ 'T47_XML'																, .F. }, ; //X3_CAMPO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cálc período'														, .F. }, ; //X3_TITULO
	{ 'Cálc Período'														, .F. }, ; //X3_TITSPA
	{ 'Period Calc'															, .F. }, ; //X3_TITENG
	{ 'Cálculo do período'													, .F. }, ; //X3_DESCRIC
	{ 'Cálculo del período'													, .F. }, ; //X3_DESCSPA
	{ 'Period Calculation'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ 'S'																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ '1'																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }, ; //X3_MODAL
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela Z31
//
aAdd( aSX3, { ;
	{ 'Z31'																	, .F. }, ; //X3_ARQUIVO
	{ '13'																	, .F. }, ; //X3_ORDEM
	{ 'Z31_XML'																, .F. }, ; //X3_CAMPO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'ARQ. XML'															, .F. }, ; //X3_TITULO
	{ 'ARQ. XML'															, .F. }, ; //X3_TITSPA
	{ 'ARQ. XML'															, .F. }, ; //X3_TITENG
	{ 'Nome do Arq. XML anexo'												, .F. }, ; //X3_DESCRIC
	{ 'Nome do Arq. XML anexo'												, .F. }, ; //X3_DESCSPA
	{ 'Nome do Arq. XML anexo'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_POSLGT
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }, ; //X3_MODAL
	{ ''																	, .F. }} ) //X3_PYME


//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG][1] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG][1] ) )
			If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
				aSX3[nI][nPosTam][1] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq][1] $ cAlias )
		cAlias += aSX3[nI][nPosArq][1] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq][1]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
					AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
					"   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF )
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			//
			// Se o campo estiver diferente da estrutura
			//
			If aSX3[nI][nJ][2]
				cX3Campo := AllTrim( aEstrut[nJ][1] )
				cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

				If  aEstrut[nJ][2] > 0 .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) .AND. ;
					!cX3Campo == "X3_ORDEM"

					cMsg := "O campo " + aSX3[nI][nPosCpo][1] + " está com o " + cX3Campo + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( cX3Dado ) ) + "]" + CRLF + ;
					"que será substituído pelo NOVO conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSX3[nI][nJ][1] ) ) + "]" + CRLF + ;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX3" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX3 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX3 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						AutoGrLog( "Alterado campo " + aSX3[nI][nPosCpo][1] + CRLF + ;
						"   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" + CRLF + ;
						"            para [" + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF )

						RecLock( "SX3", .F. )
						FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
						MsUnLock()
					EndIf

				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

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
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDSX301" ) ) ) ;
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
