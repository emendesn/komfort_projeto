#include 'protheus.ch'
#include 'parmtype.ch'

User Function ConvData(cData)

Local cRetData := ""
Local cDia	:= ""
Local cMes	:= ""
Local cAno	:= ""
Local cTipo := "1" // 1=yyyymmdd/2= dd/dd/dddd

cTipo := iif("/" $ cData,"2","1")

if cTipo == "2"
	cData := Dtos(cTod(cData))	
Endif	

cDia := Right(cData,2)
cMes := SubStr(cData,5,2)
cAno := left(cData,4)

cRetData := cAno + "-" + cMes + "-" + cDia

Return (cRetData)


User Function CWsData(cData)

Local cRetData := ""
Local cDia	:= ""
Local cMes	:= ""
Local cAno	:= ""

cData := StrTran(cData,"-","")

cDia := Right(cData,2)
cMes := SubStr(cData,5,2)
cAno := left(cData,4)

cRetData := cDia + "/" + cMes + "/" +cAno

Return CTOD(cRetData)