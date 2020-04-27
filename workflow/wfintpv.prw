#include "totvs.ch"
#include "apwebex.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFINTPV   ºAutor  ³Cristiam Rossi      º Data ³  07/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow integração com PV. Bloqueio de Entrega por conta  º±±
±±º          ³ de Desconto superior ao parâmetro GL_MAXDESC               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Komfort House / GLOBAL                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFintPV( lWEB, cPedPar )
Local   cHTML    := ""
Private xURL     := "http://177.190.192.187:6592/wf/"		// nao trocar por MV_ pois vai dar erro quand chamado diretamente pelo WS
Private cEMPRESA := HttpPost->empresa
Private wFILIAL  := HttpPost->filial
Private cPEDIDO  := HttpPost->pedido
Private wUser    := HttpPost->usuario
Private cRESULT  := HttpPost->resultado
Private wOBS     := HttpPost->obsaprov

Default cEMPRESA := HttpGet->empresa
Default WFILIAL  := HttpGet->filial
Default cPEDIDO  := HttpGet->pedido
Default wUser    := HttpGet->usuario
Default cRESULT  := HttpGet->resultado
Default wOBS     := HttpGet->obsaprov

Default cEMPRESA := "01"
Default WFILIAL  := "0101"

Default lWEB     := .T.
Default cPedPar  := ""

	if lWEB
		PrepEnv()	// Inicia ambiente
	else
		cEMPRESA := cEmpAnt
		WFILIAL  := cFilAnt
		cPEDIDO  := cPedPar
	endif

//	WEB EXTENDED INIT cHTML

	if empty( cPEDIDO )
		cHTML := "<h1>Favor informar um pedido de vendas</h1>"
	elseif ! empty( cRESULT )
		cHTML := gravar( cPEDIDO )
	else
		cHtml := u_formWSPV( lWEB, nil, cPEDIDO )
	endif

//	WEB EXTENDED END

Return cHTML



//---------------------------------------
Static Function gravar( cPEDIDO )
Local cHtml    := "<h2>Falha no Processo</h2>"
Local cEmail   := ""
Local cMailSup := ""

	if chkFile("SC5")
		SC5->( dbSetOrder(1) )
		if SC5->( dbSeek( xFilial("SC5") + cPEDIDO ) )
			recLock("SC5", .F.)
			SC5->C5_XLIBER  := iif(cRESULT=="SIM","L","B")
			SC5->C5_XLIBDH  := DtoC(Date()) + " " + Time()
			SC5->C5_XLIBUSR := wUser
			SC5->C5_XLIBOBS := wOBS

			SC5->( msUnlock() )

			SA3->( dbSetOrder(1) )
			if SA3->( dbSeek( xFilial("SA3") + SC5->C5_VEND1 ))
/*
				if ! empty( SA3->A3_EMAIL )
					cEmail := alltrim(SA3->A3_EMAIL)
				endif
				cSuper := SA3->A3_SUPER
				cGeren := SA3->A3_GEREN
*/
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

				cMsg := u_formWSPV( .F., .T. /*lVisual*/ ,cPEDIDO)

				cAssunto  := "Retorno do Aprovador - PV: " + SC5->C5_NUM
				U_sendMail( cEmail, cAssunto, cMsg )

				cHtml := "<h2>Processo finalizado</h2>"
			endif
		endif
	endif
	
return cHtml

//---------------------------------------
Static Function PrepEnv()
	RPCSetType(3)
	Prepare Environment Empresa cEMPRESA Filial WFILIAL
Return nil


//---------------------------------------
User Function formWSPV(lWEB, lVisual, cPEDIDO)
Local   cHtml    := ""
Local   lOK      := .F.
Local   nMAXdesc := getMV("GL_MAXDESC")
Local   cAprUser := ""
Local   cNomVend := ""
Local   cGeren   := ""
Default lVisual  := .F.
Default cPEDIDO  := ""

	if empty( cPEDIDO )
		return "<h2>Pedido Não Informado</h2>"
	endif

	if chkFile("SC5")
		SC5->( dbSetOrder(1) )
		if SC5->( dbSeek( xFilial("SC5") + cPEDIDO ) )
			lOK := .T.
		endif
	endif

	if ! lOK
		return "<h2>Não encontrado Pedido de vendas: "+ cPEDIDO +"</h2>"
	endif

	SA3->( dbSetOrder(1) )
	if SA3->( dbSeek( xFilial("SA3") + SC5->C5_VEND1 ) )
		cNomVend := alltrim( iif( !empty(SA3->A3_NOME), SA3->A3_NOME, SA3->A3_NREDUZ ) ) 
	endif

	if lWEB
		cHtml := CgTempl()
	else

		cHtml := "<strong>Orçamento: </strong>"+SC5->C5_ORCRES+"<br />"
		cHtml += "<strong>Pedido: </strong>"+SC5->C5_NUM+"<br />"
		cHtml += "<strong>Data da Venda: </strong>"+DtoC( SC5->C5_EMISSAO )+"<br />"
		cHtml += "<strong>Vendedor: </strong>"+cNomVend+"<br />"
		cHtml += "<br />"
		cHtml += "<a href='#URL'>Clique AQUI para "+ iif( lVisual, "Visualizar","Aprovar ou Reprovar" ) + "</a>"
		cHtml := Strtran( cHtml, "#URL" , xURL+"u_WFintPV.apw?empresa="+cEmpAnt+"&filial="+cFilAnt+"&pedido="+SC5->C5_NUM )

		return cHtml
	endif

	cAprUser := superGetMV( "GL_APRUSER", , "KHALED" )
	cHtml    := Strtran( cHtml, "#USER" , cAprUser )


	aAreaSM0 := SM0->( getArea() )
	SM0->( dbSetOrder(1) )
	if SM0->( dbSeek( cEmpAnt + cFilAnt /*SC5->C5_FILIAL*/ ) )
		cHtml := Strtran( cHtml, "#LOJA" , SM0->M0_FILIAL )
	endif
	SM0->( restArea( aAreaSM0 ) )

	SUA->( dbSetOrder(1) )
	if SUA->( dbSeek( xFilial("SUA") + SC5->C5_NUMTMK ) )
		cHtml := Strtran( cHtml, "#FORMAPGTO" , SUA->UA_FORMPG )
		cHtml := Strtran( cHtml, "#PARCELAS"  , cValToChar(SUA->UA_PARCELA)+" parcela"+iif(SUA->UA_PARCELA>1, "s", "" ) )
		cHtml := Strtran( cHtml, "#OBSCOML"   , alltrim( strtran(SUA->UA_OBSFOLL , CRLF, "<br />" ) ) )
	endif

	cHtml := Strtran( cHtml, "#MAXDESC"  , cValToChar(nMAXdesc) )
	cHtml := Strtran( cHtml, "#ORCAMENTO", SC5->C5_ORCRES )
	cHtml := Strtran( cHtml, "#PEDIDO"   , SC5->C5_NUM )
	cHtml := Strtran( cHtml, "#CLIENTE"  , Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME" ) )
	cHtml := Strtran( cHtml, "#CPFCNPJ"  , transform( SA1->A1_CGC, iif( len(alltrim(SA1->A1_CGC)) < 14 , "@R 999.999.999-99", "@R99.999.999/9999-99") ) )
	cHtml := Strtran( cHtml, "#DTVENDA"  , DtoC( SC5->C5_EMISSAO ) )
	cHtml := Strtran( cHtml, "#OBSPV"    , MSMM(SC5->C5_XCODOBS,43) )

	cHtml  := Strtran( cHtml, "#VENDEDOR", cNomVend )
	cSuper := SA3->A3_GRPREP // SA3->A3_SUPER
//	cGeren := SA3->A3_UNIDAD // SA3->A3_GEREN
	if ! empty( cSuper )
		ACA->( dbSetOrder(1) )
		if ACA->( dbSeek( xFilial("ACA") + cSuper ) )
			cSuper := ACA->ACA_USRESP
			cGeren := ACA->ACA_GRPSUP
		endif

//		cHtml := Strtran( cHtml, "#SUPERVISOR", Posicione("SA3",1,xFilial("SA3")+cSuper, "A3_NOME" ) )
		cHtml := Strtran( cHtml, "#GERENTE"   , UsrFullName(cSuper) )
		if empty( cGeren )
			cGeren := cSuper // SA3->A3_SUPER
		endif
	endif
	if ! empty( cGeren )
		ACA->( dbSetOrder(1) )
		if ACA->( dbSeek( xFilial("ACA") + cGeren ) )
			cGeren := ACA->ACA_USRESP
		endif
//		cHtml := Strtran( cHtml, "#GERENTE"   , Posicione("SA3",1,xFilial("SA3")+cGeren, "A3_NOME" ) )
		cHtml := Strtran( cHtml, "#SUPERVISOR", UsrFullName(cGeren) )
	endif

	if ! empty(SC5->C5_XLIBER) .and. ! empty( SC5->C5_XLIBDH )		// ajuste para visualizar o PV
		lWEB    := .F.
		lVisual := .T.
	endif

	if ! lWEB
		nPos1 := AT("<form" , cHtml)
		nPos2 := AT("</form", cHtml)

		if nPos1 > 0 .and. nPos2 > 0
			if lVisual
/*				cHtml := left(cHtml, nPos1-1) + ;
							"<td align='center'><h2>"+iif(SC5->C5_XLIBER=="L","LIBERADO","BLOQUEADO")+"</h2><br />" + ;
							strTran(SC5->C5_XLIBOBS,CRLF,"<br />") + "</td>" + ;
							substr(cHtml, nPos2+7 )
*/
				cHtml := left(cHtml, nPos1-1) + ;
							"<center><h2>"+iif(SC5->C5_XLIBER=="L","LIBERADO","BLOQUEADO")+"</h2><br />" + ;
							strTran(SC5->C5_XLIBOBS,CRLF,"<br />") + "</center>" + ;
							substr(cHtml, nPos2+7 )

			else
				cHtml := left(cHtml, nPos1-1) + ;
							"<a href='#URL'>Clique AQUI para Aprovar ou Reprovar</a>" + ;
							substr(cHtml, nPos2+7 )
			endif
		endif
	endif

	cHtml := Strtran( cHtml, "#ITENS" , fItens() )

	cHtml := Strtran( cHtml, "#URL" , xURL+"u_WFintPV.apw?empresa="+cEmpAnt+"&filial="+cFilAnt+"&pedido="+SC5->C5_NUM )

return cHtml


//---------------------------------------------------------------------------------------
Static Function CgTempl()
Local cHtml    := ""
Local cArquivo := "\workflow\aprovPV.html"
Local nHandle
Local nReadTot := 0
Local nTotal, nRead, nBuffer, cBuffer, cRetorno

	if file(cArquivo)

		nHandle := fOpen( cArquivo )
		If nHandle == -1
			cHtml += "Erro de abertura : FERROR "+cValToChar(fError())
			cHtml += "<br />Arquivo: "+ cArquivo
		else

			nTotal  := FSeek( nHandle, 0, 2 )
			nBuffer := Min( 50*1024, nTotal )
			FSeek( nHandle, 0, 0)

			while nReadTot < nTotal
				cBuffer  := Space(nBuffer)
				nRead    := FRead(nHandle,@cBuffer,nBuffer)
				nReadTot += nRead
				cHtml    += cBuffer
			end
		endif

		fClose(nHandle)

		cHtml := Strtran( cHtml, "#EMPRESA", cEmpAnt )
		cHtml := Strtran( cHtml, "#FILIAL" , cFilAnt )

	else
		cHtml += "arquivo template \workflow\aprovPV.html não encontrado!"
	endif

Return cHtml


//-------------------------------------------------------------
Static Function fItens()
Local cHtml    := ""
Local aArea    := getArea()
Local aAreaSC6 := SC6->( getArea() )
Local nPrcFim  := 0
Local lPar     := .F.

	SC6->( dbSetOrder(1) )
	SC6->( dbSeek( SC5->( C5_FILIAL + C5_NUM ), .T. ) )
	while ! SC6->( EOF() ) .and. SC5->( C5_FILIAL + C5_NUM ) == SC6->( C6_FILIAL + C6_NUM )
/*
		cHtml += "<tr>"
		cHtml += "<td"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ SC6->C6_PRODUTO +"</td>"
		cHtml += "<td"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ SC6->C6_DESCRI +"</td>"
		cHtml += "<td align='right'"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ cValToChar(SC6->C6_QTDVEN) +"</td>"
		cHtml += "<td align='right'"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ transform(SC6->C6_PRUNIT,  "@E 999,999,999,999.99") +"</td>"
		cHtml += "<td align='right'"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ transform(SC6->C6_PRCVEN,  "@E 999,999,999,999.99") +"</td>"
		cHtml += "<td align='right'"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ transform(SC6->C6_DESCONT, "@E 9,999.99") +"%</td>"
		cHtml += "<td align='center'"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ DtoC(SC6->C6_ENTREG) +"</td>"
		cHtml += "<td"+iif(lPar," style='background-color: #EDF2F6;'","")+">"+ iif(SC6->C6_MOSTRUA=="1", "Novo", "Mostruário") +"</td>"
		cHtml += "</tr>"
*/
		cHtml += '<div style="display: table-row">'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">'+SC6->C6_PRODUTO+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">'+SC6->C6_DESCRI+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right">'+cValToChar(SC6->C6_QTDVEN)+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right">'+transform(SC6->C6_PRUNIT,  "@E 999,999,999,999.99")+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right">'+transform(SC6->C6_VALDESC, "@E 999,999,999,999.99")+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right">'+transform(SC6->C6_PRCVEN,  "@E 999,999,999,999.99")+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right">'+transform(SC6->C6_DESCONT, "@E 9,999.99")+'%</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:center">'+DtoC(SC6->C6_ENTREG)+'</div>'
		cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">'+iif(SC6->C6_MOSTRUA=="1", "Novo", "Mostruário")+'</div>'
		cHtml += '</div>'

		nPrcFim += SC6->C6_PRCVEN
		lPar  := ! lPar

		SC6->( dbSkip() )
	end
/*
	cHtml += "<tr>"
	cHtml += "<td colspan='4'></td>"
	cHtml += "<td align='right'"+iif(lPar," style='background-color: #EDF2F6;'","")+"><strong>"+ transform(nPrcFim,  "@E 999,999,999,999.99") +"</strong></td>"
	cHtml += "<td colspan='3'></td>"
	cHtml += "</tr>"
*/
	cHtml += '<div style="display: table-row">'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'; text-align:right"><strong>'+transform(nPrcFim,  "@E 999,999,999,999.99")+'</strong></div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '<div style="display: table-cell; padding: 3px 10px; background-color: '+iif(lPar,"#EDF2F6","#FFFFFF")+'">&nbsp;</div>'
	cHtml += '</div>'


	SC6->( restArea( aAreaSC6 ) )
	restArea( aArea )
return cHtml
