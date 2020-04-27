#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx?wsdl
Gerado em        05/02/19 10:27:45
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _GKMKQEM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSClienteKh
------------------------------------------------------------------------------- */

WSCLIENT WSClienteKh

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD SalvarConta
	WSMETHOD SalvarUsuario
	WSMETHOD SalvarEndereco
	WSMETHOD Validar
	WSMETHOD ListarNovos
	WSMETHOD Listar
	WSMETHOD SaveCustomer

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cContaCodigoInterno       AS string
	WSDATA   nParceiroCodigo           AS int
	WSDATA   nTipo                     AS int
	WSDATA   cNome                     AS string
	WSDATA   cSobrenome                AS string
	WSDATA   cRazaoSocial              AS string
	WSDATA   cNomeFantasia             AS string
	WSDATA   cCPF                      AS string
	WSDATA   cCNPJ                     AS string
	WSDATA   cRG                       AS string
	WSDATA   cIE                       AS string
	WSDATA   cIM                       AS string
	WSDATA   cDataNascimento           AS dateTime
	WSDATA   nContaStatus              AS int
	WSDATA   cTexto1                   AS string
	WSDATA   cTexto2                   AS string
	WSDATA   cTexto3                   AS string
	WSDATA   nNumero1                  AS int
	WSDATA   nNumero2                  AS int
	WSDATA   nNumero3                  AS int
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarContaResult      AS Cliente_clsRetornoOfclsContakH
	WSDATA   cUsuarioCodigoInterno     AS string
	WSDATA   cLogOn                    AS string
	WSDATA   cSenha                    AS string
	WSDATA   cEmail                    AS string
	WSDATA   nNewsletter               AS int
	WSDATA   nSexo                     AS int
	WSDATA   nUsuarioStatus            AS int
	WSDATA   oWSSalvarUsuarioResult    AS Cliente_clsRetornoOfclsUsuarioKh
	WSDATA   nAfiliadoCodigoEcommerce  AS int
	WSDATA   nCodigoEnderecoEcommerce  AS int
	WSDATA   nFinalidade               AS int
	WSDATA   nTipoLogradouro           AS int
	WSDATA   cLogradouro               AS string
	WSDATA   cNumero                   AS string
	WSDATA   cComplemento              AS string
	WSDATA   cBairro                   AS string
	WSDATA   cCidade                   AS string
	WSDATA   cEstado                   AS string
	WSDATA   cPais                     AS string
	WSDATA   cCEP                      AS string
	WSDATA   cDDD1                     AS string
	WSDATA   cTelefone1                AS string
	WSDATA   cRamal1                   AS string
	WSDATA   cDDD2                     AS string
	WSDATA   cTelefone2                AS string
	WSDATA   cRamal2                   AS string
	WSDATA   cDDD3                     AS string
	WSDATA   cTelefone3                AS string
	WSDATA   cRamal3                   AS string
	WSDATA   cDDDCelular               AS string
	WSDATA   cCelular                  AS string
	WSDATA   cDDDFax                   AS string
	WSDATA   cFax                      AS string
	WSDATA   cReferencia               AS string
	WSDATA   nStatusEndereco           AS int
	WSDATA   oWSSalvarEnderecoResult   AS Cliente_clsRetornoOfclsEnderecokH
	WSDATA   oWSValidarResult          AS Cliente_clsRetornoOfclsUsuarioKh
	WSDATA   oWSListarNovosResult      AS Cliente_clsRetornoOfclsUsuarioKh
	WSDATA   oWSListarResult           AS Cliente_clsRetornoOfclsUsuarioKh
	WSDATA   oWSUsuario                AS Cliente_clsUsuariokH
	WSDATA   oWSSaveCustomerResult     AS Cliente_clsRetornoOfclsUsuarioKh

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSClienteKh
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSClienteKh
	::oWS                := NIL 
	::oWSSalvarContaResult := Cliente_clsRetornoOfclsContakH():New()
	::oWSSalvarUsuarioResult := Cliente_clsRetornoOfclsUsuarioKh():New()
	::oWSSalvarEnderecoResult := Cliente_clsRetornoOfclsEnderecokH():New()
	::oWSValidarResult   := Cliente_clsRetornoOfclsUsuarioKh():New()
	::oWSListarNovosResult := Cliente_clsRetornoOfclsUsuarioKh():New()
	::oWSListarResult    := Cliente_clsRetornoOfclsUsuarioKh():New()
	::oWSUsuario         := Cliente_clsUsuariokH():New()
	::oWSSaveCustomerResult := Cliente_clsRetornoOfclsUsuarioKh():New()
Return

WSMETHOD RESET WSCLIENT WSClienteKh
	::nLojaCodigo        := NIL 
	::cContaCodigoInterno := NIL 
	::nParceiroCodigo    := NIL 
	::nTipo              := NIL 
	::cNome              := NIL 
	::cSobrenome         := NIL 
	::cRazaoSocial       := NIL 
	::cNomeFantasia      := NIL 
	::cCPF               := NIL 
	::cCNPJ              := NIL 
	::cRG                := NIL 
	::cIE                := NIL 
	::cIM                := NIL 
	::cDataNascimento    := NIL 
	::nContaStatus       := NIL 
	::cTexto1            := NIL 
	::cTexto2            := NIL 
	::cTexto3            := NIL 
	::nNumero1           := NIL 
	::nNumero2           := NIL 
	::nNumero3           := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSSalvarContaResult := NIL 
	::cUsuarioCodigoInterno := NIL 
	::cLogOn             := NIL 
	::cSenha             := NIL 
	::cEmail             := NIL 
	::nNewsletter        := NIL 
	::nSexo              := NIL 
	::nUsuarioStatus     := NIL 
	::oWSSalvarUsuarioResult := NIL 
	::nAfiliadoCodigoEcommerce := NIL 
	::nCodigoEnderecoEcommerce := NIL 
	::nFinalidade        := NIL 
	::nTipoLogradouro    := NIL 
	::cLogradouro        := NIL 
	::cNumero            := NIL 
	::cComplemento       := NIL 
	::cBairro            := NIL 
	::cCidade            := NIL 
	::cEstado            := NIL 
	::cPais              := NIL 
	::cCEP               := NIL 
	::cDDD1              := NIL 
	::cTelefone1         := NIL 
	::cRamal1            := NIL 
	::cDDD2              := NIL 
	::cTelefone2         := NIL 
	::cRamal2            := NIL 
	::cDDD3              := NIL 
	::cTelefone3         := NIL 
	::cRamal3            := NIL 
	::cDDDCelular        := NIL 
	::cCelular           := NIL 
	::cDDDFax            := NIL 
	::cFax               := NIL 
	::cReferencia        := NIL 
	::nStatusEndereco    := NIL 
	::oWSSalvarEnderecoResult := NIL 
	::oWSValidarResult   := NIL 
	::oWSListarNovosResult := NIL 
	::oWSListarResult    := NIL 
	::oWSUsuario         := NIL 
	::oWSSaveCustomerResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSClienteKh
Local oClone := WSClienteKh():New()
	oClone:_URL          := ::_URL 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cContaCodigoInterno := ::cContaCodigoInterno
	oClone:nParceiroCodigo := ::nParceiroCodigo
	oClone:nTipo         := ::nTipo
	oClone:cNome         := ::cNome
	oClone:cSobrenome    := ::cSobrenome
	oClone:cRazaoSocial  := ::cRazaoSocial
	oClone:cNomeFantasia := ::cNomeFantasia
	oClone:cCPF          := ::cCPF
	oClone:cCNPJ         := ::cCNPJ
	oClone:cRG           := ::cRG
	oClone:cIE           := ::cIE
	oClone:cIM           := ::cIM
	oClone:cDataNascimento := ::cDataNascimento
	oClone:nContaStatus  := ::nContaStatus
	oClone:cTexto1       := ::cTexto1
	oClone:cTexto2       := ::cTexto2
	oClone:cTexto3       := ::cTexto3
	oClone:nNumero1      := ::nNumero1
	oClone:nNumero2      := ::nNumero2
	oClone:nNumero3      := ::nNumero3
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarContaResult :=  IIF(::oWSSalvarContaResult = NIL , NIL ,::oWSSalvarContaResult:Clone() )
	oClone:cUsuarioCodigoInterno := ::cUsuarioCodigoInterno
	oClone:cLogOn        := ::cLogOn
	oClone:cSenha        := ::cSenha
	oClone:cEmail        := ::cEmail
	oClone:nNewsletter   := ::nNewsletter
	oClone:nSexo         := ::nSexo
	oClone:nUsuarioStatus := ::nUsuarioStatus
	oClone:oWSSalvarUsuarioResult :=  IIF(::oWSSalvarUsuarioResult = NIL , NIL ,::oWSSalvarUsuarioResult:Clone() )
	oClone:nAfiliadoCodigoEcommerce := ::nAfiliadoCodigoEcommerce
	oClone:nCodigoEnderecoEcommerce := ::nCodigoEnderecoEcommerce
	oClone:nFinalidade   := ::nFinalidade
	oClone:nTipoLogradouro := ::nTipoLogradouro
	oClone:cLogradouro   := ::cLogradouro
	oClone:cNumero       := ::cNumero
	oClone:cComplemento  := ::cComplemento
	oClone:cBairro       := ::cBairro
	oClone:cCidade       := ::cCidade
	oClone:cEstado       := ::cEstado
	oClone:cPais         := ::cPais
	oClone:cCEP          := ::cCEP
	oClone:cDDD1         := ::cDDD1
	oClone:cTelefone1    := ::cTelefone1
	oClone:cRamal1       := ::cRamal1
	oClone:cDDD2         := ::cDDD2
	oClone:cTelefone2    := ::cTelefone2
	oClone:cRamal2       := ::cRamal2
	oClone:cDDD3         := ::cDDD3
	oClone:cTelefone3    := ::cTelefone3
	oClone:cRamal3       := ::cRamal3
	oClone:cDDDCelular   := ::cDDDCelular
	oClone:cCelular      := ::cCelular
	oClone:cDDDFax       := ::cDDDFax
	oClone:cFax          := ::cFax
	oClone:cReferencia   := ::cReferencia
	oClone:nStatusEndereco := ::nStatusEndereco
	oClone:oWSSalvarEnderecoResult :=  IIF(::oWSSalvarEnderecoResult = NIL , NIL ,::oWSSalvarEnderecoResult:Clone() )
	oClone:oWSValidarResult :=  IIF(::oWSValidarResult = NIL , NIL ,::oWSValidarResult:Clone() )
	oClone:oWSListarNovosResult :=  IIF(::oWSListarNovosResult = NIL , NIL ,::oWSListarNovosResult:Clone() )
	oClone:oWSListarResult :=  IIF(::oWSListarResult = NIL , NIL ,::oWSListarResult:Clone() )
	oClone:oWSUsuario    :=  IIF(::oWSUsuario = NIL , NIL ,::oWSUsuario:Clone() )
	oClone:oWSSaveCustomerResult :=  IIF(::oWSSaveCustomerResult = NIL , NIL ,::oWSSaveCustomerResult:Clone() )
Return oClone

// WSDL Method SalvarConta of Service WSClienteKh

WSMETHOD SalvarConta WSSEND nLojaCodigo,cContaCodigoInterno,nParceiroCodigo,nTipo,cNome,cSobrenome,cRazaoSocial,cNomeFantasia,cCPF,cCNPJ,cRG,cIE,cIM,cDataNascimento,nContaStatus,cTexto1,cTexto2,cTexto3,nNumero1,nNumero2,nNumero3,cA1,cA2,oWS WSRECEIVE oWSSalvarContaResult WSCLIENT WSClienteKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarConta xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ContaCodigoInterno", ::cContaCodigoInterno, cContaCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ParceiroCodigo", ::nParceiroCodigo, nParceiroCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Nome", ::cNome, cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Sobrenome", ::cSobrenome, cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, cRazaoSocial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeFantasia", ::cNomeFantasia, cNomeFantasia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("RG", ::cRG, cRG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("IE", ::cIE, cIE , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("IM", ::cIM, cIM , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, cDataNascimento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ContaStatus", ::nContaStatus, nContaStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1", ::cTexto1, cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2", ::cTexto2, cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3", ::cTexto3, cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1", ::nNumero1, nNumero1 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2", ::nNumero2, nNumero2 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3", ::nNumero3, nNumero3 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarConta>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarConta",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSSalvarContaResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARCONTARESPONSE:_SALVARCONTARESULT","clsRetornoOfclsConta",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarUsuario of Service WSClienteKh

WSMETHOD SalvarUsuario WSSEND nLojaCodigo,cUsuarioCodigoInterno,cContaCodigoInterno,cLogOn,cSenha,cNome,cSobrenome,cEmail,nNewsletter,nSexo,nUsuarioStatus,cTexto1,cTexto2,cTexto3,nNumero1,nNumero2,nNumero3,cA1,cA2,oWS WSRECEIVE oWSSalvarUsuarioResult WSCLIENT WSClienteKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarUsuario xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("UsuarioCodigoInterno", ::cUsuarioCodigoInterno, cUsuarioCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ContaCodigoInterno", ::cContaCodigoInterno, cContaCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LogOn", ::cLogOn, cLogOn , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Senha", ::cSenha, cSenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Nome", ::cNome, cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Sobrenome", ::cSobrenome, cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Email", ::cEmail, cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Newsletter", ::nNewsletter, nNewsletter , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Sexo", ::nSexo, nSexo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("UsuarioStatus", ::nUsuarioStatus, nUsuarioStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1", ::cTexto1, cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2", ::cTexto2, cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3", ::cTexto3, cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1", ::nNumero1, nNumero1 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2", ::nNumero2, nNumero2 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3", ::nNumero3, nNumero3 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarUsuario>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarUsuario",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSSalvarUsuarioResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARUSUARIORESPONSE:_SALVARUSUARIORESULT","clsRetornoOfclsUsuario",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarEndereco of Service WSClienteKh

WSMETHOD SalvarEndereco WSSEND nLojaCodigo,cContaCodigoInterno,nAfiliadoCodigoEcommerce,nCodigoEnderecoEcommerce,cNome,cEmail,nTipo,nFinalidade,nTipoLogradouro,cLogradouro,cNumero,cComplemento,cBairro,cCidade,cEstado,cPais,cCEP,cDDD1,cTelefone1,cRamal1,cDDD2,cTelefone2,cRamal2,cDDD3,cTelefone3,cRamal3,cDDDCelular,cCelular,cDDDFax,cFax,cReferencia,nStatusEndereco,cTexto1,cTexto2,cTexto3,nNumero1,nNumero2,nNumero3,cA1,cA2,oWS WSRECEIVE oWSSalvarEnderecoResult WSCLIENT WSClienteKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarEndereco xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ContaCodigoInterno", ::cContaCodigoInterno, cContaCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AfiliadoCodigoEcommerce", ::nAfiliadoCodigoEcommerce, nAfiliadoCodigoEcommerce , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoEnderecoEcommerce", ::nCodigoEnderecoEcommerce, nCodigoEnderecoEcommerce , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Nome", ::cNome, cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Email", ::cEmail, cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Finalidade", ::nFinalidade, nFinalidade , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoLogradouro", ::nTipoLogradouro, nTipoLogradouro , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Logradouro", ::cLogradouro, cLogradouro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero", ::cNumero, cNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Complemento", ::cComplemento, cComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Bairro", ::cBairro, cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Cidade", ::cCidade, cCidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Estado", ::cEstado, cEstado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Pais", ::cPais, cPais , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CEP", ::cCEP, cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DDD1", ::cDDD1, cDDD1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Telefone1", ::cTelefone1, cTelefone1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Ramal1", ::cRamal1, cRamal1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DDD2", ::cDDD2, cDDD2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Telefone2", ::cTelefone2, cTelefone2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Ramal2", ::cRamal2, cRamal2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DDD3", ::cDDD3, cDDD3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Telefone3", ::cTelefone3, cTelefone3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Ramal3", ::cRamal3, cRamal3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DDDCelular", ::cDDDCelular, cDDDCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Celular", ::cCelular, cCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DDDFax", ::cDDDFax, cDDDFax , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Fax", ::cFax, cFax , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Referencia", ::cReferencia, cReferencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusEndereco", ::nStatusEndereco, nStatusEndereco , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1", ::cTexto1, cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2", ::cTexto2, cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3", ::cTexto3, cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1", ::nNumero1, nNumero1 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2", ::nNumero2, nNumero2 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3", ::nNumero3, nNumero3 , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarEndereco>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarEndereco",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSSalvarEnderecoResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARENDERECORESPONSE:_SALVARENDERECORESULT","clsRetornoOfclsEndereco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Validar of Service WSClienteKh

WSMETHOD Validar WSSEND nLojaCodigo,cEmail,cContaCodigoInterno,cA1,cA2,oWS WSRECEIVE oWSValidarResult WSCLIENT WSClienteKh
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
cSoap += WSSoapValue("Email", ::cEmail, cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ContaCodigoInterno", ::cContaCodigoInterno, cContaCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Validar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Validar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSValidarResult:SoapRecv( WSAdvValue( oXmlRet,"_VALIDARRESPONSE:_VALIDARRESULT","clsRetornoOfclsUsuario",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ListarNovos of Service WSClienteKh

WSMETHOD ListarNovos WSSEND nLojaCodigo,cA1,cA2,oWS WSRECEIVE oWSListarNovosResult WSCLIENT WSClienteKh
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
cSoap += "</ListarNovos>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ListarNovos",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSListarNovosResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARNOVOSRESPONSE:_LISTARNOVOSRESULT","clsRetornoOfclsUsuario",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service WSClienteKh

WSMETHOD Listar WSSEND nLojaCodigo,cemail,cCPF,cCNPJ,cA1,cA2,oWS WSRECEIVE oWSListarResult WSCLIENT WSClienteKh
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
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CPF", ::cCPF, cCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","clsRetornoOfclsUsuario",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveCustomer of Service WSClienteKh

WSMETHOD SaveCustomer WSSEND oWSUsuario,cA1,cA2,oWS WSRECEIVE oWSSaveCustomerResult WSCLIENT WSClienteKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SaveCustomer xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("Usuario", ::oWSUsuario, oWSUsuario , "clsUsuario", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveCustomer>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SaveCustomer",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/cliente.asmx")

::Init()
::oWSSaveCustomerResult:SoapRecv( WSAdvValue( oXmlRet,"_SAVECUSTOMERRESPONSE:_SAVECUSTOMERRESULT","clsRetornoOfclsUsuario",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsConta

WSSTRUCT Cliente_clsRetornoOfclsContakH
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Cliente_ArrayOfClsContaKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsRetornoOfclsContakH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsRetornoOfclsContakH
Return

WSMETHOD CLONE WSCLIENT Cliente_clsRetornoOfclsContakH
	Local oClone := Cliente_clsRetornoOfclsContakH():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsRetornoOfclsContakH
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsConta",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Cliente_ArrayOfClsContaKH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure clsRetornoOfclsUsuario

WSSTRUCT Cliente_clsRetornoOfclsUsuarioKh
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Cliente_ArrayOfClsUsuariokH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsRetornoOfclsUsuarioKh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsRetornoOfclsUsuarioKh
Return

WSMETHOD CLONE WSCLIENT Cliente_clsRetornoOfclsUsuarioKh
	Local oClone := Cliente_clsRetornoOfclsUsuarioKh():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsRetornoOfclsUsuarioKh
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsUsuario",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Cliente_ArrayOfClsUsuariokH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure clsRetornoOfclsEndereco

WSSTRUCT Cliente_clsRetornoOfclsEnderecokH
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Cliente_ArrayOfClsEnderecokH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsRetornoOfclsEnderecokH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsRetornoOfclsEnderecokH
Return

WSMETHOD CLONE WSCLIENT Cliente_clsRetornoOfclsEnderecokH
	Local oClone := Cliente_clsRetornoOfclsEnderecokH():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsRetornoOfclsEnderecokH
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsEndereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Cliente_ArrayOfClsEnderecokH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsConta

WSSTRUCT Cliente_ArrayOfClsContaKH
	WSDATA   oWSclsConta               AS Cliente_clsContakH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_ArrayOfClsContaKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_ArrayOfClsContaKH
	::oWSclsConta          := {} // Array Of  Cliente_clsContakH():New()
Return

WSMETHOD CLONE WSCLIENT Cliente_ArrayOfClsContaKH
	Local oClone := Cliente_ArrayOfClsContaKH():NEW()
	oClone:oWSclsConta := NIL
	If ::oWSclsConta <> NIL 
		oClone:oWSclsConta := {}
		aEval( ::oWSclsConta , { |x| aadd( oClone:oWSclsConta , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_ArrayOfClsContaKH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSCONTA","clsConta",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsConta , Cliente_clsContakH():New() )
			::oWSclsConta[len(::oWSclsConta)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfClsUsuario

WSSTRUCT Cliente_ArrayOfClsUsuariokH
	WSDATA   oWSclsUsuario             AS Cliente_clsUsuariokH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_ArrayOfClsUsuariokH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_ArrayOfClsUsuariokH
	::oWSclsUsuario        := {} // Array Of  Cliente_clsUsuariokH():New()
Return

WSMETHOD CLONE WSCLIENT Cliente_ArrayOfClsUsuariokH
	Local oClone := Cliente_ArrayOfClsUsuariokH():NEW()
	oClone:oWSclsUsuario := NIL
	If ::oWSclsUsuario <> NIL 
		oClone:oWSclsUsuario := {}
		aEval( ::oWSclsUsuario , { |x| aadd( oClone:oWSclsUsuario , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_ArrayOfClsUsuariokH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSUSUARIO","clsUsuario",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsUsuario , Cliente_clsUsuariokH():New() )
			::oWSclsUsuario[len(::oWSclsUsuario)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsConta

WSSTRUCT Cliente_clsContakH
	WSDATA   nLojaCodigo               AS int
	WSDATA   cContaCodigoInterno       AS string OPTIONAL
	WSDATA   nParceiroCodigo           AS int
	WSDATA   nAfiliadoCodigo           AS int
	WSDATA   oWSTipo                   AS Cliente_ContaTipokH
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cRazaoSocial              AS string OPTIONAL
	WSDATA   cNomeFantasia             AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cCNPJ                     AS string OPTIONAL
	WSDATA   cRG                       AS string OPTIONAL
	WSDATA   cIE                       AS string OPTIONAL
	WSDATA   cIM                       AS string OPTIONAL
	WSDATA   cDataNascimento           AS string OPTIONAL
	WSDATA   oWSContaStatus            AS Cliente_ContaStatuskH
	WSDATA   cTexto1                   AS string OPTIONAL
	WSDATA   cTexto2                   AS string OPTIONAL
	WSDATA   cTexto3                   AS string OPTIONAL
	WSDATA   nNumero1                  AS decimal
	WSDATA   nNumero2                  AS decimal
	WSDATA   nNumero3                  AS decimal
	WSDATA   nParceiroCodigoAtacado    AS int OPTIONAL
	WSDATA   oWSSituacaoCadastral      AS Cliente_SituacaoCadastral OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsContakH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsContakH
Return

WSMETHOD CLONE WSCLIENT Cliente_clsContakH
	Local oClone := Cliente_clsContakH():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:cContaCodigoInterno  := ::cContaCodigoInterno
	oClone:nParceiroCodigo      := ::nParceiroCodigo
	oClone:nAfiliadoCodigo      := ::nAfiliadoCodigo
	oClone:oWSTipo              := IIF(::oWSTipo = NIL , NIL , ::oWSTipo:Clone() )
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cRazaoSocial         := ::cRazaoSocial
	oClone:cNomeFantasia        := ::cNomeFantasia
	oClone:cCPF                 := ::cCPF
	oClone:cCNPJ                := ::cCNPJ
	oClone:cRG                  := ::cRG
	oClone:cIE                  := ::cIE
	oClone:cIM                  := ::cIM
	oClone:cDataNascimento      := ::cDataNascimento
	oClone:oWSContaStatus       := IIF(::oWSContaStatus = NIL , NIL , ::oWSContaStatus:Clone() )
	oClone:cTexto1              := ::cTexto1
	oClone:cTexto2              := ::cTexto2
	oClone:cTexto3              := ::cTexto3
	oClone:nNumero1             := ::nNumero1
	oClone:nNumero2             := ::nNumero2
	oClone:nNumero3             := ::nNumero3
	oClone:nParceiroCodigoAtacado := ::nParceiroCodigoAtacado
	oClone:oWSSituacaoCadastral := IIF(::oWSSituacaoCadastral = NIL , NIL , ::oWSSituacaoCadastral:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cliente_clsContakH
	Local cSoap := ""
	cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, ::nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ContaCodigoInterno", ::cContaCodigoInterno, ::cContaCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ParceiroCodigo", ::nParceiroCodigo, ::nParceiroCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AfiliadoCodigo", ::nAfiliadoCodigo, ::nAfiliadoCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Tipo", ::oWSTipo, ::oWSTipo , "ContaTipo", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RazaoSocial", ::cRazaoSocial, ::cRazaoSocial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NomeFantasia", ::cNomeFantasia, ::cNomeFantasia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CNPJ", ::cCNPJ, ::cCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("RG", ::cRG, ::cRG , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IE", ::cIE, ::cIE , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("IM", ::cIM, ::cIM , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DataNascimento", ::cDataNascimento, ::cDataNascimento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ContaStatus", ::oWSContaStatus, ::oWSContaStatus , "ContaStatus", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto1", ::cTexto1, ::cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto2", ::cTexto2, ::cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto3", ::cTexto3, ::cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero1", ::nNumero1, ::nNumero1 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero2", ::nNumero2, ::nNumero2 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero3", ::nNumero3, ::nNumero3 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ParceiroCodigoAtacado", ::nParceiroCodigoAtacado, ::nParceiroCodigoAtacado , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("SituacaoCadastral", ::oWSSituacaoCadastral, ::oWSSituacaoCadastral , "SituacaoCadastral", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsContakH
	Local oNode5
	Local oNode16
	Local oNode24
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cContaCodigoInterno :=  WSAdvValue( oResponse,"_CONTACODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nParceiroCodigo    :=  WSAdvValue( oResponse,"_PARCEIROCODIGO","int",NIL,"Property nParceiroCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAfiliadoCodigo    :=  WSAdvValue( oResponse,"_AFILIADOCODIGO","int",NIL,"Property nAfiliadoCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_TIPO","ContaTipo",NIL,"Property oWSTipo as tns:ContaTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSTipo := Cliente_ContaTipokH():New()
		::oWSTipo:SoapRecv(oNode5)
	EndIf
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSobrenome         :=  WSAdvValue( oResponse,"_SOBRENOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRazaoSocial       :=  WSAdvValue( oResponse,"_RAZAOSOCIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNomeFantasia      :=  WSAdvValue( oResponse,"_NOMEFANTASIA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCPF               :=  WSAdvValue( oResponse,"_CPF","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCNPJ              :=  WSAdvValue( oResponse,"_CNPJ","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cRG                :=  WSAdvValue( oResponse,"_RG","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIE                :=  WSAdvValue( oResponse,"_IE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cIM                :=  WSAdvValue( oResponse,"_IM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataNascimento    :=  WSAdvValue( oResponse,"_DATANASCIMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode16 :=  WSAdvValue( oResponse,"_CONTASTATUS","ContaStatus",NIL,"Property oWSContaStatus as tns:ContaStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSContaStatus := Cliente_ContaStatuskH():New()
		::oWSContaStatus:SoapRecv(oNode16)
	EndIf
	::cTexto1            :=  WSAdvValue( oResponse,"_TEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto2            :=  WSAdvValue( oResponse,"_TEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto3            :=  WSAdvValue( oResponse,"_TEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,"Property nNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,"Property nNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,"Property nNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nParceiroCodigoAtacado :=  WSAdvValue( oResponse,"_PARCEIROCODIGOATACADO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	oNode24 :=  WSAdvValue( oResponse,"_SITUACAOCADASTRAL","SituacaoCadastral",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode24 != NIL
		::oWSSituacaoCadastral := Cliente_SituacaoCadastral():New()
		::oWSSituacaoCadastral:SoapRecv(oNode24)
	EndIf
Return

// WSDL Data Structure clsUsuario

WSSTRUCT Cliente_clsUsuariokH
	WSDATA   nLojaCodigo               AS int
	WSDATA   cUsuarioCodigoInterno     AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cSobrenome                AS string OPTIONAL
	WSDATA   cEmail                    AS string OPTIONAL
	WSDATA   oWSNewsletter             AS Cliente_SimNaokH
	WSDATA   oWSSexo                   AS Cliente_SexoTipokH
	WSDATA   oWSUsuarioStatus          AS Cliente_UsuarioStatuskH
	WSDATA   oWSStatusIntegracao       AS Cliente_UsuarioStatusIntegracaokH
	WSDATA   cTexto1                   AS string OPTIONAL
	WSDATA   cTexto2                   AS string OPTIONAL
	WSDATA   cTexto3                   AS string OPTIONAL
	WSDATA   nNumero1                  AS decimal
	WSDATA   nNumero2                  AS decimal
	WSDATA   nNumero3                  AS decimal
	WSDATA   cAdditionalFieldsJson     AS string OPTIONAL
	WSDATA   oWSConta                  AS Cliente_clsContakH OPTIONAL
	WSDATA   oWSEnderecos              AS Cliente_ArrayOfClsEnderecokH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsUsuariokH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsUsuariokH
Return

WSMETHOD CLONE WSCLIENT Cliente_clsUsuariokH
	Local oClone := Cliente_clsUsuariokH():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:cUsuarioCodigoInterno := ::cUsuarioCodigoInterno
	oClone:cNome                := ::cNome
	oClone:cSobrenome           := ::cSobrenome
	oClone:cEmail               := ::cEmail
	oClone:oWSNewsletter        := IIF(::oWSNewsletter = NIL , NIL , ::oWSNewsletter:Clone() )
	oClone:oWSSexo              := IIF(::oWSSexo = NIL , NIL , ::oWSSexo:Clone() )
	oClone:oWSUsuarioStatus     := IIF(::oWSUsuarioStatus = NIL , NIL , ::oWSUsuarioStatus:Clone() )
	oClone:oWSStatusIntegracao  := IIF(::oWSStatusIntegracao = NIL , NIL , ::oWSStatusIntegracao:Clone() )
	oClone:cTexto1              := ::cTexto1
	oClone:cTexto2              := ::cTexto2
	oClone:cTexto3              := ::cTexto3
	oClone:nNumero1             := ::nNumero1
	oClone:nNumero2             := ::nNumero2
	oClone:nNumero3             := ::nNumero3
	oClone:cAdditionalFieldsJson := ::cAdditionalFieldsJson
	oClone:oWSConta             := IIF(::oWSConta = NIL , NIL , ::oWSConta:Clone() )
	oClone:oWSEnderecos         := IIF(::oWSEnderecos = NIL , NIL , ::oWSEnderecos:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cliente_clsUsuariokH
	Local cSoap := ""
	cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, ::nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("UsuarioCodigoInterno", ::cUsuarioCodigoInterno, ::cUsuarioCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sobrenome", ::cSobrenome, ::cSobrenome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Email", ::cEmail, ::cEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Newsletter", ::oWSNewsletter, ::oWSNewsletter , "SimNao", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Sexo", ::oWSSexo, ::oWSSexo , "SexoTipo", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("UsuarioStatus", ::oWSUsuarioStatus, ::oWSUsuarioStatus , "UsuarioStatus", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("StatusIntegracao", ::oWSStatusIntegracao, ::oWSStatusIntegracao , "UsuarioStatusIntegracao", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto1", ::cTexto1, ::cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto2", ::cTexto2, ::cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto3", ::cTexto3, ::cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero1", ::nNumero1, ::nNumero1 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero2", ::nNumero2, ::nNumero2 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero3", ::nNumero3, ::nNumero3 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AdditionalFieldsJson", ::cAdditionalFieldsJson, ::cAdditionalFieldsJson , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Conta", ::oWSConta, ::oWSConta , "clsConta", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Enderecos", ::oWSEnderecos, ::oWSEnderecos , "ArrayOfClsEndereco", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsUsuariokH
	Local oNode6
	Local oNode7
	Local oNode8
	Local oNode9
	Local oNode17
	Local oNode18
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cUsuarioCodigoInterno :=  WSAdvValue( oResponse,"_USUARIOCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cSobrenome         :=  WSAdvValue( oResponse,"_SOBRENOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEmail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode6 :=  WSAdvValue( oResponse,"_NEWSLETTER","SimNao",NIL,"Property oWSNewsletter as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSNewsletter := Cliente_SimNaokH():New()
		::oWSNewsletter:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_SEXO","SexoTipo",NIL,"Property oWSSexo as tns:SexoTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSSexo := Cliente_SexoTipokH():New()
		::oWSSexo:SoapRecv(oNode7)
	EndIf
	oNode8 :=  WSAdvValue( oResponse,"_USUARIOSTATUS","UsuarioStatus",NIL,"Property oWSUsuarioStatus as tns:UsuarioStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode8 != NIL
		::oWSUsuarioStatus := Cliente_UsuarioStatuskH():New()
		::oWSUsuarioStatus:SoapRecv(oNode8)
	EndIf
	oNode9 :=  WSAdvValue( oResponse,"_STATUSINTEGRACAO","UsuarioStatusIntegracao",NIL,"Property oWSStatusIntegracao as tns:UsuarioStatusIntegracao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode9 != NIL
		::oWSStatusIntegracao := Cliente_UsuarioStatusIntegracaokH():New()
		::oWSStatusIntegracao:SoapRecv(oNode9)
	EndIf
	::cTexto1            :=  WSAdvValue( oResponse,"_TEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto2            :=  WSAdvValue( oResponse,"_TEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto3            :=  WSAdvValue( oResponse,"_TEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,"Property nNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,"Property nNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,"Property nNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cAdditionalFieldsJson :=  WSAdvValue( oResponse,"_ADDITIONALFIELDSJSON","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode17 :=  WSAdvValue( oResponse,"_CONTA","clsConta",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode17 != NIL
		::oWSConta := Cliente_clsContakH():New()
		::oWSConta:SoapRecv(oNode17)
	EndIf
	oNode18 :=  WSAdvValue( oResponse,"_ENDERECOS","ArrayOfClsEndereco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode18 != NIL
		::oWSEnderecos := Cliente_ArrayOfClsEnderecokH():New()
		::oWSEnderecos:SoapRecv(oNode18)
	EndIf
Return

// WSDL Data Enumeration ContaTipo

WSSTRUCT Cliente_ContaTipokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_ContaTipokH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "PessoaFísica" )
	aadd(::aValueList , "PessoaJurídica" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_ContaTipokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_ContaTipokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_ContaTipokH
Local oClone := Cliente_ContaTipokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ContaStatus

WSSTRUCT Cliente_ContaStatuskH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_ContaStatuskH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
	aadd(::aValueList , "Aprovação" )
	aadd(::aValueList , "Integracao" )
	aadd(::aValueList , "Alteracao" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_ContaStatuskH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_ContaStatuskH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_ContaStatuskH
Local oClone := Cliente_ContaStatuskH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SituacaoCadastral

WSSTRUCT Cliente_SituacaoCadastral
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_SituacaoCadastral
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Pendente" )
	aadd(::aValueList , "Aprovado" )
	aadd(::aValueList , "Reprovado" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_SituacaoCadastral
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_SituacaoCadastral
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_SituacaoCadastral
Local oClone := Cliente_SituacaoCadastral():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SimNao

WSSTRUCT Cliente_SimNaokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_SimNaokH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Sim" )
	aadd(::aValueList , "Não" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_SimNaokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_SimNaokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_SimNaokH
Local oClone := Cliente_SimNaokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SexoTipo

WSSTRUCT Cliente_SexoTipokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_SexoTipokH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Masculino" )
	aadd(::aValueList , "Feminino" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_SexoTipokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_SexoTipokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_SexoTipokH
Local oClone := Cliente_SexoTipokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration UsuarioStatus

WSSTRUCT Cliente_UsuarioStatuskH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_UsuarioStatuskH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_UsuarioStatuskH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_UsuarioStatuskH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_UsuarioStatuskH
Local oClone := Cliente_UsuarioStatuskH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration UsuarioStatusIntegracao

WSSTRUCT Cliente_UsuarioStatusIntegracaokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_UsuarioStatusIntegracaokH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Integrar" )
	aadd(::aValueList , "Integrado" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_UsuarioStatusIntegracaokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_UsuarioStatusIntegracaokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_UsuarioStatusIntegracaokH
Local oClone := Cliente_UsuarioStatusIntegracaokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfClsEndereco

WSSTRUCT Cliente_ArrayOfClsEnderecokH
	WSDATA   oWSclsEndereco            AS Cliente_clsEnderecokH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_ArrayOfClsEnderecokH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_ArrayOfClsEnderecokH
	::oWSclsEndereco       := {} // Array Of  Cliente_clsEnderecokH():New()
Return

WSMETHOD CLONE WSCLIENT Cliente_ArrayOfClsEnderecokH
	Local oClone := Cliente_ArrayOfClsEnderecokH():NEW()
	oClone:oWSclsEndereco := NIL
	If ::oWSclsEndereco <> NIL 
		oClone:oWSclsEndereco := {}
		aEval( ::oWSclsEndereco , { |x| aadd( oClone:oWSclsEndereco , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cliente_ArrayOfClsEnderecokH
	Local cSoap := ""
	aEval( ::oWSclsEndereco , {|x| cSoap := cSoap  +  WSSoapValue("clsEndereco", x , x , "clsEndereco", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_ArrayOfClsEnderecokH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSENDERECO","clsEndereco",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsEndereco , Cliente_clsEnderecokH():New() )
			::oWSclsEndereco[len(::oWSclsEndereco)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsEndereco

WSSTRUCT Cliente_clsEnderecokH
	WSDATA   nLojaCodigo               AS int
	WSDATA   nEnderecoCodigo           AS int
	WSDATA   nAfiliadoCodigo           AS int
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   oWSTipo                   AS Cliente_EndTipokH
	WSDATA   oWSFinalidade             AS Cliente_EndFinalidadekH
	WSDATA   oWSTipoLogradouro         AS Cliente_EndTipoLogradourokH
	WSDATA   cLogradouro               AS string OPTIONAL
	WSDATA   cNumero                   AS string OPTIONAL
	WSDATA   cComplemento              AS string OPTIONAL
	WSDATA   cBairro                   AS string OPTIONAL
	WSDATA   cCidade                   AS string OPTIONAL
	WSDATA   cEstado                   AS string OPTIONAL
	WSDATA   cPais                     AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
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
	WSDATA   oWSEnderecoStatus         AS Cliente_EndStatuskH
	WSDATA   cTexto1                   AS string OPTIONAL
	WSDATA   cTexto2                   AS string OPTIONAL
	WSDATA   cTexto3                   AS string OPTIONAL
	WSDATA   nNumero1                  AS decimal
	WSDATA   nNumero2                  AS decimal
	WSDATA   nNumero3                  AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_clsEnderecokH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Cliente_clsEnderecokH
Return

WSMETHOD CLONE WSCLIENT Cliente_clsEnderecokH
	Local oClone := Cliente_clsEnderecokH():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:nEnderecoCodigo      := ::nEnderecoCodigo
	oClone:nAfiliadoCodigo      := ::nAfiliadoCodigo
	oClone:cNome                := ::cNome
	oClone:oWSTipo              := IIF(::oWSTipo = NIL , NIL , ::oWSTipo:Clone() )
	oClone:oWSFinalidade        := IIF(::oWSFinalidade = NIL , NIL , ::oWSFinalidade:Clone() )
	oClone:oWSTipoLogradouro    := IIF(::oWSTipoLogradouro = NIL , NIL , ::oWSTipoLogradouro:Clone() )
	oClone:cLogradouro          := ::cLogradouro
	oClone:cNumero              := ::cNumero
	oClone:cComplemento         := ::cComplemento
	oClone:cBairro              := ::cBairro
	oClone:cCidade              := ::cCidade
	oClone:cEstado              := ::cEstado
	oClone:cPais                := ::cPais
	oClone:cCEP                 := ::cCEP
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
	oClone:oWSEnderecoStatus    := IIF(::oWSEnderecoStatus = NIL , NIL , ::oWSEnderecoStatus:Clone() )
	oClone:cTexto1              := ::cTexto1
	oClone:cTexto2              := ::cTexto2
	oClone:cTexto3              := ::cTexto3
	oClone:nNumero1             := ::nNumero1
	oClone:nNumero2             := ::nNumero2
	oClone:nNumero3             := ::nNumero3
Return oClone

WSMETHOD SOAPSEND WSCLIENT Cliente_clsEnderecokH
	Local cSoap := ""
	cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, ::nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EnderecoCodigo", ::nEnderecoCodigo, ::nEnderecoCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AfiliadoCodigo", ::nAfiliadoCodigo, ::nAfiliadoCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Nome", ::cNome, ::cNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Tipo", ::oWSTipo, ::oWSTipo , "EndTipo", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Finalidade", ::oWSFinalidade, ::oWSFinalidade , "EndFinalidade", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoLogradouro", ::oWSTipoLogradouro, ::oWSTipoLogradouro , "EndTipoLogradouro", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Logradouro", ::cLogradouro, ::cLogradouro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero", ::cNumero, ::cNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Complemento", ::cComplemento, ::cComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Bairro", ::cBairro, ::cBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Cidade", ::cCidade, ::cCidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Estado", ::cEstado, ::cEstado , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Pais", ::cPais, ::cPais , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDD1", ::cDDD1, ::cDDD1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Telefone1", ::cTelefone1, ::cTelefone1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ramal1", ::cRamal1, ::cRamal1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDD2", ::cDDD2, ::cDDD2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Telefone2", ::cTelefone2, ::cTelefone2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ramal2", ::cRamal2, ::cRamal2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDD3", ::cDDD3, ::cDDD3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Telefone3", ::cTelefone3, ::cTelefone3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Ramal3", ::cRamal3, ::cRamal3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDDCelular", ::cDDDCelular, ::cDDDCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Celular", ::cCelular, ::cCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("DDDFax", ::cDDDFax, ::cDDDFax , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Fax", ::cFax, ::cFax , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Referencia", ::cReferencia, ::cReferencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EnderecoStatus", ::oWSEnderecoStatus, ::oWSEnderecoStatus , "EndStatus", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto1", ::cTexto1, ::cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto2", ::cTexto2, ::cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto3", ::cTexto3, ::cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero1", ::nNumero1, ::nNumero1 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero2", ::nNumero2, ::nNumero2 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero3", ::nNumero3, ::nNumero3 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_clsEnderecokH
	Local oNode5
	Local oNode6
	Local oNode7
	Local oNode30
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nEnderecoCodigo    :=  WSAdvValue( oResponse,"_ENDERECOCODIGO","int",NIL,"Property nEnderecoCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAfiliadoCodigo    :=  WSAdvValue( oResponse,"_AFILIADOCODIGO","int",NIL,"Property nAfiliadoCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_TIPO","EndTipo",NIL,"Property oWSTipo as tns:EndTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSTipo := Cliente_EndTipokH():New()
		::oWSTipo:SoapRecv(oNode5)
	EndIf
	oNode6 :=  WSAdvValue( oResponse,"_FINALIDADE","EndFinalidade",NIL,"Property oWSFinalidade as tns:EndFinalidade on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode6 != NIL
		::oWSFinalidade := Cliente_EndFinalidadekH():New()
		::oWSFinalidade:SoapRecv(oNode6)
	EndIf
	oNode7 :=  WSAdvValue( oResponse,"_TIPOLOGRADOURO","EndTipoLogradouro",NIL,"Property oWSTipoLogradouro as tns:EndTipoLogradouro on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSTipoLogradouro := Cliente_EndTipoLogradourokH():New()
		::oWSTipoLogradouro:SoapRecv(oNode7)
	EndIf
	::cLogradouro        :=  WSAdvValue( oResponse,"_LOGRADOURO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNumero            :=  WSAdvValue( oResponse,"_NUMERO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cComplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cBairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCidade            :=  WSAdvValue( oResponse,"_CIDADE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEstado            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPais              :=  WSAdvValue( oResponse,"_PAIS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCEP               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,NIL) 
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
	oNode30 :=  WSAdvValue( oResponse,"_ENDERECOSTATUS","EndStatus",NIL,"Property oWSEnderecoStatus as tns:EndStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode30 != NIL
		::oWSEnderecoStatus := Cliente_EndStatuskH():New()
		::oWSEnderecoStatus:SoapRecv(oNode30)
	EndIf
	::cTexto1            :=  WSAdvValue( oResponse,"_TEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto2            :=  WSAdvValue( oResponse,"_TEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto3            :=  WSAdvValue( oResponse,"_TEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,"Property nNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,"Property nNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,"Property nNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Enumeration EndTipo

WSSTRUCT Cliente_EndTipokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_EndTipokH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Residencial" )
	aadd(::aValueList , "Comercial" )
	aadd(::aValueList , "Outros" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_EndTipokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_EndTipokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_EndTipokH
Local oClone := Cliente_EndTipokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration EndFinalidade

WSSTRUCT Cliente_EndFinalidadekH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_EndFinalidadekH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Contato" )
	aadd(::aValueList , "Entrega" )
	aadd(::aValueList , "Cobrança" )
	aadd(::aValueList , "EntregaLista" )
	aadd(::aValueList , "Evento" )
	aadd(::aValueList , "RetiraLoja" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_EndFinalidadekH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_EndFinalidadekH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_EndFinalidadekH
Local oClone := Cliente_EndFinalidadekH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration EndTipoLogradouro

WSSTRUCT Cliente_EndTipoLogradourokH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_EndTipoLogradourokH
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

WSMETHOD SOAPSEND WSCLIENT Cliente_EndTipoLogradourokH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_EndTipoLogradourokH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_EndTipoLogradourokH
Local oClone := Cliente_EndTipoLogradourokH():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration EndStatus

WSSTRUCT Cliente_EndStatuskH
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Cliente_EndStatuskH
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Cliente_EndStatuskH
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Cliente_EndStatuskH
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Cliente_EndStatuskH
Local oClone := Cliente_EndStatuskH():New()
	oClone:Value := ::Value
Return oClone


