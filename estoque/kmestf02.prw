#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260Inclui³ Autor ³ Eveli Morasco         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de inclusao de transferencias                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260Inclui(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KMESTF02(cAlias,nReg,nOpcx)

Local cSaveMenuh,nOpca := 0,cNumSeq,aCM:={},aCusto:={}
Local GetList:={},lDigita,lAglutina
Local cCodPict,cUmPict,cLocPict,cDocPict,cUmValid,cLotePict,cPotPict,cPerImPct
Local dDataFec  := MVUlmes()
Local oDlg,oBtn
Local cTela
Local lDocto	:= .T.
Local lButLotDst:= .T.
Local lCAT83    := .F.
Local aButton   := {}
Local cLoteDigiD:=""
Local cLocCQ    := SuperGetMV('MV_CQ', .F., '98')
Local aTela		:= {}
Local aGet		:= {}
Local aSay		:= {}
Local cServico	:= ""
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)



//---------ESPECIFICO KOMFORT INICIO----------
Local cItemx := ""
Local _lRes      := .T.
Local _lPedAchou := .T.
Local _lOkGer   := .F.
Local lCredito	:= .T.
Local lEstoque	:= .T.
Local lAvCred	:= .F.
Local lAvEst	:= .F.
Local lLiber	:= .F.
Local lTransf   := .F.
Private _aPVEnd     := {}
Private lMsErroAuto := .F.
Private _cAlias     := GetNextAlias()
Private _cQuery     := ""
Private _aPedLib    := {}
Private _aPedNor    := {}
Private _aReserv    := {}
Private _aExcRes    := {}
Private _aCabec     := {}
Private _aItens     := {}
Private _aLinha     := {}
Private _nQtdTra    := 0
Private _cReserv    := 0
Private _nPos       := 0
Private _nx         := 0
Private _ny         := 0
Private _lPedOk     := .T.
Private _lSai       := .T.
//---------ESPECIFICO KOMFORT FIM-------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Se mostra e permite digitar lancamentos contabeis   ³
//³ mv_par02 - Se deve aglutinar os lancamentos contabeis          ³
//³ mv_par03 - Subtrai Saldo Terc. N.Poder ? SIM/NAO               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA260",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F12 para acionar perguntas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F12 TO Pergunte("MTA260",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a variavel que identifica se o calculo do custo e' :    ³
//³               O = On-Line                                    ³
//³               M = Mensal                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCusMed  := GetMv("MV_CUSMED")
PRIVATE cCadastro:= OemToAnsi("Especifico Komfort - Transferencias")	//"Transferˆncias"
PRIVATE aRegSD3  := {}
PRIVATE aCtbDia  := {}
Static nFCICalc := SuperGetMV("MV_FCICALC",.F.,0)

Static __lIntWMS := FindFunction("IntWMS")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	PRIVATE nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T.	// Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst 			// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	SX5->(dbSeek(xFilial("SX5")+"09EST"))
	cLoteEst:=IIf(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo		// Nome do arquivo contra prova
EndIf

Private cDescOrig	:= cDescDest := Criavar("B1_DESC", .F.)
Private cSavCdOri   := ""

//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB    := {}
Private aWmsAviso  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para inclusao de botoes na ToolBar.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT260BTN"))
	aButton := ExecBlock("MT260BTN",.F.,.F.)
	If ValType(aButton) # "A"
		aButton := {}
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para acionar ou nao o botao Sel Lote Destino³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT260BLD"))
	lButLotDst := ExecBlock("MT260BLD",.F.,.F.)
	If ValType(lButLotDst) # "L"
		lButLotDst := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de botao que permite selecionar lote destino da     ³
//³ transferencia diferente do lote origem.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lButLotDst
	aAdd(aButton,{'BONUS',{|| A260LDest(cCodDest,@cLoteDigiD,cLotePict,.T.)},"Informar lote destino","Lt. Dest."}) //"Sel. Lote Destino"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar data do ultimo fechamento em SX6.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dDataFec >= dDataBase
	Help ( " ", 1, "FECHTO" )
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Existencia do ponto de entrada e seta valor       ³
//³ da variavel que define se edita o documento ou nao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTA260DOC")
	lDocto := ExecBlock("MTA260DOC",.F.,.F.)
	lDocto := If(ValType(lDocto)#"L",.T.,lDocto)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F4 para comunicacao com Saldos dos Lotes         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 To A260AvalF4()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega as pictures do SX3 para manter o padrao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)    // ordem por campo

dbSeek("D3_COD")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cCodOrig := cCodDest := Space(X3_TAMANHO)
cCodPict := Trim(X3_PICTURE)

dbSeek("D3_UM")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cUmOrig := cUmDest := Space(X3_TAMANHO)
cUmPict := Trim(X3_PICTURE)
cUmValid:= Trim(X3_VALID)

dbSeek("D3_LOCAL")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cLocOrig := cLocDest := Space(X3_TAMANHO)
cLocPict := Trim(X3_PICTURE)

dbSeek("D3_LOCALIZ")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cLoclzOrig := cLoclzDest := Space(X3_TAMANHO)
cLoclzPict := Trim(X3_PICTURE)

dbSeek("D3_QUANT")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE nQuant260   := Criavar("D3_QUANT")
PRIVATE cQtdPict := Trim(X3_PICTURE)

dbSeek("D3_QTSEGUM")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE nQuant260D   :=  Criavar("D3_QTSEGUM")
PRIVATE cQtd2Pict := Trim(X3_PICTURE)

dbSeek("D3_DOC")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cDocto := CriaVar("D3_DOC")
cDocPict := Trim(X3_PICTURE)

dbSeek("D3_NUMLOTE")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cNumLote := Space(X3_TAMANHO)
cLotePict := Trim(X3_PICTURE)

dbSeek("D3_NUMSERI")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cNumSerie := Space(X3_TAMANHO)
cSeriePict := Trim(X3_PICTURE)

dbSeek("D3_LOTECTL")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE cLoteDigi:= Space(X3_TAMANHO)
cLoteDigiD:= Space(X3_TAMANHO)
cLotCTLPic := Trim(X3_PICTURE)

dbSeek("D3_DTVALID")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE dDtValid := dDtVldDest := CriaVar("D3_DTVALID")
cDtVldPic := Trim(X3_PICTURE)

dbSeek("D3_POTENCI")
If Eof();Help(" ",1,"NOSX3");EndIf
PRIVATE nPotencia:= CriaVar("D3_POTENCI")
cPotPict := Trim(X3_PICTURE)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Portaria CAT83   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If V240CAT83()
	lCAT83:=.T.
	dbSeek("D3_CODLAN")
	If Eof()
		Help(" ",1,"NOSX3")
	EndIf
EndIf

PRIVATE cCAT83O:= IIF(lCAT83,CriaVar("D3_CODLAN"),"")
PRIVATE cCAT83D:= IIF(lCAT83,CriaVar("D3_CODLAN"),"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percentual FCI   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFCICalc == 1 .And. cPaisLoc == "BRA"
	dbSeek("D3_PERIMP")
	If Eof();Help(" ",1,"NOSX3");EndIf
	PRIVATE nPerImp := CriaVar("D3_PERIMP")
	cPerImPct := Trim(X3_PICTURE)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve ordem original do SX3                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSetOrder(1)

PRIVATE dEmis260 := M->dDataBase
PRIVATE lControl :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o posicionamento dos Says/Gets    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A260PosGet(@aSay, @aGet, @aTela)

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

DbSelectArea("SC0")
SC0->(DbSetOrder(1))

//	BeginTran()
BEGIN TRANSACTION

While _lSai
	
	//Zera variaveis
	DbSelectArea("SX3")
	DbSetOrder(2)    // ordem por campo
	SX3->(DbSeek("D3_COD"))
	cCodOrig := cCodDest := Space(X3_TAMANHO)
	cCodPict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_UM"))
	cUmOrig := cUmDest := Space(X3_TAMANHO)
	cUmPict := Trim(X3_PICTURE)
	cUmValid:= Trim(X3_VALID)
	SX3->(DbSeek("D3_LOCAL"))
	cLocOrig := cLocDest := Space(X3_TAMANHO)
	cLocPict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_LOCALIZ"))
	cLoclzOrig := cLoclzDest := Space(X3_TAMANHO)
	cLoclzPict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_QUANT"))
	nQuant260   := Criavar("D3_QUANT")
	cQtdPict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_QTSEGUM"))
	nQuant260D   :=  Criavar("D3_QTSEGUM")
	cQtd2Pict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_DOC"))
	cDocto := CriaVar("D3_DOC")
	cDocPict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_NUMLOTE"))
	cNumLote := Space(X3_TAMANHO)
	cLotePict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_NUMSERI"))
	cNumSerie := Space(X3_TAMANHO)
	cSeriePict := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_LOTECTL"))
	cLoteDigi:= Space(X3_TAMANHO)
	cLoteDigiD:= Space(X3_TAMANHO)
	cLotCTLPic := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_DTVALID"))
	dDtValid := dDtVldDest := CriaVar("D3_DTVALID")
	cDtVldPic := Trim(X3_PICTURE)
	SX3->(DbSeek("D3_POTENCI"))
	nPotencia:= CriaVar("D3_POTENCI")
	cPotPict := Trim(X3_PICTURE)
	cCAT83O:= IIF(lCAT83,CriaVar("D3_CODLAN"),"")
	cCAT83D:= IIF(lCAT83,CriaVar("D3_CODLAN"),"")
	If nFCICalc == 1 .And. cPaisLoc == "BRA"
		SX3->(DbSeek("D3_PERIMP"))
		nPerImp := CriaVar("D3_PERIMP")
		cPerImPct := Trim(X3_PICTURE)
	EndIf
	
	SX3->(DbSetOrder(1))
	
	cDescOrig	:= cDescDest := Criavar("B1_DESC", .F.)
	cSavCdOri   := ""
	
	nOpca:=0
	DEFINE MSDIALOG oDlg FROM  aTela[1],aTela[2] TO aTela[3],aTela[4] TITLE OemToAnsi("Especifico Komfort - Transferencias") PIXEL	//"Transferˆncias"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Panel                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPanel:= tSay():New(,,,oDlg)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	
	DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oPanel
	@ aGet[1,1],aGet[1,2] TO aGet[1,3],aGet[1,4] LABEL OemToAnsi("Origem")  OF oPanel  PIXEL	//"Origem"
	@ aGet[2,1],aGet[2,2] TO aGet[2,3],aGet[2,4] LABEL OemToAnsi("Destino") OF oPanel  PIXEL	//"Destino"
	@ aGet[3,1],aGet[3,2] MSGET cCodOrig F3 "SB1" Picture PesqPict("SD3","D3_COD") Valid NaoVazio() .And. A260IniCpo(1,@cServico) ;
	SIZE aGet[3,3],aGet[3,4] OF oPanel PIXEL
	
	@ aGet[4,1],aGet[4,2] MSGET cUmOrig  When .F. SIZE aGet[4,3],aGet[4,4] OF oPanel PIXEL
	
	@ aGet[5,1],aGet[5,2] MSGET cLocOrig Picture cLocPict F3 "NNR" Valid ExistCpo("NNR") .And. NaoVazio() .And. A260Local() ;
	.And. VldUser("D3_LOCAL") SIZE aGet[5,3],aGet[5,4] OF oPanel PIXEL   //Armazem Origem
	
	@ aGet[6,1],aGet[6,2] MSGET cLoclzOrig F3 "SBE" Picture cLoclzPict Valid If(Localiza(cCodOrig) .Or. IntDl(cCodOrig),A260Locali(),Vazio()) ;
	When (Localiza(cCodOrig) .Or. IntDl(cCodOrig)) SIZE aGet[6,3],aGet[6,4] OF oPanel PIXEL
	
	If lCAT83 .And. cPaisLoc == "BRA"
		@ aGet[20,1],aGet[20,2] MSGET cCAT83O F3 "CDZ"	SIZE aGet[20,3],aGet[20,4] Valid IIF(Vazio() .Or. ExistCpo("CDZ",&(ReadVar())),.T.,.F.) OF oPanel PIXEL   //Cod.CAT83
	EndIf
	
	@ aGet[7,1],aGet[7,2] MSGET cCodDest F3 "SB1" Picture cCodPict Valid NaoVazio() .And. A260IniCpo(2) When .F. SIZE aGet[7,3],aGet[7,4] OF oPanel PIXEL
	
	@ aGet[8,1],aGet[8,2] MSGET cUmDest  When .F. SIZE aGet[8,3],aGet[8,4] OF oPanel PIXEL
	
	@ aGet[9,1],aGet[9,2] MSGET cLocDest Picture cLocPict F3 "NNR" Valid ExistCpo("NNR") .And. NaoVazio() .And. A260LocDest() .And. ;
	VldUser("D3_LOCAL") When .F. SIZE aGet[9,3],aGet[9,4] OF oPanel PIXEL //Armazem Destino
	
	@ aGet[10,1],aGet[10,2] MSGET cLoclzDest F3 "SBE" Picture cLoclzPict Valid If(Localiza(cCodDest) .Or. IntDl(cCodDest),A260Locali(),Vazio()) ;
	When (Localiza(cCodDest) .Or. IntDl(cCodDest)) SIZE aGet[10,3],aGet[10,4] OF oPanel PIXEL
	@ aGet[11,1],aGet[11,2] MSGET cNumSerie When Localiza(cCodOrig) SIZE aGet[11,3],aGet[11,4] OF oPanel PIXEL
	
	If lCAT83 .And. cPaisLoc == "BRA"
		@ aGet[21,1],aGet[21,2] MSGET cCAT83D F3 "CDZ"	SIZE aGet[21,3],aGet[21,4] Valid IIF(Vazio() .Or. ExistCpo("CDZ",&(ReadVar())),.T.,.F.) OF oPanel PIXEL  //Cod.CAT83
	EndIf
	
	@ (aGet[12,1]+25),aGet[11,2] MSGET cLoteDigi  Picture cLotCtlPic Valid A260Lote() When (Rastro(cCodOrig,"S") .Or. Rastro(cCodOrig,"L")) SIZE (aGet[12,3]+85),aGet[12,4] OF oPanel PIXEL
	@ (aGet[13,1]+25),aGet[13,2] MSGET cNumLote   Picture cLotePict  Valid A260Lote() When Rastro(cCodOrig,"S") SIZE aGet[13,3],aGet[13,4] OF oPanel PIXEL
	@ (aGet[14,1]+25),aGet[14,2] MSGET dDtValid   Picture cDtVldPic  Valid dDtValid > dDataBase When lControl  SIZE aGet[14,3],aGet[14,4] OF oPanel PIXEL
	@ (aGet[15,1]+25),aGet[15,2] MSGET nPotencia  Picture cPotPict   When lControl  SIZE aGet[15,3],aGet[15,4] OF oPanel PIXEL
	@ (aGet[16,1]+25),aGet[16,2] MSGET nQuant260  Picture cQtdPict   Valid A260Quant(1) SIZE aGet[16,3],aGet[16,4] OF oPanel PIXEL
	@ (aGet[17,1]+25),aGet[17,2] MSGET nQuant260D Picture cQtd2Pict  Valid A260Quant(2) SIZE aGet[17,3],aGet[17,4] OF oPanel PIXEL
	@ (aGet[18,1]+25),aGet[18,2] MSGET dEmis260 Valid A260Data() .And. VldUser('D3_EMISSAO') SIZE aGet[18,3],aGet[18,4] OF oPanel PIXEL
	@ (aGet[19,1]+25),aGet[19,2] MSGET cDocto Picture cDocPict Valid A260Doc() SIZE aGet[19,3],aGet[19,4] OF oPanel PIXEL WHEN lDocto
	If nFCICalc == 1
		@ (aGet[22,1]+25),aGet[22,2] MSGET nPerImp Picture cPerImPct Valid A250VlPImp() SIZE aGet[22,3],aGet[22,4] OF oPanel PIXEL
	EndIf
	@ aSay[1,1],aSay[1,2] SAY cDescOrig SIZE aSay[1,3],aSay[1,4] OF oPanel PIXEL
	@ aSay[2,1],aSay[2,2] SAY cDescDest SIZE aSay[2,3],aSay[2,4] OF oPanel PIXEL
	@ aSay[3,1],aSay[3,2] SAY OemtoAnsi("Produto")	SIZE aSay[3,3],aSay[3,4] 	OF oPanel PIXEL 		//"Produto"
	@ aSay[4,1],aSay[4,2] SAY OemToAnsi("Unidade de Medida")	SIZE aSay[4,3],aSay[4,4] 	OF oPanel PIXEL 		//"Unidade de Medida"
	@ aSay[5,1],aSay[5,2] SAY OemToAnsi("Armazem  /  Endereco")	SIZE aSay[5,3],aSay[5,4] 	OF oPanel PIXEL 		//"Armazem  /  Endereco"
	@ aSay[7,1],aSay[7,2] SAY OemToAnsi("Produto")	SIZE aSay[7,3],aSay[7,4] 	OF oPanel PIXEL 		//"Produto"
	@ aSay[8,1],aSay[8,2] SAY OemToAnsi("Unidade de Medida")	SIZE aSay[8,3],aSay[8,4] 	OF oPanel PIXEL 		//"Unidade de Medida"
	@ aSay[9,1],aSay[9,2] SAY OemToAnsi("Armazem  /  Endereco")	SIZE aSay[9,3],aSay[9,4] 	OF oPanel PIXEL 		//"Armazem  /  Endereco"
	@ aSay[11,1],aSay[11,2] SAY OemToAnsi("Numero de Serie") SIZE aSay[11,3],aSay[11,4]	OF oPanel PIXEL 		//"N£mero de Serie"
	@ (aSay[12,1]+25),aSay[11,2] SAY OemToAnsi("Lote") SIZE aSay[12,3],aSay[12,4] OF oPanel PIXEL	//"Lote"
	@ (aSay[13,1]+25),aSay[13,2] SAY OemToAnsi("Sub-Lote") SIZE aSay[13,3],aSay[13,4] OF oPanel PIXEL	//"Sub-Lote"
	@ (aSay[14,1]+25),aSay[14,2] SAY OemToAnsi("Data de Validade") SIZE aSay[14,3],aSay[14,4] OF oPanel PIXEL	//"Data de Validade"
	@ (aSay[15,1]+25),aSay[15,2] SAY OemToAnsi("Pot.") SIZE aSay[15,3],aSay[15,4] OF oPanel PIXEL	//"Pot."
	@ (aSay[16,1]+25),aSay[16,2] SAY OemToAnsi("Quantidade Primaria") SIZE aSay[16,3],aSay[16,4] OF oPanel PIXEL	//"Quantidade Prim ria"
	@ (aSay[17,1]+25),aSay[17,2] SAY OemToAnsi("Quantidade Secundaria") SIZE aSay[17,3],aSay[17,4] OF oPanel PIXEL	//"Quantidade Secund ria"
	@ (aSay[18,1]+25),aSay[18,2] SAY OemToAnsi("Data") SIZE aSay[18,3],aSay[18,4] OF oPanel PIXEL	//"Data"
	@ (aSay[19,1]+25),aSay[19,2] SAY OemToAnsi("Documento") SIZE aSay[19,3],aSay[19,4] OF oPanel PIXEL	//"Documento"
	If nFCICalc == 1
		@ (aSay[22,1]+25),aSay[22,2] SAY OemToAnsi("Percentual"+chr(13)+chr(10)+"Importacao") SIZE aSay[22,3],aSay[22,4] OF oPanel PIXEL 			//"Percentual Importacao"
	EndIf
	
	If lCAT83
		@ (aSay[20,1]),aSay[20,2] SAY OemToAnsi("Cod.Cat"+chr(13)+chr(10)+"Produto Origem") SIZE aSay[20,3],aSay[20,4] OF oPanel PIXEL 		//Cod.Cat Produto Origem
		@ (aSay[21,1]),aSay[21,2] SAY OemToAnsi("Cod.Cat"+chr(13)+chr(10)+"Produto Destino") SIZE aSay[21,3],aSay[21,4] OF oPanel PIXEL 		//Cod.Cat Produto Destino
	EndIf
	
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| If(A260TudoOK(cLocCQ, cLoteDigiD, cServico, lWmsNew,cDocto),(nOpca:=1,oDlg:End()),"") },;
	{||nOpca:=0,oDlg:End()},, aButton)
	If nOpcA == 0
		Exit
	EndIf
	//-- Adicionada validacao do local de origem
	If nOpca == 1
		If !A260Local(cLocOrig)
			Exit
		EndIf
	EndIf
	
	//---------ESPECIFICO KOMFORT INICIO----------
	_cQuery := " SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_QTDVEN,DC_LOCALIZ,C6_QTDEMP,ISNULL(C9_QTDLIB,0) C9_QTDLIB, C6_LOCALIZ, C6_RESERVA "
	_cQuery += " FROM " + RETSQLNAME("SC6") + " SC6 (NOLOCK) "
	_cQuery += " LEFT OUTER JOIN " + RETSQLNAME("SDC") + " SDC (NOLOCK) ON DC_PEDIDO = C6_NUM AND DC_ITEM = C6_ITEM "
	_cQuery += " AND DC_PRODUTO = C6_PRODUTO AND C6_LOCAL = DC_LOCAL AND SDC.D_E_L_E_T_ <> '*' "
	_cQuery += " LEFT OUTER JOIN SC9010 (NOLOCK)  SC9 ON C9_FILIAL = C6_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC9.D_E_L_E_T_ <> '*' "
	_cQuery += " AND C9_BLEST = '' AND C9_BLCRED = '' "
	_cQuery += " WHERE SC6.D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_BLQ <> 'R' "
	_cQuery += " AND C6_NOTA = '' "
	_cQuery += " AND C6_FILIAL  = '"+ xFilial("SC6") +"' "
	_cQuery += " AND C6_PRODUTO = '"+ cCodOrig +"' "
	_cQuery += " AND DC_LOCALIZ = '"+ cLoclzOrig +"' "
	_cQuery += " AND C6_LOCAL   = '"+ cLocOrig +"' "
	_cQuery += " ORDER BY C9_QTDLIB DESC "
	
	_cQuery := ChangeQuery(_cQuery)
	
	If Select(_cAlias) > 0
		(_cAlias)->(DbCloseArea())
	EndIf
	
	DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
	
	MemoWrite('\Querys\KMESTF02.sql',_cQuery)
	
	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	
	If (_cAlias)->(Eof())//Fim de arquivo - Não achou pedido
		
		_lPedAchou := .F.
	else
		cItemx := (_cAlias)->C6_ITEM
	EndIf
	
	_nQtdTra := nQuant260
	
	If !_lPedAchou//Verifica se tem reserva
		
		_cQuery := " SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_QTDVEN,DC_LOCALIZ,C6_QTDEMP,C6_QTDLIB C9_QTDLIB, C6_LOCALIZ, C6_RESERVA
		_cQuery += " FROM " + RETSQLNAME("SDC") + " (NOLOCK) SDC "
		_cQuery += " INNER JOIN " + RETSQLNAME("SC0") + " (NOLOCK) SC0 ON C0_FILIAL = DC_FILIAL AND C0_NUM = DC_PEDIDO AND C0_PRODUTO = DC_PRODUTO AND SC0.D_E_L_E_T_ <> '*' "
		_cQuery += " LEFT  JOIN " + RETSQLNAME("SC6") + " (NOLOCK) SC6 ON C6_FILIAL = '"+ xFilial("SC6") +"' AND C6_RESERVA = C0_NUM AND C6_PRODUTO = C0_PRODUTO AND SC6.D_E_L_E_T_ <> '*' "
		_cQuery += " WHERE  SDC.D_E_L_E_T_ <> '*' AND DC_FILIAL = '"+ xFilial("SDC") +"' AND DC_PRODUTO = '"+ cCodOrig +"' AND DC_LOCALIZ = '"+ cLoclzOrig +"' "
		_cQuery += " AND DC_LOCAL = '"+ cLocOrig +"' AND DC_QUANT > 0 AND DC_ORIGEM = 'SC0' "
		_cQuery += " AND SC6.D_E_L_E_T_ <> '*' "
		_cQuery += " AND C6_BLQ <> 'R' "
		_cQuery += " AND C6_NOTA = '' "
		
		_cQuery := ChangeQuery(_cQuery)
		
		If Select(_cAlias) > 0
			(_cAlias)->(DbCloseArea())
		EndIf
		
		DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
		
		MemoWrite('\Querys\KMESTF02_SC0.sql',_cQuery)
		
		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())
		
		If (_cAlias)->(Eof())//Fim de arquivo - Não achou pedido
			
			_lPedAchou := .F.
			
		Else
			
			_lPedAchou	:= .T.
			
		EndIf
		
		If !_lPedAchou //Se não achou eu verifico se tem a reseva, mas não ta em pedido
			
			_cQuery := " SELECT * "
			_cQuery += " FROM " + RETSQLNAME("SDC") + " (NOLOCK) SDC "
			_cQuery += " INNER JOIN " + RETSQLNAME("SC0") + " (NOLOCK) SC0 ON C0_FILIAL = DC_FILIAL AND C0_NUM = DC_PEDIDO AND C0_PRODUTO = DC_PRODUTO AND SC0.D_E_L_E_T_ <> '*' "
			_cQuery += " WHERE SDC.D_E_L_E_T_ <> '*' "
			_cQuery += " AND DC_FILIAL  = '"+ xFilial("SDC") +"' "
			_cQuery += " AND DC_PRODUTO = '"+ cCodOrig +"' "
			_cQuery += " AND DC_LOCALIZ = '"+ cLoclzOrig +"' "
			_cQuery += " AND DC_LOCAL   = '"+ cLocOrig +"' "
			_cQuery += " AND DC_QUANT > 0 "
			_cQuery += " AND DC_ORIGEM = 'SC0' "
			
			_cQuery := ChangeQuery(_cQuery)
			
			If Select(_cAlias) > 0
				(_cAlias)->(DbCloseArea())
			EndIf
			
			DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
			
			MemoWrite('\Querys\KMESTF02_SC01.sql',_cQuery)
			
			DbSelectArea(_cAlias)
			(_cAlias)->(DbGoTop())
			
			While (_cAlias)->(!Eof())  .And. _nQtdTra > 0
				
				_nQtdTra -= (_cAlias)->DC_QUANT
				
				SC0->(DbGoTop())
				If SC0->(DbSeek(xFilial("SC0")+(_cAlias)->C0_NUM + (_cAlias)->C0_PRODUTO))
					
					AADD(_aExcRes,{SC0->C0_NUM})
					
					AADD(_aReserv,{"SC0",;  //chave de busca
					.T.,; //Se será necessário alterar a reserva
					SC0->C0_TIPO     ,;
					SC0->C0_DOCRES   ,;
					SC0->C0_SOLICIT  ,;
					SC0->C0_FILRES   ,;
					SC0->C0_NUM      ,;
					SC0->C0_PRODUTO  ,;
					SC0->C0_LOCAL    ,;
					SC6->C6_QTDVEN   ,;
					SC0->C0_NUMLOTE  ,;
					SC0->C0_LOTECTL  ,;
					SC0->C0_LOCALIZ  ,;
					SC0->C0_NUMSERI  })
					
				EndIf
				
				(_cAlias)->(DbSkip())
				
			EndDo
			
		EndIf
		
	EndIf
	
	If _lPedAchou//Achou pedido
		
		DbSelectArea(_cAlias)
		(_cAlias)->(DbGoTop())
		
		While (_cAlias)->(!Eof())  .And. _nQtdTra > 0
			
			_nQtdTra -= (_cAlias)->C6_QTDVEN
			
			If (_cAlias)->C9_QTDLIB > 0//Liberado
				
				//                        1                   2                 3                     4                 5
				AADD(_aPedLib,{(_cAlias)->C6_FILIAL,(_cAlias)->C6_NUM,(_cAlias)->C6_ITEM,(_cAlias)->C6_LOCALIZ,(_cAlias)->C6_RESERVA})
				
			Else //Não liberado
				
				//                        1                   2                 3                     4                 5
				AADD(_aPedNor,{(_cAlias)->C6_FILIAL,(_cAlias)->C6_NUM,(_cAlias)->C6_ITEM,(_cAlias)->C6_LOCALIZ,(_cAlias)->C6_RESERVA})
				
			EndIf
			
			(_cAlias)->(DbSkip())
			
		EndDo
		
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		
		If Len(_aPedLib) > 0
			
			For _nx := 1 To Len(_aPedLib)
				
				_aCabec := {}
				_aItens := {}
				lMsErroAuto := .F.
				
				SC5->(DbGoTop())
				SC5->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
				
				SC6->(DbGoTop())
				SC6->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
				
				aadd(_aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
				aadd(_aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
				aadd(_aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
				aadd(_aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
				aadd(_aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
				aadd(_aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})
				If Empty(AllTrim(SC5->C5_CONTRA))
					
					aadd(_aCabec,{"C5_CONTRA","000",Nil})
					
				Else
					
					aadd(_aCabec,{"C5_CONTRA",SC5->C5_CONTRA,Nil})
					
				EndIf
				
				While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedLib[_nx,1] .And. SC6->C6_NUM == _aPedLib[_nx,2]
					
					If SC6->C6_LOCAL == cLocOrig .and. SC6->C6_ITEM == cItemx
						
						SB1->(DbGoTop())
						SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
						
						_aLinha := {}
						
						aadd(_aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM,Nil})
						aadd(_aLinha,{"AUTDELETA" ,"N"              ,Nil})
						aadd(_aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO  ,Nil})
						aadd(_aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN   ,Nil})
						aadd(_aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN   ,Nil})
						aadd(_aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT   ,Nil})
						aadd(_aLinha,{"C6_VALOR"  ,SC6->C6_VALOR    ,Nil})
						
						If !Empty(AllTrim(SC6->C6_RESERVA))//Se Tiver Reserva
							
							SC0->(DbGoTop())
							If SC0->(DbSeek(xFilial("SC0")+SC6->C6_RESERVA + SC6->C6_PRODUTO))
								
								If SC6->C6_ITEM == _aPedLib[_nx,3]
									AADD(_aExcRes,{SC6->C6_RESERVA})
								EndIf
								
								AADD(_aReserv,{SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,;  //1 - chave de busca
								SC6->C6_ITEM == _aPedLib[_nx,3],; //2 - Se será necessário alterar a reserva
								SC0->C0_TIPO     ,;//3
								SC0->C0_DOCRES   ,;//4
								SC0->C0_SOLICIT  ,;//5
								SC0->C0_FILRES   ,;//6
								SC0->C0_NUM      ,;//7
								SC0->C0_PRODUTO  ,;//8
								SC0->C0_LOCAL    ,;//9
								SC6->C6_QTDVEN   ,;//10
								SC0->C0_NUMLOTE  ,;//11
								SC0->C0_LOTECTL  ,;//12
								SC0->C0_LOCALIZ  ,;//13
								SC0->C0_NUMSERI  })//14
							EndIf
							
							aadd(_aLinha,{"C6_RESERVA",''           ,Nil})
							
							If SB1->B1_LOCALIZ == 'S'
								
								aadd(_aLinha,{"C6_LOCALIZ",''           ,Nil})
								
							EndIf
							
							
						Else
							
							If SB1->B1_LOCALIZ == 'S'
								
								If SC6->C6_ITEM == _aPedLib[_nx,3]
									
									aadd(_aLinha,{"C6_LOCALIZ",''           ,Nil})
									
								Else
									
									If !Empty(AllTrim(SC6->C6_LOCALIZ))
										
										AADD(_aPVEnd,{SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,;  //1 - chave de busca
										SC6->C6_LOCALIZ  })//Endereço
										
										aadd(_aLinha,{"C6_LOCALIZ",''  ,Nil})
										
									Else
										
										aadd(_aLinha,{"C6_LOCALIZ",SC6->C6_LOCALIZ  ,Nil})
										
									EndIf
									
								EndIf
								
							EndIf
							
						EndIf
						
						aadd(_aLinha,{"C6_TES"    ,SC6->C6_TES      ,Nil})
						aadd(_aItens,_aLinha)
						
					EndIf
					
					SC6->(DbSkip())
					
				EndDo
				
				//MATA410(_aCabec,_aItens,4)
				MsExecAuto({|x,y,z| MATA410(x,y,z)}, _aCabec, _aItens, 4)
				
				If lMsErroAuto
					_lSai       := .F.
					DisarmTransaction()
					MostraErro()
					_lPedOk := .F.
					Alert("Erro ao liberar empenho de pedido, por favor verifique o pedido "+_aPedLib[_nx,2]+"!")
					Return
				EndIf
				
			Next _nx
			
		EndIf
		
		If Len(_aPedNor) > 0
			
			For _nx := 1 To Len(_aPedNor)
				
				_aCabec := {}
				_aItens := {}
				lMsErroAuto := .F.
				
				SC5->(DbGoTop())
				SC5->(DbSeek(_aPedNor[_nx,1]+_aPedNor[_nx,2]))
				
				SC6->(DbGoTop())
				SC6->(DbSeek(_aPedNor[_nx,1]+_aPedNor[_nx,2]))
				
				aadd(_aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
				aadd(_aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
				aadd(_aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
				aadd(_aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
				aadd(_aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
				aadd(_aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})
				If Empty(AllTrim(SC5->C5_CONTRA))
					
					aadd(_aCabec,{"C5_CONTRA","000",Nil})
					
				Else
					
					aadd(_aCabec,{"C5_CONTRA",SC5->C5_CONTRA,Nil})
					
				EndIf
				
				While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedNor[_nx,1] .And. SC6->C6_NUM == _aPedNor[_nx,2]
					
					If SC6->C6_LOCAL == cLocOrig .and. SC6->C6_ITEM == cItemx
						
						SB1->(DbGoTop())
						SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
						
						_aLinha := {}
						
						aadd(_aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM,Nil})
						aadd(_aLinha,{"AUTDELETA" ,"N"              ,Nil})
						aadd(_aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO  ,Nil})
						aadd(_aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN   ,Nil})
						aadd(_aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN   ,Nil})
						aadd(_aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT   ,Nil})
						aadd(_aLinha,{"C6_VALOR"  ,SC6->C6_VALOR    ,Nil})
						
						If !Empty(AllTrim(SC6->C6_RESERVA))//Se Tiver Reserva
							
							SC0->(DbGoTop())
							If SC0->(DbSeek(xFilial("SC0")+SC6->C6_RESERVA + SC6->C6_PRODUTO))
								
								If SC6->C6_ITEM == _aPedNor[_nx,3]
									AADD(_aExcRes,{SC6->C6_RESERVA})
								EndIf
								
								AADD(_aReserv,{SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,;  //chave de busca
								SC6->C6_ITEM == _aPedNor[_nx,3],; //Se será necessário alterar a reserva
								SC0->C0_TIPO     ,;
								SC0->C0_DOCRES   ,;
								SC0->C0_SOLICIT  ,;
								SC0->C0_FILRES   ,;
								SC0->C0_NUM      ,;
								SC0->C0_PRODUTO  ,;
								SC0->C0_LOCAL    ,;
								SC6->C6_QTDVEN   ,;
								SC0->C0_NUMLOTE  ,;
								SC0->C0_LOTECTL  ,;
								SC0->C0_LOCALIZ  ,;
								SC0->C0_NUMSERI  })
							EndIf
							
							aadd(_aLinha,{"C6_RESERVA",''           ,Nil})
							
							If SB1->B1_LOCALIZ == 'S'
								
								aadd(_aLinha,{"C6_LOCALIZ",''           ,Nil})
								
							EndIf
							
						Else
							
							If SB1->B1_LOCALIZ == 'S'
								
								If SC6->C6_ITEM == _aPedNor[_nx,3]
									
									aadd(_aLinha,{"C6_LOCALIZ",''           ,Nil})
									
								Else
									aadd(_aLinha,{"C6_LOCALIZ",SC6->C6_LOCALIZ  ,Nil})
								EndIf
								
							EndIf
							
						EndIf
						
						aadd(_aLinha,{"C6_TES"    ,SC6->C6_TES      ,Nil})
						aadd(_aItens,_aLinha)
						
					EndIf
					
					SC6->(DbSkip())
					
				EndDo
				
				//MATA410(_aCabec,_aItens,4)
				MsExecAuto({|x,y,z| MATA410(x,y,z)}, _aCabec, _aItens, 4)
				
				If lMsErroAuto
					_lSai       := .F.
					DisarmTransaction()
					MostraErro()
					_lPedOk := .F.
					Alert("Erro ao liberar empenho de pedido, por favor verifique o pedido "+_aPedLib[_nx,2]+"!")
					Return
				EndIf
				
			Next _nx
			
		EndIf
		
	EndIf
	//Exclui a Reserva
	If Len(_aExcRes) > 0
		_lRes := fExcReserv(_aExcRes,_lPedAchou)
	EndIf
	If !_lRes
		DisarmTransaction()
		Return
	EndIf
	//---------ESPECIFICO KOMFORT FIM-------------
	
	If _lPedOk
		
		If 	a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,;
			cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,cServico,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,cLoteDigiD,dDtVldDest,cCAT83O,cCAT83D)
			// Processa Gatilhos
			EvalTrigger()
			If __lSX8
				ConfirmSX8()
			EndIf
			
			//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os
			//-- registros do SDB para convocacao, ou exibir as mensagens de erro WMS caso necessário
			If a260IntWMS() .And. !lWmsNew
				WmsExeDCF('2')
			EndIf
			
			
			//---------ESPECIFICO KOMFORT INICIO----------
			
			//Cria Reseva
			If Len(_aReserv) > 0
				_lRes := fCriaRes(_aReserv)
			EndIf
			If !_lRes
				DisarmTransaction()
				Return
			EndIf
			
			If _lPedAchou
				
				If Len(_aPedLib) > 0
					
					For _nx := 1 To Len(_aPedLib)
						
						_aCabec := {}
						_aItens := {}
						lMsErroAuto := .F.
						
						SC5->(DbGoTop())
						SC5->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
						
						SC6->(DbGoTop())
						SC6->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
						
						aadd(_aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
						aadd(_aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
						aadd(_aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
						aadd(_aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
						aadd(_aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
						aadd(_aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})
						
						While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedLib[_nx,1] .And. SC6->C6_NUM == _aPedLib[_nx,2]
							
							If SC6->C6_LOCAL == cLocOrig .and. SC6->C6_ITEM == cItemx
								
								SB1->(DbGoTop())
								SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
								
								_aLinha := {}
								
								aadd(_aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM,Nil})
								aadd(_aLinha,{"AUTDELETA" ,"N"              ,Nil})
								aadd(_aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO  ,Nil})
								aadd(_aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN   ,Nil})
								aadd(_aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN   ,Nil})
								aadd(_aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT   ,Nil})
								aadd(_aLinha,{"C6_VALOR"  ,SC6->C6_VALOR    ,Nil})
								//aadd(_aLinha,{"C6_QTDLIB" ,SC6->C6_QTDVEN   ,Nil})
								
								_nPos := Ascan(_aReserv,{|x|Alltrim(X[1])==SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM})
								
								If _nPos > 0 //Tem Reserva
									
									_cReserv := ''
									_cReserv := _aReserv[_nPos,7]
									
									aadd(_aLinha,{"C6_RESERVA",_cReserv ,Nil})
									
								Else
									
									If SB1->B1_LOCALIZ == 'S'
										
										If SC6->C6_ITEM == _aPedLib[_nx,3]
											
											If !Empty(AllTrim(_aPedLib[_nx,4]))
												
												aadd(_aLinha,{"C6_LOCALIZ",cLocLzDest   ,Nil})
												
											EndIf
										Else
											
											_nPos := Ascan(_aPVEnd,{|x|Alltrim(X[1])==SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM})
											
											If _nPos > 0
												
												aadd(_aLinha,{"C6_LOCALIZ",_aPVEnd[_nPos,2]  ,Nil})
												
											Else
												
												aadd(_aLinha,{"C6_LOCALIZ",SC6->C6_LOCALIZ  ,Nil})
												
											EndIf
											
										EndIf
										
									EndIf
									
								EndIf
								
								aadd(_aLinha,{"C6_TES"    ,SC6->C6_TES      ,Nil})
								aadd(_aItens,_aLinha)
								
							EndIf
							
							SC6->(DbSkip())
							
						EndDo
						
						//MATA410(_aCabec,_aItens,4)
						MsExecAuto({|x,y,z| MATA410(x,y,z)}, _aCabec, _aItens, 4)
						
						If lMsErroAuto
							DisarmTransaction()
							MostraErro()
							_lPedOk := .F.
							Alert("Erro ao liberar empenho de pedido, por favor verifique o pedido "+_aPedLib[_nx,2]+"!")
							Return
						EndIf
						
					Next _nx
					
					For _nx := 1 To Len(_aPedLib)
						
						//Libera o pedido
						SC6->(DbGoTop())
						SC6->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
						
						While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedLib[_nx,1] .And. SC6->C6_NUM == _aPedLib[_nx,2]
							/*
							SC9->(DbSetOrder(1))
							If SC9->(DbSeek(xFilial("SC9") + AvKey(_aPedLib[_nx,2],"C9_NUM") + AvKey(_aPedLib[_nx,3],"C9_ITEM") ))
								Estorna a Liberação do Pedido por meio da rotina padrão de estorno.
								A460Estorna()
							EndIF
							*/
							
							lAvEst	:= .T.
							//FwMsgRun( ,{|| fLibPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN) }, , "Realizando liberação do pedido de vendas, Por Favor Aguardar..." )
							MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
							
							SC6->(DbSkip())
							
						EndDo
						
					Next _nx
					
				EndIf
				
				If Len(_aPedNor) > 0
					
					For _nx := 1 To Len(_aPedNor)
						
						_aCabec := {}
						_aItens := {}
						lMsErroAuto := .F.
						
						SC5->(DbGoTop())
						SC5->(DbSeek(_aPedNor[_nx,1]+_aPedNor[_nx,2]))
						
						SC6->(DbGoTop())
						SC6->(DbSeek(_aPedNor[_nx,1]+_aPedNor[_nx,2]))
						
						aadd(_aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
						aadd(_aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
						aadd(_aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
						aadd(_aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
						aadd(_aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
						aadd(_aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})
						
						While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedNor[_nx,1] .And. SC6->C6_NUM == _aPedNor[_nx,2]
							
							If SC6->C6_LOCAL == cLocOrig .and. SC6->C6_ITEM == cItemx
								
								SB1->(DbGoTop())
								SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
								
								_aLinha := {}
								
								aadd(_aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM,Nil})
								aadd(_aLinha,{"AUTDELETA" ,"N"              ,Nil})
								aadd(_aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO  ,Nil})
								aadd(_aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN   ,Nil})
								aadd(_aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN   ,Nil})
								aadd(_aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT   ,Nil})
								aadd(_aLinha,{"C6_VALOR"  ,SC6->C6_VALOR    ,Nil})
								
								_nPos := Ascan(_aReserv,{|x|Alltrim(X[1])==SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM})
								
								If _nPos > 0 //Tem Reserva
									
									_cReserv := ''
									_cReserv := _aReserv[_nPos,7]
									
									aadd(_aLinha,{"C6_RESERVA",_cReserv ,Nil})
									
								Else
									
									If SB1->B1_LOCALIZ == 'S'
										
										If SC6->C6_ITEM == _aPedNor[_nx,3]
											
											If !Empty(Alltrim(_aPedNor[_nx,4]))
												
												aadd(_aLinha,{"C6_LOCALIZ",cLocLzDest   ,Nil})
												
											EndIf
										Else
											aadd(_aLinha,{"C6_LOCALIZ",SC6->C6_LOCALIZ  ,Nil})
										EndIf
										
									EndIf
									
								EndIf
								
								aadd(_aLinha,{"C6_TES"    ,SC6->C6_TES      ,Nil})
								aadd(_aItens,_aLinha)
								
							EndIf
							
							SC6->(DbSkip())
							
						EndDo
						
						//MATA410(_aCabec,_aItens,4)
						MsExecAuto({|x,y,z| MATA410(x,y,z)}, _aCabec, _aItens, 4)
						
						If lMsErroAuto
							DisarmTransaction()
							MostraErro()
							_lPedOk := .F.
							Alert("Erro ao liberar empenho de pedido, por favor verifique o pedido "+_aPedNor[_nx,2]+"!")
							Return
						Else
							
						EndIf
						
					Next _nx
					
				EndIf
				
			EndIf
			
			MsgInfo("Transferência realizado com sucesso!","TRANSOK")
			_lOkGer := .T.
			_lSai := .F.
			
			//---------ESPECIFICO KOMFORT FIM-------------
		Else
			_lSai       := .F.
			DisarmTransaction()
			MostraErro()
			If __lSX8
				RollBackSX8()
			EndIf
			Return
		EndIf
		
	Else
		
		_lSai       := .F.
		DisarmTransaction()
		
	EndIf
	
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desativa a tecla F4 neste momento por seguranca              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 To
A260Comum(aCtbDia)

END TRANSACTION

If _lOkGer .And. Len(_aPedLib) > 0 .And. _lPedAchou
	For _nx := 1 To Len(_aPedLib)
		
		//Libera o pedido
		SC6->(DbGoTop())
		SC6->(DbSeek(_aPedLib[_nx,1]+_aPedLib[_nx,2]))
		
		While SC6->(!Eof()) .And. SC6->C6_FILIAL == _aPedLib[_nx,1] .And. SC6->C6_NUM == _aPedLib[_nx,2]
			
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)
			
			SC6->(DbSkip())
			
		EndDo
		
	Next _nx
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260AVALF4³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 01/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada da funcao F4                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA241                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260AvalF4()
Local cCadastroSav := cCadastro
If Upper(ReadVar()) $ "CNUMLOTE/CLOTEDIGI"
	F4Lote(,,,"A260",cCodOrig,cLocOrig,Nil,cLoclzOrig)
ElseIf Upper(ReadVar()) == "CCODORIG" .Or. Upper(ReadVar()) == "CCODDEST" .Or. Upper(ReadVar()) == "NQUANT260"
	MaViewSB2(cCodOrig)
ElseIf Upper(ReadVar()) == "CLOCLZORIG" .Or. Upper(ReadVar()) == "CNUMSERIE"
	F4RetSld(,,,"A260", cCodOrig, cLocOrig,, ReadVar() )
ElseIf Upper(ReadVar()) == "CLOCLZDEST"
	F4RetSld(,,,"A260", cCodDest, cLocDest,, ReadVar() )
EndIf
// -- Recupera titulo
cCadastro := cCadastroSav
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260PosGet³ Autor ³ Emerson Rony Oliveira ³ Data ³ 18/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que posiciona os campos na tela de acordo com o     ³±±
±±³          ³ tamanho do codigo do produto                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor com as coordenadas/tamanhos dos SAYS         ³±±
±±³          ³ ExpA2 = Vetor com as coordenadas/tamanhos dos GETS         ³±±
±±³          ³ ExpA3 = Vetor com as coordenadas/tamanho da tela           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260PosGet(aSay, aGet, aTela)
Local nTamCod := TamSX3("D3_COD")[1]

DEFAULT aSay  := {}
DEFAULT aGet  := {}
DEFAULT aTela := {}

If !(nTamCod > 15) // tamanho minimo (15)
	aTela:= {140,000,550,730}
	
	aSay := {{036,040,130,006}, {074,040,130,006}, {020,011,024,007}, {020,118,032,016}, {020,178,035,016},;
	{020,178,035,013}, {061,011,024,007}, {058,118,032,016}, {058,178,035,016}, {061,178,035,013},;
	{096,004,025,016}, {096,118,012,013}, {096,179,022,007}, {096,234,025,016}, {096,307,009,013},;
	{118,003,030,016}, {118,104,030,016}, {118,205,015,007}, {118,270,029,007},;
	{020,309,035,013}, {059,309,035,013}, {118,330,029,014}}
	
	aGet := {{003,006,045,362}, {049,006,085,362}, {020,039,068,009}, {020,153,012,009}, {020,216,012,009},;
	{020,246,060,009}, {059,039,068,009}, {059,153,012,009}, {059,216,012,009}, {059,246,060,009},;
	{096,029,085,009}, {096,132,045,009}, {096,204,027,009}, {096,260,044,009}, {096,323,010,009},;
	{118,037,063,009}, {118,137,063,009}, {118,223,040,009}, {118,282,044,009},;
	{020,327,032,010}, {059,327,032,010}, {118,344,035,009}}
Else
	aTela:= {140,000,550,770}
	
	aSay := {{038,040,130,006}, {074,040,130,006}, {026,011,024,007}, {022,186,032,016}, {022,246,035,016},;
	{026,246,035,013}, {061,011,024,007}, {058,186,032,016}, {058,246,035,016}, {061,246,035,013},;
	{096,004,025,016}, {096,118,012,013}, {096,179,022,007}, {096,234,025,016}, {096,307,009,013},;
	{118,003,030,016}, {118,104,030,016}, {118,205,015,007}, {118,270,029,007},;
	{038,190,035,013}, {078,190,035,013}, {118,330,029,014}}
	
	aGet := {{003,006,045,380}, {049,006,085,380}, {024,039,136,009}, {024,221,012,009}, {024,284,012,009},;
	{024,314,060,009}, {059,039,136,009}, {059,221,012,009}, {059,284,012,009}, {059,314,060,009},;
	{096,029,085,009}, {096,132,045,009}, {096,204,027,009}, {096,260,044,009}, {096,323,010,009},;
	{118,037,063,009}, {118,137,063,009}, {118,223,040,009}, {118,282,044,009},;
	{038,246,032,010}, {074,246,032,010}, {118,344,035,009}}
EndIf

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±³                   ROTINAS DE CRITICA DE CAMPOS                        ³±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260IniCpo³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14/03/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa campos a partir do codigo do produto            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260IniCpo(ExpN1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = 1 - inicializa campos do codigo origem             ³±±
±±³          ³         2 - inicializa campos do codigo destino            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260IniCpo(nOrigDest,cServico)
Static lA260INI := Nil
Local lRet    :=.T.
Local cVar    := IIf(nOrigDest=1,cCodOrig,cCodDest)
Local nDec2UM := TamSX3('D3_QTSEGUM')[2]
Local lWmsNew := SuperGetMv("MV_WMSNEW",.F.,.F.)

Default cServico := ""

lA260INI := If(lA260INI == Nil,ExistBlock("A260INI"),lA260INI)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa PE na digitacao do campo                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lA260INI
	lRet := Execblock("A260INI",.F.,.F.)
	lRet := If(ValType(lRet)#"L",.T.,lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o usuario tem permissao de inclusao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .AND. IsInCallStack("MATA260") .Or. IsInCallStack("MATA261")
	lRet := MaAvalPerm(1,{cVar,"MTA260",3})
EndIf
If !lRet
	Help(,,1,'SEMPERM')
EndIf

// Utilizado para verificar se quando o protudo for WMS novo não efetuar transferencias quando for Produto PAI
If lRet .And. a260IntWMS(cVar) .And. lWmsNew
	lRet:= MTVerPai(cVar)
EndIf

// Utilizado para verificar se quando o produdo for WMS novo não efetuar transferencias
If lRet .And. IntDl() .And. lWmsNew .And. (IntDl(cVar) .Or. IntDl(cCodOrig))
	Help(" ",1,"A260WMS",,'Produto informado controlado por WMS não é possivel efetuar a transferência! Utilize o monitor de transferência WMS!',1,0)
	lRet:= .F.
EndIf

If lRet
	dbSelectArea("SB1")
	If !SB1->(dbSeek(xFilial('SB1')+cVar))
		Help(" ",1,"A260SB1")
		lRet:=.F.
	EndIf
	If !ExistCpo("SB1")
		lRet:=.F.
	EndIf
	If lRet .And. nOrigDest == 1
		If cSavCdOri <> "" .And. cSavCdOri <> SB1->B1_COD
			cCodDest	:= ""
			cUmDest	 	:= ""
			cLocDest  	:= ""
			cDescDest	:= ""
		EndIf
		cSavCdOri  := SB1->B1_COD
		cUmOrig    := B1_UM
		cLocOrig   := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		cDescOrig  := B1_DESC
		cCodDest   := IIf(Empty(cCodDest),cCodOrig,cCodDest)
		cUmDest    := IIf(Empty(cUmDest),B1_UM,cUmDest)
		cLocDest   := IIf(Empty(cLocDest),RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocDest)
		cDescDest  := IIf(Empty(cDescDest),B1_DESC,cDescDest)
		nQuant260D := Round(QtdComp(ConvUm(B1_COD, nQuant260, nQuant260D, 2)), nDec2UM)
		
		If a260IntWMS(cCodOrig) .Or. lWmsNew
			SB5->(dbSetOrder(1))
			If SB5->(dbSeek(xFilial("SB5")+cCodOrig))
				cServico := SB5->B5_SERVINT
			EndIf
		EndIf
	Else
		cUmDest  := B1_UM
		cLocDest := IIf(Empty(cLocDest),RetFldProd(SB1->B1_COD,"B1_LOCPAD"),cLocDest)
		cDescDest:= B1_DESC
	EndIf
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260Lote   ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 25/11/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡„o referente aos campos de Lote                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260Lote()
Local cAlias := Alias()
Local nOrder := IndexOrd()
Local nRecno := Recno()
Local lRet   := .T.
Local cVar	 := Upper(ReadVar())

If Empty(&(ReadVar()))
	Help(" ",1,"MA260LOTE")
	lRet:=.F.
EndIf

If lRet
	If Rastro(cCodOrig,'S') .And. If(cVar == "CNUMLOTE",!Empty(cLoteDigi),!Empty(cNumLote))
		SB8->(dbSetOrder(2))
		If SB8->(dbSeek(xFilial('SB8') + cNumLote + cLoteDigi + cCodOrig + cLocOrig, .F.))
			cLoteDigi := SB8->B8_LOTECTL
			dDtValid  := SB8->B8_DTVALID
			nPotencia := SB8->B8_POTENCI
		Else
			Help(' ', 1, 'A240LOTERR')
			lRet := .F.
		EndIf
	Else
		SB8->(dbSetOrder(3))
		If SB8->(dbSeek(xFilial('SB8')+cCodOrig+cLocOrig+cLoteDigi, .F.))
			dDtValid :=SB8->B8_DTVALID
			nPotencia:=SB8->B8_POTENCI
		Else
			Help(' ', 1, 'A240LOTERR')
			lRet := .F.
		EndIf
	EndIf
EndIf

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoto(nRecno)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260Quant ³ Autor ³ Fernando Joly Siquini ³ Data ³19/07/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata a Convers„o de Unidades de Medida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260Quant(ExpN1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ ExpN1 = 1 - Trata 1a Unidade de Medida                     ³±±
±±³          ³         2 - Trata 2a Unidade de Medida                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MatA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A260Quant(nTipoUM)

Local aAreaAnt   := GetArea()
Local aAreaSB1   := SB1->(GetArea())
Local aAreaSB2   := SB2->(GetArea())
Local aAreaSB8   := SB8->(GetArea())
Local aAreaSBE   := SBE->(GetArea())
Local lEstNeg    := .F.
Local lRastro    := .F.
Local lLocaliza  := .F.
Local lRet       := .T.
Local nTam1UM    := TamSX3('D3_QUANT')[1]
Local nTam2UM    := TamSX3('D3_QTSEGUM')[1]
Local nDec1UM    := TamSX3('D3_QUANT')[2]
Local nDec2UM    := TamSX3('D3_QTSEGUM')[2]
Local nQuantVld  := 0
Local lEmpPrev   := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local lWmsNew	 := SuperGetMv("MV_WMSNEW",.F.,.F.)
Local lValidPE
Local oSaldoWMS  := Iif(lWmsNew,WMSDTCEstoqueEndereco():New(),Nil)

SB1->(dbSetOrder(1))

If nTipoUM == 1
	//-- Verifica se deve reiniciar a 2a.UM com base na 1a.UM digitada
	nQuantVld := Round(QtdComp(ConvUm(cCodOrig, nQuant260, nQuant260D,2)), nDec2UM)
	If !(StrZero(nQuant260D,nTam2UM,nDec2UM)==StrZero(nQuantVld,nTam2UM,nDec2UM))
		nQuant260D := nQuantVld
	EndIf
ElseIf nTipoUM == 2
	//-- Verifica se deve reiniciar a 1a.UM com base na 2a.UM digitada
	nQuantVld := Round(QtdComp(ConvUm(cCodOrig, nQuant260, nQuant260D,2)), nDec2UM)
	//-- Recalcula a 1a.UM somente quando a reconversao para a 2a.UM divergir da 2a.UM digitada
	If !(StrZero(nQuant260D,nTam2UM,nDec2UM)==StrZero(nQuantVld,nTam2UM,nDec2UM))
		nQuantVld := Round(QtdComp(ConvUm(cCodOrig, nQuant260, nQuant260D, 1)), nDec1UM)
		If !(StrZero(nQuant260,nTam1UM,nDec1UM)==StrZero(nQuantVld,nTam1UM,nDec1UM))
			nQuant260 := nQuantVld
		EndIf
	EndIf
EndIf

//-- Valida Movimenta‡äes c/Quantidade Negativa
If QtdComp(nQuant260) < QtdComp(0)
	Help(' ', 1, 'POSIT')
	lRet := .F.
EndIf

If lRet
	lEstNeg   := (GetMv('MV_ESTNEG')=='N')
	lRastro   := Rastro(cCodOrig)
	lLocaliza := Localiza(cCodOrig,.T.)
EndIf

If lRet .And. (lEstNeg .Or. lRastro .Or. lLocaliza)
	//-- Valida Saldo em Estoque Negativo
	If lEstNeg
		dbSelectArea('SB2')
		aAreaSB2 := GetArea()
		SB2->(dbSetOrder(1))
		If !SB2->(dbSeek(xFilial('SB2')+cCodOrig+cLocOrig))
			Help(' ', 1, 'REGNOIS')
			lRet := .F.
		ElseIf QtdComp(SaldoMov(Nil, Nil, Nil,If(mv_par03==1,.F.,Nil), Nil,Nil, If(lLocaliza, If((cCodOrig==cCodDest.And.cLocOrig==cLocDest.And.cLoclzOrig#cLoclzDest), .F., Nil), Nil),If(Type('dEmis260') == "D",dEmis260,dDataBase))) < QtdComp(nQuant260)
			Help(' ', 1, 'MA240NEGAT')
			lRet := .F.
		EndIf
		dbSetOrder(aAreaSB2[2])
		dbGoto(aAreaSB2[3])
	EndIf
	
	//-- Valida Saldo em Estoque ref. a Rastreabilidade
	If lRet .And. lRastro
		dbSelectArea('SB8')
		aAreaSB8 := GetArea()
		If	Rastro(cCodOrig, 'S')
			SB8->(dbSetOrder(2))
			If SB8->(dbSeek(xFilial('SB8')+cNumLote+cLoteDigi+cCodOrig+cLocOrig, .F.))
				If QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrev,Nil,dEmis260)) < QtdComp(nQuant260)
					Help(' ', 1, 'A240NEGAT' )
					lRet := .F.
				EndIf
			EndIf
		ElseIf QtdComp(SaldoLote(cCodOrig,cLocOrig,cLoteDigi,Nil,Nil,Nil,Nil,dEmis260)) < QtdComp(nQuant260)
			Help(' ', 1, 'A240NEGAT')
			lRet := .F.
		EndIf
		dbSetOrder(aAreaSB8[2])
		dbGoto(aAreaSB8[3])
	EndIf
	
	//-- Valida Saldo em Estoque ref. a Localiza‡Æo
	If lRet .And. lLocaliza
		If lRet
			dbSelectArea('SBE')
			aAreaSBE := GetArea()
			SBE->(dbSetOrder(1))
			If SBE->(dbSeek(xFilial('SBE')+cLocDest+cLoclzDest, .F.))
				If QtdComp(BE_CAPACID)>QtdComp(0) .And. (QtdComp(BE_CAPACID)<QtdComp(nQuant260+QuantSBF(cLocDest, cLoclzDest)))
					Help(' ', 1, 'MA265CAPAC')
					lRet := .F.
				EndIf
			EndIf
			
			If .F.//lRet - NÃO VALIDA O SALDO ATUAL - KOMFORT
				If !(lWmsNew .And. a260IntWMS(cCodOrig))
					If QtdComp(SaldoSBF(cLocOrig,cLoclzOrig,cCodOrig,cNumSerie,cLoteDigi,If(Rastro(cCodOrig,'S'),cNumLote,''))) < QtdComp(nQuant260)
						Help(' ', 1, 'SALDOLOCLZ')
						lRet := .F.
					EndIf
				Else
					If QtdComp(oSaldoWMS:GetSldWMS(cCodOrig,cLocOrig,cLoclzOrig,cLoteDigi,If(Rastro(cCodOrig, 'S'),cNumLote,''),cNumSerie)) < QtdComp(nQuant260)
						Help(' ', 1, 'SALDOLOCLZ')
						lRet := .F.
					EndIf
				EndIf
			EndIf //- FIM KOMFORT
			dbSetOrder(aAreaSBE[2])
			dbGoto(aAreaSBE[3])
		EndIf
	EndIf
EndIf

If ExistBlock("MT260UM")
	lValidPE := ExecBlock("MT260UM",.F.,.F.,{nTipoUM,lRet})
	If ValType(lValidPE) == "L"
		lRet := lValidPE
	EndIf
EndIf
SB1->(dbSetOrder(aAreaSB1[2]))
SB1->(dbGoto(aAreaSB1[3]))
RestArea(aAreaAnt)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260Data  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 20/03/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡„o do campo dEmis260                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260Data()
Local dData
Local dDataFec := MVUlmes()
Local lRet := .T.
dData:= &(ReadVar())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar data do ultimo fechamento em SX6.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dDataFec >= dData
	Help ( " ", 1, "FECHTO" )
	lRet := .F.
EndIf
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  A260TudoOK  ³ Larson Zordan               ³ Data ³ 26/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ - Verifica se existe o Ponto de Entrada MT260TOK e consiste  ³±±
±±³          ³   o retorno que devera ser logico.                           ³±±
±±³          ³ - Valida as informacoes inseridas pelo usuario.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260TudoOK(ExpC01,ExpC02)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC01 = Local(Almoxarifado) Controle Qualidade              ³±±
±±³          ³ ExpC02 = Codigo do Lote de destino                           ³±±
±±³          ³ ExpC03 = Codigo do Servico WMS                               ³±±
±±³          ³ ExpL04 = Indica se a validacao esta sendo executada pelo WMS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A260TudoOk(cLocCQ, cLoteDigiD, cServico, lWms, cDocto)
Local aAreaAnt   := GetArea()
Local aAreaSB2   := SB2->(GetArea())
Local aAreaSB8   := SB8->(GetArea())
Local aAreaSBE   := SBE->(GetArea())
Local lEstNeg    := .F.
Local lRastro    := .F.
Local lLocaliza  := .F.
Local lRet       := .T.
Local lEmpPrev   := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local lValida    := .T.
Local oTransfer  := Nil
Local lWmsSD3    := If(!(Type('lExecWms')=='U'), lExecWms, .F.)
Local lWmsNew	 := SuperGetMv("MV_WMSNEW",.F.,.F.)
Local oSaldoWMS  := Iif(lWmsNew,WMSDTCEstoqueEndereco():New(),Nil)
Local oOrdServ	 := Nil
Local cArmCQ := GetMV("MV_CQ")

Default lWms     := .F.
Default cDocto   := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para a validacao dos dados digitados nos    ³
//³ Gets fixos.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT260TOK")
	lRet := ExecBlock("MT260TOK",.F.,.F.,{cLoteDigiD})
	lRet := If(ValType(lRet)#"L",.T.,lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do armazem. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	lRet := MaAvalPerm(3,{cLocOrig,cCodOrig}) .And. MaAvalPerm(3,{cLocDest,cCodDest})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica calendário contábil                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	lRet := (CtbValiDt(Nil,DEMIS260,,Nil ,Nil ,{"EST001"}))
EndIf

// As validacoes abaixo devem ser executadas mesmo que exista o ponto de entrada e este retorne .T.
If lRet
	If lRet .And. cCodOrig+cUmOrig+cLocOrig+cLocLzOrig+cLoteDigi == cCodDest+cUmDest+cLocDest+cLoclzDest+If(!Empty(cLoteDigiD),cLoteDigiD,cLoteDigi)
		Help(" ",1,"MA260IGUAL") // A origem da transferência não pode ser igual ao destino
		lRet := .F.
	EndIf
	
	If lRet .And. Localiza(cCodOrig,.T.)
		// Avalia qtd utilizada em movimentos com Numero de Serie
		If !MtAvlNSer(cCodOrig,cNumSerie,nQuant260,nQuant260D)
			lRet := .F.
		EndIf
		
		If lRet .And. Empty(cLocLzOrig+cNumSerie)
			Help(" ",1,"LOCALIZOBR") //Quando o produto utiliza controle de Endereço, deve ter preenchido no movimento o campo Endereço, Número deSérie ou os dois.
			lRet := .F.
		EndIf
		
		// se produto e' o unico na localizacao
		If lRet .And. (!ProdLocali(cCodDest,cLocDest,cLoclzDest))
			lRet := .F.
		EndIf
	EndIf
	
	If  lRet .And. ((Localiza(cCodDest,.T.)) .Or. a260IntWMS(cCodDest))
		If cLocDest == cLocCQ
			If !ProdLocali(cCodDest,cLocDest,cLoclzDest)
				lRet := .F.
			EndIf
		EndIf
		
		// --- Validacoes WMS
		If lRet .And. !Empty(cLocLzDest) .And. a260IntWMS(cCodDest)
			If ExistBlock("MA260WMS")
				cRetPE := ExecBlock("MA260WMS",.F.,.F.,{cLocOrig,cCodOrig,cLoclzOrig})
				lValida := (!(ValType(CRetPE)=="C" .And. cLocDest $ cRetPE))
			EndIf
			If lValida
				If !lWmsNew
					lRet := WMSVldTran(cDocto, cServico, cCodOrig, cLocOrig, cLoclzOrig, cCodDest, cLocDest, cLoclzDest, cLoteDigi, cNumLote, cNumSerie, nQuant260)
				ElseIf !lWmsSD3
					If !Empty(cLoclzDest)
						oTransfer := WMSBCCTransferencia():New()
						// Endereco Origem
						oTransfer:oMovEndOri:SetArmazem(cLocOrig)
						oTransfer:oMovEndOri:SetEnder(cLoclzOrig)
						// Endereco Destino
						oTransfer:oMovEndDes:SetArmazem(cLocDest)
						oTransfer:oMovEndDes:SetEnder(cLoclzDest)
						// Produto
						oTransfer:oMovPrdLot:SetArmazem(cLocDest)
						oTransfer:oMovPrdLot:SetProduto(cCodOrig)
						oTransfer:oMovPrdLot:SetPrdOri(cCodOrig)
						oTransfer:oMovPrdLot:SetLoteCtl(cLoteDigi)
						oTransfer:oMovPrdLot:SetNumLote(cNumLote)
						oTransfer:oMovPrdLot:SetNumSer(cNumSerie)
						// Serviço
						oTransfer:oMovServic:SetServico(cServico)
						oTransfer:oOrdServ:SetDocto(cDocto)
						oTransfer:SetQuant(nQuant260)
						If !oTransfer:VldGeracao()
							WmsMessagem(oTransfer:GetErro(),"SIGAWMS",5/*MSG_HELP*/)
							lRet := .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lRet .And. (Rastro(cCodOrig) .And. Empty(If(Rastro(cCodOrig,"S"),cNumLote,cLoteDigi)))
		Help(" ",1,"MA260LOTE") //É obrigatória a digitação do número do lote, pois o produto utiliza rastreabilidade
		lRet := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a Qtde estiver em branco ele deve dar uma mensagem  ³
	//³ de que este registro nao sera' gravado.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. (nQuant260 == 0)
		Help(" ",1,"MA240NAOGR")
		lRet := .F.
	EndIf
	
	//--> Verifica se o saldo do armz esta liberado
	If lRet .And. (!SldBlqSB2(cCodOrig,cLocOrig))
		lRet := .F.
	EndIf
	
	//--> Verifica se o saldo do armz Dest esta liberado
	If lRet .And. (!SldBlqSB2(cCodOrig,cLocDest))
		lRet := .F.
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao do Custo FIFO On-Line                     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IsFifoOnLine()
		If SaldoSBD("SD3",cCodOrig,cLocOrig,Nil)[1] < nQuant260
			Help(" ",1,"DIVFIFO2")
			lRet := .F.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consistir saldo referente a Rastro, Localizacao e Quantidade Negativa  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		lEstNeg   := (GetMv('MV_ESTNEG')=='N')
		lRastro   := Rastro(cCodOrig)
		lLocaliza := Localiza(cCodOrig,.T.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa se o tipo do armazem permite a movimentacao |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. AvalBlqLoc(cCodOrig,cLocOrig,Nil,,cCodDest,cLocDest)
		lRet := .F.
	EndIf
	
	If lRet .And. (lEstNeg.Or.lRastro.Or.lLocaliza)
		//-- Valida Saldo em Estoque Negativo
		If lEstNeg
			dbSelectArea('SB2')
			aAreaSB2 := GetArea()
			SB2->(dbSetOrder(1))
			If !SB2->(dbSeek(xFilial('SB2')+cCodOrig+cLocOrig))
				Help(' ', 1, 'REGNOIS')
				lRet := .F.
			ElseIf QtdComp(SaldoMov(Nil, Nil, Nil,IIf(lWms,Nil,IIf(mv_par03==1,.F.,Nil)), Nil,Nil, If(lLocaliza, If((cCodOrig==cCodDest.And.cLocOrig==cLocDest.And.cLoclzOrig#cLoclzDest), .F., Nil), Nil),If(Type('dEmis260') == "D",dEmis260,dDataBase))) < QtdComp(nQuant260)
				Help(' ', 1, 'MA240NEGAT')
				lRet := .F.
			EndIf
			dbSetOrder(aAreaSB2[2])
			dbGoto(aAreaSB2[3])
		EndIf
		
		//-- Valida Saldo em Estoque ref. a Rastreabilidade
		If lRet .And. lRastro
			dbSelectArea('SB8')
			aAreaSB8 := GetArea()
			If	Rastro(cCodOrig, 'S')
				SB8->(dbSetOrder(2))
				If SB8->(dbSeek(xFilial('SB8')+cNumLote+cLoteDigi+cCodOrig+cLocOrig, .F.))
					If QtdComp(SB8Saldo(Nil,.T.,Nil,Nil,Nil,lEmpPrev,Nil,dEmis260)) < QtdComp(nQuant260)
						Help(' ', 1, 'A240NEGAT' )
						lRet := .F.
					EndIf
				EndIf
			Else
				If !(lWmsNew .And. a260IntWMS(cCodOrig))
					If QtdComp(SaldoLote(cCodOrig,cLocOrig,cLoteDigi,Nil,Nil,Nil,Nil,dEmis260)) < QtdComp(nQuant260)
						Help(' ', 1, 'A240NEGAT')
						lRet := .F.
					EndIf
				Else
					If QtdComp(oSaldoWMS:GetSldWMS(cCodOrig,cLocOrig,,cLoteDigi)) < QtdComp(nQuant260)
						Help(' ', 1, 'A240NEGAT')
						lRet := .F.
					EndIf
				EndIf
			EndIf
			dbSetOrder(aAreaSB8[2])
			dbGoto(aAreaSB8[3])
		EndIf
		
		//-- Valida Saldo em Estoque ref. a Localizacao
		If  lRet .And. !lWmsNew .And. !lWms .And. lLocaliza
			If lRet
				dbSelectArea('SBE')
				aAreaSBE := GetArea()
				SBE->(dbSetOrder(1))
				If SBE->(dbSeek(xFilial('SBE')+cLocDest+cLoclzDest, .F.))
					If QtdComp(BE_CAPACID)>QtdComp(0) .And. (QtdComp(BE_CAPACID)<QtdComp(nQuant260+QuantSBF(cLocDest, cLoclzDest)))
						Help(' ', 1, 'MA265CAPAC')
						lRet := .F.
					EndIf
				EndIf
				
				If .F.//lRet - NÃO VALIDA O SALDO ATUAL - KOMFORT
					If !(lWmsNew .And. a260IntWMS(cCodOrig))
						If QtdComp(SaldoSBF(cLocOrig,cLoclzOrig,cCodOrig,cNumSerie,cLoteDigi,If(Rastro(cCodOrig,'S'),cNumLote,''))) < QtdComp(nQuant260)
							Help(' ', 1, 'SALDOLOCLZ')
							lRet := .F.
						EndIf
					Else
						If QtdComp(oSaldoWMS:GetSldWMS(cCodOrig,cLocOrig,cLoclzOrig,cLoteDigi,If(Rastro(cCodOrig,'S'),cNumLote,''),cNumSerie)) < QtdComp(nQuant260)
							Help(' ', 1, 'SALDOLOCLZ')
							lRet := .F.
						EndIf
					EndIf
				EndIf//	FIM KOMFORT
				
				dbSetOrder(aAreaSBE[2])
				dbGoto(aAreaSBE[3])
			EndIf
		EndIf
		RestArea(aAreaAnt)
	EndIf
	
	If cLocOrig == cArmCQ .And. cLocOrig # cLocDest
		Help(" ",1,"A260LOCCQ")
		lRet := .F.
	EndIf
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260Local ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 27/02/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡„o do campo cLocOrig                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260Local(cLocOrig)
Static l260Local := Nil
Local lRet 		 := .T.
Local cAlias	 :=Alias()
Local nOrder	 :=IndexOrd()
Local nRecno	 :=Recno()
Local cLocal

Default cLocOrig := ''

cLocal    := If(Empty(cLocOrig),&(ReadVar()),cLocOrig)

l260Local :=If(l260Local==Nil,ExistBlock("A260LOC"),l260Local)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localizacoes - Valida armazem de transito                     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IsLocTran(cLocal)
	lRet := .F.
EndIf

If cLocal == GetMV("MV_CQ") .and. IIf(Empty(cLocOrig),.F.,cLocal <> cLocOrig)
	Help(" ",1,"A260LOCCQ")
	lRet:=.F.
ElseIf (cLocal==GetMv("MV_LOCPROC")) .And. If(Empty(cCodOrig),.T.,A260ApropI(cCodOrig))	//-- Soh impede transferencia do Armazem de Processo se o Produto for de "Apropriacao Indireta"
	If Aviso("Atencao","Transferencias do armazem de processo podem ser realizadas atraves de movimentacao especifica.",{"Confirma","Abandona"}) == 2
		lRet:=.F.
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto est  sendo inventariado.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If BlqInvent(cCodOrig,cLocal,,cLoclzOrig)
		Help(" ",1,"BLQINVENT",,cCodOrig+" Almox: "+cLocal,1,11)
		lRet:=.F.
	EndIf
	If lRet
		If l260Local
			ExecBlock("A260LOC",.F.,.F., {cCodOrig,cLocal,1}) //Terceiro parametro igual a 1 para indicar armazem origem
		EndIf
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If ! SB2->(dbSeek(xFilial('SB2')+cCodOrig+cLocal))
			Help(" ",1,"A260LOCAL")
			lRet:=.F.
		EndIf
		dbSelectArea(cAlias)
		dbSetOrder(nOrder)
		dbGoTo(nRecno)
	EndIf
EndIf
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A260Locali³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 14/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida as localizacoes da transferencia                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260Locali()
Local aArea     := GetArea()
Local cCampo    := ReadVar()
Local cConteudo := &(cCampo)
Local lRet      := .T.
If !Vazio(cConteudo)
	If cCampo == "CLOCLZORIG"
		lRet := ExistCpo("SBE",cLocOrig+cConteudo)
	ElseIf cCampo == "CLOCLZDEST"
		lRet := ExistCpo("SBE",cLocDest+cConteudo)
	EndIf
EndIf
If X3Obrigat('D3_LOCALIZ') .And. Vazio(cConteudo)
	lret := .F.
EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260Comum ³ Autor ³ Microsiga S.A.        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste referente a contabilizacao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A260Comum()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a260Comum(aCtbDia)
Local nX := 1
Default aCtbDia	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O" .And. Type("nTotal")=="N"
	If !lCriaHeader .And. nTotal<>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa perguntas deste programa                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ mv_par01 - Se mostra e permite digitar lancamentos contabeis   ³
		//³ mv_par02 - Se deve aglutinar os lancamentos contabeis          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MTA260",.F.)
		lDigita   := IIf(mv_par01 == 1,.T.,.F.)
		lAglutina := IIf(mv_par02 == 1,.T.,.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se ele criou o arquivo de prova ele deve gravar o rodape'    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RodaProva(nHdlPrv,nTotal)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o código de diário³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aCtbDia)
			cCodDiario := CtbaVerdia()
			For nX := 1 to Len(aCtbDia)
				aCtbDia[nX][3] := cCodDiario
			Next nX
		EndIf
		
		If cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina,,,,,,aCtbDia)
			lCriaHeader := .T.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava a data de Contabilizacao do campo D3_DTLANC         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nX := 1 To Len(aRegSD3)
				SD3->(dbGoTo(aRegSD3[nX]))
				RecLock("SD3",.F.)
				Replace D3_DTLANC With dDataBase
				MsUnLock()
			Next nX
		EndIf
	EndIf
EndIf

Return

/*----------------------------------------------------
Suavizar a nova verificação de integração com o WMS
------------------------------------------------------*/
Static Function a260IntWMS(cProduto)
Default cProduto := ""
If __lIntWMS
	Return IntWMS(cProduto)
Else
	Return IntDL(cProduto)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A260LocDest³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 29/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡„o do campo cLocDest                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260LocDest()
Local aArea		:= GetArea()
Local lRet		:= .T.
Local cArmCQ	:= GetMV("MV_CQ")
Local l260local	:= If(l260Local==Nil,ExistBlock("A260LOC"),l260Local)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto est  sendo inventariado.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cLocOrig == cArmCQ .And. cLocOrig # cLocDest
	Help(" ",1,"A260LOCCQ")
	lRet:=.F.
Else
	If BlqInvent(cCodDest,cLocDest,,cLoclzDest)
		Help(" ",1,"BLQINVENT",,cCodDest+" Almox: "+cLocDest,1,11)
		lRet:=.F.
	ElseIf (cLocDest==GetMv("MV_LOCPROC")) .And. If(Empty(cCodDest),.T.,A260ApropI(cCodDest))	//-- Soh impede transferencia para Armazem de Processo se o Produto for de "Apropriacao Indireta"
		If Aviso("Atencao","Transferencias do armazem de processo podem ser realizadas atraves de movimentacao especifica.",{"Confirma","Abandona"})  == 2
			lRet:=.F.
		EndIf
	EndIf
	If lRet .And. l260Local
		ExecBlock("A260LOC",.F.,.F., {cCodDest,cLocDest,2}) //Terceiro parametro igual a 2 para indicar armazem destino
	EndIf
	If lRet .And. (GetMv("MV_VLDALMO") == "S")
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If !(lRet:=SB2->(dbSeek(xFilial("SB2")+cCodDest+cLocDest)))
			Help(" ",1,"A260LOCAL")
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A260Doc  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 31/03/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o documento da transferencia.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A260Doc()
Local lRet:=.T.,cAlias:=Alias(),nOrder:=IndexOrd(),nRecno:=Recno()
Local cDoc		:= &(ReadVar())
Local lValidaDoc:=GetMV("MV_VLDDOC") == "S"

If lValidaDoc
	If !Empty(cDoc)
		dbSelectArea("SD3")
		SD3->(dbSetOrder(2))
		If SD3->(dbSeek(xFilial('SD3')+cDoc))
			While SD3->(!Eof()) .And. SD3->(D3_FILIAL+D3_DOC) == xFilial("SD3")+cDoc
				If SD3->D3_ESTORNO # "S"
					Help(" ",1,"a24101")
					lRet:= .F.
					Exit
				EndIf
				SD3->(dbSkip())
			EndDo
		EndIf
		dbSelectArea(cAlias)
		dbSetOrder(nOrder)
		dbGoTo(nRecno)
	EndIf
EndIf

Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F4Localiz³ Autor ³ Sergio Silveira       ³ Data ³ 24/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz a consulta de localizacoes por produto                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F4Localiz(a,b,c)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ a,b,c = parametros padroes quando utiliza-se o SetKey()    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F4RetSld( a, b, c, cProg, cProd, cLoc, nQtd, cReadVar, lEndOrig, cOP, lNumSerie)

LOCAL aArrayF4  :={}, aArrayF4NS:={}, nX, cVar
LOCAL cProduto  :="", nPosProd:=0, cLocal:="", nPosLocal:=0, nPosLocaliz:=0, nPosQuant:=0,nPosNumSer:=0,nPosSerie:=0,nPosQt2U:=0
LOCAL nQuant    := 0
LOCAL nQuantLoc := 0
LOCAL nQtLoc2U  := 0
LOCAL nEndereco
LOCAL cChave2
LOCAL cLocEnd  := ""
LOCAL lGetDados  := .F.
LOCAL aUsado     := {}
LOCAL nPosNumLote
LOCAL nPosLoteCtl
LOCAL lLote      := .F.
LOCAL cQuant, cQtSegU, nOAT
LOCAL lSaida     := .F.
LOCAL oDlg
LOCAL nOpcA      := 0
LOCAL aPosSBF 	 := {}
LOCAL aArea		 :=GetArea()
LOCAL lShowNSeri := .F.
LOCAL cNumSeri   := CriaVar( "BF_NUMSERI", .F. )
Local cLoteCtl   := ""
Local cNumLote   := ""
LOCAL nNumSerie  := 0
LOCAL lSelLote   := (SuperGetMV("MV_SELLOTE") == "1")
Local lWmsNew    := SuperGetMV("MV_WMSNEW",.F.,.F.) .And. IntWMS()
Local lWms       := .F.
LOCAL nLoop      := 0
LOCAL dDtValid   := CTOD('  /  /  ')
LOCAL aAreaSB8   := SB8->(GetArea())
LOCAL aDelArrF4  := {}
LOCAL nPos 		 := 0
LOCAL lMTF4LOC   := ExistBlock("MTF4LOC")
LOCAL aArrayAux  := Nil
LOCAL nHdl       := GetFocus()
LOCAL aSldEmp	 := {0,0}
LOCAL cCadastro  := ""
LOCAL nI		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_VLDLOTE - Utilizado para visualizar somente os lotes que  |
//| possuem o campo B8_DATA com o valor menor ou igual a database|
//| do sistema                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lVldDtLote := SuperGetMV("MV_VLDLOTE",.F.,.T.)

DEFAULT lNumSerie := .F.
DEFAULT lEndorig  := .T.
DEFAULT cOP := ""

nQtd := If( ValType( nQtd ) <> "N", 0, nQtd )

If cProg $ "A430/A440/A410/A467/A468/A462/A241/A265"
	For nX := 1 To Len(aHeader)
		If "_PRODUTO" $ AllTrim( aHeader[ nX, 2 ] ) .Or. ;
			"_COD"     $ Right( AllTrim( aHeader[ nX, 2 ] ), 4 )
			cProduto    := aCols[ n, nX ]
			nPosProd    := nX
		ElseIf "_LOCAL" == Right( AllTrim( aHeader[ nX, 2 ] ), 6 )
			cLocal      := aCols[ n, nX ]
			nPosLocal   := nX
		ElseIf "_LOCALIZ" $ AllTrim( aHeader[ nX, 2 ] )
			nPosLocaliz := nX
		ElseIf "_NUMLOTE" $ AllTrim( aHeader[ nX, 2 ] )
			nPosNumLote := nX
			cNumLote    := aCols[ n, nX ]
		ElseIf "_LOTECTL" $ AllTrim( aHeader[ nX, 2 ] )
			nPosLoteCtl := nX
			cLoteCtl    := aCols[ n, nX ]
		ElseIf ("_QUANT" == Right( AllTrim( aHeader[ nX, 2 ] ), 6 ) .Or. ;
			"_QTDVEN" $ AllTrim( aHeader[ nX, 2 ] )) .And. cProg $ "A430/A410/A467/A468/A462/A241/A265"
			nQuant      := aCols[ n, nX ]
			nPosQuant   := nX
		ElseIf "_QTDLIB" $ AllTrim( aHeader[ nX, 2 ] ) .And. cProg == "A440"
			nQuant      := aCols[ n, nX ]
			nPosQuant   := nX
		ElseIf "_NUMSERI" $ AllTrim( aHeader[ nX, 2 ] )
			nPosNumSer := nX
			cNumSeri   := aCols[ n, nX ]
		EndIf
		
	Next nX
	
	lGetDados := .T.
	
	For nLoop := 1 To Len( aCols )
		If nLoop <> n .And. If(ValType(aCols[nLoop,Len(aCols[nLoop])]) == "L",!aCols[nLoop,Len(aCols[nLoop])],.T.)
			If cProg # "A265"
				If aCols[ nLoop, nPosProd ] == cProduto .And. aCols[nLoop,nPosLocal] == cLocal .And. aCols[nLoop,nPosLoteCtl] == cLoteCtl .And. aCols[nLoop,nPosNumLote] == cNumLote
					nScan := aScan( aUsado, { |x| x[1] == aCols[nLoop,nPosLocaliz]  .And. x[3] == aCols[nLoop,nPosLoteCtl] .And. x[4] == aCols[nLoop,nPosNumLote] .And. x[5] == If(nPosNumSer>0,aCols[nLoop,nPosNumSer],"")} )
					If nScan == 0
						AAdd(aUsado,{aCols[nLoop,nPosLocaliz],aCols[nLoop,nPosQuant],aCols[nLoop,nPosLoteCtl],aCols[nLoop,nPosNumLote],If(nPosNumSer>0,aCols[nLoop,nPosNumSer],"")} )
					Else
						aUsado[ nScan ,2] += aCols[ nLoop, nPosQuant ]
					EndIf
				EndIf
			EndIf
		EndIf
	Next nLoop
	If cProg $ "A241"
		lSaida   := ( cTM > "500" ) .Or. (cTm <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I")
		IF cTm <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I"
			cLocal := GETMV("MV_LOCPROC")
		Endif
	ElseIf cProg == "A265"
		cProduto:=cProd
		cLocal  :=cLoc
	EndIf
ElseIf cProg $ "A175"
	cProduto := cA175Prod
	cLocal   := cA175Loc
	nPosQuant:= aScan(aHeader, {|x| AllTRim(x[2]) == 'D7_QTDE'})
	nPosQt2U := aScan(aHeader, {|x| AllTRim(x[2]) == 'D7_QTSEGUM'})
	nQuant   := aCols[n,nPosQuant]
	cNumLote := cA175LoteC
	cLoteCtl := cA175LotCt
ElseIf cProg $ "A260"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := ""
	cLoteCtl := ""
ElseIf cProg $ "A261"
	cProduto   := cProd
	cLocal     := cLoc
	nQuant     := nQtd
	cNumLote   := ""
	cLoteCtl   := ""
	nPos261Loc := O:COLPOS
ElseIf cProg $ "A240"
	lSaida   := ( M->D3_TM > "500" ) .Or. (M->D3_TM <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I")
	cProduto := M->D3_COD
	IF  M->D3_TM <= "500" .and. SF5->F5_APROPR != "S" .And. SB1->B1_APROPRI == "I"
		cLocal := GETMV("MV_LOCPROC")
	Else
		cLocal   := M->D3_LOCAL
	Endif
	nQuant   := M->D3_QUANT
	cNumLote := M->D3_NUMLOTE
	cLoteCtl := M->D3_LOTECTL
ElseIf cProg $ "A270"
	lSaida   := .T.
	cProduto := M->B7_COD
	cLocal   := M->B7_LOCAL
	nQuant   := M->B7_QUANT
	cNumLote := M->B7_NUMLOTE
	cLoteCtl := M->B7_LOTECTL
ElseIf cProg $ "A242" .Or. cProg $ "A242C"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := ""
	cLoteCtl := ""
ElseIf cProg $ "A275"
	cProduto := M->DD_PRODUTO
	cLocal   := M->DD_LOCAL
	nQuant   := M->DD_QUANT
	cNumLote := M->DD_NUMLOTE
	cLoteCtl := M->DD_LOTECTL
ElseIf cProg $ "A380"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := SD4->D4_NUMLOTE
	cLoteCtl := SD4->D4_LOTECTL
ElseIf cProg $ "A381"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cLoteCtl := cEndLCtl
	cNumLote := cEndLote
ElseIf cProg $ 'DLA220'
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := M->DCF_NUMLOT
	cLoteCtl := M->DCF_LOTECT
ElseIf cProg $ "WMSA332A"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := M->D12_NUMLOT
	cLoteCtl := M->D12_LOTECT
ElseIf cProg $ "ATEC"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := ""
	cLoteCtl := ""
ElseIf cProg $ "A310"
	cProduto := cProduto1
	cLocal   := cLocOrig
	nQuant   := nQtd
	cNumLote := cNumLote
	cLoteCtl := cLoteDigi
ElseIf cProg $ "A311"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := ""
	cLoteCtl := ""
ElseIf cProg $ "AGR900"
	cProduto := FwFldGet("NPH_CODPRO")
	cLocal   := FwFldGet("NPH_LOCAL")
	nQuant   := FwFldGet("NPN_QUANT")
	cNumLote := ""
	cLoteCtl := FwFldGet("NPN_LOTE")
ElseIf cProg $ "ACDI011"
	cProduto := cProd
	cLocal   := cLoc
	nQuant   := nQtd
	cNumLote := ""
	cLoteCtl := ""
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o F4 apenas se o produto tiver controle de localizacao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Localiza( cProduto,.T.) .And. If( cProg $ "A240úA241", lSaida, .T. )
	If Rastro( cProduto )
		If !Empty( If( Rastro( cProduto, "S" ), cNumLote, cLoteCtl ) )
			lLote := .T.
		EndIf
	EndIf
	
	If lWmsNew .And. IntWMS(cProduto)
		lWms      := .T.
		oSaldoWMS := WMSDTCEstoqueEndereco():New()
		If cProg $ "A380úA381" .Or. FwIsInCallStack("MATA650")
			oSaldoWMS:SetProducao(.T.)
		EndIf
		If Rastro(cProduto,"S")
			aSaldo := oSaldoWMS:GetSldEnd(cProduto,cLocal,,cLoteCtl,cNumLote,,1)
			
		Else
			aSaldo := oSaldoWMS:GetSldEnd(cProduto,cLocal,,cLoteCtl,,,1)
			
		EndIf
		For nI := 1 To Len(aSaldo)
			aSaldo[nI,6] := TransForm(aSaldo[nI,6],PesqPict("D14","D14_QTDEST",13))
			aSaldo[nI,7] := TransForm(aSaldo[nI,7],PesqPict("D14","D14_QTDES2",13))
		Next nI
		aArrayF4 	:= Aclone(aSaldo)
		If !Empty(aArrayF4)
			If !Empty(aArrayF4[1][5])
				lShowNSeri := .T.
			EndIf
		EndIf
	Else
		aPosSBF := SBF->(GetArea())
		dbSelectArea("SBF")
		cChave2 := xFilial( "SBF" ) + cProduto + cLocal
		cCompara:= "BF_FILIAL+BF_PRODUTO+BF_LOCAL"
		dbSetOrder(2)
		If lLote
			If Rastro(cProduto,"S")
				cCompara+="+BF_LOTECTL+BF_NUMLOTE"
				cChave2 +=cLoteCtl + cNumLote
			Else
				cCompara+="+BF_LOTECTL"
				cChave2 +=cLoteCtl
			EndIf
		EndIf
		dbSeek(cChave2)
		While !SBF->( Eof() ) .And. cChave2 == &(cCompara)
			If !Empty(cOP)
				aSldEmp := SldEmpOP(SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOTECTL,SBF->BF_NUMLOTE,cOP,SBF->BF_LOCALIZ,SBF->BF_NUMSERI,"L")
			EndIf
			//			nSaldoLoc  := SBF->BF_QUANT - (SBF->BF_EMPENHO-aSldEmp[1]+AvalQtdPre("SBF",1))
			nSaldoLoc  := SBF->BF_QUANT
			//			nSaldoLoc2 := SBF->BF_QTSEGUM - (SBF->BF_EMPEN2-aSldEmp[2]+AvalQtdPre("SBF",1,.T.))
			_nSldEmp := (SBF->BF_EMPENHO-aSldEmp[1]+AvalQtdPre("SBF",1))//mudado para ser a quantidade de empenho
			If QtdComp(nSaldoLoc) > QtdComp(0)
				nScan := AScan( aUsado, { |x| x[1] == SBF->BF_LOCALIZ .And. If(lLote,If(Rastro(cProduto,"S"),x[3]==SBF->BF_LOTECTL.And.x[4]==SBF->BF_NUMLOTE,x[3]==SBF->BF_LOTECTL),.T.) .And. x[5] == If(nPosNumSer>0,SBF->BF_NUMSERI,"")} )
				If nScan <> 0
					nSaldoLoc  -= aUsado[ nScan, 2 ]
					//					nSaldoLoc2 -= ConvUM(cProduto, aUsado[ nScan, 2 ], 0, 2)
					_nSldEmp -= ConvUM(cProduto, aUsado[ nScan, 2 ], 0, 2)
				EndIf
			EndIf
			If nSaldoLoc > 0
				dDtValid   := CTOD('  /  /  ')
				If Rastro(cProduto)
					dbSelectArea("SB8")
					dbSetOrder(3)
					If dbSeek(xFilial("SB8")+cProduto+SBF->BF_LOCAL+SBF->BF_LOTECTL+If(Rastro(cProduto,"S"),SBF->BF_NUMLOTE,""))
						If lVldDtLote .And. SB8->B8_DATA > dDataBase
							dbSelectArea("SBF")
							SBF->( dbSkip() )
							Loop
						EndIf
						dDtValid:=B8_DTVALID
					EndIf
				EndIf
				dbSelectArea("SBF")
				//				AAdd(aArrayF4NS,{SBF->BF_LOCALIZ,SBF->BF_NUMSERI,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(nSaldoLoc2,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				//				AAdd(aArrayF4,{SBF->BF_LOCALIZ,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(nSaldoLoc2,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				AAdd(aArrayF4NS,{SBF->BF_LOCALIZ,SBF->BF_NUMSERI,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(_nSldEmp,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				AAdd(aArrayF4,{SBF->BF_LOCALIZ,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(_nSldEmp,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				If !Empty(SBF->BF_NUMSERI)
					lShowNSeri := .T.
				EndIf
			EndIf
			SBF->( dbSkip() )
		EndDo
		RestArea(aPosSBF)
	EndIf
	If lShowNSeri
		aArrayF4:=ACLONE(aArrayF4NS)
	EndIf
	If ExistBlock("MTVLDLOC")
		aDelArrF4 := ExecBlock("MTVLDLOC",.F.,.F.,ACLONE(aArrayF4))
		If ValType(aDelArrF4) == "A" .And. Len(aDelArrF4) > 0
			For nX := 1 To Len(aDelArrF4)
				If lShowNSeri
					nPos := aScan(aArrayF4,{|x| x[1] == aDelArrF4[nX][1] .And. x[2] == aDelArrF4[nX][2] .And. x[5] == aDelArrF4[nX][5] .And. x[6] == aDelArrF4[nX][6] .And. x[7] == aDelArrF4[nX][7]})
				Else
					nPos := aScan(aArrayF4,{|x| x[1] == aDelArrF4[nX][1] .And. x[4] == aDelArrF4[nX][4] .And. x[5] == aDelArrF4[nX][5] .And. x[6] == aDelArrF4[nX][6]})
				Endif
				If nPos > 0
					Adel(aArrayF4,nPos)
					ASize(aArrayF4,Len(aArrayF4)-1)
				Endif
			Next
		Endif
	EndIf
	If Len( aArrayF4 ) > 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada utilizado para manipular a ordem do array aArrayF4 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMTF4LOC
			aArrayAux := ExecBlock('MTF4LOC', .F., .F., {aArrayF4})
			If ValType(aArrayAux) == 'A'  .And. Len(aArrayF4) == Len(aArrayAux)
				aArrayF4 := aClone(aArrayAux)
			EndIf
		EndIf
		
		nOpcA := 0
		cCadastro := OemToAnsi("Saldos por Localizacao")
		DEFINE MSDIALOG oDlg TITLE cCadastro From 09,0 To 33,75 OF oMainWnd
		@ 1.1,  .7  Say OemToAnsi("Produto :")  //"Produto :"
		@ 1  , 3.8  MSGet cProduto SIZE 150,10 When .F.
		If lShowNSeri
			If lWms
				@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER RetTitle("D14_LOCAL"),OemToAnsi("Localizacao"),RetTitle("D14_LOTECT"),RetTitle("D14_NUMLOT"),OemToAnsi(de),OemToAnsi("Saldo"),OemToAnsi("Empenho"),RetTitle("D14_DTVALD"),RetTitle("D14_PRODUT") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //"Localizacao"###"Numero de Serie"###"Saldo"###"Saldo 2aUM"
			Else
				@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Localizacao"),OemToAnsi("Numero de Serie"),OemToAnsi("Saldo"),OemToAnsi("Empenho"),RetTitle("BF_LOTECTL"),RetTitle("BF_NUMLOTE"),RetTitle("B8_DTVALID") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //"Localizacao"###"Numero de Serie"###"Saldo"###"Saldo 2aUM"
			EndIf
		Else
			If lWms
				@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER RetTitle("D14_LOCAL"),OemToAnsi("Numero de Serie"),RetTitle("D14_LOTECT"),RetTitle("D14_NUMLOT"),OemToAnsi("Saldo"),OemToAnsi("Empenho"),RetTitle("D14_DTVALD"),RetTitle("D14_PRODUT") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //"Localizacao"###"Numero de Serie"###"Saldo"###"Saldo 2aUM"
			Else
				@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Localizacao"),OemToAnsi("Saldo"),OemToAnsi("Empenho"),RetTitle("BF_LOTECTL"),RetTitle("BF_NUMLOTE"),RetTitle("B8_DTVALID") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //"Localizacao"###"Saldo"###"Saldo 2aUM"
			EndIf
		EndIf
		oQual:SetArray(aArrayF4)
		If lShowNSeri
			If lWms
				oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7],aArrayF4[oQual:nAT,8],aArrayF4[oQual:nAT,9]}}
			Else
				oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7]}}
			EndIf
		Else
			If lWms
				oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7],aArrayF4[oQual:nAT,8],aArrayF4[oQual:nAT,9]}}
			Else
				oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6]}}
			EndIf
		EndIf
		DEFINE SBUTTON FROM 06  ,264  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 18.5,264  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT,.T.) CENTERED
		
		If nOpca == 1
			If lShowNSeri
				If lWms
					cLocEnd := aArrayF4[ nOAT, 2 ]
					cNumSeri  := aArrayF4[ nOAT, 5 ]
					cLoteCtl  := aArrayF4[ nOAT, 3 ]
					cNUMLote  := aArrayF4[ nOAT, 4 ]
					dDtValid  := aArrayF4[ nOAT, 8 ]
					cQuant    := aArrayF4[ nOAT, 6 ]
				Else
					cLocEnd := aArrayF4[ nOAT, 1 ]
					cNumSeri  := aArrayF4[ nOAT, 2 ]
					cLoteCtl  := aArrayF4[ nOAT, 5 ]
					cNUMLote  := aArrayF4[ nOAT, 6 ]
					dDtValid  := aArrayF4[ nOAT, 7 ]
					cQuant    := aArrayF4[ nOAT, 3 ]
					cQuant    := StrTran( cQuant, ".", ""  )
					cQuant    := StrTran( cQuant, ",", "." )
					nQuantLoc := Val( cQuant )
				EndIf
			Else
				If lWms
					cLocEnd := aArrayF4[ nOAT, 2 ]
					cLoteCtl  := aArrayF4[ nOAT, 3 ]
					cNUMLote  := aArrayF4[ nOAT, 4 ]
					dDtValid  := aArrayF4[ nOAT, 8 ]
					cQuant    := aArrayF4[ nOAT, 6 ]
					cQtSegU   := aArrayF4[ nOAT, 7 ]
				Else
					cLocEnd := aArrayF4[ nOAT, 1 ]
					cLoteCtl  := aArrayF4[ nOAT, 4 ]
					cNUMLote  := aArrayF4[ nOAT, 5 ]
					dDtValid  := aArrayF4[ nOAT, 6 ]
					cQuant    := aArrayF4[ nOAT, 2 ]
					cQtSegU   := aArrayF4[ nOAT, 3 ]
				EndIf
				If UPPER(AllTrim(GetSrvProfString("PictFormat", ""))) == "AMERICAN"
					cQuant    := StrTran( cQuant, ",", ""  )
					cQtSegU   := StrTran( cQtSegU, ",", ""  )
					nQuantLoc :=  Val( cQuant )
				Else
					cQuant    := StrTran( cQuant, ".", ""  )
					cQuant    := StrTran( cQuant, ",", "." )
					cQtSegU   := StrTran( cQtSegU, ".", ""  )
					cQtSegU   := StrTran( cQtSegU, ",", "." )
					nQuantLoc := Val( cQuant )
					nQtLoc2U  := Val( cQtSegU )
				EndIf
			EndIf
		EndIf
	Else
		Help( " ", 1, "F4LOCALIZ" )
	EndIf
	
	If !Empty(cLocEnd) .Or. !Empty(cNumSeri)
		If cProg == "A175" .And. nPosLocLz > 0
			&cReadVar := IIF("D7_LOCALIZ"$cReadVar,cLocEnd,cNumSeri)
			aCols[n,nPosLocLz] := cLocEnd
			nPosSerie:= Ascan(aHeader,{|x| AllTrim(x[2])=="D7_NUMSERI" })
			If nPosSerie > 0
				aCols[n,nPosSerie] := cNumSeri
			Endif
		ElseIf cProg == "A260"
			&cReadVar := cLocEnd
			If Type("cNumSerie") == "C" .And. !Empty(cNumSeri)
				cNumSerie := cNumSeri
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse - MATA685   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Type("aCols") == "A" .And. !Empty(cNumSeri)
				If lShowNSeri .And. aScan(aHeader,{|x|AllTrim(x[2])=='BC_NUMSERI'}) > 0
					aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=='BC_NUMSERI'}) ] := cNumSeri
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse - MATA650   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Type("aCols") == "A" .And. !Empty(cNumSeri)
				If lShowNSeri .And. aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) > 0
					aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) ] := cNumSeri
				EndIf
			EndIf
		ElseIf cProg == "A261"
			aCols[n, nPosLote]   := cNumLote
			If lEndOrig
				aCols[n, nPosLotCtl] := cLoteCtl
				aCols[n, nPosDValid] := dDtValid
				aCols[n, nPosDtVldD] := dDtValid
			Else
				aCols[n, nPosLotDes] := cLoteCtl
				aCols[n, nPosDtVldD] := dDtValid
			Endif
			If Type("nPosnSer") == "N" .And. nPosnSer > 0
				aCols[n, nPosnSer]   := cNumSeri
			EndIf
			If nPos261Loc > 0
				If lNumSerie
					aCols[n, 5] := cLocEnd
				Else
					aCols[n, nPos261Loc] := cLocEnd
				EndIf
			EndIf
			If lNumSerie
				&cReadVar := cNumSeri
			Else
				&cReadVar := cLocEnd
			EndIf
		ElseIf cProg == "A265"
			aCols[n, nPosNumSer] := cNumSeri
			aCols[n, nPosLocali] := cLocEnd
			If Valtype("cReadVar") == "C"
				If SubStr(cReadVar,4,10) == "DB_LOCALIZ"
					&cReadVar := cLocEnd
				ElseIf SubStr(cReadVar,4,10) == "DB_NUMSERI"
					&cReadVar := cNumSeri
				EndIf
			EndIf
		ElseIf cProg $ "A430"
			aCols[ n, nPosLocaliza ] := cLocEnd
			M->C0_LOCALIZ            := cLocEnd
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lShowNSeri .And. !Empty( nPosNumSer )
				aCols[ n, nPosNumSer ] := cNumSeri
				M->C0_NUMSERI := cNumSeri
			EndIf
		ElseIf cProg $ "A440/A410"
			aCols[ n, nPosLocaliza ] := cLocEnd
			M->C6_LOCALIZ            := cLocEnd
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o lote e sublote                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lWmsNew .And. IntWMS(cProduto)
				If Rastro(cProduto,"S")
					aCols[n, nPosNumLote] := cNumLote
					M->C6_NUMLOTE         := cNumLote
				EndIf
				If Rastro(cProduto,"L")
					aCols[n, nPosLoteCtl] := cLoteCtl
					M->C6_LOTECTL         := cLoteCtl
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lShowNSeri .And. !Empty( nPosNumSer )
				aCols[ n, nPosNumSer ] := cNumSeri
				M->C6_NUMSERI := cNumSeri
			EndIf
		ElseIf cProg $ "A467/A468"
			aCols[ n, nPosLocaliza ] := cLocEnd
			M->D2_LOCALIZ            := cLocEnd
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lShowNSeri .And. !Empty( nPosNumSer )
				aCols[ n, nPosNumSer ] := cNumSeri
				M->D2_NUMSERI := cNumSeri
			EndIf
			
		ElseIf cProg $ "A462"
			aCols[ n, nPosLocaliza ] := cLocEnd
			M->CN_LOCALIZ            := cLocEnd
		ElseIf cProg == "A240"
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOCALIZ" } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := cLocEnd
				M->D3_LOCALIZ := cLocEnd
				If !Empty(dDtValid)
					M->D3_DTVALID := dDtValid
				EndIf
			EndIf
			If ExistTrigger("D3_LOCALIZ")
				RunTrigger(1,NIL,NIL,"D3_LOCALIZ")
			Endif
			If lShowNSeri
				nNumSerie := Ascan(aGets,{ |x| Subs(x,9,10) == 'D3_NUMSERI' } )
				If nNumSerie > 0
					aTela[Val(Subs(aGets[nNumSerie],1,2))][Val(Subs(aGets[nNumSerie],3,1))*2] := cNumSeri
					M->D3_NUMSERI := cNumSeri
				EndIf
				If ExistTrigger('D3_NUMSERI')
					RunTrigger(1,NIL,NIL,'D3_NUMSERI')
				Endif
			EndIf
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_LOTECTL" } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := cLoteCtl
				M->D3_LOTECTL := cLoteCtl
			EndIf
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_NUMLOTE" } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := cNumLote
				M->D3_NUMLOTE := cNumLote
			EndIf
		ElseIf cProg == "A241"
			If nPos241Loc > 0
				aCols[n, nPos241Loc] := cLocEnd
			EndIf
			If nPosLote > 0
				aCols[n,nPosLote] := cNumLote
			EndIf
			If nPosLotCTL > 0
				aCols[n,nPosLotCTL] := cLoteCtl
			EndIf
			&cReadVar := cLocEnd
			If lShowNSeri
				If nPosNumSer > 0
					aCols[n, nPosNumSer] := cNumSeri
				EndIf
			EndIf
			If Type("nPosDValid") == "N" .And. nPosDValid > 0
				aCols[n,nPosDValid] := dDtValid
			EndIf
		ElseIf cProg == "A270"
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_LOCALIZ" } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := cLocEnd
				M->B7_LOCALIZ := cLocEnd
			EndIf
			If lShowNSeri
				nNumSerie := Ascan(aGets,{ |x| Subs(x,9,10) == 'B7_NUMSERI' } )
				If nNumSerie > 0
					aTela[Val(Subs(aGets[nNumSerie],1,2))][Val(Subs(aGets[nNumSerie],3,1))*2] := cNumSeri
					M->B7_NUMSERI := cNumSeri
				EndIf
			EndIf
		ElseIf cProg == "A242"
			&cReadVar := cLocEnd
			If Type("cNumSerie") == "C"
				cNumSerie := cNumSeri
			EndIf
			If Type("cNumLote") == "C"
				cNumLote  := cNumLote
			EndIf
			If Type("cLoteDigi") == "C"
				cLoteDigi := cLoteCtl
			EndIf
			If Type("dDtValid2") == "D"
				dDtValid2  := dDtValid
			EndIf
		ElseIf cProg == "A242C"
			&cReadVar := cLocEnd
			If Type("cNumSerie") == "C"
				aCols[n,aScan(aHeader,{|x|AllTrim(x[2])=='D3_NUMSERI'})] := cNumSeri
			EndIf
			If Type("cNumLote") == "C"
				aCols[n,aScan(aHeader,{|x|AllTrim(x[2])=='D3_NUMLOTE'})]  := cNumLote
			EndIf
			If Type("cLoteDigi") == "C"
				aCols[n,aScan(aHeader,{|x|AllTrim(x[2])=='D3_LOTECTL'})] := cLoteCtl
			EndIf
			If Type("dDtValid2") == "D"
				aCols[n,aScan(aHeader,{|x|AllTrim(x[2])=='D3_DTVALID'})]  := dDtValid
			EndIf
		ElseIf cProg == "A275"
			nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "DD_LOCALIZ" } )
			If nEndereco > 0
				aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := cLocEnd
				M->DD_LOCALIZ := cLocEnd
			EndIf
		ElseIf cProg == "A380"
			&cReadVar := cLocEnd
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lShowNSeri .And. aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) > 0
				aCols[ n, aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) ] := cNumSeri
				M->DC_NUMSERI := cNumSeri
			EndIf
		ElseIf cProg == "A381"
			&cReadVar := cLocEnd
			aCols[n,aScan(aHeader,{|x|AllTrim(x[2])=='DC_LOCALIZ'})] := cLocEnd
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lShowNSeri .And. aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) > 0
				aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=='DC_NUMSERI'}) ] := cNumSeri
			EndIf
		ElseIf cProg == "ATEC"
			nEndereco:= Ascan(aHeader,{|x| AllTrim(x[2])=="ABA_LOCALI" })
			aCols[n,nEndereco] := cLocEnd
			&cReadVar          := cLocEnd
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o numero de serie caso esteja no browse             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosNumSer:= Ascan(aHeader,{|x| AllTrim(x[2])=="ABA_NUMSER" })
			If lShowNSeri .And. !Empty( nPosNumSer )
				aCols[ n, nPosNumSer ] := cNumSeri
				M->ABA_NUMSER := cNumSeri
			EndIf
		ElseIf cProg == "A310"
			&cReadVar := cLocEnd
			If Type("cNumSerie") == "C"
				cNumSerie := cNumSeri
			EndIf
			If Type("cNumLote") == "C"
				cNumLote  := cNumLote
			EndIf
			If Type("cLoteDigi") == "C"
				cLoteDigi := cLoteCtl
			EndIf
			If Type("dDtValid2") == "D"
				dDtValid2  := dDtValid
			EndIf
		ElseIf cProg == "A311"
			FwFldPut("NNT_LOCALI", cLocEnd)
			FwFldPut("NNT_LOTECT", cLoteCtl)
			FwFldPut("NNT_NUMLOT", cNUMLote)
			M->NNT_LOTECT 	:= cLoteCtl
			M->NNT_NUMLOT	:= cNUMLote
			
			IF !Empty(cNumSeri)
				M->NNT_NSERIE:= cNumSeri
				FwFldPut( "NNT_NSERIE" , cNumSeri,,,,.T. )
			EndIF
		ElseIf cProg $ 'DLA220|WMSA332A'
			&cReadVar := cLocaliza
		ElseIf cProg == 'AGR900'
			
			&(ReadVar()) := cLocEnd
		ElseIf cProg == "ACDI011"
			MV_PAR02 := cQuant
			MV_PAR07 := dDtValid
			MV_PAR09 := cLocEnd
		EndIf
		
		If nQuant > nQuantLoc
			If cProg == "A175"
				aCols[n,nPosQuant]:= nQuantLoc
				aCols[n,nPosQt2U] := nQtLoc2U
			ElseIf cProg == "A260"
				&cReadVar := cLocEnd
			ElseIf cProg == "A261"
				If nPos261Qtd > 0
					aCols[n, nPosQuant] := nQuantLoc
				EndIf
				M->D3_QUANT := nQuantLoc
			ElseIf cProg $ "A430"
				aCols[ n, nPosQuant ] := nQuantLoc
				M->C0_QUANT           := nQuantLoc
			ElseIf cProg $ "A440/A410"
				If !lSelLote
					aCols[ n, nPosQuant ] := nQuantLoc
					If cProg == "A410"
						M->C6_QUANT           := nQuantLoc
					Else
						M->C6_QTDLIB          := nQuantLoc
					EndIf
				EndIf
			ElseIf cProg == "A240"
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "D3_QUANT" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := nQuantLoc
					M->D3_QUANT := nQuantLoc
				EndIf
			ElseIf cProg == "A241"
				// Somente altera a coluna da quantidade se o programa for
				// diferente do MATA185 - Baixa de Pre-requisicoes
				If (nPos241Qtd > 0) .And. !l185
					aCols[n, nPos241Qtd] := nQuantLoc
				EndIf
				M->D3_QUANT := nQuantLoc
			ElseIf cProg == "A270"
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "B7_QUANT" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := nQuantLoc
					M->B7_QUANT := nQuantLoc
				EndIf
			ElseIf cProg == "A242" .Or. cProg == "A242C"
				&cReadVar := cLocEnd
			ElseIf cProg == "A310"
				&cReadVar := cLocEnd
				nQuant:= nQuantLoc
			ElseIf cProg == "A275"
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "DD_QUANT" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := nQuantLoc
					M->DD_QUANT := nQuantLoc
				EndIf
			ElseIf cProg == "ATEC"
				nEndereco := Ascan(aHeader,{|x| AllTrim(x[2])=="ABA_QUANT" })
				If ( nEndereco > 0 )
					aCols[n,nEndereco] := nQuantLoc
				EndIf
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaSB8)
EndIf
RestArea(aArea)
SetFocus(nHdl)
Return .T.


//--------------------------------------------------------------
/*/{Protheus.doc} fExcReserv
Description //Exclusão de Reserva
@param aReserva Parameter Array com as reservas a serem excluidas
@return xRet Return Description
@author  - Alexis Duarte
@since 17/10/2018
/*/
//--------------------------------------------------------------
Static Function fExcReserv(aReserva,_lPed)

Local nx := 0
Local nOperacao := 3
Local cObs := "Exclusão de reserva ao estornar o pedido de venda."
Local cQuery := ""
Local cProduto := ""
Local cLocal := ""
Local nQuant := 0
Local cAlias := getNextAlias()
Local nUso := 0

Local lReserv := .F.

Local aLote := {}
Local aOperacao := {}

Local aHeaderAux := {}
Local aColsAux := {}

dbSelectArea("SX3")
dbSetOrder(2)

if dbSeek("C0_VALIDA ")
	nUso++
	aAdd(aHeaderAux,{ TRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT }	)
endif

aColsAux := Array(nUso+1)

for nx := 1 to len(aReserva)
	
	aOperacao := {}
	lReserv := .F.
	
	cQuery := "SELECT * FROM "+retSqlName("SC0")
	cQuery += " WHERE C0_NUM = '"+ aReserva[nx][1] +"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	
	PLSQuery(cQuery, cAlias)
	
	if (cAlias)->(!eof())
		
		aColsAux[1] := (cAlias)->C0_VALIDA
		aColsAux[nUso+1] := .F.
		
		aOperacao := {	nOperacao				,;	// Operacao : 1 Inclui,2 Altera,3 Exclui
		(cAlias)->C0_TIPO		,;	// Tipo da Reserva : PD - Pedido
		(cAlias)->C0_DOCRES		,;	// Documento que originou a Reserva
		(cAlias)->C0_SOLICIT	,;	// Solicitante
		(cAlias)->C0_FILIAL		,;	// Filial
		cObs					}	// Observacao
		
		aLote := {"","",(cAlias)->C0_LOCALIZ,""} // Array com os dados do lote para a rotina a430Reserv
		
	endif
	
	if len(aOperacao) > 0
		
		cProduto := (cAlias)->C0_PRODUTO
		cLocal := (cAlias)->C0_LOCAL
		If _lPed
			nQuant := (cAlias)->C0_QUANT
		Else
			nQuant := (cAlias)->C0_QTDORIG
		EndIf
		
		cNumRes := (cAlias)->C0_NUM
		
		lReserv := A430Reserv (aOPERACAO,cNumRes,cProduto,cLocal,nQuant,aLOTE,aHeaderAux,aColsAux,NIL,.F.)
		
		SC0->( MsUnLock() )  //-->Libera a tabela SC0 para confirmar reserva
		
		if !lReserv
			_lSai       := .F.
			MostraErro()
			RollBackSx8()
		else
			ConfirmSX8()
		endif
		
	endif
	
next nx

Return lReserv



Static Function fCriaRes()

Local cObs := ""   // Observacao na reserva
Local nDtlimit := 0		// Numero de dias para calculo da data limite da reserva
Local aOperacao := {}		// Array com os dados de envio para a rotina a430Reserv
Local aHeaderAux := {}		// Simulacao do aHeader para a rotina a430Reserv
Local aColsAux := {}		// Simulacao do aCols para a rotina a430Reserv
Local cCliente := ""		// Cliente do pedido de venda
Local cProduto := ""		// Produto a ser reservado
Local cLocal := ""		// Armazem
Local nQUANT := 0		// Quantidade a ser reservada
Local nUso := 0		// Contador auxiliar para montagem do aHeader
Local aLote := {} // Array com os dados do lote para a rotina a430Reserv
Local cItem := ""
Local cNumRes := ""		// Gera Numero de Reserva Sequencial
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com aHeader e aCols somente 		    ³
//³ com os dados necessarios para a rotina de reserva ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderAux := {}

dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("C0_VALIDA ")
	nUso++
	AADD(aHeaderAux,{ TRIM(X3Titulo()),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	SX3->X3_VALID,;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_ARQUIVO,;
	SX3->X3_CONTEXT }	)
Endif

// Numero de dias para calculo da data limite da reserva
nDtlimit := SuperGetMV("MV_DTLIMIT",,0)

aColsAux := Array(nUso+1)
aColsAux[1] := dDataBase + nDtlimit
aColsAux[nUso+1] := .F.

Dbselectarea("SD1")
DbsetOrder(1)

Dbselectarea("SB1")
DbsetOrder(1)

DbSelectArea("SC0")
SC0->(DbSetOrder(1))

For _ny := 1 To Len(_aReserv)
	
	If _aReserv[_ny,2]
		
		aLote := {"","",cLocLzDest,""}
		
		cObs := "Reserva automatica, gerada na transferência("+_aReserv[_ny,7]+")"
		
		aOperacao := {	1						,;	// Operacao : 1 Inclui,2 Altera,3 Exclui
		"PD"					,;	// Tipo da Reserva : PD - Pedido
		_aReserv[_ny,4]			,;	// Documento que originou a Reserva
		_aReserv[_ny,5]	        ,;	// Solicitante
		_aReserv[_ny,6]			,;	// Filial
		cObs		} 				// Observacao
		
		cProduto	:= _aReserv[_ny,8]
		cLocal		:= _aReserv[_ny,9]
		nQuant		:= _aReserv[_ny,10]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ------------- Geração da reserva ---------------- ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumRes := GetSx8Num("SC0","C0_NUM")
		lReserv := A430Reserv (aOPERACAO,cNumRes,cProduto,cLocal,nQuant,aLOTE,aHeaderAux,aColsAux,NIL,.F.)
		SC0->( MsUnLock() )  //-->³Libera a tabela SC0 para confirmar reserva³
		
		If !lReserv
			_lSai       := .F.
			Alert("Erro ao gerar a reserva")
			MostraErro()
			RollBackSx8()
		Else
			_aReserv[_ny,7] := cNumRes
			ConfirmSX8()
			
		EndIf
		
		//Endif
	Endif
Next _ny
//RestArea(aArea)

Return lReserv

/*
--------------------------------------------------------|
-> Realiza a liberação dos itens do pedido de venda.	|
-> By Alexis Duarte									    |
-> 14/08/2018                                           |
-> Uso: Komfort House                                   |
--------------------------------------------------------|
*/

/*
Static Function fLibPed(_cPedido,_cItem,_cProd,_nQuant)

Local cPedido 	:= _cPedido
Local cItem		:= _cItem
Local cProduto	:= _cProd
Local nQuant	:= _nQuant
Local cFilBkp	:= cFilAnt

Local nQtdLib	:= 0

Local lAvalCre 	:= .T.	// Avaliacao de Credito
Local lBloqCre 	:= .F. 	// Bloqueio de Credito
Local lAvalEst	:= .T.	// Avaliacao de Estoque
Local lBloqEst	:= .T.	// Bloqueio de Estoque
Local lRet := .F.

SC6->(DbSetOrder(1))
If SC6->(DbSeek(xFilial("SC6") + AvKey(cPedido,"C6_NUM") + AvKey(cItem,"C6_ITEM") + AvKey(cProduto,"C6_PRODUTO") ))

cFilAnt := SC6->C6_MSFIL
SC9->(DbSetOrder(1))
If SC9->(DbSeek(xFilial("SC9") + AvKey(cPedido,"C9_NUM") + AvKey(cItem,"C9_ITEM") ))
//-- Estorna a Liberação do Pedido por meio da rotina padrão de estorno.
A460Estorna()
EndIF

RecLock("SC6",.F.)
SC6->C6_QTDLIB := nQuant
MsUnlock()

nQtdLib := MaLibDoFat(SC6->(RecNo()),nQuant,@lBloqCre,@lBloqEst,lAvalCre,lAvalEst,.F.,.F.,NIL,NIL,NIL,NIL,NIL,0)

If nQtdLib > 0
Sleep(1500) //Sleep de 2 segundo
SC6->(MaLiberOk({cPedido},.F.))
lRet := .T.
Endif

Endif

Return lRet
*/
