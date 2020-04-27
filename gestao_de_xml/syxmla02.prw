#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "TOTVS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYXMLA02 บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TELA PRINCIPAL DA GESTAO DE XML                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GESTOR DE XML                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

USER FUNCTION SYXMLA02()

Private cFiltro  := ""
Private cFornece := ""
Private cCodFor  := SPACE(06)
Private cLJFor   := SPACE(02)
Private cNumNota := SPACE(9)
Private cLjDe 	 := SPACE(2)
Private cLjAte   := SPACE(2)
Private cMascara := "Desmarcar Todos"
Private aFiltro  := {}
Private oSt1     := LoadBitmap(GetResources(),'BR_CINZA')
Private oSt2     := LoadBitmap(GetResources(),'BR_AZUL')
Private oSt3     := LoadBitmap(GetResources(),'BR_AMARELO')
Private oSt4     := LoadBitmap(GetResources(),'BR_VERDE')
Private oSt5     := LoadBitmap(GetResources(),'BR_BRANCO')
Private oSt6     := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oSt7     := LoadBitmap(GetResources(),'BR_LARANJA')
Private oSt8     := LoadBitmap(GetResources(),'BR_PINK')
Private oBtnMark
Private lFinaliza := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ DECLARACAO DE VARIAVEIS DE CONTROLE DA ROTINA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lPRODFOR := GETMV("MV_PRODFOR",,.F.)  	// FAZ A VALIDACAO PRODUTO X FORNECEDOR
Private lMULTPED := GETMV("MV_MULTPED",,.F.)  	// PERMITE SELECIONAR MAIS DE UM PEDIDO
Private lTAGXML  := GETMV("MV_TAGXML",,.F.)  	// VALIDA SE FAZ A AMARRACAO DOS PEDIDOS DE ACORDO COM A TAG DO XML
Private lLIBSPED := GETMV("MV_LIBSPED",,.F.)  	// VALIDA SE PERMITE OU NAO FAZER A LIBERACAO DO XML SEM PEDIDO VINCULADO
Private lVLDPNF  := GETMV("MV_VLDPNF",,.F.)  	// VALIDA SE CRIA A PRE-NOTA DE ENTRADA OU NAO
Private lTCLIENT := GETMV("MV_TCLIENT",,.F.)  	// VALIDA SE IRA FAZER O TRATAMENTO PARA CLIENTE
Private lFILTFIL := GETMV("MV_FILTFIL",,.F.)  	// FILTRA OS XMLS DE ACORDO COM O CNPJ DA FILIAL LOJADA
Private lUSACONV := GETMV("MV_USACONV",,.F.)  	// VALIDA SE USA A TRATATIVA PARA CONVERSADO DA UM
Private lSOLTIPO := GETMV("MV_SOLTIPO",,.F.)  // SOLICITA O TIPO DE NOTA QUE SERA GERADA NA PRE-NOTA DE ENTRADA
Private cEspecie := GETMV("MV_ESPXML",,"SPED")
Private cTipoNF  := GETMV("MV_TIPONF",,"N")
Private cFormNF  := GETMV("MV_FORMNF",,"S")
Private lCliente := .F.

DEFAULT lCLIENTE := .F.                         // VARIAVER QUE IR TRATAR SE E FORNECEDOR OU CLIENTE. .F. == FORNECEDOR / .T. == CLIENTE

aFiltro  := { {.T.,"01","Aguardando Autoriza็ใo SEFAZ"} , {.T.,"02","Em Aberto"} , {.T.,"03","Em Anแlise"} , {.T.,"04","Autorizado (Liberado)"} , {.T.,"05","Bloqueado"} , {.T.,"06","Rejeitado"} , {.T.,"07","Rejeitado SEFAZ"} , {.T.,"08","Bloqueado sem Pedido"} }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ANTES DE ENTRAR NA TELA VERIFICA O EMAIL  E BAIXA OS XML'S ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| U_SYXMLA01()}, "Por Favor Aguarde, Verificando Email e Fazendo o Download dos XML's ...")

IF MsgYesNo("Deseja Filtrar os XML's?","YESNO")
	FILXML()
EndIF

While lFinaliza
	LjMsgRun("Aguarde, Por Favor Aguarde ...",, {|| TELAXML() })
EndDo

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TELAXML  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta a Tela de Gestao dos XML                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION TELAXML()

Local cQuery    := ""
Local aInfAna   := {}
Local aInfOK    := {}
Local aButtons  := {}
Local aFilAtu   := FWArrFilAtu()
Local aSize     := MsAdvSize()
Local nBtn      := 3
Local nAcols    := 0
Local nQntEmail := 0
Local oFnt, oTela, oBrwAna, oBrwOK, oLgd, oTimer, oBtnFil , oFolder

cQuery := " SELECT Z31_STATUS, Z31_NUM, Z31_SERIE, Z31_EMIS, Z31_CODFOR, Z31_LJFOR, Z31_CNPJFO, Z31_FORNEC, Z31_NOMFOR, Z31_LJDEST, Z31_USER, Z31_DTLOG, Z31_HRLOG, Z31_DTXML, Z31_CHAVE, Z31_DTRCB, Z31_HRRCB, Z31_CNPJDE , Z31_RZEMIT , Z31_NMEMIT  "
cQuery += " FROM " + RETSQLNAME("Z31")
cQuery += " WHERE Z31_FILIAL = ' ' "
cQuery += " AND D_E_L_E_T_ = ' ' "

IF LEN(ALLTRIM(cFornece)) > 0
	cQuery += " AND Z31_CNPJFO = '" + cFornece + "' "
ENDIF
IF LEN(ALLTRIM(cFiltro)) > 0
	cQuery += " AND Z31_STATUS IN (" + cFiltro + ") "
ENDIF
IF LEN(ALLTRIM(cNumNota)) > 0
	cQuery += " AND Z31_NUM = '"+cNumNota+"'"
ENDIF
IF LEN(ALLTRIM(cLjDe)) > 0 .AND. LEN(ALLTRIM(cLjAte)) > 0
	cQuery += " AND Z31_LJDEST BETWEEN '"+cLjDe+"' AND '"+cLjAte+"'"
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FILTRA SOMENTE OS XML DA FILIAL LOGADA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF lFILTFIL
	cQuery += " AND Z31_CNPJDE = '"+aFilAtu[18]+"'"
EndIF

cQuery += " ORDER BY Z31_EMIS, Z31_CNPJFO "

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

DbGoTop()
While !EOF()
	IF TRB->Z31_STATUS == "04"
		aAdd( aInfOK  , { TRB->Z31_STATUS, TRB->Z31_NUM, TRB->Z31_SERIE, TRB->Z31_EMIS, TRB->Z31_CODFOR, TRB->Z31_LJFOR, TRB->Z31_CNPJFO, TRB->Z31_FORNEC, TRB->Z31_NOMFOR, TRB->Z31_LJDEST, TRB->Z31_USER, TRB->Z31_DTLOG, TRB->Z31_HRLOG, TRB->Z31_DTXML, TRB->Z31_CHAVE, TRB->Z31_DTRCB, TRB->Z31_HRRCB,  TRB->Z31_CNPJDE , TRB->Z31_RZEMIT , TRB->Z31_NMEMIT } )
	Else
		aAdd( aInfAna , { TRB->Z31_STATUS, TRB->Z31_NUM, TRB->Z31_SERIE, TRB->Z31_EMIS, TRB->Z31_CODFOR, TRB->Z31_LJFOR, TRB->Z31_CNPJFO, TRB->Z31_FORNEC, TRB->Z31_NOMFOR, TRB->Z31_LJDEST, TRB->Z31_USER, TRB->Z31_DTLOG, TRB->Z31_HRLOG, TRB->Z31_DTXML, TRB->Z31_CHAVE, TRB->Z31_DTRCB, TRB->Z31_HRRCB,  TRB->Z31_CNPJDE , TRB->Z31_RZEMIT , TRB->Z31_NMEMIT } )
	EndIF
	DbSkip()
EndDo

If Len(aInfAna) = 0 .AND. Len(aInfOK) = 0
	MsgInfo("Nใo Existe DANFE's Para o Filtro Selecionado!!!")
EndIf

nQntEmail := U_SYXMLA01(.F.)
Aadd(aButtons,{"PROJETPMS"	,{|| Processa({|| U_SYXMLA01(.T.)}, "Por Favor Aguarde ..."), nBtn := 5, oTela:End() } 	,  "Baixar XML("+ IIf(ValType(nQntEmail) == "N", AllTrim(Str(nQntEmail)), "0") +")" } )
Aadd(aButtons,{"PROJETPMS"	,{|| nBtn := 1 , oTela:END() } 	, "Atualiza Lista de XML" } )
Aadd(aButtons,{"PROJETPMS"	,{|| nBtn := 2 , oTela:End() } 	, "Filtro XML" } )
Aadd(aButtons,{"PROJETPMS"	,{|| LEGENDA() } 	, "Legenda" } )
Aadd(aButtons,{"PROJETPMS"	,{|| BUSCAXML() , nBtn := 1 , oTela:END() } 	, "Busca XML" } )

DEFINE FONT oFnt NAME "ARIAL" SIZE 0,-12 BOLD
DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Tela de Manuten็ใo de XML's" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

oTela:lEscClose := .F.

oFolder:=TFolder():New(0,0,{"XML's PARA ANALISE","XML's LIBERADOS"},,oTela,,,,.T.,,0,0)
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

IF Len(aInfAna) > 0
	oBrwAna:= TwBrowse():New(000,000,635,210,,{'','Nfe-Serie','Dt.Emisใo','Cod.Fornecedor','Lj.Fornecedor','CNPJ','Razใo Social','Nome Fantasia','Lj.Destino','CPNJ Destinatแrio [XML]','Razใo Social Emitente [XML]','Nome Fantasia Emitente [XML]','Log.User','Log.Data','Log.Hora','Dt.Grv.XML','Chave NFE','Data de Recebimento','Hora de Recebimento'},,oFolder:aDialogs[1],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrwAna:SetArray(aInfAna)
	oBrwAna:bLine := {|| { IF(aInfAna[oBrwAna:nAt,01] == "01",oSt1,(IF(aInfAna[oBrwAna:nAt,01] == "02",oSt2,(IF(aInfAna[oBrwAna:nAt,01] == "03",oSt3,(IF(aInfAna[oBrwAna:nAt,01] == "04",oSt4,(IF(aInfAna[oBrwAna:nAt,01] == "05",oSt5,(IF(aInfAna[oBrwAna:nAt,01] == "06",oSt6,(IF(aInfAna[oBrwAna:nAt,01] == "07",oSt7,(IF(aInfAna[oBrwAna:nAt,01] == "08",oSt8,(   )))))))))))))))) ,;
	ALLTRIM(aInfAna[oBrwAna:nAt,02]) + " - "  + ALLTRIM(aInfAna[oBrwAna:nAt,03]) ,;   // NUMERO DA DANFE + SERIE DA DANFE
	DTOC(STOD(aInfAna[oBrwAna:nAt,04]))                                       ,;   // DATA DE EMISSAO DA DANFE
	ALLTRIM(aInfAna[oBrwAna:nAt,05])                                          ,;   // CODIGO DO FORNECEDOR
	ALLTRIM(aInfAna[oBrwAna:nAt,06])                                          ,;   // LOJA DO FORNECEDOR
	ALLTRIM(aInfAna[oBrwAna:nAt,07])                                          ,;   // CNPJ DO FORNECEDOR
	ALLTRIM(aInfAna[oBrwAna:nAt,08])                                          ,;   // RAZAO SOCIAL DO FORNECEDOR
	ALLTRIM(aInfAna[oBrwAna:nAt,09])                                          ,;   // NOME FANTASIA DO FORNECEDOR
	ALLTRIM(aInfAna[oBrwAna:nAt,10])                                          ,;   // LOJA DE DESTINO
	ALLTRIM(aInfAna[oBrwAna:nAt,18])                                          ,;   // CNPJ DESTINATARIO VINDO DO XML
	ALLTRIM(aInfAna[oBrwAna:nAt,19])                                          ,;   // RAZAO SOCIAL EMITENTE VINDO DO XML
	ALLTRIM(aInfAna[oBrwAna:nAt,20])                                          ,;   // NOME FANTASIA VINDO DO XML
	ALLTRIM(aInfAna[oBrwAna:nAt,11])                                          ,;   // ULTIMO USUARIO QUE ALTEROU O REGISTRO (WOKFLOW E PADRAO DA IMPORTACAO)
	DTOC(STOD(aInfAna[oBrwAna:nAt,12]))                                       ,;   // DATA DA ULTIMA ALTERACAO DO REGISTRO
	ALLTRIM(aInfAna[oBrwAna:nAt,13])                                          ,;   // HORA DA ULTIMA ALTERACAO DO REGISTRO
	DTOC(STOD(aInfAna[oBrwAna:nAt,14]))                                       ,;	// DATA DA GRAVACAO DO XML NA TABELA
	ALLTRIM(aInfAna[oBrwAna:nAt,15])                                          ,;	// CHAVE DA DANFE
	DTOC(STOD(aInfAna[oBrwAna:nAt,16]))                                       ,;	// DATA DE RECEBIMENTO
	ALLTRIM(aInfAna[oBrwAna:nAt,17])                                          }}   // HORA DE RECEBIMENTO
	oBrwAna:bLDblClick := {|| nAcols := oBrwAna:nAt , oTela:END() , nBtn := 4 }
	oBrwAna:Align:= CONTROL_ALIGN_ALLCLIENT
EndIF

IF Len(aInfOK) > 0
	oBrwOK:= TwBrowse():New(000,000,635,210,,{'','Nfe-Serie','Dt.Emisใo','Cod.Fornecedor','Lj.Fornecedor','CNPJ','Razใo Social','Nome Fantasia','Lj.Destino','CPNJ Destinatแrio [XML]','Razใo Social Emitente [XML]','Nome Fantasia Emitente [XML]','Log.User','Log.Data','Log.Hora','Dt.Grv.XML','Chave NFE','Data de Recebimento','Hora de Recebimento'},,oFolder:aDialogs[2],,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBrwOK:SetArray(aInfOK)
	oBrwOK:bLine := {|| { IF(aInfOK[oBrwOK:nAt,01] == "01",oSt1,(IF(aInfOK[oBrwOK:nAt,01] == "02",oSt2,(IF(aInfOK[oBrwOK:nAt,01] == "03",oSt3,(IF(aInfOK[oBrwOK:nAt,01] == "04",oSt4,(IF(aInfOK[oBrwOK:nAt,01] == "05",oSt5,(IF(aInfOK[oBrwOK:nAt,01] == "06",oSt6,(IF(aInfOK[oBrwOK:nAt,01] == "07",oSt7,(IF(aInfOK[oBrwOK:nAt,01] == "08",oSt8,(   )))))))))))))))) ,;
	ALLTRIM(aInfOK[oBrwOK:nAt,02]) + " - "  + ALLTRIM(aInfOK[oBrwOK:nAt,03]) ,;   // NUMERO DA DANFE + SERIE DA DANFE
	DTOC(STOD(aInfOK[oBrwOK:nAt,04]))                                       ,;   // DATA DE EMISSAO DA DANFE
	ALLTRIM(aInfOK[oBrwOK:nAt,05])                                          ,;   // CODIGO DO FORNECEDOR
	ALLTRIM(aInfOK[oBrwOK:nAt,06])                                          ,;   // LOJA DO FORNECEDOR
	ALLTRIM(aInfOK[oBrwOK:nAt,07])                                          ,;   // CNPJ DO FORNECEDOR
	ALLTRIM(aInfOK[oBrwOK:nAt,08])                                          ,;   // RAZAO SOCIAL DO FORNECEDOR
	ALLTRIM(aInfOK[oBrwOK:nAt,09])                                          ,;   // NOME FANTASIA DO FORNECEDOR
	ALLTRIM(aInfOK[oBrwOK:nAt,10])                                          ,;   // LOJA DE DESTINO
	ALLTRIM(aInfOK[oBrwOK:nAt,18])                                          ,;   // CNPJ DESTINATARIO VINDO DO XML
	ALLTRIM(aInfOK[oBrwOK:nAt,19])                                          ,;   // RAZAO SOCIAL EMITENTE VINDO DO XML
	ALLTRIM(aInfOK[oBrwOK:nAt,20])                                          ,;   // NOME FANTASIA VINDO DO XML
	ALLTRIM(aInfOK[oBrwOK:nAt,11])                                          ,;   // ULTIMO USUARIO QUE ALTEROU O REGISTRO (WOKFLOW E PADRAO DA IMPORTACAO)
	DTOC(STOD(aInfOK[oBrwOK:nAt,12]))                                       ,;   // DATA DA ULTIMA ALTERACAO DO REGISTRO
	ALLTRIM(aInfOK[oBrwOK:nAt,13])                                          ,;   // HORA DA ULTIMA ALTERACAO DO REGISTRO
	DTOC(STOD(aInfOK[oBrwOK:nAt,14]))                                       ,;	// DATA DA GRAVACAO DO XML NA TABELA
	ALLTRIM(aInfOK[oBrwOK:nAt,15])                                          ,;	// CHAVE DA DANFE
	DTOC(STOD(aInfOK[oBrwOK:nAt,16]))                                       ,;	// DATA DE RECEBIMENTO
	ALLTRIM(aInfOK[oBrwOK:nAt,17])                                          }}   // HORA DE RECEBIMENTO
	oBrwOK:bLDblClick := {|| nAcols := oBrwOK:nAt , oTela:END() , nBtn := 6 }
	oBrwOK:Align:= CONTROL_ALIGN_ALLCLIENT
EndIF

ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End() } , { || oTela:End() },, aButtons)

IF nBtn = 1
	//IF MsgYesNo("Deseja Filtrar os XML's?","YESNO")
	//FILXML()
	//EndIF
ElseIF nBtn = 2
	FILXML()
ElseIF nBtn = 3
	lFinaliza := .F.
ElseIF nBtn = 4
	ATUFOR( aInfAna[nAcols,02], aInfAna[nAcols,03], aInfAna[nAcols,07] , nBtn)
ElseIF nBtn = 5
	lFinaliza := .T.
ElseIF nBtn = 6
	ATUFOR( aInfOK[nAcols,02], aInfOK[nAcols,03], aInfOK[nAcols,07] , nBtn)
EndIF

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  FILXML  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta a Tela de Filtro do XML                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION FILXML()

Local oOk	   := LoadBitMap(GetResources(), "LBOK")
Local oNo	   := LoadBitMap(GetResources(), "LBNO")
Local oFiltro, oBrwFil, oBtnOK, oBtnSair, oNumNota, oLjDe, oLjAte

DEFINE MSDIALOG oFiltro FROM 0,0 TO 350,425 TITLE "Selecionar Filtro de XML" Of oMainWnd PIXEL

oFiltro:lEscClose := .F.

@ 005, 005 Say "Escolha os Status : " Size 100,010 Pixel Of oFiltro

oBrwFil:= TWBrowse():New(015,005,130,130,,{"","","Status XML"},,oFiltro,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwFil:SetArray(aFiltro)
oBrwFil:bLine := {|| { If(aFiltro[oBrwFil:nAt,01],oOK,oNO) ,IF(aFiltro[oBrwFil:nAt,02] == "01",oSt1,IF(aFiltro[oBrwFil:nAt,02] == "02",oSt2,IF(aFiltro[oBrwFil:nAt,02] == "03",oSt3,IF(aFiltro[oBrwFil:nAt,02] == "04",oSt4,IF(aFiltro[oBrwFil:nAt,02] == "05",oSt5,IF(aFiltro[oBrwFil:nAt,02] == "06",oSt6,IF(aFiltro[oBrwFil:nAt,02] == "07",oSt7,IF(aFiltro[oBrwFil:nAt,02] == "08",oSt8,IF(aFiltro[oBrwFil:nAt,02] == "09",oSt9,IF(aFiltro[oBrwFil:nAt,02] == "10",oSt10,IF(aFiltro[oBrwFil:nAt,02] == "11",oSt11,IF(aFiltro[oBrwFil:nAt,02] == "12",oSt12,IF(aFiltro[oBrwFil:nAt,02] == "13",oSt13,oSt14))))))))))))) , aFiltro[oBrwFil:nAt,03] }}

oBrwFil:LHSCROLL  := .F.
oBrwFil:LVSCROLL  := .F.

oBrwFil:bLDblClick := {|| ( aFiltro[oBrwFil:nAt,1] := !aFiltro[oBrwFil:nAt,1] , oBrwFil:Refresh() ) }

@ 005, 145 Say "C๓digo Fornecedor : " Size 100,010 Pixel Of oFiltro
@ 015, 145 MSGET cCodFor PICTURE PesqPict("SA2","A2_COD")  F3 "SA2" SIZE 040,010 PIXEL OF oFiltro VALID(cLJFor := SA2->A2_LOJA , cFornece := SA2->A2_CGC)
@ 015, 185 MSGET cLJFor  PICTURE PesqPict("SA2","A2_LOJA")          SIZE 020,010 PIXEL OF oFiltro

@ 030, 145 Say "N๚mero da nota : " Size 100,010 Pixel Of oNumNota
@ 040, 145 MSGET cNumNota PICTURE PesqPict("Z31","Z31_NUM") SIZE 065,010 PIXEL OF oNumNota

@ 055, 145 Say "Loja de : " Size 100,010 Pixel Of oLjDe
@ 065, 145 MSGET cLjDe PICTURE PesqPict("Z31","Z31_FILIAL") F3 "SM0" SIZE 065,010 PIXEL OF oLjDe

@ 080, 145 Say "Loja at้ : " Size 100,010 Pixel Of oLjAte
@ 090, 145 MSGET cLjAte PICTURE PesqPict("Z31","Z31_FILIAL") F3 "SM0" SIZE 065,010 PIXEL OF oLjAte

@ 105, 145 Say "(Branco Filtra Todos)" Size 100,010 Pixel Of oFiltro

oBtnOK:= TButton():New( 152,075, "OK" , oFiltro , {||},065,012, , , , .T. , , , , { ||})
oBtnOK:BLCLICKED:= {|| CarrFil(), oFiltro:End() }

oBtnSair:= TButton():New( 152,145, "Sair" , oFiltro , {||},065,012, , , , .T. , , , , { ||})
oBtnSair:BLCLICKED:= {|| cFiltro  := "" , cFornece := "" , cCodFor  := SPACE(06) , cLJFor   := SPACE(02) , cNumNota := SPACE(9) , cLjDe 	 := SPACE(2) , cLjAte   := SPACE(2) , oFiltro:Refresh() , oFiltro:End() }

oBtnMark:= TButton():New( 152,005, "Desmarcar Todos" , oFiltro , {||},065,012, , , , .T. , , , , { ||})
oBtnMark:BLCLICKED:= {|| MarkAll(), oBrwFil:Refresh()  }

ACTIVATE DIALOG oFiltro CENTERED

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarkAll  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MarkAll()

If cMascara == "Marcar Todos"
	For nX:=1 To Len(aFiltro)
		aFiltro[nX,1] := .T.
	Next
	cMascara := "Desmarcar Todos"
Else
	For nX:=1 To Len(aFiltro)
		aFiltro[nX,1] := .F.
	Next
	cMascara := "Marcar Todos"
EndIF

oBtnMark:CCAPTION := cMascara
oBtnMark:Refresh()

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ CarrFil  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Carrega as informacoes do filtro                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

STATIC FUNCTION CarrFil()

cFiltro := ""

For nZ:=1 To Len(aFiltro)
	IF aFiltro[nZ,1]
		cFiltro += "'" + aFiltro[nZ,2] + "',"
	EndIF
Next

cFiltro := SUBSTR(cFiltro,1,Len(cFiltro) - 1)

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ  ATUFOR  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Atualiza o Fornecedor (XMLS que nao tenham for. cad.)      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION ATUFOR(cNum, cSerie, cCNPJ , nOpc)

Local nSelec := 1
Local oDlgCli

IF nOpc = 4
	IF lTCLIENT
		DEFINE MSDIALOG oDlgCli FROM 0,0 TO 100,230 TITLE "CLIENTE X FORNECEDOR" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
		oDlgCli:lEscClose := .F.
		
		@ 010,010 Say "Por Favor, Escolha a Op็ใo Desejada: " Size 500,030 Pixel Of oDlgCli
		
		@ 027, 005 BUTTON "&CLIENTE"		SIZE 50,15 OF oDlgCli PIXEL ACTION {|| (nSelec := 2 , lCLIENTE := .T. , oDlgCli:End())  }
		@ 027, 060 BUTTON "&FORNECEDOR" 	SIZE 50,15 OF oDlgCli PIXEL ACTION {|| (lCLIENTE := .F. , oDlgCli:End())  }
		
		ACTIVATE MSDIALOG oDlgCli CENTERED
	EndIF
	
	IF nSelec = 1
		DbSelectArea("SA2")
		SA2->(DbSetOrder(3))
		SA2->(DbGotop())
		IF SA2->(DbSeek(xFilial("SA2") + cCNPJ ))
			DbSelectArea("Z31")
			Z31->(DbSetOrder(1))
			Z31->(DbGoTop())
			Z31->(DbSeek(xFilial("Z31") + cNum + cSerie + cCNPJ))
			RecLock("Z31",.F.)
			Z31->Z31_CODFOR := SA2->A2_COD
			Z31->Z31_LJFOR  := SA2->A2_LOJA
			Z31->Z31_FORNEC := SA2->A2_NOME
			Z31->Z31_NOMFOR := SA2->A2_NREDUZ
			MsUnlock()
			Z31->(DbCloseArea())
			SA2->(DbCloseArea())
			U_SYXMLA03( cNum, cSerie, cCNPJ)
		Else
			MsgInfo("Fornecedor Nใo Cadastrado, Entre em Contato com o Depto. Responsแvel pelo Cadastro" + CHR(13) + CHR(10) + "CNPJ : " + cCNPJ)
			Z31->(DbCloseArea())
			SA2->(DbCloseArea())
		EndIF
	Else
		DbSelectArea("SA1")
		SA1->(DbSetOrder(3))
		IF SA1->(DbSeek(xFilial("SA1") + cCNPJ))
			U_SYXMLA03( cNum, cSerie, cCNPJ)
		Else
			MsgInfo("Cliente Nใo Cadastrado, Entre em Contato com o Depto. Responsแvel pelo Cadastro" + CHR(13) + CHR(10) + "CNPJ : " + cCNPJ)
			Z31->(DbCloseArea())
			SA1->(DbCloseArea())
		EndIF
	EndIF
ElseIF nOpc = 6
	U_SYXMLA03( cNum, cSerie, cCNPJ)
EndIF

RETURN()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarkAll  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  29/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION LEGENDA()

Local oLegenda
Local aLegenda := { {"01","Aguardando Autoriza็ใo SEFAZ"} , {"02","Em Aberto"} , {"03","Em Anแlise"} , {"04","Autorizado (Liberado)"} , {"05","Bloqueado"} , {"06","Rejeitado"} , {"07","Rejeitado SEFAZ"} , {"08","Bloqueado sem Pedido"} }

DEFINE MSDIALOG oLegenda FROM 0,0 TO 300,300 TITLE "Legenda" Of oMainWnd PIXEL

oLgd:= TwBrowse():New(240,020,130,140,,{'','Legenda'},,oLegenda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLgd:SetArray(aLegenda)
oLgd:bLine := {|| {  IF(aLegenda[oLgd:nAt,01] == "01",oSt1,IF(aLegenda[oLgd:nAt,01] == "02",oSt2,IF(aLegenda[oLgd:nAt,01] == "03",oSt3,IF(aLegenda[oLgd:nAt,01] == "04",oSt4,IF(aLegenda[oLgd:nAt,01] == "05",oSt5,IF(aLegenda[oLgd:nAt,01] == "06",oSt6,IF(aLegenda[oLgd:nAt,01] == "07",oSt7,IF(aLegenda[oLgd:nAt,01] == "08",oSt8,IF(aLegenda[oLgd:nAt,01] == "09",oSt9,IF(aLegenda[oLgd:nAt,01] == "10",oSt10,IF(aLegenda[oLgd:nAt,01] == "11",oSt11,IF(aLegenda[oLgd:nAt,01] == "12",oSt12,IF(aLegenda[oLgd:nAt,01] == "13",oSt13,oSt14))))))))))))) ,;
ALLTRIM(aLegenda[oLgd:nAt,02]) }}
oLgd:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oLegenda CENTERED

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ BUSCAXML บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ BUSCA O XML DE UM DIRETORIO                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION BUSCAXML()

LOCAL cDirectory := ""
LOCAL aArquivos := {}
LOCAL nArq := 0
PRIVATE aParamFile := ARRAY(1)
PRIVATE cType	:= "*.xml"
cDriver := "|- SELECIONE OS XML's -|"

cDirectory := ALLTRIM(cGetFile("Arquivos XML's|'"+cType+"'|",'Selecione os arquivos desejados', 0,, .T., GETF_LOCALHARD +  GETF_RETDIRECTORY,.T.))
aArquivos := Directory(cDirectory+cType)

IF Len(aArquivos) = 0
	MsgInfo("Nใo existem arquivos xmls nesta pasta, por favor selecione outra pasta!")
Else
	aArquivos := MARKFILE(aArquivos,cDirectory,cDriver)
EndIF

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MARKFILE บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ BUSCA O XML DE UM DIRETORIO                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION MARKFILE(aArquivos,cDiretorio,cDriver)

Local cTitulo   := "Arquivos para importa็ใo: "
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")
Local nx        := 0
Local nAchou    := 0
Local aChaveArq := {}
Local bCondicao := {|| .T.}
Local aDXML     := {}
Local oChkQual,lQual,oQual,cVarQ

For nX := 1 to Len(aArquivos)
	aDXML := ABRXML(cDiretorio , aArquivos[nX,1])
	AADD(aChaveArq,{.F.,aArquivos[nX][1],cDiretorio, aDXML[1] , aDXML[2] , aDXML[3] , aDXML[4] , aDXML[5] , aDXML[6] , aDXML[7] , aDXML[8]})
Next nX

DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
oDlg:lEscClose := .F.

@ 05,15 TO 125,300 LABEL UPPER(cDriver) OF oDlg PIXEL
@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Marca Todos" SIZE 50, 10 OF oDlg PIXEL;
ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))

@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Num้ro NF + S้rie","Fornecedor","Filial Destino","Chave" SIZE;
273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL

oQual:SetArray(aChaveArq)
oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,4] + " - " + aChaveArq[oQual:nAt,5],aChaveArq[oQual:nAt,9],aChaveArq[oQual:nAt,11],aChaveArq[oQual:nAt,2]}}

DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(GRVXML(aChaveArq),oDlg:End(),.T.),.F.) ENABLE OF oDlg
DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

RETURN()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ  Troca   บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ BUSCA O XML DE UM DIRETORIO                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION Troca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarcaOk  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ BUSCA O XML DE UM DIRETORIO                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION MarcaOk(aArray)

Local lRet :=.F.
Local nx   :=0

For nx:=1 To Len(aArray)
	
	If aArray[nx,1]
		lRet:=.T.
	EndIf
	
Next nx

If !lRet
	Alert("Nใo existem itens marcados")
EndIf

Return lRet
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ  ABRXML  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ FAZ A LEITURA DO ARQUIVO XML PARA BUSCAR INFORMACOES	      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION ABRXML(cDir,cArqXML)

Local cStatus   := ""
Local cError    := ""
Local cWarning  := ""
Local cChaveNF  := ""
Local cNumNf    := ""
Local cSerNf    := ""
Local dDtEmis   := ""
Local cCNPJEMI  := ""
Local cCNPJDES  := ""
Local cNomEmit  := ""
Local cRazEmit  := ""
Local cRazDest  := ""
Local oXml      := NIL
Local aLojas    := {}
Local aRetorno  := {}
Local cPach    	:= ALLTRIM(GetMv("MV_XMLDIR"))  // DIRETORIO PADRAO PARA A IMPORTACAO DO XML
Local oNoPrin
Local cRetXml

__CopyFile(cDir+cArqXML, cPach+cArqXML)

oXml    := XmlParserFile( cPach+cArqXML, "_", @cError, @cWarning )
cRetXml := XmlC14NFile( cPach+cArqXML, "_", @cError, @cWarning )

IF !EMPTY(ALLTRIM(cError))
	MsgInfo("Ocorreu um erro com o XML!" + CRLF + ALLTRIM(cError) + CRLF + "Por Favor, Verificar a Caixa de Entrada do E-mail 'nfe.xml'")
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	aAdd( aRetorno , "" )
	
	RETURN(aRetorno)
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
	ElseIF XmlChildEx ( oNoPrin, "_PROTNFE") <> NIL
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
		MsgAlert("XML invแvido!")
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		aAdd( aRetorno , "" )
		
		RETURN(aRetorno)
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
	If XmlChildEx ( oNoPrin:_INFNFE:_EMIT, "_CNPJ") <> Nil
		cCNPJEMI := oNoPrin:_INFNFE:_EMIT:_CNPJ:TEXT
	EndIF 
	If XmlChildEx ( oNoPrin:_INFNFE:_DEST, "_CNPJ") <> Nil
		cCNPJDES := oNoPrin:_INFNFE:_DEST:_CNPJ:TEXT
	EndIF
	If XmlChildEx ( oNoPrin:_INFNFE:_EMIT, "_XFANT") <> Nil
		NomEmit  := oNoPrin:_INFNFE:_EMIT:_XFANT:TEXT
	Else
		NomEmit  := oNoPrin:_INFNFE:_EMIT:_XNOME:TEXT
	EndIF
	cRazEmit  := oNoPrin:_INFNFE:_EMIT:_XNOME:TEXT
	cRazDest  := oNoPrin:_INFNFE:_DEST:_XNOME:TEXT
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

aAdd( aRetorno , cNumNf )
aAdd( aRetorno , cSerNf )
aAdd( aRetorno , dDtEmis )
aAdd( aRetorno , cCNPJEMI )
aAdd( aRetorno , cCNPJDES )
aAdd( aRetorno , cNomEmit )
aAdd( aRetorno , cRazEmit )
aAdd( aRetorno , cRazDest )

FErase(cPach+cArqXML)

RETURN(aRetorno)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ GRVXML   บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  28/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ GRAVA AS INFORMACOES DO XML NAS TABELAS ESPECIFICAS        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION GRVXML(aXML)

Local cDir   := ALLTRIM(GetMv("MV_XMLDIR"))
Local cPathE := ALLTRIM(GetMv("MV_XMLDIR2"))

Private aXmlRec := {}
Private nQntRec := 0

For nX:=1 To Len(aXML)
	__CopyFile(aXml[nX,3]+aXml[nX,2], cDir+aXml[nX,2])
	__CopyFile(aXml[nX,3]+aXml[nX,2], cPathE+aXml[nX,2])
	
	U_LEXML(aXml[nX,2])
Next

RETURN()
