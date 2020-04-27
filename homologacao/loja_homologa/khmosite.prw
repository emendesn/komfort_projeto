#include 'protheus.ch'
#include 'parmtype.ch'

User function KHMOSITE()
    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cApro := "1"
    Private cFina := "2"
    Private cRepr := "3"
    Private aItens := {}
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




    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Monitor de Pedidos" Of oMainWnd PIXEL

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
Static Function fCarrTit()

    Local cAlias :=  getNextAlias()
    Local cQuery := ""
    Local aItens := {}
	Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Atendimento Planejado" --> Padrão
	Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Atendimento Pendente" --> Padrão
	Local oSt3 := LoadBitmap(GetResources(),'BR_VERDE') //"Atendimento Encerrado" --> Padrão
	Local oSt4 := LoadBitmap(GetResources(),'BR_PRETO') //"Atendimento Cancelado" --> Padrão
	Local oSt5 := LoadBitmap(GetResources(),'BR_AMARELO')  //"Em Andamento" --> Customizado Komfort
	Local oSt6 := LoadBitmap(GetResources(),'BR_LARANJA') //"Visita Tec" --> Customizado Komfort
	Local oSt7 := LoadBitmap(GetResources(),'BR_PINK') //"Devolucao" --> Customizado Komfort
	Local oSt8 := LoadBitmap(GetResources(),'BR_BRANCO') //"Retorno" --> Customizado Komfort
	Local oSt9 := LoadBitmap(GetResources(),'BR_VIOLETA')  //"Troca Aut" --> Customizado Komfort
	local oSt10 := LoadBitmap(GetResources(),'BR_CINZA') //"Compartilhamento" --> Padrão
    Local oSt11 := LoadBitmap(GetResources(),'BR_AZUL_CLARO')  // Email Fabricante --> Customizado Komfort
	Local oStatus 
	
	
	
	dbSelectArea("Z12")
	cQuery := " SELECT DISTINCT Z12_PEDERP AS PEDIDO_SITE, Z12_DTINC AS DATA_PV, Z12_HRINT AS HORA_PV, Z12_PRODUT AS CODKIT, "
	cQuery += " CASE WHEN C5_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,C5_NUM),'')='' THEN 'NÃO INTEGRADO' END    PEDIDO, "
	cQuery += " CASE WHEN C6_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,C6_NUM),'')='' THEN 'NÃO INTEGRADO' END  ITENS_PV, "
	cQuery += " CASE WHEN E1_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,E1_NUM),'')='' THEN 'NÃO INTEGRADO' END CT_RECEBER, "
	cQuery += " CASE WHEN E2_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,E2_NUM),'')='' THEN 'NÃO INTEGRADO' END   CT_PAGAR, "
	cQuery += " CASE WHEN UA_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,UA_NUM),'')='' THEN 'NÃO INTEGRADO' END  ORCAMENTO, "
	cQuery += " CASE WHEN UB_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,UB_NUM),'')='' THEN 'NÃO INTEGRADO' END  ITENS_ORC, "
	cQuery += " CASE WHEN L4_NUM <> '' THEN 'INTEGRADO' WHEN ISNULL(CONVERT(VARCHAR,L4_NUM),'')='' THEN 'NÃO INTEGRADO'  END     FOR_PAG "
	cQuery += " FROM Z12010(NOLOCK) Z12 "
	cQuery += " LEFT JOIN SC5010(NOLOCK) SC5 ON  Z12.Z12_PEDERP = SC5.C5_NUM  AND Z12.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SC6010(NOLOCK) SC6 ON SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SE1010(NOLOCK) SE1 ON SE1.E1_NUM = SC6.C6_NUM AND SE1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SE2010(NOLOCK) SE2 ON SE2.E2_NUM = SE1.E1_NUM AND SE2.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SUA010(NOLOCK) SUA ON SUA.UA_NUM = SC5.C5_NUMTMK AND SUA.UA_FILIAL = '0142' AND SUA.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SUB010(NOLOCK) SUB ON SUB.UB_NUM = SUA.UA_NUM AND SUB.UB_FILIAL = '0142' AND SUB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SL4010(NOLOCK) SL4 ON SL4.L4_NUM = SUB.UB_NUM AND SL4.L4_FILIAL = '0142' AND SL4.D_E_L_E_T_ = '' "
	

	
	
	
	PLSQuery(cQuery, cAlias)
	
	while (cAlias)->(!eof())
	
	 aAdd(aItens,{ oSt1 ,;	//1
						(cAlias)->PEDIDO_SITE ,;	//2
						(cAlias)->DATA_PV    ,;   //3
						(cAlias)->HORA_PV    ,;  //4
						(cAlias)->CODKIT     ,;  //5
						(cAlias)->PEDIDO     ,;	//6
	                    (cAlias)->ITENS_PV   ,;   //7
						(cAlias)->CT_RECEBER ,;	//7
						(cAlias)->CT_PAGAR   ,;	//8
						(cAlias)->ORCAMENTO  ,; 	//9
						(cAlias)->ITENS_ORC  ,; 	//10
						(cAlias)->FOR_PAG ;
						})	//11
						 						
	 (cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aItens) <= 0
	aAdd(aItens,{"","",ctod("//"),"","","","","","","","",""})
    endif
    
    
    oBrowse:SetArray(aItens)
    
    

    oBrowse:bLine := {|| {      aItens[oBrowse:nAt,01] ,;
        						aItens[oBrowse:nAt,02] ,;  
                                aItens[oBrowse:nAt,03] ,;
                                aItens[oBrowse:nAt,04] ,;
                                aItens[oBrowse:nAt,05] ,;
                                aItens[oBrowse:nAt,06] ,;
                                aItens[oBrowse:nAt,07] ,;
                                aItens[oBrowse:nAt,08] ,;
                                aItens[oBrowse:nAt,09] ,;
                                aItens[oBrowse:nAt,10] ,;
                                aItens[oBrowse:nAt,11] ,;
                                aItens[oBrowse:nAt,12] ;
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
        aItens[nLinha][2] := oOk
    else
        aItens[nLinha][2] := oNo
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
            aItens[nx][9] := cNumCtr
            aAdd(aGrava,{;
                        aItens[nx][14],; //RECNO
                        aItens[nx][9]}) //CTR
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
                cPara := alltrim(cPasta +"\"+ cvaltochar(aItens[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))

                //Verifico se ja existe o arquivo na pasta, e removo
                if File( cPasta +"\"+ cValToChar(aItens[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
                    if fErase(cPasta +"\"+ cValToChar(aItens[nLinha][14]) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
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

                aItens[nLinha][8] := "SIM"
                aAdd(aGrava,{;
                            aItens[nLinha][14],; //RECNO
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
		ZK8->(DbSeek(xFilial()+ aItens[nx][04]))
        //ZK8->(dbgoto( aItens[nx][04]))
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
	    if ZK8->(DbSeek(xFilial()+ aItens[nx][04]))
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


	



Static function fValSc6(cNum,cNumKit)

local cQuery := ""
Local cQryc6 := ""
Local cAliazkc := getNextAlias()
Local cAliaSc6 := getNextAlias()
local nRowsb1 :=  0
local nRowsC6 :=  0
Local nRet := 0

dbSelectArea("ZKC")
cQuery := " SELECT COUNT(B1_COD) AS QTDKIT FROM ZKC010 (NOLOCK)  ZKC INNER JOIN ZKD010 (NOLOCK) ZKD ON ZKD_FILIAL = ''  "
cQuery += " AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = '' INNER JOIN SB1010 (NOLOCK) SB1 ON B1_FILIAL = '  '  " 
cQuery += " AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = '' WHERE ZKC_FILIAL = '' AND ZKC_SKU= '"+cNumKit+"' AND ZKC.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery, cAliazkc)

while (cAliazkc)->(!eof())
	nRowsb1 := (cAlias)->(QTDKIT)
End

dbSelectArea("SC6")
cQryc6 := " SELECT  COUNT(C6_PRODUTO) AS PRODUTO FROM SC5010(NOLOCK) SC5 "
cQryc6 += " INNER JOIN SC6010(NOLOCK) SC6 ON C5_NUM = C6_NUM  "
cQryc6 += " WHERE C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_ = '' "


PLSQuery(cQryc6, cAliaSc6)

while (cAliaSc6)->(!eof())
		nRowsC6 := (cAlias)->(PRODUTO)
End
	
	if nRowsb1 == nRowsC6
		nRet := 1
	Else
		nRet := 2
	EndIf

(ZKC)->(DbCloseArea())	
(SC6)->(DbCloseArea())	
return nRet