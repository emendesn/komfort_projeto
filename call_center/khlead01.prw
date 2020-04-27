#include 'protheus.ch'
#include 'parmtype.ch'
//--------------------------------------------------------------
/*/{Protheus.doc} KHLEAD01
Description //Importação de leads komforthouse
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/04/2019 /*/
//--------------------------------------------------------------
user function KHLEAD01()
Local cCodigo  := ""
Local nCodCont := ""
Local cControl := ""
Local nX       := 0
Local cQuery   := ""
Local nQnt     := 0
Local dDtInclu :=  date()
Local cCodIn   := '0001'
Private cArquivo := "C:\totvs\leads.csv"
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
//----------------------------------
// Pega o Ultimo registro da ACH010
//----------------------------------
cQuery := " SELECT MAX(ACH_CODIGO) AS CODGIO FROM ACH010

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())

	While TMP->(!EOF())
		cCodigo := SOMA1(TMP->CODGIO)
		TMP->(dBSkip())
	EndDo

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

MSGINFO("Por favor, se não existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importação neste diretório!" + CRLF + "Renomear o arquivo para [leads.csv]!!!")
//---------------------------------------
// Verifica se existe a pasta e o arquivo
//---------------------------------------
	If(!File(cArquivo))
		MSGINFO("ArquiVO CSV não encontrado" + CRLF + " Formato ")
		RETURN()
	EndIf
	
lRetConf := MSGYESNO("CONFIRMA A IMPORTAÇÃO DA PLANILHA?","CONFIRMA")
	
	If 	lRetConf
		
		Processa({|| IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
		
		DbSelectArea('ACH')
		ACH->(DbSetOrder(6))//ACH_FILIAL+ACH_XDTINC+ACH_XCODMK
			IF ACH->(DbSeek(xFilial()+dtos(dDtInclu)+cCodIn))
				MsgAlert("A data: "+dtoc(dDtInclu)+" Já possuí dados importados" )
			Else
			
				IF Len(aMatriz) > 0
					For nX:=1 To Len(aMatriz)
						Begin Transaction
							Processa({|| GRAVAACH(cCodigo,aMatriz[nX],dDtInclu,cCodIn)}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
						End Transaction
							cCodigo := SOMA1(cCodigo)
							nQnt += 1
						Next
							MsgAlert("Quantidade de registros inseridos : "+cvaltochar(nQnt))
				Else
					MsgAlert("A Planilha não possuí dados para importação ")
				EndIf
			EndIf
	Else 
		RETURN()
	EndIf
RETURN()
//--------------------------------------------------------------
/*/{Protheus.doc} IMPDADOS
Description //Importação de leads komforthouse
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/04/2019 /*/
//--------------------------------------------------------------
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
//--------------------------------------------------------------
/*/{Protheus.doc} GRAVAACH
Description //Importação de leads komforthouse
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/04/2019 /*/
//--------------------------------------------------------------
STATIC FUNCTION GRAVAACH(cCodigo,aDados,dDtInclu,cCodIn)
	Local cCod      := ""
	Local cMay      := ""
	Local cControle := cCodigo
	Local cTel      :=  substr(aDados[3],6,16)
	Local cDd       :=  substr(aDados[3],2,2)
	Local dData     := 	ctod(substr(aDados[6],1,10))
	Local cUser     := LogUserName()

	DbSelectArea("ACH")
	RecLock("ACH",.T.)
	ACH->ACH_CODIGO:= cCodigo
	ACH->ACH_EMAIL := aDados[1]
	ACH->ACH_RAZAO := aDados[2]
	ACH->ACH_NFANT := aDados[2]
	ACH->ACH_TEL   := cTel
	ACH->ACH_DDD   := cDd
	ACH->ACH_DTCAD := dData
	ACH->ACH_LOJPRO:= aDados[9]
	ACH->ACH_MSFIL := aDados[9]
	ACH->ACH_XFILIA:= aDados[9]
	ACH->ACH_LOJA  := '01'
	ACH->ACH_XMIMKT:= aDados[5]
	ACH->ACH_XINTER:= aDados[7]
	ACH->ACH_XORIGE:= aDados[10]
	ACH->ACH_XDTINC:= dDtInclu
	ACH->ACH_XUSER := cUser
	ACH->ACH_XCODMK:= cCodIn
	ACH->ACH_MIDIA := '000019'
	ACH->(MsUnlock())
	
	Do While .T.
			cControle := GetSxeNum("ACH","ACH_CODIGO")
			If __lSx8
				ConfirmSx8()
			EndIf
			If !DbSeek( xFilial() + cControle+ "01" )
				Exit
			EndIf
    EndDo

RETURN()

