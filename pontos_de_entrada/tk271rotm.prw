// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : TK271ROTM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "protheus.ch"
#DEFINE CRLF CHR(10)+CHR(13)

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     2/06/2014
/*/
//------------------------------------------------------------------------------------------
user function TK271ROTM()
//--< variáveis >---------------------------------------------------------------------------
Local aArea 	:= GetArea()
Local aRotina 	:= {}	//Adiciona Rotina Customizada aos botoes do Browse
Local cQuery	:= ""            

//aAdd( aRotina, { 'Libera Pedido' 	,'U_A273VLDA()'	, 0 , 7 })
aAdd( aRotina, { 'Reimpressão' 		,'U_A273VLD9()'	, 0 , 7 })
//AAdd( aRotina, { 'Bloqueio'	        ,'U_KMFRA06()'	, 0 , 4 , 0 , NIL   })  //#RVC20180918.n - Rotina comentada após alinhamento com crédito, fora de uso
AAdd( aRotina, { 'Reimpr. Agregado'	    ,'U_SYVR109()'	, 0 , 7 })  //Marcio Nunes 14/05/2019  
                                                          
If GetMv("MV_SYATSUA",,.F.)
	cQuery := "UPDATE "+RetSqlName("SUA")+" SET UA_OPER='2' WHERE UA_FILIAL = '"+xFilial("SUA")+"' AND UA_OPER = '1' AND UA_EMISSAO = '"+Dtos(dDatabase)+"' AND (UA_NUMSC5='' AND UA_PEDLIN2='') AND D_E_L_E_T_ = ' '
	TcSqlExec(cQuery)  
Endif

RestArea(aArea)

Return aRotina
//--< fim de arquivo >----------------------------------------------------------------------

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : TK271ROTM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

User Function A273VLD6(cAtendimento)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea   	:= GetArea()
Local cObs    	:= ""										//variavel com a descricao do MEMO
Local cObs1		:= ""
Local oMonoAs	:= TFont():New( "Courier New", 6, 0 )		//Fonte do MEMO
Local cUser		:= UsrRetName(__cUserID) + " | " + DtoC(dDataBase) + " | " + TIME() 
Local nOpca		:= 0										//Opcao de escolha OK ou CANCELA
Local nTotal 	:= 0
Local lHist		:= !Empty(SUA->UA_CODFOLL)
Local oDlg													//Tela para cancelamento
Local oObs													//MEMO para observacao do cancelamento
Local cHist           

Default cAtendimento := SUA->UA_NUM  

SUA->(DbSetOrder(1))
SUA->(DbSeek(xFilial("SUA") + cAtendimento ))

//Grava Memo.
DEFINE MSDIALOG oDlg FROM 05,10 TO 270,470 TITLE "Follow Up" PIXEL

cHist := MSMM(SUA->UA_CODFOLL,TamSx3("UA_OBSFOLL")[1]) + CRLF

@ 03,04 To 129,228 LABEL "Digite a Informação" OF oDlg PIXEL
@ 12,08 GET oObs VAR cObs OF oDlg MEMO SIZE 215,95 PIXEL Valid !Empty(cObs)

oObs:oFont := oMonoAs

DEFINE SBUTTON FROM 111,200 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

IF nOpca == 1
	If lHist
		cObs1 := cHist + CRLF +cUser + CRLF + cObs
	Else 
		cObs1 := cUser + CRLF + cObs
	Endif
	RecLock("SUA",.F.)
	MSMM(,TamSx3("UA_CODFOLL")[1],,cObs1,1,,,"SUA","UA_CODFOLL")
	MsUnlock()
EndIF

Return

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : TK271ROTM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

User Function A273VLD9()

Local nAviso	 := 0
Local aBoxParam  := {}
Local aRetParam  := {} 
Local _cFilial := Subs(cNumEmp,3,4)//#CMG20180312.n
                      
cFilAnt := _cFilial//#CMG20180312.n

nAviso := Aviso( "Reimpressão" , "Selecione uma opção" , { "Follow Up" , "Retira" ,"Recibo RA","Orçamento" , "Pedido" ,  "Sair"  },2)

If nAviso==4	//Orçamento

	Aadd(aBoxParam,{1,"Orçamento"	,CriaVar("UA_NUM"	,.F.) ,PesqPict("SUA","UA_NUM")		,"","KHF3OR","",TamSX3("UA_NUM")[1]		,.T.})
	Aadd(aBoxParam,{1,"Filial"		,CriaVar("UA_FILIAL",.F.) ,PesqPict("SUA","UA_FILIAL")	,"","SM0"		,"",TamSX3("UA_FILIAL")[1]	,.T.})	//#RVC20180510.n
	
	IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
		Return(.F.)
	EndIf
	
	DbSelectArea("SUA")
	DbSetOrder(1)
//	DbSeek(xFILIAL("SUA") + MV_PAR01 )	//#RVC20180510.o
	DbSeek(MV_PAR02 + MV_PAR01 )		//#RVC20180510.n
	
	//U_SYTMR002()
	U_KMORCAMEN(Mv_Par01,.F.,MV_PAR02) // VERSAO GRAFICA DO ORCAMENTO - LUIZ EDUARDO F.C. - 24.10.2017
	
Elseif nAviso==5	//Pedido	

	Aadd(aBoxParam,{1,"Pedido de Venda"	,CriaVar("C5_NUM"	,.F.) ,PesqPict("SC5","C5_NUM")		,"","KHF3PV","",TamSX3("C5_NUM")[1]		,.T.})
	Aadd(aBoxParam,{1,"Filial" 			,CriaVar("C5_FILIAL",.F.) ,PesqPict("SC5","C5_FILIAL")	,"",""		,"",TamSX3("C5_FILIAL")[1]	,.T.})	//#RVC20180510.n
	
	
	IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
		Return(.F.)
	EndIf
	
	DbSelectArea("SUA")
	DbSetOrder(8)
//	DbSeek(xFilial("SUA") + Mv_Par01 )	//#RVC20180510.o
	DbSeek(MV_PAR02 + MV_PAR01 )		//#RVC20180510.n
		
	If !Empty(SUA->UA_NUMSC5)   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ MODIFICADO A IMPRESSAO DO PEDIDO - PEDIDO GRAFICO - LUIZ EDUARDO F.C. - 17.10.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//U_SYTMR003(SUA->UA_NUMSC5)
		U_KMPEDIDO(SUA->UA_NUMSC5)
	Endif
	
Elseif nAviso==1	//Follow-up
	
	U_A273VLD6(SUA->UA_NUM)
	
Elseif nAviso==2	//Retira

	Aadd(aBoxParam,{1,"Chamado" ,CriaVar("UA_NUM",.F.) ,PesqPict("SUA","UA_NUM"),"","KHF3TR","",TamSX3("UA_NUM")[1],.T.})
	
	IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
		Return(.F.)
	EndIf
	
	U_KMOMSR04(MV_PAR01)
		
Elseif nAviso==3	//Recibo RA
	
	U_KMFINR07()
	
Elseif nAviso==6	//Elseif nAviso==5	//#RVC20180504.n
	
	Return
				
Endif

Return

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : TK271ROTM
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 02/06/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

User Function A273VLDA()

Local aArea 	:= GetArea()
Local aProdutos := {}
Local _cFilial := Subs(cNumEmp,3,4)//#CMG20180312.n
                      
cFilAnt := _cFilial//#CMG20180312.n

IF SUA->UA_OPER<>"1"
	Aviso("Atenção","Liberação não permitida. Este pedido é um orçamento.",{"Ok"})
	RestArea(aArea)
	Return
Endif

IF SUA->UA_PEDPEND<> "5" .And. Empty(SUA->UA_DOC)
	Aviso("Atenção","Liberação não permitida. Somente pedido 'Em Aguardar Conferido.' ",{"Ok"})
	RestArea(aArea)
	Return
Endif

IF !Empty(SUA->UA_DOC)
	Aviso("Atenção","A nota fiscal referente a este pedido já foi emitida!",{"Ok"})
	RestArea(aArea)
	Return
Endif

SA1->(DbSetOrder(1))
If SA1->(Dbseek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA ))	
	If SA1->A1_01PEDFI=="1"
		MsgStop("Cliente possui pendencias financeiras. Contate o financeiro.","Atenção")
		lRet := .F.
	Endif	
Endif

If !MsgYesNo("Confirma a liberação deste pedido ?","Atenção")
	RestArea(aArea)
	Return
Endif
           
Begin Transaction 

	FwMsgRun( ,{|| LibPedido(aProdutos) }, , "Por favor, aguarde liberando pedido..." )

End Transaction

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPedido ºAutor  ³Microsiga           º Data ³  12/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de pedidos em aguardar.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibPedido(aProdutos)

Local lLiber 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTransf		:= .F.                                                     	// Compatibilizacao com o SIGAFAT
Local lLiberOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lResidOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lFaturOk 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTLVReg  		:= .F.
Local cFilDep		:= GetMv("MV_SYLOCDP",,"100001")
Local cFilOld		:= cFilAnt

//Gera as ordens de compras para produtos sem estoque
CarregaProd(aProdutos)

RecLock("SUA",.F.)
SUA->UA_PEDPEND := "3"
Msunlock()

IF !Empty(SUA->UA_NUMSC5)
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + SUA->UA_NUMSC5 ))
		RecLock("SC5",.F.)
		SC5->C5_PEDPEND := "3"
		Msunlock()
	Endif
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6") + SUA->UA_NUMSC5 ))
		While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+SUA->UA_NUMSC5
			Reclock("SC6" ,.F.,.T.)
			SC6->C6_PEDPEND	:= "3"
			MaAvalSC6("SC6",1,"SC5",lLiber,lTransf,@lLiberOk,@lResidOk,@lFaturOk,,,,,,lTLVReg)
			Msunlock()
			SC6->(DbSkip())
		End
	Endif
	
Endif

lLiber 		:= .F.
lTransf		:= .F.
lLiberOk 	:= .T.
lResidOk 	:= .T.
lFaturOk 	:= .F.
lTLVReg  	:= .F.

IF !Empty(SUA->UA_PEDLIN2)
	
	cFilAnt := cFilDep
	
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(cFilDep + SUA->UA_PEDLIN2 ))
		RecLock("SC5",.F.)
		SC5->C5_PEDPEND := "3"
		Msunlock()
	Endif
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(cFilDep + SUA->UA_PEDLIN2 ))
		While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==cFilDep+SUA->UA_PEDLIN2
			Reclock("SC6" ,.F.,.T.)
			SC6->C6_PEDPEND	:= "3"
			MaAvalSC6("SC6",1,"SC5",lLiber,lTransf,@lLiberOk,@lResidOk,@lFaturOk,,,,,,lTLVReg)
			Msunlock()
			SC6->(DbSkip())
		End
	Endif
	
	cFilAnt := cFilOld
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A273VLDB  ºAutor  ³Microsiga           º Data ³  29/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro na consulta padrao das filiais                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A273VLDB()

Local nPosLin := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_XFORFAT"})
Local nLinha  := n
Local cReturn := ""
Local cLocDep := GetMv("MV_SYLOCDP",,"100001")

IF aCols[nLinha,nPosLin]=="2"
	cReturn := Alltrim(SM0->M0_CODFIL)==cLocDep
Else
	cReturn := Alltrim(SM0->M0_CODFIL)==cFilAnt
Endif

RETURN(cReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A273VLDC  ºAutor  ³Microsiga           º Data ³  29/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro na consulta padrao das filiais                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A273VLDC(cAtendimento)
 
Local aArea		 := GetArea()
Local aBoxParam  := {}
Local aRetParam  := {}
Local cLocDep 	 := GetMv("MV_SYLOCDP",,"100001")

Aadd(aBoxParam,{1,"Resp.Tecnico" ,CriaVar("A3_COD",.F.) ,PesqPict("SA3","A3_COD"),"","SA3RT","",50,.T.})

IF !ParamBox(aBoxParam,"Informe os Parametros",@aRetParam)
	Return(.F.)
EndIf

SUA->(DbSetOrder(1))
If SUA->(DbSeek(xFilial("SUA") + cAtendimento ))
	
	RecLock("SUA",.F.)
	Replace UA_VEND1 with Mv_Par01	
	Msunlock()
	
	If !Empty(SUA->UA_NUMSC5)
		
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SUA") + SUA->UA_NUMSC5 ))
		
		RecLock("SC5",.F.)		
		Replace C5_VEND2	with SUA->UA_VEND1
		Replace C5_COMIS2	with Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
		Msunlock()
	
	Endif
	
	If !Empty(SUA->UA_PEDLIN2)
	
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(cLocDep + SUA->UA_PEDLIN2 ))
		
		RecLock("SC5",.F.)		
		Replace C5_VEND2	with SUA->UA_VEND1
		Replace C5_COMIS2	with Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
		Msunlock()
	
	Endif
	
Endif

RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarregaProdºAutor ³Eduardo Patriani    º Data ³  12/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carregas os produtos para geracao da OC.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarregaProd(aProdutos)

Local aArea  	:= GetArea()
Local cAlias 	:= GetNextAlias()
Local xFilAtu	:= ''
Local cQuery 	:= ''
Local cLocDep	:= GetMv("MV_SYLOCDP",,"100001")
Local nSaldoSB2 := 0	

cQuery += " SELECT UB_NUM,UB_ITEM,UB_PRODUTO,UB_QUANT,UB_VRUNIT,UB_PRCTAB,UB_LOCAL,UB_DTENTRE,UA_CLIENTE,UA_LOJA,B1_PROC,B1_LOJPROC,UB_01PEDCO,UB_CONDENT,UB_XFILPED,SUB.R_E_C_N_O_ RECSUB " 
cQuery += " FROM "+RetSqlName("SUB")+" SUB "
cQuery += " INNER JOIN "+RetSqlName("SUA")+" SUA ON UA_FILIAL = '"+SUA->UA_FILIAL+"' AND UA_NUM=UB_NUM     AND SUA.D_E_L_E_T_= ' ' "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=UB_PRODUTO AND SB1.D_E_L_E_T_= ' ' "
cQuery += " WHERE "
cQuery += " UB_FILIAL=UA_FILIAL "
cQuery += " AND UA_NUM = '"+SUA->UA_NUM+"' "
cQuery += " AND UA_PEDPEND  = '5' "
cQuery += " AND UA_DOC  = ' ' "
cQuery += " AND UA_CANC = ' ' "
cQuery += " AND UB_01PEDCO = ' ' "
cQuery += " AND UB_01CANC  = ' ' "
cQuery += " AND B1_01CAT1 <> '08' " //Imper
cQuery += " AND SUB.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY B1_PROC,B1_LOJPROC,UA_CLIENTE,UA_LOJA,B1_COD "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
		
	SA2->(DbSetOrder(1))	
	SA2->(DbSeek(xFilial("SA2") + (cAlias)->B1_PROC + (cAlias)->B1_LOJPROC ))
	If SA2->A2_XFORFAT=="1"
		cFilAtu := xFilial("SB2")
	Else                       
		cFilAtu := cLocDep
	Endif
	
	SB2->(DbSetOrder(1))	
	SB2->(DbSeek(cFilAtu + PADR((cAlias)->UB_PRODUTO,TAMSX3("B2_COD")[1]) + (cAlias)->UB_LOCAL ))	
	nSaldoSB2 := 0	
	nSaldoSB2 := ((SB2->B2_QATU) - (SB2->B2_QEMP + SB2->B2_RESERVA + SB2->B2_QPEDVEN))
	
	If nSaldoSB2 > 0
		(cAlias)->(DbSkip())	
		Loop
	Endif
				
	nPos := Ascan( aProdutos ,{|x| x[1]+x[2] == (cAlias)->B1_PROC+(cAlias)->B1_LOJPROC })
	If nPos == 0
		AAdd( aProdutos , { (cAlias)->B1_PROC , (cAlias)->B1_LOJPROC , (cAlias)->UB_XFILPED , {  (cAlias)->UB_PRODUTO , (cAlias)->UB_QUANT , (cAlias)->UB_VRUNIT , (cAlias)->UB_PRCTAB , (cAlias)->UB_LOCAL , (cAlias)->UB_DTENTRE , (cAlias)->UB_NUM , (cAlias)->UB_ITEM , (cAlias)->UB_XFILPED , (cAlias)->RECSUB } } )
		nPos := Len(aProdutos)
	Else
		AAdd( aProdutos[nPos] , { (cAlias)->UB_PRODUTO , (cAlias)->UB_QUANT , (cAlias)->UB_VRUNIT , (cAlias)->UB_PRCTAB , (cAlias)->UB_LOCAL , (cAlias)->UB_DTENTRE , (cAlias)->UB_NUM , (cAlias)->UB_ITEM , (cAlias)->UB_XFILPED , (cAlias)->RECSUB  } )
	EndIf		
	
	(cAlias)->(DbSkip())
End
(cAlias)->( dbCloseArea() )

If Len(aProdutos) > 0
	GeraSC7(SUA->UA_FILIAL,aProdutos)
Else
	Aviso("Atencao","Não existem ordens de compra para serem geradas.",{"Ok"})
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraSC7   ºAutor  ³Eduardo Patriani    º Data ³ 12/01/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera pedido de compra.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraSC7(cFilAtu,aProdutos)

Local cItem		:= ""
Local cCondPg	:= ''
Local cTes		:= ''
Local nX     	:= 0
Local nY		:= 0
Local nA		:= 0
Local aCabec	:= {}
Local aItem		:= {}
Local aItens 	:= {} 
Local aAtuPV	:= {}
Local lRet		:= .F.
Local nItem		:= 1
Local nTotal	:= 0
Local nPercFre	:= 0
Local nPrazo	:= 0

Local cFilOld	:= cFilAnt
Local nModOld	:= nModulo

nModulo := 02

For nY := 1 To Len(aProdutos)
			
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + aProdutos[nY,1] + aProdutos[nY,2]  ))
	If SA2->A2_01PRAZO > 0
		nPrazo := SA2->A2_01PRAZO
	Else
		nPrazo := GetMv("SY_PRZFORN",,30)
	Endif
	
	cFilAnt	:= aProdutos[nY,3]
	
	DbSelectArea("SC7")
	DbSetOrder(1)
	cNumSC7 := ''
	
	lMsErroAuto := .F.
	aCabec		:= {}
	aItem		:= {}	
	nItem		:= 1
	nTotal		:= 0
	nPercFre	:= 0
				
	aCabec	:=	{ 	{"C7_FILIAL"   ,xFilial("SC7")		,Nil,Posicione("SX3", 2, "C7_FILIAL"	, "X3_ORDEM")},; // Filial
					{"C7_NUM"      ,cNumSC7    			,Nil,Posicione("SX3", 2, "C7_NUM"		, "X3_ORDEM")},; // Numero do Pedido
					{"C7_EMISSAO"  ,dDataBase  			,Nil,Posicione("SX3", 2, "C7_EMISSAO" 	, "X3_ORDEM")},; // Data de Emissao
					{"C7_FORNECE"  ,aProdutos[nY,1]		,Nil,Posicione("SX3", 2, "C7_FORNECE"	, "X3_ORDEM")},; // Fornecedor
					{"C7_LOJA"     ,aProdutos[nY,2]		,Nil,Posicione("SX3", 2, "C7_LOJA"		, "X3_ORDEM")},; // Loja do Fornecedor
					{"C7_COND"     ,SA2->A2_COND		,Nil,Posicione("SX3", 2, "C7_COND"		, "X3_ORDEM")},; // Condicao de pagamento
					{"C7_CONTATO"  ,SA2->A2_CONTATO		,Nil,Posicione("SX3", 2, "C7_CONTATO"	, "X3_ORDEM")},; // Contato
					{"C7_FILENT"   ,aProdutos[nY,3]		,Nil,Posicione("SX3", 2, "C7_FILENT"	, "X3_ORDEM")}}  // Filial Entrega

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordena o vetor de Cabeçalho   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCabec := aSort(aCabec ,,,{|x,y| x[4] < y[4]})
	
	For nX := 4 To Len(aProdutos[nY])
		
		aItens := {}
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1") + aProdutos[nY,nX,1] ))
		
		nTotal += Round(aProdutos[nY,nX,2]*SB1->B1_CUSTD , MsDecimais(1))
		
		SB4->(DbSetOrder(1))
		If SB4->(DbSeek(xFilial("SB4") + SB1->B1_01PRODP )) .And. nPercFre == 0
			nPercFre := SB4->B4_01VLFRE			
		Endif
				
		aAdd(aItens, { "C7_ITEM"	, StrZero(nItem,TamSX3("C7_ITEM")[1])							, Nil, Posicione("SX3", 2, "C7_ITEM" 	, "X3_ORDEM")})	// 1. Item do Pedido de Compras
		aAdd(aItens, { "C7_PRODUTO"	, aProdutos[nY,nX,1]											, Nil, Posicione("SX3", 2, "C7_PRODUTO"	, "X3_ORDEM")})	// 2. Produto
		aAdd(aItens, { "C7_QUANT"	, aProdutos[nY,nX,2]									  		, Nil, Posicione("SX3", 2, "C7_QUANT"	, "X3_ORDEM")})	// 3. Quantidade do Item
		aAdd(aItens, { "C7_PRECO"	, SB1->B1_CUSTD													, Nil, Posicione("SX3", 2, "C7_PRECO"	, "X3_ORDEM")})	// 4. Valor Unitario
		aAdd(aItens, { "C7_TOTAL"	, Round(aProdutos[nY,nX,2]*SB1->B1_CUSTD , MsDecimais(1))		, Nil, Posicione("SX3", 2, "C7_TOTAL"	, "X3_ORDEM")})	// 5. Total do Item
		aAdd(aItens, { "C7_DATPRF"	, dDatabase+nPrazo 												, 'AlwaysTrue()', Posicione("SX3", 2, "C7_DATPRF"	, "X3_ORDEM")}) // 6. Data de Entrega
		aAdd(aItens, { "C7_TES"		, SB1->B1_TE													, Nil, Posicione("SX3", 2, "C7_TES"		, "X3_ORDEM")})	// 7. Tes de Entrada
		aAdd(aItens, { "C7_FLUXO"	, "S"															, Nil, Posicione("SX3", 2, "C7_FLUXO"	, "X3_ORDEM")}) // 8. Fluxo de Caixa
		aAdd(aItens, { "C7_TIPO"	, 1																, Nil, Posicione("SX3", 2, "C7_TIPO"	, "X3_ORDEM")})
		aAdd(aItens, { "C7_UM"		, SB1->B1_UM													, Nil, Posicione("SX3", 2, "C7_UM"		, "X3_ORDEM")})
		aAdd(aItens, { "C7_LOCAL"	, aProdutos[nY,nX,5]											, Nil, Posicione("SX3", 2, "C7_LOCAL"	, "X3_ORDEM")})
		aAdd(aItens, { "C7_OBS"		, "At.: "+cFilAtu+"/"+aProdutos[nY,nX,7]+''+aProdutos[nY,nX,8] 	, 'AlwaysTrue()', Posicione("SX3", 2, "C7_OBS"		, "X3_ORDEM")})
		aAdd(aItens, { "C7_01TPMAT"	, "3"															, 'AlwaysTrue()', Posicione("SX3", 2, "C7_01TPMAT"	, "X3_ORDEM")})
		aAdd(aItens, { "C7_NUMSUA"	, cFilAtu+aProdutos[nY,nX,7]+aProdutos[nY,nX,8]					, 'AlwaysTrue()', Posicione("SX3", 2, "C7_NUMSUA"	, "X3_ORDEM")})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ordena os campos de acordo com a ordem do SX3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aItens := aSort(aItens,,,{|x,y| x[4] < y[4]})
		
		aAdd(aItem,aItens)
		
		AAdd(aAtuPV,{ cFilAtu , aProdutos[nY,nX,7] , aProdutos[nY,nX,8] })
				
		nItem++
		
	Next nX
	       
	MSExecAuto({|x,y,w,z| Mata120(x,y,w,z)}, 1, aCabec, aItem, 3)	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Arquivo de semaforo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RollBackSX8()
		cFilant	:= cFilOld
	Else
		ConfirmSX8()
		lRet 	:= .T.
		cFilant	:= cFilOld				
	EndIf
		
Next

cFilant	:= cFilOld
nModulo := nModOld

If lRet
	For nA:=1 To Len(aAtuPV)
		SUB->(DbSetOrder(1))
		If SUB->(DbSeek(xFilial("SUB") + aAtuPV[nA,2] + aAtuPV[nA,3] ))
			SUB->(RecLock("SUB",.F.))
			SUB->UB_01PEDCOM := RetNumOC(aAtuPV,nA)
			SUB->(Msunlock())
		Endif
	Next
Endif

Return

Static Function RetNumOC(aAtuPV,nA)

Local cRetorno	:= ""
Local cQuery	:= ""
Local cAlias 	:= GetNextAlias()

cQuery := "SELECT C7_NUM,C7_ITEM FROM "+RetSqlName("SC7")+" SC7 WHERE C7_NUMSUA = '"+aAtuPV[nA,1]+aAtuPV[nA,2]+aAtuPV[nA,3]+"' AND SC7.D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
If (cAlias)->(!Eof())
	cRetorno := (cAlias)->C7_NUM+(cAlias)->C7_ITEM
EndIf
(cAlias)->( dbCloseArea() )

Return(cRetorno)