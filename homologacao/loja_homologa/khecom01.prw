#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))
//--------------------------------------------------------------
/*/{Protheus.doc} KHECOM01
Description //Fila do orçamentos pemdentes de analise do credito
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 09/11/2018 /*/
//--------------------------------------------------------------
User Function KHECOM01()

    Local aSize     := MsAdvSize()
    Local aButtons  := {}
    Local nCont := 1
    Private ddata :=  DATE()
    Private aItens := {}
    Private aErrost := {}
    Private oTButton1
    Private oTButton2
    Private oTButton3
    Private oTButton4
    Private oTButton5
    Private oTButton6
    Private oTButton7
    Private oTButton8
    Private oTButton9
    Private oSay1
    Private oSay2
    Private oSay3
    Private oSay4
    Private oSay5
    Private oSay6
    Private oTela, oOrcPriori, oOrcFila
    Private oSpDiv
    Private oBrwSup
    Private oBrwInf
    Private oPnlmei
    Private oPnlbot
    Private cOrder := "decrescente"
    
    
    DEFINE FONT oFont NAME "Arial" SIZE 0, -16 BOLD
    DEFINE MSDIALOG oTela FROM 0,0 TO aSize[6],aSize[5] TITLE "PORTAL SITE" Of oMainWnd PIXEL

    oPanel := TPanel():New(000,000,,oTela, NIL, .T., .F., NIL, NIL,000,000, .T., .F. )
    oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	oSpDiv := TSplitter():New( 30,01,oTela,675,270, 1 ) // Orientacao Vertical
	oSpDiv:setCSS("QSplitter::handle:vertical{background-color: #666666; height: 8px;}")
	oSpDiv:align := CONTROL_ALIGN_ALLCLIENT

    oPnlmei := TPanel():New(000,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[7],aSize[6], .T., .F. )
    oPnlSup := TPanel():New(020,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. ) 
    oPnlbot := TPanel():New(130,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[7],aSize[6], .T., .F. ) 
    oPnlInf := TPanel():New(150,000,,oSpDiv, NIL, .T., .F., NIL, NIL,aSize[6],aSize[5], .T., .F. )
    
    oSay1:= TSay():New(000,005,{||'Integração E-commerce'  },oPnlmei,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
    oSay3:= TSay():New(020,010,{||'Pesquisa por Data:'  },oPnlmei,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,10)//
    @ 035, 010 MSGET oGet3 VAR ddata SIZE 060, 010 When .T. OF oPnlmei COLORS 0, 16777215 PIXEL  
    oTButton6 := TButton():New( 035, 070, "IR",oPnlmei,{||fCarrItSup(),fCarrItInf()}, 023,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    
   
    oTButton5 := TButton():New( 035, 110, "Todos",oPnlmei,{||fCarrItSup(nCont),fCarrItInf()}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
  
    
     oSay2:= TSay():New(020,200,{||'Rotinas Automáticas de Integração:'  },oPnlmei,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
    oTButton9 := TButton():New( 035, 200, "PV_Ecommerce",oPnlmei,{||U_JOBNEWPV()}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton7 := TButton():New( 035, 250, "Pedido",oPnlmei,{||U_KHJOBPVE()}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton8 := TButton():New( 035, 300, "Produto",oPnlmei,{||U_KHJB010()}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton8 := TButton():New( 035, 350, "Saldo",oPnlmei,{||U_KHESTLOAD()}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
   
    
    //BOTOES DO GRID INFERIOR ERROR LOG 
    oSay4:= TSay():New(000,005,{||'Ocorrências E-commerce'  },oPnlbot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,20)//
    oSay5:= TSay():New(020,010,{||'Pesquisa por Categoria:'  },oPnlbot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,250,10)//
    oTButton1 := TButton():New( 035, 010, "Produto",oPnlbot,{||fCarrItInf("Z06")}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton2 := TButton():New( 035, 060, "Saldo",oPnlbot,{||fCarrItInf("Z07")}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton3 := TButton():New( 035, 110, "Cliente",oPnlbot,{||fCarrItInf("Z11")}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    oTButton4 := TButton():New( 035, 160, "Pedido",oPnlbot,{||fCarrItInf("Z12")}, 040,12,,,.F.,.T.,.F.,,.F.,,,.F.)
    
    //ORÇAMENTOS DE PRIORIDADE
    oBrwSup := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'-','Pedido Site','Data PV','Hora Pv','Data Agend','Faturado','CodKit','Pedido','Itens_PV','CT_Receber','CT_Pagar','Orcamento','Itens_orc','For_pag'},,oPnlSup,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    oBrwSup:bLDblClick := {|| fSetOPeracao(oBrwSup:nColPos,aItens[oBrwSup:nAt])  }
    fCarrItSup()
    
    //ORÇAMENTOS PENDENTES
    oBrwInf := TwBrowse():New(005, 005, aSize[6], aSize[5],, {'Ocorrencias de integracao do E-commerce','Data da Ocorrencia', 'Hora da Ocorrencia'},,oPnlInf,,,,,,,,,,,, .F.,, .T.,, .T.,,,)
    
    oBrwInf:bLDblClick := {|| fSetOPeracao(oBrwInf:nColPos,aErrost[oBrwInf:nAt])  }
    oBrwInf:bHeaderClick := {|o, iCol| fSetOrder(iCol), oBrwInf:Refresh()}
    
    fCarrItInf()
    
    SetKey(VK_F5, {|| processa( {|| fCarrItSup(), fCarrItInf() }, "Aguarde...", "Atualizando Dados...", .f.) })
    SetKey(VK_F4, {|| processa( {|| fExcel() }, "Aguarde...", "Atualizando Dados...", .f.) })

    ACTIVATE MSDIALOG oTela ON INIT EnchoiceBar( oTela, { || } , { || oTela:End() },, aButtons)
    
Return

//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItSup
Description //Carrega itens do painel Superior - Reanalise *Prioridades
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItSup(nCont)
    
   	Local _lStat := .T.
    Local cAlias :=  getNextAlias()
    Local cQuery := ""
	Local oSt1 := LoadBitmap(GetResources(),'BR_AZUL') //"Atendimento Planejado" --> Padrão
	Local oSt2 := LoadBitmap(GetResources(),'BR_VERMELHO')  //"Atendimento Pendente" --> Padrão
	Default nCont := 2


	cQuery := " SELECT  DISTINCT Z12_PEDWEB AS PEDIDO_SITE, " +ENTER	
	cQuery += " SUBSTRING(Z12_DTINC,7,2)+'/'+SUBSTRING(Z12_DTINC,5,2)+'/'+SUBSTRING(Z12_DTINC,1,4)  DATA_PV," +ENTER
	cQuery += " Z12_HRINT AS HORA_PV, " +ENTER
	cQuery += " SUBSTRING(C6_DTAGEND,7,2)+'/'+SUBSTRING(C6_DTAGEND,5,2)+'/'+SUBSTRING(C6_DTAGEND,1,4)  DTAGEND, " +ENTER
	cQuery += " CASE WHEN C5_NOTA <> '' THEN 'SIM' WHEN ISNULL(CONVERT(VARCHAR,C5_NOTA),'')='' THEN 'NAO' END FATURADO, Z12_PRODUT AS CODKIT, " +ENTER
	cQuery += " CASE WHEN C5_NUM <> '' THEN C5_NUM WHEN ISNULL(CONVERT(VARCHAR,C5_NUM),'')='' THEN 'NAO_INTEGRADO' END    PEDIDO, " +ENTER
	cQuery += " CASE WHEN C6_NUM <> '' THEN C6_NUM WHEN ISNULL(CONVERT(VARCHAR,C6_NUM),'')='' THEN 'NAO_INTEGRADO' END  ITENS_PV, " +ENTER
	cQuery += " CASE WHEN E1_NUM <> '' THEN E1_NUM WHEN ISNULL(CONVERT(VARCHAR,E1_NUM),'')='' THEN 'NAO_INTEGRADO' END CT_RECEBER, " +ENTER
	cQuery += " CASE WHEN E2_NUM <> '' THEN E2_NUM WHEN ISNULL(CONVERT(VARCHAR,E2_NUM),'')='' THEN 'NAO_INTEGRADO' END   CT_PAGAR, " +ENTER
	cQuery += " CASE WHEN UA_NUM <> '' THEN UA_NUM WHEN ISNULL(CONVERT(VARCHAR,UA_NUM),'')='' THEN 'NAO_INTEGRADO' END  ORCAMENTO, " +ENTER
	cQuery += " CASE WHEN UB_NUM <> '' THEN UB_NUM WHEN ISNULL(CONVERT(VARCHAR,UB_NUM),'')='' THEN 'NAO_INTEGRADO' END  ITENS_ORC, " +ENTER
	cQuery += " CASE WHEN L4_NUM <> '' THEN L4_NUM WHEN ISNULL(CONVERT(VARCHAR,L4_NUM),'')='' THEN 'NAO_INTEGRADO'  END     FOR_PAG " +ENTER
	cQuery += " FROM Z12010(NOLOCK) Z12 " +ENTER
	cQuery += " LEFT JOIN SC5010(NOLOCK) SC5 ON  Z12.Z12_PEDERP = SC5.C5_NUM  AND Z12.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SC6010(NOLOCK) SC6 ON SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SE1010(NOLOCK) SE1 ON SE1.E1_NUM = SC6.C6_NUM AND SE1.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SE2010(NOLOCK) SE2 ON SE2.E2_NUM = SE1.E1_NUM AND SE2.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SUA010(NOLOCK) SUA ON SUA.UA_NUM = SC5.C5_NUMTMK AND SUA.UA_FILIAL = '0142' AND SUA.UA_CANC = '' " +ENTER
	cQuery += " LEFT JOIN SUB010(NOLOCK) SUB ON SUB.UB_NUM = SUA.UA_NUM AND SUB.UB_FILIAL = '0142' AND SUB.D_E_L_E_T_ = '' " +ENTER
	cQuery += " LEFT JOIN SL4010(NOLOCK) SL4 ON SL4.L4_NUM = SUB.UB_NUM AND SL4.L4_FILIAL = '0142' AND SL4.D_E_L_E_T_ = '' " +ENTER
	cQuery += " WHERE Z12.D_E_L_E_T_ = '' AND SUA.UA_CANC = '' " +ENTER
	if nCont == 2
	cQuery += " AND Z12.Z12_DTINC = '"+dtos(ddata)+"' " +ENTER
	EndIf
	cQuery += " ORDER BY DATA_PV " +ENTER
	
	PLSQuery(cQuery, cAlias)
	
	aItens := {}
	
	while (cAlias)->(!eof())
		_lStat := .T.
		Do Case
            Case (cAlias)->PEDIDO == "NAO_INTEGRADO" 
                _lStat := .F.
            Case fValSc6((cAlias)->PEDIDO,(cAlias)->CODKIT)== 2
             	 _lStat := .F.
            Case (cAlias)->CT_RECEBER == "NAO_INTEGRADO" 
                _lStat := .F.
            Case  ! fValiFin((cAlias)->FOR_PAG) 
                _lStat := .F.
            Case (cAlias)->ORCAMENTO ==  "NAO_INTEGRADO" 
                _lStat := .F.
            Case (cAlias)->ITENS_ORC == "NAO_INTEGRADO" 
                _lStat := .F.
            Case  ! fValiFin((cAlias)->FOR_PAG) 
                _lStat := .F.
        EndCase
		
	
	 aAdd(aItens,{  iif(_lStat ,oSt1,oSt2)    ,;	//1
						(cAlias)->PEDIDO_SITE ,;	//2
						(cAlias)->DATA_PV    ,;     //3
						(cAlias)->HORA_PV    ,;     //4
						(cAlias)->DTAGEND     ,;    //5
						(cAlias)->FATURADO     ,;   //6
						(cAlias)->CODKIT     ,;     //7
						(cAlias)->PEDIDO     ,;	    //8
	 iif (fValSc6((cAlias)->PEDIDO,(cAlias)->CODKIT)== 1 ,"INTEGRADO" ,"NAO_INTEGRADO")  ,;     //9
	 iiF(fValiFin((cAlias)->FOR_PAG) ,(cAlias)->CT_RECEBER,"NAO_INTEGRADO") ,;	    //10
						(cAlias)->CT_PAGAR   ,;	    //11
						(cAlias)->ORCAMENTO  ,; 	//12
						(cAlias)->ITENS_ORC  ,; 	//13
	 iiF(fValiFin((cAlias)->FOR_PAG),(cAlias)->FOR_PAG,"NAO_INTEGRADO") ;			//14
						})	//11
						 						
	 (cAlias)->(dbskip())		
	end
	
	(cAlias)->(dbCloseArea())
    
    if len(aItens) == 0
	aAdd(aItens,{oSt1,"",ctod("//"),"","",ctod("//"),"","","","","","","",""})
    endif
    
    
    oBrwSup:SetArray(aItens)
    
    oBrwSup:bLine := {|| {      aItens[oBrwSup:nAt,01] ,;
        						aItens[oBrwSup:nAt,02] ,;  
                                aItens[oBrwSup:nAt,03] ,;
                                aItens[oBrwSup:nAt,04] ,;
                                aItens[oBrwSup:nAt,05] ,;
                                aItens[oBrwSup:nAt,06] ,;
                                aItens[oBrwSup:nAt,07] ,;
                                aItens[oBrwSup:nAt,08] ,;
                                aItens[oBrwSup:nAt,09] ,;
                                aItens[oBrwSup:nAt,10] ,;
                                aItens[oBrwSup:nAt,11] ,;
                                aItens[oBrwSup:nAt,12] ,;
                                aItens[oBrwSup:nAt,13] ,;
                                aItens[oBrwSup:nAt,14] ;
                                }}
    
     oBrwSup:Align := CONTROL_ALIGN_ALLCLIENT

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fExcel
Description //Carrega itens do painel Inferior - Em aberto, Em atendimento, Sugerido 
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington RAul
@since 09/11/2018 /*/
//--------------------------------------------------------------
   
Static Function fExcel()

	Local oExcel := FWMsExcel():New()
    Local cArqTemp := GetTempPath() + "Ecommerce"+substr(time(), 7, 2)+".XLS"
	Local aFields := {"Z12_PEDWEB","Z12_DTINC","Z12_HRINT","C6_DTAGEND","C5_NOTA","Z12_PRODUT","C5_NUM",;
	"C6_NUM","E1_NUM","E2_NUM","UA_NUM","UB_NUM", "L4_NUM"}
    Local aCab := {}
    Local cTitle := "Relatório Analítico E-commerce"
    Local nx := 0

    if len(aItens) <= 0 
        Return(msginfo("Não ha dados para impressão...","ATENÇÃO"))
    endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nx := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nx]))
	    	Aadd(aCab, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nx

	cNamePlan := cNameTable := cTitle

	oExcel:AddworkSheet(cNamePlan)
	oExcel:AddTable (cNamePlan,cNameTable)
	
	//Colunas do Excel ----------------------------------------
	for nx := 1 to Len(aCab)
		if aCab[nx][8] == "C"// Tipo Caracter
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
		elseif aCab[nx][8] == "N"// Tipo Numerico
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],3,2)
		elseif aCab[nx][8] == "D" // Tipo Data
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,3)			
		else
			oExcel:AddColumn(cNamePlan,cNameTable,aCab[nx][1],1,1)
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
                                            aItens[nx][10],; 
                                            aItens[nx][11],; 
                                            aItens[nx][12],;    
                                            aItens[nx][13],;
                                            aItens[nx][14];
											},{1,2,3,4,5,6,7,8,9,10,11,12,13,14})
	next nx
    

	oExcel:Activate()
	oExcel:GetXMLFile(cArqTemp)
	ShellExecute("open", cArqTemp, "", "C:\", 1 )
	
Return


//--------------------------------------------------------------
/*/{Protheus.doc} fCarrItInf
Description //Carrega itens do painel Inferior - Em aberto, Em atendimento, Sugerido 
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington RAul
@since 09/11/2018 /*/
//--------------------------------------------------------------
Static Function fCarrItInf(cTable)

    Local cAlias := getNextAlias()
    Local cQuery := "" 
    Local cStatus := ""
    Default cTable := "Z06"
    
        cQuery := " SELECT ISNULL(CAST(CAST(Z14_ERRO AS VARBINARY(1024)) AS VARCHAR(1024)),'') AS Z14_ERRO," +ENTER
        cQuery += " SUBSTRING(Z14_DATA,7,2)+'/'+SUBSTRING(Z14_DATA,5,2)+'/'+SUBSTRING(Z14_DATA,1,4)  DATA, " +ENTER
        cQuery += "  Z14_HORA  AS HORA " +ENTER
        cQuery += " FROM Z14010(NOLOCK)" +ENTER
        cQuery += " WHERE Z14_TABELA = '"+cTable+"'" +ENTER
        cQuery += " AND Z14_DATA = '"+dtos(ddata)+"'" +ENTER

        PLSQuery(cQuery, cAlias)

        aErrost := {}

        while (cAlias)->(!eof())
           
            aAdd(aErrost,{     Alltrim((cAlias)->Z14_ERRO),;
            				   (cAlias)->DATA,;
            				   (cAlias)->HORA;
                            })

        (cAlias)->(dbskip())
        End
        
        (cAlias)->(dbCloseArea())
        
        if len(aErrost) == 0
            AAdd(aErrost, {"",ctod("//"),""})
        endif

        oBrwInf:SetArray(aErrost)
   
        oBrwInf:bLine := {|| { aErrost[oBrwInf:nAt,01],;
        					   aErrost[oBrwInf:nAt,02],;
        					   aErrost[oBrwInf:nAt,03];
                                }}
        
        oBrwInf:Align := CONTROL_ALIGN_ALLCLIENT

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
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------


Static Function fSetOPeracao(nColuna,_array)

		Do Case
		
			Case nColuna == 1 //Status
			
			Case nColuna == 2 //Pedido_site
			
			Case nColuna == 3 //data do pv
			
			Case nColuna == 4 //hora do pv
			
			Case nColuna == 5 // data agendamento
			
			Case nColuna == 6 //faturado S/N
			
			Case nColuna ==  7 //codigo do kit
			processa( {|| findKit(_array) }, "Aguarde...", "Localizando kit...", .f.)
			Case nColuna == 8 //Pedido
			
			Case nColuna == 9 //itens pv
			processa( {|| findItPv(_array) }, "Aguarde...", "Localizando Itens...", .f.)
			Case nColuna == 10 //Contas a receber
			processa( {|| fFinanc(_array) }, "Aguarde...", "Localizando Itens...", .f.)
			Case nColuna == 11 //Contas a pagar
			processa( {|| fFinRec(_array) }, "Aguarde...", "Localizando Itens...", .f.)
			Case nColuna == 12 //Orçamento
			
			Case nColuna == 13 //Itens Orçamento
			
			Case nColuna == 14 //Forma de pagamento		
			 processa( {|| fCondPagto(_array) }, "Aguarde...", "Localizando Condição de Pagamento...", .f.)

		EndCase

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fValiFin
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------
Static Function fValiFin (_cNum)

Local _lRetFin := .F.
Local nForm := 0
Local nCtRec := 0
Local cQuery :=  ""
Local cAliE1 := GetNextAlias()

 dbSelectArea("SL4")
    SL4->(dbSetOrder(1)) //L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_   
    if SL4->(dbSeek("0142"+alltrim(_cNum)))
        while SL4->L4_FILIAL+SL4->L4_NUM == "0142"+alltrim(_cNum)
            nForm += SL4->L4_VALOR
            SL4->( dbSkip() )
        end
    endif
 SL4->(DbCloseArea())

    cQuery := " SELECT E1_VALOR FROM SE1010(NOLOCK) " +ENTER
    cQuery += "  WHERE E1_PREFIXO = 'K42' " +ENTER
    cQuery += "  AND E1_NUMSUA = '"+alltrim(_cNum)+"'" +ENTER
    cQuery += "  AND D_E_L_E_T_ = '' " +ENTER   
    PLSQuery(cQuery,cAliE1)
    While (cAliE1)->(!EOF())
    	nCtRec += (cAliE1)->(E1_VALOR)
       	(cAliE1)->(dbskip()) 	
   End
        (cAliE1)->(dbCloseArea())
   	 
If nForm == nCtRec 
 _lRetFin := .T.
EndIf

Return _lRetFin
//--------------------------------------------------------------
/*/{Protheus.doc} fCondPagto
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------

Static Function fCondPagto(_array)

    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal := 0
    Local aFormas := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)

    dbSelectArea("SL4")
    SL4->(dbSetOrder(1)) //L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_
    
    if SL4->(dbSeek("0142"+alltrim(_array[14])))
        while SL4->L4_FILIAL+SL4->L4_NUM == "0142"+alltrim(_array[14])
            AAdd(aFormas, {SL4->L4_NUM,SL4->L4_DATA,SL4->L4_VALOR,SL4->L4_FORMA,SL4->L4_OBS,SL4->L4_XPARC})
            nTotal += SL4->L4_VALOR
            SL4->( dbSkip() )
        end
    endif

    DEFINE MSDIALOG oTela FROM 0,0 TO 600,900 TITLE "FORMAS DE PAGAMENTO" Of oMainWnd PIXEL
    
    oSay := TSay():New(280,010,{||'Valor Total:'},oTela,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet := TGet():New(279,100,{|u| If( PCount() == 0, nTotal, nTotal := u ) },oTela,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTotal",,,,lHasButton)    
    //                                     L  - A
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

Return nTotal

//--------------------------------------------------------------
/*/{Protheus.doc} fFinanc
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------

Static Function fFinanc(_array)

	Local cAliE1 := getNextAlias()
    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal := 0
    Local aFormas := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)
    Local cQuery := ""
    
    DEFINE MSDIALOG oTela FROM 0,0 TO 600,900 TITLE "FINANCEIRO" Of oMainWnd PIXEL
     
    cQuery := " SELECT E1_NUMSUA,E1_VENCTO,E1_VALOR,E1_TIPO,E1_XDESCFI, E1_HIST FROM SE1010(NOLOCK) " +ENTER
    cQuery += "  WHERE E1_PREFIXO = 'K42' " +ENTER
    cQuery += "  AND E1_NUMSUA = '"+_array[14]+"'" +ENTER
    cQuery += "  AND D_E_L_E_T_ = '' " +ENTER
    
    
    PLSQuery(cQuery,cAliE1)
    
    While (cAliE1)->(!EOF())
    
    	Aadd(aFormas, {	(cAliE1)->(E1_NUMSUA),;
    					(cAliE1)->(E1_VENCTO),;
    					(cAliE1)->(E1_VALOR),;
    					(cAliE1)->(E1_TIPO),;
    					(cAliE1)->(E1_XDESCFI),;
    					(cAliE1)->(E1_HIST),;
    					nTotal += (cAliE1)->(E1_VALOR);
    					})
    	(cAliE1)->(dbskip())
    	
        End
        
        (cAliE1)->(dbCloseArea())
    	    
    oSay := TSay():New(280,010,{||'Valor Total:'},oTela,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet := TGet():New(279,100,{|u| If( PCount() == 0, nTotal, nTotal := u ) },oTela,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTotal",,,,lHasButton)    
    //                                     L  - A
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

Return nTotal

//--------------------------------------------------------------
/*/{Protheus.doc} fFinRec
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------

Static Function fFinRec(_array)

	Local cAliE2 := getNextAlias()
    Local oTela as object
    Local oBrwForma as object
    Local oSay as object
    Local oGet as object
    Local lHasButton := .T. //Indica se, verdadeiro (.T.), o uso dos botões padrão, como calendário e calculadora.
    Local nTotal := 0
    Local aFormas := {}
    Local oFont := TFont():New('Courier new',,-18,.T.)
    Local cQuery := ""
    
    DEFINE MSDIALOG oTela FROM 0,0 TO 600,900 TITLE "FINANCEIRO" Of oMainWnd PIXEL
     
    cQuery := "	SELECT E2_NUM,E2_VENCTO, E2_VALOR,E2_TIPO,E2_NOMFOR,E2_XDESCFI FROM SE2010(NOLOCK) " +ENTER
    cQuery += "	WHERE E2_NUM = '"+_array[8]+"' " +ENTER
    cQuery += "	AND D_E_L_E_T_ = '' " +ENTER
    
    
    PLSQuery(cQuery,cAliE2)
    
    While (cAliE2)->(!EOF())
    
    	Aadd(aFormas, {	(cAliE2)->(E2_NUM),;
    					(cAliE2)->(E2_VENCTO),;
    					(cAliE2)->(E2_VALOR),;
    					(cAliE2)->(E2_TIPO),;
    					(cAliE2)->(E2_NOMFOR),;
    					(cAliE2)->(E2_XDESCFI),;
    					nTotal += (cAliE2)->(E2_VALOR);
    					})
    	(cAliE2)->(dbskip())
    	
        End
        
        (cAliE2)->(dbCloseArea())
    	  
    oSay := TSay():New(280,010,{||'Valor Total:'},oTela,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
    oGet := TGet():New(279,100,{|u| If( PCount() == 0, nTotal, nTotal := u ) },oTela,060, 010, "@E 999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTotal",,,,lHasButton)    
    //                                     L  - A
    oBrwForma := TwBrowse():New(005, 005, 445, 260,, {;
                                                    'Numero',;
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
/*/{Protheus.doc} fValSc6
Description //Define a ação com base na coluna clicada
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul Pinto
@since 23/08/2019 /*/
//--------------------------------------------------------------

Static function fValSc6(cNum,cNumKit)

local cQuery := ""
Local cQryc6 := ""
Local cAliazkc := getNextAlias()
Local cAliaSc6 := getNextAlias()
local nRowsb1 :=  0
local nRowsC6 :=  0
Local nRet := 0

cQuery := " SELECT COUNT(B1_COD) AS QTDKIT FROM ZKC010 (NOLOCK)  ZKC INNER JOIN ZKD010 (NOLOCK) ZKD ON ZKD_FILIAL = ''  "
cQuery += " AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = '' INNER JOIN SB1010 (NOLOCK) SB1 ON B1_FILIAL = '  '  " 
cQuery += " AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = '' WHERE ZKC_FILIAL = '' AND ZKC_SKU= '"+cNumKit+"' AND ZKC.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery, cAliazkc)

while (cAliazkc)->(!eof())
	nRowsb1 := (cAliazkc)->(QTDKIT)
	(cAliazkc)->(dbskip())
End

cQryc6 := " SELECT  COUNT(C6_PRODUTO) AS PRODUTO FROM SC5010(NOLOCK) SC5 "
cQryc6 += " INNER JOIN SC6010(NOLOCK) SC6 ON C5_NUM = C6_NUM  "
cQryc6 += " WHERE C6_NUM = '"+cNum+"' AND SC6.D_E_L_E_T_ = '' "


PLSQuery(cQryc6, cAliaSc6)

while (cAliaSc6)->(!eof())
		nRowsC6 := (cAliaSc6)->(PRODUTO)
	(cAliaSc6)->(dbskip())
End
	
	if nRowsb1 == nRowsC6
		nRet := 1
	Else
		nRet := 2
	EndIf

return nRet
//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //Trás todos os produtos do kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------
Static Function findKit(_array)                        

Local cQuery := ""	
Local _cCod := ""
Local _cDesc := ""
Local cAlias := GetNextAlias()
Local oTela
Local 	aProd := {}
Private oBrwPro

DEFINE MSDIALOG oTela FROM 0,0 TO 200,600 TITLE "Produtos do kit" Of oMainWnd PIXEL
        
    oBrwPro := TwBrowse():New(005, 005, 445, 220,, {;
                                                    'Codigo',;
                                                    'Descrição',;
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

cQuery := " SELECT B1_COD,B1_DESC FROM ZKC010 (NOLOCK)  ZKC INNER JOIN ZKD010 (NOLOCK) ZKD ON ZKD_FILIAL = ''  "
cQuery += " AND ZKD_CODPAI = ZKC_CODPAI AND ZKD.D_E_L_E_T_ = '' INNER JOIN SB1010 (NOLOCK) SB1 ON B1_FILIAL = '  '  " 
cQuery += " AND B1_COD = ZKD_CODFIL AND SB1.D_E_L_E_T_ = '' WHERE ZKC_FILIAL = '' AND ZKC_SKU= '"+_array[7]+"' AND ZKC.D_E_L_E_T_ = ' ' "

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())

	aAdd(aProd,{(cAlias)->(B1_COD),;
	            (cAlias)->(B1_DESC);
	})
	(cAlias)->(dbskip())
End
(cAlias)->(DbCloseArea())
  oBrwPro:SetArray(aProd)
    
    oBrwPro:bLine := {||{     aProd[oBrwPro:nAt,01] ,; 
                              aProd[oBrwPro:nAt,02] ;
                            }}
    
    oBrwPro:Refresh()



ACTIVATE MSDIALOG oTela CENTERED

Return
//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //Trás todos os produtos do kit
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------

Static Function findItPv(_array)                        

Local cQuery := ""	
Local _cCod := ""
Local _cDesc := ""
Local cAlias := GetNextAlias()
Local oTela
Local 	aProd := {}
Private oBrwPro

DEFINE MSDIALOG oTela FROM 0,0 TO 200,600 TITLE "Itens do Pedido" Of oMainWnd PIXEL
        
    oBrwPro := TwBrowse():New(005, 005, 445, 220,, {;
                                                    'Codigo',;
                                                    'Descrição',;
                                                    },,oTela,,,,,,,,,,,, .F.,, .T.,, .T.,,,)

cQuery := " SELECT C6_PRODUTO,C6_DESCRI  FROM SC5010(NOLOCK) SC5 "
cQuery += " INNER JOIN SC6010(NOLOCK) SC6 ON C5_NUM = C6_NUM  "
cQuery += " WHERE C6_NUM = '"+_array[8]+"' AND SC6.D_E_L_E_T_ = '' "

PLSQuery(cQuery, cAlias)

while (cAlias)->(!eof())

	aAdd(aProd,{(cAlias)->(C6_PRODUTO),;
	            (cAlias)->(C6_DESCRI);
	})
	(cAlias)->(dbskip())
End
(cAlias)->(DbCloseArea())
  oBrwPro:SetArray(aProd)
    
    
    oBrwPro:bLine := {||{     aProd[oBrwPro:nAt,01] ,; 
                              aProd[oBrwPro:nAt,02] ;
                            }}
    
    oBrwPro:Refresh()



ACTIVATE MSDIALOG oTela CENTERED

Return

//--------------------------------------------------------------
/*/{Protheus.doc} findKit
Description //CRIA A SL4 APARTIR DA SE1
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since 11/02/2019 /*/
//--------------------------------------------------------------

Static function fGerSl4(_array)

Local _lRet := .T.
Local nFormPag := 0
Local nQtdPar  := 0
LocaL nPos     := 0
Local nPosOper := 0
Local cAlias := GetNextAlias()
Local aOpera   := {}

aAdd(aOpera,{1,"American Express"})
aAdd(aOpera,{3,"Bradesco"})
aAdd(aOpera,{4,"Dinners"})
aAdd(aOpera,{8,"MasterCard"})
aAdd(aOpera,{9,"Visa"})
aAdd(aOpera,{41,"ELO"})
								
cQuery := " SELCT E1_NUMSUA,E1_EMISSAO,E1_VALOR,E1_TIPO,E1_DOCTEF,E1_PARCELA " + ENTER
cQuery += " FROM "+RetSqlName("SE1")+"(NOLOCK) WHERE E1_NUM = '"+_array[2]+"' AND D_E_L_E_T_ = '' AND E1_FILORIG = '0142' " + ENTER 


DbSelectArea("Z12")
Z12->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO
if Z12->(DbSeek(xFilial()+_array[2]))
 nFormPag := Z12->Z12_PAGECO
 nQtdParc  := Z12->Z12_QTDPAR
 cAutoriz := Z12->Z12_AUTORI
 cCCID    := Z12->Z12_IDCART
endiF

if nFormPag == 1
	IF nQtdParc == 1
			cCodAd := "115"
	elseif nQtdParc > 1   .AND. nQtdParc <= 6
			cCodAd := "115"
	elseif nQtdParc > 6 .AND. nQtdParc <= 10
			cCodAd := "115"
	EndIf

elseif nFormPag == 2
	cCodAd := "116"
endif


DbSelectArea("SAE")
SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

if SAE->(DbSeek(xFilial()+cCodAd))
	cPortado  := SAE->AE_XPORTAD
	cAdmins := SAE->AE_DESC
Endif


PLSQuery(cQuery, cAlias)

	iF EMPTY (cAlias->(E1_NUMSUA))
		MsgAlert("Para ajustar as Formas de Pagamento é necessário o ajuste do Contas a Receber Primeiro")
		_lRet := .F.
		Return _lRet
	EndIf

while (cAlias)->(!eof())
	
		DbSelectArea("SL4")
        SL4->(dbSetOrder(1))//L4_FILIAL, L4_NUM, L4_ORIGEM, R_E_C_N_O_, D_E_L_E_T_
		If SL4->(DbSeek(xFilial()+cAlias->(E1_NUMSUA)+"SITE"))
		SL4->(RecLock("SL4",.F.))
		Else
		SL4->(RecLock("SL4",.T.))
		EndIf	
		SL4->L4_FILIAL  := "0142"
		SL4->L4_NUM     := cAlias->(E1_NUMSUA)
		SL4->L4_DATA    := cAlias->(E1_EMISSAO)
		SL4->L4_VALOR   := cAlias->(E1_VALOR)
		SL4->L4_FORMA   := cAlias->(E1_TIPO)
		SL4->L4_ADMINIS := cAdmins//BUSCAR SAE
		SL4->L4_OBS     := "RAKUTEN PAY"
		SL4->L4_TERCEIR := .F.
		SL4->L4_AUTORIZ := cAlias->(E1_DOCTEF)
		SL4->L4_MOEDA   := 1
		SL4->L4_ORIGEM  := "SITE"
		SL4->L4_DESCMN  := 0
		SL4->L4_XFORFAT := "1"
		SL4->L4_XPARC   := cValToChar(nQtdParc)
		SL4->L4_XPARNSU := cAlias->(E1_PARCELA)
		SL4->L4_XNCART4 := Right(cCCID,4)//4 ULTIMOS CARTÃO 
		SL4->L4_XFLAG   := Iif(nPosOper > 0,aOpera[nPosOper][2],"")
		SL4->(MsUnlock())
	
	(cAlias)->(dbskip())
End
	(cAlias)->(DbCloseArea())
	Z12->(DbCloseArea())
    SL4->(DbCloseArea())	
    SAE->(DbCloseArea())
Return _lRet



