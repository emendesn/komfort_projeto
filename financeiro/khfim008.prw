#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

Static nAltBot		:= 010
Static nDistPad		:= 001

//--------------------------------------------------------------
/*/{Protheus.doc} KHFIN008
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington Raul
@since 30/10/2018 /*/
//--------------------------------------------------------------
USER FUNCTION KHFIM008()

    Local cDescricao := "Cobrança"
	
	Private lChecSu := .F.
	Private lChecIn := .F.
	Private lAcesso := .F.
	Private nOrder := 0 
    
	Private oTela
	Private oCheckBo1
    Private aInfo := {}
	Private oLayer := FWLayer():new()
	Private aSize := FWGetDialogSize(oMainWnd)
    Private aButtons := {}
    Private aAlter := {}
    
	Private oParam
    Private oCliPag
    Private oBotoes
    Private oCliDev
	Private oParDev
	
    Private oGridNCC := nil
    Private aHeaderNCC := {}
    Private aNCC := {}

    Private oGridTit := nil
    Private aDevCli := {}
    Private aTitulos := {}

	Private oGridTerRet := nil
    Private aHeadTerRet := {}
    Private aTermos := {}    

	Private cPesqCli := space(50)
    
    Private oCliente
    Private cNomeCli := space(100)

	Private oDataDe
	Private oDataAte
    
    Private oSupOk := LoadBitMap(GetResources(), "LBOK")
    Private oSupNo := LoadBitMap(GetResources(), "LBNO")
    
    Private oInfpOk := LoadBitMap(GetResources(), "LBOK")
    Private oInfNo := LoadBitMap(GetResources(), "LBNO")
    
    
    Private oParam
    private oOpcoes
    Private nOpcoes := 1

	Private oSt1 := LoadBitmap(GetResources(),'BR_VERDE') 	//BAIXADO
	Private oSt2 := LoadBitmap(GetResources(),'BR_AZUL') 	//ABERTO
	Private oSt3 := LoadBitmap(GetResources(),'BR_VERMELHO')//VENCIDO
	Private oSt4 := LoadBitmap(GetResources(),'BR_LARANJA')	//BAIXA PARCIAL

    Private oFont11

	Private nPFlag := nPTitulo := nPPrefixo := nPParcela := nPTipo := nPEmissao := nPCliente := nPLojaCli := nPNome := nPChamado := nPTroca := nPUserName := 0

	Private oPesquisa
	Private oConfNCC
	Private oConfSup
	Private oConfInf
	Private oReprova
	Private oConheci
    Private oSair
    
    Private oTitulo
    Private cCpfCnpj := SPACE(20)
    
    Private cCpfCnpj := SPACE(20)
    Private oTButton1
    Private oEmisDe
    private dEmInf := ctod('//') 
    Private oEmisAt
    private dAteInf := ctod('//')
    
    Private oEmSup
    private dEmSup := ctod('//') 
    Private oAteSup
    private dAteSup := ctod('//')
    
    
    Private cCadastro := "Manutenção de Negativação"


    aObjects := {}
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )
    AAdd( aObjects, { 100 , 100, .T. , .T. , .F. } )

    aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }
    
    aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )
   
    oTela := tDialog():New(aSize[1],aSize[2],aSize[3],aSize[4],OemToAnsi(cDescricao),,,,,/*nClrText*/,/*nClrBack*/,,,.T.)
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD
    
    EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,,,,.F.,,)
    
    //Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
	oLayer:init(oTela,.F.)
	
	//Cria as Linhas do Layer
    oLayer:AddLine("L01",20,.F.)
	oLayer:AddLine("L02",30,.F.)
	oLayer:AddLine("L03",20,.F.)
	oLayer:AddLine("L04",30,.F.)

    //Cria as colunas do Layer
	oLayer:addCollumn('Col01_01',90,.F.,"L01")//Parametros
	oLayer:addCollumn('Col01_02',10,.F.,"L01")//Acoes/botoes

    oLayer:addCollumn('Col02_01',100,.F.,"L02")//clientes negativados

    oLayer:addCollumn('Col03_01',90,.F.,"L03")//parametros
    oLayer:addCollumn('Col03_02',10,.F.,"L03")//Ações Botões

    oLayer:addCollumn('Col04_01',100,.F.,"L04")//Clientes que tem que sair da negativação
    
    oLayer:addWindow('Col01_01','C1_Win01_01','Parametros',100,.F.,.F.,/**/,"L01",/**/)
    oLayer:addWindow('Col01_02','C1_Win01_02','Botoes',100,.F.,.F.,/**/,"L01",/**/)
	oLayer:addWindow('Col02_01','C2_Win02_01','Clientes Para Negativação',100,.F.,.F.,/*{|| }*/,"L02",/**/)
    oLayer:addWindow('Col03_01','C3_Win03_01','Parametros',100,.F.,.F.,/**/,"L03",/**/)
    oLayer:addWindow('Col03_02','C3_Win03_02','Botoes',100,.F.,.F.,/**/,"L03",/**/)
    oLayer:addWindow('Col04_01','C4_Win04_01','Clientes Para Sair da Negativação',100,.F.,.F.,/**/,"L04",/**/)

    oParam :=  oLayer:getWinPanel('Col01_01','C1_Win01_01',"L01")
    oBotoes := oLayer:getWinPanel('Col01_02','C1_Win01_02',"L01")
    oCliDev := oLayer:getWinPanel('Col02_01','C2_Win02_01',"L02")
	oDevPar := oLayer:getWinPanel('Col03_01','C3_Win03_01',"L03")
    oParDev := oLayer:getWinPanel('Col03_02','C3_Win03_02',"L03")
	oCliPag := oLayer:getWinPanel('Col04_01','C4_Win04_01',"L04")

    CriaParam()
    CriaBotoes()
    CrBtInf()
    DevParam()

	oGridNCC := TwBrowse():New(005, 005, aSize[4], aSize[3],, { '',; 
																'Codigo',;
                                                                'Usuário',;
                                                                'DT_negativa',;
                                                                'Ent_Spc',;
                                                                'Ent_Serasa',;
                                                                'Cliente',;
                                                                'Rua',;
                                                                'Cep',;
                                                                'Bairro',;
                                                                'MUnicipio',;
                                                                'Email',;
                                                                'Valor',;
                                                                'Titulo'},,oCliDev,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
   
    oGridNCC:bLDblClick := {|| fMarSup(oGridNCC:nAt)  }
    fCarrTit()
    
    oGridNCC:nScrollType := 1

    oGridNCC:setFocus()
	
	oGridTit := TwBrowse():New(005, 005, aSize[4], aSize[3],, { '',; 
																'Nome',;
                                                                'CPF/CNPJ',;
                                                                'Endereço',;
                                                                'CEP',;
                                                                'Bairro',;
                                                                'Municipio',;
                                                                'Email',;
                                                                'Titulo'},,oCliPag,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oGridTit:bLDblClick := {|| fMarInf(oGridTit:nAt)  }
    fCarNeg()
    
    // Scroll type 
    oGridTit:nScrollType := 1

    oGridTit:setFocus()

    oTela:Activate(,,,.T.,/*valid*/,,{|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.) } )

Return()

//--------------------------------------------------------------
/*/{Protheus.doc} CriaParam
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function CriaParam()
	
	Local cParam := space(100)
	
	
	//'Cliente De
	@  02,  000 Say  oSay Prompt 'Cliente de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  045 MSGet oCliente	Var cPesqCli		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 05 When .T.	F3 "SA1" Of oParam 
	
	//'Data Abertura De
	@  02,  200 Say  oSay Prompt 'Negativação de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  250 MSGet oEmSup	Var dEmSup		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam
	
	//'Data Abertura Ate
	@  02,  300 Say  oSay Prompt 'Negativação Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oParam Pixel
	@  01,  350 MSGet oAteSup	Var dAteSup		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oParam 
	
	@  20, 000 CHECKBOX oCheckBo1 VAR lChecSu PROMPT "Todos" SIZE 048, 008 OF oParam COLORS 0, 16777215 PIXEL VALID {|| processa( {||fAllSup(lChecSu)}, "Aguarde...", "Atualizando Dados...", .f.)}
Return


//--------------------------------------------------------------
/*/{Protheus.doc} CriaParam
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function DevParam()
	
	Local cParam := space(100)
	
	
	//'Nome Cliente
	@  02,  00 Say  oSay Prompt 'Nome Cliente:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDevPar Pixel
	@  01,  45 MSGet oCliente	Var cNomeCli		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  150, 05 When .T. F3 "SA1" Of oDevPar  
	
	//'Data Abertura De
	@  02,  200 Say  oSay Prompt 'Negativação de:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDevPar Pixel
	@  01,  250 MSGet oDataDe	Var dEmInf		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oDevPar
	
	//'Data Abertura Ate
	@  02,  300 Say  oSay Prompt 'Negativação Ate:'		FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oDevPar Pixel
	@  01,  350 MSGet oDataAte	Var dAteInf		FONT oFont11 COLOR CLR_BLUE Pixel SIZE  50, 05 When .T.	Of oDevPar 
	
	@  20, 000 CHECKBOX oCheckBo1 VAR lChecIn PROMPT "Todos" SIZE 048, 008 OF oDevPar COLORS 0, 16777215 PIXEL VALID {|| processa( {||fAllInf(lChecIn)}, "Aguarde...", "Atualizando Dados...", .f.)}
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit()

   Local cQuery := ""
    Local cAlias := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') //"Acordo no financeiro"
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Acordo Rejeitado" --> Padrão
    Local oSt3 := LoadBitmap(GetResources(),'BR_AZUL') //"Acordo finalizado" --> Padrão
    Local oSt4 := LoadBitmap(GetResources(),'BR_AMARELO')  //"Acordo Aguardando aprovação" --> Customizado Komfort
    Local cCpfFor
	Local cCpfFin
	Local lCod := .T.
	Local lLik := .T.
	Local nCpf := 0
    
    If !Empty(AllTrim(cPesqCli))
		nCpf := Val(cPesqCli)
		If nCpf > 0
			if len(alltrim(cPesqCli)) > 6
				cCpfFor := StrTran(AllTrim(cPesqCli),"-","")
				cCpfFin	:= StrTran(AllTrim(cCpfFor),".","")
			Else
				lCod := .F.
				cCpfFin := cPesqCli
			EndIf
		Else
		lLik := .F.
		cCpfFin := cPesqCli
		EndIf
	EndIf
			 cQuery := CRLF + "SELECT Z18_CODIGO ,Z18_USERNE ,Z18_DTNEGA , "
			 cQuery += CRLF + "Z18_ENTSPC,Z18_ENTSER, "
			 cQuery += CRLF + "Z17_NOME,Z17_CPF, Z17_ENDERE, Z17_CEP,Z17_BAIRRO, "
			 cQuery += CRLF + "Z17_MUNICI, Z17_EMAIL, Z17_VALOR, Z17_TITULO, Z17.R_E_C_N_O_ AS REC17, Z18.R_E_C_N_O_ AS REC18    "
			 cQuery += CRLF + "FROM Z18010(NOLOCK) Z18 INNER JOIN Z17010(NOLOCK) Z17 ON Z18.Z18_CODIGO = Z17.Z17_CODIGO  "
		     cQuery += CRLF + "WHERE Z17.D_E_L_E_T_ = '' "
			 cQuery += CRLF + "AND Z18.D_E_L_E_T_ = '' "
	if !Empty(AllTrim(cCpfFin))
		if lLik
			IF lCod
				cQuery += CRLF + " AND Z17_CPF = '"+cCpfFin+"' "
			Else
				cQuery += CRLF + " AND Z18_CODIGO = '"+cCpfFin+"' "
			EndIf
		Else 
			cQuery += CRLF + " AND Z17_NOME LIKE '%"+UPPER(alltrim(cCpfFin))+"%' "
		EndIf
	EndIf
	 if !empty(dEmInf)
        cQuery += " AND Z18.DTNEGA  >= '"+ dtos(dEmInf) +"'" 
    endif
    if !empty(dAteInf)
        cQuery += " AND Z18.DTNEGA  <= '"+ dtos(dAteInf)+ "'"
    endif
	cQuery += CRLF + " ORDER BY Z18_DTNEGA "

    PLSQuery(cQuery, cAlias)

    aDevCli := {}

    while (cAlias)->(!eof())

        aAdd(aDevCli,{;
        				oSupNo,;
                        (cAlias)->Z18_CODIGO,;   
                        (cAlias)->Z18_USERNE,;
                        (cAlias)->Z18_DTNEGA,;
                        (cAlias)->Z18_ENTSPC,;
                        (cAlias)->Z18_ENTSER,;
                        (cAlias)->Z17_NOME,;
                        (cAlias)->Z17_ENDERE,;
                        (cAlias)->Z17_CEP,;
                        (cAlias)->Z17_BAIRRO,;
                        (cAlias)->Z17_MUNICI,;
                        (cAlias)->Z17_EMAIL,;
                        (cAlias)->Z17_VALOR,;
                        (cAlias)->Z17_TITULO,;
                        (cAlias)->REC17,;
                        (cAlias)->REC18})
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aDevCli) == 0
        AAdd(aDevCli, {oSupNo,""," ",CTOD("//"),CTOD("//"),CTOD("//"),"","","","","","",""})
    endif

    oGridNCC:SetArray(aDevCli)
    
    

    oGridNCC:bLine := {|| {     aDevCli[oGridNCC:nAt,01],;
        						aDevCli[oGridNCC:nAt,02] ,;  
                                aDevCli[oGridNCC:nAt,03] ,;
                                aDevCli[oGridNCC:nAt,04] ,;
                                aDevCli[oGridNCC:nAt,05] ,;
                                aDevCli[oGridNCC:nAt,06] ,;
                                aDevCli[oGridNCC:nAt,07] ,;
                                aDevCli[oGridNCC:nAt,08] ,;
                                aDevCli[oGridNCC:nAt,09] ,;
                                aDevCli[oGridNCC:nAt,10] ,;
                                aDevCli[oGridNCC:nAt,11] ,;
                                aDevCli[oGridNCC:nAt,12] ,;
                                aDevCli[oGridNCC:nAt,13] ,;
                               }}
    
    oGridNCC:refresh()
    oGridNCC:setFocus()
    oGridNCC:Align := CONTROL_ALIGN_ALLCLIENT


Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarNeg
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarNeg()

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') //"Acordo no financeiro"
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Acordo Rejeitado" --> Padrão
    Local oSt3 := LoadBitmap(GetResources(),'BR_AZUL') //"Acordo finalizado" --> Padrão
    Local oSt4 := LoadBitmap(GetResources(),'BR_AMARELO')  //"Acordo Aguardando aprovação" --> Customizado Komfort
    Local cCpfFor
	Local cCpfFin
	Local lCod := .T.
	Local lLik := .T.
	Local nCpf := 0
    
    If !Empty(AllTrim(cNomeCli))
		nCpf := Val(cNomeCli)
		If nCpf > 0
			if len(alltrim(cNomeCli)) > 6
				cCpfFor := StrTran(AllTrim(cNomeCli),"-","")
				cCpfFin	:= StrTran(AllTrim(cCpfFor),".","")
			Else
				lCod := .F.
				cCpfFin := cNomeCli
			EndIf
		Else
		lLik := .F.
		cCpfFin := cNomeCli
		EndIf
	EndIf
			 cQuery := CRLF + "SELECT DISTINCT A1.A1_COD AS CLIENTE,A1.A1_NOME AS NOME,A1.A1_CGC AS CPFCNPJ, "
			 cQuery += CRLF + "A1.A1_END AS ENDERECO,A1.A1_CEP AS CEP,A1.A1_BAIRRO AS BAIRRO,A1.A1_MUN AS MUNICIPIO,A1.A1_EMAIL AS EMAIL, E1.E1_NUM AS TITULO "
			 cQuery += CRLF + " , Z18.R_E_C_N_O_ AS REC18, Z17.R_E_C_N_O_ AS REC17, A1.R_E_C_N_O_ AS RECA1 "
			 cQuery += CRLF + " FROM SE1010(NOLOCK) E1 "
			 cQuery += CRLF + "INNER JOIN SA1010(NOLOCK) A1 ON E1.E1_CLIENTE = A1.A1_COD INNER JOIN Z17010(NOLOCK) Z17 ON Z17.Z17_CODIGO = E1.E1_CLIENTE   "
			 cQuery += CRLF + "INNER JOIN Z18010(NOLOCK) Z18 ON Z18.Z18_CODIGO = E1.E1_CLIENTE WHERE E1.E1_BAIXA <> '' AND A1.A1_XNEGATI = '1' "
		     cQuery += CRLF + "AND E1.E1_SALDO > 0 AND E1.E1_VENCTO < GETDATE()-45 AND E1.D_E_L_E_T_ = '' AND Z17.D_E_L_E_T_ = '' AND Z18.D_E_L_E_T_ = ''"
	if !Empty(AllTrim(cCpfFin))
		if lLik
			IF lCod
				cQuery += CRLF + " AND A1.A1_CGC = '"+cCpfFin+"' "
			Else
				cQuery += CRLF + " AND A1.A1_COD = '"+cCpfFin+"' "
			EndIf
		Else 
			cQuery += CRLF + " AND A1.A1_NOME LIKE '%"+UPPER(alltrim(cCpfFin))+" %' "
		EndIf
	EndIf
	 if !empty(dEmSup)
        cQuery += " AND Z18.DTNEGA  >= '"+ dtos(dEmSup) +"'" 
    endif
    if !empty(dAteSup)
        cQuery += " AND Z18.DTNEGA  <= '"+ dtos(dAteSup)+ "'"
    endif	
	
    PLSQuery(cQuery, cAlias)

    aTitulos := {}

    while (cAlias)->(!eof())

        aAdd(aTitulos,{;
        				oInfNo,;
                        (cAlias)->CLIENTE,;   
                        (cAlias)->NOME,;
                        (cAlias)->CPFCNPJ,;
                        (cAlias)->ENDERECO,;
                        (cAlias)->CEP,;
                        (cAlias)->BAIRRO,;
                        (cAlias)->MUNICIPIO,;
                        (cAlias)->EMAIL,;
                        (cAlias)->TITULO,;
                        (cAlias)->REC18,;
                        (cAlias)->REC17,;
                        (cAlias)->RECA1})
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aTitulos) == 0
        AAdd(aTitulos, {oInfNo,""," ","","","","","","",""})
    endif

    oGridTit:SetArray(aTitulos)
    
    

    oGridTit:bLine := {|| {   	aTitulos[oGridTit:nAt,01],;
        						aTitulos[oGridTit:nAt,02] ,;  
                                aTitulos[oGridTit:nAt,03] ,;
                                aTitulos[oGridTit:nAt,04] ,;
                                aTitulos[oGridTit:nAt,05] ,;
                                aTitulos[oGridTit:nAt,06] ,;
                                aTitulos[oGridTit:nAt,07] ,;
                                aTitulos[oGridTit:nAt,08] ,;
                                aTitulos[oGridTit:nAt,09] ,;
                                aTitulos[oGridTit:nAt,10] ,;
                               }}
    
    oGridTit:refresh()
    oGridTit:setFocus()
    oGridTit:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} CriaBotoes
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul 
@since 31/10/2018 /*/
//--------------------------------------------------------------    
Static Function CriaBotoes()

    Local aTamBot := Array(4)
    Local cTitulo := "Clientes já analisados para negativação"

    aFill(aTamBot,0)
	//Adpta o tamanho dos botoes na tela
	StaticCall(AGEND,DefTamBot,@aTamBot)
	aTamBot[3] := (oBotoes:nClientWidth)
	aTamBot[4] := (oBotoes:nClientHeight)
    
	StaticCall(AGEND,DefTamBot,@aTamBot,000,000,-100,nAltBot,.T.,oBotoes)
	oPesquisa := tButton():New(aTamBot[1],aTamBot[2],"&Pesquisar",oBotoes,{|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.)},aTamBot[3],aTamBot[4],,,,.T.,,,,)
	       
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConfNCC := tButton():New(aTamBot[1],aTamBot[2],"&Retirar",oBotoes,{|| fRetSup() },aTamBot[3],aTamBot[4],,,,.T.,,,,)
    
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConfSup := tButton():New(aTamBot[1],aTamBot[2],"&Excel",oBotoes,{|| fExSup(cTitulo) },aTamBot[3],aTamBot[4],,,,.T.,,,,)
    
    
    oLayer:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} CriaBotoes
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 31/10/2018 /*/
//--------------------------------------------------------------    

Static Function CrBtInf()

    Local aTamBot := Array(4)
    Local cTitulo := "Clientes que devem sair da negativação"

    aFill(aTamBot,0)
	//Adpta o tamanho dos botoes na tela
	StaticCall(AGEND,DefTamBot,@aTamBot)
	aTamBot[3] := (oParDev:nClientWidth)
	aTamBot[4] := (oParDev:nClientHeight)
    
	StaticCall(AGEND,DefTamBot,@aTamBot,000,000,-100,nAltBot,.T.,oParDev)
	oPesquisa := tButton():New(aTamBot[1],aTamBot[2],"&Pesquisar",oParDev,{|| processa( {|| fCarNeg()}, "Aguarde...", "Atualizando Dados...", .F.)},aTamBot[3],aTamBot[4],,,,.T.,,,,)
	       
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConfNCC := tButton():New(aTamBot[1],aTamBot[2],"&Retirar",oParDev,{|| fRetInf() },aTamBot[3],aTamBot[4],,,,.T.,,,,)
    
    StaticCall(AGEND,DefTamBot,@aTamBot,aTamBot[1] + nAltBot + nDistPad)
    oConfInf := tButton():New(aTamBot[1],aTamBot[2],"&Excel",oParDev,{|| fExInf(cTitulo) },aTamBot[3],aTamBot[4],,,,.T.,,,,)
    
    oLayer:Refresh()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marcar/Desmarcar todos itens da tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellingtom Raul
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fAllSup(lCheck)

	Local nx := 0
	
	If lCheck
		
				for nx := 1 To Len(oGridNCC:AARRAY)
					if oGridNCC:AARRAY[nx][1]:CNAME  == "LBNO"
						aDevCli[nx][1] := oSupOk
					endif
				next nx
			
		
	
	Else
		
					for nx := 1 To Len(oGridNCC:AARRAY)
						if oGridNCC:AARRAY[nx][1]:CNAME  == "LBOK"
							aDevCli[nx][1] := oSupNo
						endif
					next nx
				
			
    EndIf	
	
	oGridNCC:Refresh()

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marcar/Desmarcar todos itens da tela.
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 31/10/2018 /*/
//--------------------------------------------------------------
Static Function fAllInf(lCheck)

	Local nx := 0
		
	If lCheck
		
				for nx := 1 To Len(oGridTit:AARRAY)
					if oGridTit:AARRAY[nx][1]:CNAME  == "LBNO"
						aTitulos[nx][1] := oInfpOk
					endif
				next nx
			
		
	
	Else
		
					for nx := 1 To Len(oGridTit:AARRAY)
						if oGridTit:AARRAY[nx][1]:CNAME  == "LBOK"
							aTitulos[nx][1] := oInfNo
						endif
					next nx
				
			
    EndIf	
	
	oGridTit:Refresh()
	

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fMarSup(nLinha)

    if oGridNCC:AARRAY[nLinha][1]:CNAME == "LBNO"
        aDevCli[nLinha][1] := oSupOk
    else
        aDevCli[nLinha][1] := oSupNo
    endif
    
    oGridNCC:refresh()
    
Return




//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fMarInf(nLinha)

    if oGridTit:AARRAY[nLinha][1]:CNAME == "LBNO"
        aTitulos[nLinha][1] := oInfpOk
    else
        aTitulos[nLinha][1] := oInfNo
    endif
    
    oGridTit:refresh()
    
Return



//--------------------------------------------------------------
/*/{Protheus.doc} SetCab1
Description //seta o pedido posicionado no cabeçalho
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 28/09/2018
/*/
//--------------------------------------------------------------
Static Function SetCab1(cParam1)
	
	if !(empty(cParam1))
		cCab :="Titulo: " + Alltrim(cParam1)
		oLayer:setWinTitle('Col02_01' ,'C2_Win02_01',cCab ,"L02" )
	endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} Retirar da negativação
Description //seta o pedido posicionado no cabeçalho
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 28/09/2018
/*/
//--------------------------------------------------------------

Static Function fRetSup()
	
	Local lLinha 

    for nx := 1 to len(oGridNCC:AARRAY)
        if oGridNCC:AARRAY[nx][1]:CNAME == "LBOK"
            If MsgYesno("Deseja remover este cliente da lista de negativados?","Atenção!")
	            nLinha := nx
	                dbSelectArea("Z17")
	            	Z17->(dbgoto(aDevCli[nLinha][15])) //Posicione no registro da Z17
		      		  IF !EOF()
		      		  	RecLock("Z17",.F.)
		      		  		Z17->(dbDelete())
		      		  	Z17->(msUnLock())
		      		  EndIF
	             	dbSelectArea("Z18")
					Z18->(dbgoto(aDevCli[nLinha][16])) // Posiciona no Registo da Z18
					  IF !EOF()
		      		  	RecLock("Z18",.F.)
		      		  		Z18->(dbDelete())
		      		  	Z18->(msUnLock())
		      		  EndIF	
		      	    dbSelectArea("SA1")
					SA1->(DbGoTop())
					SA1->(dbSetOrder(1)) //A1_FILIAL, A1_COD, A1_LOJA, R_E_C_N_O_, D_E_L_E_T_
					if SA1->(dbSeek(xFilial()+Alltrim(aDevCli[nLinha][2])+"01"))
						Reclock("SA1",.F.)
							SA1->A1_XNEGATI := "2"
						SA1->(msUnlock())
					endif       
	            exit
            EndIf
        endif
    next nx

   fCarrTit()

Return 


//--------------------------------------------------------------
/*/{Protheus.doc} Retirar da negativação Painel Inferior 
Description //seta o pedido posicionado no cabeçalho
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 28/09/2018
/*/
//--------------------------------------------------------------

Static Function fRetInf()
	
	Local lLinha
	Local cUser := LogUserName() 
	Local dData := DATE()

    for nx := 1 to len(oGridTit:AARRAY)
        if oGridTit:AARRAY[nx][1]:CNAME == "LBOK"
            If MsgYesno("Deseja remover este cliente da lista de negativados?","Atenção!")
	            nLinha := nx
	             	dbSelectArea("Z18")
					Z18->(dbgoto(aTitulos[nLinha][12])) // Posiciona no Registo da Z18
					  IF !EOF()
		      		  	RecLock("Z18",.F.)
		      		  		Z18->Z18_USERET := cUser
		      		  		Z18->Z18_SAISPC := dData
		      		  		Z18->Z18_SAISER := dData
		      		  	Z18->(msUnLock())
		      		  EndIF	
		      	    dbSelectArea("SA1")
					SA1->(dbgoto(aTitulos[nLinha][13])) // Posiciona no Registo da Z18
					if !EOF()
						Reclock("SA1",.F.)
							SA1->A1_XNEGATI := "2"
						SA1->(msUnlock())
					endif       
	            exit
            EndIf
        endif
    next nx

   fCarrTit()

Return 

//--------------------------------------------------------------
/*/{Protheus.doc} fExSup  
Description // Gera excel para o grid superior
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 03/11/2019
/*/
//--------------------------------------------------------------

Static Function fExSup(cTitle)
	
	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Negativados"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"A1_COD","A1_NOME","E1_VENCTO","E1_VENCTO","E1_VENCTO","A1_NOME","A1_END","A1_CEP","A1_BAIRRO","A1_MUN","A1_EMAIL","E1_VALOR","E1_NUM"}
    Local aCab := {}
    Local nx := 0
    Local nr := 0

    if len(aDevCli) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aCab,{aFields[nx],"","","","","","","C","","","",""})
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
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx


    for nr := 1 to len(aDevCli) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aDevCli[nr][2],;
											aDevCli[nr][3],;
                                            aDevCli[nr][4],;
											aDevCli[nr][5],;
                                            aDevCli[nr][6],;
                                            aDevCli[nr][7],;
                                            aDevCli[nr][8],;
                                            aDevCli[nr][9],;
                                            aDevCli[nr][10],;
                                            aDevCli[nr][11],;
                                            aDevCli[nr][12],;
                                            aDevCli[nr][13],;
                                            aDevCli[nr][14];
                                            })
	next nr
    

	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fExInf  
Description // Gera excel para o grid Inferior
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 03/11/2019
/*/
//--------------------------------------------------------------

Static Function fExInf(cTitle)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Retira_Negativados"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"A1_COD","A1_NOME","A1_CGC","A1_END","A1_CEP","A1_BAIRRO","A1_MUN","A1_EMAIL","E1_NUM"}
    Local aCab := {}
    Local nx := 0
    Local nr := 0

    if len(aTitulos) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aCab,{aFields[nx],"","","","","","","C","","","",""})
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
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		endif
	next nx

    for nr := 1 to len(aTitulos) 
	   	oExcel:AddRow(cNamePlan,cNameTable,{;
	   										aTitulos[nr][2],;
											aTitulos[nr][3],;
                                            aTitulos[nr][4],;
											aTitulos[nr][5],;
                                            aTitulos[nr][6],;
                                            aTitulos[nr][7],;
                                            aTitulos[nr][8],;
                                            aTitulos[nr][9],;
                                            aTitulos[nr][10];
                                            })
	next nr
    

	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return



