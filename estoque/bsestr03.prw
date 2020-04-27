 #Include "Protheus.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BSESTR03  ºAutor  ³Renan Paiva         º Data ³  05/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio para imprimir o saldo em estoque na data informadaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BSEstR03()

Local oReport   
private dData 
//U_CheckPRW("BSESTR03")
Private cPerg := Padr("BSESTR03",10)

AdjSx1()

If TRepInUse() //Verifica se o objeto de impressao do release 4 esta em uso
	Pergunte(cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
Else
	MsgStop("Relatório disponível somente em Release 4","Erro de Release")
EndIf
Return

************************************************************************************
//ROTINA PARA DEFINIÇÃO DO RELATORIO											  //
************************************************************************************
Static Function ReportDef()

Local oReport
Local oSection1 //cabecalho
Local oSection2 //itens do relatorio analitico

oReport:=TReport():New("BSESTR03","Posição de Estoque Data Referencia: "+DtoC(MV_PAR01),cPerg,{|oReport|PrintReport(oReport)},"Este relatório imprimirá a Posicao de Estoque conforme os parametros fornecidos pelo usuário")
oSection := TRSection():New(oReport,"Totais",{"SB1"})
oReport:SetLandscape() //Seta o relatorio para paisagem
oReport:oPage:nPaperSize := 9 //Seta o tamanho pagina para A4
oReport:SetTotalInLine(.F.)

TRCell():New(oSection,"dData" 	,,"Data")
TRCell():New(oSection,"B1_COD" 	, "SB1")
TRCell():New(oSection,"B1_DESC" 	    , "SB1")
TRCell():New(oSection,"B1_UM" 	    , "SB1")
TRCell():New(oSection,"B1_CUSTD" 	    , "SB1")
TRCell():New(oSection,"B1_POSIPI" 	    , "SB1")
TRCell():New(oSection,"QUANTIDADE"    , ,"Quantidade"	,"@E 999,999,999,999.99999",23)   
TRCell():New(oSection,"CUSTO" 	    , ,"Custo"			,"@E 999,999,999,999.99999",23)   
TRCell():New(oSection,"TOTAL" 	    , ,"Valor Total"	,"@E 999,999,999,999.9999" ,23) 

oSection:Cell("QUANTIDADE"):SetHeaderAlign("RIGHT")
oSection:Cell("CUSTO"):SetHeaderAlign("RIGHT")
oSection:Cell("TOTAL"):SetHeaderAlign("RIGHT")

oBreak := TRBreak():New(oSection,{|| Eof()},"Total do Relatorio")

TRFunction():New(oSection:Cell("QUANTIDADE"),NIL,"SUM",oBreak,,"@E 999,999,999,999.99999",,.F.,.F.)
//TRFunction():New(oSection:Cell("CUSTO"),NIL,"SUM",oBreak,,"@E 999,999,999,999.99999",,.F.,.F.)
TRFunction():New(oSection:Cell("TOTAL"),NIL,"SUM",oBreak,,"@E 999,999,999,999.9999",,.F.,.F.)
  

Return oReport

**************************************************************
//Rotina para impressao do relatorio                        //
**************************************************************

Static Function PrintReport(oReport)

Local oSection := oReport:Section(1) //Inicializa a primeira sessao do treport
Local aSaldo :=  {}   
Local aSaldoSum := Array(2)
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+MV_PAR02,.T.) 

oSection:Cell("QUANTIDADE"):SetBlock({|| aSaldoSum[1]})
oSection:Cell("CUSTO"):SetBlock({|| aSaldoSum[2] / aSaldoSum[1]})
oSection:Cell("TOTAL"):SetBlock({|| aSaldoSum[2]})
oSection:Cell("Data"):SetValue(dData)
oReport:SetMeter(SB1->(RecCount()))

oSection:Init()

oReport:SkipLine()
oReport:PrintText("Empresa: " + AllTrim(SM0->M0_NOME),oReport:Row(),oReport:Col())          
oReport:SkipLine()
oReport:PrintText("Posição de Estoque Data Referencia: " + DtoC(MV_PAR01),oReport:Row(),oReport:Col())

While !Eof() .And. SB1->B1_COD <= MV_PAR03  
	If MV_PAR04 == "**"    
		aFill(aSaldoSum, 0)
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2") + SB1->B1_COD)
		dData := DtoC(MV_PAR01)
		While SB2->B2_COD == SB1->B1_COD .And. !Eof()
			aSaldo := CalcEst(SB1->B1_COD, SB2->B2_LOCAL,MV_PAR01+1) 			
			aSaldoSum[1] += aSaldo[1]
			aSaldoSum[2] += aSaldo[2]
			dbSelectArea("SB2")
			dbSkip()
		EndDo	
	Else
		aSaldoSum := CalcEst(SB1->B1_COD, MV_PAR04,MV_PAR01+1)
	EndIf	              
	If !(MV_PAR05 == 1 .And. aSaldoSum[1] == 0 .And. aSaldoSum[2] == 0)
		oSection:PrintLine()
	EndIf	
	oReport:IncMeter()
	dbSelectArea("SB1")
	dbSkip()
EndDo



oSection:Finish()

Return


**************************************************************
//cria as perguntas do relatorio                            //
**************************************************************

Static Function AdjSx1()

Local _aPerg  := {}
Local _ni

Aadd(_aPerg,{"Data Referencia?","mv_ch1","D",08,0,"G","","mv_par01","","","","",""})
Aadd(_aPerg,{"Produto De?","mv_ch2","C",15,0,"G","","mv_par02","","","","SB1",""})
Aadd(_aPerg,{"Produto Ate?","mv_ch3","C",15,0,"G","","mv_par03","","","","SB1",""})
Aadd(_aPerg,{"Armazem?","mv_ch4","C",2,0,"G","","mv_par04","","","","",""})
Aadd(_aPerg,{"Imprime Qtd e Custo Zerado?","mv_ch5","N",1,0,"C","","mv_par05","Nao","Sim","","",""})



dbSelectArea("SX1")
For _ni := 1 To Len(_aPerg)
	If !dbSeek(cPerg+StrZero(_ni,2))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO    := cPerg
		SX1->X1_ORDEM    := StrZero(_ni,2)
		SX1->X1_PERGUNT  := _aPerg[_ni][1]
		SX1->X1_PERSPA   := _aPerg[_ni][1]
		SX1->X1_PERENG   := _aPerg[_ni][1]
		SX1->X1_VARIAVL  := _aPerg[_ni][2]
		SX1->X1_TIPO     := _aPerg[_ni][3]
		SX1->X1_TAMANHO  := _aPerg[_ni][4]
		SX1->X1_DECIMAL  := _aPerg[_ni][5]
		SX1->X1_GSC      := _aPerg[_ni][6]
		SX1->X1_VALID	 := _aPerg[_ni][7]
		SX1->X1_VAR01    := _aPerg[_ni][8]
		SX1->X1_DEF01    := _aPerg[_ni][9]
		SX1->X1_DEFSPA1  := _aPerg[_ni][9]
		SX1->X1_DEFENG1  := _aPerg[_ni][9]
		SX1->X1_DEF02    := _aPerg[_ni][10]
		SX1->X1_DEFSPA2  := _aPerg[_ni][10]
		SX1->X1_DEFENG2  := _aPerg[_ni][10]
		SX1->X1_DEF03    := _aPerg[_ni][11]
		SX1->X1_DEFSPA3  := _aPerg[_ni][11]
		SX1->X1_DEFENG3  := _aPerg[_ni][11]
		SX1->X1_F3       := _aPerg[_ni][12]
		SX1->X1_CNT01    := _aPerg[_ni][13]
		MsUnLock()
	EndIf
Next _ni

Return
