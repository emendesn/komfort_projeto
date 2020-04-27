#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} KHLEAD02
Description //Controle de cobrança
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 11/03/2019 /*/
//--------------------------------------------------------------
User Function KHLEAD02()

    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private aMonito := {}
    Private oTela, oTitulos
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")
    Private oPainel
    Private oFilial
    Private oTButton1
    Private oTitulo
    Private oEmissaoDe
    private dDateDe  := Date() 
    Private oEmissaoAt
    private dDateAte := ctod('//')
   
    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "TITULOS PENDENTES" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif

    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  '',;
                                                                '',;
                                                                'QTD REGISTORS',;
                                                                'DT INCLUSAO',;
                                                                'USUARIO'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
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
    @  44, 05 MSGet oTitulo Var dDateDe FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel   
    @  34, 40 Say  oSay Prompt 'Até:'	FONT oFont11 COLOR CLR_BLUE Size  30, 08 Of oPainel Pixel
    @  44, 40 MSGet oTitulo Var dDateAte FONT oFont11 COLOR CLR_BLUE Pixel SIZE 30, 05 VALID {|| processa( {|| fCarrTit( dDateDe, dDateAte) }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
        
    oTButton1 := TButton():New(44, 080, "Visualizar",oPainel,{||fVisual()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
Return
//--------------------------------------------------------------
/*/{Protheus.doc} fCarrTit
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL PINTO
@since 11/03/2019 /*/
//--------------------------------------------------------------
Static Function fCarrTit(dDate1,dDate2)

    Local cQuery := ""
    Local cAlias := getNextAlias()
    Local oSt1 := LoadBitmap(GetResources(),'BR_VERDE')
    Default dDate1 := Date()
 
    cQuery := "SELECT COUNT(ACH_CODIGO) AS QTD_REGISTRO, " + ENTER
    cQuery += "SUBSTRING(ACH_XDTINC,7,2) +'/' + SUBSTRING(ACH_XDTINC,5,2) +'/'+SUBSTRING(ACH_XDTINC,1,4)  AS DT_INCLUSAO, " + ENTER
    cQuery += "ACH_XUSER AS USUARIO " + ENTER
    cQuery += "FROM ACH010" + ENTER
    cQuery += "WHERE  ACH_XUSER <> '' " + ENTER
    cQuery += "AND D_E_L_E_T_ <> '*'" + ENTER
    if !empty(dDate1)
        cQuery += " AND ACH_XDTINC >= '"+ dtos(dDate1) +"'" + ENTER
    endif
    if !empty(dDate2)
        cQuery += " AND ACH_XDTINC <= '"+ dtos(dDate2)+ "'"  + ENTER
    endif 
   cQuery += "GROUP BY ACH_XDTINC , ACH_XUSER " + ENTER
   
   
    PLSQuery(cQuery, cAlias)

    aMonito := {}

    while (cAlias)->(!eof())


        aAdd(aMonito,{;
                        oSt1,;
                        oNo,;
                        (cAlias)->QTD_REGISTRO,; //QTD REGISTROS
                        (cAlias)->DT_INCLUSAO,; //DATA INCLUSÃO  
                        (cAlias)->USUARIO}) //USUÁRIO 
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aMonito) == 0
        AAdd(aMonito, {oSt1,oNo,0,"",""})
    endif

    oBrowse:SetArray(aMonito)

    oBrowse:bLine := {|| {      aMonito[oBrowse:nAt,01] ,;
        						aMonito[oBrowse:nAt,02] ,;  
                                aMonito[oBrowse:nAt,03] ,;
                                aMonito[oBrowse:nAt,04] ,;
                                aMonito[oBrowse:nAt,05] ;
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

Static Function fVisual()

Local lRet := .T.
Local nLinha := 0
  
    for nx := 1 to len(oBrowse:AARRAY)
        if oBrowse:AARRAY[nx][2]:CNAME == "LBOK"
            nLinha := nx
            exit
        endif
    next nx
    
    if nLinha > 0
	    dData:= ctod(aMonito[nx][04])
	    
	   fMonitor(dData)
  	else
        msgAlert("Não existe registro selecionado!!!")
    endif

Return


//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description                                 
@author  -
@since 22/04/2019
/*/
//--------------------------------------------------------------
Static Function fMonitor(dData)
Local oButton1
Local aSize := MsAdvSize()
Local oBrwForma as object
Local oFont := TFont():New('Courier new',,-18,.T.)
Local cQuery := ""
Local aPag := {}
Local cAliasPag := ""
Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Parcela em dia" --> Customizado
Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Parcela Pendente" --> Customizado
Static oDlg



  		DEFINE MSDIALOG oDlg TITLE "Monitor de Importação" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

  		oBrwPag := TwBrowse():New(000, 000, 500, 235,, {;
    												'Codigo',;
                                                    'Email',;
                                                    'Razao',;
                                                    'Nome',;
                                                    'Telefone',;
                                                    'DDD',;
                                                    'Cadastro',;
                                                    'Loja',;
                                                    'Midia_MKT',;
                                                    'Interesse',;
                                                    'Origem',;
                                                    'Inclusão',;
                                                    'Usuario',;
                                                    'Cod_MKT';
                                                    },,oDlg,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
                                                    
                                                    
          cQuery := " SELECT ACH_CODIGO AS CODIGO,ACH_EMAIL AS EMAIL,ACH_RAZAO AS RAZAO,ACH_NFANT AS NOME,ACH_TEL AS TELEFONE,"+ ENTER
          cQuery += " ACH_DDD AS DDD,ACH_DTCAD AS CADASTRO,ACH_LOJPRO AS LOJA,ACH_XMIMKT AS MIDIA_MKT,ACH_XINTER AS INTERESSE,"+ ENTER
          cQuery += " ACH_XORIGE AS ORIGEM,ACH_XDTINC AS INCLUSAO,ACH_XUSER AS USUARIO,ACH_XCODMK AS COD_MKT"+ ENTER
          cQuery += " FROM ACH010"+ ENTER
          cQuery += " WHERE ACH_XDTINC = '"+ dtos(dData) +"'"+ ENTER
          cQuery += " AND D_E_L_E_T_ <> '*'"+ ENTER

          cAliasPag := getNextAlias()
          PLSQuery(cQuery, cAliasPag)
          DbSelectArea(cAliasPag)
          (cAliasPag)->(DbGoTop())

        while (cAliasPag)->(!eof())        
        	        	
			aAdd(aPag,{ 	(cAliasPag)->CODIGO,;
			(cAliasPag)->EMAIL,;
			(cAliasPag)->RAZAO,;
			(cAliasPag)->NOME,;
			(cAliasPag)->TELEFONE,;
			(cAliasPag)->DDD,;
			(cAliasPag)->CADASTRO,;
			(cAliasPag)->LOJA,;
			(cAliasPag)->MIDIA_MKT,;
			(cAliasPag)->INTERESSE,;
			(cAliasPag)->ORIGEM,;
			(cAliasPag)->INCLUSAO,;
			(cAliasPag)->USUARIO,;
			(cAliasPag)->COD_MKT})					

			(cAliasPag)->(dbSkip())
		end
		
	(cAliasPag)->(dbCloseArea())
          

    if len(aPag) <= 0
        AAdd(aPag, {"","","","","","",CTOD(""),"","","","",CTOD(""),"",""})
    endif
    
    oBrwPag:SetArray(aPag)
    
    oBrwPag:bLine := {|| ;
                            { aPag[oBrwPag:nAt,01] ,;
                              aPag[oBrwPag:nAt,02] ,; 
                              aPag[oBrwPag:nAt,03] ,;
                              aPag[oBrwPag:nAt,04] ,; 
                              aPag[oBrwPag:nAt,05] ,;
                              aPag[oBrwPag:nAt,06] ,;
                              aPag[oBrwPag:nAt,07] ,;
                              aPag[oBrwPag:nAt,08] ,;
                              aPag[oBrwPag:nAt,09] ,; 
                              aPag[oBrwPag:nAt,10] ,;
                              aPag[oBrwPag:nAt,11] ,;
                              aPag[oBrwPag:nAt,12] ,;
                              aPag[oBrwPag:nAt,13] ,;
                              aPag[oBrwPag:nAt,14] ;
                            }}
    
    oBrwPag:Refresh()
    
    @ 235, 460 BUTTON oButton1 PROMPT "Sair" SIZE 037, 012 OF  ACTION(oDlg:End()) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

