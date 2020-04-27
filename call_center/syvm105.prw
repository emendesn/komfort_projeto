#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CRLF CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVM105  บAutor  ณEduardo Patriani    บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao das comissoes dos funcionarios.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SYVM105()

Local cCadastro 	:= OemToAnsi("Manuten็ใo de Comiss๕es")
Local cPerg			:= Padr('SYVM0105',10)
Local aSays	  		:= {}
Local aButtons		:= {}
Local aBtok			:= {}
Local aPosObj   	:= {}
Local aObjects  	:= {}
Local aSize     	:= {}
Local aPosGet   	:= {}
Local aInfo     	:= {}
Local nOpca			:= 0
Local nOpcX			:= 0
Local cIDUser		:= __cUserID					// Guarda o ID do usuario atual
Local cGrpGer		:= GetMv("MV_SYGRPGE",,"000000|000002")

Private oFolder
Private aTELA[0][0]
Private aGETS[0]

Private aHeadP1
Private aColsP1
Private aAltP1
Private oGetP1

Private aHeadP2
Private aColsP2
Private aAltP2
Private oGetP2

Private aHeadP3
Private aColsP3
Private aAltP3
Private oGetP3

Private aHeadP4
Private aColsP4
Private aAltP4
Private oGetP4

Private aHeadP5
Private aColsP5
Private aAltP5
Private oGetP5 

Private oDlg
Private oEnchoice
Private oPanelGet
Private aAux 		:= {}
Private aBkp 		:= {}
Private aBonus		:= {}

Private cLocDep 	:= GetMv("MV_SYLOCDP",,"100001")                        
Private cString		:= ""
Private nValorVda 	:= 0
Private nVlrCotaLjs	:= 0
Private nTotalVdas	:= 0
Private cDataIni
Private cDataFim
Private dDtVencto

Private bForeColor  := &("{||	Iif( oGetP2:aCols[oGetP2:oBrowse:nAt,5] < 0 , " + Str(CLR_RED) + " , " + Str(CLR_BLACK) + " ) }")

A105SX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif

SZ6->(DbSetOrder(1))
SZ6->(DbSeek(xFilial("SZ6") + MV_PAR01))

cDataIni 	:= Dtos(SZ6->Z6_DTINI)		//Data Inicial
cDataFim 	:= Dtos(SZ6->Z6_DTFIM)		//Data Final
dDtVencto   := SZ6->Z6_DTFIM			//Data Vencto
nTotalVdas  := PesqVlrVdas() 			//Somatoria das vendas de todas as lojas para calculo da comissao dos supervisores

AADD(aSays,OemToAnsi( "Este programa tem como objetivo gerar as comiss๕es dos funcionแrios, "))
AADD(aSays,OemToAnsi( "de acordo com as cotas cadastradas e as vendas geradas de cada loja. "))

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
If nOpca == 1

	MontaHeader(@aHeadP1,@aHeadP2)
	
	oVendedor:= MsNewProcess():New({|lEnd| CarregaVend() }		,"Aguarde", "Carregando Comiss๕es dos Vendedores...",.F.)
	oVendedor:Activate()
	
	If Len(aColsP1) > 0

		oGerente:= MsNewProcess():New({|lEnd|  CarregaGere() }		,"Aguarde", "Carregando Comiss๕es dos Gerentes...",.F.)
		oGerente:Activate()
		
		oSuper:= MsNewProcess():New({|lEnd|  CarregaSuper() }		,"Aguarde", "Carregando Comiss๕es dos Supervisores...",.F.)
		oSuper:Activate()
		
		If !Empty(cString)
			oProduto:= MsNewProcess():New({|lEnd|  CarregaProd() }	,"Aguarde", "Carregando Comiss๕es de Produtos...",.F.)
			oProduto:Activate()
		Endif
		
	Endif
Else
	Return	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o calculo automatico de dimensoes de objetos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE FONT oFntBut NAME "Arial" SIZE 0, -20

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

oFolder:=TFolder():New(0,0,{"Vendedore(s)","Gerente(s)","Supervisor(es)","Produto(s)"},,oDlg,,,,.T.,.F.,0,0)
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

If Alltrim(cIDUser) $ cGrpGer
	oFolder:aEnable(3,.F.)
Else
	oFolder:aEnable(3,.T.)
Endif

oPanel1			:= TPanel():New(0, 0, '', oFolder:aDialogs[1], NIL, .T., .F., NIL, NIL, 0,100, .T., .F. )
oPanel1:Align 	:= CONTROL_ALIGN_TOP

oPanel2			:= TPanel():New(0, 0, '', oFolder:aDialogs[1], NIL, .T., .F., NIL, NIL, 0,0 , .T., .F. )
oPanel2:Align 	:= CONTROL_ALIGN_ALLCLIENT

oGetP1:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AlwaysTrue","AlwaysTrue","",{""},,,,,,oPanel1,@aHeadP1,@aColsP1)
oGetP1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP1:lDelete := .F.
oGetP1:GoTop()
oGetP1:BCHANGE:={|| 	MudaVendedor(@aColsP2,oGetP1:ACOLS[oGetP1:NAT][aScan(aHeadP1,{ |x| Alltrim(x[2])=="VENDED"})],oPanel2,aPosObj),oGetP1:oBrowse:Refresh() }

oGetP2:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AlwaysTrue","AlwaysTrue","",{""},,,,,,oPanel2,@aHeadP2,@aColsP2)
oGetP2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP2:lDelete := .F.
oGetP2:oBrowse:SetBlkColor(bForeColor)
//oGetP2:GoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaco backup para trabalhar com a propriedade BChangeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aBkp := aClone(oGetP2:aCols)

oPanel3			:= TPanel():New(0, 0, '', oFolder:aDialogs[2], NIL, .T., .F., NIL, NIL, 0,0 , .T., .F. )
oPanel3:Align 	:= CONTROL_ALIGN_ALLCLIENT

oGetP3:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AlwaysTrue","AlwaysTrue","",{""},,,,,,oPanel3,@aHeadP3,@aColsP3)
oGetP3:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP3:lDelete := .F.
oGetP3:GoTop()

oPanel4			:= TPanel():New(0, 0, '', oFolder:aDialogs[3], NIL, .T., .F., NIL, NIL, 0,0 , .T., .F. )
oPanel4:Align 	:= CONTROL_ALIGN_ALLCLIENT

oGetP4:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AlwaysTrue","AlwaysTrue","",{""},,,,,,oPanel4,@aHeadP4,@aColsP4)
oGetP4:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP4:lDelete := .F.
oGetP4:GoTop()

oPanel5			:= TPanel():New(0, 0, '', oFolder:aDialogs[4], NIL, .T., .F., NIL, NIL, 0,0 , .T., .F. )
oPanel5:Align 	:= CONTROL_ALIGN_ALLCLIENT

oGetP5:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AlwaysTrue","AlwaysTrue","",{""},,,,,,oPanel5,@aHeadP5,@aColsP5)
oGetP5:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetP5:lDelete := .F.
oGetP5:GoTop()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| IIF( m105Sair(oGetP1,oGetP2,oGetP3) , oDlg:End() , .F. ) } , {|| oDlg:End() },,aBtok)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaVend  บAutor ณ SYMM             บ Data ณ  14/05/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregas as comissoes dos vendedores.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaVend()

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local nCredito 	:= 0
Local nValor	:= 0
Local nVlrCanc	:= 0
Local nCancela	:= 0
Local cQuery 	:= ''
Local nVendedor	:= ''

aColsP1 := {}
aColsP2	:= {}

cQuery += " SELECT FILIAL, PEDIDO, VENDEDOR, SUM((VALOR+FRETE)-(DESCONTO+CREDITO)) VALOR, COTA_LOJA, COTA_MENSAL, EMISSAO FROM ( "+CRLF
cQuery += " SELECT UB_FILIAL FILIAL, UB_NUM PEDIDO,UA_VEND VENDEDOR,SUM(UB_VLRITEM)VALOR,Z3_COTAUSR COTA_MENSAL, Z3_COTALJ COTA_LOJA, UA_FRETE FRETE, UA_DESCONT DESCONTO, 0 CREDITO, UA_EMISSAO EMISSAO "+CRLF
cQuery += " FROM "+RetSqlName("SUB")+" SUB "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON UA_VEND=Z3_CODVEND AND Z3_FILIAL = '"+xFilial("SZ3")+"' AND Z3_CODCOMP = '"+Mv_Par01+"' AND SZ3.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " WHERE "+CRLF
cQuery += " SUA.UA_FILIAL = '"+xFilial("SUA")+"' "+CRLF
cQuery += " AND SUA.UA_FILIAL=SUB.UB_FILIAL "+CRLF
cQuery += " AND SUA.UA_VEND   <> ' ' "+CRLF
//cQuery += " AND SUA.UA_VEND   =  '000111' "+CRLF
cQuery += " AND SUA.UA_CANC   =  ' ' "+CRLF
cQuery += " AND SUA.UA_PEDPEND IN('3','5') "+CRLF
cQuery += " AND SUA.UA_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "+CRLF
//cQuery += " AND SUB.UB_01CANC = ' ' "+CRLF
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " GROUP BY UB_FILIAL,UB_NUM,UA_VEND,Z3_COTAUSR,Z3_COTALJ,UA_FRETE,UA_DESCONT,UA_EMISSAO "+CRLF
cQuery += " ) AS TABELA "+CRLF
cQuery += " GROUP BY FILIAL, PEDIDO, VENDEDOR, COTA_LOJA, COTA_MENSAL, EMISSAO "+CRLF
cQuery += " ORDER BY VENDEDOR,PEDIDO "+CRLF

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,"EMISSAO","D",TamSx3("UA_EMISSAO")[1],TamSx3("UA_EMISSAO")[2])

(cAlias)->(DbGotop())
oVendedor:SetRegua1( (cAlias)->(RecCount()) )
While (cAlias)->(!Eof())
	
	nVlrCanc := 0	
	nCancela := 0
	nCredito := 0
	nValor	 := 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnalisa itens cancelados                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SUA->(DbSetOrder(1))
	SUA->(DbSeek((cAlias)->FILIAL+(cAlias)->PEDIDO))
	If (SUA->UA_DESCONT > 0) .Or. (SUA->UA_DESCONT = 0)
		nCancela := RetVlrCancel( (cAlias)->FILIAL,(cAlias)->PEDIDO )
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFiltra pedidos cancelado que ja foram entregues para abatimen-ณ
	//ณto da comissao.                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	If nVendedor <> (cAlias)->VENDEDOR
		FilPedCanc((cAlias)->FILIAL,(cAlias)->VENDEDOR,@nVlrCanc,.T.)
		nVendedor := (cAlias)->VENDEDOR
	Endif
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnalisa creditos concedidos ao cliente.                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	nCredito := RetVlrCredito((cAlias)->FILIAL,(cAlias)->PEDIDO)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValor Total atualizado.                   				 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	//nValor := (cAlias)->VALOR - (nCancela+nCredito)
	//nValor := ( (cAlias)->VALOR+nCredito ) - nCancela
	nValor := (cAlias)->VALOR - nCancela
		
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3")+(cAlias)->VENDEDOR))
	
	oVendedor:IncRegua1("Processando Vendedor: " + (cAlias)->VENDEDOR+"-"+SA3->A3_NOME )
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaCols dos Vendedores.	                   				 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	nPos := Ascan( aColsP1 ,{|x| x[1]+x[2] == (cAlias)->FILIAL+(cAlias)->VENDEDOR })
	If nPos == 0
		AAdd( aColsP1 , { '' , '' , '' , 0 , 0 , 0 , 0 , 0 , 0 , 0, .F. } )
		nPos := Len(aColsP1)
	EndIf
	aColsP1[nPos,01]	:= (cAlias)->FILIAL
	aColsP1[nPos,02] 	:= (cAlias)->VENDEDOR
	aColsP1[nPos,03] 	:= SA3->A3_NOME
	aColsP1[nPos,04] 	+= nValor
	aColsP1[nPos,05] 	+= nVlrCanc
	aColsP1[nPos,06] 	+= nValor - nVlrCanc
	aColsP1[nPos,07] 	:= (cAlias)->COTA_MENSAL
	aColsP1[nPos,08] 	:= Round((aColsP1[nPos,6]/(cAlias)->COTA_MENSAL)*100,2)
	aColsP1[nPos,09] 	:= 0
	aColsP1[nPos,10] 	:= 0
	aColsP1[nPos,11] 	:= .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaCols das Vendas.		                   				 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	AAdd( aColsP2 , { (cAlias)->FILIAL, (cAlias)->VENDEDOR,(cAlias)->EMISSAO, (cAlias)->PEDIDO, nValor, 0, 0, .F. } )
	                    
	nValorVda += nValor - nVlrCanc
		
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula oo valor a pagar da comissao de cada vendedor conformeณ
//ณa tabela de percentuais                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nY := 1 To Len(aColsP1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso o vendedor atingir a cota, vai receber um percentual     ณ
	//ณsobre todos produtos informados no cadastro de cotas.         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aColsP1[nY,6] >= 100
		cString += "'"+aColsP1[nY,2]+"',"
	Endif
		
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + aColsP1[nY,2] ))
	
	SZ4->(DbSetOrder(1))
	SZ4->(DbSeek(xFilial("SZ4") + SA3->A3_01TIPO ))
	While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL+SZ4->Z4_TIPO == xFilial("SZ4") + SA3->A3_01TIPO
		
		If aColsP1[nY,8] 	<= SZ4->Z4_COND
			aColsP1[nY,9]	:= SZ4->Z4_PERCEN
			aColsP1[nY,10]	:= Round((aColsP1[nY,6]*SZ4->Z4_PERCEN)/100,2)
			Exit
		Endif
		
		SZ4->(DbSkip())
	End
Next
If !Empty(cString)
	cString := Substr(cString,1,Len(cString)-1)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula oo valor de cada comissao por venda realizada.        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oVendedor:SetRegua2(Len(aColsP2))
For nI := 1 To Len(aColsP2)
	
	oVendedor:IncRegua2("Processando Pedido:" + aColsP2[nI,2])
	
	nPos := Ascan( aColsP1 ,{|x| x[2] == aColsP2[nI,2] })
	If nPos > 0
		aColsP2[nI,6] 	:= aColsP1[nPos,9]
		aColsP2[nI,7]	:= Round((aColsP2[nI,5]*aColsP2[nI,6])/100,2)
	Endif
	
Next
Sleep(1000)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaGereบAutor  ณ SYMM              บ Data ณ  14/05/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregas as comissoes dos gerentes.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaGere()
                  
Local cQuery  := ""
Local cAlias  := GetNextAlias()

aColsP3	:= {}

cQuery := " SELECT DISTINCT Z3_FILIAL FILIAL, Z3_CODCOMP COMPETENCIA, Z3_COTALJ COTA_LOJA, Z3_CODVEND GERENTE, Z3_NOMEVEN NOME, Z3_COTAUSR COTA_USR "
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3 "
cQuery += " WHERE SZ3.Z3_CODCOMP = '"+Mv_Par01+"' "
cQuery += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQuery += " AND SZ3.Z3_TIPOUSR = '2' "
cQuery += " AND SZ3.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
oGerente:SetRegua1( (cAlias)->(RecCount()) )
While (cAlias)->(!Eof())

	oGerente:IncRegua1("Processando Gerente: " + (cAlias)->GERENTE+"-"+(cAlias)->NOME )
		
	nPos := Ascan( aColsP3 ,{|x| x[1]+x[2] == (cAlias)->FILIAL+(cAlias)->GERENTE })
	If nPos == 0
		AAdd( aColsP3 , { '' , '' , '' , 0 , 0 , 0 , 0 , 0, .F. } )
		nPos := Len(aColsP3)
	EndIf
	aColsP3[nPos,1]	:=	(cAlias)->FILIAL
	aColsP3[nPos,2] := 	(cAlias)->GERENTE
	aColsP3[nPos,3] := 	(cAlias)->NOME
	aColsP3[nPos,4] := 	nValorVda
	aColsP3[nPos,5] := 	(cAlias)->COTA_USR
	aColsP3[nPos,6] := 	Round((aColsP3[nPos,4]/(cAlias)->COTA_USR)*100,2)
	aColsP3[nPos,7] := 	0
	aColsP3[nPos,8] := 	0
	aColsP3[nPos,9] := 	.F.
		
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula oo valor a pagar da comissao de cada gerente conforme ณ
//ณa tabela de percentuais                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGerente:SetRegua2(Len(aColsP3))
For nY := 1 To Len(aColsP3)

	oGerente:IncRegua2("Processando Pedido...")	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso o vendedor atingir a cota, vai receber um percentual     ณ
	//ณsobre todos produtos informados no cadastro de cotas.         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aColsP3[nY,6] >= 70
		AAdd( aBonus , { aColsP3[nY,1], aColsP3[nY,2], aColsP3[nY,3], "Gerente" } )	
	Endif
	
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + aColsP3[nY,2] ))
	
	SZ4->(DbSetOrder(1))
	SZ4->(DbSeek(xFilial("SZ4") + SA3->A3_01TIPO ))
	While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL+SZ4->Z4_TIPO == xFilial("SZ4") + SA3->A3_01TIPO
		
		If aColsP3[nY,6] 	<= SZ4->Z4_COND
			aColsP3[nY,7]	:= SZ4->Z4_PERCEN
			aColsP3[nY,8]	:= Round((aColsP3[nY,4]*SZ4->Z4_PERCEN)/100,2)
			Exit
		Endif
		
		SZ4->(DbSkip())
	End
Next

Sleep(1000)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaSuperบAutor  ณ SYMM             บ Data ณ  14/05/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregas as comissoes dos supervisores.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaSuper()
                  
Local cQuery  := ""
Local cAlias  := GetNextAlias()

aColsP4	:= {}

cQuery := " SELECT DISTINCT Z3_FILIAL FILIAL, Z3_CODCOMP COMPETENCIA, Z3_COTALJ COTA_LOJA, Z3_CODVEND SUPERVISOR, Z3_NOMEVEN NOME, Z3_COTAUSR COTA_USR "
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3 "
cQuery += " WHERE SZ3.Z3_CODCOMP = '"+Mv_Par01+"' "
cQuery += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQuery += " AND SZ3.Z3_TIPOUSR = '3' "
cQuery += " AND SZ3.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
oSuper:SetRegua1( (cAlias)->(RecCount()) )
While (cAlias)->(!Eof())

	oSuper:IncRegua1("Processando Supervisor: " + (cAlias)->SUPERVISOR+"-"+(cAlias)->NOME )
		
	nPos := Ascan( aColsP4 ,{|x| x[1]+x[2] == (cAlias)->FILIAL+(cAlias)->SUPERVISOR })
	If nPos == 0
		AAdd( aColsP4 , { '' , '' , '' , 0 , 0 , 0 , 0 , 0, .F. } )
		nPos := Len(aColsP4)
	EndIf
	aColsP4[nPos,1]	:=	(cAlias)->FILIAL
	aColsP4[nPos,2] := 	(cAlias)->SUPERVISOR
	aColsP4[nPos,3] := 	(cAlias)->NOME
	aColsP4[nPos,4] :=  nTotalVdas	
	aColsP4[nPos,5] := 	(cAlias)->COTA_USR
	aColsP4[nPos,6] := 	Round((aColsP4[nPos,4]/(cAlias)->COTA_USR)*100,2)
	aColsP4[nPos,7] := 	0
	aColsP4[nPos,8] := 	0
	aColsP4[nPos,9] := 	.F.
		
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula oo valor a pagar da comissao de cada gerente conforme ณ
//ณa tabela de percentuais                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nY := 1 To Len(aColsP4)
	
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + aColsP4[nY,2] ))
	
	SZ4->(DbSetOrder(1))
	SZ4->(DbSeek(xFilial("SZ4") + SA3->A3_01TIPO ))
	While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL+SZ4->Z4_TIPO == xFilial("SZ4") + SA3->A3_01TIPO
		
		If aColsP4[nY,6] 	<= SZ4->Z4_COND
			aColsP4[nY,7]	:= SZ4->Z4_PERCEN
			aColsP4[nY,8]	:= Round((aColsP4[nY,4]*SZ4->Z4_PERCEN)/100,2)
			Exit
		Endif
		
		SZ4->(DbSkip())
	End
Next

Sleep(1000)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CarregaProd บAutor ณ SYMM             บ Data ณ  14/05/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregas as comissoes dos produtos.	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CarregaProd()

Local cQuery  := ""
Local cAlias  := GetNextAlias()

aColsP5	:= {}

cQuery := " SELECT C6_FILIAL FILIAL,C5_VEND1 VENDEDOR, C6_PRODUTO PRODUTO, SUM(C6_VALOR) VALOR, Z3_PERCVEN PERCVEN, Z3_PERCGER PERCGER "
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_NUM=C6_NUM AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON Z3_FILIAL = '"+xFilial("SZ3")+"' AND Z3_CODPRO=C6_PRODUTO AND SZ3.D_E_L_E_T_ = ' ' "
cQuery += " WHERE SC6.C6_FILIAL IN('"+cLocDep+"','"+xFilial("SC6")+"') "
cQuery += " AND SC6.C6_BLQ <> 'R' "
cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SC5.C5_VEND1 IN ("+cString+") "
cQuery += " AND SC5.C5_01COMPE =  ' ' "
cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
cQuery += " AND SZ3.Z3_CODCOMP = '"+Mv_Par01+"' "
cQuery += " GROUP BY C6_FILIAL,C5_VEND1,C6_PRODUTO,Z3_PERCVEN,Z3_PERCGER "
cQuery += " ORDER BY C6_FILIAL,C5_VEND1,C6_PRODUTO "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
oProduto:SetRegua1( (cAlias)->(RecCount()) )
While (cAlias)->(!Eof())

	oProduto:IncRegua1("Processando Produtos..." )
		
	nPos := Ascan( aColsP5 ,{|x| x[1]+x[2] == (cAlias)->FILIAL+(cAlias)->VENDEDOR })
	If nPos == 0
		AAdd( aColsP5 , { '' , '' , '' , '' , '' , '' , 0 , 0, 0, .F. } )
		nPos := Len(aColsP5)
	EndIf
	aColsP5[nPos,1]	:=	(cAlias)->FILIAL
	aColsP5[nPos,2] :=	(cAlias)->VENDEDOR
	aColsP5[nPos,3] := 	Posicione("SA3",1,xFilial("SA3")+(cAlias)->VENDEDOR,"A3_NOME")
	aColsP5[nPos,4] := 	"Vendedor"	
	aColsP5[nPos,5] := 	(cAlias)->PRODUTO
	aColsP5[nPos,6] := 	Posicione("SB1",1,xFilial("SB1")+(cAlias)->PRODUTO,"B1_DESC")
	aColsP5[nPos,7] := 	(cAlias)->VALOR
	aColsP5[nPos,8] := 	(cAlias)->PERCVEN
	aColsP5[nPos,9] := 	Round((aColsP5[nPos,7]*(cAlias)->PERCVEN)/100,2)
	aColsP5[nPos,10]:= 	.F.
	
	If Len(aBonus) > 0
		For nX := 1 To Len(aBonus)

			AAdd( aColsP5 , { '' , '' , '' , '' , '' , '' , 0 , 0, 0, .F. } )
			nPos := Len(aColsP5)
			
			aColsP5[nPos,1]	:=	aBonus[nX,1]
			aColsP5[nPos,2] :=	aBonus[nX,2]
			aColsP5[nPos,3] := 	aBonus[nX,3]
			aColsP5[nPos,4] := 	aBonus[nX,4]
			aColsP5[nPos,5] := 	(cAlias)->PRODUTO
			aColsP5[nPos,6] := 	Posicione("SB1",1,xFilial("SB1")+(cAlias)->PRODUTO,"B1_DESC")
			aColsP5[nPos,7] := 	(cAlias)->VALOR
			aColsP5[nPos,8] := 	(cAlias)->PERCGER
			aColsP5[nPos,9] := 	Round((aColsP5[nPos,7]*(cAlias)->PERCGER)/100,2)
			aColsP5[nPos,10]:= 	.F.
			
		Next 
	Endif
			
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )


Sleep(1000)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontaHeader บAutor ณ SYMM             บ Data ณ  14/05/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o aHeader das Grids.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MontaHeader(aHeadP1,aHeadP2)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho da tela de vendedores                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadP1 := {}
Aadd(aHeadP1,{"Loja"           	,"FILORI","@!",Len(cFilAnt),0,"","","C","","","","",""})
Aadd(aHeadP1,{"Vendedor"		,"VENDED","@!",06,0,"","","C","","","","",""})
Aadd(aHeadP1,{"Nome" 			,"NOMVEN","@!",30,0,"","","C","","","","",""})
Aadd(aHeadP1,{"Vlr Vendas Bru."	,"VLRVEN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP1,{"Vlr Cancelado"	,"VLRCAN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP1,{"Vlr Vendas Liq."	,"VLRLIQ","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP1,{"Vlr Cota"	 	,"VLRCOT","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP1,{"% Cota"			,"PERCOT","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP1,{"% Comissao"		,"PERCOM","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP1,{"Vlr. Pagar"		,"VLRPAG","@E 999,999,999.99",14,2,"","","N","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho da tela de vendas                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadP2 := {}
Aadd(aHeadP2,{"Loja"           	,"FILORI","@!",Len(cFilAnt),0,"","","C","","","","",""})
Aadd(aHeadP2,{"Vendedor"		,"VENDED","@!",06,0,"","","C","","","","",""})
Aadd(aHeadP2,{"Dt.Emissao"		,"DTEMIS","@!",08,0,"","","D","","","","",""})
Aadd(aHeadP2,{"Pedido"			,"PEDIDO","@!",06,0,"","","C","","","","",""})
Aadd(aHeadP2,{"Vlr Vendas"		,"VLRVEN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP2,{"% Comissao"		,"PERCOM","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP2,{"Vlr. Pagar"		,"VLRPAG","@E 999,999,999.99",14,2,"","","N","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho da tela dos gerentes.                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadP3 := {}
Aadd(aHeadP3,{"Loja"           	,"FILORI","@!",Len(cFilAnt),0,"","","C","","","","",""})
Aadd(aHeadP3,{"Gerente"			,"VENDED","@!",06,0,"","","C","","","","",""})
Aadd(aHeadP3,{"Nome" 			,"NOMVEN","@!",30,0,"","","C","","","","",""})
Aadd(aHeadP3,{"Vlr Vendas"		,"VLRVEN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP3,{"Vlr Cota"	 	,"VLRCOT","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP3,{"% Cota"			,"PERCOT","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP3,{"% Comissao"		,"PERCOM","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP3,{"Vlr. Pagar"		,"VLRPAG","@E 999,999,999.99",14,2,"","","N","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho da tela dos supervisores.                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadP4 := {}
Aadd(aHeadP4,{"Loja"           	,"FILORI","@!",Len(cFilAnt),0,"","","C","","","","",""})
Aadd(aHeadP4,{"Supervisor"		,"VENDED","@!",06,0,"","","C","","","","",""})
Aadd(aHeadP4,{"Nome" 			,"NOMVEN","@!",30,0,"","","C","","","","",""})
Aadd(aHeadP4,{"Vlr Vendas"		,"VLRVEN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP4,{"Vlr Cota"	 	,"VLRCOT","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP4,{"% Cota"			,"PERCOT","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP4,{"% Comissao"		,"PERCOM","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP4,{"Vlr. Pagar"		,"VLRPAG","@E 999,999,999.99",14,2,"","","N","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o cabecalho da tela de produtos.                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHeadP5 := {}
Aadd(aHeadP5,{"Loja"           	,"FILORI","@!"		,Len(cFilAnt),0,"","","C","","","","",""})
Aadd(aHeadP5,{"Codigo"    		,"VENDED","@!"		,06,0,"","","C","","","","",""})
Aadd(aHeadP5,{"Nome" 			,"NOMVEN","@!"		,30,0,"","","C","","","","",""})
Aadd(aHeadP5,{"Cargo" 			,"CARGO" ,"@!"		,30,0,"","","C","","","","",""})
Aadd(aHeadP5,{"Produto" 		,"CODPRO","@!"		,30,0,"","","C","","","","",""})
Aadd(aHeadP5,{"Descricao" 		,"DESCRI","@S60"	,80,0,"","","C","","","","",""})
Aadd(aHeadP5,{"Vlr Vendas"		,"VLRVEN","@E 999,999,999.99",14,2,"","","N","","","","",""})
Aadd(aHeadP5,{"% Comissao"		,"PERCOM","@E 999.99",6,2,"","","N","","","","",""})
Aadd(aHeadP5,{"Vlr. Pagar"		,"VLRPAG","@E 999,999,999.99",14,2,"","","N","","","","",""})


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMudaVendedorบAutorณ Eduardo Patriani   บ Data ณ  26/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os vendedores pela propriedade BChange.             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MudaVendedor(aCols1,cVendedor,oPanel2,aPosObj) 

Local nI, nX, nY

//Crio novo array
aAux := {}
For nX := 1 To Len(aBkp)
	If aBkp[nX,2]==cVendedor
		AAdd(aAux , aClone(aBkp[nX]) )
	Endif
Next nX

oGetP2:aCols := aAux
oGetP2:oBrowse:Refresh()
oGetP2:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณm105Sair	บAutor  ณMicrosiga           บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo ao sair da tela principal                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function m105Sair(oGetP1,oGetP2,oGetP3)

Local aArea 	:= GetArea()
Local lAglutina	:= GetMv("MV_SYAGLCO",,.F.) //Aglutina as comissoes somentes do vendedores.
Local aAux		:= {}

aColsP1 := aClone(oGetP1:aCols)
aColsP2 := aClone(aBkp)
aColsP3 := aClone(oGetP3:aCols)
aColsP4 := aClone(oGetP4:aCols)
If Len(aColsP5) > 0
	aColsP5 := aClone(oGetP5:aCols)
Endif

If !MsgYesNo("Confirma a gera็ใo das comiss๕es ?","Aten็ใo")
	RestArea(aArea)
	Return(.T.)
Endif

If !lAglutina
	aAux := aClone(aColsP2)	
Else
	aAux := aClone(aColsP1)	
Endif

Begin Transaction 

cQuery := " UPDATE "+RetSqlName("SUA")+" SET UA_01COMPE = ' ' WHERE UA_FILIAL = '"+xFilial("SUA")+"' AND UA_01COMPE = '"+MV_PAR01+"' "
T_SySqlExec(cQuery)
            
cQuery := " DELETE "+RetSqlName("SE3")+" WHERE E3_FILIAL = '"+xFilial("SE3")+"' AND E3_PROCCOM = '"+MV_PAR01+"' "
T_SySqlExec(cQuery)

LjMsgRun("Por favor aguarde, gerando as comiss๕es dos vendedores..."	,, {|| m105Grava(lAglutina,aAux) })
//LjMsgRun("Por favor aguarde, gerando as comiss๕es dos gerentes..."		,, {|| m105Grava(.T.,aColsP3) })
//LjMsgRun("Por favor aguarde, gerando as comiss๕es dos Supervisores..."	,, {|| m105Grava(.T.,aColsP4) })

End Transaction

RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณm105Grava	บAutor  ณMicrosiga           บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera as comissoes dos funcionarios.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function m105Grava(lAglutina,aAux)

Local nI 	:= 0

For nI := 1 To Len(aAux)

	SUA->(DbSetOrder(1))
	If SUA->(DbSeek(xFilial("SUA") + aAux[nI,4] ))
		If SUA->(FieldPos("UA_01COMPE")) > 0
			RecLock("SUA",.F.)
			SUA->UA_01COMPE := MV_PAR01
			Msunlock()
		Endif
	Endif

	DbSelectArea("SE3")
	RecLock("SE3",.T.)
	SE3->E3_FILIAL 	:= aAux[nI,1]
	SE3->E3_VEND 	:= aAux[nI,2]
	SE3->E3_NUM 	:= If(lAglutina,Strzero(Val(MV_PAR01),9),aAux[nI,4])
	SE3->E3_EMISSAO	:= dDatabase
	SE3->E3_CODCLI	:= If(lAglutina,GetMv("MV_CLIPAD") ,SUA->UA_CLIENTE)
	SE3->E3_LOJA	:= If(lAglutina,GetMv("MV_LOJAPAD"),SUA->UA_LOJA)
	SE3->E3_BASE	:= aAux[nI,5]
	SE3->E3_PORC	:= If(lAglutina,aAux[nI,7],aAux[nI,6])
	SE3->E3_COMIS	:= If(lAglutina,aAux[nI,8],aAux[nI,7])
	SE3->E3_PEDIDO	:= If(lAglutina,Strzero(Val(MV_PAR01),9),aAux[nI,4])
	SE3->E3_VENCTO	:= dDtVencto
	SE3->E3_PROCCOM	:= Mv_Par01
	SE3->E3_MOEDA	:= "01"
	Msunlock()
	
Next 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A105SX1  บAutor  ณEduardo Patriani    บ Data ณ  11/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Perguntas. 			                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A105SX1(cPerg)

Local aArea := GetArea()
Local aPerg := {}
Local i

Aadd(aPerg,{cPerg,"01","Competencia ?" ,"MV_CH1","C",TamSx3("Z6_CODCOMP")[1],0,"G","MV_PAR01","SZ6",""	,""	,"",""})

DbSelectArea("SX1")
DbSetOrder(1)
For i := 1 To Len(aPerg)
	IF  !DbSeek(aPerg[i,1]+aPerg[i,2])
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIF
	Replace X1_GRUPO   with aPerg[i,01] ;		Replace X1_ORDEM   with aPerg[i,02]
	Replace X1_PERGUNT with aPerg[i,03] ;		Replace X1_VARIAVL with aPerg[i,04]
	Replace X1_TIPO	   with aPerg[i,05] ;		Replace X1_TAMANHO with aPerg[i,06]
	Replace X1_PRESEL  with aPerg[i,07] ;		Replace X1_GSC	   with aPerg[i,08]
	Replace X1_VAR01   with aPerg[i,09] ;		Replace X1_F3	   with aPerg[i,10]
	Replace X1_DEF01   with aPerg[i,11] ;		Replace X1_DEF02   with aPerg[i,12]
	Replace X1_DEF03   with aPerg[i,13] ;		Replace X1_DEF04   with aPerg[i,14]
	MsUnlock()
Next i
RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM105   บAutor  ณMicrosiga           บ Data ณ  12/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function PesqVlrVdas()
                  
Local cQuery  	:= ""
Local nVendedor := ""
Local cAlias  	:= GetNextAlias()
Local nTotal  	:= 0

cQuery += " SELECT FILIAL,PEDIDO,VENDEDOR,SUM((VALOR+FRETE)-(DESCONTO+CREDITO)) VALOR FROM ( "+CRLF
cQuery += " SELECT UB_FILIAL FILIAL,UB_NUM PEDIDO,UA_VEND VENDEDOR,SUM(UB_VLRITEM)VALOR,UA_FRETE FRETE,UA_DESCONT DESCONTO,0 CREDITO "+CRLF
cQuery += " FROM "+RetSqlName("SUB")+" SUB "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM AND SUA.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " WHERE SUA.UA_FILIAL=SUB.UB_FILIAL "+CRLF
cQuery += " AND SUA.UA_VEND   <> ' ' "+CRLF
cQuery += " AND SUA.UA_CANC   =  ' ' "+CRLF
cQuery += " AND SUA.UA_PEDPEND IN('3','5') "+CRLF
cQuery += " AND SUA.UA_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "+CRLF
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " GROUP BY UB_FILIAL,UB_NUM,UA_VEND,UA_FRETE,UA_DESCONT,UA_EMISSAO "+CRLF
cQuery += " ) AS TABELA "+CRLF
cQuery += " GROUP BY FILIAL,PEDIDO,VENDEDOR "+CRLF
cQuery += " ORDER BY VENDEDOR,PEDIDO "+CRLF

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())

	nVlrCanc := 0	
	nCancela := 0
	nVlrCredito := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnalisa itens cancelados                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SUA->(DbSetOrder(1))
	SUA->(DbSeek((cAlias)->FILIAL+(cAlias)->PEDIDO))
	If (SUA->UA_DESCONT > 0) .Or. (SUA->UA_DESCONT = 0)
		nCancela := RetVlrCancel( (cAlias)->FILIAL,(cAlias)->PEDIDO )
	Endif	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFiltra pedidos cancelado que ja foram entregues para abatimen-ณ
	//ณto da comissao.                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	If nVendedor <> (cAlias)->VENDEDOR
		FilPedCanc((cAlias)->FILIAL,(cAlias)->VENDEDOR,@nVlrCanc,.F.)
		nVendedor := (cAlias)->VENDEDOR
	Endif		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnalisa creditos concedidos ao cliente.                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	nVlrCredito := RetVlrCredito((cAlias)->FILIAL,(cAlias)->PEDIDO)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValor Total atualizado.                   				 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	nTotal += (cAlias)->VALOR - (nCancela+nVlrCredito)
	nTotal -= nVlrCanc	

	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

Return nTotal

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM105   บAutor  ณMicrosiga           บ Data ณ  12/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RetVlrCredito(cFilAtu,cAtende)

Local nCredito := 0

SL4->(DbSetOrder(1))
SL4->(DbSeek( cFilAtu + cAtende + "SIGATMK" ))
While SL4->(!Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM+Alltrim(SL4->L4_ORIGEM)==xFilial("SL4") + cAtende + "SIGATMK"
	If Alltrim(SL4->L4_FORMA)=="CR"
		nCredito += SL4->L4_VALOR
	Endif
	SL4->(DbSkip())
End

Return nCredito

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM105   บAutor  ณMicrosiga           บ Data ณ  12/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RetVlrCancel( cFilAtu , cNumero )

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local nRetorno 	:= 0

cQuery += " SELECT (VALOR_ITEM*PERC_DESC) VALOR_ABAT FROM "
cQuery += " ( "
cQuery += " SELECT UB_NUM NUMERO,SUM(UB_VLRITEM) VALOR_ITEM, (SELECT (1-(UA_DESCONT/UA_VALBRUT)) FROM "+RetSqlName("SUA")+" SUA WHERE UA_FILIAL = '"+cFilAtu+"' AND UA_NUM = '"+cNumero+"' AND SUA.D_E_L_E_T_ = ' ' ) PERC_DESC "
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " WHERE "
cQuery += " 	 	UB_FILIAL 	= '"+cFilAtu+"' "
cQuery += " AND 	UB_NUM 		= '"+cNumero+"' "
cQuery += " AND 	UB_01CANC 	= 'S' "
cQuery += " GROUP BY UB_NUM "
cQuery += " ) AS TABELA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	nRetorno := (cAlias)->VALOR_ABAT
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

Return nRetorno

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVM105   บAutor  ณMicrosiga           บ Data ณ  12/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FilPedCanc( cFilAtu , cVendedor, nVlrCanc, lInclui ) 

Local cAlias 	:= GetNextAlias()
Local cQuery 	:= ""
Local nNewValor	:= 0
Local nVlrAbat	:= 0
Local nTotIt	:= 0
Local nPercen	:= 0
Local nVlrNCC	:= 0

cQuery += " SELECT UA_FILIAL FILIAL,UA_VEND VENDEDOR, UA_EMISSAO EMISSAO,UB_NUM PEDIDO,UA_DESCONT DESCONTO,UA_VALMERC VALOR_BRUTO,SUM(UB_VLRITEM) VALOR "
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+cFilAtu+"' AND UA_NUM=UB_NUM AND UA_EMISSAO < '"+cDataIni+"' AND SUA.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " UB_FILIAL = '"+cFilAtu+"' "
cQuery += " AND UB_01DTCAN BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
cQuery += " AND UA_VEND = '"+cVendedor+"' "
cQuery += " AND UB_01CANC = 'S' "
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY UA_FILIAL,UA_VEND,UA_EMISSAO,UB_NUM,UA_DESCONT,UA_VALMERC "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,"EMISSAO","D",TamSx3("UA_EMISSAO")[1],TamSx3("UA_EMISSAO")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())                                  
	
	If (cAlias)->DESCONTO > 0
		nPercen	 := Round((cAlias)->DESCONTO/(cAlias)->VALOR_BRUTO,2)	 	
		nVlrAbat := Round(((cAlias)->VALOR*nPercen),2)		
		nNewValor:= Round((cAlias)->VALOR-nVlrAbat,2)
	Else
		nNewValor := (cAlias)->VALOR
	Endif

	If lInclui
		//AAdd( aColsP2 , { (cAlias)->FILIAL, (cAlias)->VENDEDOR,(cAlias)->EMISSAO, (cAlias)->PEDIDO, (cAlias)->VALOR*(-1), 0, 0, .F. } )
		AAdd( aColsP2 , { (cAlias)->FILIAL, (cAlias)->VENDEDOR,(cAlias)->EMISSAO, (cAlias)->PEDIDO, nNewValor*(-1), 0, 0, .F. } )
	Endif
	nVlrCanc += nNewValor //(cAlias)->VALOR	
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

Return