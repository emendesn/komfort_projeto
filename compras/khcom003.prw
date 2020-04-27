#include 'protheus.ch'
#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE ENTER CHR(13)+CHR(10)

Static nAltBot		:= 010
Static nDistPad		:= 001

//--------------------------------------------------------------
/*/{Protheus.doc} KHCOM003
Description //Manutenção de Kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 02/01/2019 /*/
//--------------------------------------------------------------
User Function KHCOM003()

	Local cDescricao := "Manutenção de Kits"
    
    Private oTela
	Private oLayer := FWLayer():new()
	Private aCoord := FWGetDialogSize(oMainWnd) //ret. array com a area da tela
    Private oCampos
	Private oBotoes
	Private oKits
    Private oItens

    Private aCantoKit := {"1-Sim","2-Não","3-Ambos"}
    Private nCantoKit := val(aCantoKit[3])

    Private aCheKit := {"1-Sim","2-Não","3-Ambos"}
    Private nCheKit := val(aCheKit[3])

    Private aChdKit := {"1-Sim","2-Não","3-Ambos"}
    Private nChdKit := val(aChdKit[3])

    Private aSemBracoK := {"1-Sim","2-Não","3-Ambos"}
    Private nSemBracoK := val(aSemBracoK[3])

    Private aBaseKit := {"1-Sim","2-Não","3-Ambos"}
    Private nBaseKit := val(aBaseKit[3])

    Private aUsbKit := {"1-Sim","2-Não","3-Ambos"}
    Private nUsbKit := val(aUsbKit[3])

    Private aPuffKit := {"1-Sim","2-Não","3-Ambos"}
    Private nPuffKit := val(aPuffKit[3])

    Private oGetFiltro
    Private cGetFiltro := space(100)

    Private aHeaderKit
    Private aColsKit
    
    Private aHeaderItK
    Private aColsItKit

    Private oMSNewGe1
    Private oMSNewGe2

    Private nPStatus := 0
	Private nPCodPai := 0
    Private nPDesc := 0
    Private nPEcomm := 0
    Private nPSKU := 0

    Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
	Private oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cDescricao),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
	
	//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	oLayer:AddLine("L01",24,.T.)
	oLayer:AddLine("L02",39,.T.)
	oLayer:AddLine("L03",37,.T.)
		
	//Cria as colunas do Layer
	oLayer:addCollumn('Col01',90,.F.,"L01")
	oLayer:addCollumn('Col02',10,.F.,"L01")
	oLayer:addCollumn('Col03',100,.F.,"L02")  
	oLayer:addCollumn('Col04',100,.F.,"L03")  
	
	//Adiciona Janelas as colunas
	oLayer:addWindow('Col01','C1_Win01','Parâmetros',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col02','C2_Win02','Açoões',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col03','C3_Win03','Kits',100,.F.,.F.,/**/,"L02",/**/)
	oLayer:addWindow('Col04','C4_Win04','Itens Kit',100,.F.,.F.,/**/,"L03",/**/)
		
	oCampos := oLayer:getWinPanel('Col01','C1_Win01',"L01")
	oBotoes := oLayer:getWinPanel('Col02','C2_Win02',"L01")                             
	oKits := oLayer:getWinPanel('Col03','C3_Win03',"L02")
	oItKits := oLayer:getWinPanel('Col04','C4_Win04',"L03")
    
    CriaParam()
	CriaBotoes()

    fMSNewGe1()
    fMSNewGe2()

    fGetKits()
    fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2])

	oTela:Activate(,,,.T.,/*valid*/,,{|| } )
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} CriaParam
Description //Criação dos parametros superiores
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function CriaParam()

    //Descrição Kit
	@  002,  000 Say  oSay Prompt 'Descrição Kit:' FONT oFont11 COLOR CLR_BLUE Size  40, 08 Of oCampos Pixel
	@  011,  000 MSGet oGetFiltro	Var cGetFiltro FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 05 Picture "@!" Of oCampos

    //Canto
    @ 002, 160 Say  oSay Prompt 'Canto ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oCampos Pixel
    TComboBox():New( 011,160, {|u|if(PCount()>0,nCantoKit := val(u),nCantoKit)} ,aCantoKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

    //Che/E
    @ 002, 210 Say  oSay Prompt 'CH/E ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oCampos Pixel
    TComboBox():New( 011,210, {|u|if(PCount()>0,nCheKit := val(u),nCheKit)} ,aCheKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)
        
    //Ch/D
    @ 002, 260 Say  oSay Prompt 'CH/D ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oCampos Pixel
    TComboBox():New( 011,260, {|u|if(PCount()>0,nChdKit := val(u),nChdKit)} ,aChdKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

    //Puff
    @ 002, 310 Say  oSay Prompt 'PUFF ?' FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oCampos Pixel
    TComboBox():New( 011,310, {|u|if(PCount()>0,nPuffKit := val(u),nPuffKit)} ,aPuffKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

    //Sem Braço
    @ 002, 360 Say  oSay Prompt 'Sem Braço ?' FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oCampos Pixel
    TComboBox():New( 011,360, {|u|if(PCount()>0,nSemBracok := val(u),nSemBracoK)} ,aSemBracoK, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

    //Base
    @ 002, 410 Say  oSay Prompt 'Base ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oCampos Pixel
    TComboBox():New( 011,410, {|u|if(PCount()>0,nBaseKit := val(u),nBaseKit)} ,aBaseKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)
    
    //USB
    @ 002, 460 Say  oSay Prompt 'USB ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oCampos Pixel
    TComboBox():New( 011,460, {|u|if(PCount()>0,nUsbKit := val(u),nUsbKit)} ,aUsbKit, 040, 011, oCampos, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 010, 490 BUTTON oBtnPesquisar PROMPT "Pesquisar" SIZE 040, 011 OF oCampos ACTION {|| fGetKits() } PIXEL
    oBtnPesquisar:setCSS("QPushButton{color: #000000; border: 1px solid #6B8E23; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #00FF7F);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #00FF7F, stop: 1 #008000);}")

    @ 010, 537 BUTTON oBtnA_Saldo PROMPT "A_Saldo" SIZE 040, 011 OF oCampos ACTION {|| U_KHESTLOAD(),U_KHESTJOB() } PIXEL
       
    @ 010, 587 BUTTON oBtnA_Produto PROMPT "A_Produto" SIZE 040, 011 OF oCampos ACTION {|| U_KHJB010() } PIXEL
    
    @ 010, 637 BUTTON oBtnA_excel PROMPT "Gera_Excel" SIZE 040, 011 OF oCampos ACTION {|| U_KHMKT001() } PIXEL
    


Return

//--------------------------------------------------------------
/*/{Protheus.doc} CriaBotoes
Description //Criação dos botões laterais
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function CriaBotoes()
    
	Local aTamBot := Array(4)

	aFill(aTamBot,0)
	
    //Adpta o tamanho dos botoes na tela
	StaticCall(AGEND,DefTamBot,@aTamBot)
	aTamBot[3] := (oBotoes:nClientWidth)
	aTamBot[4] := (oBotoes:nClientHeight)
    
	StaticCall(AGEND,DefTamBot,@aTamBot,000,000,-100,nAltBot,.T.,oBotoes)
	tButton():New(aTamBot[1],aTamBot[2],"&Alterar",oBotoes,{|| fAltKit(oMSNewGe1:acols[oMSNewGe1:nat][nPSKU], oMSNewGe1:nat) },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| })
	
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    tButton():New(aTamBot[1],aTamBot[2],"&Visualizar",oBotoes,{|| fVisKit(oMSNewGe1:acols[oMSNewGe1:nat][nPSKU]) },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| })

    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    tButton():New(aTamBot[1],aTamBot[2],"&Bloquear/Desbloquear",oBotoes,{|| fBloq(oMSNewGe1:acols[oMSNewGe1:nat][nPSKU], oMSNewGe1:nat) },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| })

    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oSair := tButton():New(aTamBot[1],aTamBot[2],"&Sair",oBotoes,{|| oTela:end() },aTamBot[3],aTamBot[4],,,,.T.,,,,{|| })
    oSair:setCSS("QPushButton{color: #000000; border: 1px solid #A52A2A; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FF0000, stop: 1 #FFA07A);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FFA07A, stop: 1 #FF0000);}")
   	
	oLayer:Refresh()
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGetKits
Description //Carrega os kits cadastrados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fGetKits()
    
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local aInfo := {}

    cQuery := "SELECT *"
    cQuery += " FROM "+ retSqlName("ZKC")
    cQuery += " WHERE D_E_L_E_T_ = ''"
        
    aInfo := Separa(cGetFiltro," ",.F.)
    
    For ni := 1 To Len(aInfo)
        cQuery += " AND ZKC_DESCRI LIKE '%"+ alltrim(aInfo[ni]) +"%'"
	Next
    
    if nCantoKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-6, 1) = '1'"
    elseif nCantoKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-6, 1) = '0'"
    endif

    if nCheKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-5, 1) = '1'"
    elseif nCheKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-5, 1) = '0'"
    endif

    if nChdKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-4, 1) = '1'"
    elseif nChdKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-4, 1) = '0'"
    endif

    if nPuffKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-3, 1) = '1'"
    elseif nPuffKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-3, 1) = '0'"
    endif

    if nSemBracoK == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-2, 1) = '1'"
    elseif nSemBracoK == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-2, 1) = '0'"
    endif

    if nBaseKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-1, 1) = '1'"
    elseif nBaseKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI)-1, 1) = '0'"
    endif

    if nUsbKit == 1
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI), 1) = '1'"
    elseif nUsbKit == 2
        cQuery += " AND SUBSTRING(ZKC_CODPAI, LEN(ZKC_CODPAI), 1) = '0'"
    endif

    PLSQuery(cQuery, cAlias)

    aColsKit := {}

    While (cAlias)->(!eof())
        if (cAlias)->ZKC_MSBLQL == '1'
            aAdd(aColsKit,{iif((cAlias)->ZKC_ECOM == '1',oSt1,oSt2),;
                            (cAlias)->ZKC_CODPAI ,;
                            (cAlias)->ZKC_DESCRI ,;
                            iif((cAlias)->ZKC_ECOM == '1',"SIM","NÃO") ,;
                            (cAlias)->ZKC_SKU ,;
                            .T.})
        else
            aAdd(aColsKit,{iif((cAlias)->ZKC_ECOM == '1',oSt1,oSt2),;
                            (cAlias)->ZKC_CODPAI ,;
                            (cAlias)->ZKC_DESCRI ,;
                            iif((cAlias)->ZKC_ECOM == '1',"SIM","NÃO") ,;
                            (cAlias)->ZKC_SKU ,;
                            .F.})
        endif

        (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())

    if len(aColsKit) == 0
        aAdd(aColsKit,{oSt2,"","","","",.F.})
    endif
    
    oMSNewGe1:setArray(aColsKit)
    
    SetCab1(oMSNewGe1:acols[oMSNewGe1:nat][nPCodPai],oMSNewGe1:acols[oMSNewGe1:nat][nPDesc])
    
    oMSNewGe1:ForceRefresh()

    oTela:refresh()

    if oMSNewGe2 <> nil
        fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2])
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGe1
Description //Monta Form Superior com os Kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGe1()
	
	Local nX
	Local aFieldFill := {}
    Local aAlterFields := {}

    aHeaderKit := {}
	
	Aadd(aHeaderKit,{"","FLAG","@BMP",2,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
	aAdd(aHeaderKit,{"Codigo Kit","ZKC_CODPAI",PesqPict("ZKC","ZKC_CODPAI"),35,TamSX3("ZKC_CODPAI")[2],,"",TamSX3("ZKC_CODPAI")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderKit,{"Descrição Kit","ZKC_DESCRI",PesqPict("ZKC","ZKC_DESCRI"),60,TamSX3("ZKC_DESCRI")[2],,"",TamSX3("ZKC_DESCRI")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderKit,{"E-Commerce","ZKC_ECOM",PesqPict("ZKC","ZKC_ECOM"),3,TamSX3("ZKC_ECOM")[2],,"",TamSX3("ZKC_ECOM")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderKit,{"SKU Kit","ZKC_SKU",PesqPict("ZKC","ZKC_SKU"),TamSX3("ZKC_SKU")[1],TamSX3("ZKC_SKU")[2],,"",TamSX3("ZKC_SKU")[3]	,"","","","",,'V',,,})

    oMSNewGe1 := MsNewGetDados():New(0,0,0,0, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oKits, aHeaderKit, aColsKit,{|| fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2]), SetCab1(oMSNewGe1:acols[oMSNewGe1:nat][nPCodPai],oMSNewGe1:acols[oMSNewGe1:nat][nPDesc]) })
	oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    
    nPStatus := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	nPCodPai := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="ZKC_CODPAI"})
    nPDesc := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="ZKC_DESCRI"})
    nPEcomm := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="ZKC_ECOM"})
    nPSKU := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="ZKC_SKU"})

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItKit
Description //Carrega os itens do kit posicionado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fCarrItKit(cPai)

    Local cQuery := ""
    Local cAlias := getNextAlias()

    cQuery := "SELECT ZKD_CODPAI, ZKD_CODFIL, B1_DESC, B1_XPRECV,B1_PRV1"
    cQuery += " FROM "+ retSqlName("ZKD")+" KD"
    cQuery += " INNER JOIN "+ retSqlName("SB1")+" B1 ON B1.B1_COD = KD.ZKD_CODFIL"
    cQuery += " WHERE KD.D_E_L_E_T_ = ''"
    cQuery += " AND B1.D_E_L_E_T_ = ''"
    cQuery += " AND ZKD_CODPAI = '"+ cPai +"'"

    PLSQuery(cQuery, cAlias)

    aColsItKit := {}
    
    While (cAlias)->(!eof())
        aAdd(aColsItKit,{;
                        (cAlias)->ZKD_CODPAI,;
                        (cAlias)->ZKD_CODFIL,;
                        (cAlias)->B1_XPRECV,;
                        (cAlias)->B1_PRV1,;
                        (cAlias)->B1_DESC,;
                        .F.;
                        })
        (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())

    if len(aColsItKit) == 0
        aAdd(aColsItKit,{"","","","","",.F.})
    endif

    oMSNewGe2:setArray(aColsItKit)        
    oMSNewGe2:ForceRefresh()

    oTela:refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGe2
Description //Monta Form Inferior com os itens dos Kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGe2()

	Local nX
	Local aFieldFill := {}
	Local aAlterFields := {}            
	
    aHeaderItK := {}

    Aadd(aHeaderItK,{"Codigo Pai","ZKD_CODPAI",PesqPict("ZKD","ZKD_CODPAI"),TamSX3("ZKD_CODPAI")[1],TamSX3("ZKD_CODPAI")[2],,"",TamSX3("ZKD_CODPAI")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderItK,{"Codigo Produto","ZKD_CODFIL",PesqPict("SB1","ZKD_CODFIL"),TamSX3("ZKD_CODFIL")[1],TamSX3("ZKD_CODFIL")[2],,"",TamSX3("ZKD_CODFIL")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderItK,{"Preco Ecommerce","B1_XPRECV",PesqPict("SB1","B1_XPRECV"),TamSX3("B1_XPRECV")[1],TamSX3("B1_XPRECV")[2],,"",TamSX3("B1_XPRECV")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderItK,{"Preco Orcamento","B1_PRV1",PesqPict("SB1","B1_PRV1"),TamSX3("B1_PRV1")[1],TamSX3("B1_PRV1")[2],,"",TamSX3("B1_PRV1")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderItK,{"Descrição","B1_DESC",PesqPict("SB1","B1_DESC"),60,TamSX3("B1_DESC")[2],,"",TamSX3("B1_DESC")[3]	,"","","","",,'V',,,})

    oMSNewGe2 := MsNewGetDados():New( 0, 0, 0, 0, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oItKits, aHeaderItK, aColsItKit)
    oMSNewGe2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fAltKit
Description //Altera os dados do kit posicionado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fAltKit(cSku, nLinha)

    Local nRec := 0
    Local aAreaZKC := getArea()
    
    Private aCpos := {'ZKC_CODPAI',/*'ZKC_DESCRI',*/'ZKC_MSBLQL','ZKC_ECOM','ZKC_DESCST','ZKC_PRCDE','ZKC_PRCATE','ZKC_COR','ZKC_GARANT','ZKC_EMBALA','ZKC_ESPUMA','ZKC_TECIDO','ZKC_TPENCO','ZKC_TPASSE','ZKC_PECA','ZKC_COMPRI','ZKC_ALTURA','ZKC_PROFUN','ZKC_PESO','ZKC_PSUPOR','ZKC_TEXTO','ZKC_ESTRUT','ZKC_DETALH','ZKC_SKU','ZKC_PRCPOR'}    
    Private cCadastro := "Cadastro de Kits - Alteração de Kits"

    dbSelectArea("ZKC")
    ZKC->(dbSetOrder(3))

    if ZKC->(dbSeek(xFilial()+cSku))
        AxAltera("ZKC",ZKC->(Recno()),4,,aCpos)
        
        //Não mexer nesse trecho abaixo.. -------
        MSMM(,TamSX3("ZKC_CODTXT")[1],,ZKC->ZKC_TEXTO,1,,,"ZKC","ZKC_CODTXT")
        MSMM(,TamSX3("ZKC_CODEST")[1],,ZKC->ZKC_ESTRUT,1,,,"ZKC","ZKC_CODEST")
        MSMM(,TamSX3("ZKC_CODDET")[1],,ZKC->ZKC_DETALH,1,,,"ZKC","ZKC_CODDET")
        //----------------------------------------
        if existBlock("KHALTKIT")  
            ExecBlock("KHALTKIT",.F.,.F.,{ ZKC->(Recno()) })
        endif

    endif
    
    if ZKC->ZKC_MSBLQL == '1'
        oMSNewGe1:acols[nLinha][len(oMSNewGe1:aHeader)+1] := .T.
    else
        oMSNewGe1:acols[nLinha][len(oMSNewGe1:aHeader)+1] := .F.
    endif

    if ZKC->ZKC_ECOM == '1'
        oMSNewGe1:acols[nLinha][nPStatus] := oSt1
        oMSNewGe1:acols[nLinha][nPEcomm] := "SIM"
    else
        oMSNewGe1:acols[nLinha][nPStatus] := oSt2
        oMSNewGe1:acols[nLinha][nPEcomm] := "NÃO"
    endif

    oMSNewGe1:refresh()
    
    restArea(aAreaZKC)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fVisKit
Description //Visualização do kit posicionado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fVisKit(cSku)

    Local nRec := 0
    Local aAreaZKC := getArea()
    
    Private cCadastro := "Cadastro de Kits - Visualização de Kits"

    dbSelectArea("ZKC")
    ZKC->(dbSetOrder(3))

    if ZKC->(dbSeek(xFilial()+cSku))
        AxVisual("ZKC",ZKC->(Recno()),2)
    endif

    restArea(aAreaZKC)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fBloq
Description //Bloqueia o Kit Posicionado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fBloq(cSku, nLinha)

Local aAreaZKC := getArea()
    
    dbSelectArea("ZKC")
    ZKC->(dbSetOrder(3))

    if ZKC->(dbSeek(xFilial()+cSku))
        recLock("ZKC",.F.)
            if ZKC->ZKC_MSBLQL == '1'
                ZKC->ZKC_MSBLQL := '2'
                oMSNewGe1:acols[nLinha][len(oMSNewGe1:aHeader)+1] := .F.
                oMSNewGe1:refresh()
            else
                ZKC->ZKC_MSBLQL := '1'
                oMSNewGe1:acols[nLinha][len(oMSNewGe1:aHeader)+1] := .T.
                oMSNewGe1:refresh()
            endif
        ZKC->(msUnlock())
    else
        Alert("Registro não localizado !!","Atenção")
    endif

    restArea(aAreaZKC)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} SetCab1
Description //seta o Kit posicionado no cabeçalho
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 14/05/2019
/*/
//--------------------------------------------------------------
Static Function SetCab1(cParam1,cParam2)
	
	if !(empty(cParam1))
		cCab :="Kit: " + Alltrim(cParam1) +" / "+ Alltrim(cParam2)
		oLayer:setWinTitle('Col03' ,'C3_Win03',cCab ,"L02" )
	endif

Return