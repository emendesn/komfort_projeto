#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#include 'parmtype.ch'
#Include "ap5mail.ch"

//Colunas do pedido de compra
#DEFINE xMark 1
#DEFINE xPc 2
#DEFINE xCodPc 3
#DEFINE xItem 4
#DEFINE xPcEmissao 5
#DEFINE xDescri 6
#DEFINE xQtdPc 7
#DEFINE xArmazem 8
#DEFINE xFornec 9

//Colunas do pedido de vendas
#DEFINE xFil 2
#DEFINE xEmissaoPv 3
#DEFINE xPv 4
#DEFINE xCodPv 5
#DEFINE xDescriPv 6
#DEFINE xItemPv 7
#DEFINE xQtdPv 8
#DEFINE xLocalPv 9
#DEFINE xFornecPv 10

//--------------------------------------------------------------
/*/{Protheus.doc} KHCOM001
Description /Pedidos de compras X Pedidos de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 12/1103/20189 /*/
//--------------------------------------------------------------
User Function KHCOM001()

    Local aSize     := MsAdvSize() //TODO CORRIGIR ESSA LINHA
    Local aButtons  := {}                

    Private aPC := {}
    Private aPV := {}
    
    Private oTela, aPC, aPV
    Private oSpDiv

    Private oBrwPC
    Private oBrwPV

    Private oOk	 	:= LoadBitMap(GetResources(), "LBOK")
    Private oNo	 	:= LoadBitMap(GetResources(), "LBNO")

    Private oFornece
    Private cFornece := CriaVar("B1_PROC", .F.)
    
    Private oTransf
	Private cTransf:="S" // alterado por solicitação da equipe de compras - Marcio Nunes - 23/01/2020

    Private oLoja
    Private cLoja := CriaVar("B1_LOJPROC", .F.)

    Private oProduto
    Private cProduto := CriaVar("C6_PRODUTO", .F.)

    Private oEmissaoDe
    Private dEmissaoDe := CriaVar("C5_EMISSAO", .F.)

    Private oEmissaoAt
    Private dEmissaoAt := CriaVar("C5_EMISSAO", .F.)

    Private oDescri
    Private cDescricao := CriaVar("B1_DESC", .F.)

    Private oArmazem
    Private cArmazem := CriaVar("B1_LOCPAD", .F.)
    
    Private cCadastro := "Pedidos de Compras x Pedidos de Vendas"

    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

    fCarrParam()

    oPnlPC := TPanel():New(aSize[2]+30,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]-50,aSize[5]/2, .T., .F. )
    oPnlPV := TPanel():New(aSize[2]+30,aSize[3]/2,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]-50,aSize[5], .T., .F. )

    //Pedidos de compras
    oBrwPC := TwBrowse():New(003, 003, (aSize[3]/2)-2, aSize[4]-55,, {'','Pedido','Produto','Item','Emissão','Descrição','Quant','Armazem','Fornecedor'},,oPnlPC,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    oBrwPC:bLDblClick := {|| fMarc(oBrwPC:nAt, oBrwPC, aPC, xPc, .T.)  }
    fCarrPC()
    
    //Pedidos de vendas
    oBrwPV := TwBrowse():New(003, 003, aSize[3]/2, aSize[4]-55,, {'','Filial','Emissao','Pedido','Produto','Descricao','Item','Qtd Venda','Armazem','Fornecedor'},,oPnlPV,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    oBrwPV:bLDblClick := {|| fMarc(oBrwPV:nAt, oBrwPV, aPV, xPv, .F.)  }
    oBrwPV:bHeaderClick := {|o, iCol| fDefAction(iCol, oBrwPV, aPV, xPv)}
    fCarrPV()
    
    oBrwPC:nScrollType := 1
    oBrwPV:nScrollType := 1

    oBrwPC:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrPC(), fCarrPV() }, "Aguarde...", "Atualizando Dados...", .f.) })
    
    AAdd(aButtons,{	'',{|| fExcelPV(oBrwPV:aarray) }, "Excel PV's"} )
    AAdd(aButtons,{	'',{|| fExcelPC(oBrwPC:aarray) }, "Excel PC's"} )
    AAdd(aButtons,{	'',{|| U_KHPCPVR() }, "Necessidade PC"} )

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, {|| oTela:End() } , {|| oTela:End() },, aButtons)
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrParam
Description //Filtros e pârametros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 13/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrParam()

    @  34, 05 Say  oSay Prompt 'Fornecedor'	FONT oFont11 COLOR CLR_BLUE Size  32, 08 Of oTela Pixel
    @  44, 05 MSGet oFornece Var cFornece FONT oFont11 COLOR CLR_BLUE Pixel SIZE 14, 05 VALID {|| }  F3 "FOR" When .T. Of oTela 

    @  34, 40 Say  oSay Prompt 'Loja'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oTela Pixel
    @  44, 40 MSGet oLoja Var cLoja FONT oFont11 COLOR CLR_BLUE Pixel SIZE 10, 05 VALID {|| processa( {|| fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oTela 
    
    @  34, 70 Say  oSay Prompt 'Cod Produto'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oTela Pixel
    @  44, 70 MSGet oProduto Var cProduto FONT oFont11 COLOR CLR_BLUE Pixel SIZE 80, 05 VALID {|| processa( {|| fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.)} F3 "KHF3B1" When .T. Picture "@!" Of oTela 
    
    @  34, 155 Say  oSay Prompt 'Emissão de' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 155 MSGet oEmissaoDe Var dEmissaoDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrPV() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oTela 
    
    @  34, 210 Say  oSay Prompt 'Emissão ate' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 210 MSGet oEmissaoAt Var dEmissaoAt FONT oFont11 COLOR CLR_BLUE Pixel SIZE 50, 05 VALID {|| processa( {|| fCarrPV() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Of oTela 

    @  34, 270 Say  oSay Prompt 'Descrição' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
    @  44, 270 MSGet oDescri Var cDescricao FONT oFont11 COLOR CLR_BLUE Pixel SIZE 80, 05 VALID {|| processa( {|| fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.) } When .T. Picture "@!" Of oTela 
    

	@  34, 360 Say  oSay Prompt 'Armazem' FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oTela Pixel
	@  44, 360 MSGet oArmazem Var cArmazem FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {||fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.) } F3 "NNR" When .T. Picture "@!" Of oTela

	@  34, 400 Say  oSay Prompt 'Cons.Transf.?' FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oTela Pixel
	@  44, 400 MSGet oTransf Var cTransf FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {||fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.) } F3 "NNR" When .T. Picture "@!" Of oTela

	tButton():New(44,450,"&Vincular",oTela,{|| fVincula() },40,10,,,,.T.,,,,/*{|| }*/)
	tButton():New(44,500,"&Gerar PC",oTela,{|| processa( {|| fGerPc() }, "Aguarde...", "Gerando pedido de compras...", .f.) },40,10,,,,.T.,,,,/*{|| }*/)
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fDefAction
Description //Função responsavel por difinir a ação dependendo da coluna
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fDefAction(nColuna, oObj, aArrayUsed, nOption)

    Do Case
	    Case nColuna == xMark
            fMarcAll(oObj, aArrayUsed, nOption)
        Case nColuna == xEmissaoPv
            oBrwPV:aarray := aSort(oBrwPV:aarray, , , {|x,y| x[nColuna] < y[nColuna]})
            oBrwPV:refresh()
    endCase

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarc
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fMarc(nLinha, oObj, aArrayUsed, nOption, lVincula)

    Local nPos := 0
    default lVincula := .F.
    
    if lVincula .and. oObj:AARRAY[nLinha][xMark]:CNAME == "LBNO"
        for nx := 1 to len(oBrwPC:AARRAY)
            if oObj:AARRAY[nx][xMark]:CNAME <> "LBNO"
                alert("Ja existe registros selecionados...")
                return
            endif
        next nx
    endif

    if oObj:AARRAY[nLinha][xMark]:CNAME == "LBNO"
        if !empty(aArrayUsed[nLinha][nOption])
            aArrayUsed[nLinha][xMark] := oOk

             if lVincula
                nPos := aScan(oBrwPV:AARRAY ,{|x|alltrim(x[xCodPv]) == alltrim(oBrwPC:AARRAY[nLinha][xCodPc]) .and. x[xQtdPv] == oBrwPC:AARRAY[nLinha][xQtdPc] }) 
                    
                if nPos > 0
                    if aPV[nPos][xMark]:CNAME == "LBNO"
                        aPV[nPos][xMark] := oOk
                    endif
                    
                    oBrwPV:refresh()
                else
                    aArrayUsed[nLinha][xMark] := oNo
                    alert("Não foi encontrado referencias para o Produto e Quantidade Selecionado.")
                    return
                endif
            endif

        endif
    else
        if !empty(aArrayUsed[nLinha][nOption])
            aArrayUsed[nLinha][xMark] := oNo

            if lVincula
                nPos := aScan(oBrwPV:AARRAY ,{|x|alltrim(x[xCodPv]) == alltrim(oBrwPC:AARRAY[nLinha][xCodPc]) .and. x[xQtdPv] == oBrwPC:AARRAY[nLinha][xQtdPc] }) 
                
                if nPos > 0
                    aPV[nPos][xMark] := oNo
                endif

                oBrwPV:refresh()

            endif

        endif
    endif

    oBrwPC:nScrollType := 1
    oBrwPV:nScrollType := 1

    oObj:refresh()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fMarcAll
Description //Marca todos os registros
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 27/02/2019 /*/
//--------------------------------------------------------------
Static Function fMarcAll(oObj, aArrayUsed, nOption)

    for nx := 1 to len(oObj:AARRAY)
        if oObj:AARRAY[nx][xMark]:CNAME == "LBNO"
            if !empty(aArrayUsed[nx][nOption])
                aArrayUsed[nx][xMark] := oOk
            endif
        else
            if !empty(aArrayUsed[nx][nOption])
                aArrayUsed[nx][xMark] := oNo
            endif
        endif
    next nx

    oObj:refresh()
    oBrwPC:setFocus()
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrPC
Description //Carrega itens do painel Superior - Reanalise *Prioridades
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrPC()
    
    Local cAlias := getNextAlias()
    Local cQuery := ""
    Local cStatus := ""

    cQuery := " SELECT C7_NUM, C7_PRODUTO, C7_ITEM, C7_EMISSAO, C7_DESCRI ,C7_QUANT, C7_LOCAL, C7_FORNECE"
    cQuery += " FROM "+ retSqlName("SC7") +" SC7"
    cQuery += " INNER JOIN "+ retSqlName("SB1") +" SB1 ON SC7.C7_PRODUTO = SB1.B1_COD"
    cQuery += " WHERE (C7_01NUMPV = '000000' OR C7_01NUMPV = '')"
    cQuery += " AND SC7.D_E_L_E_T_ = ' '"
    cQuery += " AND SB1.D_E_L_E_T_ = ' '"
    cQuery += " AND C7_RESIDUO <> 'S'"
    cQuery += " AND C7_QUJE = 0"
    cQuery += " AND B1_XENCOME = '2'"
    cQuery += " AND B1_TIPO = 'ME'"
    
    if !empty(alltrim(cProduto))
        cQuery += " AND C7_PRODUTO = '"+ cProduto +"'"
    endif

    if !empty(alltrim(cFornece))
        cQuery += " AND C7_FORNECE = '"+ cFornece +"'"
    endif
    
    if !empty(alltrim(cLoja))
        cQuery += " AND C7_LOJA = '"+ cLoja +"'"
    endif

    if !empty(alltrim(cArmazem))
        cQuery += " AND C7_LOCAL = '"+ cArmazem +"'"+CRLF
    endif
    
    cQuery += " ORDER BY C7_NUM, C7_ITEM"
    
    PLSQuery(cQuery, cAlias)

    aPC := {}

    while (cAlias)->(!eof())
        
        aAdd(aPC,{  oNo,; 
                    (cAlias)->C7_NUM,;
                    (cAlias)->C7_PRODUTO,;
                    (cAlias)->C7_ITEM,;
                    (cAlias)->C7_EMISSAO,;
                    alltrim((cAlias)->C7_DESCRI),;
                    (cAlias)->C7_QUANT,;
                    (cAlias)->C7_LOCAL,;
                    (cAlias)->C7_FORNECE;
                    })

    (cAlias)->(dbskip())
    End
    
    (cAlias)->(dbCloseArea())
    
    if len(aPC) == 0
        AAdd(aPC, {"LBNO","","","",CTOD(""),"",0,"",""})
    endif

    oBrwPC:SetArray(aPC)

    oBrwPC:bLine := {|| {   aPC[oBrwPC:nAt,01] ,; 
                            aPC[oBrwPC:nAt,02] ,; 
                            aPC[oBrwPC:nAt,03] ,;
                            aPC[oBrwPC:nAt,04] ,;
                            aPC[oBrwPC:nAt,05] ,;
                            aPC[oBrwPC:nAt,06] ,;
                            aPC[oBrwPC:nAt,07] ,;
                            aPC[oBrwPC:nAt,08] ,;
                            aPC[oBrwPC:nAt,09] ;
                            }}
    
    
    oBrwPC:nScrollType := 1

    oBrwPC:Refresh()
    oBrwPC:setFocus()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrPV
Description //Carrega os pedidos de venda
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrPV()

    Local cAlias := getNextAlias()
    Local cQuery := "" 
    Local cStatus := ""

    cQuery := "SELECT DISTINCT C6_MSFIL,C5_EMISSAO,C5_NUM,C6_PRODUTO,B1_DESC,C6_ITEM,C6_QTDVEN,C6_LOCAL,B1_PROC"+CRLF
    cQuery += " FROM "+ retSqlName("SC6") +" SC6 (NOLOCK) "+CRLF
    cQuery += " INNER JOIN "+ retSqlName("SC5") +" SC5 (NOLOCK) ON SC5.C5_MSFIL = SC6.C6_MSFIL"+CRLF
    cQuery += " AND SC5.C5_NUM = SC6.C6_NUM"+CRLF
    cQuery += " LEFT JOIN "+ retSqlName("SC9") +" SC9 (NOLOCK) ON SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC9.D_E_L_E_T_ = ''"+CRLF
    cQuery += " INNER JOIN "+ retSqlName("SB1") +" SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD"+CRLF
    //cQuery += " LEFT JOIN "+ retSqlName("SC7") +" SC7 ON SC6.C6_NUM = SC7.C7_01NUMPV AND SC6.C6_PRODUTO = SC7.C7_PRODUTO AND SC6.D_E_L_E_T_ = ' ' AND C7_NUM IS NULL AND C7_RESIDUO <> 'S' "+CRLF
    cQuery += " WHERE SC6.D_E_L_E_T_ = ' '	"+CRLF
    cQuery += " AND SC5.D_E_L_E_T_ = ' '	"+CRLF
    cQuery += " AND C6_BLQ <> 'R' "+CRLF
    cQuery += " AND C6_RESERVA = ' ' "+CRLF
    cQuery += " AND SB1.D_E_L_E_T_ = ' ' "+CRLF
    
    if !empty(alltrim(cProduto))
        cQuery += " AND C6_PRODUTO = '"+ cProduto +"'	"+CRLF
    endif

    if !empty(alltrim(cArmazem))
        cQuery += " AND C6_LOCAL = '"+ cArmazem +"'"+CRLF
    endif
    //Alterado Vanito - Para tratar as transferencias de Loja.
    If cTransf=="N"
	
		cQuery += "AND SC6.C6_TES <> '602'"
	
	Endif
    
    
    
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
    cQuery += " AND B1_TIPO <> 'MC'"+CRLF
    
    if !empty(alltrim(cFornece))
        cQuery += " AND B1_PROC = '"+ cFornece +"'"+CRLF
        cQuery += " AND B1_LOJPROC = '"+ cLoja +"'	"+CRLF
    endif
    
    if !empty(alltrim(cDescricao))
        cQuery += " AND B1_DESC LIKE '%"+ alltrim(cDescricao) +"%'"+CRLF
    endif

    if !empty(dtos(dEmissaoDe))
        cQuery += " AND SC5.C5_EMISSAO >= '"+ dtos(dEmissaoDe) +"'"+CRLF
    endif
    
    if !empty(dtos(dEmissaoAt))
        cQuery += " AND SC5.C5_EMISSAO <= '"+ dtos(dEmissaoAt) +"'"+CRLF
    endif
    
    //cQuery += " AND SC5.C5_NUM NOT IN (SELECT C7_01NUMPV FROM SC7010 WHERE C7_01NUMPV = C5_NUM AND D_E_L_E_T_ = ' ' AND C7_RESIDUO <> 'S' )"
    //Rotina alterada para trazer os dados por item. Utilizando a SC5 não era apresentado na query os produtos quando temos dois fornecedores diferentes no mesmo pedido.
    //Marcio Nunes - 22/08/2019 - Chamado: 11540
	cQuery += " AND C6_NUM NOT IN (SELECT C7_01NUMPV FROM SC7010 WHERE C7_01NUMPV = C6_NUM "+CRLF	
    
    cQuery += " AND C6_PRODUTO=C7_PRODUTO AND D_E_L_E_T_ = ' ' AND C7_RESIDUO <> 'S' AND (C7_XNUMPVI = C6_ITEM OR C7_XNUMPVI='ZZ') )"+CRLF //99 garante que não vai aparecer o passado

    cQuery += " ORDER BY C5_EMISSAO, C5_NUM, C6_ITEM"                       

    //MemoWrite( "C:\spool\khcom001.txt", cQuery )

    PLSQuery(cQuery, cAlias)

    aPV := {}

    while (cAlias)->(!eof())
        
        aAdd(aPV,{      oNo,;
                        alltrim(U_RETDESCFI((cAlias)->C6_MSFIL)),;
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
    
    if len(aPV) == 0
        AAdd(aPV, {oNo,"",CTOD(""),"","","","",0,"",""})
    endif

    oBrwPV:SetArray(aPV)

    oBrwPV:bLine := {|| {    aPV[oBrwPV:nAt,01] ,; 
                                aPV[oBrwPV:nAt,02] ,;
                                aPV[oBrwPV:nAt,03] ,;
                                aPV[oBrwPV:nAt,04] ,;
                                aPV[oBrwPV:nAt,05] ,;
                                aPV[oBrwPV:nAt,06] ,;
                                aPV[oBrwPV:nAt,07] ,;
                                aPV[oBrwPV:nAt,08] ,;
                                aPV[oBrwPV:nAt,09] ,;
                                aPV[oBrwPV:nAt,10] ;
                            }}
    
    oBrwPC:nScrollType := 1
    oBrwPV:nScrollType := 1

    oBrwPV:Refresh()
    oBrwPC:setFocus()

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fVincula
Description //Realiza o vinculo automatico do pedido de vendas com p pedidos de compras
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 15/03/2019 /*/
//--------------------------------------------------------------
Static Function fVincula()
    
    Local nPosPC := aScan(oBrwPC:AARRAY ,{|x|alltrim(x[xMark]:CNAME ) == "LBOK"})
    Local nPosPV := aScan(oBrwPV:AARRAY ,{|x|alltrim(x[xMark]:CNAME ) == "LBOK"}) 
    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local nStatus := 0

    if nPosPC == 0
        msgAlert("Pedido de compras não selecionado.","Atenção")
        Return
    endif

    if nPosPV == 0
        msgAlert("Pedido de Vendas não selecionado.","Atenção")      
        Return
    endif
    
    cQuery := "SELECT * FROM "+ retSqlName("SC7")
    cQuery += " WHERE C7_NUM = '"+oBrwPC:AARRAY[nPosPC][xPc]+"'"
    cQuery += " AND C7_ITEM = '"+oBrwPC:AARRAY[nPosPC][xItem]+"'"
    cQuery += " AND (C7_XNUMPVI ='' OR C7_XNUMPVI='ZZ') AND D_E_L_E_T_ = ''" //C7_XNUMPVI ='', mostra somente se o item (do pedido de vendaas) não está preenchido no pedido de compras - Marcio Nunes                                 
                                    
    PLSQuery(cQuery, cAlias)

    if (cAlias)->(!eof())
                                                                                                        //grava o item do pedido de compras para manter o relacionamento no select da tela de pedidos
        cUpdate := "UPDATE "+ retSqlName("SC7") +" SET C7_01NUMPV = '"+ oBrwPV:AARRAY[nPosPV][xPv] +"', C7_XNUMPVI = '"+ oBrwPV:AARRAY[nPosPV][xItemPv] +"'"
        cUpdate += " WHERE C7_NUM = '"+oBrwPC:AARRAY[nPosPC][xPc]+"'"
        cUpdate += " AND C7_ITEM = '"+oBrwPC:AARRAY[nPosPC][xItem]+"'"
        cUpdate += " AND D_E_L_E_T_ = ''"

        nStatus := TcSqlExec(cUpdate)
					
        if (nStatus < 0)
            msgAlert("Erro ao executar o update: " + TCSQLError())
            return
        endif	
     
        apMsgInfo("Pv "+ oBrwPV:AARRAY[nPosPV][xPv] +" vinculado ao Pedido de compras "+ oBrwPC:AARRAY[nPosPC][xPc]+".","SUCCESS")
                
        oBrwPC:setFocus()
        processa( {|| fCarrPV(), fCarrPC() }, "Aguarde...", "Atualizando Dados...", .F.)
    else
        msgAlert("Pedido de compras não Encontrado.","")
        Return
    endif
    
    (cAlias)->(dbCloseArea())

Return


Static Function fGerPc()
    
    Local AItensPc := {}
    Private lMsErroAuto := .F.

    if empty(alltrim(cFornece))
        return(msgAlert("Por favor utilize o filtro de fornecedor..","Atenção"))
    endif

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	
    for nx := 1 to len(oBrwPV:AARRAY)
        if oBrwPV:AARRAY[nx][xMark]:CNAME == "LBOK"
            aAdd(AItensPc,{;
                            oBrwPV:aarray[nx][xFornecPv],;  // 1 - fornecedor
                            oBrwPV:aarray[nx][xQtdPv],;     // 2 - quantidade
                            FPreco(oBrwPV:aarray[nx][xCodPv]),; // 3 - Preço
                            oBrwPV:aarray[nx][xQtdPv] * FPreco(oBrwPV:aarray[nx][xCodPv]),; // 4 - preço total
                            oBrwPV:aarray[nx][xPv],; // 5 - numero do pv
                            oBrwPV:aarray[nx][xCodPv],; // 6 - Codigo
                            oBrwPV:aarray[nx][xItemPv]; // 7 - Codigo
                            })         
        endif
    next
	
    if len(AItensPc) > 0        

		aCabec	:= {}
		aItens	:= {}
		_prcPC	:= 0
		_cNumPC	:= GETNUMSC7()
		
        dbSelectArea("SA2")
        SA2->(DbSetOrder(1))
        
        if SA2->(dbSeek(xFilial() + AItensPc[1][1] + "01"))
            _cCond	:= SA2->A2_COND
        else
            alert("Condição de pagamento não identificada")
            Return
        endif
				
		aadd(aCabec,{"C7_EMISSAO"	,dDataBase})
		aadd(aCabec,{"C7_FORNECE"	,AItensPc[1][1]})
		aadd(aCabec,{"C7_LOJA"		,"01"})
		aadd(aCabec,{"C7_COND"		,IIF(alltrim(_cCond)=="","001",_cCond)})
		aadd(aCabec,{"C7_CONTATO"	,"AUTO"})
		aadd(aCabec,{"C7_FILENT"	,cFilAnt})
		aadd(aCabec,{"C7_NUM"		,_cNumPC})
			
		for nx := 1 to len(AItensPc)

			aLinha := {}
				
			aadd(aLinha,{"C7_PRODUTO"	,AItensPc[nx][6]                    ,Nil})
			aadd(aLinha,{"C7_QUANT"		,AItensPc[nx][2] 					,Nil})
			aadd(aLinha,{"C7_PRECO"		,AItensPc[nx][3]					,Nil})
			aadd(aLinha,{"C7_TOTAL"		,AItensPc[nx][4]					,Nil})
			aadd(aLinha,{"C7_OBS"		,"PEDIDO EXCEL "+ AItensPc[nx][5]   ,Nil})			
			aadd(aLinha,{"C7_TES"		,"050"								,Nil})
			aadd(aLinha,{"C7_01NUMPV"	,AItensPc[nx][5]				    ,Nil})
			aadd(aLinha,{"C7_XNUMPVI"	,AItensPc[nx][7]				    ,Nil})//GRAVA O ITEM DO PEDIDO DE COMPRAS NA GERAÇÃO DO PC			
				
			aadd(aItens,aLinha)
				
		next nx
		
		MATA120(1,aCabec,aItens,3)
		
		If !lMsErroAuto
			apMsgInfo("Pedido: " + _cNumPC + " Gerado com Sucesso.","SUCCESS")
            fCarrPV()
            processa( {|| fMailNotif(_cNumPC) }, "Aguarde...", "Enviando email de notificação...", .f.)
		Else
			ConOut("Erro na inclusao!")
			MostraErro()
		EndIf
		
	Endif
		
Return

//--------------------------------------------------------------
/*/{Protheus.doc} FPreco
Description //Retorna o preço do produto.
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/03/2019 /*/
//--------------------------------------------------------------
Static Function FPreco(cCod)

    Local nPreco := 0

    dbSelectArea("SB1")
    SB1->(dbGoTop())

    if SB1->(dbSeek(xFilial("SB1") + cCod))
        nPreco := SB1->B1_01CUSTO
    endIf

Return nPreco


//--------------------------------------------------------------
/*/{Protheus.doc} fMailNotif
Description //Monta o corpo de email
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/03/2019 /*/
//--------------------------------------------------------------
Static Function fMailNotif(cNumPc)

    Local lEnvia := .F.
    Local cHtml := ""
    Local cPara := u_EmailUsr(UsrRetName(__cUserId))//"alexis.duarte@komforthouse.com.br"
    Local cAlias := getNextAlias()
    Local cQuery := ""
    
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

    cHtml += "    <p>Segue abaixo pedido de compras gerado pela rotina automatica.</p>" 

    cHtml += "    <table style='width:100%'>" 
    cHtml += "      <tr>" 
    cHtml += "         <th>Ped. Compras </th>" 
    cHtml += "         <th>Item</th>" 
    cHtml += "         <th>Produto</th>" 
    cHtml += "         <th>Descrição</th>" 
    cHtml += "         <th>Quantidade</th>" 
    cHtml += "         <th>Preço</th>" 
    cHtml += "         <th>Valor Total</th>" 
    cHtml += "         <th>Fornecedor</th>" 
    cHtml += "      </tr>" 
    
    cQuery := "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, C7_FORNECE
    cQuery += " FROM "+ retSqlName("SC7")
    cQuery += " WHERE C7_NUM = '"+ cNumPc +"'"
    cQuery += " AND D_E_L_E_T_ = ''"

    PLSQuery(cQuery, cAlias)

    while (cAlias)->(!eof())

        cHtml += "      <tr>" 
        cHtml += "        <td>"+ (cAlias)->C7_NUM +"</td>" 
        cHtml += "        <td>"+ (cAlias)->C7_ITEM +"</td>" 
        cHtml += "        <td>"+ (cAlias)->C7_PRODUTO +"</td>" 
        cHtml += "        <td>"+ (cAlias)->C7_DESCRI +"</td>" 
        cHtml += "        <td>"+ cValToChar((cAlias)->C7_QUANT) +"</td>" 
        cHtml += "        <td>"+ transform((cAlias)->C7_PRECO,"@E 999,999.99") +"</td>" 
        cHtml += "        <td>"+ transform((cAlias)->C7_TOTAL,"@E 999,999.99") +"</td>" 
        cHtml += "        <td>"+ (cAlias)->C7_FORNECE +"</td>" 
        cHtml += "      </tr>" 

        lEnvia := .T.
        (cAlias)->(dbskip())
    end

    cHtml += "    </table>" 
    
    cHtml += "    <p>Mensagem enviada automaticamente, não responder este email.</p>"         
    
    cHtml += "  </body>" 
    cHtml += "</html>" 

    cAssunto := "Pedido de compra gerado automaticamente"
    cMensagem := cHtml
    
    if lEnvia 
        processa( {|| u_sendMail( cPara, cAssunto, cMensagem ) }, "Aguarde...", "Enviando email para "+ cPara +"...", .F.)
    endif

return


//--------------------------------------------------------------
/*/{Protheus.doc} fExcelPV
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/03/2019 /*/
//--------------------------------------------------------------
Static Function fExcelPV(aItens)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "khcom001_PV_"+substr(time(), 7, 2)+".XLS"
	Local aCab := {}
    Local nx := 0
    Local cTitle := "Pedidos Venda"

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

    aAdd(aCab,{"Produto","C6_PRODUTO",PesqPict("SC6","C6_PRODUTO"),TamSX3("C6_PRODUTO")[1],TamSX3("C6_PRODUTO")[2],,"",TamSX3("C6_PRODUTO")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Emissao","C5_EMISSAO",PesqPict("SC5","C5_EMISSAO"),TamSX3("C5_EMISSAO")[1],TamSX3("C5_EMISSAO")[2],,"",TamSX3("C5_EMISSAO")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Pedido Venda","C5_NUM",PesqPict("SC5","C5_NUM"),TamSX3("C5_NUM")[1],TamSX3("C5_NUM")[2],,"",TamSX3("C5_NUM")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Produto","C6_PRODUTO",PesqPict("SC6","C6_PRODUTO"),TamSX3("C6_PRODUTO")[1],TamSX3("C6_PRODUTO")[2],,"",TamSX3("C6_PRODUTO")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Descrição","B1_DESC",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],TamSX3("B1_DESC")[2],,"",TamSX3("B1_DESC")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Item Pv","C6_ITEM",PesqPict("SC6","C6_ITEM"),TamSX3("C6_ITEM")[1],TamSX3("C6_ITEM")[2],,"",TamSX3("C6_ITEM")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Qty Pv","C6_QTDVEN",PesqPict("SC6","C6_QTDVEN"),TamSX3("C6_ITEM")[1],TamSX3("C6_QTDVEN")[2],,"",TamSX3("C6_QTDVEN")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Armazem","C6_LOCAL",PesqPict("SC6","C6_LOCAL"),TamSX3("C6_LOCAL")[1],TamSX3("C6_LOCAL")[2],,"",TamSX3("C6_LOCAL")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Fornecedor","B1_PROC",PesqPict("SB1","B1_PROC"),TamSX3("B1_PROC")[1],TamSX3("B1_PROC")[2],,"",TamSX3("B1_PROC")[3]	,"","","","",,'V',,,})
    
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
                                            aItens[nx][2],;
											aItens[nx][3],;
                                            aItens[nx][4],;
											aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            aItens[nx][9],;
                                            aItens[nx][10];
											},{1,2,3,4,5,6,7,8,9})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fExcelPV
Description //Imprime o Browse dos pedidos de compra
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos
@since 15/02/2020 /*/
//--------------------------------------------------------------
Static Function fExcelPC(aItens)

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "khcom001_PC_"+substr(time(), 7, 2)+".XLS"
	Local aCab := {}
    Local nx := 0
    Local cTitle := "Pedidos de Compra"

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

    aAdd(aCab,{"Pedido","C7_NUM",PesqPict("SC7","C7_NUM"),TamSX3("C7_NUM")[1],TamSX3("C7_NUM")[2],,"",TamSX3("C7_NUM")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Produto","C7_PRODUTO",PesqPict("SC7","C7_PRODUTO"),TamSX3("C7_PRODUTO")[1],TamSX3("C7_PRODUTO")[2],,"",TamSX3("C7_PRODUTO")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Item","C7_ITEM",PesqPict("SC7","C7_ITEM"),TamSX3("C7_ITEM")[1],TamSX3("C7_ITEM")[2],,"",TamSX3("C7_ITEM")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Emissao","C7_EMISSAO",PesqPict("SC7","C7_EMISSAO"),TamSX3("C7_EMISSAO")[1],TamSX3("C7_EMISSAO")[2],,"",TamSX3("C7_EMISSAO")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Descrição","B1_DESC",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],TamSX3("B1_DESC")[2],,"",TamSX3("B1_DESC")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Qnt","C7_QUANT",PesqPict("SC7","C7_QUANT"),TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2],,"",TamSX3("C7_QUANT")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Armazem","C6_LOCAL",PesqPict("SC6","C6_LOCAL"),TamSX3("C6_LOCAL")[1],TamSX3("C6_LOCAL")[2],,"",TamSX3("C6_LOCAL")[3]	,"","","","",,'V',,,})
    aAdd(aCab,{"Fornecedor","B1_PROC",PesqPict("SB1","B1_PROC"),TamSX3("B1_PROC")[1],TamSX3("B1_PROC")[2],,"",TamSX3("B1_PROC")[3]	,"","","","",,'V',,,})
    
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
                                            aItens[nx][2],;
											aItens[nx][3],;
                                            aItens[nx][4],;
											aItens[nx][5],;
                                            aItens[nx][6],;
                                            aItens[nx][7],;
                                            aItens[nx][8],;
                                            aItens[nx][9];
                                            },{1,2,3,4,5,6,7,8})
	next nx
    
	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return
