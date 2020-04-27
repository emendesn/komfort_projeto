#include 'protheus.ch'
#include 'parmtype.ch'



/*/{Protheus.doc} FATA140
//TODO : Gravar as categorias na tabela intemediária (Z09)
@author ERPPLUS
@since 30/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function FATA140()


Local aArea 	:= GetArea()
Local xRet		:= .T.
Local aParam	:= PARAMIXB
Local oObj
Local cIdPonto
Local cIdModel 
Local lIsGrid
Local oModel
Local oModelDA1
Local cQuery	:= ""
Local nAux		:= 0

Local cMaster	:= "ACUMASTER"
Local cDetail 	:= ""

If aParam <> Nil
    oObj := aParam[1]
    cIdPonto := aParam[2]
    cIdModel := aParam[3]
    lIsGrid := (Len(aParam) > 3)	
    
    cDetail := Iif(lIsGrid,"ACUDETAIL",cDetail)
    
	If UPPER(ALLTRIM(cIdPonto)) == "FORMCOMMITTTSPRE"	
		oModel   := FWModelActive()					
			
    	Z09->(dbSetOrder(1))
    	//Z09_FILIAL+Z09_COD+Z09_STATUS
    	If !Z09->(dbSeek(xFILIAL("Z09")+oModel:GetValue(cMaster,"ACU_COD")))
        	Z09->(RecLock("Z09",.T.))
        	Z09->Z09_FILIAL  := Z09->(xFILIAL("Z09"))
        	Z09->Z09_STATUS  := IIF(oModel:GetValue(cMaster,"ACU_MSBLQL")== "2","1","2")
        	Z09->Z09_COD 	 := oModel:GetValue(cMaster,"ACU_COD")
        	Z09->Z09_DESC	 := oModel:GetValue(cMaster,"ACU_DESC")
        	//Z09->Z09_DESCC	 := oModel:GetValue(cMaster,"ACU_DESCC")
        	Z09->Z09_DTINC   := dDataBase
        	Z09->Z09_HRINC   := TIME()
        	Z09->Z09_INTEG   := "S"
        	Z09->(MsUnLock())
        Else
         	Z09->(RecLock("Z09",.F.))
        	Z09->Z09_STATUS  := IIF(oModel:GetValue(cMaster,"ACU_MSBLQL")== "2","1","2")
        	Z09->Z09_DESC	 := oModel:GetValue(cMaster,"ACU_DESC")
        	//Z09->Z09_DESCC	 := oModel:GetValue(cMaster,"ACU_DESCC")
        	Z09->Z09_DTINC   := dDataBase
        	Z09->Z09_HRINC   := TIME()
        	Z09->Z09_INTEG   := "S"
        	Z09->(MsUnLock())       	 	      	
        Endif 
			
	Endif
	
Endif

RestArea(aArea)

return xRet