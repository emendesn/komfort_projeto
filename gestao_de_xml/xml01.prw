#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"

#DEFINE CRLF Chr(10)+Chr(13)

//----------------------------------------------------------------------------------|
//	Function - XML01() -> Verifica uma conta de E-Mail e salva os arquivos em anexo |
//	--------------------> em um diretorio corrente da rede.-------------------------|
//  Parametros ->> Nil	<<----------------------------------------------------------|
//  By Alexis Duarte - 14/05/2018 - KOMFORT HOUSE ----------------------------------|
//----------------------------------------------------------------------------------|

USER FUNCTION XML01()

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

Private cPach    := GetSrvProfString ("ROOTPATH","") + ALLTRIM(GetMv("MV_XMLDIR")) 
Private cPathE   := ALLTRIM(GetMv("MV_XMLDIR2")) // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Private cMailXML := ALLTRIM(GetMv("MV_MAILXML")) // ENDERECO DE EMAIL PARA O DOWNLOAD DOS XMLS
Private cUserXML := ALLTRIM(GetMv("MV_USERXML")) // USUARIO PARA A AUTENTIFICACAO DA CONTA DE EMAIL
Private cPswXML  := ALLTRIM(GetMv("MV_PSWXML"))  // SENHA PARA ACESSO AO EMAIL
Private aEmail   := {}
Private oMailMsg

Private lRecebe := .T.

oServer := TMailManager():New()
oMailMsg := TMailMessage():New()
oServer:Init( cMailXML, "", cUserXML, cPswXML, 0, 110 )

If oServer:SetPopTimeOut( 120 ) != 0
	Conout( "Falha ao setar o time out" )
	Return .F.
EndIf

If oServer:PopConnect() != 0
	MsgInfo("N�o foi possivel conectar no e-mail!","Aten��o")
	Conout( "Falha ao conectar" )
	Return .F.
EndIf

oServer:GetNumMsgs( @nNumMsg )
nTam := nNumMsg

If !lRecebe
	oServer:POPDisconnect()
	Return(nTam)
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Bloqueia para acesso unico a rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If File(cDirLock + cArqLock)
		nHandle := FOpen(cDirLock + cArqLock, 2)
		cUsrXml := FReadStr(nHandle, 16)
		FClose(nHandle)
		
		MsgInfo("A rotina de baixa Xml j� est� sendo executada!" + CRLF + "Usu�rio: " + AllTrim(cUsrXml), "Aten��o")
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega o nAnexo com 1 para atender a nova build.            ³
	//³ http://tdn.totvs.com.br/pages/viewpage.action?pageId=6065802 ³
	//³ ***Eduardo Araujo - 25/10/2012***                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAnexo := 1
	
	For nY:=1 To Len(aEmail)
		IF LOWER(SUBSTR(ALLTRIM(aEmail[nY,1]),LEN(ALLTRIM(aEmail[nY,1]))-2,3)) == "xml"
			oMailMsg:SaveAttach(nAnexo, cPach+ALLTRIM(aEmail[nY,1]))
			__CopyFile(cPach+aEmail[nY,1], cPathE+aEmail[nY,1])
			lRet := CpyS2T( ALLTRIM(GetMv("MV_XMLDIR"))+aEmail[nY,1], cPathE, .F. )

			if lRet == .F.
				alert('N�o foi possivel copiar o Arquivo: '+aEmail[nY,1])
			end

		EndIF
		nAnexo++
	Next nY
	aEmail := {}
	nAnexo  := 0
	nCnt++
	
	If lRet
		oServer:DeleteMsg(nI)
	EndIF
Next

oServer:POPDisconnect()

If File(cDirLock + cArqLock)
	FErase(cDirLock + cArqLock)
EndIf

RETURN (.T.)