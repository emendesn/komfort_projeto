#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'restful.ch' 
#Include "aarray.ch"
#Include "json.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} KHENVICLI
Description //Envio de clientes reclame aqui
@param xParam Parameter Description
@return xRet Return Description
@author  - Wellington Raul
@since: 14-06-2019 /*/
/* Documentação:
https://github.com/imsys/JSON-ADVPL/blob/master/LEIAME.md
::vetores associativos advpl
https://tdn.totvs.com/display/tec/JsonObject%3AfromJSON
::documentação do json objetc da totvs
https://tdn.totvs.com/display/framework/FWRest
::classe fwrest utilizada para enviar as requisições 
*/
//--------------------------------------------------------------
User Function KHENVECO()

    Local oRest      := ''
    Local cEndPoint  := ''
    Local cBody      := ''
    Local cBodyTes	 := ''
    Local cUserApi   := ''
    Local cPassApi   := ''
    Local cTMPZ20    := ''
    Local cJson      := ''
    Local cQuery 	 := ''
    Local _nQtd 	 := 0
    Local aHeader    := {}
    Local aaBusiness 
    Local aJson := {}
    local aUltimo := {}
    Local aClie := {}
    Local aProd := {}
    Local aClient := {}
    Local aItems := {}
    Local _aOps := {}
    local wrk		 := nil
    Local oCod 		 := Nil
    Local oCustomer  := Nil
    Local oList      := Nil
    Local oProduct   := NIl
    Local oItems 	 := NIl
    Local oJson 	 
    Local cTMPZ20  := GetNextAlias()
    Local cTMPZ21  := GetNextAlias()

    //End Point é o endereço do wbservice
    //cEndPoint := ALLTRIM(GETNEWPAR("KH_ENDRECL","http://trustvox.com.br")) //Produção
    cEndPoint := ALLTRIM(GETNEWPAR("KH_ENDRECL","http://staging.trustvox.com.br")) //Homologação
    //Instancio o objeto e passo como parametro o endereço 
    oRest     := FWRest():New(cEndPoint)
    
    //monto o header da requisição 
    aAdd(aHeader,"Content-Type: application/json")
    aAdd(aHeader,"Accept: application/vnd.trustvox.com; version=1")
    //Aadd(aHeader, "Authorization: Bearer SLEYyzsnaxvs4t-7khhG" ) //Produção
    Aadd(aHeader, "Authorization: Bearer BNNkGD7WKtgsMxzDmpcs" ) //Homologação
    //informo qual é a pasta dentro do endereço do webservice
    //oRest:setPath("/api/stores/109491/orders") //Produção
    oRest:setPath("/api/stores/4637/orders") //Homologação
    
    //Query para pegar os dados da tabela muro
    cQuery := CRLF + "SELECT TOP 1000 Z20_COD, Z20_PEDIDO, Z20_NOME, Z20_SBNOME,Z20_EMAIL,Z20_ENTREG, R_E_C_N_O_ AS RECNO "
    cQuery += CRLF + "FROM Z20010 (NOLOCK) "
    cQuery += CRLF + "WHERE D_E_L_E_T_ = '' "
    cQuery += CRLF + "AND Z20_FILIAL = '0142'"
    cQuery += CRLF + "AND Z20_STATUS = '1' "
    cQuery += CRLF + "ORDER BY Z20_COD "
        
    PlSquery(cQuery, cTMPZ20 )
    
    While (cTMPZ20)->(!EOF())
	    aAdd(aClie,{(cTMPZ20)->Z20_COD,;
	    			(cTMPZ20)->Z20_PEDIDO,;
	    			(cTMPZ20)->Z20_NOME,;
	    			(cTMPZ20)->Z20_SBNOME,;
	    			(cTMPZ20)->Z20_EMAIL,;
	    			(cTMPZ20)->Z20_ENTREG,;
	    			(cTMPZ20)->RECNO})
	    	(cTMPZ20)->(DbSkip())		
	    End
	    	(cTMPZ20)->(DbCloseArea())
    
 DbSelectArea('Z20')
    //percorro o array para montar o body da requisição	
   for nx := 1 to len(aClie)
	   aProd  :=	fPedido(Alltrim(aClie[nx][2]))
	   _nQtd  := len(aProd)
	  oCliente := JsonObject():New()
	  oCliente['delivery_date'] := fData(aClie[nx][6])
	  oCliente['order_id'] := Alltrim(aClie[nx][2])
	  oCliente['client'] := JsonObject():New()
	  oCliente['client']['last_name'] := Alltrim(aClie[nx][4])
	  oCliente['client']['first_name'] := Alltrim(aClie[nx][3])
	  oCliente['client']['email'] := Alltrim(aClie[nx][5])
	  oCliente['items'] := {}
	          for nz := 1 to len (aProd)
		      oItems := JsonObject():New()
		      oItems['id']   := Alltrim(aProd[nz][1])
		      oItems['name'] := Alltrim(aProd[nz][2])
		      oItems['url'] := "https://www.komforthouse.com.br/product/image/"+Alltrim(aProd[nz][1])+"/"+Alltrim(aProd[nz][1])+"/Vitrine/sofa-3-lugares-marrom-vancouver.ashx"
		      	AADD(oCliente['items'],oItems)
	          next nz 
	  cRet := oCliente:toJson()
	    //verifico se a função retorno os produtos do pedido, caso seja não eu não envio esse cliente 
	    If len(aProd) > 0 
	      //passo o body para o objeto orest
	      oRest:SetPostParams(cRet)
	      //envio a requisição POST para o webservice
	       If oRest:POST(aHeader)   
	            Z20->(DbGoTo(aClie[nx][7]))
		            if ! EOF()
			            Z20->(RecLock("Z20",.F.))
				            Z20->Z20_DTENVI   := dDataBase
				            Z20->Z20_HRENVI   := Time()
				            Z20->Z20_STATUS   := '2'
				            //Z20->Z20_JSENVI   := cJson
				            Z20->Z20_JSTATU   := orest:oresponseh:cstatuscode
				            Z20->Z20_JSRECE   := orest:oresponseh:creason
			            Z20->(MsUnlock())
		            EndIf
	        Else
	            Z20->(DbGoTo(aClie[nx][7]))
		            if ! EOF()
			            Z20->(RecLock("Z20",.F.))
				            Z20->Z20_DTENVI := dDataBase
				            Z20->Z20_HRENVI := Time()
				            Z20->Z20_STATUS := '3'
				            //Z20->Z20_JSENVI := cJson
				            Z20->Z20_JSTATU := orest:oresponseh:cstatuscode
				            Z20->Z20_JSRECE := oRest:cResult
			            Z20->(MsUnlock())
		            EndIf
	        EndIf
	
	        oRest:cResult := ''
    	    FreeObj(oItems)
	        FreeObj(oCliente)
	        
	    ELse
	    	 Z20->(DbGoTo(aClie[nx][7]))
		            if ! EOF()
			            Z20->(RecLock("Z20",.F.))
				            Z20->Z20_DTENVI   := dDataBase
				            Z20->Z20_HRENVI   := Time()
				            Z20->Z20_STATUS   := '4'
				            //Z20->Z20_JSENVI   := 'Array de produtos Vazio'
				            Z20->Z20_JSTATU   := '000'
				            Z20->Z20_JSRECE   := 'Array de produtos Vazio' 
			            Z20->(MsUnlock())
		            EndIf
	    EndIf	       
   next nx

 Z20->(DbCloseArea())

Return( Nil )

//--------------------------------------------------------------
/*/{Protheus.doc} fpedido
Description //Chama a rotina de projetos via Schedule
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul pinto
@since: 26-06-2019 /*/
//--------------------------------------------------------------

Static function fPedido(cPedi)

Local  cQue02 := ""
Local  cQue03 := ""
Local cTMPZ21 := GetNextAlias()
Local cTMPZ22 := GetNextAlias()
Local  aPprod := {}
Local  aPedeco := {}

	 cQue02 := CRLF + " SELECT Z12_PRODUT FROM Z12010 "
	 cQue02 += CRLF + " WHERE Z12_PEDERP = '"+cPedi+"' "
	 cQue02 += CRLF + " AND D_E_L_E_T_ = '' "
    	  
     PlSquery(cQue02, cTMPZ21 )
    
	    While (cTMPZ21)->(!EOF())
	    aAdd(aPedeco,{(cTMPZ21)->Z12_PRODUT})
	    	(cTMPZ21)->(DbSkip())		
	    End
	    	(cTMPZ21)->(DbCloseArea())
    
    for nY := 1 to len(aPedeco)
    
	   cQue03 := CRLF + " SELECT ZKC_SKU, ZKC_DESCRI FROM ZKC010 "
	   cQue03 += CRLF + " WHERE ZKC_SKU = '"+aPedeco[nY][1]+"' "
	   cQue03 += CRLF + " AND D_E_L_E_T_ = ''  "
	    
	   PlSquery(cQue03, cTMPZ22 )
	    
	    While (cTMPZ22)->(!EOF())
		aAdd(aPprod,{(cTMPZ22)->ZKC_SKU,;
		  			 (cTMPZ22)->ZKC_DESCRI})
		   	(cTMPZ22)->(DbSkip())		
		End
		   (cTMPZ22)->(DbCloseArea())
    Next nY
    
    	
    	
Return aPprod

//--------------------------------------------------------------
/*/{Protheus.doc} fData
Description //Retorna a data no formato delivery
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul pinto
@since: 26-06-2019 /*/
//--------------------------------------------------------------

Static function fData(_dEntre)

Local _data   := date()
Local _Hora   := time()
Local cData   := ""
Local NewData := ""

cData    := DTOS(_dEntre) 
NewData	 := SubStr(cData,1,4)+"-"+SubStr(cData,5,2)+"-"+SubStr(cData,7,2)
//NewData  += "T"+_Hora
//NewData  += "+00:00"

Return NewData
//--------------------------------------------------------------
/*/{Protheus.doc} JBINPA01
Description //Chama a rotina de projetos via Schedule
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul pinto
@since: 26-06-2019 /*/
//--------------------------------------------------------------
User Function JBENVECO()

    Local _aEnv := {}

    _aEnv := {'01','0101'}
    RPCClearEnv()
    RPCSetType(3)
    RPCSetEnv(_aEnv[1], _aEnv[2])
    U_KHENVECO()
    RPCClearEnv()
Return()

//--------------------------------------------------------------
/*/{Protheus.doc} FSTringJs
Description //Montagem da String no formato Json
@param xParam Parameter Description
@return xRet Return Description
@author  - wellington raul pinto
@since: 26-06-2019 /*/
//--------------------------------------------------------------
Static function FSTringJs(aClie)

Local cJson := ""
Local aProd := {}

	 for nx := 1 to len(aClie)
	  cJson := '{  ' + CRLF 
      cJson += ' "order_id":"'+Alltrim(aClie[nx][1])+'", ' + CRLF 
      cJson += ' "client":{  "first_name":"'+Alltrim(aClie[nx][3])+'", "last_name":"'+Alltrim(aClie[nx][4])+'", "email":"'+Alltrim(aClie[nx][5])+'"}, ' + CRLF
      cJson += ' "delivery_date":"'+fData()+'", ' + CRLF
      cJson += ' "items":[  ' + CRLF
      aProd  :=	fPedido(Alltrim(aClie[nx][2]))
	  _nQtd  := len(aProd)   
		    for nz := 1 to len (aProd)     
		    cJson += '  {  "id":"'+Alltrim(aProd[nz][2])+'","name":"'+Alltrim(aProd[nz][1])+'", "url":"http://komforthouse.com.br"}'+iif(_nQtd > nz,",","" )+'' + CRLF
			next nz 
	  cJson += ']}' + CRLF
	  Next Nx
	  
Return cJson






