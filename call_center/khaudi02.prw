
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} KHAUDI02
Description //Controle de AVALIAÇÕES
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHAUDI02()
    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cUserMv	:= SuperGetMV("KH_ALTAUD",.F.,"000455|000374|001483")
    Private aAudit := {}
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
    private dDateAte := Date() 
    Private lEst := .F.

	
	if __cUserid $ cUserMv
	lEst := .T.
	endif


    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "AVALIAÇÕES LOJAS" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif
    

    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                '',;
                                                                'Loja',;
                                                                'Nome Gestor',;
                                                                'Nome Auditor',;
                                                                'Total de Pontos',;
                                                                'Data Sis'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
        
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
 
      oTButton1 := TButton():New(44, 110, "Incluir",oPainel,{||fInclui()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
      oTButton1 := TButton():New(44, 160, "Alterar",oPainel,{||fAlterAva()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
      oTButton1 := TButton():New(44, 210, "Liberar",oPainel,{||fLibera()}, 40,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := lEst},,.F. )
      oTButton1 := TButton():New(44, 260, "Deletar",oPainel,{||fDeleta()}, 40,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := lEst},,.F. )
Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description ZKE_DTINCL
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit( dDate1, dDate2,cLoja,cVende,cUsua)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')
    Default dDate1 := Date()
    Private cUser := RetCodUsr() //Retorna o Codigo do Usuario
    Private cNamUser := UsrRetName( cUser )//Retorna o nome do usuario 
    
    //Private cUser := LogUserName()
    
    cQuery := "SELECT ZKE_LIBERA,ZKE_LOJA, ZKE_GESTOR,ZKE_AUDITO, ZKE_TOTAL,ZKE_DTINCL, R_E_C_N_O_ AS RECNO " + ENTER
    cQuery += " FROM ZKE010" + ENTER
    //cQuery += " WHERE ZKE_LIBERA = 'N' " + ENTER
    cQuery += " WHERE D_E_L_E_T_ = ''"+ ENTER
    
    if !__cUserid $ cUserMv
	    cQuery += " AND ZKE_AUDITO ='"+Alltrim(cNamUser)+"'"+ ENTER
	endif
	 
    if !empty(dDate1)
        cQuery += " AND ZKE_DTINCL >= '"+ dtos(dDate1) +"'" 
    endif

    if !empty(dDate2)
        cQuery += " AND ZKE_DTINCL <= '"+ dtos(dDate2)+ "'"
    endif
   
   if !empty(cLoja)
        cQuery += " AND ZKE_LOJA = '"+ cLoja + "'"
    endif
   cQuery += "ORDER BY ZKE_TOTAL DESC "+ ENTER
    
    PLSQuery(cQuery, cAlias)

    aAudit := {}

    while (cAlias)->(!eof())


        aAdd(aAudit,{;
                        (cAlias)->ZKE_LIBERA,;
                        oNo,;
                        (cAlias)->ZKE_LOJA,; //Loja
                        (cAlias)->ZKE_GESTOR,; //Nome Gestor
                        (cAlias)->ZKE_AUDITO,; //Nome Auditor
                        (cAlias)->ZKE_TOTAL,; //Total de Pontos
                        (cAlias)->ZKE_DTINCL,;
                        (cAlias)->RECNO}) //Data Sistema
                        
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aAudit) == 0
        AAdd(aAudit, {"S",oNo,"","","",0,""})
    endif

    oBrowse:SetArray(aAudit)

    oBrowse:bLine := {|| { ;     
    							Iif(aAudit[oBrowse:nAt,01]='S',oSt1,oSt2) ,;
        						aAudit[oBrowse:nAt,02] ,;  
                                U_RETDESCFI(aAudit[oBrowse:nAt,03]),;
                                aAudit[oBrowse:nAt,04] ,;
                                aAudit[oBrowse:nAt,05] ,;
                                aAudit[oBrowse:nAt,06] ,;
                                aAudit[oBrowse:nAt,07] ;
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
        aAudit[nLinha][2] := oOk
    else
        aAudit[nLinha][2] := oNo
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
Local cLojaA := ""
Local Clibera := ""
Local nRecno := 0  
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
 
    if nLinha > 0 
    	Clibera:= Alltrim(aAudit[nLinha][1])
    	nRecno := aAudit[nLinha][8]
	    if Clibera = 'N'
		    U_KHAUDI01(lRet,,,,,nRecno)
		    processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.)
	    else 
	    	msgAlert("Alteração de avaliação Liberada, só é possível através do Botão Liberar")
	    endif
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

Static Function fLibera()

Local lRet := .T.
Local lRetLi := .T.
Local cLibera := 'S'
Local nLinha := 0
Local nRecno := 0
Local cLojaA := ""
Local dLibera := DATE()
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
	    cLojaA := Alltrim(aAudit[nLinha][03])
	    dDataSis := aAudit[nLinha][07]
	    nRecno := aAudit[nLinha][08]
	    If !EMPTY(dDataSis)
		    U_KHAUDI01(lRet,cLojaA,dDataSis,cLibera,lRetLi,nRecno)
		    processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.)
	    else
	    	msgAlert("Não existe registro para liberação!!!")
	    endif
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
Local cLojaA := ""
Local nRecno := 0



   
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
	    nRecno := aAudit[nLinha][08]
		if MsgYesno("Deseja excluir o registro","Atençao!!")
            DbSelectArea("ZKE")
		    ZKE->(dbgoto(nRecno)) // Posiciona no Registo da Z18
            if ! EOF()
                RecLock("ZKE",.F.)
                    ZKE->(dbDelete())
            ZKE->(msUnLock())
                //return(apMsgAlert("Registro Deletado com Sucesso!","SUCESS"),processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.))
                processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.)
            else	
                return(apMsgAlert("Registro Não encontrado!","Atenção"))
            endif
	    Endif
        ZKE->(DBCLOSEAREA("ZKE"))
    else
        msgAlert("Não existe registro selecionado!!!")
    endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fInclui
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL 
@since 10/04/2019 /*/
//--------------------------------------------------------------

Static Function fInclui()
    
	    U_KHAUDI01()
	    processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.)
  	
Return


	
