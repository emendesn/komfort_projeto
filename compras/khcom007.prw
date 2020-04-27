#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} KHCOM007
Description //Controle de produtos cancela Substituํ
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHCOM007()
   Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private aTapec := {}
    Private oTela, oTitulos
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")
    Private oPainel
    Private oFilial
    Private oCliente
    Private cFornece := CriaVar("A1_COD", .F.)
    Private oPedido
    Private cPedido := CriaVar("C5_NUM", .F.)
    Private oPedComp
    Private cProduto := CriaVar("C6_NUM", .F.)

  

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "PAINEL CANCELA SUBSTITUอ" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif
    
 
    
    
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'-',;
    														  '-',;
    														  'Filial',;
    														  'Emissใo',;
    														  '<- Dias ->',;
    														  'Cancelamento',;
    														  '<- Dias ->',;
    														  'Envio Email',;
    														  '<-Dias->',;
    														  'Retorno Email',;
    														  'Pedido',;
    														  'Produto',;
    														  'Descri็ใo',;
    														  'Item PV',;
    														  'Qtd Venda',;
    														  'Local',;
     														  "Fornecedor",;
															  "No. Ped. Compra"},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
        
    fCarrTit()
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F4, {|| zLegenda() })
    SetKey(VK_F5, {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .f.) })
   
    
    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End() } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()

  	@  34, 05 Say  oSay Prompt 'Fornecedor'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 05 MSGet oCliente Var cFornece FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.) }  F3 "SA1" When .T. Of oTela 

    @  34, 55 Say  oSay Prompt 'Pedido'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 55 MSGet oPedido Var cPedido FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.) } F3 "SC5" When .T. Of oTela 
    
    @  34, 105 Say  oSay Prompt 'Produto'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 105 MSGet oPedComp Var cProduto FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.)} F3 "SC7" When .T. Picture "@!" Of oTela 
    
	@  34, 205 Say  oSay Prompt 'F4 - Legenda'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    
    //tButton():New(44,155,"&Visu Anexo",oTela,{|| fShow() },50,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,155,"&Alterar",oTela,{|| fAltera() },50,10,,,,.T.,,,,/*{|| }*/)

Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit()

	Local cQuery := ""
    Local cAlias := getNextAlias()
    Local cAnexo := "NรO"
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') //"Cancelado"
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Pendente" --> Padrใo
        
	cQuery := CRLF + " SELECT Z16_STATUS,Z16_XFILIA,Z16_EMISSA,Z16_NUMPV,Z16_PRODUT,Z16_DESC,Z16_ITEM,Z16_QTDVEM,Z16_LOCAL,Z16_FORNEC,Z16_DTENV,Z16_RETMAI,Z16_DATA , C7_01NUMPV FROM Z16010(NOLOCK) Z16 " 
	cQuery += " LEFT JOIN SC7010 SC7 ON SC7.D_E_L_E_T_ = ' ' AND C7_01NUMPV = Z16_NUMPV " 
	cQuery += CRLF + " WHERE Z16.D_E_L_E_T_ = '' "
   
     If !EMPTY(cPedido)
    cQuery += CRLF +  " AND Z16_NUMPV = '"+cPedido+"'"
    EndIf
     If !EMPTY(cProduto)
    cQuery += CRLF + " AND Z16_PRODUT = '"+cProduto+"'"
    EndIf
    If !EMPTY(cFornece)
    cQuery += CRLF + " AND Z16_FORNEC = '"+cFornece+"'"
    EndIf
    
    cQuery += CRLF + " ORDER BY Z16_EMISSA, Z16_ITEM "
   
   
    PLSQuery(cQuery, cAlias)

    aTapec := {}

    while (cAlias)->(!eof())

        aAdd(aTapec,{;  
            			(cAlias)->Z16_STATUS,;
        				 oNo,;
                        (cAlias)->Z16_XFILIA,;
                        (cAlias)->Z16_EMISSA,;
                        0,;
                        (cAlias)->Z16_DATA,;
                        0,;
                        (cAlias)->Z16_DTENV,;
                        0,;
                        (cAlias)->Z16_RETMAI,;
                        (cAlias)->Z16_NUMPV,;
                        (cAlias)->Z16_PRODUT,;
                        (cAlias)->Z16_DESC,;
                        (cAlias)->Z16_ITEM,;
                        (cAlias)->Z16_QTDVEM,;
                        (cAlias)->Z16_LOCAL,;
                        (cAlias)->Z16_FORNEC,;
                        (cAlias)->Z16_XFILIA,;
                        (cAlias)->C7_01NUMPV;
                        })
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())
    
    
    if len(aTapec) == 0
        AAdd(aTapec, {"1",oNo,"",CTOD("//"),0,CTOD("//"),0,CTOD("//"),0,CTOD("//"),"","","","","","","","",""})
    endif

    oBrowse:SetArray(aTapec)

    oBrowse:bLine := {|| {   	iif(aTapec[oBrowse:nAt,01]=="1",oSt1,oSt2) ,;  
                                aTapec[oBrowse:nAt,02] ,;
                                ALLTRIM(U_RETDESCFI(aTapec[oBrowse:nAt,03])) ,;
                                aTapec[oBrowse:nAt,04] ,;
                                fCalEn(aTapec[oBrowse:nAt,04],aTapec[oBrowse:nAt,06]),;
                                aTapec[oBrowse:nAt,06] ,;
                                fCalEn(aTapec[oBrowse:nAt,06],aTapec[oBrowse:nAt,08]),;
                                aTapec[oBrowse:nAt,08] ,;
                                fCalEn(aTapec[oBrowse:nAt,08],aTapec[oBrowse:nAt,10]),;
                                aTapec[oBrowse:nAt,10] ,;
                                aTapec[oBrowse:nAt,11] ,;
                                aTapec[oBrowse:nAt,12] ,;
                                aTapec[oBrowse:nAt,13] ,;
                                aTapec[oBrowse:nAt,14] ,;
                                aTapec[oBrowse:nAt,15] ,;
                                aTapec[oBrowse:nAt,16] ,;
                                aTapec[oBrowse:nAt,17] ,;
                                aTapec[oBrowse:nAt,18],;                              
                                aTapec[oBrowse:nAt,19];                              
                            }}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCalqDt
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static function fCalqDt(dEmissa)

Local _dData := Date()
Local nDias 
	nDias := DateDiffDay(dEmissa,_dData)
Return nDias


//--------------------------------------------------------------
/*/{Protheus.doc} fCalqDt
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static function fCalEn(dEmissa,dDtEnv)

Local cData
Local cDaEn
Local nDias 
default dDtEnv := Date()
default dEmissa := Date()

cData:= DTOS(dDtEnv)

StrTran(cData,'/','')
if EMPTY(cData)
dDtEnv := Date()
EndIf

cDaEn:= DTOS(dEmissa)

StrTran(cDaEn,'/','')
if EMPTY(cDaEn)
dEmissa := Date()
EndIf



	nDias := DateDiffDay(dEmissa,dDtEnv)
Return nDias



//--------------------------------------------------------------
/*/{Protheus.doc} fCalqDt
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static function fCalRet(dDtEnv,dDtRet)

Local nDias := 0
Default dDtEnv := Date()
Default dDtRet := Date()

	nDias := DateDiffDay(dDtEnv,dDtRet)
Return nDias
//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fMarc(nLinha)

    if oBrowse:AARRAY[nLinha][2]:CNAME == "LBNO"
        aTapec[nLinha][2] := oOk
    else
        aTapec[nLinha][2] := oNo
    endif

    oBrowse:refresh()
    
Return

Static Function fAltera()

	
	Local nLinha := 0
	Local aCamp := {"Z16_STATUS","Z16_DTENV","Z16_RETMAI"}
	Private cCadastro := "Cancela Subistituํ  - Altera็ใo de Cadastro"
   

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0 

    	    DbSelectArea('Z16')
	    	Z16->(DbSetOrder(2))//Z16_XFILIA+Z16_NUMPV+Z16_ITEM
			if Z16->(DbSeek(aTapec[nLinha][18]+aTapec[nLinha][11]+aTapec[nLinha][14]))     
	        AxAltera("Z16",Z16->(Recno()),4,,aCamp)
	        endif

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ zLegenda   บAutor  ณMicrosiga         บ Data ณ  09/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria array com as cores/legendas                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function zLegenda()

	Local aLegenda := {}

	//Monta as legendas (Cor, Legenda)

	aAdd(aLegenda,     {"BR_VERDE"		,	"Cancelado"})
	aAdd(aLegenda,     {"BR_VERMELHO" 	,	"Pendente" })

	*/
	//Chama a fun็ใo que monta a tela de legenda
	BrwLegenda("STATUS CHAMADO", "Status Chamado", aLegenda)

Return