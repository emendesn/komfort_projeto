#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
#include 'parmtype.ch'
#Include "ap5mail.ch"

#DEFINE xStatus 1
#DEFINE xMark 2                                                                
#DEFINE xTitulo 3
#DEFINE xCodCli 4
#DEFINE xLojaCli 5
#DEFINE xNomeCli 6
#DEFINE xValor 7
#DEFINE xEmissao 8
#DEFINE xFil 9
#DEFINE xRamais 10
#DEFINE xAnexo 11
#DEFINE xCTR 12
#DEFINE xCTR1 13
#DEFINE xCTR2 14
#DEFINE xCTR3 15
#DEFINE xConcilia 16
#DEFINE xDataConc 17
#DEFINE xUsuario 18
#DEFINE xObservacao 19
#DEFINE xrecno 20
#DEFINE xMsFil 21
#DEFINE xEmail 22

//--------------------------------------------------------------
/*/{Protheus.doc} KHFIN001
Description //Depositos bancarios
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 19/02/2019 /*/
//--------------------------------------------------------------
User Function KHFIN001()

    Local aSize := MsAdvSize()
    Local aButtons  := {}

    Private aTitulos := {}
    Private oTela, oTitulos
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")

    Private oFilial
    Private cFil := CriaVar("E1_MSFIL", .F.)

    Private oTitulo
    Private cTitulo := CriaVar("E1_NUM", .F.)

    Private oEmissaoDe
    private dEmissaoDeDe := ctod('//')
    
    Private oEmissaoAt
    private dEmissaoAt := ctod('//')

    Private cPasta := "\comprovantes_bancarios"
    Private cRaiz := GetSrvProfString("RootPath","")+cPasta

    Private nopcConcil := 2
    Private cUsersFin := superGetMv('KH_USRFIN', .F., '000006|000779' )

    Private lVisual := iif(__cUserID $ cUsersFin, .T., .F.)

    Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
    Private oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')
    Private oSt3 := LoadBitmap(GetResources(),'BR_AMARELO')

    AAdd(aButtons,{	'',{|| fExcel() }, "Relatorio"} )

    dbSelectArea("SE1")
    SE1->(dbSetOrder(1))

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "TITULOS PENDENTES" Of oMainWnd PIXEL

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif
    
    fCarrParam()
    
    //TITULOS PENDENTES
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;            // 1
                                                                '',;            // 2
                                                                'Titulo',;      // 3
                                                                'Cod. Cliente',;// 4
                                                                'Loja Cli.',;   // 5
                                                                'Nome Cliente',;// 6
                                                                'Valor',;       // 7
                                                                'Emissão',;     // 8
                                                                'Filial',;      // 9
                                                                'Ramais',;      // 10
                                                                'Anexo',;       // 11
                                                                'CTR 1',;       // 12
                                                                'CTR 2',;       // 13
                                                                'CTR 3',;       // 14
                                                                'CTR 4',;       // 15
                                                                'Conciliação',; // 16
                                                                'Data Conciliação',; // 17
                                                                'Usuario',;     // 18
                                                                'Observação';   // 19
                                                                },,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
    oBrowse:bHeaderClick := {|o, iCol| fDefAction(iCol) }

    fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt)
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F2, {|| processa( {|| fDesmAll() }, "Aguarde...", "Atualizando Dados...", .f.) })
    SetKey(VK_F5, {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .f.) })

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || oTela:End() } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()

    @  34, 05 Say  oSay Prompt 'Filial'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oTela Pixel
    @  44, 05 MSGet oFilial Var cFil FONT oFont11 COLOR CLR_BLUE Pixel SIZE 14, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)}  F3 "SM0" When .T. Of oTela 

    @  34, 50 Say  oSay Prompt 'Titulo'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oTela Pixel
    @  44, 50 MSGet oTitulo Var cTitulo FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oTela 
    
    @  34, 105 Say  oSay Prompt 'Emissão de' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 105 MSGet oEmissaoDe Var dEmissaoDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| } When .T. Of oTela 
    
    @  34, 160 Say  oSay Prompt 'Emissão ate' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 160 MSGet oEmissaoAt Var dEmissaoAt FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oTela 

    if lVisual
        @  34,  220 Say  oSay Prompt 'Conciliado:'		FONT oFont11 COLOR CLR_BLUE Size  60, 08 Of oTela Pixel
        @  42,  220 RADIO oRadPedFat VAR nopcConcil ITEMS "Sim","Não" SIZE 45, 25 OF oTela COLOR 0, 16777215  ON CHANGE {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)} PIXEL
    endif

    tButton():New(44,270,"&Anexo",oTela,{|| fAnexo() },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,320,"C&TR",oTela,{|| fCtr() },40,10,,,,.T.,,,,/*{|| }*/)
    
    if lVisual
        tButton():New(44,370,"&Email",oTela,{|| SendPend() },40,10,,,,.T.,,,,/*{|| }*/)
        tButton():New(44,420,"&Conciliar",oTela,{|| fConc() },40,10,,,,.T.,,,,/*{|| }*/)
        tButton():New(44,470,"&Visualizar",oTela,{|| fShow() },40,10,,,,.T.,,,,/*{|| }*/)
        tButton():New(44,520,"&Observação",oTela,{|| ViewObserv() },40,10,,,,.T.,,,,/*{|| }*/)
    else
        tButton():New(44,370,"&Visualizar",oTela,{|| fShow() },40,10,,,,.T.,,,,/*{|| }*/)
    endif

Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit(cFilSel, cTit, dDtEmiDe, dEmiAte)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local cAnexo := "NÃO"
    Local cConcil := "NÃO"

    default cFilSel := ""
    default cTit := ""
    default dDtEmiDe := ctod('//')
    default dEmiAte := ctod('//')

    cQuery := "SELECT E1_MSFIL,E1_NUM,E1_CLIENTE, E1_LOJA,E1_NOMCLI,E1_VALOR,E1_EMISSAO, E1_XDESCFI, (ZK9_RAMAL1+'/'+ZK9_RAMAL2+'/'+ZK9_RAMAL3) AS RAMAIS, E1_XANEXO, E1_XCTR, E1_XCTR1, E1_XCTR2, E1_XCTR3, E1_XCONCIL , E1_XDTCONC, E1_XUSRCON, E1_XOBSDEP, E1_XEMAIL, SE1.R_E_C_N_O_"
    cQuery += " FROM "+ retSqlName("SE1")+ " SE1"
    cQuery += " INNER JOIN "+retSqlName("ZK9")+" ZK9 ON SE1.E1_MSFIL = ZK9.ZK9_COD"
    cQuery += " WHERE E1_TIPO = 'R$'"
    cQuery += " AND E1_EMISSAO >= '20190301'" // alterar par a data de corte
    
    if !Empty(alltrim(cFilSel))
        cQuery += " AND E1_MSFIL = '"+ cFilSel +"'"
    endif

    if !Empty(alltrim(cTit))
        cQuery += " AND E1_NUM = '"+ cTit +"'"
    endif
    
    if !empty(dtos(dDtEmiDe))
        cQuery += " AND E1_EMISSAO >= '"+ dtos(dDtEmiDe) +"'" 
    endif

    if !empty(dtos(dEmiAte))
        cQuery += " AND E1_EMISSAO <= '"+ dtos(dEmiAte)+ "'"
    endif

    if nopcConcil == 1
        cQuery += " AND E1_XCONCIL = '1'"
    else
        cQuery += " AND E1_XCONCIL <> '1'"
    endif
    
    if !lVisual
        cQuery += " AND E1_MSFIL = '"+ cFilAnt +"'"
    endif

    cQuery += " AND ZK9.D_E_L_E_T_ = ' '"
    cQuery += " AND SE1.D_E_L_E_T_ = ' '"

    PLSQuery(cQuery, cAlias)

    aTitulos := {}

    while (cAlias)->(!eof())

        iif(empty(alltrim((cAlias)->E1_XANEXO)), cAnexo := "NÃO", cAnexo := "SIM")
        iif((cAlias)->E1_XCONCIL == "1", cConcil := "SIM", cConcil := "NÃO")

        aAdd(aTitulos,{;
                        iif((cAlias)->E1_XCONCIL == "1", oSt1, iif((cAlias)->E1_XEMAIL > 0, oSt3, oSt2)),;
                        oNo,;
                        (cAlias)->E1_NUM,;
                        (cAlias)->E1_CLIENTE,;
                        (cAlias)->E1_LOJA,;
                        (cAlias)->E1_NOMCLI,;
                        (cAlias)->E1_VALOR,;
                        (cAlias)->E1_EMISSAO,;
                        (cAlias)->E1_XDESCFI,;
                        (cAlias)->RAMAIS,;
                        cAnexo,;
                        (cAlias)->E1_XCTR,;
                        (cAlias)->E1_XCTR1,;
                        (cAlias)->E1_XCTR2,;
                        (cAlias)->E1_XCTR3,;
                        cConcil,;
                        (cAlias)->E1_XDTCONC,;
                        (cAlias)->E1_XUSRCON,;
                        (cAlias)->E1_XOBSDEP,;
                        (cAlias)->R_E_C_N_O_,;
                        (cAlias)->E1_MSFIL,;
                        (cAlias)->E1_XEMAIL})
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aTitulos) == 0
        oSt0 := LoadBitmap(GetResources(),'BR_BRANCO')
        AAdd(aTitulos,{oSt0,oNo,"","","","",0,CTOD("//"),"","","","","","NãO","","",CTOD("//"),"","",0,"",""})
    endif

    oBrowse:SetArray(aTitulos)

    oBrowse:bLine := {|| {   aTitulos[oBrowse:nAt,xStatus] ,; 
                                aTitulos[oBrowse:nAt,xMark] ,;
                                aTitulos[oBrowse:nAt,xTitulo] ,;
                                aTitulos[oBrowse:nAt,xCodCli] ,;
                                aTitulos[oBrowse:nAt,xLojaCli] ,;
                                aTitulos[oBrowse:nAt,xNomeCli] ,;
                                transform(aTitulos[oBrowse:nAt,xValor],"@E 999,999.99") ,;
                                aTitulos[oBrowse:nAt,xEmissao] ,;
                                aTitulos[oBrowse:nAt,xFil] ,;
                                aTitulos[oBrowse:nAt,xRamais] ,;
                                aTitulos[oBrowse:nAt,xAnexo] ,;
                                aTitulos[oBrowse:nAt,xCTR] ,;
                                aTitulos[oBrowse:nAt,xCTR1] ,;
                                aTitulos[oBrowse:nAt,xCTR2] ,;
                                aTitulos[oBrowse:nAt,xCTR3] ,;
                                aTitulos[oBrowse:nAt,xConcilia] ,;
                                aTitulos[oBrowse:nAt,xDataConc] ,;
                                aTitulos[oBrowse:nAt,xUsuario] ,;
                                aTitulos[oBrowse:nAt,xObservacao] ,;
                                aTitulos[oBrowse:nAt,xrecno],;
                                aTitulos[oBrowse:nAt,xMsFil],;
                                aTitulos[oBrowse:nAt,xEmail];
                            }}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fMarc(nLinha)

    if oBrowse:AARRAY[nLinha][xMark]:CNAME == "LBNO"
        if !empty(aTitulos[nLinha][xTitulo])
            aTitulos[nLinha][xMark] := oOk
        endif
    else
        if !empty(aTitulos[nLinha][xTitulo])
            aTitulos[nLinha][xMark] := oNo
        endif
    endif

    oBrowse:refresh()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marca todos os registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fMarcAll()

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][xMark]:CNAME == "LBNO"
            if !empty(aTitulos[nx][xTitulo])
                aTitulos[nx][xMark] := oOk
            endif
        else
            if !empty(aTitulos[nx][xTitulo])
                aTitulos[nx][xMark] := oNo
            endif
        endif
    next nx

    oBrowse:refresh()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fDesmAll
Description //Desmarca todos os registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fDesmAll()

    for nx := 1 to len(oBrowse:AARRAY)
        if !empty(aTitulos[nx][xTitulo])
            aTitulos[nx][xMark] := oNo
        endif
    next nx

    oBrowse:refresh()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCtr
Description //Tela para informar o numero do CTR
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fCtr()

    Local oBtnCancelar
    Local oBtnGravar
    Local oCtr
    Local oGet
    Local cCtr := space(6)
    Local oGet1
    Local cCtr1 := space(6)
    Local oGet2
    Local cCtr2 := space(6)
    Local oGet3
    Local cCtr3 := space(6)
    Local oGroup
    Local oTexto
    Local aMark := {}
    Local lEnd := .F.
    Static oDlg

    if empty(alltrim(oBrowse:AARRAY[oBrowse:nat][xTitulo]))
        Return
    endif
    
    cCtr := oBrowse:AARRAY[oBrowse:nat][xCTR]
    cCtr1 := oBrowse:AARRAY[oBrowse:nat][xCTR1]
    cCtr2 := oBrowse:AARRAY[oBrowse:nat][xCTR2]
    cCtr3 := oBrowse:AARRAY[oBrowse:nat][xCTR3]

    _cTitulo := oBrowse:AARRAY[oBrowse:nat][xTitulo]

    DEFINE MSDIALOG oDlg TITLE "Komfort House" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

        @ 002, 002 GROUP oGroup TO 080, 123 OF oDlg COLOR 0, 16777215 PIXEL
        @ 006, 007 SAY oTexto PROMPT "Informe o codigo de identificação do Deposito" SIZE 113, 007 OF oDlg COLORS 32768, 16777215 PIXEL
        
        @ 019, 011 SAY oCtr PROMPT "CTR 1:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 018, 035 MSGET oGet VAR cCtr SIZE 060, 010 OF oDlg  PICTURE "@!" VALID { || vldTam(cCTr) } COLORS 0, 16777215 PIXEL

        @ 034, 011 SAY oCtr PROMPT "CTR 2:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 033, 035 MSGET oGet1 VAR cCtr1 SIZE 060, 010 OF oDlg  PICTURE "@!" VALID { || vldTam(cCtr1) } COLORS 0, 16777215 PIXEL
        
        @ 049, 011 SAY oCtr PROMPT "CTR 3:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 048, 035 MSGET oGet2 VAR cCtr2 SIZE 060, 010 OF oDlg PICTURE "@!" VALID { || vldTam(cCtr2) } COLORS 0, 16777215 PIXEL

        @ 065, 011 SAY oCtr PROMPT "CTR 4:" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 064, 035 MSGET oGet3 VAR cCtr3 SIZE 060, 010 OF oDlg PICTURE "@!" VALID { || vldTam(cCtr3) } COLORS 0, 16777215 PIXEL
        
        @ 085, 085 BUTTON oBtnGravar PROMPT "Gravar" SIZE 037, 012 OF oDlg ACTION {|| lEnd := fGravar(UPPER(cCtr),UPPER(cCtr1),UPPER(cCtr2),UPPER(cCtr3),_cTitulo), iif(lEnd,oDlg:end(),) } PIXEL
        @ 085, 043 BUTTON oBtnCancelar PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION {|| oDlg:end() } PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} vldTam
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 21/03/2019 /*/
//--------------------------------------------------------------
Static Function vldTam(cCtr)

    local lRet := .T.

    if !empty(alltrim(cCtr))
        if !alltrim(cCtr) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
            if len(alltrim(cCtr)) < 6
                msgAlert("O Numero do CTR deve conter 6 Caracteres.","Atenção")
                lRet := .F.
            endif
        endif
    endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} fGravar
Description //Grava o numero do CTR
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fGravar(cNumCtr,cNumCtr1,cNumCtr2,cNumCtr3,cTit)
    
    Local aGrava := {}
    Local nlinha := oBrowse:nat

    if nLinha > 0
        
        if !empty(alltrim(cNumCtr)) .and. !empty(alltrim(cNumCtr1))
            if cNumCtr == cNumCtr1 .and. !alltrim(cNumCtr) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr1) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 1) e (CTR 2).","Atenção")
                return .F.
            endif
        endif

        if !empty(alltrim(cNumCtr)) .and. !empty(alltrim(cNumCtr2))
            if cNumCtr == cNumCtr2 .and. !alltrim(cNumCtr) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr2) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 1) e (CTR 3).","Atenção")
                return .F.
            endif
        endif

        if !empty(alltrim(cNumCtr)) .and. !empty(alltrim(cNumCtr3))
            if cNumCtr == cNumCtr3 .and. !alltrim(cNumCtr) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr3) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 1) e (CTR 4).","Atenção")
                return .F.
            endif
        endif
        
        if !empty(alltrim(cNumCtr1)) .and. !empty(alltrim(cNumCtr2))
            if cNumCtr1 == cNumCtr2 .and. !alltrim(cNumCtr1) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr2) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 2) e (CTR 3).","Atenção")
                return .F.
            endif
        endif
        
        if !empty(alltrim(cNumCtr1)) .and. !empty(alltrim(cNumCtr3))
            if cNumCtr1 == cNumCtr3 .and. !alltrim(cNumCtr1) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr3) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 2) e (CTR 4).","Atenção")
                return .F.
            endif
        endif
        
        if !empty(alltrim(cNumCtr2)) .and. !empty(alltrim(cNumCtr3))
            if cNumCtr2 == cNumCtr3 .and. !alltrim(cNumCtr2) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto" .and. !alltrim(cNumCtr3) $ "caixa|CAIXA|Caixa|JUNTO|junto|Junto"
                msgAlert("Existe Ctr's duplicados, por favor verifique os ctr's (CTR 3) e (CTR 4).","Atenção")
                return .F.
            endif
        endif

        //Verificar se o CTR ja existe em outro registro antes de inserir o mesmo no registro possicionado.
        if !empty(alltrim(cNumCtr))
            if !fPesqCTR(cNumCtr,cTit)
                return .F.
            endif
        endif

        if !empty(alltrim(cNumCtr1))
            if !fPesqCTR(cNumCtr1,cTit)
                return .F.
            endif
        endif

        if !empty(alltrim(cNumCtr2))
            if !fPesqCTR(cNumCtr2,cTit)
                return .F.
            endif
        endif

        if !empty(alltrim(cNumCtr3))
            if !fPesqCTR(cNumCtr3,cTit)
                return .F.
            endif
        endif

        aTitulos[nlinha][xCTR] := cNumCtr
        aTitulos[nlinha][xCTR1] := cNumCtr1
        aTitulos[nlinha][xCTR2] := cNumCtr2
        aTitulos[nlinha][xCTR3] := cNumCtr3
        
        aAdd(aGrava,{;
                    aTitulos[nlinha][xrecno],;  //RECNO
                    aTitulos[nlinha][xCTR],;    //CTR
                    aTitulos[nlinha][xCTR1],;   //CTR1
                    aTitulos[nlinha][xCTR2],;   //CTR2
                    aTitulos[nlinha][xCTR3];    //CTR3
                    }) 

        for ny := 1 to len(aGrava)
            SE1->(dbgoto(aGrava[ny][1]))
            recLock("SE1",.F.)
                SE1->E1_XCTR := aGrava[ny][2]
                SE1->E1_XCTR1 := aGrava[ny][3]
                SE1->E1_XCTR2 := aGrava[ny][4]
                SE1->E1_XCTR3 := aGrava[ny][5]
            SE1->(msUnlock())
        next ny

        aTitulos[nLinha][xMark] := oNo

        oBrowse:refresh()
    endif

Return .T.

//--------------------------------------------------------------
/*/{Protheus.doc} fAnexo
Description //Realiza a gravação do arquivo (anexo) ao titulo
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fAnexo()

    Local cCaminho := space(150)
    Local oDlg
    Local nOpc := 0
    Local aMark := {}
    Local lCopy := .F.
    Local aGrava := {}
    Local nLinha := 0

    if empty(alltrim(oBrowse:AARRAY[oBrowse:nat][xTitulo]))
        Return
    endif

    DEFINE MSDIALOG oDlg TITLE "Comprovante de deposito Bancario" From 0,0 To 10,50 

    //--Caminho para importar o Arquivo CSV
    oSayArq := tSay():New(05,07,{|| "Informe o local onde se encontra o arquivo para importação:"},oDlg,,,,,,.T.,,,200,80)
    oGetArq := TGet():New(15,05,{|u| If(PCount()>0,cCaminho:=u,cCaminho)},oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'cCaminho')
    oBtnArq := tButton():New(15,165,"Abrir",oDlg,{|| cCaminho := AlocDlgArq(cCaminho)},30,12,,,,.T.) //&Abrir...

    oBtnImp := tButton():New(060,060,"Importar",oDlg,{|| nOpc:=1,oDlg:End()},40,12,,,,.T.) //Importar
    oBtnCan := tButton():New(060,110,"Cancelar",oDlg,{|| nOpc:=0,oDlg:End()},40,12,,,,.T.) //Cancelar

    ACTIVATE MSDIALOG oDlg CENTERED

    if nOpc == 1
        
        nLinha := oBrowse:nat
               
        if nLinha > 0
            /*
            cCaminho := cNewString := alltrim(cCaminho)
            cNewString := StrTran(cCaminho,' ','_')
            
            if frename( cCaminho , cNewString ) == 0
                cCaminho := cNewString
            else
                MsgStop('Falha na operação, não foi possivel renomear o arquivo : FError '+str(ferror(),4))
                Return
            endif
            */
            if CpyT2S(cCaminho, cPasta)
                
                cDe := alltrim(cPasta + substr(cCaminho,rat("\",cCaminho),len(cCaminho)))
                cPara := alltrim(cPasta +"\"+ cvaltochar(aTitulos[nLinha][xrecno]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))

                //Verifico se ja existe o arquivo na pasta, e removo
                if File( cPasta +"\"+ cValToChar(aTitulos[nLinha][xrecno]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
                    if fErase(cPasta +"\"+ cValToChar(aTitulos[nLinha][xrecno]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
                        MsgStop('Não foi possivel excluir o registro existente : FError '+str(ferror(),4))
                        Return
                    endif
                endif

                //Renomeio o arquivo com o nome do recno do registro
                nStatus1 := frename( cDe , cPara )
                
                if nStatus1 == -1
                    MsgStop('Falha na operação, não foi possivel renomear o arquivo : FError '+str(ferror(),4))
                    Return
                endif

                msgalert("Arquivo importado com sucesso!!")

                aTitulos[nLinha][xAnexo] := "SIM"
                aAdd(aGrava,{;
                            aTitulos[nLinha][xrecno],; //RECNO
                            alltrim(cRaiz + substr(cPara,rat("\",cPara),len(cPara)))}) //Caminho do arquivo
                                
                SE1->(dbgoto(aGrava[1][1])) //Posicione no registro

                recLock("SE1",.F.)
                    SE1->E1_XANEXO := aGrava[1][2] //gravação do caminho
                SE1->(msUnlock())

                oBrowse:refresh()
            endif
        else
            msgAlert("Não existe registro selecionado!!")
        endif
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fShow
Description //Visualiza o arquivo em anexo
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fShow()
    
    Local cTemp := GetTempPath()
    Local nLinha := oBrowse:nat

    if empty(alltrim(oBrowse:AARRAY[oBrowse:nat][xTitulo]))
        Return
    endif
    
    if nLinha > 0
        SE1->(dbgoto(aTitulos[nLinha][xrecno]))

        if empty(SE1->E1_XANEXO)
            msgAlert("Não existe anexo para esse registro!!","Atenção")
            return
        endif

        if file(alltrim(cPasta + substr(SE1->E1_XANEXO, rat("\",SE1->E1_XANEXO), len(SE1->E1_XANEXO))))
            if CpyS2TEx(alltrim(SE1->E1_XANEXO), alltrim(cTemp + substr(SE1->E1_XANEXO,rat("\",SE1->E1_XANEXO)+1,len(SE1->E1_XANEXO))))
                
                ShellExecute("open",  alltrim(cTemp + substr(SE1->E1_XANEXO,rat("\",SE1->E1_XANEXO)+1,len(SE1->E1_XANEXO))), "", "C:\", 1 )
                aTitulos[nLinha][xMark] := oNo
                oBrowse:refresh()

            else
                msgAlert("Não foi possivel abrir o arquivo!!","Atenção")
            endif
        else
            msgAlert("Arquivo não encontrado!!","Atenção")
        endif
    else
        msgAlert("Não existe registro selecionado!!","Atenção")
    endif

return

//--------------------------------------------------------------
/*/{Protheus.doc} AlocDlgArq
Description //Define os tipo de arquivo para importação
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function AlocDlgArq(cArquivo)

    Local cType := "Arquivos .PDF|*.pdf| Arquivos .jpeg|*.jpeg| Arquivos .jpg|*.jpg| Arquivos .bmp|*.bmp| Arquivos .png|*.png|"
    Local cArquivo := cGetFile(cType, "Arquivos Imagem")

    If !Empty(cArquivo)
        cArquivo += Space(150-Len(cArquivo))
    Else
        cArquivo := Space(150)
    EndIf

Return cArquivo

//--------------------------------------------------------------
/*/{Protheus.doc} fConc
Description //Realiza a conciliação do comprovante
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fConc()

    Local nLinha := oBrowse:nat

    if empty(alltrim(oBrowse:AARRAY[oBrowse:nat][xTitulo]))
        Return
    endif

    if nLinha > 0
        if aTitulos[nLinha][xAnexo] == "SIM" .and. !empty(alltrim(aTitulos[nLinha][xCTR]))
            SE1->(dbgoto(aTitulos[nLinha][xrecno])) //Posicione no registro

            recLock("SE1",.F.)
                SE1->E1_XCONCIL := "1"//=SIM 2="NÃO"
                SE1->E1_XDTCONC := ddatabase
                SE1->E1_XUSRCON := UsrRetName(__cUserID)
            SE1->(msUnlock())

            aTitulos[nLinha][xConcilia] := "SIM"
            aTitulos[nLinha][xDataConc] := ddatabase
            aTitulos[nLinha][xUsuario] := UsrRetName(__cUserID)

            oBrowse:refresh()
            
            apMsgAlert("Conciliação realizada com sucesso","SUCCESSFUL")

            fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt)
        else
            if aTitulos[nLinha][xAnexo] == "NÃO"
                MsgStop("Não é possivel realizar a conciliação sem Anexo!","Atenção")
            endif

            if empty(alltrim(aTitulos[nLinha][xCTR]))
                MsgStop("Não é possivel realizar a conciliação sem o Numero do CTR!","Atenção")
            endif
        endif
    else
        msgAlert("Não existe registro selecionado!!","Atenção")
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} ViewObserv
Description //Altera e visualiza o campo observação
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function ViewObserv()
	
	Local oBtnSair
	Local oGroup1
		
	Local oObs
	Local cMsgObs := ""
	Local lGrava := .F.
	Local oDlgView
    Local nLinha := oBrowse:nat

    if empty(alltrim(oBrowse:AARRAY[oBrowse:nat][xTitulo]))
        Return
    endif
    
    if nLinha > 0
        cMsgObs := alltrim(aTitulos[nLinha][xObservacao])

        DEFINE MSDIALOG oDlgView TITLE "Observações " FROM 000, 000  TO 500, 390 COLORS 0, 16777215 PIXEL
        
            @ 003, 002 GROUP oGroup1 TO 230, 192 PROMPT " Observações do Titulo: " + aTitulos[nLinha][xTitulo] OF oDlgView COLOR 0, 16777215 PIXEL
            @ 011, 006 GET oObs VAR cMsgObs MEMO SIZE 182, 216 PIXEL OF oDlgView	    
            
            @ 232, 003 BUTTON oBtnSair PROMPT "Salvar" SIZE 188, 014 OF oDlgView ACTION {|| lGrava := .T., oDlgView:end() } PIXEL
        
        ACTIVATE MSDIALOG oDlgView CENTERED

        if lGrava
            SE1->(dbgoto(aTitulos[nLinha][xrecno])) //Posicione no registro

            recLock("SE1",.F.)
                SE1->E1_XOBSDEP := cMsgObs
            SE1->(msUnlock())

            aTitulos[nLinha][xObservacao] := cMsgObs
            
            oBrowse:refresh()
        endif
    else
        msgAlert("Não existe registro selecionado!!!","Atenção")
    endif
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} sendPend
Description //Monta o corpo de email
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function SendPend()

    Local lEnvia := .F.
    Local cHtml := ""
    Local cParaLoja := ""

    dbSelectArea("ZK9")
    ZK9->(dbSetOrder(1))

    cHtml := "<html>" 
    cHtml += "  <head>" 
    cHtml += "    <style>" 
    cHtml += "    table, th, td {" 
    cHtml += "      border: 2px solid black;" 
    cHtml += "      border-collapse: collapse;" 
    cHtml += "    }" 
    cHtml += "    th, td {" 
    cHtml += "      padding: 6px;" 
    cHtml += "      text-align: left;" 
    cHtml += "    }" 
    cHtml += "    </style>" 
    cHtml += "  </head>" 
    cHtml += "  <body>" 

    cHtml += "    <p>Boa tarde loja!</p>" 
    cHtml += "    <p>Solicitamos realizar os depósitos abaixo com máxima urgência, Por favor.</p>" 

    cHtml += "    <table style='width:100%'>" 
    cHtml += "      <tr>" 
    cHtml += "         <th> No. Titulo </th>" 
    cHtml += "         <th>Tipo</th>" 
    cHtml += "         <th>Dt Emissão</th>" 
    cHtml += "         <th>Cod. Cliente</th>" 
    cHtml += "         <th>Loja Cli.</th>" 
    cHtml += "         <th>Nome</th>" 
    cHtml += "         <th>Vlr. Titulo</th>" 
    cHtml += "      </tr>" 
    
    begin transaction

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][xMark]:CNAME == "LBOK" .and. oBrowse:AARRAY[nx][xConcilia] = "NÃO"
            
            cHtml += "      <tr>" 
            cHtml += "        <td>"+ aTitulos[nx][xTitulo] +"</td>" 
            cHtml += "        <td>R$</td>" 
            cHtml += "        <td>"+ dtoc(aTitulos[nx][xEmissao]) +"</td>" 
            cHtml += "        <td>"+ aTitulos[nx][xCodCli] +"</td>" 
            cHtml += "        <td>"+ aTitulos[nx][xLojaCli] +"</td>" 
            cHtml += "        <td>"+ aTitulos[nx][xNomeCli] +"</td>" 
            cHtml += "        <td>"+ transform(aTitulos[nx][xValor],"@E 999,999.99") +"</td>" 
            cHtml += "      </tr>" 
            
            lEnvia := .T.

            SE1->(dbgoto(aTitulos[nx][xrecno])) //Posicione no registro

            recLock("SE1",.F.)
                SE1->E1_XEMAIL += 1
            SE1->(msUnlock())

            aTitulos[nx][xStatus] := oSt3

            if empty(alltrim(cParaLoja))
                if ZK9->(dbSeek(xFilial() + aTitulos[nx][xMsFil]))
                    cParaLoja := alltrim(ZK9->ZK9_EMAIL)
                endif
            endif
        endif
    next nx

    cHtml += "    </table>" 
    
    cHtml += "    <p>Departamento financeiro deseja ótimas vendas.</p>"         
    
    cHtml += "  </body>" 
    cHtml += "</html>" 

    cAssunto := "Comprovante de Deposito"
    cMensagem := cHtml
    
    if lEnvia 
        processa( {|| sendMail( cParaLoja, cAssunto, cMensagem ) }, "Aguarde...", "Enviando email para "+ cParaLoja +"...", .F.)
        fDesmAll()
        oBrowse:refresh()
    endif

    end Transaction

return

//--------------------------------------------------------------
/*/{Protheus.doc} fPesqCTR
Description //Função responsavel por virificar a existencia do numero do ctr
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fPesqCTR(cCtr, cTit)

    Local lRet := .F.
    Local cQuery := ""
    Local cAlias := getNextAlias()

    if alltrim(cCtr) == 'CAIXA' .or. alltrim(cCtr) == 'JUNTO'
        Return .T.
    endif

    cQuery := "SELECT E1_NUM FROM "+ retSqlName("SE1")
    cQuery += " WHERE (E1_NUM NOT IN ('"+ cTit +"') AND E1_XCTR = '"+ cCTr +"')"
    cQuery += " OR (E1_NUM NOT IN ('"+ cTit +"') AND E1_XCTR1 = '"+ cCTr +"')"
    cQuery += " OR (E1_NUM NOT IN ('"+ cTit +"') AND E1_XCTR2 = '"+ cCTr +"')"
    cQuery += " OR (E1_NUM NOT IN ('"+ cTit +"') AND E1_XCTR3 = '"+ cCTr +"')"
    cQuery += " AND D_E_L_E_T_ = ' '"
    
    PLSQuery(cQuery, cAlias)

    if (cAlias)->(!eof())
        Help(NIL, NIL, 'ATENÇÃO', NIL,"O CTR "+ cCtr +" ja foi informado em outro titulo ("+ alltrim((cAlias)->E1_NUM) +").", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Para prosseguir, informe um Ctr Diferente."})
    else
        lret := .T.        
    endif

    (cAlias)->(dbCloseArea())

Return lret

//--------------------------------------------------------------
/*/{Protheus.doc} fDefAction
Description //Função responsavel por difinir a ação dependendo da coluna
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fDefAction(nColuna)

    if nColuna == 2
        fMarcAll()
    else
        oBrowse:aarray := aSort(oBrowse:aarray, , , {|x,y| x[nColuna] < y[nColuna]})
        oBrowse:refresh()
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} sendMail
Description //Função responsavel pelo envio de email para as lojas
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static function sendMail(cPara, cAssunto, cMensagem)

	Local cAccount := AllTrim(SUPERGETMV("KH_MAILFIN", .F., "fin@komforthouse.com.br"))	 // ExpC1 : Conta para conexao com servidor SMTP
	Local cPassword := AllTrim(SUPERGETMV("KH_PASSFIN", .F., "komfort01")) // ExpC2 : Password da conta para conexao com o servidor SMTP
	Local cServer := AllTrim(GetMV("MV_RELSERV")) // ExpC3 : Servidor de SMTP
	Local cError := ""
	Local lAutentica := GetMV("MV_RELAUTH") // Necessita de autenticação de e-mail
	Local lResult    := .F.	// Retorno se enviou ou não a mensagem
	Local cCco := AllTrim(superGetMv("KH_MCCOFIN", .F., "financeiro@komforthouse.com.br"))  // Email CCo, que recebera uma copia do email

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult 

	If lResult .and. lAutentica
		lResult := Mailauth(cAccount,cPassword)
	Endif

	If lResult           

		SEND MAIL	FROM cAccount;
		TO      	cPara;
		CC          cCco; 
        SUBJECT 	cAssunto;
		BODY    	cMensagem;
		RESULT 		lResult

		If ! lResult //Erro no envio do email
			GET MAIL ERROR cError
		EndIf

		DISCONNECT SMTP SERVER
	else
        alert("Não foi possivel conectar na conta: "+ cAccount)
    endif

Return lResult

//--------------------------------------------------------------
/*/{Protheus.doc} fExcel
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fExcel()

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "KOMFORT_"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"E1_NUM","E1_CLIENTE","E1_LOJA","E1_NOMCLI","E1_VALOR","E1_EMISSAO","E1_XDESCFI","E1_XANEXO","E1_XCTR","E1_XCTR1","E1_XCTR2","E1_XCTR3","E1_XCONCIL","E1_XDTCONC","E1_XUSRCON","E1_XOBSDEP","E1_XEMAIL"}
    Local aCab := {}
    Local nx := 0
    Local cTitle := "Relação de titulos"
    Local aItens := {}
    Local cPerg := "KHFIN001"
    Local cAlias := getNextAlias()
    Local cQuery := ""

    xPutSx1(cPerg)
	
    If !Pergunte(cPerg,.T.)
		Return
	Endif	

    cQuery := "SELECT E1_NUM, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR, E1_EMISSAO, E1_XDESCFI,"
	cQuery += " E1_XANEXO, E1_XCTR, E1_XCTR1, E1_XCTR2, E1_XCTR3, E1_XCONCIL , E1_XDTCONC, E1_XUSRCON, E1_XOBSDEP, E1_XEMAIL"
    cQuery += " FROM "+ retSqlName("SE1")+" SE1 INNER JOIN "+retSqlName("ZK9")+" ZK9 ON SE1.E1_MSFIL = ZK9.ZK9_COD "
    cQuery += " WHERE E1_TIPO = 'R$' "
    cQuery += " AND E1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
    cQuery += " AND ZK9.D_E_L_E_T_ = ' ' "
    cQuery += " AND SE1.D_E_L_E_T_ = ' '"

    PLSQuery(cQuery, cAlias)

    while (cAlias)->(!eof())
        aAdd(aItens,{;
                        (cAlias)->E1_NUM,;
                        (cAlias)->E1_CLIENTE,;
                        (cAlias)->E1_LOJA,;
                        (cAlias)->E1_NOMCLI,;
                        (cAlias)->E1_VALOR,;
                        (cAlias)->E1_EMISSAO,;
                        (cAlias)->E1_XDESCFI,;
                        (cAlias)->E1_XANEXO,;
                        (cAlias)->E1_XCTR,;
                        (cAlias)->E1_XCTR1,;
                        (cAlias)->E1_XCTR2,;
                        (cAlias)->E1_XCTR3,;
                        (cAlias)->E1_XCONCIL,;
                        (cAlias)->E1_XDTCONC,;
                        (cAlias)->E1_XUSRCON,;
                        (cAlias)->E1_XOBSDEP,;
                        (cAlias)->E1_XEMAIL})
        (cAlias)->(dbskip())
    end

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nx

	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		else // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		endif
	next nx

    for nx := 1 to len(aItens) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aItens[nx][1],; 
                                            aItens[nx][2],; 
											aItens[nx][3],; 
                                            aItens[nx][4],;
                                            aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            iif(empty(alltrim(aItens[nx][8])),"NÃO","SIM"),;
											aItens[nx][9],; // ctr
                                            aItens[nx][10],;// ctr1
                                            aItens[nx][11],;// ctr2
                                            aItens[nx][12],;// ctr3
                                            iif(aItens[nx][13]=='1',"SIM","NÃO"),;
                                            aItens[nx][14],;
                                            aItens[nx][15],;
                                            aItens[nx][16],;
                                            aItens[nx][17];
											},{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} xPutSx1
Description //Criação dos perguntes
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 28/02/2019 /*/
//--------------------------------------------------------------
Static Function xPutSx1(cPerg)
	
	cPerg := PADR(cPerg,10)
	aRegs := {}
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If !Dbseek(cPerg)

		Aadd(aRegs,{cPerg,"01","Data de ?"	,"","D","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		Aadd(aRegs,{cPerg,"02","Data até ?"	,"","D","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	Endif

	For i:=1 to LEN(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= LEN(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return