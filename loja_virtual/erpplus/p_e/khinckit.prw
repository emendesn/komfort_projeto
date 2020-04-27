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
user function KHINCKIT()

	Local aArea 	:= GetArea()
	Local xRet		:= .T.
	Local aParam	:= PARAMIXB 
	Local nRecno	:= aParam[1] //R_E_C_N_O DA TABELA ZKC
	
	If nRecno > 0 
		ZKC->(DbGoTo(nRecno))
		
        If ZKC->ZKC_ECOM == '1' .AND. ZKC->ZKC_MSBLQL == '2'
        	Z06->(dbSetOrder(1))
        	Z06->(dbSeek(xFILIAL("Z06")+ZKC->ZKC_SKU))
        	If !Z06->(Found())
	        	Z06->(RecLock("Z06",.T.))
	        	
	        	Z06->Z06_FILIAL  := Z06->(xFILIAL("Z06"))
	        	Z06->Z06_PRODUT  := ZKC->ZKC_SKU
	        	Z06->Z06_STATUS  := "1"
	        	Z06->Z06_DTINC   := Date()
	        	Z06->Z06_HRINC   := TIME()
	        	Z06->Z06_INTEG   := "S" //INTEGRA ?
	        	
	        	Z06->(MsUnLock())
	        Else
	        	Z06->(RecLock("Z06",.F.))
	        	
	        	Z06->Z06_FILIAL  := Z06->(xFILIAL("Z06"))
	        	Z06->Z06_STATUS  := "1"
	        	Z06->Z06_DTINC   := Date()
	        	Z06->Z06_HRINC   := TIME()
	        	Z06->Z06_INTEG   := "S" //INTEGRA ?
	        	
	        	Z06->(MsUnLock())	        	
	        Endif
	        
		Endif//
		
	Endif// nRecno
	
	RestArea(aArea)
return xRet

