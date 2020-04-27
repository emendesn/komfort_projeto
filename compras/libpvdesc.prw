#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBPVDESC ºAutor  ³ Cristiam Rossi     º Data ³  21/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Liberação de Pedidos de Vendas Bloqueados por    º±±
±±º          ³ ultrapassar o parâmetro GL_MAXDESC                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL / KOMFORTHOUSE                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function libPVdesc( lAuto, cNumPV, cAcao, cUser )
Local   aArea     := getArea()
Local   cFilQuery := " C5_XLIBER='B' and C5_XLIBUSR='' "
Local   xRet      := .F.
Private cCadastro := "Pedidos de Venda Bloqueados por Desconto excessivo"
Private aRotina   := {}
Private bLibera   := {|| manutLib('L')}
Private bBloqueia := {|| manutLib('B')}
Private xUser
Default lAuto     := .F.
Default cNumPV    := ""
Default cAcao     := ""
Default cUser     := cUserName

	xUser := cUser

	if lAuto
		SC5->( dbSetOrder(1) )
		if ! empty( cNumPV ) .and. SC5->( dbSeek( xFilial("SC5") + cNumPV ) )
			if SC5->C5_XLIBER=='B' .and. empty(SC5->C5_XLIBUSR)
				manutLib( cAcao, lAuto )
				xRet := .T.
			else
				conout("PV: "+cNumPV+" ja "+iif(SC5->C5_XLIBER=="B","Bloqueado","Liberado")+" - "+DtoC(Date())+" "+Time() )
			endif
		else
			conout("PV: "+cNumPV+" nao encontrado - "+DtoC(Date())+" "+Time() )
		endif
		restArea( aArea )
		return xRet
	endif

	chkParam()

	aadd( aRotina, { "Pesquisar" ,"AxPesqui"       ,0,1,0 ,.F.})
	aadd( aRotina, { "Visualizar","A410Visual"     ,0,2,0 ,NIL})
	aadd( aRotina, { "Liberar"   ,"eval(bLibera)"  ,0,4,0 ,NIL})
	aadd( aRotina, { "Bloquear"  ,"eval(bBloqueia)",0,4,0 ,NIL})

	dbSelectArea("SC5")

	mBrowse( 6, 1,22,75,"SC5",,,,,,,,,,,,,,cFilQuery)

	restArea( aArea )
Return nil


//----------------
Static Function manutLib( cAcao, lAuto )
Local   xRet  := nil
Private cObs  := ""
Default lAuto := .F.

	if lAuto .or. Aviso(iif(cAcao="L","Liberação","Bloqueio")+" de Pedidos", "Você confirma a "+iif(cAcao="L","Liberação","Bloqueio")+" do Pedido selecionado?", {"Sim", "Não"}) == 1
		if ! getObs( iif(cAcao="L","Liberação","Bloqueio")+" de Pedidos" )
			msgStop("Processo cancelado pelo usuário", iif(cAcao="L","Liberação","Bloqueio")+" de Pedidos" )
		else
			recLock("SC5", .F.)
			SC5->C5_XLIBER  := cAcao
			SC5->C5_XLIBDH  := DtoC(Date()) + " " + Time()
			SC5->C5_XLIBUSR := xUser
			SC5->C5_XLIBOBS := alltrim( cObs )

			dbCommit()
			msUnlock()

			envMail()

			xRet := 1
		endif
	endif

return xRet


//----------------
Static Function chkParam()

	if ! SX6->( dbSeek( xFilial("SX6") + "GL_MAXDESC" ) )
		recLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "GL_MAXDESC"
		SX6->X6_TIPO    := "N"
		SX6->X6_DESCRIC := "Percentual max. desconto por item PV s/ bloqueio"
		SX6->X6_DSCSPA  := SX6->X6_DESCRIC
		SX6->X6_DSCENG  := SX6->X6_DESCRIC
		SX6->X6_CONTEUD := "70"
		SX6->X6_CONTSPA := SX6->X6_CONTEUD
		SX6->X6_CONTENG := SX6->X6_CONTEUD
		SX6->X6_PROPRI  := "U"
		msUnlock()
	endif

	if ! SX6->( dbSeek( xFilial("SX6") + "GL_APRMAIL" ) )
		recLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "GL_APRMAIL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "E-mail aprovador de PV c/ desc. excedente"
		SX6->X6_DSCSPA  := SX6->X6_DESCRIC
		SX6->X6_DSCENG  := SX6->X6_DESCRIC
		SX6->X6_CONTEUD := "luciana.milanelli@komforthouse.com.br"
		SX6->X6_CONTSPA := SX6->X6_CONTEUD
		SX6->X6_CONTENG := SX6->X6_CONTEUD
		SX6->X6_PROPRI  := "U"
		msUnlock()
	endif

return nil


//------------------------------------------
Static Function getObs( cTitulo )
Local oDlg
Local lOk   := .F.
Local oGET

	define msDialog oDlg Title cTitulo from 0,0 to 200, 420 pixel

	@ 5 ,5 say "Observações:" of oDlg Pixel
	@ 17,5 Get oGET Var cObs MEMO HSCROLL Size 204,60 of oDlg Pixel

	tButton():New(80,120,'Confirmar',oDlg,{|| lOk := .T., oDlg:End()},40,16,,,,.T.)
	tButton():New(80,170,'Sair'     ,oDlg,{||oDlg:End()},40,16,,,,.T.) 

	Activate msDialog oDlg Centered

return lOk


//-----------------------------------------
Static Function envMail()
Local cEmail   := ""
Local cMsg     := ""
Local cSuper   := ""
Local cMailSup := ""
Local cAssunto := ""
Local aArea    := getArea()

	SA3->( dbSetOrder(1) )
	if SA3->( dbSeek( xFilial("SA3") + SC5->C5_VEND1 ))
		if ! empty( SA3->A3_CODUSR)
			cEmail := alltrim( UsrRetMail( SA3->A3_CODUSR ) )
		endif

		cSuper := SA3->A3_GRPREP
		if !empty(cSuper)
			ACA->( dbSetOrder(1) )
			if ACA->( dbSeek( xFilial("ACA") + cSuper ) )
				cMailSup := UsrRetMail( ACA->ACA_USRESP )
				if ! empty( cMailSup )
					cEmail += iif(empty(cEmail),"",";") + alltrim(cMailSup)
				endif

				if !empty( ACA->ACA_GRPSUP )
					if ACA->( dbSeek( xFilial("ACA") + ACA->ACA_GRPSUP ) )
						cMailSup := UsrRetMail( ACA->ACA_USRESP )
						if ! empty( cMailSup )
							cEmail += iif(empty(cEmail),"",";") + alltrim(cMailSup)
						endif
					endif
					
				endif
			endif
		endif

		cMsg := u_formWSPV( .F., .T. /*lVisual*/ )

		cAssunto  := "Retorno do Aprovador - PV: " + SC5->C5_NUM
		U_sendMail( cEmail, cAssunto, cMsg )
	endif

	restArea( aArea )
return nil