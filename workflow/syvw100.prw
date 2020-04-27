#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYVW100  ºAutor  ³ Symm Consultoria   º Data ³  18/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia WKF para o responsável tecnico.                       º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SYVW100( cAtende )

Local oProcess
Local oHTML
Local cTime	   := Time()
Local cHora	   := Substr(cTime,1,2) + Substr(cTime,4,2) + Substr(cTime,7,2)
Local cTo      := ""
Local nVlrTot  := 0
Local cPath	   := GetMV("MV_CSREPOR",,"workflow\report\")
Local cReport  := cEmpAnt + "-" + DTOS(ddatabase) + "-" + cHora + "-orcamento.htm"

DbSelectArea("SUA")
DbSetOrder(1)
DbSeek(xFilial("SUA")+cAtende)
If SUA->UA_OPER=="2"
	Return
Endif

RecLock("SUA",.F.)
SUA->UA_ENWKFRT :='1'
Msunlock()

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SUA->UA_CLIENTE + SUA->UA_LOJA )

DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3")+SUA->UA_VEND1 )
cTo := GetMv("MV_SYENVRT",,"eduardopatriani@uol.com.br")	//Alltrim(SA3->A3_EMAIL)

DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial("SE4")+SUA->UA_CONDPG )

oProcess := TWFProcess():New( "000001", "Notificacao - Acompanhamento do Pedido pelo Responsavel Tecnico" )
oProcess:NewTask( "Envio de Notificacao de RT", "\workflow\orcamento.htm" )
oProcess:cSubject := "Envio de Notificacao de RT"
oProcess:cTo := cTo
oProcess:NewVersion(.T.)

oHtml := oProcess:oHTML

//Cabecalho
oHtml:ValByName( "CPEDIDO"		, SUA->UA_NUM )
oHtml:ValByName( "CODCLI"		, SA1->A1_COD+'-'+SA1->A1_LOJA )
oHtml:ValByName( "CLIENTE"		, SA1->A1_NOME )
oHtml:ValByName( "ENDERECO"		, SA1->A1_END )
oHtml:ValByName( "MUNICIPIO"	, SA1->A1_MUN )
oHtml:ValByName( "ESTADO"		, SA1->A1_EST )
oHtml:ValByName( "INSCR_EST"	, SA1->A1_INSCR )
oHtml:ValByName( "COND_PGTO"	, SE4->E4_COND )
oHtml:ValByName( "NOME_TEC"		, SA3->A3_NOME )
oHtml:ValByName( "NOME_VEND"	, RTrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")) )
oHtml:ValByName( "CGC_CPF"		, SA1->A1_CGC )

DbSelectArea("SUB")
DbSetOrder(1)
DbSeek(xFilial("SUB") + SUA->UA_NUM )
While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB") + SUA->UA_NUM 

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + SUB->UB_PRODUTO ))
	
	AAdd( (oHtml:ValByName( "T.1" )), SUB->UB_ITEM 		)	
	AAdd( (oHtml:ValByName( "T.2" )), SUB->UB_PRODUTO 	)
	AAdd( (oHtml:ValByName( "T.3" )), SB1->B1_DESC 		)
	AAdd( (oHtml:ValByName( "T.4" )), SUB->UB_UM 		)
	AAdd( (oHtml:ValByName( "T.5" )), Transform(SUB->UB_QUANT	,'@E 999,999.99') )
	AAdd( (oHtml:ValByName( "T.6" )), Transform(SUB->UB_VRUNIT	,'@E 999,999.99') )
	AAdd( (oHtml:ValByName( "T.7" )), Transform(SUB->UB_VLRITEM,'@E 999,999.99') )
	
	nVlrTot += SUB->UB_VLRITEM
	
	DbSelectArea("SUB")
	dbSkip()
EndDo

oHtml:ValByName( "lbl_total" ,TRANSFORM( nVlrTot , '@E 999,999.99' ) )

oProcess:ClientName( Subs(cUsuario,7,15) )

oHTML:SaveFile(cPath+cReport)

// Inicia Processo
oProcess:Start()
                   
Return