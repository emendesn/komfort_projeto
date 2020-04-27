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
/*/{Protheus.doc} UPDSIX01
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDSIX01( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPDSIX01" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDSIX01" )
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
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

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
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  12/02/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
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

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela AC8
//
aAdd( aSIX, { ;
	'AC8'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT'				, ; //CHAVE
	'Contato + Entidade + Fil.Entidade + Cod.Entidade'						, ; //DESCRICAO
	'Contacto + Entidad + Suc.Entidad + Cod.Entidad'						, ; //DESCSPA
	'Contact + Entity + Entit.Branch + Entity Code'							, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AC8'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON'				, ; //CHAVE
	'Entidade + Fil.Entidade + Cod.Entidade + Contato'						, ; //DESCRICAO
	'Entidad + Suc.Entidad + Cod.Entidad + Contacto'						, ; //DESCSPA
	'Entity + Entit.Branch + Entity Code + Contact'							, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AC8'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'AC8_FILIAL+AC8_CODENT'													, ; //CHAVE
	'Cod.Entidade'															, ; //DESCRICAO
	'Cod.Entidad'															, ; //DESCSPA
	'Entity Code'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'AC8SA1'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela AX1
//
aAdd( aSIX, { ;
	'AX1'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX1_FILIAL+AX1_CODCAT+AX1_ITEM'										, ; //CHAVE
	'Categoria+Item'														, ; //DESCRICAO
	'Categoria+Item'														, ; //DESCSPA
	'Categoria+Item'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AX2
//
aAdd( aSIX, { ;
	'AX2'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX2_FILIAL+AX2_FILORI+AX2_DOC+AX2_SERIE+AX2_ITEM'						, ; //CHAVE
	'Filial Orig.+Documento+Serie+Item NF'									, ; //DESCRICAO
	'Filial Orig.+Documento+Serie+Item Factura'								, ; //DESCSPA
	'Filial Orig.+Document+Serie+Item Factura'								, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX2'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AX2_FILIAL+AX2_FILORI+AX2_DOC+AX2_SERIE+AX2_FORNEC+AX2_LOJFOR'			, ; //CHAVE
	'Filial Orig.+Documento+Serie+Fornecedor+Loja'							, ; //DESCRICAO
	'Filial Orig.+Documento+Serie+Proveedor+Tienda'							, ; //DESCSPA
	'Filial Orig.+Documento+Serie+Proveedor+Tienda'							, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AX3
//
aAdd( aSIX, { ;
	'AX3'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX3_FILIAL+AX3_NUM'													, ; //CHAVE
	'Num.Cobranca'															, ; //DESCRICAO
	'Num.Cobranca'															, ; //DESCSPA
	'Num.Cobranca'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX3'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AX3_FILIAL+AX3_PEDIDO'													, ; //CHAVE
	'Ped.Venda'																, ; //DESCRICAO
	'Ped.Venda'																, ; //DESCSPA
	'Ped.Venda'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX3'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'AX3_FILIAL+AX3_DOC+AX3_SERIE'											, ; //CHAVE
	'NF Saida+Serie NF'														, ; //DESCRICAO
	'NF Saida+Serie NF'														, ; //DESCSPA
	'NF Saida+Serie NF'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AX6
//
aAdd( aSIX, { ;
	'AX6'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX6_FILIAL+AX6_NUM'													, ; //CHAVE
	'Num.Ticket'															, ; //DESCRICAO
	'Num.Ticket'															, ; //DESCSPA
	'Num.Ticket'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX6'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AX6_FILIAL+AX6_STATUS+AX6_NUM'											, ; //CHAVE
	'Status+Num.Ticket'														, ; //DESCRICAO
	'Status+Num.Ticket'														, ; //DESCSPA
	'Status+Num.Ticket'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX6'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'AX6_FILIAL+AX6_TPDEFE+AX6_NUM'											, ; //CHAVE
	'Tipo Defeito+Num.Ticket'												, ; //DESCRICAO
	'Tipo Defeito+Num.Ticket'												, ; //DESCSPA
	'Tipo Defeito+Num.Ticket'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AX8
//
aAdd( aSIX, { ;
	'AX8'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX8_FILIAL+AX8_COD+AX8_DESC'											, ; //CHAVE
	'Codigo+Descricao'														, ; //DESCRICAO
	'Codigo+Descricao'														, ; //DESCSPA
	'Codigo+Descricao'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX8'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AX8_FILIAL+AX8_DESC+AX8_COD'											, ; //CHAVE
	'Descricao+Codigo'														, ; //DESCRICAO
	'Descricao+Codigo'														, ; //DESCSPA
	'Descricao+Codigo'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AX9
//
aAdd( aSIX, { ;
	'AX9'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AX9_FILIAL+AX9_COD+AX9_DESC'											, ; //CHAVE
	'Codigo+Descricao'														, ; //DESCRICAO
	'Codigo+Descricao'														, ; //DESCSPA
	'Codigo+Descricao'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AX9'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AX9_FILIAL+AX9_DESC+AX9_COD'											, ; //CHAVE
	'Descricao+Codigo'														, ; //DESCRICAO
	'Descricao+Codigo'														, ; //DESCSPA
	'Descricao+Codigo'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AXA
//
aAdd( aSIX, { ;
	'AXA'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AXA_FILIAL+AXA_TICKET+AXA_DATA+AXA_HORA'								, ; //CHAVE
	'Ticket+Data+Hora'														, ; //DESCRICAO
	'Ticket+Data+Hora'														, ; //DESCSPA
	'Ticket+Data+Hora'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AXB
//
aAdd( aSIX, { ;
	'AXB'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AXB_FILIAL+AXB_CODSTS+AXB_USER'										, ; //CHAVE
	'Cod.Status+Cod.Usuario'												, ; //DESCRICAO
	'Cod.Status+Cod.Usuario'												, ; //DESCSPA
	'Cod.Status+Cod.Usuario'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AXB'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AXB_FILIAL+AXB_CODSTS+AXB_IDUSER'										, ; //CHAVE
	'Cod.Status+Id.Usuario'													, ; //DESCRICAO
	'Cod.Status+Id.Usuario'													, ; //DESCSPA
	'Cod.Status+Id.Usuario'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AXY
//
aAdd( aSIX, { ;
	'AXY'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AXY_FILIAL+AXY_LOTE'													, ; //CHAVE
	'Cod. Lote'																, ; //DESCRICAO
	'Cod. Lote'																, ; //DESCSPA
	'Cod. Lote'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AXY'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AXY_FILIAL+AXY_LOTE+AXY_LOJA'											, ; //CHAVE
	'Cod. Lote + Loja'														, ; //DESCRICAO
	'Cod. Lote + Loja'														, ; //DESCSPA
	'Cod. Lote + Loja'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela AXZ
//
aAdd( aSIX, { ;
	'AXZ'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AXZ_FILIAL+AXZ_COD+AXZ_LOCAL+AXZ_DATA'									, ; //CHAVE
	'Produto+Armazem+Data'													, ; //DESCRICAO
	'Produto+Armazem+Data'													, ; //DESCSPA
	'Produto+Armazem+Data'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AYO
//
aAdd( aSIX, { ;
	'AYO'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AYO_FILIAL+AYO_CODPRO+AYO_PRODUT+AYO_ITEM'								, ; //CHAVE
	'Produto + Produto MP+Item'												, ; //DESCRICAO
	'Produto + Produto MP+Item'												, ; //DESCSPA
	'Produto + Produto MP+Item'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AYO'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AYO_FILIAL+AYO_CODPRO+AYO_PRODUT+AYO_CHVCLP'							, ; //CHAVE
	'Produto + Produto MP + Tamanho PA'										, ; //DESCRICAO
	'Produto + Produto MP + Tamanho PA'										, ; //DESCSPA
	'Produto + Produto MP + Tamanho PA'										, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AYO'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'AYO_FILIAL+AYO_CODPRO+AYO_PRODUT+AYO_CHVLNP'							, ; //CHAVE
	'Produto + Produto MP + Cor PA'											, ; //DESCRICAO
	'Produto + Produto MP + Cor PA'											, ; //DESCSPA
	'Produto + Produto MP + Cor PA'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela AYS
//
aAdd( aSIX, { ;
	'AYS'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AYS_FILIAL+AYS_CODPRO+AYS_LINGRD'										, ; //CHAVE
	'Produto + Cor'															, ; //DESCRICAO
	'Produto + Cor'															, ; //DESCSPA
	'Produto + Cor'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela AYW
//
aAdd( aSIX, { ;
	'AYW'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AYW_FILIAL+AYW_CODGRP+AYW_CODEMP+AYW_CODUNI+AYW_CODFIL+AYW_CAT1+AYW_CAT2+AYW_CAT3+AYW_DATA', ; //CHAVE
	'Cod.Grupo+Cod.Empresa+Cod.Un.Neg+Filial+Categoria 1+Categoria 2+Catego'	, ; //DESCRICAO
	'Cod.Grupo+Cod.Empresa+Cod.Un.Neg+Filial+Categoria 1+Categoria 2+Catego'	, ; //DESCSPA
	'Cod.Grupo+Cod.Empresa+Cod.Un.Neg+Filial+Categoria 1+Categoria 2+Catego'	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AYX
//
aAdd( aSIX, { ;
	'AYX'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AYX_FILIAL+AYX_CODIGO'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AYX'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AYX_FILIAL+AYX_DESC'													, ; //CHAVE
	'Descricao'																, ; //DESCRICAO
	'Descricao'																, ; //DESCSPA
	'Descricao'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela AYY
//
aAdd( aSIX, { ;
	'AYY'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'AYY_FILIAL+AYY_CODPRO+AYY_DATREM'										, ; //CHAVE
	'Cod.Prod.Pai+Data Remarc.'												, ; //DESCRICAO
	'Cod.Prod.Pai+Data Remarc.'												, ; //DESCSPA
	'Cod.Prod.Pai+Data Remarc.'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'AYY'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'AYY_FILIAL+AYY_DATREM+AYY_CODPRO'										, ; //CHAVE
	'Data Remarc.+Cod.Prod.Pai'												, ; //DESCRICAO
	'Data Remarc.+Cod.Prod.Pai'												, ; //DESCSPA
	'Data Remarc.+Cod.Prod.Pai'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela DAH
//
aAdd( aSIX, { ;
	'DAH'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'DAH_FILIAL+DAH_CODCAR+DAH_SEQCAR+DAH_SEQUEN'							, ; //CHAVE
	'Codigo Carga + Seq. Carga + Seq. Entrega'								, ; //DESCRICAO
	'Codigo Carga + Sec. Carga + Sec. Entrega'								, ; //DESCSPA
	'Load Code + Load Seq. + Delivery Seq'									, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'DAH'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'DAH_XNRSAC'															, ; //CHAVE
	'Numero SAC'															, ; //DESCRICAO
	'Numero SAC'															, ; //DESCSPA
	'Numero SAC'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SA1
//
aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'A1_FILIAL+A1_COD+A1_LOJA'												, ; //CHAVE
	'Codigo + Loja'															, ; //DESCRICAO
	'Codigo + Tienda'														, ; //DESCSPA
	'Code + Unit'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'A1_FILIAL+A1_NOME+A1_LOJA'												, ; //CHAVE
	'Nome + Loja'															, ; //DESCRICAO
	'Nombre + Tienda'														, ; //DESCSPA
	'Name + Unit'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'A1_FILIAL+A1_CGC'														, ; //CHAVE
	'CNPJ/CPF'																, ; //DESCRICAO
	'CNPJ/CPF'																, ; //DESCSPA
	'CNPJ/CPF'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'A1_FILIAL+A1_TEL+A1_DDD+A1_DDI'										, ; //CHAVE
	'Telefone + DDD + DDI'													, ; //DESCRICAO
	'Telefono + DDN + DDI'													, ; //DESCSPA
	'Phone + DDD + DDI'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'A1_FILIAL+A1_NREDUZ'													, ; //CHAVE
	'N Fantasia'															, ; //DESCRICAO
	'Nom Fantasia'															, ; //DESCSPA
	'Trade Name'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'A1_FILIAL+A1_GRPVEN'													, ; //CHAVE
	'Grp.Vendas'															, ; //DESCRICAO
	'Grp.Ventas'															, ; //DESCSPA
	'Sale Group'															, ; //DESCENG
	'S'																		, ; //PROPRI
	'ACY'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'A1_FILIAL+A1_NUMRA'													, ; //CHAVE
	'Numero RA'																, ; //DESCRICAO
	'Numero RA'																, ; //DESCSPA
	'RA Number'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'A1_FILIAL+A1_VINCULO'													, ; //CHAVE
	'P. Vinculo'															, ; //DESCRICAO
	'P. Vinculo'															, ; //DESCSPA
	'P.Emp.Bond'															, ; //DESCENG
	'S'																		, ; //PROPRI
	'CC1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'A1_FILIAL+A1_01IDLOJ'													, ; //CHAVE
	'Id. Lojas'																, ; //DESCRICAO
	'Id. Lojas'																, ; //DESCSPA
	'Id. Lojas'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SYVA00402'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'A1_FILIAL+A1_VEND+A1_COD+A1_LOJA'										, ; //CHAVE
	'Vendedor + Codigo + Loja'												, ; //DESCRICAO
	'Vendedor + Codigo + Tienda'											, ; //DESCSPA
	'Seller + Code + Unit'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'A1_FILIAL+A1_CLIPRI+A1_LOJPRI+A1_COD+A1_LOJA'							, ; //CHAVE
	'Cli. Primar. + Loja Cli.Pri + Codigo + Loja'							, ; //DESCRICAO
	'Cli. Primar. + Tien Cli.Pri + Codigo + Tienda'							, ; //DESCSPA
	'Primary Cli. + Pri.Cli. Sto + Code + Unit'								, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'A1_FILIAL+A1_SITUA'													, ; //CHAVE
	'Situacão FRT'															, ; //DESCRICAO
	'Situaci. FRT'															, ; //DESCSPA
	'POS Status'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA1'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'A1_FILIAL+A1_FILTRF'													, ; //CHAVE
	'Fil. Transf.'															, ; //DESCRICAO
	'Suc. Tranf.'															, ; //DESCSPA
	'Tranf.Branch'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'FILTRF'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SA2
//
aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'A2_FILIAL+A2_COD+A2_LOJA'												, ; //CHAVE
	'Codigo + Loja'															, ; //DESCRICAO
	'Codigo + Tienda'														, ; //DESCSPA
	'Supplier + Unit'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'A2_FILIAL+A2_NOME+A2_LOJA'												, ; //CHAVE
	'Razao Social + Loja'													, ; //DESCRICAO
	'Razon Social + Tienda'													, ; //DESCSPA
	'Company Name + Unit'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'A2_FILIAL+A2_CGC'														, ; //CHAVE
	'CNPJ/CPF'																, ; //DESCRICAO
	'CNPJ/CPF'																, ; //DESCSPA
	'CNPJ/CPF'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'A2_FILIAL+A2_ID_FBFN'													, ; //CHAVE
	'Identificac.'															, ; //DESCRICAO
	'Identificac.'															, ; //DESCSPA
	'Identificat.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'A2_FILIAL+A2_CONREG+A2_SIGLCR'											, ; //CHAVE
	'Numero C.R + Sigla C.R'												, ; //DESCRICAO
	'Numero C.R. + Sigla C.R.'												, ; //DESCSPA
	'Reg.Coun.No. + C.R Acronym'											, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'A2_FILIAL+A2_VINCULO'													, ; //CHAVE
	'P. Vinculo'															, ; //DESCRICAO
	'P. Vinculo'															, ; //DESCSPA
	'P.Emp.Bond'															, ; //DESCENG
	'S'																		, ; //PROPRI
	'CC1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'A2_FILIAL+A2_NUMRA'													, ; //CHAVE
	'Cód Func'																, ; //DESCRICAO
	'Cod. Empl.'															, ; //DESCSPA
	'Empl. code'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'A2_FILIAL+A2_NREDUZ+A2_COD+A2_LOJA'									, ; //CHAVE
	'N Fantasia+Codigo+Loja'												, ; //DESCRICAO
	'N Fantasia+Codigo+Loja'												, ; //DESCSPA
	'N Fantasia+Codigo+Loja'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SYMMSA21'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'A2_FILIAL+A2_01IDLOJ'													, ; //CHAVE
	'Id. Lojas'																, ; //DESCRICAO
	'Id. Lojas'																, ; //DESCSPA
	'Id. Lojas'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SYVA00403'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'A2_FILIAL+A2_CODADM'													, ; //CHAVE
	'Cód. Adm.'																, ; //DESCRICAO
	'Cod. Adm.'																, ; //DESCSPA
	'Adm. Code'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SYTM0001'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'A2_FILIAL+A2_FILTRF'													, ; //CHAVE
	'Fil. Transf.'															, ; //DESCRICAO
	'Suc. Transf.'															, ; //DESCSPA
	'Tranf.Brch.'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'FILTRF2'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SC5
//
aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'C5_FILIAL+C5_NUM'														, ; //CHAVE
	'Numero'																, ; //DESCRICAO
	'Numero'																, ; //DESCSPA
	'Number'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'C5_FILIAL+DTOS(C5_EMISSAO)+C5_NUM'										, ; //CHAVE
	'DT Emissao + Numero'													, ; //DESCRICAO
	'Fch Emision + Numero'													, ; //DESCSPA
	'Issue Date + Number'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM'								, ; //CHAVE
	'Cliente + Loja + Numero'												, ; //DESCRICAO
	'Cliente + Tienda + Numero'												, ; //DESCSPA
	'Customer + Unit + Number'												, ; //DESCENG
	'S'																		, ; //PROPRI
	'CLI'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'C5_FILIAL+C5_OS'														, ; //CHAVE
	'Gerado p/ OS'															, ; //DESCRICAO
	'Nr.OS Genera'															, ; //DESCSPA
	'Gen.f/S.O.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'C5_FILIAL+C5_NUMENT'													, ; //CHAVE
	'Entrega'																, ; //DESCRICAO
	'Entrega'																, ; //DESCSPA
	'Delivery'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'C5_FILIAL+C5_CODED+C5_NUMPR'											, ; //CHAVE
	'Cod. Edital + Nr. Processo'											, ; //DESCRICAO
	'Cód. Edital + Nr. Proceso'												, ; //DESCSPA
	'Public Note + Process no.'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'C5_FILIAL+C5_CODEMB'													, ; //CHAVE
	'Cod. Embarc.'															, ; //DESCRICAO
	'Cód. Embarc.'															, ; //DESCSPA
	'Shipment Cde'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'C5_FILIAL+C5_MODANP'													, ; //CHAVE
	'Modal ANP'																, ; //DESCRICAO
	'Modal ANP'																, ; //DESCSPA
	'Modal ANP'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'C5_FILIAL+C5_CODVGLP'													, ; //CHAVE
	'Cod.Vas.GLP'															, ; //DESCRICAO
	'Cód.Vas.GLP'															, ; //DESCSPA
	'GLP cont cd'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC5'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'C5_FILIAL+C5_NUM+C5_MSFIL'												, ; //CHAVE
	'Filial + Numero + MSFIL'												, ; //DESCRICAO
	'Filial + Numero + MSFIL'												, ; //DESCSPA
	'Filial + Numero + MSFIL'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SC5MSFIL'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SC7
//
aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN'									, ; //CHAVE
	'Numero PC + Item + Sequencia'											, ; //DESCRICAO
	'Nr.PedCompra + Item + Secuencia'										, ; //DESCSPA
	'PO Number + Item + Sequence'											, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM'						, ; //CHAVE
	'Produto + Fornecedor + Loja + Numero PC'								, ; //DESCRICAO
	'Producto + Proveedor + Tienda + Nr.PedCompra'							, ; //DESCSPA
	'Product + Supplier + Unit + PO Number'									, ; //DESCENG
	'S'																		, ; //PROPRI
	'SB1+FOR'																, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'C7_FILIAL+C7_FORNECE+C7_LOJA+C7_NUM'									, ; //CHAVE
	'Fornecedor + Loja + Numero PC'											, ; //DESCRICAO
	'Proveedor + Tienda + Nr.PedCompra'										, ; //DESCSPA
	'Supplier + Unit + PO Number'											, ; //DESCENG
	'S'																		, ; //PROPRI
	'FOR'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN'							, ; //CHAVE
	'Produto + Numero PC + Item + Sequencia'								, ; //DESCRICAO
	'Producto + Nr.PedCompra + Item + Secuencia'							, ; //DESCSPA
	'Product + PO Number + Item + Sequence'									, ; //DESCENG
	'S'																		, ; //PROPRI
	'SB1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'C7_FILIAL+DTOS(C7_EMISSAO)+C7_NUM+C7_ITEM+C7_SEQUEN'					, ; //CHAVE
	'DT Emissao + Numero PC + Item + Sequencia'								, ; //DESCRICAO
	'Fch Emision + Nr.PedCompra + Item + Secuencia'							, ; //DESCSPA
	'Issue Date + PO Number + Item + Sequence'								, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM'						, ; //CHAVE
	'Filial Entr. + Produto + Fornecedor + Loja + Numero PC'				, ; //DESCRICAO
	'Suc. Entrega + Producto + Proveedor + Tienda + Nr.PedCompra'			, ; //DESCSPA
	'Branch Deliv + Product + Supplier + Unit + PO Number'					, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SB1+FOR'															, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'C7_FILIAL+C7_PRODUTO+DTOS(C7_DATPRF)'									, ; //CHAVE
	'Produto + Dt. Entrega'													, ; //DESCRICAO
	'Producto + Fch Entrega'												, ; //DESCSPA
	'Product + Delivery Dt.'												, ; //DESCENG
	'S'																		, ; //PROPRI
	'SB1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'C7_FILIAL+C7_OP+C7_NUM+C7_ITEM+C7_SEQUEN'								, ; //CHAVE
	'OP. + Numero PC + Item + Sequencia'									, ; //DESCRICAO
	'Orden Produc + Nr.PedCompra + Item + Secuencia'						, ; //DESCSPA
	'Prod.Order + PO Number + Item + Sequence'								, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'C7_FILENT+C7_FORNECE+C7_LOJA+C7_NUM'									, ; //CHAVE
	'Filial Entr. + Fornecedor + Loja + Numero PC'							, ; //DESCRICAO
	'Suc. Entrega + Proveedor + Tienda + Nr.PedCompra'						, ; //DESCSPA
	'Branch Deliv + Supplier + Unit + PO Number'							, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+FOR'																, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'C7_FILIAL+STR(C7_TIPO,1)+C7_NUM+C7_ITEM+C7_SEQUEN'						, ; //CHAVE
	'Tipo + Numero PC + Item + Sequencia'									, ; //DESCRICAO
	'Tipo + Nr.PedCompra + Item + Secuencia'								, ; //DESCSPA
	'Type + PO Number + Item + Sequence'									, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'C7_FILIAL+C7_TPOP+C7_OP+C7_NUM+C7_ITEM+C7_SEQUEN'						, ; //CHAVE
	'Tipo Op + OP. + Numero PC + Item + Sequencia'							, ; //DESCRICAO
	'Tipo Op + Orden Produc + Nr.PedCompra + Item + Secuencia'				, ; //DESCSPA
	'Type of PO + Prod.Order + PO Number + Item + Sequence'					, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'C7_FILIAL+C7_APROV+C7_GRUPCOM'											, ; //CHAVE
	'Grupo Aprov. + Gr. Compras'											, ; //DESCRICAO
	'Grupo Aprob + Gr. Compras'												, ; //DESCSPA
	'Appr. Group + Buyers Grp'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_NUM'								, ; //CHAVE
	'Filial Entr. + Produto + Fornecedor + Numero PC'						, ; //DESCRICAO
	'Suc. Entrega + Producto + Proveedor + Nr.PedCompra'					, ; //DESCSPA
	'Branch Deliv + Product + Supplier + PO Number'							, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SB1+FOR'															, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'E'																		, ; //ORDEM
	'C7_FILENT+C7_NUM+C7_ITEM'												, ; //CHAVE
	'Filial Entr. + Numero PC + Item'										, ; //DESCRICAO
	'Suc. Entrega + Nr.PedCompra + Item'									, ; //DESCSPA
	'Branch Deliv + PO Number + Item'										, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'F'																		, ; //ORDEM
	'C7_FILIAL+C7_ENCER+C7_PRODUTO+DTOS(C7_EMISSAO)'						, ; //CHAVE
	'Ped. Encerr. + Produto + DT Emissao'									, ; //DESCRICAO
	'Ped.Concluid + Producto + Fch Emision'									, ; //DESCSPA
	'Closed Order + Product + Issue Date'									, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'G'																		, ; //ORDEM
	'C7_FILIAL+DTOS(C7_DATPRF)+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN'			, ; //CHAVE
	'Dt. Entrega + Produto + Numero PC + Item + Sequencia'					, ; //DESCRICAO
	'Fch Entrega + Producto + Nr.PedCompra + Item + Secuencia'				, ; //DESCSPA
	'Delivery Dt. + Product + PO Number + Item + Sequence'					, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'H'																		, ; //ORDEM
	'C7_FILENT+C7_FORNECE+C7_LOJA+C7_PRODUTO'								, ; //CHAVE
	'Filial Entr. + Fornecedor + Loja + Produto'							, ; //DESCRICAO
	'Suc. Entrega + Proveedor + Tienda + Producto'							, ; //DESCSPA
	'Branch Deliv + Supplier + Unit + Product'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SA2+XXX+SB1'														, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'I'																		, ; //ORDEM
	'C7_FILENT+C7_FORNECE+C7_PRODUTO'										, ; //CHAVE
	'Filial Entr. + Fornecedor + Produto'									, ; //DESCRICAO
	'Suc. Entrega + Proveedor + Producto'									, ; //DESCSPA
	'Branch Deliv + Supplier + Product'										, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SA2+SB1'															, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'J'																		, ; //ORDEM
	'C7_FILENT+C7_PRODUTO+C7_NUM+C7_ITEM'									, ; //CHAVE
	'Filial Entr. + Produto + Numero PC + Item'								, ; //DESCRICAO
	'Suc. Entrega + Producto + Nr.PedCompra + Item'							, ; //DESCSPA
	'Branch Deliv + Product + PO Number + Item'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SB1'																, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'K'																		, ; //ORDEM
	'C7_FILIAL+C7_NODIA'													, ; //CHAVE
	'Seq. Diário'															, ; //DESCRICAO
	'Sec. Diario'															, ; //DESCSPA
	'Record Seq.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'L'																		, ; //ORDEM
	'C7_FILIAL+C7_NUM+C7_01PRODP+C7_01GRADE+C7_01FILDE'						, ; //CHAVE
	'Pedido+Produto Pai+Grade+Filial Destino'								, ; //DESCRICAO
	'Pedido+Produto Pai+Grade+Filial Destino'								, ; //DESCSPA
	'Pedido+Produto Pai+Grade+Filial Destino'								, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SYMMSC701'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'M'																		, ; //ORDEM
	'C7_FILIAL+C7_NUM+C7_PRODUTO+C7_01GRADE'								, ; //CHAVE
	'Numero PC + Produto + ID Grade'										, ; //DESCRICAO
	'Numero PC + Produto + ID Grade'										, ; //DESCSPA
	'Numero PC + Produto + ID Grade'										, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SYMMSC702'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SC7'																	, ; //INDICE
	'N'																		, ; //ORDEM
	'C7_FILIAL+C7_NUM+C7_FILENT'											, ; //CHAVE
	'C7_FILIAL+C7_NUM+C7_FILENT'											, ; //DESCRICAO
	'C7_FILIAL+C7_NUM+C7_FILENT'											, ; //DESCSPA
	'C7_FILIAL+C7_NUM+C7_FILENT'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SE1
//
aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO'						, ; //CHAVE
	'Prefixo + No. Titulo + Parcela + Tipo'									, ; //DESCRICAO
	'Prefijo + Num. Titulo + Cuota + Tipo'									, ; //DESCSPA
	'Prefix + Bill Number + Installment + Type'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+XXX+XXX+05'														, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO'		, ; //CHAVE
	'Cliente + Loja + Prefixo + No. Titulo + Parcela + Tipo'				, ; //DESCRICAO
	'Cliente + Tienda + Prefijo + Num. Titulo + Cuota + Tipo'				, ; //DESCSPA
	'Customer + Unit + Prefix + Bill Number + Installment + Type'			, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA1+XXX+XXX+XXX+XXX+05'												, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'E1_FILIAL+E1_NATUREZ+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_TIPO'				, ; //CHAVE
	'Natureza + Nome Cliente + Prefixo + No. Titulo + Tipo'					, ; //DESCRICAO
	'Modalidad + Nomb Cliente + Prefijo + Num. Titulo + Tipo'				, ; //DESCSPA
	'Class + Cust.Name + Prefix + Bill Number + Type'						, ; //DESCENG
	'S'																		, ; //PROPRI
	'SED+XXX+XXX+XXX+05'													, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'E1_FILIAL+E1_PORTADO+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_TIPO'				, ; //CHAVE
	'Portador + Nome Cliente + Prefixo + No. Titulo + Tipo'					, ; //DESCRICAO
	'Portador + Nomb Cliente + Prefijo + Num. Titulo + Tipo'				, ; //DESCSPA
	'Bearer + Cust.Name + Prefix + Bill Number + Type'						, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA6+XXX+XXX+XXX+05'													, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'E1_FILIAL+E1_NUMBOR+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO'	, ; //CHAVE
	'Num. Bordero + Nome Cliente + Prefixo + No. Titulo + Parcela + Tipo'		, ; //DESCRICAO
	'Num.Bordero + Nomb Cliente + Prefijo + Num. Titulo + Cuota + Tipo'		, ; //DESCSPA
	'Bordero Nr. + Cust.Name + Prefix + Bill Number + Installment + Type'		, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+XXX+XXX+XXX+XXX+05'												, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_EMISSAO)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA'		, ; //CHAVE
	'DT Emissao + Nome Cliente + Prefixo + No. Titulo + Parcela'			, ; //DESCRICAO
	'Fch Emision + Nomb Cliente + Prefijo + Num. Titulo + Cuota'			, ; //DESCSPA
	'issue Date + Cust.Name + Prefix + Bill Number + Installment'			, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA'		, ; //CHAVE
	'Vencto real + Nome Cliente + Prefixo + No. Titulo + Parcela'			, ; //DESCRICAO
	'Venc. Real + Nomb Cliente + Prefijo + Num. Titulo + Cuota'				, ; //DESCSPA
	'Real Matur. + Cust.Name + Prefix + Bill Number + Installment'			, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_STATUS+DTOS(E1_VENCREA)'				, ; //CHAVE
	'Cliente + Loja + Status + Vencto real'									, ; //DESCRICAO
	'Cliente + Tienda + Estatus + Venc. Real'								, ; //DESCSPA
	'Customer + Unit + Status + Real Matur.'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'E1_FILIAL+E1_NRDOC+E1_PREFIXO+E1_CLIENTE+E1_LOJA'						, ; //CHAVE
	'Nr.Documento + Prefixo + Cliente + Loja'								, ; //DESCRICAO
	'Nr.Documento + Prefijo + Cliente + Tienda'								, ; //DESCSPA
	'Doc.Num. + Prefix + Customer + Unit'									, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_FATPREF+E1_FATURA'						, ; //CHAVE
	'Cliente + Loja + Pref. Fatura + Fatura'								, ; //DESCRICAO
	'Cliente + Tienda + Pref.Factura + Factura'								, ; //DESCSPA
	'Customer + Unit + Invoice Pref + Invoice'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_EMISSAO)+E1_NATUREZ+E1_CLIENTE+E1_LOJA+E1_TIPO'		, ; //CHAVE
	'DT Emissao + Natureza + Cliente + Loja + Tipo'							, ; //DESCRICAO
	'Fch Emision + Modalidad + Cliente + Tienda + Tipo'						, ; //DESCSPA
	'issue Date + Class + Customer + Unit + Type'							, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+SED'																, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'E1_FILIAL+E1_NUMBOR+DTOS(E1_EMISSAO)'									, ; //CHAVE
	'Num. Bordero + DT Emissao'												, ; //DESCRICAO
	'Num.Bordero + Fch Emision'												, ; //DESCSPA
	'Bordero Nr. + issue Date'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'E1_FILIAL+E1_ORDPAGO'													, ; //CHAVE
	'Ordem Pagto'															, ; //DESCRICAO
	'Orden Pago'															, ; //DESCSPA
	'PaymentOrder'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'E'																		, ; //ORDEM
	'E1_FILIAL+E1_CODINT+E1_CODEMP+E1_MATRIC+E1_ANOBASE+E1_MESBASE'			, ; //CHAVE
	'Instituicao + Empresa/Grup + Matricula + Ano Base + Mes Base'			, ; //DESCRICAO
	'Institucion + Empresa/Grup + Matricula + Ano Base + Mes Base'			, ; //DESCSPA
	'Institution + Co/Group + Registration + Base Year + Base Month'		, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'F'																		, ; //ORDEM
	'E1_FILIAL+E1_NUMLIQ'													, ; //CHAVE
	'N.Liquidacao'															, ; //DESCRICAO
	'Nro.Liquidac'															, ; //DESCSPA
	'Setl. No.'																, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'G'																		, ; //ORDEM
	'E1_FILIAL+E1_IDCNAB'													, ; //CHAVE
	'Id. Cnab'																, ; //DESCRICAO
	'Id. CNAB'																, ; //DESCSPA
	'CNAB Iden.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'H'																		, ; //ORDEM
	'E1_FILIAL+E1_CODIMOV'													, ; //CHAVE
	'Cod. Imovel'															, ; //DESCRICAO
	'Cod.Inmueble'															, ; //DESCSPA
	'Est.Code'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'I'																		, ; //ORDEM
	'E1_FILIAL+E1_NUMRA+DTOS(E1_VENCTO)+E1_PREFIXO'							, ; //CHAVE
	'Numero RA + Vencimento + Prefixo'										, ; //DESCRICAO
	'Numero RA + Vencimiento + Prefijo'										, ; //DESCSPA
	'RA Number + Maturity Dt. + Prefix'										, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'J'																		, ; //ORDEM
	'E1_IDCNAB'																, ; //CHAVE
	'Id. Cnab'																, ; //DESCRICAO
	'Id. CNAB'																, ; //DESCSPA
	'CNAB Iden.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'K'																		, ; //ORDEM
	'E1_FILIAL+E1_NODIA'													, ; //CHAVE
	'Seq. Diario'															, ; //DESCRICAO
	'Sec. Diario'															, ; //DESCSPA
	'Tax Rec. Seq'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'L'																		, ; //ORDEM
	'E1_FILIAL+E1_DOCTEF'													, ; //CHAVE
	'Num. NSU'																, ; //DESCRICAO
	'Num. NSU'																, ; //DESCSPA
	'NSU Number'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'IDXFINA01'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'M'																		, ; //ORDEM
	'E1_FILIAL+E1_NFELETR'													, ; //CHAVE
	'NF Eletr'																, ; //DESCRICAO
	'eFact'																	, ; //DESCSPA
	'Elect.Inv.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'N'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_EMISSAO)+E1_NSUTEF'									, ; //CHAVE
	'DT Emissao + NSU SITEF'												, ; //DESCRICAO
	'Fch Emision + NSU SITEF'												, ; //DESCSPA
	'issue Date + NSU SITEF'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'O'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_EMISSAO)+E1_DOCTEF'									, ; //CHAVE
	'DT Emissao + Num. NSU'													, ; //DESCRICAO
	'Fch Emision + Num. NSU'												, ; //DESCSPA
	'issue Date + NSU Number'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'P'																		, ; //ORDEM
	'E1_FILIAL+E1_JURFAT'													, ; //CHAVE
	'Num Fat Jur'															, ; //DESCRICAO
	'Num Fact Jur'															, ; //DESCSPA
	'Leg.Inv.No.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'Q'																		, ; //ORDEM
	'E1_FILIAL+E1_PORTADO+E1_AGEDEP+E1_CONTA+E1_BCOCHQ+E1_AGECHQ+E1_CTACHQ+E1_PREFIXO+E1_NUM', ; //CHAVE
	'Portador + Depositaria + Num da Conta + Bco. Cheque + Agenc.Cheque + C'	, ; //DESCRICAO
	'Portador + Depositaria + Num Cuenta + Bco. Cheque + Agen. Cheque + Cta'	, ; //DESCSPA
	'Bearer + Depositary + Account Num. + Ch. Bank + C.Bank Off. + Ch. Acc.'	, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'R'																		, ; //ORDEM
	'E1_FILIAL+DTOS(E1_EMISSAO)+E1_PARCELA+E1_NSUTEF+E1_TIPO+DTOS(E1_VENCREA)'	, ; //CHAVE
	'DT Emissao + Parcela + NSU SITEF + Tipo + Vencto real'					, ; //DESCRICAO
	'Fch Emision + Cuota + NSU SITEF + Tipo + Venc. Real'					, ; //DESCSPA
	'issue Date + Installment + NSU SITEF + Type + Real Matur.'				, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'S'																		, ; //ORDEM
	'E1_FILIAL+E1_TITPAI'													, ; //CHAVE
	'Titulo Pai'															, ; //DESCRICAO
	'Titulo Orig.'															, ; //DESCSPA
	'Parent Bill'															, ; //DESCENG
	'S'																		, ; //PROPRI
	'FILIAL + TITULO PAI'													, ; //F3
	'TITPAI'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'T'																		, ; //ORDEM
	'E1_FILIAL+E1_NUMSUA'													, ; //CHAVE
	'Numero TLV'															, ; //DESCRICAO
	'Numero TLV'															, ; //DESCSPA
	'Numero TLV'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE1TLV'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SU5
//
aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'U5_FILIAL+U5_CODCONT+U5_IDEXC'											, ; //CHAVE
	'Contato + ID Exchange'													, ; //DESCRICAO
	'Contacto + ID Exchange'												, ; //DESCSPA
	'Contact + Exchange ID'													, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'U5_FILIAL+U5_CONTAT'													, ; //CHAVE
	'Nome'																	, ; //DESCRICAO
	'Nombre'																, ; //DESCSPA
	'Name'																	, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'U5_FILIAL+U5_FONE+U5_DDD+U5_CODPAIS'									, ; //CHAVE
	'Fone Resid. + DDD + DDI'												, ; //DESCRICAO
	'Telef. Resid + DDN + DDI'												, ; //DESCSPA
	'Home Phone + DDD + DDI'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'U5_FILIAL+U5_CELULAR+U5_DDD+U5_CODPAIS'								, ; //CHAVE
	'Celular + DDD + DDI'													, ; //DESCRICAO
	'Celular + DDN + DDI'													, ; //DESCSPA
	'Mobile + DDD + DDI'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'U5_FILIAL+U5_FCOM1+U5_DDD+U5_CODPAIS'									, ; //CHAVE
	'Fone Com.1 + DDD + DDI'												, ; //DESCRICAO
	'Tel. Com.1 + DDN + DDI'												, ; //DESCSPA
	'Work Phone 1 + DDD + DDI'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'U5_FILIAL+U5_FCOM2+U5_DDD+U5_CODPAIS'									, ; //CHAVE
	'Fone Com.2 + DDD + DDI'												, ; //DESCRICAO
	'Tel. Com.2 + DDN + DDI'												, ; //DESCSPA
	'Work Phone 2 + DDD + DDI'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'U5_FILIAL+U5_FAX+U5_DDD+U5_CODPAIS'									, ; //CHAVE
	'Fax + DDD + DDI'														, ; //DESCRICAO
	'FAX + DDN + DDI'														, ; //DESCSPA
	'Fax + DDD + DDI'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'U5_FILIAL+U5_CPF'														, ; //CHAVE
	'CPF'																	, ; //DESCRICAO
	'CPF'																	, ; //DESCSPA
	'CPF'																	, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'U5_FILIAL+U5_EMAIL'													, ; //CHAVE
	'E-mail'																, ; //DESCRICAO
	'E-mail'																, ; //DESCSPA
	'E-mail'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'U5_FILIAL+U5_IDSITE'													, ; //CHAVE
	'Id no Site'															, ; //DESCRICAO
	'Id en el Sit'															, ; //DESCSPA
	'Site Id'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'U5_FILIAL+U5_IDEXC'													, ; //CHAVE
	'ID Exchange'															, ; //DESCRICAO
	'ID Exchange'															, ; //DESCSPA
	'Exchange ID'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'U5_FILIAL+U5_CONPRI+U5_CODCONT'										, ; //CHAVE
	'Cont Primar. + Contato'												, ; //DESCRICAO
	'Cont Primar. + Contacto'												, ; //DESCSPA
	'Prim.Contact + Contact'												, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SU5'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'U5_FILIAL+U5_01SAI'													, ; //CHAVE
	'Cod.Cliente'															, ; //DESCRICAO
	'Cod.Cliente'															, ; //DESCSPA
	'Cod.Cliente'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SU501SAI'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SUA
//
aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'UA_FILIAL+UA_NUM'														, ; //CHAVE
	'Atendimento'															, ; //DESCRICAO
	'Nro. Llamada'															, ; //DESCSPA
	'Servicing'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'UA_FILIAL+UA_SERIE+UA_DOC'												, ; //CHAVE
	'Serie + Nota Fiscal'													, ; //DESCRICAO
	'Serie + Num. Factura'													, ; //DESCSPA
	'Series + Invoice'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'UA_FILIAL+UA_VEND+DTOS(UA_EMISSAO)+UA_NUM'								, ; //CHAVE
	'Vendedor + Data + Atendimento'											, ; //DESCRICAO
	'Vendedor + Fecha + Nro. Llamada'										, ; //DESCSPA
	'Seller + Date + Servicing'												, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA3'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'UA_FILIAL+DTOS(UA_EMISSAO)'											, ; //CHAVE
	'Data'																	, ; //DESCRICAO
	'Fecha'																	, ; //DESCSPA
	'Date'																	, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'UA_FILIAL+UA_OPERADO+DTOS(UA_EMISSAO)'									, ; //CHAVE
	'Operador + Data'														, ; //DESCRICAO
	'Operador + Fecha'														, ; //DESCSPA
	'Operator + Date'														, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'UA_FILIAL+UA_CLIENTE+UA_LOJA+DTOS(UA_EMISSAO)'							, ; //CHAVE
	'Cliente + Loja + Data'													, ; //DESCRICAO
	'Cliente + Tienda + Fecha'												, ; //DESCSPA
	'Customer + Store + Date'												, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'7'																		, ; //ORDEM
	'UA_FILIAL+UA_CLIENTE+UA_LOJA+STR(UA_DIASDAT,8,0)+STR(UA_HORADAT,8,0)'		, ; //CHAVE
	'Cliente + Loja + Num Dias + Num. Horas'								, ; //DESCRICAO
	'Cliente + Tienda + Num Dias + Nro. Horas'								, ; //DESCSPA
	'Customer + Store + Days of Call + Time'								, ; //DESCENG
	'S'																		, ; //PROPRI
	'SA1'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'8'																		, ; //ORDEM
	'UA_FILIAL+UA_NUMSC5'													, ; //CHAVE
	'Ped SIGAFAT'															, ; //DESCRICAO
	'Nro. Pedido'															, ; //DESCSPA
	'SIGAFAT Ord.'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'UA_FILIAL+UA_CODLIG'													, ; //CHAVE
	'Ocorrencia'															, ; //DESCRICAO
	'Ocurrencia'															, ; //DESCSPA
	'Occurrence'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'UA_FILIAL+UA_CONTRA'													, ; //CHAVE
	'Contrato'																, ; //DESCRICAO
	'Contrato'																, ; //DESCSPA
	'Contract'																, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'UA_FILIAL+UA_CODCONT+UA_CLIENTE+UA_LOJA'								, ; //CHAVE
	'Contato + Cliente + Loja'												, ; //DESCRICAO
	'Contacto + Cliente + Tienda'											, ; //DESCSPA
	'Contact + Customer + Store'											, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'UA_FILIAL+UA_SDOC+UA_DOC'												, ; //CHAVE
	'Série Doc. + Nota Fiscal'												, ; //DESCRICAO
	'Serie Doc. + Num. Factura'												, ; //DESCSPA
	'Inv. Series + Invoice'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUA'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'UA_FILIAL + UA_01SAC'													, ; //CHAVE
	'Filial + Numero Chamado SAC'											, ; //DESCRICAO
	'Filial + Numero Chamado SAC'											, ; //DESCSPA
	'Filial + Numero Chamado SAC'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SUASAC'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela SUB
//
aAdd( aSIX, { ;
	'SUB'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO'									, ; //CHAVE
	'No Orcamento + Item + Produto'											, ; //DESCRICAO
	'Nro. Presup. + Num. Item + Producto'									, ; //DESCSPA
	'Budget Numb. + Item Number + Product'									, ; //DESCENG
	'S'																		, ; //PROPRI
	'XXX+XXX+PRT'															, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUB'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'UB_FILIAL+UB_PRODUTO+DTOS(UB_EMISSAO)'									, ; //CHAVE
	'Produto + Dt Emissao'													, ; //DESCRICAO
	'Producto + Fch Emision'												, ; //DESCSPA
	'Product + Issue Date'													, ; //DESCENG
	'S'																		, ; //PROPRI
	'PRT'																	, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUB'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'UB_FILIAL+UB_NUMPV+UB_ITEMPV'											, ; //CHAVE
	'Pedido + Item Pedido'													, ; //DESCRICAO
	'Pedido + Item pedido'													, ; //DESCSPA
	'Order + Order Item'													, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUB'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'UB_XFILPED+UB_01PEDCO'													, ; //CHAVE
	'Loja Pedido+Ordem Compra'												, ; //DESCRICAO
	'Loja Pedido+Ordem Compra'												, ; //DESCSPA
	'Loja Pedido+Ordem Compra'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SYSUB01'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SUB'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'UB_FILIAL+UB_XFILPED+UB_NUMPV+UB_ITEMPV'								, ; //CHAVE
	'Loja Pedido+Pedido+Item Pedido'										, ; //DESCRICAO
	'Loja Pedido+Pedido+Item Pedido'										, ; //DESCSPA
	'Loja Pedido+Pedido+Item Pedido'										, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SYSUB02'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ1
//
aAdd( aSIX, { ;
	'SZ1'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z1_FILIAL+Z1_COD'														, ; //CHAVE
	'Codigo da Regra'														, ; //DESCRICAO
	'Codigo da Regra'														, ; //DESCSPA
	'Codigo da Regra'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ1'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z1_FILIAL+Z1_COD+Z1_TIPOCPC+Z1_CONDPG'									, ; //CHAVE
	'Codigo + Tipo Produto + Cond. Pagto'									, ; //DESCRICAO
	'Codigo + Tipo Produto + Cond. Pagto'									, ; //DESCSPA
	'Codigo + Tipo Produto + Cond. Pagto'									, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ1'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'Z1_FILIAL+Z1_CONDPG+Z1_TIPOCPC+Z1_COD'									, ; //CHAVE
	'Cond. Pagto + Tipo Produto + Codigo da Regra'							, ; //DESCRICAO
	'Cond. Pagto + Tipo Produto + Codigo da Regra'							, ; //DESCSPA
	'Cond. Pagto + Tipo Produto + Codigo da Regra'							, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ1'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'Z1_FILIAL+Z1_COD+Z1_CONDPG'											, ; //CHAVE
	'Codigo + Cond. Pagto'													, ; //DESCRICAO
	'Codigo + Cond. Pagto'													, ; //DESCSPA
	'Codigo + Cond. Pagto'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ2
//
aAdd( aSIX, { ;
	'SZ2'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z2_FILIAL+Z2_CODREG+Z2_CODTAB'											, ; //CHAVE
	'Codigo Regra + Codigo Tabela'											, ; //DESCRICAO
	'Codigo Regra + Codigo Tabela'											, ; //DESCSPA
	'Codigo Regra + Codigo Tabela'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ2'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z2_FILIAL+Z2_CODTAB+Z2_CODREG'											, ; //CHAVE
	'Codigo Tabela + Codigo Regra'											, ; //DESCRICAO
	'Codigo Tabela + Codigo Regra'											, ; //DESCSPA
	'Codigo Tabela + Codigo Regra'											, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ3
//
aAdd( aSIX, { ;
	'SZ3'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z3_FILIAL+Z3_CODCOMP'													, ; //CHAVE
	'Competencia'															, ; //DESCRICAO
	'Competencia'															, ; //DESCSPA
	'Competencia'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ3'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z3_FILIAL+Z3_CODCOMP+Z3_CODVEND'										, ; //CHAVE
	'Competencia + Vendedor'												, ; //DESCRICAO
	'Competencia + Vendedor'												, ; //DESCSPA
	'Competencia + Vendedor'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ4
//
aAdd( aSIX, { ;
	'SZ4'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z4_FILIAL+Z4_TIPO+Z4_ORDEM'											, ; //CHAVE
	'Tipo + Ordem'															, ; //DESCRICAO
	'Tipo + Ordem'															, ; //DESCSPA
	'Tipo + Ordem'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ5
//
aAdd( aSIX, { ;
	'SZ5'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z5_FILIAL+Z5_CODIGO'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ5'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z5_FILIAL+Z5_NOME'														, ; //CHAVE
	'Montador'																, ; //DESCRICAO
	'Montador'																, ; //DESCSPA
	'Montador'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZ6
//
aAdd( aSIX, { ;
	'SZ6'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z6_FILIAL+Z6_CODCOMP'													, ; //CHAVE
	'Codigo Competencia'													, ; //DESCRICAO
	'Codigo Competencia'													, ; //DESCSPA
	'Codigo Competencia'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela Z01
//
aAdd( aSIX, { ;
	'Z01'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z01_FILIAL+Z01_COD'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela Z02
//
aAdd( aSIX, { ;
	'Z02'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z02_FILIAL+Z02_FORMA'													, ; //CHAVE
	'Forma Pgto.'															, ; //DESCRICAO
	'Forma Pgto.'															, ; //DESCSPA
	'Forma Pgto.'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z02'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z02_FILIAL+Z02_BANCO+Z02_AGENCI+Z02_NUMCON'							, ; //CHAVE
	'Banco + Agencia + Cta.Coorente'										, ; //DESCRICAO
	'Banco + Agencia + Cta.Coorente'										, ; //DESCSPA
	'Banco + Agencia + Cta.Coorente'										, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela Z03
//
aAdd( aSIX, { ;
	'Z03'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z03_FILIAL+Z03_COD'													, ; //CHAVE
	'Codigo'																, ; //DESCRICAO
	'Codigo'																, ; //DESCSPA
	'Codigo'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z03'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z03_FILIAL+Z03_DESC'													, ; //CHAVE
	'Descricao'																, ; //DESCRICAO
	'Descricao'																, ; //DESCSPA
	'Descricao'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z03'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'Z03_FILIAL+Z03_SX1'													, ; //CHAVE
	'Perg. SX1'																, ; //DESCRICAO
	'Perg. SX1'																, ; //DESCSPA
	'Perg. SX1'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela Z04
//
aAdd( aSIX, { ;
	'Z04'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z04_FILIAL+Z04_ENTFIL'													, ; //CHAVE
	'Filial Entid'															, ; //DESCRICAO
	'Filial Entid'															, ; //DESCSPA
	'Filial Entid'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z04'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z04_FILIAL+Z04_ENTALI'													, ; //CHAVE
	'Alias Entid.'															, ; //DESCRICAO
	'Alias Entid.'															, ; //DESCSPA
	'Alias Entid.'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z04'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'Z04_FILIAL+Z04_CHVPK'													, ; //CHAVE
	'Chave PK'																, ; //DESCRICAO
	'Chave PK'																, ; //DESCSPA
	'Chave PK'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z04'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'Z04_FILIAL+Z04_ENTPK'													, ; //CHAVE
	'Chave Entid.'															, ; //DESCRICAO
	'Chave Entid.'															, ; //DESCSPA
	'Chave Entid.'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela Z31
//
aAdd( aSIX, { ;
	'Z31'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z31_FILIAL+Z31_NUM+Z31_SERIE+Z31_CNPJFO'								, ; //CHAVE
	'Z31_FILIAL+Z31_NUM+Z31_SERIE+Z31_CNPJFO'								, ; //DESCRICAO
	'Z31_FILIAL+Z31_NUM+Z31_SERIE+Z31_CNPJFO'								, ; //DESCSPA
	'Z31_FILIAL+Z31_NUM+Z31_SERIE+Z31_CNPJFO'								, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z31'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z31_FILIAL+ Z31_CHAVE'													, ; //CHAVE
	'Z31_FILIAL+ Z31_CHAVE'													, ; //DESCRICAO
	'Z31_FILIAL+ Z31_CHAVE'													, ; //DESCSPA
	'Z31_FILIAL+ Z31_CHAVE'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela Z32
//
aAdd( aSIX, { ;
	'Z32'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z32_FILIAL+Z32_CHAVE+Z32_LJDEST+Z32_PEDIDO'							, ; //CHAVE
	'CHAVE DANFE+LJ. DESTINO+NUM.PEDIDO'									, ; //DESCRICAO
	'CHAVE DANFE+LJ. DESTINO+NUM.PEDIDO'									, ; //DESCSPA
	'CHAVE DANFE+LJ. DESTINO+NUM.PEDIDO'									, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z32'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z32_FILIAL+Z32_CHAVE'													, ; //CHAVE
	'FILIAL+CHAVE DANFE'													, ; //DESCRICAO
	'FILIAL+CHAVE DANFE'													, ; //DESCSPA
	'FILIAL+CHAVE DANFE'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela Z34
//
aAdd( aSIX, { ;
	'Z34'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z34_FILIAL+Z34_PEDIDO+Z34_CHAVE'										, ; //CHAVE
	'NUM.PEDIDO+CHAVE DANFE'												, ; //DESCRICAO
	'NUM.PEDIDO+CHAVE DANFE'												, ; //DESCSPA
	'NUM.PEDIDO+CHAVE DANFE'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z34'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z34_FILIAL+Z34_ITEM+Z34_COD'											, ; //CHAVE
	'Num.Item+Cod.Prod'														, ; //DESCRICAO
	'Num.Item+Cod.Prod'														, ; //DESCSPA
	'Num.Item+Cod.Prod'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z34'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'Z34_FILIAL+Z34_CHAVE'													, ; //CHAVE
	'FILIAL+CHAVE'															, ; //DESCRICAO
	'FILIAL+CHAVE'															, ; //DESCSPA
	'FILIAL+CHAVE'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'Z34'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'Z34_FILIAL+Z34_ITEM+Z34_PEDPRO+Z34_CHAVE'								, ; //CHAVE
	'Filal+Item+Produto+Chave'												, ; //DESCRICAO
	'Filal+Item+Produto+Chave'												, ; //DESCSPA
	'Filal+Item+Produto+Chave'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZAA
//
aAdd( aSIX, { ;
	'ZAA'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZAA_FILIAL+ZAA_ZZCODF+ZAA_ZZLOJA'										, ; //CHAVE
	'INDICE PERCENTUAL ACEITE'												, ; //DESCRICAO
	'INDICE PERCENTUAL ACEITE'												, ; //DESCSPA
	'INDICE PERCENTUAL ACEITE'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Tabela ZK0
//
aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_COD'													, ; //CHAVE
	'Código'																, ; //DESCRICAO
	'Código'																, ; //DESCSPA
	'Código'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_CARGA'													, ; //CHAVE
	'Carga'																	, ; //DESCRICAO
	'Carga'																	, ; //DESCSPA
	'Carga'																	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_PROD+ZK0_COD'											, ; //CHAVE
	'Produto+Código'														, ; //DESCRICAO
	'Produto+Código'														, ; //DESCSPA
	'Produto+Código'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_CLI+ZK0_LJCLI'											, ; //CHAVE
	'Cliente+Loja Cliente'													, ; //DESCRICAO
	'Cliente+Loja Cliente'													, ; //DESCSPA
	'Cliente+Loja Cliente'													, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_NUMSAC'													, ; //CHAVE
	'Num.SAC'																, ; //DESCRICAO
	'Num.SAC'																, ; //DESCSPA
	'Num.SAC'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'ZK0'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'ZK0_FILIAL+ZK0_PEDORI'													, ; //CHAVE
	'Pedido Origi'															, ; //DESCRICAO
	'Pedido Origi'															, ; //DESCSPA
	'Pedido Origi'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
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

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

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
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDSIX01" ) ) ) ;
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
