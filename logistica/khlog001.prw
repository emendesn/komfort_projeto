#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"
#INCLUDE "MsOle.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} KHLOG001
Description //Painel de tapeçaria
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHLOG001()

    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cApro := "1"
    Private cFina := "2"
    Private cRepr := "3"
    Private aTapec := {}
    Private oTela, oPedidos 
    Private oPainel
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")

    Private oFilial
    Private cFil := CriaVar("E1_MSFIL", .F.)

    Private oPedido
    Private cPedido := CriaVar("E1_NUM", .F.)

    Private oEmissaoDe
    private dEmissaoDeDe := ctod('//')
    
    Private oEmissaoAt
    private dEmissaoAt := ctod('//')

    Private cPasta := "\formulario_tapecaria"
    Private cRaiz := GetSrvProfString("RootPath","")+cPasta



    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "PAINEL DE TAPEÇARIA" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif


    //PRODUTOS PENDENTES
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                'Pedido',;
                                                                'Cliente',;
                                                                'Data Emissao',;
                                                                'Filial',;
                                                                'Prod Especial',;
                                                                'Item PV',;
                                                                'Dec Especial',;
                                                                'Prod Original',;
                                                                'Desc Original',;                                                                
                                                                'Quantidade'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
        
    fCarrTit()
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .f.) })
   
   
   
    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()
	
    @  34, 05 Say  oSay Prompt 'Pedido'	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel Pixel
    @  44, 05 MSGet oPedido Var cPedido FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
   
    tButton():New(44,050,"&Anexo",oPainel,{|| fAnexo() },40,10,,,,.T.,,,,/*{|| }*/)
    tButton():New(44,100,"&formulario",oPainel,{|| fGerForm() },40,10,,,,.T.,,,,/*{|| }*/)
   
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
    Local cAnexo := "NÃO"
            
    cQuery := " SELECT Z15_NUMPV,A1_NOME,Z15_EMISSA,Z15_XFILIA,Z15_PRODES,Z15_ITEMPV,Z15_DESCPR,Z15_PRODOR,Z15_DESCOR,Z15_QTDVEN,Z15_ANEXO FROM Z15010(NOLOCK) Z15 "
    cQuery += " INNER JOIN SA1010(NOLOCK) A1 ON A1.A1_COD = Z15.Z15_CLIENT"
    cQuery += " WHERE Z15.D_E_L_E_T_ = ' '"
    cQuery += " AND Z15_TAPECA = '1' "  
    if !empty(cPedido)
    cQuery += " AND Z15_NUMPV = '"+cPedido+"'" 
    endif
    cQuery += " ORDER BY Z15_NUMPV "
    
    PLSQuery(cQuery, cAlias)

    aTapec := {}

    while (cAlias)->(!eof())

        aAdd(aTapec,{;      
        				oNo,;
                        (cAlias)->Z15_NUMPV,;
                        (cAlias)->A1_NOME,;
                        (cAlias)->Z15_EMISSA,;
                        (cAlias)->Z15_XFILIA,;
                        (cAlias)->Z15_PRODES,;
                        (cAlias)->Z15_ITEMPV,;
                        (cAlias)->Z15_DESCPR,;
                        (cAlias)->Z15_PRODOR,;
                        (cAlias)->Z15_DESCOR,;
                        (cAlias)->Z15_QTDVEN,;
                        (cAlias)->Z15_ANEXO;
                        })
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aTapec) == 0
        AAdd(aTapec, {oNo,""," ",CTOD("//"),"","","","","","","",""})
    endif

    oBrowse:SetArray(aTapec)

    oBrowse:bLine := {|| {   	aTapec[oBrowse:nAt,01] ,;  
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
                                aTapec[oBrowse:nAt,12] ;
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

    if oBrowse:AARRAY[nLinha][1]:CNAME == "LBNO"
        aTapec[nLinha][1] := oOk
    else
        aTapec[nLinha][1] := oNo
    endif

    oBrowse:refresh()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fAnexo
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static Function fAnexo()

    Local cCaminho := space(150)
    Local oDlg
    Local nOpc := 0
    Local aMark := {}
    Local lCopy := .F.
    Local aGrava := {}

    for nA := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nA][1]:CNAME == "LBOK"
            aAdd(aMark, "")
        endif
    next nA

    if len(aMark) > 1
        msgAlert("Não é possivel incluir mais de um formulario por linha.","Atenção")
        Return
    endif

    DEFINE MSDIALOG oDlg TITLE "Retorno de Solicitação Tapeçaria" From 0,0 To 10,50 

    //--Caminho para importar o Arquivo CSV
    oSayArq := tSay():New(05,07,{|| "Informe o local onde se encontra o arquivo para importação:"},oDlg,,,,,,.T.,,,200,80)
    oGetArq := TGet():New(15,05,{|u| If(PCount()>0,cCaminho:=u,cCaminho)},oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'cCaminho')
    oBtnArq := tButton():New(15,165,"Abrir",oDlg,{|| cCaminho := AlocDlgArq(cCaminho)},30,12,,,,.T.) //&Abrir...

    oBtnImp := tButton():New(060,060,"Importar",oDlg,{|| nOpc:=1,oDlg:End()},40,12,,,,.T.) //Importar
    oBtnCan := tButton():New(060,110,"Cancelar",oDlg,{|| nOpc:=0,oDlg:End()},40,12,,,,.T.) //Cancelar

    ACTIVATE MSDIALOG oDlg CENTERED

    if nOpc == 1
        for nx := 1 to len(oBrowse:AARRAY)
            if oBrowse:AARRAY[nx][1]:CNAME == "LBOK"
                nLinha := nx
                exit
            endif
        next nx
        
        if nLinha > 0  
        	if !EMPTY(aTapec[nLinha][02])
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
		                cPara := alltrim(cPasta +"\"+ alltrim(cvaltochar(aTapec[nLinha][02]+aTapec[nLinha][05])) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)))
		
		                //Verifico se ja existe o arquivo na pasta, e removo
		                if File( cPasta +"\"+ Alltrim(cValToChar(aTapec[nLinha][02]+aTapec[nLinha][05])) + substring(cCaminho,rat(".",cCaminho),len(cCaminho)) )
		                    if fErase(cPasta +"\"+ Alltrim(cValToChar(aTapec[nLinha][02]+aTapec[nLinha][05])) + substring(cCaminho,rat(".",cCaminho),len(cCaminho))) == -1
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
		
		                aAdd(aGrava,{;
		                            aTapec[nLinha][02]+aTapec[nLinha][05],; //RECNO
		                            alltrim(cRaiz + substr(cPara,rat("\",cPara),len(cPara)))}) //Caminho do arquivo
		               
		                           
		                        DbSelectArea('Z15')
								Z15->(DbSetOrder(1))//Z15_FILIAL+Z15_NUMPV+Z15_PRODES+Z15_ITEMPV
								If Z15->(DbSeek(xFilial()+aTapec[nLinha][02]+aTapec[nLinha][05]+aTapec[nLinha][06]))
									RecLock("Z15",.F.)
								Else
									RecLock("Z15",.T.)
								EndIf
								Z15->Z15_ANEXO := aGrava[1][2]
		                        Z15->(msUnlock())
		
		                oBrowse:refresh()
		            endif
		     Else
	             msgAlert("Não existe dados para anexar documento!!")
	             Return
             EndIf
        else
            msgAlert("Não existe registro selecionado!!")
            Return
        endif
    endif

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fShow
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static Function fShow()
    
    Local cTemp := GetTempPath()
    Local nLinha := 0

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][1]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    	DbSelectArea('ZK8')
    	SE1->(DbSetOrder(1))//Filial + cod cliente 
		ZK8->(DbSeek(xFilial()+ aTapec[nx][04]))
        //ZK8->(dbgoto( aTapec[nx][04]))
        //CpyS2TEx( <cOrigem>, <cDestino> )
        if CpyS2TEx(alltrim(Z15->Z15_ANEXO), alltrim(cTemp + substr(Z15->Z15_ANEXO,rat("\",Z15->Z15_ANEXO)+1,len(Z15->Z15_ANEXO))))
            
            ShellExecute("open",  alltrim(cTemp + substr(Z15->Z15_ANEXO,rat("\",Z15->Z15_ANEXO)+1,len(Z15->Z15_ANEXO))), "", "C:\", 1 )
        
        else
            msgAlert("Não foi possivel abrir o arquivo!!")
        endif
    else
        msgAlert("Não existe registro selecionado!!!")
    endif

return

//--------------------------------------------------------------
/*/{Protheus.doc} AlocDlgArq
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static Function AlocDlgArq(cArquivo)

    Local cType := "Arquivos .PDF|*.pdf|Arquivos .docx|*.docx| Arquivos .jpeg|*.jpeg| Arquivos .jpg|*.jpg| Arquivos .bmp|*.bmp| Arquivos .png|*.png|"
    Local cArquivo := cGetFile(cType, "Arquivos Imagem")

    If !Empty(cArquivo)
        cArquivo += Space(150-Len(cArquivo))
    Else
        cArquivo := Space(150)
    EndIf

Return cArquivo

//--------------------------------------------------------------
/*/{Protheus.doc} fInfCliente
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static Function fInfCliente()

	
	Local nLinha := 0
    local aArea := getArea()
    Private aCpos := {}
	Private cCadastro := "Cobranca - Visualização de Negociação"
   

    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][1]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx

    if nLinha > 0
    
	    dbSelectArea("ZK8")
	    ZK8->(DbSetOrder(1)) //ZK8_FILIAL,ZK8_CODCLI, R_E_C_N_O_, D_E_L_E_T_
	    ZK8->(DbGoTop())// Posiciona no primeiro registro 
	    if ZK8->(DbSeek(xFilial()+ aTapec[nx][04]))
	        AxVisual("ZK8",ZK8->(Recno()),4)
	    endif

	EndIf
    restArea(aArea)

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fGerForm
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 11/03/2019 /*/
//--------------------------------------------------------------

Static Function fGerForm()

Local cAlias 	:= CriaTrab(,.F.)
Local cPedido	:= ""
Local cCliente	:= ""
Local cLoja     := ""
Local dData		
Local cCodPad	:= ""
Local cDescPad	:= ""
Local cQtde  	:= ""
Local cCodEsp	:= ""
Local cDescEsp	:= ""
Local cFileSave	:= ''
Local nLastKey  := 0
Private cPathSrv	:= "\modelos\"
Private cPathTer	:= "c:\modelos\"
Private cArquivo 	:= "formulario2.dotx"
Private aItens	 	:= {}
Private aInfo       := {}
Private oWord 		:= Nil
       
//SUBSTITUIDO PELO FONTE KMFATR01

for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][1]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
next nx

if nLinha > 0

		IF !EMPTY(aTapec[nLinha][02])
			/*+--------------+
			| Cria Diretório |
			+----------------+*/
			MakeDir(Trim(cPathTer))
			
			If !File(cPathSrv+cArquivo) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
				MsgStop( "O arquivo não foi encontrado no Servidor.","Atenção" )
				Return
			EndIf
			
			/*+---------------------------------------------+
			| Apaga o arquivo caso já exista no diretório |
			+---------------------------------------------+*/
			If File(cPathTer+cArquivo)
				FErase(cPathTer+cArquivo)
			Endif
			
			CpyS2T(cPathSrv+cArquivo,cPathTer,.T.)
			
			If nLastKey == 27
				Return
			Endif
			
			
			cPedido	:= aTapec[nLinha][02]
			cCliente:= aTapec[nLinha][03]
			cLoja   := aTapec[nLinha][05]
			dData	:= aTapec[nLinha][04]	
			cCodPad	:= aTapec[nLinha][06]
			cDescPad := aTapec[nLinha][08] 
			cQtde  	:= aTapec[nLinha][11]
			cCodEsp	:= aTapec[nLinha][06]
			cDescEsp:= aTapec[nLinha][08]
			
			
			/*+---------------------------------------------+
			| Inicializa o Ole com o MS-Word 97 ( 8.0 )   |
			+---------------------------------------------+*/
			BeginMsOle()
			oWord := OLE_CreateLink()
			OLE_NewFile(oWord,cPathTer+cArquivo)
			
			OLE_SetDocumentVar(oWord, 'cPedido', cPedido )
			OLE_SetDocumentVar(oWord, 'cCliente', cCliente	)
			OLE_SetDocumentVar(oWord, 'cLoja', cLoja	)
			OLE_SetDocumentVar(oWord, 'dData', dData	)
			OLE_SetDocumentVar(oWord, 'cCodPad', cCodPad	)
			OLE_SetDocumentVar(oWord, 'cDescPad', cDescPad	)
			OLE_SetDocumentVar(oWord, 'cQtde', cQtde	)
			OLE_SetDocumentVar(oWord, 'cCodEsp', cCodEsp	)
			OLE_SetDocumentVar(oWord, 'cDescEsp', cDescEsp	)
			
			
			OLE_SetProperty( oWord, oleWdVisible,   .T. )
			OLE_UpDateFields(oWord)
			
			cFileSave := AllTrim(cPedido+cCliente)+Strzero(nZ,2)+".docx"
			OLE_SaveAsFile( oWord,cPathTer+cFileSave )
			
			OLE_CloseLink( oWord ) // Encerra link
			
			Sleep(2000)
			ShellExecute('Open',cPathTer+cFileSave,'','',1)
		ELSE
		MsgAlert("Não existe dados para imprimir")
		Return
		EndIf
Else
MsgAlert("Nenhuma Lina selecionada")
Return
EndIf

Return Nil	
