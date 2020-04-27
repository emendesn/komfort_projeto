#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'
#include 'TbiConn.ch'


/*/{Protheus.doc} KHINCKIT
//TODO: Atualiza tabela intermediaria de produtos do E-Commerce
		assim que o kit sofrer alteração.
@author Rafael S.Silva
@since 23/05/2019
@return Nil 

@type function
/*/
user function KHALTKIT()

	Local aArea 	:= GetArea()
	Local xRet		:= .T.
	Local aParam	:= PARAMIXB 
	Local cQuery 	:= ""
	Local nRecno	:= aParam[1] //R_E_C_N_O DA TABELA ZKC
	Local nTamProd  := 0

	nTamProd := TAMSX3("Z06_PRODUT")[1]

	//If nRecno > 0 
	//	ZKC->(DbGoTo(nRecno))
		
        If ZKC->ZKC_ECOM == '1' .AND. ZKC->ZKC_MSBLQL == '2'
			
			cQuery := ""
			cQuery += CRLF + "SELECT R_E_C_N_O_ Z06_RECNO, * "
			cQuery += CRLF + "FROM "+ Z06->(RetSqlName("Z06"))
			//cQuery += CRLF + " FROM Z06010(NOLOCK) " 
			//cQuery += CRLF +" WHERE Z06_FILIAL = '"+xFilial("Z06")+"' AND Z06_PRODUT = '"+ZKC->ZKC_SKU+"' "
			cQuery += CRLF +" WHERE Z06_FILIAL = '"+xFilial("Z06")+"' AND Z06_PRODUT = '"+ZKC->ZKC_CODPAI+"' "
			cQuery += CRLF +" AND D_E_L_E_T_ = ' ' "

			if Select("TZ06") > 0
				TZ06->(DbCloseArea())
			endif

			MemoWrite("ALTKIT.SQL",cQuery)
			TcQuery cQuery New Alias "TZ06"
        	
        	If TZ06->(Eof())
	        	Z06->(RecLock("Z06",.T.))
	        	
	        	Z06->Z06_FILIAL  := Z06->(xFILIAL("Z06"))
	        	//Z06->Z06_PRODUT  := ZKC->ZKC_SKU
	        	Z06->Z06_PRODUT  := ZKC->ZKC_CODPAI
	        	Z06->Z06_STATUS  := "1"
	        	Z06->Z06_DTINC   := Date()
	        	Z06->Z06_HRINC   := TIME()
	        	Z06->Z06_INTEG   := "S" //INTEGRAR?
	        	
	        	Z06->(MsUnLock())
	        Else

				Z06->(DbGoTo(TZ06->Z06_RECNO))

	        	Z06->(RecLock("Z06",.F.))
	        	
	        	Z06->Z06_FILIAL  := Z06->(xFILIAL("Z06"))
	        	Z06->Z06_STATUS  := "1"
	        	Z06->Z06_DTINC   := Date()
	        	Z06->Z06_HRINC   := TIME()
	        	Z06->Z06_INTEG   := "S" //INTEGRAR?
	        	
	        	Z06->(MsUnLock())	       	
	        Endif
	        
		Endif
		
	//Endif// nRecno

	If Select("Z06") 
		Z06->(DbCloseArea())
	Endif

	If Select("TZ06") 
		TZ06->(DbCloseArea())
	Endif


	RestArea(aArea)
return xRet