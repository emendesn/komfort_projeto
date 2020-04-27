#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.com.br/ikcwebservice/ProdutoCategoria.asmx?wsdl
Gerado em        04/29/19 10:17:32
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HFKJMRX ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSProdutoCategoriaKh
------------------------------------------------------------------------------- */

WSCLIENT WSProdutoCategoriaKh

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Salvar
	WSMETHOD Excluir
	WSMETHOD ListarCategoriasAtivasPorProduto

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodProd     AS string
	WSDATA   cCodCate   AS string
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS ProdutoCategoria_clsRetornoKH
	WSDATA   oWSExcluirResult          AS ProdutoCategoria_clsRetornoKH
	WSDATA   cProdutoCodigoInterno     AS string
	WSDATA   oWSListarCategoriasAtivasPorProdutoResult AS ProdutoCategoria_clsRetornoOfclsCategoria

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSProdutoCategoriaKh
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSProdutoCategoriaKh
	::oWS                := NIL 
	::oWSSalvarResult    := ProdutoCategoria_clsRetornoKH():New()
	::oWSExcluirResult   := ProdutoCategoria_clsRetornoKH():New()
	::oWSListarCategoriasAtivasPorProdutoResult := ProdutoCategoria_CLSRETORNOOFCLSCATEGORIA():New()
Return

WSMETHOD RESET WSCLIENT WSProdutoCategoriaKh
	::nLojaCodigo        := NIL 
	::cCodProd := NIL 
	::cCodCate := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSSalvarResult    := NIL 
	::oWSExcluirResult   := NIL 
	::cProdutoCodigoInterno := NIL 
	::oWSListarCategoriasAtivasPorProdutoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSProdutoCategoriaKh
Local oClone := WSProdutoCategoriaKh():New()
	oClone:_URL          := ::_URL 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodProd := ::cCodProd
	oClone:cCodCate := ::cCodCate
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarResult :=  IIF(::oWSSalvarResult = NIL , NIL ,::oWSSalvarResult:Clone() )
	oClone:oWSExcluirResult :=  IIF(::oWSExcluirResult = NIL , NIL ,::oWSExcluirResult:Clone() )
	oClone:cProdutoCodigoInterno := ::cProdutoCodigoInterno
	oClone:oWSListarCategoriasAtivasPorProdutoResult :=  IIF(::oWSListarCategoriasAtivasPorProdutoResult = NIL , NIL ,::oWSListarCategoriasAtivasPorProdutoResult:Clone() )
Return oClone

// WSDL Method Salvar of Service WSProdutoCategoriaKh

WSMETHOD Salvar WSSEND nLojaCodigo,cCodProd,cCodCate,cA1,cA2,oWS WSRECEIVE oWSSalvarResult WSCLIENT WSProdutoCategoriaKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Salvar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoCategoria", ::cCodCate, cCodCate , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/ProdutoCategoria.asmx")

::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","clsRetornoOfclsProdutoCategoria",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Excluir of Service WSProdutoCategoriaKh

WSMETHOD Excluir WSSEND nLojaCodigo,cCodProd,cCodCate,cA1,cA2,oWS WSRECEIVE oWSExcluirResult WSCLIENT WSProdutoCategoriaKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Excluir xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoCategoria", ::cCodCate, cCodCate , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Excluir>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Excluir",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/ProdutoCategoria.asmx")

::Init()
::oWSExcluirResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRRESPONSE:_EXCLUIRRESULT","clsRetornoOfclsProdutoCategoria",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ListarCategoriasAtivasPorProduto of Service WSProdutoCategoriaKh

WSMETHOD ListarCategoriasAtivasPorProduto WSSEND nLojaCodigo,cProdutoCodigoInterno,cA1,cA2,oWS WSRECEIVE oWSListarCategoriasAtivasPorProdutoResult WSCLIENT WSProdutoCategoriaKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<ListarCategoriasAtivasPorProduto xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProdutoCodigoInterno", ::cProdutoCodigoInterno, cProdutoCodigoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ListarCategoriasAtivasPorProduto>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ListarCategoriasAtivasPorProduto",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/ProdutoCategoria.asmx")

::Init()
::oWSListarCategoriasAtivasPorProdutoResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARCATEGORIASATIVASPORPRODUTORESPONSE:_LISTARCATEGORIASATIVASPORPRODUTORESULT","clsRetornoOfclsCategoria",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsProdutoCategoria

WSSTRUCT ProdutoCategoria_clsRetornoKH
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS ProdutoCategoria_ArrayOfClsProdutoCategoriaKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_clsRetornoKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_clsRetornoKH
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_clsRetornoKH
	Local oClone := ProdutoCategoria_clsRetornoKH():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_clsRetornoKH
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsProdutoCategoria",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := ProdutoCategoria_ArrayOfClsProdutoCategoriaKH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure clsRetornoOfclsCategoria

WSSTRUCT ProdutoCategoria_clsRetornoOfclsCategoria
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS ProdutoCategoria_ArrayOfClsCategoria OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_clsRetornoOfclsCategoria
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_clsRetornoOfclsCategoria
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_clsRetornoOfclsCategoria
	Local oClone := ProdutoCategoria_clsRetornoOfclsCategoria():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_clsRetornoOfclsCategoria
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsCategoria",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := ProdutoCategoria_ArrayOfClsCategoria():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsProdutoCategoria

WSSTRUCT ProdutoCategoria_ArrayOfClsProdutoCategoriaKH
	WSDATA   oWSclsProdutoCategoria    AS ProdutoCategoria_clsProdutoCategoriaKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_ArrayOfClsProdutoCategoriaKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_ArrayOfClsProdutoCategoriaKH
	::oWSclsProdutoCategoria := {} // Array Of  ProdutoCategoria_clsProdutoCategoriaKH():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_ArrayOfClsProdutoCategoriaKH
	Local oClone := ProdutoCategoria_ArrayOfClsProdutoCategoriaKH():NEW()
	oClone:oWSclsProdutoCategoria := NIL
	If ::oWSclsProdutoCategoria <> NIL 
		oClone:oWSclsProdutoCategoria := {}
		aEval( ::oWSclsProdutoCategoria , { |x| aadd( oClone:oWSclsProdutoCategoria , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_ArrayOfClsProdutoCategoriaKH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTOCATEGORIA","clsProdutoCategoria",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProdutoCategoria , ProdutoCategoria_clsProdutoCategoriaKH():New() )
			::oWSclsProdutoCategoria[len(::oWSclsProdutoCategoria)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfClsCategoria

WSSTRUCT ProdutoCategoria_ArrayOfClsCategoria
	WSDATA   oWSclsCategoria           AS ProdutoCategoria_clsCategoria OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_ArrayOfClsCategoria
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_ArrayOfClsCategoria
	::oWSclsCategoria      := {} // Array Of  ProdutoCategoria_CLSCATEGORIA():New()
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_ArrayOfClsCategoria
	Local oClone := ProdutoCategoria_ArrayOfClsCategoria():NEW()
	oClone:oWSclsCategoria := NIL
	If ::oWSclsCategoria <> NIL 
		oClone:oWSclsCategoria := {}
		aEval( ::oWSclsCategoria , { |x| aadd( oClone:oWSclsCategoria , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_ArrayOfClsCategoria
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSCATEGORIA","clsCategoria",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsCategoria , ProdutoCategoria_clsCategoria():New() )
			::oWSclsCategoria[len(::oWSclsCategoria)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsProdutoCategoria

WSSTRUCT ProdutoCategoria_clsProdutoCategoriaKH
	WSDATA   nLojaCodigo               AS int
	WSDATA   oWSProdutoCategoriaKhStatus AS ProdutoCategoria_StatusKh
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_clsProdutoCategoriaKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_clsProdutoCategoriaKH
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_clsProdutoCategoriaKH
	Local oClone := ProdutoCategoria_clsProdutoCategoriaKH():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:oWSProdutoCategoriaKhStatus := IIF(::oWSProdutoCategoriaKhStatus = NIL , NIL , ::oWSProdutoCategoriaKhStatus:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_clsProdutoCategoriaKH
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_PRODUTOCATEGORIASTATUS","ProdutoCategoriaStatus",NIL,"Property oWSProdutoCategoriaKhStatus as tns:ProdutoCategoriaStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSProdutoCategoriaKhStatus := ProdutoCategoria_StatusKh():New()
		::oWSProdutoCategoriaKhStatus:SoapRecv(oNode2)
	EndIf
Return

// WSDL Data Structure clsCategoria

WSSTRUCT ProdutoCategoria_clsCategoria
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCategoriaCodigoInterno   AS string OPTIONAL
	WSDATA   cPaiInterno               AS string OPTIONAL
	WSDATA   oWSCategoriaStatus        AS ProdutoCategoria_CategoriaStatus
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   nOrdem                    AS int
	WSDATA   oWSCategoriasFilhas       AS ProdutoCategoria_ArrayOfClsCategoria OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_clsCategoria
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ProdutoCategoria_clsCategoria
Return

WSMETHOD CLONE WSCLIENT ProdutoCategoria_clsCategoria
	Local oClone := ProdutoCategoria_clsCategoria():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:cCategoriaCodigoInterno := ::cCategoriaCodigoInterno
	oClone:cPaiInterno          := ::cPaiInterno
	oClone:oWSCategoriaStatus   := IIF(::oWSCategoriaStatus = NIL , NIL , ::oWSCategoriaStatus:Clone() )
	oClone:cNome                := ::cNome
	oClone:nOrdem               := ::nOrdem
	oClone:oWSCategoriasFilhas  := IIF(::oWSCategoriasFilhas = NIL , NIL , ::oWSCategoriasFilhas:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_clsCategoria
	Local oNode4
	Local oNode7
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cCategoriaCodigoInterno :=  WSAdvValue( oResponse,"_CATEGORIACODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPaiInterno        :=  WSAdvValue( oResponse,"_PAIINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode4 :=  WSAdvValue( oResponse,"_CATEGORIASTATUS","CategoriaStatus",NIL,"Property oWSCategoriaStatus as tns:CategoriaStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode4 != NIL
		::oWSCategoriaStatus := ProdutoCategoria_CategoriaStatus():New()
		::oWSCategoriaStatus:SoapRecv(oNode4)
	EndIf
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nOrdem             :=  WSAdvValue( oResponse,"_ORDEM","int",NIL,"Property nOrdem as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode7 :=  WSAdvValue( oResponse,"_CATEGORIASFILHAS","ArrayOfClsCategoria",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSCategoriasFilhas := ProdutoCategoria_ArrayOfClsCategoria():New()
		::oWSCategoriasFilhas:SoapRecv(oNode7)
	EndIf
Return

// WSDL Data Enumeration ProdutoCategoriaStatus

WSSTRUCT ProdutoCategoria_StatusKh
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_StatusKh
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT ProdutoCategoria_StatusKh
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_StatusKh
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT ProdutoCategoria_StatusKh
Local oClone := ProdutoCategoria_StatusKh():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration CategoriaStatus

WSSTRUCT ProdutoCategoria_CategoriaStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ProdutoCategoria_CategoriaStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT ProdutoCategoria_CategoriaStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ProdutoCategoria_CategoriaStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT ProdutoCategoria_CategoriaStatus
Local oClone := ProdutoCategoria_CategoriaStatus():New()
	oClone:Value := ::Value
Return oClone


