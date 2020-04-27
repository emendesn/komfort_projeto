#INCLUDE "PROTHEUS.CH"
#INCLUDE "parmtype.ch"




USER FUNCTION ITEM()
	Local aArea 	:= GetArea()
	Local xRet		:= .T.
	Local aParam	:= PARAMIXB
	Local oObj
	Local cIdPonto
	Local cIdModel 
	Local lIsGrid
	
	
	If aParam <> Nil
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)	
        
        If UPPER(ALLTRIM(cIdPonto)) == "FORMCOMMITTTSPOS"
        	// Inclusão do produto para integração RAKUTEN
        	If M->B1_PROMOC == 'S'
	        	Z06->(dbSetOrder(1))
	        	Z06->(dbSeek(xFILIAL("Z06")+M->B1_COD))
	        	If !Z06->(Found())
		        	Z06->(RecLock("Z06",.T.))
		        	Z06->Z06_FILIAL  := Z06->(xFILIAL("Z06"))
		        	Z06->Z06_PRODUT  := SB1->B1_COD
		        	Z06->Z06_STATUS  := "1"
		        	Z06->Z06_DTINC   := Date()
		        	Z06->Z06_HRINC   := TIME()
		        	Z06->Z06_INTEG   := "S"
		        	Z06->(MsUnLock())
		        Endif
			Endif
	    Endif
	Endif	
	
	RestArea(aArea)
RETURN xRet