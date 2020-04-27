#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "MsOle.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SYVR104   ºAutor  ³ Eduardo Patriani   º Data ³  17/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Termo de Renuncia utilizando modelo .DOT 	          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SYVR104()

Local nLastKey  := 0
Local cCodCli	:= ''
Local cLojaCli	:= ''
Local cCodCont	:= ''
Local cRG		:= ''
Local cFileSave	:= ''

Private cPathSrv	:= "\modelos\"
Private cPathTer	:= "C:\"
Private cArquivo 	:= "termo_renuncia.dotx"
Private aItens	 	:= {}
Private aInfo       := {}
Private oWord 		:= Nil

/*+----------------+
| Cria Diretório |
+----------------+*/
MakeDir(Trim(cPathTer))

If !File(cPathSrv+cArquivo) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgStop( "O arquivo não foi encontrado no Servidor.","Atenção" )
	Return
EndIf

/*+---------------------------------------------+
| Apaga o arquivo caso já exista no diretório |
+---------------------------------------------+*/
If File(cPathTer+cArquivo)
	FErase(cPathTer+cArquivo)
Endif

CpyS2T(cPathSrv+cArquivo,cPathTer,.T.)

If nLastKey == 27
	Return
Endif

cAlias 	 := GetNextAlias()
cCodCli  := SUA->UA_CLIENTE
cLojaCli := SUA->UA_LOJA
cCodCont := SUA->UA_CODCONT

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + cCodCli + cLojaCli ))

SA5->(DbSetOrder(1))
SA5->(DbSeek(xFilial("SA5") + cCodCont ))

/*+---------------------------------------------+
| Inicializa o Ole com o MS-Word 97 ( 8.0 )   |
+---------------------------------------------+*/
BeginMsOle()
oWord := OLE_CreateLink()
OLE_NewFile(oWord,cPathTer+cArquivo)

OLE_SetDocumentVar(oWord, 'dData'		, DTOC(SUA->UA_EMISSAO)	)
OLE_SetDocumentVar(oWord, 'cCliente'	, SA1->A1_NOME 			)
OLE_SetDocumentVar(oWord, 'cContato'	, If(!Empty(cCodCont),SU5->U5_CONTAT,SA1->A1_NOME)	)
OLE_SetDocumentVar(oWord, 'cRG'			, SA1->A1_RG			)

OLE_SetProperty( oWord, oleWdVisible,   .T. )
OLE_UpDateFields(oWord)

cFileSave := AllTrim(SUA->UA_NUM)+ "_" + DtoS(dDataBase) + "_" + StrTran(Time(),":","")
OLE_SaveAsFile( oWord,cPathTer+ cFileSave+".docx" )

OLE_CloseLink( oWord ) // Encerra link
ShellExecute('Open',cPathTer+ cFileSave+".docx",'','',1)

Return Nil