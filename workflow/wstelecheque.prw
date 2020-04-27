#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx?WSDL
Gerado em        09/16/16 09:46:38
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _OIVSXCD ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWeb_x0020_Service_x0020_-_x0020_Autorizador_x0020_Telecheque_x0020_
------------------------------------------------------------------------------- */

WSCLIENT WsConsultaCH

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD AnalisaCompra
	WSMETHOD AnalisaProposta
	WSMETHOD CancelaProposta
	WSMETHOD ConsultaSituacaoProposta
	WSMETHOD EfetivacaoProposta
	WSMETHOD ConfirmaDadosCompra
	WSMETHOD ConsultaServico
	WSMETHOD MetodoTesteBancoAtendendo_In_Out_PXML

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cp_xml                    AS string
	WSDATA   cAnalisaCompraResult      AS string
	WSDATA   cAnalisaPropostaResult    AS string
	WSDATA   cCancelaPropostaResult    AS string
	WSDATA   cConsultaSituacaoPropostaResult AS string
	WSDATA   cEfetivacaoPropostaResult AS string
	WSDATA   cConfirmaDadosCompraResult AS string
	WSDATA   ccodigo_acesso            AS string
	WSDATA   csenha_acesso             AS string
	WSDATA   cservico                  AS string
	WSDATA   cConsultaServicoResult    AS string
	WSDATA   cMetodoTesteBancoAtendendo_In_Out_PXMLResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WsConsultaCH
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160510 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WsConsultaCH
Return

WSMETHOD RESET WSCLIENT WsConsultaCH
	::cp_xml             := NIL 
	::cAnalisaCompraResult := NIL 
	::cAnalisaPropostaResult := NIL 
	::cCancelaPropostaResult := NIL 
	::cConsultaSituacaoPropostaResult := NIL 
	::cEfetivacaoPropostaResult := NIL 
	::cConfirmaDadosCompraResult := NIL 
	::ccodigo_acesso     := NIL 
	::csenha_acesso      := NIL 
	::cservico           := NIL 
	::cConsultaServicoResult := NIL 
	::cMetodoTesteBancoAtendendo_In_Out_PXMLResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WsConsultaCH
Local oClone := WsConsultaCH():New()
	oClone:_URL          := ::_URL 
	oClone:cp_xml        := ::cp_xml
	oClone:cAnalisaCompraResult := ::cAnalisaCompraResult
	oClone:cAnalisaPropostaResult := ::cAnalisaPropostaResult
	oClone:cCancelaPropostaResult := ::cCancelaPropostaResult
	oClone:cConsultaSituacaoPropostaResult := ::cConsultaSituacaoPropostaResult
	oClone:cEfetivacaoPropostaResult := ::cEfetivacaoPropostaResult
	oClone:cConfirmaDadosCompraResult := ::cConfirmaDadosCompraResult
	oClone:ccodigo_acesso := ::ccodigo_acesso
	oClone:csenha_acesso := ::csenha_acesso
	oClone:cservico      := ::cservico
	oClone:cConsultaServicoResult := ::cConsultaServicoResult
	oClone:cMetodoTesteBancoAtendendo_In_Out_PXMLResult := ::cMetodoTesteBancoAtendendo_In_Out_PXMLResult
Return oClone

// WSDL Method AnalisaCompra of Service WsConsultaCH

WSMETHOD AnalisaCompra WSSEND cp_xml WSRECEIVE cAnalisaCompraResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AnalisaCompra xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</AnalisaCompra>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/AnalisaCompra",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cAnalisaCompraResult :=  WSAdvValue( oXmlRet,"_ANALISACOMPRARESPONSE:_ANALISACOMPRARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AnalisaProposta of Service WsConsultaCH

WSMETHOD AnalisaProposta WSSEND cp_xml WSRECEIVE cAnalisaPropostaResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AnalisaProposta xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</AnalisaProposta>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/AnalisaProposta",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://www14.telecheque.com.br/wsautorizador/wsautorizador.asmx")

//	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cAnalisaPropostaResult :=  WSAdvValue( oXmlRet,"_ANALISAPROPOSTARESPONSE:_ANALISAPROPOSTARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelaProposta of Service WsConsultaCH

WSMETHOD CancelaProposta WSSEND cp_xml WSRECEIVE cCancelaPropostaResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelaProposta xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</CancelaProposta>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/CancelaProposta",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cCancelaPropostaResult :=  WSAdvValue( oXmlRet,"_CANCELAPROPOSTARESPONSE:_CANCELAPROPOSTARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultaSituacaoProposta of Service WsConsultaCH

WSMETHOD ConsultaSituacaoProposta WSSEND cp_xml WSRECEIVE cConsultaSituacaoPropostaResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultaSituacaoProposta xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConsultaSituacaoProposta>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/ConsultaSituacaoProposta",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cConsultaSituacaoPropostaResult :=  WSAdvValue( oXmlRet,"_CONSULTASITUACAOPROPOSTARESPONSE:_CONSULTASITUACAOPROPOSTARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EfetivacaoProposta of Service WsConsultaCH

WSMETHOD EfetivacaoProposta WSSEND cp_xml WSRECEIVE cEfetivacaoPropostaResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EfetivacaoProposta xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</EfetivacaoProposta>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/EfetivacaoProposta",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cEfetivacaoPropostaResult :=  WSAdvValue( oXmlRet,"_EFETIVACAOPROPOSTARESPONSE:_EFETIVACAOPROPOSTARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConfirmaDadosCompra of Service WsConsultaCH

WSMETHOD ConfirmaDadosCompra WSSEND cp_xml WSRECEIVE cConfirmaDadosCompraResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConfirmaDadosCompra xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConfirmaDadosCompra>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/ConfirmaDadosCompra",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cConfirmaDadosCompraResult :=  WSAdvValue( oXmlRet,"_CONFIRMADADOSCOMPRARESPONSE:_CONFIRMADADOSCOMPRARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultaServico of Service WsConsultaCH

WSMETHOD ConsultaServico WSSEND ccodigo_acesso,csenha_acesso,cservico,cp_xml WSRECEIVE cConsultaServicoResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultaServico xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("codigo_acesso", ::ccodigo_acesso, ccodigo_acesso , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("senha_acesso", ::csenha_acesso, csenha_acesso , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("servico", ::cservico, cservico , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ConsultaServico>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/ConsultaServico",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cConsultaServicoResult :=  WSAdvValue( oXmlRet,"_CONSULTASERVICORESPONSE:_CONSULTASERVICORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method MetodoTesteBancoAtendendo_In_Out_PXML of Service WsConsultaCH

WSMETHOD MetodoTesteBancoAtendendo_In_Out_PXML WSSEND cp_xml WSRECEIVE cMetodoTesteBancoAtendendo_In_Out_PXMLResult WSCLIENT WsConsultaCH
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MetodoTesteBancoAtendendo_In_Out_PXML xmlns="http://autorizador.telecheque.com.br/">'
cSoap += WSSoapValue("p_xml", ::cp_xml, cp_xml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</MetodoTesteBancoAtendendo_In_Out_PXML>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://autorizador.telecheque.com.br/MetodoTesteBancoAtendendo_In_Out_PXML",; 
	"DOCUMENT","http://autorizador.telecheque.com.br/",,,; 
	"http://hom10.telecheque.com.br/wsautorizador/wsautorizador.asmx")

::Init()
::cMetodoTesteBancoAtendendo_In_Out_PXMLResult :=  WSAdvValue( oXmlRet,"_METODOTESTEBANCOATENDENDO_IN_OUT_PXMLRESPONSE:_METODOTESTEBANCOATENDENDO_IN_OUT_PXMLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



