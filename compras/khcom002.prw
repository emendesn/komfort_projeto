#include "rwmake.ch"
#include "TbiConn.ch"
#include "protheus.ch"
#include "TopConn.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} KHCOM002
Description //Tela de cadastro de kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
User Function KHCOM002()                        

  Private oButtonAddPreKit
  Private oButtonKit
  Private oButtonRemover
  
  Private oDescriProd
  Private cDescriProd := space(100)
  
  Private oDescriSite
  Private cDescriSite := space(100)

  Private oGetCor
  Private cGetCor := space(20)
  Private oGetFilCor
  Private cGetFilCor := space(15)
  Private oGetFilMedida
  Private cGetFilMedida := space(4)
  Private oGetFilModelo
  Private cGetFilModelo := space(20)
  Private oGetMedida
  Private nGetMedida := 0
  Private oGetModelo
  Private cGetModelo := space(6)
  Private oGetPuff
  Private oGroupFiltros
  Private oGroupItFill
  Private oGroupKit
  Private oSay1
  Private oSayCanto
  Private oSayChd
  Private oSayCHE
  Private oSayCor
  Private oSayFilCor
  Private oSayFilMedida
  Private oSayFilMod
  Private oSayFilSemBraco
  Private oSayMedida
  Private oSayModelo
  Private oSayPuff
  Private oSaySB
  Private oSayUsb

  Private oButtonPesq

  Private aCanto := {"1-Ambos","2-Sim","3-Não"}
  Private nCanto := val(aCanto[1])
  
  Private aCantoKit := {"1-Sim","2-Não"}
  Private nCantoKit := val(aCantoKit[2])

  Private aChe := {"1-Ambos","2-Sim","3-Não"}
  Private nChe := val(aChe[1])

  Private aCheKit := {"1-Sim","2-Não"}
  Private nCheKit := val(aCheKit[2])

  Private aChd := {"1-Ambos","2-Sim","3-Não"}
  Private nChd := val(aChd[1])

  Private aChdKit := {"1-Sim","2-Não"}
  Private nChdKit := val(aChdKit[2])

  Private aSemBraco := {"1-Ambos","2-Sim","3-Não"}
  Private nSemBraco := val(aSemBraco[1])

  Private aSemBracoK := {"1-Sim","2-Não"}
  Private nSemBracoK := val(aSemBracoK[2])

  Private aBase := {"1-Ambos","2-Sim","3-Não"}
  Private nBase := val(aBase[1])

  Private aBaseKit := {"1-Sim","2-Não"}
  Private nBaseKit := val(aBaseKit[2])

  Private aUsb := aUsbKit := {"1-Ambos","2-Sim","3-Não"}
  Private nUsb := nUsbKit := val(aUsb[1])

  Private aUsbKit := {"1-Sim","2-Não"}
  Private nUsbKit := val(aUsbKit[2])

  Private aPuffKit := {"1-Sim","2-Não"}
  Private nPuffKit := val(aPuffKit[2])
    
  Private aColsProd := {}
  Private aColsKit := {}

  Private oSayCodKit
  Private cCodKit := ""

  Private aColsCores := {}
  Private cGetFiltro := Space(15)
  
  Private nOrder := 0 
  
  Static oDlg

  DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

  DEFINE MSDIALOG oDlg TITLE "Kit de Produtos" FROM 000, 000  TO 540, 1300 COLORS 0, 16777215 PIXEL

    @ 000, 004 GROUP oGroupFiltros TO 032, 647 PROMPT " Filtros " OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 009, 009 SAY oSayFilMod PROMPT "Modelo" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 016, 008 MSGET oGetFilModelo VAR cGetFilModelo FONT oFont11 SIZE 041, 010 VALID {||  } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 008, 055 SAY oSayFilMedida PROMPT "Medida" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 016, 055 MSGET oGetFilMedida VAR cGetFilMedida FONT oFont11 SIZE 039, 010 VALID {||  } OF oDlg COLORS 0, 16777215 PIXEL

    @ 008, 099 SAY oSayFilCor PROMPT "Cor" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 016, 099 MSGET oGetFilCor VAR cGetFilCor FONT oFont11 SIZE 033, 010 VALID {||  } OF oDlg COLORS 0, 16777215 PIXEL    
    
    @ 008, 137 Say  oSay Prompt 'Canto ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 016,136, {|u|if(PCount()>0,nCanto:= val(u),nCanto)} ,aCanto, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
    
    @ 008, 180 Say  oSay Prompt 'CH/E ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 016,180, {|u|if(PCount()>0,nChe := val(u),nChe)} ,aChe, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
        
    @ 008, 225 Say  oSay Prompt 'CH/D ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 016,225, {|u|if(PCount()>0,nChd := val(u),nChd)} ,aChd, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 008, 270 Say  oSay Prompt 'Sem Braço ?'		FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oDlg Pixel
   	TComboBox():New( 016,270, {|u|if(PCount()>0,nSemBraco := val(u),nSemBraco)} ,aSemBraco, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 008, 313 Say  oSay Prompt 'Base ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 016,313, {|u|if(PCount()>0,nBase := val(u),nBase)} ,aBase, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
    
    @ 008, 357 Say  oSay Prompt 'USB ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 016,357, {|u|if(PCount()>0,nUsb := val(u),nUsb)} ,aUsb, 040, 013, oDlg, ,/*bMudaFiltro*/,,,,.T.,,,.F.,{||.T.},.T.,,)
    
    @ 016, 400 BUTTON oButtonPesq PROMPT "Pesquisar" SIZE 050, 012 OF oDlg ACTION {|| processa( {|| fCarrProd() }, "Aguarde...", "Atualizando Dados...", .F.) } PIXEL
    @ 016, 594 BUTTON oButtonPesq PROMPT "Sair" SIZE 050, 012 OF oDlg ACTION {|| oDlg:end() } PIXEL

//----------------------------------------------------------------------------------------------------------------
    @ 034, 003 GROUP oGroupItFill TO 146, 647 PROMPT " Itens Filtrados " OF oDlg COLOR 0, 16777215 PIXEL
    fMSNewGetP()    
    @ 043, 594 BUTTON oButtonAddPreKit PROMPT "Add Pré Kit" SIZE 050, 012 OF oDlg ACTION {|| processa( {|| fCloneItem(oMSNewGetProd) }, "Aguarde...", "Atualizando Dados...", .F.) } PIXEL
//----------------------------------------------------------------------------------------------------------------

    @ 148, 003 GROUP oGroupKit TO 267, 647 PROMPT " Kit's " OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 155, 007 SAY oSayModelo PROMPT "Forn/Modelo" FONT oFont11 SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 164, 007 MSGET oGetModelo VAR cGetModelo FONT oFont11 SIZE 045, 010 VALID {|| fGerCodKit() } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL

    @ 155, 056 SAY oSayMedida PROMPT "Medida" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 164, 055 MSGET oGetMedida VAR nGetMedida FONT oFont11 SIZE 037, 010 VALID {|| fGerCodKit() } Picture "@R 9.99" OF oDlg COLORS 0, 16777215 PIXEL

    @ 155, 095 SAY oSayCor PROMPT "Cor" FONT oFont11 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 164, 095 MSGET oGetCor VAR cGetCor FONT oFont11 SIZE 040, 010 VALID {|| fGerCodKit() } Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL    

    @ 155, 140 Say  oSay Prompt 'Canto ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 164,140, {|u|if(PCount()>0,nCantoKit := val(u),nCantoKit)} ,aCantoKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 155, 185 Say  oSay Prompt 'CH/E ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 164,185, {|u|if(PCount()>0,nCheKit := val(u),nCheKit)} ,aCheKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)
        
    @ 155, 230 Say  oSay Prompt 'CH/D ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 164,230, {|u|if(PCount()>0,nChdKit := val(u),nChdKit)} ,aChdKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 155, 275 Say  oSay Prompt 'PUFF ?'		FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oDlg Pixel
   	TComboBox():New( 164,275, {|u|if(PCount()>0,nPuffKit := val(u),nPuffKit)} ,aPuffKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 155, 320 Say  oSay Prompt 'Sem Braço ?'		FONT oFont11 COLOR CLR_BLUE Size  040, 07 Of oDlg Pixel
   	TComboBox():New( 164,320, {|u|if(PCount()>0,nSemBracok := val(u),nSemBracoK)} ,aSemBracoK, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 155, 365 Say  oSay Prompt 'Base ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 164,365, {|u|if(PCount()>0,nBaseKit := val(u),nBaseKit)} ,aBaseKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)
    
    @ 155, 410 Say  oSay Prompt 'USB ?'		FONT oFont11 COLOR CLR_BLUE Size  025, 07 Of oDlg Pixel
   	TComboBox():New( 164,410, {|u|if(PCount()>0,nUsbKit := val(u),nUsbKit)} ,aUsbKit, 040, 013, oDlg, ,{|| fGerCodKit() },,,,.T.,,,.F.,{||.T.},.T.,,)

    @ 166, 458 SAY oSayCodKit PROMPT cCodKit SIZE 186, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 181, 418 SAY oDescKit PROMPT "Descrição Kit" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 190, 418 MSGET oDescriProd VAR cDescriProd SIZE 225, 010 Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL

    @ 205, 418 SAY oDescriSite PROMPT "Descrição Site" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 214, 418 MSGET oDescriProd VAR cDescriSite SIZE 225, 010 Picture "@!" OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 236, 594 BUTTON oButtonKit PROMPT "Gerar Kit" SIZE 050, 012 OF oDlg ACTION {|| fGeraKit() } PIXEL
    
    @ 250, 594 BUTTON oButtonRemover PROMPT "Remover Pré Kit" SIZE 050, 012 OF oDlg ACTION {|| processa( {|| fDelItem(oMSNewGetKit:nAt, oMSNewGetKit) }, "Aguarde...", "Deletando...", .F.) } PIXEL

    fMSNewGek()

  //ACTIVATE MSDIALOG oDlg CENTERED
  oDlg:Activate(,,,.T.,/*valid*/,,{|| processa( {|| fCarrProd() }, "Aguarde...", "Atualizando Dados...", .f.)} )

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGetP
Description //Monta Form Superior com os Kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGetP()

  Local aHeaderProd := {}
  Local aFields := {"B1_COD","B1_DESC","B1_01PRODP"}
  Local aAlterFields := {}

  Static oMSNewGetProd

  DbSelectArea("SX3")
  
  SX3->(DbSetOrder(2))
  
  Aadd(aHeaderProd,{"","FLAG","@BMP",2,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})

  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderProd, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  oMSNewGetProd := MsNewGetDados():New( 044, 006, 138, 592, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderProd, aColsProd)
  oMSNewGetProd:oBrowse:bLDblClick := {|| fMarcOne(oMSNewGetProd:nAt, oMSNewGetProd)  } 

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMSNewGek
Description //Monta Form Inferior com os Item Kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMSNewGek()

  Local nX
  Local aHeaderKit := {}
  Local aFieldFill := {}
  Local aFields := {"B1_COD","B1_DESC","B1_01PRODP"}
  Local aAlterFields := {}

  Static oMSNewGetKit

  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      
      Aadd(aHeaderKit, {AllTrim(X3Titulo()),;
                        SX3->X3_CAMPO,;
                        SX3->X3_PICTURE,;
                        iif(aFields[nX] == "B1_DESC",60,SX3->X3_TAMANHO),;
                        SX3->X3_DECIMAL,;
                        SX3->X3_VALID,;
                        SX3->X3_USADO,;
                        SX3->X3_TIPO,;
                        SX3->X3_F3,;
                        SX3->X3_CONTEXT,;
                        SX3->X3_CBOX,;
                        SX3->X3_RELACAO})
    Endif
  Next nX

  oMSNewGetKit := MsNewGetDados():New( 179, 006, 262, 415, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderKit, aColsKit)

Return   

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrProd
Description //Popula os itens do Form Superior
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fCarrProd()

  Local cquery := ""
  Local cAlias := getNextAlias()

  aColsProd := {}

  cquery := "SELECT B1_COD, B1_DESC, B1_01PRODP"
  cquery += " FROM "+ retSqlName("SB1")+" (NOLOCK)"
  cquery += " WHERE  D_E_L_E_T_ = ' '
  cquery += " AND B1_MSBLQL <> '1'"
  cquery += " AND B1_TIPO IN ('ME','PA')"     //WW9-Y6L-HHHL (Número do ticket: 14191) - Marcio Nunes

  if !empty(alltrim(cGetFilModelo))
    cquery += " AND B1_DESC LIKE '%"+ alltrim(cGetFilModelo) +"%'"//--MODELO
  endif

  if !empty(alltrim(cGetFilMedida))
    cquery += " AND B1_DESC LIKE '%"+ alltrim(cGetFilMedida) +"%'"  //--TAMANHO
  endif

  if !empty(alltrim(cGetFilCor))
    cquery += " AND B1_DESC LIKE '%"+ alltrim(cGetFilCor) +"%'"  //--COR
  endif
  
  if nCanto == 2
    cquery += " AND B1_DESC LIKE '%CT%'"    //--CANTO
  endif

  if nChe == 2
    cquery += " AND B1_DESC LIKE '%CH/E%'"  //--CHE
  endif

  if nChd == 2
    cquery += " AND B1_DESC LIKE '%CH/D%'"  //--CHD
  endif

  if nSemBraco == 2
    cquery += " AND B1_DESC LIKE '% SB%'"   //--SEM BRAÇO
  endif

  if nBase == 2
    cquery += " AND B1_DESC LIKE '%BASE%'"  //--BASE
  endif

  if nUsb == 2
    cquery += " AND B1_DESC LIKE '%C/USB%'" //--USB
  endif
  
  cquery += " ORDER BY B1_COD"
  
  PLSQuery(cQuery, cAlias)

  while (cAlias)->(!eof())
    Aadd(aColsProd,{"LBNO",;
                    (cAlias)->B1_COD,;
                    (cAlias)->B1_DESC,;
                    (cAlias)->B1_01PRODP,;
                    .F. })

  (cAlias)->(DbSkip())
  end

  if len(aColsProd) <= 0
    Aadd(aColsProd,{"LBNO","","","",.F.})
  endif 
    
	oMSNewGetProd:SetArray(aColsProd)    
	oMSNewGetProd:Refresh()



Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcOne
Description //Marca o checkbox da linha posicionada 
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fMarcOne(nLin, oObj) 

	Local nPFlag := Ascan(oObj:aHeader,{|x|AllTrim(x[2])=="FLAG"})
	
  if oObj:aCols[nLin,nPFlag] == "LBTIK"
	  oObj:aCols[nLin,nPFlag] := "LBNO"
  else
    oObj:aCols[nLin,nPFlag] := "LBTIK"
	endif

	oObj:Refresh()
	
Return 

//--------------------------------------------------------------
/*/{Protheus.doc} fCloneItem
Description //Adiciona os itens selecionados do Form Superior no Form inferior
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fCloneItem(oObj)
  
  Local nPFlag := Ascan(oObj:aHeader,{|x|AllTrim(x[2])=="FLAG"})
  
  if len(oMSNewGetKit:aCols) > 0
    if empty(oMSNewGetKit:aCols[1][1])
      oMSNewGetKit:aCols := {}
    endif
  endif

  For nx:= 1 to Len(oObj:aCols)
    if oObj:aCols[nx][nPFlag] == "LBTIK"
      
      nPosP := Ascan(oMSNewGetKit:aCols,{|x|AllTrim(x[1]) == oObj:aCols[nx][2]})
      if nPosP == 0
        Aadd(oMSNewGetKit:aCols,{;
                                oObj:aCols[nx][2],;
                                oObj:aCols[nx][3],;
                                oObj:aCols[nx][4],;
                                .F. })
        
        fMarcOne(nx, oObj)
      else
        MsgAlert("Produto "+ oObj:aCols[nx][2] +" Já existe no Pré Kit..","Atenção")
      endif

    endif
  Next

  oMSNewGetKit:Refresh()
  oGetModelo:setFocus()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fDelItem
Description //Deleta linha no form Inferior
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fDelItem(nLinha, oObj)

  if len(oObj:aCols) > 0
    adel(oObj:aCols, nLinha)

    aSize(oObj:aCols,len(oObj:aCols)-1)

    oObj:Refresh()
    oGetModelo:setFocus()
  endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGerCodKit
Description //Gera o codigo do kit, de acordo com os parametros informados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fGerCodKit()

  cCodKit := ""

  if !empty(alltrim(cGetModelo))
    if nGetMedida == 0
      nGetMedida := 0
      oGetMedida:Refresh()
    endif
  endif

  cCodKit := alltrim(cGetModelo)
  
  cCodKit += strtran(transform(nGetMedida,"@R 9.99"),".","")
                
  cCodKit += fCleanCor(cGetCor)

  if nCantoKit == 1 
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nCheKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nChdKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nPuffKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nSemBracoK == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nBaseKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nUsbKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif
  
  oSayCodKit:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGeraKit
Description //Função responsavel pela validação dos campos o geração dos kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fGeraKit()

  DbSelectArea("ZKC")
  DbSetOrder(1)

  if empty(alltrim(cGetModelo))
    Alert( "Campo (Forn/Modelo) Obrigatorio.","Atenção")
    Return
  endif

  if nGetMedida == 0
    Alert("Campo (Medida) Obrigatorio.","Atenção")
    Return
  endif

  
  if empty(alltrim(cGetCor))
    Alert("Campo (Cor) Obrigatorio.","Atenção")
    Return
  endif
  

  if empty(alltrim(cDescriProd))
    Alert("Campo (Descrição do Kit) Obrigatorio.","Atenção")
    Return
  endif
  
  /* 
  //Removida validação da obrigatoriedade do campo (Descrição Site).
  if empty(alltrim(cDescriSite))
    Alert("Campo (Descrição Site) Obrigatorio.","Atenção")
    Return
  endif
  */
  
  //fReplicate()
  fConfirm()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fConfirm
Description //Função responsavel por gravar as tabelas de Kit e itens do Kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fConfirm()

  Local cCodKit := ""
      
  cCodKit := alltrim(cGetModelo)

  cCodKit += strtran(transform(nGetMedida,"@R 9.99"),".","")
  
  cCodKit += fCleanCor(cGetCor)

  if nCantoKit == 1 
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nCheKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nChdKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nPuffKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nSemBracoK == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nBaseKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif

  if nUsbKit == 1
    cCodKit += "1"
  else
    cCodKit += "0"
  endif
        
  if !ZKC->(DbSeek(xFilial() + cCodKit))

    if len(oMSNewGetKit:aCols) > 0
        ZKC->(recLock("ZKC",.T.))

          ZKC->ZKC_CODPAI := cCodKit
          //ZKC->ZKC_CODFIL := oMSNewGetKit:aCols[ny][1]
          ZKC->ZKC_DESCRI := alltrim(cDescriProd) + " TC " + alltrim(cGetCor)//aColsCores[nx][3]
          ZKC->ZKC_DESCST := alltrim(cDescriSite)
          ZKC->ZKC_MSBLQL := '2'
          ZKC->ZKC_ECOM := '2'
          ZKC->ZKC_SKU := fGetSKU()
        ZKC->(msUnlock())

        if existBlock("KHINCKIT")  
            ExecBlock("KHINCKIT",.F.,.F.,{ ZKC->(Recno()) })
        endif
    endif

    for ny := 1 to len(oMSNewGetKit:aCols)
      ZKD->(recLock("ZKD",.T.))
        ZKD->ZKD_CODPAI := cCodKit
        ZKD->ZKD_CODFIL := oMSNewGetKit:aCols[ny][1]
      ZKD->(msUnlock())
    Next ny
    
    //msginfo("Kit "+ cCodKit +" Gerado com Sucesso!!","Atenção")
  else
    msgalert("O Kit "+ cCodKit +" ja foi incluido!!","Atenção")
    Return
  endif

  cGetModelo := space(6)
  nGetMedida := 0
  cGetCor := space(6)
  nCantoKit := nCheKit := nChdKit := nPuffKit := nSemBracoK := nBaseKit := nUsbKit := val(aCantoKit[2])

  oMSNewGetKit:aCols := {}
  
  cCodKit := space(40)
  cDescriProd := space(100)
  cDescriSite := space(100)

  oDescriProd:Refresh()
  oDescriSite:Refresh()
  oSayCodKit:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCleanCor
Description //Função para limpar a string da Cor
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fCleanCor(cCor)

  cCor := StrTran( cCor, "TC", "" )
  cCor := StrTran( cCor, "-", "" )
  cCor := StrTran( cCor, "FL", "" )
  cCor := StrTran( cCor, "/", "" )
  cCor := StrTran( cCor, " ", "" )
  cCor := ALLTRIM(cCor)

Return cCor

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marcar/Desmarcar todos itens da tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fMarcAll(nColuna)

	Local nPFlag := Ascan(oMSNewGe1:aHeader,{|x|AllTrim(x[2])=="FLAG"})
  Local nx := 0
	
	if nOrder++ == 0
		if nColuna == nPFlag
			for nx := 1 To Len(oMSNewGe1:aCols)
				if oMSNewGe1:aCols[nx,nPFlag] == "LBNO"
					oMSNewGe1:aCols[nx,nPFlag] := "LBTIK"
				else
					oMSNewGe1:aCols[nx,nPFlag] := "LBNO"
				endif
			next nx
		endif
	else
		nOrder := 0
	endif

	oMSNewGe1:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGetSKU
Description //Função responsavel por gerar o proximo numero do kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fGetSKU()

	Local cSku := ""
	Local cAlias := getNextAlias()
	Local cQuery := "SELECT ISNULL(MAX(ZKC_SKU),0) AS SKU FROM "+RetSqlName("ZKC")+" WHERE D_E_L_E_T_ = ''"

	PLSQuery(cQuery, cAlias)

	if (cAlias)->SKU == 0
    cSku := strZero((cAlias)->SKU,12,0)
    cSku := Soma1(cSku)
  else
    cSku := strZero((cAlias)->SKU,12,0)
    cSku := Soma1(cSku)
	endif

	(cAlias)->(dbCloseArea())

Return cSku

//--------------------------------------------------------------
/*/{Protheus.doc} fGetTam
Description //Calcula o tamanho dos kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
/*
// Função não Utilizada ------>>>>
Static Function fGetTam()

  Local nTamanho := 0
  Local cQuery := ""
  Local cAlias := getNextAlias()

  DbSelectArea("SB1")
  DbSetOrder(1)

  for nx := 1 to len(oMSNewGetKit:aCols)

    if SB1->(DbSeek(xFilial()+oMSNewGetKit:aCols[nx][1]))

      cQuery := "SELECT BV_01CGRD FROM SBV010"
      cQuery += " WHERE BV_CHAVE = '"+ SB1->B1_01CLGRD +"'"
      cQuery += " AND BV_DESCTAB LIKE '"+ Right(cGetModelo,3) +"%'"
      cQuery += " AND D_E_L_E_T_ = ''"

      PLSQuery(cQuery, cAlias)

      if (cAlias)->(!eof())
        nTamanho += (cAlias)->BV_01CGRD
      endif
      
      (cAlias)->(dbCloseArea())

    endif
  
  next nx

Return nTamanho
*/

//--------------------------------------------------------------
/*/{Protheus.doc} fReplicate
Description //Função para replicar os Kits, obs: Função não terminada devido falta de campos para compor os kits
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
/* Função Não utilizada -------->>>
Static Function fReplicate()

  Local oButtonCancel
  Local oButtonConfirm
  Local oSayCores
  Local cDescFor := "Cores Disponiveis para o Fornecedor: "
  Local oGetFiltro
  
  cGetFiltro := Space(15)

  Static oDlgCor

  DEFINE MSDIALOG oDlgCor TITLE "Cores Kits" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    fMSNewGe1()
    @ 004, 005 SAY oSayCores PROMPT cDescFor+GetFornece(Left(cGetModelo,3)) SIZE 150, 011 OF oDlgCor COLORS 0, 16777215 PIXEL
    @ 004, 177 MSGET oGetFiltro VAR cGetFiltro SIZE 068, 010 OF oDlgCor VALID {|| pesqCor()} COLORS 0, 16777215 PIXEL
    @ 236, 165 BUTTON oButtonCancel PROMPT "Cancelar" SIZE 037, 012 OF oDlgCor ACTION {|| oDlgCor:end() } PIXEL
    @ 236, 208 BUTTON oButtonConfirm PROMPT "Confirmar" SIZE 037, 012 OF oDlgCor ACTION {|| processa( {|| fConfirm() }, "Aguarde...", "Gerando kits...", .F.) } PIXEL

  ACTIVATE MSDIALOG oDlgCor CENTERED

Return
*/

/*
Static Function fMSNewGe1()

  Local nX
  Local aHeaderCores := {}
  Local aFieldFill := {}
  Local aFields := {"BV_DESCTAB","BV_DESCRI"}
  Local aAlterFields := {}
  Static oMSNewGe1

  aColsCores := {}

  // Define field properties
  DbSelectArea("SX3")
  
  SX3->(DbSetOrder(2))

  Aadd(aHeaderCores,{"","FLAG","@BMP",2,0,"","€€€€€€€€€€€€€€","C","","R","","","","V","","",""})

  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderCores, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  GetCores(@aColsCores)
  
  oMSNewGe1 := MsNewGetDados():New( 019, 003, 232, 246, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgCor, aHeaderCores, aColsCores)
  oMSNewGe1:oBrowse:bLDblClick := {|| fMarcOne(oMSNewGe1:nAt, oMSNewGe1)  } 
  oMSNewGe1:oBrowse:bHeaderClick := {|o, iCol| fMarcAll(iCol)}

Return
*/

/*
Static Function GetCores(aColsCores)

  Local cQuery := ""
  Local cAlias := getNextAlias()
  Local cFornecedor := Left(cGetModelo,3)

  cFornecedor := GetFornece(cFornecedor)

  cQuery := "SELECT BV_DESCTAB, BV_DESCRI"
  cQuery += " FROM "+ RetSqlName("SBV")
  cQuery += " WHERE BV_DESCTAB LIKE '"+ cFornecedor +"'"
  cQuery += " AND D_E_L_E_T_ = ''"

  PLSQuery(cQuery, cAlias)

  while (cAlias)->(!eof())

    aAdd(aColsCores,{;
                    "LBNO",;
                    (cAlias)->BV_DESCTAB,;
                    (cAlias)->BV_DESCRI,;
                    .F.;
                    })

  (cAlias)->(DbSkip())
  end

Return
*/

//--------------------------------------------------------------
/*/{Protheus.doc} GetFornece
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
/*
Static Function GetFornece(cFornece)

  Do Case
      Case cFornece == 'GRA'
        cFornece := "GRALHA"
      Case cFornece == 'LIN'
        cFornece := "LINOFORTE"
      Case cFornece == 'ENE'
        cFornece := "ENELE"
      Otherwise
        cFornece := "XXXXXXXXXX"
  EndCase

Return cFornece
*/

/*
Static Function pesqCor()

  Local nPosCor := 0

  nPosCor := Ascan(aColsCores,{|x|allTrim(x[3]) == alltrim(cGetFiltro)})

  if nPosCor > 0
    n := nPosCor
    oMSNewGe1:oBrowse:nAt := nPosCor
    oMSNewGe1:oBrowse:Refresh()
    oMSNewGe1:Refresh()
  else
    Alert("TC informado não encontrado..")
  endif
 
Return
*/
