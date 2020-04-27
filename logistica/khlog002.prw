#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} KHLOG002
Description //Painel de Notas Cancela Subs
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHLOG002()

    Local aSize     := MsAdvSize()
    Local aButtons  := {}
    Private aNfTrans  := {}
    Private oTela, oPedidos 
    Private oPainel
    Private oBrowse
    Private cCadastro := "Notas de Devolução Cancela Substituí"

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "PAINEL DE NF DEVOLUCAO CS" Of oMainWnd PIXEL

    //fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(030,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(030,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif

    //PRODUTOS PENDENTES
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  'Numero',;
                                                                'Serie',;
                                                                'Filial',;
                                                                'Fornecedor',;
                                                                'Data Emissao',;
                                                                'Transmissao'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
        
    fCarrTit()
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .f.) })
   
   
   
    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } ,{ || oTela:End() },.F.,aButtons,,,,,,.F.,,)
    
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
    
        
   cQuery := CRLF + " SELECT F1_DOC AS NUMERO,F1_SERIE AS SERIE, M0.FILIAL AS FILIAL ,F1_FORNECE AS FORNECEDOR, F1_EMISSAO AS EMISSAO, F1_HORA,'PENDENTE' AS TRANSMISSAO  FROM "+RetSqlName('SF1')+" (NOLOCK) F1 "
   cQuery += CRLF + " INNER JOIN SM0010 (NOLOCK) M0 ON FILFULL = F1_FILIAL "
   cQuery += CRLF + " INNER JOIN "+RetSqlName('SFT')+" (NOLOCK) FT ON FT_FILIAL = F1_FILIAL AND FT_NFISCAL = F1_DOC AND FT_SERIE = F1_SERIE AND FT_CLIEFOR = F1_FORNECE  "
   cQuery += CRLF + " WHERE F1.D_E_L_E_T_ = '' "
   cQuery += CRLF + " AND F1_XCANSUB <> '' "
   cQuery += CRLF + " AND FT_CHVNFE = '' "

   PLSQuery(cQuery, cAlias)

   aNfTrans := {}

   while (cAlias)->(!eof())

        aAdd(aNfTrans,{;      
                        (cAlias)->NUMERO,;
                        (cAlias)->SERIE,;
                        (cAlias)->FILIAL,;
                        (cAlias)->FORNECEDOR,;
                        (cAlias)->EMISSAO,;
                        (cAlias)->TRANSMISSAO,;
                        })
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aNfTrans) == 0
        AAdd(aNfTrans, {""," "," ","",CTOD("//"),""})
    endif

    oBrowse:SetArray(aNfTrans)

    oBrowse:bLine := {|| {   	aNfTrans[oBrowse:nAt,01] ,;  
                                aNfTrans[oBrowse:nAt,02] ,;
                                aNfTrans[oBrowse:nAt,03] ,;
                                aNfTrans[oBrowse:nAt,04] ,;
                                aNfTrans[oBrowse:nAt,05] ,;
                                aNfTrans[oBrowse:nAt,06]}}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Return

