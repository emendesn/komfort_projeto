#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'TbiConn.ch'
#include 'restful.ch' 

//--------------------------------------------------------------
/*/{Protheus.doc} KFINRA01
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 26-07-2019 /*/
//--------------------------------------------------------------
User Function KFINRA01()

    Local oRest       := Nil
    Local cEndPoint   := ''
    Local cUserApi    := ''
    Local cPassApi    := ''
    Local aHeader     := {}

    Private oResult  := Nil

    cEndPoint := AllTrim(GetNewPar("MV_XAPIRAK","https://api.rakuten.com.br"))
    cUserApi  := AllTrim(GetNewPar("MV_XUSRRAK","21579533001626"))
    cPassApi  := AllTrim(GetNewPar("MV_XPSWRAK","AD8E898F4D86F6E3CD6CFD40BEB0508D"))
    oRest     := FWRest():New(cEndPoint)
 
    Aadd(aHeader, "Authorization: Basic "+ Encode64(cUserApi+":"+cPassApi) )
    aAdd(aHeader,"Content-Type: application/json")

    getReleases(aHeader,oRest)

Return()


Static function getReleases(aHeader,oRest,cPage)

    Local oReleases   := Nil
    Local dDataDef    := CTOD("  /  /    ")
    Local cVendName   := ""
    Local cVendID     := ""
    Local cIdPagam    := ""
    Local cTipo       := ""
    Local cParcela    := ""
    Local nValTaxa    := 0
    Local dDataCancel := CTOD("  /  /    ")
    Local dDtFutDisp  := CTOD("  /  /    ")
    Local dDataDispo  := CTOD("  /  /    ")
    Local dDtFutDisp  := CTOD("  /  /    ")
    Local nValLibera  := 0
    Local nValaReceb  := 0
    Local nX          := 0
    Local cParams     :=  ""

    Default cPage := "1"

    cParams :=  "?status=available&page="

    oRest:setPath("/rpay/v1/releases"+cParams+cPage)

    If oRest:Get(aHeader)
        FWJsonDeserialize(DecodeUtf8(oRest:cResult),@oResult)

        If UPPER(oResult:result) == "SUCCESS"
            If Valtype(oResult:releases) == "A"
                oReleases := oResult:releases

                For nX:= 1 to Len(oReleases)
                    if Upper(oReleases[nX]:status) == "AVAILABLE"
                        cVendName   := oReleases[nX]:seller_name
                        cVendID     := oReleases[nX]:seller_id
                        cIdPagam    := oReleases[nX]:reference
                        cTipo       := oReleases[nX]:kind
                        cParcela    := oReleases[nX]:installment
                        nValTaxa    := oReleases[nX]:fee_amount
                        dDataCancel := iif(Valtype(oReleases[nX]:cancelled_at) == "U",dDataDef,DATEISOCV(oReleases[nX]:cancelled_at))
                        dDtFutDisp  := iif(Valtype(oReleases[nX]:available_on) == "U",dDataDef,DATEISOCV(oReleases[nX]:available_on))
                        dDataDispo  := iif(Valtype(oReleases[nX]:available_at) == "U",dDataDef,DATEISOCV(oReleases[nX]:available_at))
                        nValLibera  := oReleases[nX]:available_amount
                        nValaReceb  := oReleases[nX]:amount

                        //Efetua baixa do pedido informado se1
                        KHBXSE1(cIdPagam,nValLibera,Left(cParcela,2),dDtFutDisp,"RAKUTEN - PEDIDO "+ cIdPagam + " PARCELA " + cParcela )
                        //efetua baixa do pedido informado se2
                        KHBXSE2(cIdPagam,Left(cParcela,2),dDtFutDisp,"RAKUTEN - PEDIDO "+ cIdPagam + " PARCELA " + cParcela )
                    EndIf
                Next
            else
                U_KHLOGWS("",dDataBase,Time(),"Dados retornados invalidos - KHFINRA01","SITE")
            EndIf

            If oResult:Pagination:Page < oResult:Pagination:Page_count
                getReleases(aHeader,oRest,cValToChar(oResult:Pagination:Page+1))
            Endif
        endif
    else
        U_KHLOGWS("",dDataBase,Time(),"Erro ao consumir os dados da API, verificar parâmetros! - KHFINRA01","SITE")
    endif

return 

//--------------------------------------------------------------
/*/{Protheus.doc} DATEISOCV
Description //Descrição da Função
@param cDataIso Data no formato ISO
@return dDataRet Retorna a data no formato padrão ADVPL
@author  - Rafael S.Silva
@since: 26-08-2019 /*/
//--------------------------------------------------------------
Static function DATEISOCV(cDataIso)

Local cDateRet := ""
Local dDataRet := CTOD("  /  /    ")
Local cDay     := ""
Local cMonth   := ""
Local cYear    := ""

nVerao := 0//GETNewPar("MV_HVERAO",0)

cDateRet := DTOC(fwDateTimeToLocal(cDataIso,nVerao)[1])

/* Verificar necessidade deste trecho
   retonro da função FwDateTimeLocal() está retornando a data no formato correto.
cDay    := SubStr(cDateRet,4,2)
cMonth  := Left(cDateRet,2)
cYear   := Right(cDateRet,4) 
*/

dDataRet := CTOD(cDateRet)

return dDataRet

//--------------------------------------------------------------
/*/{Protheus.doc} KHBXSE1
Description : Efetua a baixa do título e parcela informados
@param cPed Numero do titulo
       nValBaixa valor do título
       cParcela  Parcela a ser baixada
       cistórico da baixa
@return xRet Nil
@author  - Rafael S.Silva
@since: 26-08-2019 /*/
//--------------------------------------------------------------
Static Function KHBXSE1(cPed,nValBaixa,cParcela,dDtBaixa,cHistorico)

Local aBaixa   := {}
Local cTipo    := ''
Local cPrefixo := "K42"
Local cQuery   := ""
Local dDataPg  := dDtBaixa+2
Local dNewData := DataValida(dDataPg, .T.)

cQuery += "SELECT Z12_PEDERP,Z12_PAGECO,Z12_CODCLI,Z12_LOJCLI" + CRLF
cQuery += "FROM  "+Z12->(RetSqlName("Z12"))+" Z12 " + CRLF
cQuery += "  WHERE Z12_FILIAL = '"+xFilial("Z12")+"' AND Z12_PEDWEB = '"+cPed+"' " + CRLF
cQuery += "  AND Z12_PEDERP <> ' ' " + CRLF
cQuery += "  AND D_E_L_E_T_ = ' ' " + CRLF

If Select("TSZ12") > 0
    TSZ12->(DbCloseArea())
Endif

TcQuery cQuery New Alias "TSZ12"

cParcela := PADR(cValToChar(Val(cParcela)),TamSx3("E1_PARCELA")[1])

if !TSZ12->(Eof())//baixa o título somente se encontrar o numero do pedido no site
    
    cTipo := IF(Val(TSZ12->Z12_PAGECO) == 1,"CC","BRA")  
    cTipo := Padr(cTipo,3)
    cPed  := Padr(AllTrim(TSZ12->Z12_PEDERP),TamSx3("E1_NUM")[1]) // Pega o numero do pedido, pois o título foi criado com este número

    lMsErroAuto := .F.
    //PREFIXO+NUM+PARCELA+TIPO
    SE1->(Dbsetorder(1))
    if SE1->(DbSeek(xFilial("SE1") + cPrefixo + cPed + cParcela + cTipo  ))
        
      If Empty(SE1->E1_BAIXA)
        aBaixa := {}

        aAdd(aBaixa,{"E1_FILIAL"  ,xFilial("SE1")         ,Nil    })
        aAdd(aBaixa,{"E1_PREFIXO"  ,cPrefixo               ,Nil    })
        aAdd(aBaixa,{"E1_NUM"      ,cPed                   ,Nil    })
        aAdd(aBaixa,{"E1_TIPO"     ,cTipo                  ,Nil    })
        aAdd(aBaixa,{"E1_PARCELA"  ,cParcela               ,Nil    })
        aAdd(aBaixa,{"E1_CLIENTE"  ,TSZ12->Z12_CODCLI      ,Nil    })
        aAdd(aBaixa,{"E1_LOJA"     ,TSZ12->Z12_LOJCLI      ,Nil    })
        aAdd(aBaixa,{"AUTMOTBX"    ,"NOR"                  ,Nil    })
        aAdd(aBaixa,{"AUTBANCO"    ,"   "                  ,Nil    })
        aAdd(aBaixa,{"AUTAGENCIA"  ,"     "                ,Nil    })
        aAdd(aBaixa,{"AUTCONTA"    ,"          "           ,Nil    })
        aAdd(aBaixa,{"AUTDTBAIXA"  ,dNewData               ,Nil    })
        aAdd(aBaixa,{"AUTDTCREDITO",dDataBase              ,Nil    })
        aAdd(aBaixa,{"AUTHIST"     ,cHistorico             ,Nil    })
        aAdd(aBaixa,{"AUTJUROS"    ,0                      ,Nil,.T.})
        aAdd(aBaixa,{"AUTVALREC"   ,nValBaixa              ,Nil    })
        
        MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 
        
        If lMsErroAuto
            cLogErro := 'BAIXA_RAKUTEN_'+STRTRAN(TIME(),":","-")+".log"
            MostraErro("\SYSTEM\EXECAUTO\",cLogErro) 
            U_KHLOGWS("SE1",dDataBase,Time(),MemoRead(cLogErro) + "KHFINRA01","PROTHEUS")
        Endif
     EndIf
    else
        U_KHLOGWS("SE1",dDataBase,Time(),"Titulo "+ cPed +" parcela " + cParcela + " não localizado","PROTHEUS")
    Endif
else
    cLogErro := 'Erro - Nenhum título encontrado com o código ' + cPed + ". Verificar pedidos do e-commerce."
    U_KHLOGWS("SE1",dDataBase,Time(),cLogErro + "KHFINRA01","PROTHEUS")
Endif

Return ( Nil )


//--------------------------------------------------------------
/*/{Protheus.doc} KHBXSE2
Description : Efetua a baixa do título e parcela informados
@param cPed Numero do titulo
       nValBaixa valor do título
       cParcela  Parcela a ser baixada
       cistórico da baixa
@return xRet Nil
@author  - Rafael S.Silva
@since: 26-08-2019 /*/
//--------------------------------------------------------------
Static Function KHBXSE2(cPed,cParcela,dDtBaixa,cHistorico)

Local aBaixa   := {}
Local cTipo    := ''
Local cPrefixo := "TXA"
Local cQuery   := ""
Local cCodAd   := ""
Local cItem    := ""
Local cNaturez  := ""
Local cForTX    := ""
Local cPortado  := ""
Local cLojTX    := ""
Local nPos     := 0
Local cCodParc := ""
local nValTx   := 0
Local nValTaxa := 0
Local nValAdm  := 0
Local dDataPg  := dDtBaixa+2
Local dNewData := DataValida(dDataPg, .T.)
Local aConParc := {{10,"A"},{11,"B"},{12,"C"},{13,"D"},{14,"E"},{15,"F"},{16,"G"},{17,"H"},{18,"I"},{19,"J"},{20,"K"}}

cQuery += "SELECT Z12_PEDERP,Z12_PAGECO" + CRLF
cQuery += "FROM  "+Z12->(RetSqlName("Z12"))+" Z12 " + CRLF
cQuery += "  WHERE Z12_FILIAL = '"+xFilial("Z12")+"' AND Z12_PEDWEB = '"+cPed+"' " + CRLF
cQuery += "  AND Z12_PEDERP <> ' ' " + CRLF
cQuery += "  AND D_E_L_E_T_ = ' ' " + CRLF

If Select("TSZ12") > 0
    TSZ12->(DbCloseArea())
Endif

TcQuery cQuery New Alias "TSZ12"

cParcela := PADR(cValToChar(Val(cParcela)),TamSx3("E2_PARCELA")[1])

if !TSZ12->(Eof())//baixa o título somente se encontrar o numero do pedido no site
    
    cTipo := IF(Val(TSZ12->Z12_PAGECO) == 1,"CC","BRA") 
    cTipo := Padr(cTipo,3)
    cPed  := Padr(AllTrim(TSZ12->Z12_PEDERP),TamSx3("E2_NUM")[1]) // Pega o numero do pedido, pois o título foi criado com este número

    if Val(TSZ12->Z12_PAGECO)  == 1
        Do Case
            Case Val(cParcela) == 1
                cCodAd := "115"
                cItem  := '001'
            Case Val(cParcela)   > 1 .AND. Val(cParcela)  <= 6
                cCodAd := "115"
                cItem := '002'
            Case Val(cParcela)  > 6 .AND. Val(cParcela)  <= 10
                cCodAd := "115"
                cItem := '003'
        EndCase

    elseif Val(TSZ12->Z12_PAGECO)  == 2
        cCodAd := "116"
		cItem  := "001"
    endif

    DbSelectArea("SAE")
	SAE->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO

	If SAE->(DbSeek(xFilial()+cCodAd))
		cNaturez :=  SAE->AE_01NATTX
		cForTX    := SAE->AE_XFORTX
		cPortado  := SAE->AE_XPORTAD
		cLojTX    := SAE->AE_XLJTX
	Endif

    lMsErroAuto := .F.

    dbSelectArea("SE2")
    SE2->(dbSetOrder(1))

    If SE2->(dbSeek(xFilial("SE2") + cPrefixo + cPed + cParcela + cTipo + cForTX + cLojTX ))
        
         If Empty(SE2->E2_BAIXA)
	        If SE2->E2_SALDO > 0
	
	            aBaixa := {}
	            AADD(aBaixa, {"E2_FILIAL" , xFilial("SE2") , Nil})
	            AADD(aBaixa, {"E2_PREFIXO" , cPrefixo , Nil})
	            AADD(aBaixa, {"E2_NUM" , cPed , Nil})
	            AADD(aBaixa, {"E2_PARCELA" , cParcela , Nil})
	            AADD(aBaixa, {"E2_TIPO" , cTipo , Nil})
	            AADD(aBaixa, {"E2_FORNECE" , cForTX , Nil})
	            AADD(aBaixa, {"E2_LOJA" , cLojTX , Nil}) 
	            AADD(aBaixa, {"AUTMOTBX" , "NOR" , Nil})
	            AADD(aBaixa, {"AUTBANCO" , cPortado , Nil})
	            AADD(aBaixa, {"AUTAGENCIA" , "00001" , Nil})
	            AADD(aBaixa, {"AUTCONTA" , "0000000001" , Nil})
	            AADD(aBaixa, {"AUTDTBAIXA" , dNewData , Nil}) 
	            AADD(aBaixa, {"AUTDTCREDITO", dDataBase , Nil}) 
	            AADD(aBaixa, {"AUTHIST" , cHistorico , Nil})
	            AADD(aBaixa, {"AUTVLRPG" , SE2->E2_SALDO, Nil})
	            //ACESSAPERG("FIN080", .F.)
	
	            MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)
	        
	            If lMsErroAuto
	                cLogErro := 'BAIXA_RAKUTEN_'+STRTRAN(TIME(),":","-")+".log"
	                MostraErro("\SYSTEM\EXECAUTO\",cLogErro) 
	                U_KHLOGWS("SE2",dDataBase,Time(),MemoRead(cLogErro) + "KHFINRA01","PROTHEUS")
	            Endif
	        Else
	            U_KHLOGWS("SE2",dDataBase,Time(),"Título sem saldo para efetuar baixa - KHFINRA01","PROTHEUS")
	        endif
	     EndIf   
    else
        U_KHLOGWS("SE1",dDataBase,Time(),"Titulo "+ cPed +" parcela " + cParcela + " não localizado","PROTHEUS")
    Endif

else
    cLogErro := 'Erro - Nenhum título encontrado com o código ' + cPed + ". Verificar pedidos do e-commerce."
    U_KHLOGWS("SE1",dDataBase,Time(),cLogErro + "KHFINRA01","PROTHEUS")
Endif

Return ( Nil )

//--------------------------------------------------------------
/*/{Protheus.doc} JBFINCONC
Description //Realiza baixa dos pedidos da Rakuten
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 01-08-2019 /*/
//--------------------------------------------------------------
User Function JBFINCONC(aEmp)

	Local aEmp := {"01","0142"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2] 
    U_KFINRA01()
	RESET ENVIRONMENT
    
Return()