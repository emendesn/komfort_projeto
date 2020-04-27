#INCLUDE "PROTHEUS.CH"
#DEFINE DMPAPER_A4 9
#DEFINE DMPAPER_A4SMALL     10          // A4 SMALL 210 X 297 MM

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SYVR105  บAutor  ณ SYMM CONSULTORIA   บ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ EMISSAO DA ORDEM DE SEPARACAO DOS PEDIDOS DE VENDA.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CASA CENARIO	                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SYVR105()

Local wnrel   	:="SYVR105"
Private aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}//OBRIGATORIO PARA O SetPrint

RptStatus({|| ReportDef()},"Por favor aguarde, Gerando a impressใo.")
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ SYMM CONSULTORIA   บ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a impressao da ordem de separacao.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CASA CENARIO	                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

Local Linha    	:= 0 
Local nTotVal  	:= 0 
Local cAuxRel 	:= ""
Local cObs 		:= ''
Local cQuebra	:= ''
Local cFilOld	:= cFilAnt

Private oReport	:= Nil
Private oFont01 := TFont():New( "Arial",15,15,,.T.,,,,,,,,,,,)
Private oFont02 := TFont():New( "Arial",10,10,,.T.,,,15,,,,,,,,)
Private oFont03 := TFont():New( "Arial",08,08,,.T.,,,15,,,,,,,,)
Private aPedidos:= {}

If !SYPERGUNTA() 
	Return(.T.)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltra os pedidos de venda.               	    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FiltraPedidos(@aPedidos)  

If Len(aPedidos) > 0
	cQuebra := aPedidos[1,1]+aPedidos[1,2]+aPedidos[1,4]+Dtos(aPedidos[1,11])
Else          
	MsgAlert("Nao existem dados para serem exibidos","Atencao")
	Return(.T.)
Endif
                
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Selecao da impressora.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:=TMSPrinter():New("Impressใo da Ordem de Separa็ใo")  
oReport:SetPortrait()  
oReport:Setup() 
oReport:SetPaperSize(DMPAPER_A4SMALL) 
oReport:StartPage()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao dos Pedidos.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 To Len(aPedidos)
	
	If cQuebra <> aPedidos[nX,1]+aPedidos[nX,2]+aPedidos[nX,4]+Dtos(aPedidos[nX,11])
		cQuebra:= aPedidos[nX,1]+aPedidos[nX,2]+aPedidos[nX,4]+Dtos(aPedidos[nX,11])
		oReport:EndPage()
		oReport:StartPage()
	Endif
	
	oReport:Box(0200,0050,400,2350)
	
	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek(cEmpAnt+aPedidos[nX,1])
	
	//Cabecalho (Dados da empresa)
	oReport:Say(0100,0070,"ORDEM DE SEPARAวรO REF. AO PEDIDO DE VENDA Nบ " + aPedidos[nX,2],oFont02)
	oReport:Say(0100,1705,"DATA DE ENTREGA: "+ DTOC(aPedidos[nX,11]),oFont02)
	
	oReport:Say(0250,0070,AllTrim(SM0->M0_NOME)+"-"+AllTrim(SM0->M0_NOMECOM),oFont01)
	oReport:Say(0300,0070,AllTrim(SM0->M0_ENDCOB)+SPACE(1)+AllTrim(SM0->M0_COMPCOB),oFont02)
	
	cEndereco := Transform(SM0->M0_CEPCOB,"@R 99999-999" )+" - "+AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB) +" - "+AllTrim(SM0->M0_ESTCOB)
	oReport:Say(0350,0070,cEndereco,oFont03)
	
	nLinha :=400
	
	//Proximo Box (Dados do Cliente)
	ProxTabela()
	
	oReport:Say(nLinha,1100,"Cliente",oFont01)
	
	PulaLinha()
	
	oReport:Line(nLinha		,0050,nLinha		,2350) //Linha Cima
	oReport:Line(nLinha		,0050,nLinha+250	,0050) //Linha Esquerda
	oReport:Line(nLinha		,2350,nLinha+250	,2350) //Linha Direita
	oReport:Line(nLinha+250	,0050,nLinha+250	,2350) //Linha Baixo
	
	oReport:Say(nLinha,0070,POSICIONE("SA1",1,xFilial("SA1")+aPedidos[nX,4]+aPedidos[nX,5], "A1_NOME"),oFont01)
	
	PulaLinha()
	PulaLinha()
	
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+aPedidos[nX,4]+aPedidos[nX,5]))
	
	If SA1->A1_PESSOA=="F"
		cAuxRel := "CPF: "+Transform(SA1->A1_CGC,"@R 999.999.999-99")+" - RG: "+Alltrim(SA1->A1_RG)
	Else
		cAuxRel := "CNPJ: "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")+" - Incricao Estadual: "+Alltrim(SA1->A1_INSCR)
	Endif
	oReport:Say(nLinha,0070,cAuxRel,oFont03)
	
	PulaLinha()
	
	cAuxRel:= "Telefone: "+Alltrim(SA1->A1_TEL)+" - E-Mail: "+Alltrim(SA1->A1_EMAIL)
	oReport:Say(nLinha,0070,cAuxRel,oFont03)
	
	PulaLinha()
	
	If !Empty(SA1->A1_ENDENT)
		cAuxRel := Alltrim(SA1->A1_ENDENT)+" - "+Alltrim(SA1->A1_COMPENT)+" - "+Alltrim(SA1->A1_BAIRROE)+" - "+Alltrim(SA1->A1_MUNE)+" - "+Alltrim(SA1->A1_ESTE)+" - "+Transform(SA1->A1_CEPE,"@R 99999-999")
	Else 
		cAuxRel := Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_COMPLEM)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_EST)+" - "+Transform(SA1->A1_CEP,"@R 99999-999")
	Endif	
	oReport:Say(nLinha,0070,cAuxRel,oFont03)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria Box da Observacao                                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProxTabela()
	PulaLinha()
	oReport:Say(nlinha,1050,"Observa็๕es",oFont01)
	PulaLinha()
	
	oReport:Line(nLinha		,0050,nLinha 		,2350) //Linha Cima
	oReport:Line(nLinha		,0050,nLinha+100 	,0050) //Linha Esquerda
	oReport:Line(nLinha		,2350,nLinha+100	,2350) //Linha Direita
	oReport:Line(nLinha+100	,0050,nLinha+100 	,2350) //Linha Baixo
	
	cFilAnt := Left(aPedidos[nX,10],Len(cFilAnt))
	SUA->(DbSetOrder(1))
	SUA->(DbSeek(aPedidos[nX,10]))
	cObs := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
	
	oReport:Say(nLinha+50,0070,cObs,oFont02)
	cFilAnt := cFilOld
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria Box dos Itens		                                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProxTabela()
	PulaLinha()
	IncDadoItem(aPedidos[nX,1],aPedidos[nX,2])
	
	ProxTabela()
	nLinha:= nLinha+60
	oReport:Say(nLinha,0050,"Declaro, neste ato, que as mercadorias relacionadas acima ('Produtos'): ",oFont02)
	
	nLinha:= nLinha+100
	oReport:Say(nLinha,0050,"(a) foram desembalados e conferidos pelo responsแvel no ato de recebimento dos produtos, e ",oFont02)
	
	PulaLinha()
	oReport:Say(nLinha,0050,"(b) encontram-se em perfeito estado de conserva็ใo e apresentam a quantidade, qualidade e especificacoes contratadas.",oFont02)
	
	PulaLinha()
	PulaLinha()
	oReport:Say(nLinha,0050,"Caso os Produtos nao estejam em conformidade com o disposto acima, o comprador deverแ entrar em contato com o Servi็o de",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"Atendimento ao Cliente da Casa Cenแrio ('SAC')",oFont02)
	PulaLinha()	
	oReport:Say(nLinha,0050,"atrav้s do e-mail ou telefone indicados abaixo, informando sobre as irregularidades constatadas (se possํvel, incluindo fotos das",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"irregularidades).",oFont02)
	PulaLinha()		
	oReport:Say(nLinha,0050,"Se o comprador nใo notificar o SAC na forma estabelecida na sentenca anterior a Casa Cenario entendera que os Produtos foram ",oFont02)
	PulaLinha()		
	oReport:Say(nLinha,0050,"recebidos em conformidade com o presente termo e com seu pedido.",oFont02)
		
	nLinha:= nLinha+100
	oReport:Say(nLinha,0050,"SAC",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"E-mail: contato@casacenario.com.br",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"Telefone: (11) 2344-8300",oFont02)
	
	nLinha:= nLinha+100
	oReport:Say(nLinha,0050,"___________________________________________________________",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"Assinatura do Responsavel pelo Recebimento",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"Nome Legivel: ",oFont02)
	PulaLinha()
	oReport:Say(nLinha,0050,"RG: ",oFont02)
	
	nLinha:= nLinha+100
	oReport:Say(nLinha,0050,"Os Produtos entregues foram montados ? ( ) Sim ( ) Nใo",oFont02)
	
Next

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()
oReport:EndPage()
oReport:Preview()

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVR105   บAutor  ณMicrosiga           บ Data ณ  08/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IncDadoItem(cFilAtu,cPedido)

Local cAuxRel
Local nPulaLinha := 0 
Local lQuebra

PulaLinha()
oReport:Say(nLinha,1100,"Itens",oFont01)
PulaLinha()

oReport:Line(nLinha		,0050,nLinha 		,2350) //Linha Cima
oReport:Line(nLinha		,0050,nLinha+100 	,0050) //Linha Esquerda
oReport:Line(nLinha		,2350,nLinha+100 	,2350) //Linha Direita
oReport:Line(nLinha+100	,0050,nLinha+100 	,2350) //Linha Baixo

oReport:Line(nLinha,0500,nLinha+100,0500 ) //Linha vertical 1
oReport:Line(nLinha,1410,nLinha+100,1410 ) //Linha vertical 2
oReport:Line(nLinha,1600,nLinha+100,1600 ) //Linha vertical 3
oReport:Line(nLinha,1840,nLinha+100,1840 ) //Linha vertical 4
oReport:Line(nLinha,2000,nLinha+100,2000 ) //Linha vertical 5

oReport:Say(nLinha+50,0090,"Produto"		,oFont02)
oReport:Say(nLinha+50,0530,"Descricao"		,oFont02)
oReport:Say(nLinha+50,1465,"Qtde"			,oFont02)
oReport:Say(nLinha+50,1630,"Volumes"		,oFont02)
oReport:Say(nLinha+50,1850,"Local"			,oFont02)  
oReport:Say(nLinha+50,2010,"Local Saida"	,oFont02) 

PulaLinha()

 //Carrega itens do pedido de venda
CarregaItens(cFilAtu,cPedido)

TRBSC6->(dbGoTop())
While !TRBSC6->(EOF())
	
	lQuebra:= .F.
	
	oReport:Line(nLinha,0050,nLinha+100,0050) //Linha Esquerda
	oReport:Line(nLinha,2350,nLinha+100,2350) //Linha Direita
	
	oReport:Line(nLinha,0500,nLinha+100,0500 ) //Linha vertical 1
	oReport:Line(nLinha,1410,nLinha+100,1410 ) //Linha vertical 2
	oReport:Line(nLinha,1600,nLinha+100,1600 ) //Linha vertical 3
	oReport:Line(nLinha,1840,nLinha+100,1840 ) //Linha vertical 4
	oReport:Line(nLinha,2000,nLinha+100,2000 ) //Linha vertical 5
	
	oReport:Say(nLinha+50,0090,TRBSC6->C6_PRODUTO,oFont02)
	
	cAux := Alltrim (Posicione("SB1",1,XFILIAL("SB1")+AVKEY(TRBSC6->C6_PRODUTO,"B1_COD"),"B1_DESC"))
	
	If Len(cAux) > 50//Esta funcao suportara no maximo 80 caracteres na descricao, caso necessario ajuste os parametros do substr()
		oReport:Say(nLinha+50,0530,Substr(cAux,1,50),oFont03)
		oReport:Line(nLinha,0500,nLinha+100,0500 ) //Linha vertical 1
		oReport:Line(nLinha,1410,nLinha+100,1410 ) //Linha vertical 2
		oReport:Line(nLinha,1600,nLinha+100,1600 ) //Linha vertical 3
		oReport:Line(nLinha,1840,nLinha+100,1840 ) //Linha vertical 4
		oReport:Line(nLinha,2000,nLinha+100,2000 ) //Linha vertical 5
		PulaLinha()
		
		oReport:Say(nLinha+50,0530,Substr(cAux,51,40),oFont03)
		oReport:Line( nLinha+100 , 0050 , nLinha+100 , 2350 ) //Linha Baixo
		nLinha := nLinha - 50
		lQuebra := .T.
	Else
		oReport:Say(nLinha+50,0530,cAux,oFont02)
		oReport:Line(nLinha+100,0050,nLinha+100,2350) //Linha Baixo
	EndIf
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + AVKEY(TRBSC6->C6_PRODUTO,"B1_COD")))
	
	SB4->(DbSetOrder(1))
	SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP ))
	
	oReport:Say(nLinha+50,1465,AllTrim(STR(TRBSC6->C6_QTDVEN)),oFont02)
	oReport:Say(nLinha+50,1630,AllTrim(Transform(SB4->B4_01VOLUM,"@R 999999")),oFont02)
	oReport:Say(nLinha+50,1850,TRBSC6->C6_LOCAL,oFont02)
	oReport:Say(nLinha+50,2010,IF(TRBSC6->C6_FILIAL=="100001","FRANQUEADORA","FRANQUIA"),oFont03)
	oReport:Say(nLinha+80,2010,IF(TRBSC6->C6_FILIAL=="100001","MASTER",IF(TRBSC6->C6_FILIAL=="110002","RAPOSO",IF(TRBSC6->C6_FILIAL=="120003","BANDEIRANTES","WASGHINGTON"))),oFont03)
	
	TRBSC6->(DbSkip())
	
	If lQuebra
		PulaLinha()
	EndIf
	
	PulaLinha()
	
End
oReport:Line(nLinha    	,0050,nLinha+100,0050) //Linha Esquerda
oReport:Line(nLinha    	,2350,nLinha+100,2350) //Linha Direita
oReport:Line(nLinha+100	,0050,nLinha+100,2350) //Linha Baixo

oReport:Line(nLinha,0500,nLinha+100,0500 ) //Linha vertical 1
oReport:Line(nLinha,1410,nLinha+100,1410 ) //Linha vertical 2
oReport:Line(nLinha,1600,nLinha+100,1600 ) //Linha vertical 3
oReport:Line(nLinha,1840,nLinha+100,1840 ) //Linha vertical 4
oReport:Line(nLinha,2000,nLinha+100,2000 ) //Linha vertical 5

PulaLinha()

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYVR105   บAutor  ณMicrosiga           บ Data ณ  08/22/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CarregaItens(cFilAtu,cPedido)

Local cFileWork		:= ""
Local aEstrutura	:= {}

If Select("TRBSC6") > 0 
	TRBSC6->(DBCLOSEAREA())
Endif

AAdd(aEstrutura, {"C6_PRODUTO"	,AVSX3("C6_PRODUTO",2)	,AVSX3("C6_PRODUTO",3)	,AVSX3("C6_PRODUTO",4)})
AAdd(aEstrutura, {"C6_DESCRI"  	,AVSX3("C6_DESCRI",2) 	,AVSX3("C6_DESCRI",3)	,AVSX3("C6_DESCRI",4)})
AAdd(aEstrutura, {"C6_QTDVEN"  	,AVSX3("C6_QTDVEN",2) 	,AVSX3("C6_QTDVEN",3)	,AVSX3("C6_QTDVEN",4)})
AAdd(aEstrutura, {"C6_FILIAL" 	,AVSX3("C6_FILIAL",2)	,AVSX3("C6_FILIAL",3)	,AVSX3("C6_FILIAL",4)})
AAdd(aEstrutura, {"C6_LOCAL" 	,AVSX3("C6_LOCAL",2)	,AVSX3("C6_LOCAL",3)	,AVSX3("C6_LOCAL",4)})
   
cFileWork := CriaTrab(aEstrutura,.T.)
DbUseArea(.T.,,cFileWork,"TRBSC6",.F.)

SC6->(DbSetOrder(1))
SC6->(dbSeek(cFilAtu+cPedido)) 
While !SC6->(EOF()) .And. SC6->C6_FILIAL+SC6->C6_NUM==cFilAtu+cPedido
	If Dtos(SC6->C6_DTAGEND) == Dtos(Mv_Par09) //.And. Dtos(SC6->C6_DTAGEND) <= Dtos(Mv_Par10)
		TRBSC6->(RecLock("TRBSC6",.T.))
		AvReplace("SC6","TRBSC6")
		TRBSC6->(MsUnlock())
	Endif
	SC6->(dbSkip())
End

Return
 
Static Function PulaLinha()
nLinha+=50
Return
 
Static Function ProxTabela()
nLinha+=70
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltraPedidosบAutor  ณ                 บ Data ณ  25/08/14   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFiltra os pedidos de venda.                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FiltraPedidos(aPedidos)

Local cQuery := ''
Local cAlias := GetNextAlias()

cQuery += " SELECT C5_FILIAL,C5_NUM,C5_NUMTMK,C5_CLIENTE,C5_LOJACLI,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,	C6_NUMTMK, C6_DTAGEND "
cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C6_NUM=C5_NUM AND SC5.D_E_L_E_T_ = ' ' " 
cQuery += " WHERE "
cQuery += " 		C5_FILIAL=C6_FILIAL "
cQuery += " 	AND	C5_FILIAL	BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' "
cQuery += " 	AND C5_NUM		BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' "
cQuery += " 	AND C5_CLIENTE	BETWEEN '"+Mv_Par05+"' AND '"+Mv_Par06+"' "
cQuery += " 	AND C5_NUMTMK	BETWEEN '"+Mv_Par07+"' AND '"+Mv_Par08+"' "
cQuery += " 	AND C6_DTAGEND  = '"+Dtos(Mv_Par09)+"' "
cQuery += " 	AND C6_DTAGEND <> ' ' "
cQuery += " 	AND C6_DTENTOK =  ' ' "
cQuery += " 	AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY C5_CLIENTE,C5_NUMTMK "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,"C6_DTAGEND","D",TamSx3("C6_DTAGEND")[1],TamSx3("C6_DTAGEND")[2])

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	
	SA1->(DbSetOrder(1))
	SA1->(Dbseek(xFilial("SA1") + (cAlias)->C5_CLIENTE + (cAlias)->C5_LOJACLI ))
	If SA1->A1_01PEDFI=="1"
		(cAlias)->(DbsKIP())
		Loop
	Endif
	
	AAdd( aPedidos , { 	(cAlias)->C5_FILIAL,;
						(cAlias)->C5_NUM,;
						(cAlias)->C5_NUMTMK,;
						(cAlias)->C5_CLIENTE,;
						(cAlias)->C5_LOJACLI,;
						(cAlias)->C6_ITEM,;
						(cAlias)->C6_PRODUTO,;
						(cAlias)->C6_DESCRI,;
						(cAlias)->C6_QTDVEN,;
						(cAlias)->C6_NUMTMK,;
						(cAlias)->C6_DTAGEND} )		
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYPERGUNTAบAutor  ณMicrosiga           บ Data ณ  25/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SYPERGUNTA()

Local aBoxParam  := {}
Local aRetParam  := {}

Aadd(aBoxParam,{1,"Da Filial"				,CriaVar("C5_FILIAL",.F.)					,PesqPict("SC5","C5_FILIAL"),"","SM0","",50,.F.})
Aadd(aBoxParam,{1,"Ate Filial"	   			,Replicate("Z",TamSx3("C5_FILIAL")[1])		,PesqPict("SC5","C5_FILIAL"),"","SM0","",50,.F.})
Aadd(aBoxParam,{1,"Da Pedido"				,CriaVar("C5_NUM",.F.)						,PesqPict("SC5","C5_NUM"),"","SC5","",50,.F.})
Aadd(aBoxParam,{1,"Ate Pedido"	   			,Replicate("Z",TamSx3("C5_NUM")[1])		,PesqPict("SC5","C5_NUM"),"","SC5","",50,.F.})
Aadd(aBoxParam,{1,"Do Cliente"				,CriaVar("A1_COD",.F.)						,PesqPict("SA1","A1_COD"),"","SA1","",50,.F.})
Aadd(aBoxParam,{1,"Ate Cliente"	   			,Replicate("Z",TamSx3("A1_COD")[1])		,PesqPict("SA1","A1_COD"),"","SA1","",50,.F.})
Aadd(aBoxParam,{1,"Do Atendimento"			,CriaVar("UA_NUM",.F.)						,PesqPict("SA3","A3_COD"),"","SUA","",50,.F.})
Aadd(aBoxParam,{1,"Ate Atendimento"			,Replicate("Z",TamSx3("UA_NUM")[1])		,PesqPict("SA3","A3_COD"),"","SUA","",50,.F.})
Aadd(aBoxParam,{1,"Dt.Agendamento"			,dDatabase									,PesqPict("SD2","D2_EMISSAO"),"","","",50,.F.})
//Aadd(aBoxParam,{1,"Ate Dt.Agendamento"		,Ctod("31/12/49")							,PesqPict("SD2","D2_EMISSAO"),"","","",50,.F.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

Mv_par01   := aRetParam[1]
Mv_par02   := aRetParam[2]
Mv_par03   := aRetParam[3]
Mv_par04   := aRetParam[4]
Mv_par05   := aRetParam[5]
Mv_par06   := aRetParam[6]
Mv_par07   := aRetParam[7]
Mv_par08   := aRetParam[8]
Mv_par09   := Iif(empty(aRetParam[09]),ctod(''),aRetParam[09])
//Mv_par10   := Iif(empty(aRetParam[10]),ctod(''),aRetParam[10])

Return(.T.)