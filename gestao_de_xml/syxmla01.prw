#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"

#DEFINE CRLF Chr(10)+Chr(13)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ SYXMLA01 บ Autor บ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบObjetivo  ณ Verifica uma conta de E-Mail e salva os arquivos em anexo  บฑฑ
ฑฑบ          ณ em um diretorio corrente da rede.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GESTOR DE XML                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION SYXMLA01(lRecebe)

Local nNumMsg   := 0
Local nTam      := 0
Local nI        := 0
Local nAttachs  := 0
Local nAnexo    := 0
Local nCnt      := 1
Local lRet      := .T.
Local cDirLock	:= GetMv("MV_BLQXML") // DIRETORIO PADRAO PARA A GRAVACAO DO ARQUIVO DE BLOQUEIO DE ACESSO AO XML
Local cArqLock	:= "XML.LCK" // NOME DO ARQUIVO DE BLOQUEIO DE ACESSO DO XML
Local nHandle	:= 0
Local oDlg, oBrw, oBtn, oSay , oServer

Private oSt1     := LoadBitmap(GetResources(),'BR_CINZA')
Private oSt2     := LoadBitmap(GetResources(),'BR_AZUL')
Private oSt7     := LoadBitmap(GetResources(),'BR_VERMELHO')
Private cPach    := GetSrvProfString ("ROOTPATH","") + ALLTRIM(GetMv("MV_XMLDIR"))  // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Private cPathE   := ALLTRIM(GetMv("MV_XMLDIR2")) // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Private cMailXML := ALLTRIM(GetMv("MV_MAILXML")) // ENDERECO DE EMAIL PARA O DOWNLOAD DOS XMLS
Private cUserXML := ALLTRIM(GetMv("MV_USERXML")) // USUARIO PARA A AUTENTIFICACAO DA CONTA DE EMAIL
Private cPswXML  := ALLTRIM(GetMv("MV_PSWXML"))  // SENHA PARA ACESSO AO EMAIL
Private aXmlRec  := {}
Private aEmail   := {}
Private nQntRec  := 0
Private oMailMsg

Default lRecebe := .T.

oServer := TMailManager():New()
oMailMsg := TMailMessage():New()
oServer:Init( cMailXML, "", cUserXML, cPswXML, 0, 110 )

If oServer:SetPopTimeOut( 120 ) != 0
	Conout( "Falha ao setar o time out" )
	Return .F.
EndIf

If oServer:PopConnect() != 0
	MsgInfo("Nใo foi possivel conectar no e-mail!","Aten็ใo")
	Conout( "Falha ao conectar" )
	Return .F.
EndIf

oServer:GetNumMsgs( @nNumMsg )
nTam := nNumMsg

If !lRecebe
	oServer:POPDisconnect()
	Return(nTam)
	
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBloqueia para acesso unico a rotinaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If File(cDirLock + cArqLock)
		nHandle := FOpen(cDirLock + cArqLock, 2)
		cUsrXml := FReadStr(nHandle, 16)
		FClose(nHandle)
		
		MsgInfo("A rotina de baixa Xml jแ estแ sendo executada!" + CRLF + "Usuแrio: " + AllTrim(cUsrXml), "Aten็ใo")
		Return(.T.)
	Else
		nHandle := FCreate(cDirLock + cArqLock)
		
		If nHandle > 0
			FWrite(nHandle, AllTrim(cUserName))
			FClose(nHandle)
		EndIf
	EndIf
EndIF

ProcRegua(nTam)

For nI := 1 To nTam
	IncProc( "Lendo e-mail - "+ StrZero(nCnt,9) +" / "+  StrZero(nTam,9) )
	
	oMailMsg:Clear()
	oMailMsg:Receive( oServer, nI )
	nAttachs:=oMailMsg:GetAttachCount(nI)
	For nZ:=1 To nAttachs
		aAdd( aEmail, oMailMsg:GetAttachInfo(nZ) )
	Next
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega o nAnexo com 1 para atender a nova build.            ณ
	//ณ http://tdn.totvs.com.br/pages/viewpage.action?pageId=6065802 ณ
	//ณ ***Eduardo Araujo - 25/10/2012***                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nAnexo := 1
	
	For nY:=1 To Len(aEmail)
		IF LOWER(SUBSTR(ALLTRIM(aEmail[nY,1]),LEN(ALLTRIM(aEmail[nY,1]))-2,3)) == "xml"
			oMailMsg:SaveAttach(nAnexo, cPach+ALLTRIM(aEmail[nY,1]))
			__CopyFile(cPach+aEmail[nY,1], cPathE+aEmail[nY,1])
			lRet := U_LEXML(aEmail[nY,1])
		EndIF
		nAnexo++
	Next
	aEmail := {}
	nAnexo  := 0
	nCnt++
	If lRet
		oServer:DeleteMsg(nI)
	EndIF
Next

oServer:POPDisconnect()

If Len(aXmlRec) > 0
	oDlg := TDialog():New(000, 000, 200, 500, "XMLs Recebidos",,,,,,,,, .T.)
	
	oBrw:= TwBrowse():New(005, 005, 240, 080,, {'','Num.Nfe','Serie','Dt. Emis.','Fornecedor','Lj.Destino'},, oDlg,,,,,,,,,,,, .F.,, .T.,, .F.,,,)
	oBrw:SetArray(aXmlRec)
	oBrw:bLine := {|| { IF(aXmlRec[oBrw:nAt,01] == "01",oSt1,IF(aXmlRec[oBrw:nAt,01] == "02",oSt2,oSt7)) ,;
	AllTrim(aXmlRec[oBrw:nAt,02]) 		,;
	AllTrim(aXmlRec[oBrw:nAt,03]) 		,;
	DtoC(aXmlRec[oBrw:nAt,04])		  	,;
	AllTrim(aXmlRec[oBrw:nAt,05])		,;
	AllTrim(aXmlRec[oBrw:nAt,06]) 		}}
	
	oSay	:= TSay():New( 090, 10,{|| "Quantidade de Xml processada: "+Str(nQntRec)}, oDlg,,,,,, .T., CLR_RED, CLR_WHITE, 200, 20)
	oBtn	:= SButton():New( 090, 190, 1, {|| oDlg:End()}, oDlg, .T.,,)
	
	oDlg:Activate(,,, .T.)
Else
	MsgAlert("Nใo existem XML para baixar!","Aten็ใo")
EndIf

If File(cDirLock + cArqLock)
	FErase(cDirLock + cArqLock)
EndIf

RETURN (.T.)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ   LEXML  บ Autor บ Luiz Eduardo F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบObjetivo  ณ Faz a leitura dos arquivos XML e grava as informacoes na   บฑฑ
ฑฑบ          ณ tabela Z31                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION LEXML(cXML)

Local cError         := ""
Local cWarning       := ""
Local oXml           := NIL
Local cFile          := ""
Local cDir           := ALLTRIM(GetMv("MV_XMLDIR"))
Local cNumNf         := ""
Local cSerNf         := ""
Local cDtEmis        := ""
Local cCNPJEMI       := ""
Local cCNPJDES       := ""
Local cChaveNf       := ""
Local cStatus  		 := ""
Local cFStatus       := ""
Local cNomEmit       := ""
Local cRazEmit       := ""
Local cRazDest       := ""
Local nPos           := 0
Local aLojas         := {}
Local lRejeita       := .F.
Local lConsultaChave := GetMv("MV_XMLAUTO",,.F.)
Local lOkFil         := .T.
Local aRetStatus	 := {}
Local oNoPrin

//a partir do rootpath do ambiente
cFile := cDir+cXML

//Gera o Objeto XML
oXml := XmlParserFile( cFile, "_", @cError, @cWarning )

IF !EMPTY(ALLTRIM(cError))
	MsgInfo("Ocorreu um erro com o XML!" + CRLF + ALLTRIM(cError) + CRLF + "Por Favor, Verificar a Caixa de Entrada do E-mail 'nfe.xml'")
	RETURN(.F.)
EndIF
oNoPrin := XmlGetChild ( oXml, 1 )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Metodo encontrado para validar os tipos de xml (xml ou xmls) , sendo que o xmls o len dele e 7 - Luiz Eduardo - 20.05.11ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF XmlChildCount(onoprin) = 7
	If ALLTRIM(oNoPrin:REALNAME) == "procCancNFe"
		
		MsgInfo("Nใo foi possivel baixar o XML!" + CRLF + "Favor verificar caixa de e-mail", "Aten็ใo!")
		RETURN(.F.)
	ElseIf ALLTRIM(oNoPrin:REALNAME) == "procEventoNFe"
		
		MsgInfo("Nใo foi possivel baixar o XML!" + CRLF + "Favor verificar caixa de e-mail", "Aten็ใo!")
		RETURN(.F.)
	Else
		IF XmlChildCount(onoprin:_protnfe) = 1
			cStatus  := "01"
			cChaveNF := oNoPrin:_PROTNFE:_PROTNFE:_INFPROT:_CHNFE:TEXT
		ELSE
			cStatus  := "01"
			cChaveNF := oNoPrin:_PROTNFE:_INFPROT:_CHNFE:TEXT
		EndIF
	EndIf
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tratamento para Notas Fiscais Canceladas ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ALLTRIM(oNoPrin:REALNAME) == "procCancNFe"
		
		MsgInfo("Nใo foi possivel baixar o XML!" + CRLF + "Favor verificar caixa de e-mail", "Aten็ใo!")
		RETURN(.F.)
	ElseIf ALLTRIM(oNoPrin:REALNAME) == "procEventoNFe"
		
		MsgInfo("Nใo foi possivel baixar o XML!" + CRLF + "Favor verificar caixa de e-mail", "Aten็ใo!")
		RETURN(.F.)
	ElseIF ALLTRIM(oNoPrin:REALNAME) == "NFe"
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
		cChaveNF := oXml:_ENVINFE:_NFE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT
		cChaveNF := SUBSTR(ALLTRIM(cChaveNF),5,LEN(ALLTRIM(cChaveNF)))
	Else
		IF XmlChildEx ( oNoPrin , "_PROTNFE") <> NIL
			cStatus  := "01"
			IF XmlChildEx ( oNoPrin:_PROTNFE,   "_INFPROT") <> NIL
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
		Else
			MsgAlert("XML invแlido!")   
			RETURN(.F.)
		EndIF
	EndIF
EndIF
SM0->(DbGoTop())

While SM0->(!EOF())
	aAdd( aLojas, { SM0->M0_CODIGO , SM0->M0_CODFIL , SM0->M0_CGC } )
	SM0->(DbSkip())
EndDo

IF ALLTRIM(oNoPrin:REALNAME) == "NFe"
	cNumNf   := STRZERO(VAL(oNoPrin:_INFNFE:_IDE:_NNF:TEXT),9)
	IF ALLTRIM(oNoPrin:_INFNFE:_IDE:_SERIE:TEXT) == "0"
		cSerNf := "1  "
	Else
		cSerNf := PADR(oNoPrin:_INFNFE:_IDE:_SERIE:TEXT,3)
	EndIF
	If XmlChildEx ( oNoPrin:_INFNFE:_IDE, "_DEMI") <> Nil
		cDtEmis  := STOD(SUBSTR(oNoPrin:_INFNFE:_IDE:_DEMI:TEXT,1,4) + SUBSTR(oNoPrin:_INFNFE:_IDE:_DEMI:TEXT,6,2) + SUBSTR(oNoPrin:_INFNFE:_IDE:_DEMI:TEXT,9,2))
	ElseIf XmlChildEx ( oNoPrin:_INFNFE:_IDE, "_DHEMI") <> Nil
		cDtEmis  := STOD(SUBSTR(oNoPrin:_INFNFE:_IDE:_DHEMI:TEXT,1,4) + SUBSTR(oNoPrin:_INFNFE:_IDE:_DHEMI:TEXT,6,2) + SUBSTR(oNoPrin:_INFNFE:_IDE:_DHEMI:TEXT,9,2))
	EndIf
	IF XmlChildEx ( oNoPrin:_INFNFE:_EMIT, "_CNPJ") <> Nil
		cCNPJEMI := oNoPrin:_INFNFE:_EMIT:_CNPJ:TEXT
	EndIF
	IF XmlChildEx ( oNoPrin:_INFNFE:_DEST, "_CNPJ") <> Nil
		cCNPJDES := oNoPrin:_INFNFE:_DEST:_CNPJ:TEXT
	EndIF
	If XmlChildEx ( oNoPrin:_INFNFE:_EMIT, "_XFANT") <> Nil
		NomEmit  := oNoPrin:_INFNFE:_EMIT:_XFANT:TEXT
	Else
		NomEmit  := oNoPrin:_INFNFE:_EMIT:_XNOME:TEXT
	EndIF
	cRazEmit := oNoPrin:_INFNFE:_EMIT:_XNOME:TEXT
	cRazDest := oNoPrin:_INFNFE:_DEST:_XNOME:TEXT
Else
	cNumNf   := STRZERO(VAL(oNoPrin:_NFE:_INFNFE:_IDE:_NNF:TEXT),9)
	IF ALLTRIM(oNoPrin:_NFE:_INFNFE:_IDE:_SERIE:TEXT) == "0"
		cSerNf := "1  "
	Else
		cSerNf   := PADR(oNoPrin:_NFE:_INFNFE:_IDE:_SERIE:TEXT,3)
	EndIF
	If XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DEMI") <> Nil
		cDtEmis  := STOD(SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,4) + SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DEMI:TEXT,6,2) + SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2))
	ElseIf XmlChildEx ( oNoPrin:_NFE:_INFNFE:_IDE, "_DHEMI") <> Nil
		cDtEmis  := STOD(SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,4) + SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,6,2) + SUBSTR(oNoPrin:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,9,2))
	EndIf
	IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_EMIT, "_CNPJ") <> Nil
		cCNPJEMI := oNoPrin:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	EndIF
	IF XmlChildEx ( oNoPrin:_NFE:_INFNFE:_DEST, "_CNPJ") <> Nil
		cCNPJDES := oNoPrin:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	EndIF
	If XmlChildEx( oNoPrin:_NFE:_INFNFE:_EMIT ,   "_XFANT") <> NIL
		cNomEmit  := oNoPrin:_NFE:_INFNFE:_EMIT:_XFANT:TEXT
	Else
		cNomEmit  := oNoPrin:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
	EndIF
	cRazEmit  := oNoPrin:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
	cRazDest  := oNoPrin:_NFE:_INFNFE:_DEST:_XNOME:TEXT
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as informa็๕es do XML na tabela Z31 ณ
//ณ OBS - TIPO DO XML - NFEPROC (VER ERRO)    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("Z31")
Z31->(DbSetOrder(1))
Z31->(DbGoTop())

If !Z31->(DbSeek(xFilial("Z31") + cNumNf + cSerNf +  cCNPJEMI ))
	
	If lConsultaChave
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConsulta automatica da chave do XMLณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aRetStatus := U_SYXMLA04(cChaveNF, oNoPrin, cXML)
		
		If aRetStatus[1] .And. !Empty(aRetStatus[2])
			cFStatus := "02" // Liberado
			lRejeita := .F.
		ElseIf !aRetStatus[1] .And. !Empty(aRetStatus[2])
			cFStatus := "07" // Bloqueado Sefaz
			lRejeita := .T.
		ElseIf !aRetStatus[1] .And. Empty(aRetStatus[2])
			cFStatus := "01" // Aguardando Liberacao
			lRejeita := .F.
		EndIf
	Else
		cFStatus := "01" // Aguardando Liberacao
	EndIf
	
	aAdd(aXmlRec, {cFStatus, cNumNf, cSerNf, cDtEmis, Posicione("SA2",3,xFilial("SA2")+cCNPJEMI,"A2_NOME"), Posicione("SA2",3,xFilial("SA2")+cCNPJDES,"A2_LOJA") })
	nQntRec++
	
	Z31->(RecLock("Z31",.T.))
	Z31->Z31_FILIAL  := xFilial("Z31")
	Z31->Z31_STATUS  := cFStatus
	Z31->Z31_NUM     := cNumNf
	Z31->Z31_SERIE   := cSerNf
	Z31->Z31_EMIS    := cDtEmis
	Z31->Z31_CODFOR  := Posicione("SA2",3,xFilial("SA2")+cCNPJEMI,"A2_COD")
	Z31->Z31_LJFOR   := Posicione("SA2",3,xFilial("SA2")+cCNPJEMI,"A2_LOJA")
	Z31->Z31_CNPJFO  := cCNPJEMI
	Z31->Z31_FORNEC  := Posicione("SA2",3,xFilial("SA2")+cCNPJEMI,"A2_NOME")
	Z31->Z31_NOMFOR  := Posicione("SA2",3,xFilial("SA2")+cCNPJEMI,"A2_NREDUZ")
	nPos := 0
	nPos := aScan( aLojas , { |x| x[3] == cCNPJDES } )
	Z31->Z31_LJDEST  := IIF(nPos > 0 , aLojas[nPos,2] , )
	Z31->Z31_XML     := cXML
	Z31->Z31_CHAVE   := cChaveNF
	Z31->Z31_DTXML   := dDataBase
	Z31->Z31_HRXML   := Time()
	Z31->Z31_USER    := "workflow"
	Z31->Z31_DTLOG   := dDataBase
	Z31->Z31_HRLOG   := Time()
	Z31->Z31_CNPJDE  := cCNPJDES
	Z31->Z31_RZEMIT  := cRazEmit
	Z31->Z31_NMEMIT  := cNomEmit
	
	If lRejeita
		MSMM(,TamSx3("Z31_MOTIVO")[1],,"Rejeitado SEFAZ",1,,,"Z31","Z31_CODMEM")
	EndIf
	Z31->(MsUnlock())
	
	FRename ( cDir+cXML, cDir+cChaveNF+".xml" )
Else
	MsgInfo("Jแ existe informa็ใo gravada na base referente e este XML")
EndIf

Z31->(DbCloseArea())

RETURN(.T.)
