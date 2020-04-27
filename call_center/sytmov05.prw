#Include "Protheus.ch"
#Include "RwMake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SYTMOV05 ºAutor  ³ Vinícius Moreira   º Data ³ 30/10/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TELA DE CADASTRO DA TABELA Z01 - TIPOS DE PEDIDO DE VENDA  º±±
±±º          ³ E ORCAMENTOS AUTIMATICOS DO SAC                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION SYTMOV05()

Local cAlias  := "Z01"
Local cTitulo := "Tipos de pedido de venda / orçamentos"
Private aRotAdic := {} //#AFD20180619.N
	
	aAdd(aRotAdic,{"Copiar", "U_fCopia", 0, 6})//#AFD20180619.N


AxCadastro(cAlias, cTitulo, , ,aRotAdic)                 

Return

//---------------------------------------------|
//	Funtion - fCopia() -> //Copia o registro   | 
//	Uso - Komfort House					       |
//  By Alexis Duarte - 19/06/2018  			   |
//---------------------------------------------|
User Function fCopia()
	
	Local aAreaZ01 := Z01->(getArea())
	Local aZ01 := {} 
	
	if msgYesNo("Deseja Copiar o Registro -> "+ Z01->Z01_COD,"ATENÇÃO")
		aAdd(aZ01,{	Z01->Z01_FILIAL,Z01->Z01_TIPO,Z01->Z01_COD,Z01->Z01_TES,;
					Z01->Z01_CONDPG,Z01->Z01_TRANSP,Z01->Z01_DESC,Z01->Z01_OCORR,;
					Z01->Z01_LOCAL,Z01->Z01_TPPEDI,Z01->Z01_RETIRA,;
					Z01->Z01_TESFOR,Z01->Z01_TPMVTO,Z01->Z01_XBXNCC})
		
		recLock("Z01",.T.)

			Z01->Z01_FILIAL := aZ01[1][1]
			Z01->Z01_TIPO 	:= aZ01[1][2]
			Z01->Z01_COD 	:= "COPIA "
			Z01->Z01_TES 	:= aZ01[1][4]
			Z01->Z01_CONDPG := aZ01[1][5]
			Z01->Z01_TRANSP := aZ01[1][6]
			Z01->Z01_DESC 	:= aZ01[1][7]
			Z01->Z01_OCORR 	:= aZ01[1][8]
			Z01->Z01_LOCAL 	:= aZ01[1][9]
			Z01->Z01_TPPEDI := aZ01[1][10]
			Z01->Z01_RETIRA := aZ01[1][11]
			Z01->Z01_TESFOR := aZ01[1][12]
			Z01->Z01_TPMVTO := aZ01[1][13]
			Z01->Z01_XBXNCC := aZ01[1][14]
			
		msUnlock()
	endif
	
	restArea(aAreaZ01)
	
Return .T.
