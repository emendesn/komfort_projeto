#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ SYXMLA03 ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Valida a Chave da DANFE no site da SEFAZ e faz os tratamen ∫±±
±±∫          ≥ tos do arquivo PDF gerado.                                 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GESTAO DE XML                                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±≥ Programador ≥ Data   ≥ Chamado ≥ Motivo da Alteracao                  ≥±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ¥±±
±±≥Caio Garcia  ≥28/02/18≥         ≥Ajuste para considerar tag xped       ≥±±
±±≥#CMG20180228 ≥        ≥         ≥                                      ≥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
USER FUNCTION SYXMLA03(cNum, cSerie, cCNPJ)

Local oTlChave
Local oBtnAtz, oBtnRjt

Private aSize 		:= MsAdvSize()
Private aHeaderGrd  := {}
Private aColsGrd    := {}
Private aVisuPed    := {}
Private aClone      := {}
Private aDados      := {}
Private aProdutos   := {}
Private aDesconto   := { 0 , ""}
Private nDesconto   := 0
Private aValores    := {}
Private _nQuant		:= 0
Private _nCustoReal	:= 0
Private nCont		:= 0  
Private lControl    := .F.
Private _aXPed      := {}
Private _cXPed      := {}
Private _cXPedIt      := {}
Private _lMarc      := .F.

DbSelectArea("Z31")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("Z31") + cNum + cSerie + cCNPJ)

IF Z31->Z31_STATUS == "01"
	
	DEFINE MSDIALOG oTlChave FROM 0,0 TO 110,350 TITLE "Valida Chave de Acesso........." Of oMainWnd PIXEL
	
	oTlChave:lEscClose := .F.
	
	@ 005, 010 Say "Chave de Acesso : " Size 100,010 Pixel Of oTlChave
	@ 015, 010 MSGET Z31->Z31_CHAVE WHEN .T. PICTURE PesqPict("Z31","Z31_CHAVE") SIZE 156,010 PIXEL OF oTlChave
	
	oBtnAtz:= TButton():New( 035,010, "Autorizada" , oTlChave , {||},045,015, , , , .T. , , , , { ||})
	oBtnAtz:BLCLICKED:= {|| oTlChave:End(), STSSEFAZ(1,cNum, cSerie, cCNPJ)}
	
	oBtnRjt:= TButton():New( 035,121, "Rejeitada"  , oTlChave , {||},045,015, , , , .T. , , , , { ||})
	oBtnRjt:BLCLICKED:= {|| oTlChave:End(), STSSEFAZ(2,cNum, cSerie, cCNPJ)}
	
	ACTIVATE DIALOG oTlChave CENTERED
	
ELSEIF Z31->Z31_STATUS == "02"
	RecLock("Z31",.F.)
	Z31->Z31_STATUS := "03"
	Z31->Z31_USER   := ALLTRIM(cUserName)
	Z31->Z31_DTLOG  := dDataBase
	Z31->Z31_HRLOG  := Time()
	MsUnlock()
	XMLPEDIDO()
ELSEIF Z31->Z31_STATUS == "03"
	If ALLTRIM(Z31->Z31_USER) == ALLTRIM(cUserName)
		RecLock("Z31",.F.)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
		XMLPEDIDO()
	Else
		MsgInfo("DANFE sendo analizada! "+CHR(13)+CHR(10)+"Data - "+DTOC(Z31->Z31_DTLOG) + "   Hora - " + Z31->Z31_HRLOG + "  User - " + Z31->Z31_USER)
	EndIF
ELSEIF Z31->Z31_STATUS == "04"
	IF MsgYesNo("DANFE J· LIberada para Recebimento em Loja pela Central de Recebimento!"+CHR(13)+CHR(10)+"Data "+DTOC(Z31->Z31_DTLOG) + " Hora " + ALLTRIM(Z31->Z31_HRLOG) + "User " + ALLTRIM(Z31->Z31_USER) + ". Deseja fazer o estorno do XML?","YESNO")
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ CHAMA A ROTINA DE ESTORNO DE XML ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		U_SYXMLA09()
	EndIF
ELSEIF Z31->Z31_STATUS == "05"
	If ALLTRIM(Z31->Z31_USER) == ALLTRIM(cUserName)
		IF MsgYesNo("DANFE Bloqueada pelo usu·rio : " + ALLTRIM(Z31->Z31_USER) + " (" + DTOC(Z31->Z31_DTLOG) + "  |  " + Z31->Z31_HRLOG + ") !, Deseja Alterar o STATUS para 'EM ABERTO'?","YESNO")
			RecLock("Z31",.F.)
			Z31->Z31_STATUS := "03"
			Z31->Z31_USER   := ALLTRIM(cUserName)
			Z31->Z31_DTLOG  := dDataBase
			Z31->Z31_HRLOG  := Time()
			MsUnlock()
			XMLPEDIDO()
		EndIF
	Else
		MsgInfo("DANFE Bloqueada pela Central de Recebimento!"+CHR(13)+CHR(10)+"Data "+DTOC(Z31->Z31_DTLOG) + " Hora " + Z31->Z31_HRLOG + "User " + Z31->Z31_USER)
	EndIF
ELSEIF Z31->Z31_STATUS == "06"
	If ALLTRIM(Z31->Z31_USER) == ALLTRIM(cUserName)
		MsgAlert("DANFE Rejeitada!"+CHR(13)+CHR(10)+"Data "+DTOC(Z31->Z31_DTLOG) + " Hora " + Z31->Z31_HRLOG + "User " + Z31->Z31_USER)
	EndIF
ELSEIF Z31->Z31_STATUS == "07"
	MsgInfo("DANFE Rejeitada na SEFAZ!")
ELSEIF Z31->Z31_STATUS == "08"
	If ALLTRIM(Z31->Z31_USER) == ALLTRIM(cUserName)
		IF MsgYesNo("DANFE Bloqueada S/ Pedido pela Central de Recebimento!, Deseja Alterar o STATUS para 'EM ABERTO'?","YESNO")
			RecLock("Z31",.F.)
			Z31->Z31_STATUS := "03"
			Z31->Z31_USER   := ALLTRIM(cUserName)
			Z31->Z31_DTLOG  := dDataBase
			Z31->Z31_HRLOG  := Time()
			MsUnlock()
			XMLPEDIDO()
		EndIF
	Else
		MsgInfo("DANFE Bloqueada S/ Pedido pela Central de Recebimento!"+CHR(13)+CHR(10)+"Data "+DTOC(Z31->Z31_DTLOG) + " Hora " + Z31->Z31_HRLOG + "User " + Z31->Z31_USER)
	EndIF
ENDIF


RETURN(.T.)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ STSSEFAZ ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ GRAVA O STATUS DE ACORDO COM O STATUS DA SEFAZ             ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION STSSEFAZ(nOpc,cNum, cSerie, cCNPJ)

DbSelectArea("Z31")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("Z31") + cNum + cSerie + cCNPJ)
RecLock("Z31",.F.)
If nOpc = 1
	Z31->Z31_STATUS := "02"
Else
	Z31->Z31_STATUS := "07"
EndIF
Z31->Z31_USER   := ALLTRIM(cUserName)
Z31->Z31_DTLOG  := dDataBase
Z31->Z31_HRLOG  := Time()
MsUnlock()

RETURN(.T.)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥XMLPEDIDO ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Faz a amarracao PEDIDOS X XML                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION XMLPEDIDO()

Local cError     := ""
Local cWarning   := ""
Local cQuery     := ""
Local cLinDup    := ""
Local cLinVcto   := ""
Local cLinVlr    := ""
Local lXmlOk     := .T.
Local aDirectory := {}
Local cLinEsp  	 := ""
Local cLinPesob  := ""
Local cPach      := ALLTRIM(GetMv("MV_XMLDIR"))  // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Local cPathE     := ALLTRIM(GetMv("MV_XMLDIR2")) // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Local lOrdem   	 := .F.
Local oXml       := NIL
Local cXML       := ALLTRIM(Z31->Z31_XML)
Local cXMLCVH    := ALLTRIM(Z31->Z31_CHAVE) + ".xml"
Local cFile      := ""
Local nPos       := 0
Local nPosPed    := 0
Local nBtn       := 4
Local aLojas     := {}
Local oOk	     := LoadBitMap(GetResources(), "LBOK")
Local oNo	     := LoadBitMap(GetResources(), "LBNO")
Local oPnlXML, oPnlPEDIDO, oPnlIDE, oPnlNF, oPnlDest, oPnlVlr, oPnlIn, oBrw, oBrwPedido, oBtnSair, oBtnAna, oBtnBlq, oBtnRjt, oTela, oBtnDevCL, oBtnBlqPed, oScroll, oPnlscroll

Private cChaveNF  := ""
Private cLjPed    := ""
Private cForne    := ""
Private cLoja     := ""
Private aProdXML  := {}
Private aPedidos  := {}
Private lCampoFil := .F.
Private oNoPrin
Private oFntTit, oFnt, oFntInf,oBtnForne


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒêø
//≥ VALIDA QUAL CAMPO SERA USADO - C7_01FILDE SE O MODULO DO GCV ESTA INSTALADO / C7_FILENT PARA OS CASOS DE NAO ESTAR INSTALADO O GCV ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒêŸ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SC7")
While !Eof() .And. (X3_ARQUIVO == "SC7")
	IF AllTrim(SX3->X3_CAMPO) $ ("C7_01FILDE")
		lCampoFil := .T.
	ENDIF
	SX3->(DbSkip())
EndDo

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Verifico que o xml existe no servidor≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cFile := cPach+cXML
oXml := XmlParserFile( cFile, "_", @cError, @cWarning )

IF !EMPTY(ALLTRIM(cError))
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Caso n„o ache o xml, faz uma busca com a chave + '.xml'≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cFile := cPach+cXMLCVH
	oXml  := XmlParserFile( cFile, "_", @cError, @cWarning )
	
	IF !EMPTY(ALLTRIM(cError))
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Se o arquivo nao estiver no servidor, procuro no P:/ e copio para a pasta edi/≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		aDirectory := Directory(cPathE + cXML)
		
		If Len(aDirectory) > 0
			cFile:=aDirectory[1][1]
			cFile:=cPathE+cFile
			__CopyFile(cFile, cPach+aDirectory[1][1])
			cFile:="edi/"+aDirectory[1][1]
			
			oXml  := XmlParserFile( cFile, "_", @cError, @cWarning )
			
			IF !EMPTY(ALLTRIM(cError))
				lXmlOk := .F.
			EndIf
		Else
			lXmlOk := .F.
		EndIf
	EndIf
EndIF

If lXmlOk
	oNoPrin := XmlGetChild ( oXml, 1 )
Else
	Alert("N„o foi possivel carregar o XML dessa nota.")
	Conout(DtoC(Date())+" - "+Time()+" - "+cError)
	
	RecLock("Z31",.F.)
	Z31->Z31_STATUS := "02"
	Z31->Z31_USER   := ALLTRIM(cUserName)
	Z31->Z31_DTLOG  := dDataBase
	Z31->Z31_HRLOG  := Time()
	MsUnlock()
	
	Return()
EndIf

SM0->(DbGoTop())

While SM0->(!EOF())
	aAdd( aLojas, { ALLTRIM(SM0->M0_CODIGO) , ALLTRIM(SM0->M0_CODFIL) , ALLTRIM(SM0->M0_CGC) , ALLTRIM(SM0->M0_FILIAL) } )
	SM0->(DbSkip())
EndDo

IF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "nfe"
	nPos   := aScan( aLojas , { |x| x[3] == oNoPrin:_INFNFE:_DEST:_CNPJ:TEXT } )
	cForne := Posicione("SA2",3,xFilial("SA2")+oNoPrin:_INFNFE:_EMIT:_CNPJ:TEXT,"A2_COD")
	cLoja  := Posicione("SA2",3,xFilial("SA2")+oNoPrin:_INFNFE:_EMIT:_CNPJ:TEXT,"A2_LOJA")
ElseIF ALLTRIM(LOWER(oNoPrin:REALNAME)) $  "enviNFe/nfeproc""
	nPos   := aScan( aLojas , { |x| x[3] == oNoPrin:_NFE:_INFNFE:_DEST:_CNPJ:TEXT } )
	cForne := Posicione("SA2",3,xFilial("SA2")+oNoPrin:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT,"A2_COD")
	cLoja  := Posicione("SA2",3,xFilial("SA2")+oNoPrin:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT,"A2_LOJA")
EndIF

If nPos == 0
	Alert("Nota Faturada com cnpj inexistente!!!")
	cLjPed := ""
Else
	IF Len(ALLTRIM(ALOJAS[nPos,2])) = 2
		cLjPed := ALLTRIM(ALOJAS[nPos,1]) + ALLTRIM(ALOJAS[nPos,2])
	Else
		cLjPed := ALLTRIM(ALOJAS[nPos,2])
	EndIF
EndIf


//#CMG20180228.bn
IF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "nfe"

	For _ny := 1 To Len(oNoPrin:_INFNFE:_DET)          
	
		If ALLTRIM(oNoPrin:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT) <> Nil 
		
			If !Empty(ALLTRIM(oNoPrin:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT))

		     	_cXPed   := StrZero(Val(oNoPrin:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT),6)
		     	_cXPedIt := StrZero(Val(oNoPrin:_INFNFE:_DET[_ny]:_PROD:_NITEMPED:TEXT),4)
		     
				AADD(_aXPed,{_cXPed,_cXPedIt})

		    EndIf
		    
		EndIf
    
	Next _ny                                                                                                        

ElseIf ALLTRIM(LOWER(oNoPrin:REALNAME)) $  "enviNFe/nfeproc""
	
	For _ny := 1 To Len(oNoPrin:_NFE:_INFNFE:_DET)          
	
		If ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT) <> Nil 
		
			If !Empty(ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT))
		        
		     	_cXPed   := StrZero(Val(oNoPrin:_NFE:_INFNFE:_DET[_ny]:_PROD:_XPED:TEXT),6)
		     	_cXPedIt := StrZero(Val(oNoPrin:_NFE:_INFNFE:_DET[_ny]:_PROD:_NITEMPED:TEXT),4)
		     
				AADD(_aXPed,{_cXPed,_cXPedIt})
		    
			EndIf
		
		EndIf
    
	Next _ny                                                                                                        
	
EndIF
//#CMG20180228.en

cQuery := "	SELECT C7_NUM,C7_ITEM, SUM(C7_QUANT) AS QTDE, C7_EMISSAO, C7_DATPRF,C7_CONAPRO "
cQuery += " FROM " + RETSQLNAME("SC7") "
cQuery += " WHERE C7_FILIAL = '" + XFILIAL("SC7") +"' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND C7_QUJE < C7_QUANT "
cQuery += " AND C7_FORNECE = '" + cForne + "' "
cQuery += " AND C7_LOJA = '" + cLoja + "' "
cQuery += " AND C7_RESIDUO <> 'S' " 
IF lCampoFil
	cQuery += " AND (C7_01FILDE = '" + cLjPed + "' " 
	cQuery += " OR C7_01FILDE = ' ') "	
Else
	cQuery += " AND C7_FILENT = '" + cLjPed + "' "
EndIF
cQuery += " GROUP BY C7_NUM,C7_ITEM, C7_EMISSAO, C7_DATPRF, C7_CONAPRO "
cQuery += " ORDER BY C7_NUM,C7_ITEM "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

TRB->(DbGoTop())
While TRB->(!EOF())

	//#CMG20180228.bn
	_lMarc := .F.
                     
    For _ny := 1 To Len(_aXPed)
	    
		If TRB->C7_NUM+TRB->C7_ITEM == _aXPed[_ny,1]+_aXPed[_ny,2]
		
			_lMarc := .T.                    
			Exit
		
		EndIf   
		
	Next _ny
	//#CMG20180228.en
	
	aAdd( aPedidos , { _lMarc, TRB->C7_NUM, TRB->QTDE, TRB->C7_EMISSAO, TRB->C7_DATPRF, "" , TRB->C7_CONAPRO} )
	TRB->(DbSkip())
EndDo

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Metodo encontrado para validar os tipos de xml (xml ou xmls) , sendo que o xmls o len dele e 7 - Luiz Eduardo - 20.05.11≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
IF XmlChildCount(onoprin) = 7
	IF XmlChildCount(onoprin:_protnfe) = 1
		cStatus  := "01"
		cChaveNF := oNoPrin:_PROTNFE:_PROTNFE:_INFPROT:_CHNFE:TEXT
	ELSE
		cStatus  := "01"
		cChaveNF := oNoPrin:_PROTNFE:_INFPROT:_CHNFE:TEXT
	EndIF
Else
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Tratamento para Notas Fiscais Canceladas ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If ALLTRIM(oNoPrin:REALNAME) == "procCancNFe"
		cStatus  := "09"
		cChaveNF := oNoPrin:_RETCANCNFE:_INFCANC:_CHNFE:TEXT
	ElseIF ALLTRIM(oNoPrin:REALNAME) == "NFe"
		cStatus  := "01"
		cStatus  := "01"
		If XmlChildEx ( oXml:_NFE, "_SIGNATURE") <> Nil
			cChaveNF := oXml:_NFE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT
			cChaveNF := SUBSTR(ALLTRIM(cChaveNF),5,LEN(ALLTRIM(cChaveNF)))
		Else
			cChaveNF := oXml:_NFE:_INFNFE:_ID:TEXT
			cChaveNF := SUBSTR(ALLTRIM(cChaveNF),4,LEN(ALLTRIM(cChaveNF)))
		EndIf
	ElseIF ALLTRIM(oNoPrin:REALNAME) == "enviNFe"
		cStatus  := "01"
		cChaveNF := onoprin:_NFE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT
		cChaveNF := SUBSTR(ALLTRIM(cChaveNF),5,LEN(ALLTRIM(cChaveNF)))
	Else
		cStatus  := "01"
		IF XmlChildEx ( oNoPrin:_PROTNFE ,   "_INFPROT") <> NIL
			IF VALTYPE(oNoPrin:_PROTNFE:_INFPROT) == "O"
				cChaveNF := oNoPrin:_PROTNFE:_INFPROT:_CHNFE:TEXT
			ELSEIF VALTYPE(oNoPrin:_PROTNFE:_INFPROT) == "A"
				For nX := 1 To Len(oNoPrin:_PROTNFE:_INFPROT)
					cChaveNF := oNoPrin:_PROTNFE:_INFPROT[nX]:_CHNFE:TEXT
					
				Next nX
			ENDIF
		Else
			cChaveNF := RIGHT(ALLTRIM(oNoPrin:_NFE:_INFNFE:_ID:TEXT),LEN(ALLTRIM(oNoPrin:_NFE:_INFNFE:_ID:TEXT))-3)
		EndIF
	EndIF
EndIF

TRB->(DbCloseArea())

//If XmlChildEx ( oNoPrin, "_NFE ") <> NIL
IF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "nfe"
	//CARREGA ACOLS COM OS VALORES DO CABECALHO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT   )  																			// VALOR TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT   )  																			// BASE DE CALCULO TOTAL DE ICMS DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )  																			// VALOR DO ICMS TOTAL DA NOTA FISCAL
	aAdd ( aValores , IIF(ALLTRIM(oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT) <> "0" , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT , "0" )  )        // BASE DE CALCULO DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT  )                                                                            // VALOR DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )                                                                            // TOTAL DE DESCONTO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )                                                                            // BASE DE CALCULO TOTAL DE ICMS ST TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT   )                                                                            // VALOR DE ICMS ST TOTAL DA NOTA FISCAL
	
	// INDICE
	/*01*/aAdd( aDados, oNoPrin:_INFNFE:_EMIT:_XNOME:TEXT  )
	/*02*/aAdd( aDados, oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT + "  ,  " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT + "  ,  " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT )
	If XmlChildEx ( oNoPrin:_INFNFE:_EMIT:_ENDEREMIT ,   "_FONE") <> NIL
		/*03*/aAdd( aDados, "Cep " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT + "  ,  Fone " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT )
	Else
		/*03*/aAdd( aDados, "Cep " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  )
	EndIF
	/*04*/aAdd( aDados, "Cnpj " + oNoPrin:_INFNFE:_EMIT:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_INFNFE:_EMIT:_IE:TEXT )
	/*05*/aAdd( aDados, "Natureza da OperaÁ„o - " + oNoPrin:_INFNFE:_IDE:_NATOP:TEXT ) // natureza da operacao
	
	If XmlChildEx ( oNoPrin:_INFNFE:_IDE, "_DEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + oNoPrin:_INFNFE:_IDE:_DEMI:TEXT )  // dt. emissao
	ElseIf XmlChildEx ( oNoPrin:_INFNFE:_IDE, "_DHEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + SubStr(oNoPrin:_INFNFE:_IDE:_DHEMI:TEXT,1,10) )  // dt. emissao
	EndIf
	
	If nPos == 0
		/*07*/aAdd( aDados, "CNPJ INEXISTENTE" )  // DADOS DO DESTINATARIO
	Else
		/*07*/aAdd( aDados, oNoPrin:_INFNFE:_DEST:_XNOME:TEXT + " ( " + aLojas[nPos,2] + " - " + aLojas[nPos,4] + " )" )  // DADOS DO DESTINATARIO
	EndIf
	
	//	/*07*/aAdd( aDados, oNoPrin:_INFNFE:_DEST:_XNOME:TEXT + " ( " + aLojas[nPos,2] + " - " + aLojas[nPos,4] + " )" )  // DADOS DO DESTINATARIO
	/*08*/aAdd( aDados, oNoPrin:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT + "  ,  " + oNoPrin:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT + "  ,  " + oNoPrin:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT )
	/*09*/aAdd( aDados, "Cep " + oNoPrin:_INFNFE:_DEST:_ENDERDEST:_CEP:TEXT + "  ,  " + oNoPrin:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT + "-" + oNoPrin:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT )
	/*10*/aAdd( aDados, "Cnpj " + oNoPrin:_INFNFE:_DEST:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_INFNFE:_DEST:_IE:TEXT )
	/*11*/aAdd( aDados, "Base de Calculo - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT )
	/*12*/aAdd( aDados, "Total ICMS - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )
	/*13*/aAdd( aDados, "Base de Calculo ST - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*14*/aAdd( aDados, "Total ICMS ST - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT )
	/*15*/aAdd( aDados, "Desconto - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )
	/*16*/aAdd( aDados, "Frete - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT )
	/*17*/aAdd( aDados, "Total IPI - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT )
	/*18*/aAdd( aDados, "PIS - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VPIS:TEXT )
	/*19*/aAdd( aDados, "COFINS - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*20*/aAdd( aDados, "Seguro - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:TEXT )
	/*21*/aAdd( aDados, "Outros - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:TEXT )
	/*22*/aAdd( aDados, "Valor Total NF - " + oNoPrin:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT )
	If XmlChildEx ( oNoPrin:_INFNFE ,   "_COBR") <> NIL
		If XmlChildEx ( oNoPrin:_INFNFE:_COBR ,   "_DUP") <> NIL
			IF VALTYPE(oNoPrin:_INFNFE:_COBR:_DUP) == "O"
				/*23*/aAdd( aDados, "Duplicata - " + oNoPrin:_INFNFE:_COBR:_DUP:_NDUP:TEXT )
				
				If XmlChildEx ( oNoPrin:_INFNFE:_COBR:_DUP , "_DVENC") <> NIL
					/*24*/aAdd( aDados, "Dt.Vcto - "   + oNoPrin:_INFNFE:_COBR:_DUP:_DVENC:TEXT)
				Else
					/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML")
				EndIF
				
				If XmlChildEx ( oNoPrin:_INFNFE:_COBR:_DUP ,   "_VDUP") <> NIL
					/*25*/aAdd( aDados, "Valor - "    + oNoPrin:_INFNFE:_COBR:_DUP:_VDUP:TEXT )
				Else
					/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML")
				EndIF
			ElseIF VALTYPE(oNoPrin:_INFNFE:_COBR:_DUP) == "A"
				For nX:=1 To Len(oNoPrin:_INFNFE:_COBR:_DUP)
					cLinDup  += " - " + oNoPrin:_INFNFE:_COBR:_DUP[nX]:_NDUP:TEXT
					
					If XmlChildEx ( oNoPrin:_INFNFE:_COBR:_DUP[nX] , "_DVENC") <> NIL
						cLinVcto += " - " + oNoPrin:_INFNFE:_COBR:_DUP[nX]:_DVENC:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_INFNFE:_COBR:_DUP[nX] ,   "_VDUP") <> NIL
						cLinVlr  += " - " + oNoPrin:_INFNFE:_COBR:_DUP[nX]:_VDUP:TEXT
					EndIF
				Next
				/*23*/aAdd( aDados, "Duplicata" + cLinDup )
				/*24*/aAdd( aDados, "Dt.Vcto"   + cLinVcto)
				/*25*/aAdd( aDados, "Valor"     + cLinVlr )
			EndIF
		Else
			/*23*/aAdd( aDados, "Duplicata - NAO INFORMADO NO XML" )
			/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML"   )
			/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML"    )
		EndIF
	Else
		/*23*/aAdd( aDados, "Duplicata - N√O INFORMADO NO XML" )
		/*24*/aAdd( aDados, "Dt.Vcto - -- / -- / ---- ")
		/*25*/aAdd( aDados, "Valor - --,-- " )
	EndIF
	
	If XmlChildEx ( oNoPrin:_INFNFE ,   "_COMPRA") <> NIL
		If	XmlChildEx ( oNoPrin:_INFNFE:_COMPRA ,   "_XPED") <> NIL
			/*26*/aAdd( aDados, "Pedido(s) - " + oNoPrin:_INFNFE:_COMPRA:_XPED:TEXT )
		Else
			/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
		EndIf
	Else
		/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
	EndIF
	
	If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP ,   "_VOL") <> NIL
		If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_QVOL") <> NIL
			
			If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
				/*27*/aAdd( aDados, "Especie - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
			Else
				/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
			EndIF
			
			If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
				/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
			Else
				/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
			EndIF
		Else
			If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
				/*27*/aAdd( aDados, "Especie - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - NAO INFORMADO NO XML" )
			Else
				/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde -  Qtde - NAO INFORMADO NO XML" )
			EndIF
			
			If XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
				/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
			Else
				/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
			EndIF
		EndIF
	Else
		/*27*/aAdd( aDados, "Especie - N√O INFORMADO NO XML" )
		/*28*/aAdd( aDados, "P.Bruto - N√O INFORMADO NO XML" )
	EndIF
	
	If XmlChildEx ( oNoPrin:_INFNFE , "_INFADIC") <> NIL
		If XmlChildEx ( oNoPrin:_INFNFE:_INFADIC , "_INFCPL") <> NIL
			/*29*/aAdd( aDados, oNoPrin:_INFNFE:_INFADIC:_INFCPL:TEXT )
		Else
			/*29*/aAdd( aDados, "NAO INFORMADO NO XML" )
		Endif
		
		If XmlChildEx ( oNoPrin:_INFNFE:_INFADIC , "_INFADFISCO") <> NIL
			/*30*/aAdd( aDados, oNoPrin:_INFNFE:_INFADIC:_INFADFISCO:TEXT )
		Else
			/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
		EndIF
	Else
		/*29*/aAdd( aDados, "N√O INFORMADO NO XML" )
		/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
	EndIF
	
	IF VALTYPE(oNoPrin:_INFNFE:_DET) == "O"
		IF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VBCSTRET:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VICMSSTRET:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN201") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN202") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		Else
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		EndIF
		
		IF XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO , "_IPI") <> NIL
			If XmlChildEx ( oNoPrin:_INFNFE:_DET:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
				aProdXML[1,13] := oNoPrin:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
				aProdXML[1,15] := oNoPrin:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
				aProdXML[1,16] := oNoPrin:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
			EndIF
		EndIF
		
	ElseIF VALTYPE(oNoPrin:_INFNFE:_DET) == "A"
		For nX := 1 To Len(oNoPrin:_INFNFE:_DET)
			IF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS  , "_ICMSSN201") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS  , "_ICMSSN202") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			Else
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			EndIF
			
			IF XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO , "_IPI") <> NIL
				If XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
					aProdXML[nX,13] := oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
					
					If XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_PIPI") <> NIL
						aProdXML[nX,15] := oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_VBC") <> NIL
						aProdXML[nX,16] := oNoPrin:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
					EndIF
					
				EndIF
			EndIF
		Next
	EndIF
ElseIF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "envinfe"
	//CARREGA ACOLS COM OS VALORES DO CABECALHO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT   )  																			// VALOR TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT   )  																			// BASE DE CALCULO TOTAL DE ICMS DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )  																			// VALOR DO ICMS TOTAL DA NOTA FISCAL
	aAdd ( aValores , IIF(ALLTRIM(oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT) <> "0" , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT , "0" )  )        // BASE DE CALCULO DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT  )                                                                            // VALOR DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )                                                                            // TOTAL DE DESCONTO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )                                                                            // BASE DE CALCULO TOTAL DE ICMS ST TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT   )                                                                            // VALOR DE ICMS ST TOTAL DA NOTA FISCAL
	
	// INDICE
	/*01*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_EMIT:_XNOME:TEXT  )
	/*02*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT )
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT ,   "_FONE") <> NIL
		/*03*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT + "  ,  Fone " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT )
	Else
		/*03*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  )
	EndIF
	/*04*/aAdd( aDados, "Cnpj " + oNoPrin:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_NFE:_INFNFE:_EMIT:_IE:TEXT )
	/*05*/aAdd( aDados, "Natureza da OperaÁ„o - " + oNoPrin:_NFE:_INFNFE:_IDE:_NATOP:TEXT ) // natureza da operacao
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + oNoPrin:_NFE:_INFNFE:_IDE:_DEMI:TEXT )  // dt. emissao
	ElseIf XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DHEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + SubStr(oNoPrin:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10) )  // dt. emissao
	EndIf
	
	If nPos == 0
		/*07*/aAdd( aDados, "CNPJ INEXISTENTE" )  // DADOS DO DESTINATARIO
	Else
		/*07*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_DEST:_XNOME:TEXT + " ( " + aLojas[nPos,2] + " - " + aLojas[nPos,4] + " )" )  // DADOS DO DESTINATARIO
	EndIf
	
	/*07*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_DEST:_XNOME:TEXT + " ( " + aLojas[nPos,2] + " - " + aLojas[nPos,4] + " )" )  // DADOS DO DESTINATARIO
	/*08*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT )
	/*09*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT )
	/*10*/aAdd( aDados, "Cnpj " + oNoPrin:_NFE:_INFNFE:_DEST:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_NFE:_INFNFE:_DEST:_IE:TEXT )
	/*11*/aAdd( aDados, "Base de Calculo - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT )
	/*12*/aAdd( aDados, "Total ICMS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )
	/*13*/aAdd( aDados, "Base de Calculo ST - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*14*/aAdd( aDados, "Total ICMS ST - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT )
	/*15*/aAdd( aDados, "Desconto - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )
	/*16*/aAdd( aDados, "Frete - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT )
	/*17*/aAdd( aDados, "Total IPI - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT )
	/*18*/aAdd( aDados, "PIS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPIS:TEXT )
	/*19*/aAdd( aDados, "COFINS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*20*/aAdd( aDados, "Seguro - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:TEXT )
	/*21*/aAdd( aDados, "Outros - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:TEXT )
	/*22*/aAdd( aDados, "Valor Total NF - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT )
	If XmlChildEx (  oNoPrin:_NFE:_INFNFE ,   "_COBR") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR ,   "_DUP") <> NIL
			IF VALTYPE(oNoPrin:_NFE:_INFNFE:_COBR:_DUP) == "O"
				/*23*/aAdd( aDados, "Duplicata - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_NDUP:TEXT )
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP , "_DVENC") <> NIL
					/*24*/aAdd( aDados, "Dt.Vcto - "   + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_DVENC:TEXT)
				Else
					/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML")
				EndIF
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP ,   "_VDUP") <> NIL
					/*25*/aAdd( aDados, "Valor - "    + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_VDUP:TEXT )
				Else
					/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML")
				EndIF
			ElseIF VALTYPE(oNoPrin:_NFE:_INFNFE:_COBR:_DUP) == "A"
				For nX:=1 To Len(oNoPrin:_NFE:_INFNFE:_COBR:_DUP)
					cLinDup  += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_NDUP:TEXT
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX] , "_DVENC") <> NIL
						cLinVcto += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_DVENC:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX] ,   "_VDUP") <> NIL
						cLinVlr  += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_VDUP:TEXT
					EndIF
				Next
				/*23*/aAdd( aDados, "Duplicata" + cLinDup )
				/*24*/aAdd( aDados, "Dt.Vcto"   + cLinVcto)
				/*25*/aAdd( aDados, "Valor"     + cLinVlr )
			EndIF
		Else
			/*23*/aAdd( aDados, "Duplicata - NAO INFORMADO NO XML" )
			/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML"   )
			/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML"    )
		EndIF
	Else
		/*23*/aAdd( aDados, "Duplicata - N√O INFORMADO NO XML" )
		/*24*/aAdd( aDados, "Dt.Vcto - -- / -- / ---- ")
		/*25*/aAdd( aDados, "Valor - --,-- " )
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE ,   "_COMPRA") <> NIL
		If	XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COMPRA ,   "_XPED") <> NIL
			/*26*/aAdd( aDados, "Pedido(s) - " + oNoPrin:_NFE:_INFNFE:_COMPRA:_XPED:TEXT )
		Else
			/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
		EndIf
	Else
		/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP ,   "_VOL") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_QVOL") <> NIL
			
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
				/*27*/aAdd( aDados, "Especie - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
			Else
				/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
			EndIF
			
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
				/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
			Else
				/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
			EndIF
		Else
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
				/*27*/aAdd( aDados, "Especie - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - NAO INFORMADO NO XML" )
			Else
				/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde -  Qtde - NAO INFORMADO NO XML" )
			EndIF
			
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
				/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
			Else
				/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
			EndIF
		EndIF
	Else
		/*27*/aAdd( aDados, "Especie - N√O INFORMADO NO XML" )
		/*28*/aAdd( aDados, "P.Bruto - N√O INFORMADO NO XML" )
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE , "_INFADIC") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_INFADIC , "_INFCPL") <> NIL
			/*29*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT )
		Else
			/*29*/aAdd( aDados, "NAO INFORMADO NO XML" )
		Endif
		
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_INFADIC , "_INFADFISCO") <> NIL
			/*30*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_INFADIC:_INFADFISCO:TEXT )
		Else
			/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
		EndIF
	Else
		/*29*/aAdd( aDados, "N√O INFORMADO NO XML" )
		/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
	EndIF
	
	IF VALTYPE(oNoPrin:_NFE:_INFNFE:_DET) == "O"
		IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN201") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN202") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		Else
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		EndIF
		
		IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO , "_IPI") <> NIL
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
				aProdXML[1,13] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
				aProdXML[1,15] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
				aProdXML[1,16] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
			EndIF
		EndIF
		
	ElseIF VALTYPE(oNoPrin:_NFE:_INFNFE:_DET) == "A"
		For nX := 1 To Len(oNoPrin:_NFE:_INFNFE:_DET)
			IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VBCSTRET:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VICMSSTRET:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS  , "_ICMSSN201") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS  , "_ICMSSN202") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			Else
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			EndIF
			
			IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO , "_IPI") <> NIL
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
					aProdXML[nX,13] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_PIPI") <> NIL
						aProdXML[nX,15] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_VBC") <> NIL
						aProdXML[nX,16] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
					EndIF
					
				EndIF
			EndIF
			
		Next
	EndIF
Else
	//CARREGA ACOLS COM OS VALORES DO CABECALHO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT   )  																					// VALOR TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT   )  																					// BASE DE CALCULO TOTAL DE ICMS DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )  																					// VALOR DO ICMS TOTAL DA NOTA FISCAL
	aAdd ( aValores , IIF(ALLTRIM(oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT) <> "0" , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT , "0" )  )  	// BASE DE CALCULO DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT  )                                                  			                        // VALOR DO IPI TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )                                                    	                       		// TOTAL DE DESCONTO DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )                                                                            		// BASE DE CALCULO TOTAL DE ICMS ST TOTAL DA NOTA FISCAL
	aAdd ( aValores , oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT   )                                                                            		// VALOR DE ICMS ST TOTAL DA NOTA FISCAL
	
	// INDICE
	/*01*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_EMIT:_XNOME:TEXT  )
	/*02*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_NRO:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT )
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT ,   "_FONE") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT ,   "_CEP") <> NIL
			/*03*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT + "  ,  Fone " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT )
		Else
			/*03*/aAdd( aDados, "Cep NAO INFORMADO NO XML" + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT + "  ,  Fone " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT )
		EndIF
	Else
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT ,   "_CEP") <> NIL
			/*03*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  )
		Else
			/*03*/aAdd( aDados, "Cep NAO INFORMADO NO XML" + "  ,  " + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  )
		EndIF
	EndIF
	/*04*/aAdd( aDados, "Cnpj " + oNoPrin:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_NFE:_INFNFE:_EMIT:_IE:TEXT )
	/*05*/aAdd( aDados, "Natureza da OperaÁ„o - " + oNoPrin:_NFE:_INFNFE:_IDE:_NATOP:TEXT ) // natureza da operacao
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + oNoPrin:_NFE:_INFNFE:_IDE:_DEMI:TEXT )  // dt. emissao
	ElseIf XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DHEMI") <> Nil
		/*06*/aAdd( aDados, "Data de Emiss„o - " + SubStr(oNoPrin:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10) )  // dt. emissao
	EndIf
	
	If nPos == 0
		/*07*/aAdd( aDados, "CNPJ INEXISTENTE" )  // DADOS DO DESTINATARIO
	Else
		/*07*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_DEST:_XNOME:TEXT + " ( " + aLojas[nPos,2] + " - " + aLojas[nPos,4] + " )" )  // DADOS DO DESTINATARIO
	EndIf
	
	/*08*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XLGR:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XBAIRRO:TEXT )
	IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST ,   "_CEP") <> NIL
		/*09*/aAdd( aDados, "Cep " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_CEP:TEXT + "  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT )
	Else
		/*09*/aAdd( aDados, "Cep NAO INFORMADO NO XML  ,  " + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_XMUN:TEXT + "-" + oNoPrin:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT )
	EndIF
	
	IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DEST ,   "_IE") <> NIL
		/*10*/aAdd( aDados, "Cnpj " + oNoPrin:_NFE:_INFNFE:_DEST:_CNPJ:TEXT + "     -     I.E. " + oNoPrin:_NFE:_INFNFE:_DEST:_IE:TEXT )
	Else
		IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DEST ,   "_CNPJ") <> NIL
		/*10*/aAdd( aDados, "Cnpj " + oNoPrin:_NFE:_INFNFE:_DEST:_CNPJ:TEXT + "     -     I.E. NAO INFORMADO NO XML")   
		Else
	 		aAdd( aDados, "Cnpj INVALIDO   -     I.E. NAO INFORMADO NO XML") 	
		EndIF
	EndIF
	
	/*11*/aAdd( aDados, "Base de Calculo - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT )
	/*12*/aAdd( aDados, "Total ICMS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT )
	/*13*/aAdd( aDados, "Base de Calculo ST - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*14*/aAdd( aDados, "Total ICMS ST - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT )
	/*15*/aAdd( aDados, "Desconto - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT )
	/*16*/aAdd( aDados, "Frete - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT )
	/*17*/aAdd( aDados, "Total IPI - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT )
	/*18*/aAdd( aDados, "PIS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPIS:TEXT )
	/*19*/aAdd( aDados, "COFINS - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:TEXT )
	/*20*/aAdd( aDados, "Seguro - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:TEXT )
	/*21*/aAdd( aDados, "Outros - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:TEXT )
	/*22*/aAdd( aDados, "Valor Total NF - " + oNoPrin:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT )
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE ,   "_COBR") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR ,   "_DUP") <> NIL
			IF VALTYPE(oNoPrin:_NFE:_INFNFE:_COBR:_DUP) == "O"
				/*23*/aAdd( aDados, "Duplicata - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_NDUP:TEXT )
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP , "_DVENC") <> NIL
					/*24*/aAdd( aDados, "Dt.Vcto - "   + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_DVENC:TEXT)
				Else
					/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML")
				EndIF
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP ,   "_VDUP") <> NIL
					/*25*/aAdd( aDados, "Valor - "    + oNoPrin:_NFE:_INFNFE:_COBR:_DUP:_VDUP:TEXT )
				Else
					/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML" )
				EndIF
			ElseIF VALTYPE(oNoPrin:_NFE:_INFNFE:_COBR:_DUP) == "A"
				For nX:=1 To Len(oNoPrin:_NFE:_INFNFE:_COBR:_DUP)
					cLinDup  += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_NDUP:TEXT
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX] , "_DVENC") <> NIL
						cLinVcto += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_DVENC:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX] ,   "_VDUP") <> NIL
						cLinVlr  += " - " + oNoPrin:_NFE:_INFNFE:_COBR:_DUP[nX]:_VDUP:TEXT
					EndIF
				Next
				/*23*/aAdd( aDados, "Duplicata" + cLinDup )
				/*24*/aAdd( aDados, "Dt.Vcto"   + cLinVcto)
				/*25*/aAdd( aDados, "Valor"     + cLinVlr )
			EndIF
		Else
			/*23*/aAdd( aDados, "Duplicata - NAO INFORMADO NO XML" )
			/*24*/aAdd( aDados, "Dt.Vcto - NAO INFORMADO NO XML"   )
			/*25*/aAdd( aDados, "Valor - NAO INFORMADO NO XML"    )
		EndIF
	Else
		/*23*/aAdd( aDados, "Duplicata - N√O INFORMADO NO XML" )
		/*24*/aAdd( aDados, "Dt.Vcto - -- / -- / ---- ")
		/*25*/aAdd( aDados, "Valor - --,-- " )
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE ,   "_COMPRA") <> NIL
		If	XmlChildEx ( oNoPrin:_NFE:_INFNFE:_COMPRA ,   "_XPED") <> NIL
			/*26*/aAdd( aDados, "Pedido(s) - " + oNoPrin:_NFE:_INFNFE:_COMPRA:_XPED:TEXT )
		Else
			/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
		EndIf
	Else
		/*26*/aAdd( aDados, "Pedido(s) - N√O INFORMADO NO XML")
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP ,   "_VOL") <> NIL
		IF VALTYPE(oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL) == "O"
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_QVOL") <> NIL
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
					/*27*/aAdd( aDados, "Especie - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
				Else
					/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
				EndIF
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
					/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
				Else
					/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
				EndIF
			Else
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_ESP") <> NIL
					/*27*/aAdd( aDados, "Especie - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT + "  Qtde - NAO INFORMADO NO XML" )
				Else
					/*27*/aAdd( aDados, "Especie - NAO INFORMADO NO XML  Qtde -  Qtde - NAO INFORMADO NO XML" )
				EndIF
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOB") <> NIL .AND. XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL ,   "_PESOL") <> NIL
					/*28*/aAdd( aDados, "P.Bruto - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
				Else
					/*28*/aAdd( aDados, "P.Bruto - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML" )
				EndIF
			EndIF
		ElseIF VALTYPE(oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL) == "A"
			For nX:=1 To Len(oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL)
				
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] ,   "_QVOL") <> NIL
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_ESP") <> NIL
						cLinEsp += oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_ESP:TEXT + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_QVOL:TEXT
					Else
						cLinEsp += " NAO INFORMADO NO XML  Qtde - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_QVOL:TEXT
					EndIF
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_PESOB") <> NIL .AND.	XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_PESOL") <> NIL
						cLinPesob += oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_PESOL:TEXT
					Else
						cLinPesob += " NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML"
					EndIF
					
				Else
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_ESP") <> NIL
						cLinEsp +=  oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_ESP:TEXT + "  Qtde - NAO INFORMADO NO XML"
					Else
						cLinEsp += " - NAO INFORMADO NO XML  Qtde -  Qtde - NAO INFORMADO NO XML"
					EndIF
					
					If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_PESOB") <> NIL .AND.	XmlChildEx ( oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX] , "_PESOL") <> NIL
						cLinPesob += oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_PESOB:TEXT + "  P.Liqui - " + oNoPrin:_NFE:_INFNFE:_TRANSP:_VOL[nX]:_PESOL:TEXT
					Else
						cLinPesob += " - NAO INFORMADO NO XML" + "  P.Liqui -  NAO INFORMADO NO XML"
					EndIF
				EndIf
			Next
			/*27*/aAdd( aDados, "Especie - " + cLinEsp  )
			/*28*/aAdd( aDados, "P.Bruto - " + cLinPesob)
		EndIf
	Else
		/*27*/aAdd( aDados, "Especie - N√O INFORMADO NO XML" )
		/*28*/aAdd( aDados, "P.Bruto - N√O INFORMADO NO XML" )
	EndIF
	
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE , "_INFADIC") <> NIL
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_INFADIC , "_INFCPL") <> NIL
			/*29*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT )
		Else
			/*29*/aAdd( aDados, "NAO INFORMADO NO XML" )
		Endif
		
		If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_INFADIC , "_INFADFISCO") <> NIL
			/*30*/aAdd( aDados, oNoPrin:_NFE:_INFNFE:_INFADIC:_INFADFISCO:TEXT )
		Else
			/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
		EndIF
	Else
		/*29*/aAdd( aDados, "N√O INFORMADO NO XML" )
		/*30*/aAdd( aDados, "N√O INFORMADO NO XML" )
	EndIF
	
	
	IF VALTYPE(oNoPrin:_NFE:_INFNFE:_DET) == "O"
		IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VBCSTRET:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS60:_VICMSSTRET:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN201") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN202") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		Else
			aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_NITEM:TEXT)       ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)   ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)  ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
			ALLTRIM("0") ,;
			ALLTRIM("0") } )
		EndIF
		
		IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO , "_IPI") <> NIL
			If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
				aProdXML[1,13] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI , "_PIPI") <> NIL
					aProdXML[1,15] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
				EndIf
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI , "_VBC") <> NIL
					aProdXML[1,16] := oNoPrin:_NFE:_INFNFE:_DET:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
				EndIf
			EndIF
		EndIF
		
	ElseIF VALTYPE(oNoPrin:_NFE:_INFNFE:_DET) == "A"
		For nX := 1 To Len(oNoPrin:_NFE:_INFNFE:_DET)
			IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS10") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS10:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS20") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS20:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS40") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS60") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VBCSTRET:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS60:_VICMSSTRET:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS70") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS70:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMS90") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN101") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN101:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN102") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN102:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN201") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN201:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN202") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN202:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN500") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN500:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			ElseIF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS , "_ICMSSN900") <> NIL
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMSSN900:_CSOSN:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			Else
				aAdd ( aProdXML , { 	ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_NITEM:TEXT)       ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_XPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_NCM:TEXT)   ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT) + ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_CFOP:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_UCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_QCOM:TEXT)  ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VUNCOM:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_PROD:_VPROD:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT) ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM(oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT) ,;
				ALLTRIM("0") ,;
				ALLTRIM("0") } )
			EndIF
			
			IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO , "_IPI") <> NIL
				If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI , "_IPITRIB") <> NIL
					aProdXML[nX,13] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
					IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_PIPI") <> NIL
						aProdXML[nX,15] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
					EndIF
					IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB , "_VBC") <> NIL
						aProdXML[nX,16] := oNoPrin:_NFE:_INFNFE:_DET[nX]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
					EndIF
				EndIF
			EndIF
		Next
	EndIF
EndIF

DEFINE FONT oFntTit NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE FONT oFntInf NAME "ARIAL" SIZE 0,-12
DEFINE FONT oFnt    NAME "ARIAL" SIZE 0,-10
DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6] + 050,aSize[5] TITLE "Pedidos X XML" Of oMainWnd PIXEL

oScroll := TScrollArea():New(oTela,01,01,100,100,.T.,.T.,.T.)
oScroll:Align := CONTROL_ALIGN_ALLCLIENT

@ 000,000 MSPANEL oPnlscroll OF oScroll SIZE 2150,2150
oScroll:SetFrame( oPnlscroll )

oTela:lEscClose := .F.

oPnlPEDIDO:= TPanel():New(010,010, "",oPnlscroll, NIL, .T., .F., NIL, NIL,225,300, .T., .F. )

IF lCLIENTE
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ MOSTRA AS INFORMACOES DO CLIENTE ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	@ 005,025 Say "InformaÁıes do Cliente [Sistema]" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlPEDIDO
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	SA1->(DbSeek(xFilial("SA1") + SUBSTR(aDados[4],6,15)))
	
	@ 030,005 Say "CÛdigo : " 			+ SA1->A1_COD 		Size 200,010 Font oFntInf Pixel Of oPnlPEDIDO
	@ 030,050 Say "Loja   : " 			+ SA1->A1_LOJA		Size 200,010 Font oFntInf Pixel Of oPnlPEDIDO
	@ 040,005 Say "CNPJ   : " 			+ SA1->A1_CGC		Size 200,010 Font oFntInf Pixel Of oPnlPEDIDO
	@ 050,005 Say "Raz„o Social   : " 	+ SA1->A1_NOME 		Size 200,010 Font oFntInf Pixel Of oPnlPEDIDO
	@ 060,005 Say "Nome Fantasia   : " 	+ SA1->A1_NREDUZ 	Size 200,010 Font oFntInf Pixel Of oPnlPEDIDO
	
Else
	oPnlPEDIDO:NCLRPANE := 14803406
	@ 005,025 Say "Listagem de Pedidos Referentes a este Fornecedor" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlPEDIDO
	
	If Len(aPedidos) > 0
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ VERIFICA A TAG <XPED> E J¡ MARCA O PEDIDO REFERENTE - AMARRACAO 1 PARA 1 - UM PEDIDO PARA UM XML ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		IF lTAGXML
			nPosPed := aScan( aPedidos , { |x| ALLTRIM(x[2]) == ALLTRIM(SUBSTR(aDados[26],13,LEN(aDados[26]))) } )
			IF nPosPed > 0
				IF aPedidos[nPosPed,7] == "B"
					MsgInfo("O Pedido Relacionado na TAG do XML Est· Bloqueado! - Pedido : " + aPedidos[nPosPed,2])
				Else
					aPedidos[nPosPed,1] := .T.
				EndIF
			EndIF
		EndIF
		
		oBrwPedido:= TWBrowse():New(015,005,210,275,,{"","Numero","Qtde.Total","Dt.Entrega","STATUS"},,oPnlPEDIDO,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oBrwPedido:SetArray(aPedidos)
		oBrwPedido:bLine := {|| { If(aPedidos[oBrwPedido:nAt,1],oOK,oNO) , aPedidos[oBrwPedido:nAt,2], Transform(aPedidos[oBrwPedido:nAt,3]  , "@E 9999,9999"), DTOC(STOD(aPedidos[oBrwPedido:nAt,5])), IF( aPedidos[oBrwPedido:nAt,7] == "B" , "BLOQUEADO" , "LIBERADO" ) }}
		oBrwPedido:bLDblClick := {|| AtuBrwPed(oBrwPedido:nAt,oBrwPedido) /*IF( aPedidos[oBrwPedido:nAt,7] == "B" , MsgInfo("Pedido Bloqueado, N„o È PossÌvel Seleciona-lo!!!!") , ( aPedidos[oBrwPedido:nAt,1] := !aPedidos[oBrwPedido:nAt,1] , oBrwPedido:Refresh() ) )*/ }
	Else
		MsgInfo("N„o Existe Pedido para este Fornecedor!!!")
	EndIF
EndIF

oPnlXML:= TPanel():New(010,250, "",oPnlscroll, NIL, .T., .F., NIL, NIL,420,340, .T., .F. )
oPnlXML:NCLRPANE := 14803406
IF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "nfe"
	@ 005,160 Say "VizualizaÁ„o da DANFE - " + STRZERO(VAL(oNoPrin:_INFNFE:_IDE:_NNF:TEXT),9) + " / " + oNoPrin:_INFNFE:_IDE:_SERIE:TEXT + "" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlXML
ElseIF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "envinfe"
	@ 005,160 Say "VizualizaÁ„o da DANFE - " + STRZERO(VAL(oNoPrin:_NFE:_INFNFE:_IDE:_NNF:TEXT),9) + " / " + oNoPrin:_NFE:_INFNFE:_IDE:_SERIE:TEXT + "" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlXML
Else
	@ 005,160 Say "VizualizaÁ„o da DANFE - " + STRZERO(VAL(oNoPrin:_NFE:_INFNFE:_IDE:_NNF:TEXT),9) + " / " + oNoPrin:_NFE:_INFNFE:_IDE:_SERIE:TEXT + "" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlXML
EndIF

// PAINEL COM AS INFORMACOES DO FORNECEDOR
oPnlIDE:= TPanel():New(015,010, "",oPnlXML, NIL, .T., .F., NIL, NIL,240,060, .T., .F. )
@ 005,085 Say "IdentificaÁ„o do Emitente"  		Size 200,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlIDE
@ 015,010 Say aDados[1]				  			Size 200,010 Font oFntInf				Pixel Of oPnlIDE
@ 025,010 Say aDados[2]				  			Size 200,010 Font oFntInf				Pixel Of oPnlIDE
@ 035,010 Say aDados[3]				  			Size 200,010 Font oFntInf				Pixel Of oPnlIDE
@ 045,010 Say aDados[4]				  			Size 200,010 Font oFntInf				Pixel Of oPnlIDE

// PAINEL COM AS INFORMACOES DA NOTA FISCAL
oPnlNF:= TPanel():New(080,010, "",oPnlXML, NIL, .T., .F., NIL, NIL,240,050, .T., .F. )
@ 005,085 Say "InformaÁıes da Nota Fiscal"		Size 400,010 Font oFnt Color CLR_BLUE 	Pixel Of oPnlNF
@ 015,010 Say "Chave de Acesso - " + cChaveNF 	Size 400,010 Font oFntInf 				Pixel Of oPnlNF
@ 025,010 Say aDados[5]				  			Size 400,010 Font oFntInf				Pixel Of oPnlNF
@ 035,010 Say aDados[6]				  			Size 400,010 Font oFntInf				Pixel Of oPnlNF

// PAINEL COM AS INFORMACOES DO DESTINATARIO
oPnlDest:= TPanel():New(135,010, "",oPnlXML, NIL, .T., .F., NIL, NIL,240,060, .T., .F. )
@ 005,085 Say "Destinat·rio / Remetente"		Size 400,010 Font oFnt Color CLR_BLUE 			Pixel Of oPnlDest

If nPos == 0
	@ 015,010 Say "CNPJ INEXISTENTE"				Size 400,010 Font oFntInf Color CLR_RED			Pixel Of oPnlDest
Else
	@ 015,010 Say aDados[7]    						Size 400,010 Font oFntInf 						Pixel Of oPnlDest
EndIf

@ 025,010 Say aDados[8]				  			Size 400,010 Font oFntInf			 			Pixel Of oPnlDest
@ 035,010 Say aDados[9]				  			Size 400,010 Font oFntInf			   			Pixel Of oPnlDest
@ 045,010 Say aDados[10]						Size 400,010 Font oFntInf			   			Pixel Of oPnlDest

// PAINEL COM AS INFORMACOES DE VALORES
oPnlVlr:= TPanel():New(015,260, "",oPnlXML, NIL, .T., .F., NIL, NIL,150,180, .T., .F. )
@ 005,050 Say "Impostos / InformaÁıes"				Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlVlr
@ 015,010 Say aDados[11]    						Size 400,010 Font oFntInf 					Pixel Of oPnlVlr
@ 025,010 Say aDados[12]    						Size 400,010 Font oFntInf 		   			Pixel Of oPnlVlr
@ 035,010 Say aDados[13]    						Size 400,010 Font oFntInf 		   			Pixel Of oPnlVlr
@ 045,010 Say aDados[14]    						Size 400,010 Font oFntInf 			  		Pixel Of oPnlVlr
@ 055,010 Say aDados[15]    						Size 400,010 Font oFntInf 			  		Pixel Of oPnlVlr
@ 065,010 Say aDados[16]    						Size 400,010 Font oFntInf 	  				Pixel Of oPnlVlr
@ 075,010 Say aDados[17]    						Size 400,010 Font oFntInf 			  		Pixel Of oPnlVlr
@ 085,010 Say aDados[20]    						Size 400,010 Font oFntInf 	 				Pixel Of oPnlVlr
@ 095,010 Say aDados[21]    						Size 400,010 Font oFntInf 	  				Pixel Of oPnlVlr
@ 105,010 Say aDados[22]    						Size 400,010 Font oFntInf 	  				Pixel Of oPnlVlr
@ 115,010 Say aDados[23]    						Size 400,010 Font oFntInf 					Pixel Of oPnlVlr
@ 125,010 Say aDados[24]    						Size 400,010 Font oFntInf 	   				Pixel Of oPnlVlr
@ 135,010 Say aDados[25]    						Size 400,010 Font oFntInf 	   				Pixel Of oPnlVlr
@ 145,010 Say aDados[26]    						Size 400,010 Font oFntInf 					Pixel Of oPnlVlr
@ 155,010 Say aDados[27]    						Size 400,010 Font oFntInf 			 		Pixel Of oPnlVlr
@ 165,010 Say aDados[28]    						Size 400,010 Font oFntInf 			 		Pixel Of oPnlVlr

// PAINEL COM AS INFORMACOES COMPLEMENTARES
oPnlIn:= TPanel():New(200,010, "",oPnlXML, NIL, .T., .F., NIL, NIL,400,055, .T., .F. )
@ 005,170 Say "InformaÁıes Complementares"			Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlIn
@ 012,010 Say aDados[29]    						Size 400,100 Font oFnt  					Pixel Of oPnlIn
@ 049,010 Say aDados[30]    						Size 400,010 Font oFnt						Pixel Of oPnlIn

If Len(aProdXML) > 0
	aSort(aProdXML,,,{|x,y| x[2] < y[2]})
	// BROWSE COM OS PRODUTOS
	oBrw:= TwBrowse():New(265,010,400,072,,{'Item','Cod.Produto','DescriÁ„o','NCM/SH','CST','CFOP','UN','Qtde.','Vlr.Unit','Vlr.Total','B.Calc.ICMS','Vlr.ICMS','Vlr.IPI','Aliq.ICMS','Aliq.IPI','Base Calc.IPI'},,oPnlXML,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrw:SetArray(aProdXML)
	oBrw:bLine := {|| {  	aProdXML[oBrw:nAt,01] ,;
	aProdXML[oBrw:nAt,02] ,;
	aProdXML[oBrw:nAt,03] ,;
	aProdXML[oBrw:nAt,04] ,;
	aProdXML[oBrw:nAt,05] ,;
	aProdXML[oBrw:nAt,06] ,;
	aProdXML[oBrw:nAt,07] ,;
	aProdXML[oBrw:nAt,08] ,;
	aProdXML[oBrw:nAt,09] ,;
	aProdXML[oBrw:nAt,10] ,;
	aProdXML[oBrw:nAt,11] ,;
	aProdXML[oBrw:nAt,12] ,;
	aProdXML[oBrw:nAt,13] ,;
	aProdXML[oBrw:nAt,14] ,;
	aProdXML[oBrw:nAt,15] ,;
	aProdXML[oBrw:nAt,16] }}
	oBrw:BHEADERCLICK := {|oObj,nCol| OrderCab(@oBrw, @lOrdem, nCol), oPnlXML:Refresh(), oBrw:Refresh() }
EndIF

IF lCLIENTE
	oBtnSair:= TButton():New( 320,010, "Liberar" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnSair:BLCLICKED:= {|| U_SYXMLA07() , nBtn := 10 , oTela:End() }
	
	oBtnRjt:= TButton():New( 337,010, "Rejeitar" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnRjt:BLCLICKED:= {|| IIF(MSGBLOQ(3),(nBtn := 2 , oTela:End()),)  }
	
	oBtnBlq:= TButton():New( 320,090, "Bloquear" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnBlq:BLCLICKED:= {|| IIF(MSGBLOQ(1),(nBtn := 2 , oTela:End()),)  }
	
	oBtnSair:= TButton():New( 337,090, "Sair" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnSair:BLCLICKED:= {|| nBtn := 4 , oTela:End()}
Else
	If Len(aPedidos) > 0
		oBtnAna:= TButton():New( 320,010, "Analisar" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
		oBtnAna:BLCLICKED:= {|| nBtn := 1 , oTela:End()}
	EndIF
	
	oBtnBlq:= TButton():New( 320,090, "Bloquear" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnBlq:BLCLICKED:= {|| IIF(MSGBLOQ(1),(nBtn := 2 , oTela:End()),)  }
	
	oBtnBlqPed:= TButton():New( 337,090, "Bloqueio s/ Pedido" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnBlqPed:BLCLICKED:= {|| IIF(MSGBLOQ(2),(nBtn := 2 , oTela:End()),)  }
	
	oBtnRjt:= TButton():New( 337,010, "Rejeitar" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnRjt:BLCLICKED:= {|| IIF(MSGBLOQ(3),(nBtn := 2 , oTela:End()),)  }
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ FAZ A LIBERACAO DO XML SEM PEDIDO VINCULADO ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	IF lLIBSPED
		oBtnSair:= TButton():New( 320,170, "Liberar s/ Pedido" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
		oBtnSair:BLCLICKED:= {|| U_SYXMLA07() , nBtn := 10 , oTela:End() }
	EndIF
	
	oBtnSair:= TButton():New( 337,170, "Sair" , oPnlscroll , {||},060,012, , , , .T. , , , , { ||})
	oBtnSair:BLCLICKED:= {|| nBtn := 4 , oTela:End()}
EndIF

ACTIVATE DIALOG oTela

IF nBtn = 1
	EVENTBTN(2)
ElseIF nBtn = 4
	EVENTBTN(1)
EndIF

RETURN()
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥ OrderCab ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Ordena as informacoes do grid                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function OrderCab(oBrw, lOrdem, nCol)

lOrdem := !lOrdem

IF lOrdem
	aSort( oBrw:AARRAY ,,, {|x,y| x[nCol] > y[nCol] } )
Else
	aSort( oBrw:AARRAY ,,, {|x,y| x[nCol] < y[nCol] } )
EndIf

Return(.T.)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ MSGBLOQ  ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Msg de Bloqueio ou Rejeicao sem Pedido                     ∫±±
±±∫          ≥ nOpc = 1 (BLOQUEIO)                                        ∫±±
±±∫          ≥ nOpc = 2 (REJEICAO)                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

STATIC FUNCTION MSGBLOQ(nOpc)

Local lMsg := .F.

If nOpc = 1
	IF MsgYesNo("Deseja Realmente Bloquear Este XML?","YESNO")
		Ma01Memo()
		lMsg := .T.
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "05"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
	EndIF
ElseIf nOpc = 2
	IF MsgYesNo("Deseja Realmente Bloquear Este XML Por Falta de Pedido?","YESNO")
		Ma01Memo()
		lMsg := .T.
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "08"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
	EndIf
ElseIf nOpc = 3
	IF MsgYesNo("Deseja Realmente Rejeitar Este XML?","YESNO")
		Ma01Memo()
		lMsg := .T.
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "06"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
	EndIF
EndIF

RETURN(lMsg)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ EVENTBTN ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Trata os eventos nos botoes da tela                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION EVENTBTN(nOpc)

Local cPEDOK   := ""
Local nIt      := 1
Local nUsado   := 0
Local nPos     := 0
Local lTRava   := .F.
Local oDesconto, oBtnCfm
Local aAltDesc := {}
Local aHdrDesc := {}
Local aPedDesc := {}
Local lPEDOK   := .T.
Local oGetDes

Begin Transaction

IF nOpc = 1   // SAIR
	RecLock("Z31",.F.)
	Z31->Z31_STATUS := "02"
	Z31->Z31_USER   := ALLTRIM(cUserName)
	Z31->Z31_DTLOG  := dDataBase
	Z31->Z31_HRLOG  := Time()
	MsUnlock()
	MsgInfo("Status da DANFE " + Z31->Z31_NUM + " - " + Z31->Z31_SERIE + " foi alterado para 'EM BERTO' ! ")
ElseIF nOpc = 2  // ANALISAR
	aVisuPed := {}
	For nY:=1 To Len(aPedidos)
		If aPedidos[nY,1]
			aAdd( aVisuPed , { ALLTRIM(STR(nIt)), aPedidos[nY,2], aPedidos[nY,3], aPedidos[nY,4], aPedidos[nY,5]})
			nIt++
		EndIF
	Next
	If Len(aVisuPed) > 0
		VLDDANFE()
	Else
		MsgInfo("Por Favor, Selecione ao Menos um Pedido!")
	EndIF
ElseIF nOpc = 3 // LIBERAR
	IF MsgYesNo("Confirma a LIBERA«√O da DANFE? ","YESNO")
		
		cqry := " SELECT * FROM"  + RETSQLNAME('Z34')
		cqry += " WHERE Z34_FILIAL = '" + XFILIAL("Z34") + "'"
		cqry += " AND Z34_CHAVE = '" + Z31->Z31_CHAVE  + "' "
		
		If Select("TRB") > 0
			TRB->(DbCloseArea())
		EndIf
		
		cqry := ChangeQuery(cqry)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cqry),"TRB",.F.,.T.)
		
		Z34->(DbClosearea("Z34"))
		DbSelectarea("Z34")
		Z34->(DBSetOrder(1))
		While TRB->(!EOF())
			IF Z34->(DbSeek(xFilial("Z34") + TRB->Z34_PEDIDO + TRB->Z34_CHAVE))
				Z34->(RecLock("Z34",.F.))
				Z34->(dbDelete())
				Z34->(MsUnlock())
			ENDIF
			
			TRB->(DBSKIP())
		ENDDO
		
		/*
		For nZ:=1 To Len(oGetCat:ACOLS)
		IF EMPTY(oGetCat:ACOLS[nZ,1])
		lTRava := .T.
		ElseIF oGetCat:ACOLS[nZ,6] = 0
		lTRava := .T.
		ElseIF EMPTY(oGetCat:ACOLS[nZ,19])
		lTRava := .T.
		ElseIF EMPTY(oGetCat:ACOLS[nZ,20])
		lTRava := .T.
		EndIF
		Next
		*/
		For nZ:=1 To Len(oGetCat:ACOLS)
			IF EMPTY(oGetCat:ACOLS[nZ,1])
				lTRava := .T.
			ElseIF oGetCat:ACOLS[nZ,6] = 0
				lTRava := .T.
			EndIF
		Next
		If lTrava
			MsgInfo("Por Favor, Preencher os campos 'PEDIDO' , 'CUSTO REAL' de todos os produtos da DANFE!!!")
			RecLock("Z31",.F.)
			Z31->Z31_STATUS := "02"
			Z31->Z31_USER   := ALLTRIM(cUserName)
			Z31->Z31_DTLOG  := dDataBase
			Z31->Z31_HRLOG  := Time()
			MsUnlock()
		Else
			Z31->(RecLock("Z31",.F.))
			Z31->Z31_STATUS := "04"
			Z31->Z31_USER   := ALLTRIM(cUserName)
			Z31->Z31_DTLOG  := dDataBase
			Z31->Z31_HRLOG  := Time()
			Z31->Z31_VLRTOT := VAL(aValores[1])
			Z31->Z31_BICMS  := VAL(aValores[2])
			Z31->Z31_VALICM := VAL(aValores[3])
			Z31->Z31_BASIPI := VAL(aValores[4])
			Z31->Z31_VLRIPI := VAL(aValores[5])
			Z31->Z31_DESCON := VAL(aValores[6])
			Z31->Z31_BICMST := VAL(aValores[7])
			Z31->Z31_VICMST := VAL(aValores[8])
			Z31->Z31_ESTATU := "01"
			Z31->Z31_QTDTOT := _nQuant
			Z31->(MsUnlock())
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ Grava as informacoes PEDIDO X PRODUTO DANFE na tabela Z34 ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			DbSelectArea("Z34")
			Z34->(DbSetOrder(1))
			Z34->(DbGoTop())
			For nY:=1 To Len(oGetCat:ACOLS)
				For nOK := 1 To Len(ALLTRIM(oGetCat:ACOLS[nY,1]))
					IF nOK = Len(ALLTRIM(oGetCat:ACOLS[nY,1]))
						cPEDOK += SUBSTR(ALLTRIM(oGetCat:ACOLS[nY,1]),nOK,1)
						IF !(Z34->(DbSeek(xFilial("Z34") + cPEDOK + oGetCat:ACOLS[nY,2] )))
							
							nPos := aScan( aProdutos , { |x| ALLTRIM(x[1]) == ALLTRIM(cPEDOK) } )
							
							Z34->(RecLock("Z34",.T.))
							Z34->Z34_FILIAL := xFilial("Z34")
							for nt:= 1 to len(aPedidos)
								IF apedidos[nt,1] == .T.
									Z34->Z34_PEDIDO := aPedidos[nt,2]
								end if
							next
							
							Z34->Z34_CHAVE  := Z31->Z31_CHAVE
							Z34->Z34_NFDANF := Z31->Z31_NUM
							Z34->Z34_SRDANF := Z31->Z31_SERIE
							Z34->Z34_COD    := oGetCat:ACOLS[nY,2]
							Z34->Z34_DESCRI := oGetCat:ACOLS[nY,3]
							//Z34->Z34_QUANT  := aProdutos[nPos,5] //IIF(lPEDOK,oGetCat:ACOLS[nY,4],0)
							Z34->Z34_QUANT  := IIF(lPEDOK,oGetCat:ACOLS[nY,4],0)
							Z34->Z34_VUNIT  := IIF(lPEDOK,oGetCat:ACOLS[nY,5],0)
							Z34->Z34_CUSTRE := oGetCat:ACOLS[nY,6]
							Z34->Z34_VLRTOT := (Z34->Z34_QUANT * Z34->Z34_VUNIT ) //IIF(lPEDOK,oGetCat:ACOLS[nY,7],0)
							Z34->Z34_NCM    := oGetCat:ACOLS[nY,8]
							Z34->Z34_CST    := oGetCat:ACOLS[nY,9]
							Z34->Z34_CFOP   := oGetCat:ACOLS[nY,10]
							Z34->Z34_BICMS  := IIF(VAL(oGetCat:ACOLS[nY,11])=0,0,Z34->Z34_VLRTOT)
							Z34->Z34_ALQICM := IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,12]),0)
							Z34->Z34_VICMS  := ((Z34->Z34_BICMS * Z34->Z34_ALQICM )/100) //IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,13]),0)
							Z34->Z34_BASIPI := IIF(VAL(oGetCat:ACOLS[nY,14])=0,0,Z34->Z34_VLRTOT)//IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,14]),0)
							Z34->Z34_VLRIPI := ((Z34->Z34_BICMS * Z34_ALQIPI)/100) //IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,15]),0)
							Z34->Z34_ALQIPI := IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,16]),0)
							Z34->Z34_UN     := aProdutos[nPos,4]
							Z34->Z34_ITEM	:= ALLTRIM(cPEDOK)
							Z34->Z34_PEDPRO := aProdutos[nPos,2]
							Z34->Z34_LOCAL  := aProdutos[nPos,7]
							Z34->Z34_TES    := aProdutos[nPos,8]
							Z34->Z34_LOTE   := oGetCat:ACOLS[nY,19]
							Z34->Z34_DTVALI := oGetCat:ACOLS[nY,20]
							
							//IF lUSACONV
							//Z34->Z34_QTDCON := QTDCONV(Z34->Z34_COD,Z34->Z34_QUANT,Z31->Z31_CODFOR,Z31->Z31_LJFOR)
							//EndIF
							Z34->(MsUnlock())
							
						Else
							MsgInfo("J· existe informaÁıes (DANFE x PRODUTOS X PEDIDOS) liberadas!!!")
						EndIF
						
						//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
						//≥ Grava as informacoes da DANFE e do Pedido na tabela Z32 ≥
						//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
						DbSelectArea("Z32")
						Z32->(DbSetOrder(1))
						Z32->(DbGoTop())
						IF !(Z32->(DbSeek(xFilial("Z32") + Z31->Z31_CHAVE + Z31->Z31_LJDEST + aPedidos[1,2])))
							Z32->(RecLock("Z32",.T.))
							Z32->Z32_FILIAL := xFilial("Z32")
							Z32->Z32_CHAVE  := Z31->Z31_CHAVE
							Z32->Z32_NUM    := Z31->Z31_NUM
							Z32->Z32_SERIE  := Z31->Z31_SERIE
							Z32->Z32_FORNEC := Z31->Z31_CODFOR
							Z32->Z32_LJFORN := Z31->Z31_LJFOR
							Z32->Z32_LJDEST := Z31->Z31_LJDEST
							for nt:= 1 to len(aPedidos)
								IF apedidos[nt,1] == .T.
									Z32->Z32_PEDIDO := aPedidos[nt,2]
								end if
							next
							
							Z32->(MsUnlock())
						EndIF
						cPEDOK := ""
					ELSEIF SUBSTR(ALLTRIM(oGetCat:ACOLS[nY,1]),nOK,1) <> "/"
						cPEDOK += SUBSTR(ALLTRIM(oGetCat:ACOLS[nY,1]),nOK,1)
					Else
						
						IF !(Z34->(DbSeek(xFilial("Z34") + cPEDOK + oGetCat:ACOLS[nY,2] )))
							
							nPos := aScan( aProdutos , { |x| ALLTRIM(x[1]) == ALLTRIM(cPEDOK) } )
							
							Z34->(RecLock("Z34",.T.))
							Z34->Z34_FILIAL := xFilial("Z34")
							for nt:= 1 to len(aPedidos)
								IF apedidos[nt,1] == .T.
									Z34->Z34_PEDIDO := aPedidos[nt,2]
								end if
							next
							Z34->Z34_CHAVE  := Z31->Z31_CHAVE
							Z34->Z34_NFDANF := Z31->Z31_NUM
							Z34->Z34_SRDANF := Z31->Z31_SERIE
							Z34->Z34_COD    := oGetCat:ACOLS[nY,2]
							Z34->Z34_DESCRI := oGetCat:ACOLS[nY,3]
							//Z34->Z34_QUANT  := aProdutos[nPos,5]//IIF(lPEDOK,oGetCat:ACOLS[nY,4],0)
							Z34->Z34_QUANT  := IIF(lPEDOK,oGetCat:ACOLS[nY,4],0)
							Z34->Z34_VUNIT  := IIF(lPEDOK,oGetCat:ACOLS[nY,5],0)
							Z34->Z34_CUSTRE := oGetCat:ACOLS[nY,6]
							Z34->Z34_VLRTOT := (Z34->Z34_QUANT * Z34->Z34_VUNIT )
							Z34->Z34_NCM    := oGetCat:ACOLS[nY,8]
							Z34->Z34_CST    := oGetCat:ACOLS[nY,9]
							Z34->Z34_CFOP   := oGetCat:ACOLS[nY,10]
							Z34->Z34_BICMS  := IIF(VAL(oGetCat:ACOLS[nY,11])=0,0,Z34->Z34_VLRTOT)//IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,11]),0)
							Z34->Z34_ALQICM := IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,12]),0)
							Z34->Z34_VICMS  := ((Z34->Z34_BICMS * Z34->Z34_ALQICM )/100) //IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,13]),0)
							Z34->Z34_BASIPI := IIF(VAL(oGetCat:ACOLS[nY,14])=0,0,Z34->Z34_VLRTOT)//IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,14]),0)
							Z34->Z34_VLRIPI := ((Z34->Z34_BICMS * Z34_ALQIPI)/100)//IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,15]),0)
							Z34->Z34_ALQIPI := IIF(lPEDOK,VAL(oGetCat:ACOLS[nY,16]),0)
							Z34->Z34_UN     := aProdutos[nPos,4]
							Z34->Z34_ITEM	:= ALLTRIM(cPEDOK)
							Z34->Z34_PEDPRO := aProdutos[nPos,2]
							Z34->Z34_LOCAL  := aProdutos[nPos,7]
							Z34->Z34_TES    := aProdutos[nPos,8]
							Z34->Z34_LOTE   := oGetCat:ACOLS[nY,19]
							Z34->Z34_DTVALI := oGetCat:ACOLS[nY,20]
							
							//IF lUSACONV
							//Z34->Z34_QTDCON := QTDCONV(Z34->Z34_COD,Z34->Z34_QUANT,Z31->Z31_CODFOR,Z31->Z31_LJFOR)
							//EndIF
							Z34->(MsUnlock())
							lPEDOK := .T.
						Else
							MsgInfo("J· existe informaÁıes (DANFE x PRODUTOS X PEDIDOS) liberadas!!!")
						EndIF
						
						//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
						//≥ Grava as informacoes da DANFE e do Pedido na tabela Z32 ≥
						//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
						DbSelectArea("Z32")
						Z32->(DbSetOrder(1))
						Z32->(DbGoTop())
						IF !(Z32->(DbSeek(xFilial("Z32") + Z31->Z31_CHAVE + Z31->Z31_LJDEST + aPedidos[1,2])))
							Z32->(RecLock("Z32",.T.))
							Z32->Z32_FILIAL := xFilial("Z32")
							Z32->Z32_CHAVE  := Z31->Z31_CHAVE
							Z32->Z32_NUM    := Z31->Z31_NUM
							Z32->Z32_SERIE  := Z31->Z31_SERIE
							Z32->Z32_FORNEC := Z31->Z31_CODFOR
							Z32->Z32_LJFORN := Z31->Z31_LJFOR
							Z32->Z32_LJDEST := Z31->Z31_LJDEST
							for nt:= 1 to len(aPedidos)
								IF apedidos[nt,1] == .T.
									Z32->Z32_PEDIDO := aPedidos[nt,2]
								end if
							next
							Z32->(MsUnlock())
						EndIF
						cPEDOK := ""
					EndIF
				Next
				lPEDOK := .T.
			Next
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥VALIDA SE VAI SER CRIADA A PRE-NOTA DE ENTRADA OU NAO ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			IF lVLDPNF
				IF MsgYesNo("Deseja Criar o Documento de PrÈ-Nota de Entrada? ","YESNO")
					U_SYXMLA05(Z31->Z31_CHAVE)
				EndIF
			EndIF
		EndIF
	Else
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "02"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
		MsgInfo("Status da DANFE " + Z31->Z31_NUM + " - " + Z31->Z31_SERIE + " foi alterado para 'EM BERTO' ! ")
	EndIF
ElseIF nOpc = 4
	IF MsgYesNo("Confirma a RejeiÁ„o da DANFE? ","YESNO")
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "06"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
		Ma01Memo()
	EndIF
ElseIF nOpc = 5
	IF MsgYesNo("Deseja Bloquear a DANFE? ","YESNO")
		RecLock("Z31",.F.)
		Z31->Z31_STATUS := "05"
		Z31->Z31_USER   := ALLTRIM(cUserName)
		Z31->Z31_DTLOG  := dDataBase
		Z31->Z31_HRLOG  := Time()
		MsUnlock()
		Ma01Memo()
	EndIF
EndIF

End Transaction

RETURN()

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ VLDDANFE ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Tela de analise DANFE X PEDIDOS (ultima tela)              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION VLDDANFE()

Local nUsado     := 0							//Linhas do acols
Local aHeader 	 := {}
Local aAlterZ34  := {}
Local oPnlVsi
Local oPnlPEDIDO, oPnlIDE, oPnlNF, oPnlDest, oPnlVlr, oPnlIn, oBrw, oBrwPedido, oSclAna, oPnlScrAna
Local oBtnSair, oBtnLib, oBtnRej, oBtnBloq, oBtnPed, oBtnXML, oBtnDfz, oBtnCond, oBtnBijux , oBtnAmos

Local cNumPed 	  := ""
Local cDtEmis 	  := ""
Local cDtEnt  	  := ""
Local cForne  	  := ""
Local cRazao  	  := ""
Local cFanta  	  := ""
Local cCNPJ   	  := ""
Local cEnde   	  := ""
Local cRepres 	  := ""
Local cMail   	  := ""
Local cProd   	  := ""
Local cCont   	  := ""
Local cMaMemo     := ""
Local cCondPag    := ""
Local cAcresc     := ""
Local cDesc       := ""
Local cImgAmos    := ""
Local nUsado      := 0
Local nBtn        := 8
Local lBijux      := .F.
Local aHdrAdd	  := {}
Local nQntLin	  := 0
Local nCnt		  := 0
Local nPula		  := 0

Private oPnlDanfe, oTGet1, oTGet2
Private aPnlBut     := {}
Private aHdrProd    := {}
Private aItPed      := {}
Private oPnlBut,oTelVLDDANFE

aAlterZ34  := {"Z34_PEDIDO","Z34_CUSTRE","Z34_LOTE","Z34_DTVALI"}

DEFINE MSDIALOG oTelVLDDANFE FROM 0,0 TO aSize[6] + 050,aSize[5] TITLE "Pedidos X XML" Of oMainWnd PIXEL

oSclAna := TScrollArea():New(oTelVLDDANFE,01,01,100,100,.T.,.T.,.T.)
oSclAna:Align := CONTROL_ALIGN_ALLCLIENT

@ 000,000 MSPANEL oPnlScrAna OF oSclAna SIZE 2150,2150
oSclAna:SetFrame( oPnlScrAna )


oTelVLDDANFE:lEscClose := .F.

oPnlPEDIDO:= TPanel():New(010,010, "",oPnlScrAna, NIL, .T., .F., NIL, NIL,225,300, .T., .F. )
oPnlPEDIDO:NCLRPANE := 14803406
@ 005,085 Say "Pedidos Selecionados"Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlPEDIDO

oBrwPedido:= TWBrowse():New(015,005,210,065,,{"","Numero","Qtde.Total","Dt.Emiss„o","Dt.Entrega"},,oPnlPEDIDO,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwPedido:SetArray(aVisuPed)
oBrwPedido:bLine   := {|| { aVisuPed[oBrwPedido:nAt,1], aVisuPed[oBrwPedido:nAt,2], Transform(aVisuPed[oBrwPedido:nAt,3]  , "@E 9999,9999"), DTOC(STOD(aVisuPed[oBrwPedido:nAt,4])), DTOC(STOD(aVisuPed[oBrwPedido:nAt,5])) }}

// PAINEL DE DETALHES DO PEDIDO
oPnlBut:= TPanel():New(082,005, "",oPnlPEDIDO, NIL, .T., .F., NIL, NIL,210,212, .T., .F. )
@ 002,075 Say "Detalhes do Pedido"Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlBut

aAdd( aPnlBut , "Num.Pedido : " + ALLTRIM(aVisuPed[oBrwPedido:nAt,2]))

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
SC7->(DbGoTop())
SC7->(DbSeek(xFilial("SC7") + aVisuPed[oBrwPedido:nAt,2]))

DbSelectArea("SA2")
SA2->(DbSetOrder(1))
SA2->(DbGoTop())
SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ))

//DbSelectArea("ZAA")
//ZAA->(DbSetOrder(1))
//ZAA->(DbGoTop())
//ZAA->(DbSeek(xFilial("ZAA") + SC7->C7_FORNECE + SC7->C7_LOJA ))

aAdd( aPnlBut , "Dt.Emiss„o - "    		+ DTOC(SC7->C7_EMISSAO))
aAdd( aPnlBut , "Dt.Entrega : "    		+ DTOC(SC7->C7_DATPRF) + " atÈ " + DTOC(SC7->C7_DATPRF))
aAdd( aPnlBut , "Fornecedor :  "   		+ ALLTRIM(SC7->C7_FORNECE) + " / " + ALLTRIM(SC7->C7_LOJA))
aAdd( aPnlBut , "Raz„o Rocial : "  		+ ALLTRIM(SA2->A2_NOME))
aAdd( aPnlBut , "Contato : "       		+ ALLTRIM(SA2->A2_CONTATO))
aAdd( aPnlBut , "N.Fantasia : "    		+ ALLTRIM(SA2->A2_NREDUZ))
aAdd( aPnlBut , "e-Mail : "        		+ ALLTRIM(SA2->A2_EMAIL))
aAdd( aPnlBut , "End. : "          		+ ALLTRIM(SA2->A2_END) + " , " + ALLTRIM(SA2->A2_NR_END) + " , CEP " + ALLTRIM(SA2->A2_CEP) + " , " + ALLTRIM(SA2->A2_BAIRRO) + " , " + ALLTRIM(SA2->A2_MUN) + " , " + ALLTRIM(SA2->A2_ESTADO))
aAdd( aPnlBut , "CNPJ : "          		+ ALLTRIM(SA2->A2_CGC))
aAdd( aPnlBut , "Repres. : "       		+ ALLTRIM(SA2->A2_REPRES))
aAdd( aPnlBut , "Produto - "       		+ LEFT(ALLTRIM(SC7->C7_PRODUTO),9) + " - " + ALLTRIM(SC7->C7_DESCRI))
aAdd( aPnlBut , "Regra Fornecedor %"     )
aAdd( aPnlBut , "")
aAdd( aPnlBut , "")

@ 005, 002 SAY REPLICATE("-",160) FONT oFnt SIZE 200,005 PIXEL OF oPnlBut
@ 010, 002 MSGET oNumPed  VAR aPnlBut[01]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 010, 120 MSGET oDtEmis  VAR aPnlBut[02]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 020, 120 MSGET oDtEnt   VAR aPnlBut[03]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 020, 002 MSGET oForne   VAR aPnlBut[04]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 030, 002 MSGET oRazao   VAR aPnlBut[05]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 030, 120 MSGET oCont    VAR aPnlBut[06]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 040, 002 MSGET oFanta   VAR aPnlBut[07]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 040, 120 MSGET oMail    VAR aPnlBut[08]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 050, 002 MSGET oEnde    VAR aPnlBut[09]  	OF oPnlBut SIZE 200,010 FONT oFnt When .F. PIXEL NOBORDER
@ 060, 002 MSGET oCNPJ    VAR aPnlBut[10]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 060, 120 MSGET oRepres  VAR aPnlBut[11]  	OF oPnlBut SIZE 100,010 FONT oFnt When .F. PIXEL NOBORDER
@ 070, 002 SAY REPLICATE("-",160) FONT oFnt SIZE 200,005 PIXEL OF oPnlBut

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aHeader a partir dos campos do SX3         	 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SC7")
While !Eof() .And. (X3_ARQUIVO == "SC7")
	IF AllTrim(SX3->X3_CAMPO) $ ("C7_ITEM/C7_PRODUTO/C7_DESCRI/C7_UM/C7_QUANT/C7_PRECO/C7_TOTAL/C7_IPI/C7_DATPRF/C7_DESC1/C7_EMISSAO/C7_QUJE/C7_VLDESC/C7_VALIPI/C7_VALICM/C7_DESC/C7_PICM/C7_LOCAL/C7_TES")
		nUsado++
		Aadd(aHdrProd,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN })
	EndIF
	SX3->(DbSkip())
EndDo

aHdrProd := ORDBRW(aHdrProd)

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
SC7->(DbGoTop())
SC7->(DbSeek(xFilial("SC7") + aVisuPed[oBrwPedido:nAt,2]))
aAdd( aPnlBut , "CondiÁ„o de Pagamento - " + SC7->C7_COND + " / " + Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI"))
While !SC7->(EOF()) .AND. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aVisuPed[oBrwPedido:nAt,2])
	If lCampoFil
		IF ALLTRIM(SC7->C7_01FILDE) = ALLTRIM(cLjPed)
			//aAdd(aProdutos , { SC7->C7_ITEM , SC7->C7_PRODUTO , SC7->C7_UM, SC7->C7_QUANT , SC7->C7_PRECO , SC7->C7_TOTAL  , SC7->C7_IPI , SC7->C7_DATPRF , SC7->C7_DESC1, SC7->C7_EMISSAO ,SC7->C7_QUJE,SC7->C7_DESCRI, SC7->C7_VLDESC , SC7->C7_VALIPI , SC7->C7_VALICM , SC7->C7_DESC , SC7->C7_PICM, SC7->C7_LOCAL ,.F. } )
			aAdd( aProdutos , { ;
			SC7->C7_ITEM 		,;
			SC7->C7_PRODUTO 	,;
			SC7->C7_DESCRI		,;
			SC7->C7_UM			,;
			SC7->C7_QUANT		,;
			SC7->C7_QUJE		,;
			SC7->C7_LOCAL		,;
			SC7->C7_TES 		,;
			SC7->C7_PRECO		,;
			SC7->C7_TOTAL		,;
			SC7->C7_VLDESC		,;
			SC7->C7_EMISSAO 	,;
			SC7->C7_DATPRF		,;
			SC7->C7_IPI			,;
			SC7->C7_VALIPI		,;
			SC7->C7_PICM		,;
			SC7->C7_VALICM      })
		EndIF
	Else
		IF ALLTRIM(SC7->C7_FILENT) = ALLTRIM(cLjPed)
			//aAdd(aProdutos , { SC7->C7_ITEM , SC7->C7_PRODUTO , SC7->C7_UM, SC7->C7_QUANT , SC7->C7_PRECO , SC7->C7_TOTAL  , SC7->C7_IPI , SC7->C7_DATPRF , SC7->C7_DESC1, SC7->C7_EMISSAO ,SC7->C7_QUJE,SC7->C7_DESCRI, SC7->C7_VLDESC , SC7->C7_VALIPI , SC7->C7_VALICM , SC7->C7_DESC , SC7->C7_PICM, SC7->C7_LOCAL ,.F. } )
			aAdd( aProdutos , { ;
			SC7->C7_ITEM 		,;
			SC7->C7_PRODUTO 	,;
			SC7->C7_DESCRI		,;
			SC7->C7_UM			,;
			SC7->C7_QUANT		,;
			SC7->C7_QUJE		,;
			SC7->C7_LOCAL		,;
			SC7->C7_TES 		,;
			SC7->C7_PRECO		,;
			SC7->C7_TOTAL		,;
			SC7->C7_VLDESC		,;
			SC7->C7_EMISSAO 	,;
			SC7->C7_DATPRF		,;
			SC7->C7_IPI			,;
			SC7->C7_VALIPI		,;
			SC7->C7_PICM		,;
			SC7->C7_VALICM      })
		EndIF
	EndIF
	SC7->(DbSkip())
EndDo

oGetDados:= MsNewGetDados():New(090,000,150,210,0,,,,,,,,,,oPnlBut,aHdrProd,aProdutos)
oGetDados:oBrowse:Refresh()

@ 150, 075 Say "ObservaÁıes do Pedido" Size 200,010 FONT oFnt Color CLR_BLUE Pixel Of oPnlBut
@ 155, 002 SAY REPLICATE("-",160) FONT oFnt SIZE 200,005 PIXEL OF oPnlBut
@ 160, 002 MSGET oMemo    VAR aPnlBut[13]    OF oPnlBut SIZE 200,010 FONT oFnt When .F. PIXEL NOBORDER
@ 170, 002 MSGET oAcresc  VAR aPnlBut[14]    OF oPnlBut SIZE 200,010 FONT oFnt When .F. PIXEL NOBORDER
@ 180, 002 MSGET oDesc    VAR aPnlBut[15]    OF oPnlBut SIZE 200,010 FONT oFnt When .F. PIXEL NOBORDER
@ 190, 002 MSGET oCondPag VAR aPnlBut[16]    OF oPnlBut SIZE 200,010 FONT oFnt When .F. PIXEL NOBORDER

oBrwPedido:bChange := {|| AtuPanel(aVisuPed[oBrwPedido:nAt,2]) }

oPnlDanfe:= TPanel():New(010,250, "",oPnlScrAna, NIL, .T., .F., NIL, NIL,420,340, .T., .F. )
oPnlDanfe:NCLRPANE := 14803406

IF ALLTRIM(LOWER(oNoPrin:REALNAME)) == "nfe"
	@ 005,160 Say "VizualizaÁ„o da DANFE - " + STRZERO(VAL(oNoPrin:_INFNFE:_IDE:_NNF:TEXT),9) + " / " + oNoPrin:_INFNFE:_IDE:_SERIE:TEXT + "" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlDanfe
Else
	@ 005,160 Say "VizualizaÁ„o da DANFE - " + STRZERO(VAL(oNoPrin:_NFE:_INFNFE:_IDE:_NNF:TEXT),9) + " / " + oNoPrin:_NFE:_INFNFE:_IDE:_SERIE:TEXT + "" Size 200,010 Font oFntTit Color CLR_BLUE Pixel Of oPnlDanfe
EndIF

// PAINEL COM AS INFORMACOES DO FORNECEDOR
oPnlIDE:= TPanel():New(015,010, "",oPnlDanfe, NIL, .T., .F., NIL, NIL,240,060, .T., .F. )
@ 005,085 Say "IdentificaÁ„o do Emitente"  		Size 200,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlIDE
@ 015,010 Say aDados[1]				  			Size 200,010 Font oFntInf					Pixel Of oPnlIDE
@ 025,010 Say aDados[2]				  			Size 200,010 Font oFntInf					Pixel Of oPnlIDE
@ 035,010 Say aDados[3]				  			Size 200,010 Font oFntInf					Pixel Of oPnlIDE
@ 045,010 Say aDados[4]				  			Size 200,010 Font oFntInf					Pixel Of oPnlIDE

// PAINEL COM AS INFORMACOES DA NOTA FISCAL
oPnlNF:= TPanel():New(080,010, "",oPnlDanfe, NIL, .T., .F., NIL, NIL,240,050, .T., .F. )
@ 005,085 Say "InformaÁıes da Nota Fiscal"		Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlNF
@ 015,010 Say "Chave de Acesso - " + cChaveNF 	Size 400,010 Font oFntInf 					Pixel Of oPnlNF
@ 025,010 Say aDados[5]				  			Size 400,010 Font oFntInf					Pixel Of oPnlNF
@ 035,010 Say aDados[6]				  			Size 400,010 Font oFntInf					Pixel Of oPnlNF

// PAINEL COM AS INFORMACOES DO DESTINATARIO
oPnlDest:= TPanel():New(135,010, "",oPnlDanfe, NIL, .T., .F., NIL, NIL,240,060, .T., .F. )
@ 005,085 Say "Destinat·rio / Remetente"		Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlDest
@ 015,010 Say aDados[7]    						Size 400,010 Font oFntInf 					Pixel Of oPnlDest
@ 025,010 Say aDados[8]				  			Size 400,010 Font oFntInf					Pixel Of oPnlDest
@ 035,010 Say aDados[9]				  			Size 400,010 Font oFntInf					Pixel Of oPnlDest
@ 045,010 Say aDados[10]						Size 400,010 Font oFntInf					Pixel Of oPnlDest

// PAINEL COM AS INFORMACOES DE VALORES
oPnlVlr:= TPanel():New(015,260, "",oPnlDanfe, NIL, .T., .F., NIL, NIL,150,180, .T., .F. )
@ 005,050 Say "Impostos / InformaÁıes"				Size 400,010 Font oFnt Color CLR_BLUE	Pixel Of oPnlVlr
@ 015,010 Say aDados[11]    						Size 400,010 Font oFntInf 				Pixel Of oPnlVlr
@ 025,010 Say aDados[12]    						Size 400,010 Font oFntInf 		   		Pixel Of oPnlVlr
@ 035,010 Say aDados[13]    						Size 400,010 Font oFntInf 		   		Pixel Of oPnlVlr
@ 045,010 Say aDados[14]    						Size 400,010 Font oFntInf 				Pixel Of oPnlVlr
@ 055,010 Say aDados[15]    						Size 400,010 Font oFntInf 				Pixel Of oPnlVlr
@ 065,010 Say aDados[16]    						Size 400,010 Font oFntInf 	  			Pixel Of oPnlVlr
@ 075,010 Say aDados[17]    						Size 400,010 Font oFntInf 			  	Pixel Of oPnlVlr
@ 085,010 Say aDados[20]    						Size 400,010 Font oFntInf 	 			Pixel Of oPnlVlr
@ 095,010 Say aDados[21]    						Size 400,010 Font oFntInf 	  			Pixel Of oPnlVlr
@ 105,010 Say aDados[22]    						Size 400,010 Font oFntInf 	  			Pixel Of oPnlVlr
@ 115,010 Say aDados[23]    						Size 400,010 Font oFntInf 				Pixel Of oPnlVlr
@ 125,010 Say aDados[24]    						Size 400,010 Font oFntInf 	   			Pixel Of oPnlVlr
@ 135,010 Say aDados[25]    						Size 400,010 Font oFntInf 	   			Pixel Of oPnlVlr
@ 145,010 Say aDados[26]    						Size 400,010 Font oFntInf 				Pixel Of oPnlVlr
@ 155,010 Say aDados[27]    						Size 400,010 Font oFntInf 			 	Pixel Of oPnlVlr
@ 165,010 Say aDados[28]    						Size 400,010 Font oFntInf 			 	Pixel Of oPnlVlr

// PAINEL COM AS INFORMACOES COMPLEMENTARES
oPnlIn:= TPanel():New(200,010, "",oPnlDanfe, NIL, .T., .F., NIL, NIL,400,055, .T., .F. )
@ 005,170 Say "InformaÁıes Complementares"			Size 400,010 Font oFnt Color CLR_BLUE 		Pixel Of oPnlIn
@ 012,010 Say aDados[29]    						Size 400,100 Font oFnt  					Pixel Of oPnlIn
@ 049,010 Say aDados[30]    						Size 400,010 Font oFnt						Pixel Of oPnlIn

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aHeader a partir dos campos do SX3         	 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("Z34")
While !Eof() .And. (X3_ARQUIVO == "Z34")
	IF AllTrim(SX3->X3_CAMPO) $ ("Z34_PEDIDO/Z34_COD/Z34_DESCRI/Z34_QUANT/Z34_VUNIT/Z34_CUSTRE/Z34_VLRTOT/Z34_NCM/Z34_CST/Z34_CFOP/Z34_BICMS/Z34_ALQICM/Z34_VICMS/Z34_BASIPI/Z34_VLRIPI/Z34_ALQIPI/Z34_UN/Z34_PEDPRO/Z34_LOTE/Z34_DTVALI")
		nUsado++
		Aadd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN })
		
		IF AllTrim(SX3->X3_CAMPO) $ ("Z34_PEDIDO/Z34_CUSTRE")
			M->&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO)
		EndIF
	ENDIF
	SX3->(DbSkip())
EndDo

If Len(aHeader) > 0
	_nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "Z34_CUSTRE"})
	
	If _nPos > 0
		aHeader[_nPos,6] := "U_Z34Totais('C')"
	EndIf
EndIf

For nY:=1 To Len(aProdXML)
	aAdd( aClone, { M->Z34_PEDIDO			,;		// NUMERO DO PEDIDO
	aProdXML[nY,2]		,; 		// CODIGO DO PRODUTO (FORNECEDOR)
	aProdXML[nY,3]		,;		// DESCRICAO DO PRODUTO (FORNECEDOR)
	VAL(aProdXML[nY,8])		,; 		// QUANTIDADE
	VAL(aProdXML[nY,9])		,;		// VALOR UNITARIO DO PRODUTO
	VAL(aProdXML[nY,9])       ,;      // CUSTO REAL DO PRODUTO
	VAL(aProdXML[nY,10])		,;		// VALOR TOTAL DO PRODUTO
	aProdXML[nY,4]		,; 		// NCM DO PRODUTO
	aProdXML[nY,5]		,; 		// CST DO PRODUTO
	aProdXML[nY,6]		,; 		// CFOP DO PRODUTO
	aProdXML[nY,11]		,;		// BASE DE CALCULO DO ICMS
	aProdXML[nY,14]		,;		// ALIQUOTA DE CALCULO DE ICMS
	aProdXML[nY,12]		,; 		// VALOR DO ICMS
	aProdXML[nY,16]		,; 		// BASE DE CALCULO IPI
	aProdXML[nY,13]		,; 		// VALOR DO IPI
	aProdXML[nY,15]		,; 		// ALIQUOTA DE CALCULO DE IPI
	aProdXML[nY,7]		,; 		// UNIDADE DE MEDIDA
	""           		,; 		// CODIGO PRODUTO
	SPACE(20)          		,; 		// LOTE
	CTOD("")           		,; 		// DATA VALIDADE
	.F.					} )		// VARIAVEL DE CONTROLE DO MSNEWGETDADOS
	
	
	_nCustoReal += VAL(aProdXML[nY,9]) * VAL(aProdXML[nY,8])
	_nQuant		+= VAL(aProdXML[nY,8])
Next

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ FAZ A AMARRACAO PRODUTO X FORNECEDOR≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
IF lPRODFOR
	For nPed := 1 To Len(aVisuPed)
		DbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		SC7->(DbGoTop())
		SC7->(DbSeek(xFilial("SC7") + aVisuPed[nPed,2]))
		While !SC7->(EOF()) .AND. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aVisuPed[nPed,2])
			If lCampoFil
				IF ALLTRIM(SC7->C7_01FILDE) = ALLTRIM(cLjPed)
					aAdd( aItPed , { .F. , aVisuPed[nPed,2] , SC7->C7_ITEM ,  SC7->C7_PRODUTO , SC7->C7_DESCRI , SC7->C7_UM } )
				EndIF
			Else
				IF ALLTRIM(SC7->C7_FILENT) = ALLTRIM(cLjPed)
					aAdd( aItPed , { .F. , aVisuPed[nPed,2] , SC7->C7_ITEM ,  SC7->C7_PRODUTO , SC7->C7_DESCRI , SC7->C7_UM } )
				EndIF
			EndIF
			SC7->(DbSkip())
		EndDo
	Next
	
	DbSelectArea("SA5")
	SA5->(DbSetOrder(14))
	SA5->(DbGoTop())
	
	IF lMULTPED
		For nT:=1 To Len(aClone)
			IF SA5->(DbSeek(xFilial("SA5") + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR) + aClone[nT,2]))
				While SA5->(!Eof()) .And. ( SA5->A5_FILIAL + SA5->A5_FORNECE + SA5->A5_LOJA + ALLTRIM(SA5->A5_CODPRF) == xFilial("SA5") + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR) + aClone[nT,2])
					nPos   := aScan( aItPed , { |x| ALLTRIM(x[4]) == ALLTRIM(SA5->A5_PRODUTO) } )
					If nPos > 0
						IF EMPTY(aClone[nT,18])
							aClone[nT,18] := PADR(aItPed[nPos,4],30)
						Else
							aClone[nT,18] := PADR((ALLTRIM(aClone[nT,18]) + "/" + ALLTRIM(aItPed[nPos,4])),30)
						EndIF
						
						IF EMPTY(aClone[nT,1])
							aClone[nT,1] := aItPed[nPos,2]+aItPed[nPos,3]
						Else
							aClone[nT,1] := aClone[nT,1] + "/" + aItPed[nPos,2] + aItPed[nPos,3]
						EndIF
					EndIF
					
					SA5->(DbSkip())
				EndDo
			EndIF
		Next
	Else
		For nY:=1 To Len(aClone)
			IF SA5->(DbSeek(xFilial("SA5") + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR) + aClone[nY,2]))
				While SA5->(!Eof()) .And. ( SA5->A5_FILIAL + SA5->A5_FORNECE + SA5->A5_LOJA + ALLTRIM(SA5->A5_CODPRF) == xFilial("SA5") + Z31->Z31_CODFOR + ALLTRIM(Z31->Z31_LJFOR) + aClone[nY,2])
					IF EMPTY(aClone[nY,18])
						aClone[nY,18] := PADR(SA5->A5_PRODUTO,30)
					Else
						aClone[nY,18] := PADR((aClone[nY,18] + "/" + SA5->A5_PRODUTO),30)
					EndIF
					
					For nZ:=1 To Len(aProdutos)
						IF ALLTRIM(aProdutos[nZ,2]) == ALLTRIM(SA5->A5_PRODUTO)
							IF EMPTY(aClone[nY,1])
								aClone[nY,1] := PADR(aProdutos[nZ,1],30)
							Else
								aClone[nY,1] := PADR((aClone[nY,1] + "/" + aProdutos[nZ,1]),30)
							EndIF
						EndIF
					Next
					SA5->(DbSkip())
				EndDo
			EndIF
		Next
	EndIF
EndIF

oGetCat:=MsNewGetDados():New(260,010,336,355,GD_INSERT+GD_DELETE+GD_UPDATE,"AllwaysTrue","AllwaysTrue",,aAlterZ34,,Len(aClone), "AllwaysTrue", "", "AllwaysTrue",oPnlDanfe,aHeader,aClone)
oGetCat:OBROWSE:LADJUSTCOLSIZE := .T.
//oGetCat:OBROWSE:BLDBLCLICK := {|| /*( aPedidos[oBrwPedido:nAt,1] := !aPedidos[oBrwPedido:nAt,1] , oBrwPedido:Refresh() )*/ msginfo("teste" + oGetCat:ACOLS[oGetCat:OBROWSE:nAt,18]) }

@ 260,360 To 280,415 Label "Total Custo Real" Of oPnlDanfe Pixel
oTGet1 := TGet():New( 267,363,{||IIF(PCOUNT() > 0, _nCustoReal := u, _nCustoReal)},oPnlDanfe,050,010, PesqPict("Z34","Z34_CUSTRE"),,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.T.,,'_nCustoReal',,,, )

@ 285,360 To 305,415 Label "Total Quantidade" Of oPnlDanfe Pixel
oTGet2 := TGet():New( 292,363,{||IIF(PCOUNT() > 0, _nQuant := u, _nQuant)},oPnlDanfe,050,010, PesqPict("Z34","Z34_QUANT"),,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.T.,,'_nQuant',,,, )

oBtnLib:= TButton():New( 312,010, "Liberar" , oPnlScrAna , {||},060,010, , , , .T. , , , , { ||})
oBtnLib:BLCLICKED:= {|| nBtn := 1 , oTelVLDDANFE:End() }

oBtnBloq:= TButton():New( 323,010, "Bloquear" , oPnlScrAna , {||},060,010, , , , .T. , , , , { ||})
oBtnBloq:BLCLICKED:= {|| nBtn := 2 , oTelVLDDANFE:End() }

oBtnRejQtd:= TButton():New( 334,010, "Rejeitar" , oPnlScrAna , {||},060,010, , , , .T. , , , , { ||})
oBtnRejQtd:BLCLICKED:= {|| nBtn := 3 , oTelVLDDANFE:End() }

oBtnSair:= TButton():New( 312,090, "Sair" , oPnlScrAna , {||},060,010, , , , .T. , , , , { ||})
oBtnSair:BLCLICKED:= {|| nBtn := 4 , oTelVLDDANFE:End() , EVENTBTN(1) }

ACTIVATE DIALOG oTelVLDDANFE

IF nBtn = 1 	// -> LIBERAR
	IF lMULTPED
		U_SYXMLA08()
	Else
		EVENTBTN(3)
	EndIF
ElseIF nBtn = 2 // -> BLOQUEAR
	EVENTBTN(5)
ElseIF nBtn = 3 // -> REJEITAR
	EVENTBTN(4)
ElseIF nBtn = 4 // -> SAIR
	EVENTBTN(1)
EndIF

RETURN()
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ AtuPanel ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Atualiza o painel que exibe os detalhes do pedido          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION AtuPanel(cPed)

Local nUsado      := 0
Local aHdrAdd	  := {}
Local nQntLin	  := 0
Local nCnt		  := 0
Local nPula		  := 0

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
SC7->(DbGoTop())
SC7->(DbSeek(xFilial("SC7") + cPed))

DbSelectArea("SA2")
SA2->(DbSetOrder(1))
SA2->(DbGoTop())
SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ))

//DbSelectArea("ZAA")
//ZAA->(DbSetOrder(1))
//ZAA->(DbGoTop())
//ZAA->(DbSeek(xFilial("ZAA") + SC7->C7_FORNECE + SC7->C7_LOJA ))

oNumPed:CTEXT	:= "Num.Pedido : "	+ ALLTRIM(cPed)
oDtEmis:CTEXT	:= "Dt.Emiss„o - "  + DTOC(SC7->C7_EMISSAO)
oDtEnt:CTEXT	:= "Dt.Entrega : "  + DTOC(SC7->C7_DATPRF) + " atÈ " + DTOC(SC7->C7_DATPRF)
oForne:CTEXT	:= "Fornecedor : "   + ALLTRIM(SC7->C7_FORNECE) + " / " + ALLTRIM(SC7->C7_LOJA)
oRazao:CTEXT	:= "Raz„o Rocial : "  + ALLTRIM(SA2->A2_NOME)
oCont:CTEXT		:= "Contato : "        + ALLTRIM(SA2->A2_CONTATO)
oFanta:CTEXT	:= "N.Fantasia : "    + ALLTRIM(SA2->A2_NREDUZ)
oMail:CTEXT		:= "e-Mail : "         + ALLTRIM(SA2->A2_EMAIL)
oEnde:CTEXT		:= "End. : "           + ALLTRIM(SA2->A2_END) + " , " + ALLTRIM(SA2->A2_NR_END) + " , CEP " + ALLTRIM(SA2->A2_CEP) + " , " + ALLTRIM(SA2->A2_BAIRRO) + " , " + ALLTRIM(SA2->A2_MUN) + " , " + ALLTRIM(SA2->A2_ESTADO)
oCNPJ:CTEXT		:= "CNPJ : "           + ALLTRIM(SA2->A2_CGC)
oRepres:CTEXT	:= "Repres. : "      + ALLTRIM(SA2->A2_REPRES)
oAcresc:CTEXT	:= "Regra Fornecedor %"
oDesc:CTEXT		:= ""
oMemo:CTEXT		:= ""

DbSelectArea("SC7")
SC7->(DbSetOrder(23))
SC7->(DbGoTop())
SC7->(DbSeek(xFilial("SC7") + cPed + cLjPed))

oCondPag:CTEXT:="CondiÁ„o de Pagamento - " + SC7->C7_COND + " / " + Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")

oNumPed:REFRESH()
oDtEmis:REFRESH()
oDtEnt:REFRESH()
oForne:REFRESH()
oRazao:REFRESH()
oCont:REFRESH()
oFanta:REFRESH()
oMail:REFRESH()
oEnde:REFRESH()
oCNPJ:REFRESH()
oRepres:REFRESH()
oMemo:REFRESH()
oCondPag:REFRESH()

aProdutos := {}
aHdrProd  := {}

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aHeader a partir dos campos do SX3         	 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SC7")
While !Eof() .And. (X3_ARQUIVO == "SC7")
	IF AllTrim(SX3->X3_CAMPO) $ ("C7_ITEM/C7_PRODUTO/C7_DESCRI/C7_UM/C7_QUANT/C7_QUJE/C7_PRECO/C7_TOTAL/C7_IPI/C7_VALIPI/C7_PICM/C7_VALICM/C7_VLDESC/C7_DATPRF/C7_EMISSAO/C7_DESC1/C7_DESC/C7_LOCAL/C7_TES")
		nUsado++
		Aadd(aHdrProd,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN })
	EndIF
	SX3->(DbSkip())
EndDo

aHdrProd := ORDBRW(aHdrProd)

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
SC7->(DbGoTop())
SC7->(DbSeek(xFilial("SC7") + cPed))
While !SC7->(EOF()) .AND. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cPed)
	If lCampoFil
		IF ALLTRIM(SC7->C7_01FILDE) = ALLTRIM(cLjPed)
			//aAdd(aProdutos , { SC7->C7_ITEM , SC7->C7_PRODUTO , SC7->C7_UM, SC7->C7_QUANT , SC7->C7_PRECO , SC7->C7_TOTAL  , SC7->C7_IPI , SC7->C7_DATPRF , SC7->C7_DESC1, SC7->C7_EMISSAO ,SC7->C7_QUJE,SC7->C7_DESCRI, SC7->C7_VLDESC , SC7->C7_VALIPI , SC7->C7_VALICM , SC7->C7_DESC , SC7->C7_PICM, SC7->C7_LOCAL ,.F. } )
			aAdd( aProdutos , { ;
			SC7->C7_ITEM 		,;
			SC7->C7_PRODUTO 	,;
			SC7->C7_DESCRI		,;
			SC7->C7_UM			,;
			SC7->C7_QUANT		,;
			SC7->C7_QUJE		,;
			SC7->C7_LOCAL		,;
			SC7->C7_TES 		,;
			SC7->C7_PRECO		,;
			SC7->C7_TOTAL		,;
			SC7->C7_VLDESC		,;
			SC7->C7_EMISSAO 	,;
			SC7->C7_DATPRF		,;
			SC7->C7_IPI			,;
			SC7->C7_VALIPI		,;
			SC7->C7_PICM		,;
			SC7->C7_VALICM      })
		EndIF
	Else
		IF ALLTRIM(SC7->C7_FILENT) = ALLTRIM(cLjPed)
			//aAdd(aProdutos , { SC7->C7_ITEM , SC7->C7_PRODUTO , SC7->C7_UM, SC7->C7_QUANT , SC7->C7_PRECO , SC7->C7_TOTAL  , SC7->C7_IPI , SC7->C7_DATPRF , SC7->C7_DESC1, SC7->C7_EMISSAO ,SC7->C7_QUJE,SC7->C7_DESCRI, SC7->C7_VLDESC , SC7->C7_VALIPI , SC7->C7_VALICM , SC7->C7_DESC , SC7->C7_PICM, SC7->C7_LOCAL ,.F. } )
			aAdd( aProdutos , { ;
			SC7->C7_ITEM 		,;
			SC7->C7_PRODUTO 	,;
			SC7->C7_DESCRI		,;
			SC7->C7_UM			,;
			SC7->C7_QUANT		,;
			SC7->C7_QUJE		,;
			SC7->C7_LOCAL		,;
			SC7->C7_TES 		,;
			SC7->C7_PRECO		,;
			SC7->C7_TOTAL		,;
			SC7->C7_VLDESC		,;
			SC7->C7_EMISSAO 	,;
			SC7->C7_DATPRF		,;
			SC7->C7_IPI			,;
			SC7->C7_VALIPI		,;
			SC7->C7_PICM		,;
			SC7->C7_VALICM      })
		EndIF
	EndIF
	SC7->(DbSkip())
EndDo

oGetDados:= MsNewGetDados():New(090,000,150,210,0,,,,,,,,,,oPnlBut,aHdrProd,aProdutos)
oGetDados:oBrowse:Refresh()

Return(.T.)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ Ma01Memo  ≥ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Obervacao do pedido.                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function Ma01Memo()

Local lOk := .T.
Local oDlg
Local oPanel
Local cMemoAnt := ""
Local nOpca    := 0
Local __cMaMemo

cMemoAnt := __cMaMemo

While lOk
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 300,450 TITLE "Digite o Motivo..." Of oMainWnd PIXEL
	
	oDlg:lEscClose := .F.
	
	oPanel:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
	oPanel:Align:=CONTROL_ALIGN_ALLCLIENT
	oPanel:NCLRPANE:=24855406
	
	@ 0,0 GET oMemo VAR __cMaMemo MEMO PIXEL OF oDlg
	oMemo:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg,{|| nOpca := 1 , oDlg:End() }, {|| oDlg:End() } ) )
	
	IF nOpca == 0
		__cMaMemo := cMemoAnt
		MsgAlert("Motivo n„o preenchido, por favor digite o motivo!!!!!")
	ElseIf nOpca == 1 .And. __cMaMemo != cMemoAnt
		RecLock("Z31",.F.)
		MSMM(,TamSx3("Z31_MOTIVO")[1],,__cMaMemo,1,,,"Z31","Z31_CODMEM")
		MsUnLock()
		lOk := .F.
	EndIF
EndDo

Return(.T.)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥Z34Totais ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Carrega os totais de custo e quantidade                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function Z34Totais(_cOpt)

Local lVlrCusto	:= IIF(_cOpt == "C", .T., .F.)
Local lVlrQnt	:= IIF(_cOpt == "Q", .T., .F.)

If lVlrCusto
	_nCustoReal := 0
	
	For _nZ:=1 To Len(oGetCat:ACOLS)
		If _nZ == oGetCat:NAT
			_nCustoReal += M->Z34_CUSTRE * oGetCat:ACOLS[_nZ,4]
		Else
			_nCustoReal += oGetCat:ACOLS[_nZ,6]	 * oGetCat:ACOLS[_nZ,4]
		EndIf
	Next _nZ
ElseIf lVlrQnt
	_nQuant		:= 0
	
	For _nZ:=1 To Len(oGetCat:ACOLS)
		If _nZ == oGetCat:NAT
			_nQuant	+= M->_QUANT
		Else
			_nQuant	+= oGetCat:ACOLS[_nZ,4]
		EndIf
	Next _nZ
EndIf

oPnlDanfe:Refresh()
oTGet1:Refresh()
oTGet2:Refresh()

Return(.T.)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ∫  ORDBRW  ∫ Autor ∫ LUIZ EDUARDO F.C.  ∫ Data ≥  15/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Objetivo  ≥ ORDENA O BROWSE DO SC7 NA TELA DE ANALISE DE XML           ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                              `
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
STATIC FUNCTION ORDBRW(aCabec)

Local aCampos := {"C7_ITEM","C7_PRODUTO","C7_DESCRI","C7_UM","C7_QUANT","C7_QUJE","C7_LOCAL","C7_TES","C7_PRECO","C7_TOTAL","C7_VLDESC","C7_EMISSAO","C7_DATPRF","C7_IPI","C7_VALIPI","C7_PICM","C7_VALICM"}
Local aClone  := {}
Local nPos    := 0

For nX := 1 To Len(aCampos)
	nPos := aScan( aCabec, { |x|ALLTRIM(x[2]) == aCampos[nX] } )
	aAdd( aClone , aCabec[nPos] )
Next

RETURN(aClone)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥ OrderCab ∫ Autor ≥ LUIZ EDUARDO F.C.  ∫ Data ≥  01/08/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Ordena as informacoes do grid                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function AtuBrwPed(nPos,oBrwPedido)

IF aPedidos[nPos,7] == "B"
	MsgInfo("Pedido Bloqueado, N„o È PossÌvel Seleciona-lo!!!!")
Else
	IF lMULTPED
		IF aPedidos[nPos,1]
			aPedidos[nPos,1] := .F.
		Else
			aPedidos[nPos,1] := .T.
		EndIF
	Else
		For nT:=1 To Len(aPedidos)
			IF aPedidos[nT,1]
				aPedidos[nT,1] := .F.
			EndIF
		Next
		aPedidos[nPos,1] := .T.
	EndIF
EndIF
oBrwPedido:Refresh()

RETURN()
