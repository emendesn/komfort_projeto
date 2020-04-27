#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.com.br/ikcwebservice/sku.asmx?wsdl 
Gerado em        09/25/19 15:59:50
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IKLYNTP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSKU
------------------------------------------------------------------------------- */

WSCLIENT WSSKU

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Salvar
	WSMETHOD Save
	WSMETHOD AlterarPreco
	WSMETHOD AlterarStatus
	WSMETHOD Excluir
	WSMETHOD Listar
	WSMETHOD SalvarLote
	WSMETHOD SaveLote
	WSMETHOD AlterarPrecoLote
	WSMETHOD List

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodigoInternoProduto     AS string
	WSDATA   cPartNumber               AS string
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   oWSsku1                   AS SKU_ArrayOfString
	WSDATA   oWSsku2                   AS SKU_ArrayOfString
	WSDATA   oWSsku3                   AS SKU_ArrayOfString
	WSDATA   oWSsku4                   AS SKU_ArrayOfString
	WSDATA   oWSsku5                   AS SKU_ArrayOfString
	WSDATA   nStatusSKU                AS int
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   cproductInternalCode      AS string
	WSDATA   oWSProdutoCaracteristica  AS SKU_clsProdutoCaracteristica
	WSDATA   oWSoption1                AS SKU_ArrayOfString
	WSDATA   oWSoption2                AS SKU_ArrayOfString
	WSDATA   oWSoption3                AS SKU_ArrayOfString
	WSDATA   oWSoption4                AS SKU_ArrayOfString
	WSDATA   oWSoption5                AS SKU_ArrayOfString
	WSDATA   oWSSaveResult             AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   oWSAlterarPrecoResult     AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   oWSAlterarStatusResult    AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   oWSExcluirResult          AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   oWSListarResult           AS SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   oWSSkus                   AS SKU_ArrayOfLoteSkuSalvar
	WSDATA   oWSSalvarLoteResult       AS SKU_clsRetornoOfRetornoLote
	WSDATA   oWSSaveLoteResult         AS SKU_clsRetornoOfRetornoLote
	WSDATA   oWSAlterarPrecoLoteResult AS SKU_clsRetornoOfRetornoLote
	WSDATA   nstoreCode                AS int
	WSDATA   nitensPerPage             AS int
	WSDATA   npage                     AS int
	WSDATA   oWSListResult             AS SKU_PagedResultOfSkuModel

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSKU
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20190114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSKU
	::oWSsku1            := SKU_ARRAYOFSTRING():New()
	::oWSsku2            := SKU_ARRAYOFSTRING():New()
	::oWSsku3            := SKU_ARRAYOFSTRING():New()
	::oWSsku4            := SKU_ARRAYOFSTRING():New()
	::oWSsku5            := SKU_ARRAYOFSTRING():New()
	::oWS                := NIL 
	::oWSSalvarResult    := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSProdutoCaracteristica := SKU_CLSPRODUTOCARACTERISTICA():New()
	::oWSoption1         := SKU_ARRAYOFSTRING():New()
	::oWSoption2         := SKU_ARRAYOFSTRING():New()
	::oWSoption3         := SKU_ARRAYOFSTRING():New()
	::oWSoption4         := SKU_ARRAYOFSTRING():New()
	::oWSoption5         := SKU_ARRAYOFSTRING():New()
	::oWSSaveResult      := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSAlterarPrecoResult := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSAlterarStatusResult := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSExcluirResult   := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSListarResult    := SKU_CLSRETORNOOFCLSPRODUTOCARACTERISTICA():New()
	::oWSSkus            := SKU_ARRAYOFLOTESKUSALVAR():New()
	::oWSSalvarLoteResult := SKU_CLSRETORNOOFRETORNOLOTE():New()
	::oWSSaveLoteResult  := SKU_CLSRETORNOOFRETORNOLOTE():New()
	::oWSAlterarPrecoLoteResult := SKU_CLSRETORNOOFRETORNOLOTE():New()
	::oWSListResult      := SKU_PAGEDRESULTOFSKUMODEL():New()
Return

WSMETHOD RESET WSCLIENT WSSKU
	::nLojaCodigo        := NIL 
	::cCodigoInternoProduto := NIL 
	::cPartNumber        := NIL 
	::nPrecoPor          := NIL 
	::oWSsku1            := NIL 
	::oWSsku2            := NIL 
	::oWSsku3            := NIL 
	::oWSsku4            := NIL 
	::oWSsku5            := NIL 
	::nStatusSKU         := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSSalvarResult    := NIL 
	::cproductInternalCode := NIL 
	::oWSProdutoCaracteristica := NIL 
	::oWSoption1         := NIL 
	::oWSoption2         := NIL 
	::oWSoption3         := NIL 
	::oWSoption4         := NIL 
	::oWSoption5         := NIL 
	::oWSSaveResult      := NIL 
	::oWSAlterarPrecoResult := NIL 
	::oWSAlterarStatusResult := NIL 
	::oWSExcluirResult   := NIL 
	::oWSListarResult    := NIL 
	::oWSSkus            := NIL 
	::oWSSalvarLoteResult := NIL 
	::oWSSaveLoteResult  := NIL 
	::oWSAlterarPrecoLoteResult := NIL 
	::nstoreCode         := NIL 
	::nitensPerPage      := NIL 
	::npage              := NIL 
	::oWSListResult      := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSKU
Local oClone := WSSKU():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodigoInternoProduto := ::cCodigoInternoProduto
	oClone:cPartNumber   := ::cPartNumber
	oClone:nPrecoPor     := ::nPrecoPor
	oClone:oWSsku1       :=  IIF(::oWSsku1 = NIL , NIL ,::oWSsku1:Clone() )
	oClone:oWSsku2       :=  IIF(::oWSsku2 = NIL , NIL ,::oWSsku2:Clone() )
	oClone:oWSsku3       :=  IIF(::oWSsku3 = NIL , NIL ,::oWSsku3:Clone() )
	oClone:oWSsku4       :=  IIF(::oWSsku4 = NIL , NIL ,::oWSsku4:Clone() )
	oClone:oWSsku5       :=  IIF(::oWSsku5 = NIL , NIL ,::oWSsku5:Clone() )
	oClone:nStatusSKU    := ::nStatusSKU
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarResult :=  IIF(::oWSSalvarResult = NIL , NIL ,::oWSSalvarResult:Clone() )
	oClone:cproductInternalCode := ::cproductInternalCode
	oClone:oWSProdutoCaracteristica :=  IIF(::oWSProdutoCaracteristica = NIL , NIL ,::oWSProdutoCaracteristica:Clone() )
	oClone:oWSoption1    :=  IIF(::oWSoption1 = NIL , NIL ,::oWSoption1:Clone() )
	oClone:oWSoption2    :=  IIF(::oWSoption2 = NIL , NIL ,::oWSoption2:Clone() )
	oClone:oWSoption3    :=  IIF(::oWSoption3 = NIL , NIL ,::oWSoption3:Clone() )
	oClone:oWSoption4    :=  IIF(::oWSoption4 = NIL , NIL ,::oWSoption4:Clone() )
	oClone:oWSoption5    :=  IIF(::oWSoption5 = NIL , NIL ,::oWSoption5:Clone() )
	oClone:oWSSaveResult :=  IIF(::oWSSaveResult = NIL , NIL ,::oWSSaveResult:Clone() )
	oClone:oWSAlterarPrecoResult :=  IIF(::oWSAlterarPrecoResult = NIL , NIL ,::oWSAlterarPrecoResult:Clone() )
	oClone:oWSAlterarStatusResult :=  IIF(::oWSAlterarStatusResult = NIL , NIL ,::oWSAlterarStatusResult:Clone() )
	oClone:oWSExcluirResult :=  IIF(::oWSExcluirResult = NIL , NIL ,::oWSExcluirResult:Clone() )
	oClone:oWSListarResult :=  IIF(::oWSListarResult = NIL , NIL ,::oWSListarResult:Clone() )
	oClone:oWSSkus       :=  IIF(::oWSSkus = NIL , NIL ,::oWSSkus:Clone() )
	oClone:oWSSalvarLoteResult :=  IIF(::oWSSalvarLoteResult = NIL , NIL ,::oWSSalvarLoteResult:Clone() )
	oClone:oWSSaveLoteResult :=  IIF(::oWSSaveLoteResult = NIL , NIL ,::oWSSaveLoteResult:Clone() )
	oClone:oWSAlterarPrecoLoteResult :=  IIF(::oWSAlterarPrecoLoteResult = NIL , NIL ,::oWSAlterarPrecoLoteResult:Clone() )
	oClone:nstoreCode    := ::nstoreCode
	oClone:nitensPerPage := ::nitensPerPage
	oClone:npage         := ::npage
	oClone:oWSListResult :=  IIF(::oWSListResult = NIL , NIL ,::oWSListResult:Clone() )
Return oClone

// WSDL Method Salvar of Service WSSKU

WSMETHOD Salvar WSSEND nLojaCodigo,cCodigoInternoProduto,cPartNumber,nPrecoPor,oWSsku1,oWSsku2,oWSsku3,oWSsku4,oWSsku5,nStatusSKU,cA1,cA2,oWS WSRECEIVE oWSSalvarResult WSCLIENT WSSKU
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
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodigoInternoProduto, cCodigoInternoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sku1", ::oWSsku1, oWSsku1 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sku2", ::oWSsku2, oWSsku2 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sku3", ::oWSsku3, oWSsku3 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sku4", ::oWSsku4, oWSsku4 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("sku5", ::oWSsku5, oWSsku5 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusSKU", ::nStatusSKU, nStatusSKU , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Save of Service WSSKU

WSMETHOD Save WSSEND cproductInternalCode,oWSProdutoCaracteristica,oWSoption1,oWSoption2,oWSoption3,oWSoption4,oWSoption5,cA1,cA2,oWS WSRECEIVE oWSSaveResult WSCLIENT WSSKU
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Save xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("productInternalCode", ::cproductInternalCode, cproductInternalCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProdutoCaracteristica", ::oWSProdutoCaracteristica, oWSProdutoCaracteristica , "clsProdutoCaracteristica", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("option1", ::oWSoption1, oWSoption1 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("option2", ::oWSoption2, oWSoption2 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("option3", ::oWSoption3, oWSoption3 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("option4", ::oWSoption4, oWSoption4 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("option5", ::oWSoption5, oWSoption5 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Save>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Save",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSSaveResult:SoapRecv( WSAdvValue( oXmlRet,"_SAVERESPONSE:_SAVERESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPreco of Service WSSKU

WSMETHOD AlterarPreco WSSEND nLojaCodigo,cPartNumber,nPrecoPor,cA1,cA2,oWS WSRECEIVE oWSAlterarPrecoResult WSCLIENT WSSKU
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarPreco xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPreco>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPreco",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSAlterarPrecoResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECORESPONSE:_ALTERARPRECORESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatus of Service WSSKU

WSMETHOD AlterarStatus WSSEND nLojaCodigo,cPartNumber,nStatusSKU,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusResult WSCLIENT WSSKU
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
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusSKU", ::nStatusSKU, nStatusSKU , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatus>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatus",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSAlterarStatusResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSRESPONSE:_ALTERARSTATUSRESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Excluir of Service WSSKU

WSMETHOD Excluir WSSEND nLojaCodigo,cPartNumber,cA1,cA2,oWS WSRECEIVE oWSExcluirResult WSCLIENT WSSKU
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
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Excluir>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Excluir",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSExcluirResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRRESPONSE:_EXCLUIRRESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service WSSKU

WSMETHOD Listar WSSEND nLojaCodigo,cCodigoInternoProduto,cPartNumber,nStatusSKU,cA1,cA2,oWS WSRECEIVE oWSListarResult WSCLIENT WSSKU
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
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodigoInternoProduto, cCodigoInternoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusSKU", ::nStatusSKU, nStatusSKU , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","clsRetornoOfclsProdutoCaracteristica",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarLote of Service WSSKU

WSMETHOD SalvarLote WSSEND nLojaCodigo,oWSSkus,cA1,cA2,oWS WSRECEIVE oWSSalvarLoteResult WSCLIENT WSSKU
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
cSoap += WSSoapValue("Skus", ::oWSSkus, oWSSkus , "ArrayOfLoteSkuSalvar", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSSalvarLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARLOTERESPONSE:_SALVARLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveLote of Service WSSKU

WSMETHOD SaveLote WSSEND oWSSkus,cA1,cA2,oWS WSRECEIVE oWSSaveLoteResult WSCLIENT WSSKU
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SaveLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("Skus", ::oWSSkus, oWSSkus , "ArrayOfLoteSkuSave", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SaveLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSSaveLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_SAVELOTERESPONSE:_SAVELOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPrecoLote of Service WSSKU

WSMETHOD AlterarPrecoLote WSSEND nLojaCodigo,oWSSkus,cA1,cA2,oWS WSRECEIVE oWSAlterarPrecoLoteResult WSCLIENT WSSKU
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarPrecoLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Skus", ::oWSSkus, oWSSkus , "ArrayOfLoteSkuAlterarPreco", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPrecoLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPrecoLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSAlterarPrecoLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECOLOTERESPONSE:_ALTERARPRECOLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method List of Service WSSKU

WSMETHOD List WSSEND nstoreCode,nitensPerPage,npage,cA1,cA2,oWS WSRECEIVE oWSListResult WSCLIENT WSSKU
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<List xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("storeCode", ::nstoreCode, nstoreCode , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("itensPerPage", ::nitensPerPage, nitensPerPage , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</List>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/List",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/sku.asmx")

::Init()
::oWSListResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTRESPONSE:_LISTRESULT","PagedResultOfSkuModel",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfString

WSSTRUCT SKU_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT SKU_ArrayOfString
	Local oClone := SKU_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT SKU_ArrayOfString
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfclsProdutoCaracteristica

WSSTRUCT SKU_clsRetornoOfclsProdutoCaracteristica
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS SKU_ArrayOfClsProdutoCaracteristica OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_clsRetornoOfclsProdutoCaracteristica
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_clsRetornoOfclsProdutoCaracteristica
Return

WSMETHOD CLONE WSCLIENT SKU_clsRetornoOfclsProdutoCaracteristica
	Local oClone := SKU_clsRetornoOfclsProdutoCaracteristica():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_clsRetornoOfclsProdutoCaracteristica
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsProdutoCaracteristica",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := SKU_ArrayOfClsProdutoCaracteristica():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLoteSkuSalvar

WSSTRUCT SKU_ArrayOfLoteSkuSalvar
	WSDATA   oWSLoteSkuSalvar          AS SKU_LoteSkuSalvar OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_ArrayOfLoteSkuSalvar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_ArrayOfLoteSkuSalvar
	::oWSLoteSkuSalvar     := {} // Array Of  SKU_LOTESKUSALVAR():New()
Return

WSMETHOD CLONE WSCLIENT SKU_ArrayOfLoteSkuSalvar
	Local oClone := SKU_ArrayOfLoteSkuSalvar():NEW()
	oClone:oWSLoteSkuSalvar := NIL
	If ::oWSLoteSkuSalvar <> NIL 
		oClone:oWSLoteSkuSalvar := {}
		aEval( ::oWSLoteSkuSalvar , { |x| aadd( oClone:oWSLoteSkuSalvar , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT SKU_ArrayOfLoteSkuSalvar
	Local cSoap := ""
	aEval( ::oWSLoteSkuSalvar , {|x| cSoap := cSoap  +  WSSoapValue("LoteSkuSalvar", x , x , "LoteSkuSalvar", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLote

WSSTRUCT SKU_clsRetornoOfRetornoLote
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS SKU_ArrayOfRetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_clsRetornoOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_clsRetornoOfRetornoLote
Return

WSMETHOD CLONE WSCLIENT SKU_clsRetornoOfRetornoLote
	Local oClone := SKU_clsRetornoOfRetornoLote():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_clsRetornoOfRetornoLote
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLote",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := SKU_ArrayOfRetornoLote():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure PagedResultOfSkuModel

WSSTRUCT SKU_PagedResultOfSkuModel
	WSDATA   nTotalItens               AS int
	WSDATA   nTotalPages               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_PagedResultOfSkuModel
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_PagedResultOfSkuModel
Return

WSMETHOD CLONE WSCLIENT SKU_PagedResultOfSkuModel
	Local oClone := SKU_PagedResultOfSkuModel():NEW()
	oClone:nTotalItens          := ::nTotalItens
	oClone:nTotalPages          := ::nTotalPages
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_PagedResultOfSkuModel
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nTotalItens        :=  WSAdvValue( oResponse,"_TOTALITENS","int",NIL,"Property nTotalItens as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTotalPages        :=  WSAdvValue( oResponse,"_TOTALPAGES","int",NIL,"Property nTotalPages as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ArrayOfClsProdutoCaracteristica

WSSTRUCT SKU_ArrayOfClsProdutoCaracteristica
	WSDATA   oWSclsProdutoCaracteristica AS SKU_clsProdutoCaracteristica OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_ArrayOfClsProdutoCaracteristica
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_ArrayOfClsProdutoCaracteristica
	::oWSclsProdutoCaracteristica := {} // Array Of  SKU_CLSPRODUTOCARACTERISTICA():New()
Return

WSMETHOD CLONE WSCLIENT SKU_ArrayOfClsProdutoCaracteristica
	Local oClone := SKU_ArrayOfClsProdutoCaracteristica():NEW()
	oClone:oWSclsProdutoCaracteristica := NIL
	If ::oWSclsProdutoCaracteristica <> NIL 
		oClone:oWSclsProdutoCaracteristica := {}
		aEval( ::oWSclsProdutoCaracteristica , { |x| aadd( oClone:oWSclsProdutoCaracteristica , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_ArrayOfClsProdutoCaracteristica
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTOCARACTERISTICA","clsProdutoCaracteristica",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProdutoCaracteristica , SKU_clsProdutoCaracteristica():New() )
			::oWSclsProdutoCaracteristica[len(::oWSclsProdutoCaracteristica)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LoteSkuSalvar

WSSTRUCT SKU_LoteSkuSalvar
	WSDATA   cCodigoInternoProduto     AS string OPTIONAL
	WSDATA   cPartNumber               AS string OPTIONAL
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   oWSsku1                   AS SKU_ArrayOfString OPTIONAL
	WSDATA   oWSsku2                   AS SKU_ArrayOfString OPTIONAL
	WSDATA   oWSsku3                   AS SKU_ArrayOfString OPTIONAL
	WSDATA   oWSsku4                   AS SKU_ArrayOfString OPTIONAL
	WSDATA   oWSsku5                   AS SKU_ArrayOfString OPTIONAL
	WSDATA   nStatusSKU                AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_LoteSkuSalvar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_LoteSkuSalvar
Return

WSMETHOD CLONE WSCLIENT SKU_LoteSkuSalvar
	Local oClone := SKU_LoteSkuSalvar():NEW()
	oClone:cCodigoInternoProduto := ::cCodigoInternoProduto
	oClone:cPartNumber          := ::cPartNumber
	oClone:nPrecoPor            := ::nPrecoPor
	oClone:oWSsku1              := IIF(::oWSsku1 = NIL , NIL , ::oWSsku1:Clone() )
	oClone:oWSsku2              := IIF(::oWSsku2 = NIL , NIL , ::oWSsku2:Clone() )
	oClone:oWSsku3              := IIF(::oWSsku3 = NIL , NIL , ::oWSsku3:Clone() )
	oClone:oWSsku4              := IIF(::oWSsku4 = NIL , NIL , ::oWSsku4:Clone() )
	oClone:oWSsku5              := IIF(::oWSsku5 = NIL , NIL , ::oWSsku5:Clone() )
	oClone:nStatusSKU           := ::nStatusSKU
Return oClone

WSMETHOD SOAPSEND WSCLIENT SKU_LoteSkuSalvar
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoInternoProduto", ::cCodigoInternoProduto, ::cCodigoInternoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PartNumber", ::cPartNumber, ::cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, ::nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sku1", ::oWSsku1, ::oWSsku1 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sku2", ::oWSsku2, ::oWSsku2 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sku3", ::oWSsku3, ::oWSsku3 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sku4", ::oWSsku4, ::oWSsku4 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sku5", ::oWSsku5, ::oWSsku5 , "ArrayOfString", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("StatusSKU", ::nStatusSKU, ::nStatusSKU , "int", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLote

WSSTRUCT SKU_ArrayOfRetornoLote
	WSDATA   oWSRetornoLote            AS SKU_RetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_ArrayOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_ArrayOfRetornoLote
	::oWSRetornoLote       := {} // Array Of  SKU_RETORNOLOTE():New()
Return

WSMETHOD CLONE WSCLIENT SKU_ArrayOfRetornoLote
	Local oClone := SKU_ArrayOfRetornoLote():NEW()
	oClone:oWSRetornoLote := NIL
	If ::oWSRetornoLote <> NIL 
		oClone:oWSRetornoLote := {}
		aEval( ::oWSRetornoLote , { |x| aadd( oClone:oWSRetornoLote , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_ArrayOfRetornoLote
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTE","RetornoLote",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLote , SKU_RetornoLote():New() )
			::oWSRetornoLote[len(::oWSRetornoLote)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsProdutoCaracteristica

WSSTRUCT SKU_clsProdutoCaracteristica
	WSDATA   nLojaCodigo               AS int
	WSDATA   cPartNumber               AS string OPTIONAL
	WSDATA   nPrecoDe                  AS decimal OPTIONAL
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   oWSProdutoCaracteristicaStatus AS SKU_ProdutoCaracteristicaStatus
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   nPeso                     AS decimal OPTIONAL
	WSDATA   nPesoEmbalagem            AS decimal OPTIONAL
	WSDATA   nAltura                   AS decimal OPTIONAL
	WSDATA   nAlturaEmbalagem          AS decimal OPTIONAL
	WSDATA   nLargura                  AS decimal OPTIONAL
	WSDATA   nLarguraEmbalagem         AS decimal OPTIONAL
	WSDATA   nProfundidade             AS decimal OPTIONAL
	WSDATA   nProfundidadeEmbalagem    AS decimal OPTIONAL
	WSDATA   nAdicionalEntrega         AS int OPTIONAL
	WSDATA   nQuantidadeMinima         AS int OPTIONAL
	WSDATA   nQuantidadeMaxima         AS int OPTIONAL
	WSDATA   nValorMinimo              AS int OPTIONAL
	WSDATA   cTexto1                   AS string OPTIONAL
	WSDATA   cTexto2                   AS string OPTIONAL
	WSDATA   cTexto3                   AS string OPTIONAL
	WSDATA   cTexto4                   AS string OPTIONAL
	WSDATA   cTexto5                   AS string OPTIONAL
	WSDATA   cTexto6                   AS string OPTIONAL
	WSDATA   cTexto7                   AS string OPTIONAL
	WSDATA   cTexto8                   AS string OPTIONAL
	WSDATA   cTexto9                   AS string OPTIONAL
	WSDATA   cTexto10                  AS string OPTIONAL
	WSDATA   nNumero1                  AS decimal OPTIONAL
	WSDATA   nNumero2                  AS decimal OPTIONAL
	WSDATA   nNumero3                  AS decimal OPTIONAL
	WSDATA   nNumero4                  AS decimal OPTIONAL
	WSDATA   nNumero5                  AS decimal OPTIONAL
	WSDATA   nNumero6                  AS decimal OPTIONAL
	WSDATA   nNumero7                  AS decimal OPTIONAL
	WSDATA   nNumero8                  AS decimal OPTIONAL
	WSDATA   nNumero9                  AS decimal OPTIONAL
	WSDATA   nNumero10                 AS decimal OPTIONAL
	WSDATA   cEAN                      AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_clsProdutoCaracteristica
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_clsProdutoCaracteristica
Return

WSMETHOD CLONE WSCLIENT SKU_clsProdutoCaracteristica
	Local oClone := SKU_clsProdutoCaracteristica():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:cPartNumber          := ::cPartNumber
	oClone:nPrecoDe             := ::nPrecoDe
	oClone:nPrecoPor            := ::nPrecoPor
	oClone:oWSProdutoCaracteristicaStatus := IIF(::oWSProdutoCaracteristicaStatus = NIL , NIL , ::oWSProdutoCaracteristicaStatus:Clone() )
	oClone:cDescricao           := ::cDescricao
	oClone:nPeso                := ::nPeso
	oClone:nPesoEmbalagem       := ::nPesoEmbalagem
	oClone:nAltura              := ::nAltura
	oClone:nAlturaEmbalagem     := ::nAlturaEmbalagem
	oClone:nLargura             := ::nLargura
	oClone:nLarguraEmbalagem    := ::nLarguraEmbalagem
	oClone:nProfundidade        := ::nProfundidade
	oClone:nProfundidadeEmbalagem := ::nProfundidadeEmbalagem
	oClone:nAdicionalEntrega    := ::nAdicionalEntrega
	oClone:nQuantidadeMinima    := ::nQuantidadeMinima
	oClone:nQuantidadeMaxima    := ::nQuantidadeMaxima
	oClone:nValorMinimo         := ::nValorMinimo
	oClone:cTexto1              := ::cTexto1
	oClone:cTexto2              := ::cTexto2
	oClone:cTexto3              := ::cTexto3
	oClone:cTexto4              := ::cTexto4
	oClone:cTexto5              := ::cTexto5
	oClone:cTexto6              := ::cTexto6
	oClone:cTexto7              := ::cTexto7
	oClone:cTexto8              := ::cTexto8
	oClone:cTexto9              := ::cTexto9
	oClone:cTexto10             := ::cTexto10
	oClone:nNumero1             := ::nNumero1
	oClone:nNumero2             := ::nNumero2
	oClone:nNumero3             := ::nNumero3
	oClone:nNumero4             := ::nNumero4
	oClone:nNumero5             := ::nNumero5
	oClone:nNumero6             := ::nNumero6
	oClone:nNumero7             := ::nNumero7
	oClone:nNumero8             := ::nNumero8
	oClone:nNumero9             := ::nNumero9
	oClone:nNumero10            := ::nNumero10
	oClone:cEAN                 := ::cEAN
Return oClone

WSMETHOD SOAPSEND WSCLIENT SKU_clsProdutoCaracteristica
	Local cSoap := ""
	cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, ::nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PartNumber", ::cPartNumber, ::cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoDe", ::nPrecoDe, ::nPrecoDe , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, ::nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProdutoCaracteristicaStatus", ::oWSProdutoCaracteristicaStatus, ::oWSProdutoCaracteristicaStatus , "ProdutoCaracteristicaStatus", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Descricao", ::cDescricao, ::cDescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Peso", ::nPeso, ::nPeso , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PesoEmbalagem", ::nPesoEmbalagem, ::nPesoEmbalagem , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Altura", ::nAltura, ::nAltura , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AlturaEmbalagem", ::nAlturaEmbalagem, ::nAlturaEmbalagem , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Largura", ::nLargura, ::nLargura , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("LarguraEmbalagem", ::nLarguraEmbalagem, ::nLarguraEmbalagem , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Profundidade", ::nProfundidade, ::nProfundidade , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ProfundidadeEmbalagem", ::nProfundidadeEmbalagem, ::nProfundidadeEmbalagem , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("AdicionalEntrega", ::nAdicionalEntrega, ::nAdicionalEntrega , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeMinima", ::nQuantidadeMinima, ::nQuantidadeMinima , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("QuantidadeMaxima", ::nQuantidadeMaxima, ::nQuantidadeMaxima , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ValorMinimo", ::nValorMinimo, ::nValorMinimo , "int", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto1", ::cTexto1, ::cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto2", ::cTexto2, ::cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto3", ::cTexto3, ::cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto4", ::cTexto4, ::cTexto4 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto5", ::cTexto5, ::cTexto5 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto6", ::cTexto6, ::cTexto6 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto7", ::cTexto7, ::cTexto7 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto8", ::cTexto8, ::cTexto8 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto9", ::cTexto9, ::cTexto9 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Texto10", ::cTexto10, ::cTexto10 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero1", ::nNumero1, ::nNumero1 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero2", ::nNumero2, ::nNumero2 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero3", ::nNumero3, ::nNumero3 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero4", ::nNumero4, ::nNumero4 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero5", ::nNumero5, ::nNumero5 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero6", ::nNumero6, ::nNumero6 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero7", ::nNumero7, ::nNumero7 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero8", ::nNumero8, ::nNumero8 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero9", ::nNumero9, ::nNumero9 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("Numero10", ::nNumero10, ::nNumero10 , "decimal", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("EAN", ::cEAN, ::cEAN , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_clsProdutoCaracteristica
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cPartNumber        :=  WSAdvValue( oResponse,"_PARTNUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPrecoDe           :=  WSAdvValue( oResponse,"_PRECODE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPrecoPor          :=  WSAdvValue( oResponse,"_PRECOPOR","decimal",NIL,"Property nPrecoPor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_PRODUTOCARACTERISTICASTATUS","ProdutoCaracteristicaStatus",NIL,"Property oWSProdutoCaracteristicaStatus as tns:ProdutoCaracteristicaStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSProdutoCaracteristicaStatus := SKU_ProdutoCaracteristicaStatus():New()
		::oWSProdutoCaracteristicaStatus:SoapRecv(oNode5)
	EndIf
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPeso              :=  WSAdvValue( oResponse,"_PESO","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nPesoEmbalagem     :=  WSAdvValue( oResponse,"_PESOEMBALAGEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nAltura            :=  WSAdvValue( oResponse,"_ALTURA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nAlturaEmbalagem   :=  WSAdvValue( oResponse,"_ALTURAEMBALAGEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nLargura           :=  WSAdvValue( oResponse,"_LARGURA","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nLarguraEmbalagem  :=  WSAdvValue( oResponse,"_LARGURAEMBALAGEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nProfundidade      :=  WSAdvValue( oResponse,"_PROFUNDIDADE","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nProfundidadeEmbalagem :=  WSAdvValue( oResponse,"_PROFUNDIDADEEMBALAGEM","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nAdicionalEntrega  :=  WSAdvValue( oResponse,"_ADICIONALENTREGA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nQuantidadeMinima  :=  WSAdvValue( oResponse,"_QUANTIDADEMINIMA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nQuantidadeMaxima  :=  WSAdvValue( oResponse,"_QUANTIDADEMAXIMA","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nValorMinimo       :=  WSAdvValue( oResponse,"_VALORMINIMO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cTexto1            :=  WSAdvValue( oResponse,"_TEXTO1","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto2            :=  WSAdvValue( oResponse,"_TEXTO2","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto3            :=  WSAdvValue( oResponse,"_TEXTO3","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto4            :=  WSAdvValue( oResponse,"_TEXTO4","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto5            :=  WSAdvValue( oResponse,"_TEXTO5","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto6            :=  WSAdvValue( oResponse,"_TEXTO6","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto7            :=  WSAdvValue( oResponse,"_TEXTO7","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto8            :=  WSAdvValue( oResponse,"_TEXTO8","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto9            :=  WSAdvValue( oResponse,"_TEXTO9","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTexto10           :=  WSAdvValue( oResponse,"_TEXTO10","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero4           :=  WSAdvValue( oResponse,"_NUMERO4","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero5           :=  WSAdvValue( oResponse,"_NUMERO5","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero6           :=  WSAdvValue( oResponse,"_NUMERO6","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero7           :=  WSAdvValue( oResponse,"_NUMERO7","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero8           :=  WSAdvValue( oResponse,"_NUMERO8","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero9           :=  WSAdvValue( oResponse,"_NUMERO9","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::nNumero10          :=  WSAdvValue( oResponse,"_NUMERO10","decimal",NIL,NIL,NIL,"N",NIL,NIL) 
	::cEAN               :=  WSAdvValue( oResponse,"_EAN","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure RetornoLote

WSSTRUCT SKU_RetornoLote
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_RetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SKU_RetornoLote
Return

WSMETHOD CLONE WSCLIENT SKU_RetornoLote
	Local oClone := SKU_RetornoLote():NEW()
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_RetornoLote
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration ProdutoCaracteristicaStatus

WSSTRUCT SKU_ProdutoCaracteristicaStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SKU_ProdutoCaracteristicaStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT SKU_ProdutoCaracteristicaStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SKU_ProdutoCaracteristicaStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT SKU_ProdutoCaracteristicaStatus
Local oClone := SKU_ProdutoCaracteristicaStatus():New()
	oClone:Value := ::Value
Return oClone


