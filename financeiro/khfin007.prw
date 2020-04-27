#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} KHFIN007
Description //Tela de analise para negativação
@param xParam Parameter Description
@return xRet Return Description
@author  - WELLINGTON RAUL
@since 11/03/2019 /*/
//--------------------------------------------------------------

user function KHFIN007()

    Local aSize := MsAdvSize()
    Local aButtons  := {}
    Private cApro := "1"
    Private cFina := "2"
    Private aTitulos := {}
    Private oTela, oTitulos 
    Private oPainel
    Private oBrowse
    Private oOk := LoadBitMap(GetResources(), "LBOK")
    Private oNo := LoadBitMap(GetResources(), "LBNO")

    Private oFilial
    Private cFil := CriaVar("E1_MSFIL", .F.)

    Private oTitulo
    Private cCpfCnpj := SPACE(20)

    Private oEmissaoDe
    private dEmissaoDeDe := ctod('//')
    
    Private oEmissaoAt
    private dEmissaoAt := ctod('//')




    DEFINE FONT oFont11 NAME "Arial" SIZE 0, -11 BOLD

    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "Painel de Negativação" Of oMainWnd PIXEL

    fCarrParam()

    if aSize[6] < 700
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+73,aSize[4]-60, .T., .F. )
    else
        oPainel := TPanel():New(060,000,,oTela, NIL, .T., .F., NIL, NIL,aSize[6]+39,aSize[4]-60, .T., .F. )
    endif


    //TITULOS PENDENTES
    oBrowse := TwBrowse():New(005, 005, aSize[6], aSize[5],, {  'Codigo',;
                                                                'Cliente',;
                                                                'CPF/CNPJ',;
                                                                'Endereco',;
                                                                'Cep',;
                                                                'Bairro',;
                                                                'Municipio',;
                                                                'Email',;
                                                                'Titulo'},,oPainel,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrowse:bLDblClick := {|| fSetOPeracao(oBrowse:nColPos,aTitulos[oBrowse:nAt])}  
    fCarrTit()
    
    // Scroll type 
    oBrowse:nScrollType := 1

    oBrowse:setFocus()

    SetKey(VK_F5, {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .f.) })
    SetKey(VK_F3, {|| zLegenda(),.f.})
    
    ACTIVATE MSDIALOG oTela  CENTERED
    
Return

Static Function fCarrParam()

    @  34, 05 Say  oSay Prompt 'Cliente: '	FONT oFont11 COLOR CLR_BLUE Size  50, 08 Of oPainel Pixel
    @  44, 05 MSGet oTitulo Var cCpfCnpj FONT oFont11 COLOR CLR_BLUE Pixel SIZE 150, 05 VALID {|| processa( {|| fCarrTit() }, "Aguarde...", "Atualizando Dados...", .F.)} When .T. Of oPainel 
     

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
    
    If !Empty(AllTrim(cCpfCnpj))
		nCpf := Val(cCpfCnpj)
		If nCpf > 0
			if len(alltrim(cCpfCnpj)) > 6
				cCpfFor := StrTran(AllTrim(cCpfCnpj),"-","")
				cCpfFin	:= StrTran(AllTrim(cCpfFor),".","")
			Else
				lCod := .F.
				cCpfFin := cCpfCnpj
			EndIf
		Else
		lLik := .F.
		cCpfFin := cCpfCnpj
		EndIf
	EndIf

	cQuery := CRLF + " SELECT DISTINCT A1.A1_COD AS CLIENTE,A1.A1_NOME AS NOME,A1.A1_CGC AS CPFCNPJ," 
	cQuery += CRLF + " A1.A1_END AS ENDERECO,A1.A1_CEP AS CEP,A1.A1_BAIRRO AS BAIRRO,A1.A1_MUN AS MUNICIPIO,A1.A1_EMAIL AS EMAIL, E1.E1_NUM AS TITULO "
	cQuery += CRLF + " FROM SE1010(NOLOCK) E1 "
	cQuery += CRLF + " INNER JOIN SA1010(NOLOCK) A1 "
	cQuery += CRLF + " ON A1.A1_COD = E1.E1_CLIENTE "
	cQuery += CRLF + " INNER JOIN SC5010(NOLOCK) C5 "
	cQuery += CRLF + " ON C5.C5_CLIENTE = E1.E1_CLIENTE "
	cQuery += CRLF + " WHERE E1_VENCTO < GETDATE()-45   "
	cQuery += CRLF + " AND E1.D_E_L_E_T_ = '' "
	cQuery += CRLF + " AND E1.E1_TIPO IN ('BOL','CHK') "
	cQuery += CRLF + " AND E1.E1_BAIXA = '' "
	cQuery += CRLF + " AND E1.E1_SALDO > 0 "
	if !Empty(AllTrim(cCpfFin))
		if lLik
			IF lCod
				cQuery += CRLF + " AND A1.A1_CGC = '"+cCpfFin+"' "
			Else
				cQuery += CRLF + " AND A1.A1_COD = '"+cCpfFin+"' "
			EndIf
		Else 
			cQuery += CRLF + " AND A1.A1_NOME LIKE '%"+UPPER(cCpfFin)+"%' "
		EndIf
	Else
	cQuery += CRLF + " GROUP BY A1.A1_COD,A1.A1_NOME,A1.A1_CGC,A1.A1_END,A1.A1_CEP,A1.A1_BAIRRO, A1.A1_MUN ,A1.A1_EMAIL, E1.E1_NUM "
	EndIf
    PLSQuery(cQuery, cAlias)

    aTitulos := {}

    while (cAlias)->(!eof())

        aAdd(aTitulos,{;
                        (cAlias)->CLIENTE,;   
                        (cAlias)->NOME,;
                        (cAlias)->CPFCNPJ,;
                        (cAlias)->ENDERECO,;
                        (cAlias)->CEP,;
                        (cAlias)->BAIRRO,;
                        (cAlias)->MUNICIPIO,;
                        (cAlias)->EMAIL,;
                        (cAlias)->TITULO})
    
    (cAlias)->(dbskip())
    end

    (cAlias)->(dbCloseArea())

    if len(aTitulos) == 0
        AAdd(aTitulos, {""," ","","","","","","",""})
    endif

    oBrowse:SetArray(aTitulos)
    
    

    oBrowse:bLine := {|| {      aTitulos[oBrowse:nAt,01],;
        						aTitulos[oBrowse:nAt,02] ,;  
                                aTitulos[oBrowse:nAt,03] ,;
                                aTitulos[oBrowse:nAt,04] ,;
                                aTitulos[oBrowse:nAt,05] ,;
                                UPPER(aTitulos[oBrowse:nAt,06]) ,;
                                aTitulos[oBrowse:nAt,07] ,;
                                UPPER(aTitulos[oBrowse:nAt,08]) ,;
                                aTitulos[oBrowse:nAt,09] ,;
                            }}
    
    oBrowse:refresh()
    oBrowse:setFocus()
    oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

Return


//--------------------------------------------------------------
/*/{Protheus.doc} fSetOperacao
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 07/12/2018 /*/
//--------------------------------------------------------------
Static Function fSetOPeracao(nColuna,_array)
    
    Do Case

        Case nColuna == 1 //Cliente 

        Case nColuna == 2 //Nome
        	
        Case nColuna == 3 //Cpf
           fPagto(_array)
        Case nColuna == 4 //Endereco
            
        Case nColuna == 5 //cep
        
        Case nColuna == 6 //Bairro
           
        Case nColuna == 7 //Municipio

        Case nColuna == 8 //Email
        
        Case nColuna == 9 //Titulo


    EndCase

Return

Static Function fPagto(_array)

	Local aSize := MsAdvSize()
    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal := 0
    Local aFormas := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)
    Local cQuery := ""
    Local aPag := {}
    Local aInfo := {}
    Local cAliasPag := ""
    Local oButton1
	Local oButton2
	Local oGet1
	Local nVlrParc := space(10)
	Local oGet2 
	Local _dDat := date()
	Local oGet3
	Local nQtdPar := 0
	Local oGet4
	Local nVlrEnt := space(10)
	Local oRadMenu1
	Local nRadMenu1 := 1
	Local oRadMenu2 
	Local nRadMenu2 := 2
	Local nRadM4 := 2
	Local nRadM5 := 2
	Local nRadM6 := 2
	Local nRadMenu3 := 1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Parcela em dia" --> Customizado
	Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Parcela Pendente" --> Customizado
	Local oGet5
	Local cObs := ""
	Local oGet6
	Local cNovaObs := " "
	Local nTaxa:= 0
	Local oGet7
	lOCAL oGet10
	Local oRadMenu4
	Local oRadMenu3
	Local oSay8
	Local oSay9
	Private oBrwPag


    DEFINE MSDIALOG oTela FROM 0,0 TO 500,1400 TITLE "TITULOS A RECEBER" Of oMainWnd PIXEL
        
    oBrwPag := TwBrowse():New(005, 005, 445, 220,, {;
    												'',;
                                                    'Cliente',;
                                                    'Nome',;
                                                    'Titulo',;
                                                    'Parcela',;
                                                    'Vencimento',;
                                                    'Dias Vencidos',;
                                                    'Valor',;
                                                    'Renegociação',;
                                                    'Faturado',;
                                                    'Entrega';
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
            
          
           cQuery := CRLF +" SELECT DISTINCT E1_BAIXA, E1_CLIENTE,E1_NOMCLI,E1_NUM,E1_PARCELA , E1_VENCTO, "
           cQuery += CRLF +" DATEDIFF ( DD , E1_VENCTO , GETDATE()  )AS DIAS_VENC, "
           cQuery += CRLF +" E1_VALOR, E1_XDTNEGO, C6_DATFAT AS FATURADO, "
		   cQuery += CRLF +" CASE "
		   cQuery += CRLF +" WHEN DAH_XDESCR = '' THEN 'SEM REGISTRO' "
		   cQuery += CRLF +" WHEN DAH_XDESCR <> '' THEN DAH_XDESCR "
		   cQuery += CRLF +" END "
		   cQuery += CRLF +" AS ENTREGA "
           cQuery += CRLF +" FROM SE1010(NOLOCK) E1 "
		   cQuery += CRLF +" INNER JOIN SC6010(NOLOCK) C6 "
		   cQuery += CRLF +" ON E1.E1_CLIENTE = C6.C6_CLI "
		   cQuery += CRLF +" LEFT JOIN DAI010(NOLOCK) AI "
		   cQuery += CRLF +" ON AI.DAI_PEDIDO = C6.C6_NUM AND AI.DAI_CLIENT = C6.C6_CLI   "
		   cQuery += CRLF +" LEFT JOIN DAH010(NOLOCK) AH  "
		   cQuery += CRLF +" ON AH.DAH_CODCAR = AI.DAI_COD AND AH.DAH_SEQUEN = AI.DAI_SEQUEN AND AI.DAI_CLIENT = AH.DAH_CODCLI "
           cQuery += CRLF +" WHERE E1.E1_BAIXA = '' "
           cQuery += CRLF +" AND E1.E1_SALDO > 0 "
           cQuery += CRLF +" AND E1.E1_VENCTO < GETDATE()-45  "
		   cQuery += CRLF +" AND E1.E1_CLIENTE = '"+_array[1]+"'" 
           cQuery += CRLF +" AND E1.E1_NUM = '"+_array[9]+"'"
           cQuery += CRLF +" AND E1.D_E_L_E_T_ = '' "
		   cQuery += CRLF +" AND AI.D_E_L_E_T_ = '' "
		   cQuery += CRLF +" AND AH.D_E_L_E_T_ = '' "
		   cQuery += CRLF +" AND C6.D_E_L_E_T_ = '' "
           cQuery += CRLF +" ORDER BY E1_BAIXA DESC  "


          cAliasPag := getNextAlias()
          PLSQuery(cQuery, cAliasPag)
          DbSelectArea(cAliasPag)
          (cAliasPag)->(DbGoTop())

          aPag := {}
          nValVdo  := 0
          nValAber := 0
          nTotVdo := 0
          nTotAber := 0
        while (cAliasPag)->(!eof())        
        	        	
			aAdd(aPag,{ (cAliasPag)->E1_BAIXA,;
			(cAliasPag)->E1_CLIENTE,;
			(cAliasPag)->E1_NOMCLI,;
			(cAliasPag)->E1_NUM,;
			(cAliasPag)->E1_PARCELA,;
			(cAliasPag)->E1_VENCTO,;
			(cAliasPag)->DIAS_VENC,;
			(cAliasPag)->E1_VALOR,;
			(cAliasPag)->E1_XDTNEGO,;
			(cAliasPag)->FATURADO,;
			(cAliasPag)->ENTREGA})					
						
			If (cAliasPag)->DIAS_VENC > 0
				nValVdo += (cAliasPag)->E1_VALOR+35
				nTotVdo +=1
			Else
				nValAber += (cAliasPag)->E1_VALOR
				nTotAber +=1			
			EndIf
			(cAliasPag)->(dbSkip())
		end
		//Totais
	
		aAdd(aPag,{ 	1,;
			"Totais",;
			"",;
			"",;
			"Qtd Parcelas",;
			"",;
			0,;
			0,;
			""})
					
		If nValVdo > 0
			aAdd(aPag,{;
			 	1,;
				"Tot Vencido + Multa",;
				"",;
				"",;
				nTotVdo,;
				"",;
				0,;
				nValVdo,;
				""})
		EndIf
		If nValAber > 0
			aAdd(aPag,{ 	2,;
				"Tot Aberto",;
				"",;
				"",;
				nTotAber,;
				"",;
				0,;
				nValAber,;
				""})
		EndIf
		If nValAber > 0 .And. nValVdo > 0
			aAdd(aPag,{ 	3,;
				"Tot Geral",;
				"",;
				"",;
				nTotVdo+nTotAber,;
				"",;
				0,;
				nValAber+nValVdo,;
				""})
		EndIf

	(cAliasPag)->(dbCloseArea())
          

    if len(aPag) <= 0
        AAdd(aPag, {"","","","","",CTOD(""),0,"",CTOD(""),""})
    endif
    
    oBrwPag:SetArray(aPag)
    
    oBrwPag:bLine := {|| ;
                            { Iif(aPag[oBrwPag:nAt][07]<= 0,oSt1,oSt2),;
                              aPag[oBrwPag:nAt,02] ,; 
                              aPag[oBrwPag:nAt,03] ,;
                              aPag[oBrwPag:nAt,04] ,; 
                              aPag[oBrwPag:nAt,05] ,;
                              aPag[oBrwPag:nAt,06] ,;
                              Iif(aPag[oBrwPag:nAt][07]<= 0,0,aPag[oBrwPag:nAt,07]),;
                              aPag[oBrwPag:nAt,08] ,;
                              aPag[oBrwPag:nAt,09] ,;
                              aPag[oBrwPag:nAt,10] ,;
                              aPag[oBrwPag:nAt,11] ;
                            }}
    
    oBrwPag:Refresh()

    dbSelectArea("SA1")
	SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
	SA1->(dbSeek(xFilial()+_array[3]))
	cObs :=SA1->A1_XOBSCOB
	
    aInfo := _array
    
    @ 232, 596 BUTTON oButton1 PROMPT "Salvar" SIZE 060, 017 OF oTela  ACTION (fGrava(cNovaObs,cObs,aInfo,_dDat,nValVdo,nRadM4,nRadM5,nRadM6),oTela:End()) PIXEL
    @ 232, 500 BUTTON oButton2 PROMPT "Cancelar" SIZE  060, 017 OF oTela ACTION(oTela:End())  PIXEL
    @ 232, 011 SAY oSay6 PROMPT "Negativar"  SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 227, 035 RADIO oRadMenu4 VAR nRadM4 ITEMS "Sim","Não" SIZE 043, 017 OF oTela COLOR 0, 16777215 PIXEL
    @ 232, 061 SAY oSay7 PROMPT "SPC"  SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 227, 080 RADIO oRadMenu5 VAR nRadM5 ITEMS "Sim","Não" SIZE 043, 017 OF oTela COLOR 0, 16777215 PIXEL
    @ 232, 106 SAY oSay8 PROMPT "Serasa"  SIZE 037, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 227, 130 RADIO oRadMenu6 VAR nRadM6 ITEMS "Sim","Não" SIZE 043, 017 OF oTela COLOR 0, 16777215 PIXEL
    @ 232, 160 SAY oSay2 PROMPT "Data:" SIZE 038, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 232, 175 MSGET oGet2 VAR _dDat SIZE 060, 010 OF oTela COLORS 0, 16777215 PIXEL
    @ 024, 462 GET oGet5 VAR cObs MEMO SIZE 227, 085 WHEN .F. OF oTela COLORS 0, 16777215 PIXEL
    @ 127, 462 GET oGet6 VAR cNovaObs MEMO SIZE 226, 091 OF oTela COLORS 0, 16777215 PIXEL
    @ 007, 535 SAY oSay1 PROMPT "Histórico de Atendimento" SIZE 064, 007 OF oTela COLORS 0, 16777215 PIXEL
    @ 111, 545 SAY oSay2 PROMPT "Nova Informação" SIZE 044, 009 OF oTela COLORS 0, 16777215 PIXEL

    ACTIVATE MSDIALOG oTela CENTERED

Return


//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description
@param xParam Parameter Description
@return xRet Return Description
@author  -Wellington Raul
@since 11/02/2019
/*/
//--------------------------------------------------------------
Static Function fGrava(cNovaObs,cObs,aInfo,_dDat,nValVdo,nRadM4,nRadM5,nRadM6)
	Local dData := DATE()
	Local cUser := LogUserName()
	local cObsNew := " "
	Local cConfir := "2"
	cObsNew += "Título: "+ALLTRIM(aInfo[9])+"Usuáio: "+ALLTRIM(cUser)+" Data: "+ALLTRIM(dtos(dData))+CRLF+cNovaObs

If !EMPTY(cNovaObs)
	DbSelectArea("SA1")
    SA1->(dbSetOrder(3)) //A1_FILIAL, A1_CGC
	If  SA1->(dbSeek(xFilial()+aInfo[3]))
		/*
		RecLock("SA1", .F.)
		SA1->A1_XOBSCOB += (cObsNew)+CRLF+CRLF
		SA1->A1_XNEGATI := cConfir
		MsUnLock() //Confirma e finaliza a operação
		SA1->(dbCloseArea())
		*/
	EndIf
Else
	MSGINFO( "Nenhuma Informação Inserida", "Aviso" )	
EndIf
	
If nRadM4 == 1
 cConfir := "1"
  	iF nRadM5 == 2 .AND. nRadM6 == 2
		MsgAlert("Para negativação é necessário informar alguma administradora de crédito")
		Return
	Else	
	DbSelectArea('Z17')
	Z17->(DbSetOrder(1))//Filial + cod cliente 
		If Z17->(DbSeek(xFilial()+aInfo[1]))
	    	RecLock("Z17",.F.)
		Else
			RecLock("Z17",.T.)
		EndIf
		Z17->Z17_FILIAL := xFilial() 			  //filial do sistema 
		Z17->Z17_CODIGO := aInfo[1]  			  //codifo do sistema 
		Z17->Z17_NOME   := aInfo[2]    			  //nome do sistema 
		Z17->Z17_CPF    := aInfo[3]     		  //cpf do cliente
		Z17->Z17_ENDERE := aInfo[4]               //rua do cliente
		Z17->Z17_CEP    := aInfo[5]               //cep do cliente
		Z17->Z17_BAIRRO := aInfo[6]               //bairro do cliente
		Z17->Z17_MUNICI := aInfo[7]               //municipio do cliente
		Z17->Z17_EMAIL :=  aInfo[8]   			  //email do cliente 
		Z17->Z17_VALOR  := nValVdo			      //valor atualizado 
		Z17->Z17_TITULO := aInfo[9] 			  //titulo 
		MsUnLock()
		Z17->(dbCloseArea())
				
		DbSelectArea('Z18') 
		Z18->(DbSetOrder(1))//Filial + cod cliente + Titulo+valor
		iF Z18->(DbSeek(xFilial()+aInfo[1]+aInfo[9]+cvaltochar(nValVdo) ))
		 	RecLock("Z18",.F.)
		Else
			Reclock("Z18",.T.)
		EndIF
		Z18->Z18_FILIAL := xFilial()			 //filial do sistema
		Z18->Z18_CODIGO := aInfo[1] 			 //codigo do cliente 
		Z18->Z18_USERNE := cUser				 //usuario que negativou o cliente 
			if nRadM4 == 1
				Z18->Z18_DTNEGA := _dDat		 //data da negativação
			EndIf
			If nRadM5 == 1
				Z18->Z18_ENTSPC := _dDat			 //data da negativação spc
			EndIf
			if nRadM6 == 1
				Z18->Z18_ENTSER := _dDat             //data da negativação serasa 
			EndIf
		Z18->Z18_VLRATI :=  nValVdo              //valor atualizado
		Z18->Z18_TITULO :=	aInfo[9] 			 //titulo 
		MsUnLock()
		Z18->(dbCloseArea())
		EndIf
				
Else
	If !EMPTY(cNovaObs)
		MsgInfo("Apenas a Observação foi salva","Aviso!")		
	Else
		MsgInfo("Nenhuma informação foi salva","Aviso!")		
	EndIf
EndIf
	
	
	
Return


	

return