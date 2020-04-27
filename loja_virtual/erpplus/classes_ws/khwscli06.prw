#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"


/* ===============================================================================
WSDL Location    https://www.komforthouse.com.br/ikcwebservice/pedido.asmx?wsdl
Gerado em        04/30/19 15:22:15
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RNUIICR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPedidoKH
------------------------------------------------------------------------------- */

WSCLIENT WSPedidoKH

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ListarNovos
	WSMETHOD Listar
	WSMETHOD Validar
	WSMETHOD ValidarComStatus
	WSMETHOD AlterarStatusMobile
	WSMETHOD AlterarStatusBoleto
	WSMETHOD AlterarStatus
	WSMETHOD AlterarStatusItem
	WSMETHOD AlterarStatusIntegracao

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   nStatusPedido             AS int
	WSDATA   cStatusInternoPedido      AS string
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSListarNovosResult      AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   nCodigoPedido             AS int
	WSDATA   oWSListarResult           AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   cCodigoInternoPedido      AS string
	WSDATA   oWSValidarResult          AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   oWSValidarComStatusResult AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   nPedidoStatus             AS int
	WSDATA   cObjetoSedex              AS string
	WSDATA   nNotaFiscal               AS int
	WSDATA   cSerie                    AS string
	WSDATA   cEmailRetiraLoja          AS string
	WSDATA   oWSAlterarStatusMobileResult AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   cObservacaoPedido         AS string
	WSDATA   oWSAlterarStatusBoletoResult AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   oWSAlterarStatusResult    AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   nItemPedidoCodigo         AS int
	WSDATA   cItemPedidoCodigoInterno  AS string
	WSDATA   nItemPedidoStatus         AS int
	WSDATA   cItemPedidoStatusInterno  AS string
	WSDATA   oWSAlterarStatusItemResult AS Pedido_clsRetornoOfclsPedidoKH
	WSDATA   oWSPedidoKHs                AS Pedido_ArrayOfLotePedido
	WSDATA   nStatus                   AS int
	WSDATA   oWSAlterarStatusIntegracaoResult AS Pedido_clsRetornoOfRetornoLotePedido

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPedidoKH
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPedidoKH
	::oWS                := NIL 
	::oWSListarNovosResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSListarResult    := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSValidarResult   := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSValidarComStatusResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSAlterarStatusMobileResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSAlterarStatusBoletoResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSAlterarStatusResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSAlterarStatusItemResult := Pedido_clsRetornoOfclsPedidoKH():New()
	::oWSPedidoKHs         := Pedido_ARRAYOFLOTEPEDIDO():New()
	::oWSAlterarStatusIntegracaoResult := Pedido_CLSRETORNOOFRETORNOLOTEPEDIDO():New()
Return

WSMETHOD RESET WSCLIENT WSPedidoKH
	::nLojaCodigo        := NIL 
	::nStatusPedido      := NIL 
	::cStatusInternoPedido := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSListarNovosResult := NIL 
	::nCodigoPedido      := NIL 
	::oWSListarResult    := NIL 
	::cCodigoInternoPedido := NIL 
	::oWSValidarResult   := NIL 
	::oWSValidarComStatusResult := NIL 
	::nPedidoStatus      := NIL 
	::cObjetoSedex       := NIL 
	::nNotaFiscal        := NIL 
	::cSerie             := NIL 
	::cEmailRetiraLoja   := NIL 
	::oWSAlterarStatusMobileResult := NIL 
	::cObservacaoPedido  := NIL 
	::oWSAlterarStatusBoletoResult := NIL 
	::oWSAlterarStatusResult := NIL 
	::nItemPedidoCodigo  := NIL 
	::cItemPedidoCodigoInterno := NIL 
	::nItemPedidoStatus  := NIL 
	::cItemPedidoStatusInterno := NIL 
	::oWSAlterarStatusItemResult := NIL 
	::oWSPedidoKHs         := NIL 
	::nStatus            := NIL 
	::oWSAlterarStatusIntegracaoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPedidoKH
Local oClone := WSPedidoKH():New()
	oClone:_URL          := ::_URL 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:nStatusPedido := ::nStatusPedido
	oClone:cStatusInternoPedido := ::cStatusInternoPedido
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSListarNovosResult :=  IIF(::oWSListarNovosResult = NIL , NIL ,::oWSListarNovosResult:Clone() )
	oClone:nCodigoPedido := ::nCodigoPedido
	oClone:oWSListarResult :=  IIF(::oWSListarResult = NIL , NIL ,::oWSListarResult:Clone() )
	oClone:cCodigoInternoPedido := ::cCodigoInternoPedido
	oClone:oWSValidarResult :=  IIF(::oWSValidarResult = NIL , NIL ,::oWSValidarResult:Clone() )
	oClone:oWSValidarComStatusResult :=  IIF(::oWSValidarComStatusResult = NIL , NIL ,::oWSValidarComStatusResult:Clone() )
	oClone:nPedidoStatus := ::nPedidoStatus
	oClone:cObjetoSedex  := ::cObjetoSedex
	oClone:nNotaFiscal   := ::nNotaFiscal
	oClone:cSerie        := ::cSerie
	oClone:cEmailRetiraLoja := ::cEmailRetiraLoja
	oClone:oWSAlterarStatusMobileResult :=  IIF(::oWSAlterarStatusMobileResult = NIL , NIL ,::oWSAlterarStatusMobileResult:Clone() )
	oClone:cObservacaoPedido := ::cObservacaoPedido
	oClone:oWSAlterarStatusBoletoResult :=  IIF(::oWSAlterarStatusBoletoResult = NIL , NIL ,::oWSAlterarStatusBoletoResult:Clone() )
	oClone:oWSAlterarStatusResult :=  IIF(::oWSAlterarStatusResult = NIL , NIL ,::oWSAlterarStatusResult:Clone() )
	oClone:nItemPedidoCodigo := ::nItemPedidoCodigo
	oClone:cItemPedidoCodigoInterno := ::cItemPedidoCodigoInterno
	oClone:nItemPedidoStatus := ::nItemPedidoStatus
	oClone:cItemPedidoStatusInterno := ::cItemPedidoStatusInterno
	oClone:oWSAlterarStatusItemResult :=  IIF(::oWSAlterarStatusItemResult = NIL , NIL ,::oWSAlterarStatusItemResult:Clone() )
	oClone:oWSPedidoKHs    :=  IIF(::oWSPedidoKHs = NIL , NIL ,::oWSPedidoKHs:Clone() )
	oClone:nStatus       := ::nStatus
	oClone:oWSAlterarStatusIntegracaoResult :=  IIF(::oWSAlterarStatusIntegracaoResult = NIL , NIL ,::oWSAlterarStatusIntegracaoResult:Clone() )
Return oClone

// WSDL Method ListarNovos of Service WSPedidoKH

WSMETHOD ListarNovos WSSEND nLojaCodigo,nStatusPedido,cStatusInternoPedido,cA1,cA2,oWS WSRECEIVE oWSListarNovosResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<ListarNovos xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusPedido", ::nStatusPedido, nStatusPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusInternoPedido", ::cStatusInternoPedido, cStatusInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ListarNovos>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ListarNovos",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSListarNovosResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARNOVOSRESPONSE:_LISTARNOVOSRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service WSPedidoKH

WSMETHOD Listar WSSEND nLojaCodigo,nCodigoPedido,nStatusPedido,cStatusInternoPedido,cA1,cA2,oWS WSRECEIVE oWSListarResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Listar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusPedido", ::nStatusPedido, nStatusPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusInternoPedido", ::cStatusInternoPedido, cStatusInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Validar of Service WSPedidoKH

WSMETHOD Validar WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,cA1,cA2,oWS WSRECEIVE oWSValidarResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Validar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Validar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Validar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSValidarResult:SoapRecv( WSAdvValue( oXmlRet,"_VALIDARRESPONSE:_VALIDARRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ValidarComStatus of Service WSPedidoKH

WSMETHOD ValidarComStatus WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,nStatusPedido,cA1,cA2,oWS WSRECEIVE oWSValidarComStatusResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<ValidarComStatus xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusPedido", ::nStatusPedido, nStatusPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ValidarComStatus>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ValidarComStatus",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSValidarComStatusResult:SoapRecv( WSAdvValue( oXmlRet,"_VALIDARCOMSTATUSRESPONSE:_VALIDARCOMSTATUSRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatusMobile of Service WSPedidoKH

WSMETHOD AlterarStatusMobile WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,nPedidoStatus,cStatusInternoPedido,cObjetoSedex,nNotaFiscal,cSerie,cEmailRetiraLoja,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusMobileResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatusMobile xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PedidoStatus", ::nPedidoStatus, nPedidoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusInternoPedido", ::cStatusInternoPedido, cStatusInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ObjetoSedex", ::cObjetoSedex, cObjetoSedex , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NotaFiscal", ::nNotaFiscal, nNotaFiscal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Serie", ::cSerie, cSerie , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EmailRetiraLoja", ::cEmailRetiraLoja, cEmailRetiraLoja , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatusMobile>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatusMobile",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSAlterarStatusMobileResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSMOBILERESPONSE:_ALTERARSTATUSMOBILERESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatusBoleto of Service WSPedidoKH

WSMETHOD AlterarStatusBoleto WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,nPedidoStatus,cStatusInternoPedido,cObjetoSedex,nNotaFiscal,cSerie,cObservacaoPedido,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusBoletoResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatusBoleto xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PedidoStatus", ::nPedidoStatus, nPedidoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusInternoPedido", ::cStatusInternoPedido, cStatusInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ObjetoSedex", ::cObjetoSedex, cObjetoSedex , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NotaFiscal", ::nNotaFiscal, nNotaFiscal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Serie", ::cSerie, cSerie , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ObservacaoPedido", ::cObservacaoPedido, cObservacaoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatusBoleto>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatusBoleto",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSAlterarStatusBoletoResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSBOLETORESPONSE:_ALTERARSTATUSBOLETORESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatus of Service WSPedidoKH

WSMETHOD AlterarStatus WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,nPedidoStatus,cStatusInternoPedido,cObjetoSedex,nNotaFiscal,cSerie,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatus xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PedidoStatus", ::nPedidoStatus, nPedidoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusInternoPedido", ::cStatusInternoPedido, cStatusInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ObjetoSedex", ::cObjetoSedex, cObjetoSedex , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NotaFiscal", ::nNotaFiscal, nNotaFiscal , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Serie", ::cSerie, cSerie , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatus>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatus",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSAlterarStatusResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSRESPONSE:_ALTERARSTATUSRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatusItem of Service WSPedidoKH

WSMETHOD AlterarStatusItem WSSEND nLojaCodigo,nCodigoPedido,cCodigoInternoPedido,nItemPedidoCodigo,cItemPedidoCodigoInterno,nItemPedidoStatus,cItemPedidoStatusInterno,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusItemResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatusItem xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ItemPedidoCodigo", ::nItemPedidoCodigo, nItemPedidoCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ItemPedidoCodigoInterno", ::cItemPedidoCodigoInterno, cItemPedidoCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ItemPedidoStatus", ::nItemPedidoStatus, nItemPedidoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ItemPedidoStatusInterno", ::cItemPedidoStatusInterno, cItemPedidoStatusInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatusItem>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatusItem",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSAlterarStatusItemResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSITEMRESPONSE:_ALTERARSTATUSITEMRESULT","clsRetornoOfclsPedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatusIntegracao of Service WSPedidoKH

WSMETHOD AlterarStatusIntegracao WSSEND nLojaCodigo,oWSPedidoKHs,nStatus,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusIntegracaoResult WSCLIENT WSPedidoKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatusIntegracao xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pedidos", ::oWSPedidoKHs, oWSPedidoKHs , "ArrayOfLotePedido", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Status", ::nStatus, nStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatusIntegracao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatusIntegracao",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://www.komforthouse.com.br/ikcwebservice/pedido.asmx")

::Init()
::oWSAlterarStatusIntegracaoResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSINTEGRACAORESPONSE:_ALTERARSTATUSINTEGRACAORESULT","clsRetornoOfRetornoLotePedido",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsPedido

WSSTRUCT Pedido_clsRetornoOfclsPedidoKH
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Pedido_ArrayOfClsPedidoKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_clsRetornoOfclsPedidoKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_clsRetornoOfclsPedidoKH
Return

WSMETHOD CLONE WSCLIENT Pedido_clsRetornoOfclsPedidoKH
	Local oClone := Pedido_clsRetornoOfclsPedidoKH():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_clsRetornoOfclsPedidoKH
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsPedido",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Pedido_ArrayOfClsPedidoKH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLotePedido

WSSTRUCT Pedido_ArrayOfLotePedido
	WSDATA   oWSLotePedido             AS Pedido_LotePedido OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfLotePedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfLotePedido
	::oWSLotePedido        := {} // Array Of  Pedido_LOTEPEDIDO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfLotePedido
	Local oClone := Pedido_ArrayOfLotePedido():NEW()
	oClone:oWSLotePedido := NIL
	If ::oWSLotePedido <> NIL 
		oClone:oWSLotePedido := {}
		aEval( ::oWSLotePedido , { |x| aadd( oClone:oWSLotePedido , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_ArrayOfLotePedido
	Local cSoap := ""
	aEval( ::oWSLotePedido , {|x| cSoap := cSoap  +  WSSoapValue("LotePedido", x , x , "LotePedido", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLotePedido

WSSTRUCT Pedido_clsRetornoOfRetornoLotePedido
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Pedido_ArrayOfRetornoLotePedido OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_clsRetornoOfRetornoLotePedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_clsRetornoOfRetornoLotePedido
Return

WSMETHOD CLONE WSCLIENT Pedido_clsRetornoOfRetornoLotePedido
	Local oClone := Pedido_clsRetornoOfRetornoLotePedido():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_clsRetornoOfRetornoLotePedido
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLotePedido",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Pedido_ArrayOfRetornoLotePedido():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsPedido

WSSTRUCT Pedido_ArrayOfClsPedidoKH
	WSDATA   oWSclsPedido              AS Pedido_clsPedidoKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfClsPedidoKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfClsPedidoKH
	::oWSclsPedido         := {} // Array Of  Pedido_clsPedidoKH():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfClsPedidoKH
	Local oClone := Pedido_ArrayOfClsPedidoKH():NEW()
	oClone:oWSclsPedido := NIL
	If ::oWSclsPedido <> NIL 
		oClone:oWSclsPedido := {}
		aEval( ::oWSclsPedido , { |x| aadd( oClone:oWSclsPedido , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfClsPedidoKH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPEDIDO","clsPedido",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsPedido , Pedido_clsPedidoKH():New() )
			::oWSclsPedido[len(::oWSclsPedido)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LotePedido

WSSTRUCT Pedido_LotePedido
	WSDATA   nCodigoPedido             AS int
	WSDATA   cCodigoInternoPedido      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_LotePedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_LotePedido
Return

WSMETHOD CLONE WSCLIENT Pedido_LotePedido
	Local oClone := Pedido_LotePedido():NEW()
	oClone:nCodigoPedido        := ::nCodigoPedido
	oClone:cCodigoInternoPedido := ::cCodigoInternoPedido
Return oClone

WSMETHOD SOAPSEND WSCLIENT Pedido_LotePedido
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoPedido", ::nCodigoPedido, ::nCodigoPedido , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoInternoPedido", ::cCodigoInternoPedido, ::cCodigoInternoPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLotePedido

WSSTRUCT Pedido_ArrayOfRetornoLotePedido
	WSDATA   oWSRetornoLotePedido      AS Pedido_RetornoLotePedido OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfRetornoLotePedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfRetornoLotePedido
	::oWSRetornoLotePedido := {} // Array Of  Pedido_RETORNOLOTEPEDIDO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfRetornoLotePedido
	Local oClone := Pedido_ArrayOfRetornoLotePedido():NEW()
	oClone:oWSRetornoLotePedido := NIL
	If ::oWSRetornoLotePedido <> NIL 
		oClone:oWSRetornoLotePedido := {}
		aEval( ::oWSRetornoLotePedido , { |x| aadd( oClone:oWSRetornoLotePedido , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfRetornoLotePedido
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTEPEDIDO","RetornoLotePedido",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLotePedido , Pedido_RetornoLotePedido():New() )
			::oWSRetornoLotePedido[len(::oWSRetornoLotePedido)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsPedido

WSSTRUCT Pedido_clsPedidoKH
	WSDATA   nBanco                    AS int
	WSDATA   cCheque                   AS string OPTIONAL
	WSDATA   cAgencia                  AS string OPTIONAL
	WSDATA   cConta                    AS string OPTIONAL
	WSDATA   cContaDigito              AS string OPTIONAL
	WSDATA   lEntregaAgendada          AS boolean
	WSDATA   cDataEntrega              AS dateTime
	WSDATA   cPeriodoEntrega           AS string OPTIONAL
	WSDATA   nValorAgendamento         AS decimal
	WSDATA   nLojaCodigo               AS int
	WSDATA   nPedidoCodigo             AS int
	WSDATA   cPedCliCod     		   AS string OPTIONAL
	WSDATA   cPedIntCod      AS string OPTIONAL
	WSDATA   nParceiroCodigo           AS int
	WSDATA   nAfiliadoCodigo           AS int
	WSDATA   cCestaMensagem            AS string OPTIONAL
	WSDATA   cSedex                    AS string OPTIONAL
	WSDATA   cSedexData                AS string OPTIONAL
	WSDATA   cObservacao               AS string OPTIONAL
	WSDATA   cMotivoCancel             AS string OPTIONAL
	WSDATA   nDesconto                 AS decimal
	WSDATA   oWSPessoa                 AS Pedido_ContaTipoKH
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cIE                       AS string OPTIONAL
	WSDATA   cDataNascimento           AS string OPTIONAL
	WSDATA   cNomeDestinatario         AS string OPTIONAL
	WSDATA   oWSTipoLogradouro         AS Pedido_EndTipoLogradouroKH
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cEstado                   AS string OPTIONAL
	WSDATA   cPais                     AS string OPTIONAL
	WSDATA   cDDD1                     AS string OPTIONAL
	WSDATA   cTelefone1                AS string OPTIONAL
	WSDATA   cRamal1                   AS string OPTIONAL
	WSDATA   cDDD2                     AS string OPTIONAL
	WSDATA   cTelefone2                AS string OPTIONAL
	WSDATA   cRamal2                   AS string OPTIONAL
	WSDATA   cDDD3                     AS string OPTIONAL
	WSDATA   cTelefone3                AS string OPTIONAL
	WSDATA   cRamal3                   AS string OPTIONAL
	WSDATA   cDDDCelular               AS string OPTIONAL
	WSDATA   cCelular                  AS string OPTIONAL
	WSDATA   cDDDFax                   AS string OPTIONAL
	WSDATA   cFax                      AS string OPTIONAL
	WSDATA   cReferencia               AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   cNumeroNF                 AS string OPTIONAL
	WSDATA   cSerieNF                  AS string OPTIONAL
	WSDATA   nPagamento                AS int
	WSDATA   nOperaCod                 AS int
	WSDATA   nTipoPag                  AS int
	WSDATA   nOperaInte                AS int
	WSDATA   nPgtoInterno              AS int
	WSDATA   nValorSubTotal            AS decimal
	WSDATA   nValorTotal               AS decimal
	WSDATA   nValParc             	   AS decimal
	WSDATA   nValorJuros               AS decimal
	WSDATA   nValorDescontoAVista      AS decimal
	WSDATA   nValorPresente            AS decimal
	WSDATA   nValorGarantiaEstendida   AS decimal
	WSDATA   nQtdParcel                AS int
	WSDATA   nScore                    AS int
	WSDATA   nPedidoStatus             AS int
	WSDATA   cPedidoStatusInterno      AS string OPTIONAL
	WSDATA   oWSStatusClearSale        AS Pedido_PedidoStatusClearSaleKH
	WSDATA   lAnaliseRisco             AS boolean
	WSDATA   cData                     AS string OPTIONAL
	WSDATA   cDataAtualizacao          AS string OPTIONAL
	WSDATA   nValorVale                AS decimal
	WSDATA   nValorRestante            AS decimal
	WSDATA   nListaCodigo              AS int
	WSDATA   oWSEnderecoLista          AS Pedido_SimNaoKH
	WSDATA   oWSFreteGratis            AS Pedido_SimNaoKH
	WSDATA   oWSFreteGratisRecusado    AS Pedido_FreteGratisRecusadoKH
	WSDATA   oWSTipoFrete              AS Pedido_FreteTipoKH
	WSDATA   nValorFrete               AS decimal
	WSDATA   nValorFreteCobrado        AS decimal
	WSDATA   nPesoTotal                AS decimal
	WSDATA   nPesoTotalCubado          AS decimal
	WSDATA   nPesoTotalCobrado         AS decimal
	WSDATA   nPesoTotalCubadoCobrado   AS decimal
	WSDATA   nServicoEntregaCodigo     AS int
	WSDATA   nPrazoEntrega             AS int
	WSDATA   cCPFNP                    AS string OPTIONAL
	WSDATA   cTexto1                   AS string OPTIONAL
	WSDATA   cTexto2                   AS string OPTIONAL
	WSDATA   cTexto3                   AS string OPTIONAL
	WSDATA   cTexto4                   AS string OPTIONAL
	WSDATA   cTexto5                   AS string OPTIONAL
	WSDATA   nNumero1                  AS decimal
	WSDATA   nNumero2                  AS decimal
	WSDATA   nNumero3                  AS decimal
	WSDATA   nNumero4                  AS decimal
	WSDATA   nNumero5                  AS decimal
	WSDATA   lSemCadastro              AS boolean
	WSDATA   cPedidoCupomProximaCompra AS string OPTIONAL
	WSDATA   cPedidoCupom              AS string OPTIONAL
	WSDATA   cPedidoCupomValidade      AS string OPTIONAL
	WSDATA   lPedidoRecuperado         AS boolean
	WSDATA   oWSItens                  AS Pedido_ArrayOfItemKH OPTIONAL
	WSDATA   oWSCartao                 AS Pedido_clsCartaoKH OPTIONAL
	WSDATA   oWSCartoes                AS Pedido_ArrayOfClsCartao OPTIONAL
	WSDATA   oWSStatusList             AS Pedido_ArrayOfClsStatusHistoricoPedido OPTIONAL
	WSDATA   nTrazerTrocoPara          AS decimal
	WSDATA   cCNPJNP                   AS string OPTIONAL
	WSDATA   oWSOrigem                 AS Pedido_OrigemPedidoKH
	WSDATA   oWSNFAdditionalData       AS Pedido_InvoiceAdditionalData OPTIONAL
	WSDATA   oWSPrescriptions          AS Pedido_ArrayOfPrescription OPTIONAL
	WSDATA   oWSTelevendasInfo         AS Pedido_TeleSalesData OPTIONAL
	WSDATA   oWSInformacoesAdicionais  AS Pedido_AdditionalData OPTIONAL
	WSDATA   oWSDadosComplementares    AS Pedido_ArrayOfDadoComplementar OPTIONAL
	WSDATA   nPointsValue              AS decimal OPTIONAL
	WSDATA   nRakutenPaymentsBalanceValue AS decimal OPTIONAL
	WSDATA   lPagamentoDoisCartoes     AS boolean OPTIONAL
	WSDATA   lGarantiaSeparada         AS boolean OPTIONAL
	WSDATA   nParcelamentoGCodigo2     AS int OPTIONAL
	WSDATA   nParcelamentoPCodigo2     AS int OPTIONAL
	WSDATA   nPagamento2               AS int OPTIONAL
	WSDATA   nOperadora2               AS int OPTIONAL
	WSDATA   nFormaPgto2               AS int OPTIONAL
	WSDATA   nOperadoraInterno2        AS int OPTIONAL
	WSDATA   nPgtoInterno2        AS int OPTIONAL
	WSDATA   nQtdParc2            AS int OPTIONAL
	WSDATA   nValParc2            AS decimal OPTIONAL
	WSDATA   nValorJuros2              AS decimal OPTIONAL
	WSDATA   nValorDescontoAVista2     AS decimal OPTIONAL
	WSDATA   cPedidoCodigosAgrupados   AS string OPTIONAL
	WSDATA   nProductsServicesValue    AS decimal OPTIONAL
	WSDATA   cLogisticsVolumes         AS string OPTIONAL
	WSDATA   oWSDeliveryType           AS Pedido_DeliveryType OPTIONAL
	WSDATA   oWSCarrier                AS Pedido_Carrier OPTIONAL
	WSDATA   lJurosComprador           AS boolean OPTIONAL
	WSDATA   lJurosComprador2          AS boolean OPTIONAL
	WSDATA   oWSPayBilletInvoicesData  AS Pedido_ArrayOfPayBilletInvoiceData OPTIONAL
	WSDATA   nPaymentCouponValue       AS decimal OPTIONAL
	WSDATA   oWSHarbor                 AS Pedido_HarborModel OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_clsPedidoKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_clsPedidoKH
Return

WSMETHOD CLONE WSCLIENT Pedido_clsPedidoKH
	Local oClone := Pedido_clsPedidoKH():NEW()
	oClone:nBanco               := ::nBanco
	oClone:cCheque              := ::cCheque
	oClone:cAgencia             := ::cAgencia
	oClone:cConta               := ::cConta
	oClone:cContaDigito         := ::cContaDigito
	oClone:lEntregaAgendada     := ::lEntregaAgendada
	oClone:cDataEntrega         := ::cDataEntrega
	oClone:cPeriodoEntrega      := ::cPeriodoEntrega
	oClone:nValorAgendamento    := ::nValorAgendamento
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:nPedidoCodigo        := ::nPedidoCodigo
	oClone:cPedCliCod:= ::cPedidoCodigoCliente
	oClone:cPedIntCod := ::cPedIntCod
	oClone:nParceiroCodigo      := ::nParceiroCodigo
	oClone:nAfiliadoCodigo      := ::nAfiliadoCodigo
	oClone:cCestaMensagem       := ::cCestaMensagem
	oClone:cSedex               := ::cSedex
	oClone:cSedexData           := ::cSedexData
	oClone:cObservacao          := ::cObservacao
	oClone:cMotivoCancel        := ::cMotivoCancel
	oClone:nDesconto            := ::nDesconto
	oClone:oWSPessoa            := IIF(::oWSPessoa = NIL , NIL , ::oWSPessoa:Clone() )
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cCPF                 := ::cCPF
	oClone:cCNPJ                := ::cCNPJ
	oClone:cRG                  := ::cRG
	oClone:cIE                  := ::cIE
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:cNomeDestinatario    := ::cNomeDestinatario
	oClone:oWSTipoLogradouro    := IIF(::oWSTipoLogradouro = NIL , NIL , ::oWSTipoLogradouro:Clone() )
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumero              := ::cNumero
	oClone:cComplemento         := ::cComplemento
	oClone:cCEP                 := ::cCEP
	oClone:cBairro              := ::cBairro
	oClone:cCidade              := ::cCidade
	oClone:cEstado              := ::cEstado
	oClone:cPais                := ::cPais
	oClone:cDDD1                := ::cDDD1
	oClone:cTelefone1           := ::cTelefone1
	oClone:cRamal1              := ::cRamal1
	oClone:cDDD2                := ::cDDD2
	oClone:cTelefone2           := ::cTelefone2
	oClone:cRamal2              := ::cRamal2
	oClone:cDDD3                := ::cDDD3
	oClone:cTelefone3           := ::cTelefone3
	oClone:cRamal3              := ::cRamal3
	oClone:cDDDCelular          := ::cDDDCelular
	oClone:cCelular             := ::cCelular
	oClone:cDDDFax              := ::cDDDFax
	oClone:cFax                 := ::cFax
	oClone:cReferencia          := ::cReferencia
	oClone:cEmail               := ::cEmail
	oClone:cNumeroNF            := ::cNumeroNF
	oClone:cSerieNF             := ::cSerieNF
	oClone:nPagamento           := ::nPagamento
	oClone:nOperaCod           := ::nOperaCod
	oClone:nTipoPag           := ::nTipoPag
	oClone:nOperaInte    := ::nOperaInte
	oClone:nPgtoInterno    := ::nPgtoInterno
	oClone:nValorSubTotal       := ::nValorSubTotal
	oClone:nValorTotal          := ::nValorTotal
	oClone:nValParc        := ::nValParc
	oClone:nValorJuros          := ::nValorJuros
	oClone:nValorDescontoAVista := ::nValorDescontoAVista
	oClone:nValorPresente       := ::nValorPresente
	oClone:nValorGarantiaEstendida := ::nValorGarantiaEstendida
	oClone:nQtdParcel        := ::nQtdParcel
	oClone:nScore               := ::nScore
	oClone:nPedidoStatus        := ::nPedidoStatus
	oClone:cPedidoStatusInterno := ::cPedidoStatusInterno
	oClone:oWSStatusClearSale   := IIF(::oWSStatusClearSale = NIL , NIL , ::oWSStatusClearSale:Clone() )
	oClone:lAnaliseRisco        := ::lAnaliseRisco
	oClone:cData                := ::cData
	oClone:cDataAtualizacao     := ::cDataAtualizacao
	oClone:nValorVale           := ::nValorVale
	oClone:nValorRestante       := ::nValorRestante
	oClone:nListaCodigo         := ::nListaCodigo
	oClone:oWSEnderecoLista     := IIF(::oWSEnderecoLista = NIL , NIL , ::oWSEnderecoLista:Clone() )
	oClone:oWSFreteGratis       := IIF(::oWSFreteGratis = NIL , NIL , ::oWSFreteGratis:Clone() )
	oClone:oWSFreteGratisRecusado := IIF(::oWSFreteGratisRecusado = NIL , NIL , ::oWSFreteGratisRecusado:Clone() )
	oClone:oWSTipoFrete         := IIF(::oWSTipoFrete = NIL , NIL , ::oWSTipoFrete:Clone() )
	oClone:nValorFrete          := ::nValorFrete
	oClone:nValorFreteCobrado   := ::nValorFreteCobrado
	oClone:nPesoTotal           := ::nPesoTotal
	oClone:nPesoTotalCubado     := ::nPesoTotalCubado
	oClone:nPesoTotalCobrado    := ::nPesoTotalCobrado
	oClone:nPesoTotalCubadoCobrado := ::nPesoTotalCubadoCobrado
	oClone:nServicoEntregaCodigo := ::nServicoEntregaCodigo
	oClone:nPrazoEntrega        := ::nPrazoEntrega
	oClone:cCPFNP               := ::cCPFNP
	oClone:cTexto1              := ::cTexto1
	oClone:cTexto2              := ::cTexto2
	oClone:cTexto3              := ::cTexto3
	oClone:cTexto4              := ::cTexto4
	oClone:cTexto5              := ::cTexto5
	oClone:nNumero1             := ::nNumero1
	oClone:nNumero2             := ::nNumero2
	oClone:nNumero3             := ::nNumero3
	oClone:nNumero4             := ::nNumero4
	oClone:nNumero5             := ::nNumero5
	oClone:lSemCadastro         := ::lSemCadastro
	oClone:cPedidoCupomProximaCompra := ::cPedidoCupomProximaCompra
	oClone:cPedidoCupom         := ::cPedidoCupom
	oClone:cPedidoCupomValidade := ::cPedidoCupomValidade
	oClone:lPedidoRecuperado    := ::lPedidoRecuperado
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
	oClone:oWSCartao            := IIF(::oWSCartao = NIL , NIL , ::oWSCartao:Clone() )
	oClone:oWSCartoes           := IIF(::oWSCartoes = NIL , NIL , ::oWSCartoes:Clone() )
	oClone:oWSStatusList        := IIF(::oWSStatusList = NIL , NIL , ::oWSStatusList:Clone() )
	oClone:nTrazerTrocoPara     := ::nTrazerTrocoPara
	oClone:cCNPJNP              := ::cCNPJNP
	oClone:oWSOrigem            := IIF(::oWSOrigem = NIL , NIL , ::oWSOrigem:Clone() )
	oClone:oWSNFAdditionalData  := IIF(::oWSNFAdditionalData = NIL , NIL , ::oWSNFAdditionalData:Clone() )
	oClone:oWSPrescriptions     := IIF(::oWSPrescriptions = NIL , NIL , ::oWSPrescriptions:Clone() )
	oClone:oWSTelevendasInfo    := IIF(::oWSTelevendasInfo = NIL , NIL , ::oWSTelevendasInfo:Clone() )
	oClone:oWSInformacoesAdicionais := IIF(::oWSInformacoesAdicionais = NIL , NIL , ::oWSInformacoesAdicionais:Clone() )
	oClone:oWSDadosComplementares := IIF(::oWSDadosComplementares = NIL , NIL , ::oWSDadosComplementares:Clone() )
	oClone:nPointsValue         := ::nPointsValue
	oClone:nRakutenPaymentsBalanceValue := ::nRakutenPaymentsBalanceValue
	oClone:lPagamentoDoisCartoes := ::lPagamentoDoisCartoes
	oClone:lGarantiaSeparada    := ::lGarantiaSeparada
	oClone:nParcelamentoGCodigo2 := ::nParcelamentoGCodigo2
	oClone:nParcelamentoPCodigo2 := ::nParcelamentoPCodigo2
	oClone:nPagamento2          := ::nPagamento2
	oClone:nOperadora2          := ::nOperadora2
	oClone:nFormaPgto2          := ::nFormaPgto2
	oClone:nOperadoraInterno2   := ::nOperadoraInterno2
	oClone:nPgtoInterno2   := ::nPgtoInterno2
	oClone:nQtdParc2       := ::nQtdParc2
	oClone:nValParc2       := ::nValParc2
	oClone:nValorJuros2         := ::nValorJuros2
	oClone:nValorDescontoAVista2 := ::nValorDescontoAVista2
	oClone:cPedidoCodigosAgrupados := ::cPedidoCodigosAgrupados
	oClone:nProductsServicesValue := ::nProductsServicesValue
	oClone:cLogisticsVolumes    := ::cLogisticsVolumes
	oClone:oWSDeliveryType      := IIF(::oWSDeliveryType = NIL , NIL , ::oWSDeliveryType:Clone() )
	oClone:oWSCarrier           := IIF(::oWSCarrier = NIL , NIL , ::oWSCarrier:Clone() )
	oClone:lJurosComprador      := ::lJurosComprador
	oClone:lJurosComprador2     := ::lJurosComprador2
	oClone:oWSPayBilletInvoicesData := IIF(::oWSPayBilletInvoicesData = NIL , NIL , ::oWSPayBilletInvoicesData:Clone() )
	oClone:nPaymentCouponValue  := ::nPaymentCouponValue
	oClone:oWSHarbor            := IIF(::oWSHarbor = NIL , NIL , ::oWSHarbor:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_clsPedidoKH
	Local oNode22
	Local oNode32
	Local oNode74
	Local oNode81
	Local oNode82
	Local oNode83
	Local oNode84
	Local oNode109
	Local oNode110
	Local oNode111
	Local oNode112
	Local oNode115
	Local oNode116
	Local oNode117
	Local oNode118
	Local oNode119
	Local oNode120
	Local oNode139
	Local oNode140
	Local oNode143
	Local oNode145
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nBanco             :=  WSAdvValue( oResponse,"_BANCO","int",NIL,"Property nBanco as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCheque            :=  WSAdvValue( oResponse,"_CHEQUE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAgencia           :=  WSAdvValue( oResponse,"_AGENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cConta             :=  WSAdvValue( oResponse,"_CONTA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cContaDigito       :=  WSAdvValue( oResponse,"_CONTADIGITO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lEntregaAgendada   :=  WSAdvValue( oResponse,"_ENTREGAAGENDADA","boolean",NIL,"Property lEntregaAgendada as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cDataEntrega       :=  WSAdvValue( oResponse,"_DATAENTREGA","dateTime",NIL,"Property cDataEntrega as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cPeriodoEntrega    :=  WSAdvValue( oResponse,"_PERIODOENTREGA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorAgendamento  :=  WSAdvValue( oResponse,"_VALORAGENDAMENTO","decimal",NIL,"Property nValorAgendamento as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPedidoCodigo      :=  WSAdvValue( oResponse,"_PEDIDOCODIGO","int",NIL,"Property nPedidoCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPedCliCod:=  WSAdvValue( oResponse,"_PEDIDOCODIGOCLIENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedIntCod :=  WSAdvValue( oResponse,"_PEDIDOCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nParceiroCodigo    :=  WSAdvValue( oResponse,"_PARCEIROCODIGO","int",NIL,"Property nParceiroCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAfiliadoCodigo    :=  WSAdvValue( oResponse,"_AFILIADOCODIGO","int",NIL,"Property nAfiliadoCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCestaMensagem     :=  WSAdvValue( oResponse,"_CESTAMENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSedex             :=  WSAdvValue( oResponse,"_SEDEX","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSedexData         :=  WSAdvValue( oResponse,"_SEDEXDATA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cObservacao        :=  WSAdvValue( oResponse,"_OBSERVACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMotivoCancel      :=  WSAdvValue( oResponse,"_MOTIVOCANCEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nDesconto          :=  WSAdvValue( oResponse,"_DESCONTO","decimal",NIL,"Property nDesconto as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode22 :=  WSAdvValue( oResponse,"_PESSOA","ContaTipo",NIL,"Property oWSPessoa as tns:ContaTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode22 != NIL
		::oWSPessoa := Pedido_ContaTipoKH():New()
		::oWSPessoa:SoapRecv(oNode22)
	EndIf
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSobrenome         :=  WSAdvValue( oResponse,"_SOBRENOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRG                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIE                :=  WSAdvValue( oResponse,"_IE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeDestinatario  :=  WSAdvValue( oResponse,"_NOMEDESTINATARIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode32 :=  WSAdvValue( oResponse,"_TIPOLOGRADOURO","EndTipoLogradouro",NIL,"Property oWSTipoLogradouro as tns:EndTipoLogradouro on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode32 != NIL
		::oWSTipoLogradouro := Pedido_EndTipoLogradouroKH():New()
		::oWSTipoLogradouro:SoapRecv(oNode32)
	EndIf
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEstado            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPais              :=  WSAdvValue( oResponse,"_PAIS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDD1              :=  WSAdvValue( oResponse,"_DDD1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelefone1         :=  WSAdvValue( oResponse,"_TELEFONE1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRamal1            :=  WSAdvValue( oResponse,"_RAMAL1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDD2              :=  WSAdvValue( oResponse,"_DDD2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelefone2         :=  WSAdvValue( oResponse,"_TELEFONE2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRamal2            :=  WSAdvValue( oResponse,"_RAMAL2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDD3              :=  WSAdvValue( oResponse,"_DDD3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelefone3         :=  WSAdvValue( oResponse,"_TELEFONE3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRamal3            :=  WSAdvValue( oResponse,"_RAMAL3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDDCelular        :=  WSAdvValue( oResponse,"_DDDCELULAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCelular           :=  WSAdvValue( oResponse,"_CELULAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDDDFax            :=  WSAdvValue( oResponse,"_DDDFAX","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFax               :=  WSAdvValue( oResponse,"_FAX","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cReferencia        :=  WSAdvValue( oResponse,"_REFERENCIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumeroNF          :=  WSAdvValue( oResponse,"_NUMERONF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSerieNF           :=  WSAdvValue( oResponse,"_SERIENF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPagamento         :=  WSAdvValue( oResponse,"_PAGAMENTO","int",NIL,"Property nPagamento as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nOperaCod         :=  WSAdvValue( oResponse,"_OPERADORA","int",NIL,"Property nOperaCod as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTipoPag         :=  WSAdvValue( oResponse,"_FORMAPGTO","int",NIL,"Property nTipoPag as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nOperaInte  :=  WSAdvValue( oResponse,"_OPERADORAINTERNO","int",NIL,"Property nOperaInte as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPgtoInterno  :=  WSAdvValue( oResponse,"_FORMAPGTOINTERNO","int",NIL,"Property nPgtoInterno as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorSubTotal     :=  WSAdvValue( oResponse,"_VALORSUBTOTAL","decimal",NIL,"Property nValorSubTotal as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorTotal        :=  WSAdvValue( oResponse,"_VALORTOTAL","decimal",NIL,"Property nValorTotal as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValParc      :=  WSAdvValue( oResponse,"_VALORPARCELA","decimal",NIL,"Property nValParc as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorJuros        :=  WSAdvValue( oResponse,"_VALORJUROS","decimal",NIL,"Property nValorJuros as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorDescontoAVista :=  WSAdvValue( oResponse,"_VALORDESCONTOAVISTA","decimal",NIL,"Property nValorDescontoAVista as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorPresente     :=  WSAdvValue( oResponse,"_VALORPRESENTE","decimal",NIL,"Property nValorPresente as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorGarantiaEstendida :=  WSAdvValue( oResponse,"_VALORGARANTIAESTENDIDA","decimal",NIL,"Property nValorGarantiaEstendida as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQtdParcel      :=  WSAdvValue( oResponse,"_QTDEPARCELAS","int",NIL,"Property nQtdParcel as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nScore             :=  WSAdvValue( oResponse,"_SCORE","int",NIL,"Property nScore as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPedidoStatus      :=  WSAdvValue( oResponse,"_PEDIDOSTATUS","int",NIL,"Property nPedidoStatus as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPedidoStatusInterno :=  WSAdvValue( oResponse,"_PEDIDOSTATUSINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode74 :=  WSAdvValue( oResponse,"_STATUSCLEARSALE","PedidoStatusClearSale",NIL,"Property oWSStatusClearSale as tns:PedidoStatusClearSale on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode74 != NIL
		::oWSStatusClearSale := Pedido_PedidoStatusClearSaleKH():New()
		::oWSStatusClearSale:SoapRecv(oNode74)
	EndIf
	::lAnaliseRisco      :=  WSAdvValue( oResponse,"_ANALISERISCO","boolean",NIL,"Property lAnaliseRisco as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataAtualizacao   :=  WSAdvValue( oResponse,"_DATAATUALIZACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nValorVale         :=  WSAdvValue( oResponse,"_VALORVALE","decimal",NIL,"Property nValorVale as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorRestante     :=  WSAdvValue( oResponse,"_VALORRESTANTE","decimal",NIL,"Property nValorRestante as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nListaCodigo       :=  WSAdvValue( oResponse,"_LISTACODIGO","int",NIL,"Property nListaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode81 :=  WSAdvValue( oResponse,"_ENDERECOLISTA","SimNao",NIL,"Property oWSEnderecoLista as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode81 != NIL
		::oWSEnderecoLista := Pedido_SimNaoKH():New()
		::oWSEnderecoLista:SoapRecv(oNode81)
	EndIf
	oNode82 :=  WSAdvValue( oResponse,"_FRETEGRATIS","SimNao",NIL,"Property oWSFreteGratis as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode82 != NIL
		::oWSFreteGratis := Pedido_SimNaoKH():New()
		::oWSFreteGratis:SoapRecv(oNode82)
	EndIf
	oNode83 :=  WSAdvValue( oResponse,"_FRETEGRATISRECUSADO","FreteGratisRecusado",NIL,"Property oWSFreteGratisRecusado as tns:FreteGratisRecusado on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode83 != NIL
		::oWSFreteGratisRecusado := Pedido_FreteGratisRecusadoKH():New()
		::oWSFreteGratisRecusado:SoapRecv(oNode83)
	EndIf
	oNode84 :=  WSAdvValue( oResponse,"_TIPOFRETE","FreteTipo",NIL,"Property oWSTipoFrete as tns:FreteTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode84 != NIL
		::oWSTipoFrete := Pedido_FreteTipoKH():New()
		::oWSTipoFrete:SoapRecv(oNode84)
	EndIf
	::nValorFrete        :=  WSAdvValue( oResponse,"_VALORFRETE","decimal",NIL,"Property nValorFrete as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValorFreteCobrado :=  WSAdvValue( oResponse,"_VALORFRETECOBRADO","decimal",NIL,"Property nValorFreteCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesoTotal         :=  WSAdvValue( oResponse,"_PESOTOTAL","decimal",NIL,"Property nPesoTotal as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesoTotalCubado   :=  WSAdvValue( oResponse,"_PESOTOTALCUBADO","decimal",NIL,"Property nPesoTotalCubado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesoTotalCobrado  :=  WSAdvValue( oResponse,"_PESOTOTALCOBRADO","decimal",NIL,"Property nPesoTotalCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesoTotalCubadoCobrado :=  WSAdvValue( oResponse,"_PESOTOTALCUBADOCOBRADO","decimal",NIL,"Property nPesoTotalCubadoCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nServicoEntregaCodigo :=  WSAdvValue( oResponse,"_SERVICOENTREGACODIGO","int",NIL,"Property nServicoEntregaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrazoEntrega      :=  WSAdvValue( oResponse,"_PRAZOENTREGA","int",NIL,"Property nPrazoEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCPFNP             :=  WSAdvValue( oResponse,"_CPFNP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto1            :=  WSAdvValue( oResponse,"_TEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto2            :=  WSAdvValue( oResponse,"_TEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto3            :=  WSAdvValue( oResponse,"_TEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto4            :=  WSAdvValue( oResponse,"_TEXTO4","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto5            :=  WSAdvValue( oResponse,"_TEXTO5","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,"Property nNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,"Property nNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,"Property nNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero4           :=  WSAdvValue( oResponse,"_NUMERO4","decimal",NIL,"Property nNumero4 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero5           :=  WSAdvValue( oResponse,"_NUMERO5","decimal",NIL,"Property nNumero5 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::lSemCadastro       :=  WSAdvValue( oResponse,"_SEMCADASTRO","boolean",NIL,"Property lSemCadastro as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cPedidoCupomProximaCompra :=  WSAdvValue( oResponse,"_PEDIDOCUPOMPROXIMACOMPRA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedidoCupom       :=  WSAdvValue( oResponse,"_PEDIDOCUPOM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPedidoCupomValidade :=  WSAdvValue( oResponse,"_PEDIDOCUPOMVALIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lPedidoRecuperado  :=  WSAdvValue( oResponse,"_PEDIDORECUPERADO","boolean",NIL,"Property lPedidoRecuperado as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	oNode109 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode109 != NIL
		::oWSItens := Pedido_ArrayOfItemKH():New()
		::oWSItens:SoapRecv(oNode109)
	EndIf
	oNode110 :=  WSAdvValue( oResponse,"_CARTAO","clsCartao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode110 != NIL
		::oWSCartao := Pedido_clsCartaoKH():New()
		::oWSCartao:SoapRecv(oNode110)
	EndIf
	oNode111 :=  WSAdvValue( oResponse,"_CARTOES","ArrayOfClsCartao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode111 != NIL
		::oWSCartoes := Pedido_ArrayOfClsCartao():New()
		::oWSCartoes:SoapRecv(oNode111)
	EndIf
	oNode112 :=  WSAdvValue( oResponse,"_STATUSLIST","ArrayOfClsStatusHistoricoPedido",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode112 != NIL
		::oWSStatusList := Pedido_ArrayOfClsStatusHistoricoPedido():New()
		::oWSStatusList:SoapRecv(oNode112)
	EndIf
	::nTrazerTrocoPara   :=  WSAdvValue( oResponse,"_TRAZERTROCOPARA","decimal",NIL,"Property nTrazerTrocoPara as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCNPJNP            :=  WSAdvValue( oResponse,"_CNPJNP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode115 :=  WSAdvValue( oResponse,"_ORIGEM","OrigemPedido",NIL,"Property oWSOrigem as tns:OrigemPedido on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode115 != NIL
		::oWSOrigem := Pedido_OrigemPedidoKH():New()
		::oWSOrigem:SoapRecv(oNode115)
	EndIf
	oNode116 :=  WSAdvValue( oResponse,"_NFADDITIONALDATA","InvoiceAdditionalData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode116 != NIL
		::oWSNFAdditionalData := Pedido_InvoiceAdditionalData():New()
		::oWSNFAdditionalData:SoapRecv(oNode116)
	EndIf
	oNode117 :=  WSAdvValue( oResponse,"_PRESCRIPTIONS","ArrayOfPrescription",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode117 != NIL
		::oWSPrescriptions := Pedido_ArrayOfPrescription():New()
		::oWSPrescriptions:SoapRecv(oNode117)
	EndIf
	oNode118 :=  WSAdvValue( oResponse,"_TELEVENDASINFO","TeleSalesData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode118 != NIL
		::oWSTelevendasInfo := Pedido_TeleSalesData():New()
		::oWSTelevendasInfo:SoapRecv(oNode118)
	EndIf
	oNode119 :=  WSAdvValue( oResponse,"_INFORMACOESADICIONAIS","AdditionalData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode119 != NIL
		::oWSInformacoesAdicionais := Pedido_AdditionalData():New()
		::oWSInformacoesAdicionais:SoapRecv(oNode119)
	EndIf
	oNode120 :=  WSAdvValue( oResponse,"_DADOSCOMPLEMENTARES","ArrayOfDadoComplementar",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode120 != NIL
		::oWSDadosComplementares := Pedido_ArrayOfDadoComplementar():New()
		::oWSDadosComplementares:SoapRecv(oNode120)
	EndIf
	::nPointsValue       :=  WSAdvValue( oResponse,"_POINTSVALUE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nRakutenPaymentsBalanceValue :=  WSAdvValue( oResponse,"_RAKUTENPAYMENTSBALANCEVALUE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::lPagamentoDoisCartoes :=  WSAdvValue( oResponse,"_PAGAMENTODOISCARTOES","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lGarantiaSeparada  :=  WSAdvValue( oResponse,"_GARANTIASEPARADA","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nParcelamentoGCodigo2 :=  WSAdvValue( oResponse,"_PARCELAMENTOGCODIGO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nParcelamentoPCodigo2 :=  WSAdvValue( oResponse,"_PARCELAMENTOPCODIGO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPagamento2        :=  WSAdvValue( oResponse,"_PAGAMENTO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nOperadora2        :=  WSAdvValue( oResponse,"_OPERADORA2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nFormaPgto2        :=  WSAdvValue( oResponse,"_FORMAPGTO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nOperadoraInterno2 :=  WSAdvValue( oResponse,"_OPERADORAINTERNO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPgtoInterno2 :=  WSAdvValue( oResponse,"_FORMAPGTOINTERNO2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nQtdParc2     :=  WSAdvValue( oResponse,"_QTDEPARCELAS2","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValParc2     :=  WSAdvValue( oResponse,"_VALORPARCELA2","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorJuros2       :=  WSAdvValue( oResponse,"_VALORJUROS2","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorDescontoAVista2 :=  WSAdvValue( oResponse,"_VALORDESCONTOAVISTA2","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cPedidoCodigosAgrupados :=  WSAdvValue( oResponse,"_PEDIDOCODIGOSAGRUPADOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nProductsServicesValue :=  WSAdvValue( oResponse,"_PRODUCTSSERVICESVALUE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cLogisticsVolumes  :=  WSAdvValue( oResponse,"_LOGISTICSVOLUMES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode139 :=  WSAdvValue( oResponse,"_DELIVERYTYPE","DeliveryType",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode139 != NIL
		::oWSDeliveryType := Pedido_DeliveryType():New()
		::oWSDeliveryType:SoapRecv(oNode139)
	EndIf
	oNode140 :=  WSAdvValue( oResponse,"_CARRIER","Carrier",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode140 != NIL
		::oWSCarrier := Pedido_Carrier():New()
		::oWSCarrier:SoapRecv(oNode140)
	EndIf
	::lJurosComprador    :=  WSAdvValue( oResponse,"_JUROSCOMPRADOR","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::lJurosComprador2   :=  WSAdvValue( oResponse,"_JUROSCOMPRADOR2","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	oNode143 :=  WSAdvValue( oResponse,"_PAYBILLETINVOICESDATA","ArrayOfPayBilletInvoiceData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode143 != NIL
		::oWSPayBilletInvoicesData := Pedido_ArrayOfPayBilletInvoiceData():New()
		::oWSPayBilletInvoicesData:SoapRecv(oNode143)
	EndIf
	::nPaymentCouponValue :=  WSAdvValue( oResponse,"_PAYMENTCOUPONVALUE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode145 :=  WSAdvValue( oResponse,"_HARBOR","HarborModel",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode145 != NIL
		::oWSHarbor := Pedido_HarborModel():New()
		::oWSHarbor:SoapRecv(oNode145)
	EndIf
Return

// WSDL Data Structure RetornoLotePedido

WSSTRUCT Pedido_RetornoLotePedido
	WSDATA   nCodigo                   AS int
	WSDATA   nCodigoPedido             AS int
	WSDATA   cCodigoInternoPedido      AS string OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_RetornoLotePedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_RetornoLotePedido
Return

WSMETHOD CLONE WSCLIENT Pedido_RetornoLotePedido
	Local oClone := Pedido_RetornoLotePedido():NEW()
	oClone:nCodigo              := ::nCodigo
	oClone:nCodigoPedido        := ::nCodigoPedido
	oClone:cCodigoInternoPedido := ::cCodigoInternoPedido
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_RetornoLotePedido
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCodigoPedido      :=  WSAdvValue( oResponse,"_CODIGOPEDIDO","int",NIL,"Property nCodigoPedido as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCodigoInternoPedido :=  WSAdvValue( oResponse,"_CODIGOINTERNOPEDIDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration ContaTipo

WSSTRUCT Pedido_ContaTipoKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ContaTipoKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "PessoaFísica" )
	aadd(::aValueList , "PessoaJurídica" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_ContaTipoKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ContaTipoKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_ContaTipoKH
Local oClone := Pedido_ContaTipoKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration EndTipoLogradouro

WSSTRUCT Pedido_EndTipoLogradouroKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_EndTipoLogradouroKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Rua" )
	aadd(::aValueList , "Avenida" )
	aadd(::aValueList , "Praça" )
	aadd(::aValueList , "Outros" )
	aadd(::aValueList , "Aeroporto" )
	aadd(::aValueList , "Alameda" )
	aadd(::aValueList , "Área" )
	aadd(::aValueList , "Beco" )
	aadd(::aValueList , "Bloco" )
	aadd(::aValueList , "Calçada" )
	aadd(::aValueList , "Campo" )
	aadd(::aValueList , "Chácara" )
	aadd(::aValueList , "Colônia" )
	aadd(::aValueList , "Condomínio" )
	aadd(::aValueList , "Conjunto" )
	aadd(::aValueList , "Distrito" )
	aadd(::aValueList , "Escadaria" )
	aadd(::aValueList , "Esplanada" )
	aadd(::aValueList , "Estação" )
	aadd(::aValueList , "Estância" )
	aadd(::aValueList , "Estrada" )
	aadd(::aValueList , "Favela" )
	aadd(::aValueList , "Fazenda" )
	aadd(::aValueList , "Feira" )
	aadd(::aValueList , "Hospital" )
	aadd(::aValueList , "Hotel" )
	aadd(::aValueList , "Jardim" )
	aadd(::aValueList , "Ladeira" )
	aadd(::aValueList , "Lago" )
	aadd(::aValueList , "Lagoa" )
	aadd(::aValueList , "Largo" )
	aadd(::aValueList , "Linha" )
	aadd(::aValueList , "Loteamento" )
	aadd(::aValueList , "Morro" )
	aadd(::aValueList , "Nucleo" )
	aadd(::aValueList , "Parque" )
	aadd(::aValueList , "Passarela" )
	aadd(::aValueList , "Pátio" )
	aadd(::aValueList , "Porto" )
	aadd(::aValueList , "Pousada" )
	aadd(::aValueList , "Povoado" )
	aadd(::aValueList , "Praia" )
	aadd(::aValueList , "Quadra" )
	aadd(::aValueList , "Recanto" )
	aadd(::aValueList , "Residencial" )
	aadd(::aValueList , "Rodovia" )
	aadd(::aValueList , "Setor" )
	aadd(::aValueList , "Sítio" )
	aadd(::aValueList , "Travessa" )
	aadd(::aValueList , "Techo" )
	aadd(::aValueList , "Trevo" )
	aadd(::aValueList , "Vale" )
	aadd(::aValueList , "Vereda" )
	aadd(::aValueList , "Via" )
	aadd(::aValueList , "Viaduto" )
	aadd(::aValueList , "Viela" )
	aadd(::aValueList , "Vila" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_EndTipoLogradouroKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_EndTipoLogradouroKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_EndTipoLogradouroKH
Local oClone := Pedido_EndTipoLogradouroKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration PedidoStatusClearSale

WSSTRUCT Pedido_PedidoStatusClearSaleKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PedidoStatusClearSaleKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Aprovado" )
	aadd(::aValueList , "Suspenso" )
	aadd(::aValueList , "Fraude" )
	aadd(::aValueList , "Aprovação_Automática" )
	aadd(::aValueList , "Suspensão_Automática" )
	aadd(::aValueList , "Fraude_Confirmada" )
	aadd(::aValueList , "Cancelado" )
	aadd(::aValueList , "Reprovado" )
	aadd(::aValueList , "Cancelado_Politica" )
	aadd(::aValueList , "APA" )
	aadd(::aValueList , "APM" )
	aadd(::aValueList , "RPM" )
	aadd(::aValueList , "AMA" )
	aadd(::aValueList , "ERR" )
	aadd(::aValueList , "NVO" )
	aadd(::aValueList , "SUS" )
	aadd(::aValueList , "CAN" )
	aadd(::aValueList , "FRD" )
	aadd(::aValueList , "RPA" )
	aadd(::aValueList , "PER" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_PedidoStatusClearSaleKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PedidoStatusClearSaleKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_PedidoStatusClearSaleKH
Local oClone := Pedido_PedidoStatusClearSaleKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SimNao

WSSTRUCT Pedido_SimNaoKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_SimNaoKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Sim" )
	aadd(::aValueList , "Não" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_SimNaoKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_SimNaoKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_SimNaoKH
Local oClone := Pedido_SimNaoKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration FreteGratisRecusado

WSSTRUCT Pedido_FreteGratisRecusadoKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_FreteGratisRecusadoKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nao" )
	aadd(::aValueList , "Sim" )
	aadd(::aValueList , "Parcial" )
	aadd(::aValueList , "SimPromoServicoCesta" )
	aadd(::aValueList , "SimPromoServicoItem" )
	aadd(::aValueList , "SimPromoOperadora" )
	aadd(::aValueList , "NaoPromoServicoCesta" )
	aadd(::aValueList , "NaoPromoServicoItem" )
	aadd(::aValueList , "NaoPromoOperadora" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_FreteGratisRecusadoKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_FreteGratisRecusadoKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_FreteGratisRecusadoKH
Local oClone := Pedido_FreteGratisRecusadoKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration FreteTipo

WSSTRUCT Pedido_FreteTipoKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_FreteTipoKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Cesta" )
	aadd(::aValueList , "Item" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_FreteTipoKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_FreteTipoKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_FreteTipoKH
Local oClone := Pedido_FreteTipoKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfItem

WSSTRUCT Pedido_ArrayOfItemKH
	WSDATA   oWSItem                   AS Pedido_ItemKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfItemKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfItemKH
	::oWSItem              := {} // Array Of  Pedido_ItemKH():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfItemKH
	Local oClone := Pedido_ArrayOfItemKH():NEW()
	oClone:oWSItem := NIL
	If ::oWSItem <> NIL 
		oClone:oWSItem := {}
		aEval( ::oWSItem , { |x| aadd( oClone:oWSItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfItemKH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITEM","Item",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSItem , Pedido_ItemKH():New() )
			::oWSItem[len(::oWSItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsCartao

WSSTRUCT Pedido_clsCartaoKH
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cSeguranca                AS string OPTIONAL
	WSDATA   cTitular                  AS string OPTIONAL
	WSDATA   cValidMes                 AS string OPTIONAL
	WSDATA   cValidAno                 AS string OPTIONAL
	WSDATA   cCarTID                   AS string OPTIONAL
	WSDATA   cRetOperCd 			   AS string OPTIONAL
	WSDATA   cRetOperMsg 			   AS string OPTIONAL
	WSDATA   cAutorizaCC     		   AS string OPTIONAL
	WSDATA   cCarCPFCNPJ               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_clsCartaoKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_clsCartaoKH
Return

WSMETHOD CLONE WSCLIENT Pedido_clsCartaoKH
	Local oClone := Pedido_clsCartaoKH():NEW()
	oClone:cNumero              := ::cNumero
	oClone:cSeguranca           := ::cSeguranca
	oClone:cTitular             := ::cTitular
	oClone:cValidMes         := ::cValidMes
	oClone:cValidAno         := ::cValidAno
	oClone:cCarTID              := ::cCarTID
	oClone:cRetOperCd := ::cRetOperCd
	oClone:cRetOperMsg := ::cRetOperMsg
	oClone:cAutorizaCC := ::cAutorizaCC
	oClone:cCarCPFCNPJ          := ::cCarCPFCNPJ
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_clsCartaoKH
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSeguranca         :=  WSAdvValue( oResponse,"_SEGURANCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTitular           :=  WSAdvValue( oResponse,"_TITULAR","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cValidMes       :=  WSAdvValue( oResponse,"_VALIDADEMES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cValidAno       :=  WSAdvValue( oResponse,"_VALIDADEANO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCarTID            :=  WSAdvValue( oResponse,"_CARTID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRetOperCd :=  WSAdvValue( oResponse,"_CAROPERADORARETORNOCODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRetOperMsg :=  WSAdvValue( oResponse,"_CAROPERADORARETORNOMENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAutorizaCC :=  WSAdvValue( oResponse,"_CARAUTORIZACAOCODIGO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCarCPFCNPJ        :=  WSAdvValue( oResponse,"_CARCPFCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfClsCartao

WSSTRUCT Pedido_ArrayOfClsCartao
	WSDATA   oWSclsCartao              AS Pedido_clsCartaoKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfClsCartao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfClsCartao
	::oWSclsCartao         := {} // Array Of  Pedido_clsCartaoKH():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfClsCartao
	Local oClone := Pedido_ArrayOfClsCartao():NEW()
	oClone:oWSclsCartao := NIL
	If ::oWSclsCartao <> NIL 
		oClone:oWSclsCartao := {}
		aEval( ::oWSclsCartao , { |x| aadd( oClone:oWSclsCartao , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfClsCartao
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSCARTAO","clsCartao",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsCartao , Pedido_clsCartaoKH():New() )
			::oWSclsCartao[len(::oWSclsCartao)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfClsStatusHistoricoPedido

WSSTRUCT Pedido_ArrayOfClsStatusHistoricoPedido
	WSDATA   oWSclsStatusHistoricoPedido AS Pedido_clsStatusHistoricoPedido OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfClsStatusHistoricoPedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfClsStatusHistoricoPedido
	::oWSclsStatusHistoricoPedido := {} // Array Of  Pedido_CLSSTATUSHISTORICOPEDIDO():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfClsStatusHistoricoPedido
	Local oClone := Pedido_ArrayOfClsStatusHistoricoPedido():NEW()
	oClone:oWSclsStatusHistoricoPedido := NIL
	If ::oWSclsStatusHistoricoPedido <> NIL 
		oClone:oWSclsStatusHistoricoPedido := {}
		aEval( ::oWSclsStatusHistoricoPedido , { |x| aadd( oClone:oWSclsStatusHistoricoPedido , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfClsStatusHistoricoPedido
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSSTATUSHISTORICOPEDIDO","clsStatusHistoricoPedido",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsStatusHistoricoPedido , Pedido_clsStatusHistoricoPedido():New() )
			::oWSclsStatusHistoricoPedido[len(::oWSclsStatusHistoricoPedido)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration OrigemPedido

WSSTRUCT Pedido_OrigemPedidoKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_OrigemPedidoKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Todas" )
	aadd(::aValueList , "Loja" )
	aadd(::aValueList , "Televendas" )
	aadd(::aValueList , "SuperMall" )
	aadd(::aValueList , "Mobile" )
	aadd(::aValueList , "AppMobile" )
	aadd(::aValueList , "Coc" )
	aadd(::aValueList , "SuperCash" )
	aadd(::aValueList , "MercadoLivre" )
	aadd(::aValueList , "Nova" )
	aadd(::aValueList , "Walmart" )
	aadd(::aValueList , "Submarino" )
	aadd(::aValueList , "Rakuten" )
	aadd(::aValueList , "Buscape" )
	aadd(::aValueList , "CSU" )
	aadd(::aValueList , "FastShop" )
	aadd(::aValueList , "ShopFacil" )
	aadd(::aValueList , "Dafiti" )
	aadd(::aValueList , "Americanas" )
	aadd(::aValueList , "Shoptime" )
	aadd(::aValueList , "SouBarato" )
	aadd(::aValueList , "Netshoes" )
	aadd(::aValueList , "MagazineLuiza" )
	aadd(::aValueList , "Farfetch" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_OrigemPedidoKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_OrigemPedidoKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_OrigemPedidoKH
Local oClone := Pedido_OrigemPedidoKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure InvoiceAdditionalData

WSSTRUCT Pedido_InvoiceAdditionalData
	WSDATA   cLogisticsInvoiceKey      AS string OPTIONAL
	WSDATA   cLogisticsInvoiceCFOP     AS string OPTIONAL
	WSDATA   cLogisticsInvoiceDate     AS string OPTIONAL
	WSDATA   nLogisticsInvoiceValueBaseICMS AS decimal
	WSDATA   nLogisticsInvoiceValueICMS AS decimal
	WSDATA   nLogisticsInvoiceValueBaseICMSST AS decimal
	WSDATA   nLogisticsInvoiceValueICMSST AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_InvoiceAdditionalData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_InvoiceAdditionalData
Return

WSMETHOD CLONE WSCLIENT Pedido_InvoiceAdditionalData
	Local oClone := Pedido_InvoiceAdditionalData():NEW()
	oClone:cLogisticsInvoiceKey := ::cLogisticsInvoiceKey
	oClone:cLogisticsInvoiceCFOP := ::cLogisticsInvoiceCFOP
	oClone:cLogisticsInvoiceDate := ::cLogisticsInvoiceDate
	oClone:nLogisticsInvoiceValueBaseICMS := ::nLogisticsInvoiceValueBaseICMS
	oClone:nLogisticsInvoiceValueICMS := ::nLogisticsInvoiceValueICMS
	oClone:nLogisticsInvoiceValueBaseICMSST := ::nLogisticsInvoiceValueBaseICMSST
	oClone:nLogisticsInvoiceValueICMSST := ::nLogisticsInvoiceValueICMSST
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_InvoiceAdditionalData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cLogisticsInvoiceKey :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEKEY","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLogisticsInvoiceCFOP :=  WSAdvValue( oResponse,"_LOGISTICSINVOICECFOP","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLogisticsInvoiceDate :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEDATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nLogisticsInvoiceValueBaseICMS :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEVALUEBASEICMS","decimal",NIL,"Property nLogisticsInvoiceValueBaseICMS as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLogisticsInvoiceValueICMS :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEVALUEICMS","decimal",NIL,"Property nLogisticsInvoiceValueICMS as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLogisticsInvoiceValueBaseICMSST :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEVALUEBASEICMSST","decimal",NIL,"Property nLogisticsInvoiceValueBaseICMSST as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLogisticsInvoiceValueICMSST :=  WSAdvValue( oResponse,"_LOGISTICSINVOICEVALUEICMSST","decimal",NIL,"Property nLogisticsInvoiceValueICMSST as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfPrescription

WSSTRUCT Pedido_ArrayOfPrescription
	WSDATA   oWSPrescription           AS Pedido_Prescription OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPrescription
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPrescription
	::oWSPrescription      := {} // Array Of  Pedido_PRESCRIPTION():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPrescription
	Local oClone := Pedido_ArrayOfPrescription():NEW()
	oClone:oWSPrescription := NIL
	If ::oWSPrescription <> NIL 
		oClone:oWSPrescription := {}
		aEval( ::oWSPrescription , { |x| aadd( oClone:oWSPrescription , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPrescription
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PRESCRIPTION","Prescription",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPrescription , Pedido_Prescription():New() )
			::oWSPrescription[len(::oWSPrescription)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TeleSalesData

WSSTRUCT Pedido_TeleSalesData
	WSDATA   nGerenteCodigo            AS int
	WSDATA   nOperadorCodigo           AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_TeleSalesData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_TeleSalesData
Return

WSMETHOD CLONE WSCLIENT Pedido_TeleSalesData
	Local oClone := Pedido_TeleSalesData():NEW()
	oClone:nGerenteCodigo       := ::nGerenteCodigo
	oClone:nOperadorCodigo      := ::nOperadorCodigo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_TeleSalesData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nGerenteCodigo     :=  WSAdvValue( oResponse,"_GERENTECODIGO","int",NIL,"Property nGerenteCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nOperadorCodigo    :=  WSAdvValue( oResponse,"_OPERADORCODIGO","int",NIL,"Property nOperadorCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure AdditionalData

WSSTRUCT Pedido_AdditionalData
	WSDATA   nFatorConversao           AS decimal
	WSDATA   cConteudo                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_AdditionalData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_AdditionalData
Return

WSMETHOD CLONE WSCLIENT Pedido_AdditionalData
	Local oClone := Pedido_AdditionalData():NEW()
	oClone:nFatorConversao      := ::nFatorConversao
	oClone:cConteudo            := ::cConteudo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_AdditionalData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nFatorConversao    :=  WSAdvValue( oResponse,"_FATORCONVERSAO","decimal",NIL,"Property nFatorConversao as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cConteudo          :=  WSAdvValue( oResponse,"_CONTEUDO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfDadoComplementar

WSSTRUCT Pedido_ArrayOfDadoComplementar
	WSDATA   oWSDadoComplementar       AS Pedido_DadoComplementar OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfDadoComplementar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfDadoComplementar
	::oWSDadoComplementar  := {} // Array Of  Pedido_DADOCOMPLEMENTAR():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfDadoComplementar
	Local oClone := Pedido_ArrayOfDadoComplementar():NEW()
	oClone:oWSDadoComplementar := NIL
	If ::oWSDadoComplementar <> NIL 
		oClone:oWSDadoComplementar := {}
		aEval( ::oWSDadoComplementar , { |x| aadd( oClone:oWSDadoComplementar , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfDadoComplementar
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DADOCOMPLEMENTAR","DadoComplementar",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDadoComplementar , Pedido_DadoComplementar():New() )
			::oWSDadoComplementar[len(::oWSDadoComplementar)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration DeliveryType

WSSTRUCT Pedido_DeliveryType
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_DeliveryType
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "None" )
	aadd(::aValueList , "Home" )
	aadd(::aValueList , "Store" )
	aadd(::aValueList , "Carrier" )
	aadd(::aValueList , "Harbor" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_DeliveryType
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_DeliveryType
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_DeliveryType
Local oClone := Pedido_DeliveryType():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure Carrier

WSSTRUCT Pedido_Carrier
	WSDATA   nId                       AS int
	WSDATA   cName                     AS string OPTIONAL
	WSDATA   cPhone                    AS string OPTIONAL
	WSDATA   cDescription              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_Carrier
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_Carrier
Return

WSMETHOD CLONE WSCLIENT Pedido_Carrier
	Local oClone := Pedido_Carrier():NEW()
	oClone:nId                  := ::nId
	oClone:cName                := ::cName
	oClone:cPhone               := ::cPhone
	oClone:cDescription         := ::cDescription
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_Carrier
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nId                :=  WSAdvValue( oResponse,"_ID","int",NIL,"Property nId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cName              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPhone             :=  WSAdvValue( oResponse,"_PHONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescription       :=  WSAdvValue( oResponse,"_DESCRIPTION","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfPayBilletInvoiceData

WSSTRUCT Pedido_ArrayOfPayBilletInvoiceData
	WSDATA   oWSPayBilletInvoiceData   AS Pedido_PayBilletInvoiceData OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfPayBilletInvoiceData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfPayBilletInvoiceData
	::oWSPayBilletInvoiceData := {} // Array Of  Pedido_PAYBILLETINVOICEDATA():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfPayBilletInvoiceData
	Local oClone := Pedido_ArrayOfPayBilletInvoiceData():NEW()
	oClone:oWSPayBilletInvoiceData := NIL
	If ::oWSPayBilletInvoiceData <> NIL 
		oClone:oWSPayBilletInvoiceData := {}
		aEval( ::oWSPayBilletInvoiceData , { |x| aadd( oClone:oWSPayBilletInvoiceData , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfPayBilletInvoiceData
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PAYBILLETINVOICEDATA","PayBilletInvoiceData",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSPayBilletInvoiceData , Pedido_PayBilletInvoiceData():New() )
			::oWSPayBilletInvoiceData[len(::oWSPayBilletInvoiceData)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure HarborModel

WSSTRUCT Pedido_HarborModel
	WSDATA   cCode                     AS string OPTIONAL
	WSDATA   cName                     AS string OPTIONAL
	WSDATA   cShipName                 AS string OPTIONAL
	WSDATA   cDestinationCity          AS string OPTIONAL
	WSDATA   cResponsiblePersonName    AS string OPTIONAL
	WSDATA   cResponsiblePersonPhone   AS string OPTIONAL
	WSDATA   cDeliveryDate             AS dateTime
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_HarborModel
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_HarborModel
Return

WSMETHOD CLONE WSCLIENT Pedido_HarborModel
	Local oClone := Pedido_HarborModel():NEW()
	oClone:cCode                := ::cCode
	oClone:cName                := ::cName
	oClone:cShipName            := ::cShipName
	oClone:cDestinationCity     := ::cDestinationCity
	oClone:cResponsiblePersonName := ::cResponsiblePersonName
	oClone:cResponsiblePersonPhone := ::cResponsiblePersonPhone
	oClone:cDeliveryDate        := ::cDeliveryDate
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_HarborModel
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCode              :=  WSAdvValue( oResponse,"_CODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cName              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cShipName          :=  WSAdvValue( oResponse,"_SHIPNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDestinationCity   :=  WSAdvValue( oResponse,"_DESTINATIONCITY","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cResponsiblePersonName :=  WSAdvValue( oResponse,"_RESPONSIBLEPERSONNAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cResponsiblePersonPhone :=  WSAdvValue( oResponse,"_RESPONSIBLEPERSONPHONE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDeliveryDate      :=  WSAdvValue( oResponse,"_DELIVERYDATE","dateTime",NIL,"Property cDeliveryDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure Item

WSSTRUCT Pedido_ItemKH
	WSDATA   nItemCodigo               AS int
	WSDATA   nItemCodigoComprado       AS int
	WSDATA   nItemStatus               AS int
	WSDATA   cItemStatusInterno        AS string OPTIONAL
	WSDATA   nItemQtde                 AS int
	WSDATA   nValItem                AS decimal
	WSDATA   nValFinal           AS decimal
	WSDATA   nItemValorPresente        AS decimal
	WSDATA   nItemValorGarantiaEstendida AS decimal
	WSDATA   nItemAnosGarantiaEstendida AS int
	WSDATA   cItemCertificadoGarantiaEstendida AS string OPTIONAL
	WSDATA   cEnqCodInterno            AS string OPTIONAL
	WSDATA   oWSItemTipo               AS Pedido_ItemKHTipo
	WSDATA   oWSPresente               AS Pedido_SimNaoKH
	WSDATA   cCupom                    AS string OPTIONAL
	WSDATA   cItemNome                 AS string OPTIONAL
	WSDATA   cItemMensagem             AS string OPTIONAL
	WSDATA   cItemMsgPresente          AS string OPTIONAL
	WSDATA   cItemPartNumber           AS string OPTIONAL
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   oWSFreteGratis            AS Pedido_SimNaoKH
	WSDATA   oWSFreteGratisRecusado    AS Pedido_FreteGratisRecusadoKH
	WSDATA   nItemValorFrete           AS decimal
	WSDATA   nItemValorFreteCobrado    AS decimal
	WSDATA   nServicoEntregaCodigo     AS int
	WSDATA   nItemPrazoEntrega         AS int
	WSDATA   cItemDataEntrega          AS string OPTIONAL
	WSDATA   cSedex                    AS string OPTIONAL
	WSDATA   nItemPeso                 AS decimal
	WSDATA   nItemPesoCubado           AS decimal
	WSDATA   nItemPesoCobrado          AS decimal
	WSDATA   nItemPesoCubadoCobrado    AS decimal
	WSDATA   nListaCodigo              AS int
	WSDATA   cListaCodigoInterno       AS string OPTIONAL
	WSDATA   oWSListaTipoEntrega       AS Pedido_ListaTipoEntregaKH
	WSDATA   oWSItemTroca              AS Pedido_SimNaoKH
	WSDATA   cItemTexto1               AS string OPTIONAL
	WSDATA   cItemTexto2               AS string OPTIONAL
	WSDATA   cItemTexto3               AS string OPTIONAL
	WSDATA   nItemNumero1              AS decimal
	WSDATA   nItemNumero2              AS decimal
	WSDATA   nItemNumero3              AS decimal
	WSDATA   oWSPersonalizacaoExtra    AS Pedido_SimNaoKH
	WSDATA   cPersonalizacaoTexto      AS string OPTIONAL
	WSDATA   cItemCodigoInterno        AS string OPTIONAL
	WSDATA   cSeloQuantidadeMinimaProduto1 AS string OPTIONAL
	WSDATA   cSeloQuantidadeMinimaProduto2 AS string OPTIONAL
	WSDATA   cSeloQuantidadeMinimaProduto3 AS string OPTIONAL
	WSDATA   nFreteValorFixo           AS decimal
	WSDATA   nBasketItemCode           AS int OPTIONAL
	WSDATA   nLookCode                 AS int OPTIONAL
	WSDATA   lCourtesy                 AS boolean OPTIONAL
	WSDATA   nCompanyId                AS int OPTIONAL
	WSDATA   oWSProductsServicesItems  AS Pedido_ArrayOfProductServiceItem OPTIONAL
	WSDATA   oWSWarehouses             AS Pedido_ArrayOfWarehousesItem OPTIONAL
	WSDATA   nServiceCode              AS int OPTIONAL
	WSDATA   oWSStoreAddress           AS Pedido_Address OPTIONAL
	WSDATA   oWSCustomizations         AS Pedido_ArrayOfCustomizationItem OPTIONAL
	WSDATA   oWSFilesUploadUrl         AS Pedido_ArrayOfString OPTIONAL
	WSDATA   nDiscountsValue           AS decimal OPTIONAL
	WSDATA   oWSDiscounts              AS Pedido_ArrayOfDiscountItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ItemKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ItemKH
Return

WSMETHOD CLONE WSCLIENT Pedido_ItemKH
	Local oClone := Pedido_ItemKH():NEW()
	oClone:nItemCodigo          := ::nItemCodigo
	oClone:nItemCodigoComprado  := ::nItemCodigoComprado
	oClone:nItemStatus          := ::nItemStatus
	oClone:cItemStatusInterno   := ::cItemStatusInterno
	oClone:nItemQtde            := ::nItemQtde
	oClone:nValItem           := ::nValItem
	oClone:nValFinal      := ::nValFinal
	oClone:nItemValorPresente   := ::nItemValorPresente
	oClone:nItemValorGarantiaEstendida := ::nItemValorGarantiaEstendida
	oClone:nItemAnosGarantiaEstendida := ::nItemAnosGarantiaEstendida
	oClone:cItemCertificadoGarantiaEstendida := ::cItemCertificadoGarantiaEstendida
	oClone:cEnqCodInterno       := ::cEnqCodInterno
	oClone:oWSItemTipo          := IIF(::oWSItemTipo = NIL , NIL , ::oWSItemTipo:Clone() )
	oClone:oWSPresente          := IIF(::oWSPresente = NIL , NIL , ::oWSPresente:Clone() )
	oClone:cCupom               := ::cCupom
	oClone:cItemNome            := ::cItemNome
	oClone:cItemMensagem        := ::cItemMensagem
	oClone:cItemMsgPresente     := ::cItemMsgPresente
	oClone:cItemPartNumber      := ::cItemPartNumber
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:oWSFreteGratis       := IIF(::oWSFreteGratis = NIL , NIL , ::oWSFreteGratis:Clone() )
	oClone:oWSFreteGratisRecusado := IIF(::oWSFreteGratisRecusado = NIL , NIL , ::oWSFreteGratisRecusado:Clone() )
	oClone:nItemValorFrete      := ::nItemValorFrete
	oClone:nItemValorFreteCobrado := ::nItemValorFreteCobrado
	oClone:nServicoEntregaCodigo := ::nServicoEntregaCodigo
	oClone:nItemPrazoEntrega    := ::nItemPrazoEntrega
	oClone:cItemDataEntrega     := ::cItemDataEntrega
	oClone:cSedex               := ::cSedex
	oClone:nItemPeso            := ::nItemPeso
	oClone:nItemPesoCubado      := ::nItemPesoCubado
	oClone:nItemPesoCobrado     := ::nItemPesoCobrado
	oClone:nItemPesoCubadoCobrado := ::nItemPesoCubadoCobrado
	oClone:nListaCodigo         := ::nListaCodigo
	oClone:cListaCodigoInterno  := ::cListaCodigoInterno
	oClone:oWSListaTipoEntrega  := IIF(::oWSListaTipoEntrega = NIL , NIL , ::oWSListaTipoEntrega:Clone() )
	oClone:oWSItemTroca         := IIF(::oWSItemTroca = NIL , NIL , ::oWSItemTroca:Clone() )
	oClone:cItemTexto1          := ::cItemTexto1
	oClone:cItemTexto2          := ::cItemTexto2
	oClone:cItemTexto3          := ::cItemTexto3
	oClone:nItemNumero1         := ::nItemNumero1
	oClone:nItemNumero2         := ::nItemNumero2
	oClone:nItemNumero3         := ::nItemNumero3
	oClone:oWSPersonalizacaoExtra := IIF(::oWSPersonalizacaoExtra = NIL , NIL , ::oWSPersonalizacaoExtra:Clone() )
	oClone:cPersonalizacaoTexto := ::cPersonalizacaoTexto
	oClone:cItemCodigoInterno   := ::cItemCodigoInterno
	oClone:cSeloQuantidadeMinimaProduto1 := ::cSeloQuantidadeMinimaProduto1
	oClone:cSeloQuantidadeMinimaProduto2 := ::cSeloQuantidadeMinimaProduto2
	oClone:cSeloQuantidadeMinimaProduto3 := ::cSeloQuantidadeMinimaProduto3
	oClone:nFreteValorFixo      := ::nFreteValorFixo
	oClone:nBasketItemCode      := ::nBasketItemCode
	oClone:nLookCode            := ::nLookCode
	oClone:lCourtesy            := ::lCourtesy
	oClone:nCompanyId           := ::nCompanyId
	oClone:oWSProductsServicesItems := IIF(::oWSProductsServicesItems = NIL , NIL , ::oWSProductsServicesItems:Clone() )
	oClone:oWSWarehouses        := IIF(::oWSWarehouses = NIL , NIL , ::oWSWarehouses:Clone() )
	oClone:nServiceCode         := ::nServiceCode
	oClone:oWSStoreAddress      := IIF(::oWSStoreAddress = NIL , NIL , ::oWSStoreAddress:Clone() )
	oClone:oWSCustomizations    := IIF(::oWSCustomizations = NIL , NIL , ::oWSCustomizations:Clone() )
	oClone:oWSFilesUploadUrl    := IIF(::oWSFilesUploadUrl = NIL , NIL , ::oWSFilesUploadUrl:Clone() )
	oClone:nDiscountsValue      := ::nDiscountsValue
	oClone:oWSDiscounts         := IIF(::oWSDiscounts = NIL , NIL , ::oWSDiscounts:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ItemKH
	Local oNode13
	Local oNode14
	Local oNode21
	Local oNode22
	Local oNode35
	Local oNode36
	Local oNode43
	Local oNode54
	Local oNode55
	Local oNode57
	Local oNode58
	Local oNode59
	Local oNode61
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nItemCodigo        :=  WSAdvValue( oResponse,"_ITEMCODIGO","int",NIL,"Property nItemCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemCodigoComprado :=  WSAdvValue( oResponse,"_ITEMCODIGOCOMPRADO","int",NIL,"Property nItemCodigoComprado as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemStatus        :=  WSAdvValue( oResponse,"_ITEMSTATUS","int",NIL,"Property nItemStatus as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cItemStatusInterno :=  WSAdvValue( oResponse,"_ITEMSTATUSINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nItemQtde          :=  WSAdvValue( oResponse,"_ITEMQTDE","int",NIL,"Property nItemQtde as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValItem         :=  WSAdvValue( oResponse,"_ITEMVALOR","decimal",NIL,"Property nValItem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nValFinal    :=  WSAdvValue( oResponse,"_ITEMVALORFINAL","decimal",NIL,"Property nValFinal as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemValorPresente :=  WSAdvValue( oResponse,"_ITEMVALORPRESENTE","decimal",NIL,"Property nItemValorPresente as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemValorGarantiaEstendida :=  WSAdvValue( oResponse,"_ITEMVALORGARANTIAESTENDIDA","decimal",NIL,"Property nItemValorGarantiaEstendida as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemAnosGarantiaEstendida :=  WSAdvValue( oResponse,"_ITEMANOSGARANTIAESTENDIDA","int",NIL,"Property nItemAnosGarantiaEstendida as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cItemCertificadoGarantiaEstendida :=  WSAdvValue( oResponse,"_ITEMCERTIFICADOGARANTIAESTENDIDA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEnqCodInterno     :=  WSAdvValue( oResponse,"_ENQCODINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode13 :=  WSAdvValue( oResponse,"_ITEMTIPO","ItemTipo",NIL,"Property oWSItemTipo as tns:ItemTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode13 != NIL
		::oWSItemTipo := Pedido_ItemKHTipo():New()
		::oWSItemTipo:SoapRecv(oNode13)
	EndIf
	oNode14 :=  WSAdvValue( oResponse,"_PRESENTE","SimNao",NIL,"Property oWSPresente as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSPresente := Pedido_SimNaoKH():New()
		::oWSPresente:SoapRecv(oNode14)
	EndIf
	::cCupom             :=  WSAdvValue( oResponse,"_CUPOM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemNome          :=  WSAdvValue( oResponse,"_ITEMNOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemMensagem      :=  WSAdvValue( oResponse,"_ITEMMENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemMsgPresente   :=  WSAdvValue( oResponse,"_ITEMMSGPRESENTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemPartNumber    :=  WSAdvValue( oResponse,"_ITEMPARTNUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode21 :=  WSAdvValue( oResponse,"_FRETEGRATIS","SimNao",NIL,"Property oWSFreteGratis as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode21 != NIL
		::oWSFreteGratis := Pedido_SimNaoKH():New()
		::oWSFreteGratis:SoapRecv(oNode21)
	EndIf
	oNode22 :=  WSAdvValue( oResponse,"_FRETEGRATISRECUSADO","FreteGratisRecusado",NIL,"Property oWSFreteGratisRecusado as tns:FreteGratisRecusado on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode22 != NIL
		::oWSFreteGratisRecusado := Pedido_FreteGratisRecusadoKH():New()
		::oWSFreteGratisRecusado:SoapRecv(oNode22)
	EndIf
	::nItemValorFrete    :=  WSAdvValue( oResponse,"_ITEMVALORFRETE","decimal",NIL,"Property nItemValorFrete as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemValorFreteCobrado :=  WSAdvValue( oResponse,"_ITEMVALORFRETECOBRADO","decimal",NIL,"Property nItemValorFreteCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nServicoEntregaCodigo :=  WSAdvValue( oResponse,"_SERVICOENTREGACODIGO","int",NIL,"Property nServicoEntregaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemPrazoEntrega  :=  WSAdvValue( oResponse,"_ITEMPRAZOENTREGA","int",NIL,"Property nItemPrazoEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cItemDataEntrega   :=  WSAdvValue( oResponse,"_ITEMDATAENTREGA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSedex             :=  WSAdvValue( oResponse,"_SEDEX","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nItemPeso          :=  WSAdvValue( oResponse,"_ITEMPESO","decimal",NIL,"Property nItemPeso as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemPesoCubado    :=  WSAdvValue( oResponse,"_ITEMPESOCUBADO","decimal",NIL,"Property nItemPesoCubado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemPesoCobrado   :=  WSAdvValue( oResponse,"_ITEMPESOCOBRADO","decimal",NIL,"Property nItemPesoCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemPesoCubadoCobrado :=  WSAdvValue( oResponse,"_ITEMPESOCUBADOCOBRADO","decimal",NIL,"Property nItemPesoCubadoCobrado as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nListaCodigo       :=  WSAdvValue( oResponse,"_LISTACODIGO","int",NIL,"Property nListaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cListaCodigoInterno :=  WSAdvValue( oResponse,"_LISTACODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode35 :=  WSAdvValue( oResponse,"_LISTATIPOENTREGA","ListaTipoEntrega",NIL,"Property oWSListaTipoEntrega as tns:ListaTipoEntrega on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode35 != NIL
		::oWSListaTipoEntrega := Pedido_ListaTipoEntregaKH():New()
		::oWSListaTipoEntrega:SoapRecv(oNode35)
	EndIf
	oNode36 :=  WSAdvValue( oResponse,"_ITEMTROCA","SimNao",NIL,"Property oWSItemTroca as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode36 != NIL
		::oWSItemTroca := Pedido_SimNaoKH():New()
		::oWSItemTroca:SoapRecv(oNode36)
	EndIf
	::cItemTexto1        :=  WSAdvValue( oResponse,"_ITEMTEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemTexto2        :=  WSAdvValue( oResponse,"_ITEMTEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemTexto3        :=  WSAdvValue( oResponse,"_ITEMTEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nItemNumero1       :=  WSAdvValue( oResponse,"_ITEMNUMERO1","decimal",NIL,"Property nItemNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemNumero2       :=  WSAdvValue( oResponse,"_ITEMNUMERO2","decimal",NIL,"Property nItemNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nItemNumero3       :=  WSAdvValue( oResponse,"_ITEMNUMERO3","decimal",NIL,"Property nItemNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode43 :=  WSAdvValue( oResponse,"_PERSONALIZACAOEXTRA","SimNao",NIL,"Property oWSPersonalizacaoExtra as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode43 != NIL
		::oWSPersonalizacaoExtra := Pedido_SimNaoKH():New()
		::oWSPersonalizacaoExtra:SoapRecv(oNode43)
	EndIf
	::cPersonalizacaoTexto :=  WSAdvValue( oResponse,"_PERSONALIZACAOTEXTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cItemCodigoInterno :=  WSAdvValue( oResponse,"_ITEMCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSeloQuantidadeMinimaProduto1 :=  WSAdvValue( oResponse,"_SELOQUANTIDADEMINIMAPRODUTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSeloQuantidadeMinimaProduto2 :=  WSAdvValue( oResponse,"_SELOQUANTIDADEMINIMAPRODUTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSeloQuantidadeMinimaProduto3 :=  WSAdvValue( oResponse,"_SELOQUANTIDADEMINIMAPRODUTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nFreteValorFixo    :=  WSAdvValue( oResponse,"_FRETEVALORFIXO","decimal",NIL,"Property nFreteValorFixo as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nBasketItemCode    :=  WSAdvValue( oResponse,"_BASKETITEMCODE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nLookCode          :=  WSAdvValue( oResponse,"_LOOKCODE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::lCourtesy          :=  WSAdvValue( oResponse,"_COURTESY","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
	::nCompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode54 :=  WSAdvValue( oResponse,"_PRODUCTSSERVICESITEMS","ArrayOfProductServiceItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode54 != NIL
		::oWSProductsServicesItems := Pedido_ArrayOfProductServiceItem():New()
		::oWSProductsServicesItems:SoapRecv(oNode54)
	EndIf
	oNode55 :=  WSAdvValue( oResponse,"_WAREHOUSES","ArrayOfWarehousesItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode55 != NIL
		::oWSWarehouses := Pedido_ArrayOfWarehousesItem():New()
		::oWSWarehouses:SoapRecv(oNode55)
	EndIf
	::nServiceCode       :=  WSAdvValue( oResponse,"_SERVICECODE","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode57 :=  WSAdvValue( oResponse,"_STOREADDRESS","Address",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode57 != NIL
		::oWSStoreAddress := Pedido_Address():New()
		::oWSStoreAddress:SoapRecv(oNode57)
	EndIf
	oNode58 :=  WSAdvValue( oResponse,"_CUSTOMIZATIONS","ArrayOfCustomizationItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode58 != NIL
		::oWSCustomizations := Pedido_ArrayOfCustomizationItem():New()
		::oWSCustomizations:SoapRecv(oNode58)
	EndIf
	oNode59 :=  WSAdvValue( oResponse,"_FILESUPLOADURL","ArrayOfString",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode59 != NIL
		::oWSFilesUploadUrl := Pedido_ArrayOfString():New()
		::oWSFilesUploadUrl:SoapRecv(oNode59)
	EndIf
	::nDiscountsValue    :=  WSAdvValue( oResponse,"_DISCOUNTSVALUE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode61 :=  WSAdvValue( oResponse,"_DISCOUNTS","ArrayOfDiscountItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode61 != NIL
		::oWSDiscounts := Pedido_ArrayOfDiscountItem():New()
		::oWSDiscounts:SoapRecv(oNode61)
	EndIf
Return

// WSDL Data Structure clsStatusHistoricoPedido

WSSTRUCT Pedido_clsStatusHistoricoPedido
	WSDATA   nStatusCodigo             AS int
	WSDATA   cLabelAdmin               AS string OPTIONAL
	WSDATA   cDataAtualizacao          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_clsStatusHistoricoPedido
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_clsStatusHistoricoPedido
Return

WSMETHOD CLONE WSCLIENT Pedido_clsStatusHistoricoPedido
	Local oClone := Pedido_clsStatusHistoricoPedido():NEW()
	oClone:nStatusCodigo        := ::nStatusCodigo
	oClone:cLabelAdmin          := ::cLabelAdmin
	oClone:cDataAtualizacao     := ::cDataAtualizacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_clsStatusHistoricoPedido
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nStatusCodigo      :=  WSAdvValue( oResponse,"_STATUSCODIGO","int",NIL,"Property nStatusCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cLabelAdmin        :=  WSAdvValue( oResponse,"_LABELADMIN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataAtualizacao   :=  WSAdvValue( oResponse,"_DATAATUALIZACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure Prescription

WSSTRUCT Pedido_Prescription
	WSDATA   nOrderCode                AS int
	WSDATA   cName                     AS string OPTIONAL
	WSDATA   cCRM                      AS string OPTIONAL
	WSDATA   cState                    AS string OPTIONAL
	WSDATA   cSpecialty                AS string OPTIONAL
	WSDATA   cNoDataReason             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_Prescription
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_Prescription
Return

WSMETHOD CLONE WSCLIENT Pedido_Prescription
	Local oClone := Pedido_Prescription():NEW()
	oClone:nOrderCode           := ::nOrderCode
	oClone:cName                := ::cName
	oClone:cCRM                 := ::cCRM
	oClone:cState               := ::cState
	oClone:cSpecialty           := ::cSpecialty
	oClone:cNoDataReason        := ::cNoDataReason
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_Prescription
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nOrderCode         :=  WSAdvValue( oResponse,"_ORDERCODE","int",NIL,"Property nOrderCode as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cName              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCRM               :=  WSAdvValue( oResponse,"_CRM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cState             :=  WSAdvValue( oResponse,"_STATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSpecialty         :=  WSAdvValue( oResponse,"_SPECIALTY","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNoDataReason      :=  WSAdvValue( oResponse,"_NODATAREASON","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure DadoComplementar

WSSTRUCT Pedido_DadoComplementar
	WSDATA   cChave                    AS string OPTIONAL
	WSDATA   cValor                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_DadoComplementar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_DadoComplementar
Return

WSMETHOD CLONE WSCLIENT Pedido_DadoComplementar
	Local oClone := Pedido_DadoComplementar():NEW()
	oClone:cChave               := ::cChave
	oClone:cValor               := ::cValor
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_DadoComplementar
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cChave             :=  WSAdvValue( oResponse,"_CHAVE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cValor             :=  WSAdvValue( oResponse,"_VALOR","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure PayBilletInvoiceData

WSSTRUCT Pedido_PayBilletInvoiceData
	WSDATA   cId                       AS string OPTIONAL
	WSDATA   cReference                AS string OPTIONAL
	WSDATA   oWSStatus                 AS Pedido_PaymentStatus
	WSDATA   nAmount                   AS decimal
	WSDATA   nPaidAmount               AS decimal
	WSDATA   cPaidDate                 AS dateTime
	WSDATA   nRefundableAmount         AS decimal
	WSDATA   cMethod                   AS string OPTIONAL
	WSDATA   oWSBilletInvoiceData      AS Pedido_BilletInvoiceData OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PayBilletInvoiceData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_PayBilletInvoiceData
Return

WSMETHOD CLONE WSCLIENT Pedido_PayBilletInvoiceData
	Local oClone := Pedido_PayBilletInvoiceData():NEW()
	oClone:cId                  := ::cId
	oClone:cReference           := ::cReference
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
	oClone:nAmount              := ::nAmount
	oClone:nPaidAmount          := ::nPaidAmount
	oClone:cPaidDate            := ::cPaidDate
	oClone:nRefundableAmount    := ::nRefundableAmount
	oClone:cMethod              := ::cMethod
	oClone:oWSBilletInvoiceData := IIF(::oWSBilletInvoiceData = NIL , NIL , ::oWSBilletInvoiceData:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PayBilletInvoiceData
	Local oNode3
	Local oNode9
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cId                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cReference         :=  WSAdvValue( oResponse,"_REFERENCE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_STATUS","PaymentStatus",NIL,"Property oWSStatus as tns:PaymentStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSStatus := Pedido_PaymentStatus():New()
		::oWSStatus:SoapRecv(oNode3)
	EndIf
	::nAmount            :=  WSAdvValue( oResponse,"_AMOUNT","decimal",NIL,"Property nAmount as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPaidAmount        :=  WSAdvValue( oResponse,"_PAIDAMOUNT","decimal",NIL,"Property nPaidAmount as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPaidDate          :=  WSAdvValue( oResponse,"_PAIDDATE","dateTime",NIL,"Property cPaidDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nRefundableAmount  :=  WSAdvValue( oResponse,"_REFUNDABLEAMOUNT","decimal",NIL,"Property nRefundableAmount as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cMethod            :=  WSAdvValue( oResponse,"_METHOD","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode9 :=  WSAdvValue( oResponse,"_BILLETINVOICEDATA","BilletInvoiceData",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSBilletInvoiceData := Pedido_BilletInvoiceData():New()
		::oWSBilletInvoiceData:SoapRecv(oNode9)
	EndIf
Return

// WSDL Data Enumeration ItemTipo

WSSTRUCT Pedido_ItemKHTipo
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ItemKHTipo
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Produto" )
	aadd(::aValueList , "Brinde" )
	aadd(::aValueList , "ProdutoGratis" )
	aadd(::aValueList , "ValePresente" )
	aadd(::aValueList , "Personalizado" )
	aadd(::aValueList , "Manipulado" )
	aadd(::aValueList , "ServicoObrigatorio" )
	aadd(::aValueList , "ServicoOpcional" )
	aadd(::aValueList , "Assinatura" )
	aadd(::aValueList , "Componente" )
	aadd(::aValueList , "ExclusivoLook" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_ItemKHTipo
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ItemKHTipo
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_ItemKHTipo
Local oClone := Pedido_ItemKHTipo():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ListaTipoEntrega

WSSTRUCT Pedido_ListaTipoEntregaKH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ListaTipoEntregaKH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "CadaCompra" )
	aadd(::aValueList , "Semanalmente" )
	aadd(::aValueList , "Unica" )
	aadd(::aValueList , "Creditos" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_ListaTipoEntregaKH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ListaTipoEntregaKH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_ListaTipoEntregaKH
Local oClone := Pedido_ListaTipoEntregaKH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfProductServiceItem

WSSTRUCT Pedido_ArrayOfProductServiceItem
	WSDATA   oWSProductServiceItem     AS Pedido_ProductServiceItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfProductServiceItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfProductServiceItem
	::oWSProductServiceItem := {} // Array Of  Pedido_PRODUCTSERVICEITEM():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfProductServiceItem
	Local oClone := Pedido_ArrayOfProductServiceItem():NEW()
	oClone:oWSProductServiceItem := NIL
	If ::oWSProductServiceItem <> NIL 
		oClone:oWSProductServiceItem := {}
		aEval( ::oWSProductServiceItem , { |x| aadd( oClone:oWSProductServiceItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfProductServiceItem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_PRODUCTSERVICEITEM","ProductServiceItem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSProductServiceItem , Pedido_ProductServiceItem():New() )
			::oWSProductServiceItem[len(::oWSProductServiceItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfWarehousesItem

WSSTRUCT Pedido_ArrayOfWarehousesItem
	WSDATA   oWSWarehousesItem         AS Pedido_WarehousesItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfWarehousesItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfWarehousesItem
	::oWSWarehousesItem    := {} // Array Of  Pedido_WAREHOUSESITEM():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfWarehousesItem
	Local oClone := Pedido_ArrayOfWarehousesItem():NEW()
	oClone:oWSWarehousesItem := NIL
	If ::oWSWarehousesItem <> NIL 
		oClone:oWSWarehousesItem := {}
		aEval( ::oWSWarehousesItem , { |x| aadd( oClone:oWSWarehousesItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfWarehousesItem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_WAREHOUSESITEM","WarehousesItem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSWarehousesItem , Pedido_WarehousesItem():New() )
			::oWSWarehousesItem[len(::oWSWarehousesItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure Address

WSSTRUCT Pedido_Address
	WSDATA   cInternalCode             AS string OPTIONAL
	WSDATA   cName                     AS string OPTIONAL
	WSDATA   cType                     AS string OPTIONAL
	WSDATA   cPurposeType              AS string OPTIONAL
	WSDATA   cRoadType                 AS string OPTIONAL
	WSDATA   cAddressInfo              AS string OPTIONAL
	WSDATA   cNumber                   AS string OPTIONAL
	WSDATA   cComplement               AS string OPTIONAL
	WSDATA   cReference                AS string OPTIONAL
	WSDATA   cNeighborhood             AS string OPTIONAL
	WSDATA   cState                    AS string OPTIONAL
	WSDATA   cCity                     AS string OPTIONAL
	WSDATA   nCountryId                AS int
	WSDATA   cZipCode                  AS string OPTIONAL
	WSDATA   cAreaCode1                AS string OPTIONAL
	WSDATA   cTelephoneNumber1         AS string OPTIONAL
	WSDATA   cExtensionNumber1         AS string OPTIONAL
	WSDATA   cAreaCode2                AS string OPTIONAL
	WSDATA   cTelephoneNumber2         AS string OPTIONAL
	WSDATA   cExtensionNumber2         AS string OPTIONAL
	WSDATA   cAreaCode3                AS string OPTIONAL
	WSDATA   cTelephoneNumber3         AS string OPTIONAL
	WSDATA   cExtensionNumber3         AS string OPTIONAL
	WSDATA   cCelAreaCode              AS string OPTIONAL
	WSDATA   cCelNumber                AS string OPTIONAL
	WSDATA   cParametrizedText1        AS string OPTIONAL
	WSDATA   cParametrizedText2        AS string OPTIONAL
	WSDATA   cParametrizedText3        AS string OPTIONAL
	WSDATA   nParametrizedNumber1      AS decimal
	WSDATA   nParametrizedNumber2      AS decimal
	WSDATA   nParametrizedNumber3      AS decimal
	WSDATA   cStatus                   AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   lIsCommissioned           AS boolean
	WSDATA   cCreateDate               AS dateTime
	WSDATA   cChangeDate               AS dateTime
	WSDATA   nStoreId                  AS int
	WSDATA   nDeliveryTime             AS int
	WSDATA   nWarehouseId              AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_Address
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_Address
Return

WSMETHOD CLONE WSCLIENT Pedido_Address
	Local oClone := Pedido_Address():NEW()
	oClone:cInternalCode        := ::cInternalCode
	oClone:cName                := ::cName
	oClone:cType                := ::cType
	oClone:cPurposeType         := ::cPurposeType
	oClone:cRoadType            := ::cRoadType
	oClone:cAddressInfo         := ::cAddressInfo
	oClone:cNumber              := ::cNumber
	oClone:cComplement          := ::cComplement
	oClone:cReference           := ::cReference
	oClone:cNeighborhood        := ::cNeighborhood
	oClone:cState               := ::cState
	oClone:cCity                := ::cCity
	oClone:nCountryId           := ::nCountryId
	oClone:cZipCode             := ::cZipCode
	oClone:cAreaCode1           := ::cAreaCode1
	oClone:cTelephoneNumber1    := ::cTelephoneNumber1
	oClone:cExtensionNumber1    := ::cExtensionNumber1
	oClone:cAreaCode2           := ::cAreaCode2
	oClone:cTelephoneNumber2    := ::cTelephoneNumber2
	oClone:cExtensionNumber2    := ::cExtensionNumber2
	oClone:cAreaCode3           := ::cAreaCode3
	oClone:cTelephoneNumber3    := ::cTelephoneNumber3
	oClone:cExtensionNumber3    := ::cExtensionNumber3
	oClone:cCelAreaCode         := ::cCelAreaCode
	oClone:cCelNumber           := ::cCelNumber
	oClone:cParametrizedText1   := ::cParametrizedText1
	oClone:cParametrizedText2   := ::cParametrizedText2
	oClone:cParametrizedText3   := ::cParametrizedText3
	oClone:nParametrizedNumber1 := ::nParametrizedNumber1
	oClone:nParametrizedNumber2 := ::nParametrizedNumber2
	oClone:nParametrizedNumber3 := ::nParametrizedNumber3
	oClone:cStatus              := ::cStatus
	oClone:cCNPJ                := ::cCNPJ
	oClone:lIsCommissioned      := ::lIsCommissioned
	oClone:cCreateDate          := ::cCreateDate
	oClone:cChangeDate          := ::cChangeDate
	oClone:nStoreId             := ::nStoreId
	oClone:nDeliveryTime        := ::nDeliveryTime
	oClone:nWarehouseId         := ::nWarehouseId
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_Address
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cInternalCode      :=  WSAdvValue( oResponse,"_INTERNALCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cName              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cType              :=  WSAdvValue( oResponse,"_TYPE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPurposeType       :=  WSAdvValue( oResponse,"_PURPOSETYPE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRoadType          :=  WSAdvValue( oResponse,"_ROADTYPE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAddressInfo       :=  WSAdvValue( oResponse,"_ADDRESSINFO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumber            :=  WSAdvValue( oResponse,"_NUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplement        :=  WSAdvValue( oResponse,"_COMPLEMENT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cReference         :=  WSAdvValue( oResponse,"_REFERENCE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNeighborhood      :=  WSAdvValue( oResponse,"_NEIGHBORHOOD","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cState             :=  WSAdvValue( oResponse,"_STATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCity              :=  WSAdvValue( oResponse,"_CITY","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCountryId         :=  WSAdvValue( oResponse,"_COUNTRYID","int",NIL,"Property nCountryId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cZipCode           :=  WSAdvValue( oResponse,"_ZIPCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAreaCode1         :=  WSAdvValue( oResponse,"_AREACODE1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelephoneNumber1  :=  WSAdvValue( oResponse,"_TELEPHONENUMBER1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExtensionNumber1  :=  WSAdvValue( oResponse,"_EXTENSIONNUMBER1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAreaCode2         :=  WSAdvValue( oResponse,"_AREACODE2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelephoneNumber2  :=  WSAdvValue( oResponse,"_TELEPHONENUMBER2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExtensionNumber2  :=  WSAdvValue( oResponse,"_EXTENSIONNUMBER2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cAreaCode3         :=  WSAdvValue( oResponse,"_AREACODE3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTelephoneNumber3  :=  WSAdvValue( oResponse,"_TELEPHONENUMBER3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExtensionNumber3  :=  WSAdvValue( oResponse,"_EXTENSIONNUMBER3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCelAreaCode       :=  WSAdvValue( oResponse,"_CELAREACODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCelNumber         :=  WSAdvValue( oResponse,"_CELNUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cParametrizedText1 :=  WSAdvValue( oResponse,"_PARAMETRIZEDTEXT1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cParametrizedText2 :=  WSAdvValue( oResponse,"_PARAMETRIZEDTEXT2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cParametrizedText3 :=  WSAdvValue( oResponse,"_PARAMETRIZEDTEXT3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nParametrizedNumber1 :=  WSAdvValue( oResponse,"_PARAMETRIZEDNUMBER1","decimal",NIL,"Property nParametrizedNumber1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nParametrizedNumber2 :=  WSAdvValue( oResponse,"_PARAMETRIZEDNUMBER2","decimal",NIL,"Property nParametrizedNumber2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nParametrizedNumber3 :=  WSAdvValue( oResponse,"_PARAMETRIZEDNUMBER3","decimal",NIL,"Property nParametrizedNumber3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cStatus            :=  WSAdvValue( oResponse,"_STATUS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lIsCommissioned    :=  WSAdvValue( oResponse,"_ISCOMMISSIONED","boolean",NIL,"Property lIsCommissioned as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cCreateDate        :=  WSAdvValue( oResponse,"_CREATEDATE","dateTime",NIL,"Property cCreateDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cChangeDate        :=  WSAdvValue( oResponse,"_CHANGEDATE","dateTime",NIL,"Property cChangeDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nStoreId           :=  WSAdvValue( oResponse,"_STOREID","int",NIL,"Property nStoreId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nDeliveryTime      :=  WSAdvValue( oResponse,"_DELIVERYTIME","int",NIL,"Property nDeliveryTime as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nWarehouseId       :=  WSAdvValue( oResponse,"_WAREHOUSEID","int",NIL,"Property nWarehouseId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfCustomizationItem

WSSTRUCT Pedido_ArrayOfCustomizationItem
	WSDATA   oWSCustomizationItem      AS Pedido_CustomizationItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfCustomizationItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfCustomizationItem
	::oWSCustomizationItem := {} // Array Of  Pedido_CUSTOMIZATIONITEM():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfCustomizationItem
	Local oClone := Pedido_ArrayOfCustomizationItem():NEW()
	oClone:oWSCustomizationItem := NIL
	If ::oWSCustomizationItem <> NIL 
		oClone:oWSCustomizationItem := {}
		aEval( ::oWSCustomizationItem , { |x| aadd( oClone:oWSCustomizationItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfCustomizationItem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CUSTOMIZATIONITEM","CustomizationItem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCustomizationItem , Pedido_CustomizationItem():New() )
			::oWSCustomizationItem[len(::oWSCustomizationItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfString

WSSTRUCT Pedido_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfString
	Local oClone := Pedido_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfString
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cstring ,  x:TEXT  ) } )
Return

// WSDL Data Structure ArrayOfDiscountItem

WSSTRUCT Pedido_ArrayOfDiscountItem
	WSDATA   oWSDiscountItem           AS Pedido_DiscountItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ArrayOfDiscountItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ArrayOfDiscountItem
	::oWSDiscountItem      := {} // Array Of  Pedido_DISCOUNTITEM():New()
Return

WSMETHOD CLONE WSCLIENT Pedido_ArrayOfDiscountItem
	Local oClone := Pedido_ArrayOfDiscountItem():NEW()
	oClone:oWSDiscountItem := NIL
	If ::oWSDiscountItem <> NIL 
		oClone:oWSDiscountItem := {}
		aEval( ::oWSDiscountItem , { |x| aadd( oClone:oWSDiscountItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ArrayOfDiscountItem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_DISCOUNTITEM","DiscountItem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSDiscountItem , Pedido_DiscountItem():New() )
			::oWSDiscountItem[len(::oWSDiscountItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Enumeration PaymentStatus

WSSTRUCT Pedido_PaymentStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_PaymentStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Pending" )
	aadd(::aValueList , "Review" )
	aadd(::aValueList , "Approved" )
	aadd(::aValueList , "Cancelled" )
	aadd(::aValueList , "Authorized" )
	aadd(::aValueList , "Completed" )
	aadd(::aValueList , "Rejected" )
	aadd(::aValueList , "Refunded" )
	aadd(::aValueList , "PartialRefunded" )
	aadd(::aValueList , "Chargeback" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Pedido_PaymentStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_PaymentStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Pedido_PaymentStatus
Local oClone := Pedido_PaymentStatus():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure BilletInvoiceData

WSSTRUCT Pedido_BilletInvoiceData
	WSDATA   cNumber                   AS string OPTIONAL
	WSDATA   cInstallment              AS string OPTIONAL
	WSDATA   cDownloadUrl              AS string OPTIONAL
	WSDATA   cExpiryDate               AS dateTime
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_BilletInvoiceData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_BilletInvoiceData
Return

WSMETHOD CLONE WSCLIENT Pedido_BilletInvoiceData
	Local oClone := Pedido_BilletInvoiceData():NEW()
	oClone:cNumber              := ::cNumber
	oClone:cInstallment         := ::cInstallment
	oClone:cDownloadUrl         := ::cDownloadUrl
	oClone:cExpiryDate          := ::cExpiryDate
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_BilletInvoiceData
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cNumber            :=  WSAdvValue( oResponse,"_NUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cInstallment       :=  WSAdvValue( oResponse,"_INSTALLMENT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDownloadUrl       :=  WSAdvValue( oResponse,"_DOWNLOADURL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cExpiryDate        :=  WSAdvValue( oResponse,"_EXPIRYDATE","dateTime",NIL,"Property cExpiryDate as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ProductServiceItem

WSSTRUCT Pedido_ProductServiceItem
	WSDATA   cProductServiceInternalCode AS string OPTIONAL
	WSDATA   cProductServiceName       AS string OPTIONAL
	WSDATA   nProductServicePrice      AS decimal
	WSDATA   lProductServiceObligatory AS boolean
	WSDATA   nProductServiceId         AS int
	WSDATA   nQuantity                 AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_ProductServiceItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_ProductServiceItem
Return

WSMETHOD CLONE WSCLIENT Pedido_ProductServiceItem
	Local oClone := Pedido_ProductServiceItem():NEW()
	oClone:cProductServiceInternalCode := ::cProductServiceInternalCode
	oClone:cProductServiceName  := ::cProductServiceName
	oClone:nProductServicePrice := ::nProductServicePrice
	oClone:lProductServiceObligatory := ::lProductServiceObligatory
	oClone:nProductServiceId    := ::nProductServiceId
	oClone:nQuantity            := ::nQuantity
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_ProductServiceItem
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cProductServiceInternalCode :=  WSAdvValue( oResponse,"_PRODUCTSERVICEINTERNALCODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cProductServiceName :=  WSAdvValue( oResponse,"_PRODUCTSERVICENAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nProductServicePrice :=  WSAdvValue( oResponse,"_PRODUCTSERVICEPRICE","decimal",NIL,"Property nProductServicePrice as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::lProductServiceObligatory :=  WSAdvValue( oResponse,"_PRODUCTSERVICEOBLIGATORY","boolean",NIL,"Property lProductServiceObligatory as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::nProductServiceId  :=  WSAdvValue( oResponse,"_PRODUCTSERVICEID","int",NIL,"Property nProductServiceId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQuantity          :=  WSAdvValue( oResponse,"_QUANTITY","int",NIL,"Property nQuantity as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure WarehousesItem

WSSTRUCT Pedido_WarehousesItem
	WSDATA   nWarehouseId              AS int
	WSDATA   nQuantity                 AS int
	WSDATA   nCommissionValue          AS decimal
	WSDATA   cCommissionCNPJ           AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_WarehousesItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_WarehousesItem
Return

WSMETHOD CLONE WSCLIENT Pedido_WarehousesItem
	Local oClone := Pedido_WarehousesItem():NEW()
	oClone:nWarehouseId         := ::nWarehouseId
	oClone:nQuantity            := ::nQuantity
	oClone:nCommissionValue     := ::nCommissionValue
	oClone:cCommissionCNPJ      := ::cCommissionCNPJ
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_WarehousesItem
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nWarehouseId       :=  WSAdvValue( oResponse,"_WAREHOUSEID","int",NIL,"Property nWarehouseId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQuantity          :=  WSAdvValue( oResponse,"_QUANTITY","int",NIL,"Property nQuantity as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCommissionValue   :=  WSAdvValue( oResponse,"_COMMISSIONVALUE","decimal",NIL,"Property nCommissionValue as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCommissionCNPJ    :=  WSAdvValue( oResponse,"_COMMISSIONCNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure CustomizationItem

WSSTRUCT Pedido_CustomizationItem
	WSDATA   nId                       AS int
	WSDATA   nCustomProductId          AS int
	WSDATA   nPrice                    AS decimal
	WSDATA   cText                     AS string OPTIONAL
	WSDATA   cCustomerFile             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_CustomizationItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_CustomizationItem
Return

WSMETHOD CLONE WSCLIENT Pedido_CustomizationItem
	Local oClone := Pedido_CustomizationItem():NEW()
	oClone:nId                  := ::nId
	oClone:nCustomProductId     := ::nCustomProductId
	oClone:nPrice               := ::nPrice
	oClone:cText                := ::cText
	oClone:cCustomerFile        := ::cCustomerFile
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_CustomizationItem
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nId                :=  WSAdvValue( oResponse,"_ID","int",NIL,"Property nId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nCustomProductId   :=  WSAdvValue( oResponse,"_CUSTOMPRODUCTID","int",NIL,"Property nCustomProductId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrice             :=  WSAdvValue( oResponse,"_PRICE","decimal",NIL,"Property nPrice as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cText              :=  WSAdvValue( oResponse,"_TEXT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCustomerFile      :=  WSAdvValue( oResponse,"_CUSTOMERFILE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure DiscountItem

WSSTRUCT Pedido_DiscountItem
	WSDATA   nDiscount                 AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Pedido_DiscountItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Pedido_DiscountItem
Return

WSMETHOD CLONE WSCLIENT Pedido_DiscountItem
	Local oClone := Pedido_DiscountItem():NEW()
	oClone:nDiscount            := ::nDiscount
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Pedido_DiscountItem
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nDiscount          :=  WSAdvValue( oResponse,"_DISCOUNT","decimal",NIL,"Property nDiscount as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


