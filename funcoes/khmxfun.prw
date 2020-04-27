#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

#Define STR_PULA    Chr(13)+Chr(10)

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������ͻ��
���Programa  �          � Autor � LUIZ EDUARDO .F.C  � Data �  22/06/2017        ���
��������������������������������������������������������������������������������͹��
���Descricao � REPOSITORIO DE FUNCOES - KOMFORT                                  ���
��������������������������������������������������������������������������������͹��
���Uso       � KOMFORT                                                           ���
��������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������ͻ��
���Fun��o    � FM_Direct       � Autor � LUIZ EDUARDO F.C.  � Data �  22/06/2017 ���
��������������������������������������������������������������������������������͹��
���Descri��o � VERIFICA SE EXISTE UM DIRETORIO, SE NAO EXISTIR CRIA              ���
��������������������������������������������������������������������������������͹��
��� LINK     � http://codigofonte.uol.com.br/codigos/verificar-e-criar-diretorio ���
���          � PARATEMTROS DA ROTINA :                                           ���
���          � cPath -> CAMINHO A SER VERIFICADO/CRIADO PELA ROTINA              ���
���          � lDrive -> FLAG PARA CONTROLAR A DIGITACAO DA UNIDADE DE DRIVE     ���
���          � .T. = TERA QUE INFORMAR A UNIDADE DE DRIVE                        ���
���          � .F. = NAO CONTROLA A UNIDADE DE DRIVE                             ���
���          � lMsg -> QUESTIONA SOBRE CRIAR O DIRETORIO                         ���
��������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
USER FUNCTION FM_Direct( cPath, lDrive, lMSg )

Local aDir
Local lRet:=.T.
Default lMSg := .T.

If Empty(cPath)
	Return lRet
EndIf

lDrive := If(lDrive == Nil, .T., lDrive)

cPath := Alltrim(cPath)
If Subst(cPath,2,2) <> ":" .AND. lDrive
	MsgInfo("Unidade de drive n?o especificada") //Unidade de drive n?o especificada
	lRet:=.F.
Else
	cPath := If(Right(cPath,1) == "", Left(cPath,Len(cPath)-1), cPath)
	aDir  := Directory(cPath,"D")
	If Len(aDir) = 0
		If lMSg
			If MsgYesNo("Diretorio - "+cPath+" - nao encontrado, deseja cria-lo" ) //Diretorio  -  nao encontrado, deseja cria-lo
				If MakeDir(cPath) <> 0
					Help(" ",1,"NOMAKEDIR")
					lRet := .F.
				EndIf
			EndIf
		Else
			If MakeDir(cPath) <> 0
				Help(" ",1,"NOMAKEDIR")
				lRet := .F.
			EndIf
		EndIF
	EndIf
EndIf

RETURN lRet
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � BUSCACOMBO �Autor  � Luiz Eduardo F.C.  � Data �  09/15/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Traz o conteudo de um campo com combobox                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION BUSCACOMBO(_cCampo,_cValor)

Local _cRet := ""

aSx3Box  := RetSx3Box( Posicione("SX3", 2,_cCampo , "X3CBox()" ),,, 1 )
nAscan := Ascan( aSx3Box, { |e| e[2] = _cValor } )
If nAscan > 0
	_cRet  := AllTrim( aSx3Box[nAscan][3] )
Else
	_cRet  := ""
Endif

Return(_cRet)
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  IMPMEMO   �Autor  � Luiz Eduardo F.C.  � Data �  04/07/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � ROTINA QUE IMPRIME UM CAMOP MEMO                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
/*/{Protheus.doc} zMemoToA
Fun��o Memo To Array, que quebra um texto em um array conforme n�mero de colunas
@author Atilio
@since 15/08/2014
@version 1.0
@param cTexto, Caracter, Texto que ser� quebrado (campo MEMO)
@param nMaxCol, Num�rico, Coluna m�xima permitida de caracteres por linha
@param cQuebra, Caracter, Quebra adicional, for�ando a quebra de linha al�m do enter (por exemplo '<br>')
@param lTiraBra, L�gico, Define se em toda linha ser� retirado os espa�os em branco (Alltrim)
@return nMaxLin, N�mero de linhas do array
@example
cCampoMemo := SB1->B1_X_TST
nCol        := 200
aDados      := u_zMemoToA(cCampoMemo, nCol)
@obs Difere da MemoLine(), pois j� retorna um Array pronto para impress�o
/*/
USER FUNCTION IMPMEMO(cTexto, nMaxCol, cQuebra, lTiraBra)

Local aArea     := GetArea()
Local aTexto    := {}
Local aAux      := {}
Local nAtu      := 0
Default cTexto  := ''
Default nMaxCol := 80
Default cQuebra := ';'
Default lTiraBra:= .T.

//Quebrando o Array, conforme -Enter-
aAux:= StrTokArr(cTexto,Chr(13))

//Correndo o Array e retirando o tabulamento
For nAtu:=1 TO Len(aAux)
	aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
Next

//Correndo as linhas quebradas
For nAtu:=1 To Len(aAux)
	
	//Se o tamanho de Texto, for maior que o n�mero de colunas
	If (Len(aAux[nAtu]) > nMaxCol)
		
		//Enquanto o Tamanho for Maior
		While (Len(aAux[nAtu]) > nMaxCol)
			//Pegando a quebra conforme texto por par�metro
			nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
			
			//Caso n�o tenha, a �ltima posi��o ser� o �ltimo espa�o em branco encontrado
			If nUltPos == 0
				nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
			EndIf
			
			//Se n�o encontrar espa�o em branco, a �ltima posi��o ser� a coluna m�xima
			If(nUltPos==0)
				nUltPos:=nMaxCol
			EndIf
			
			//Adicionando Parte da Sring (de 1 at� a �lima posi��o v�lida)
			aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
			
			//Quebrando o resto da String
			aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
		EndDo
		
		//Adicionando o que sobrou
		aAdd(aTexto,aAux[nAtu])
	Else
		//Se for menor que o M�ximo de colunas, adiciona o texto
		aAdd(aTexto,aAux[nAtu])
	EndIf
Next

//Se for para tirar os brancos
If lTiraBra
	//Percorrendo as linhas do texto e aplica o AllTrim
	For nAtu:=1 To Len(aTexto)
		aTexto[nAtu] := Alltrim(aTexto[nAtu])
	Next
EndIf

RestArea(aArea)

RETURN(aTexto)
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNSB2   �Autor  � Luiz Eduardo F.C.  � Data �  05/07/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � CRIA SB2 DE ACORDO COM SB1                                   ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION XFUNSB2()

Local cQuery := ""

cQuery := " SELECT B1_COD, B1_LOCPAD FROM " + RETSQLNAME("SB1")
cQuery += " WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND B1_TIPO = 'ME' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

TMP->(DbGoTop())
While TMP->(!EOF())
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	SB2->(DbGoTop())
	IF !SB2->(DbSeek(xFilial("SB2") + TMP->B1_COD + TMP->B1_LOCPAD))
		CRIASB2(TMP->B1_COD, TMP->B1_LOCPAD)
	EndIF
	TMP->(DbSkip())
EndDo

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � KMFUNCOES  �Autor  � Luiz Eduardo F.C.  � Data �  28/07/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � PAINEL COM AS FUNCOES KOMFORT                                ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION KMFUNCOES()

Local aSize     := MsAdvSize()
Local oTela

DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Fun��es KOMFORT" Of oMainWnd PIXEL

// TRAZ O LOGO DA KOMFORT HOSUE
@ 005,005 JPEG oLogo FILE "modelos\logo.jpg" SIZE  010,010 OF oTela PIXEL NOBORDER
oLogo:LAUTOSIZE    := .F.
oLogo:LSTRETCH     := .T.

// CRIA OS BOTOES DA ROTINA
@ 055,005 BUTTON  "SAIR" 			SIZE 050,020 PIXEL OF oTela ACTION ( oTela:End() )
@ 055,070 BUTTON  "REFAZ SBZ" 		SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Refazendo Registros na Tabela SBZ...",,{|| U_REFAZSBZ()} ) )
@ 055,135 BUTTON  "CRIA SB2" 		SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Criando Registros na Tabela SB2 de acordo com o Cadastro de Produtos (SB1)...",,{|| U_XFUNSB2()} ) )
@ 055,205 BUTTON  "CRIA SB3" 		SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Criando Registros na Tabela SBE ...",,{|| U_REFAZSBE()} ) )
@ 055,275 BUTTON  "REFAZ SB9" 		SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Refazendo Registros na Tabela SB9...",,{|| U_XFUNSB9()} ) )

@ 100,005 BUTTON  "REFAZ DA1" 		SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Refazendo Registros na Tabela DA1...",,{|| U_XFUNDA1()} ) )
@ 100,070 BUTTON  "ATU B1_LOCPAD" 	SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Atualizando B1_LOCPAD...",,{|| U_XFUNSB1()} ) )
@ 100,135 BUTTON  "REFAZ SBK"	 	SIZE 050,020 PIXEL OF oTela ACTION ( LjMsgRun("Aguarde, Refazendo Registros na Tabela SBK...",,{|| U_XFUNSBK()} ) )

ACTIVATE MSDIALOG oTela CENTERED

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  REFAZSBZ  �Autor  � Luiz Eduardo F.C.  � Data �  28/07/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � RECRIA A TABELA SBZ                                          ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION REFAZSBZ()

Local cQuery := ""
Local aLojas := {}

aLojas := {}
SM0->(DbGoTop())
While SM0->(!EOF())
	aAdd( aLojas , { SM0->M0_CODFIL , SM0->M0_FILIAL} )
	SM0->(DbSkip())
EndDo

//�������������������������Ŀ
//� APAGA TODA A TABELA SBZ �
//���������������������������
cQuery := " DELETE FROM "  + RETSQLNAME('SBZ')
TCSQLExec(cQuery)

For nX:=1 To Len(aLojas)
	LjMsgRun("Aguarde, Criando SBZ na filial " + aLojas[nX,1] + " - " + aLojas[nX,2],,{|| GRAVASBZ(ALLTRIM(aLojas[nX,1]))} )
Next                                                                                                                                      '

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GRAVASBZ �Autor  �Alfa Consultoria    � Data �  20/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para Gravar SBZ.                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
STATIC FUNCTION GRAVASBZ(cLoja)

Local cGrupo	:= GetMv("KH_GRPPROD",,"2001|2002") //Grupo de Produtos que nao deverao cadastrar na tabela SBZ
Local cQuery := ""

cQuery := " SELECT B1_COD, B1_GRUPO FROM " + RETSQLNAME("SB1")
cQuery += " WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND B1_TIPO = 'ME' "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

While TRB->(!EOF())
	RecLock("SBZ",.T.) // .T. = INCLUI
	SBZ->BZ_FILIAL 	:= cLoja
	SBZ->BZ_COD    	:= TRB->B1_COD
	SBZ->BZ_LOCPAD 	:= ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", cLoja))
	SBZ->BZ_LOCALIZ	:= iif( (cLoja$alltrim(SUPERGETMV("SY_LOCALIZ"))) .And. !(TRB->B1_GRUPO $ cGrupo)  ,"S","N")
	SBZ->BZ_DTINCLU	:= DDATABASE
	SBZ->BZ_TIPOCQ 	:= 'M'
	SBZ->BZ_CTRWMS 	:= '2'
	MsUnLock()
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GRAVASBZ �Autor  �Alfa Consultoria    � Data �  20/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para Gravar SBZ.                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION REFAZSBE()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cQuery   := ""
Local cLocal   := ""

Private cArquivo := "C:\totvs\sbe.csv"
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

MSGINFO("Por favor, se n�o existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importa��o neste diret�rio!" + CRLF + "Renomear o arquivo para [sbe.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV n�o encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| U_IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

IF Len(aMatriz) > 0
	For nX:=1 To Len(aMatriz)
		DbSelectArea("SBE")
		DbGoTop()
		DbSetOrder(1)
		
		//IF Len(ALLTRIM(aMatriz[nX,02])) = 1
		//cLocal := "0" + aMatriz[nX,02]
		//EndIF
		
		IF !DbSeek(xFilial("SBE") + aMatriz[nX,02] + aMatriz[nX,03])
			RecLock("SBE",.T.)
			
			SBE->BE_FILIAL	:= cFilAnt
			SBE->BE_LOCAL	:= aMatriz[nX,02]
			SBE->BE_LOCALIZ	:= aMatriz[nX,03]
			SBE->BE_DESCRIC	:= aMatriz[nX,04]
			SBE->BE_CAPACID	:= VAL(aMatriz[nX,05])
			SBE->BE_PRIOR	:= aMatriz[nX,06]
			SBE->BE_ALTURLC	:= VAL(aMatriz[nX,07])
			SBE->BE_LARGLC	:= VAL(aMatriz[nX,08])
			SBE->BE_COMPRLC	:= VAL(aMatriz[nX,09])
			SBE->BE_PERDA	:= VAL(aMatriz[nX,10])
			SBE->BE_STATUS 	:= aMatriz[nX,11]
			
			MsUnLock()
		EndIF
	Next
EndIF


RETURN()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPDADOS � Autor � LUIZ EDUARDO F.C.  � Data �  21/03/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � LE O ARQUIVO CSV E CARREGA UM ARRAY                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION IMPDADOS()

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
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNSB9   �Autor  � Luiz Eduardo F.C.  � Data �  20/08/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � CRIA SB9 DE ACORDO COM SB1                                   ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
USER FUNCTION XFUNSB9()

Local cqry   := ""
Local cQuery := ""

If MsgYesNo("Execute esta rotina na empresa que deseja recriar o SB9, deseja prosseguir?" ) //Diretorio  -  nao encontrado, deseja cria-lo

//���������������������������������Ŀ
//� DELETE REGISTROS DA TABELA SB9  �
//�����������������������������������
cqry := " DELETE FROM "  + RETSQLNAME('SB9')
TCSQLExec(cqry)

cQuery := " SELECT B1_COD, B1_LOCPAD FROM SB1010 "
cQuery += " WHERE B1_FILIAL = ' ' "
cQuery += " AND D_E_L_E_T_ = ' '
cQuery += " AND B1_TIPO = 'ME'

If Select("TRB") > 0
TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

DbSelectArea("SB9")

While TRB->(!EOF())
RecLock("SB9",.T.) // .T. = INCLUI
SB9->B9_FILIAL 	:= cFilAnt
SB9->B9_COD    	:= TRB->B1_COD
SB9->B9_LOCAL 	:= TRB->B1_LOCPAD
SB9->B9_QINI	:= 0
MsUnLock()
TRB->(DbSkip())
EndDo

If Select("TRB") > 0
TRB->(DbCloseArea())
EndIf
EndIF

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNDA1   �Autor  � Luiz Eduardo F.C.  � Data �  20/08/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � CARREGA A TABELA DA1 COM DADOS DA PLANILHA                   ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION XFUNDA1()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cqry     := ""
Local cLocal   := ""
Local _cItem   := "0000"

Private cArquivo := "C:\totvs\da1.csv"
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

MSGINFO("Por favor, se n�o existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importa��o neste diret�rio!" + CRLF + "Renomear o arquivo para [da1.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV n�o encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| U_IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

//���������������������������������Ŀ
//� DELETE REGISTROS DA TABELA SB9  �
//�����������������������������������
cqry := " DELETE FROM "  + RETSQLNAME('DA1')
TCSQLExec(cqry)

IF Len(aMatriz) > 0
	DbSelectArea("DA1")
	DbGoTop()
	
	For nX:=1 To Len(aMatriz)
		RecLock("DA1",.T.)
		
		DA1->DA1_FILIAL := XFILIAL("DA1")
		DA1->DA1_ITEM   := Soma1(_cItem) //STRZERO(VAL(aMatriz[nX,02]),4)
		DA1->DA1_CODTAB := STRZERO(VAL(aMatriz[nX,03]),3)
		DA1->DA1_CODPRO := aMatriz[nX,04]
		DA1->DA1_GRUPO  := aMatriz[nX,05]
		DA1->DA1_REFGRD := aMatriz[nX,06]
		DA1->DA1_PRCVEN := VAL(StrTran( aMatriz[nX,07],",", "." ))
		DA1->DA1_ATIVO  := aMatriz[nX,10]
		DA1->DA1_TPOPER := aMatriz[nX,13]
		DA1->DA1_DATVIG := dDataBase
		
		MsUnLock()
	Next
EndIF

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNSB1   �Autor  � Luiz Eduardo F.C.  � Data �  20/08/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � ATUALIZA O B1_LOCPAD COM OS DADOS DA PLANILHA                ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION XFUNSB1()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cqry     := ""
Local cLocal   := ""
Local nCont    := 0

Private cArquivo := "C:\totvs\sb1.csv"
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

MSGINFO("Por favor, se n�o existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importa��o neste diret�rio!" + CRLF + "Renomear o arquivo para [sb1.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV n�o encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| U_IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

IF Len(aMatriz) > 0
	For nX:=1 To Len(aMatriz)
		cqry := " UPDATE SB1010 SET B1_LOCPAD = '" + STRZERO(VAL(aMatriz[nX,03]),2) + "' "
		cqry += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
		cqry += " AND D_E_L_E_T_ = ' ' "
		cqry += " AND B1_COD = '" + ALLTRIM(aMatriz[nX,01]) + "' "
		TCSQLExec(cqry)
	Next
EndIF

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNSBK   �Autor  � Luiz Eduardo F.C.  � Data �  20/08/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � CARREGA A TABELA DA1 COM DADOS DA PLANILHA                   ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION XFUNSBK()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cqry     := ""
Local cLocal   := ""

Private cArquivo := "C:\totvs\sbk.csv"
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

MSGINFO("Por favor, se n�o existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importa��o neste diret�rio!" + CRLF + "Renomear o arquivo para [sbk.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV n�o encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| U_IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

//���������������������������������Ŀ
//� DELETE REGISTROS DA TABELA SB9  �
//�����������������������������������
cqry := " DELETE FROM "  + RETSQLNAME('SBK')
TCSQLExec(cqry)

IF Len(aMatriz) > 0
	DbSelectArea("SBK")
	DbGoTop()
	DbSetOrder(2)
	
	For nX:=1 To Len(aMatriz)
		IF SBK->(DbSeek(xFilial("SBK") + aMatriz[nX,02] + STRZERO(VAL(aMatriz[nX,03]),2) + SPACE(10) + aMatriz[nX,09]))
			RecLock("SBK",.F.)
			SBK->BK_QINI := SBK->BK_QINI + VAL(aMatriz[nX,05])
			MsUnLock()
		Else
			RecLock("SBK",.T.)
			
			SBK->BK_FILIAL		:= cFilAnt
			SBK->BK_COD	        := aMatriz[nX,02]
			SBK->BK_LOCAL	    := STRZERO(VAL(aMatriz[nX,03]),2)
			SBK->BK_DATA        := dDataBase
			SBK->BK_QINI        := VAL(aMatriz[nX,05])
			SBK->BK_LOCALIZ     := aMatriz[nX,09]
			SBK->BK_PRIOR       := aMatriz[nX,11]
			
			MsUnLock()
		EndIF
	Next
EndIF

RETURN()
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �  XFUNSB9   �Autor  � Luiz Eduardo F.C.  � Data �  20/08/17   ���
���������������������������������������������������������������������������͹��
���Desc.     � CARREGA A TABELA DA1 COM DADOS DA PLANILHA                   ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION XFUNSB9()

Local cCodigo  := ""
Local nCodCont := ""
Local nX       := 0
Local cqry     := ""
Local cLocal   := ""
Local cQuery := ""

Private cArquivo := "C:\totvs\sb9.csv"
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

If MsgYesNo("Execute esta rotina na empresa que deseja recriar o SB9, deseja prosseguir?" ) //Diretorio  -  nao encontrado, deseja cria-lo
	
	//���������������������������������Ŀ
	//� DELETE REGISTROS DA TABELA SB9  �
	//�����������������������������������
	cqry := " DELETE FROM "  + RETSQLNAME('SB9')
	TCSQLExec(cqry)
	
	cQuery := " SELECT B1_COD, B1_LOCPAD FROM SB1010 "
	cQuery += " WHERE B1_FILIAL = ' ' "
	cQuery += " AND D_E_L_E_T_ = ' '
	cQuery += " AND B1_TIPO = 'ME'
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	DbSelectArea("SB9")
	
	While TRB->(!EOF())
		RecLock("SB9",.T.) // .T. = INCLUI
		SB9->B9_FILIAL 	:= cFilAnt
		SB9->B9_COD    	:= TRB->B1_COD
		SB9->B9_LOCAL 	:= TRB->B1_LOCPAD
		SB9->B9_QINI	:= 0
		SB9->B9_DATA    := CTOD("20/08/2017")
		MsUnLock()
		TRB->(DbSkip())
	EndDo
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
EndIF

MSGINFO("Por favor, se n�o existir a pasta no caminho C:\totvs criar a mesma e colocar o arquivo *.csv de importa��o neste diret�rio!" + CRLF + "Renomear o arquivo para [sb9.csv]!!!")

If(!File(cArquivo))
	MSGINFO("ArquiVO CSV n�o encontrado" + CRLF + " Formato ")
	RETURN()
Else
	Processa({|| U_IMPDADOS()}, "Aguarde...","Fazendo a leitura do arquivo *.CSV...",.F.)
Endif

IF Len(aMatriz) > 0
	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))
	SB9->(DbGoTop())
	
	For nX:=1 To Len(aMatriz)
		IF SB9->(DbSeek(STRZERO(VAL(aMatriz[nX,01]),4) + aMatriz[nX,02] + STRZERO(VAL(aMatriz[nX,03]),2)	+ DTOS(CTOD("20/08/2017"))))
			SB9->(RecLock("SB9",.F.))
			SB9->B9_QINI    	:= VAL(aMatriz[nX,05]) + SB9->B9_QINI			
			SB9->(MsUnLock())
		ElSe
			SB9->(RecLock("SB9",.T.))
			
			//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
			
			SB9->B9_FILIAL		:= STRZERO(VAL(aMatriz[nX,01]),4)
			SB9->B9_COD			:= aMatriz[nX,02]
			SB9->B9_LOCAL		:= STRZERO(VAL(aMatriz[nX,03]),2)
			SB9->B9_DATA		:= dDataBase
			SB9->B9_QINI    	:= VAL(aMatriz[nX,05])
			SB9->B9_MCUSTD  	:= "1"
			SB9->B9_VINI1   	:= VAL(StrTran( aMatriz[nX,07],",", "." ))
			SB9->B9_CM1			:= VAL(StrTran( aMatriz[nX,20],",", "." ))
			SB9->B9_DATA        := CTOD("20/08/2017")
			
			SB9->(MsUnLock())
		EndIF
	Next
EndIF
