#include "protheus.ch"
#include "totvs.ch"

//-----------------------------------------------------|
//	Funtion - KMFINR07() -> Re-Impressão de RA		   |
//  Parametros ->> Nil	<<-----------------------------|
//  By Alexis Duarte - 24/04/2018 - KOMFORT HOUSE -----|
//-----------------------------------------------------|

User Function KMFINR07()

	cPerg := "KMFINR07"
	
	ValidPerg(cPerg)	

	If !Pergunte(cPerg,.T.)
		MsgAlert("Operação cancelada pelo Usuario.")
		Return(Nil)
	EndIf                                                                                                                                                             
    
	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))  
	
	if SE1->(DbSeek(xFilial("SE1") + MV_PAR02 + MV_PAR01))                                                                                                                
		U_KMFINR03(mv_par01,mv_par02)
	else
		MsgAlert("Titulo: "+ MV_PAR01 +" Prefixo: "+ MV_PAR02 +" Informado não existe!!!")
	endif
	
Return


//--------------------------------------------------------------|
//	Funtion - ValidPerg() -> Validação e criação dos perguntes  |
//  Parametros ->> cPerg    <<----------------------------------|
//  By Alexis Duarte - 24/04/2018 - KOMFORT HOUSE --------------|
//--------------------------------------------------------------|

Static Function ValidPerg(cPerg)

	Local aArea := GetArea()
	Local cPerg := PADR(cPerg,10)
	Local aRegs := {}
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	if !dbseek(cPerg)
		
//		AADD(aRegs,{cPerg,"01"	,"Informe o Titulo:"	,""	,"", "mv_ch1" ,"C",09,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SE1RA"	,""})				//#RVC20180511.o
		AADD(aRegs,{cPerg,"01"	,"Informe o Titulo:"	,""	,"", "mv_ch1" ,"C",09,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SE1RA"	,"","","","@!",""})	//#RVC20180511.n
//		AADD(aRegs,{cPerg,"02"	,"Informe o Prefixo:"  	,""	,"", "mv_ch2" ,"C",03,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""		,""})				//#RVC20180511.o
		AADD(aRegs,{cPerg,"02"	,"Informe o Prefixo:"  	,""	,"", "mv_ch2" ,"C",03,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","","@!",""})	//#RVC20180511.n
	
	endif

	for i:=1 to len(aRegs)
		if !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Else
					exit
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbcloseArea()
	RestArea(aArea)
	
Return
