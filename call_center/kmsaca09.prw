#include 'protheus.ch'
#include 'parmtype.ch'
#include "tbiconn.ch"

User Function KMSACA09(cNumSAC, cCodCli, cLojCli, cNumPV, cNumNF, nVlrMerc,cTpOp)

Local cObs		:= ""
Local cMotivo	:= ""
Local aAreaSUC	:= SUC->(GetArea())	
Local aAreaSUD	:= SUD->(GetArea())
Local aAreaZ01	:= Z01->(GetArea())
Local aAcaoZ01	:= {}

Default cTpOp := "NDC"	//NCC

dbSelectArea("SUD")
SUD->(dbSetOrder(1))
SUD->(dbGoTop())

If SUD->(dbSeek(xFilial('SUD') + PADR(cNumSAC,TamSX3("UD_CODIGO")[1])))
	While SUD->(!Eof()) .And. SUD->(UD_FILIAL + UD_CODIGO) == xFilial("SUD") + cNumSAC
		If	SUD->UD_01PEDID == cNumPV
			Aadd(aAcaoZ01,{SUD->UD_01TIPO, SUD->UD_XNUMTIT,SUD->(RECNO())})
		EndIf
		SUD->(dbSkip())
	EndDo	
EndIf

dbSelectArea("Z01")
Z01->(dbSetOrder(1))
Z01->(dbGoTop())

For nA	:= 1 to Len(aAcaoZ01)
	If Z01->(dbSeek(xFilial('Z01') + PADR(aAcaoZ01[nA][1],TamSX3("Z01_COD")[1])))
		If Empty(aAcaoZ01[nA][2]) .AND. Z01_TPMVTO == "1"
			cObs := "NF.[" + alltrim(cNumNF) +"] Tipo:[" + alltrim(aAcaoZ01[nA][1]) + "] PV.[" + alltrim(cNumPV) + "]"
			//CriaTit(cNumTitulo,nValorTit,cCliente,cLoja,cMotivo,cNrChamado,cObs,cTPTit)
			If CriaTit(cNumNF, cNumPV, nVlrMerc,cCodCli,cLojCli,cMotivo,cNumSAC,cObs,cTpOp)
				SUD->(dbGoTo(aAcaoZ01[nA][3]))
				RecLock("SUD",.F.)
					SUD->UD_XNUMTIT := cNumNF
				MSUnlock()
			EndIf
		EndIf
	EndIf
Next

RestArea(aAreaSUC)
RestArea(aAreaSUD)
RestArea(aAreaZ01)
	
Return

//----------------------------------------------------------------
/*/{Protheus.doc} CriaTit()
Criação de Titulo via execAuto
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------
Static Function CriaTit(cNumTitulo, cNumPV, nValorTit,cCliente,cLoja,cMotivo,cNrChamado,cObs,cTPTit)
    
   	Local lRet 			:= .T.                  				// Retorno                                                      
	Local aVetor        := {}                   				// Array com dados para gerar.
//	Local cPrefixo		:= "MAN"	//#RVC20180606.o
	Local cPrefixo		:= "SAC"	//#RVC20180606.n
	Local cNumTit     	:= GetSxeNum("SE1","E1_NUM")
	Local cTipo			:= iif(cTPTit=="NCC","NCC","NDC")
	Local cNatNCC	 	:= SuperGetMV("MV_NATNCC")
	Local cNatNDC		:= SuperGetMV("MV_NATNDC")
	Local cParcela 		:= SuperGetMV("MV_1DUP")				// Parcela a gerar
	
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	
//	cNumTitulo := cNumTit
	Default cNumTitulo := cNumTit	//#RVC20180514.n
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	
	While SE1->(DbSeek(xFilial("SE1") + cPrefixo + cNumTitulo + cParcela + cTipo))
		cParcela := CHR(ASC(cParcela)+1)
	End
	
	aAdd(aVetor,{"E1_PREFIXO"	,cPrefixo											,Nil})
	aAdd(aVetor,{"E1_NUM"	  	,cNumTitulo											,Nil})
	aAdd(aVetor,{"E1_PARCELA" 	,cParcela											,Nil})
	aAdd(aVetor,{"E1_NATUREZ" 	,iif(cTPTit=="NCC",cNatNCC,cNatNDC)                	,Nil})
	aAdd(aVetor,{"E1_TIPO" 		,cTipo												,Nil})
	aAdd(aVetor,{"E1_EMISSAO"	,dDatabase											,Nil})
	aAdd(aVetor,{"E1_VALOR"		,nValorTit											,Nil})
	aAdd(aVetor,{"E1_VENCTO"	,dDatabase											,Nil})
	aAdd(aVetor,{"E1_VENCREA"	,dDatabase					   						,Nil})
	aAdd(aVetor,{"E1_VENCORI"	,dDatabase											,Nil})
	aAdd(aVetor,{"E1_SALDO"		,nValorTit											,Nil})
	aAdd(aVetor,{"E1_VLCRUZ"	,xMoeda(nValorTit,1,1,nValorTit)	            	,Nil})
	aAdd(aVetor,{"E1_CLIENTE"	,Alltrim(cCliente)									,Nil})
	aAdd(aVetor,{"E1_LOJA"		,Alltrim(cLoja)										,Nil})
	aAdd(aVetor,{"E1_MOEDA"		,1													,Nil})
	aAdd(aVetor,{"E1_STATUS"	,"A"												,Nil})
	aAdd(aVetor,{"E1_SITUACA"	,"0"												,Nil})
	aAdd(aVetor,{"E1_ORIGEM"	,"KMSACA09"											,Nil})
	aAdd(aVetor,{"E1_MULTNAT"	,"2"												,Nil})
	aAdd(aVetor,{"E1_FLUXO"		,"N"												,Nil})
	aAdd(aVetor,{"E1_BASCOM1"	,xMoeda(nValorTit,1,1,nValorTit)					,Nil})
	aAdd(aVetor,{"E1_HIST"		,cObs												,Nil})
	aAdd(aVetor,{"E1_PEDIDO"	,cNumPV												,Nil})	
	aAdd(aVetor,{"E1_01SAC"		,cNrChamado											,Nil})
	aAdd(aVetor,{"E1_01MOTIV"	,cMotivo											,Nil})
	AAdd(aVetor,{"E1_USRNAME"	,UsrRetName(__cUserID)								,Nil})
	
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3)
	
	If  lMsErroAuto
		MostraErro()
		DisarmTransaction()
		lRet 	   := .F.
		//aLogRotAut := GetAutoGrLog()
	Else
		ConfirmSX8()
		msgInfo("Titulo "+ alltrim(cNumTitulo) +" gerado com sucesso!!!","Komfort House")
	EndIf

Return lRet

User Function KMSACA9A(aVetor,nOpc) 

	Local aBaixa		:= {}
	Local lOk			:= .T.
	Local aAreaSE1		:= SE1->(GetArea())
	Local lMsErroAuto	:= .F.
	
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
	SE1->(dbGoTop())

	If SE1->(dbSeek(xFilial("SE1") + "SAC" + aVetor[1] + "A " + "NDC"))
	
		AADD(aBaixa , {"E1_PREFIXO"		 ,"SAC"					,NIL})
		AADD(aBaixa , {"E1_NUM"		 		,aVetor[1]				,NIL})
		AADD(aBaixa , {"E1_PARCELA"	 	,SE1->E1_PARCELA,NIL}) //Parcela estava fixa apresentando erro no SEEK devido o tamanho do campo - Marcio Nunes - 5101 
		AADD(aBaixa , {"E1_TIPO"	 			,"NDC"						,NIL})
		AADD(aBaixa , {"AUTMOTBX"    	,"DEV"         				,Nil})
		AADD(aBaixa , {"AUTBANCO"    	,"CX1"						,Nil})
		AADD(aBaixa , {"AUTAGENCIA"  	,"00001"					,Nil})
		AADD(aBaixa , {"AUTCONTA"    	,"0000000001"			,Nil})
		AADD(aBaixa , {"AUTDTBAIXA"  	,dDataBase     			,Nil})
		AADD(aBaixa , {"AUTDTCREDITO"	,dDataBase     			,Nil})
		AADD(aBaixa , {"AUTHIST"     		,"Ret.Emprest"			,Nil})
		AADD(aBaixa , {"AUTJUROS"    		,0            					,Nil})
		AADD(aBaixa , {"AUTVALREC"   	,aVetor[2]    			,Nil})
			   
		MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, nOpc)       

		If lMsErroAuto
			MostraErro()
			lOk := .F.
		Endif
	EndIf
	
	RestArea(aAreaSE1)
	
Return(lOk)

User Function KMSACA9B(aVetor)

	Local aSE1			:= {}
	Local lOk			:= .T.
	Local aAreaSE1		:= SE1->(GetArea())
	Local lMsErroAuto	:= .F.
	
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
	SE1->(dbGoTop())
	
	If SE1->(dbSeek(aVetor[1] + aVetor[2] + aVetor[3] + aVetor[4] + aVetor[5]))
		AADD(aSE1 , {"E1_FILIAL" ,aVetor[1] ,NIL})
		AADD(aSE1 , {"E1_PREFIXO",aVetor[2]	,NIL})
		AADD(aSE1 , {"E1_NUM"	 ,aVetor[3]	,NIL})
		AADD(aSE1 , {"E1_PARCELA",aVetor[4] ,NIL})
		AADD(aSE1 , {"E1_TIPO"	 ,aVetor[5]	,NIL})

		MsExecAuto( { |x,y| FINA040(x,y)} , aSE1, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		If lMsErroAuto
			MostraErro()
			lOk := .F.
		Endif
	EndIf
	
	RestArea(aAreaSE1)
	
Return(lOk)