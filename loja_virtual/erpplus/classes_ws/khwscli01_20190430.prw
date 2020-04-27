#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx?wsdl
Gerado em        04/24/19 16:59:44
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WYJMVSJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service ProdutosKH
------------------------------------------------------------------------------- */

WSCLIENT ProdutosKH

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
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodProd     AS string
	WSDATA   cCodForn  AS string
	WSDATA   cNomeProduto              AS string
	WSDATA   cTitProd            AS string
	WSDATA   cSbTitProd         AS string
	WSDATA   cDescProd         AS string
	WSDATA   cCaracProd    AS string
	WSDATA   cTexto1            AS string
	WSDATA   cTexto2            AS string
	WSDATA   cTexto3            AS string
	WSDATA   cTexto4            AS string
	WSDATA   cTexto5            AS string
	WSDATA   cTexto6            AS string
	WSDATA   cTexto7            AS string
	WSDATA   cTexto8            AS string
	WSDATA   cTexto9            AS string
	WSDATA   cTexto10           AS string
	WSDATA   nNumero1           AS decimal
	WSDATA   nNumero2           AS decimal
	WSDATA   nNumero3           AS decimal
	WSDATA   nNumero4           AS decimal
	WSDATA   nNumero5           AS decimal
	WSDATA   nNumero6           AS decimal
	WSDATA   nNumero7           AS decimal
	WSDATA   nNumero8           AS decimal
	WSDATA   nNumero9           AS decimal
	WSDATA   nNumero10          AS decimal
	WSDATA   cCodigoInternoEnquadramento AS string
	WSDATA   cModeloProduto            AS string
	WSDATA   nPesoProduto              AS decimal
	WSDATA   nPesoEmbalagemProduto     AS decimal
	WSDATA   nAlturaProduto            AS decimal
	WSDATA   nAlturaEmbalagemProduto   AS decimal
	WSDATA   nLarguraProduto           AS decimal
	WSDATA   nLarguraEmbalagemProduto  AS decimal
	WSDATA   nProfundidadeProduto      AS decimal
	WSDATA   nProfundidadeEmbalagemProduto AS decimal
	WSDATA   nEntregaProduto           AS int
	WSDATA   nQuantidadeMaximaPorVenda AS int
	WSDATA   nStatusProduto            AS int
	WSDATA   cTipoProduto              AS string
	WSDATA   nPresente                 AS int
	WSDATA   nPrecoCheioProduto        AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   nPersonalizacaoExtra      AS int
	WSDATA   cPersonalizacaoLabel      AS string
	WSDATA   cISBN                     AS string
	WSDATA   cEAN13                    AS string
	WSDATA   cYouTubeCode              AS string
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS Produto_clsRetornoProduto
	WSDATA   nCNPJCodigo               AS int
	WSDATA   oWSSaveResult             AS Produto_clsRetornoProduto
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   oWSAlterarPrecoResult     AS Produto_clsRetornoProduto
	WSDATA   oWSAlterarStatusResult    AS Produto_clsRetornoProduto
	WSDATA   oWSExcluirResult          AS Produto_clsRetornoProduto
	WSDATA   cCodigoInternoFabricante  AS string
	WSDATA   nProdutoStatus            AS int
	WSDATA   oWSListarResult           AS Produto_clsRetornoProduto
	WSDATA   nstoreCode                AS int
	WSDATA   cinternalCode             AS string
	WSDATA   cmanufacturerInternalCode AS string
	WSDATA   cname                     AS string
	WSDATA   nstatus                   AS int
	WSDATA   ntype                     AS int
	WSDATA   nitensPerPage             AS int
	WSDATA   npage                     AS int
	WSDATA   oWSListResult             AS Produto_PagedResultOfProductModel
	WSDATA   cCodProdPrincipal AS string
	WSDATA   cCodProdPersonalizacao AS string
	WSDATA   nStatusPersonlizacao      AS int
	WSDATA   oWSSalvarPersonalizacaoResult AS Produto_clsRetornoProdutoPersonalizacao
	WSDATA   oProdutosKHs               AS Produto_ArrayOfLoteProdutoAlterarPreco
	WSDATA   oWSAlterarPrecoLoteResult AS Produto_clsRetornoOfRetornoLote

ENDWSCLIENT

WSMETHOD NEW WSCLIENT ProdutosKH
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT ProdutosKH
	::oWS                := NIL 
	::oWSSalvarResult    := Produto_clsRetornoProduto():New()
	::oWSSaveResult      := Produto_clsRetornoProduto():New()
	::oWSAlterarPrecoResult := Produto_clsRetornoProduto():New()
	::oWSAlterarStatusResult := Produto_clsRetornoProduto():New()
	::oWSExcluirResult   := Produto_clsRetornoProduto():New()
	::oWSListarResult    := Produto_clsRetornoProduto():New()
	::oWSListResult      := Produto_PAGEDRESULTOFPRODUCTMODEL():New()
	::oWSSalvarPersonalizacaoResult := Produto_clsRetornoProdutoPERSONALIZACAO():New()
	::oProdutosKHs        := Produto_ARRAYOFLOTEPRODUTOALTERARPRECO():New()
	::oWSAlterarPrecoLoteResult := Produto_CLSRETORNOOFRETORNOLOTE():New()
Return

WSMETHOD RESET WSCLIENT ProdutosKH
	::nLojaCodigo        := NIL 
	::cCodProd := NIL 
	::cCodForn := NIL 
	::cNomeProduto       := NIL 
	::cTitProd     := NIL 
	::cSbTitProd  := NIL 
	::cDescProd  := NIL 
	::cCaracProd := NIL 
	::cTexto1     := NIL 
	::cTexto2     := NIL 
	::cTexto3     := NIL 
	::cTexto4     := NIL 
	::cTexto5     := NIL 
	::cTexto6     := NIL 
	::cTexto7     := NIL 
	::cTexto8     := NIL 
	::cTexto9     := NIL 
	::cTexto10    := NIL 
	::nNumero1    := NIL 
	::nNumero2    := NIL 
	::nNumero3    := NIL 
	::nNumero4    := NIL 
	::nNumero5    := NIL 
	::nNumero6    := NIL 
	::nNumero7    := NIL 
	::nNumero8    := NIL 
	::nNumero9    := NIL 
	::nNumero10   := NIL 
	::cCodigoInternoEnquadramento := NIL 
	::cModeloProduto     := NIL 
	::nPesoProduto       := NIL 
	::nPesoEmbalagemProduto := NIL 
	::nAlturaProduto     := NIL 
	::nAlturaEmbalagemProduto := NIL 
	::nLarguraProduto    := NIL 
	::nLarguraEmbalagemProduto := NIL 
	::nProfundidadeProduto := NIL 
	::nProfundidadeEmbalagemProduto := NIL 
	::nEntregaProduto    := NIL 
	::nQuantidadeMaximaPorVenda := NIL 
	::nStatusProduto     := NIL 
	::cTipoProduto       := NIL 
	::nPresente          := NIL 
	::nPrecoCheioProduto := NIL 
	::nPrecoPor          := NIL 
	::nPersonalizacaoExtra := NIL 
	::cPersonalizacaoLabel := NIL 
	::cISBN              := NIL 
	::cEAN13             := NIL 
	::cYouTubeCode       := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
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
	::cCodProdPrincipal := NIL 
	::cCodProdPersonalizacao := NIL 
	::nStatusPersonlizacao := NIL 
	::oWSSalvarPersonalizacaoResult := NIL 
	::oProdutosKHs        := NIL 
	::oWSAlterarPrecoLoteResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT ProdutosKH
Local oClone := ProdutosKH():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodProd := ::cCodProd
	oClone:cCodForn := ::cCodForn
	oClone:cNomeProduto  := ::cNomeProduto
	oClone:cTitProd := ::cTitProd
	oClone:cSbTitProd := ::cSbTitProd
	oClone:cDescProd := ::cDescProd
	oClone:cCaracProd := ::cCaracProd
	oClone:cTexto1 := ::cTexto1
	oClone:cTexto2 := ::cTexto2
	oClone:cTexto3 := ::cTexto3
	oClone:cTexto4 := ::cTexto4
	oClone:cTexto5 := ::cTexto5
	oClone:cTexto6 := ::cTexto6
	oClone:cTexto7 := ::cTexto7
	oClone:cTexto8 := ::cTexto8
	oClone:cTexto9 := ::cTexto9
	oClone:cTexto10 := ::cTexto10
	oClone:nNumero1 := ::nNumero1
	oClone:nNumero2 := ::nNumero2
	oClone:nNumero3 := ::nNumero3
	oClone:nNumero4 := ::nNumero4
	oClone:nNumero5 := ::nNumero5
	oClone:nNumero6 := ::nNumero6
	oClone:nNumero7 := ::nNumero7
	oClone:nNumero8 := ::nNumero8
	oClone:nNumero9 := ::nNumero9
	oClone:nNumero10 := ::nNumero10
	oClone:cCodigoInternoEnquadramento := ::cCodigoInternoEnquadramento
	oClone:cModeloProduto := ::cModeloProduto
	oClone:nPesoProduto  := ::nPesoProduto
	oClone:nPesoEmbalagemProduto := ::nPesoEmbalagemProduto
	oClone:nAlturaProduto := ::nAlturaProduto
	oClone:nAlturaEmbalagemProduto := ::nAlturaEmbalagemProduto
	oClone:nLarguraProduto := ::nLarguraProduto
	oClone:nLarguraEmbalagemProduto := ::nLarguraEmbalagemProduto
	oClone:nProfundidadeProduto := ::nProfundidadeProduto
	oClone:nProfundidadeEmbalagemProduto := ::nProfundidadeEmbalagemProduto
	oClone:nEntregaProduto := ::nEntregaProduto
	oClone:nQuantidadeMaximaPorVenda := ::nQuantidadeMaximaPorVenda
	oClone:nStatusProduto := ::nStatusProduto
	oClone:cTipoProduto  := ::cTipoProduto
	oClone:nPresente     := ::nPresente
	oClone:nPrecoCheioProduto := ::nPrecoCheioProduto
	oClone:nPrecoPor     := ::nPrecoPor
	oClone:nPersonalizacaoExtra := ::nPersonalizacaoExtra
	oClone:cPersonalizacaoLabel := ::cPersonalizacaoLabel
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
	oClone:cCodProdPrincipal := ::cCodProdPrincipal
	oClone:cCodProdPersonalizacao := ::cCodProdPersonalizacao
	oClone:nStatusPersonlizacao := ::nStatusPersonlizacao
	oClone:oWSSalvarPersonalizacaoResult :=  IIF(::oWSSalvarPersonalizacaoResult = NIL , NIL ,::oWSSalvarPersonalizacaoResult:Clone() )
	oClone:oProdutosKHs   :=  IIF(::oProdutosKHs = NIL , NIL ,::oProdutosKHs:Clone() )
	oClone:oWSAlterarPrecoLoteResult :=  IIF(::oWSAlterarPrecoLoteResult = NIL , NIL ,::oWSAlterarPrecoLoteResult:Clone() )
Return oClone

// WSDL Method Salvar of Service ProdutosKH

WSMETHOD Salvar WSSEND nLojaCodigo,cCodProd,cCodForn,cNomeProduto,cTitProd,cSbTitProd,cDescProd,cCaracProd,cTexto1,cTexto2,cTexto3,cTexto4,cTexto5,cTexto6,cTexto7,cTexto8,cTexto9,cTexto10,nNumero1,nNumero2,nNumero3,nNumero4,nNumero5,nNumero6,nNumero7,nNumero8,nNumero9,nNumero10,cCodigoInternoEnquadramento,cModeloProduto,nPesoProduto,nPesoEmbalagemProduto,nAlturaProduto,nAlturaEmbalagemProduto,nLarguraProduto,nLarguraEmbalagemProduto,nProfundidadeProduto,nProfundidadeEmbalagemProduto,nEntregaProduto,nQuantidadeMaximaPorVenda,nStatusProduto,cTipoProduto,nPresente,nPrecoCheioProduto,nPrecoPor,nPersonalizacaoExtra,cPersonalizacaoLabel,cISBN,cEAN13,cYouTubeCode,cA1,cA2,oWS WSRECEIVE oWSSalvarResult WSCLIENT ProdutosKH
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
cSoap += WSSoapValue("CodigoInternoFornecedor", ::cCodForn, cCodForn , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TituloProduto", ::cTitProd, cTitProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("SubTituloProduto", ::cSbTitProd, cSbTitProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DescricaoProduto", ::cDescProd, cDescProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CaracteristicaProduto", ::cCaracProd, cCaracProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1Produto", ::cTexto1, cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2Produto", ::cTexto2, cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3Produto", ::cTexto3, cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto4Produto", ::cTexto4, cTexto4 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto5Produto", ::cTexto5, cTexto5 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto6Produto", ::cTexto6, cTexto6 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto7Produto", ::cTexto7, cTexto7 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto8Produto", ::cTexto8, cTexto8 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto9Produto", ::cTexto9, cTexto9 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto10Produto", ::cTexto10, cTexto10 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1Produto", ::nNumero1, nNumero1 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2Produto", ::nNumero2, nNumero2 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3Produto", ::nNumero3, nNumero3 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero4Produto", ::nNumero4, nNumero4 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero5Produto", ::nNumero5, nNumero5 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero6Produto", ::nNumero6, nNumero6 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero7Produto", ::nNumero7, nNumero7 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero8Produto", ::nNumero8, nNumero8 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero9Produto", ::nNumero9, nNumero9 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero10Produto", ::nNumero10, nNumero10 , "decimal", .T. , .F., 0 , NIL, .F.,.F.)  
cSoap += WSSoapValue("CodigoInternoEnquadramento", ::cCodigoInternoEnquadramento, cCodigoInternoEnquadramento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ModeloProduto", ::cModeloProduto, cModeloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoProduto", ::nPesoProduto, nPesoProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoEmbalagemProduto", ::nPesoEmbalagemProduto, nPesoEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaProduto", ::nAlturaProduto, nAlturaProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaEmbalagemProduto", ::nAlturaEmbalagemProduto, nAlturaEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraProduto", ::nLarguraProduto, nLarguraProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraEmbalagemProduto", ::nLarguraEmbalagemProduto, nLarguraEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeProduto", ::nProfundidadeProduto, nProfundidadeProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeEmbalagemProduto", ::nProfundidadeEmbalagemProduto, nProfundidadeEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EntregaProduto", ::nEntregaProduto, nEntregaProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QuantidadeMaximaPorVenda", ::nQuantidadeMaximaPorVenda, nQuantidadeMaximaPorVenda , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatusProduto, nStatusProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::cTipoProduto, cTipoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Presente", ::nPresente, nPresente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheioProduto", ::nPrecoCheioProduto, nPrecoCheioProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoExtra", ::nPersonalizacaoExtra, nPersonalizacaoExtra , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoLabel", ::cPersonalizacaoLabel, cPersonalizacaoLabel , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ISBN", ::cISBN, cISBN , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EAN13", ::cEAN13, cEAN13 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("YouTubeCode", ::cYouTubeCode, cYouTubeCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Save of Service ProdutosKH

WSMETHOD Save WSSEND nLojaCodigo,cCodProd,cCodForn,cNomeProduto,cTitProd,cSbTitProd,cDescProd,cCaracProd,cTexto1,cTexto2,cTexto3,cTexto4,cTexto5,cTexto6,cTexto7,cTexto8,cTexto9,cTexto10,nNumero1,nNumero2,nNumero3,nNumero4,nNumero5,nNumero6,nNumero7,nNumero8,nNumero9,nNumero10,cCodigoInternoEnquadramento,cModeloProduto,nPesoProduto,nPesoEmbalagemProduto,nAlturaProduto,nAlturaEmbalagemProduto,nLarguraProduto,nLarguraEmbalagemProduto,nProfundidadeProduto,nProfundidadeEmbalagemProduto,nEntregaProduto,nQuantidadeMaximaPorVenda,nStatusProduto,cTipoProduto,nPresente,nPrecoCheioProduto,nPrecoPor,nPersonalizacaoExtra,cPersonalizacaoLabel,cISBN,cEAN13,cYouTubeCode,nCNPJCodigo,cA1,cA2,oWS WSRECEIVE oWSSaveResult WSCLIENT ProdutosKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<Save xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoFornecedor", ::cCodForn, cCodForn , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TituloProduto", ::cTitProd, cTitProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("SubTituloProduto", ::cSbTitProd, cSbTitProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DescricaoProduto", ::cDescProd, cDescProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CaracteristicaProduto", ::cCaracProd, cCaracProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto1Produto", ::cTexto1, cTexto1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto2Produto", ::cTexto2, cTexto2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto3Produto", ::cTexto3, cTexto3 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto4Produto", ::cTexto4, cTexto4 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto5Produto", ::cTexto5, cTexto5 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto6Produto", ::cTexto6, cTexto6 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto7Produto", ::cTexto7, cTexto7 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto8Produto", ::cTexto8, cTexto8 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto9Produto", ::cTexto9, cTexto9 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Texto10Produto", ::cTexto10, cTexto10 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero1Produto", ::nNumero1, nNumero1 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero2Produto", ::nNumero2, nNumero2 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero3Produto", ::nNumero3, nNumero3 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero4Produto", ::nNumero4, nNumero4 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero5Produto", ::nNumero5, nNumero5 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero6Produto", ::nNumero6, nNumero6 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero7Produto", ::nNumero7, nNumero7 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero8Produto", ::nNumero8, nNumero8 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero9Produto", ::nNumero9, nNumero9 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Numero10Produto", ::nNumero10, nNumero10 , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoEnquadramento", ::cCodigoInternoEnquadramento, cCodigoInternoEnquadramento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ModeloProduto", ::cModeloProduto, cModeloProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoProduto", ::nPesoProduto, nPesoProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PesoEmbalagemProduto", ::nPesoEmbalagemProduto, nPesoEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaProduto", ::nAlturaProduto, nAlturaProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("AlturaEmbalagemProduto", ::nAlturaEmbalagemProduto, nAlturaEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraProduto", ::nLarguraProduto, nLarguraProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("LarguraEmbalagemProduto", ::nLarguraEmbalagemProduto, nLarguraEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeProduto", ::nProfundidadeProduto, nProfundidadeProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProfundidadeEmbalagemProduto", ::nProfundidadeEmbalagemProduto, nProfundidadeEmbalagemProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EntregaProduto", ::nEntregaProduto, nEntregaProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("QuantidadeMaximaPorVenda", ::nQuantidadeMaximaPorVenda, nQuantidadeMaximaPorVenda , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatusProduto, nStatusProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::cTipoProduto, cTipoProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Presente", ::nPresente, nPresente , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheioProduto", ::nPrecoCheioProduto, nPrecoCheioProduto , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoExtra", ::nPersonalizacaoExtra, nPersonalizacaoExtra , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PersonalizacaoLabel", ::cPersonalizacaoLabel, cPersonalizacaoLabel , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ISBN", ::cISBN, cISBN , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("EAN13", ::cEAN13, cEAN13 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("YouTubeCode", ::cYouTubeCode, cYouTubeCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJCodigo", ::nCNPJCodigo, nCNPJCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Save>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Save",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSSaveResult:SoapRecv( WSAdvValue( oXmlRet,"_SAVERESPONSE:_SAVERESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPreco of Service ProdutosKH

WSMETHOD AlterarPreco WSSEND nLojaCodigo,cCodProd,nPrecoCheio,nPrecoPor,cA1,cA2,oWS WSRECEIVE oWSAlterarPrecoResult WSCLIENT ProdutosKH
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
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPreco>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPreco",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarPrecoResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECORESPONSE:_ALTERARPRECORESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarStatus of Service ProdutosKH

WSMETHOD AlterarStatus WSSEND nLojaCodigo,cCodProd,nStatusProduto,cA1,cA2,oWS WSRECEIVE oWSAlterarStatusResult WSCLIENT ProdutosKH
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
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusProduto", ::nStatusProduto, nStatusProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarStatus>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarStatus",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarStatusResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARSTATUSRESPONSE:_ALTERARSTATUSRESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Excluir of Service ProdutosKH

WSMETHOD Excluir WSSEND nLojaCodigo,cCodProd,cA1,cA2,oWS WSRECEIVE oWSExcluirResult WSCLIENT ProdutosKH
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
cSoap += "</Excluir>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Excluir",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSExcluirResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRRESPONSE:_EXCLUIRRESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service ProdutosKH

WSMETHOD Listar WSSEND nLojaCodigo,cCodProd,cCodigoInternoFabricante,cNomeProduto,nProdutoStatus,nTipoProduto,cA1,cA2,oWS WSRECEIVE oWSListarResult WSCLIENT ProdutosKH
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
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoFabricante", ::cCodigoInternoFabricante, cCodigoInternoFabricante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeProduto", ::cNomeProduto, cNomeProduto , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ProdutoStatus", ::nProdutoStatus, nProdutoStatus , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("TipoProduto", ::nTipoProduto, nTipoProduto , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","clsRetornoOfclsProduto",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method List of Service ProdutosKH

WSMETHOD List WSSEND nstoreCode,cinternalCode,cmanufacturerInternalCode,cname,nstatus,ntype,nitensPerPage,npage,cA1,cA2,oWS WSRECEIVE oWSListResult WSCLIENT ProdutosKH
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
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSListResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTRESPONSE:_LISTRESULT","PagedResultOfProductModel",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarPersonalizacao of Service ProdutosKH

WSMETHOD SalvarPersonalizacao WSSEND nLojaCodigo,cCodProdPrincipal,cCodProdPersonalizacao,nStatusPersonlizacao,cA1,cA2,oWS WSRECEIVE oWSSalvarPersonalizacaoResult WSCLIENT ProdutosKH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarPersonalizacao xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProdutoPrincipal", ::cCodProdPrincipal, cCodProdPrincipal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProdutoPersonalizacao", ::cCodProdPersonalizacao, cCodProdPersonalizacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusPersonlizacao", ::nStatusPersonlizacao, nStatusPersonlizacao , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarPersonalizacao>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarPersonalizacao",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSSalvarPersonalizacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARPERSONALIZACAORESPONSE:_SALVARPERSONALIZACAORESULT","clsRetornoOfclsProdutoPersonalizacao",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AlterarPrecoLote of Service ProdutosKH

WSMETHOD AlterarPrecoLote WSSEND nLojaCodigo,oProdutosKHs,cA1,cA2,oWS WSRECEIVE oWSAlterarPrecoLoteResult WSCLIENT ProdutosKH
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
cSoap += WSSoapValue("Produtos", ::oProdutosKHs, oProdutosKHs , "ArrayOfLoteProdutoAlterarPreco", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AlterarPrecoLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/AlterarPrecoLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/produto.asmx")

::Init()
::oWSAlterarPrecoLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_ALTERARPRECOLOTERESPONSE:_ALTERARPRECOLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsProduto

WSSTRUCT Produto_clsRetornoProduto
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Produto_ARRAYOFPRODKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_clsRetornoProduto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_clsRetornoProduto
Return

WSMETHOD CLONE WSCLIENT Produto_clsRetornoProduto
	Local oClone := Produto_clsRetornoProduto():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_clsRetornoProduto
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ARRAYOFPRODKH",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Produto_ARRAYOFPRODKH():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure PagedResultOfProductModel

WSSTRUCT Produto_PagedResultOfProductModel
	WSDATA   nTotalItens               AS int
	WSDATA   nTotalPages               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_PagedResultOfProductModel
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_PagedResultOfProductModel
Return

WSMETHOD CLONE WSCLIENT Produto_PagedResultOfProductModel
	Local oClone := Produto_PagedResultOfProductModel():NEW()
	oClone:nTotalItens          := ::nTotalItens
	oClone:nTotalPages          := ::nTotalPages
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_PagedResultOfProductModel
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nTotalItens        :=  WSAdvValue( oResponse,"_TOTALITENS","int",NIL,"Property nTotalItens as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTotalPages        :=  WSAdvValue( oResponse,"_TOTALPAGES","int",NIL,"Property nTotalPages as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure clsRetornoOfclsProdutoPersonalizacao

WSSTRUCT Produto_clsRetornoProdutoPersonalizacao
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Produto_ARRAYOFPRODKHPersonalizacao OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_clsRetornoProdutoPersonalizacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_clsRetornoProdutoPersonalizacao
Return

WSMETHOD CLONE WSCLIENT Produto_clsRetornoProdutoPersonalizacao
	Local oClone := Produto_clsRetornoProdutoPersonalizacao():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_clsRetornoProdutoPersonalizacao
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ARRAYOFPRODKHPersonalizacao",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Produto_ARRAYOFPRODKHPersonalizacao():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLoteProdutoAlterarPreco

WSSTRUCT Produto_ArrayOfLoteProdutoAlterarPreco
	WSDATA   oWSLoteProdutoAlterarPreco AS Produto_LoteProdutoAlterarPreco OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfLoteProdutoAlterarPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfLoteProdutoAlterarPreco
	::oWSLoteProdutoAlterarPreco := {} // Array Of  Produto_LOTEPRODUTOALTERARPRECO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfLoteProdutoAlterarPreco
	Local oClone := Produto_ArrayOfLoteProdutoAlterarPreco():NEW()
	oClone:oWSLoteProdutoAlterarPreco := NIL
	If ::oWSLoteProdutoAlterarPreco <> NIL 
		oClone:oWSLoteProdutoAlterarPreco := {}
		aEval( ::oWSLoteProdutoAlterarPreco , { |x| aadd( oClone:oWSLoteProdutoAlterarPreco , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_ArrayOfLoteProdutoAlterarPreco
	Local cSoap := ""
	aEval( ::oWSLoteProdutoAlterarPreco , {|x| cSoap := cSoap  +  WSSoapValue("LoteProdutoAlterarPreco", x , x , "LoteProdutoAlterarPreco", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLote

WSSTRUCT Produto_clsRetornoOfRetornoLote
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS Produto_ArrayOfRetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_clsRetornoOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_clsRetornoOfRetornoLote
Return

WSMETHOD CLONE WSCLIENT Produto_clsRetornoOfRetornoLote
	Local oClone := Produto_clsRetornoOfRetornoLote():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_clsRetornoOfRetornoLote
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLote",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := Produto_ArrayOfRetornoLote():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ARRAYOFPRODKH

WSSTRUCT Produto_ARRAYOFPRODKH
	WSDATA   oWSclsProduto             AS PRODUTO_CLSPRODUTOKH OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ARRAYOFPRODKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ARRAYOFPRODKH
	::oWSclsProduto        := {} // Array Of  PRODUTO_CLSPRODUTOKH():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ARRAYOFPRODKH
	Local oClone := Produto_ARRAYOFPRODKH():NEW()
	oClone:oWSclsProduto := NIL
	If ::oWSclsProduto <> NIL 
		oClone:oWSclsProduto := {}
		aEval( ::oWSclsProduto , { |x| aadd( oClone:oWSclsProduto , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ARRAYOFPRODKH
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTO","clsProduto",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProduto , PRODUTO_CLSPRODUTOKH():New() )
			::oWSclsProduto[len(::oWSclsProduto)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFPRODKHPersonalizacao

WSSTRUCT Produto_ARRAYOFPRODKHPersonalizacao
	WSDATA   oWSclsProdutoPersonalizacao AS PRODUTO_PERSONALIZACAO OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ARRAYOFPRODKHPersonalizacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ARRAYOFPRODKHPersonalizacao
	::oWSclsProdutoPersonalizacao := {} // Array Of  PRODUTO_PERSONALIZACAO():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ARRAYOFPRODKHPersonalizacao
	Local oClone := Produto_ARRAYOFPRODKHPersonalizacao():NEW()
	oClone:oWSclsProdutoPersonalizacao := NIL
	If ::oWSclsProdutoPersonalizacao <> NIL 
		oClone:oWSclsProdutoPersonalizacao := {}
		aEval( ::oWSclsProdutoPersonalizacao , { |x| aadd( oClone:oWSclsProdutoPersonalizacao , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ARRAYOFPRODKHPersonalizacao
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSPRODUTOPERSONALIZACAO","clsProdutoPersonalizacao",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsProdutoPersonalizacao , PRODUTO_PERSONALIZACAO():New() )
			::oWSclsProdutoPersonalizacao[len(::oWSclsProdutoPersonalizacao)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LoteProdutoAlterarPreco

WSSTRUCT Produto_LoteProdutoAlterarPreco
	WSDATA   cCodProd     AS string OPTIONAL
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_LoteProdutoAlterarPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_LoteProdutoAlterarPreco
Return

WSMETHOD CLONE WSCLIENT Produto_LoteProdutoAlterarPreco
	Local oClone := Produto_LoteProdutoAlterarPreco():NEW()
	oClone:cCodProd := ::cCodProd
	oClone:nPrecoCheio          := ::nPrecoCheio
	oClone:nPrecoPor            := ::nPrecoPor
Return oClone

WSMETHOD SOAPSEND WSCLIENT Produto_LoteProdutoAlterarPreco
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, ::cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, ::nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, ::nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLote

WSSTRUCT Produto_ArrayOfRetornoLote
	WSDATA   oWSRetornoLote            AS Produto_RetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_ArrayOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_ArrayOfRetornoLote
	::oWSRetornoLote       := {} // Array Of  Produto_RETORNOLOTE():New()
Return

WSMETHOD CLONE WSCLIENT Produto_ArrayOfRetornoLote
	Local oClone := Produto_ArrayOfRetornoLote():NEW()
	oClone:oWSRetornoLote := NIL
	If ::oWSRetornoLote <> NIL 
		oClone:oWSRetornoLote := {}
		aEval( ::oWSRetornoLote , { |x| aadd( oClone:oWSRetornoLote , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_ArrayOfRetornoLote
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTE","RetornoLote",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLote , Produto_RetornoLote():New() )
			::oWSRetornoLote[len(::oWSRetornoLote)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsProduto

WSSTRUCT PRODUTO_CLSPRODUTOKH
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
	WSDATA   nQuantidadeMaximaPorVenda AS int
	WSDATA   oProdutosKHStatus          AS Produto_StatusKh
	WSDATA   oWSTipo                   AS Produto_TipoKh
	WSDATA   oWSPresente               AS Produto_SimNaoKh
	WSDATA   oWSPersonalizacaoExtra    AS Produto_SimNaoKh
	WSDATA   cPersonalizacaoLabel      AS string OPTIONAL
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

WSMETHOD NEW WSCLIENT PRODUTO_CLSPRODUTOKH
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRODUTO_CLSPRODUTOKH
Return

WSMETHOD CLONE WSCLIENT PRODUTO_CLSPRODUTOKH
	Local oClone := PRODUTO_CLSPRODUTOKH():NEW()
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
	oClone:nQuantidadeMaximaPorVenda := ::nQuantidadeMaximaPorVenda
	oClone:oProdutosKHStatus     := IIF(::oProdutosKHStatus = NIL , NIL , ::oProdutosKHStatus:Clone() )
	oClone:oWSTipo              := IIF(::oWSTipo = NIL , NIL , ::oWSTipo:Clone() )
	oClone:oWSPresente          := IIF(::oWSPresente = NIL , NIL , ::oWSPresente:Clone() )
	oClone:oWSPersonalizacaoExtra := IIF(::oWSPersonalizacaoExtra = NIL , NIL , ::oWSPersonalizacaoExtra:Clone() )
	oClone:cPersonalizacaoLabel := ::cPersonalizacaoLabel
	oClone:nCompanyId           := ::nCompanyId
	oClone:nIndicationGroupId   := ::nIndicationGroupId
	oClone:cISBN                := ::cISBN
	oClone:cEAN13               := ::cEAN13
	oClone:cYouTubeCode         := ::cYouTubeCode
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRODUTO_CLSPRODUTOKH
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
	::nQuantidadeMaximaPorVenda :=  WSAdvValue( oResponse,"_QUANTIDADEMAXIMAPORVENDA","int",NIL,"Property nQuantidadeMaximaPorVenda as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode43 :=  WSAdvValue( oResponse,"_PRODUTOSTATUS","ProdutoStatus",NIL,"Property oProdutosKHStatus as tns:ProdutoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode43 != NIL
		::oProdutosKHStatus := Produto_StatusKh():New()
		::oProdutosKHStatus:SoapRecv(oNode43)
	EndIf
	oNode44 :=  WSAdvValue( oResponse,"_TIPO","ProdutoTipo",NIL,"Property oWSTipo as tns:ProdutoTipo on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode44 != NIL
		::oWSTipo := Produto_TipoKh():New()
		::oWSTipo:SoapRecv(oNode44)
	EndIf
	oNode45 :=  WSAdvValue( oResponse,"_PRESENTE","SimNao",NIL,"Property oWSPresente as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode45 != NIL
		::oWSPresente := Produto_SimNaoKh():New()
		::oWSPresente:SoapRecv(oNode45)
	EndIf
	oNode46 :=  WSAdvValue( oResponse,"_PERSONALIZACAOEXTRA","SimNao",NIL,"Property oWSPersonalizacaoExtra as tns:SimNao on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode46 != NIL
		::oWSPersonalizacaoExtra := Produto_SimNaoKh():New()
		::oWSPersonalizacaoExtra:SoapRecv(oNode46)
	EndIf
	::cPersonalizacaoLabel :=  WSAdvValue( oResponse,"_PERSONALIZACAOLABEL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","int",NIL,NIL,NIL,"N",NIL,NIL) 
	::nIndicationGroupId :=  WSAdvValue( oResponse,"_INDICATIONGROUPID","int",NIL,"Property nIndicationGroupId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cISBN              :=  WSAdvValue( oResponse,"_ISBN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cEAN13             :=  WSAdvValue( oResponse,"_EAN13","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cYouTubeCode       :=  WSAdvValue( oResponse,"_YOUTUBECODE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure clsProdutoPersonalizacao

WSSTRUCT PRODUTO_PERSONALIZACAO
	WSDATA   nCodigo                   AS int
	WSDATA   oWSStatus                 AS Produto_KHPersonalizacaoStatus
	WSDATA   nLojaCodigo               AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRODUTO_PERSONALIZACAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRODUTO_PERSONALIZACAO
Return

WSMETHOD CLONE WSCLIENT PRODUTO_PERSONALIZACAO
	Local oClone := PRODUTO_PERSONALIZACAO():NEW()
	oClone:nCodigo              := ::nCodigo
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
	oClone:nLojaCodigo          := ::nLojaCodigo
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRODUTO_PERSONALIZACAO
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_STATUS","ProdutoPersonalizacaoStatus",NIL,"Property oWSStatus as tns:ProdutoPersonalizacaoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWSStatus := Produto_KHPersonalizacaoStatus():New()
		::oWSStatus:SoapRecv(oNode2)
	EndIf
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RetornoLote

WSSTRUCT Produto_RetornoLote
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_RetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Produto_RetornoLote
Return

WSMETHOD CLONE WSCLIENT Produto_RetornoLote
	Local oClone := Produto_RetornoLote():NEW()
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_RetornoLote
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration ProdutoStatus

WSSTRUCT Produto_StatusKh
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_StatusKh
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Produto_StatusKh
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_StatusKh
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Produto_StatusKh
Local oClone := Produto_StatusKh():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ProdutoTipo

WSSTRUCT Produto_TipoKh
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_TipoKh
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

WSMETHOD SOAPSEND WSCLIENT Produto_TipoKh
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_TipoKh
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Produto_TipoKh
Local oClone := Produto_TipoKh():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration SimNao

WSSTRUCT Produto_SimNaoKh
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_SimNaoKh
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Sim" )
	aadd(::aValueList , "Não" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Produto_SimNaoKh
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_SimNaoKh
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Produto_SimNaoKh
Local oClone := Produto_SimNaoKh():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration ProdutoPersonalizacaoStatus

WSSTRUCT Produto_KHPersonalizacaoStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Produto_KHPersonalizacaoStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT Produto_KHPersonalizacaoStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Produto_KHPersonalizacaoStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT Produto_KHPersonalizacaoStatus
Local oClone := Produto_KHPersonalizacaoStatus():New()
	oClone:Value := ::Value
Return oClone


