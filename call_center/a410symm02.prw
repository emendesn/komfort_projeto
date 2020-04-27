#include "protheus.ch"
#define DMPAPER_A4SMALL     10          // A4 Small 210 x 297 mm


/*
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
User Function RELMATA410()
Local cPerg		:= PADR("RELMATA410",10)
Private wnrel   :="RELMATA410"
Private aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}//OBRIGATORIO PARA O SetPrint

If SC5->(FieldPos("C5_CODUSR")) ==0 .or. SC6->(FieldPos("C6_DTMONTA")) ==0 .or. SB1->(FieldPos("B1_01VLMON")) ==0
	Return MsgInfo("Cadastre o campo codigo do montador (C5_CODUSR), Data da montagem (C6_DTMONTA) e valor da montagem (B1_01VLMON)")
End If

AjustaSx1(cPerg)

If Pergunte("RELMATA410",.T.)
	WorkMontador()
   		If !WK_SC6->(EOF())
			RptStatus({|| reportDef()},"Gerando Impressใo") 
   		Else
  			MsgInfo("Nenhum registro encontrado")
		End If
	WK_SC6->(DBCLOSEAREA())
End If	
Return(.T.)

/*
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
Static Function ReportDef()
Private oReport	:= Nil
Private oFont01 	:= TFont():New( "Arial",15,15,,.T.,,,    ,,,,,,,,)//titulo
Private oFont02 	:= TFont():New( "Arial",10,10,,.T.,,,15,,,,,,,,)//descricao negrito
Private oFont03 	:= TFont():New( "Arial",08,08,,.T.,,,15,,,,,,,,)//descricao
Private Linha       := 0 
Private nTotVal    := 0 
oReport:= TMSPrinter():New("Relat๓rio de Montadores")  

If Empty(SUA->UA_NUM)
   oReport:Cancel ()
End If

oReport:SetPortrait()  
oReport:Setup () 
oReport:SetPaperSize(DMPAPER_A4SMALL) 
oReport:StartPage()

nlinha :=100
FormMontador()
ProxTabela()


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
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
//Incluindo dados ao relatorio de montador
Static Function FormMontador()
Local xAuxRel
Local nPulaLinha := 0 
Local lQuebra
Local nSubTotal := 0
Local nTotalGeral:=0

Local nPosVert1 := 600
Local nPosVert2 := 800
Local nPosVert3 := 1300
Local nPosVert4 := 1850
Local nPosVert5 := 2050

Local nEspaco   := 20
Local nPosInicio := 50
Local lMudoMontador := .T.
Local cCodMontador  := ""
Local aDesc:= {}

PulaLinha() 
oReport:Say(nlinha,1100,"Relatorio de Montador",oFont01)
PulaLinha()
WK_SC6->(dbGoTop())

While !WK_SC6->(EOF())
	If Empty(cCodMontador) .Or. cCodMontador != WK_SC6->C5_CODUSR
		cCodMontador  := WK_SC6->C5_CODUSR
   		//Cabecalho itens
		ProxTabela()


		oReport:Line( nlinha , 0050 , nlinha , 2350 ) //Linha Cima
		oReport:Line( nlinha , 0050 , nlinha+100 , 0050 ) //Linha Esquerda
		oReport:Line( nlinha , 2350 , nlinha+100 , 2350 ) //Linha Direita
		oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

		oReport:Line( nlinha , nPosVert1 , nlinha+100 , nPosVert1 ) //Linha vertical 1
		oReport:Line( nlinha , nPosVert2 , nlinha+100 , nPosVert2 ) //Linha vertical 2
		oReport:Line( nlinha , nPosVert3 , nlinha+100 , nPosVert3 ) //Linha vertical 3
		oReport:Line( nlinha , nPosVert4 , nlinha+100 , nPosVert4 ) //Linha vertical 4
		oReport:Line( nlinha , nPosVert5 , nlinha+100 , nPosVert5 ) //Linha vertical 5

		oReport:Say(nlinha+50,nPosInicio+nEspaco,"Montador"	,oFont02)
		oReport:Say(nlinha+50,nPosVert1+nEspaco,"Pedido"		,oFont02)
		oReport:Say(nlinha+50,nPosVert2+nEspaco,"Cliente"		,oFont02)
		oReport:Say(nlinha+50,nPosVert3+nEspaco,"Produto"	,oFont02) 
		oReport:Say(nlinha+50,nPosVert4+nEspaco,"Data"	  		,oFont02) 
		oReport:Say(nlinha+50,nPosVert5+nEspaco,"Valor"			,oFont02)

		PulaLinha()
	End If

	oReport:Line( nlinha         , 0050 , nlinha+100 , 0050 ) //Linha Esquerda
	oReport:Line( nlinha         , 2350 , nlinha+100 , 2350 ) //Linha Direita

	oReport:Line( nlinha , nPosVert1 , nlinha+100 , nPosVert1 ) //Linha vertical 1
	oReport:Line( nlinha , nPosVert2 , nlinha+100 , nPosVert2 ) //Linha vertical 2
	oReport:Line( nlinha , nPosVert3 , nlinha+100 , nPosVert3 ) //Linha vertical 3
	oReport:Line( nlinha , nPosVert4 , nlinha+100 , nPosVert4 ) //Linha vertical 4
	oReport:Line( nlinha , nPosVert5 , nlinha+100 , nPosVert5 ) //Linha vertical 5

    If SC5->(FieldPos("C5_CODUSR")) >0
		oReport:Say(nlinha+50,nPosInicio+nEspaco,Alltrim(UsrRetName( WK_SC6->C5_CODUSR)) ,oFont03)
    End If
 	oReport:Say(nlinha+50,nPosvert1+nEspaco,WK_SC6->C6_NUM,oFont03)
 	oReport:Say(nlinha+50,nPosvert2+nEspaco,Posicione("SA1",1,xFilial("SA1")+ AvKey(WK_SC6->C5_CLIENTE,"A1_COD"), "A1_NOME" ),oFont03) 
 	//oReport:Say(nlinha+50,nPosvert3+nEspaco,WK_SC6->C6_PRODUTO,oFont03)

 	If SC6->(FieldPos("C6_DTMONTA")) >0
 		oReport:Say(nlinha+50,nPosvert4+nEspaco,dtoc(stod(WK_SC6->C6_DTMONTA)),oFont03)
 	End If
 	If SB1->(FieldPos("B1_01VLMON")) >0
 		xAuxRel := WK_SC6->C6_QTDVEN * Posicione("SB1",1,XFILIAL("SB1")+AVKEY(WK_SC6->C6_PRODUTO,"B1_COD"),"B1_01VLMON")
 		oReport:Say(nlinha+50,nPosvert5+nEspaco,AllTrim(Transform(xAuxRel, avSx3("C6_VALOR", 6) )) ,oFont03)
 		//oReport:Say(nlinha+50,nPosvert5+nEspaco,AllTrim(Transform(WK_SC6->C6_VALOR , avSx3("C6_VALOR", 6) )) ,oFont03)
 	End If
 	nSubTotal  := xAuxRel + nSubTotal
	nTotalgeral := xAuxRel + nTotalgeral
 	xAuxRel 	   := AllTrim(Posicione("SB1",1,xFilial("SB1")+WK_SC6->C6_PRODUTO,"B1_DESC"))
 	aAdd(aDesc,{xAuxRel,nPosVert3,30})
 	QuebraLinha(aDesc)//oReport:Say(nlinha+50,nPosvert3+nEspaco,WK_SC6->C6_PRODUTO,oFont03)	                                                                                    

	WK_SC6->(DbSkip())
	PulaLinha()  

	If cCodMontador != WK_SC6->C5_CODUSR
  		PulaLinha()                                   
  		
  		oReport:Line( nlinha , 0050 , nlinha , 2350 ) //Linha Cima
   		oReport:Line( nlinha , 0050 , nlinha+100 , 0050 ) //Linha Esquerda
   		oReport:Line( nlinha , 2350 , nlinha+100 , 2350 ) //Linha Direita
   		oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo
   		oReport:Line( nlinha , nPosVert1 , nlinha+100 , nPosVert1 ) //Linha vertical 1
   		oReport:Line( nlinha , nPosVert2 , nlinha+100 , nPosVert2 ) //Linha vertical 2
   		oReport:Line( nlinha , nPosVert3 , nlinha+100 , nPosVert3 ) //Linha vertical 3
		oReport:Line( nlinha , nPosVert4 , nlinha+100 , nPosVert4 ) //Linha vertical 4
  		oReport:Line( nlinha , nPosVert5 , nlinha+100 , nPosVert5 ) //Linha vertical 5
 		oReport:Say(nlinha+50,nPosInicio+nEspaco,"Sub Total ",oFont02)
		oReport:Say(nlinha+50,nPosVert5+nEspaco,AllTrim(Transform(nSubTotal , avSx3("C6_VALOR", 6) )),oFont02)
  		nSubTotal := 0
	End If
	aDesc := {}
End Do 

ProxTabela()
ProxTabela()
oReport:Line( nlinha , 0050 , nlinha , 2350 ) //Linha Cima
oReport:Say(nlinha+50,nPosInicio+nEspaco,"Total Geral ",oFont02) 
oReport:Say(nlinha+50,nPosVert5+nEspaco,AllTrim(Transform(nTotalgeral , avSx3("C6_VALOR", 6) )),oFont02)
PulaLinha() 

Return 

/*
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
Static Function PulaLinha()
nlinha =50+nlinha
Return

 /*
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
Static Function ProxTabela()
nlinha =150+nlinha
Return 

/*
Programa   : ()
Objetivo   : Imprimir relatorio de montadores 
Retorno    : 
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 30/04/2014 - 10:00
*/
Static Function WorkMontador()
Local i
Local lRet := .F.
Local cQuery := ""
Local lAnd      := .F.
Local lwhere := .T.
Local aPergunte:={"MV_PAR01","MV_PAR02", "MV_PAR03" ,"MV_PAR04" ,"MV_PAR05" ,"MV_PAR06"}
cQuery += "SELECT C5_CODUSR, C6_NUM , C5_CLIENTE ,C6_PRODUTO, C6_DTMONTA, C6_VALOR, C6_QTDVEN  FROM "+RetSqlName("SC6")+" INNER JOIN "+RetSqlName("SC5")+" ON C5_NUM = C6_NUM and C5_FILIAL = C6_FILIAL "
cQuery+= " Where C6_DTMONTA != '' and C6_FILIAL = " + SC6->(xFilial())+" And "+RetSqlName("SC6")+".D_E_L_E_T_ <> '*' "  

For i:=1 to len(aPergunte)
	If  !EMPTY (&(aPergunte[i])) 
		cQuery += " AND "
		Do case
		 
		 	Case i=1
				cQuery += " C6_DTMONTA >= '"+dtos(MV_PAR01)+"'
            Case i=2
   				cQuery += " C6_DTMONTA <= '"+dtos(MV_PAR02)+"'"
            Case i=3
   				cQuery += "C6_NUM >='"+Mv_Par03+"'       
            Case i=4
            	cQuery +="  C6_NUM <= '"+Mv_Par04+"'"
            Case i=5
             	cQuery+= "C5_CODUSR >='"+Mv_Par05 +"' 
            Case i=6
				cQuery += "	C5_CODUSR <= '"+Mv_Par06+"'"
				
		End Case
	end if
Next 

cQuery += " ORDER BY C5_CODUSR"
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"WK_SC6",.F.,.T.) 

Return 

 /*
Programa  : QuebraLinha()
Objetivo    : Impressao de relatorio entrega de produto
Retorno     :
Autor         : Fabio Satoru Yamamoto
Data/Hora  : 0205/2014 - 10:00 	
*/
Static Function QuebraLinha(aDesc)//aDesc {xtexto, nposicao, nlimite(tamanho do texto para quebra)}
Local i 
Local cDescFor
Local cDescProd
Local nPosVert1 := 600
Local nPosVert2 := 800
Local nPosVert3 := 1300
Local nPosVert4 := 1850
Local nPosVert5 := 2050
Local nEspaco	:= 20
If aScan(aDesc ,{|x|Len(x[1]) >= x[3]})=0
	For i:=1 To Len(aDesc)
   		oReport:Say(nlinha+50,aDesc[i][2]+nEspaco,aDesc[i][1],oFont03) 
		oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo
	Next
	Return
End If
 
While aScan(aDesc       ,{|x|     len(x[1]) >= x[3]})>0
	For i:=1 To Len(aDesc)
		oReport:Say(nlinha+50,aDesc[i][2]+nEspaco,Substr(aDesc[i][1],1,aDesc[i][3]),oFont03) 
		aDesc[i][1] := Substr(aDesc[i][1],aDesc[i][3]+1)
	Next
	PulaLinha() 	

   		oReport:Line( nlinha , 0050 , nlinha+100 , 0050 ) //Linha Esquerda
   		oReport:Line( nlinha , 2350 , nlinha+100 , 2350 ) //Linha Direita
   		//oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo
   		oReport:Line( nlinha , nPosVert1 , nlinha+100 , nPosVert1 ) //Linha vertical 1
   		oReport:Line( nlinha , nPosVert2 , nlinha+100 , nPosVert2 ) //Linha vertical 2
   		oReport:Line( nlinha , nPosVert3 , nlinha+100 , nPosVert3 ) //Linha vertical 3
		oReport:Line( nlinha , nPosVert4 , nlinha+100 , nPosVert4 ) //Linha vertical 4
  		oReport:Line( nlinha , nPosVert5 , nlinha+100 , nPosVert5 ) //Linha vertical 5
End Do

For i:=1 To Len(aDesc)
	oReport:Say(nlinha+50,aDesc[i][2]+nEspaco,Substr(aDesc[i][1],1,aDesc[i][3]),oFont03) 
	aDesc[i][1] := Substr(aDesc[i][1],aDesc[i][3]+1)
Next 
oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSx1บAutor  ณ SYMM Consultoria	 บ Data ณ  22/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Perguntas na SX1 atraves da funcao PUTSX1().          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSx1(cPerg)  

Local aHlpPor01 := {"Informe a data inicial."		,"",""}
Local aHlpPor02 := {"Informe a data final." 		,"",""}
Local aHlpPor03 := {"Informe o pedido inicial."		,"",""}
Local aHlpPor04 := {"Informe o pedido final."  		,"",""}
Local aHlpPor05 := {"Informe o motorista inicial."	,"",""}
Local aHlpPor05 := {"Informe o motorista final."	,"",""}

PutSx1(cPerg,"01","Data de 				?","","","MV_CH1","C",TamSx3("C5_EMISSAO")[1] 	,, ,"G",,""		,,,"MV_PAR01",			,,,,,,,,,,,,,,,,aHlpPor01,aHlpPor01,aHlpPor01)
PutSx1(cPerg,"02","Data ate		   		?","","","MV_CH2","C",TamSx3("C5_EMISSAO")[1]	,, ,"G",,""		,,,"MV_PAR02",  		,,,,,,,,,,,,,,,,aHlpPor02,aHlpPor02,aHlpPor02)
PutSx1(cPerg,"03","Pedido de 			?","","","MV_CH3","C",TamSx3("C5_NUM")[1]		,, ,"G",,"SC5"	,,,"MV_PAR03",			,,,CriaVar("C5_NUM",.F.) ,,,,,,,,,,,,,aHlpPor03,aHlpPor03,aHlpPor03)
PutSx1(cPerg,"04","Pedido ate			?","","","MV_CH4","C",TamSx3("C5_NUM")[1]		,, ,"G",,"SC5"	,,,"MV_PAR04",			,,,Replicate("Z",TamSx3("C5_NUM")[1]) 	,,,,,,,,,,,,,aHlpPor04,aHlpPor04,aHlpPor04)
PutSx1(cPerg,"05","Motorista de 		?","","","MV_CH5","C",TamSx3("C5_CODUSR")[1]	,, ,"G",,"USR"	,,,"MV_PAR05",			,,,CriaVar("C5_CODUSR",.F.) ,,,,,,,,,,,,,aHlpPor05,aHlpPor05,aHlpPor05)
PutSx1(cPerg,"06","Motorista ate		?","","","MV_CH6","C",TamSx3("C5_CODUSR")[1]	,, ,"G",,"USR"	,,,"MV_PAR06",			,,,Replicate("Z",TamSx3("C5_CODUSR")[1]) 	,,,,,,,,,,,,,aHlpPor06,aHlpPor06,aHlpPor06)

Return .T.
