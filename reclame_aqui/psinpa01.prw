#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'restful.ch' 
#Include "aarray.ch"
#Include "json.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} PSINPA01
Description //Cadastra clientes - Inpaas
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 14-06-2019 /*/
//--------------------------------------------------------------
User Function PSINPA01()

    Local oRest      := ''
    Local cEndPoint  := ''
    Local cBody      := ''
    Local cBodyTes	 := ''
    Local cUserApi   := ''
    Local cPassApi   := ''
    Local cTMPSZA    := ''
    Local cJson      := ''
    Local aHeader    := {}
    Local aaBusiness 
    Local aJson := {}
    local aLast := {}
    local wrk		 := nil
    Local oCod 		 := Nil
    Local oCustomer  := Nil
    Local oList      := Nil
    Local oProduct   := NIl
    Local cTMPSA1  := GetNextAlias()

    cTMPSZA   := GetNextAlias()

    cEndPoint := ALLTRIM(GETNEWPAR("KH_ENDRECL","http://staging.trustvox.com.br"))
    //cUserApi  := AllTrim(GetMv("MV_XUSRINP"))//
    //cPassApi  := AllTrim(GetMv("MV_XPSWINP"))//
    oRest     := FWRest():New(cEndPoint)
 
    aAdd(aHeader,"Content-Type: application/json")
    aAdd(aHeader,"Accept: application/vnd.trustvox.com; version=1")
    Aadd(aHeader, "Authorization: Bearer " + "BNNkGD7WKtgsMxzDmpcs" ) 
   
   

    oRest:setPath("/api/stores/4637/orders")

   

    oList    := LISRECLA():NEW()

/*
	// DbSelectArea("SZA")
    BeginSql Alias cTMPSZA

        %noparser%

        SELECT 
            ZA_CODIGO,
            ZA_NOME,
            ZA_CGC,
            R_E_C_N_O_ AS ZA_RECNO
        FROM 
            %table:SZA% 
        WHERE 
            ZA_STATUS = %exp:'1'% AND 
            %notDel%

    EndSql

*/
   // While !(cTMPSZA)->(Eof())

        oCod := CODRECLA():NEW()
        oCod:setData("000001","2014-02-02T14:26:40+00:00")
        
        oCustomer := SA1RECLA():NEW()
        oCustomer:setData("teste@komfort.com.br","wellington","Raul","954444444")
        
        oProduct := SB1RECLA():NEW()
        oProduct:setData("GRAREV0002A8011","https://www.komforthouse.com.br/","SOFA REVOLUTION 2 LUG 1.62X0.77X1.11 TC 9177/10568 .",1.699)
          
       // oCustomer:SetData ( AllTrim((cTMPSZA)->ZA_CODIGO), AllTrim((cTMPSZA)->ZA_NOME), AllTrim((cTMPSZA)->ZA_CGC) )

        oList:addObject(oCod)
        oList:addObject(oCustomer)
        oList:addObject(oProduct)
        

        //Serialize the json object and convert each atribute into a json key
        cBody := FWJsonSerialize(oList , .F. , .T. )

        //Convert the json keys from upper case to lower case 
        //cBody := U_PSDATALW(cBody)

   
          aaBusiness := Array(#)        
          aaBusiness[#'order_id'] :=  '000001'
          aaBusiness[#'delivery_date'] :=  '2019-11-05T14:26:40+00:00'
          aaBusiness[#'client'] :=  Array(2)
          aaBusiness[#'client'] :=  Array(#)
          aaBusiness[#'client'][#'first_name'] := 'Wellington'
          aaBusiness[#'client'][#'last_name'] := 'Wellington'
          aaBusiness[#'client'][#'email'] := 'wellington.raul@komforthouse.com.br'
          aaBusiness[#'items']:= Array(1)
          aaBusiness[#'items'][1]:= Array(#)
          aaBusiness[#'items'][1][#'name'] := 'SOFA REVOLUTION 2 LUG 1.62X0.77X1.11 TC 9177/10568'
          aaBusiness[#'items'][1][#'id'] := 'GRAREV0002A8011'
          aaBusiness[#'items'][1][#'url'] := 'https://www.komforthouse.com.br/'
     
      
          cBodyTes:= ToJson(aaBusiness)
     
        
         wrk := JsonObject():new()
         wrk['order_id']      := '0001'
         wrk['delivery_date'] := '2014-02-02T14:26:40+00:00'
         wrk['client'] := JsonObject():new()
         wrk['client']['first_name'] := 'wellington'
         wrk['client']['last_name'] := 'raul'
         wrk['client']['email'] := 'teste@komfort.com.br'
         wrk['items'] := JsonObject():new()
         wrk['items']['id'] := 'GRAREV0002A8011'
         wrk['items']['name'] := 'SOFA REVOLUTION 2 LUG'
         wrk['items']['price'] := 1.669
         wrk['seller'] := JsonObject():new()
         wrk['seller']['id'] := '000001'
         wrk['seller']['name'] := 'SOFA REVOLUTION 2 LUG'
        // wrk:fromJson('{"client": {"first_name": "Wellington", "last_name": "Raul", "email": "teste@komfort.com"}') 
        // wrk:fromJson('{"items": [{"name": "Book","id": "5115C","url": "http://store.example.com/book","price": 19.20"}]}') 
        
        
        cBodyTes := FWJsonSerialize(wrk , .F. , .T. )
        
        
      cJson := '{  ' + CRLF 
      cJson += ' "order_id":"032670", ' + CRLF 
      cJson += ' "client":{  "first_name":"Everton", "last_name":"Luiz", "email":"everton.luiz@komfort.com.br", "tags":[  "Sex/Male","Age/27" ]}, ' + CRLF
      cJson += ' "delivery_date":"2014-02-02", ' + CRLF
      cJson += ' "items":[  {  "id":"2444","name":"sofa", "url":"http://store.example.com/book","price":"19.2"}]}' + CRLF        
        
        
        
       oRest:SetPostParams(cJson)
        
        
        
        
        

        If oRest:POST(aHeader)
        
        
        	cTeste :="oi"
            /*
            SZA->(DbGoTo((cTMPSZA)->ZA_RECNO))

            SZA->(RecLock("SZA",.F.))
            SZA->ZA_DTENVIO    := dDataBase
            SZA->ZA_HORAENV    := Time()
            SZA->ZA_STATUS     := '2'
            SZA->ZA_JSONENV   := cBody
            SZA->ZA_JSONREC   := oRest:cResult
            SZA->(MsUnlock())
            */
        Else
        
        cTeste :="oi"
        	
        	/*
            SZA->(DbGoTo((cTMPSZA)->ZA_RECNO))

            SZA->(RecLock("SZA",.F.))
            SZA->ZA_DTENVIO  := dDataBase
            SZA->ZA_HORAENV  := Time()
            SZA->ZA_STATUS   := '3'
            SZA->ZA_JSONENV := cBody
            SZA->ZA_JSONREC := IIF(ValType(oRest:cResult == "U"),oRest:cInternalError,oRest:cResult)
            SZA->(MsUnlock())
            	*/
        EndIf

        oRest:cResult := ''

        //(cTMPSZA)->(DbSkip())
        oList:list := {}
  //  EndDo

        SZA->(DbCloseArea())

Return( Nil )


//--------------------------------------------------------------
/*/{Protheus.doc} JBINPA01
Description //Chama a rotina de projetos via Schedule
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 26-06-2019 /*/
//--------------------------------------------------------------
User Function JBINPA01()

    Local _aEnv := {}


    _aEnv := {'01','0101'}
    RPCClearEnv()
    RPCSetType(3)
    RPCSetEnv(_aEnv[1], _aEnv[2])
    U_PSINPA01()
    RPCClearEnv()
Return()