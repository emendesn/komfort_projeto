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
/*/{Protheus.doc} UPDZL2
Fun��o de update de dicion�rios para compatibiliza��o

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDZL2( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZA��O DE DICION�RIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como fun��o fazer  a atualiza��o  dos dicion�rios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n�o podem haver outros"
Local   cDesc3    := "usu�rios  ou  jobs utilizando  o sistema.  � EXTREMAMENTE recomendav�l  que  se  fa�a um"
Local   cDesc4    := "BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para que caso "
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
		If lAuto .OR. MsgNoYes( "Confirma a atualiza��o dos dicion�rios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()
			
			If lAuto
				If lOk
					MsgStop( "Atualiza��o Realizada.", "UPDZL2" )
				Else
					MsgStop( "Atualiza��o n�o Realizada.", "UPDZL2" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualiza��o Conclu�da." )
				Else
					Final( "Atualiza��o n�o Realizada." )
				EndIf
			EndIf
			
		Else
			MsgStop( "Atualiza��o n�o Realizada.", "UPDZL2" )
			
		EndIf
		
	Else
		MsgStop( "Atualiza��o n�o Realizada.", "UPDZL2" )
		
	EndIf
	
EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Fun��o de processamento da grava��o dos arquivos

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
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
		// S� adiciona no aRecnoSM0 se a empresa for diferente
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
				MsgStop( "Atualiza��o da empresa " + aRecnoSM0[nI][2] + " n�o efetuada." )
				Exit
			EndIf
			
			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )
			
			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
			
			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.
			
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZA��O DOS DICION�RIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora �nicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Vers�o.............: " + GetVersao(.T.) )
			AutoGrLog( " Usu�rio TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )
			
			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usu�rio da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Esta��o............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conex�o............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			
			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf
			
			oProcess:SetRegua1( 8 )
			
			//------------------------------------
			// Atualiza o dicion�rio SX3
			//------------------------------------
			FSAtuSX3()
			
			//------------------------------------
			// Atualiza o dicion�rio SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicion�rio de �ndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()
			
			oProcess:IncRegua1( "Dicion�rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/�ndices" )
			
			// Altera��o f�sica dos arquivos
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion�rio e da tabela.", "ATEN��O" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " + aArqUpd[nX] )
				EndIf
				
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf
				
			Next nX
			
			//------------------------------------
			// Atualiza os helps
			//------------------------------------
			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp()
			
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )
			
			RpcClearEnv()
			
		Next nI
		
		If !lAuto
			
			cTexto := LeLog()
			
			Define Font oFont Name "Mono AS" Size 5, 12
			
			Define MsDialog oDlg Title "Atualiza��o concluida." From 3, 0 to 340, 417 Pixel
			
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
Fun��o de processamento da grava��o do SX3 - Campos

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
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

AutoGrLog( "�nicio da Atualiza��o" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
{ "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
{ "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
{ "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
{ "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
{ "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
{ "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela ZL2
//
aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'01'																	, ; //X3_ORDEM
'ZL2_FILIAL'															, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
4																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Filial'																, ; //X3_TITULO
'Sucursal'																, ; //X3_TITSPA
'Branch'																, ; //X3_TITENG
'Filial do Sistema'														, ; //X3_DESCRIC
'Sucursal'																, ; //X3_DESCSPA
'Branch of the System'													, ; //X3_DESCENG
'@!'																	, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
1																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
''																		, ; //X3_VISUAL
''																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
'033'																	, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
''																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
''																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'02'																	, ; //X3_ORDEM
'ZL2_NOTA'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
9																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Nr. Nota'																, ; //X3_TITULO
'Nr. Nota'																, ; //X3_TITSPA
'Nr. Nota'																, ; //X3_TITENG
'Numero da Nota'														, ; //X3_DESCRIC
'Numero da Nota'														, ; //X3_DESCSPA
'Numero da Nota'														, ; //X3_DESCENG
'@!'																	, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'03'																	, ; //X3_ORDEM
'ZL2_SERIE'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
4																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Serie'																	, ; //X3_TITULO
'Serie'																	, ; //X3_TITSPA
'Serie'																	, ; //X3_TITENG
'Serie da Nota Fiscal'													, ; //X3_DESCRIC
'Serie da Nota Fiscal'													, ; //X3_DESCSPA
'Serie da Nota Fiscal'													, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'04'																	, ; //X3_ORDEM
'ZL2_COD'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
15																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Codigo'																, ; //X3_TITULO
'Codigo'																, ; //X3_TITSPA
'Codigo'																, ; //X3_TITENG
'Codigo Produto'														, ; //X3_DESCRIC
'Codigo Produto'														, ; //X3_DESCSPA
'Codigo Produto'														, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'05'																	, ; //X3_ORDEM
'ZL2_ITEMNF'															, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
4																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Item da NF'															, ; //X3_TITULO
'Item da NF'															, ; //X3_TITSPA
'Item da NF'															, ; //X3_TITENG
'Item da NF'															, ; //X3_DESCRIC
'Item da NF'															, ; //X3_DESCSPA
'Item da NF'															, ; //X3_DESCENG
'@!'																	, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'06'																	, ; //X3_ORDEM
'ZL2_ENDER'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
1																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Endere�ado'															, ; //X3_TITULO
'Endere�ado'															, ; //X3_TITSPA
'Endere�ado'															, ; //X3_TITENG
'Endere�ado  ?'															, ; //X3_DESCRIC
'Endere�ado  ?'															, ; //X3_DESCSPA
'Endere�ado  ?'															, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'07'																	, ; //X3_ORDEM
'ZL2_LOCAL'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
2																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Armazem'																, ; //X3_TITULO
'Armazem'																, ; //X3_TITSPA
'Armazem'																, ; //X3_TITENG
'Armazem'																, ; //X3_DESCRIC
'Armazem'																, ; //X3_DESCSPA
'Armazem'																, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'08'																	, ; //X3_ORDEM
'ZL2_LOCALI'															, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
15																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Endereco'																, ; //X3_TITULO
'Endereco'																, ; //X3_TITSPA
'Endereco'																, ; //X3_TITENG
'Endereco'																, ; //X3_DESCRIC
'Endereco'																, ; //X3_DESCSPA
'Endereco'																, ; //X3_DESCENG
'@!'																	, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'09'																	, ; //X3_ORDEM
'ZL2_QUANT'																, ; //X3_CAMPO
'N'																		, ; //X3_TIPO
8																		, ; //X3_TAMANHO
2																		, ; //X3_DECIMAL
'Quantidade'															, ; //X3_TITULO
'Quantidade'															, ; //X3_TITSPA
'Quantidade'															, ; //X3_TITENG
'Quantidade'															, ; //X3_DESCRIC
'Quantidade'															, ; //X3_DESCSPA
'Quantidade'															, ; //X3_DESCENG
'@E 99,999.99'															, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'10'																	, ; //X3_ORDEM
'ZL2_FORNE'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
6																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Fornecedor'															, ; //X3_TITULO
'Fornecedor'															, ; //X3_TITSPA
'Fornecedor'															, ; //X3_TITENG
'Fornecedor'															, ; //X3_DESCRIC
'Fornecedor'															, ; //X3_DESCSPA
'Fornecedor'															, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME

aAdd( aSX3, { ;
'ZL2'																	, ; //X3_ARQUIVO
'11'																	, ; //X3_ORDEM
'ZL2_LOJA'																, ; //X3_CAMPO
'C'																		, ; //X3_TIPO
2																		, ; //X3_TAMANHO
0																		, ; //X3_DECIMAL
'Loja'																	, ; //X3_TITULO
'Loja'																	, ; //X3_TITSPA
'Loja'																	, ; //X3_TITENG
'Loja'																	, ; //X3_DESCRIC
'Loja'																	, ; //X3_DESCSPA
'Loja'																	, ; //X3_DESCENG
''																		, ; //X3_PICTURE
''																		, ; //X3_VALID
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
''																		, ; //X3_RELACAO
''																		, ; //X3_F3
0																		, ; //X3_NIVEL
Chr(254) + Chr(192)														, ; //X3_RESERV
''																		, ; //X3_CHECK
''																		, ; //X3_TRIGGER
'U'																		, ; //X3_PROPRI
'N'																		, ; //X3_BROWSE
'A'																		, ; //X3_VISUAL
'R'																		, ; //X3_CONTEXT
''																		, ; //X3_OBRIGAT
''																		, ; //X3_VLDUSER
''																		, ; //X3_CBOX
''																		, ; //X3_CBOXSPA
''																		, ; //X3_CBOXENG
''																		, ; //X3_PICTVAR
''																		, ; //X3_WHEN
''																		, ; //X3_INIBRW
''																		, ; //X3_GRPSXG
''																		, ; //X3_FOLDER
''																		, ; //X3_CONDSQL
''																		, ; //X3_CHKSQL
''																		, ; //X3_IDXSRV
'N'																		, ; //X3_ORTOGRA
''																		, ; //X3_TELA
''																		, ; //X3_POSLGT
'N'																		, ; //X3_IDXFLD
''																		, ; //X3_AGRUP
''																		, ; //X3_MODAL
''																		} ) //X3_PYME


//
// Atualizando dicion�rio
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )
	
	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo] + " N�O atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf
	
	SX3->( dbSetOrder( 2 ) )
	
	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf
	
	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )
		
		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]
			
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
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )
				
			EndIf
		Next nJ
		
		dbCommit()
		MsUnLock()
		
		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo] )
		
	EndIf
	
	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )
	
Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Fun��o de processamento da grava��o do SIX - Indices

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "�nicio da Atualiza��o" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
"DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela ZL2
//
aAdd( aSIX, { ;
'ZL2'																	, ; //INDICE
'1'																		, ; //ORDEM
'ZL2_FILIAL+ZL2_NOTA+ZL2_SERIE+ZL2_COD+ZL2_ITEMNF+ZL2_LOCAL+ZL2_LOCALI'		, ; //CHAVE
'Filial+Codigo+Item'													, ; //DESCRICAO
'Filial+Codigo+Item'													, ; //DESCSPA
'Filial+Codigo+Item'													, ; //DESCENG
''																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
'ZL2'																	, ; //INDICE
'2'																		, ; //ORDEM
'ZL2_FILIAL+ZL2_NOTA+ZL2_SERIE+ZL2_FORNE+ZL2_LOJA'						, ; //CHAVE
'Nota+Serie+Forn+Loja'													, ; //DESCRICAO
'Nota+Serie+Forn+Loja'													, ; //DESCSPA
'Nota+Serie+Forn+Loja'													, ; //DESCENG
'U'																		, ; //PROPRI
''																		, ; //F3
''																		, ; //NICKNAME
'S'																		} ) //SHOWPESQ

//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )
	
	lAlt    := .F.
	lDelInd := .F.
	
	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "�ndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
			StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do �ndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for altera��o precisa apagar o indice do banco
		EndIf
	EndIf
	
	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()
	
	dbCommit()
	
	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf
	
	oProcess:IncRegua2( "Atualizando �ndices..." )
	
Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Fun��o de processamento da grava��o dos Helps de Campos

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "�nicio da Atualiza��o" + " " + "Helps de Campos" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

//
// Helps Tabela ZL2
//
aHlpPor := {}
aAdd( aHlpPor, 'Codigo Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Item da NF' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_ITEMNF", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_ITEMNF" )

aHlpPor := {}
aAdd( aHlpPor, 'Endere�ado  ?' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_ENDER ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_ENDER" )

aHlpPor := {}
aAdd( aHlpPor, 'Armazem' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_LOCAL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_LOCAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Fornecedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_FORNE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_FORNE" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZL2_LOJA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZL2_LOJA" )

AutoGrLog( CRLF + "Final da Atualiza��o" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Fun��o gen�rica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as sele��es feitas.
Se n�o for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Par�metro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta s� com Empresas
// 3 - Monta s� com Filiais de uma Empresa
//
// Par�metro  aMarcadas
// Vetor com Empresas/Filiais pr� marcadas
//
// Par�metro  cEmpSel
// Empresa que ser� usada para montar sele��o
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

oDlg:cToolTip := "Tela para M�ltiplas Sele��es de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza��o"

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
Message "M�scara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Sele��o" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "m�scara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "m�scara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), oDlg:End()  ) ;
Message "Confirma a sele��o e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplica��o" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Fun��o auxiliar para marcar/desmarcar todos os �tens do ListBox ativo

@param lMarca  Cont�udo para marca .T./.F.
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
Fun��o auxiliar para inverter a sele��o do ListBox ativo

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
Fun��o auxiliar que monta o retorno com as sele��es

@param aRet    Array que ter� o retorno das sele��es (� alterado internamente)
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
Fun��o para marcar/desmarcar usando m�scaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a m�scara (???)
@param lMarDes  Marca a ser atribu�da .T./.F.

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
Fun��o auxiliar para verificar se est�o todos marcados ou n�o

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
Fun��o de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
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
	MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Fun��o de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  15/05/2019
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
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
		cRet += "Tamanho de exibi��o maxima do LOG alcan�ado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf
	
	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
