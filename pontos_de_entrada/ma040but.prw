#include 'protheus.ch'
#include 'parmtype.ch'

User Function MTA040MNU()	

local aArea := getArea()

aadd(aRotina,{'Avaliação Monitoria','U_KHCON001()' , 0 , 3,0,NIL}) 
aadd(aRotina,{'Tela Monitoria','U_KHCON002()' , 0 , 3,0,NIL})  
aadd(aRotina,{'Retor. Clientes','U_KHRETCLI()' , 0 , 3,0,NIL})    		

restArea(aArea)
Return 