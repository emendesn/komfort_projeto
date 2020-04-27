#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} KHFIN003
Description //Visualização cobrança
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHFIN003()

    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cApro := "1"
    Private cFina := "2"
    Private cRepr := "3"
    Private aTitulos := {}
    Private oTela, oTitulos 
    Private oPainel
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



    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "NEGOCIAÇÕES COBRANCA" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif


    //TITULOS PENDENTES
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                '',;
                                                                'Nome Cliente',;
                                                                'Cod Cliente',;
                                                                'CPF/CNPJ',;
                                                                'Qtd Parcelas',;
                                                                'Valor Das Parcelas',;
                                                                'Valor da Entrada',;
                                                                'Comprovante',;
                                                                'Primeiro Vemcimento',;
                                                                'Atrasados/Todos',;
                                                                'Débito',;
                                                                'Observação',;
                                                                'Titulo Novo',;
                                                                'Alera Vencimento',;
                                                                'Usuário'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
        
    fCarrTit(cFil, cTitulo,cRepr)
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit(cFil, cTitulo) }, "Aguarde...", "Atualizando Dados...", .f.) })
    SetKey(VK_F3, {|| zLegenda(),.f.})
    
    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()
	
	
	
    //@  34, 05 Say  oSay Prompt 'Filial'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    //@  44, 05 MSGet oFilial Var cFil FONT oFont11 COLOR CLR_BLUE Pixel SIZE 14, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)}  F3 "SM0" When .T. Of oPainel 

    @  34, 05 Say  oSay Prompt 'Cod Cliente'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel Pixel
    @  44, 05 MSGet oTitulo Var cTitulo FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
   // @  34, 105 Say  oSay Prompt 'Emissão de' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel Pixel
   // @  44, 105 MSGet oEmissaoDe Var dEmissaoDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| } When .T. Of oPainel 
    
   // @  34, 160 Say  oSay Prompt 'Emissão ate' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel Pixel
   // @  44, 160 MSGet oEmissaoAt Var dEmissaoAt FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit(cFil, cTitulo, dEmissaoDe, dEmissaoAt) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 

   // tButton():New(44,250,"&Anexo",oPainel,{|| fAnexo() },40,10,,,,.T.,,,,/*{|| }*/)
   // tButton():New(44,300,"C&TR",oPainel,{|| fCtr() },40,10,,,,.T.,,,,/*{|| }*/)
   // tButton():New(44,350,"&Email",oPainel,{|| alert('Email') },40,10,,,,.T.,,,,/*{|| }*/)
   // tButton():New(44,400,"&Conciliar",oPainel,{|| alert('Conciliar') },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,050,"&Comprovante",oPainel,{|| fShow() },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,105,"&Visualizar",oPainel,{|| fInfCliente() },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,150,"&Reprovados",oPainel,{|| fCarrTit(cFil, cTitulo ,cRepr) },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,205,"&Financeiro",oPainel,{|| fCarrTit(cFil, cTitulo,cFina) },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,250,"&Aprovação",oPainel,{|| fCarrTit(cFil, cTitulo,cApro) },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,305,"&Todos",oPainel,{|| fCarrTit(cFil, cTitulo) },40,10,,,,.T.,,,,/*{|| }*/)

Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit(cFilSel, cTit,cRet)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local cAnexo := "NÃO"
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') //"Acordo no financeiro"
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Acordo Rejeitado" --> Padrão
    Local oSt3 := LoadBitmap(GetResources(),'BR_AZUL') //"Acordo finalizado" --> Padrão
    Local oSt4 := LoadBitmap(GetResources(),'BR_AMARELO')  //"Acordo Aguardando aprovação" --> Customizado Komfort
    default cFilSel := ""
    default cTit := ""
    //default dDtEmiDe := ctod('//')
    //default dEmiAte := ctod('//')
    
    cQuery := "SELECT  ZK8_WFRET,ZK8_NOMCLI,ZK8_CODCLI,ZK8_CPFCNP,ZK8_QTDPAR, ZK8_VLRPAR,ZK8_VLRENT,ZK8_PRIVEN,ZK8_COBRAR, ZK8_VLRDEV,ZK8_XUSER,ZK8_OBSWRF,ZK8_NEWTIT,ZK8_ALTVEN,ZK8_ANEXO "
    cQuery += " FROM ZK8010"
    if !Empty(alltrim(cRet))
        cQuery += " WHERE  ZK8_WFRET = '"+ cRet +"'"
        cQuery += " AND  ZK8_NEWTIT = ''"
        cQuery += " AND D_E_L_E_T_ <> '*'"
    Else
    	cQuery += " WHERE  ZK8_WFRET <>''"
    	cQuery += " AND D_E_L_E_T_ <> '*'"
    EndIf
    if !Empty(alltrim(cTit))
        cQuery += " AND ZK8_CODCLI = '"+ cTit +"'"
        cQuery += " AND D_E_L_E_T_ <> '*'"
    endif     
    cQuery += " ORDER BY ZK8_WFRET "
    /*
    if !empty(dtos(dDtEmiDe))
        cQuery += " AND E1_EMISSAO >= '"+ dtos(dDtEmiDe) +"'" 
    endif

    if !empty(dtos(dEmiAte))
        cQuery += " AND E1_EMISSAO <= '"+ dtos(dEmiAte)+ "'"
    endif
    
    */
    PLSQuery(cQuery, cAlias)

    aTitulos := {}

    while (cAlias)->(!eof())

       

        iif(empty(alltrim((cAlias)->ZK8_ANEXO)),cAnexo := "NÃO",cAnexo := "SIM")



        aAdd(aTitulos,{;
                        (cAlias)->ZK8_WFRET,;
                        oNo,;
                        (cAlias)->ZK8_NOMCLI,;
                        (cAlias)->ZK8_CODCLI,;
                        (cAlias)->ZK8_CPFCNP,;
                        (cAlias)->ZK8_QTDPAR,;
                        (cAlias)->ZK8_VLRPAR,;
                        (cAlias)->ZK8_VLRENT,;
                        cAnexo,;
                        (cAlias)->ZK8_PRIVEN,;
                        (cAlias)->ZK8_COBRAR,;
                        (cAlias)->ZK8_VLRDEV,;
                        (cAlias)->ZK8_OBSWRF,;
                        (cAlias)->ZK8_NEWTIT,;
                        (cAlias)->ZK8_ALTVEN,;
                        (cAlias)->ZK8_XUSER })
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aTitulos) == 0
        AAdd(aTitulos, {"",oNo,"","","",0,"","","NãO",CTOD("//"),"","","","","",""})
    endif

    oBrowse:SetArray(aTitulos)
    
    

    oBrowse:bLine := {|| {      Iif(empty(aTitulos[oBrowse:nAt,14]),oSt1,oSt3),;
        						aTitulos[oBrowse:nAt,02] ,;  
                                aTitulos[oBrowse:nAt,03] ,;
                                aTitulos[oBrowse:nAt,04] ,;
                                aTitulos[oBrowse:nAt,05] ,;
                                aTitulos[oBrowse:nAt,06] ,;
                                aTitulos[oBrowse:nAt,07] ,;
                                aTitulos[oBrowse:nAt,08] ,;
                                aTitulos[oBrowse:nAt,09] ,;
                                aTitulos[oBrowse:nAt,10] ,;
                                Iif(aTitulos[oBrowse:nAt,11] == "1","Atrasados","Todos") ,;
                                aTitulos[oBrowse:nAt,12] ,;
                                aTitulos[oBrowse:nAt,13] ,;
                                aTitulos[oBrowse:nAt,14] ,;
                                Iif (aTitulos[oBrowse:nAt,15] == "0","NÃO","SIM") ,;
                                aTitulos[oBrowse:nAt,16];
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
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fMarc(nLinha)

    if oBrowse:AARRAY[nLinha][2]:CNAME == "LBNO"
        aTitulos[nLinha][2] := oOk
    else
        aTitulos[nLinha][2] := oNo
    endif

    oBrowse:refresh()
    
Return


Static Function fCtr()

    Local oBtnCancelar
    Local oBtnGravar
    Local oCtr
    Local oGet
    Local cCtr := space(6)
    Local oGroup
    Local oTexto
    Local aMark := {}
    Static oDlg

    for nA := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nA][2]:CNAME == "LBOK"
            aAdd(aMark, "")
        endif
    next nA

    if len(aMark) > 1
        msgAlert("Não é possivel incluir mais de um CTR por linha.","Atenção")
        Return
    endif

    DEFINE MSDIALOG oDlg TITLE "Komfort House" FROM 000, 000  TO 100, 250 COLORS 0, 16777215 PIXEL

        @ 000, 002 GROUP oGroup TO 033, 123 OF oDlg COLOR 0, 16777215 PIXEL
        @ 006, 007 SAY oTexto PROMPT "Informe o codigo de identificação do Deposito" SIZE 113, 007 OF oDlg COLORS 32768, 16777215 PIXEL
        @ 019, 011 SAY oCtr PROMPT "CTR :" SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 018, 035 MSGET oGet VAR cCtr SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 035, 085 BUTTON oBtnGravar PROMPT "Gravar" SIZE 037, 012 OF oDlg ACTION {|| fGravar(cCtr), oDlg:end() } PIXEL
        @ 035, 043 BUTTON oBtnCancelar PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION {|| oDlg:end() } PIXEL

    ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fGravar(cNumCtr)
    
    Local aGrava := {}

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            aTitulos[nx][9] := cNumCtr
            aAdd(aGrava,{;
                        aTitulos[nx][14],; //RECNO
                        aTitulos[nx][9]}) //CTR
        endif
    next nx
    
    for ny := 1 to len(aGrava)
        SE1->(dbgoto(aGrava[ny][1]))
        recLock("SE1",.F.)
            SE1->E1_XCTR := aGrava[ny][2]
        SE1->(msUnlock())
    next ny

    oBrowse:refresh()

Return


Static Function fAnexo()

    Local cCaminho := space(150)
    Local oDlg
    Local nOpc := 0
    Local aMark := {}
    Local lCopy := .F.
    Local aGrava := {}

    for nA := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nA][2]:CNAME == "LBOK"
            aAdd(aMark, "")
        endif
    next nA

    if len(aMark) > 1
        msgAlert("Não é possivel incluir mais de um CTR por linha.","Atenção")
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
        for nx := 1 to len(oBrowse:AARRAY)
            if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
                nLinha := nx
                exit
            endif
        next nx
        
        if nLinha > 0
            cCaminho := cNewString := alltrim(cCaminho)
            cNewString := StrTran(cCaminho,' ','_')
            
            if frename( cCaminho , cNewString ) == 0
                cCaminho := cNewString
            else
                MsgStop('Falha na operação 1 : FError '+str(ferror(),4))
                Return
            endif

            if CpyT2S(cCaminho, cPasta) // ALTERAR O NOME DO ARQUIVO PARA O NUMERO DO RECNO.
                
                cDe := alltrim(cPasta + substr(cCaminho,rat("\",cCaminho),len(cCaminho)))
                cPara := alltrim(cPasta +"\"+ cvaltochar(aTitulos[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))

                //Verifico se ja existe o arquivo na pasta, e removo
                if File( cPasta +"\"+ cValToChar(aTitulos[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
                    if fErase(cPasta +"\"+ cValToChar(aTitulos[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
                        MsgStop('Não foi possivel excluir o registro existente : FError '+str(ferror(),4))
                        Return
                    endif
                endif

                //Renomeio o arquivo com o nome do recno do registro
                nStatus1 := frename( cDe , cPara )
                
                if nStatus1 == -1
                    MsgStop('Falha na operação 2 : FError '+str(ferror(),4))
                    Return
                endif

                msgalert("Arquivo importado com sucesso!!")

                aTitulos[nLinha][8] := "SIM"
                aAdd(aGrava,{;
                            aTitulos[nLinha][14],; //RECNO
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

Static Function fShow()
    
    Local cTemp := GetTempPath()
    Local nLinha := 0

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    	DbSelectArea('ZK8')
    	SE1->(DbSetOrder(1))//Filial + cod cliente 
		ZK8->(DbSeek(xFilial()+ aTitulos[nx][04]))
        //ZK8->(dbgoto( aTitulos[nx][04]))
        //CpyS2TEx( <cOrigem>, <cDestino> )
        if CpyS2TEx(alltrim(ZK8->ZK8_ANEXO), alltrim(cTemp + substr(ZK8->ZK8_ANEXO,rat("\",ZK8->ZK8_ANEXO)+1,len(ZK8->ZK8_ANEXO))))
            
            ShellExecute("open",  alltrim(cTemp + substr(ZK8->ZK8_ANEXO,rat("\",ZK8->ZK8_ANEXO)+1,len(ZK8->ZK8_ANEXO))), "", "C:\", 1 )
        
        else
            msgAlert("Não foi possivel abrir o arquivo!!")
        endif
    else
        msgAlert("Não existe registro selecionado!!!")
    endif

return

Static Function AlocDlgArq(cArquivo)

    Local cType := "Arquivos .PDF|*.pdf| Arquivos .jpeg|*.jpeg| Arquivos .jpg|*.jpg| Arquivos .bmp|*.bmp| Arquivos .png|*.png|"
    Local cArquivo := cGetFile(cType, "Arquivos Imagem")

    If !Empty(cArquivo)
        cArquivo += Space(150-Len(cArquivo))
    Else
        cArquivo := Space(150)
    EndIf

Return cArquivo



Static Function fInfCliente()

	
	Local nLinha := 0
    local aArea := getArea()
    Private aCpos := {}
	Private cCadastro := "Cobranca - Visualização de Negociação"
   

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    
	    dbSelectArea("ZK8")
	    ZK8->(DbSetOrder(1)) //ZK8_FILIAL,ZK8_CODCLI, R_E_C_N_O_, D_E_L_E_T_
	    ZK8->(DbGoTop())// Posiciona no primeiro registro 
	    if ZK8->(DbSeek(xFilial()+ aTitulos[nx][04]))
	        AxVisual("ZK8",ZK8->(Recno()),4)
	    endif

	EndIf
    restArea(aArea)

Return


Static Function zLegenda()
    
    Local aLegenda := {}
     
     
    //Monta as legendas (Cor, Legenda)
  
      aAdd(aLegenda,     {"BR_AZUL","Acordo Finalizado" })         //"Atendimento Planejado" --> Padrão
      aAdd(aLegenda,     {"BR_VERMELHO" 	,"Acordo Rejeitado" }) //"Atendimento Pendente" --> Padrão
      aAdd(aLegenda,     {"BR_VERDE"		,"Acordo no Financeiro"}) //"Atendimento Encerrado" --> Padrão
      aAdd(aLegenda,     {"BR_AMARELO"   ,"Acordo Aguardando Aprovação"  })           //"Em Andamento" --> Customizado Komfort

    //Chama a função que monta a tela de legenda
    BrwLegenda("STATUS COBRANÇA", "Status Cobrança", aLegenda) 
    
Return  


	