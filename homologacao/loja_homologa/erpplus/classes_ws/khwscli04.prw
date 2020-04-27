#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx?wsdl
Gerado em        04/26/19 11:36:42
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _BEJTSTK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSTabelaPrecokH
------------------------------------------------------------------------------- */

WSCLIENT WSTabelaPrecokH

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Salvar
	WSMETHOD Excluir
	WSMETHOD Listar
	WSMETHOD SalvarItem
	WSMETHOD ExcluirItem
	WSMETHOD SalvarItemLote
	WSMETHOD ExcluirItemLote

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nLojaCodigo               AS int
	WSDATA   cCodTabPrc AS string
	WSDATA   cNomeTabelaPreco          AS string
	WSDATA   cDataVigenciaInicial      AS dateTime
	WSDATA   cDataVigenciaFinal        AS dateTime
	WSDATA   nStatusTabelaPreco        AS int
	WSDATA   cA1                       AS string
	WSDATA   cA2                       AS string
	WSDATA   oWS                       AS SCHEMA
	WSDATA   oWSSalvarResult           AS TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   oWSExcluirResult          AS TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   cDataVigenciaIncial       AS dateTime
	WSDATA   oWSListarResult           AS TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   cCodProd     AS string
	WSDATA   cPartNumber               AS string
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   nStatusTabelaPrecoItem    AS int
	WSDATA   oWSSalvarItemResult       AS TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   oWSExcluirItemResult      AS TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   oWSItems                  AS TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	WSDATA   oWSSalvarItemLoteResult   AS TabelaPreco_clsRetornoOfRetornoLote
	WSDATA   oWSExcluirItemLoteResult  AS TabelaPreco_clsRetornoOfRetornoLote

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSTabelaPrecokH
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190212] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSTabelaPrecokH
	::oWS                := NIL 
	::oWSSalvarResult    := TabelaPreco_CLSRETORNOOFCLSTBLPRECO():New()
	::oWSExcluirResult   := TabelaPreco_CLSRETORNOOFCLSTBLPRECO():New()
	::oWSListarResult    := TabelaPreco_CLSRETORNOOFCLSTBLPRECO():New()
	::oWSSalvarItemResult := TabelaPreco_CLSRETORNOOFCLSTBLPRECO():New()
	::oWSExcluirItemResult := TabelaPreco_CLSRETORNOOFCLSTBLPRECO():New()
	::oWSItems           := TabelaPreco_ARRAYOFLOTETABELAPRECOSALVARITEM():New()
	::oWSSalvarItemLoteResult := TabelaPreco_CLSRETORNOOFRETORNOLOTE():New()
	::oWSExcluirItemLoteResult := TabelaPreco_CLSRETORNOOFRETORNOLOTE():New()
Return

WSMETHOD RESET WSCLIENT WSTabelaPrecokH
	::nLojaCodigo        := NIL 
	::cCodTabPrc := NIL 
	::cNomeTabelaPreco   := NIL 
	::cDataVigenciaInicial := NIL 
	::cDataVigenciaFinal := NIL 
	::nStatusTabelaPreco := NIL 
	::cA1                := NIL 
	::cA2                := NIL 
	::oWS                := NIL 
	::oWSSalvarResult    := NIL 
	::oWSExcluirResult   := NIL 
	::cDataVigenciaIncial := NIL 
	::oWSListarResult    := NIL 
	::cCodProd := NIL 
	::cPartNumber        := NIL 
	::nPrecoCheio        := NIL 
	::nPrecoPor          := NIL 
	::nStatusTabelaPrecoItem := NIL 
	::oWSSalvarItemResult := NIL 
	::oWSExcluirItemResult := NIL 
	::oWSItems           := NIL 
	::oWSSalvarItemLoteResult := NIL 
	::oWSExcluirItemLoteResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSTabelaPrecokH
Local oClone := WSTabelaPrecokH():New()
	oClone:_URL          := ::_URL 
	oClone:nLojaCodigo   := ::nLojaCodigo
	oClone:cCodTabPrc := ::cCodTabPrc
	oClone:cNomeTabelaPreco := ::cNomeTabelaPreco
	oClone:cDataVigenciaInicial := ::cDataVigenciaInicial
	oClone:cDataVigenciaFinal := ::cDataVigenciaFinal
	oClone:nStatusTabelaPreco := ::nStatusTabelaPreco
	oClone:cA1           := ::cA1
	oClone:cA2           := ::cA2
	oClone:oWSSalvarResult :=  IIF(::oWSSalvarResult = NIL , NIL ,::oWSSalvarResult:Clone() )
	oClone:oWSExcluirResult :=  IIF(::oWSExcluirResult = NIL , NIL ,::oWSExcluirResult:Clone() )
	oClone:cDataVigenciaIncial := ::cDataVigenciaIncial
	oClone:oWSListarResult :=  IIF(::oWSListarResult = NIL , NIL ,::oWSListarResult:Clone() )
	oClone:cCodProd := ::cCodProd
	oClone:cPartNumber   := ::cPartNumber
	oClone:nPrecoCheio   := ::nPrecoCheio
	oClone:nPrecoPor     := ::nPrecoPor
	oClone:nStatusTabelaPrecoItem := ::nStatusTabelaPrecoItem
	oClone:oWSSalvarItemResult :=  IIF(::oWSSalvarItemResult = NIL , NIL ,::oWSSalvarItemResult:Clone() )
	oClone:oWSExcluirItemResult :=  IIF(::oWSExcluirItemResult = NIL , NIL ,::oWSExcluirItemResult:Clone() )
	oClone:oWSItems      :=  IIF(::oWSItems = NIL , NIL ,::oWSItems:Clone() )
	oClone:oWSSalvarItemLoteResult :=  IIF(::oWSSalvarItemLoteResult = NIL , NIL ,::oWSSalvarItemLoteResult:Clone() )
	oClone:oWSExcluirItemLoteResult :=  IIF(::oWSExcluirItemLoteResult = NIL , NIL ,::oWSExcluirItemLoteResult:Clone() )
Return oClone

// WSDL Method Salvar of Service WSTabelaPrecokH

WSMETHOD Salvar WSSEND nLojaCodigo,cCodTabPrc,cNomeTabelaPreco,cDataVigenciaInicial,cDataVigenciaFinal,nStatusTabelaPreco,cA1,cA2,oWS WSRECEIVE oWSSalvarResult WSCLIENT WSTabelaPrecokH
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
cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NomeTabelaPreco", ::cNomeTabelaPreco, cNomeTabelaPreco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataVigenciaInicial", ::cDataVigenciaInicial, cDataVigenciaInicial , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataVigenciaFinal", ::cDataVigenciaFinal, cDataVigenciaFinal , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusTabelaPreco", ::nStatusTabelaPreco, nStatusTabelaPreco , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Salvar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Salvar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSSalvarResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARRESPONSE:_SALVARRESULT","clsRetornoOfclsTblPreco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Excluir of Service WSTabelaPrecokH

WSMETHOD Excluir WSSEND nLojaCodigo,cCodTabPrc,cA1,cA2,oWS WSRECEIVE oWSExcluirResult WSCLIENT WSTabelaPrecokH
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
cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Excluir>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Excluir",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSExcluirResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRRESPONSE:_EXCLUIRRESULT","clsRetornoOfclsTblPreco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Listar of Service WSTabelaPrecokH

WSMETHOD Listar WSSEND nLojaCodigo,cCodTabPrc,cDataVigenciaIncial,cDataVigenciaFinal,nStatusTabelaPreco,cA1,cA2,oWS WSRECEIVE oWSListarResult WSCLIENT WSTabelaPrecokH
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
cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataVigenciaIncial", ::cDataVigenciaIncial, cDataVigenciaIncial , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataVigenciaFinal", ::cDataVigenciaFinal, cDataVigenciaFinal , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusTabelaPreco", ::nStatusTabelaPreco, nStatusTabelaPreco , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Listar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/Listar",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSListarResult:SoapRecv( WSAdvValue( oXmlRet,"_LISTARRESPONSE:_LISTARRESULT","clsRetornoOfclsTblPreco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarItem of Service WSTabelaPrecokH

WSMETHOD SalvarItem WSSEND nLojaCodigo,cCodTabPrc,cCodProd,cPartNumber,nPrecoCheio,nPrecoPor,nStatusTabelaPrecoItem,cA1,cA2,oWS WSRECEIVE oWSSalvarItemResult WSCLIENT WSTabelaPrecokH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarItem xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("StatusTabelaPrecoItem", ::nStatusTabelaPrecoItem, nStatusTabelaPrecoItem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarItem>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarItem",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSSalvarItemResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARITEMRESPONSE:_SALVARITEMRESULT","clsRetornoOfclsTblPreco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExcluirItem of Service WSTabelaPrecokH

WSMETHOD ExcluirItem WSSEND nLojaCodigo,cCodTabPrc,cCodProd,cPartNumber,cA1,cA2,oWS WSRECEIVE oWSExcluirItemResult WSCLIENT WSTabelaPrecokH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<ExcluirItem xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("PartNumber", ::cPartNumber, cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ExcluirItem>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ExcluirItem",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSExcluirItemResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRITEMRESPONSE:_EXCLUIRITEMRESULT","clsRetornoOfclsTblPreco",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarItemLote of Service WSTabelaPrecokH

WSMETHOD SalvarItemLote WSSEND nLojaCodigo,oWSItems,cA1,cA2,oWS WSRECEIVE oWSSalvarItemLoteResult WSCLIENT WSTabelaPrecokH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<SalvarItemLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Items", ::oWSItems, oWSItems , "ArrayOfLoteTabelaPrecoSalvarItem", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SalvarItemLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/SalvarItemLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSSalvarItemLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_SALVARITEMLOTERESPONSE:_SALVARITEMLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExcluirItemLote of Service WSTabelaPrecokH

WSMETHOD ExcluirItemLote WSSEND nLojaCodigo,oWSItems,cA1,cA2,oWS WSRECEIVE oWSExcluirItemLoteResult WSCLIENT WSTabelaPrecokH
Local cSoap := "" , oXmlRet
Local cSoapHead := "" 

BEGIN WSMETHOD

cSoapHead += '<clsSoapHeader xmlns="http://www.ikeda.com.br">'
cSoapHead += WSSoapValue("A1", ::cA1, cA1 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("A2", ::cA2, cA2 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead += WSSoapValue("", ::oWS, oWS , "SCHEMA", .F. , .F., 0 , NIL, .F.,.F.) 
cSoapHead +=  "</clsSoapHeader>"

cSoap += '<ExcluirItemLote xmlns="http://www.ikeda.com.br">'
cSoap += WSSoapValue("LojaCodigo", ::nLojaCodigo, nLojaCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Items", ::oWSItems, oWSItems , "ArrayOfLoteTabelaPrecoExcluirItem", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ExcluirItemLote>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.ikeda.com.br/ExcluirItemLote",; 
	"DOCUMENT","http://www.ikeda.com.br",cSoapHead,,; 
	"https://komforthouse.ecservice.rakuten.com.br/ikcwebservice/tabelapreco.asmx")

::Init()
::oWSExcluirItemLoteResult:SoapRecv( WSAdvValue( oXmlRet,"_EXCLUIRITEMLOTERESPONSE:_EXCLUIRITEMLOTERESULT","clsRetornoOfRetornoLote",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure clsRetornoOfclsTblPreco

WSSTRUCT TabelaPreco_clsRetornoOfclsTblPreco
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS TabelaPreco_ArrayOfClsTblPreco OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_clsRetornoOfclsTblPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_clsRetornoOfclsTblPreco
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_clsRetornoOfclsTblPreco
	Local oClone := TabelaPreco_clsRetornoOfclsTblPreco():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_clsRetornoOfclsTblPreco
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfClsTblPreco",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := TabelaPreco_ArrayOfClsTblPreco():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfLoteTabelaPrecoSalvarItem

WSSTRUCT TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	WSDATA   oWSLoteTabelaPrecoSalvarItem AS TabelaPreco_LoteTabelaPrecoSalvarItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	::oWSLoteTabelaPrecoSalvarItem := {} // Array Of  TabelaPreco_LOTETABELAPRECOSALVARITEM():New()
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	Local oClone := TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem():NEW()
	oClone:oWSLoteTabelaPrecoSalvarItem := NIL
	If ::oWSLoteTabelaPrecoSalvarItem <> NIL 
		oClone:oWSLoteTabelaPrecoSalvarItem := {}
		aEval( ::oWSLoteTabelaPrecoSalvarItem , { |x| aadd( oClone:oWSLoteTabelaPrecoSalvarItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TabelaPreco_ArrayOfLoteTabelaPrecoSalvarItem
	Local cSoap := ""
	aEval( ::oWSLoteTabelaPrecoSalvarItem , {|x| cSoap := cSoap  +  WSSoapValue("LoteTabelaPrecoSalvarItem", x , x , "LoteTabelaPrecoSalvarItem", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure clsRetornoOfRetornoLote

WSSTRUCT TabelaPreco_clsRetornoOfRetornoLote
	WSDATA   cAcao                     AS string OPTIONAL
	WSDATA   cData                     AS dateTime
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSDATA   oWSLista                  AS TabelaPreco_ArrayOfRetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_clsRetornoOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_clsRetornoOfRetornoLote
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_clsRetornoOfRetornoLote
	Local oClone := TabelaPreco_clsRetornoOfRetornoLote():NEW()
	oClone:cAcao                := ::cAcao
	oClone:cData                := ::cData
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
	oClone:oWSLista             := IIF(::oWSLista = NIL , NIL , ::oWSLista:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_clsRetornoOfRetornoLote
	Local oNode5
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cAcao              :=  WSAdvValue( oResponse,"_ACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData              :=  WSAdvValue( oResponse,"_DATA","dateTime",NIL,"Property cData as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_LISTA","ArrayOfRetornoLote",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSLista := TabelaPreco_ArrayOfRetornoLote():New()
		::oWSLista:SoapRecv(oNode5)
	EndIf
Return

// WSDL Data Structure ArrayOfClsTblPreco

WSSTRUCT TabelaPreco_ArrayOfClsTblPreco
	WSDATA   oWSclsTblPreco            AS TabelaPreco_clsTblPreco OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_ArrayOfClsTblPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_ArrayOfClsTblPreco
	::oWSclsTblPreco       := {} // Array Of  TabelaPreco_CLSTBLPRECO():New()
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_ArrayOfClsTblPreco
	Local oClone := TabelaPreco_ArrayOfClsTblPreco():NEW()
	oClone:oWSclsTblPreco := NIL
	If ::oWSclsTblPreco <> NIL 
		oClone:oWSclsTblPreco := {}
		aEval( ::oWSclsTblPreco , { |x| aadd( oClone:oWSclsTblPreco , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_ArrayOfClsTblPreco
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSTBLPRECO","clsTblPreco",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsTblPreco , TabelaPreco_clsTblPreco():New() )
			::oWSclsTblPreco[len(::oWSclsTblPreco)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure LoteTabelaPrecoSalvarItem

WSSTRUCT TabelaPreco_LoteTabelaPrecoSalvarItem
	WSDATA   cCodTabPrc AS string OPTIONAL
	WSDATA   cCodProd     AS string OPTIONAL
	WSDATA   cPartNumber               AS string OPTIONAL
	WSDATA   nPrecoCheio               AS decimal
	WSDATA   nPrecoPor                 AS decimal
	WSDATA   nStatusTabelaPrecoItem    AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_LoteTabelaPrecoSalvarItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_LoteTabelaPrecoSalvarItem
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_LoteTabelaPrecoSalvarItem
	Local oClone := TabelaPreco_LoteTabelaPrecoSalvarItem():NEW()
	oClone:cCodTabPrc := ::cCodTabPrc
	oClone:cCodProd := ::cCodProd
	oClone:cPartNumber          := ::cPartNumber
	oClone:nPrecoCheio          := ::nPrecoCheio
	oClone:nPrecoPor            := ::nPrecoPor
	oClone:nStatusTabelaPrecoItem := ::nStatusTabelaPrecoItem
Return oClone

WSMETHOD SOAPSEND WSCLIENT TabelaPreco_LoteTabelaPrecoSalvarItem
	Local cSoap := ""
	cSoap += WSSoapValue("CodigoInternoTabelaPreco", ::cCodTabPrc, ::cCodTabPrc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CodigoInternoProduto", ::cCodProd, ::cCodProd , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PartNumber", ::cPartNumber, ::cPartNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoCheio", ::nPrecoCheio, ::nPrecoCheio , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("PrecoPor", ::nPrecoPor, ::nPrecoPor , "decimal", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("StatusTabelaPrecoItem", ::nStatusTabelaPrecoItem, ::nStatusTabelaPrecoItem , "int", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ArrayOfRetornoLote

WSSTRUCT TabelaPreco_ArrayOfRetornoLote
	WSDATA   oWSRetornoLote            AS TabelaPreco_RetornoLote OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_ArrayOfRetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_ArrayOfRetornoLote
	::oWSRetornoLote       := {} // Array Of  TabelaPreco_RETORNOLOTE():New()
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_ArrayOfRetornoLote
	Local oClone := TabelaPreco_ArrayOfRetornoLote():NEW()
	oClone:oWSRetornoLote := NIL
	If ::oWSRetornoLote <> NIL 
		oClone:oWSRetornoLote := {}
		aEval( ::oWSRetornoLote , { |x| aadd( oClone:oWSRetornoLote , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_ArrayOfRetornoLote
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RETORNOLOTE","RetornoLote",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRetornoLote , TabelaPreco_RetornoLote():New() )
			::oWSRetornoLote[len(::oWSRetornoLote)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsTblPreco

WSSTRUCT TabelaPreco_clsTblPreco
	WSDATA   cTabelaPrecoCodigoInterno AS string OPTIONAL
	WSDATA   cNome                     AS string OPTIONAL
	WSDATA   cDataVigenciaInicial      AS string OPTIONAL
	WSDATA   cDataVigenciaFinal        AS string OPTIONAL
	WSDATA   oWSStatus                 AS TabelaPreco_TabelaPrecoStatus
	WSDATA   nLojaCodigo               AS int
	WSDATA   oWSItens                  AS TabelaPreco_ArrayOfClsTblPrecoItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_clsTblPreco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_clsTblPreco
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_clsTblPreco
	Local oClone := TabelaPreco_clsTblPreco():NEW()
	oClone:cTabelaPrecoCodigoInterno := ::cTabelaPrecoCodigoInterno
	oClone:cNome                := ::cNome
	oClone:cDataVigenciaInicial := ::cDataVigenciaInicial
	oClone:cDataVigenciaFinal   := ::cDataVigenciaFinal
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
	oClone:nLojaCodigo          := ::nLojaCodigo
	oClone:oWSItens             := IIF(::oWSItens = NIL , NIL , ::oWSItens:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_clsTblPreco
	Local oNode5
	Local oNode7
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cTabelaPrecoCodigoInterno :=  WSAdvValue( oResponse,"_TABELAPRECOCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataVigenciaInicial :=  WSAdvValue( oResponse,"_DATAVIGENCIAINICIAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataVigenciaFinal :=  WSAdvValue( oResponse,"_DATAVIGENCIAFINAL","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode5 :=  WSAdvValue( oResponse,"_STATUS","TabelaPrecoStatus",NIL,"Property oWSStatus as tns:TabelaPrecoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode5 != NIL
		::oWSStatus := TabelaPreco_TabelaPrecoStatus():New()
		::oWSStatus:SoapRecv(oNode5)
	EndIf
	::nLojaCodigo        :=  WSAdvValue( oResponse,"_LOJACODIGO","int",NIL,"Property nLojaCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	oNode7 :=  WSAdvValue( oResponse,"_ITENS","ArrayOfClsTblPrecoItem",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode7 != NIL
		::oWSItens := TabelaPreco_ArrayOfClsTblPrecoItem():New()
		::oWSItens:SoapRecv(oNode7)
	EndIf
Return

// WSDL Data Structure RetornoLote

WSSTRUCT TabelaPreco_RetornoLote
	WSDATA   cCodigoInterno            AS string OPTIONAL
	WSDATA   nCodigo                   AS int
	WSDATA   cDescricao                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_RetornoLote
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_RetornoLote
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_RetornoLote
	Local oClone := TabelaPreco_RetornoLote():NEW()
	oClone:cCodigoInterno       := ::cCodigoInterno
	oClone:nCodigo              := ::nCodigo
	oClone:cDescricao           := ::cDescricao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_RetornoLote
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCodigoInterno     :=  WSAdvValue( oResponse,"_CODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nCodigo            :=  WSAdvValue( oResponse,"_CODIGO","int",NIL,"Property nCodigo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDescricao         :=  WSAdvValue( oResponse,"_DESCRICAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration TabelaPrecoStatus

WSSTRUCT TabelaPreco_TabelaPrecoStatus
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_TabelaPrecoStatus
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Nenhum" )
	aadd(::aValueList , "Ativo" )
	aadd(::aValueList , "Inativo" )
Return Self

WSMETHOD SOAPSEND WSCLIENT TabelaPreco_TabelaPrecoStatus
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_TabelaPrecoStatus
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT TabelaPreco_TabelaPrecoStatus
Local oClone := TabelaPreco_TabelaPrecoStatus():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure ArrayOfClsTblPrecoItem

WSSTRUCT TabelaPreco_ArrayOfClsTblPrecoItem
	WSDATA   oWSclsTblPrecoItem        AS TabelaPreco_clsTblPrecoItem OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_ArrayOfClsTblPrecoItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_ArrayOfClsTblPrecoItem
	::oWSclsTblPrecoItem   := {} // Array Of  TabelaPreco_CLSTBLPRECOITEM():New()
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_ArrayOfClsTblPrecoItem
	Local oClone := TabelaPreco_ArrayOfClsTblPrecoItem():NEW()
	oClone:oWSclsTblPrecoItem := NIL
	If ::oWSclsTblPrecoItem <> NIL 
		oClone:oWSclsTblPrecoItem := {}
		aEval( ::oWSclsTblPrecoItem , { |x| aadd( oClone:oWSclsTblPrecoItem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_ArrayOfClsTblPrecoItem
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLSTBLPRECOITEM","clsTblPrecoItem",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSclsTblPrecoItem , TabelaPreco_clsTblPrecoItem():New() )
			::oWSclsTblPrecoItem[len(::oWSclsTblPrecoItem)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure clsTblPrecoItem

WSSTRUCT TabelaPreco_clsTblPrecoItem
	WSDATA   cProdutoCodigoInterno     AS string OPTIONAL
	WSDATA   cPartNumber               AS string OPTIONAL
	WSDATA   oWSStatus                 AS TabelaPreco_TabelaPrecoStatus
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TabelaPreco_clsTblPrecoItem
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TabelaPreco_clsTblPrecoItem
Return

WSMETHOD CLONE WSCLIENT TabelaPreco_clsTblPrecoItem
	Local oClone := TabelaPreco_clsTblPrecoItem():NEW()
	oClone:cProdutoCodigoInterno := ::cProdutoCodigoInterno
	oClone:cPartNumber          := ::cPartNumber
	oClone:oWSStatus            := IIF(::oWSStatus = NIL , NIL , ::oWSStatus:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TabelaPreco_clsTblPrecoItem
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cProdutoCodigoInterno :=  WSAdvValue( oResponse,"_PRODUTOCODIGOINTERNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPartNumber        :=  WSAdvValue( oResponse,"_PARTNUMBER","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode3 :=  WSAdvValue( oResponse,"_STATUS","TabelaPrecoStatus",NIL,"Property oWSStatus as tns:TabelaPrecoStatus on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode3 != NIL
		::oWSStatus := TabelaPreco_TabelaPrecoStatus():New()
		::oWSStatus:SoapRecv(oNode3)
	EndIf
Return


