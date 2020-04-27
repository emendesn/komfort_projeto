#Include "Protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FC010BTN บAutor  ณ Eduardo Patriani   บ Data ณ  12/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na consulta posicao de clientes para      บฑฑ
ฑฑบ          ณ exibicao de outras informacoes do clientes.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FC010BTN()


If Paramixb[1] == 1            // Deve retornar o nome a ser exibido no botใo

       Return "Outras Informa็๕es"


ElseIf Paramixb[1] == 2        // Deve retornar a mensagem do botใo (Show Hint)

       Return "Exibe Outras Informa็๕es do Cliente"


Else                          // Rotina a ser executada ao pressionar o botใo

	A010inf()


Endif

Static Function A010inf()

Local nAviso	:= 0

nAviso := Aviso( "Posi็ao do Cliente" , "Selecione uma op็ใo" , { "OC" , "TEC" } )

If nAviso==1
	MostraOC()
Else
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MostraOC บAutor  ณ Eduardo Patriani   บ Data ณ  12/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os pedidos de compra do cliente.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  
Static Function MostraOC()

Local aArea  	:= GetArea()
Local cQuery 	:= ""   
Local cTitulo	:= "Consulta Ordens de Compra"
Local oOk    	:= LoadBitmap( GetResources(), "BR_VERDE" )
Local oNo    	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
Local cAlias 	:= GetNextAlias()
Local aSize		:= MsAdvSize( .F. )
Local aArray 	:= {}
Local aPosObj1	:= {}                 
Local aObjects	:= {}                       

Local oLbx	 := Nil

cQuery += " SELECT C7_FILIAL,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE,C7_PRECO,C7_TOTAL,C7_DATPRF,C7_FORNECE,C7_LOJA "
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SC7")+" SC7 ON C7_NUM = LEFT(UB_01PEDCO,6) AND C7_ITEM = RIGHT(UB_01PEDCO,4) AND SC7.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " SUA.UA_FILIAL = SUB.UB_FILIAL "
cQuery += " AND SUB.UB_01PEDCO 	<> ' ' "
cQuery += " AND SUA.UA_CLIENTE 	= '"+SA1->A1_COD+"' "
cQuery += " AND SUA.UA_LOJA 	= '"+SA1->A1_LOJA+"' "
cQuery += " AND SUA.UA_CANC		= ' ' "
cQuery += " AND SC7.C7_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND SC7.C7_RESIDUO <> 'R' "
cQuery += " ORDER BY UA_CLIENTE,UA_LOJA,UB_01PEDCO "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias, "C7_DATPRF", "D", TamSx3("C7_DATPRF")[1], TamSx3("C7_DATPRF")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())	

	AAdd( aArray , { ( (cAlias)->C7_QUANT <> (cAlias)->C7_QUJE ) , (cAlias)->C7_FILIAL,(cAlias)->C7_NUM,(cAlias)->C7_ITEM,(cAlias)->C7_PRODUTO,(cAlias)->C7_DESCRI,(cAlias)->C7_QUANT,(cAlias)->C7_QUJE,0,0,(cAlias)->C7_DATPRF,(cAlias)->C7_FORNECE,(cAlias)->C7_LOJA } )	

	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

If Len( aArray ) == 0
	Aviso( cTitulo, "Nao existe ordens de compra para este cliente", {"Ok"} )
	Return
Endif

aObjects := {}
AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
AAdd( aObjects, { 100, 100 , .t., .t. } )
AAdd( aObjects, { 100, 50 , .t., .f. } )

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj1 := MsObjSize( aInfo, aObjects)

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE cTitulo OF oMainWnd PIXEL
@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oScrPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlg LOWERED

@ 04,004 SAY OemToAnsi("Codigo") SIZE 025,07          OF oScrPanel PIXEL
@ 12,004 SAY SA1->A1_COD  SIZE 060,09  OF oScrPanel PIXEL FONT oBold

@ 04,067 SAY OemToAnsi("Loja") SIZE 020,07          OF oScrPanel PIXEL
@ 12,067 SAY SA1->A1_LOJA SIZE 021,09 OF oScrPanel PIXEL FONT oBold

@ 04,090 SAY OemToAnsi("Nome") SIZE 025,07 OF oScrPanel PIXEL
@ 12,090 SAY SA1->A1_NOME SIZE 165,09 OF oScrPanel PIXEL FONT oBold

@ aPosObj1[2,1],aPosObj1[2,2] LISTBOX oLbx FIELDS HEADER ;
   " ", "Filial", "Pedido", "Item", "Produto", "Descri็ใo", "Quantidade", "Qtde.Entregue", "Pre็o" , "Total" , "Data Entrega" ;
   "Fornecedor" , "Loja" SIZE aPosObj1[2,4],aPosObj1[2,3] OF oDlg PIXEL	

oLbx:SetArray( aArray )
oLbx:bLine := {|| {IIF(	aArray[oLbx:nAt,1],oOk,oNo),;
	                    aArray[oLbx:nAt,2],;
	                    aArray[oLbx:nAt,3],;
						aArray[oLbx:nAt,4],;
	                   	aArray[oLbx:nAt,5],;
	                   	Posicione("SB1",1,xFilial("SB1")+aArray[oLbx:nAt,5],"B1_DESC"),;
	                   	Transform(aArray[oLbx:nAt,7]	,PesqPict('SC7','C7_QUANT' )),;
	                   	Transform(aArray[oLbx:nAt,8]	,PesqPict('SC7','C7_QUJE'  )),;
	                   	Transform(aArray[oLbx:nAt,9]	,PesqPict('SC7','C7_PRECO' )),;
	                   	Transform(aArray[oLbx:nAt,10]	,PesqPict('SC7','C7_TOTAL' )),;
	                   	Transform(aArray[oLbx:nAt,11]	,PesqPict('SC7','C7_DATPRF')),;
	                   	aArray[oLbx:nAt,11],;
	                   	aArray[oLbx:nAt,12]}}
	                    
DEFINE SBUTTON FROM 300,625 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

RestArea(aArea)

Return