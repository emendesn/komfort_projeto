#INCLUDE "TCBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KMSACZL2 ºAutor  ³ Vanito Rocha       º Data ³ 28/06/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de Etiquetas Impressas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function KMSACZL2()

Local aCores		:= {}
Local aLegenda		:= {}
Private cPerg 		:= "KMSZL2"


Private cCadastro := "Etiquetas Impressas"

Private aRotina := {{"Pesquisa"        ,"AxPesqui"                   	, 00, 1},;
            		{"Visualizar"      ,"AxVisual"              	   	, 00, 2},;
            		{"Incluir"  	   ,"AxInclui"              	   	, 00, 3},;
            		{"Alterar"  	   ,"AxAltera"              	   	, 00, 4},;            		
					{"Excluir"   	   ,"AxExclui"					    , 00, 5},;           		
					{"Etiquetar"	   ,"U_KMTRANSF"					, 00, 6},;
					{"Enderecar"	   ,"U_KHENPROD"					, 00, 7},;
					{"Liberar Ender"   ,"U_KHLIBEND"					, 00, 8},;
					{"Legenda  "	   ,"U_ZL2LEG"						, 00, 9}}

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

dbSelectArea("ZL2")
dbSetOrder(1)

aCores    	:= {{'ZL2_ENDER=="S"'	,'BR_VERMELHO'	},;
{'ZL2_ENDER=="N"'	,'ENABLE'	} }

mBrowse( 6,1,22,75,"ZL2",,,,,,aCores)

Return


User Function ZL2LEG()

Local  aLegenda := {}

aAdd( aLegenda, { "BR_VERDE" 	, "Pendente Endereçamento" } )
aAdd( aLegenda, { "BR_VERMELHO"	, "Endereçado" } )

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return .T.


User Function KHLIBEND()

Local dData1
Local dData2
Local cPerg := "KHLIBEN"
Local cQuery:=""

fAjustSX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif

If lOk
	
	cQuery := " UPDATE 	"+RetSqlName("ZL2")	+ CRLF
	cQuery += "	SET		ZL2_ENDER='S',"	+ CRLF
	cQuery += "			ZL2_QUANT=0   "	+ CRLF
	cQuery += "	WHERE	ZL2_DTIMPR  >= '"+MV_PAR01+"'" + CRLF
	cQuery += " AND ZL2_DTIMPR	<= '"+MV_PAR02+"'" + CRLF
	cQuery += " AND D_E_L_E_T_   = ' '  "
	
	TcSqlExec(cQuery)
	
Endif

Return

Static Function fAjustSX1(cPerg)

Local _aArea	:= GetArea()
Local aRegs		:= {}

dbSelectArea("SX1")
dbSetOrder(1)

PutSx1(cPerg,"01","Data de 				?","","","MV_CH1","C",TamSx3("C5_EMISSAO")[1] 	,, ,"G",,""		,,,"MV_PAR01",			,,,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Data ate		   		?","","","MV_CH2","C",TamSx3("C5_EMISSAO")[1]	,, ,"G",,""		,,,"MV_PAR02",  		,,,,,,,,,,,,,,,,,,)

RestArea(_aArea)

Return
