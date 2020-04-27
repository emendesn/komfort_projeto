#include "rwmake.ch"
#INCLUDE "protheus.ch"
#include "colors.ch"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#include 'COLORS.CH'
#Include "prtopdef.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KHBXAUTO()

Private aRotina   := {}
Private cCadastro := "Apontamento Automatico"

	aAdd( aRotina, {"Pesquisar"     ,"AxPesqui"         ,0,1 } )
	aAdd( aRotina, {"Incluir"       ,"U_KHBXA001(1)"   ,0,3 } )

	dbSelectArea("SC2")
	SC2->(DbSetOrder(1) )

	mBrowse(,,,,"SC2",,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KHBXA001(nparam)

Local bOk           := {||}
Local bCanc         := {||oDlg:End()}
Local bEnchoice     := {||}
Local nPar          := nparam
Local cPacTot
Local cCont

Private xLoteCtl
Private xTm         := "009"
Private xCod
Private xLocEnv
Private xProduto
Private	xQtdSC2     := 0
Private nQD 	    := 0
Private nQtEtiq     := 0
Private xDtValid    := ""
Private xDesc       := ""
Private xQtdPrd     := 0
Private xProm
//Private xYears:=GETMV("MV_X2YEARS")
Private DtLtProm    := CTOD("  /  /    ")
Private lEdit       := .F.
Private lMsHelpAuto	:= .T.
Private lMsErroAuto := .F.

SetPrvt("dData,dHora,cPeca,cOpera,cMat,cNome,nPar,cOp,cLT,cDA,cCO,nQD,dHF,dHI,xnQuant,cTempo,nAux,cAO,cAD,aSize,cUn,cAlmox,cCCop,cAuxOp,cCor,nQtdePI,cPeca2,lLogic,lGrava")
SetPrvt("lOp,cPacTot,cCont,lBTrans,cWHB,cPecOp")

aSize     := MsAdvSize()

bCanc := {|| oDlg:End() }

cPeca 	  := space(15)
cOpera    := space(03)
cOp 	  := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN//space(11)
cLT  	  := space(15)
cDa 	  := CTOD("  /  /    ")
cCo		  := space(3)
cTempo 	  := CTOD("  :  ")
cCor	  := space(10)
cDescr	  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
dData 	  := dDataBase
dHora 	  := Time()
dHF 	  := space(5)
dHi 	  := space(5)

xnQuant 	  := 0
nQtdePI   := space(15)
nPar 	  := nParam
nSalEst	  := 0

lTransf   := .T.
lPI 	  := .T.
lLogic    := .T.
lGrava    := .T.
lOp       := .T.
lBTrans   := .T.

oFont1 := TFont():New("Arial",,22,,.t.,,,,,.f.)

If nPar == 1 // Incluir
	bOk   := {|| fGrava() }
ElseIf nPar == 2 // Visualizar
	fCarrega()
	bOk   := {|| oDlg:End() }
ElseIf nPar == 3 // Alterar
	fCarrega()
	bOk := {|| fAltera() }
EndIf


bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Apontamento de Produção",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oSay1 := TSay():New(36,10,{||"Data:"},oDlg,,,,,,.T.,,)
oGet1 := tGet():New(34,50,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,60,8,"99/99/9999",{||.T.},,,,,,.T.,,,{|| .F. },,,,,,,"dData")

oGroup1 := tGroup():New(72,10,132,410," Ordem de Produção ",oDlg,,,.T.)

oSay7 := TSay():New(82,20,{||"OP:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet7 := tGet():New(80,50,{|u| if(Pcount() > 0, cOp := u,cOp)},oDlg,60,8,"@!",{||fValidaOp()},,,,,,.T.,,,{|| .T. },,,,,,"SC2","cOp")

oSay7 := TSay():New(82,20,{||"Descrição:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet7 := tGet():New(80,50,{|u| if(Pcount() > 0, cOp := u,cOp)},oDlg,60,8,"@!",{||fValidaOp()},,,,,,.T.,,,{|| .T. },,,,,,"SC2","cOp")

oSay8 := TSay():New(82,160,{||"Quantidade:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet8 := tGet():New(80,200,{|u| if(Pcount() > 0, xnQuant := u,xnQuant)},oDlg,60,8,CBPictQtde(),{||fValQtde()},,,,,,.T.,,,{|| .T. },,,,,,,"xnQuant")

oSay8 := TSay():New(82,280,{||"Qtd. Produzida:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet8 := tGet():New(80,330,{|u| if(Pcount() > 0, xQtdPrd := u,xQtdPrd)},oDlg,60,8,CBPictQtde(),{||fValQtde()},,,,,,.T.,,,{|| .F. },,,,,,,"xQtdPrd")


oSay9 := TSay():New(100,20,{||"Descricao:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet9 := tGet():New(100,50,{|u| if(Pcount() > 0, xDesc := u,xDesc)},oDlg,210,8,"@R!",{||fValidaOp()},,,,,,.T.,,,{|| .F. },,,,,,,"xDesc")

//oSay9 := TSay():New(100,280,{||"Data Validade:"},oDlg,,,,,,.T.,CLR_HBLUE,)
//oGet9 := tGet():New(100,330,{|u| if(Pcount() > 0, DtLtProm := u,DtLtProm)},oDlg,60,8,"99/99/9999",{||fValidaDt()},,,,,,.T.,,,{|| lEdit },,,,,,,"DtLtProm") //08007001001
oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fValPeca()

SB1->(DbSetOrder(1) )
If !SB1->(DbSeek(xFilial("SB1") + cPeca) )
	Alert("Peça não encontrada! ")
	Return .F.
else
	cPeca2 := SB1->B1_COD
EndIf

Return


Static Function fValidaDt()

If lEdit
	If Empty(DtLtProm)
		If Rastro(xProduto)
			Alert("Por se tratar de Promocao a data de validade deve ser preenchida! ")
			
			Return
			
		EndIf
	Endif
Endif

If Rastro(xProduto)
	If Empty(xDtValid)
		xDtValid:=DtLtProm
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValidaOp()
Local cAlmox := space(02)
Local cUn := Space(02)
Local cAuxOp := cOp
Local cQuery
Local D := 365.25
Local E := 4716
Local F := 30.6001
Local M:= 01
Local dtJuliana
Local xYear:=""
Local xInt:=0
Local xLotIn1:="0"
Local _cAlias := GetNextAlias()
Local _xCtm:='PR%'
Local Stdat
Local xInt2


SC2->(DbSetOrder(1))
If SC2->(DbSeek(xFilial("SC2")+cOp))
	
	cDa	      := SC2->C2_EMISSAO
	cAlmox    := SC2->C2_LOCAL
	cUn       := SC2->C2_UM
	xProduto  := SC2->C2_PRODUTO
	xQtdSC2	  := SC2->C2_QUANT
	D:=Substr(Dtos(cDa),1,2)
	Y:=Substr(Dtos(cDa),3,2)
	Y:=Y+"0"
	nQD:=SC2->C2_QUANT
	Stdat:=DtoS(cDa)
	xLotectl:=""
	xQtdPrd:=SC2->C2_QUJE
	
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+xProduto)
	xDesc:=B1_DESC
	lEdit:=.F.
	xDtValid:=""
	
Else
	
	Alert("Ordem de Produção não encontrada! ")
	
	Return
	
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fQtdMax()
Local cQuery  := ""
Local cQuery2 := ""
Local cQuery3 := ""

Private nQtdAt := 0
Private nQtdAn := 0
Private cCodPi := ""
Private nSaldoPI := 0

nQtdAn := SC2->C2_QUANT

Return


Static Function FvldDig()

Local lRet := .F.

If xProm="1"
	lRet:=.T.
	xlEdit:=.T.
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValQtde()

If xnQuant > nQD
	alert("Quantidade informada maior que a da abertura da OP! ")
	Return .F.
EndIf

Return  .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGrava()
Local nQtde
Local aMat250:={}
Local aLog := {}
Local xMenerr:="Erro Apontamento da Ordem de Produção: "+cOp + " Qtd. Apont: " +Str(xnQuant)+ " Produto: "+xProduto+ " - " +xDesc
Local xMenAp:="Apontamento da Ordem de Produção: "+cOp + "Qtd. Apont: " +Str(xnQuant)+ " Produto: "+xProduto+ " - " +xDesc
Private lCont := .T.
Private _cNTrans
Private xDocSd3
Private lAutoErrNoFile:=.T.
Private cTo:=GetMV("MV_KHBXAUT")
Private cToAp:=GetMV("KH_KHBXAPO")

If SC2->C2_QUANT - SC2->C2_QUJE > xnQuant
	cPacTot := "P"
Else
	cPacTot := "T"
EndIf

DbSelectArea("SD3")
xDocSd3:= NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc
aAdd(aMat250,{{ 'D3_TM',xTm	 			,NIL }                    				,;
{ 'D3_OP'     ,cOp			 			,Nil},;
{ 'D3_COD'    ,xProduto   				,NIL},;
{ 'D3_QUANT'  ,xnQuant        			,NIL},;
{ 'D3_UM'     ,SB1->B1_UM				,NIL},;
{ 'D3_LOCAL'  ,SC2->C2_LOCAL    		,NIL},;
{ 'D3_CC'     ,""						,NIL},;
{ 'D3_EMISSAO',dDataBase     			,NIL},;
{ 'D3_SEGUM'  ,SB1->B1_SEGUM    		,NIL},;
{ 'D3_CONTA'  ,SB1->B1_CONTA			,NIL},;
{ 'D3_TIPO'   ,SB1->B1_TIPO     		,NIL},;
{ 'D3_CF'     ,'PR0'          			,Nil},;
{ 'D3_PARCTOT',cPacTot       			,Nil},;
{ 'D3_DOC'    ,xDocSd3            		,Nil},;
{ 'REQAUT'    ,'S'            			,Nil},;
{ 'ATUEMP'    ,'T'            			,Nil}})

Processa({|| MSExecAuto({|x,y| mata250(x,y)},aMat250[1],3)},"Aguarde. Apontando OP...")

aLog := GetAutoGRLog()
If lMsErroAuto
	If !Empty(aLog)
		U_MailNotify(cTo,"" ,xMenerr,aLog,{},.T.)
		alert("Erro no apontamento de producao, foi enviado um e-mail com os produtos sem saldo em estoque para o PCP! ")
		Return
	Else
		KMHPRD1(xDocSd3)
		U_MailNotify(cToAp,"" ,xMenAp,aLog,{},.T.)
	Endif
Else
	KMHPRD1(xDocSd3)
	aLog:={"Existe(m) produto(s) para ser(em) retirado(os) do Armazem 95 referente a Op: "+ cOp + "QQuantidade: " +Str(xnQuant)+ " Produto: "+xProduto+ " - " +xDesc }
	U_MailNotify(cToAp,"" ,xMenAp,aLog,{},.T.)
	Return
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fValida()

If xnQuant > nQd
	alert(" Quantidade não pode ser maior que a quantidade disponível! ")
	xnQuant := ""
	xnQuant := space(15)
	Return .F.
EndIf

If Empty(xnQuant)
	alert("Quantidade não pode ser em branco! ")
	Return .F.
EndIf

If Empty(cPeca)
	alert("O campo Peca deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cOpera)
	alert("O campo Operação deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cMat)
	alert("O campo Matricula deve ser preenchido! ")
	Return .F.
EndIf

If Empty(cOp)
	alert("O campo Op deve ser preenchido! ")
	Return .F.
EndIf
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ »±±
±±ºPrograma:KHBXAUTO Autor:Vanito Rocha             Data:26/07/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento automatico da Producao em subsituiçao a rotina º±±
±±º          ³ MATA250                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KMHPRD1(xDocSd3)

Local _aEtq       := {}
Local _cDimen     := ""
Local lRet		  :=.T.
Local _nx         := 0
Local _ny         := 0
Local nW 		  := 1
Local _cCodBar    := ""
Local bCount:=0
Local nItemEnd:=1
Private _oDlg     := Nil
Private _oLbx     := Nil
Private oOk       := LoadBitmap( GetResources(), "LBOK" )
Private oNo       := LoadBitmap( GetResources(), "LBNO" )

_cPerg    := PadR(_cPerg, Len(SX1->X1_GRUPO))

If !Empty(cOp) .AND. xnQuant > 0
	
	_cQuery := " SELECT * "
	_cQuery += " FROM " + RETSQLNAME("SC2") + " SC2 (NOLOCK) "
	_cQuery += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ <> '*' JOIN SA2010 SA2 (NOLOCK) ON SA2.A2_COD=SB1.B1_PROC AND SA2.A2_LOJA=SB1.B1_LOJPROC"
	_cQuery += " WHERE SC2.D_E_L_E_T_ <> '*' AND SC2.C2_SEQUEN='001'"
	_cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+cOp+"' AND '"+cOp+"' "
	_cQuery := ChangeQuery(_cQuery)
	
	_cAlias   := GetNextAlias()
	
	DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )
	
	DbSelectArea(_cAlias)
	(_cAlias)->(DbGoTop())
	nCount:=xnQuant
	If nCount > 0
		
		While (_cAlias)->(!Eof())
			
			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			If SB5->(DbSeek(xFilial("SB5") + (_cAlias)->C2_PRODUTO))
				_cDimen := cValToChar(SB5->B5_ALTURLC) + " x "+  cValToChar(SB5->B5_LARGLC) + " x " + cValToChar(SB5->B5_COMPRLC)
			EndIf
			
			
			AADD(_aEtq,{.T.,(_cAlias)->C2_NUM, (_cAlias)->C2_PRODUTO,(_cAlias)->B1_DESC, (_cAlias)->C2_QUANT,(_cAlias)->C2_EMISSAO,(_cAlias)->C2_ITEM,(_cAlias)->C2_SEQUEN,(_cAlias)->B1_PROC, (_cAlias)->B1_LOJPROC,(_cAlias)->A2_COD,(_cAlias)->A2_LOJA,(_cAlias)->A2_NOME,""})
			
			(_cAlias)->(DbSkip())
			
		EndDo
		(_cAlias)->(DbCloseArea())
	Endif
	If nCount > 0
		If Len( _aEtq ) > 0
			cModelo:= "ZEBRA"
			cPorta := "LPT1"
			MSCBPRINTER(cModelo,cPorta,,110,.F.,,,,,,)
			MSCBLOADGRF("LOGOZ.GRF")
			MSCBCHKSTATUS(.F.)
			nQtdCont := 0
			nContad	:= 0
			nQtdCont := 0
			For _nx := 1 To Len(_aEtq)
				For _ny := 1 To nCount
					
					cCodProdu := _aEtq[_nx][03]
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1") + cCodProdu ))
					
					DbSelectArea("SA2")
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial("SA2") + _aEtq[_nx][09]+_aEtq[_nx][10]))
					_cForne := _aEtq[_nx][11]+"/"+_aEtq[_nx][12]+" - "+_aEtq[_nx][13]
					
					MSCBBEGIN(1,4)
					MSCBGRAFIC(90,03,"LOGOZ")
					
					_cCodBar := _aEtq[_nx][02]+_aEtq[_nx][07]+_aEtq[_nx][08]
					MSCBWrite("^FO608,32^GFA,08960,08960,00028,:Z64:eJzt2bFu2zAQBuATFJQZjMjZPBRVH8FjB6Hqo/gR1LFAEAno0NfS4LEPoW4Funh0AUOsKNrUkdJ/tpUUSIBwKJB+rS0dj8cjQ/Q23sbzjYio1FofntnyznbASFXwWUg18yyZ/DZr5R5b+wAtPnyAluyTao6ltaqRlVWMjbA9UAStIPqCbDMJ5w0OY7qBFms8D8l0JtmY6XaW5ZRWyD5TUiN7IDxHhTAPr8Wk95PiIsVTslRraIkwf7GQEzRdXc7n53+wrtbVyMrZhuMiGRGuWV20K2ygKPeGc+llmVBb5Xmo5pk0R0Luzp+jep69jjm6dP7iamTub+J9aGyOdGjsH5eVZ96Ya3kdGItL2syzZO+Z6bPcz+rgmenP3Cep9ipz1TWC1oVae2ae8/gEiSa2bo6WHd9OVyWyUlcsaL51GZDvrjYToDoNjCjrtyVjas8t6qPyVx/twM32LyeLW262D3mqRZqb3VNPRsMC6Pdps1a+TVqwv5cNs6AvGIL2ZIu1/nVQWrdDhnrWGhsC6pnurZ22H53F3LL+/ZxFLtPOmO1tmNWD2Vg7I262fxksbwaz/Quz3WC2fxksZWb7l8Fc0M5ZP5gdsCmNLRatcmbr7mAuaFcalZI1wzwEMXMBdfsms5RbUvl2YKb870vaCy327RRQ3xS21topoJ6dkuEYND4PDT2jHb9PMrtuwXOO3y/Sf6CZolqBeEqWh8bmrxTsMZwjli9FaCzPxlZD43l9jfF15ObogvUnrVtpvYt1QrBUMF7PRtZg4/XzCvPq9RXm7Q8X2mg/Gqwd7WNuRGvz5/Vmh7dvBvdn3j5tze3vp+w8fuZ7Qn0B0R2hfsKe8Zy1l1tcof7F1onpfonsvVQ+1WfR6c6q7PuzaZvs6y6yyT7y+JPpP5FN9K3uPDbqd72zxahPZjM76q+x5fyMEvTz3gjOAd5IA+N3csHZwruTC84rknn3daVvKT/fBuejjN8zBOexNT")
					MSCBWrite("vZhec43n96nWhk7irx/edLskKwtXBmliwT7m0+oLsEMln9iAjfu5mPRXe4Z4xy+CizR4TudMjkJ7DFJ3xfJ9nqQBn6suXW3LNPj/stvkv/Kpj0/0S7EewWW7qiNbIbwkZ2N5ocatfvRlfbYoXnb7XAd3nLG9HgKGaa9JnLRRczsI5Wt1Tw/YKPZEdFDO4c44Y26nuNvnKjQJ0QrcuXd6AuGbsDluoaGt1sigxb9jDP8j14h7vhKDh+zhWqnt16WACgfh3B0a1bb1+71JbbGv4ObLndpKjurrYfUwXujBc/KVNgD+j6gLWKp23ZpTbKCcnI5BKYo65+Qlv9xtbVT2j3M83UVvQO/f8DMetyolDgd1n3XY1UYN2a+qnA3JpUiqdJtLcxHv8A+9BsqA==:4D7D")
					MSCBSAY(065,010, "FORNECEDOR : " + Left(_cForne, 37),"R","B","040,020")
					MSCBSAY(057,010, "CODIGO PRODUTO FORNECEDOR : " + 	cCodProdu,"R","0","030,020")
					MSCBSAY(051,010, "CODIGO PRODUTO NA KOMFORT : ","R","0","030,020")
					MSCBSAY(051,050, cCodProdu,"R","B","040,020")
					MSCBSAY(051,120, "Op: "+ _aEtq[_nx][02] + "  Data Produção : " + _aEtq[_nx][06],"R","0","030,020")
					cEnde := "PRD-KO-MFORT"
					aEnde:={'PK','RM','DH'}
					
					MSCBSAY( 040,010, left(_aEtq[_nx][04],50)  ,"R","B","040,020")
					MSCBSAY( 032,010, substr(_aEtq[_nx][04],51),"R","B","040,020")
					
					nInicio := 97	// 100
					nAltura := 32	//  20
					for nW := 1 to len( aEnde )
						MSCBSAY(nInicio - nW * nAltura,180 ,aEnde[nW],"R","0","310,310")
					next
					
					MSCBSAYBAR(12,25,_cCodBar,"R","MB07",15,.F.,.T.,.F.,,4,3)
					MSCBEND()
					
					DbselectArea("ZL2")
					DbSetOrder(1)
					Reclock("ZL2",.T.)
					ZL2_FILIAL:= "0101"
					ZL2_NOTA  := ""
					ZL2_SERIE := ""
					ZL2_COD   := _aEtq[_nx][03]
					ZL2_ITEMNF:= '0001'
					ZL2_LOCAL := '01'
					ZL2_LOCALI:= ''
					ZL2_QUANT := 1
					ZL2_ENDER := 'N'
					ZL2_FORNE := _aEtq[_nx][09]
					ZL2_LOJA  := _aEtq[_nx][10]
					ZL2_OP    := _aEtq[_nx][02]+_aEtq[_nx][07]+_aEtq[_nx][08]
					ZL2_D3DOC := xDocSd3
					Msunlock()
				Next _ny
			Next _nx
		EndIf
	Endif
	MSCBCLOSEPRINTER()
EndIf
Return
