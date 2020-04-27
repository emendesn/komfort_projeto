#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240FIL   ºAutor  ³Rafael Cruz          º Data ³  19.10.18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³O ponto de entrada F240FIL sera utilizado para montar o 	  º±±
±±º          ³filtro para Indregua apos preenchimento da tela de dados do º±±
±±º          ³bordero. O filtro retornado pelo ponto de entrada será 	  º±±
±±º          ³anexado ao filtro padrão do programa.       				  º±±
±±º          ³aRotina na no contas a pagar.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específicos Galderma Brasil                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F240FIL()

Local aPerg		:= {}
Local cRet		:= ""
Local aRetParam	:= {}
Local dEmissao	:= CtoD("")

	If MsgYesNo("Deseja filtrar os títulos por data de emissão?","Filtro Borderô")
	
		aAdd( aPerg ,{1,"Emissão De:  "      , dEmissao  ,"@!"                  ,'.t.',""  ,'.t.'    , 50,.t.})
		aAdd( aPerg ,{1,"Emissão Ate: "      , dEmissao  ,"@!"                  ,'.t.',""  ,'.t.'    , 50,.t.})  
	
		
		If !ParamBox(aPerg ,"Filtro titulos ",@aRetParam)
		
			Return(.F.)
		
		EndIf
		
		cRet := " DTOS(E2_EMISSAO) >= '" + DTOS(aRetParam[1]) + "' .AND. DTOS(E2_EMISSAO) <= '" + DTOS(aRetParam[2]) + "'"
	 
	 Else
	 
	 	Return(.F.)
	 
	 EndIf
	 
Return cRet