#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE MERCADORIA 	1
#DEFINE DESCONTO		2
#DEFINE	ACRESCIMO		3
#DEFINE	FRETE	   		4
#DEFINE	DESPESA			5
#DEFINE	BASEDUP			6
#DEFINE	SUFRAMA			7
#DEFINE	TOTAL			8

#DEFINE ENTER CHR(13)+CHR(10)
#DEFINE CRLF CHR(10)+CHR(13)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVPED   º Autor ³ AP6 IDE            º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. para substituir a gravacao do SC5 e SC6.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CALL CENTER - TELEVENDAS                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ´±±
±±³ Programador            ³ Data   ³ Chamado ³ Motivo da Alteracao       ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ´±±
±±³Caio Garcia             ³23/01/18³         ³Alteração do WF            ³±±
±±³#CMG20180123            ³        ³         ³                           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ´±±
±±³                        ³        ³         ³                           ³±±
±±³                        ³        ³         ³                           ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKVPED()

Local nZ		:= 0
Local aItPerso  := {}
Local _nx       := 0

Local _cFilBkp  := cFilAnt //#CMG20180914.n
Local _aSaldos  := {}
Local _nQtdEst  := 0

Local _cMsgEnt   := ""

Private _lMenMos  := .F.//#CMG20181114.n
Private _lMenSal  := .F.//#CMG20181114.n
Private _lAgend   := .T. //#CMG20180914.n
Private _cMenMos  := "| Cliente ciente que adquiriu uma peça de mostruário e verificou o estado da peça |"
Private _cMenSal  := "| Cliente ciente que adquiriu uma peça de saldão e verificou o estado da peça |"
Private _nQtdCpo 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})
Private _nPrdCpo 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Private _nAgeCpo 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_XAGEND"})
Private _nLocCpo 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_LOCAL"})
Private _nDatCpo 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DTENTRE"})
Private _aRet       := {}
Private cUsados := ""
Private nMostru 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_MOSTRUA"})
Private aMost   := {}        //nNCCUsada
Private _lBoleto := .F.
Private _lRetPV	:= .F.	//#RVC20180614.n
Private lExcVldFin:= getmv("KMH_VLDFIN")
Private _cGrpCred	:= GetMv("MV_KOGRPLB") //Usuario que poderão liberar de orcamento para faturamento no Call Center //#CMG20180608.n
Private cUserId	    := __cUserID //#CMG20180608.n
Private _dDtBlqFi    := StoD(GetMv("KH_DTBLQFI"))
Private _dDtNoAge    := StoD(GetMv("KH_DTNOAGE"))
Private _nDiasEnt    := GetMv("KH_DIASENT")
Private _lNoEst      := .F.
Private _lBlqCred    := .F.
Private _dEntreg     := CtoD('//')
Private _cGetEnd     := ""
Private lRetPass := .F.
Private lTermoRet := .F.
Private cRestEnt  := "" 

_dEntreg := fDiasValid(SUA->UA_EMISSAO,_nDiasEnt)

cFilAnt := '0101'
SUB->(DbSetOrder(1))

For _nx := 1 To Len(aCols)
	
	If aCols[_nx,nMostru] == "2"
		
		_lMenMos  := .T.//#CMG20181114.n
		
	ElseIf aCols[_nx,nMostru] == "5"//#WRP20181108 INCLUSÃO DA OPÇÃO SALDÃO
		
		_lMenSal  := .T.//#CMG20181114.n
		
	EndIf
	
Next _nx

For _nx := 1 To Len(aCols)
	
	If aCols[_nx,nMostru] == "2"
		
		_lAgend   := .F.
		
	ElseIf aCols[_nx,nMostru] == "5"//#WRP20181108 INCLUSÃO DA OPÇÃO SALDÃO
		
		_lAgend   := .F.
		
	ElseIf aCols[_nx,nMostru] == '1'//1=PEÇA NOVA LOJA;2=MOSTRUÁRIO;3=PERSONALIZADO;4=ACESSÓRIO;5=SALDÃO
		
		If fVerAgend(aCols[_nx,_nPrdCpo], aCols[_nx,_nLocCpo], aCols[_nx,_nQtdCpo])
			
			//Verifica se tem endereços disponiveis
			_cGetEnd := fRetEnd(aCols[_nx,_nPrdCpo], aCols[_nx,_nLocCpo], aCols[_nx,_nQtdCpo] )
			
			If Empty(AllTrim(_cGetEnd))
				
				_lAgend := .F.
				
			EndIf
			
			_cGetEnd := ''
			
		Else
			
			_lAgend := .F.
			
			
		EndIf
		
		
	EndIf
Next _nx

cFilAnt:= _cFilBkp

If _lAgend .And. !(Alltrim(cUserId) $ _cGrpCred) //Não for usuário credito
	
	If MsgYesNo("Deseja agendar o pedido?","AGENDAMENTO")
		
		_aRet := TELMANU(SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_NUM)
		
		cRestEnt := Alltrim(_aRet[4])
		
		If _aRet[1]
			
			SUB->(DbSetOrder(1))
			If SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM ))
				While SUB->( !Eof() ) .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM
					
					RecLock("SUB",.F.)
					SUB->UB_DTENTRE := _aRet[2]
					SUB->UB_XAGEND := "1"
					SUB->(MsUnLock())
					SUB->(DbSkip())
				EndDo
			EndIf
			
			MSMM(,TamSx3("UA_CODOBS")[1],,_aRet[3],1,,,"SUA","UA_CODOBS")
			
		EndIf
		
	EndIf
	
ElseIf !(Alltrim(cUserId) $ _cGrpCred)//Não Tem estoque
	
	SUB->(DbSetOrder(1))
	If SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM ))
		While SUB->( !Eof() ) .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM
			
			RecLock("SUB",.F.)
			SUB->UB_DTENTRE := _dEntreg
			SUB->UB_XAGEND := "2"
			SUB->(MsUnLock())
			SUB->(DbSkip())
		EndDo
	EndIf
	
	_cMsgEnt := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)
	_cMsgEnt := _cMsgEnt + CRLF

	If !('|Para produtos de encomenda a previsão de entrega é de '+AllTrim(cValToChar(_nDiasEnt))+' dias úteis|' $ _cMsgEnt)
		
		_lNoEst := .T.
		_cMsgEnt += '|Para produtos de encomenda a previsão de entrega é de '+AllTrim(cValToChar(_nDiasEnt))+' dias úteis|'
		
		If _lMenMos
			_cMsgEnt += _cMenMos
		EndIf
		
		If _lMenSal
			_cMsgEnt += _cMenSal
		EndIf
		
		MSMM(,TamSx3("UA_CODOBS")[1],,_cMsgEnt,1,,,"SUA","UA_CODOBS")
		
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA A VENDA DE MOSTRUARIOS - SE EXISTIR UM MOSTRUARIO³
//³ CRIAR AS NOTAS DE TRANSFERENCIAS AUTOMATICAS                     ³
//³ CASO EXISTA ACESSORIOS, TAMBEM CRIAR NF DE TRANSFERENCIA - Ellen ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nZ:=1 To Len(aCols)
	//If aCols[nZ,nMostru] $ "2|4"
	If aCols[nZ,nMostru] $ "2|5"//#WRP20181109.n - ADIÇÃO DA OPÇÃO SALDÃO
		aAdd( aMost , aCols[nZ] )
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRATAMENTO PARA ENVIO DO WORKFLOW PARA COMPRAS DE PRODUTOS PERSONALIZADOS - LUIZ EDUARDO .F.C. - 15.08.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 To Len(aCols)
	If aCols[nY,nMostru] == "3"
		aAdd( aItPerso , aCols[nY] )
	EndIf
Next

MsUnlockAll()

Begin Transaction

//#RVC20180614.bo
/*
If Len(aMost) > 0
FwMsgRun( ,{|| U_SYTMOV03() }, , "Por favor, aguarde preparando as Notas de Transferência..." )
EndIf

FwMsgRun( ,{|| GeraPedido() }, , "Por favor, aguarde gerando o(s) pedido(s)..." )
*/
//#RVC20180614.eo

_cPed := ""
//#RVC20180614.bn
FwMsgRun( ,{|| _lRetPV := GeraPedido(@_cPed) }, , "Por favor, aguarde... Gerando o(s) pedido(s)." )

If _lRetPV
	If Len(aMost) > 0
		FwMsgRun( ,{|| U_SYTMOV03(_cPed) }, , "Por favor, aguarde... Preparando a(s) Nota(s) de Transferência" )
	EndIF
EndIf
//#RVC20180614.en
/*
if SUA->UA_OPER=='1'
	if MsgYesNo("Imprime termo de retirada para Agregados?" +ENTER +ENTER;
				+"OBS: Após impressão, salve o termo devidamente assinado na base de conhecimentos do Cliente.","Imprime Agregados")      
		lTermoRet := .T.
	endif
endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SE EXISTIR ITENS PERSONALIZADOS ENVIA O WORKFLOW INFORMATIVO PARA COMPRAS - 15.08.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aItPerso) > 0
	U_WKFLOJ01(aItPerso)
EndIf

End Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LIBERA TODAS AS TABELAS QUE POSSAM ESTAR PRESAS NO SISTEMA - LUIZ EDUARDO F.C. - 25.08.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DBUnlockAll()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MODIFICADO A IMPRESSAO DO PEDIDO - PEDIDO GRAFICO - RAFAEL V. CRUZ - 28.07.2017 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If _lRetPV
	
	TrataDesc()		// rotina de tratamento dos descontos e ponto de pedido - Cristiam Rossi em 21/06/2017
	
	If !Empty(SUA->UA_NUMSC5)
		U_KMPEDIDO(SUA->UA_NUMSC5,_lBoleto)
	ElseIf !Empty(SUA->UA_PEDLIN2)
		U_KMPEDIDO(SUA->UA_NUMSC5,_lBoleto)
	EndIf 
	
EndIf 
 /*                   
//Impressão do termo de retirada de agregados - Marrcio Nunes - 23/05/2019
If lTermoRet
	U_SYVR109()	     
EndIf
*/
if lRetPass
	if SC6->(dbseek('01  ' + SUA->UA_NUMSC5))
		While SC6->(!Eof()) .And. SC6->C6_NUM == SUA->UA_NUMSC5
			RecLock("SC6",.F.)
				Replace SC6->C6_ENTREG  With stod('66660606')
			SC6->(msUnLock())
		SC6->(dbSkip())
		end
	endif
endif

SC5->(DbCloseArea())
SC6->(DbCloseArea())

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraPedidoº Autor ³ AP6 IDE            º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geracao dos pedidos de venda.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CALL CENTER - TELEVENDAS                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraPedido(_cPed)

Local aArea 		:= GetArea()
Local _cFilAtu		:= SUA->UA_FILIAL
Local cAtende   	:= SUA->UA_NUM
Local cAlias 		:= GetNextAlias()
Local cPedido		:= ""
Local cQuery		:= ""
Local nOpAnt 		:= 0					// Valor do status da OPERACAO anterior em caso de ALTERACAO
Local nX			:= 0
Local nVlrLiq		:= SUA->UA_VLRLIQ		// Valor liquido da venda
Local nVlrMerc		:= aValores[MERCADORIA]
Local aLinhaPr		:= {}
Local aLinhaUr  	:= {}
Local aProds 		:= {}
Local lLin01		:= .F.
Local lLin02		:= .F.
Local lBloqFina		:= .F.
Local lRateFin
Local aEncomenda	:= {}

Private cDirImp	 	:= "\CALL_CENTER_"+cFilAnt+"\"
Private cARQLOG		:= cDirImp+"TMKVPED_"+cFilAnt+"_"+cAtende+".LOG"
Private cCondPg		:= SUA->UA_CONDPG
Private cPedPend	:= SUA->UA_PEDPEND
Private nVlFre01	:= 0
Private nVlFre02	:= 0
Private	nVlDes01 	:= 0
Private	nVlDes02 	:= 0
Private nVlDesp1	:= 0
Private nVlDesp2	:= 0
Private nLinha01	:= 0
Private nLinha02	:= 0
Private	nRepre01 	:= 0
Private	nRepre02 	:= 0
Private nCredito	:= 0
Private nCredNCC	:= 0								//#RVC20181024.n
Private cLocDep 	:= GetMv("MV_SYLOCDP",,"100001")
Private lTmkVPedI	:= FindFunction("U_TMKVPEDI") 		// P.E. antes  da substituicao da gravacao do SC5 e SC6
Private lTmkVPedF	:= FindFunction("U_TMKVPEDF") 		// P.E. depois da substituicao da gravacao do SC5 e SC6
Private cObs		:= ""
Private cOcorren	:= GetMv("KH_MSGOCOR",,"000002")//Codigo da ocorrencia para mensagem (Troca/Retira)
Private aOcorrencia	:= Separa(cOcorren,"/")
Private cString		:= ""
Private aObs		:= {}
Private aMostrua	:= {}
Private lExecAuto	:= GetMv("KM_EXECAUT",,.T.)

_lRetPV		:= .F.	//#RVC20180618.n

For nX := 1 To Len(aOcorrencia)
	cString += "'"+Alltrim(aOcorrencia[nX])+"',"
Next
cString:= Substr(cString,1,Len(cString)-1)

MakeDir(cDirImp)

LjWriteLog( cARQLOG, Replicate('-',80) )
LjWriteLog( cARQLOG, "INICIADO ROTINA DE GERACAO DOS PEDIDOS DE VENDA TMKVPED() - DATA/HORA: "+DToC(Date())+" AS "+Time() )

If lTmkVPedI
	lBloqFina := U_TMKVPEDI(@cARQLOG)
EndIf

If !lBloqFina
	
	//#CMG20180920.n
	If SUA->UA_XPERLIB > 0
		
		_lBlqCred := .T.
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia Workflow para Responsavel Tecnico.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SUA->UA_VEND1) .And. ( SUA->UA_ENWKFRT=='2' .Or. Empty(SUA->UA_ENWKFRT))
		U_SYVW100(cAtende)
	EndIf
	
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4") + cCondPg ))
	lRateFin := Alltrim(SE4->E4_01FORPA)<>"CH"
	nOpAnt 	 := IF(!Empty(SUA->UA_OPER),VAL(SUA->UA_OPER),0)
	
	SUB->(DbSetOrder(1))
	If SUB->(DbSeek(xFilial("SUB") + cAtende ))
		While SUB->( !Eof() ) .And. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+cAtende
			//1                 2              3                 4                     5
			AAdd( aLinhaPr , { SUB->UB_FILIAL  , SUB->UB_ITEM    , SUB->UB_PRODUTO , SUB->UB_QUANT   , SUB->UB_VRUNIT  ,;
			SUB->UB_VLRITEM , SUB->UB_DTENTRE , SUB->UB_TES     , SUB->UB_CF      , SUB->UB_LOCAL   ,;
			SUB->UB_UM      , SUB->UB_PRCTAB  , SUB->UB_DTVALID , SUB->UB_DESC    , SUB->UB_VALDESC ,;
			SUB->UB_OPC     , SUB->(Recno())  , SUB->UB_CONDENT , SUB->UB_MOSTRUA , SUB->UB_01DESME ,;
			SUB->UB_TPENTRE , SUB->UB_DESCPER , SUB->UB_XLIBDES , SUB->UB_XDESMAX , SUB->UB_XAGEND})
			
			nLinha01 += SUB->UB_VLRITEM
			lLin01 	 := .T.
			
			AAdd( aProds , { SUA->UA_CLIENTE , SUA->UA_LOJA, SUB->UB_PRODUTO } )
			
			//Tratamento para impressão de produtos de mostruario.
			If SUB->UB_MOSTRUA == '2'
				AAdd( aMostrua , { SUB->UB_PRODUTO , SUB->UB_DESC, SUB->UB_MOSTRUA } )
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Localiza os produtos do tipo encomenda      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SUB->UB_CONDENT == '2'
				AAdd( aEncomenda , { SUB->UB_PRODUTO , SUB->UB_DESC, SUB->UB_CONDENT } )
			EndIf
			
			SUB->(DbSkip())
		End
	EndIf
	
	//Calcula em quanto os produtos da linha praia e campo representa no pedido original.
	If lLin01
		LjWriteLog( cARQLOG, "1.00 - INICIANDO VARIAVEIS DA LINHA 1" )
		nPerce01	:= Round(nLinha01/nVlrMerc,4)
		nVlFre01	:= Round(aValores[FRETE]*nPerce01,4)
		nVlDes01 	:= Round(aValores[DESCONTO]*nPerce01,4)
		nVlDesp1	:= Round(aValores[DESPESA]*nPerce01,4)
		nLinha01 	:= (nLinha01 - nVlDes01) + nVlFre01
		nRepre01 	:= Round(nLinha01/nVlrLiq,4)
	EndIf
	
	If !Empty(SUA->UA_01SAC)
		
		cQuery := " SELECT 	TOP 1 RIGHT(UC_01PED,6) AS PEDIDO, "
		cQuery += "			ISNULL(C5_NOTA,'') NOTA, "
		cQuery += "			ISNULL(C5_SERIE,'') SERIE, "
		cQuery += "			ISNULL(F2_EMISSAO,'') EMISSAO, "
		cQuery += "			UD_01DESDE DEFEITO "
		cQuery += " FROM "+RetSqlName("SUD")+" SUD "
		cQuery += " INNER JOIN "+RetSqlName("SUC")+" SUC ON UC_FILIAL  = '"+xFilial("SUC")+"'	AND UC_CODIGO=UD_CODIGO AND SUC.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL  = '"+xFilial("SB1")+"' 	AND B1_COD=UD_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL  = '"+xFilial("SC5")+"'  AND C5_NUM=RIGHT(UC_01PED,6) AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += " LEFT  JOIN "+RetSqlName("SF2")+" SF2 ON F2_FILIAL  = '"+cLocDep+"' AND F2_DOC=C5_NOTA AND F2_SERIE=C5_SERIE AND F2_CLIENTE=C5_CLIENTE AND F2_LOJA=C5_LOJACLI AND SF2.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE "
		cQuery += "		UD_FILIAL = '"+xFilial("SUD")+"' AND "
		cQuery += "		UD_OCORREN IN ("+cString+") AND "
		cQuery += "		UD_CODIGO = '"+SUA->UA_01SAC+"' AND "
		cQuery += "		SUD.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		If (cAlias)->( !EOF() )
			
			cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
			If !Empty(cObs)
				cObs += CRLF
				cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
			EndIf
			
			cObs:= "Pedido de troca, referente ao pedido "+(cAlias)->PEDIDO+"/ Nota Fiscal: "+(cAlias)->NOTA+"/"+(cAlias)->SERIE +" De: "+DTOC(STOD((cAlias)->EMISSAO)) + CRLF
			cObs+= "MOTIVO: "+(cAlias)->DEFEITO + CRLF
		EndIf
		(cAlias)->( dbCloseArea() )
		
		If !Empty(cObs)
			RecLock("SUA",.F.)
			MSMM(,TamSx3("UA_CODOBS") [1],,cObs,1,,,"SUA","UA_CODOBS")
			MsUnlock()
		EndIf
		
	EndIf
	
	//Tratamento para impressão de produtos de mostruario.
	If Len(aMostrua) > 0 .And. aMostrua[1,3] == "02"
		
		cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
		If !Empty(cObs)
			cObs += CRLF
			cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
		EndIf
		
		cObs += "O Cliente está ciente da existencia de produto(s) do tipo mostruario nesse pedido e concorda com o estado em que o mesmo se encontra, assumindo total responsabilidade" + CRLF
		cObs += "tem ciência de que não há garantia do produto."+CRLF
		
		For nX := 1 To Len(aMostrua)
			cObs += "Mostruário - Produto: "+Alltrim(aMostrua[nX,1])+"-"+Alltrim(Posicione("SB1",1,xFilial("SB1")+aMostrua[nX,1],"B1_DESC"))+CRLF
		Next
		
		If !Empty(cObs)
			RecLock("SUA",.F.)
			MSMM(,TamSx3("UA_CODOBS") [1],,cObs,1,,,"SUA","UA_CODOBS")
			MsUnlock()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para impressão de produtos do tipo Saldão -#WRP 09.11.2018³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Elseif  Len(aMostrua) > 0 .And. aMostrua[1,3] == "05"
		
		cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
		If !Empty(cObs)
			cObs += CRLF
			cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
		EndIf
		
		cObs += "O Cliente está ciente da existencia de produto(s) do tipo Saldão nesse pedido e concorda com o estado em que o mesmo se encontra, assumindo total responsabilidade" + CRLF
		cObs += "tem ciência de que não há garantia do produto."+CRLF
		
		For nX := 1 To Len(aMostrua)
			cObs += "Saldão - Produto: "+Alltrim(aMostrua[nX,1])+"-"+Alltrim(Posicione("SB1",1,xFilial("SB1")+aMostrua[nX,1],"B1_DESC"))+CRLF
		Next
		
		If !Empty(cObs)
			RecLock("SUA",.F.)
			MSMM(,TamSx3("UA_CODOBS") [1],,cObs,1,,,"SUA","UA_CODOBS")
			MsUnlock()
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravando observacao para os casos de encomenda - #Ellen 24.04.2018  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If .F.//Removido a informação de encomenda no pedido - #CMG20180605.n
		If Len(aEncomenda) > 0
			cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
			If !Empty(cObs)
				cObs += CRLF
				cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
			EndIf
			For nX := 1 To Len(aEncomenda)
				cObs += "Encomenda - Produto: "+Alltrim(aEncomenda[nX,1])+"-"+Alltrim(Posicione("SB1",1,xFilial("SB1")+aEncomenda[nX,1],"B1_DESC")+"|")+CRLF
			Next
			//cObs += "Aguardar chegada do produto no estoque para o desbloqueio do pedido"+CRLF
			If !Empty(cObs)
				RecLock("SUA",.F.)
				MSMM(,TamSx3("UA_CODOBS") [1],,cObs,1,,,"SUA","UA_CODOBS")
				MsUnlock()
			EndIf
		EndIf
	EndIf
	
	//Grava na Observação da UA se tem restrição de passagem ou não.4W9-PB2-W736 (Número do ticket: 11249)
	If SUA->UA_XRETPASS == '1'
		
		cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
		
		If !Empty(cObs)
			cObs += CRLF
			cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
		EndIf
		
		cObs += 'O espaço por onde passará o sofá POSSUI restrição de passagem.'
	Else
		
		cObs := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
		
		If !Empty(cObs)
			cObs += CRLF
			cObs += Replicate("=",TamSx3("UA_OBS")[1]) + CRLF
		EndIf
		
		cObs += 'O espaço por onde passará o sofá NÂO POSSUI restrição de passagem.'
	EndIF
	
	If !Empty(cObs)
			RecLock("SUA",.F.)
				MSMM(,TamSx3("UA_CODOBS") [1],,cObs,1,,,"SUA","UA_CODOBS")
			MsUnlock()
	EndIf
	//--------------------------------------------------------------------------------------------------------
	
	//Gera Pedido de Venda com a linha Praia e Campo
	cPedido := ""
	If Len(aLinhaPr) > 0
		IF lExecAuto
			CriaPedido(cAtende,aLinhaPr[1,21],aLinhaPr,xFilial("SC5"),@cPedido)
			LjWriteLog( cARQLOG, "2.00 - GERADO PEDIDO DE VENDA LINHA 1" )
		Else
			GERASC5(cAtende,nOpAnt,@cPedido,"1",xFilial("SC5"),aLinhaPr[1,21])
			LjWriteLog( cARQLOG, "2.00 - GERADO CABECALHO DO PEDIDO DE VENDA LINHA 1" )
			
			GERASC6(aLinhaPr,cPedido,xFilial("SC6"))
			LjWriteLog( cARQLOG, "2.10 - GERADO ITENS DO PEDIDO DE VENDA LINHA 1" )
		EndIF
		
		
		If SUA->UA_PEDPEND <> "2" //Em Aguardar na gera financeiro
			IF lExecAuto
				CriaTitulo(cAtende,cPedido,3,xFilial("SUA"),nRepre01,"1",@nCredito,SUA->UA_VEND)
			Else
				GERASE1(cAtende,cPedido,3,xFilial("SUA"),nRepre01,"1",@nCredito,SUA->UA_VEND)
			EndIF
			LjWriteLog( cARQLOG, "2.10 - GERADO FINANCEIRO LINHA 1" )
		EndIf
		
		//		TrataDesc()		// rotina de tratamento dos descontos e ponto de pedido - Cristiam Rossi em 21/06/2017
		
	EndIf
	
	If nCredito > 0
		cPedido := SUA->UA_NUMSC5
		//		SyBxNCC1(nCredito,SUA->UA_CLIENTE,SUA->UA_LOJA,_cFilAtu,cAtende,cPedido)			//#RVC20181030.o
		SyBxNCC1(nCredito,SUA->UA_CLIENTE,SUA->UA_LOJA,_cFilAtu,cAtende,cPedido,@nCredNCC)	//#RVC20181030.n
		LjWriteLog( cARQLOG, "5.00 - GERADO BAIXA DE NCC DO CLIENTE" )
		
		//#RVC20181018.bn
		Reclock("SUA",.F.)
		//SUA->UA_XVLRCRD := nCredito	//#RVC20181024.o
		SUA->UA_XVLRCRD := nCredNCC 	//#RVC20181024.n
		MsUnlock()
		//#RVC20181018.en
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime pedido de venda.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SUA->UA_NUMSC5)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ MODIFICADO A IMPRESSAO DO PEDIDO - PEDIDO GRAFICO - LUIZ EDUARDO F.C. - 17.10.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//U_SYTMR003(SUA->UA_NUMSC5)
		//			U_KMPEDIDO(SUA->UA_NUMSC5,_lBoleto) //#RVC20180728.o
		LjWriteLog( cARQLOG, "6.00 - IMPRESSAO DO PEDIDO DE VENDA LINHA 1" )
	ElseIf !Empty(SUA->UA_PEDLIN2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ MODIFICADO A IMPRESSAO DO PEDIDO - PEDIDO GRAFICO - LUIZ EDUARDO F.C. - 17.10.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//			U_KMPEDIDO(SUA->UA_NUMSC5,_lBoleto)	//#RVC20180728.o
		//U_SYTMR003(SUA->UA_PEDLIN2)
		LjWriteLog( cARQLOG, "6.00 - IMPRESSAO DO PEDIDO DE VENDA LINHA 1" )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Termo de Retira.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	U_ImpTerRet(cAtende)			//#RVC20180717.o
	U_ImpTerRet(_cFilAtu,cAtende)	//#RVC20180717.n
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Termo de Renuncia.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//U_ITRenuncia(cAtende)
	
	If INCLUI
		RecLock("SUA",.F.)
		MSMM(,TamSx3("UA_CODFOLL")[1],,M->UA_OBSFOLL,1,,,"SUA","UA_CODFOLL")
		MsUnlock()
		lConfirma:=.T.
	EndIf
	
EndIf

//#CMG20180621.bn
If !(Empty(Alltrim(SUA->UA_NUMSC5)))//Gerou pedido
	_cPed := SUA->UA_NUMSC5
	_lRetPV := .T.
	
EndIf
//#CMG20180621.en

If lTmkVPedF .and. lExcVldFin
	if SUA->UA_OPER == "1"	//#AFD20180621.N
		U_TMKVPEDF(SUA->UA_NUMSC5, SUA->UA_FILIAL, SUA->UA_CLIENTE, SUA->UA_NUM, SUA->UA_XPERLIB)	//#AFD20180621.N
		//lBloqFina := U_TMKVPEDF(@cARQLOG)	//#AFD20180621.O
	endif	//#AFD20180621.N
EndIf

LjWriteLog( cARQLOG, "FINALIZADO ROTINA DE GERACAO DOS PEDIDOS DE VENDA TMKVPED() - DATA/HORA: "+DToC(Date())+" AS "+Time() )
LjWriteLog( cARQLOG, Replicate('-',80) )

RestArea(aArea)

//Return	//#RVC20180618.o
Return _lRetPV	//#RVC20180618.n

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERASC5  ºAutor  ³Microsiga           º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o cabecalho do pedido de venda                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC5(cAtende,nOpAnt,cPedido,cLinha,cFilAtu,cTPEntrega)

Local cNumSc5 	:= ''													// Numero do Pedido	- Inclusao
Local nNumPar 	:= SuperGetMv("MV_NUMPARC")								// Numero de parcelas utilizada no sistema
Local nUA_CONTRA:= SUA->(FieldPos("UA_CONTRA"))							// Verifica se o campo CONTRATO para integracao com o SIGACRD esta criado  na base de dados
Local lTipo9	:= .F.													// Indica se a venda foi tipo 9
Local aPedido	:= {}													// Array com o numero do pedido para emissao da NF - MV_OPFAT = S
Local nValComi	:= 0 													// Valor da Comissao para o SC5
Local nI		:= 0
Local cOBS1		:= U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
Local cTPFRETE  := "" // IRA ARMAZENAR O TIPO DE FRETE DO CADASTRO DE CLIENTES - LUIZ EDUARDO F.C. - 18.08.2017
Local _cMenMost := ''//#CMG20181008.n

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)
	nValComi:= SA1->A1_COMIS
EndIf

//#CMG20181008.bn
If Len(aMostrua) > 0
	
	DBSelectarea("SM0")
	SM0-> (DbSetorder(1))
	SM0-> (DbSeek(cEmpant + cFilant))
	_cMenMost:= "MOSTRUARIO - " + Alltrim(SM0->M0_FILIAL) + ' - ' + cFilant
	
	
EndIf
//#CMG20181008.en

If nValComi == 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega o valor da comissao no cadastro de vendedores, caso nao tenha o % preenchido no cadastro de clientes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(M->UA_COMIS) .AND. !Empty(M->UA_VEND)
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+M->UA_VEND)
			nValComi := A3_COMIS
		EndIf
	EndIf
EndIf

// Verifica se a condicao de pagamento e do tipo 9
DbSelectArea("SE4")
DbSetOrder(1)
If DbSeek(xFilial("SE4")+M->UA_CONDPG)
	If SE4->E4_TIPO == "9"
		lTipo9 := .T.
	EndIf
EndIf

If M->UA_OPER == "1"
	//Se ‚ um NOVO PEDIDO gero os registros no SC5
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
	cMay := "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	While (DbSeek(cFilAtu+cNumSC5) .OR. !MayIUseCode(cMay))
		cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
		cMay 	:= "SC5"+ALLTRIM(cFilAtu)+cNumSC5
	End
	If __lSX8
		ConfirmSX8()
	EndIf
	
	lNovo := .T.
	
	DbSelectArea("SC5")
	SC5->(RecLock("SC5",lNovo))
	Replace C5_FILIAL  With xFilial("SC5")
	Replace C5_NUM     With cNumSC5
	Replace C5_TIPO    With "N"
	Replace C5_CLIENTE With M->UA_CLIENTE
	Replace C5_LOJACLI With M->UA_LOJA
	Replace C5_CLIENT  With M->UA_CLIENTE
	Replace C5_LOJAENT With M->UA_LOJA
	Replace C5_TRANSP  With M->UA_TRANSP
	Replace C5_TIPOCLI With M->UA_TIPOCLI
	Replace C5_CONDPAG With M->UA_CONDPG
	Replace C5_TABELA  With M->UA_TABELA
	Replace C5_VEND1   With M->UA_VEND
	Replace C5_COMIS1  With IIF( Empty( nValComi ), M->UA_COMIS, nValComi)
	Replace C5_ACRSFIN With 0
	Replace C5_01SAC   With M->UA_01SAC
	Replace C5_XREGCON With cRestEnt // Acrescentado a gravação do campo restrição de Entrega no agendamento pela loja.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A data de emissao do pedido e atualizada somente na primeira gravacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lNovo
		Replace C5_EMISSAO With dDataBase
	EndIf
	Replace C5_MOEDA   With M->UA_MOEDA
	Replace C5_TXMOEDA With RecMoeda(M->UA_EMISSAO,M->UA_MOEDA)
	Replace C5_LIBEROK With "S"
	Replace C5_FRETE   With If(cLinha=="1",nVlFre01,nVlFre02)
	Replace C5_DESPESA With If(cLinha=="1",nVlDesp1,nVlDesp2)
	Replace C5_DESCONT With IF(Empty(M->UA_PDESCAB),If(cLinha=="1",nVlDes01,nVlDes02),0) // O desconto no rodape e valido somente se o Operador nao usa a INDENIZACAO (Cabecalho)
	Replace C5_TIPLIB  With M->UA_TIPLIB
	Replace C5_COMIS1  With IIF( Empty( nValComi ), M->UA_COMIS, nValComi)
	Replace C5_PDESCAB With M->UA_PDESCAB
	Replace C5_TPFRETE With M->UA_TPFRETE
	//Replace C5_TPCARGA With IF(cTPEntrega=="3","1","2")
	Replace C5_TPCARGA With '1' // wellington raul 20200121 trava para que o pedido sempre utilize carga
	Replace C5_DESC1   With M->UA_DESC1
	Replace C5_DESC2   With M->UA_DESC2
	Replace C5_DESC3   With M->UA_DESC3
	Replace C5_DESC4   With M->UA_DESC4
	Replace C5_INCISS  With SA1->A1_INCISS
	Replace C5_ORCRES  With cAtende
	Replace C5_TPFRETE With Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE + M->UA_LOJA,"A1_TPFRET")
	Replace C5_XDESCFI With IIF(INCLUI,FWFILIALNAME(CEMPANT,CFILANT,1),)
	Replace C5_XCONDMA With M->UA_XCONDMA
	Replace C5_MENNOTA With _cMenMost //#CMG20181008.n
	
	// Grava as parcelas quando a venda For do tipo 9
	If lTipo9
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Acerta as informações das parcelas que foram desconsideradas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aParcelas) < nNumPar
			For nI := 1 To nNumPar - Len(aParcelas)
				AADD(aParcelas ,{	CtoD("  /  /  "),;
				0  ,;
				"" ,;
				Space(80),;
				0,;
				Space(01)})
			Next
		EndIf
		For nI := 1 TO Len(aParcelas)
			Replace &("SC5->C5_DATA"+Substr(cParcela,nI,1)) With aParcelas[nI][1]
			If aParcelas[nI][5] > 0
				Replace &("SC5->C5_PARC"+Substr(cParcela,nI,1)) With aParcelas[nI][5] //Valor em %
			Else
				Replace &("SC5->C5_PARC"+Substr(cParcela,nI,1)) With aParcelas[nI][2] //Valor em R$
			EndIf
		Next nI
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao dos campos SIGACRD para integracao com o SIGAFAT.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nUA_CONTRA > 0
		Replace C5_CONTRA with SUA->UA_CONTRA
	EndIf
	
	Replace C5_VEND2	with SUA->UA_VEND1
	Replace C5_COMIS2	with Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND1,"A3_COMIS")
	Replace C5_01TPOP 	with "1"
	//Replace C5_PEDPEND	with SUA->UA_PEDPENDS //#AFD20180413.o
	Replace C5_PEDPEND	with iif(SUA->UA_XPERLIB > 0,"2",SUA->UA_PEDPEND)//#AFD20180413.n
	Replace C5_NUMTMK	with cAtende
	Replace C5_XPERLIB	with SUA->UA_XPERLIB//#AFD20180412.n
	
	//#CMG20180914.bn
	If .F.//_lAgend
		Replace C5_XCONPED	with '1'
	EndIf
	//#CMG20180914.en
	
	SC5->(MsUnlock())
	
	If !Empty(cOBS1)
		MSMM(,TamSx3("C5_XCODOBS") [1],,cOBS1,1,,,"SC5","C5_XCODOBS")
	EndIf
	FkCommit() // Commit para integridade referencial do SC5
	
	//Atualizo o numero do pedido e do atendimento para gerar a NF  - MV_OPFAT = "S"
	AADD(aPedido,{M->UA_NUM,cNumSc5})
	
	//Atualizo o numero do pedido no SUA
	DbSelectArea("SUA")
	SUA->(RecLock("SUA",.F.))
	If cLinha == "1"
		Replace UA_NUMSC5  With cNumSC5
		LjWriteLog( cARQLOG, "2.01 - GERADO PEDIDO DE VENDA LINHA 1: "+cNumSC5 )
	Else
		Replace UA_PEDLIN2 With cNumSC5
		LjWriteLog( cARQLOG, "3.01 - GERADO PEDIDO DE VENDA LINHA 2: "+cNumSC5 )
	EndIf
	SUA->(MsUnlock())
EndIf
cPedido := cNumSC5

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERASC6  ºAutor  ³Microsiga           º Data ³  18/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera os itens do pedido de venda                       	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GERASC6(aLinha,cNumSc5,cFilAtu)

Local nX 			:= 0
Local nUB_OPC		:= SUB->(FieldPos("UB_OPC"))								// Verifica se o campo de Opcionais do produto esta criado na Base de dados
Local nC6_NUMTMK	:= SC6->(FieldPos("C6_NUMTMK"))
Local cPrcFiscal	:= TkPosto(M->UA_OPERADO,"U0_PRECOF")						// Preco Fiscal Bruto = S ou N - Posto de Venda
Local cNovoItem 	:= "00"														// Valor do NOVO ITEM que sera incluido no SUB/SC6
Local lLiber 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTransf		:= .F.                                                     	// Compatibilizacao com o SIGAFAT
Local lLiberOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lResidOk 		:= .T.														// Compatibilizacao com o SIGAFAT
Local lFaturOk 		:= .F.														// Compatibilizacao com o SIGAFAT
Local lTLVReg  		:= .F.
Local cFilOld		:= cFilAnt
/*
Local lAvalCre 		:= .F.			// Avaliacao de Credito
Local lBloqCre 		:= .F. 			// Bloqueio de Credito
Local lAvalEst		:= .T.			// Avaliacao de Estoque
Local lBloqEst		:= .T.			// Bloqueio de Estoque
*/

Local lCredito	:= .T.
Local lEstoque	:= .T.
Local lAvCred	:= .F.
Local lAvEst	:= .F.
Local lLiber	:= .F.
Local lTransf   := .F.
Local cTESCont      := GetMV("KM_TESCONT",,"631")
Local nSldPed   := 0
Local nSldPed2  := 0
Local _cFilBkp  := cFilAnt //#CMG20180914.n

Local cLOCGLP    := GetMV("MV_LOCGLP") //#CMG20180621.n
local cObsRetPas := ""

lNovo := .T.
For nX := 1 To Len(aLinha)
	
	nSaldo := 0
	cNovoItem := SomaIt(cNovoItem)
	
	//Atualizo o numero do pedido no SUB
	/*DbSelectArea("SUB")
	DbGoto(aLinha[nX][17])
	Reclock("SUB",.F.)
	Replace UB_XFILPED 	With cFilAtu
	Replace UB_NUMPV 	With cNumSC5
	Replace UB_ITEMPV 	With cNovoItem
	MsUnlock()*/
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aLinha[nX][03] ))
	
	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+aLinha[nX][08]))
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	
	If !DbSeek(cFilAtu + PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) + aLinha[nX][10] )
		CriaSb2( PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) , aLinha[nX][10] )
	EndIf

	//Incluido Para criar Saldo inicial Tabela (SB2) na filial 0101, Armazem 01..
	If !DbSeek('0101' + PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) + '01' )
		CriaSb2( PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) , '01' )
	EndIf

	dbSelectArea("SB9")
	dbSetOrder(1)
	
	if !DbSeek('0101' + PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]) + '01' )
	//Incluido Para criar Saldo inicial Tabela SB9 na filial 0101, Armazem 01..
	//B9_FILIAL, B9_COD, B9_LOCAL, B9_DATA, R_E_C_N_O_, D_E_L_E_T_
		fGeraSb9(PADR(aLinha[nX][03],TAMSX3("B2_COD")[1]),'01')
	endif

	DbSelectArea("SC6")
	SC6->(Reclock("SC6",lNovo))
	Replace C6_FILIAL  With xFilial("SC6")
	Replace C6_NUM     With cNumSC5
	Replace C6_ITEM    With cNovoItem
	Replace C6_CLI     With M->UA_CLIENTE
	Replace C6_LOJA    With M->UA_LOJA
	Replace C6_PRODUTO With aLinha[nX][03]
	Replace C6_COMIS1  With SB1->B1_COMIS
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA GRAVAR A DESCRICAO DO PRODUTO PERSONALIZADO - LUIZ EDUARDO F.C. - 11.08.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !EMPTY(aLinha[nX,22])
		Replace C6_DESCRI  With ALLTRIM(SB1->B1_DESC) + "  //  " + ALLTRIM(aLinha[nX,22])
		Replace C6_PERSONA With "1"
	Else
		Replace C6_DESCRI  With SB1->B1_DESC
		Replace C6_PERSONA With "2"
	EndIf
	
	Replace C6_UM	   With aLinha[nX][11]
	Replace C6_QTDVEN  With aLinha[nX][04]
	Replace C6_QTDLIB  With aLinha[nX][04]
	Replace C6_SEGUM   With SB1->B1_SEGUM
	Replace C6_UNSVEN  With ConvUm(aLinha[nX][03],aLinha[nX][04],0,2)
	Replace C6_PRUNIT  With aLinha[nX][12]
	Replace C6_VALOR   With aLinha[nX][06]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.07.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SA1->A1_EST) <> "SP"
		If SA1->A1_CONTRIB == "2"
			Replace C6_TES     With cTESCont
		EndIf
	Else
		Replace C6_TES     With If( !Empty(SB1->B1_TSESPEC) , SB1->B1_TSESPEC , aLinha[nX][08])				//aLinha[nX][08]
	EndIf
	Replace C6_CF      With SYRETCF(SC6->C6_TES,M->UA_CLIENTE,M->UA_LOJA,cNumSC5,cFilAtu) 					//aLinha[nX][09]
	
	//#CMG20180621.bn
	If Alltrim(aLinha[nX][19]) == '2' .Or. Alltrim(aLinha[nX][19]) == '4' .Or. Alltrim(aLinha[nX][19]) == '5' //#WRP20181129.BN
		Replace C6_LOCAL With cLOCGLP
	Else
		Replace C6_LOCAL   With aLinha[nX][10]
	EndIf
	//#CMG20180621.en
	
	If _lNoEst
		Replace C6_ENTREG  With _dDtNoAge
	ElseIf _lBlqCred
		Replace C6_ENTREG  With _dDtBlqFi
	Else
		Replace C6_ENTREG  With aLinha[nX][07]
	EndIf

	Replace C6_TPOP    With "F"
	Replace C6_CLASFIS With Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
	Replace C6_PEDCLI  With "TMK"+M->UA_NUM
	If nUB_OPC > 0
		Replace C6_OPC  With aLinha[nX][16]
	EndIf
	Replace C6_CODISS  	With SB1->B1_CODISS
	Replace C6_DTVALID 	With aLinha[nX][13]
	Replace C6_WKF1    	With "2"
	Replace C6_WKF2 	With "2"
	Replace C6_WKF3 	With "2"
	Replace C6_PEDPEND	with iif(SUA->UA_XPERLIB > 0,"2",SUA->UA_PEDPEND)//#AFD20180620.n
	Replace C6_MOSTRUA	with aLinha[nX][19]
	Replace C6_01DESME	with aLinha[nX][20]
	If nC6_NUMTMK > 0
		Replace C6_NUMTMK  With xFilial("SUA")+M->UA_NUM
	EndIf
	
	If aLinha[nX][18] = "2"
		Replace C6_01STATU 	With "2"
	Else
		Replace C6_01STATU 	With "1"
	EndIf
	
	//#CMG20180122.bn
	Replace C6_XLIBDES 	With aLinha[nX][23]
	Replace C6_XDESMAX 	With aLinha[nX][24]
	//#CMG20180122.en
	
	If cPrcFiscal == "1"  								// Se o PRECO FISCAL BRUTO = Sim
		Replace C6_PRCVEN With NoRound(aLinha[nX][06] / aLinha[nX][04],nTamDec)
	Else
		Replace C6_PRCVEN  	With aLinha[nX,05] 	// O valor do item ja esta com desconto
		Replace C6_DESCONT 	With Round(aLinha[nX,14],2)
		Replace C6_VALDESC	With Round(aLinha[nX,15],2)
	EndIf
	
	//#CMG20181210.bn
	Replace C6_XPDSBKP 	With Round(aLinha[nX,14],2)
	Replace C6_XVDSBKP	With Round(aLinha[nX,15],2)
	//#CMG20181210.en
	
	//#CMG20180801.bn
	If Round(aLinha[nX,14],2) > Round(aLinha[nX][24],2)
		Replace C6_XWFSN With 'S'
	EndIf
	
	Replace C6_XCHVSUB With aLinha[nX,1]+cNumSC5+aLinha[nX,2]
	//#CMG20180801.en
	
	If _lAgend
		
		Replace C6_01AGEND 	With aLinha[nX][25]
		
	Else
		
		Replace C6_01AGEND 	With '2'
		
	EndIf
	
	If SB1->B1_LOCALIZ == 'S'// .and. !SB1->B1_XACESSO == '1'
		
		//#CMG20181127.bn
		If fVerAgend(aLinha[nX][03], IIF(Alltrim(aLinha[nX][19])=='1',aLinha[nX][10],cLOCGLP), aLinha[nX][04])
			
			_cGetEnd := fRetEnd(aLinha[nX][03], IIF(Alltrim(aLinha[nX][19])=='1',aLinha[nX][10],cLOCGLP), aLinha[nX][04] )
			
		Else
			
			_cGetEnd := ""
			
		EndIf
		//#CMG20181127.en
		
		DbSelectArea("SC6")
		Replace C6_LOCALIZ With _cGetEnd
	Else
		Replace C6_LOCALIZ With ""
	EndIf
	
	SC6->(MsUnlock())
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())
	SC6->(DbSeek(xFilial("SC6")+cNumSC5+cNovoItem))
	
	//Tratamento para atualizar a previsao de saida no SB2. Mesmo liberando logo em seguida
	//é necessario para nao deixar o saldo negativo no B2_QPEDVEN
	//Deo - 21/12/17
	nSldPed := Max(SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP,0)
	nSldPed2:= SB1->(ConvUm(SB2->B2_COD,nSldPed,nSldPed2,2))
	FatAtuEmpN("+")
	RecLock("SB2")
	SB2->B2_QPEDVEN += nSldPed
	SB2->B2_QPEDVE2 += nSldPed2
	SB2->(MsUnlock())
	
	FkCommit() // Commit para integridade referencial do SC5
	
	
	//Empenhar o estoque para pedido diferente do status 'Em Aguardar'
	If cPedPend <> "1"
		cFilAnt:= '0101'
		lAvEst	:= .T.
		MaLibDoFat(SC6->(Recno()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
		cFilAnt:= _cFilBkp
	EndIf
	
	//Diminuo as quantidades previstas na tabela de saldos (B2_01SALPE)
	If aLinha[nX][18]=='3'
		U_AtualB2Pre("-",SC6->C6_QTDVEN,SC6->C6_FILIAL,SC6->C6_PRODUTO,SC6->C6_LOCAL)
	EndIf
	
Next

SB2->(DbCloseArea()) //#CMG20180626.n

if SUA->UA_XRETPAS == '1'
	if MsgYesNo("Identificamos que foi informado que o cliente possui RESTRIÇÃO DE PASSAGEM !!" +ENTER+ENTER;
				+ "O Produto precisa seguir desmontado pela Tapeçaria ?"+ENTER+ENTER;
				+ "OBS: Por favor informar SIM, somente nos casos aonde não seja possivel a realização da desmontagem pelo motorista.","Atenção a Restrição de Passagem.")
		
		lRetPass := .T.

		cObsSUA := U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
		cObsSC5 := U_SyLeSYP(SC5->C5_XCODOBS,TamSx3("C5_XCODOBS")[1])

		cObsRetPas := fRetPas()

		if SUA->(dbseek(cFilAnt + SUA->UA_NUM))
			
			cObsSUA := cObsSUA + CRLF
			cObsSUA += cObsRetPas
			
			recLock("SUA",.F.)
				MSMM(,TamSx3("UA_CODOBS")[1],,cObsSUA,1,,,"SUA","UA_CODOBS")
			SUA->(Msunlock())
		endif

		if SC5->(dbseek('01  ' + cNumSC5))
			
			cObsSC5 := cObsSC5 + CRLF
			cObsSC5 += cObsRetPas

			recLock("SC5",.F.)
				MSMM(,TamSx3("C5_XCODOBS")[1],,cObsSC5,1,,,"SC5","C5_XCODOBS")
			SC5->(Msunlock())
		endif
	endif
endif
//PutMv("MV_ESTNEG","N") // Restaura o parametro

Return

//staticCall(TMKVPED,fRetPas)
Static Function fRetPas()

	Local oBtnConfirm
	Local oGroup
	Local oRadMenu
	Local nRadMenu := 1
	Local oSaytexto
	Local lConfirma := .F.
	Local cMsg := ""
	
	Static oDlgRetPas

	DEFINE MSDIALOG oDlgRetPas TITLE "Restrição de Passagem" FROM 000, 000  TO 190, 390 COLORS 0, 16777215 PIXEL

		@ 066, 004 BUTTON oBtnConfirm PROMPT "Confirmar" SIZE 187, 027 OF oDlgRetPas ACTION {|| lConfirma := .T., oDlgRetPas:end() } PIXEL
		@ 001, 004 GROUP oGroup TO 031, 191 OF oDlgRetPas COLOR 0, 16777215 PIXEL
		@ 006, 007 SAY oSaytexto PROMPT "Identificamos que a opção (Restrição de passagem) foi marcada no orçamento. Por favor informar quais partes do estofado devem seguir desmontados." SIZE 179, 022 OF oDlgRetPas COLORS 13500416, 16777215 PIXEL
		@ 034, 004 RADIO oRadMenu VAR nRadMenu ITEMS "Braço","Encosto","Braço e Encosto" SIZE 187, 028 OF oDlgRetPas COLOR 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlgRetPas CENTERED

	if lConfirma
		
		cMsg := "Observações de Restrição de passagem:" + ENTER
		
		Do Case
			Case nRadMenu == 1
				cMsg += "O estofado deve seguir com o Braço desmontado devido a restrição de passagem, informado na compra."+ ENTER
			Case nRadMenu == 2
				cMsg += "O estofado deve seguir com o Encosto desmontado devido a restrição de passagem, informado na compra."+ ENTER
			Case nRadMenu == 3
				cMsg += "O estofado deve seguir com o Braço e Encosto desmontados devido a restrição de passagem, informado na compra."+ ENTER
		EndCase
	endif

Return cMsg

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GeraSE1  ºAutor  ³Microsiga           º Data ³  17/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as parcelas no financeiro.              			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function GERASE1(cAtende,cPedido,nOpc,cFilAtu,nFator,nLinha,nCredito,cVendedor)				//#RVC20180720.o
Static Function GERASE1(cAtende,cPedido,nOpc,cFilAtu,nFator,nLinha,nCredito,cVendedor,cARQLOG,cDirImp)	//#RVC20180720.n

Local aVencto  := {}
Local aRotAuto := {}
Local aBaixa   := {}
Local aVetorSE2:= {}
Local aCheque  := {}
Local aDados   := {}
Local cNumSA2  := ""
Local cNatRec  := ""
Local cNatTx   := ""
Local cPortado := GetMv("KM_PORTADO",,"C01") // INCLUIDO UM PARAMETRO PARA TRAZER POR PADRAO O BANCO GERADOR DOS TITULOS [E1_PORTADO] - LUIZ EDUARDO F.C. - 16.08.2017
Local cParcela := "0"
Local nVlrParc := 0
Local nValAdm  := 0
Local lGeraTaxa:= .F.
Local lTaxa    := .F.
Local cFilOld  := cFilAnt 	//Gravo a Filial Corrente
Local nI
Local cBanco    := ""
Local cAgencia  := ""
Local cConta    := ""
Local cNatCH    := ""
Local cDescNat  := "" // GRAVA A DESCRICAO DA NATUREZA - LUIZ EDUARDO F.C. - 31/08/2018
Local cCodSAE   := ""
Local cForTX    := ""
Local cLojTX    := ""
Local _cTpBol  	:= Alltrim(GetMv("KH_TPBOLET",,""))
Local cTpPagto	:= SuperGetMV("KH_CPTPPG",.F.,"20") //#RVC20180924.n
Local cDscAdm	:= ""	//#RVC20181206.n
Private nTmpTx	:= 0	//#RVC20180618.n
Private cTpTax	:= "1"	//#RVC20180618.n
Private _cRet	:= "0"	//#RVC20181109.n

SL4->(DbSetOrder(1))
If SL4->(DbSeek(xFilial("SL4") + cAtende + "SIGATMK" ))
	While SL4->(!Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM+Alltrim(SL4->L4_ORIGEM)==xFilial("SL4") + cAtende + "SIGATMK"
		If (SL4->L4_XFORFAT == nLinha) .And. Alltrim(SL4->L4_FORMA)<>"CR"
			//			AAdd( aVencto , {cPedido, SL4->L4_DATA, SL4->L4_VALOR, SL4->L4_FORMA , SUA->UA_CLIENTE, SUA->UA_LOJA , SL4->L4_OBS, SL4->L4_ADMINIS, SL4->L4_AUTORIZ  } )
			
			// Adição 2 campos no array aVencto, no final - Cristiam Rossi em 18/07/2017
			//			AAdd( aVencto , {cPedido, SL4->L4_DATA, SL4->L4_VALOR, SL4->L4_FORMA , SUA->UA_CLIENTE, SUA->UA_LOJA , SL4->L4_OBS, SL4->L4_ADMINIS, SL4->L4_AUTORIZ, SL4->L4_NUMCFID, SL4->L4_CODVP , SL4->L4_XPARC} )	//#RVC20180603.o
			AAdd( aVencto , {cPedido,;			// 1
			SL4->L4_DATA,;		// 2
			SL4->L4_VALOR,;		// 3
			SL4->L4_FORMA,;		// 4
			SUA->UA_CLIENTE,;	// 5
			SUA->UA_LOJA,;		// 6
			SL4->L4_OBS,;		// 7
			SL4->L4_ADMINIS,;	// 8
			SL4->L4_AUTORIZ,;	// 9
			SL4->L4_NUMCFID,;	// 10
			SL4->L4_CODVP,;		// 11
			SL4->L4_XPARC,;		// 12
			SL4->L4_XPARNSU,;	// 13
			SL4->L4_XNCART4,;	// 14
			SL4->L4_XFLAG;		// 15
			} ) //#RVC20180603.n
		ElseIf (SL4->L4_XFORFAT == nLinha) .And. Alltrim(SL4->L4_FORMA)=="CR"
			nCredito += SL4->L4_VALOR
		EndIf
		SL4->(DbSkip())
	End
EndIf

aVencto := aSort(aVencto ,,,{|x,y| x[4] + x[9] + DTOS(x[2]) < y[4] + y[9] + DTOS(y[2])})

If cFilAnt <> cFilAtu
	cFilAnt := cFilAtu
EndIf

If Len(aVencto) > 0
	
	For nI := 1 To Len(aVencto)
		
		//#CMG20180207.n
		If AllTrim(aVencto[nI,4]) $ _cTpBol
			_lBoleto := .T.
		EndIf
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + aVencto[nI,5] + aVencto[nI,6] ))
		
		cNumSA2     := "000129"	//#RVC20181107.n
		lGeraTaxa	:= .F.
		lMsErroAuto := .F.
		aRotAuto 	:= {}
		aVetorSE2   := {}
		lTaxa		:= .F.	//#RVC20181114.n
		nTmpTx		:= 0 	//#RVC20181116.n
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE E ALGUMA FORMA DE PAGAMENTO RELACIONADA A CHEQUE E FAZ UM TRATAMENTO DIFERENCIADO - LUIZ EDUARDO F.C. - 31/01/2018 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF AllTrim(aVencto[nI,4])$ "CH/CHT/CHK"
			//cCodSAE := Right(ALLTRIM(aVencto[nI][7]),3) #AFD20180502.o
			cCodSAE := RetCodSAE(aVencto[nI][7]) //#AFD20180502.n
		Else
			cCodSAE := Left(aVencto[nI][7],3)
		EndIF
		
		DbSelectArea("SAE")
		DbSetOrder(1)
		//If DbSeek(xFilial("SAE") + AvKey(Left(aVencto[nI][7],3),"AE_COD") )
		If DbSeek(xFilial("SAE") + AvKey(cCodSAE,"AE_COD") )
			cNatRec  := SAE->AE_01NAT
			cNatCH   := SAE->AE_01NAT
			cNatTx   := SAE->AE_01NATTX
			cDescNat := SAE->AE_DESC
			cPortado := SAE->AE_XPORTAD // TRAZ O BANCO CADASTRADO NO SAE - LUIZ EDUARDO F.C. - 16.08.2017
			cDscAdm	 := SAE->AE_DESC	//#RVC20181206.n
		EndIf
		
		If Empty(cNatRec)
			If AllTrim(aVencto[nI,4]) == "R$"
				cNatRec := STRTRAN(GetMv("MV_NATDINH"),'"',"")
			ElseIf AllTrim(aVencto[nI,4]) $ "CHT/CHK"
				cNatRec := STRTRAN(GetMv("MV_NATCHEQ"),'"',"")
			Else
				cNatRec := STRTRAN(GetMv("MV_NATOUTR"),'"',"")
			EndIf
		EndIf
		//		cParcela := SOMA1(cParcela,TamSX3("E1_PARCELA")[1])	//#RVC20181107.o
		
		//#RVC20181107.bn
		if IsInCallStack('U_ALTFRMPG')
			if cParcela == "0"
				cParcela := fNewParc(cAtende)
			else
				cParcela := SOMA1(cParcela,TamSX3("E1_PARCELA")[1])
			endIf
		else
			cParcela := SOMA1(cParcela,TamSX3("E1_PARCELA")[1])
		endIf
		//#RVC20181107.en
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ALTERADO PARA QUE PEGUE DE UM PARAMETRO AS INFORMCOES DOS TIPOS DE FORMA DE PAGAMENTO QUE IRAM GERAR O ³
		//³ TITULO A PAGAR DAS TAXAS - LUIZ EDUARDO F.C. - 23.06.2017                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If AllTrim(aVencto[nI,4]) $ "CC|CD"
		If AllTrim(aVencto[nI,4]) $ GetMv("KH_FRMTX",,"CC/CD/BOL/BST")
			lGeraTaxa:= .T.
			nVlrParc := 0
			SAE->(DbSetOrder(1))
			If SAE->(DbSeek(xFilial("SAE")+Left(aVencto[nI,7],TamSx3("AE_COD")[1])))
				If GetMv("MV_KOGERTX")//Desconta a taxa administrativa do valor do titulo.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ COLOCADO UMA VERIFICACAO NO VALOR DA TAXA DA ADMINISTRADORA                  ³
					//³ SE A TAXA ESTIVER ZERADA NAO CRIAR O TITULO - LUIZ EDUARDO F.C. - 23.06.2017 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//If SAE->AE_TAXA > 0
					//					cNumSA2  := IncSA2()	//#RVC20181107.o
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ NAO SERA MAIS GERADO TITULO NO FINANCEIRO DO CONTAS A RECEBER DESCONTADO AS TAXAS   ³
					//³ SERA SEMPRE GERADO COM O VALOR BRUTO. DEIXEI ESTA LINHA COMENTADA PARA QUE NO       ³
					//³ FUTURO SE MUDAREM DE IDEIA A ALTERACAO NO FONTE FOSSE MAIS FACIL - LUIZ EDUARDO F.C.³
					//³ 26/06/2017                                                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//nVlrParc := (aVencto[nI,3] - ((aVencto[nI,3] * SAE->AE_TAXA)/100))
					//nVlrParc := aVencto[nI,3]
					//Else
					nVlrParc := aVencto[nI,3]
					//EndIf
				Else
					nVlrParc := aVencto[nI,3]
				EndIf
				//#RVC20180618.bn
				if !Empty(SAE->AE_TAXA)
					nTmpTx	  := SAE->AE_TAXA
				else
					DbSelectArea("MEN")
					MEN->(DbSetOrder(2))
					MEN->(DbSeek(xFilial("MEN") + SAE->AE_COD))
					While MEN->(!EOF()) .AND. MEN->MEN_FILIAL + MEN->MEN_CODADM == xFilial("MEN") + SAE->AE_COD
						IF VAL(aVencto[nI,12]) >= MEN->MEN_PARINI .AND. VAL(aVencto[nI,12]) <= MEN->MEN_PARFIN
							nTmpTx := MEN->MEN_TAXADM	//#RVC20180618.n
							cTpTax := "2"				//#RVC20180618.n
						EndIF
						MEN->(DbSkip())
					EndDo
				endif
				//#RVC20180618.en
			Else
				nVlrParc := aVencto[nI,3]
			EndIf
		Else
			nVlrParc := aVencto[nI,3]
		EndIf
		
		DbSelectArea("SE1")
		RecLock("SE1",.T.)
		SE1->E1_FILIAL 	:= XFILIAL("SE1")	//cFilAnt
		//SE1->E1_PREFIXO	:= "PED"
		//		SE1->E1_PREFIXO	:= GetMv("KM_PREFIXO") // PEGAR O PREFIXO DO PARAMETRO - LUIZ EDUARDO F.C. - 25.08.2017	//#RVC20180717.o
		SE1->E1_PREFIXO	:= SuperGetMV("KM_PREFIXO",.F.,"ADM")													//#RVC20180717.n
		SE1->E1_NUM		:= aVencto[nI,1]
		SE1->E1_PARCELA	:= cParcela
		SE1->E1_NATUREZ	:= cNatRec
		SE1->E1_TIPO	:= aVencto[nI,4]
		SE1->E1_CLIENTE	:= aVencto[nI,5]
		SE1->E1_LOJA	:= aVencto[nI,6]
		SE1->E1_NOMCLI	:= SA1->A1_NREDUZ
		SE1->E1_EMISSAO	:= dDataBase
		SE1->E1_VENCTO	:= aVencto[nI,2]
		SE1->E1_VENCREA	:= DataValida( aVencto[nI,2] )
		SE1->E1_VENCORI	:= aVencto[nI,2]
		SE1->E1_VALOR	:= aVencto[nI,3]
		SE1->E1_EMIS1	:= dDataBase
		SE1->E1_SITUACA	:= '0'
		SE1->E1_SALDO	:= nVlrParc
		SE1->E1_MOEDA	:= 1
		SE1->E1_OCORREN	:= '01'
		SE1->E1_PEDIDO	:= aVencto[nI,1]
		SE1->E1_VLCRUZ	:= nVlrParc
		SE1->E1_STATUS	:= 'A'
		SE1->E1_ORIGEM	:= 'FINA040'
		SE1->E1_FLUXO	:= 'S'
		SE1->E1_TIPODES	:= '1'
		SE1->E1_FILORIG	:= cFilAnt
		SE1->E1_MULTNAT	:= '2'
		SE1->E1_MSFIL	:= cFilAnt
		SE1->E1_MSEMP	:= cEmpAnt
		SE1->E1_PROJPMS	:= '2'
		SE1->E1_DESDOBR	:= '2'
		SE1->E1_MODSPB	:= '1'
		SE1->E1_SCORGP	:= '2'
		SE1->E1_RELATO 	:= '2'
		SE1->E1_TPDESC	:= 'C'
		SE1->E1_VLMINIS	:= '1'
		SE1->E1_VEND1	:= cVendedor
		
		If AllTrim(aVencto[nI,4]) $ "BOL"
			SE1->E1_DOCTEF	:= Strzero( Val(aVencto[nI,9]) , TAMSX3("E1_DOCTEF")[1] )
		EndIf
		
		//If AllTrim(aVencto[nI,4]) $ "CC|CD|BST"					//#RVC20181207.o
		
		If AllTrim(aVencto[nI,4]) $ "CC|CD|BOL|CHK|R$|DOC|VA"	//#RVC20181207.n
			SE1->E1_ADM		:= Left(aVencto[nI,8],3)
			//			SE1->E1_NSUTEF 	:= Strzero( Val(aVencto[nI,9])	, TAMSX3("E1_NSUTEF")[1] )	//#RVC20180720.o
			//			SE1->E1_DOCTEF	:= Strzero( Val(aVencto[nI,9])	, TAMSX3("E1_DOCTEF")[1] )	//#RVC20180720.o
			SE1->E1_NSUTEF 	:= aVencto[nI,9]											//#RVC20180720.n
			SE1->E1_DOCTEF	:= aVencto[nI,9]											//#RVC20180720.n
			//#RVC20181003.bo
			/*			If cTpTax == '1'
			SE1->E1_01TAXA	:= SAE->AE_TAXA
			Else
			SE1->E1_01TAXA	:= nTmpTx
			EndIf
			*/			//#RVC20181003.eo
			//			SE1->E1_01TAXA  := SAE->AE_TAXA	//#RVC20180327.o
			SE1->E1_01REDE  := SAE->AE_REDE
			SE1->E1_01NORED := Posicione("SX5",1,xFilial("SX5")+"L9" + SAE->AE_REDE,"X5_DESCRI")
			SE1->E1_01OPER  := SAE->AE_COD
			SE1->E1_01NOOPE := SAE->AE_DESC
		elseIf AllTrim(aVencto[nI,4]) $ "CHT|CHK"	// cheques - Cristiam Rossi em 18/07/2017
			SE1->E1_CMC7FIN := aVencto[nI,10]	// CMC7
			SE1->E1_DOCTEF  := aVencto[nI,11]	// autorização TeleCheque
		EndIf
		
		SE1->E1_APLVLMN	:= '1'
		SE1->E1_CPFCNPJ	:= SA1->A1_CGC
		SE1->E1_NUMSUA	:= cAtende
		SE1->E1_PEDPEND	:= '2'
		SE1->E1_01VLBRU := aVencto[nI,3]
		//		SE1->E1_01QPARC	:= Len(aVencto)
		SE1->E1_01QPARC := VAL(aVencto[nI,12])
		//		SE1->E1_XDESCFI := IIF(INCLUI,FWFILIALNAME(cEmpAnt,cFilAnt,1),) #CMG20180329.o
		SE1->E1_XDESCFI := AllTrim(FWFILIALNAME(cEmpAnt,cFilAnt,1))    //#CMG20180329.n
		SE1->E1_PORTADO := cPortado
		SE1->E1_XPARNSU := aVencto[nI,13]	//#RVC20180603.n
		SE1->E1_XNCART4	:= aVencto[nI,14]	//#RVC20180603.n
		SE1->E1_XFLAG	:= aVencto[nI,15]	//#RVC20180603.n
		
		cNatRec := ""  // ZERA A VARIAVEL DE NATUREZA - LUIZ EDUARDO F.C. - 18.08.2017
		
		//		Msunlock()
		If lGeraTaxa
			If EMPTY(SAE->AE_TAXA) //#RVC20180321.n
				DbSelectArea("MEN")
				MEN->(DbSetOrder(2))
				MEN->(DbSeek(xFilial("MEN") + SAE->AE_COD))
				While MEN->(!EOF()) .AND. MEN->MEN_FILIAL + MEN->MEN_CODADM == xFilial("MEN") + SAE->AE_COD
					IF VAL(aVencto[nI,12]) >= MEN->MEN_PARINI .AND. VAL(aVencto[nI,12]) <= MEN->MEN_PARFIN
						nValAdm := aVencto[nI,3]*MEN->MEN_TAXADM
						nTmpTx	:= MEN->MEN_TAXADM					//#RVC20181003.n
						lTaxa   := .T.
						cDscAdm := MEN->MEN_XDESC					//#RVC20181113.n
					EndIF
					MEN->(DbSkip())
				EndDo
			Else										//#RVC20180321.bn
				nValAdm := aVencto[nI,3]*SAE->AE_TAXA
				nTmpTx	:= SAE->AE_TAXA					//#RVC20181003.n
				lTaxa   := .T.
				cDscAdm := SAE->AE_DESC					//#RVC20181113.n
			Endif										//#RVC20180321.en
			//nValAdm := aVencto[nI,3]*SAE->AE_TAXA
			
			cForTX    := SAE->AE_XFORTX
			cLojTX    := SAE->AE_XLJTX
			
		EndIf
		
		SE1->E1_XDSCADM:= cDscAdm 			//#RVC20181206.n
		SE1->E1_01TAXA := nTmpTx			//#RVC20181003.n
		
		SE1->(msUnLock())            //MN20190128 -  Incluso alias para evitar erro ao gravar - CHAMADO 7762
		
		if lTaxa
			
			RecLock("SE2",.T.)
			
			cFornece := IIF(EMPTY(cForTX),cNumSA2,cForTX)
			cLjFornece:= IIF(EMPTY(cLojTX),SE1->E1_LOJA,cLojTX)
			
			SE2->E2_PREFIXO := SuperGetMv("KH_PREFSE2",.F.,"TXA")
			SE2->E2_NUM := SE1->E1_NUM
			SE2->E2_PARCELA := SE1->E1_PARCELA
			SE2->E2_TIPO :=	SE1->E1_TIPO
			SE2->E2_NATUREZ := cNatTx
			SE2->E2_FORNECE := cFornece
			SE2->E2_LOJA :=	cLjFornece
			SE2->E2_EMISSAO := dDataBase
			SE2->E2_VENCTO := SE1->E1_VENCTO
			SE2->E2_VENCREA := SE1->E1_VENCREA
			SE2->E2_VALOR := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_XDESCFI := cFilAnt + " - " + FWFILIALNAME(cEmpAnt,cFilAnt,1)
			SE2->E2_PORTADO := cPortado
			SE2->E2_XNSUTEF := SE1->E1_NSUTEF
			SE2->E2_XPARNSU := SE1->E1_XPARNSU
			SE2->E2_XNCART4 := SE1->E1_XNCART4
			SE2->E2_XFLAG := SE1->E1_XFLAG
			SE2->E2_XTPPAG := cTpPagto
			SE2->E2_01NUMRA := cAtende //#RVC20181004.n	//utilizei este por não estar sendo usado em nenhuma outra rotina
			SE2->E2_HIST :=	AllTrim(SE1->E1_NUM)
			SE2->E2_ORIGEM := "FINA050"
			//----------------------- NOVOS CAMPOS (INCLUIDOS DEVIDO A ROTINA PADRÃO)---------------------------------------------------------------
			SE2->E2_SALDO := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_NOMFOR := Posicione('SA2',1,xFilial('SA2')+cFornece+cLjFornece,'A2_NREDUZ')
			SE2->E2_EMIS1 := dDataBase
			SE2->E2_VENCORI := SE1->E1_VENCORI
			SE2->E2_MOEDA := SE1->E1_MOEDA
			SE2->E2_VLCRUZ := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_RATEIO := "N"
			SE2->E2_FLUXO := "S"
			SE2->E2_OCORREN := "01"
			SE2->E2_DESDOBR := "N"
			SE2->E2_MULTNAT := "2"
			SE2->E2_PROJPMS := "2"
			SE2->E2_DIRF := "2"
			SE2->E2_MODSPB := "1"
			SE2->E2_FILORIG := SE1->E1_FILORIG
			SE2->E2_PRETPIS := "1"
			SE2->E2_PRETCOF := "1"
			SE2->E2_PRETCSL := "1"
			SE2->E2_BASEPIS := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_BASECSL := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_MDRTISS := "1"
			SE2->E2_FRETISS := "1"
			SE2->E2_APLVLMN := "1"
			SE2->E2_BASEISS := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_TEMDOCS := "2"
			SE2->E2_STATLIB := "01"
			SE2->E2_BASEIRF := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_BASECOF := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_DATAAGE := SE1->E1_VENCREA
			SE2->E2_BASEINS := A410Arred((nValAdm)/100 , "L2_VRUNIT")
			SE2->E2_TPDESC := "C"
			
			if FieldPos("E2_XDSCADM") > 0
				SE2->E2_XDSCADM := AllTrim(SE1->E1_XDSCADM)
			endIf
			
			SE2->(msUnLock())
			
		EndIF
		//#RVC20181109.en
		
		If nLinha=="1"
			LjWriteLog( cARQLOG, "2.31 - GERADO TITULO: "+SE1->E1_FILIAL+""+SE1->E1_PREFIXO+""+SE1->E1_NUM+""+SE1->E1_PARCELA+""+SE1->E1_TIPO )
		Else
			LjWriteLog( cARQLOG, "3.31 - GERADO TITULO: "+SE1->E1_FILIAL+""+SE1->E1_PREFIXO+""+SE1->E1_NUM+""+SE1->E1_PARCELA+""+SE1->E1_TIPO )
		EndIf
		
		
		//Alteração para atender a solicitação do Ticket 8137
		If AllTrim(aVencto[nI,4]) $ "R$|DOC"
			
			DbSelectArea("Z02")
			DbSetOrder(1)
			If DbSeek(xFilial("Z02") + AVKEY(aVencto[nI,4],"Z02_FORMA") )
				cBanco   := Z02->Z02_BANCO
				cAgencia := Z02->Z02_AGENCI
				cConta   := Z02->Z02_NUMCON
			Else
				aDados	 := Separa(GetMv("MV_CXFIN"),"/")
				cBanco   := aDados[1]
				cAgencia := aDados[2]
				cConta   := aDados[3]
			EndIf
			
			SE1->(DbSetOrder(1))
			If SE1->(DbSeek(xFilial("SE1") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ))
				aBaixa := {}
				
				//Baixa Titulos em dinheiro
				AADD(aBaixa , {"E1_NUM"			,SE1->E1_NUM		,NIL})
				AADD(aBaixa , {"E1_PREFIXO"		,SE1->E1_PREFIXO	,NIL})
				AADD(aBaixa , {"E1_PARCELA"		,SE1->E1_PARCELA	,NIL})
				AADD(aBaixa , {"E1_TIPO"		,SE1->E1_TIPO		,NIL})
				AADD(aBaixa , {"E1_CLIENTE"		,SE1->E1_CLIENTE	,NIL})
				AADD(aBaixa , {"E1_LOJA"		,SE1->E1_LOJA		,NIL})
				AADD(aBaixa , {"AUTMOTBX"		,"NOR"				,NIL})
				aAdd(aBaixa , {"AUTBANCO"     	,cBanco				,Nil})
				aAdd(aBaixa , {"AUTAGENCIA"     ,cAgencia			,Nil})
				aAdd(aBaixa , {"AUTCONTA"     	,cConta				,Nil})
				AADD(aBaixa , {"AUTDTBAIXA"		,dDataBase			,NIL})
				AADD(aBaixa , {"AUTDTCREDITO"	,dDataBase			,NIL})
				AADD(aBaixa , {"AUTHIST"		,"VALOR RECEBIDO S/ TITULO",NIL})
				aAdd(aBaixa , {"AUTVALREC"     	,SE1->E1_VALOR 		,Nil})
				
				MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 3)
				
				If  lMsErroAuto
					MostraErro()
					DisarmTransaction()
				EndIf
				
			EndIf
			//Realiza o cadastro do cheque na tabela SEF
			
		ElseIf Alltrim(aVencto[nI,4]) $ "CHT|CHK"
			
			aCheque := Separa(aVencto[nI][7],"|")
			
			DbSelectArea("SEF")
			Reclock( "SEF" , .T. )
			REPLACE SEF->EF_FILIAL  	 WITH xFilial("SEF")
			REPLACE SEF->EF_NUM			 WITH aCheque[4]
			REPLACE SEF->EF_BANCO	     WITH aCheque[1]
			REPLACE SEF->EF_AGENCIA 	 WITH aCheque[2]
			REPLACE SEF->EF_CONTA	     WITH aCheque[3]
			REPLACE SEF->EF_VALOR	     WITH SE1->E1_VALOR
			REPLACE SEF->EF_DATA	     WITH dDataBase
			REPLACE SEF->EF_VENCTO		 WITH SE1->E1_VENCTO
			REPLACE SEF->EF_BENEF	  	 WITH SM0->M0_NOMECOM
			REPLACE SEF->EF_CART		 WITH "R"
			//			REPLACE SEF->EF_TEL			 WITH aCheque[6] // #AFD20180517.o
			//			REPLACE SEF->EF_RG		     WITH aCheque[5] // #AFD20180517.o
			REPLACE SEF->EF_TITULO   	 WITH SE1->E1_NUM
			REPLACE SEF->EF_PREFIXO	     WITH SE1->E1_PREFIXO
			REPLACE SEF->EF_TIPO	     WITH SE1->E1_TIPO
			REPLACE SEF->EF_TERCEIR 	 WITH .F.
			REPLACE SEF->EF_HIST	     WITH ""   		  // PARA RDMAKE
			REPLACE SEF->EF_PARCELA  	 WITH SE1->E1_PARCELA
			REPLACE SEF->EF_CLIENTE	     WITH SA1->A1_COD
			REPLACE SEF->EF_LOJACLI	     WITH SA1->A1_LOJA
			REPLACE SEF->EF_CPFCNPJ	     WITH SA1->A1_CGC
			REPLACE SEF->EF_EMITENT	     WITH SA1->A1_NOME
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ID K057 -  GRAVA A NATUREZA NO CHEQUE - LUIZ EDUARDO F.C. - 31/08/2018 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			REPLACE SEF->EF_NATUR	     WITH cNatCH
			REPLACE SEF->EF_XDESCNA	     WITH cDescNat
			MsUnlock()
		EndIf
		
	Next
	
EndIf
//Retorno a Filial Corrente
cFilAnt := cFilOld

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SYRETCF  ³ Autor ³ SYMM CONSULTORIA    ³ Data ³25/06/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida o TES digitado.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SYRETCF(cTes,cCliente,cLoja,cPedido,cFilAtu)

Local aArea		:= GetArea()
Local lRet		:= ( ExistCpo('SF4',cTes,1) .And. cTes > '500' )
Local cCF		:= ""
Local cTipo		:= ""
Local cTipoCli	:= ""
Local aDadosCfo	:= {}
Default cPedido	:= ''

If !lRet
	Help (" ",1,"A410NOTES")
Else
	
	DbSelectArea('SC5')
	DbSetOrder(1)
	If !Empty(cPedido)
		If DbSeek(cFilAtu+cPedido)
			cTipo    := SC5->C5_TIPO
			cTipoCli := SC5->C5_TIPOCLI
		Else
			cTipo    := M->C5_TIPO
			cTipoCli := M->C5_TIPOCLI
		EndIf
	EndIf
	
	DbSelectArea('SA1')
	DbSetOrder(1)
	DbSeek(xFilial('SA1')+cCliente+cLoja)
	
	DbSelectArea('SF4')
	DbSetOrder(1)
	If ( MsSeek(xFilial('SF4')+cTes,.F.) )
		
		If cTipo == 'N'
			Aadd(aDadosCfo,{"OPERNF","S"})
			Aadd(aDadosCfo,{"TPCLIFOR",cTipoCli})
			Aadd(aDadosCfo,{"UFDEST",SA1->A1_EST})
			Aadd(aDadosCfo,{"INSCR" ,SA1->A1_INSCR})
			If SA1->(FieldPos("A1_CONTRIB")) > 0
				Aadd(aDadosCfo,{"CONTR", SA1->A1_CONTRIB})
			EndIf
			cCF := MaFisCfo(,SF4->F4_CF,aDadosCfo)
		EndIf
		
	EndIf
	
EndIf

RestArea(aArea)

Return(cCF)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SyBxNCC  ³ Autor ³ SYMM CONSULTORIA    ³ Data ³25/06/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa NCC do cliente.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Static Function SyBxNCC1(nCredito,cCliente,cLoja,_cFilAtu,cAtende,cPedido)		//#RVC20181030.o
Static Function SyBxNCC1(nCredito,cCliente,cLoja,_cFilAtu,cAtende,cPedido,nCredNCC)	//#RVC20181030.n

Local nX		:= 0
Local aNccItens := {}
Local lOk		:= .T.
Local cAlias 	:= GetNextAlias()
Local cQuery	:= ""

Default nCredNCC := 0 //#RVC20181030.n

//Busca todas NCCs do cliente.

//cQuery := " SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_SALDO,E1_FILIAL FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_CLIENTE = '"+M->UA_CLIENTE+"' AND E1_LOJA = '"+M->UA_LOJA+"' AND E1_STATUS = 'A' AND E1_TIPO IN ('NCC','RA') AND E1_SALDO > 0 AND D_E_L_E_T_ <> '*'  "
cQuery := " SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_SALDO,E1_FILIAL FROM "+RetSqlName("SE1")+" SE1 (NOLOCK) WHERE E1_CLIENTE = '"+cCliente+"' AND E1_LOJA = '"+cLoja+"' AND E1_STATUS = 'A' AND E1_TIPO IN ('NCC','RA') AND E1_SALDO > 0 AND D_E_L_E_T_ <> '*'  "
cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	AAdd( aNccItens , { (cAlias)->E1_NUM , (cAlias)->E1_PREFIXO , (cAlias)->E1_PARCELA , (cAlias)->E1_TIPO , (cAlias)->E1_CLIENTE , (cAlias)->E1_LOJA , (cAlias)->E1_SALDO , (cAlias)->E1_FILIAL }  )
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )
//Ordena do maior para menos valor
aSort(aNccItens,,,{ |x,y| y[7] > x[7] } )

//Realiza a baixa das NCCs
For nX := 1 To Len(aNccItens)
	
	If (nCredito > 0 ) .And. aNccItens[nX,7] <= nCredito
		
		//#RVC20181024.bn
		If Alltrim(aNccItens[nX,4]) $ "NCC"
			nCredNCC += aNccItens[nX,7]
		EndIf
		//#RVC20181024.en
		
		lOk := SyBxNCC2(aNccItens,nX,aNccItens[nX,7],_cFilAtu,cAtende,cPedido)
		If lOk
			nCredito -= aNccItens[nX,7]
		EndIf
		
	ElseIf ( nCredito > 0 ) .And. aNccItens[nX,7] >= nCredito
		
		//#RVC20181024.bn
		If Alltrim(aNccItens[nX,4]) $ "NCC"
			nCredNCC += aNccItens[nX,7]
		EndIf
		//#RVC20181024.en
		
		lOk := SyBxNCC2(aNccItens,nX,nCredito,_cFilAtu,cAtende,cPedido)
		If lOk
			nCredito -= aNccItens[nX,7]
		EndIf
		
	EndIf
	
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SyBxNCC  ³ Autor ³ SYMM CONSULTORIA    ³ Data ³25/06/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa NCC do cliente.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SyBxNCC2(aNccItens,n,nCredito,_cFilAtu,cAtende,cPedido)

Local aBaixa 	:= {}
Local lOk	 	:= .F.
Local cFilOld  	:= cFilAnt 	//Gravo a Filial Corrente
Local cMotBx	:= GetMV("KH_MOTBXRA",,"NOR")

//If cFilAnt <> aNccItens[n][8]
//cFilAnt := aNccItens[n][8]
//EndIf

Private lMsErroAuto := .F.

AADD(aBaixa , {"E1_NUM"			,aNccItens[n][1]	,NIL})
AADD(aBaixa , {"E1_PREFIXO"		,aNccItens[n][2]	,NIL})
AADD(aBaixa , {"E1_PARCELA"		,aNccItens[n][3]	,NIL})
AADD(aBaixa , {"E1_TIPO"		,aNccItens[n][4]	,NIL})
AADD(aBaixa , {"E1_CLIENTE"		,aNccItens[n][5]	,NIL})
AADD(aBaixa , {"E1_LOJA"		,aNccItens[n][6]	,NIL})
AADD(aBaixa , {"AUTMOTBX"		,cMotBx				,NIL})
AADD(aBaixa , {"AUTDTBAIXA"		,dDataBase			,NIL})
AADD(aBaixa , {"AUTDTCREDITO"	,dDataBase			,NIL})
//AADD(aBaixa , {"AUTHIST"		,"PED"+cPedido		,NIL})
AADD(aBaixa , {"AUTHIST"		,GetMv("KM_PREFIXO")+cPedido		,NIL}) // PEGAR O PREFIXO DO PARAMETRO - LUIZ EDUARDO F.C. - 25.08.2017
AADD(aBaixa , {"E1_PEDIDO"		,cPedido			,NIL})			//#RVC20181004.n
AADD(aBaixa , {"E1_NUMSUA"		,cAtende			,NIL})			//#RVC20181004.n
aAdd(aBaixa , {"AUTVALREC"     	,nCredito   		,Nil})			//#RVC20181004.n

MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 3)

If  lMsErroAuto
	MostraErro()
	DisarmTransaction()
Else
	lOk	:= .T.
	//#AFD12072018.BN
	dbselectarea("SE1")
	SE1->(dbsetorder(1))//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
	if SE1->(dbseek(xFilial()+aNccItens[n][2]+aNccItens[n][1]+aNccItens[n][3]+aNccItens[n][4]))
		
		recLock("SE1",.F.)
		SE1->E1_XFILUTI := _cFilAtu
		msUnlock()
		
		if !empty(alltrim(SE1->E1_XPEDORI))
			VrfPendFi(SE1->E1_XPEDORI, cPedido, SE1->E1_01SAC)
			AtuSE1Pedi(SE1->E1_XPEDORI, cPedido)
			//#RVC20181212.bn
		else
			AtuSE1P2(aNccItens,n,cPedido,cAtende)
			//#RVC20181212.en
		endif
		
		//#AFD26072018.BN
		//Atualiza o campo C5_01SAC com o numero do Sac, que foi preenchido na NCC.
		if !empty(alltrim(SE1->E1_01SAC))
			AtuSC5SAC(cPedido, SE1->E1_01SAC)
		endif
		//#AFD26072018.EN
		
	endif
	//#AFD12072018.BE
EndIf

//Retorno a Filial Corrente
//cFilAnt := cFilOld

Return(lOk)

//Atualiza o pedido de venda com numero do SAC quando o pagamento for realizado com NCC originado do SAC ou Devolução originada do SAC.
Static Function AtuSC5SAC(_cPedido, _cNumSAC)

dbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(dbGoTop())

if SC5->(dbSeek(xFilial()+_cPedido))
	recLock("SC5",.F.)
	SC5->C5_01SAC := _cNumSAC
	msUnlock()
endif

Return

//Verifica se o Pedido de origem do NCC esta com bloqueio financeiro.
Static Function VrfPendFi(_cPedOriNCC, _cNewPed, _numSac)

Local aArea := getArea()
Local lBlqFin := .F.
Local cFilial := ""

dbselectarea("SC5")
SC5->(dbsetorder(1))

if SC5->(dbseek(xFilial()+_cPedOriNCC))
	if SC5->C5_PEDPEND == '2'
		nPercentBlq := SC5->C5_XPERLIB
		lBlqFin := .T.
	endif
endif

//Bloqueia o pedido atual, se o pedido de origem
//estiver com bloqueio financeiro.
if lBlqFin
	SC5->(dbGotop())
	if SC5->(dbseek(xFilial()+_cNewPed))
		
		cFilial := SC5->C5_MSFIL
		
		recLock("SC5",.F.)
		SC5->C5_PEDPEND := '2'
		SC5->C5_XPERLIB := nPercentBlq
		SC5->C5_01SAC := _numSac
		msUnlock()
	endif
	
	dbSelectArea("SUA")
	SUA->(dbSetOrder(8))
	SUA->(dbGotop())
	
	if SUA->(dbSeek(cFilial+_cNewPed))
		recLock("SUA",.F.)
		SUA->UA_XPERLIB := nPercentBlq
		msUnlock()
	endif
	
endif

restArea(aArea)

return

//Altera o campo E1_PEDIDO com o numero do novo pedido gerado
//para realizar o controle do bloqueio financeiro
Static Function AtuSE1Pedi(_cPedOri, _cNewPed)

Local cAlias := getNextAlias()
Local cQuery := ""
Local cUpdate := ""
Local nStatus := 0

cQuery := "SELECT * FROM "+ retSqlName("SE1")
cQuery += " WHERE E1_PEDIDO = '"+_cPedOri+"'"
cQuery += " AND E1_TIPO != 'NCC'"
cQuery += " AND D_E_L_E_T_ = ' '"

plsQuery(cQuery,cAlias)

if (cAlias)->(!eof())
	
	cUpdate := "UPDATE "+retSqlName("SE1")+" SET E1_PEDIDO = '"+_cNewPed+"'"
	cUpdate += " WHERE E1_PEDIDO = '"+_cPedOri+"'"
	cUpdate += " AND E1_TIPO != 'NCC'"
	cUpdate += " AND D_E_L_E_T_ = ' '"
	
	nStatus := TcSqlExec(cUpdate)
	
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError())
	endif
	
endif

Return

//Altera o campo E1_PEDIDO com o numero do novo pedido gerado
//para realizar o controle do bloqueio financeiro
//#RVC20181212.bn
Static Function AtuSE1P2(_aVetor,n,cPV,cSUA)

Local cAlias := getNextAlias()
Local cQuery := ""

//		1						2						3					4						5					6					7					8
//	(cAlias)->E1_NUM , (cAlias)->E1_PREFIXO , (cAlias)->E1_PARCELA , (cAlias)->E1_TIPO , (cAlias)->E1_CLIENTE , (cAlias)->E1_LOJA , (cAlias)->E1_SALDO , (cAlias)->E1_FILIAL

cQuery := "SELECT SE1.R_E_C_N_O_ AS RECSE1, E1_NUMSUA FROM "+ retSqlName("SE1") + " (NOLOCK) SE1"
cQuery += " WHERE E1_FILIAL = '"+ _aVetor[n][8] +"'"
cQuery += " AND E1_NUM = '"+ _aVetor[n][1] +"'"
cQuery += " AND E1_PREFIXO = '"+ _aVetor[n][2] +"'"
//cQuery += " AND E1_TIPO IN ('RA','NCC')"
cQuery += " AND E1_CLIENTE = '"+ _aVetor[n][5] +"'"
cQuery += " AND E1_LOJA = '"+ _aVetor[n][6] +"'"
cQuery += " AND D_E_L_E_T_ = ' '"

plsQuery(cQuery,cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

dbSelectArea("SE1")
SE1->(dbGoTop())

While (cAlias)->(!eof())
	
	If (cAlias)->E1_NUMSUA == cSUA
		
		SE1->(dbGoTo((cAlias)->RECSE1))
		
		RecLock("SE1",.F.)
		SE1->E1_PEDIDO := cPV
		MsUnLock()
		
	ElseIf Empty((cAlias)->E1_NUMSUA)
		
		SE1->(dbGoTo((cAlias)->RECSE1))
		
		RecLock("SE1",.F.)
		SE1->E1_PEDIDO := cPV
		SE1->E1_NUMSUA := cSUA
		MsUnLock()
		
	EndIf
	(cAlias)->(dbSkip())
EndDo

Return
//#RVC20181212.en

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IncSA2 	  º Autor ³ Vendas Clientes  º Data ³  28/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui um registro no SA2.								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ IncSA2()	  					                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nil			                                    	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ ExpC1 = Codigo do Fornecedor                        	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigaloja                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncSA2()

Local cNextCodfo	:= ""	//Proximo codigo livre do cadastro de fornecedores

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procura a Adm. financeira no cadastro de ³
//³fornecedores atraves do campo A2_CODADM  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA2")
DbOrderNickName('SYTM0001') //A2_FILIAL+A2_CODADM
If !(dbSeek(xFilial("SA2")+SAE->AE_COD))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nao encontrou Adm financeira no campo A2_CODADM, agora                  ³
	//³agora verifica se o codigo no cadastro de forcedores ja esta sendo usado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA2")
	DbSetOrder(1)  //A2_FILIAL+A2_COD+A2_LOJA
	If !(dbSeek(xFilial("SA2")+PadR(AllTrim(UPPER(SAE->AE_COD)),TamSX3("A2_COD")[1])+"01"))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³O codigo no cadastro de fornecedores esta livre, entao         ³
		//³cria o registro de fornecedores com o codigo da Adm. financeira³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SA2", .T.)
		SA2->A2_FILIAL  := xFilial("SA2")
		SA2->A2_COD 	:= SAE->AE_COD
		SA2->A2_LOJA	:= "01"
		SA2->A2_NOME	:= SAE->AE_DESC
		SA2->A2_NREDUZ  := SAE->AE_DESC
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda o codigo da Administradora Financeira.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SA2->A2_CODADM  := SAE->AE_COD
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Insere A2_TIPO de acordo com o Pais³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "CHI|PAR"
			SA2->A2_TIPO	:= "A"
		ElseIf cPaisLoc $ "MEX|POR|EUA|DOM|COS|COL"
			SA2->A2_TIPO	:= "1"
		ElseIf cPaisLoc $ "URU|BOL"
			SA2->A2_TIPO	:= "2"
		Else
			SA2->A2_TIPO	:= "J"
		EndIf
		MsUnlock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A Administradora financeira foi cadastrada    ³
		//³como fornecedor retorna o codigo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Return SAE->AE_COD
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³O codigo no cadastro de fornecedores esta em uso, entao        ³
		//³cria o registro de fornecedores com o ultimo codigo + 1        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA2")
		DbSetOrder(1) //A2_FILIAL
		If (dbSeek(xFilial("SA2")))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona no ultimo registro de fornecedores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA2->(dbGoBottom())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pegue o ultimo registro de fornecedores + 1 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNextCodfo := Soma1(SA2->A2_COD)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava o Registro na SA2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SA2", .T.)
			SA2->A2_FILIAL  := xFilial("SA2")
			SA2->A2_COD 	:= cNextCodfo
			SA2->A2_LOJA	:= "01"
			SA2->A2_NOME	:= SAE->AE_DESC
			SA2->A2_NREDUZ  := SAE->AE_DESC
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Guarda o codigo da Administradora Financeira.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA2->A2_CODADM  := SAE->AE_COD
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Insere A2_TIPO de acordo com o Pais³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc $ "CHI|PAR"
				SA2->A2_TIPO	:= "A"
			ElseIf cPaisLoc $ "MEX|POR|EUA|DOM|COS|COL"
				SA2->A2_TIPO	:= "1"
			ElseIf cPaisLoc $ "URU|BOL"
				SA2->A2_TIPO	:= "2"
			Else
				SA2->A2_TIPO	:= "J"
			EndIf
			MsUnlock()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A Administradora financeira foi cadastrada    ³
			//³como fornecedor retorna o codigo              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Return cNextCodfo
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A Administradora financeira ja esta cadastrada³
	//³como fornecedor retorna o codigo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Return SA2->A2_COD
EndIf

Return (cNextCodfo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SyLeSYP  ³ Autor ³ SYMM CONSULTORIA    ³ Data ³24/11/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorno texto gravado por campo Memo.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SyLeSYP(cCodChav,nTam)

Local cAlias 	:= GetNextAlias()
Local cTexto := ""
Local cLine  := ""
Local nPos	 := 0
Local nPos2	 := 0

cQuery := " SELECT YP_TEXTO AS TEXTO FROM "+RetSqlName("SYP")+" SYP (NOLOCK) WHERE YP_FILIAL = '"+xFilial("SYP")+"' AND YP_CHAVE = '"+cCodChav+"' AND D_E_L_E_T_ <> '*'  "
cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())
While (cAlias)->(!Eof())
	
	nPos := At("\13\10",Subs((cAlias)->TEXTO,1,nTam+6))
	If ( nPos == 0 )
		cLine := RTrim(Subs((cAlias)->TEXTO,1,nTam))
		If ( nPos2 := At("\14\10", cLine) ) > 0
			cTexto += StrTran( cLine, "\14\10", Space(6) )
		Else
			cTexto += cLine
		EndIf
	Else
		cTexto += Subs((cAlias)->TEXTO,1,nPos-1) + CRLF
	EndIf
	
	(cAlias)->(DbsKIP())
End
(cAlias)->( dbCloseArea() )

Return(cTexto)


//------------------
Static Function TrataDesc()		// rotina de tratamento dos descontos e ponto de pedido - Cristiam Rossi em 21/06/2017
Local aArea    := getArea()
Local aAreaSC6 := SC6->( getArea() )
Local aItens   := {}
Local cMES     := StrZero( Month( dDatabase ), 2 )
Local cProd
Local nQtd
Local nI
//Local nMAXdesc := getMV("GL_MAXDESC")
Local nMAXdesc := GetMv("KH_DESMAXI")
Local nDESCPER := getMV("GL_DESCPER")
Local lBloqPV  := .F.
Local lPersona := .F.
Local _nDesc   := 0 //CMG20180123.n
Local _nDescP  := 0 //CMG20180123.n
Local _lWFTp  := .F.//Define o tipo do WF se foi por desconto maior que o limite ou maior que a liberado pela condição

If SC5->C5_LIBEROK == "S" .And. SC5->C5_NOTA == Repl("X",Len(SC5->C5_NOTA)) .and. empty(SC5->C5_BLQ)	// eliminado por resíduo
	Return Nil
EndIf

DbSelectArea("SB1")
SB1->(DbSetOrder(1))	// B1_FILIAL+B1_COD

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbGoTop())
SC5->(DbSeek(xFilial("SC5")+SUA->UA_NUMSC5))  //#CMG20180803.n

DbSelectArea("SC6")
SC6->(DbSetOrder(1))	// C6_FILIAL+C6_NUM+C6_ITEM
SC6->(DbGoTop())
SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM+"01")))

While ! SC6->(EOF()) .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)
	cProd  := SC6->C6_PRODUTO
	If SB1->(DbSeek(xFilial("SB1")+cProd)) .And. SB1->B1_TIPO == "ME"
		nQtd   := SC6->C6_QTDVEN
		nQtd   -= SC6->C6_XQTD		// abatendo Qtd já registrada no Consumo Médio
		
		If ! Empty( SC6->C6_BLQ ) .and. nQtd > 0
			nQtd *= -1
		EndIf
		
		AADD( aItens, { cProd, nQtd } )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ INCLUIDO TRATAMENTO PARA VERIFICAR O DESCONTO PARA ITENS PERSONALIZADOS - LUIZ EDUARDO F.C. - 11.08.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC6->C6_PERSONA == "1"
			If SC6->C6_DESCONT > nDESCPER
				lPersona := .T.
			EndIf
		Else
			If SC6->C6_XPDSBKP > _nDesc
				_nDesc  := SC6->C6_XPDSBKP
				_nDescP := SC6->C6_XDESMAX
			EndIf
		EndIf
		
		RecLock("SC6", .F.)				// atualizando o campo C6_XQTD
		SC6->C6_XQTD := SC6->C6_QTDVEN
		MsUnlock()
		
	EndIf
	
	SC6->(DbSkip())
	
EndDo

//#CMG20180123.n
If _nDesc > _nDescP
	
	lBloqPV := .T.
	
	If _nDesc > nMAXdesc
		
		_lWFTp := .T.
		
	EndIf
	
EndIf

SB3->( dbSetOrder(1) )	// B3_FILIAL+B3_COD
For nI := 1 to len(aItens)
	If aItens[nI][2] != 0
		If ! SB3->( dbSeek( xFilial("SB3") + aItens[nI][1] ) )
			recLock("SB3",.T.)
			SB3->B3_FILIAL := xFilial("SB3")
			SB3->B3_COD    := aItens[nI][1]
			SB3->B3_MES    := dDatabase
		else
			recLock("SB3",.F.)
		EndIf
		&("SB3->B3_Q"+cMES) := &("SB3->B3_Q"+cMES) + aItens[nI][2]
		msUnlock()
	EndIf
Next nI

RecLock("SC5", .F.)

If lPersona
	SC5->C5_XLIBER := 'B'
ElseIf lBloqPV
	SC5->C5_XLIBER := 'B'
Else
	SC5->C5_XLIBER := 'L'
EndIf
SC5->C5_XLIBUSR := ""
SC5->C5_XLIBDH  := ""
SC5->(MsUnlock())

If lBloqPV		// gerar WF p/ aprovador
	cPara     := superGetMV( "GL_APRMAIL", , "aprendiz_cris@yahoo.com.br" )
	cAssunto  := "WorkFlow de aprovação - desconto do pedido de venda"
	//	cMensagem := U_WFintPV( .F., SC5->C5_NUM , .F. )//#CMG20180123.o
	U_KMFATF02( .F., SC5->C5_NUM,_lWFTp )//#CMG20180123.n
	//	Processa( { || U_sendMail( cPara, cAssunto, cMensagem ) }  ,"Aguarde"   ,"Enviando e-mail...")//#CMG20180123.o
EndIf

If lPersona		// gerar WF p/ aprovador
	cPara     := superGetMV( "GL_APRMAIL", , "aprendiz_cris@yahoo.com.br" )
	cAssunto  := "WorkFlow de aprovação - desconto do pedido de venda - ITENS PERSONALIZADOS"
	//	cMensagem := U_WFintPV( .F., SC5->C5_NUM , .T.)//#CMG20180123.o
	U_KMFATF02( .F., SC5->C5_NUM,_lWFTp )//#CMG20180123.n
	//	Processa( { || U_sendMail( cPara, cAssunto, cMensagem ) }  ,"Aguarde"   ,"Enviando e-mail...")//#CMG20180123.o
EndIf

SC6->( restArea( aAreaSC6 ) )
restArea( aArea )

return nil

/*--------------------------------------------
@Função: CriaPedido()
@Autor: Eduardo Patriani
@Data: 15/02/2018
@Hora: 14:36:12
@Versão: 1.0
@Uso: Komfort House
@Descrição: Cria Pedido de Venda
---------------------------------------------
--------------------------------------------*/
Static Function CriaPedido(cAtende,cTPEntrega,aLinha,cFilAtu,cPedido)

Local aArea		:= GetArea()

Local cNumSC5    	:= ""
Local cMay       	:= ""
Local cCliente		:= ""
Local cLojaCli		:= ""
Local cDesc		:= ""
Local cPersona		:= ""
Local cItemPc    	:= "00"
Local cTES			:= ""
Local cContrato		:= ""
Local cLocal		:= ""
Local cPrcFiscal	:= TkPosto(M->UA_OPERADO,"U0_PRECOF")	// Preco Fiscal Bruto = S ou N - Posto de Venda
Local cOBS1			:= U_SyLeSYP(SUA->UA_CODOBS,TamSx3("UA_OBS")[1])
Local cFlBkp    	:= cFilAnt

Local nPrcVen		:= 0

Local aCabPv	  	:= {}
Local aItemPV    	:= {}
Local aItemSC6   	:= {}
Local aPedido		:= {}

Local lCredito		:= .T.
Local lEstoque		:= .T.
Local lAvCred		:= .F.
Local lAvEst		:= .F.
Local lLiber		:= .T.
Local lTransf    	:= .F.
Local lRetEnv		:= .F.

Local aAreaSA1      := SA1->(GetArea())
Local aAreaSC5      := SC5->(GetArea())
Local aAreaSC6      := SC6->(GetArea())
Local aAreaSB2      := SB2->(GetArea())

Private lMSHelpAuto := .T.
Private lMsErroAuto := .F.

cFilAnt := cLocDep

DbSelectArea("SC5")
DbSetOrder(1)

cNumSC5 := GetSxeNum("SC5","C5_NUM")

cMay := "SC5"+ALLTRIM(cFilAtu)+cNumSC5
While (DbSeek(cFilAtu+cNumSC5) .OR. !MayIUseCode(cMay))
	cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
	cMay 	:= "SC5"+ALLTRIM(cFilAtu)+cNumSC5
End
If __lSX8
	ConfirmSX8()
EndIf

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)

cContrato := IF(Empty(M->UA_CONTRA),"000",M->UA_CONTRA)

aCabPV:= {	{"C5_NUM" 			, cNumSC5 	        				,Nil},;
{"C5_TIPO" 		, "N"									,Nil},;
{"C5_CLIENTE"		, M->UA_CLIENTE 					,Nil},;
{"C5_LOJACLI"		, M->UA_LOJA   						,Nil},;
{"C5_CONDPAG"		, M->UA_CONDPG						,Nil},;
{"C5_EMISSAO"		, dDataBase							,Nil},;
{"C5_TIPOCLI"		, M->UA_TIPOCLI						,Nil},;
{"C5_01TPOP"		, "1"								,Nil},;
{"C5_TRANSP"		, M->UA_TRANSP						,Nil},;
{"C5_01SAC"		, M->UA_01SAC							,Nil},;
{"C5_MOEDA"  		, 1        							,Nil},;
{"C5_TABELA"  		, M->UA_TABELA						,Nil},;
{"C5_VEND1"   		, M->UA_VEND						,Nil},;
{"C5_FRETE"   		, nVlFre01							,Nil},;
{"C5_DESPESA" 		, nVlDesp1							,Nil},;
{"C5_DESCONT" 		, nVlDes01							,Nil},;
{"C5_TPCARGA"		, '1'								,Nil},;// wellington raul 20200121 trava para que o pedido sempre utilize carga 
{"C5_DESC1"   		, M->UA_DESC1						,Nil},;
{"C5_DESC2"   		, M->UA_DESC2						,Nil},;
{"C5_DESC3"   		, M->UA_DESC3						,Nil},;
{"C5_DESC4"   		, M->UA_DESC4						,Nil},;
{"C5_ORCRES"  		, cAtende							,Nil},;
{"C5_XDESCFI" 		, FWFILIALNAME(CEMPANT,CFILANT,1)	,Nil},;
{"C5_CONTRA" 		, cContrato							,Nil},;
{"C5_PEDPEND"		, SUA->UA_PEDPENDS					,Nil},;
{"C5_NUMTMK"		, cAtende							,Nil}}


For nX := 1 To Len(aLinha)
	
	cItemPC	 := Soma1(cItemPC)
	
	If cPrcFiscal == "1"	//Se o PRECO FISCAL BRUTO = Sim
		nPrcVen := NoRound(aLinha[nX][06] / aLinha[nX][04],nTamDec)
	Else
		nPrcVen := aLinha[nX][05] //O valor do item ja esta com desconto
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA CLIENTES FORA DO ESTADO NAO CONTRIBUINTES - LUIZ EDUARDO F.C. - 12.07.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALLTRIM(SA1->A1_EST) <> "SP"
		If SA1->A1_CONTRIB == "2"
			cTES := cTESCont
		EndIf
	Else
		cTES := If( !Empty(SB1->B1_TSESPEC) , SB1->B1_TSESPEC , aLinha[nX][08])
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TRATAMENTO PARA GRAVAR A DESCRICAO DO PRODUTO PERSONALIZADO - LUIZ EDUARDO F.C. - 11.08.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aLinha[nX][03] ))
	
	If !Empty(aLinha[nX,22])
		cDesc 		:= ALLTRIM(SB1->B1_DESC) + "  //  " + ALLTRIM(aLinha[nX,22])
		cPersona 	:= "1"
	Else
		cDesc 		:= SB1->B1_DESC
		cPersona 	:= "2"
	EndIf
	
	//cLocal := RetLocal()
	cLocal := aLinha[nX][10]
	
	aItemSC6	:= {	{"C6_NUM"  		, cNumSC5								,Nil},;
	{"C6_ITEM"   		, cItemPc	    						,Nil},;
	{"C6_CLI"    		, M->UA_CLIENTE						,Nil},;
	{"C6_LOJA"   		, M->UA_LOJA  							,Nil},;
	{"C6_ENTREG" 		, aLinha[nX][07]    					,Nil},;
	{"C6_PRODUTO"		, aLinha[nX][03]						,Nil},;
	{"C6_DESCRI"  		, cDesc									,Nil},;
	{"C6_PERSONA" 		, cPersona								,Nil},;
	{"C6_LOCAL"  		, cLocal								,Nil},;
	{"C6_QTDVEN" 		, aLinha[nX][04]						,Nil},;
	{"C6_PRUNIT" 		, aLinha[nX][12]						,Nil},;
	{"C6_PRCVEN" 		, nPrcVen								,Nil},;
	{"C6_DESCONT" 		, aLinha[nX][14]						,Nil},;
	{"C6_VALDESC"		, aLinha[nX][15]						,Nil},;
	{"C6_VALOR"  		, aLinha[nX][06]						,Nil},;
	{"C6_TES"			, cTES									,Nil},;
	{"C6_QTDLIB"		, 0						,Nil},;
	{"C6_PEDCLI" 		, "TMK"+M->UA_NUM						,Nil},;
	{"C6_WKF1"    		, "2"									,Nil},;
	{"C6_WKF2" 		, "2"									,Nil},;
	{"C6_WKF3" 		, "2"									,Nil},;
	{"C6_PEDPEND"		, M->UA_PEDPEND						,Nil},;
	{"C6_MOSTRUA"		, aLinha[nX][19]						,Nil},;
	{"C6_01DESME"		, aLinha[nX][20]						,Nil},;
	{"C6_NUMTMK"  		, xFilial("SUA")+M->UA_NUM			,Nil},;
	{"C6_01STATU" 		, If(aLinha[nX][18]="2","2","1")	,Nil},;
	{"C6_01AGEND"		, "2"									,Nil},;
	{"C6_XLIBDES"		, aLinha[nX][23]						,Nil},;
	{"C6_XDESMAX" 		, aLinha[nX][24]						,Nil}}
	
	//						{"C6_QTDLIB"		, aLinha[nX][04]						,Nil},;
	
	
	Aadd(aItemPv,aClone(aItemSC6))
Next

MsExecAuto({|x,y,z| mata410(x,y,z)},aCabPV,aItemPv,3)

If lMsErroAuto
	MostraErro()
	Return(.F.)
Else
	ConFirmSX8()
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	IF DbSeek(xFilial("SC5")+cNumSC5)
		If !Empty(cOBS1)
			MSMM(,TamSx3("C5_XCODOBS") [1],,cOBS1,1,,,"SC5","C5_XCODOBS")
		EndIf
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a liberacao do pedido sem avaliacao de credito e estoque. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC6")
	DbSetOrder(1)
	IF DbSeek(xFilial("SC6")+cNumSC5)
		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNumSC5
			MaLibDoFat(SC6->(Recno()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
			DbSelectArea("SC6")
			DbSkip()
		EndDo
	EndIF
	
	//Atualizo o numero do pedido e do atendimento para gerar a NF  - MV_OPFAT = "S"
	AADD(aPedido,{M->UA_NUM,cNumSc5})
	
	//Atualizo o numero do pedido no SUA
	DbSelectArea("SUA")
	SUA->(RecLock("SUA",.F.))
	Replace UA_NUMSC5 With cNumSC5
	SUA->(MsUnlock())
	
	cPedido := cNumSC5
	
	MsgInfo("Pedido criado com sucesso. Número : " + cNumSC5 + " - Filial : " + cFilAnt ,"Atenção")
EndIF

cFilAnt := cFlBkp

RestArea(aArea)
RestArea(aAreaSA1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSB2)

RETURN()

/*--------------------------------------------
@Função: CriaTitulo()
@Autor: Eduardo Patriani
@Data: 15/02/2018
@Hora: 14:35:06
@Versão: 1.0
@Uso: Komfort House
@Descrição: Gera as parcelas no financeiro
---------------------------------------------
--------------------------------------------*/
Static Function CriaTitulo(cAtende,cPedido,nOpc,cFilAtu,nFator,nLinha,nCredito,cVendedor)

Local cNumSA2  	:= ""
Local cLojaSA2  := ""
Local cNatRec  	:= ""
Local cNatTx   	:= ""
Local cBanco   	:= ""
Local cAgencia 	:= ""
Local cConta   	:= ""
Local cNatCH   	:= ""
Local cCodSAE  	:= ""
Local cForTX   	:= ""
Local cLojTX   	:= ""
Local cParcela 	:= "0"
Local cDescNat 	:= "" 								//GRAVA A DESCRICAO DA NATUREZA - LUIZ EDUARDO F.C. - 31/08/2018
Local cFilOld  	:= cFilAnt 							//Gravo a Filial Corrente
Local cPortado 	:= GetMv("KM_PORTADO",,"C01") 		//INCLUIDO UM PARAMETRO PARA TRAZER POR PADRAO O BANCO GERADOR DOS TITULOS [E1_PORTADO] - LUIZ EDUARDO F.C. - 16.08.2017
Local cTpPagto	:= SuperGetMV("KH_CPTPPG",.F.,"20") //#RVC20180924.n

Local nModOld	:= nModulo
Local nVlrParc 	:= 0
Local nVlrBrut	:= 0
Local nValAdm  	:= 0
Local nI			:= 0

Local aVencto  	:= {}
Local aRotAuto 	:= {}
Local aBaixa   	:= {}
Local aVetorSE2	:= {}
Local aCheque  	:= {}
Local aDados   	:= {}

Local lGeraTaxa	:= .F.

nModulo := 06

SL4->(DbSetOrder(1))
If SL4->(DbSeek(xFilial("SL4") + cAtende + "SIGATMK" ))
	While SL4->(!Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM+Alltrim(SL4->L4_ORIGEM)==xFilial("SL4") + cAtende + "SIGATMK"
		If (SL4->L4_XFORFAT == nLinha) .And. Alltrim(SL4->L4_FORMA)<>"CR"
			AAdd( aVencto , {cPedido,; 			// 1
			SL4->L4_DATA,; 		// 2
			SL4->L4_VALOR,; 	// 3
			SL4->L4_FORMA,; 	// 4
			SUA->UA_CLIENTE,; 	// 5
			SUA->UA_LOJA,; 		// 6
			SL4->L4_OBS,; 		// 7
			SL4->L4_ADMINIS,; 	// 8
			SL4->L4_AUTORIZ,; 	// 9
			SL4->L4_NUMCFID,; 	// 10
			SL4->L4_CODVP; 		// 11
			} )
			
			nVlrBrut += SL4->L4_VALOR
		ElseIf (SL4->L4_XFORFAT == nLinha) .And. Alltrim(SL4->L4_FORMA)=="CR"
			nCredito += SL4->L4_VALOR
			nVlrBrut += SL4->L4_VALOR
		EndIf
		SL4->(DbSkip())
	End
EndIf

aVencto := aSort(aVencto ,,,{|x,y| x[4]+DTOS(x[2]) < y[4]+DTOS(y[2])})

If Len(aVencto) > 0
	
	For nI := 1 To Len(aVencto)
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + aVencto[nI,5] + aVencto[nI,6] ))
		
		//cNumSA2     	:= ""	//#RVC20180721.o
		cNatRec 		:= ""	//ZERA A VARIAVEL DE NATUREZA - LUIZ EDUARDO F.C. - 18.08.2017
		aRotAuto 		:= {}
		aVetorSE2   	:= {}
		lGeraTaxa		:= .F.
		lMsErroAuto 	:= .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE E ALGUMA FORMA DE PAGAMENTO RELACIONADA A CHEQUE E FAZ UM TRATAMENTO DIFERENCIADO - LUIZ EDUARDO F.C. - 31/01/2018 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF AllTrim(aVencto[nI,4])$ "CH/CHT/CHK"
			cCodSAE := Right(ALLTRIM(aVencto[nI][7]),3)
		Else
			cCodSAE := Left(aVencto[nI][7],3)
		EndIF
		
		DbSelectArea("SAE")
		DbSetOrder(1)
		If DbSeek(xFilial("SAE") + AvKey(cCodSAE,"AE_COD") )
			cNatRec  := SAE->AE_01NAT
			cNatCH   := SAE->AE_01NAT
			cNatTx   := SAE->AE_01NATTX
			cDescNat := SAE->AE_DESC
			cPortado := SAE->AE_XPORTAD // TRAZ O BANCO CADASTRADO NO SAE - LUIZ EDUARDO F.C. - 16.08.2017
		EndIf
		
		If Empty(cNatRec)
			If AllTrim(aVencto[nI,4]) == "R$"
				cNatRec := STRTRAN(GetMv("MV_NATDINH"),'"',"")
			ElseIf AllTrim(aVencto[nI,4]) $ "CHT/CHK"
				cNatRec := STRTRAN(GetMv("MV_NATCHEQ"),'"',"")
			Else
				cNatRec := STRTRAN(GetMv("MV_NATOUTR"),'"',"")
			EndIf
		EndIf
		cParcela := SOMA1(cParcela,TamSX3("E1_PARCELA")[1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ALTERADO PARA QUE PEGUE DE UM PARAMETRO AS INFORMCOES DOS TIPOS DE FORMA DE PAGAMENTO QUE IRAM GERAR O ³
		//³ TITULO A PAGAR DAS TAXAS - LUIZ EDUARDO F.C. - 23.06.2017                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If AllTrim(aVencto[nI,4]) $ GetMv("KH_FRMTX",,"CC/CD/BOL/BST")
			nVlrParc := 0
			SAE->(DbSetOrder(1))
			If SAE->(DbSeek(xFilial("SAE")+Left(aVencto[nI,7],TamSx3("AE_COD")[1])))
				If GetMv("MV_KOGERTX")//Desconta a taxa administrativa do valor do titulo.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ COLOCADO UMA VERIFICACAO NO VALOR DA TAXA DA ADMINISTRADORA                  ³
					//³ SE A TAXA ESTIVER ZERADA NAO CRIAR O TITULO - LUIZ EDUARDO F.C. - 23.06.2017 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SAE->AE_TAXA > 0
						//cNumSA2  	:= IncSA2()	//#RVC20180721.o
						cNumSA2 := "000129"
						cLojaSA2 := "01"
						lGeraTaxa := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ NAO SERA MAIS GERADO TITULO NO FINANCEIRO DO CONTAS A RECEBER DISCONTADO AS TAXAS   ³
						//³ SERA SEMPRE GERADO COM O VALOR BRUTO. DEIXEI ESTA LINHA COMENTADA PARA QUE NO       ³
						//³ FUTURO SE MUDAREM DE IDEIA A ALTERACAO NO FONTE FOSSE MAIS FACIL - LUIZ EDUARDO F.C.³
						//³ 26/06/2017                                                                          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nVlrParc := aVencto[nI,3]
					Else
						nVlrParc := aVencto[nI,3]
					EndIf
				Else
					nVlrParc := aVencto[nI,3]
				EndIf
			Else
				nVlrParc := aVencto[nI,3]
			EndIf
		Else
			nVlrParc := aVencto[nI,3]
		EndIf
		
		AAdd( aRotAuto, { "E1_PREFIXO"	, GetMv("KM_PREFIXO")				, NIL } )		// PEGAR O PREFIXO DO PARAMETRO - LUIZ EDUARDO F.C. - 25.08.2017
		AAdd( aRotAuto, { "E1_NUM"    	, aVencto[nI,1]					, NIL } )
		AAdd( aRotAuto, { "E1_TIPO"   	, aVencto[nI,4]					, NIL } )
		AAdd( aRotAuto, { "E1_NATUREZ"	, cNatRec							, NIL } )
		AAdd( aRotAuto, { "E1_PARCELA"	, cParcela							, NIL } )
		AAdd( aRotAuto, { "E1_CLIENTE"	, aVencto[nI,5]					, NIL } )
		AAdd( aRotAuto, { "E1_LOJA"   	, aVencto[nI,6]					, NIL } )
		AAdd( aRotAuto, { "E1_EMISSAO"	, dDataBase						, NIL } )
		AAdd( aRotAuto, { "E1_VENCTO" 	, aVencto[nI,2]					, NIL } )
		AAdd( aRotAuto, { "E1_VENCREA"	, DataValida( aVencto[nI,2] )	, NIL } )
		AAdd( aRotAuto, { "E1_VALOR"  	, aVencto[nI,3]					, NIL } )
		AAdd( aRotAuto, { "E1_PEDIDO"  	, aVencto[nI,1]					, NIL } )
		AAdd( aRotAuto, { "E1_VEND1"  	, cVendedor						, NIL } )
		
		IF AllTrim(aVencto[nI,4]) $ "BOL"
			AAdd( aRotAuto, { "E1_DOCTEF"  	, Strzero( Val(aVencto[nI,9]) , TAMSX3("E1_DOCTEF")[1] )						, NIL } )
		EndIf
		
		If AllTrim(aVencto[nI,4]) $ "CC|CD|BST"
			
			AAdd( aRotAuto, { "E1_ADM"		, Left(aVencto[nI,8],3)														, "AlwaysTrue()" } )
			//			AAdd( aRotAuto, { "E1_NSUTEF"	, Strzero( Val(aVencto[nI,9]) , TAMSX3("E1_NSUTEF")[1] )					, "AlwaysTrue()" } )	//#RVC20180720.o
			//			AAdd( aRotAuto, { "E1_DOCTEF"	, Strzero( Val(aVencto[nI,9]) , TAMSX3("E1_DOCTEF")[1] )					, "AlwaysTrue()" } )	//#RVC20180720.o
			AAdd( aRotAuto, { "E1_NSUTEF"	, aVencto[nI,9]																, "AlwaysTrue()" } )	//#RVC20180720.n
			AAdd( aRotAuto, { "E1_DOCTEF"	, aVencto[nI,9]																, "AlwaysTrue()" } )	//#RVC20180720.n
			AAdd( aRotAuto, { "E1_01TAXA"	, SAE->AE_TAXA																, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_01REDE"	, SAE->AE_REDE																, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_01NORED"	, Posicione("SX5",1,xFilial("SX5")+"L9" + SAE->AE_REDE,"X5_DESCRI")			, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_01OPER"	, SAE->AE_COD																, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_01NOOPE"	, SAE->AE_DESC																, "AlwaysTrue()" } )
			//#RVC20180720.bn
			If cTpTax == '1'
				AAdd( aRotAuto, { "E1_01TAXA"	, SAE->AE_TAXA	, "AlwaysTrue()" } )
			Else
				AAdd( aRotAuto, { "E1_01TAXA"	, nTmpTx	, "AlwaysTrue()" } )
			EndIf
			//#RVC20180720.en
		ElseIF AllTrim(aVencto[nI,4]) $ "CHT|CHK"	// cheques - Cristiam Rossi em 18/07/2017
			
			aCheque := Separa(aVencto[nI][7],"|")
			
			AAdd( aRotAuto, { "E1_BCOCHQ"	, aCheque[1]		, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_AGECHQ"	, aCheque[2]		, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_CTACHQ"	, aCheque[3]		, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_CMC7FIN"	, aVencto[nI,10]	, "AlwaysTrue()" } ) 	// CMC7
			AAdd( aRotAuto, { "E1_DOCTEF"	, aVencto[nI,11]	, "AlwaysTrue()" } )	// autorização TeleCheque
			
		EndIf
		
		AAdd( aRotAuto, { "E1_CPFCNPJ"  	, SA1->A1_CGC						, NIL } )
		AAdd( aRotAuto, { "E1_NUMSUA"  		, cAtende							, NIL } )
		AAdd( aRotAuto, { "E1_PEDPEND"  	, '2'								, NIL } )
		AAdd( aRotAuto, { "E1_01VLBRU"  	, nVlrBrut							, NIL } )
		//		AAdd( aRotAuto, { "E1_01QPARC"  	, Len(aVencto)						, NIL } )
		AAdd( aRotAuto, { "E1_01QPARC"  	, VAL(aVencto[nI,12])			 	, NIL } )
		AAdd( aRotAuto, { "E1_XDESCFI"  	, FWFILIALNAME(cEmpAnt,cFilAnt,1)	, NIL } )
		AAdd( aRotAuto, { "E1_PORTADO"  	, cPortado							, NIL } )
		AAdd( aRotAuto, { "E1_USRNAME"		, UsrRetName(__cUserID)				, Nil } )
		
		MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )
		
		IF lMsErroAuto
			
			MostraErro()
			DisarmTransaction()
			Exit
			
		Else
			aBaixa 			:= {}
			lMsErroAuto 	:= .F.
			
			IF AllTrim(aVencto[nI,4]) == "R$"
				
				DbSelectArea("Z02")
				DbSetOrder(1)
				If DbSeek(xFilial("Z02") + AVKEY(aVencto[nI,4],"Z02_FORMA") )
					cBanco   := Z02->Z02_BANCO
					cAgencia := Z02->Z02_AGENCI
					cConta   := Z02->Z02_NUMCON
				Else
					aDados	 := Separa(GetMv("MV_CXFIN"),"/")
					cBanco   := aDados[1]
					cAgencia := aDados[2]
					cConta   := aDados[3]
				EndIf
				
				SE1->(DbSetOrder(1))
				If SE1->(DbSeek(xFilial("SE1") + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ))
					
					AADD(aBaixa , {"E1_NUM"			,SE1->E1_NUM		,NIL})
					AADD(aBaixa , {"E1_PREFIXO"		,SE1->E1_PREFIXO	,NIL})
					AADD(aBaixa , {"E1_PARCELA"		,SE1->E1_PARCELA	,NIL})
					AADD(aBaixa , {"E1_TIPO"			,SE1->E1_TIPO		,NIL})
					AADD(aBaixa , {"E1_CLIENTE"		,SE1->E1_CLIENTE	,NIL})
					AADD(aBaixa , {"E1_LOJA"			,SE1->E1_LOJA		,NIL})
					AADD(aBaixa , {"AUTMOTBX"		,"NOR"				,NIL})
					aAdd(aBaixa , {"AUTBANCO"     	,cBanco				,Nil})
					aAdd(aBaixa , {"AUTAGENCIA"     ,cAgencia			,Nil})
					aAdd(aBaixa , {"AUTCONTA"     	,cConta				,Nil})
					AADD(aBaixa , {"AUTDTBAIXA"		,dDataBase			,NIL})
					AADD(aBaixa , {"AUTDTCREDITO"	,dDataBase			,NIL})
					AADD(aBaixa , {"AUTHIST"			,"VALOR RECEBIDO S/ TITULO",NIL})
					aAdd(aBaixa , {"AUTVALREC"     	,SE1->E1_VALOR 	,Nil})
					
					MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 3)
					
					If lMsErroAuto
						
						MostraErro()
						DisarmTransaction()
						Exit
						
					EndIf
					
				EndIf
				
				//Realiza o cadastro do cheque na tabela SEF
				
			ElseIF Alltrim(aVencto[nI,4]) $ "CHT|CHK"
				
				aCheque := Separa(aVencto[nI][7],"|")
				
				DbSelectArea("SEF")
				Reclock( "SEF" , .T. )
				REPLACE SEF->EF_FILIAL  	 	WITH xFilial("SEF")
				REPLACE SEF->EF_NUM			WITH aCheque[4]
				REPLACE SEF->EF_BANCO	     	WITH aCheque[1]
				REPLACE SEF->EF_AGENCIA 	 	WITH aCheque[2]
				REPLACE SEF->EF_CONTA	     	WITH aCheque[3]
				REPLACE SEF->EF_VALOR	     	WITH SE1->E1_VALOR
				REPLACE SEF->EF_DATA	     	WITH dDataBase
				REPLACE SEF->EF_VENCTO		WITH SE1->E1_VENCTO
				REPLACE SEF->EF_BENEF	  	 	WITH SM0->M0_NOMECOM
				REPLACE SEF->EF_CART		 	WITH "R"
				//				REPLACE SEF->EF_TEL			WITH aCheque[6] // #AFD20180517.o
				//				REPLACE SEF->EF_RG		   	WITH aCheque[5] // #AFD20180517.o
				REPLACE SEF->EF_TITULO  		WITH SE1->E1_NUM
				REPLACE SEF->EF_PREFIXO	  	WITH SE1->E1_PREFIXO
				REPLACE SEF->EF_TIPO	     	WITH SE1->E1_TIPO
				REPLACE SEF->EF_TERCEIR 	 	WITH .F.
				REPLACE SEF->EF_HIST	     	WITH ""   		  // PARA RDMAKE
				REPLACE SEF->EF_PARCELA  	WITH SE1->E1_PARCELA
				REPLACE SEF->EF_CLIENTE	   	WITH SA1->A1_COD
				REPLACE SEF->EF_LOJACLI	   	WITH SA1->A1_LOJA
				REPLACE SEF->EF_CPFCNPJ	   	WITH SA1->A1_CGC
				REPLACE SEF->EF_EMITENT	   	WITH SA1->A1_NOME
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ ID K057 -  GRAVA A NATUREZA NO CHEQUE - LUIZ EDUARDO F.C. - 31/08/2018 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				REPLACE SEF->EF_NATUR	     	WITH cNatCH
				REPLACE SEF->EF_XDESCNA	    WITH cDescNat
				MsUnlock()
				
			EndIf
			
			If lGeraTaxa
				
				nValAdm := aVencto[nI,3]*SAE->AE_TAXA
				
				lMsErroAuto 	:= .F.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ ID K098 - TRATA OS TITULOS DE TAXA PARA CRIAR PARA UM UNICO FORNECEDOR - LUIZ EDUARDO F.C. - 02.02.2018 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cForTX    := SAE->AE_XFORTX
				cLojTX    := SAE->AE_XLJTX
				
				aVetorSE2 :={	{"E2_PREFIXO"		,SE1->E1_PREFIXO											,Nil}	,;				// 01
				{"E2_NUM"	   		,SE1->E1_NUM    											,Nil}	,; 				// 02
				{"E2_PARCELA"		,SE1->E1_PARCELA											,Nil}	,; 				// 03
				{"E2_TIPO"			,SE1->E1_TIPO   											,Nil}	,;				// 04
				{"E2_NATUREZ"		,cNatTx														,"AlwaysTrue()"}	,;	// 05
				{"E2_FORNECE"		,IIF(EMPTY(cForTX),"999999",cForTX)	 						,Nil}	,;				// 06	//{"E2_FORNECE",IIF(EMPTY(cForTX),cNumSA2,cForTX)	  ,Nil}	,; // 06 //#RVC20180721.o
				{"E2_LOJA"			,IIF(EMPTY(cLojTX),"01"    ,cLojTX)   						,Nil}	,; 				// 07	//{"E2_LOJA"   ,IIF(EMPTY(cLojTX),SE1->E1_LOJA,cLojTX),Nil}	,; // 07 //#RVC20180721.o
				{"E2_EMISSAO"		,dDataBase      											,NIL}	,;				// 08
				{"E2_VENCTO"		,SE1->E1_VENCTO 											,NIL}	,; 				// 09
				{"E2_VENCREA"		,SE1->E1_VENCREA											,NIL}	,; 				// 10
				{"E2_VALOR"			,A410Arred((nValAdm)/100 , "L2_VRUNIT")						,NIL}	,;				// 11
				{"E2_XDESCFI"		,cFilAnt + " - " + FWFILIALNAME(cEmpAnt,cFilAnt,1)			,NIL}	,;				// 12
				{"E2_PORTADO"		,cPortado													,NIL}	,; 				// 13
				{"E2_XNSUTEF"		,SE1->E1_NSUTEF												,NIL}	,;				// 15	//#RVC20180625.n
				{"E2_XPARNSU"		,SE1->E1_XPARNSU											,NIL}	,;				// 16	//#RVC20180625.n
				{"E2_XNCART4"		,SE1->E1_XNCART4											,NIL}	,;				// 17	//#RVC20180625.n
				{"E2_XFLAG"			,SE1->E1_XFLAG												,NIL}	,;				// 18	//#RVC20180625.n
				{"E2_XTPPAG"		,cTpPagto													,NIL}	,;				// 19	//#RVC20180924.n
				{"E2_01NUMRA"		,cAtende													,NIL}	,;				// 20	//#RVC20181004.n	//utilizei este por não estar sendo usado em nenhuma outra rotina
				{"E2_HIST"			,AllTrim(SE1->E1_NUM)										,NIL}} 					// 14
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Faz a inclusao do contas a pagar via ExecAuto ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetorSE2,,3)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se houveram erros durante a execucao da rotina automatica.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
					Exit
				EndIf
			EndIf
			
		EndIF
		
		LjWriteLog( cARQLOG, "2.31 - GERADO TITULO: "+SE1->E1_FILIAL+""+SE1->E1_PREFIXO+""+SE1->E1_NUM+""+SE1->E1_PARCELA+""+SE1->E1_TIPO )
		
	Next
	
EndIf

nModulo := nModOld

//Retorno a Filial Corrente
//cFilAnt := cFilOld

Return

/*--------------------------------------------
@Autor: Eduardo Patriani
@Data: 16/02/2018
@Hora: 13:29:18
@Função: RetLocal
@Versão: 1.0
@Uso:
@Descrição: Retorna o armazem padrão da filial
---------------------------------------------
Change:
--------------------------------------------*/
Static Function RetLocal()

Local cQuery 	:= ""
Local cRetorno 	:= ""
Local cAlias 	:= GetNextAlias()

cQuery := " SELECT NNR_CODIGO "
cQuery += " FROM "+RetSqlName("NNR")+" NNR (NOLOCK) "
cQuery += " WHERE NNR_FILIAL = '"+xFilial("NNR")+"' "
cQuery += " AND NNR_TIPO = '1' "
cQuery += " AND NNR.D_E_L_E_T_ = '' "

TcQuery cQuery New Alias (cAlias)

While (cAlias)->(!Eof())
	cRetorno := (cAlias)->NNR_CODIGO
	(cAlias)->(DbSkip())
EndDo
(cAlias)->(DbCloseArea())

Return(cRetorno)

//#AFD20180502.bn
/*
--------------------------------------------------------------------------------|
-> Retorna o codigo da tabela SAE com base nas informaçoes capturadas do cheque	|
-> By Alexis Duarte																|
-> 02/05/2018                                                                   |
-> Uso: Komfort House                                                           |
--------------------------------------------------------------------------------|
*/
Static Function RetCodSAE(cCod)

Local nPos := 1
Local cCodSAE := ""

nPos += rat("|",cCod)

cCodSAE := substr(cCod,nPos,3)

Return cCodSAE
//#AFD20180502.en

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 12/09/2018
/*/
//--------------------------------------------------------------
Static Function TELMANU(cCliente,cLoja,_cOrca)

Local aArea 		:= GetArea()
Local cTitulo := "Agendamento de Pedido"
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
Local oRegCon
Local cRegCon := space(240) 
Local oBtnAgendar
Local oBtnAltCli
Local oBtnSair
Local oGetBairro
Local cBairro := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_BAIRRO")
Local oGetCidade
Local oGetDtAgend
Local dGetDtAgend := CtoD('//')
Local oGetEstado
Local oGetRua
Local cRua := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_END")
Local cDDD := '('+ alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_DDD")) +') '
Local oGetTel1
Local cTel1 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL")
Local oGetTel2
Local cTel2 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TEL2")
Local oGetTel3
Local cTel3 := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_XTEL3")
Local oSay12
Local oSayBairro
Local oSayCep
Local cCep := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CEP")
Local oSayCidade
Local cCidade := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_MUN")
Local oSayDtAgend
Local oSayEstado
Local cEstado := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")
Local oSayObs
Local oSayRua
Local oTelefone1
Local oTelefone2
Local oTelefone3
Local cMsgUser := ""

//Informações do pedido de venda
Local oMsgPed
Local cMsgObsPed := ""

//Informações de entrega
Local oMsgEnt
Local cMsgObsEnt := ""

Local nCont := 0
Local lGrava := .F.

Local cUserName := LogUserName()

Static _oDlg

DbSelectArea("SUA")
DbSetOrder(1)

//	If SUA->(dbseek(xFilial("SUA")+_cOrca))
//		cMsgObsPed := SUA->UA_XOBSENT
//	EndIf

//	cMsgUser := cUserName + ENTER
//	cMsgUser += replicate('-',60) + ENTER

cMsgObsEnt := MSMM(SUA->UA_CODOBS,TamSx3("UA_OBS")[1],,,3)

If Empty(alltrim(cMsgObsEnt))
	cMsgObsEnt := cMsgUser + cMsgObsEnt
Else
	cMsgObsEnt := cMsgObsEnt + ENTER + ENTER + cMsgUser
endif

Private aCpos := {"A1_END","A1_BAIRRO","A1_EST","A1_CEP", "A1_MUN","A1_DDD","A1_TEL","A1_TEL2","A1_XTEL3","A1_CONTATO","A1_EMAIL","A1_COMPLEM" }
Private cCadastro := "Cadastro de Clientes - Alteração de Cadastro"

//Montagem da Tela
DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 000, 000  TO 500, 390 COLORS 0, 16777215 PIXEL STYLE 128 

@ 004, 003 GROUP oGroup1 TO 042, 192 PROMPT " Agendamento do Orçamento - " + _cOrca OF _oDlg COLOR 0, 16777215 PIXEL
//    @ 016, 009 SAY oSayObs PROMPT "Deseja agendar todos os itens disponiveis ?" SIZE 110, 007 OF _oDlg COLORS 692766, 16777215 PIXEL
@ 029, 010 SAY oSayDtAgend PROMPT "Data do agendamento:" SIZE 056, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 027, 069 MSGET oGetDtAgend VAR dGetDtAgend PICTURE PesqPict("SC6","C6_ENTREG") SIZE 056, 010 OF _oDlg  VALID vldDate(dGetDtAgend) COLORS 0, 16777215 PIXEL
@ 027, 135 BUTTON oBtnAgendar PROMPT "Agendar" SIZE 047, 012 OF _oDlg ACTION lGrava := fConfirm(dGetDtAgend,cRegCon) PIXEL

//	oBtnAgendar:BLCLICKED:= {|| lGrava := .T. , _oDlg:End() }

@ 046, 003 GROUP oGroup2 TO 115, 192 PROMPT " Informações do Cliente - " + alltrim(cCliente)  OF _oDlg COLOR 0, 16777215 PIXEL

//Rua
@ 054, 010 SAY oSayRua PROMPT "Rua:" SIZE 015, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 054, 024 SAY oGetRua PROMPT cRua SIZE 162, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Bairro
@ 061, 010 SAY oSayBairro PROMPT "Bairro:" SIZE 018, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 061, 027 SAY oGetBairro PROMPT cBairro SIZE 089, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Cidade
@ 069, 010 SAY oSayCidade PROMPT "Cidade:" SIZE 021, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 069, 030 SAY oGetCidade PROMPT cCidade SIZE 055, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Estado
@ 077, 010 SAY oSayEstado PROMPT "Estado:" SIZE 021, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 077, 031 SAY oGetEstado PROMPT cEstado SIZE 015, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Cep
@ 085, 010 SAY oSayCep PROMPT "CEP:" SIZE 014, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 085, 024 SAY oSay12 PROMPT cCep SIZE 035, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Telefone 1
@ 092, 010 SAY oTelefone1 PROMPT "Telefone 1:" SIZE 030, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 092, 039 SAY oGetTel1 PROMPT cDDD + cTel1 SIZE 060, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Telefone 2
@ 099, 010 SAY oTelefone2 PROMPT "Telefone 2:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
@ 099, 039 SAY oGetTel2 PROMPT cDDD + cTel2 SIZE 060, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//Telefone 3
@ 107, 010 SAY oTelefone3 PROMPT "Telefone 3:" SIZE 030, 007 OF oGroup2 COLORS 0, 16777215 PIXEL
@ 107, 039 SAY oGetTel3 PROMPT cDDD + cTel3 SIZE 060, 007 OF _oDlg COLORS 0, 16777215 PIXEL

//   @ 099, 124 BUTTON oBtnAltCli PROMPT "Alterar dados do Cliente" SIZE 064, 012 OF _oDlg PIXEL
//	oBtnAltCli:BLCLICKED:= {|| AxAltera("SA1",SA1->(Recno()),4,,aCpos) }

@ 118, 003 GROUP oGroup4 TO 188, 192 PROMPT " Observações de Entrega " OF _oDlg COLOR 0, 16777215 PIXEL//243
@ 125, 006 GET oMsgEnt VAR cMsgObsEnt MEMO SIZE 182, 057 PIXEL OF _oDlg

//Restrição de Entrega
@ 190, 003 GROUP oGroup5 TO 213, 192 PROMPT " Restrição de Entrega " OF _oDlg COLOR 0, 16777215 PIXEL 
@ 197, 006 GET oRegCon VAR cRegCon SIZE 185, 010 PIXEL OF _oDlg 

@ 225, 004 BUTTON oBtnSair PROMPT "Cancelar" SIZE 187, 016 OF _oDlg ACTION lGrava := lSai() PIXEL 

If !lGrava
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
Else
	
	_oDlg:End()
	
EndIf


RestArea(aArea)

Return{lGrava,dGetDtAgend,cMsgObsEnt,cRegCon}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vldDate     º Autor ³ Caio Garcia     º Data ³  20/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Data Agendamento                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function vldDate(dGetDtAgend)

Local lRet := .T.

dbSelectArea("ZK7")
ZK7->(dbsetorder(1))

//Se a data estiver cadastrada, bloqueia o agendamento
if ZK7->(dbseek(xFilial()+dtos(dGetDtAgend)))
	apMsgAlert("A data informada"+ dtoc(dGetDtAgend) +" esta bloqueada para agendamentos!","ATENÇÃO")
	return(.F.)
endif

//#RVC20181026.bo
//Removido conforme solicitação do Isaías registrado no chamado ID do Ticket R1Z-JT4-QVDM
/*	If dGetDtAgend == (dDataBase+1)//casos 24 horas

If Time() > '11:00:00'
lRet := .F.
msgAlert("Não é possivel agendar entregas 24 horas após às 11:00","ATENÇÃO")
EndIf

EndIf
//#RVC20181026.eo
*/

If dGetDtAgend < dDataBase
	lRet := .F.
	msgAlert("Não é possivel informar uma data menor que a data base.","ATENÇÃO")
EndIf

If AllTrim(DiaSemana( dGetDtAgend)) == 'Domingo'
	lRet := .F.
	msgAlert("Não é possivel agendar entrega aos domingos","ATENÇÃO")
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fConfirm    º Autor ³ Caio Garcia     º Data ³  20/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Confirma agendamento                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fConfirm(dGetDtAgend,cRegCon)

Local _lRet := .F.
	
If Empty(cRegCon)
	Alert("Campo restrição de entrega não preenchido!")
	Return _lRet
EndIF

If Empty(dGetDtAgend)
	
	Alert("Informar uma data!")
	
Else
	
	_lRet := MsgYesNo("Confirma o agendamento para "+DtoC(dGetDtAgend)+"?")
	
	If  _lRet
		
		_oDlg:End()
		
	EndIf
	
EndIf

Return _lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³lSai        º Autor ³ Caio Garcia     º Data ³  20/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Saida                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function lSai()

Local _lRet := .F.

_lRet := MsgYesNo("Deseja cancelar o agendamento?","CANCAGE")

If  _lRet
	
	_oDlg:End()
	
EndIf

Return _lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDiasValid  º Autor ³ Caio Garcia     º Data ³  20/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula dias uteis                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fDiasValid(_dData,_nDias)

Local _dRet := _dData
Local _nz   := 0
Local _lSai := .F.
Local _nRet := 0

While !_lSai
	
	_dRet := _dRet+1
	
	If DateWorkDay( _dData, _dRet ) >= _nDias
		
		_lSai := .T.
		
	EndIf
	
EndDo

Return _dRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fNewParc    º Autor ³ Rafael Cruz     º Data ³  09/11/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula parcelas                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fNewParc(cNumTMK)

local cQry 		:= ""
local cRetorno	:= "0"
local _cAlias	:= GetNextAlias()

Default _cRet 	:= "0"

cQry := "SELECT MAX(E1_PARCELA) AS PARCELA FROM SE1010 (NOLOCK)"
cQry += "WHERE "
cQry += "E1_NUMSUA = '" + Alltrim(cNumTMK) + "' AND "
cQry += "D_E_L_E_T_ = ' ' "

TcQuery cQry New Alias (_cAlias)

While (_cAlias)->(!Eof())
	cRetorno := Alltrim((_cAlias)->PARCELA)
	(_cAlias)->(DbSkip())
EndDo
(_cAlias)->(DbCloseArea())

if !empty(ALLTRIM(cRetorno))
	_cRet := SOMA1(cRetorno)
else
	_cRet := SOMA1(_cRet)
endIf

Return(_cRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVerAgend   º Autor ³ Caio Maior      º Data ³  13/11/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica saldo do produto                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fVerAgend(_cProd,_cLocPrd,_nQtdPed)

Local _cQry1 		:= ""
Local _cQry2 		:= ""
Local _cQry3 		:= ""
Local _cAlias1	    := GetNextAlias()
Local _cAlias2	    := GetNextAlias()
Local _cAlias3	    := GetNextAlias()
Local _lRet         := .F.

Local _nSld         := 0

//AJUSTE FEITO PARA LIBERAR PRODUTOS DA FLA COM LIERAÇÃO DE VENDA PELA DIRETORIA 
_cQry3 := " SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDFILA "
_cQry3 += " FROM " + RetSQLName("SC6") + "(NOLOCK) SC6 "
_cQry3 += " WHERE SC6.D_E_L_E_T_ <> '*' "
_cQry3 += " AND C6_PRODUTO = '" + _cProd + "' " 
_cQry3 += " AND C6_NOTA = '' "
_cQry3 += " AND C6_BLQ <> 'R' "
_cQry3 += " AND C6_QTDEMP = 0 "
_cQry3 += " AND C6_QTDVEN > C6_QTDLIB "
_cQry3 += " AND C6_CLI <> '000001' "
_cQry3 += " AND C6_FILIAL = '"+_cLocPrd+"' "
_cQry3 += " AND C6_XVENDA = '1'"

TcQuery _cQry3 New Alias (_cAlias3)

_cQry1 := " SELECT CASE WHEN SUM(C6_QTDVEN-C6_QTDLIB) IS NULL THEN 0 ELSE SUM(C6_QTDVEN-C6_QTDLIB) END  QTDPED "
_cQry1 += " FROM " + RetSQLName("SC6") + "(NOLOCK) SC6 "
_cQry1 += " WHERE SC6.D_E_L_E_T_ <> '*' "
_cQry1 += " AND C6_PRODUTO = '" + _cProd + "' "
_cQry1 += " AND C6_NOTA = '' "
_cQry1 += " AND C6_BLQ <> 'R' "
_cQry1 += " AND C6_QTDEMP = 0 "
_cQry1 += " AND C6_QTDVEN > C6_QTDLIB "
_cQry1 += " AND C6_CLI <> '000001' "
_cQry1 += " AND C6_FILIAL = '01  ' "
_cQry1 += " AND C6_LOCAL = '"+_cLocPrd+"' "

TcQuery _cQry1 New Alias (_cAlias1)

_cQry2 := " SELECT CASE WHEN SUM(BF_QUANT-BF_EMPENHO) IS NULL THEN 0 ELSE SUM(BF_QUANT-BF_EMPENHO) END  QTDBF "
_cQry2 += " FROM " + RetSQLName("SBF") + "(NOLOCK) SBF "
_cQry2 += " WHERE SBF.D_E_L_E_T_ <> '*' "
_cQry2 += " AND BF_PRODUTO = '" + _cProd + "' "
_cQry2 += " AND (BF_QUANT - BF_EMPENHO) >= 0 "
_cQry2 += " AND BF_LOCAL = '"+_cLocPrd+"' "
If _cLocPrd == '03'
	_cQry2 += " AND BF_LOCALIZ IN ('MOSTRUARIO')"
Else
	_cQry2 += " AND BF_LOCALIZ NOT IN ('9999','DEVOLUCAO','MOSTRUARIO')"
EndIf
_cQry2 += " AND BF_FILIAL = '0101' "

TcQuery _cQry2 New Alias (_cAlias2)

_nSld := (_cAlias2)->QTDBF-((_cAlias1)->QTDPED-(_cAlias3)->QTDFILA)

If _nSld > 0
	
	If _nSld >= _nQtdPed
		
		_lRet := .T.
		
	EndIf
	
EndIf

(_cAlias1)->(DbCloseArea())
(_cAlias2)->(DbCloseArea())
(_cAlias3)->(DbCloseArea())

Return(_lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetEnd     º Autor ³ Caio Maior      º Data ³  17/12/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o endereço livre                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fRetEnd(_cProd, _cLocal, _nQuant )

Local cQuery := ""
Local _cAliasEnd := GetNextAlias()
Local _cEndere := ""

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+_cProd))

If SB1->B1_LOCALIZ == 'S'
	
	cQuery := " SELECT TOP 1 BF_LOCALIZ "
	cQuery += " FROM "+ RetSqlName("SBF") +" SBF "
	cQuery += " WHERE BF_FILIAL = '0101' "
	cQuery += " AND BF_PRODUTO = '" + _cProd + "' "
	cQuery += " AND BF_LOCAL = '" + _cLocal + "' "
	
	If _cLocal == '03'
		cQuery += " AND BF_LOCALIZ IN ('MOSTRUARIO') "
	Else
		cQuery += " AND BF_LOCALIZ NOT IN ('9999','DEVOLUCAO','MOSTRUARIO') "
	EndIf
	
	cQuery += " AND (BF_QUANT - BF_EMPENHO) >= " + cValToChar(_nQuant) + " "
	cQuery += " AND SBF.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY BF_LOCAL, BF_LOCALIZ "
	
	//plsQuery(cQuery,_cAliasEnd)
	TcQuery cQuery New Alias (_cAliasEnd)
	
	If (_cAliasEnd)->(!Eof())
		
		_cEndere := (_cAliasEnd)->BF_LOCALIZ
		
	Else
		
		_cEndere := ""
		
	EndIf
	
	(_cAliasEnd)->(dbCloseArea())
	
EndIf

Return _cEndere


//--------------------------------------------------------------
/*/{Protheus.doc} fGeraSb9
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 22/04/2019 /*/
//--------------------------------------------------------------
Static Function fGeraSb9(_cProduto, _cLocal)

	Local aArea := getArea()
	Local aAreaSB1 := SB1->(getarea())
	Local aAreaSB9 := SB9->(getarea())
	Local aSb9 := {}
	Local cfilM := "0101"
	Local cfilBkp := cFilant

	Private lMsErroAuto := .F.

	cFilant := cfilM
		
	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
	SB9->(DbGoTop())
	
	If !DbSeek(cfilM + _cProduto + _cLocal)
		
		aadd(aSB9,{"B9_FILIAL",cfilM, Nil})
		aadd(aSB9,{"B9_COD",_cProduto, Nil})
		aadd(aSB9,{"B9_LOCAL",_cLocal, Nil})
		aadd(aSB9,{"B9_QINI",0, Nil})
		
		MSExecAuto({|x,y| MATA220(x,y)},aSB9,3)
		
		If lMsErroAuto
			MostraErro()
		EndIf
		
	EndIf

	restArea(aArea)
	restArea(aAreaSB1)
	restArea(aAreaSB9)

	cFilant := cfilBkp

Return