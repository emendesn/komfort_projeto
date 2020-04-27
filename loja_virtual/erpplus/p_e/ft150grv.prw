#include 'protheus.ch'
#include 'parmtype.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} FT150GRV
Description //P.E para gravação das categorias na tabela intermediária
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 01-08-2019 /*/
//--------------------------------------------------------------
user function FT150GRV()
	
Local aArea := GetArea()
Local xRet	:= .T.
Local aColsAux := aClone(aCols)
Local nAux	:= 0
Local lDel	:= Iif(INCLUI .or. ALTERA .or. lCopia,.F.,.T.)

Z10->(DbSetOrder(1))//FILIAL+CATEGORIA+PRODUTO

If INCLUI .or. ALTERA
	For nAux := 1 to len(aColsAux)
		if ! ( Z10->(DbSeek(xFilial("Z10")+M->ACV_CATEGO+aColsAux[nAux][3])) )
		
			Z10->( RecLock("Z10",.T.) )
			
			Z10->Z10_CATEGO := M->ACV_CATEGO
			Z10->Z10_CODPRO := aColsAux[nAux][3]
			Z10->Z10_SEQPRD := aColsAux[nAux][8]
			Z10->Z10_DTINC	:= dDatabase
			Z10->Z10_HRINC	:= Time()
			Z10->Z10_INTEG	:= "S"
			
			Z10->( Msunlock() )
		Else
			Z10->( RecLock("Z10",.F. ) )
			
			Z10->Z10_CODPRO := aColsAux[nAux][3]
			Z10->Z10_DTINC	:= Time()
			Z10->Z10_HRINC	:= dDataBase
			Z10->Z10_INTEG	:= "S"
			  	
			Z10->(Msunlock())	
		Endif
	Next nAux
	
ElseIf lDel
	
	For nAux := 1 to len(aColsAux)
		If Z10->( DbSeek(xFilial("Z10")+M->ACV_CATEGO + aColsAux[nAux][3] ) )			
			Z10->( DbDelete() )
		Endif
	Next nAux	
	
Endif	
	
RestArea(aArea)
	 
return xRet