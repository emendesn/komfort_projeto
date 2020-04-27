#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} KHADP002
Description //Controle de AVALIAÇÕES CD
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
user function KHADP002()
    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private dDate1 := DATE()
    Private dDate2 := DATE()
    Private cUserMv	:= SuperGetMV("KH_ALTCD",.F.,"000374")
    Private aAudit := {}
    Private oTela, oTitulos
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")
    Private oPainel
    Private oFilial
    Private oTButton1
    Private oTitulo
    Private cAvaliac := SPACE(6)
    Private cVende := SPACE(6)
    Private cUsua := SPACE(30) 
    Private oEmissaoDe
    private dDateDe  := Date() 
    Private oEmissaoAt
    private dDateAte := Date() 
    Private lEst := .F.
    Private lBtn := .F.
    Private lMuda := .T.
    
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "AVALIAÇÕES CD" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif

    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                '',;
                                                                'COD AVALIADOR',;
                                                                'NOME AVALIADOR',;
                                                                'COD AVALIADO',;
                                                                'NOME AVALIADO',;
                                                                'COD AVALIACAO',;
                                                                'COD AVALIACAO',;
                                                                'DATA AVALIAÇÃO'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fMarc(oBrowse:nAt)  }
    fCarrTit( dDateDe)
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .f.) })

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

Static Function fCarrParam()
   Local dDate1 := DATE()
	
    @  34, 05 Say  oSay Prompt 'Avaliação:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 05 MSGet oTitulo Var cAvaliac FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 F3 "RD6" VALID {|| processa( {||lEst:= .T., fCarrTit(,,cAvaliac ) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
    
    @  34, 210 Say  oSay Prompt 'De:'	FONT oFont11 COLOR CLR_BLUE Size  40, 08 Of oPainel Pixel
    @  44, 210 MSGet oTitulo Var dDateDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 40, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,,lMuda := .F.) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
        
    @  34, 260 Say  oSay Prompt 'Até:'	FONT oFont11 COLOR CLR_BLUE Size  40, 08 Of oPainel Pixel
    @  44, 260 MSGet oTitulo Var dDateAte FONT oFont11 COLOR CLR_BLUE Pixel SIZE 40, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte,,lMuda := .F.) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel     
    
    oTButton2 := TButton():New(44, 160, "Avaliados",oPainel,{||lEst:= .F.,fCarrTit(dDate1,dDate2,,lMuda := .F.)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton1 := TButton():New(44, 040, "Avaliar",oPainel,{||fInclui()}, 40,10,,,.F.,.T.,.F.,,.F.,{|| oTButton1:lActive := lEst},,.F. ) 
    oTButton3 := TButton():New(44, 310, "Alterar",oPainel,{||fAlterAva()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description ZKE_DTINCL
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit( dDate1, dDate2,cAvaliac,lMuda)
    Local cQuery := ""
    Local cQuinz := '000001'
    Local cMensal := '000002'
    Local cAvaPeri := ""
    Local cQueryR6 := ""
    Local cQryRd0 := ""
    Local cAliRd0 := getNextAlias()
    Local cCodAva := ""    
    Local cAliasAv := getNextAlias()
    Local cAliR6 := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
    Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')
    Local dDtIn := DATE()
    Local dDtfm 
    Local dData 
    Local cMenos1 := ""
    Local cMais1 := ""
    Default dDate1 := DATE()
    Default dDate2 := DATE()
    Default cAvaliac := ""
    Default lMuda := .T.
    Private cUser := RetCodUsr() //Retorna o Codigo do Usuario
    //Private cNamUser := UsrRetName( cUser )//Retorna o nome do usuario   
    //Private cUser := LogUserName()
  
    cQryRd0:= " SELECT RD0_CODIGO FROM RD0010 WHERE RD0_USER = '"+cUser+"' "
    PLSQuery(cQryRd0, cAliRd0)
    while (cAliRd0)->(!eof())
       cCodAva := (cAliRd0)->RD0_CODIGO
      (cAliRd0)->(dbskip())
    end
    (cAliRd0)->(dbCloseArea())
 
 
  cQueryR6 := "SELECT RD6_CODPER FROM RD6010 WHERE RD6_CODIGO = '"+cAvaliac+"'"
  PLSQuery(cQueryR6, cAliR6)
    while (cAliR6)->(!eof())
       cAvaPeri := (cAliR6)->RD6_CODPER
      (cAliR6)->(dbskip())
    end
    (cAliR6)->(dbCloseArea())
  
   dDtfm := DTOC(dDtIn)
   dData := val(SUBSTR(dDtfm,1,2))
   If  dData <= 14
   	cMenos1 :="1"
   Else
    cMais1 := "1"	 
   EndIf 
    
If lMuda
		//QUINZENAL
		If cAvaPeri = cQuinz 
			cQuery := " SELECT DISTINCT RDA_CODDOR AS COD_AVA, " + ENTER
			cQuery += " (SELECT RD0_NOME FROM RD0010(NOLOCK) WHERE RD0_CODIGO = RDA_CODDOR) AS NOME_AVA, "+ ENTER
			cQuery += " RD9_CODADO AS COD_ADO, "+ ENTER
			cQuery += " (SELECT RD0_NOME FROM RD0010(NOLOCK) WHERE RD0_CODIGO = RD9_CODADO) AS NOME_ADO, "+ ENTER 
			cQuery += " RD6_CODIGO AS COD_CAO,RD6_DESC AS NOME_CAO"+ ENTER
			cQuery += " FROM RDA010(NOLOCK)  INNER JOIN RD9010(NOLOCK) ON RDA_CODAVA = RD9_CODAVA "+ ENTER 
			cQuery += " INNER JOIN RD0010(NOLOCK) ON RD0_CODIGO = RDA_CODDOR "+ ENTER
			cQuery += " INNER JOIN RD6010(NOLOCK) ON RD6_CODIGO = RD9_CODAVA  "+ ENTER
			cQuery += " AND RD6_CODIGO = '"+cAvaliac+"' "+ ENTER
			cQuery += " AND RDA_CODDOR ='"+Alltrim(cCodAva)+"'"+ ENTER
			cQuery += " AND RDA010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RD9010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RD6010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RDA_CODDOR+RD6_CODIGO+RD9_CODADO NOT IN "+ ENTER
			cQuery += " ((SELECT ZKF_COADOR+ZKF_CODAVA+ZKF_CODADO FROM ZKF010 WHERE RDA_CODDOR = ZKF_COADOR AND RD6_CODIGO = ZKF_CODAVA "+ ENTER 
			cQuery += " AND RD9_CODADO = ZKF_CODADO AND (SUBSTRING(ZKF_DTINCL,1,4) = YEAR(GETDATE()) "+ ENTER
			cQuery += " AND ZKF_DTINCL BETWEEN  CONVERT(VARCHAR,YEAR(GETDATE()))+RIGHT ('0' + (CONVERT (VARCHAR, MONTH (GETDATE())-'"+cMenos1+"')), 2)+SUBSTRING(RD6_DTINI,7,2) "+ ENTER 
			cQuery += " AND CONVERT(VARCHAR,YEAR(GETDATE()))+RIGHT ('0' + (CONVERT (VARCHAR, MONTH (GETDATE())+'"+cMais1+"')), 2)+CONVERT(VARCHAR,SUBSTRING(RD6_DTFIM,7,2))))) "+ ENTER
		//MENSAL
		Else
			cQuery := " SELECT DISTINCT RDA_CODDOR AS COD_AVA, " + ENTER
			cQuery += " (SELECT RD0_NOME FROM RD0010(NOLOCK) WHERE RD0_CODIGO = RDA_CODDOR) AS NOME_AVA, "+ ENTER
			cQuery += " RD9_CODADO AS COD_ADO, "+ ENTER
			cQuery += " (SELECT RD0_NOME FROM RD0010(NOLOCK) WHERE RD0_CODIGO = RD9_CODADO) AS NOME_ADO, "+ ENTER 
			cQuery += " RD6_CODIGO AS COD_CAO,RD6_DESC AS NOME_CAO "+ ENTER
			cQuery += " FROM RDA010(NOLOCK)  INNER JOIN RD9010(NOLOCK) ON RDA_CODAVA = RD9_CODAVA "+ ENTER 
			cQuery += " INNER JOIN RD0010(NOLOCK) ON RD0_CODIGO = RD9_CODADO "+ ENTER
			cQuery += " INNER JOIN RD6010(NOLOCK) ON RD6_CODIGO =RD9_CODAVA  "+ ENTER
			cQuery += " AND RD6_CODIGO = '"+cAvaliac+"' "+ ENTER
			cQuery += " AND RDA_CODDOR ='"+Alltrim(cCodAva)+"'"+ ENTER
			cQuery += " AND RDA010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RD9010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RD6010.D_E_L_E_T_ = '' "+ ENTER
			cQuery += " AND RDA_CODDOR+RD6_CODIGO+RD9_CODADO NOT IN "+ ENTER
			cQuery += " ((SELECT ZKF_COADOR+ZKF_CODAVA+ZKF_CODADO FROM ZKF010 WHERE RDA_CODDOR = ZKF_COADOR AND RD6_CODIGO = ZKF_CODAVA "+ ENTER
			cQuery += " AND RD9_CODADO = ZKF_CODADO AND (SUBSTRING(ZKF_DTINCL,1,4) = YEAR(GETDATE()) "+ ENTER
			cQuery += " AND SUBSTRING(ZKF_DTINCL,5,2) = RIGHT ('0' + (CONVERT (VARCHAR, MONTH (GETDATE()))), 2))))"+ ENTER
		EndIf

    PLSQuery(cQuery, cAliasAv)

    aAudit := {}

    while (cAliasAv)->(!eof())

        aAdd(aAudit,{;
                        oSt2,;
                        oNo,;
                        (cAliasAv)->COD_AVA,; //COD AVALIADOR
                        (cAliasAv)->NOME_AVA,; //NOME AVALIADOR
                        (cAliasAv)->COD_ADO,; //COD AVALIADO
                        (cAliasAv)->NOME_ADO,; //NOME AVALIADO 
                        (cAliasAv)->COD_CAO,; //COD AVALIACAO
                        (cAliasAv)->NOME_CAO}) //NOME AVALIACAO 

    (cAliasAv)->(dbskip())
    end

    (cAliasAv)->(dbCloseArea())

    if len(aAudit) == 0
        AAdd(aAudit, {oSt1,oNo,"","","","","",""})
    endif

    oBrowse:SetArray(aAudit)

    oBrowse:bLine := {|| { ;     
    							aAudit[oBrowse:nAt,01] ,;
                                aAudit[oBrowse:nAt,02] ,;
                                aAudit[oBrowse:nAt,03] ,;
                                aAudit[oBrowse:nAt,04] ,;
                                aAudit[oBrowse:nAt,05] ,;
                                aAudit[oBrowse:nAt,06] ,;
                                aAudit[oBrowse:nAt,07] ,;
                                aAudit[oBrowse:nAt,08] ;
                               }}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Else 
cQuery := " SELECT ZKF_CODAVA AS COD_AVA, ZKF_NOMAVA AS NOM_AVA,ZKF_CODADO AS COD_AVAL,ZKF_NOADOR AS NOM_AVALI, " + ENTER
cQuery += " ZKF_COADOR AS COD_ADOR,ZKF_NOMADO AS NOM_ADOR, ZKF_DTINCL AS DT_AVALI " + ENTER
cQuery += " FROM ZKF010 WHERE D_E_L_E_T_ = '' "
cQuery += " AND ZKF_USRINC ='"+Alltrim(cUser)+"'"+ ENTER
 
if !empty(dDate1)
        cQuery += " AND ZKF_DTINCL >= '"+ dtos(dDate1) +"'" 
endif

if !empty(dDate2)
        cQuery += " AND ZKF_DTINCL <= '"+ dtos(dDate2)+ "'"
endif
 
 PLSQuery(cQuery, cAliasAv)

    aAudit := {}

    while (cAliasAv)->(!eof())

        aAdd(aAudit,{;
                        oSt1,;
                        oNo,;
                        (cAliasAv)->COD_ADOR,; //COD AVALIADOR
                        (cAliasAv)->NOM_ADOR,; //NOME AVALIADOR
                        (cAliasAv)->COD_AVAL,; //COD AVALIADO
                        (cAliasAv)->NOM_AVALI,; //NOME AVALIADO 
                        (cAliasAv)->COD_AVA,; //COD AVALIACAO
                        (cAliasAv)->NOM_AVA,; //NOME AVALIACAO
                        (cAliasAv)->DT_AVALI}) //DATA AVALICAO 

    (cAliasAv)->(dbskip())
    end

    (cAliasAv)->(dbCloseArea())

    if len(aAudit) == 0
        AAdd(aAudit, {oSt1,oNo,"","","","","","",""})
    endif

    oBrowse:SetArray(aAudit)

    oBrowse:bLine := {|| { ;     
    							aAudit[oBrowse:nAt,01] ,;
                                aAudit[oBrowse:nAt,02] ,;
                                aAudit[oBrowse:nAt,03] ,;
                                aAudit[oBrowse:nAt,04] ,;
                                aAudit[oBrowse:nAt,05] ,;
                                aAudit[oBrowse:nAt,06] ,;
                                aAudit[oBrowse:nAt,07] ,;
                                aAudit[oBrowse:nAt,08] ,;
                                aAudit[oBrowse:nAt,09] ;
                               }}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
 
EndIf

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
Local cCodAva := ""
Local cNomeAva := ""
Local cCodAdo := ""
Local cNomeAdo := ""
Local cCodCao := ""
Local cNomeCao := ""
Local aCampo := {}
  
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
 
    if nLinha > 0 
    	
	    if !EMPTY(aAudit[nx][9]) 
		    
		 cCodAva := Alltrim(aAudit[nx][03])
    	 cNomeAva := Alltrim(aAudit[nx][04])
    	 cCodAdo := Alltrim(aAudit[nx][05])
    	 cNomeAdo := Alltrim(aAudit[nx][06])
    	 cCodCao := Alltrim(aAudit[nx][07])
    	 cNomeCao := Alltrim(aAudit[nx][08])
    	 dDtIncl := aAudit[nx][9]
    	 	
    			AADD(aCampo,cCodAva)
	    		AADD(aCampo,cNomeAva)
	    		AADD(aCampo,cCodAdo)
	    		AADD(aCampo,cNomeAdo)
	    		AADD(aCampo,cCodCao)
	    		AADD(aCampo,cNomeCao)
     		 	
	    		U_KHADP001(aCampo,dDtIncl,lRet)
	    		processa( {|| fCarrTit( dDateDe, dDateAte,cCodCao) }, "Aguarde...", "Atualizando Dados...", .f.)
		    
	    else 
	    	msgAlert("Alteração disponivel apenas para avaliações já aplicadas!")
	    endif
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
Local lRet := .T.
Local nLinha := 0
Local cCodAva := ""
Local cNomeAva := ""
Local cCodAdo := ""
Local cNomeAdo := ""
Local cCodCao := ""
Local cNomeCao := ""
Local aCampo := {}
   
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
    	
    	 cCodAva := Alltrim(aAudit[nx][03])
    	 cNomeAva := Alltrim(aAudit[nx][04])
    	 cCodAdo := Alltrim(aAudit[nx][05])
    	 cNomeAdo := Alltrim(aAudit[nx][06])
    	 cCodCao := Alltrim(aAudit[nx][07])
    	 cNomeCao := Alltrim(aAudit[nx][08])
    	
    	 	If !EMPTY(cCodAva)  
    			AADD(aCampo,cCodAva)
	    		AADD(aCampo,cNomeAva)
	    		AADD(aCampo,cCodAdo)
	    		AADD(aCampo,cNomeAdo)
	    		AADD(aCampo,cCodCao)
	    		AADD(aCampo,cNomeCao)
     		 	
	    		U_KHADP001(aCampo)
	    		processa( {|| fCarrTit( dDateDe, dDateAte,cCodCao) }, "Aguarde...", "Atualizando Dados...", .f.)
		   	else
		    	msgAlert("Não existe registro selecionado!!!")
		   	endif
  	else
        msgAlert("Não existe registro selecionado!!!")
    endif
Return