#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} KHFAT002
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/04/2019 /*/
//--------------------------------------------------------------
User Function KHFAT002(cProduto, cDescri)                        

	Private oBtnConfirmar
	Private oBtnPesquisar
	Private oBtnSair
	Private oGetCor
	Private cGetCor := space(20)
	Private oGetFiltro
	Private cGetFiltro := space(100)
	Private oGetMedida
	Private cGetMedida := space(4)
	Private oGroupFIltros
	Private oGroupItensKit
	Private oGroupKits
	Private oSayCor
	Private oSayDescricao
	Private oSayMedida
	Private oSayQtdKit
	Private oSayQtdKits

	Private aHeaderKit := {}
	Private aColsKit := {}

    Private aHeaderFil := {}
	Private aColsFil := {}

    Private lExistKit := .F.

    Private oMSNewGe1 := nil
    Private oMSNewGe2 := nil

    //----------------------------------------------------------------
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
    //----------------------------------------------------------------

    Private nQtdKits := 0

    default cProduto := ""
    default cDescri := ""
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    if !empty(alltrim(cProduto))
        cGetFiltro := alltrim(cProduto) + space(100)
    endif

    if !empty(alltrim(cDescri))
        cGetFiltro := alltrim(cDescri) + space(100)
    endif

	Static oDlg

    lExistKit :=  fExistKit(cGetFiltro)

    if lExistKit
        DEFINE MSDIALOG oDlg TITLE "Pesquisa de Kits" FROM 000, 000  TO 540, 1100 COLORS 0, 16777215 PIXEL

            @ 002, 003 GROUP oGroupFIltros TO 032, 548 PROMPT " Filtros " OF oDlg COLOR 0, 16777215 PIXEL
            @ 008, 463 BUTTON oBtnPesquisar PROMPT "Pesquisar" SIZE 040, 020 OF oDlg ACTION {|| fGetKits() } PIXEL
            @ 008, 505 BUTTON oBtnSair PROMPT "Sair" SIZE 040, 020 OF oDlg ACTION { || oDlg:end(),LjMsgRun("Por favor aguarde, verificando produtos...",, {|| staticCall(SYVA103,SyCarProd) }) } PIXEL
            
            @ 009, 005 SAY oSayDescricao PROMPT "Modelo" FONT oFont11 SIZE 022, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ 016, 005 MSGET oGetFiltro VAR cGetFiltro SIZE 047, 010 VALID {||  } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL

            @ 008, 056 SAY oSayMedida PROMPT "Medida" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ 016, 056 MSGET oGetMedida VAR cGetMedida SIZE 031, 010 VALID {||  } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL

            @ 008, 093 SAY oSayCor PROMPT "Cor" FONT oFont11 SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ 016, 093 MSGET oGetCor VAR cGetCor SIZE 039, 010 VALID {||  } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL

            @ 008, 140 Say  oSay Prompt 'Canto ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
            TComboBox():New( 016,140, {|u|if(PCount()>0,nCantoKit := val(u),nCantoKit)} ,aCantoKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

            @ 008, 185 Say  oSay Prompt 'CH/E ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
            TComboBox():New( 016,185, {|u|if(PCount()>0,nCheKit := val(u),nCheKit)} ,aCheKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)
                
            @ 008, 230 Say  oSay Prompt 'CH/D ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
            TComboBox():New( 016,230, {|u|if(PCount()>0,nChdKit := val(u),nChdKit)} ,aChdKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

            @ 008, 275 Say  oSay Prompt 'PUFF ?' FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oDlg Pixel
            TComboBox():New( 016,275, {|u|if(PCount()>0,nPuffKit := val(u),nPuffKit)} ,aPuffKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

            @ 008, 320 Say  oSay Prompt 'Sem Braço ?' FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oDlg Pixel
            TComboBox():New( 016,320, {|u|if(PCount()>0,nSemBracok := val(u),nSemBracoK)} ,aSemBracoK, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)

            @ 008, 365 Say  oSay Prompt 'Base ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
            TComboBox():New( 016,365, {|u|if(PCount()>0,nBaseKit := val(u),nBaseKit)} ,aBaseKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)
            
            @ 008, 410 Say  oSay Prompt 'USB ?' FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
            TComboBox():New( 016,410, {|u|if(PCount()>0,nUsbKit := val(u),nUsbKit)} ,aUsbKit, 040, 013, oDlg, ,{|| fGetKits() },,,,.T.,,,.F.,{||.T.},.T.,,)
            
            @ 036, 003 GROUP oGroupKits TO 157, 548 PROMPT " Kit's " OF oDlg COLOR 0, 16777215 PIXEL
            fMSNewGe1()
            @ 159, 003 GROUP oGroupItensKit TO 266, 548 PROMPT " Itens Kit " OF oDlg COLOR 0, 16777215 PIXEL
            @ 045, 442 SAY oSayQtdKit PROMPT "Quantidade Kit's Selecionados:" SIZE 080, 007 OF oDlg COLORS 0, 16777215 PIXEL
            @ 045, 519 SAY oSayQtdKits PROMPT nQtdKits SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

            @ 140, 483 BUTTON oBtnConfirmar PROMPT "Confirmar" SIZE 060, 012 OF oDlg ACTION {|| oDlg:end(),A103Grava() } PIXEL
            
            fMSNewGe2()

            oSayQtdKits:refresh()

        ACTIVATE MSDIALOG oDlg CENTERED
    endif

Return lExistKit

//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGe1
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGe1()
	
	Local nX
	Local aFieldFill := {}
    Local aAlterFields := {}
	Local aFields := {"ZKC_CODPAI","ZKC_DESCRI","ZKC_SKU"}
	
	Aadd(aHeaderKit,{"","FLAG","@BMP",2,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
	aAdd(aHeaderKit,{"Codigo Kit","ZKC_CODPAI",PesqPict("ZKC","ZKC_CODPAI"),35,TamSX3("ZKC_CODPAI")[2],,"",TamSX3("ZKC_CODPAI")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderKit,{"Descrição Kit","ZKC_DESCRI",PesqPict("ZKC","ZKC_DESCRI"),60,TamSX3("ZKC_DESCRI")[2],,"",TamSX3("ZKC_DESCRI")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderKit,{"SKU Kit","ZKC_SKU",PesqPict("ZKC","ZKC_SKU"),TamSX3("ZKC_SKU")[1],TamSX3("ZKC_SKU")[2],,"",TamSX3("ZKC_SKU")[3]	,"","","","",,'V',,,})

    oMSNewGe1 := MsNewGetDados():New( 044, 006, 152, 433, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderKit, aColsKit,{|| fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2])})
	oMSNewGe1:oBrowse:bLDblClick := {|| fMarcOne(oMSNewGe1:nAt, oMSNewGe1)  }

    fGetKits()

Return


//fMarcOne: Marca o checkbox da linha posicionada 
Static Function fMarcOne(nLin, oObj) 

	Local nPFlag := Ascan(oObj:aHeader,{|x|AllTrim(x[2])=="FLAG"})
    Local nPCodPai := Ascan(oObj:aHeader,{|x|AllTrim(x[2])=="ZKC_CODPAI"})
    	
    if oObj:aCols[nLin,nPFlag] == "LBTIK"
	    if !empty(alltrim(oObj:aCols[nLin,nPCodPai]))
            oObj:aCols[nLin,nPFlag] := "LBNO"
            nQtdKits -= 1
            fMarcItens(.F.)
            oSayQtdKits:refresh()
        endif
    else
        if !empty(alltrim(oObj:aCols[nLin,nPCodPai]))
            if lSaldo := fSaldoDisp() // Verifico se todos os itens do kit possuem saldo.
                oObj:aCols[nLin,nPFlag] := "LBTIK"
                nQtdKits += 1
                fMarcItens(.T.)
                oSayQtdKits:refresh()
            endif
        endif
    endif

	oObj:Refresh()
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcItens
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMarcItens(lMark)

    Local nPFlag := Ascan(oMSNewGe2:aHeader,{|x|AllTrim(x[2])=="FLAG"})
    Default lMark := .F.

    if len(oMSNewGe2:acols) > 0
        for nx := 1 to len(oMSNewGe2:acols)
            if lMark
                oMSNewGe2:acols[nx][nPFlag] := "LBTIK"
            else
                oMSNewGe2:acols[nx][nPFlag] := "LBNO"
            endif
        Next
    endif

    oMSNewGe2:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSaldoDisp
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fSaldoDisp()
    
    Local lRet := .T.
    Local nSaldo := Ascan(oMSNewGe2:aHeader,{|x|AllTrim(x[2])=="B2_QATU"})
    Local nForaLinha := Ascan(oMSNewGe2:aHeader,{|x|AllTrim(x[2])=="B1_01FORAL"})

    if len(oMSNewGe2:acols) > 0
        For nx := 1 to Len(oMSNewGe2:acols)
            if oMSNewGe2:acols[nx][nSaldo] > 0  .AND. lRet
                lRet := .T.
            elseif oMSNewGe2:acols[nx][nSaldo] == 0 .AND. oMSNewGe2:acols[nx][nForaLinha] == 'F'
                msgAlert("Existe itens do Kit que estão fora de linha e não possuem saldo.","Atenção")
                Return  .F.
            Else
                lRet := .T.
                //msgAlert("Existe itens do Kit que não possui saldo.","Atenção")
                //Return  .F.
            endif
        Next
    endif

Return lRet


//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGe2
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGe2()

	Local nX
	Local aFieldFill := {}
	Local aFields := {"ZKD_CODPAI","ZKD_CODFIL","B1_DESC"}
	Local aAlterFields := {}            
	
    Aadd(aHeaderFil,{"","FLAG","@BMP",2,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})
    aAdd(aHeaderFil,{"Codigo","B1_COD",PesqPict("SB1","B1_COD"),TamSX3("B1_COD")[1],TamSX3("B1_COD")[2],,"",TamSX3("B1_COD")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Descrição","B1_DESC",PesqPict("SB1","B1_DESC"),60,TamSX3("B1_DESC")[2],,"",TamSX3("B1_DESC")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Preço","DA1_PRCVEN",PesqPict("DA1","DA1_PRCVEN"),TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2],,"",TamSX3("DA1_PRCVEN")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Estoque","B2_QATU",PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2],,"",TamSX3("B2_QATU")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Qtd.Prevista","B2_QATU",PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2],,"",TamSX3("B2_QATU")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Fora Linha","B1_01FORAL",PesqPict("SB1","B1_01FORAL"),TamSX3("B1_01FORAL")[1],TamSX3("B1_01FORAL")[2],,"",TamSX3("B1_01FORAL")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Campanha","B1_01FORAL",PesqPict("SB1","B1_01FORAL"),TamSX3("B1_01FORAL")[1],TamSX3("B1_01FORAL")[2],,"",TamSX3("B1_01FORAL")[3]	,"","","","",,'V',,,})
    aAdd(aHeaderFil,{"Armazem","B2_LOCAL",PesqPict("SB2","B2_LOCAL"),TamSX3("B2_LOCAL")[1],TamSX3("B2_LOCAL")[2],,"",TamSX3("B2_LOCAL")[3]	,"","","","",,'V',,,})
	
    oMSNewGe2 := MsNewGetDados():New( 166, 006, 262, 543, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderFil, aColsFil)
    
    fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2])
    
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fGetKits
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fGetKits()
    
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local aInfo := {}

    nQtdKits := 0
    
    cQuery := "SELECT *"
    cQuery += " FROM "+ retSqlName("ZKC")
    cQuery += " WHERE D_E_L_E_T_ = ''"
        
    aInfo := Separa(cGetFiltro," ",.F.)
    
    For nI:=1 To Len(aInfo)
        cQuery += " AND ZKC_DESCRI LIKE '%"+ alltrim(aInfo[nI]) +"%'"
	Next

    if !empty(alltrim(cGetCor))
        cQuery += " AND ZKC_DESCRI LIKE '%"+ alltrim(cGetCor) +"%'"
    endif

    if !empty(alltrim(cGetMedida))
        cQuery += " AND ZKC_DESCRI LIKE '%"+ alltrim(cGetMedida) +"%'"
    endif

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
        aAdd(aColsKit,{"LBNO",;
                        (cAlias)->ZKC_CODPAI ,;
                        (cAlias)->ZKC_DESCRI ,;
                        (cAlias)->ZKC_SKU ,;
                        .F.})
        (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())

    if len(aColsKit) == 0
        aAdd(aColsKit,{"LBNO","","","",.F.})
    endif
    
    oMSNewGe1:setArray(aColsKit)
    oMSNewGe1:ForceRefresh()

    oDlg:refresh()

    if oMSNewGe2 <> nil
        fCarrItKit(oMSNewGe1:acols[oMSNewGe1:nat][2])
    endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fExistKit
Description //Virifica se existe kits com os dados informados
@param //cProduto, cDescri| Parameter //Codigo do Produto, descrição do produto
@return xRet Return Description
@author  - Alexis Duarte
@since 02/05/2019 /*/
//--------------------------------------------------------------
Static Function fExistKit(cGetFiltro)

    Local lRet := .T.
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local aInfo := {}

    cQuery := "SELECT *"
    cQuery += " FROM "+ retSqlName("ZKC")
    cQuery += " WHERE D_E_L_E_T_ = ''"
    
    aInfo := Separa(cGetFiltro," ",.F.)
    
    For nI:=1 To Len(aInfo)
        cQuery += " AND ZKC_DESCRI LIKE '%"+ alltrim(aInfo[nI]) +"%'"
	Next

    if empty(alltrim(cGetFiltro))
       lRet := .F.
       return lRet
    endif

    PLSQuery(cQuery, cAlias)

    aColsKit := {}

    While (cAlias)->(!eof())
        aAdd(aColsKit,{"LBNO",;
                        (cAlias)->ZKC_CODPAI ,;
                        (cAlias)->ZKC_DESCRI ,;
                        (cAlias)->ZKC_SKU ,;
                        .F.})
        (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())

    if len(aColsKit) == 0
        aAdd(aColsKit,{"LBNO","","","",.F.})
        lRet := .F. 
    endif

return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItKit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fCarrItKit(cPai)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local nPFlag := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="FLAG"})

    cQuery := "SELECT ZKD_CODPAI, ZKD_CODFIL, B1_DESC"
    cQuery += " FROM "+ retSqlName("ZKD")+" KD"
    cQuery += " INNER JOIN "+ retSqlName("SB1")+" B1 ON B1.B1_COD = KD.ZKD_CODFIL"
    cQuery += " WHERE KD.D_E_L_E_T_ = ''"
    cQuery += " AND B1.D_E_L_E_T_ = ''"
    cQuery += " AND ZKD_CODPAI = '"+ cPai +"'"

    PLSQuery(cQuery, cAlias)

    aColsFil := {}
    
    While (cAlias)->(!eof())
        SyCarSB1((cAlias)->ZKD_CODFIL)
        (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())

    oMSNewGe2:setArray(aColsFil)

    if len(aColsFil) == 0
        aAdd(aColsFil,{"","",0,0,0,"","","",.F.})
    else
        if oMSNewGe1:acols[oMSNewGe1:nat][nPFlag] == "LBTIK"
            fMarcItens(.T.)
        else
            fMarcItens(.F.)
        endif
    endif
        
    oMSNewGe2:ForceRefresh()

    oDlg:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SyCarSB1	ºAutor  ³Microsiga           º Data ³  20/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carregas todos os produtos conforme a palavra digitada.     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SyCarSB1(cString)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local cQry	 	:= ''
Local cFilAtu	:= ''
Local nSaldoSB2 := 0
Local nSalPrev	:= 0
Local nQtdPrev	:= 0
Local cLocPad	:= ''
Local aDesc    	:= {}
Local nPrcven	:= 0
Local aDados	:= {}
Local lFora		:= .F.

//#CMG20180926.bn
Local _nB2QEmp := 0
Local _nB2Rese := 0
Local _nB2QPed := 0
Local _nB2QACl := 0                                         
Local _nB2QAtu := 0
//#CMG20180926.en

default cString := ""
//aColsFil := {}

if empty(alltrim(cString))
    
    aColsFil := {}
    oMSNewGe2:setArray(aColsFil)
    oMSNewGe2:ForceRefresh()

    oDlg:refresh()
    
    return
endif

cQry += " SELECT DISTINCT B1_COD, B1_DESC, B1_PRV1, B2_QATU, B2_QEMP, B2_RESERVA, B2_QPEDVEN, B2_QACLASS , B1_01FORAL, B1_PROC,  B1_LOJPROC, B1_01PRODP, B2_01SALPE " + CRLF //cQry += " SELECT DISTINCT B1_COD, B1_DESC, B1_PRV1, ISNULL((SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + SB2.B2_QPEDVEN)),0) B2_QATU, B1_01FORAL, B1_PROC,  B1_LOJPROC "
cQry += " FROM "+RetSqlName("SB1")+" SB1 " + CRLF
cQry += " INNER JOIN "+RetSqlName("SB4")+" SB4 ON B4_FILIAL = '"+xFilial("SB4")+"' AND B4_COD=B1_01PRODP AND B4_STATUS = 'A' AND SB4.D_E_L_E_T_ = ' ' " + CRLF //Eduardo 27/11/2014
cQry += " LEFT JOIN "+RetSqlName("SB2")+" SB2 ON B2_COD=B1_COD AND B2_LOCAL = '01' AND B2_FILIAL = '"+cLocDep+"' AND SB2.D_E_L_E_T_ = '' " + CRLF
cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' " + CRLF
cQry += " AND B1_COD = '" + cString + "'"+ CRLF

cQry += " AND SB1.B1_MSBLQL <> '1' " + CRLF //#RVC20180416.n
cQry += " AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQry += " ORDER BY B1_COD " + CRLF

cQry := ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	_lForal	:= .F.	//#RVC20181121.n

	_nB2QEmp := IIF((cAlias)->B2_QEMP<0,0,(cAlias)->B2_QEMP)
	_nB2Rese := IIF((cAlias)->B2_RESERVA<0,0,(cAlias)->B2_RESERVA)
	_nB2QPed := fQtdPed((cAlias)->B1_COD,'01')//IIF((cAlias)->B2_QPEDVEN<0,0,(cAlias)->B2_QPEDVEN) - #CMG20181113.n
	_nB2QACl := IIF((cAlias)->B2_QACLASS<0,0,(cAlias)->B2_QACLASS)
	_nB2QAtu := IIF((cAlias)->B2_QATU<0,0,(cAlias)->B2_QATU)	
	
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + (cAlias)->B1_PROC + (cAlias)->B1_LOJPROC ))
	If SA2->A2_XFORFAT=="1"
		cFilAtu := xFilial("SB2")
	Else
		cFilAtu := cLocDep
	Endif
	
	SB1->(DbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1") + PADR((cAlias)->B1_COD,TAMSX3("B1_COD")[1]) ))
	
	//Tratamento dos armazens para pecas especificas
	SB4->(DbSetOrder(1))
	SB4->(MsSeek(xFilial("SB4") + (cAlias)->B1_01PRODP ))
	cLocPad := SB1->B1_LOCPAD

    //          SALDO ATUAL - (EMPENHO + RESERVA + QTD.PEDIDO + QTD. A CLASSIFICAR)		
	nSaldoSB2 := _nB2Qatu - (_nB2QEmp+_nB2Rese+_nB2QPed+_nB2QACl)
	nSaldoSB2 := IIF(nSaldoSB2>0,nSaldoSB2,0)
	nSalPrev := (cAlias)->B2_01SALPE //AFD20180601.N
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Saldo do Produto fora de linha da loja que estiver realizando a venda - #ES20180607³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÙ
	If (cAlias)->B1_01FORAL == 'F' .And. nSaldoSB2 == 0//#CMG20180926.n - verifica se não tem saldo no 01 para procurar saldo de mostruario
		
		_lForal := .T.	//#RVC20181121.n
		
		cQry := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_LOCALIZ," + CRLF
		cQry += " B2_QATU, B2_QEMP, B2_RESERVA, B2_QPEDVEN, B2_QACLASS FROM "+RetSqlName("SB2")+" SB2 " + CRLF
		cQry += " WHERE RIGHT(B2_FILIAL,2) = '" + RIGHT(CFILANT,2) + "' " + CRLF 
		cQry += " AND D_E_L_E_T_ = ' ' " + CRLF
		cQry += " 	AND B2_COD = '" + (cAlias)->B1_COD + "' " + CRLF
		cQry += " 	AND B2_LOCAL = '" + _cSYLocPad + "' " + CRLF //#CMG20181123.n		
		cQry += " 	AND (SB2.B2_QATU - (SB2.B2_QEMP + SB2.B2_RESERVA + SB2.B2_QPEDVEN)) > 0 " + CRLF
		
		If Select("PFL") > 0
			PFL->(DbCloseArea())
		EndIf
		
		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"PFL",.F.,.T.)
		                
		_nB2QEmp := IIF(PFL->B2_QEMP<0,0,PFL->B2_QEMP)
		_nB2Rese := IIF(PFL->B2_RESERVA<0,0,PFL->B2_RESERVA)
		_nB2QPed := fQtdPed(PFL->B2_COD,_cSYLocPad)//IIF(PFL->B2_QPEDVEN<0,0,PFL->B2_QPEDVEN) - #CMG20181113.n
		_nB2QACl := IIF(PFL->B2_QACLASS<0,0,PFL->B2_QACLASS)
		_nB2QAtu := IIF(PFL->B2_QATU<0,0,PFL->B2_QATU)	
			           				
		//Se tiver saldo na loja considera esse saldo, caso contrario busca saldo da Matriz - CD 01
		nSaldoSB2 := _nB2Qatu - (_nB2QEmp+_nB2Rese+_nB2QPed+_nB2QACl)    
		nSaldoSB2 := IIF(nSaldoSB2<0,0,nSaldoSB2)
		lFora := Iif(nSaldoSB2 > 0,.T.,.F.) //#CMG20180718.n
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A tabela de preço serah por fornecedor sendo necessário      ³	 
	//³	localizar o produto em N tabelas priorizando a tabela de     ³	
	//³	fornecedor e na sequencia a tabela principal #Ellen 04062018 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("DA0") 
	Dbsetorder(1)
	
	DbSelectArea("DA1") 
	DA1->(DbSetOrder(1))
	
	DA0->(DbGotop())
	While DA0->(!Eof())
		//If DA0->DA0_ATIVO == '1' .And. ( DA0->DA0_CODTAB <> '001' .OR. DA0->DA0_CODTAB <> '002' ) - #CMG20180613.o
		If DA0->DA0_ATIVO == '1' .And. ( DA0->DA0_CODTAB <> '001' .And. DA0->DA0_CODTAB <> '002' )  //#CMG20180613.n 
		If DA1->(MsSeek(xFilial("DA1") + DA0->DA0_CODTAB + (cAlias)->B1_COD ))
			nPrcven := DA1->DA1_PRCVEN 
				AAdd(aTabela,DA1->DA1_CODTAB)
			Exit
		Endif 
		Endif
	DA0->(DbsKIP())
	EndDo
	If nPrcven > 0
		AAdd(aColsFil ,{"LBNO",(cAlias)->B1_COD,(cAlias)->B1_DESC,nPrcven,nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N", Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		nPrcven := 0
	Else
		aDados := KMHTAB001((cAlias)->B1_COD)// Verifica se existe na tabela principal
		If Len(aDados) > 0  
			AAdd(aColsFil ,{"LBNO",(cAlias)->B1_COD,(cAlias)->B1_DESC,aDados[1][2],nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N",Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		Else // Se nao tem na tabela de preco por fornecedor retorna preco zero
			AAdd(aColsFil ,{"LBNO",(cAlias)->B1_COD,(cAlias)->B1_DESC,0,nSaldoSB2,nSalPrev,(cAlias)->B1_01FORAL,"N",Iif(lFora,SuperGetMV("SY_LOCPAD"),cLocPad),.F.})
		Endif
		cTabpad := '001'
	Endif
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

DA0->( dbCloseArea() )
DA1->( dbCloseArea() )

If Len(aColsFil)==0
	aColsFil := {"LBNO","","",0,0,0,"","","",.F.}
Endif

oMSNewGe2:setArray(aColsFil)
oMSNewGe2:ForceRefresh()

oDlg:refresh()

RestArea(aArea)

Return

//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | FQTDPED       | Autor | Caio Garcia            | Data | 13/11/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Funcao para retornar a quantidade do produto em pedido             |
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+
Static Function fQtdPed(_cCodPro,_cLocal)

Local _cQuery	:= ""
Local _nQtd		:= ""
Local _cSYLocPad	:= SuperGetMV("SY_LOCPAD",.T.,"01")	//#RVC20181121.n - //#CMG20181122.n

Default _lForal := .F.	//#RVC20181121.n

_cQuery := " SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED "
_cQuery += " FROM " + RetSQLName("SC6") + "(NOLOCK) SC6 "
_cQuery += " WHERE SC6.D_E_L_E_T_ <> '*' "
_cQuery += " AND C6_PRODUTO = '" + _cCodPro + "' " 
_cQuery += " AND C6_NOTA = '' "
_cQuery += " AND C6_BLQ <> 'R' "
_cQuery += " AND C6_QTDEMP = 0 "
_cQuery += " AND C6_QTDVEN > C6_QTDLIB "
_cQuery += " AND C6_CLI <> '000001' "
_cQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"' "


If _lForal
	
	_cQuery += " AND C6_LOCAL = '" + Alltrim(_cSYLocPad) + "' "

Else	
	
	_cQuery += " AND C6_LOCAL = '" + Alltrim(_cLocal) + "' "
	
EndIf

If Select("_QTDPED_") > 0
	_QTDPED_->(DbCloseArea())
EndIf

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_QTDPED_",.F.,.T.)

_nQtd := _QTDPED_->QTDPED

Return _nQtd


//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | KMHTAB001     | Autor | Ellen Santiago         | Data | 02/06/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Funcao para retornar todos os produtos da tabela de preco principal|
//+------------+--------------------------------------------------------------------+
//| Uso        | KomfortHouse                                                       |
//+---------------------------------------------------------------------------------+

Static Function KMHTAB001(cCodPro)

Local cQuery := ""
Local aProd := {}

cQuery := "SELECT * " + CRLF
cQuery += "FROM " + RetSQLName("DA1") + " DA1 " + CRLF
cQuery += "INNER JOIN " + RetSQLName("DA0") + " DA0 " + CRLF
cQuery += "ON DA0_CODTAB = DA1_CODTAB " + CRLF 
cQuery += "WHERE DA1_CODTAB = '001' " + CRLF
cQuery += "AND DA0_ATIVO = '1'" + CRLF 
cQuery += "AND DA1_CODPRO = '" + cCodPro + "' " + CRLF
cQuery += "AND DA1.D_E_L_E_T_ = '' " + CRLF
cQuery += "AND DA0.D_E_L_E_T_ = '' " + CRLF

If Select("TempDA1") > 0
	TempDA1->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TempDA1",.F.,.T.)

While !(TempDA1->(EOF()))
	aAdd(aProd,{TempDA1->DA1_CODPRO,TempDA1->DA1_PRCVEN})
	TempDA1->(DBSkip())
EndDo

Return aProd


Static Function A103Grava()

    Local aArea 	:= GetArea()
    Local cProduto 	:= oGetD1:aCols[oGetD1:nAt,1]
    Local cRef		:= If(Valtype(cComboR)<>"N",Left(cComboR,nTamRef),'')
    Local cTam		:= If(Valtype(cComboM)<>"N",Left(cComboM,nTamCol),'')
    Local nX		:= 0
    Local lGrava	:= .F.
    Local lGravaOK	:= .F.
    Local aTemp		:= {}	
    Local cTabela  := ""	
    Local nPFlag := Ascan(oMSNewGe2:aHeader,{|x|AllTrim(x[2])=="FLAG"})

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Busca a tabela de preco a ser usada - #Ellen 02.06.2018         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aTabela) > 0 
        cTabela := aTabela[1]
    Else
        cTabela := '001'//cTabpad // Emergencial para ajuste posterior
    Endif

    For nX := 1 To Len(aTabela)
        nPos := aScan(aTabela, {|x|x  == cTabela})
        If  nPos > 0 .And. cTabela <> aTabela[nPos]    
            aadd(aTemp,aTabela[nPos])
        Else
            Iif ( Len(aTabela) == nX,cTabela := aTabela[nX],	cTabela := aTabela[nX+1] ) 
        Endif
    Next nX

    If Len(aTemp) > 0 
        lGrava	 := .F.
        lGravaOK := .F.
        MsgStop( "Ação não permitida. Produtos de diferentes tabelas de preço, selecione um produto por vez","Atenção" )
        Return
    Else

        DbSelectArea("SB4")
        DbSetOrder(1)
        DbSeek(xFilial("SB4") + cProduto )
        
        DbSelectArea("SA2")
        SA2->(DbSetOrder(1))
        SA2->(DbGoTop())
        
        SA2->(DbSeek(xFilial("SA2")+SB4->B4_PROC+SB4->B4_LOJPROC))
        
        If !Empty(Alltrim(SA2->A2_XTABELA))
            cTabPad := SA2->A2_XTABELA
        Else
            cTabpad  := cTabela
        EndIf
                        
        lGrava	 := .T.
        lGravaOK := .T.

    Endif

    //Produtos
    lGrava	:= .F.
    if Len(oMSNewGe2:acols) > 0
        for nx := 1 to len(oMSNewGe2:acols)
            if oMSNewGe2:acols[nx][nPFlag] == "LBTIK"
                lGrava 	 := .T.
                lGravaOK := .T.
            endif
        next nx
    endif

    If lGrava
        staticCall(SYVA103,A103IncItens,oMSNewGe2:acols,,,)
    EndIF

    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Ajusta os valores de frete por data de entrega.				  ³
    //³So poderá existir um valor por data de entrega.				  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lGravaOK
        U_A103AjVlrFre(.T.)
    EndIF

    If !lGravaOK
        MsgStop("Não foi selecionado nenhum item para carregar no atendimento.","Atenção")
    Endif

    aTabela := {}
    RestArea(aArea)

Return