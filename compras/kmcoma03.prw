#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define CRLF Chr(10)+Chr(13)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMCOMA03 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  20/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ATUALIZA CAMPO DE CODIGO DE BARRAS NO CADASTRO DE PRODUTOS º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMCOMA03()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cQuery   := ""

Private cArquivo := "C:\totvs\codigo.csv"
Private aMatriz  := {}
Private cCPD     := ""
Private cDados := ""
Private cChar1 := "."
Private cChar2 := "-"
Private cChar3 := "/"
Private cChar4 := ","
Private cChar5 := "'"
Private cChar6 := '"'
Private cChar7 := "("
Private cChar8 := ")"

MSGINFO("Por favor, se não existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importação neste diretório!" + CRLF + "Renomear o arquivo para [codigo.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV não encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

IF Len(aMatriz) > 0
	For nX:=1 To Len(aMatriz)
		DbSelectArea("SB1")
		DbSetOrder(12)
		IF DbSeek(xFilial("SB1") + aMatriz[nX,1])
			RecLock("SB1",.F.)
			SB1->B1_CODBAR := aMatriz[nX,2]
			MsUnLock()
		EndIF
	Next
EndIF

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPDADOS º Autor ³ LUIZ EDUARDO F.C.  º Data ³  21/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LE O ARQUIVO CSV E CARREGA UM ARRAY                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION IMPDADOS()

Local nPos     := 0
Local nCols    := 0
Local nI       := 0
Local nX       := 0
Local cLinha   := ""
Local cCab     := ""
Local lUsaCab  := .F.
Local aCSV     := {}

ProcRegua(2000)

FT_FUse(cArquivo)
FT_FGoTop()

While (!FT_FEof())
	IncProc()
	IF ( EMPTY(cCab) )
		cCab := FT_FREADLN()
	EndIF
	IF ( lUsaCab )
		AADD(aCSV,FT_FREADLN())
	ELSEIF ( !lUsaCab ) .and. ( nI > 0 )
		AADD(aCSV,FT_FREADLN())
	EndIF
	nI++
	FT_FSkip()
ENDDO

FT_FUSE()

For nI:=1 To Len(cCab)
	IncProc()
	nPos := At(";",cCab)
	IF ( nPos > 0 )
		nCols+= 1
		cCab := SubStr(cCab,nPos+1,Len(cCab)-nPos)
	EndIF
Next

aMatriz := Array(Len(aCSV),nCols+1)

For nI:=1 To Len(aCSV)
	IncProc()
	cLinha := aCSV[nI]
	For nX:= 1 To nCols+1
		nPos := At(";",cLinha)
		IF ( nPos > 0 )
			aMatriz[nI,nX] := AllTrim(SubStr(cLinha,1,nPos-1))
			cLinha := SubStr(cLinha,nPos+1,Len(cLinha)-nPos)
		Else
			aMatriz[nI,nX] := AllTrim(cLinha)
			cLinha := ""
		EndIf
	Next nX
Next nI

RETURN()
