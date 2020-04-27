#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWIZARD.CH"
#DEFINE MAXJOBNOAR 20


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ  KMESTF01  ณ Autor ณ Caio Garcia         ณ Data ณ 26/04/16 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa irแ gerar pedidos de venda, faturar, transmitir   ณฑฑ
ฑฑณe realizar a entrada no estoque da matriz.                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Cliente                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ OBPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function KMESTF01(_cEmp,_cFilial) //U_KMESTF01()

Local lCredito	:= .T.
Local lEstoque	:= .T.
Local lAvCred	:= .F.
Local lAvEst	:= .F.
Local lLiber	:= .F.
Local lTransf   := .F.

Local _aArea		 := GetArea()

Local _cNomefil :=''

Private cIdEnt  := ""

Private _lRet    := .F.
Private _nF2Rec  := 0
Private _cCNPJ      := ""
//Private _cEmp    := '01'
//Private _cFilial := '0101'
Private _aCabPv   := {}
Private _aItemC6 := {}
Private _aItemPv  := {}
Private _cArmz    := ""
Private _nPrUnit   := 0
Private _nValor    := 0
Private _cFilBkp   := "0101"

Private _aRecSUB  := {}
Private _lMail    := .T.
Private _cNumSC5  := ""
Private _cItemPV  := ""
Private _nx       := 0
Private _cNota    := ""

Private _cTes     := "602"     //TES
Private _cCond    := "001"     //Condi็ใo de pagamento
Private _cSerie := "1  "     //Serie da Nota Fiscal

Private _nValor   := 0
Private nQtde    := 0  //quantidade atual
Private aPvlNfs  :={}
Private _cNota    := ""
Private lCredOK  := .f.

Private _cAmb       := ""
Private lMsErroAuto := .F.

Private _lAmbOfic	:= .F.
      
ConOut("-----------------------------------------")
ConOut("Inicio da rotina KMESTF01: " +Time())
ConOut("Empresa "+_cEmp+" Filial "+_cFilial)
ConOut("-----------------------------------------")
 
PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial MODULO 'FAT' TABLES "SA1","SC6","SC5","SC9","SE4","SF1","SF2","SD1","SD2","SB1","SB5","SF3","SF4"

_lAmbOfic	:= IIF(Alltrim(Upper(GetEnvServer())) $ Alltrim(Upper(GetMv("KH_AMBOFIC"))),.T.,.F.)

If _lAmbOfic
	ConOut("-----AMBIENTE OFICIAL------")    
	_cAmb := '1'
Else	                      
	ConOut("-----AMBIENTE NAO OFICIAL-----")
	_cAmb := '2'
EndIf

_cQuery := "SELECT UB_FILIAL FILIAL, UB_FILIAL+UB_NUM+UB_ITEM ORCITEM, UB_PRODUTO PRODUTO, UB_QUANT QUANT, SUB.R_E_C_N_O_ RECSUB "
_cQuery += " FROM " + RETSQLNAME("SUB") + " SUB (NOLOCK) "
_cQuery += " INNER JOIN " + RETSQLNAME("SUA") + " SUA (NOLOCK) ON UA_FILIAL = UB_FILIAL AND UA_NUM = UB_NUM AND SUA.D_E_L_E_T_ <> '*' " 
_cQuery += " INNER JOIN SB1010 SB1 (NOLOCK) ON SUB.UB_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <>'*' " //devido o produto agregado nใo estar setado com 4 na SUB
_cQuery += " WHERE SUB.D_E_L_E_T_ <> '*' "
_cQuery += " AND (UB_MOSTRUA IN ('4') OR SB1.B1_XACESSO ='1') "//Caso a UB nใo esteja marcado como agregado valido a SB1, para evitar nใo gerar a transfer๊ncia
_cQuery += " AND UA_NUMSC5 <> '' "
_cQuery += " AND UA_STATUS <> 'CAN' "
_cQuery += " AND UA_CANC <> 'S' "
//_cQuery += " AND UA_EMISSAO >= '20180918' " - data alterada devido o ajuste da query, alguns pedidos nใo estavam alimentando o campo UB_MOSTRUA corretamente, por este motivo estou validando o campo B1_XACESSO
_cQuery += " AND UA_EMISSAO >= '20190501' "
_cQuery += " AND UA_FILIAL = '"+_cFilial+"' "
_cQuery += " AND UB_FILIAL+UB_NUM+UB_ITEM NOT IN (SELECT C6_XCHVTRA FROM " + RETSQLNAME("SC6") + " SC6 WHERE SC6.D_E_L_E_T_ <> '*' AND C6_XCHVTRA <> '' AND C6_BLQ <> 'R') " //C6_BLQ - valida็ใo para desconsiderar pedidos com elimina็ใo de resํduo.
_cQuery += " ORDER BY UB_FILIAL "
_cQuery := ChangeQuery(_cQuery)

_cAlias   := GetNextAlias()

DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQuery ), _cAlias, .T., .F. )

MemoWrite('\Querys\KMESTF01.sql',_cQuery)

Dbselectarea("SC5")
SC5->(DbSetorder(1))

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

While (_cAlias)->(!Eof())
	
	//cFilAnt := (_cAlias)->FILIAL
	
	DBSelectarea("SM0")
	SM0-> (DbSetorder(1))
	SM0-> (DbSeek(_cEmp + cFilant))
                                                          
	_cCNPJ := SM0->M0_CGC
	         
	//cIdEnt := fIdEnt()
	                     
	ConOut("-----------------------------------------")
	ConOut("FILIAL CORRENTE: "+CFILANT)                  
	ConOut("CNPJ: "+_cCNPJ)                  
	ConOut("ID TSS: "+cIdEnt)
	ConOut("-----------------------------------------")   
	
	lMsErroAuto := .F.
	_aCabPv  := {}
	_aItemC6 := {}
	_aItemPv := {}
	_cItemPv := "01"
	
	_cArmz := SuperGetMV("SY_LOCPAD",.F.,"01")
	
	_cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
	_cMay := "SC5"+ALLTRIM(cFilAnt)+_cNumSC5
	While SC5->(DbSeek(cFilAnt+_cNumSC5) .Or. !MayIUseCode(_cMay))
		_cNumSC5 := Soma1(_cNumSC5,Len(_cNumSC5))
		_cMay 	:= "SC5"+ALLTRIM(cFilAnt)+_cNumSC5
	EndDo
	If __lSX8
		ConfirmSX8()
	EndIf
	
	DBSelectarea("SM0")
	SM0-> (DbSetorder(1))
	SM0-> (DbSeek(cEmpant + cFilant))
	_cNomefil:= Alltrim(SM0->M0_FILIAL) +' - ' + cFilant
	
	_aCabPv:= {	{"C5_NUM" 		,_cNumSC5 	        		,Nil},; 	// Numero do pedido
	{"C5_TIPO" 		,"N"       					,Nil},; 	// Tipo de pedido
	{"C5_CLIENTE"	, '000001' 				,Nil},; 	// Codigo do cliente
	{"C5_LOJACLI"	, '01'    			,Nil},; 	// Loja do cliente
	{"C5_CONDPAG"	, "001" 	        		,Nil},; 	// Codigo da condicao de pagamanto - SE4
	{"C5_EMISSAO"	, dDataBase					,Nil},; 	// Data de emissao
	{"C5_TIPOCLI"	, SA1->A1_TIPO				,Nil},; 	// Tipo do Cliente
	{"C5_MSFIL"		, cFilAnt  		            ,Nil},; 	// Tipo do Cliente
	{"C5_MENNOTA"	, _cNomefil		            ,Nil},; 	// Mensagem para Nota
	{"C5_01PEDMO"	, "2"						,Nil},; 	// Tipo do Cliente
	{"C5_01TPOP"	, "2"						,Nil},; 	// Tipo de Operacao 2 = Transferencia
	{"C5_MOEDA"  	, 1        					,Nil}}	 	// Moeda
	
	While (_cAlias)->(!Eof()) .And. (_cAlias)->FILIAL == cFilAnt
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		
		SB1->(DbSeek(xFilial("SB1")+(_cAlias)->PRODUTO ))
		
		_nPrUnit := IIF(Empty(SB1->B1_PRV1),1,SB1->B1_PRV1)
		_nValor	 := (_nPrUnit * (_cAlias)->QUANT)
		
		_aItemC6	:= {	{"C6_NUM"  		, _cNumSC5				,Nil},;	 	// Numero do Pedido
		{"C6_ITEM"   	, _cItemPv	    		,Nil},; 	// Numero do Item no Pedido
		{"C6_CLI"    	, SA1->A1_COD			,Nil},; 	// Cliente
		{"C6_LOJA"   	, SA1->A1_LOJA			,Nil},; 	// Loja do Cliente
		{"C6_ENTREG" 	, dDataBase    			,Nil},; 	// Data da Entrega
		{"C6_PRODUTO"	, (_cAlias)->PRODUTO    ,Nil},; 	// Codigo do Produto
		{"C6_QTDVEN" 	, (_cAlias)->QUANT      ,Nil},; 	// Quantidade Vendida
		{"C6_PRUNIT" 	, _nPrUnit				,Nil},; 	// Preco Unitario Liquido	//{"C6_PRUNIT" 	, aPrdMost[nZ,nVRUNIT]	,Nil}
		{"C6_PRCVEN" 	, _nPrUnit             	,Nil},; 	// Preco Unitario Liquido	//{"C6_PRCVEN" 	, aPrdMost[nZ,nVRUNIT]	,Nil}
		{"C6_VALOR"  	, _nValor              	,Nil},; 	// Valor Total do Item		//{"C6_VALOR"  	, aPrdMost[nZ,nVLRITEM]	,Nil}
		{"C6_UM"     	, SB1->B1_UM	    	,Nil},; 	// Unidade de Medida Primar.
		{"C6_MSFIL"		, cFilAnt	            ,Nil},; 	// Tipo do Cliente
		{"C6_TES"		, _cTes				    ,Nil},; 	// TES
		{"C6_XCHVTRA"	, (_cAlias)->ORCITEM    ,Nil},; 	// TES
		{"C6_QTDLIB"	, (_cAlias)->QUANT      ,"AlwaysTrue()"},; 	// TES
		{"C6_LOCAL"  	, _cArmz				,Nil}}		//{"C6_LOCAL"  	, aPrdMost[nZ,nLOCAL]	,Nil}} //#RVC20180619.n
		
		 //Verifica se o armazem existe na SB2 e caso nใo exista chama a fun็ใo CriaSB2 para criar o armazem na SB2
		 //Wellington Raul - 03/06/2019
		 dbSelectArea("SB2")
         If dbSeek(xFilial("SB2")+(_cAlias)->PRODUTO+_cArmz)
         	dbSkip()
         Else 
	         CriaSB2((_cAlias)->PRODUTO,_cArmz)
	         dbSkip()
         EndIf
         SB2->(DbCloseArea())
		
		Aadd(_aItemPv,aClone(_aItemC6))
		
		_cItemPv := Soma1(_cItemPv)
		(_cAlias)->(DbSkip())
		
	EndDo
	
	MsUnlockAll()
	MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
	
	If lMsErroAuto
		
		cPath := "\Transf_Mostruario\Erro"
		cNomeArq := cFilAnt + "_" + ALLTRIM(_cNumSC5) + ".TXT"
		
		//Salva o erro no arquivo e local indicado
		MostraErro(cPath, cNomeArq)
		
		MostraErro()
		
		Return
		
	Else
		ConOut("Pedido: " + _cNumSC5 + " - Filial : " + cFilAnt)
		
		DbSelectArea("SUB")
		SUB->(DbSetOrder(1))
		SUB->(DbGoTop())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Executa a liberacao do pedido sem avaliacao de credito e estoque. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+_cNumSC5))
		
		While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+_cNumSC5
			MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
			SC6->(DbSkip())
		EndDo
		
		_cNota := GerFat(_cNumSC5)
				
		//transmite
		
		//cFilAnt := _cFilBkp
		
		//Da entrada
		
	EndIf
	
EndDo

RestArea(_aArea)
SA1->(DbCloseArea())
SC5->(DbCloseArea())
SC6->(DbCloseArea())
SUB->(DbCloseArea())
(_cAlias)->(DbCloseArea())

RESET ENVIRONMENT

ConOut("Fim da rotina KMESTF01 : "+Time())

Return {_lRet,_nF2Rec,cIdEnt,_cFilial}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณGerFat    บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GerFat(_cNumSC5)

lMSErroAuto := .F.

ConOut("-----------------------------------------")
ConOut("Inicio da rotina GerFat: " +Time())
ConOut("Gerando Nota Fiscal de Saida ...")
ConOut("-----------------------------------------")

DbSelectArea("SF4")
SF4->(DbSetOrder(1))
SF4->(DbGoTop())

If SF4->(DbSeek(xFilial("SF4")+_cTes))
	
	If SF4->F4_DUPLIC # "S"
		lCredOK:= .T.
	Endif
	
	If ! lCredOK
		If !Credito(_cNumSC5)
			Return Nil
		Endif
	Endif
	
EndIf

IF Empty(_cSerie)
	_cSerie:=Space(3)
Endif

Libera(_cNumSC5) // liberando pedido e empenhando

Pergunte("MT460A",.F.)
//_cNota   := MaPvlNfs(aPvlNfs,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
_cNota   := MaPvlNfs(aPvlNfs,_cSerie,.F., .F., .F., .F., .F., 0, 0, .F., .F.)

If Empty(_cNota)
	ConOut("Houve Problema na Gera็ใo da Nota Fiscal de Venda!")
	Return(_cNota)
Else
	ConOut("NF de saํda "+_cNota+" "+_cSerie)
	
	//ConOut("Transmintindo NF "+_cNota+" "+_cSerie)
	
	//transmitindo NFe
	//fAutoNfe(cEmpAnt,cFilAnt,"0",_cAmb,_cSerie,_cNota,_cNota)
	//AutoNfeEnv(cEmpAnt,cFilAnt,"0",_cAmb,_cSerie,_cNota,_cNota)
	
	//ConOut("Esperando 1 minuto...")   
	//Sleep(60000)
	
	//Gerando NFe de Entrada
	//FGerNFE(cIdent)
	
EndIf

//Verifica se a Nota Fiscal de Saida foi gerada
_nTamNFF2 := TamSX3("F2_DOC")[1]
_nTamSRF2 := TamSX3("F2_SERIE")[1]

DbSelectArea("SF2")
SF2->(DbSetOrder(1))

If SF2->(!DbSeek( xFilial("SF2") +Alltrim(_cNota)+Space(_nTamNFF2- Len(Alltrim(_cNota)))+Alltrim(_cSerie)+Space(_nTamSRF2- Len(Alltrim(_cSerie))) ))
	ConOut("Houve Problema na Gera็ใo da Nota Fiscal de Venda!")
	Return Nil                                                                                                                                      
Else
	_nF2Rec := SF2->(Recno())	
	_lRet := .T.
EndIf

SF4->(DbCloseArea())
SF2->(DbCloseArea())

Return(_cNota)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCredito   บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Credito(_cNumSC5)

Local _cBlqCred := " "
Local _lCredito := .f.
Local _nValor   := 0

_nValor:= ValorPed(_cNumSC5)

DbSelectArea("SC5")
SC5->(dbSetOrder(1))

If SC5->(DbSeek(xFilial("SC5")+_cNumSC5))
	
	_lCredito := MaAvalCred(SC5->C5_CLIENTE,SC5->C5_LOJACLI,_nValor,SC5->C5_MOEDA,.T.,@_cBlqCred)
	
EndIf

If ! _lCredito
	
	If _cBlqCred == "04"
		ConOut("Cliente "+SC5->C5_CLIENTE+SC5->C5_LOJACLI+" com o limite de credito vencido.")
	Else
		ConOut("Cliente "+SC5->C5_CLIENTE+SC5->C5_LOJACLI+"com o limite de credito excedido.")
	Endif
	
Endif

SC5->(DbCloseArea())

Return(_lCredito)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณLibera    บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Libera(_cNumSC5)

Local _aProduto := {}
Local _nx       := 0

aPvlNfs  :={}

DbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+_cNumSC5))

_aProduto := aClone(ProdPed(_cNumSC5))

For _nx:=1 to Len(_aProduto)
	
	Prepara(_cNumSC5,_aProduto[_nx,1],_aProduto[_nx,2],_aProduto[_nx,3],_aProduto[_nx,4],_aProduto[_nx,5])
	//	aadd(aPvlNfs,Prepara(_cNumSC5,_aProduto[_nx,1],_aProduto[_nx,2],_aProduto[_nx,3],_aProduto[_nx,4],_aProduto[_nx,5]))
	
Next

SC5->(DbCloseArea())

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณPrepara   บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Prepara(_cNumSC5,_cProd,_cLocal,_cOrigem,_nItem,_cTES)

Local _aProdPv := {}

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+_cNumSC5) ) //FILIAL+NUMERO

DbSelectArea("SC6")
SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial("SC6")+_cProd+_cNumSC5+_nItem))

DbSelectArea("SC9")
SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+_cNumSC5+SC6->C6_ITEM) ) //FILIAL+NUMERO+ITEM

While ! SC9->(Eof()) .And.  SC9->C9_FILIAL==xFilial("SC9") .and.;
	SC9->C9_PEDIDO==_cNumSC5 .and. SC9->C9_ITEM == SC6->C6_ITEM
	
	If Empty(SC9->C9_NFISCAL)
		Exit
	EndIf
	
	SC9->(DbSkip())
	
EndDo

DbSelectArea("SE4")
SE4->(DbSetOrder(1))
SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+_cProd )) //FILIAL+PRODUTO

DbSelectArea("SB2")
SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2")+_cProd+_cLocal) ) //FILIAL+PRODUTO+LOCAL

DbSelectArea("SF4")
SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) ) //FILIAL+CODIGO

AADD(aPvlNfs,{SC9->C9_PEDIDO,;
SC9->C9_ITEM,;
SC9->C9_SEQUEN,;
SC9->C9_QTDLIB,;
SC9->C9_PRCVEN,;
SC9->C9_PRODUTO,;
(SF4->F4_ISS=="S"),;
SC9->(RecNo()),;
SC5->(RecNo()),;
SC6->(RecNo()),;
SE4->(RecNo()),;
SB1->(RecNo()),;
SB2->(RecNo()),;
SF4->(RecNo())})


SC5->(DbCloseArea())
SC6->(DbCloseArea())
SC9->(DbCloseArea())
SE4->(DbCloseArea())
SB1->(DbCloseArea())
SB2->(DbCloseArea())
SF4->(DbCloseArea())

Return _aProdPv

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณProdPed   บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static function ProdPed(_cNumSC5)

Local _aProduto :={}
Local _cOrigem  := ""

DbSelectArea("SC6")
SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC6->(DbGoTop())

If SC6->(DbSeek(xFilial("SC6")+_cNumSC5))
	
	//Monta html dos itens do pedido
	While SC6->(!Eof()).And. SC6->C6_NUM == _cNumSC5
		
		SB1->(DbSeek(xFilial("SB1") + SC6->C6_PRODUTO))
		
		_cOrigem := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,SB1->B1_ORIGEM)
		
		AADD(_aProduto,{SC6->C6_PRODUTO,SC6->C6_LOCAL,_cOrigem,SC6->C6_ITEM,SC6->C6_TES})
		
		SC6->(DbSkip())
		
	EndDo
	
EndIf

SC6->(DbCloseArea())

Return _aProduto

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณValorPed  บ Autor ณ Caio Garcia        บ Data ณ  26/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Fun็ใo monta html para envio do e-mail.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValorPed(_cNumSC5)

Local _nValor := 0

DbSelectArea("SC6")
SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC6->(DbGoTop())

If SC6->(DbSeek(xFilial("SC6")+_cNumSC5+"01"))
	
	//Monta html dos itens do pedido
	While SC6->(!Eof()).And. SC6->C6_NUM == _cNumSC5
		
		_nValor += SC6->C6_VALOR
		
		SC6->(DbSkip())
		
	EndDo
	
EndIf

SC6->(DbCloseArea())

Return(_nValor)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณGetIdEnt  ณ Autor ณEduardo Riera          ณ Data ณ18.06.2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณObtem o codigo da entidade apos enviar o post para o Totvs  ณฑฑ
ฑฑณ          ณService                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpC1: Codigo da entidade no Totvs Services                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObtem o codigo da entidade                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
EndIf

RestArea(aArea)

Return(cIdEnt)


/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณfIdEnt    ณ Autor ณCaio Garcia            ณ Data ณ23.10.2018ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function fIdEnt()

Local _cId := ""
Local _cDbTSS    := AllTrim(UPPER(GetMv("KH_DBTSS",,"TSS")))
Local _cQuery    := ""
              
_cQuery := " SELECT ID_ENT "
_cQuery += " FROM "+_cDbTSS+".dbo.SPED001 "
_cQuery += " WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND CNPJ = '"+_cCNPJ+"' "
_cQuery += " ORDER BY ID_ENT DESC "

MemoWrite('\Querys\KMESTF01_ID.sql',_cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_TMPID_",.F.,.T.) 

_cId := _TMPID_->ID_ENT
              
If Empty(AllTrim(_cId))

	ConOut("Nใo achou ID_ENT")

EndIf                                               

_TMPID_->(DbCloseArea())
                     
Return(_cId)


Static Function fAutoNfe(cEmpresa,cFilProc,cWait,cOpc,cSerie,cNotaIni,cNotaFim)

Local aArea       := GetArea()
Local aPerg       := {}
Local lEnd        := .F.
Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
Local aXML        := {}
Local cRetorno    := ""
Local cModalidade := ""
Local cAmbiente   := ""
Local cVersao     := ""
Local cVersaoCTe  := ""
Local cVersaoDpec := ""
Local cMonitorSEF := ""
Local cSugestao   := ""
Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local nX          := 0
Local lOk         := .T.
Local oWs
Local cParNfeRem  := SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFEREM"

If cSerie == Nil
	MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfeRem,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
	MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfeRem,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
	MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
Else
	MV_PAR01 := aParam[01] := cSerie
	MV_PAR02 := aParam[02] := cNotaIni
	MV_PAR03 := aParam[03] := cNotaFim
EndIf

If .T.//IsReady()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณObtem o codigo da entidade                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cIdEnt := GetIdEnt()
	
	If !Empty(cIdEnt)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem o ambiente de execucao do Totvs Services SPED                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oWS := WsSpedCfgNFe():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:nAmbiente  := 0
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		lOk			   := execWSRet( oWS, "CFGAMBIENTE")
		If lOk
			cAmbiente := oWS:cCfgAmbienteResult
		Else
			Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem a modalidade de execucao do Totvs Services SPED                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:nModalidade:= 0
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			oWs:cModelo	   := "55"
			lOk 		   := execWSRet( oWS, "CFGModalidade" )
			If lOk
				cModalidade:= oWS:cCfgModalidadeResult
			Else
				Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem a versao de trabalho da NFe do Totvs Services SPED                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk			   := execWSRet( oWs, "CFGVersao" )
			If lOk
				cVersao    := oWS:cCfgVersaoResult
			Else
				Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		EndIf
		If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk 		   := execWSRet( oWs, "CFGVersaoCTe" )
			If lOk
				cVersaoCTe := oWS:cCfgVersaoCTeResult
			Else
				Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		EndIf
		If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk			   := execWSRet( oWs, "CFGVersaoDpec" )
			If lOk
				cVersaoDpec:= oWS:cCfgVersaoDpecResult
			Else
				Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica o status na SEFAZ                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lOk
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
			lOk := oWS:MONITORSEFAZMODELO()
			If lOk
				aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
				For nX := 1 To Len(aXML)
					Do Case
						Case aXML[nX]:cModelo == "55"
							cMonitorSEF += "- NFe"+CRLF
							cMonitorSEF += "Versao do layout: "+cVersao+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestao"+"(NFe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestใo"
							EndIf
							
						Case aXML[nX]:cModelo == "57"
							cMonitorSEF += "- CTe"+CRLF
							cMonitorSEF += "Versao do layout "+cVersaoCTe+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestao"+"(CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestใo"
							EndIf
					EndCase
					cMonitorSEF += Space(6)+"Versใo da mensagem"+": "+aXML[nX]:cVersaoMensagem+CRLF //"Versใo da mensagem"
					cMonitorSEF += Space(6)+"C๓digo do Status"+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //"C๓digo do Status"
					cMonitorSEF += Space(6)+"UF Origem"+": "+aXML[nX]:cUFOrigem //"UF Origem"
					If !Empty(aXML[nX]:cUFResposta)
						cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
					Else
						cMonitorSEF += CRLF
					EndIf
					If aXML[nX]:nTempoMedioSEF <> Nil
						cMonitorSEF += Space(6)+"Tempo de espera"+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //"Tempo de espera"
					EndIf
					If !Empty(aXML[nX]:cMotivo)
						cMonitorSEF += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF //"Motivo"
					EndIf
					If !Empty(aXML[nX]:cObservacao)
						cMonitorSEF += Space(6)+"Observa็ใo"+": "+aXML[nX]:cObservacao+CRLF //"Observa็ใo"
					EndIf
				Next nX
			EndIf
		EndIf
		
		Conout("[JOB  ]["+cIdEnt+"] - Iniciando transmissao NF-e de saida!")
		cRetorno := SpedNFeTrf("SF2",aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
		Conout("[JOB  ]["+cIdEnt+"] - "+cRetorno)
		
		Conout("[JOB  ]["+cIdEnt+"] - Iniciando transmissao NF-e de entrada!")
		cRetorno := SpedNFeTrf("SF1",aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
		Conout("[JOB  ]["+cIdEnt+"] - "+cRetorno)
		
	EndIf
Else
	Conout("SPED","Execute o m๓dulo de configura็ใo do servi็o, antes de utilizar esta op็ใo!!!")
EndIf

RestArea(aArea)

Return                                           


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  บ CRIAPNF  บ Autor บ Caio Garcia        บ Data ณ  30/08/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบObjetivo  ณ GERA NOTA DE ENTRADA DOS PEDIDOS DE TRANSFERENCIA 	      บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function FGerNFE(cIdent)

Local cFlBkp     := cFilAnt
Local cESPPNFE   := GETMV("MV_ESPPNFE",,"SPED")
Local cTPPNFE    := GETMV("MV_TPPNFE",,"N")
Local cFORPNFE   := GETMV("MV_FORPNFE",,"N")
Local cLJENTPNF  := GETMV("MV_LJENTPNF",,cFilAnt)
Local cLOCGLP    := GetMV("MV_LOCGLP")
Local cLocDep	 := GetMv("MV_SYLOCDP",,"0101")
Local cLocLoj	 := ""
Local cTESTrf	 := SuperGetMV("KH_TESTRF",.F.,"054")
Local _cChvNfe   := ""
Local _cDbTSS    := AllTrim(UPPER(GetMv("KH_DBTSS",,"TSS")))
Local _cAlias    := GetNextAlias()
Local _cQuery    := ""

Local _cArmMos   := GETMV("MV_LOCGLP",,"03")

Local _lPreNf    := .F.

Private aCabec:= {}
Private aItens:= {}
Private aLinha:= {}
Private lMsErroAuto := .F.

ConOut("-----------------------------------------")
ConOut(AllTrim(cFilAnt)+" - Inicio da rotina FGERNFE: " +Time())       
ConOut("-----------------------------------------")
      
//cIdEnt := GetIdEnt()

If !Empty(AllTrim(cIdEnt))
	
	ConOut("Ident: "+cIdent )
	
	_cQuery := " SELECT NFE_CHV CHAVE "
	_cQuery += " FROM "+_cDbTSS+".dbo.SPED054 "
	_cQuery += " WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND ID_ENT = '"+cIdEnt+"' "
	_cQuery += " AND NFE_ID = '"+SF2->F2_SERIE+SF2->F2_DOC+"' "
	
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_CHVTMP_",.F.,.T.)
	                                     
	MemoWrite('\Querys\KMESTF01_CHV.sql',_cQuery)
	                      
	DbSelectArea("_CHVTMP_")
	_CHVTMP_->(DbGoTop()) 
		
	If !Empty(AllTrim(_CHVTMP_->CHAVE))
		
		_cChvNfe := _CHVTMP_->CHAVE
		_CHVTMP_->(DbCloseArea())
		ConOut("Chave "+_cChvNfe)  
		
	Else
		
		_lPreNf := .T.
		_CHVTMP_->(DbCloseArea())
		
	EndIf
	
Else
	
	_lPreNf := .T.
	ConOut("Nใo achou Ident" )
	
EndIf

DbSelectArea("SA2")
SA2->(DbOrderNickName("FILTRF2"))
SA2->(DbGoTop())
SA2->(DbSeek(xFilial("SA2") + cFilAnt))

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SD2") + " SD2 "
_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
_cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"' "
_cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"' "
_cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
_cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"' "
_cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
_cQuery += " ORDER BY D2_ITEM "
_cQuery := ChangeQuery(_cQuery)

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),(_cAlias),.F.,.T.)

DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

cLocLoj := GetAdvFVal("SA1","A1_FILTRF",xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,1,"")
cLOCGLP := SuperGetMV("SY_LOCPAD",.F.,"01",cLocLoj)

If _lPreNf //Gerar Pre-Nota
	
	If (_cAlias)->(!Eof())
		
		ConOut("Gera Pre-Nota" )
		
		aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
		{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
		{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
		{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
		{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
		{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
		{'F1_COND'	    ,'001'	            ,NIL},;
		{'F1_FORNECE'	,SA2->A2_COD        ,NIL},;
		{'F1_LOJA'		,SA2->A2_LOJA  	    ,NIL}}
		
		While (_cAlias)->(!EOF())
			aLinha := {}
			
			aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
			{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
			{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
			{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
			{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
			{'D1_TIPO'		,cTPPNFE 				,NIL},;
			{'D1_LOCAL'		,_cArmMos	  			,NIL},;
			{'D1_TES'		,cTESTrf				,NIL}}
			
			aadd(aItens,aLinha)
			(_cAlias)->(DbSkip())
			
		EndDo
		
		cFilAnt := '0101'
		ConOut("CFILANT: "+AllTrim(cFilAnt))       
		PUTMV("MV_DISTMOV", .F.)
		PUTMV("MV_PCNFE", .F.)
		MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens,3)
		
		
		If lMsErroAuto
			
			ConOut("Erro ao incluir Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
			
		Else
			
			ConOut("Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
			
		EndIf
		
		cFilAnt := cFlBkp
		PUTMV("MV_DISTMOV", .T.)
		PUTMV("MV_PCNFE", .T.)
		
	EndIf
	
Else
	
	If (_cAlias)->(!Eof())
		
		aCabec := 	{	{'F1_TIPO'		,cTPPNFE	 		,NIL},;
		{'F1_FORMUL'	,cFORPNFE		 	,NIL},;
		{'F1_ESPECIE'	,cESPPNFE		 	,NIL},;
		{'F1_DOC'		,SF2->F2_DOC   		,NIL},;
		{'F1_SERIE' 	,SF2->F2_SERIE		,NIL},;
		{'F1_EMISSAO'	,SF2->F2_EMISSAO   	,NIL},;
		{'F1_COND'	    ,'001'	            ,NIL},;
		{'F1_FORNECE'	,SA2->A2_COD        ,NIL},;
		{'F1_CHVNFE'	,_cChvNfe           ,NIL},;
		{'F1_LOJA'		,SA2->A2_LOJA  	    ,NIL}}
		
		While (_cAlias)->(!EOF())
			aLinha := {}
			
			aLinha := {	{'D1_COD'		,(_cAlias)->D2_COD		,NIL},;
			{'D1_UM'		,(_cAlias)->D2_UM    	,NIL},;
			{'D1_QUANT'		,(_cAlias)->D2_QUANT	,NIL},;
			{'D1_VUNIT'		,(_cAlias)->D2_PRCVEN 	,NIL},;
			{'D1_TOTAL'		,(_cAlias)->D2_TOTAL  	,NIL},;
			{'D1_TIPO'		,cTPPNFE 				,NIL},;
			{'D1_LOCAL'		,_cArmMos	  			,NIL},;
			{'D1_TES'		,cTESTrf				,NIL}}
			
			aadd(aItens,aLinha)
			(_cAlias)->(DbSkip())
			
		EndDo
		
		cFilAnt := '0101'
		PUTMV("MV_DISTMOV", .F.)
		PUTMV("MV_PCNFE", .F.)
		MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)
		
		If lMsErroAuto
			ConOut("Erro ao incluir NF De Entrada - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
			
			//MostraErro()
			
			lMsErroAuto := .F.
			
			ConOut("Gera Pre-Nota" )
			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens,3)
			
			If lMsErroAuto
				
				ConOut("Erro ao incluir Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
				
			Else
				
				ConOut("Pre Nota - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
				
			EndIf
			
			//		mostraerro()
		Else
			ConOut("NF ENTRADA - N : " + SF2->F2_DOC + " " + SF2->F2_SERIE )
		EndIf
		
		cFilAnt := cFlBkp
		PUTMV("MV_DISTMOV", .T.)
		PUTMV("MV_PCNFE", .T.)
		
	EndIf
	
EndIf

Return()

