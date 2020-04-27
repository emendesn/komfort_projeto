#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.com.br/ikcwebservice/produto.asmx?wsdl
Gerado em        04/23/19 11:16:13
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function VEZUHXXA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service KHWSProduto
------------------------------------------------------------------------------- */

WSCLIENT KHWSProduto

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
	WSMETHOD List
	WSMETHOD SalvarPersonalizacao
	WSMETHOD AlterarPrecoLote

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   f                  	   AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodInProd     AS string
	WSDATA   cCodInFor  AS string
	WSDATA   cNomeProduto              AS string
	WSDATA   cTituloProduto            AS string
	WSDATA   cSubTituloProduto         AS string
	WSDATA   cDescricaoProduto         AS string
	WSDATA   cCactProd    AS string
	WSDATA   cTexto1Produto            AS string
	WSDATA   cTexto2Produto            AS string
	WSDATA   cTexto3Produto            AS string
	WSDATA   cTexto4Produto            AS string
	WSDATA   cTexto5Produto            AS string
	WSDATA   cTexto6Produto            AS string
	WSDATA   cTexto7Produto            AS string
	WSDATA   cTexto8Produto            AS string
	WSDATA   cTexto9Produto            AS string
	WSDATA   cTexto10Produto           AS string
	WSDATA   nNumero1Produto           AS decimal
	WSDATA   nNumero2Produto           AS decimal
	WSDATA   nNumero3Produto           AS decimal
	WSDATA   nNumero4Produto           AS decimal
	WSDATA   nNumero5Produto           AS decimal
	WSDATA   nNumero6Produto           AS decimal
	WSDATA   nNumero7Produto           AS decimal
	WSDATA   nNumero8Produto           AS decimal
	WSDATA   nNumero9Produto           AS decimal
	WSDATA   nNumero10Produto          AS decimal
	WSDATA   cEnquadra AS string
	WSDATA   cModProd            AS string
	WSDATA   nPesoProduto              AS decimal
	WSDATA   nPesoEmbPd     AS decimal
	WSDATA   nAlturaProduto            AS decimal
	WSDATA   nAlturaEmbP   AS decimal
	WSDATA   nLarguraProduto           AS decimal
	WSDATA   nLargEmPrd  AS decimal
	WSDATA   nProfProd      AS decimal
	WSDATA   nProfEmbPrd AS decimal
	WSDATA   nEntregaProduto           AS int
	WSDATA   nQtdMaxVnd AS int
	WSDATA   nStatProd            AS int
	WSDATA   cTipoProd              AS string
	WSDATA   nPresente                 AS int
	WSDATA   nPrcCheioPrd        AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   nPersExt      AS int
	WSDATA   cPersLabel      AS string
	WSDATA   cISBN                     AS string
	WSDATA   cEAN13                    AS string
	WSDATA   cYouTubeCode              AS string
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWsKh                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS PROD_clsRetOfclsProd
	WSDATA   nCNPJCodigo               AS int
	WSDATA   oWSSaveResult             AS PROD_clsRetOfclsProd
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   oWSAlterarPrecoResult     AS PROD_clsRetOfclsProd
	WSDATA   oWSAlterarStatusResult    AS PROD_clsRetOfclsProd
	WSDATA   oWSExcluirResult          AS PROD_clsRetOfclsProd
	WSDATA   cCodigoInternoFabricante  AS string
	WSDATA   nProdutoStatus            AS int
	WSDATA   oWSListarResult           AS PROD_clsRetOfclsProd
	WSDATA   nstoreCode                AS int
	WSDATA   cinternalCode             AS string
	WSDATA   cmanufacturerInternalCode AS string
	WSDATA   cname                     AS string
	WSDATA   nstatus                   AS int
	WSDATA   ntype                     AS int
	WSDATA   nitensPerPage             AS int
	WSDATA   npage                     AS int
	WSDATA   oWSListResult             AS PROD_PagedResultOfProductModel
	WSDATA   cCodInProdPrincipal AS string
	WSDATA   cCodInProdPersonalizacao AS string
	WSDATA   nStatusPersonlizacao      AS int
	WSDATA   oWSSalvarPersonalizacaoResult AS PROD_clsRetornoOfclsProdutoPersonalizacao
	WSDATA   oKHWSProdutos               AS PROD_ArrayOfLoteProdutoAlterarPreco
	WSDATA   oWSAlterarPrecoLoteResult AS PROD_clsRetornoOfRetornoLote

ENDWSCLIENT

WSMETHOD NEW WSCLIENT KHWSProduto
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O C�digo-Fonte Client atual requer a vers�o de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o reposit�rio ou gere o C�digo-Fonte novamente utilizando o reposit�rio atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT KHWSProduto
	::oWsKh                := NIL 
	::oWSSalvarResult    := PROD_clsRetOfclsProd():New()
	::oWSSaveResult      := PROD_clsRetOfclsProd():New()
	::oWSAlterarPrecoResult := PROD_clsRetOfclsProd():New()
	::oWSAlterarStatusResult := PROD_clsRetOfclsProd():New()
	::oWSExcluirResult   := PROD_clsRetOfclsProd():New()
	::oWSListarResult    := PROD_clsRetOfclsProd():New()
	::oWSListResult      := PROD_PAGEDRESULTOFPRODUCTMODEL():New()
	::oWSSalvarPersonalizacaoResult := PROD_CLSRETORNOOFCLSPRODUTOPERSONALIZACAO():New()
	::oKHWSProdutos        := PROD_ARRAYOFLOTEPRODUTOALTERARPRECO():New()
	::oWSAlterarPrecoLoteResult := PROD_CLSRETORNOOFRETORNOLOTE():New()
Return

WSMETHOD RESET WSCLIENT KHWSProduto
	::nLojaCodigo        := NIL 
	::cCodInProd := NIL 
	::cCodInFor := NIL 
	::cNomeProduto       := NIL 
	::cTituloProduto     := NIL 
	::cSubTituloProduto  := NIL 
	::cDescricaoProduto  := NIL 
	::cCactProd := NIL 
	::cTexto1Produto     := NIL 
	::cTexto2Produto     := NIL 
	::cTexto3Produto     := NIL 
	::cTexto4Produto     := NIL 
	::cTexto5Produto     := NIL 
	::cTexto6Produto     := NIL 
	::cTexto7Produto     := NIL 
	::cTexto8Produto     := NIL 
	::cTexto9Produto     := NIL 
	::cTexto10Produto    := NIL 
	::nNumero1Produto    := NIL 
	::nNumero2Produto    := NIL 
	::nNumero3Produto    := NIL 
	::nNumero4Produto    := NIL 
	::nNumero5Produto    := NIL 
	::nNumero6Produto    := NIL 
	::nNumero7Produto    := NIL 
	::nNumero8Produto    := NIL 
	::nNumero9Produto    := NIL 
	::nNumero10Produto   := NIL 
	::cEnquadra := NIL 
	::cModProd     := NIL 
	::nPesoProduto       := NIL 
	::nPesoEmbPd := NIL 
	::nAlturaProduto     := NIL 
	::nAlturaEmbP := NIL 
	::nLarguraProduto    := NIL 
	::nLargEmPrd := NIL 
	::nProfProd := NIL 
	::nProfEmbPrd := NIL 
	::nEntregaProduto    := NIL 
	::nQtdMaxVnd := NIL 
	::nStatProd     := NIL 
	::cTipoProd       := NIL 
	::nPresente          := NIL 
	::nPrcCheioPrd := NIL 
	::nPrecoPor          := NIL 
	::nPersExt := NIL 
	::cPersLabel := NIL 
	::cISBN              := NIL 
	::cEAN13             := NIL 
	::cYouTubeCode       := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWsKh                := NIL 
	::oWSSalvarResult    := NIL 
	::nCNPJCodigo        := NIL 
	::oWSSaveResult      := NIL 
	::nPrecoCheio        := NIL 
	::oWSAlterarPrecoResult := NIL 
	::oWSAlterarStatusResult := NIL 
	::oWSExcluirResult   := NIL 
	::cCodigoInternoFabricante := NIL 
	::nProdutoStatus     := NIL 
	::oWSListarResult    := NIL 
	::nstoreCode         := NIL 
	::cinternalCode      := NIL 
	::cmanufacturerInternalCode := NIL 
	::cname              := NIL 
	::nstatus            := NIL 
	::ntype              := NIL 
	::nitensPerPage      := NIL 
	::npage              := NIL 
	::oWSListResult      := NIL 
	::cCodInProdPrincipal := NIL 
	::cCodInProdPersonalizacao := NIL 
	::nStatusPersonlizacao := NIL 
	::oWSSalvarPersonalizacaoResult := NIL 
	::oKHWSProdutos        := NIL 
	::oWSAlterarPrecoLoteResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT KHWSProduto
Local oClone := KHWSProduto():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodInProd := ::cCodInProd
	oClone:cCodInFor := ::cCodInFor
	oClone:cNomeProduto  := ::cNomeProduto
	oClone:cTituloProduto := ::cTituloProduto
	oClone:cSubTituloProduto := ::cSubTituloProduto
	oClone:cDescricaoProduto := ::cDescricaoProduto
	oClone:cCactProd := ::cCactProd
	oClone:cTexto1Produto := ::cTexto1Produto
	oClone:cTexto2Produto := ::cTexto2Produto
	oClone:cTexto3Produto := ::cTexto3Produto
	oClone:cTexto4Produto := ::cTexto4Produto
	oClone:cTexto5Produto := ::cTexto5Produto
	oClone:cTexto6Produto := ::cTexto6Produto
	oClone:cTexto7Produto := ::cTexto7Produto
	oClone:cTexto8Produto := ::cTexto8Produto
	oClone:cTexto9Produto := ::cTexto9Produto
	oClone:cTexto10Produto := ::cTexto10Produto
	oClone:nNumero1Produto := ::nNumero1Produto
	oClone:nNumero2Produto := ::nNumero2Produto
	oClone:nNumero3Produto := ::nNumero3Produto
	oClone:nNumero4Produto := ::nNumero4Produto
	oClone:nNumero5Produto := ::nNumero5Produto
	oClone:nNumero6Produto := ::nNumero6Produto
	oClone:nNumero7Produto := ::nNumero7Produto
	oClone:nNumero8Produto := ::nNumero8Produto
	oClone:nNumero9Produto := ::nNumero9Produto
	oClone:nNumero10Produto := ::nNumero10Produto
	oClone:cEnquadra := ::cEnquadra
	oClone:cModProd := ::cModProd
	oClone:nPesoProduto  := ::nPesoProduto
	oClone:nPesoEmbPd := ::nPesoEmbPd
	oClone:nAlturaProduto := ::nAlturaProduto
	oClone:nAlturaEmbP := ::nAlturaEmbP
	oClone:nLarguraProduto := ::nLarguraProduto
	oClone:nLargEmPrd := ::nLargEmPrd
	oClone:nProfProd := ::nProfProd
	oClone:nProfEmbPrd := ::nProfEmbPrd
	oClone:nEntregaProduto := ::nEntregaProduto
	oClone:nQtdMaxVnd := ::nQtdMaxVnd
	oClone:nStatProd := ::nStatProd
	oClone:cTipoProd  := ::cTipoProd
	oClone:nPresente     := ::nPresente
	oClone:nPrcCheioPrd := ::nPrcCheioPrd
	oClone:nPrecoPor     := ::nPrecoPor
	oClone:nPersExt := ::nPersExt
	oClone:cPersLabel := ::cPersLabel
	oClone:cISBN         := ::cISBN
	oClone:cEAN13        := ::cEAN13
	oClone:cYouTubeCode  := ::cYouTubeCode
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarResult :=  IIF(::oWSSalvarResult = NIL , NIL ,::oWSSalvarResult:Clone() )
	oClone:nCNPJCodigo   := ::nCNPJCodigo
	oClone:oWSSaveResult :=  IIF(::oWSSaveResult = NIL , NIL ,::oWSSaveResult:Clone() )
	oClone:nPrecoCheio   := ::nPrecoCheio
	oClone:oWSAlterarPrecoResult :=  IIF(::oWSAlterarPrecoResult = NIL , NIL ,::oWSAlterarPrecoResult:Clone() )
	oClone:oWSAlterarStatusResult :=  IIF(::oWSAlterarStatusResult = NIL , NIL ,::oWSAlterarStatusResult:Clone() )
	oClone:oWSExcluirResult :=  IIF(::oWSExcluirResult = NIL , NIL ,::oWSExcluirResult:Clone() )
	oClone:cCodigoInternoFabricante := ::cCodigoInternoFabricante
	oClone:nProdutoStatus := ::nProdutoStatus
	oClone:oWSListarResult :=  IIF(::oWSListarResult = NIL , NIL ,::oWSListarResult:Clone() )
	oClone:nstoreCode    := ::nstoreCode
	oClone:cinternalCode := ::cinternalCode
	oClone:cmanufacturerInternalCode := ::cmanufacturerInternalCode
	oClone:cname         := ::cname
	oClone:nstatus       := ::nstatus
	oClone:ntype         := ::ntype
	oClone:nitensPerPage := ::nitensPerPage
	oClone:npage         := ::npage
	oClone:oWSListResult :=  IIF(::oWSListResult = NIL , NIL ,::oWSListResult:Clone() )
	oClone:cCodInProdPrincipal := ::cCodInProdPrincipal
	oClone:cCodInProdPersonalizacao := ::cCodInProdPersonalizacao
	oClone:nStatusPersonlizacao := ::nStatusPersonlizacao
	oClone:oWSSalvarPersonalizacaoResult :=  IIF(::oWSSalvarPersonalizacaoResult = NIL , NIL ,::oWSSalvarPersonalizacaoResult:Clone() )
	oClone:oKHWSProdutos   :=  IIF(::oKHWSProdutos = NIL , NIL ,::oKHWSProdutos:Clone() )
	oClone:oWSAlterarPrecoLoteResult :=  IIF(::oWSAlterarPrecoLoteResult = NIL , NIL ,::oWSAlterarPrecoLoteResult:Clone() )
Return oClone

// WSDL Method Salvar of Service KHWSProduto

WSMETHOD Salvar WSSEND nLojaCodigo,cCodInProd,cCodInFor,cNomeProduto,cTituloProduto,cSubTituloProduto,cDescricaoProduto,cCactProd,cTexto1Produto,cTexto2Produto,cTexto3Produto,cTexto4Produto,cTexto5Produto,cTexto6Produto,cTexto7Produto,cTexto8Produto,cTexto9Produto,cTexto10Produto,nNumero1Produto,nNumero2Produto,nNumero3Produto,nNumero4Produto,nNumero5Produto,nNumero6Produto,nNumero7Produto,nNumero8Produto,nNumero9Produto,nNumero10Produto,cEnquadra,cModProd,nPesoProduto,nPesoEmbPd,nAlturaProduto,nAlturaEmbP,nLarguraProduto,nLargEmPrd,nProfProd,nProfEmbPrd,nEntregaProduto,nQtdMaxVnd,nStatProd,cTipoProd,nPresente,nPrcCheioPrd,nPrecoPor,nPersExt,cPersLabel,cISBN,cEAN13,cYouTubeCode,cA1,cA2,oWsKh WSRECEIVE oWSSalvarResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"


cSoap += '<Salvar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoFornecedor", ::cCodInFor, cCodInFor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TituloProduto", ::cTituloProduto, cTituloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("SubTituloProduto", ::cSubTituloProduto, cSubTituloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DescricaoProduto", ::cDescricaoProduto, cDescricaoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CaracteristicaProduto", ::cCactProd, cCactProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1Produto", ::cTexto1Produto, cTexto1Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2Produto", ::cTexto2Produto, cTexto2Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3Produto", ::cTexto3Produto, cTexto3Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto4Produto", ::cTexto4Produto, cTexto4Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto5Produto", ::cTexto5Produto, cTexto5Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto6Produto", ::cTexto6Produto, cTexto6Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto7Produto", ::cTexto7Produto, cTexto7Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto8Produto", ::cTexto8Produto, cTexto8Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto9Produto", ::cTexto9Produto, cTexto9Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto10Produto", ::cTexto10Produto, cTexto10Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1Produto", ::nNumero1Produto, nNumero1Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2Produto", ::nNumero2Produto, nNumero2Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3Produto", ::nNumero3Produto, nNumero3Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero4Produto", ::nNumero4Produto, nNumero4Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero5Produto", ::nNumero5Produto, nNumero5Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero6Produto", ::nNumero6Produto, nNumero6Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero7Produto", ::nNumero7Produto, nNumero7Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero8Produto", ::nNumero8Produto, nNumero8Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero9Produto", ::nNumero9Produto, nNumero9Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero10Produto", ::nNumero10Produto, nNumero10Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoEnquadramento", ::cEnquadra, cEnquadra , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ModeloProduto", ::cModProd, cModProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoProduto", ::nPesoProduto, nPesoProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoEmbalagemProduto", ::nPesoEmbPd, nPesoEmbPd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaProduto", ::nAlturaProduto, nAlturaProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaEmbalagemProduto", ::nAlturaEmbP, nAlturaEmbP , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraProduto", ::nLarguraProduto, nLarguraProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraEmbalagemProduto", ::nLargEmPrd, nLargEmPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeProduto", ::nProfProd, nProfProd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeEmbalagemProduto", ::nProfEmbPrd, nProfEmbPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EntregaProduto", ::nEntregaProduto, nEntregaProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QuantidadeMaximaPorVenda", ::nQtdMaxVnd, nQtdMaxVnd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatProd, nStatProd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::cTipoProd, cTipoProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Presente", ::nPresente, nPresente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheioProduto", ::nPrcCheioPrd, nPrcCheioPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoExtra", ::nPersExt, nPersExt , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoLabel", ::cPersLabel, cPersLabel , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ISBN", ::cISBN, cISBN , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EAN13", ::cEAN13, cEAN13 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("YouTubeCode", ::cYouTubeCode, cYouTubeCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

Conout("------------")
oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")
	
	Conout("TIPO XML WS" + ValType(oXmlRet))
::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )



END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Save of Service KHWSProduto

WSMETHOD Save WSSEND nLojaCodigo,cCodInProd,cCodInFor,cNomeProduto,cTituloProduto,cSubTituloProduto,cDescricaoProduto,cCactProd,cTexto1Produto,cTexto2Produto,cTexto3Produto,cTexto4Produto,cTexto5Produto,cTexto6Produto,cTexto7Produto,cTexto8Produto,cTexto9Produto,cTexto10Produto,nNumero1Produto,nNumero2Produto,nNumero3Produto,nNumero4Produto,nNumero5Produto,nNumero6Produto,nNumero7Produto,nNumero8Produto,nNumero9Produto,nNumero10Produto,cEnquadra,cModProd,nPesoProduto,nPesoEmbPd,nAlturaProduto,nAlturaEmbP,nLarguraProduto,nLargEmPrd,nProfProd,nProfEmbPrd,nEntregaProduto,nQtdMaxVnd,nStatProd,cTipoProd,nPresente,nPrcCheioPrd,nPrecoPor,nPersExt,cPersLabel,cISBN,cEAN13,cYouTubeCode,nCNPJCodigo,cA1,cA2,oWsKh WSRECEIVE oWSSaveResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Save xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoFornecedor", ::cCodInFor, cCodInFor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TituloProduto", ::cTituloProduto, cTituloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("SubTituloProduto", ::cSubTituloProduto, cSubTituloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DescricaoProduto", ::cDescricaoProduto, cDescricaoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CaracteristicaProduto", ::cCactProd, cCactProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1Produto", ::cTexto1Produto, cTexto1Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2Produto", ::cTexto2Produto, cTexto2Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3Produto", ::cTexto3Produto, cTexto3Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto4Produto", ::cTexto4Produto, cTexto4Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto5Produto", ::cTexto5Produto, cTexto5Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto6Produto", ::cTexto6Produto, cTexto6Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto7Produto", ::cTexto7Produto, cTexto7Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto8Produto", ::cTexto8Produto, cTexto8Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto9Produto", ::cTexto9Produto, cTexto9Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto10Produto", ::cTexto10Produto, cTexto10Produto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1Produto", ::nNumero1Produto, nNumero1Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2Produto", ::nNumero2Produto, nNumero2Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3Produto", ::nNumero3Produto, nNumero3Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero4Produto", ::nNumero4Produto, nNumero4Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero5Produto", ::nNumero5Produto, nNumero5Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero6Produto", ::nNumero6Produto, nNumero6Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero7Produto", ::nNumero7Produto, nNumero7Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero8Produto", ::nNumero8Produto, nNumero8Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero9Produto", ::nNumero9Produto, nNumero9Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero10Produto", ::nNumero10Produto, nNumero10Produto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoEnquadramento", ::cEnquadra, cEnquadra , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ModeloProduto", ::cModProd, cModProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoProduto", ::nPesoProduto, nPesoProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoEmbalagemProduto", ::nPesoEmbPd, nPesoEmbPd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaProduto", ::nAlturaProduto, nAlturaProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaEmbalagemProduto", ::nAlturaEmbP, nAlturaEmbP , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraProduto", ::nLarguraProduto, nLarguraProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraEmbalagemProduto", ::nLargEmPrd, nLargEmPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeProduto", ::nProfProd, nProfProd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeEmbalagemProduto", ::nProfEmbPrd, nProfEmbPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EntregaProduto", ::nEntregaProduto, nEntregaProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QuantidadeMaximaPorVenda", ::nQtdMaxVnd, nQtdMaxVnd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatProd, nStatProd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::cTipoProd, cTipoProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Presente", ::nPresente, nPresente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheioProduto", ::nPrcCheioPrd, nPrcCheioPrd , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoExtra", ::nPersExt, nPersExt , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoLabel", ::cPersLabel, cPersLabel , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ISBN", ::cISBN, cISBN , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EAN13", ::cEAN13, cEAN13 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("YouTubeCode", ::cYouTubeCode, cYouTubeCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJCodigo", ::nCNPJCodigo, nCNPJCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Save>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Save",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSSaveResult:SoapRecv( WSAdvValue( oXmlRet,"_SAVERESPONSE:_SAVERESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPreco of Service KHWSProduto

WSMETHOD AlterarPreco WSSEND nLojaCodigo,cCodInProd,nPrecoCheio,nPrecoPor,cA1,cA2,oWsKh WSRECEIVE oWSAlterarPrecoResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarPreco xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPreco>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPreco",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarPrecoResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECORESPONSE:_ALTERARPRECORESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatus of Service KHWSProduto

WSMETHOD AlterarStatus WSSEND nLojaCodigo,cCodInProd,nStatProd,cA1,cA2,oWsKh WSRECEIVE oWSAlterarStatusResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarStatus xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatProd, nStatProd , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatus>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatus",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarStatusResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSRESPONSE:_ALTERARSTATUSRESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Excluir of Service KHWSProduto

WSMETHOD Excluir WSSEND nLojaCodigo,cCodInProd,cA1,cA2,oWsKh WSRECEIVE oWSExcluirResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Excluir xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Excluir>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Excluir",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSExcluirResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRRESPONSE:_EXCLUIRRESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service KHWSProduto

WSMETHOD Listar WSSEND nLojaCodigo,cCodInProd,cCodigoInternoFabricante,cNomeProduto,nProdutoStatus,nTipoProduto,cA1,cA2,oWsKh WSRECEIVE oWSListarResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Listar xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoFabricante", ::cCodigoInternoFabricante, cCodigoInternoFabricante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProdutoStatus", ::nProdutoStatus, nProdutoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::nTipoProduto, nTipoProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","PROD_clsRetOfclsProd",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method List of Service KHWSProduto

WSMETHOD List WSSEND nstoreCode,cinternalCode,cmanufacturerInternalCode,cname,nstatus,ntype,nitensPerPage,npage,cA1,cA2,oWsKh WSRECEIVE oWSListResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<List xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("storeCode", ::nstoreCode, nstoreCode , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("internalCode", ::cinternalCode, cinternalCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("manufacturerInternalCode", ::cmanufacturerInternalCode, cmanufacturerInternalCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("status", ::nstatus, nstatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("type", ::ntype, ntype , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("itensPerPage", ::nitensPerPage, nitensPerPage , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("page", ::npage, npage , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</List>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/List",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSListResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTRESPONSE:_LISTRESULT","PagedResultOfProductModel",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarPersonalizacao of Service KHWSProduto

WSMETHOD SalvarPersonalizacao WSSEND nLojaCodigo,cCodInProdPrincipal,cCodInProdPersonalizacao,nStatusPersonlizacao,cA1,cA2,oWsKh WSRECEIVE oWSSalvarPersonalizacaoResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarPersonalizacao xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProdutoPrincipal", ::cCodInProdPrincipal, cCodInProdPrincipal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProdutoPersonalizacao", ::cCodInProdPersonalizacao, cCodInProdPersonalizacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusPersonlizacao", ::nStatusPersonlizacao, nStatusPersonlizacao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarPersonalizacao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarPersonalizacao",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSSalvarPersonalizacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARPERSONALIZACAORESPONSE:_SALVARPERSONALIZACAORESULT","clsRetornoOfclsProdutoPersonalizacao",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPrecoLote of Service KHWSProduto

WSMETHOD AlterarPrecoLote WSSEND nLojaCodigo,oKHWSProdutos,cA1,cA2,oWsKh WSRECEIVE oWSAlterarPrecoLoteResult WSCLIENT KHWSProduto
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWsKh, oWsKh , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<AlterarPrecoLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Produtos", ::oKHWSProdutos, oKHWSProdutos , "ArrayOfLoteProdutoAlterarPreco", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPrecoLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPrecoLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarPrecoLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECOLOTERESPONSE:_ALTERARPRECOLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure PROD_clsRetOfclsProd

WSSTRUCT PROD_clsRetOfclsProd
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Prod_ArrayOfClsProduto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_clsRetOfclsProd
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_clsRetOfclsProd
Return

WSMETHOD CLONE WSCLIENT PROD_clsRetOfclsProd
	Local oClone := PROD_clsRetOfclsProd():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_clsRetOfclsProd
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsProduto",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Prod_ArrayOfClsProduto():New() 
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure PagedResultOfProductModel

WSSTRUCT PROD_PagedResultOfProductModel
	WSDATA   nTotalItens               AS int
	WSDATA   nTotalPages               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_PagedResultOfProductModel
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_PagedResultOfProductModel
Return

WSMETHOD CLONE WSCLIENT PROD_PagedResultOfProductModel
	Local oClone := PROD_PagedResultOfProductModel():NEW()
	oClone:nTotalItens          := ::nTotalItens
	oClone:nTotalPages          := ::nTotalPages
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_PagedResultOfProductModel
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nTotalItens        :=  WSAdvValue( oResponse,"_TOTALITENS","int",NIL,"Property nTotalItens as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTotalPages        :=  WSAdvValue( oResponse,"_TOTALPAGES","int",NIL,"Property nTotalPages as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure clsRetornoOfclsProdutoPersonalizacao

WSSTRUCT PROD_clsRetornoOfclsProdutoPersonalizacao
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Prod_ArrayOfClsProdutoPersonalizacao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_clsRetornoOfclsProdutoPersonalizacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_clsRetornoOfclsProdutoPersonalizacao
Return

WSMETHOD CLONE WSCLIENT PROD_clsRetornoOfclsProdutoPersonalizacao
	Local oClone := PROD_clsRetornoOfclsProdutoPersonalizacao():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_clsRetornoOfclsProdutoPersonalizacao
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsProdutoPersonalizacao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Prod_ArrayOfClsProdutoPersonalizacao():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLoteProdutoAlterarPreco

WSSTRUCT PROD_ArrayOfLoteProdutoAlterarPreco
	WSDATA   oWSLoteProdutoAlterarPreco AS PROD_LoteProdutoAlterarPreco OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_ArrayOfLoteProdutoAlterarPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_ArrayOfLoteProdutoAlterarPreco
	::oWSLoteProdutoAlterarPreco := {} // Array Of  PROD_LOTEPRODUTOALTERARPRECO():New()
Return

WSMETHOD CLONE WSCLIENT PROD_ArrayOfLoteProdutoAlterarPreco
	Local oClone := PROD_ArrayOfLoteProdutoAlterarPreco():NEW()
	oClone:oWSLoteProdutoAlterarPreco := NIL
	If ::oWSLoteProdutoAlterarPreco <> NIL 
		oClone:oWSLoteProdutoAlterarPreco := {}
		aEval( ::oWSLoteProdutoAlterarPreco , { |x| aadd( oClone:oWSLoteProdutoAlterarPreco , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT PROD_ArrayOfLoteProdutoAlterarPreco
	Local cSoap := ""
	aEval( ::oWSLoteProdutoAlterarPreco , {|x| cSoap := cSoap  +  WSSoapValue("LoteProdutoAlterarPreco", x , x , "LoteProdutoAlterarPreco", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLote

WSSTRUCT PROD_clsRetornoOfRetornoLote
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS PROD_ArrayOfRetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_clsRetornoOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_clsRetornoOfRetornoLote
Return

WSMETHOD CLONE WSCLIENT PROD_clsRetornoOfRetornoLote
	Local oClone := PROD_clsRetornoOfRetornoLote():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_clsRetornoOfRetornoLote
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLote",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := PROD_ArrayOfRetornoLote():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsProduto

WSSTRUCT Prod_ArrayOfClsProduto
	WSDATA   oWSclsProduto             AS PROD_clsProduto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Prod_ArrayOfClsProduto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Prod_ArrayOfClsProduto
	::oWSclsProduto        := {} // Array Of  PROD_CLSPRODUTO():New()
Return

WSMETHOD CLONE WSCLIENT Prod_ArrayOfClsProduto
	Local oClone := Prod_ArrayOfClsProduto():NEW()
	oClone:oWSclsProduto := NIL
	If ::oWSclsProduto <> NIL 
		oClone:oWSclsProduto := {}
		aEval( ::oWSclsProduto , { |x| aadd( oClone:oWSclsProduto , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Prod_ArrayOfClsProduto
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTO","clsProduto",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProduto , PROD_clsProduto():New() )
			::oWSclsProduto[len(::oWSclsProduto)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ArrayOfClsProdutoPersonalizacao

WSSTRUCT Prod_ArrayOfClsProdutoPersonalizacao
	WSDATA   oWSclsProdutoPersonalizacao AS PROD_clsProdutoPersonalizacao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Prod_ArrayOfClsProdutoPersonalizacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Prod_ArrayOfClsProdutoPersonalizacao
	::oWSclsProdutoPersonalizacao := {} // Array Of  PROD_CLSPRODUTOPERSONALIZACAO():New()
Return

WSMETHOD CLONE WSCLIENT Prod_ArrayOfClsProdutoPersonalizacao
	Local oClone := Prod_ArrayOfClsProdutoPersonalizacao():NEW()
	oClone:oWSclsProdutoPersonalizacao := NIL
	If ::oWSclsProdutoPersonalizacao <> NIL 
		oClone:oWSclsProdutoPersonalizacao := {}
		aEval( ::oWSclsProdutoPersonalizacao , { |x| aadd( oClone:oWSclsProdutoPersonalizacao , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Prod_ArrayOfClsProdutoPersonalizacao
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTOPERSONALIZACAO","clsProdutoPersonalizacao",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProdutoPersonalizacao , PROD_clsProdutoPersonalizacao():New() )
			::oWSclsProdutoPersonalizacao[len(::oWSclsProdutoPersonalizacao)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LoteProdutoAlterarPreco

WSSTRUCT PROD_LoteProdutoAlterarPreco
	WSDATA   cCodInProd     AS string OPTIONAL
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_LoteProdutoAlterarPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_LoteProdutoAlterarPreco
Return

WSMETHOD CLONE WSCLIENT PROD_LoteProdutoAlterarPreco
	Local oClone := PROD_LoteProdutoAlterarPreco():NEW()
	oClone:cCodInProd := ::cCodInProd
	oClone:nPrecoCheio          := ::nPrecoCheio
	oClone:nPrecoPor            := ::nPrecoPor
Return oClone

WSMETHOD SOAPSEND WSCLIENT PROD_LoteProdutoAlterarPreco
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoInternoProduto", ::cCodInProd, ::cCodInProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, ::nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, ::nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLote

WSSTRUCT PROD_ArrayOfRetornoLote
	WSDATA   oWSRetornoLote            AS PROD_RetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_ArrayOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_ArrayOfRetornoLote
	::oWSRetornoLote       := {} // Array Of  PROD_RETORNOLOTE():New()
Return

WSMETHOD CLONE WSCLIENT PROD_ArrayOfRetornoLote
	Local oClone := PROD_ArrayOfRetornoLote():NEW()
	oClone:oWSRetornoLote := NIL
	If ::oWSRetornoLote <> NIL 
		oClone:oWSRetornoLote := {}
		aEval( ::oWSRetornoLote , { |x| aadd( oClone:oWSRetornoLote , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_ArrayOfRetornoLote
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTE","RetornoLote",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLote , PROD_RetornoLote():New() )
			::oWSRetornoLote[len(::oWSRetornoLote)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsProduto

WSSTRUCT PROD_clsProduto
	WSDATA   nLojaCodigo               AS int
	WSDATA   nProdutoCodigo            AS int OPTIONAL
	WSDATA   cProdutoCodigoInterno     AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cTitulo                   AS string OPTIONAL
	WSDATA   lIsRequiredCustomization  AS boolean
	WSDATA   cSubtitulo                AS string OPTIONAL
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   cCaracteristica           AS string OPTIONAL
	WSDATA   cLongPage                 AS string OPTIONAL
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
	WSDATA   nNumero1                  AS decimal
	WSDATA   nNumero2                  AS decimal
	WSDATA   nNumero3                  AS decimal
	WSDATA   nNumero4                  AS decimal
	WSDATA   nNumero5                  AS decimal
	WSDATA   nNumero6                  AS decimal
	WSDATA   nNumero7                  AS decimal
	WSDATA   nNumero8                  AS decimal
	WSDATA   nNumero9                  AS decimal
	WSDATA   nNumero10                 AS decimal
	WSDATA   nPeso                     AS decimal
	WSDATA   nAltura                   AS decimal
	WSDATA   nLargura                  AS decimal
	WSDATA   nProfundidade             AS decimal
	WSDATA   nPesoEmbalagem            AS decimal
	WSDATA   nAlturaEmbalagem          AS decimal
	WSDATA   nLarguraEmbalagem         AS decimal
	WSDATA   nProfundidadeEmbalagem    AS decimal
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   nEntrega                  AS int
	WSDATA   nQtdMaxVnd AS int
	WSDATA   oKHWSProdutoStatus          AS PROD_ProdutoStatus
	WSDATA   oWSTipo                   AS PROD_ProdutoTipo
	WSDATA   oWSPresente               AS PROD_SimNao
	WSDATA   oWSPersonalizacaoExtra    AS PROD_SimNao
	WSDATA   cPersLabel      AS string OPTIONAL
	WSDATA   nCompanyId                AS int OPTIONAL
	WSDATA   nIndicationGroupId        AS int
	WSDATA   cISBN                     AS string OPTIONAL
	WSDATA   cEAN13                    AS string OPTIONAL
	WSDATA   cYouTubeCode              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_clsProduto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_clsProduto
Return

WSMETHOD CLONE WSCLIENT PROD_clsProduto
	Local oClone := PROD_clsProduto():NEW()
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:nProdutoCodigo       := ::nProdutoCodigo
	oClone:cProdutoCodigoInterno := ::cProdutoCodigoInterno
	oClone:cNome                := ::cNome
	oClone:cTitulo              := ::cTitulo
	oClone:lIsRequiredCustomization := ::lIsRequiredCustomization
	oClone:cSubtitulo           := ::cSubtitulo
	oClone:cDescricao           := ::cDescricao
	oClone:cCaracteristica      := ::cCaracteristica
	oClone:cLongPage            := ::cLongPage
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
	oClone:nPeso                := ::nPeso
	oClone:nAltura              := ::nAltura
	oClone:nLargura             := ::nLargura
	oClone:nProfundidade        := ::nProfundidade
	oClone:nPesoEmbalagem       := ::nPesoEmbalagem
	oClone:nAlturaEmbalagem     := ::nAlturaEmbalagem
	oClone:nLarguraEmbalagem    := ::nLarguraEmbalagem
	oClone:nProfundidadeEmbalagem := ::nProfundidadeEmbalagem
	oClone:nPrecoCheio          := ::nPrecoCheio
	oClone:nPrecoPor            := ::nPrecoPor
	oClone:nEntrega             := ::nEntrega
	oClone:nQtdMaxVnd := ::nQtdMaxVnd
	oClone:oKHWSProdutoStatus     := IIF(::oKHWSProdutoStatus = NIL , NIL , ::oKHWSProdutoStatus:Clone() )
	oClone:oWSTipo              := IIF(::oWSTipo = NIL , NIL , ::oWSTipo:Clone() )
	oClone:oWSPresente          := IIF(::oWSPresente = NIL , NIL , ::oWSPresente:Clone() )
	oClone:oWSPersonalizacaoExtra := IIF(::oWSPersonalizacaoExtra = NIL , NIL , ::oWSPersonalizacaoExtra:Clone() )
	oClone:cPersLabel := ::cPersLabel
	oClone:nCompanyId           := ::nCompanyId
	oClone:nIndicationGroupId   := ::nIndicationGroupId
	oClone:cISBN                := ::cISBN
	oClone:cEAN13               := ::cEAN13
	oClone:cYouTubeCode         := ::cYouTubeCode
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_clsProduto
	Local oNode43
	Local oNode44
	Local oNode45
	Local oNode46
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nProdutoCodigo     :=  WSAdvValue( oResponse,"_PRODUTOCODIGO","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::cProdutoCodigoInterno :=  WSAdvValue( oResponse,"_PRODUTOCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTitulo            :=  WSAdvValue( oResponse,"_TITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lIsRequiredCustomization :=  WSAdvValue( oResponse,"_ISREQUIREDCUSTOMIZATION","boolean",NIL,"Property lIsRequiredCustomization as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
	::cSubtitulo         :=  WSAdvValue( oResponse,"_SUBTITULO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCaracteristica    :=  WSAdvValue( oResponse,"_CARACTERISTICA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cLongPage          :=  WSAdvValue( oResponse,"_LONGPAGE","string",NIL,NIL,NIL,"S",NIL,NIL) 
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
	::nNumero1           :=  WSAdvValue( oResponse,"_NUMERO1","decimal",NIL,"Property nNumero1 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero2           :=  WSAdvValue( oResponse,"_NUMERO2","decimal",NIL,"Property nNumero2 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero3           :=  WSAdvValue( oResponse,"_NUMERO3","decimal",NIL,"Property nNumero3 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero4           :=  WSAdvValue( oResponse,"_NUMERO4","decimal",NIL,"Property nNumero4 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero5           :=  WSAdvValue( oResponse,"_NUMERO5","decimal",NIL,"Property nNumero5 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero6           :=  WSAdvValue( oResponse,"_NUMERO6","decimal",NIL,"Property nNumero6 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero7           :=  WSAdvValue( oResponse,"_NUMERO7","decimal",NIL,"Property nNumero7 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero8           :=  WSAdvValue( oResponse,"_NUMERO8","decimal",NIL,"Property nNumero8 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero9           :=  WSAdvValue( oResponse,"_NUMERO9","decimal",NIL,"Property nNumero9 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNumero10          :=  WSAdvValue( oResponse,"_NUMERO10","decimal",NIL,"Property nNumero10 as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeso              :=  WSAdvValue( oResponse,"_PESO","decimal",NIL,"Property nPeso as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAltura            :=  WSAdvValue( oResponse,"_ALTURA","decimal",NIL,"Property nAltura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLargura           :=  WSAdvValue( oResponse,"_LARGURA","decimal",NIL,"Property nLargura as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nProfundidade      :=  WSAdvValue( oResponse,"_PROFUNDIDADE","decimal",NIL,"Property nProfundidade as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesoEmbalagem     :=  WSAdvValue( oResponse,"_PESOEMBALAGEM","decimal",NIL,"Property nPesoEmbalagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nAlturaEmbalagem   :=  WSAdvValue( oResponse,"_ALTURAEMBALAGEM","decimal",NIL,"Property nAlturaEmbalagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLarguraEmbalagem  :=  WSAdvValue( oResponse,"_LARGURAEMBALAGEM","decimal",NIL,"Property nLarguraEmbalagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nProfundidadeEmbalagem :=  WSAdvValue( oResponse,"_PROFUNDIDADEEMBALAGEM","decimal",NIL,"Property nProfundidadeEmbalagem as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrecoCheio        :=  WSAdvValue( oResponse,"_PRECOCHEIO","decimal",NIL,"Property nPrecoCheio as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPrecoPor          :=  WSAdvValue( oResponse,"_PRECOPOR","decimal",NIL,"Property nPrecoPor as s:decimal on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nEntrega           :=  WSAdvValue( oResponse,"_ENTREGA","int",NIL,"Property nEntrega as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nQtdMaxVnd :=  WSAdvValue( oResponse,"_QUANTIDADEMAXIMAPORVENDA","int",NIL,"Property nQtdMaxVnd as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode43 :=  WSAdvValue( oResponse,"_PRODUTOSTATUS","ProdutoStatus",NIL,"Property oKHWSProdutoStatus as tns:ProdutoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode43 != NIL
		::oKHWSProdutoStatus := PROD_ProdutoStatus():New()
		::oKHWSProdutoStatus:SoapRecv(oNode43)
	EndIf
	oNode44 :=  WSAdvValue( oResponse,"_TIPO","ProdutoTipo",NIL,"Property oWSTipo as tns:ProdutoTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode44 != NIL
		::oWSTipo := PROD_ProdutoTipo():New()
		::oWSTipo:SoapRecv(oNode44)
	EndIf
	oNode45 :=  WSAdvValue( oResponse,"_PRESENTE","SimNao",NIL,"Property oWSPresente as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode45 != NIL
		::oWSPresente := PROD_SimNao():New()
		::oWSPresente:SoapRecv(oNode45)
	EndIf
	oNode46 :=  WSAdvValue( oResponse,"_PERSONALIZACAOEXTRA","SimNao",NIL,"Property oWSPersonalizacaoExtra as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode46 != NIL
		::oWSPersonalizacaoExtra := PROD_SimNao():New()
		::oWSPersonalizacaoExtra:SoapRecv(oNode46)
	EndIf
	::cPersLabel :=  WSAdvValue( oResponse,"_PERSONALIZACAOLABEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIndicationGroupId :=  WSAdvValue( oResponse,"_INDICATIONGROUPID","int",NIL,"Property nIndicationGroupId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cISBN              :=  WSAdvValue( oResponse,"_ISBN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEAN13             :=  WSAdvValue( oResponse,"_EAN13","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cYouTubeCode       :=  WSAdvValue( oResponse,"_YOUTUBECODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure clsProdutoPersonalizacao

WSSTRUCT PROD_clsProdutoPersonalizacao
	WSDATA   nCodigo                   AS int
	WSDATA   oWSStatus                 AS PROD_ProdutoPersonalizacaoStatus
	WSDATA   nLojaCodigo               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_clsProdutoPersonalizacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_clsProdutoPersonalizacao
Return

WSMETHOD CLONE WSCLIENT PROD_clsProdutoPersonalizacao
	Local oClone := PROD_clsProdutoPersonalizacao():NEW()
	oClone:nCodigo              := ::nCodigo
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
	oClone:nLojaCodigo          := ::nLojaCodigo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_clsProdutoPersonalizacao
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_STATUS","ProdutoPersonalizacaoStatus",NIL,"Property oWSStatus as tns:ProdutoPersonalizacaoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSStatus := PROD_ProdutoPersonalizacaoStatus():New()
		::oWSStatus:SoapRecv(oNode2)
	EndIf
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RetornoLote

WSSTRUCT PROD_RetornoLote
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_RetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PROD_RetornoLote
Return

WSMETHOD CLONE WSCLIENT PROD_RetornoLote
	Local oClone := PROD_RetornoLote():NEW()
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_RetornoLote
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration ProdutoStatus

WSSTRUCT PROD_ProdutoStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_ProdutoStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT PROD_ProdutoStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_ProdutoStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT PROD_ProdutoStatus
Local oClone := PROD_ProdutoStatus():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ProdutoTipo

WSSTRUCT PROD_ProdutoTipo
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_ProdutoTipo
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

WSMETHOD SOAPSEND WSCLIENT PROD_ProdutoTipo
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_ProdutoTipo
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT PROD_ProdutoTipo
Local oClone := PROD_ProdutoTipo():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SimNao

WSSTRUCT PROD_SimNao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_SimNao
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Sim" )
	aadd(::aValueList , "N�o" )
Return Self

WSMETHOD SOAPSEND WSCLIENT PROD_SimNao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_SimNao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT PROD_SimNao
Local oClone := PROD_SimNao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ProdutoPersonalizacaoStatus

WSSTRUCT PROD_ProdutoPersonalizacaoStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PROD_ProdutoPersonalizacaoStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT PROD_ProdutoPersonalizacaoStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PROD_ProdutoPersonalizacaoStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT PROD_ProdutoPersonalizacaoStatus
Local oClone := PROD_ProdutoPersonalizacaoStatus():New()
	oClone:Value := ::Value
Return oClone


