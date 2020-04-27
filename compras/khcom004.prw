#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} KHCOM004
Description //Controle de produtos medida especial 
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
User Function KHCOM004()
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
    Private cCliente := CriaVar("A1_COD", .F.)
    Private oPedido
    Private cPedido := CriaVar("C5_NUM", .F.)
    Private oPedComp
    Private cPedCom := CriaVar("C6_NUM", .F.)

  

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "PRODUTOS MEDIDA ESPECIAL" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif
    
    
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'-',;
    														  '-',;
    														  'Pedido',;
    														  'Cod Cliente',;
    														  'Nome Cliente',;
    														  'Emissão',;
    														  'Filial',;
    														  'Produto Esp',;
    														  'Item PV',;
    														  'Desc Esp',;
    														  'Produto Ori',;
    														  'Desc Ori',;
    														  'Qtd Venda',;
    														  "Anexo"},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
        
    fCarrTit()
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .f.) })
   
     AAdd(aButtons,{	'',{|| U_KHCOM005() }, "Manutenção Medida Especial"} )
     AAdd(aButtons,{	'',{|| fCarEsp() },    "Integrar Medida Especial"} )
     AAdd(aButtons,{	'',{|| zLegenda() },    "Legenda"} )
    
    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()

  	@  34, 05 Say  oSay Prompt 'Cliente'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 05 MSGet oCliente Var cCliente FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.) }  F3 "SA1" When .T. Of oTela 

    @  34, 55 Say  oSay Prompt 'Pedido'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 55 MSGet oPedido Var cPedido FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.) } F3 "SC5" When .T. Of oTela 
    
    @  34, 105 Say  oSay Prompt 'Ped Compras'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 105 MSGet oPedComp Var cPedCom FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.)} F3 "SC7" When .T. Picture "@!" Of oTela 
    
    tButton():New(44,155,"&Visu Anexo",oTela,{|| fShow() },50,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,205,"&Alterar",oTela,{|| fAltera() },50,10,,,,.T.,,,,/*{|| }*/)

Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit()


	Local cQuery := ""
    Local cAlias := getNextAlias()
    Local cAnexo := "NÃO"
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') // 2 = ANDAMENTO
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  // 1 = FINALIZADO
    Local oSt3 := LoadBitmap(GetResources(),'BR_CINZA')  //3 CANCELADO
    Local oSt4 := LoadBitmap(GetResources(),'BR_AZUL')  //4 PENDENTE
    
    cQuery := " SELECT Z15_STATUS,Z15_NUMPV,Z15_CLIENT,A1_NOME,Z15_EMISSA,Z15_XFILIA,Z15_PRODES,Z15_ITEMPV,Z15_DESCPR,Z15_PRODOR,Z15_DESCOR,Z15_QTDVEN,Z15_ANEXO FROM Z15010(NOLOCK) Z15 "
    cQuery += " INNER JOIN SA1010(NOLOCK) A1 ON A1.A1_COD = Z15.Z15_CLIENT"
    cQuery += " WHERE Z15.D_E_L_E_T_ = ' '"
   
    If !EMPTY(cCliente)
    cQuery += " AND Z15_CLIENT = '"+cCliente+"'"
    EndIf
     If !EMPTY(cPedido)
    cQuery += " AND Z15_NUMPV = '"+cPedido+"'"
    EndIf
     If !EMPTY(cPedCom)
    cQuery += " AND Z15_PEDCOM = '"+cPedCom+"'"
    EndIf
    
    cQuery += " ORDER BY Z15_NUMPV "
   
   
    PLSQuery(cQuery, cAlias)

    aTapec := {}

    while (cAlias)->(!eof())

        aAdd(aTapec,{;
              			(cAlias)->Z15_STATUS,;
        				oNo,;
                        (cAlias)->Z15_NUMPV,;
                        (cAlias)->Z15_CLIENT,;
                        (cAlias)->A1_NOME,;
                        (cAlias)->Z15_EMISSA,;
                        (cAlias)->Z15_XFILIA,;
                        (cAlias)->Z15_PRODES,;
                        (cAlias)->Z15_ITEMPV,;
                        (cAlias)->Z15_DESCPR,;
                        (cAlias)->Z15_PRODOR,;
                        (cAlias)->Z15_DESCOR,;
                        (cAlias)->Z15_QTDVEN,;
                        IIF(!empty ((cAlias)->Z15_ANEXO),"SIM","NAO");
                        })
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())
    
    if len(aTapec) == 0
        AAdd(aTapec, {oSt1,oNo,""," "," ",CTOD("//"),"","","","","","","","NAO"})
    endif

    oBrowse:SetArray(aTapec)

    oBrowse:bLine := {|| {   	iif(aTapec[oBrowse:nAt,01]=="1",oSt2,;
    							iif(aTapec[oBrowse:nAt,01]=="2",oSt1,;
    							iif(aTapec[oBrowse:nAt,01]=="3",oSt3,oSt4))),;  
                                aTapec[oBrowse:nAt,02] ,;
                                aTapec[oBrowse:nAt,03] ,;
                                aTapec[oBrowse:nAt,04] ,;
                                aTapec[oBrowse:nAt,05] ,;
                                aTapec[oBrowse:nAt,06] ,;
                                aTapec[oBrowse:nAt,07] ,;
                                aTapec[oBrowse:nAt,08] ,;
                                aTapec[oBrowse:nAt,09] ,;
                                aTapec[oBrowse:nAt,10] ,;
                                aTapec[oBrowse:nAt,11] ,;
                                aTapec[oBrowse:nAt,12] ,;
                                aTapec[oBrowse:nAt,13] ,;
                                aTapec[oBrowse:nAt,14] ;
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
        aTapec[nLinha][2] := oOk
    else
        aTapec[nLinha][2] := oNo
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
            aTapec[nx][9] := cNumCtr
            aAdd(aGrava,{;
                        aTapec[nx][14],; //RECNO
                        aTapec[nx][9]}) //CTR
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
                cPara := alltrim(cPasta +"\"+ cvaltochar(aTapec[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))

                //Verifico se ja existe o arquivo na pasta, e removo
                if File( cPasta +"\"+ cValToChar(aTapec[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
                    if fErase(cPasta +"\"+ cValToChar(aTapec[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
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

                aTapec[nLinha][8] := "SIM"
                aAdd(aGrava,{;
                            aTapec[nLinha][14],; //RECNO
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
    Local cAnexo := ''

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    	If aTapec[nLinha][13] =='SIM'
	    	DbSelectArea('Z15')
	    	Z15->(DbSetOrder(2))//Z15_CLIENT+Z15_NUMPV+Z15_ITEMPV
			if Z15->(DbSeek(xFilial()+aTapec[nLinha][03]+aTapec[nLinha][02]+aTapec[nLinha][08]))     
			        CpyS2TEx(alltrim(Z15->Z15_ANEXO), alltrim(cTemp + substr(Z15->Z15_ANEXO,rat("\",Z15->Z15_ANEXO)+1,len(Z15->Z15_ANEXO))))    
			        ShellExecute("open",  alltrim(cTemp + substr(Z15->Z15_ANEXO,rat("\",Z15->Z15_ANEXO)+1,len(Z15->Z15_ANEXO))), "", "C:\", 1 )
			        oBrowse:refresh()
	        Else
	            msgAlert("Não foi possivel abrir o arquivo!!")
	        endif
        Else
         MsgAlert("Este Regisro Não Possuí Anexo!")
        EndIf
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



Static Function fAltera()

	
	Local nLinha := 0
	Local aCamp := {"Z15_STATUS","Z15_PRODOR","Z15_PEDCOM","Z15_DTPEDC","Z15_DTENCP","Z15_TAPECA"}
	Private cCadastro := "Medida Especial - Alteração de Cadastro"
   

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    
    
	    DbSelectArea('Z15')
	    	Z15->(DbSetOrder(2))//Z15_CLIENT+Z15_NUMPV+Z15_ITEMPV
			if Z15->(DbSeek(xFilial()+aTapec[nLinha][04]+aTapec[nLinha][03]+aTapec[nLinha][09]))     
	        AxAltera("Z15",Z15->(Recno()),4,,aCamp)
	    endif

	EndIf

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fGraZ15
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static function fGraZ15()

Local nQtde := 0

	If !EMPTY(cForne) .AND. !EMPTY(cLoKo)
	for nx := 1 to len(aPedEsp)
	nQtde += 1
	DbSelectArea("Z15")
	Z15->(DbSetOrder(2))//Z15_CLIENT+Z15_NUMPV+Z15_ITEMPV
	if Z15->(DbSeek(xFilial()+aPedEsp[nx][02]+aPedEsp[nx][04]+aPedEsp[nx][07]))
	Reclock("Z15",.F.)
	Else
	Reclock("Z15",.T.)
	EndIf
	Z15_FILIAL := xFilial("Z15")
	Z15_XFILIA := aPedEsp[nx][01]
	Z15_EMISSA := aPedEsp[nx][03]
	Z15_CLIENT := aPedEsp[nx][02]
	Z15_NUMPV  := aPedEsp[nx][04]
	Z15_ITEMPV := aPedEsp[nx][07]
	Z15_FORNEC := aPedEsp[nx][10]
	Z15_PRODES := ALLTRIM(aPedEsp[nx][05])
	Z15_DESCPR := aPedEsp[nx][06]
	Z15_LOCAL  := aPedEsp[nx][09]
	Z15_QTDVEN := aPedEsp[nx][08]
	Z15_STATUS := "4"
	MsUnLock()
	Next nx
	MsgAlert("Quantidade de Registros Integrados: "+cvaltochar(nQtde)+".")
	
	Else
	MsgAlert("É Necessário informar um fornecedor e loja para integrar")
	EndIf

Return


Static Function fCarEsp()


	Local cAlias := getNextAlias()
    Local cQuery := "" 
    Local cStatus := ""
    Local oButton1
	Local oButton2
	Local oGroup1
	Local oGroup2
	Local oGroup3
	Private cForne := CriaVar("B1_PROC", .F.)
    Private oLoj
    Private cLoKo := CriaVar("B1_LOJPROC", .F.)
    Private oEmiDe
    Private dEmiDe := CriaVar("C5_EMISSAO", .F.)
    Private oEmiAt
    Private dEmiAt := CriaVar("C5_EMISSAO", .F.)
    Private oDescri
    Private cDescricao := CriaVar("B1_DESC", .F.)
	Private oFont := TFont():New('Courier new',,-18,.T.)
	Private oBroesp
	Private cPedVen := CriaVar("C5_NUM", .F.)
	Private aPedEsp
	Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Medida Especial" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
    
   
    @ 005, 006 GROUP oGroup1 TO 036, 393 PROMPT "Filtros" OF oDlg COLOR 0, 16777215 PIXEL
    @ 041, 006 GROUP oGroup2 TO 199, 393 PROMPT "Dados" OF oDlg COLOR 0, 16777215 PIXEL
    @ 203, 008 GROUP oGroup3 TO 242, 393 PROMPT "Ação" OF oDlg COLOR 0, 16777215 PIXEL
    @ 013, 009 Say  oSay1 Prompt 'Fornecedor'	FONT oFont11 COLOR CLR_BLUE Size  32, 08 Of oDlg Pixel
    @ 022, 009 MSGet oFornece Var cForne FONT oFont11 COLOR CLR_BLUE Pixel SIZE 14, 05 VALID {|| }  F3 "FOR" When .T. Of oDlg 
    @ 013, 045 Say  oSay2 Prompt 'Loja'	FONT oFont11 COLOR CLR_BLUE Size  15, 08 Of oDlg Pixel
    @ 022, 045 MSGet oLoj Var cLoKo FONT oFont11 COLOR CLR_BLUE Pixel SIZE 10, 05 VALID {|| processa( {|| fIteEsp() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oDlg 
    @ 013, 065 Say  oSay3 Prompt 'Pedido' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
    @ 022, 065 MSGet oEmiDe Var cPedVen FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fIteEsp() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oDlg 
    @ 013, 144 Say  oSay3 Prompt 'Emissão de' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
    @ 022, 144 MSGet oEmiDe Var dEmiDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fIteEsp() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oDlg 
    @ 013, 228 Say  oSay4 Prompt 'Emissão ate' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDlg Pixel
    @ 022, 227 MSGet oEmiAt Var dEmiAt FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fIteEsp() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oDlg 
    @ 226, 290 BUTTON oButton1 PROMPT "Integrar" SIZE 037, 012 OF oDlg ACTION(fGraZ15(),oDlg:End()) PIXEL
    @ 226, 350 BUTTON oButton2 PROMPT "Sair" SIZE 037, 012 OF oDlg ACTION(oDlg:End()) PIXEL

    oBroesp := TwBrowse():New(49,10,381,150,, {'Filial',;
															    'Cliente',;
															    'Emissao',;
															    'Pedido',;
															    'Produto',;
															    'Descricao',;
															    'Item',;
															    'Qtd Venda',;
															    'Armazem',;
															    'Fornecedor'},,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

	fIteEsp()
	
    ACTIVATE MSDIALOG oDlg CENTERED


Return 


Static Function fIteEsp()


	Local cAlias := getNextAlias()
    Local cQuery := "" 
    Local cStatus := ""

    cQuery := "SELECT C6_MSFIL,A1_COD,C5_EMISSAO,C5_NUM,C6_PRODUTO,B1_DESC,C6_ITEM,C6_QTDVEN,C6_LOCAL,B1_PROC"+CRLF
    cQuery += " FROM "+ retSqlName("SC6") +" SC6 "+CRLF
    cQuery += " INNER JOIN "+ retSqlName("SC5") +" SC5 ON SC5.C5_MSFIL = SC6.C6_MSFIL"+CRLF
    cQuery += " INNER JOIN SA1010(NOLOCK) A1 ON A1.A1_COD=SC6.C6_CLI "+CRLF
    cQuery += " AND SC5.C5_NUM = SC6.C6_NUM"+CRLF
    cQuery += " LEFT JOIN "+ retSqlName("SC9") +" SC9 ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''"+CRLF
    cQuery += " INNER JOIN "+ retSqlName("SB1") +" SB1 ON SC6.C6_PRODUTO = SB1.B1_COD"+CRLF
    //cQuery += " LEFT JOIN "+ retSqlName("SC7") +" SC7 ON SC6.C6_NUM = SC7.C7_01NUMPV AND SC6.C6_PRODUTO = SC7.C7_PRODUTO AND SC6.D_E_L_E_T_ = ' ' AND C7_NUM IS NULL AND C7_RESIDUO <> 'S' "+CRLF
    cQuery += " WHERE SC6.D_E_L_E_T_ = ' '	"+CRLF
    cQuery += " AND SC5.D_E_L_E_T_ = ' '	"+CRLF
    cQuery += " AND C6_BLQ <> 'R' "+CRLF
    cQuery += " AND C6_RESERVA = ' ' "+CRLF   
    cQuery += " AND C5_NOTA = ' '"+CRLF
    cQuery += " AND C6_NOTA = ' '"+CRLF
    cQuery += " AND ISNULL(C9_BLEST,'XX') <> ''"
    cQuery += " AND (SELECT (B2_QATU-B2_RESERVA) AS SALDO  "+CRLF
    cQuery += " FROM "+ retSqlName("SB2")+CRLF
    cQuery += " WHERE B2_COD = C6_PRODUTO"+CRLF
    cQuery += " AND B2_FILIAL = '0101'"+CRLF
    cQuery += " AND B2_LOCAL = '01'"+CRLF
    cQuery += " AND D_E_L_E_T_ = ' ') = 0"+CRLF
    cQuery += " AND B1_XENCOME = '2'"+CRLF
    cQuery += " AND B1_DESC LIKE '%"+ alltrim("MED") +"%'"+CRLF
    
    if !empty(alltrim(cForne))
       cQuery += " AND B1_PROC = '"+ cForne +"'"+CRLF
    endif 
    
     if !empty(alltrim(cLoKo))
     	cQuery += " AND B1_LOJPROC = '"+ cLoKo +"'	"+CRLF
     EndIf    
     
      if !empty(alltrim(cPedVen))
     	cQuery += " AND SC5.C5_NUM = '"+ cPedVen +"'	"+CRLF
     EndIf    
       
    if !empty(dtos(dEmiDe))
        cQuery += " AND SC5.C5_EMISSAO >= '"+ dtos(dEmiDe) +"'"+CRLF
    endif
    
    if !empty(dtos(dEmiAt))
        cQuery += " AND SC5.C5_EMISSAO <= '"+ dtos(dEmiAt) +"'"+CRLF
    endif
    
    cQuery += " AND SC5.C5_NUM NOT IN (SELECT C7_01NUMPV FROM SC7010 WHERE C7_01NUMPV = C5_NUM AND D_E_L_E_T_ = ' ' AND C7_RESIDUO <> 'S' )"
    //cQuery += " AND A1.A1_COD+SC6.C6_NUM+SC6.C6_ITEM NOT IN (SELECT Z15_CLIENT+Z15_NUMPV+Z15_ITEMPV  FROM Z15010(NOLOCK) WHERE D_E_L_E_T_ = ' ')"
    cQuery += " ORDER BY C5_EMISSAO, C6_NUM, C6_ITEM"

    //MemoWrite( "C:\spool\khcom001.txt", cQuery )

    PLSQuery(cQuery, cAlias)

    aPedEsp := {}

    while (cAlias)->(!eof())
        
        aAdd(aPedEsp,{  alltrim(U_RETDESCFI((cAlias)->C6_MSFIL)),;
                        (cAlias)->A1_COD,;
                        (cAlias)->C5_EMISSAO,;
                        (cAlias)->C5_NUM,;
                        (cAlias)->C6_PRODUTO,;
                        alltrim((cAlias)->B1_DESC),;
                        (cAlias)->C6_ITEM,;
                        (cAlias)->C6_QTDVEN,;
                        (cAlias)->C6_LOCAL,;
                        (cAlias)->B1_PROC;
                    })

    (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())
    
    if len(aPedEsp) == 0
        AAdd(aPedEsp, {"","",CTOD(""),"","","","",0,"",""})
    endif

    oBroesp:SetArray(aPedEsp)

    oBroesp:bLine := {|| {      aPedEsp[oBroesp:nAt,01] ,; 
                                aPedEsp[oBroesp:nAt,02] ,;
                                aPedEsp[oBroesp:nAt,03] ,;
                                aPedEsp[oBroesp:nAt,04] ,;
                                aPedEsp[oBroesp:nAt,05] ,;
                                aPedEsp[oBroesp:nAt,06] ,;
                                aPedEsp[oBroesp:nAt,07] ,;
                                aPedEsp[oBroesp:nAt,08] ,;
                                aPedEsp[oBroesp:nAt,09] ,;
                                aPedEsp[oBroesp:nAt,10] ;
                            }}
    
    oBroesp:refresh()
    //oBroesp:setFocus()
    //oBroesp:Align := CONTROL_ALIGN_ALLCLIENT
	
Return

Static Function zLegenda()

	Local aLegenda := {}

	//Monta as legendas (Cor, Legenda)

	aAdd(aLegenda,     {"BR_AZUL","Produto Pendente" })         //"Atendimento Planejado" --> Padrão
	aAdd(aLegenda,     {"BR_VERMELHO" 	,"Produto Finalizado" }) //"Atendimento Pendente" --> Padrão
	aAdd(aLegenda,     {"BR_VERDE"		,"Produto Em Andamento"}) //"Atendimento Encerrado" --> Padrão
	aAdd(aLegenda,     {"BR_CINZA"		,"Produto Cancelado"}) //"Atendimento Cancelado" --> Padrão

	//Chama a função que monta a tela de legenda
	BrwLegenda("STATUS MEDIDA ESPECIAL", "Status Medida Especial", aLegenda)

Return

