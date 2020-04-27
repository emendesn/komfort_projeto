#include "rwmake.ch"
#include "protheus.ch"
#define DMPAPER_A4SMALL     10          // A4 Small 210 x 297 mm

/*
Programa  : A121SYMM01()
Objetivo    :  Impressao de relatorio entrega de produto
Retorno     :
Autor         : Fabio Satoru Yamamoto
Data/Hora  : 02/05/2014 - 10:00 	
*/
User Function A121SYMM01()
Private wnrel   :="A121SYMM01"
Private aReturn := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}//OBRIGATORIO PARA O SetPrint

AjustaSx1(cPerg)

If Pergunte("A121SYMM01",.T.)

	Work_SD1()
	If !WK_SD1->(EOF())
		RptStatus({|| reportDef()},"Gerando Impressใo") 
	Else
		MsgInfo("Nenhum registro encontrado")
	End If
	WK_SD1->(DBCLOSEAREA())

End If

Return(.T.)

/*
Programa  : ReportDef()
Objetivo    : Impressao de relatorio entrega de produto
Retorno     :
Autor         : Fabio Satoru Yamamoto
Data/Hora  : 02/05/2014 - 10:00 	
*/
Static Function ReportDef()
Local cAuxRel     := ""
Private oReport	:= Nil
Private oFont01 	:= TFont():New( "Arial",15,15,,.T.,,,    ,,,,,,,,)//titulo
Private oFont02 	:= TFont():New( "Arial",10,10,,.T.,,,15,,,,,,,,)//descricao negrito
Private oFont03 	:= TFont():New( "Arial",08,08,,.T.,,,15,,,,,,,,)//descricao
Private Linha     := 0 
Private nTotVal   := 0 
oReport:= TMSPrinter():New("Relat๓rio de Pedido de Compra")  

oReport:SetPortrait()  
oReport:Setup () 
oReport:SetPaperSize(DMPAPER_A4SMALL) 
oReport:StartPage()

//Cabecalho
//oReport:Say(0100, 1000, "Relatorio de Pedido de Compra",oFont01) 
oReport:Say(0100,700,"Pedidos Pendentes de entrada na Loja: "+SM0->M0_CODFIL+" - "+SM0->M0_NOMECOM,oFont01)
nlinha :=200

FormPedCom() //Formulario de itens

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
Programa  : FormPedCom()
Objetivo    : Impressao de relatorio entrega de produto
Retorno     :
Autor         : Fabio Satoru Yamamoto
Data/Hora  : 02/05/2014 - 10:00 	
*/
Static Function FormPedCom()
Local cDescFor	 := ""
Local cDescProd := "" 
Local aDesc         := {}
Private nEspaco   := 20
Private aPosVert := {50,270,400,1000,1600,1850,2050,2200,2350} 
//Cabecalho itens
PulaLinha()

oReport:Line( nlinha , 0050 , nlinha , 2350 ) //Linha Cima
oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

PrintVertical()
oReport:Line( nlinha , 0050 , nlinha , 2350 ) //Linha Cima
oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

oReport:Say(nlinha+50,aPosVert[1]+nEspaco,"Nota",oFont02)
oReport:Say(nlinha+50,aPosVert[2]+nEspaco,"Serie",oFont02)
oReport:Say(nlinha+50,aPosVert[3]+nEspaco,"Fornecedor",oFont02)
oReport:Say(nlinha+50,aPosVert[4]+nEspaco,"Produto",oFont02) 
oReport:Say(nlinha+50,aPosVert[5]+nEspaco,"Quantidade",oFont02) 
oReport:Say(nlinha+50,aPosVert[6]+nEspaco,"Data",oFont02)     
oReport:Say(nlinha+50,aPosVert[7]+nEspaco,"OC",oFont02) 
oReport:Say(nlinha+50,aPosVert[8]+nEspaco,"Loja",oFont02) 

PulaLinha()

WK_SD1->(dbGoTop())
While !WK_SD1->(EOF()) 

	oReport:Line( nlinha         , 0050 , nlinha+100 , 0050 ) //Linha Esquerda
	oReport:Line( nlinha         , 2350 , nlinha+100 , 2350 ) //Linha Direita
	//oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

	PrintVertical()
	oReport:Say(nlinha+50,aPosVert[1]+nEspaco,WK_SD1->F1_DOC,oFont02)
    oReport:Say(nlinha+50,aPosVert[2]+nEspaco,WK_SD1->F1_SERIE,oFont03)
    oReport:Say(nlinha+50,aPosVert[5]+nEspaco,AllTrim(STR(WK_SD1->D1_QUANT)),oFont03)
    oReport:Say(nlinha+50,aPosVert[6]+nEspaco,dtoc(stod(WK_SD1->D1_EMISSAO)),oFont03)
    oReport:Say(nlinha+50,aPosVert[7]+nEspaco,WK_SD1->D1_PEDIDO,oFont03)
    oReport:Say(nlinha+50,aPosVert[8]+nEspaco,SM0->M0_CODFIL,oFont03)

	cDescFor	 := AllTrim(POSICIONE("SA2",1,XFILIAL("SA2")+WK_SD1->F1_FORNECE,"A2_NOME"))
	cDescProd 	 := AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+WK_SD1->D1_COD,"B1_DESC")) 
	aAdd(aDesc,{cDescFor,aPosVert[3],30})
	aAdd(aDesc,{cDescProd,aPosVert[4],30})
	QuebraLinha(aDesc)
	WK_SD1->(DbSkip())
	PulaLinha()
	aDesc:={}
End Do 



Return 

/*
Programa   : Work_SD1()
Objetivo   : Impressao de relatorio entrega de produto
Retorno    :
Autor      : Fabio Satoru Yamamoto
Data/Hora  : 02/05/2014 - 10:00 	
*/
Static Function Work_SD1()
Local i
Local lRet			:= .F.
Local cQuery		:= ""
Local lAnd			:= .F.
Local lwhere		:= .T.
Local aPergunte	:={"MV_PAR01","MV_PAR02"/*,"MV_PAR03"*/}
//SF1 CAPA
//SD1 ITEM
cQuery += "SELECT  F1_DOC, F1_SERIE, F1_FORNECE, D1_COD, D1_QUANT, D1_EMISSAO, D1_PEDIDO,  F1_LOJAENT FROM "+RetSqlName("SD1")+" INNER JOIN "+RetSqlName("SF1")+" ON F1_DOC = D1_DOC and F1_FILIAL = D1_FILIAL "
cQuery+= " Where D1_TES = '' and D1_FILIAL = " + SD1->(xFilial("SD1"))+" And "+RetSqlName("SD1")+".D_E_L_E_T_ <> '*' "  

For i:=1 to len(aPergunte)
	If  !EMPTY (&(aPergunte[i])) 
		cQuery += " AND "
		Do case
		 	Case i=1
		 		//cQuery += " F1_LOJAENT = '"+MV_PAR01+"'"
		 		cQuery += " D1_DTDIGIT >= '"+dtos(MV_PAR01)+"'	 
		 	Case i=2
				//cQuery += " D1_DTDIGIT >= '"+dtos(MV_PAR02)+"'
				cQuery += " D1_DTDIGIT <= '"+dtos(MV_PAR02)+"'"
           /*
           Case i=3
   				cQuery += " D1_DTDIGIT <= '"+dtos(MV_PAR03)+"'"
   			*/
		End Case
	end if
Next 

cQuery += " ORDER BY D1_DOC, D1_ITEM"
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"WK_SD1",.F.,.T.) 

Return

Static Function PulaLinha()
nlinha =50+nlinha
Return
 
Static Function ProxTabela()
nlinha =70+nlinha
Return
 
/*
Programa  : QuebraLinha()
Objetivo    : Impressao de relatorio entrega de produto
Retorno     :
Autor         : Fabio Satoru Yamamoto
Data/Hora  : 02/05/2014 - 10:00 	
*/
Static Function QuebraLinha(aDesc)//aDesc {xtexto, nposicao, nlimite(tamanho do texto para quebra)}
Local i 
Local cDescFor
Local cDescProd
Local TamLim := 30

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
		aDesc[i][1] := Substr(aDesc[i][1],TamLim+1)
	Next
	PulaLinha() 	
	PrintVertical()
End Do

For i:=1 To Len(aDesc)
	oReport:Say(nlinha+50,aDesc[i][2]+nEspaco,Substr(aDesc[i][1],1,aDesc[i][3]),oFont03) 
	aDesc[i][1] := Substr(aDesc[i][1],aDesc[i][3]+1)
Next 
oReport:Line( nlinha+100 , 0050 , nlinha+100 , 2350 ) //Linha Baixo

Return 

Static Function PrintVertical()
Local i
For i:=1 To len(aPosVert) 
	oReport:Line( nlinha , aPosVert[i] , nlinha+100 , aPosVert[i] )
next
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

PutSx1(cPerg,"01","Data Entrada de 		?","","","MV_CH1","C",TamSx3("C5_EMISSAO")[1] 	,, ,"G",,""		,,,"MV_PAR01",			,,,,,,,,,,,,,,,,aHlpPor01,aHlpPor01,aHlpPor01)
PutSx1(cPerg,"02","Data Entrada ate		?","","","MV_CH2","C",TamSx3("C5_EMISSAO")[1]	,, ,"G",,""		,,,"MV_PAR02",  		,,,,,,,,,,,,,,,,aHlpPor02,aHlpPor02,aHlpPor02)
