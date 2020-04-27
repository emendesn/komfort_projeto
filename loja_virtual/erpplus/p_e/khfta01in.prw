#include 'protheus.ch'
#include 'parmtype.ch'


//--------------------------------------------------------------
/*/{Protheus.doc} KHFTA01IN
Description //P.E na gravação  da inclusão das categorias x Produtos customizadas
			para gravar na tabela intermediária (Z10)
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 20-05-2019 /*/
//--------------------------------------------------------------
user function KHFTA01IN()
	
	Local aArea	:= GetArea()

	Z10->(DbSelectArea('Z10'))
	
	Z10->(dbSetOrder(1))

	if ! ( Z10->(DbSeek(xFilial("Z10")+ZKG->ZKG_CATEGO + ZKG->ZKG_SKU)) )
	
		Z10->( RecLock("Z10",.T.) )
		
		Z10->Z10_FILIAL := xFilial("Z10")
		Z10->Z10_CATEGO := ZKG->ZKG_CATEGO
		Z10->Z10_CODPRO := ZKG->ZKG_SKU
		Z10->Z10_DTINC	:= dDatabase
		Z10->Z10_HRINC	:= Time()
		Z10->Z10_INTEG	:= "S"
		
		Z10->( Msunlock() )
	Else
		Z10->( RecLock("Z10",.F. ) )
		
		Z10->Z10_FILIAL := xFilial("Z10")
		Z10->Z10_CODPRO := ZKG->ZKG_SKU
		Z10->Z10_DTINC	:= Time()
		Z10->Z10_HRINC	:= dDataBase
		Z10->Z10_INTEG	:= "S"
		  	
		Z10->(Msunlock())	
	Endif
	
	Z10->(DbCloseArea())

	RestArea(aArea)
return