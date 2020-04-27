#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
#include 'parmtype.ch'
#include 'colors.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} KHTMK001
Description //Fila do orçamentos pemdentes de analise do credito
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
User Function KHTMK001()

Local aSize        := MsAdvSize()
Local cPesq        := Space(40)
Local cAltOpeCred  := SuperGetMV("KH_ALTOPCR",.F.,"000778|001041")

Private aOrcPriori := {}
Private aOrcFila   := {}
Private oLayer     := FWLayer():new()
Private oTela, oOrcPriori, oOrcFila
Private oPainel1, oPainel2, oPainel3
Private oBrwSup
Private oBrwInf
Private cOrder := "decrescente"


DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "FILA DE ORÇAMENTOS" Of oMainWnd PIXEL

//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botao de fechar
oLayer:init(oTela,.F.)
//Cria as Linhas do Layer
oLayer:AddLine("L01",25,.F.)
oLayer:AddLine("L02",15,.F.)
oLayer:AddLine("L03",60,.F.)
//Cria as colunas do Layer
oLayer:addCollumn('Col01_01',100,.F., "L01") 
oLayer:addCollumn('Col02_01',100,.F., "L02") 
oLayer:addCollumn('Col03_01',100,.F., "L03") 
//Cria as janelas
oLayer:addWindow('Col01_01','C1_Win01_01','Orçamentos de Prioridade',100,.F.,.F.,/**/,"L01",/**/)
oLayer:addWindow('Col02_01','C1_Win02_01','Pesquisa',100,.F.,.F.,/**/,"L02",/**/)
oLayer:addWindow('Col03_01','C1_Win03_01','Orçamentos Pendentes.',100,.F.,.F.,/**/,"L03",/**/)
//Adiciona os paineis aos objetos
oPainel1 := oLayer:GetWinPanel('Col01_01','C1_Win01_01',"L01")
oPainel2 := oLayer:GetWinPanel('Col02_01','C1_Win02_01',"L02")
oPainel3 := oLayer:GetWinPanel('Col03_01','C1_Win03_01',"L03")
    

//ORÇAMENTOS DE PRIORIDADE
oBrwSup := TwBrowse():New(000,000,oPainel1:nClientWidth/2,oPainel1:nClientHeight/2,, {'-',;
                                                                                      'Filial',;
						    														  'Status Cred',;
						    														  'Atend. Cred',;
						    														  'Atendimento',;
						    														  'Cliente',;
						    														  'Loja',;
						    														  'Nome Cliente',;
						    														  'Data',;
						    														  'Vendedor',;
						    														  'Nome Vendedor',;
						    														  'Dt. Env. Cred.',;
						    														  'Hr. Env. Cred.',;
						    														  'Formas Pagto Deletadas'},,oPainel1,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
			    														  
oBrwSup:bLDblClick := {|| fSetOPeracao(oBrwSup:nColPos,aOrcPriori[oBrwSup:nAt])  }
fCarrItSup()
    
//ORÇAMENTOS PENDENTES
oBrwInf := TwBrowse():New(000,000,oPainel3:nClientWidth/2,oPainel3:nClientHeight/2,, {'-',;
																					  'Filial',;
						                                                              'Status Cred',;
						                                                              'Atend. Cred',;
						                                                              'Atendimento',;
						                                                              'Cliente',;
						                                                              'Loja',;
						                                                              'Nome Cliente',;
						                                                              'Data',;
						                                                              'Vendedor',;
						                                                              'Nome Vendedor',;
						                                                              'Dt. Env. Cred.',;
						                                                              'Hr. Env. Cred.',;
						                                                              'Formas Pagto Deletadas'},,oPainel3,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

fCarrItInf()
oBrwInf:bLDblClick := {|| fSetOPeracao(oBrwInf:nColPos,aOrcFila[oBrwInf:nAt])}
oBrwInf:bHeaderClick := {|o, iCol| fSetOrder(iCol), oBrwInf:Refresh()}
    
@002,002 SAY oPesq PROMPT "Atendimento\Cliente: " SIZE 50, 10 OF oPainel2 COLORS 0, 16777215 PIXEL
@002,055 MSGET oGet VAR cPesq SIZE 100, 010 OF oPainel2 PIXEL
@002,160 BUTTON "&Pesquisar" SIZE 050, 012 ACTION Processa({|| fCarrItInf(cPesq) },"Aguarde...","Atualizando Dados...",.F.) OF oPainel2 PIXEL

if (Alltrim(__cUserId) $ cAltOpeCred)
   @002,230 BUTTON "&Orçamentos" SIZE 050, 012 ACTION Processa({|| U_KHTMK002() },"Aguarde...","Atualizando Dados...",.F.) OF oPainel2 PIXEL     
endif


SetKey(VK_F5, {|| processa( {|| fCarrItSup(), fCarrItInf() }, "Aguarde...", "Atualizando Dados...", .f.) })

ACTIVATE MSDIALOG oTela CENTERED
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItSup
Description //Carrega itens do painel Superior - Reanalise *Prioridades
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItSup()
    
    Local cAlias := getNextAlias()
    Local cQuery := ""
    Local cStatus := ""
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') // Cliente Normal
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')//Cliente Recompra
    
        cQuery := " SELECT UA_FILIAL, UA_XSTATUS, UA_XATCRED, UA_NUM, UA_CLIENTE, UA_LOJA, UA_DESCNT, UA_EMISSAO, UA_VEND, UA_XDTENV, UA_XHRENV,"
        cQuery += " (SELECT COUNT(C6_NUM) FROM SC6010(NOLOCK) C6 WHERE UA.UA_CLIENTE = C6.C6_CLI AND C6_BLQ <> 'R' AND C6.D_E_L_E_T_ = '') AS RECOMPRA,"
        cQuery += " (SELECT COUNT(*) FROM SL4010(NOLOCK) WHERE L4_NUM = UA.UA_NUM AND D_E_L_E_T_ = '*') AS FORMASDEL"
        cQuery += " FROM SUA010(NOLOCK) UA"
        cQuery += " WHERE UA_PEDPEND = '2'"
        cQuery += " AND UA_CANC <> 'S'"
       // cQuery += " AND UA_EMISSAO BETWEEN '20190601' AND 'ZZZ'"
        cQuery += " AND UA_XSTATUS = '5'"
        cQuery += " AND D_E_L_E_T_ = ' '"
        cQuery += " ORDER BY R_E_C_N_O_"
        
        PLSQuery(cQuery, cAlias)

        aOrcPriori := {}

        while (cAlias)->(!eof())
            
            cStatus := ""

            Do Case
               Case (cAlias)->UA_XSTATUS == '1'
                  cStatus := "EM ABERTO"
               Case (cAlias)->UA_XSTATUS == '2'
                  cStatus := "EM ATENDIMENTO"
               Case (cAlias)->UA_XSTATUS == '4'
                  cStatus := "SUGERIDO"
               Case (cAlias)->UA_XSTATUS == '5'
                  cStatus := "REANALISE"
            EndCase

            aAdd(aOrcPriori,{   Iif((cAlias)->RECOMPRA > 0, oSt2, oSt1),;
                                (cAlias)->UA_FILIAL,;
                                cStatus,;
                                (cAlias)->UA_XATCRED,;
                                (cAlias)->UA_NUM,;
                                (cAlias)->UA_CLIENTE,;
                                (cAlias)->UA_LOJA,;
                                Posicione("SA1",1,xFilial("SA1")+(cAlias)->UA_CLIENTE+(cAlias)->UA_LOJA,"A1_NOME"),;
                                (cAlias)->UA_EMISSAO,;
                                (cAlias)->UA_VEND,;
                                Posicione("SA3",1,xFilial("SA3")+(cAlias)->(UA_VEND),"A3_NOME"),;
                                (cAlias)->UA_XDTENV,;
                                (cAlias)->UA_XHRENV,;
                                IIf((cAlias)->FORMASDEL > 0, 'SIM', 'NÃO')})

        (cAlias)->(dbskip())
        End
        
        (cAlias)->(dbCloseArea())
        
        if len(aOrcPriori) == 0
            AAdd(aOrcPriori, {"","","","","","","",CTOD(""),"","",CTOD(""),"","",""})
        endif

        oBrwSup:SetArray(aOrcPriori)
   
        oBrwSup:bLine := {|| {   aOrcPriori[oBrwSup:nAt,01] ,;
                                 alltrim(U_RETDESCFI(aOrcPriori[oBrwSup:nAt,02])) ,; 
                                 aOrcPriori[oBrwSup:nAt,03] ,;
                                 aOrcPriori[oBrwSup:nAt,04] ,;
                                 aOrcPriori[oBrwSup:nAt,05] ,;
                                 aOrcPriori[oBrwSup:nAt,06] ,;
                                 aOrcPriori[oBrwSup:nAt,07] ,;
                                 aOrcPriori[oBrwSup:nAt,08] ,;
                                 aOrcPriori[oBrwSup:nAt,09] ,;
                                 aOrcPriori[oBrwSup:nAt,10] ,;
                                 aOrcPriori[oBrwSup:nAt,11] ,;
                                 aOrcPriori[oBrwSup:nAt,12] ,;
                                 aOrcPriori[oBrwSup:nAt,13] ,;
                                 aOrcPriori[oBrwSup:nAt,14] ;
                                }}
        
        oBrwSup:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItInf
Description //Carrega itens do painel Inferior - Em aberto, Em atendimento, Sugerido 
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItInf(cPesq)

    Local cAlias  := getNextAlias()
    Local cQuery  := "" 
    Local cStatus := ""
    Local cCpo    := IIf(IsNumeric(cpesq), "UA_NUM", "A1_NOME")
    Local aLikes  := {}
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE') // Cliente Normal
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')//Cliente Recompra
        
    Default cPesq   := ""
    
    // Retira aspas simples e duplas
    cPesq    := StrTran(cPesq,"'"," ")
    cPesq    := StrTran(cPesq,'"'," ")

    // Retira espacos em branco do campo de pesquisa.
    cPesq    := Alltrim(cPesq)

    // Transformo a pesquisa digitada em letras maiusculas
    cPesq    := Upper(cPesq)

    // Gera array com likes da pesquisa.
    aLikes   := StrToKArr(cPesq, " ")

    // Limpo o array do grid principal
    aOrcFila := {}
    
        cQuery := " SELECT  UA_FILIAL, UA_XSTATUS, UA_XATCRED, UA_NUM, UA_CLIENTE, UA_LOJA, A1_NOME, UA_DESCNT, UA_EMISSAO, UA_VEND, UA_XDTENV, UA_XHRENV,"
        cQuery += "(SELECT COUNT(C6_NUM) FROM SC6010(NOLOCK) C6 WHERE UA.UA_CLIENTE = C6.C6_CLI AND C6_BLQ <> 'R' AND C6.D_E_L_E_T_ = '') AS RECOMPRA,"
        cQuery += "(SELECT COUNT(*) FROM SL4010(NOLOCK) WHERE L4_NUM = UA.UA_NUM AND D_E_L_E_T_ = '*') AS FORMASDEL"
        cQuery += " FROM SUA010(NOLOCK) UA"
        cQuery += " INNER JOIN SA1010(NOLOCK) A1 ON UA_CLIENTE = A1_COD AND UA_LOJA = A1_LOJA"
        cQuery += " WHERE UA_PEDPEND = '2'"
        cQuery += " AND UA_CANC <> 'S'"
        cQuery += " AND UA_EMISSAO BETWEEN GETDATE()-5 AND GETDATE()"
        cQuery += " AND UA_XSTATUS NOT IN ('3','5')"
        cQuery += " AND UA.D_E_L_E_T_ = ' '"
        cQuery += " AND A1.D_E_L_E_T_ = ' '"
        
        If !Empty(aLikes)
			For nX := 1 to len(aLikes)
				cQuery += "AND " + cCpo + " LIKE '%"+ aLikes[nX] + "%' " + CRLF
			Next nX
		EndIf
        
        cQuery += " ORDER BY UA.R_E_C_N_O_"

        PLSQuery(cQuery, cAlias)

        while (cAlias)->(!eof())
            
            cStatus := ""
            
            Do Case
               Case (cAlias)->UA_XSTATUS == '1'
                  cStatus := "EM ABERTO"
               Case (cAlias)->UA_XSTATUS == '2'
                  cStatus := "EM ATENDIMENTO"
               Case (cAlias)->UA_XSTATUS == '4'
                  cStatus := "SUGERIDO"
               Case (cAlias)->UA_XSTATUS == '5'
                  cStatus := "REANALISE"
            EndCase
            
            aAdd(aOrcFila,{     Iif((cAlias)->RECOMPRA > 0, oSt2, oSt1),;
                                (cAlias)->UA_FILIAL,;
                                cStatus,;
                                (cAlias)->UA_XATCRED,;
                                (cAlias)->UA_NUM,;
                                (cAlias)->UA_CLIENTE,;
                                (cAlias)->UA_LOJA,;
                                (cAlias)->A1_NOME,;
                                (cAlias)->UA_EMISSAO,;
                                (cAlias)->UA_VEND,;
                                Posicione("SA3",1,xFilial("SA3")+(cAlias)->(UA_VEND),"A3_NOME"),;
                                (cAlias)->UA_XDTENV,;
                                (cAlias)->UA_XHRENV,;
                                IIf((cAlias)->FORMASDEL > 0, 'SIM', 'NÃO') })

        (cAlias)->(dbskip())
        End
        
        (cAlias)->(dbCloseArea())
        
        if len(aOrcFila) == 0
            AAdd(aOrcFila, {"","","","","","","",CTOD(""),"","",CTOD(""),"","",""})
        endif

        oBrwInf:SetArray(aOrcFila)
   
        oBrwInf:bLine := {|| {   aOrcFila[oBrwInf:nAt,01],;
                                 alltrim(U_RETDESCFI(aOrcFila[oBrwInf:nAt,02])) ,; 
                                 aOrcFila[oBrwInf:nAt,03] ,;
                                 aOrcFila[oBrwInf:nAt,04] ,;
                                 aOrcFila[oBrwInf:nAt,05] ,;
                                 aOrcFila[oBrwInf:nAt,06] ,;
                                 aOrcFila[oBrwInf:nAt,07] ,;
                                 aOrcFila[oBrwInf:nAt,08] ,;
                                 aOrcFila[oBrwInf:nAt,09] ,;
                                 aOrcFila[oBrwInf:nAt,10] ,;
                                 aOrcFila[oBrwInf:nAt,11] ,;
                                 aOrcFila[oBrwInf:nAt,12] ,;
                                 aOrcFila[oBrwInf:nAt,13] ,;
                                 aOrcFila[oBrwInf:nAt,14] ;
                                                           }}
        
        oBrwInf:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} AltAtend
Description //Função responsavel pela alteração do atendente
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function AltAtend(aCols)

    Local oButton1 
    Local oButton2 
    Local oTComboBox 
    Local cCombo := ""
    Local oGet1
    Local cGet1 := aCols[4]
    Local oGroup1
    Local oSay1
    Local oSay2
    Local oSay3
    Local cAltOpeCred := SuperGetMV("KH_ALTOPCR",.F.,"000778|001041")
    Local GrpCred := SuperGetMV("MV_KOGRPLB",.F.,"000000")
    Local aUsersCod := separa(GrpCred,"|")
    Local aUsersCred := {}
    Local lOk := .F.

    Static oDlg

    if Empty(alltrim(aCols[2]))
        Return
    endif

    if !(Alltrim(__cUserId) $ cAltOpeCred)
        Return
    endif

    for nx := 1 to len(aUsersCod)
        aAdd(aUsersCred,usrRetName(aUsersCod[nx]))
    next nx

    aUsersCred := aSort(aUsersCred, , , {|x,y| x < y})

    DEFINE MSDIALOG oDlg TITLE "KOMFORT HOUSE" FROM 000, 000  TO 160, 335 COLORS 0, 16777215 PIXEL

        @ 001, 002 GROUP oGroup1 TO 077, 166 PROMPT "  Alterar Atendente  " OF oDlg COLOR 0, 16777215 PIXEL
        @ 012, 010 SAY oSay1 PROMPT "Deseja Alterar o Atendente do orçamento: "+ aCols[5] SIZE 125, 010 OF oDlg COLORS 180, 16777215 PIXEL
        @ 025, 010 SAY oSay2 PROMPT "De :" SIZE 013, 007 OF oDlg COLORS 0, 16777215 PIXEL
        @ 023, 029 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
        @ 038, 010 SAY oSay3 PROMPT "Para :" SIZE 016, 007 OF oDlg COLORS 0, 16777215 PIXEL
       
        oTComboBox := TComboBox():New(036,029,{|u|if(PCount()>0,cCombo:=u,cCombo)},aUsersCred,060,010,oDlg,,{||},,,,.T.,,,,,,,,,)
        oTComboBox:setCSS("QComboBox QAbstractItemView {selection-background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #4169E1, stop: 1 #ADD8E6);}")

        oButton1 := TButton():New( 062, 061, "Cancelar",oDlg,{|| oDlg:end() }, 047,12,,,.F.,.T.,.F.,,.F.,,,.F. )
        //oButton1:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #A52A2A; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FF0000, stop: 1 #FFA07A);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FFA07A, stop: 1 #FF0000);}")
        
        oButton2 := TButton():New( 062, 115, "Confirmar",oDlg,{|| lOk := .T., oDlg:end() }, 047,12,,,.F.,.T.,.F.,,.F.,,,.F. )
        //oButton2:setCSS("QPushButton{color: #FFFFFF; border: 1px solid #6B8E23; border-radius: 4px; background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #00FF7F);} QPushButton:pressed {background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #00FF7F, stop: 1 #008000);}")

    ACTIVATE MSDIALOG oDlg CENTERED

    if lOk
        
        if empty(alltrim(cCombo))
            Return(msgAlert("Nenhum operador foi selecionado!!"))
        endif

        dbSelectArea("SUA")
        SUA->(dbSetOrder(1))

        if SUA->(dbSeek(aCols[2]+aCols[5]))
            RecLock("SUA",.F.)
				SUA->UA_XATCRED := cCombo
			SUA->(Msunlock())
            
            processa( {|| fCarrItSup(), fCarrItInf() }, "Aguarde...", "Atualizando Dados...", .f.) 
        endif
        
        SUA->(dbCloseArea())
    endif
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSetOrder
Description //Ordenação da coluna Orçamento
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 26/11/2018 /*/
//--------------------------------------------------------------
Static Function fSetOrder(iCol)

    if iCol == 4
        if cOrder == "decrescente"
            oBrwInf:aarray := aSort(oBrwInf:aarray, , , {|x,y| x[iCol] > y[iCol]})
            cOrder := "crescente"
        else
            oBrwInf:aarray := aSort(oBrwInf:aarray, , , {|x,y| x[iCol] < y[iCol]})
            cOrder := "decrescente"
        endif
        
        oBrwInf:Refresh()
    endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 07/12/2018 /*/
//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array)

    Do Case

        Case nColuna == 1 //Legenda
        	fLegenda()
        Case nColuna == 2 //Filial
        	
        Case nColuna == 3 //Status Credito
            fPegaPro(_array)
        Case nColuna == 4 //Atend. Credito
            AltAtend(_array)
        Case nColuna == 5 //Atendimento
            processa( {|| fCondPagto(_array) }, "Aguarde...", "Localizando formas de pagamento...", .f.)
        Case nColuna == 6 //Cod Cliente
        	processa( {|| fInfCliente(_array) }, "Aguarde...", "Localizando cliente...", .f.)
        Case nColuna == 7 //Loja

        Case nColuna == 8 //Nome Cliente
        
        Case nColuna == 9 //Data

        Case nColuna == 10 //Vendedor

        Case nColuna == 11 //Nome Vendedor

        Case nColuna == 12 //Data Env. P/ Credito
        
        Case nColuna == 13 //Hora Env. P/ Credito

    EndCase

Return


Static Function fInfCliente(_array)

    local aArea := getArea()
    Local cResumo := ''
    Local aFormas := {}
    Local nTotal   := 0
    Local nTotbol  := 0
    Local nTotdin  := 0
    Local nTotcd   := 0
    Local nTotcc   := 0
    Local nTotchk  := 0
    Local nParc    := 0 
    Private aCpos := {  "A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3",;
    					"A1_CONTATO","A1_EMAIL","A1_COMPLEM","A1_NOME","A1_NREDUZ","A1_XHISTCR","A1_XFILMAT",;
    					"A1_XNTRAB","A1_XENDTRB","A1_XDTADM","A1_XCARGO","A1_XVLRSAL","A1_XDDDTC","A1_XTELCML","A1_XNRAMAL",;
    					"A1_DDDTELR","A1_XTELREC","A1_XCNTREC","A1_XHISTCR","A1_DDDTR1","A1_TELREC1","A1_DDDTR2",;
    					"A1_TELREC2","A1_XSCOR","A1_XPASPC","A1_XQTRES","A1_XVLTRE","A1_XOCUPA","A1_XNATUR","A1_XNONJG ",;
    					"A1_XCPFJG","A1_XCARJG","A1_XADMJG","A1_XSALJG","A1_XNEMJG","A1_XDDDJG","A1_XFONJG","A1_XDDDCJG",;
    					"A1_FOEMJG","A1_XPAREC","A1_XAUTJG","A1_CGC","A1_DTNASC","A1_XCPFJU","A1_DDDSPC3","A1_TELSCP3","A1_XINADIN","A1_ENDENT",;
    					"A1_XIDADE","A1_XESTCIV","A1_XNOMERC","A1_XCPFRC","A1_XGPARRC","A1_XDDDRC","A1_XTELRC","A1_XEMPRC","A1_XDTARC",;
    					"A1_XCARGRC","A1_XDDDERC","A1_XTEMPRC","A1_XHOLER","A1_XCBANC","A1_XCENDER","A1_XDOCPES","A1_XIMPREN","A1_XENDGO",;
    					"A1_XENDSPC","A1_XANCRED","A1_XDANALI","A1_BAIRROE","A1_COMPENT","A1_01MUNEN","A1_MUNE","A1_ESTE","A1_CEPE","A1_PFISICA",;
                        "A1_RENCOM","A1_DTNCOM","A1_TELSPC","A1_CNPJEMP","A1_SCREMP","A1_XTEMLR","A1_XMORADI","A1_XSCRCON"}
                        
	Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"
    
    dbSelectArea("SL4")
    SL4->(dbSetOrder(1)) //L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_
    
    if SL4->(dbSeek(_array[2]+_array[5]))
        while SL4->L4_FILIAL+SL4->L4_NUM == _array[2]+_array[5]
            AAdd(aFormas, {SL4->L4_NUM,SL4->L4_DATA,SL4->L4_VALOR,SL4->L4_FORMA,SL4->L4_OBS,SL4->L4_XPARC})
            nTotal += SL4->L4_VALOR
            SL4->( dbSkip() )
        end
    endif
    SL4->(dbCloseArea())
    
    For nx := 1 to Len(aFormas)
    	
    	If AllTrim(aFormas[nx][4]) == 'R$'
    		nTotdin += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CD'
    		nTotcd += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CC'
    		nTotcc += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'BOL'
    		nTotbol += aFormas[nx][3]
    		nParc := aFormas[nx][6]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CHK'
    		nTotchk += aFormas[nx][3]
    	EndIf
    	
    Next nx
    
    cResumo := 'Total: ' + cvalToChar(nTotal) + ' / '
    
    If nTotdin > 0
    	cResumo += 'R$: ' + cValToChar(nTotdin) + ' / '
    EndIf
    	
    If nTotbol > 0
      	cResumo += 'BOL: ' + cValToChar(nTotbol) + ' (' + cValToChar(nParc) + 'X) / '
    EndIF
      	
    If nTotcd > 0
    	cResumo += 'CD: ' + cValToChar(nTotcd) + ' / '
    EndIF
    	
    If nTotcc > 0
     	cResumo += 'CC: ' + cValToChar(nTotcc) + ' / '
    EndIf
    
    If nTotchk > 0
     	cResumo += 'CHK: ' + cValToChar(nTotchk) + ' / '
    EndIf
    
    SetKey(VK_F10, {|| U_KHTMK003(cResumo)})
    
    dbSelectArea("SA1")
    SA1->(dbSetOrder(1)) //A1_FILIAL, A1_COD, A1_LOJA, R_E_C_N_O_, D_E_L_E_T_
    
    if SA1->(dbSeek(xFilial()+_array[6]+_array[7]))
        AxAltera("SA1",SA1->(Recno()),4,,aCpos)
    endif

    restArea(aArea)

    SetKey(VK_F10, {||})
Return

Static Function fCondPagto(_array)

    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local oSay2 as object
    Local oGet2 as object
    Local cResumo  := ''
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal   := 0
    Local nTotbol  := 0
    Local nTotdin  := 0
    Local nTotcd   := 0
    Local nTotcc   := 0
    Local nTotchk  := 0
    Local nParc    := 0
    Local aFormas  := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)

    dbSelectArea("SL4")
    SL4->(dbSetOrder(1)) //L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_
    
    if SL4->(dbSeek(_array[2]+_array[5]))
        while SL4->L4_FILIAL+SL4->L4_NUM == _array[2]+_array[5]
            AAdd(aFormas, {SL4->L4_NUM,SL4->L4_DATA,SL4->L4_VALOR,SL4->L4_FORMA,SL4->L4_OBS,SL4->L4_XPARC})
            nTotal += SL4->L4_VALOR
            SL4->( dbSkip() )
        end
    endif
    
    SL4->(dbCloseArea())
     
    For nx := 1 to Len(aFormas)
    	
    	If AllTrim(aFormas[nx][4]) == 'R$'
    		nTotdin += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CD'
    		nTotcd += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CC'
    		nTotcc += aFormas[nx][3]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'BOL'
    		nTotbol += aFormas[nx][3]
    		nParc := aFormas[nx][6]
    	EndIf
    	
    	If AllTrim(aFormas[nx][4]) == 'CHK'
    		nTotchk += aFormas[nx][3]
    	EndIf
    	
    Next nx
    
    cResumo := 'Total: ' + cvalToChar(nTotal) + ' / '
    
    If nTotdin > 0
    	cResumo += 'R$: ' + cValToChar(nTotdin) + ' / '
    EndIf
    	
    If nTotbol > 0
      	cResumo += 'BOL: ' + cValToChar(nTotbol) + ' (' + cValToChar(nParc) + 'X) / '
    EndIF
      	
    If nTotcd > 0
    	cResumo += 'CD: ' + cValToChar(nTotcd) + ' / '
    EndIF
    	
    If nTotcc > 0
     	cResumo += 'CC: ' + cValToChar(nTotcc) + ' / '
    EndIf
    
    If nTotchk > 0
     	cResumo += 'CHK: ' + cValToChar(nTotchk) + ' / '
    EndIf
    
    DEFINE MSDIALOG oTela FROM 0,0 TO 600,900 TITLE "FORMAS DE PAGAMENTO" Of oMainWnd PIXEL
    
    oSay := TSay():New(280,010,{||'Valor Total:'},oTela,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet := TGet():New(279,080,{|u| If( PCount() == 0, nTotal, nTotal := u ) },oTela,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTotal",,,,lHasButton)    
    //                                     L  - A
    oSay2 := TSay():New(270,160,{||'Resumo das formas de Pagamento:'},oTela,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet2 := TGet():New(280,160,{|u| If( PCount() == 0, cResumo, cResumo := u ) },oTela,160, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cResumo",,,,lHasButton)
    
    
    oBrwForma := TwBrowse():New(005, 005, 445, 260,, {;
                                                    'Orçamento',;
                                                    'Vencimento',;
                                                    'Valor',;
                                                    'Forma',;
                                                    'Descrição',;
                                                    'Complemento';
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

    if len(aFormas) <= 0
        AAdd(aFormas, {"",ctod("//"),0,"","",""})
    endif
    
    //oBrwForma:SetArray(aFormas)
    //Everton Santos - 11/07/2019
    //Efetuada ordenação do grid de formas de pagamento por tipo e data. Número do ticket: 10540 
    oBrwForma:SetArray(aSort(aFormas, , , {|x, y| (x[4] < y[4]) .OR. x[4] == y[4] .AND. x[2] < y[2] }))
      
    
    oBrwForma:bLine := {|| ;
                            { aFormas[oBrwForma:nAt,01] ,; 
                              aFormas[oBrwForma:nAt,02] ,;
                              transform(aFormas[oBrwForma:nAt,03],"@E 999,999.99") ,;
                              aFormas[oBrwForma:nAt,04] ,;
                              alltrim(aFormas[oBrwForma:nAt,05]) ,;
                              aFormas[oBrwForma:nAt,06] ;
                            };
                        }
    
    oBrwForma:Refresh()

    ACTIVATE MSDIALOG oTela CENTERED

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Welligton Raul
@since 26/06/2018 /*/
//--------------------------------------------------------------
Static function fPegaPro(_array)

Local GrpCred	:= SuperGetMV("MV_KOGRPLB",.F.,"000000")

If MsgYesno("Deseja Assumir o atendimento?","Atendimento")
	if empty(alltrim(_array[4])) .and. Alltrim(__cUserId) $ GrpCred
			DbSelectArea("SUA")
			SUA->(DbSetOrder(1))//UA_FILIAL, UA_NUM, R_E_C_N_O_, D_E_L_E_T_
			If SUA->(DbSeek(_array[2]+_array[5]))
			RecLock("SUA",.F.)			
				SUA->UA_XATCRED := usrRetName(__cUserId)
				SUA->UA_XSTATUS := "2" //EM ATENDIMENTO
			SUA->(Msunlock())
			fCarrItInf()
			Else
			MsgAlert("Registro não encontrado")
			EndIf
	Else
	MsgAlert("Proposta em atendimento. Analista responsável: "+alltrim(_array[4])+".")
	endif
EndIf

Return

Static Function fLegenda()
    
    Local aLegenda := {}
     
    //Monta as legendas (Cor, Legenda)
    
    aAdd(aLegenda,{"BR_VERDE",      "Primeira Compra"})
    aAdd(aLegenda,{"BR_VERMELHO",   "Recompra"})
         
    //Chama a função que monta a tela de legenda
    BrwLegenda("Status Legenda", "Status Legenda", aLegenda) 
    
Return                                
