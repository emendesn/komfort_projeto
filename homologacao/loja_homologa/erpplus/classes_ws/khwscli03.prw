#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/estoque.asmx?wsdl
Gerado em        04/26/19 10:38:58
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _VJSHIJR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEstoqueKh
------------------------------------------------------------------------------- */

WSCLIENT WSEstoqueKh

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Salvar
	WSMETHOD Retornar
	WSMETHOD SalvarLote

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodigoProdutoInterno     AS string
	WSDATA   cPartNumber               AS string
	WSDATA   nQtdEstoque               AS int
	WSDATA   nQtdMinima                AS int
	WSDATA   nTipoAlteracao            AS int
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS Estoque_clsRetornoKh
	WSDATA   oWSRetornarResult         AS Estoque_clsRetornoKh
	WSDATA   oWSEstoqueKhs               AS Estoque_ArrayOfLoteEstoqueSalvar
	WSDATA   oWSSalvarLoteResult       AS Estoque_clsRetornoOfRetornoLote

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEstoqueKh
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEstoqueKh
	::oWS                := NIL 
	::oWSSalvarResult    := Estoque_clsRetornoKh():New()
	::oWSRetornarResult  := Estoque_clsRetornoKh():New()
	::oWSEstoqueKhs        := Estoque_ARRAYOFLOTEESTOQUESALVAR():New()
	::oWSSalvarLoteResult := Estoque_CLSRETORNOOFRETORNOLOTE():New()
Return

WSMETHOD RESET WSCLIENT WSEstoqueKh
	::nLojaCodigo        := NIL 
	::cCodigoProdutoInterno := NIL 
	::cPartNumber        := NIL 
	::nQtdEstoque        := NIL 
	::nQtdMinima         := NIL 
	::nTipoAlteracao     := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSSalvarResult    := NIL 
	::oWSRetornarResult  := NIL 
	::oWSEstoqueKhs        := NIL 
	::oWSSalvarLoteResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEstoqueKh
Local oClone := WSEstoqueKh():New()
	oClone:_URL          := ::_URL 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodigoProdutoInterno := ::cCodigoProdutoInterno
	oClone:cPartNumber   := ::cPartNumber
	oClone:nQtdEstoque   := ::nQtdEstoque
	oClone:nQtdMinima    := ::nQtdMinima
	oClone:nTipoAlteracao := ::nTipoAlteracao
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarResult :=  IIF(::oWSSalvarResult = NIL , NIL ,::oWSSalvarResult:Clone() )
	oClone:oWSRetornarResult :=  IIF(::oWSRetornarResult = NIL , NIL ,::oWSRetornarResult:Clone() )
	oClone:oWSEstoqueKhs   :=  IIF(::oWSEstoqueKhs = NIL , NIL ,::oWSEstoqueKhs:Clone() )
	oClone:oWSSalvarLoteResult :=  IIF(::oWSSalvarLoteResult = NIL , NIL ,::oWSSalvarLoteResult:Clone() )
Return oClone

// WSDL Method Salvar of Service WSEstoqueKh

WSMETHOD Salvar WSSEND nLojaCodigo,cCodigoProdutoInterno,cPartNumber,nQtdEstoque,nQtdMinima,nTipoAlteracao,cA1,cA2,oWS WSRECEIVE oWSSalvarResult WSCLIENT WSEstoqueKh
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
cSoap += WSSoapValue("CodigoProdutoInterno", ::cCodigoProdutoInterno, cCodigoProdutoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QtdEstoque", ::nQtdEstoque, nQtdEstoque , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QtdMinima", ::nQtdMinima, nQtdMinima , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoAlteracao", ::nTipoAlteracao, nTipoAlteracao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/estoque.asmx")

::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","clsRetornoOfclsEstoque",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Retornar of Service WSEstoqueKh

WSMETHOD Retornar WSSEND nLojaCodigo,cCodigoProdutoInterno,cPartNumber,cA1,cA2,oWS WSRECEIVE oWSRetornarResult WSCLIENT WSEstoqueKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Retornar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoProdutoInterno", ::cCodigoProdutoInterno, cCodigoProdutoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Retornar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Retornar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/estoque.asmx")

::Init()
::oWSRetornarResult:SoapRecv( WSAdvValue( oXmlRet,"_RETORNARRESPONSE:_RETORNARRESULT","clsRetornoOfclsEstoque",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarLote of Service WSEstoqueKh

WSMETHOD SalvarLote WSSEND nLojaCodigo,oWSEstoqueKhs,cA1,cA2,oWS WSRECEIVE oWSSalvarLoteResult WSCLIENT WSEstoqueKh
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Estoques", ::oWSEstoqueKhs, oWSEstoqueKhs , "ArrayOfLoteEstoqueSalvar", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/estoque.asmx")

::Init()
::oWSSalvarLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARLOTERESPONSE:_SALVARLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsEstoque

WSSTRUCT Estoque_clsRetornoKh
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Estoque_ArrayKh OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_clsRetornoKh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_clsRetornoKh
Return

WSMETHOD CLONE WSCLIENT Estoque_clsRetornoKh
	Local oClone := Estoque_clsRetornoKh():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_clsRetornoKh
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsEstoque",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Estoque_ArrayKh():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLoteEstoqueSalvar

WSSTRUCT Estoque_ArrayOfLoteEstoqueSalvar
	WSDATA   oWSLoteEstoqueSalvar      AS Estoque_LoteEstoqueSalvar OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_ArrayOfLoteEstoqueSalvar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_ArrayOfLoteEstoqueSalvar
	::oWSLoteEstoqueSalvar := {} // Array Of  Estoque_LOTEESTOQUESALVAR():New()
Return

WSMETHOD CLONE WSCLIENT Estoque_ArrayOfLoteEstoqueSalvar
	Local oClone := Estoque_ArrayOfLoteEstoqueSalvar():NEW()
	oClone:oWSLoteEstoqueSalvar := NIL
	If ::oWSLoteEstoqueSalvar <> NIL 
		oClone:oWSLoteEstoqueSalvar := {}
		aEval( ::oWSLoteEstoqueSalvar , { |x| aadd( oClone:oWSLoteEstoqueSalvar , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Estoque_ArrayOfLoteEstoqueSalvar
	Local cSoap := ""
	aEval( ::oWSLoteEstoqueSalvar , {|x| cSoap := cSoap  +  WSSoapValue("LoteEstoqueSalvar", x , x , "LoteEstoqueSalvar", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLote

WSSTRUCT Estoque_clsRetornoOfRetornoLote
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Estoque_ArrayOfRetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_clsRetornoOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_clsRetornoOfRetornoLote
Return

WSMETHOD CLONE WSCLIENT Estoque_clsRetornoOfRetornoLote
	Local oClone := Estoque_clsRetornoOfRetornoLote():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_clsRetornoOfRetornoLote
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLote",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Estoque_ArrayOfRetornoLote():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsEstoque

WSSTRUCT Estoque_ArrayKh
	WSDATA   oWSclsEstoque             AS Estoque_clsEstoqueKh OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_ArrayKh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_ArrayKh
	::oWSclsEstoque        := {} // Array Of  Estoque_clsEstoqueKh():New()
Return

WSMETHOD CLONE WSCLIENT Estoque_ArrayKh
	Local oClone := Estoque_ArrayKh():NEW()
	oClone:oWSclsEstoque := NIL
	If ::oWSclsEstoque <> NIL 
		oClone:oWSclsEstoque := {}
		aEval( ::oWSclsEstoque , { |x| aadd( oClone:oWSclsEstoque , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_ArrayKh
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSESTOQUE","clsEstoque",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsEstoque , Estoque_clsEstoqueKh():New() )
			::oWSclsEstoque[len(::oWSclsEstoque)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LoteEstoqueSalvar

WSSTRUCT Estoque_LoteEstoqueSalvar
	WSDATA   cCodigoProdutoInterno     AS string OPTIONAL
	WSDATA   cPartNumber               AS string OPTIONAL
	WSDATA   nQtdEstoque               AS int
	WSDATA   nQtdMinima                AS int
	WSDATA   nTipoAlteracao            AS int
	WSDATA   nWarehouseId              AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_LoteEstoqueSalvar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_LoteEstoqueSalvar
Return

WSMETHOD CLONE WSCLIENT Estoque_LoteEstoqueSalvar
	Local oClone := Estoque_LoteEstoqueSalvar():NEW()
	oClone:cCodigoProdutoInterno := ::cCodigoProdutoInterno
	oClone:cPartNumber          := ::cPartNumber
	oClone:nQtdEstoque          := ::nQtdEstoque
	oClone:nQtdMinima           := ::nQtdMinima
	oClone:nTipoAlteracao       := ::nTipoAlteracao
	oClone:nWarehouseId         := ::nWarehouseId
Return oClone

WSMETHOD SOAPSEND WSCLIENT Estoque_LoteEstoqueSalvar
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoProdutoInterno", ::cCodigoProdutoInterno, ::cCodigoProdutoInterno , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PartNumber", ::cPartNumber, ::cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QtdEstoque", ::nQtdEstoque, ::nQtdEstoque , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QtdMinima", ::nQtdMinima, ::nQtdMinima , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("TipoAlteracao", ::nTipoAlteracao, ::nTipoAlteracao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WarehouseId", ::nWarehouseId, ::nWarehouseId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLote

WSSTRUCT Estoque_ArrayOfRetornoLote
	WSDATA   oWSRetornoLote            AS Estoque_RetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_ArrayOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_ArrayOfRetornoLote
	::oWSRetornoLote       := {} // Array Of  Estoque_RETORNOLOTE():New()
Return

WSMETHOD CLONE WSCLIENT Estoque_ArrayOfRetornoLote
	Local oClone := Estoque_ArrayOfRetornoLote():NEW()
	oClone:oWSRetornoLote := NIL
	If ::oWSRetornoLote <> NIL 
		oClone:oWSRetornoLote := {}
		aEval( ::oWSRetornoLote , { |x| aadd( oClone:oWSRetornoLote , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_ArrayOfRetornoLote
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTE","RetornoLote",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLote , Estoque_RetornoLote():New() )
			::oWSRetornoLote[len(::oWSRetornoLote)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsEstoque

WSSTRUCT Estoque_clsEstoqueKh
	WSDATA   nLojaCodigo               AS int
	WSDATA   nQtde                     AS int
	WSDATA   nQtdeMinimo               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_clsEstoqueKh
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_clsEstoqueKh
Return

WSMETHOD CLONE WSCLIENT Estoque_clsEstoqueKh
	Local oClone := Estoque_clsEstoqueKh():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:nQtde                := ::nQtde
	oClone:nQtdeMinimo          := ::nQtdeMinimo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_clsEstoqueKh
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQtde              :=  WSAdvValue( oResponse,"_QTDE","int",NIL,"Property nQtde as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQtdeMinimo        :=  WSAdvValue( oResponse,"_QTDEMINIMO","int",NIL,"Property nQtdeMinimo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RetornoLote

WSSTRUCT Estoque_RetornoLote
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Estoque_RetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Estoque_RetornoLote
Return

WSMETHOD CLONE WSCLIENT Estoque_RetornoLote
	Local oClone := Estoque_RetornoLote():NEW()
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Estoque_RetornoLote
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


