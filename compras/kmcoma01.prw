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
±±ºPrograma  ³ KMCOMA01 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  21/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MIGRACAO DE CLIENTES NETGERA - PROTHEUS                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION KMCOMA01()

Local cCodigo  := ""
Local nCodCont := ""
Local cControl := ""
Local nX       := 0
Local cQuery   := ""

Private cArquivo := "C:\totvs\cliente.csv"
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PEGA O ULTIMO REGISTRO DO SA1 - PEGANDO VIA GETXNUM ESTAVA DANDO PROBLEMA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT TOP 1  A1_COD FROM " + RETSQLNAME("SA1")
cQuery += " WHERE A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY A1_COD DESC "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())

While TMP->(!EOF())
	cCodigo := SOMA1(TMP->A1_COD)
	TMP->(dBSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PEGA O ULTIMO REGISTRO DO SU5 - PEGANDO VIA GETXNUM ESTAVA DANDO PROBLEMA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT TOP 1 U5_CODCONT FROM " + RETSQLNAME("SU5")
cQuery += " WHERE U5_FILIAL = '" + XFILIAL("SU5") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY U5_CODCONT DESC "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())

While TMP->(!EOF())
	nCodCont := SOMA1(TMP->U5_CODCONT)
	cControl := nCodCont
	TMP->(dBSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

MSGINFO("Por favor, se não existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importação neste diretório!" + CRLF + "Renomear o arquivo para [cliente.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV não encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

IF Len(aMatriz) > 0
	For nX:=1 To Len(aMatriz)
		DbSelectArea("SA1")
		DbSetOrder(3)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TRATAMENTO PARA O CAMPO CNPJ ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCPF := aMatriz[nX,1]
		
		cCPF := STRTRAN(cCPF,cChar1,"")
		cCPF := STRTRAN(cCPF,cChar2,"")
		cCPF := STRTRAN(cCPF,cChar3,"")
		cCPF := ALLTRIM(cCPF)
		
		IF SA1->(!DbSeek(xFilial("SA1") + cCPF))
			
			Begin Transaction
			Processa({|| GRAVASA1(cCodigo,aMatriz[nX])}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
			End Transaction
			
		EndIF
		
		DbCloseArea()
		cCodigo := SOMA1(cCodigo)
	Next
EndIF

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_DDI, A1_DDD, A1_TEL, "
cQuery += " A1_TEL2, A1_XTEL3, A1_EMAIL, A1_HPAGE FROM " + RETSQLNAME("SA1")
cQuery += " WHERE A1_FILIAL = '" + XFILIAL("SA1") + "' "
cQuery += " AND A1_XORIGEM = 'NETGERA' "
cQuery += " AND A1_XDTIMP = '" + DTOS(dDataBase) + "' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	Begin Transaction
	
	DbSelectArea("SU5")
	SU5->(DbSetOrder(8))
	IF !SU5->(DbSeek(xFilial("SU5") + TRB->A1_CGC))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVANDO AS INFORMACOES DO CONTATO - SU5 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SU5->(RecLock("SU5",.T.))
		SU5->U5_FILIAL  := xFilial("SU5")
		SU5->U5_CODCONT := nCodCont
		SU5->U5_CONTAT  := TRB->A1_NOME
		SU5->U5_END     := TRB->A1_END
		SU5->U5_BAIRRO  := TRB->A1_BAIRRO
		SU5->U5_MUN     := TRB->A1_MUN
		SU5->U5_EST     := TRB->A1_EST
		SU5->U5_CEP     := TRB->A1_CEP
		SU5->U5_CODPAIS := TRB->A1_DDI
		SU5->U5_DDD     := TRB->A1_DDD
		SU5->U5_FONE    := TRB->A1_TEL
		SU5->U5_FCOM1   := TRB->A1_TEL2
		SU5->U5_EMAIL   := TRB->A1_EMAIL
		SU5->U5_URL     := TRB->A1_HPAGE
		SU5->U5_ATIVO   := "1" // ATIVO SIM
		SU5->U5_STATUS  := "2" // CADASTRO ATUALIZADO
		SU5->U5_MSBLQL  := "2" // STATUS ATIVO
		SU5->U5_01SAI   := TRB->A1_COD + TRB->A1_LOJA
		SU5->U5_XORIGEM := "NETGERA"
		SU5->U5_XDTIMP  := dDataBase
		SU5->U5_CPF     := TRB->A1_CGC
		SU5->(MsUnLock())
		
		Do While .T.
			cControl := GetSxeNum("SU5","U5_CODCONT")
			If __lSx8
				ConfirmSx8()
			EndIf
			If !DbSeek( xFilial( "SU5" ) + U5_CONTAT )
				Exit
			EndIf
		EndDo
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVANDO AS INFORMACOES NA TABELA DE RELACIONAMENTO DE ENTIDADES - CONTATO X CLIENTE - AC8 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("AC8")
		AC8->(RecLock("AC8",.T.))
		AC8->AC8_FILIAL := xFilial("AC8")
		AC8->AC8_ENTIDA := "SA1"
		AC8->AC8_CODENT := TRB->A1_COD + TRB->A1_LOJA
		AC8->AC8_CODCON := nCodCont
		AC8->AC8_XORIGE := "NETGERA"
		AC8->AC8_XDTIMP  := dDataBase
		AC8->(MsUnLock())
		
		nCodCont := SOMA1(nCodCont)
		
	EnDIF
	
	End Transaction
	
	TRB->(DbSkip())
EndDo

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
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GRAVASA1 º Autor ³ LUIZ EDUARDO F.C.  º Data ³  21/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GRAVA AS INFORMACOES DO CSV NA TABELA DE CLIENTES (SA1)    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION GRAVASA1(cCodigo,aDados)

Local cCod      := ""
Local cMay      := ""
Local cControle := cCodigo

RecLock("SA1",.T.)

SA1->A1_FILIAL  := xFilial("SA1")
SA1->A1_COD     := cCodigo
SA1->A1_LOJA    := "01"
SA1->A1_DDI     := "55"
SA1->A1_XORIGEM := "NETGERA"
SA1->A1_XDTIMP  := dDataBase
SA1->A1_DTCAD   := CTOD(aDados[18])
SA1->A1_HRCAD   := Time()
SA1->A1_TIPO    := "F"
SA1->A1_ULTENDE := "2"
SA1->A1_CGC     := cCPF
SA1->A1_PAIS    := "105"
SA1->A1_CODPAIS := "01058"
SA1->A1_RISCO   := "A" // FORCAR A GRAVACAO DO CAMPO RISCO - LUIZ EDUARDO F.C. - 05.07.2017 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FORCAR A GRAVACAO DOS SEGUINTES CAMPO POR SOLICITACAO DA LUCIANA - LUIZ EDUARDO F.C. - 02.08.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA1->A1_TPFRET  := "C"
SA1->A1_TRANSP  := "000001"
SA1->A1_COND    := "001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO PESSOA. "F" = FISICA / "J" = JURIDICA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Len(ALLTRIM(cCPF)) = 11
	SA1->A1_PESSOA  := "F"
	SA1->A1_TPESSOA := "PF"
	SA1->A1_INSCR   := "ISENTO"
	SA1->A1_MSBLQL  := "2"
Else
	SA1->A1_PESSOA  := "J"
	SA1->A1_TPESSOA := "CI"
	SA1->A1_MSBLQL  := "1"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA O CAMPO INSCRICAO ESTADUAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDados := aDados[2]
	cDados := STRTRAN(cDados,cChar1,"")
	cDados := STRTRAN(cDados,cChar2,"")
	cDados := STRTRAN(cDados,cChar3,"")
	cDados := STRTRAN(cDados,cChar4,"")
	cDados := STRTRAN(cDados,cChar5,"")
	cDados := STRTRAN(cDados,cChar6,"")
	cDados := STRTRAN(cDados,cChar7,"")
	cDados := STRTRAN(cDados,cChar8,"")
	cDados := NOACENTO(cDados)
	cDados := ALLTRIM(cDados)
	
	SA1->A1_INSCR := cDados
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO RAZAO SOCIAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[4]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_NOME   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO NOME REDUZ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[5]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_NREDUZ   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO ENDERECO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[6]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_END   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO COMPLEMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[7]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_COMPLEM   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO BAIRRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[8]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_BAIRRO   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO MUNICIPIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[9]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_MUN   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO ESTADO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[10]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_EST   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO CODIGO DE MUNICIPIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := RIGHT(ALLTRIM(aDados[11]),5)

SA1->A1_COD_MUN := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO CEP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[12]
cDados := STRTRAN(cDados,cChar2,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_CEP  := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO DDD ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[13]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := LEFT(ALLTRIM(cDados),2)

SA1->A1_DDD   := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO TELEFONE 1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[13]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := SUBSTR(ALLTRIM(cDados),3,LEN(ALLTRIM(cDados)))

SA1->A1_TEL := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO TELEFONE 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[14]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := SUBSTR(ALLTRIM(cDados),3,LEN(ALLTRIM(cDados)))

SA1->A1_TEL2 := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO TELEFONE 3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[15]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := SUBSTR(ALLTRIM(cDados),3,LEN(ALLTRIM(cDados)))

SA1->A1_XTEL3 := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO CONTATO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[16]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_CONTATO   := cDados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO EMAIL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := UPPER(aDados[17])
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_EMAIL   := ALLTRIM(cDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO OPTANTE PELO SIMPLES NACIONAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[24]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := LEFT(ALLTRIM(cDados),2)

IF LEFT(cDados,1) == "S"
	SA1->A1_SIMPLES := "1"
	SA1->A1_SIMPNAC := "1"
Else
	SA1->A1_SIMPLES := "2"
	SA1->A1_SIMPNAC := "2"
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO CONTRIBUINTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[26]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)

cDados := LEFT(ALLTRIM(cDados),2)

IF LEFT(cDados,1) == "S"
	SA1->A1_CONTRIB := "1"
Else
	SA1->A1_CONTRIB := "2"
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA O CAMPO INSCRICAO MUNICIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDados := aDados[3]
cDados := STRTRAN(cDados,cChar1,"")
cDados := STRTRAN(cDados,cChar2,"")
cDados := STRTRAN(cDados,cChar3,"")
cDados := STRTRAN(cDados,cChar4,"")
cDados := STRTRAN(cDados,cChar5,"")
cDados := STRTRAN(cDados,cChar6,"")
cDados := STRTRAN(cDados,cChar7,"")
cDados := STRTRAN(cDados,cChar8,"")
cDados := NOACENTO(cDados)
cDados := ALLTRIM(cDados)

SA1->A1_INSCR := cDados

SA1->(MsUnlock())

Do While .T.
	cControle := GetSxeNum("SA1","A1_COD")
	If __lSx8
		ConfirmSx8()
	EndIf
	If !DbSeek( xFilial( "SA1" ) + cControle + "01" )
		Exit
	EndIf
EndDo

//EndIF

RETURN()
