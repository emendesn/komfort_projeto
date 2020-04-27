#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} KHCON002
Description //Controle de cobrança
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
User Function KHCON002()

    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cUserMv	:= SuperGetMV("KH_ALTERAV",.F.,"001038|000455")
    Private aMonito := {}
    Private oTela, oTitulos
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")
    Private oPainel
    Private oFilial
    Private oTButton1
    Private oTitulo
    Private cLoja := SPACE(6)
    Private cVende := SPACE(6)
    Private cUsua := SPACE(30) 
    Private oEmissaoDe
    private dDateDe  := Date() 
    Private oEmissaoAt
    private dDateAte := ctod('//')
    Private lEst := .F.
    

	
	if __cUserid $ cUserMv
	lEst := .T.
	endif


    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "MONITORIA" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif

    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                '',;
                                                                'Codigo',;
                                                                'Vendedor',;
                                                                'Data Video',;
                                                                'Hora Video',;
                                                                'Data Sis',;
                                                                'Hora Sis',;
                                                                'Avaliador',;
                                                                'Link',;
                                                                'Questão 1',;
                                                                'Questão 2',;
                                                                'Questão 3',;
                                                                'Questão 4',;
                                                                'Questão 5',;
                                                                'Questão 6',;
                                                                'Questão 7',;
                                                                'Total Pontos',;
                                                                'Aproveitamento',;
                                                                'Tempo Loja',;
                                                                'Loja',;
                                                                'Qtd PV',;
                                                                'Qtd Aten'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    //oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
    oBrowse:bLDblClick := {|| fSetOPeracao(oBrowse:nColPos,aMonito[oBrowse:nAt])  } 
        
    fCarrTit( dDateDe)
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.) })

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()

	

    @  34, 05 Say  oSay Prompt 'De:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 05 MSGet oTitulo Var dDateDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,Alltrim(cLoja),Alltrim(cVende),Alltrim(cUsua)) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
    @  34, 40 Say  oSay Prompt 'Até:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 40 MSGet oTitulo Var dDateAte FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,Alltrim(cLoja),Alltrim(cVende),Alltrim(cUsua)) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
    @  34, 75 Say  oSay Prompt 'Loja:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 75 MSGet oTitulo Var cLoja FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 F3 "SM0" VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,Alltrim(cLoja),Alltrim(cVende),Alltrim(cUsua)) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
    @  34, 110 Say  oSay Prompt 'Vendedor:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 110 MSGet oTitulo Var cVende FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 F3 "SA3" VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,Alltrim(cLoja),Alltrim(cVende),Alltrim(cUsua)) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
    @  34, 145 Say  oSay Prompt 'Avaliador:'	FONT oFont11 COLOR CLR_BLUE Size  40, 08 Of oPainel Pixel
    @  44, 145 MSGet oTitulo Var cUsua FONT oFont11 COLOR CLR_BLUE Pixel SIZE 40, 05  VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,Alltrim(cLoja),Alltrim(cVende),Alltrim(cUsua)) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    

    //oTButton1 := tButton():New(44,195,"&Alterar",oPainel,{|| fAlterAva() },40,10,,,,.T.,, {|| oTButton1:lActive := lEst},,)
    oTButton1 := TButton():New(44, 195, "Alterar",oPainel,{||fAlterAva()}, 40,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := lEst},,.F. )
    oTButton1 := TButton():New(44, 245, "Deletar",oPainel,{||fDeleta()}, 40,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := lEst},,.F. )
Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit( dDate1, dDate2,cLoja,cVende,cUsua)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
    Default dDate1 := Date()

 
    cQuery := "SELECT ZKB_CODVEN,ZKB_VENDED,ZKB_DTVIDE,ZKB_HRVIDE,ZKB_DTSIST,ZKB_HRSIST,ZKB_AVALIA," + ENTER
    cQuery += "ZKB_LINK,ZKB_PONT1,ZKB_PONT2,ZKB_PONT3,ZKB_PONT4,ZKB_PONT5,ZKB_PONT6,ZKB_PONT7,ZKB_TOTPON," + ENTER
    cQuery += "ZKB_APROVE,ZKB_PONT10,ZKB_LOJA,ZKB_QTDPED,ZKB_QTDATE " + ENTER
    cQuery += "FROM ZKB010" + ENTER
    cQuery += "WHERE D_E_L_E_T_ <> '*'" + ENTER
   
    if !empty(dDate1)
        cQuery += " AND ZKB_DTSIST >= '"+ dtos(dDate1) +"'" 
    endif

    if !empty(dDate2)
        cQuery += " AND ZKB_DTSIST <= '"+ dtos(dDate2)+ "'"
    endif
   
   if !empty(cLoja)
        cQuery += " AND ZKB_LOJA = '"+ cLoja + "'"
    endif
   
   if !empty(cVende)
        cQuery += " AND ZKB_CODVEN = '"+ cVende + "'"
    endif
    
    if !empty(cUsua)
        cQuery += " AND ZKB_AVALIA LIKE '%" + cUsua + "%'"
    endif
   
    PLSQuery(cQuery, cAlias)

    aMonito := {}

    while (cAlias)->(!eof())


        aAdd(aMonito,{;
                        oSt1,;
                        oNo,;
                        (cAlias)->ZKB_CODVEN,; //cod vendedor
                        (cAlias)->ZKB_VENDED,; //nome vendedor
                        (cAlias)->ZKB_DTVIDE,; //Data video
                        (cAlias)->ZKB_HRVIDE,; //Hora Sistema
                        (cAlias)->ZKB_DTSIST,; //Data Sistema
                        (cAlias)->ZKB_HRSIST,; //Hora Sistema
                        (cAlias)->ZKB_AVALIA,; //Avaliador
                        (cAlias)->ZKB_LINK,;   //Link
                        (cAlias)->ZKB_PONT1,;  //Questão 1
                        (cAlias)->ZKB_PONT2,;  //Questão 2
                        (cAlias)->ZKB_PONT3,;  //Questão 3
                        (cAlias)->ZKB_PONT4,;  //Questão 4
                        (cAlias)->ZKB_PONT5,;  //Questão 5
                        (cAlias)->ZKB_PONT6,;  //Questão 6
                        (cAlias)->ZKB_PONT7,;  //Questão 7
                        (cAlias)->ZKB_TOTPON,; //Pontos Totais 
                        (cAlias)->ZKB_APROVE,; //Aproveitamento
                        (cAlias)->ZKB_PONT10,; //Hora em Loja
                        (cAlias)->ZKB_LOJA,;   //Loja
                        (cAlias)->ZKB_QTDPED,; //Quantidade Pedido
                        (cAlias)->ZKB_QTDATE}) //Quantidade Atendimento
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aMonito) == 0
        AAdd(aMonito, {oSt1,oNo,"","",CTOD(""),"","","","","",0,0,0,0,0,0,0,0,0,"","",0,0,""})
    endif

    oBrowse:SetArray(aMonito)

    oBrowse:bLine := {|| {      aMonito[oBrowse:nAt,01] ,;
        						aMonito[oBrowse:nAt,02] ,;  
                                aMonito[oBrowse:nAt,03] ,;
                                aMonito[oBrowse:nAt,04] ,;
                                aMonito[oBrowse:nAt,05] ,;
                                aMonito[oBrowse:nAt,06] ,;
                                aMonito[oBrowse:nAt,07] ,;
                                aMonito[oBrowse:nAt,08] ,;
                                aMonito[oBrowse:nAt,09] ,;
                                aMonito[oBrowse:nAt,10] ,;
                                aMonito[oBrowse:nAt,11] ,;
                                aMonito[oBrowse:nAt,12] ,;
                                aMonito[oBrowse:nAt,13] ,;
                                aMonito[oBrowse:nAt,14] ,;
                                aMonito[oBrowse:nAt,15] ,;
        						aMonito[oBrowse:nAt,16] ,;  
                                aMonito[oBrowse:nAt,17] ,;
                                aMonito[oBrowse:nAt,18] ,;
                                aMonito[oBrowse:nAt,19] ,;
                                aMonito[oBrowse:nAt,20] ,;
                                aMonito[oBrowse:nAt,21] ,;
                                aMonito[oBrowse:nAt,22] ,;
                                aMonito[oBrowse:nAt,23] ;
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
        aMonito[nLinha][2] := oOk
    else
        aMonito[nLinha][2] := oNo
    endif

    oBrowse:refresh()
    
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fAlterAva
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 10/04/2019 /*/
//--------------------------------------------------------------

Static Function fAlterAva()

Local lRet := .T.
Local nLinha := 0
   
    for nx := 1 to len(oBrowse:AARRAY) 
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
	    cCod:= Alltrim(aMonito[nx][03])
	    //dDataSis := aMonito[nx][07] //Ajuste da posição para capturar a data do sistema - Marcio Nunes 22/07/2019 - 10807
		dDataVid := aMonito[nx][05] //Ajuste da posição para capturar a data do video - Marcio Nunes 26/07/2019 - 10807	    
	    U_KHCON001(lRet,cCod,dDataVid)
	    processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.)
  	else
        msgAlert("Não existe registro selecionado!!!")
    endif                                                          

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fAlterAva
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 10/04/2019 /*/
//--------------------------------------------------------------

Static Function fDeleta()

Local lRet := .T.
Local nLinha := 0

   
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
	    cCod:= Alltrim(aMonito[nx][03])
	    dDataSis := aMonito[nx][05]  
	    
	    DbSelectArea("ZKB")
		ZKB->(DbSetOrder(4))//ZKB_FILIAL+ZKB_CODVEN+ ZKB_DTSIST
		if ZKB->(DbSeek(xFilial()+cCod+dtos(dDataSis))) 
			RecLock("ZKB",.F.)
				ZKB->(dbDelete())
			ZKB->(msUnLock())
			return(apMsgAlert("Registro Deletado com Sucesso!","SUCESS"),processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.))
		else
			
			return(apMsgAlert("Data Informada não existe para exclusão!","WARNING"))
		endif
	    
  	else
        msgAlert("Não existe registro selecionado!!!")
    endif
 
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrPV
Description //Carrega os pedidos de venda da loja pela data do video do browse ao clicar na coluna Qtd de PV
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos 
@since 14/09/2019 /*/
//--------------------------------------------------------------
Static Function fCarrPV(_array)

Local cAlias    := getNextAlias()
Local cQuery    := ''
Local nQnt      := 0
Local aSize     := MsAdvSize()
Local aPedVen   := {}
Local oTela 
Local oBrowse
Local aButtons  := {} 
Default _array  := {}



cQuery := " SELECT C5_NUM, C5_CLIENTE,C5_MSFIL, C5_VEND1, C5_EMISSAO " + CRLF
cQuery += " FROM SC5010(NOLOCK) SC5 " + CRLF
cQuery += " INNER JOIN SUA010(NOLOCK) SUA ON C5_NUMTMK = UA_NUM AND C5_MSFIL = UA_FILIAL " + CRLF 
cQuery += " INNER JOIN SE1010(NOLOCK) SE1 ON C5_MSFIL = E1_MSFIL AND (C5_NUM = E1_NUM AND C5_01SAC='' OR (C5_NUM = E1_PEDIDO AND C5_01SAC='')) AND C5_CLIENTE = E1_CLIENTE AND C5_LOJACLI = E1_LOJA " + CRLF
cQuery += " WHERE C5_MSFIL = '"+ _array[21] + "' " + CRLF 
cQuery += " AND C5_CLIENTE <> '000001' " + CRLF 
cQuery += " AND C5_EMISSAO = '"+ DTOS(_array[5]) +"' " + CRLF 
cQuery += " AND SC5.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND SE1.D_E_L_E_T_ = '' " + CRLF 
cQuery += " AND SUA.D_E_L_E_T_ ='' " + CRLF
cQuery += " GROUP BY C5_NUM, C5_CLIENTE,C5_MSFIL, C5_VEND1, C5_EMISSAO " + CRLF 
cQuery += " ORDER BY C5_NUM " + CRLF

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())
	  nQnt++	
	  Aadd(aPedVen,{nQnt,;
	               (cAlias)->C5_NUM,;
	               Posicione("SA1",1,xFilial("SA1")+(cAlias)->C5_CLIENTE+(cAlias)->C5_MSFIL,"A1_NOME"),;
	               Posicione("SA3",1,xFilial("SA3")+(cAlias)->C5_VEND1,"A3_NOME"),;
	               (cAlias)->C5_EMISSAO })
	  (cALias)->(dbSkip())			 
EndDo

(cAlias)->(dbCloseArea())

If Len(aPedVen) <= 0
	Aadd(aPedVen,{0,'','','',CTOD("")})
EndIf

DEFINE MSDIALOG oTela FROM 0,0 TO 400, 800 TITLE "Pedidos de Venda da Loja " +_array[21] Of oMainWnd PIXEL

EnchoiceBar(oTela,{ || oTela:End() },{ || oTela:End() },.F.,aButtons,,,.F.,.F.,.T.,.T.,.F.)

oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],,{'Nº','PEDIDO','CLIENTE','VENDEDOR','EMISSAO'},,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

oBrowse:Setarray(aPedVen) 

oBrowse:bLine := {||,{aPedVen[oBrowse:nAt,01],aPedVen[oBrowse:nAt,02],aPedVen[oBrowse:nAt,03],aPedVen[oBrowse:nAt,04],aPedVen[oBrowse:nAt,05]}}
 														 
oBrowse:Align := CONTROL_ALIGN_ALLCLIENT 

oBrowse:Refresh()
 														 
ACTIVATE MSDIALOG oTela CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Everton Santos 
@since 14/09/2019 /*/
//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array)

    Do Case

        Case nColuna == 1 //Legenda

        Case nColuna == 2 //CheckBox
        	fMarc(oBrowse:nAt)
        Case nColuna == 3 //Codigo vendedor
            
        Case nColuna == 4 //Nome vendedor
            
        Case nColuna == 5 //Data Video
            
        Case nColuna == 6 //Hora Video

        Case nColuna == 7 //Data Sistema

        Case nColuna == 8 //Hora Sistema

        Case nColuna == 9 //Avaliador

        Case nColuna == 10 //Link

        Case nColuna == 11 //Questão 1

        Case nColuna == 12 //Questão 2
        
        Case nColuna == 13 //Questão 3
         
        Case nColuna == 14 //Questão 4
        
        Case nColuna == 15 //Questão 5
        
        Case nColuna == 16 //Questão 6
        
        Case nColuna == 17 //Questão 7
        
        Case nColuna == 18 //Pontos Totais
        
        Case nColuna == 19 //Aproveitamento
        
        Case nColuna == 20 //Hora em Loja
        
        Case nColuna == 21 //Loja
        
        Case nColuna == 22 //Qtd Pedido
        	processa( {|| fCarrPV(_array)}, "Aguarde...", "Localizando Pedidos de Venda...", .f.)
        Case nColuna == 23 //Qtd Atendimento
        	
    EndCase

Return

