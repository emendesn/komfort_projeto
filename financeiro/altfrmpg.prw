#include "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTFRMPG  บAutor  ณ Cristiam Rossi     บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para excluir tํtulos e gerar novos conforme sele็ใo บฑฑ
ฑฑบ          ณ do usuแrio (de venda jแ finalizada)                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Global / KomfortHouse                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณCaio Garcia   ณ24/04/18ณ      ณ Ajuste para alterar titulos ap๓s baixa ณฑฑ
ฑฑณ#CMG20180424  ณ        ณ      ณ                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function AltFrmPg()

Local aArea		:= getArea()
//Local cFilQuery := " UA_CODCANC=' ' and UA_NUMSC5<>' ' and  UA_OPER='1' "	//  and UA_DOC<>' '	//#RVC20181022.o
Local cFilQuery   := " "																		//#RVC20181022.n
Local aCores	  := {}																			//#RVC20181022.n
Private cCadastro := "Mudar Forma de Pagamento - Atendimentos Finalizados"
Private aRotina   := {}
Private bEstorna  := {|| altForma() }
Private cPrefixo  := GetMv("KM_PREFIXO") // IRA CARREGAR O PREFIXO DOS TITULOS ATRAVES DESTE PARAMETRO


aadd( aRotina, { "Pesquisar"       ,"AxPesqui"        ,0,1,0 ,.F.})
aadd( aRotina, { "Visualizar"      ,"TK271CallCenter" ,0,2,0 ,NIL})
aadd( aRotina, { "Alt. Forma Pagto","eval(bEstorna)"  ,0,4,0 ,NIL})

//#RVC20181022.bn
aCores :=   {{"EMPTY(UA_CODCANC) .AND. UA_OPER == '1' .AND. !EMPTY(UA_NUMSC5)", 'BR_VERDE'},; // FATURADO
			 {"EMPTY(UA_CODCANC) .AND. UA_OPER <> '1' .AND. EMPTY(UA_NUMSC5) ", 'BR_AZUL' },; // EM ABERTO
             {"!EMPTY(UA_CODCANC).AND. UA_OPER <> '1' "						  , 'BR_PRETO' }} // CANCELADO
//#RVC20181022.en

DbSelectArea("SUA")

//mBrowse( 6, 1,22,75,"SUA",,,,,,,,,,,,,,cFilQuery)				//#RVC20181022.o
mBrowse( 6, 1,22,75,"SUA" ,,,,, ,aCores,,,,,,,,cFilQuery)		//#RVC20181022.n

restArea( aArea )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTFORMA  บAutor  ณ Cristiam Rossi     บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function altForma()

Local   aArea	:= GetArea()
Local   lRet	:= .F.
Local	lRa		:= .F. 
Local   oDlg
Local   oTFolder
Local   oList1
Local   oList2
Local	oList3	//#RVC20180722.n
Local	oList4	//#RVC20180723.n
Local   oBtnExc
Local   aParcelas := {}
Local   nI
Local   nJ
Local	nK	//#RVC20180713.n
//Local   cCGC      := Posicione("SA1",1,xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA), "A1_CGC")			//#RVC20180713.o
Local   cCGC      	:= GetAdvFVal("SA1","A1_CGC",xFilial("SA1") + SUA->(UA_CLIENTE+UA_LOJA),1,"Erro")	//#RVC20180713.n
Local	cE2PFX		:= SuperGetMV("KH_PREFSE2",.F.,"TXA")												//#RVC20180713.n
//Local	nCredito	:= 0																				//#RVC20180717.n
Local	_cFilAtu	:= SUA->UA_FILIAL																	//#RVC20180717.n
Local	cDirImp	 	:= "\CALL_CENTER_"+cFilAnt+"\"														//#RVC20180717.n
Local	cARQLOG		:= cDirImp+"TMKVPED_"+cFilAnt+"_"+SUA->UA_NUM+".LOG"								//#RVC20180717.n
Local	nModOld		:= nModulo																			//#RVC20180718.n
Local	lExecAuto 	:= GetMv("KM_EXECAUT",,.T.)															//#RVC20180719.n
Local	cCliente	:= ""
Local	cLoja		:= ""
Local	lTudoOK 	:= .F.

Private _nValBx   := 0 //#CMG20180424.n
Private _nCrAnt   := 0 //#RVC20180721.n
Private _nNwVlr   := 0 //#RVC20180815.n
//Private cTitulo   := "Mudan็a Forma de Pagamento"	//#RVC20180722.o
Private cNumTlv   := SUA->UA_NUM
Private cNumPV    := SUA->UA_NUMSC5
Private cNumNF    := SUA->UA_DOC
Private cSerie    := SUA->UA_SERIE
Private _cChar	  := ""	//#RVC20180815.n
Private _cNSU	  := ""	
Private _cParNSU  := ""	
Private aVend     := {}
Private aTitulos  := {}
Private aFormPG   := {}
Private aCredRA   := {} //#RVC20180722.n
Private _aTitBx   := {} //#CMG20180424.n
Private _lFrmPg	  := .F.//#RVC20180815.n
Private nCredito  := 0
Private _lCanc    := .F.//#RVC20181022.n
Private nCredNCC  := SUA->UA_XVLRCRD	//#RVC20181030.n
Private _cTpOper  := SUA->UA_OPER		//#RVC20181107.n

//Processa( { || lRet := ValidPrev() }  ,"Aguarde"   ,"Validando as informa็๕es...")	//#RVC20181022.o	

//#RVC20181022.bn
if !EMPTY(SUA->UA_CODCANC) .and. EMPTY(SUA->UA_NUMSC5) .and. SUA->UA_OPER <> '1'
	if MsgYesNo("A proposta estแ cancelada. Deseja Continuar?","Aten็ใo")
		fSkSE1()
		_lCanc := .T.
		Processa( { || lRet := ValidPrev() }  ,"Aguarde"   ,"Validando as informa็๕es...")
	else
		Return NIL
	endIf
else
	if SUA->UA_OPER <> '1'
		MsgStop("A proposta ้ um or็amento. Selecione uma proposta vแlida","Aten็ใo")
	else
		Processa( { || lRet := ValidPrev() }  ,"Aguarde"   ,"Validando as informa็๕es...")
	endIf
endIf
//#RVC20181022.en

If ! lRet
	restArea( aArea )
	return nil
EndIf

aFormPG := cargaPgto()
aFormPG := aSort(aFormPG,,,{|x,y| x[3] < y[3] })

lRet := .F.

DEFINE MSDIALOG oDlg FROM 0,0 TO 380,590 TITLE "Tํtulos existentes" Of oMainWnd PIXEL

oTFolder := TFolder():New( 2, 5, {'Formas de Pagto','Tํtulos a Receber','Cr้ditos Utilizados','Tํtulos Baixados'},,oDlg,,,,.T.,,290,150 )

@ 5,5 say "Forma de pagamento utilizada:" of oTFolder:aDialogs[1] pixel
@ 15,5 LISTBOX oList1 Fields HEADER "Data","Valor","Forma","Obs","Atendimento","" SIZE 280,110  OF oTFolder:aDialogs[1] PIXEL
oList1:SetArray(aFormPG)
oList1:bLine := { || { aFormPG[oList1:nAt,1], aFormPG[oList1:nAt,2], aFormPG[oList1:nAt,3], aFormPG[oList1:nAt,4], aFormPG[oList1:nAt,5],"" }}

@ 5,5 say "Tํtulos existentes relacionados a venda:" of oTFolder:aDialogs[2] pixel
@ 15,5 LISTBOX oList2 Fields HEADER "Prefixo","N๚mero","Parcela","Tipo","Valor","Vencto","" SIZE 280,110  OF oTFolder:aDialogs[2] PIXEL
oList2:SetArray(aTitulos)
oList2:bLine := { || { aTitulos[oList2:nAt,1], aTitulos[oList2:nAt,2], aTitulos[oList2:nAt,3], aTitulos[oList2:nAt,4], aTitulos[oList2:nAt,5], aTitulos[oList2:nAt,6], "" }}

@ 5,5 say "Cr้ditos utilizados relacionados a venda:" of oTFolder:aDialogs[3] pixel
@ 15,5 LISTBOX oList3 Fields HEADER "Prefixo","N๚mero","Emissใo","Valor","Hist๓rico","" SIZE 280,110  OF oTFolder:aDialogs[3] PIXEL
oList3:SetArray(aCredRA)
oList3:bLine := { || { aCredRA[oList3:nAt,1], aCredRA[oList3:nAt,2], aCredRA[oList3:nAt,3], aCredRA[oList3:nAt,4], aCredRA[oList3:nAt,5], "" }}

@ 5,5 say "Tํtulos baixados relacionados a venda:" of oTFolder:aDialogs[4] pixel
@ 15,5 LISTBOX oList4 Fields HEADER "Prefixo","N๚mero","Parcela","Tipo","Valor","Vencimento","" SIZE 280,110  OF oTFolder:aDialogs[4] PIXEL
oList4:SetArray(_aTitBx)
oList4:bLine := { || { _aTitBx[oList4:nAt,1], _aTitBx[oList4:nAt,2], _aTitBx[oList4:nAt,3], _aTitBx[oList4:nAt,4], _aTitBx[oList4:nAt,5], _aTitBx[oList4:nAt,6], "" }}

@ 160, 05 say "Voc๊ confirma a exclusใo do(s) registro(s) acima?" of oDlg Pixel

@ 170, 05 button oBtnExc prompt "Excluir" size 40,15 of oDlg pixel action ( lRet := .T., oDlg:end() )
@ 170, 250 button "Sair" size 40,15 of oDlg pixel action ( lRet := .F., oDlg:end() )
/*
If len(aTitulos) == 1 .and. aTitulos[1,5] == 0		// nใo tem financeiro
oBtnExc:disable()
endIf
*/
Activate msDialog oDlg Centered

nModulo	:= 06	//#RVC20180718.n
If lRet
	If len(aTitulos) == 1 .and. aTitulos[1,5] == 0		// nใo tem financeiro
	//	msgStop("Certifique-se de que haja tํtulos disponํveis para altera็ใo!","Nใo hแ tํtulo(s) เ ser(em) processado(s).") //#RVC20180915.o 
	//	lRet := .F. //#RVC20180915.o
		//#RVC20180915.bn
		If len(aCredRa) == 1 .and. aCredRa[1,4] == 0
			If Aviso("Tํtulo(s) nใo encontrado(s)","Deseja continuar ?",{"Sim","Nใo"},1) == 1
				lRet	:= .F.
				lRa		:= .T.
			EndIf
		Else
			msgStop("Certifique-se de que haja tํtulos disponํveis para altera็ใo!","Nใo hแ tํtulo(s) เ ser(em) processado(s).")
			lRet := .F.
		EndIf
		//#RVC20180915.en
	EndIf
Else
	Return atuSl4()
EndIf
//#RVC20180815.bn
If lRet
	
	Processa( { || _lFrmPg := SkForm(aFormPG) }  ,"Aguarde"   ,"Validando informa็๕es...")
	
	If _lFrmPg
		Processa( { || aFormPG := AtuForm(aFormPG) }  ,"Aguarde"   ,"Validando informa็๕es...")
		//aFormPG := AtuForm(aFormPG)
	EndIf
	
	If _lFrmPg := .T.
		Processa( { || aTitulos := AtuTit(aTitulos) }  ,"Aguarde"   ,"Validando informa็๕es...")
		//aTitulos := AtuTit(aTitulos)
		//if len(aFormPG) == len(aTitulos)
			If len(aTitulos) == 1 .and. aTitulos[1,5] == 0		// nใo tem financeiro
				msgStop("Certifique-se de que haja tํtulos disponํveis para altera็ใo!","Nใo hแ tํtulo(s) เ ser(em) processado(s).")
				_lFrmPg := .T.
				lRet := .F.
			EndIf
		//else
			//msgStop("Existe divergencia entre os titulos selecionados!","Aten็ใo")
			//_lFrmPg := .T.
			//lRet := .F.
		//endif
	EndIf
EndIf
//#RVC20180815.en

//If lRet			//#RVC20180915.o
If lRet .OR. lRa	//#RVC20180915.n
	
	lCheque := .F.

	// exclusใo SL4	//#RVC20180719.bn
	begin transaction
	
	dbSelectArea("SL4")
	for nI := 1 to len( aFormPG )
		dbGoto( aFormPG[nI,8] )
		If recno() == aFormPG[nI,8]
			recLock("SL4",.F.)
			dbDelete()
			msUnLock()
		else
			lRet := .F.
			disarmTransaction()
		endIf

		if alltrim(aFormPG[nI,3]) == "CHK"
			lCheque := .T.
		endif

	next

	if lCheque
		fDelSEF(SUA->UA_NUMSC5)
	endif

	//Altero a filial para que nใo seja filtrada as formas de pagamento.
	_cFilOld := cFilAnt	//#RVC20181011.n
	cFilAnt	:= "0101"	//#RVC20181011.n
	
	//Altero o tipo de opera็ใo para que obrigue a digita็ใo do NSU
	If (RecLock("SUA" , .F.))
	
		SUA->UA_OPER := "1"	//#RVC20181107.n
		
		SUA->(MsUnlock())
	
	EndIf
		
	aParcelas := CallVPA()	// Chama tela de Formas de Pagamento
	
	//Devolvo a filial de origem 
	cFilAnt := _cFilOld	//#RVC20181011.n
	
	//Devolvo o tipo de opera็ใo
	
	If (RecLock("SUA" , .F.))
	
		SUA->UA_OPER := _cTpOper	//#RVC20181107.n
		
		SUA->(MsUnlock())
	
	EndIf
		
	If len( aParcelas ) > 0
		
		// ver integra็ใo TeleCheque
		
		// exclusใo SL4
		//#RVC20180719.bo
/*		dbSelectArea("SL4")
		for nI := 1 to len( aFormPG )
			dbGoto( aFormPG[nI,8] )
			If recno() == aFormPG[nI,8]
				recLock("SL4",.F.)
				dbDelete()
				msUnLock()
			else
				lRet := .F.
				disarmTransaction()
			endIf
		next*/
		//#RVC20180719.eo
		
		// criar SL4
//		If lRet
		If lRet .OR. lRa //#RVC20180915.n
			dbSelectArea("SL4")
			for nI := 1 to len( aParcelas )
				
				xTemp := strTokArr( aParcelas[nI,4], "|")
				
				recLock("SL4", .T.)
				SL4->L4_FILIAL  := xFilial("SL4")
				SL4->L4_NUM     := cNumTlv
				SL4->L4_DATA    := aParcelas[nI,1]
				SL4->L4_VALOR   := aParcelas[nI,2]
				SL4->L4_FORMA   := aParcelas[nI,3]
				SL4->L4_OBS     := aParcelas[nI,4]
				SL4->L4_TERCEIR := .F.
//				SL4->L4_AUTORIZ := iIf( len(xTemp)>0, xTemp[2], "" )	//#RVC20180711.o
				SL4->L4_AUTORIZ := IIf( len(xTemp)>1, xTemp[2], "" )	//#RVC20180711.n
				SL4->L4_MOEDA   := 1
				SL4->L4_ORIGEM  := "SIGATMK"
				SL4->L4_XFORFAT := "1"
//				SL4->L4_CGC 	:= separa(aParcelas[nI,4],"|")[5] //AFD20180518.n	//#RVC20180712.o
				//#RVC20180712.bn
				If	Alltrim(aParcelas[nI,3]) $ "CHT|CHK"	
					SL4->L4_CGC 	:= separa(aParcelas[nI,4],"|")[5] 
				EndIf
				SL4->L4_ADMINIS	:= IIf(len(xTemp) > 1,xTemp[1], "" )	//#RVC20180712.n
				SL4->L4_COMP	:= cValToChar(aParcelas[nI,5])			//#RVC20180712.n
				//#RVC20180712.en
				
				if	Alltrim(aParcelas[nI,3]) $ "CHT|CHK"	
					SL4->L4_XPARC := Alltrim(aParcelas[nI,5])
				endif
				
				msUnlock()
			next
		EndIf
		
		U_TMKVSL4(cNumTlv,aParcelas)	//#RVC20180719.n
		
		// exclusใo SE1
		If lRet
			dbSelectArea("SE1")
			for nI := 1 to len( aTitulos )
				dbGoto( aTitulos[nI,7] )
				If recno() == aTitulos[nI,7]
					lMsErroAuto := .F.
					aDados  := {	{"E1_FILIAL"    ,SE1->E1_FILIAL     ,Nil},;
					{"E1_PREFIXO"	,SE1->E1_PREFIXO	,Nil},;
					{"E1_NUM"		,SE1->E1_NUM		,Nil},;
					{"E1_PARCELA"	,SE1->E1_PARCELA	,Nil},;
					{"E1_TIPO"		,SE1->E1_TIPO		,Nil} }
					MsgRun("Excluindo Titulo a Receber: Parc. " + cValToChar(nI) + "/" + cValToChar(Len(aTitulos)),"Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aDados,5) })
					
					If lMsErroAuto
						disarmTransaction()
						mostraErro()
						lRet := .F.
						exit
					endIf
				else
//					lRet := .F. //#RVC20180722.o
					Loop		//#RVC20180722.n
				endIf
			next
		endIf
		
		If lRet			//#RVC20180917.n
		//Exclusใo SE2	//#RVC20180713.bn
		dbSelectArea("SE2")
		SE2->(dbGoTop())
//		If lRet			//#RVC20180917.o
			for nK := 1 to len(aTitulos)
				If Alltrim(aTitulos[nK][4]) $ "CC|CD" .AND. SE2->(dbSeek(xFilial("SE2") + cE2PFX + aTitulos[nK][2] + aTitulos[nK][3] + aTitulos[nK][4]))
					lMsErroAuto := .F.
					aDados2  := {	{"E2_FILIAL"    ,xFilial("SE2")	,Nil},;
									{"E2_PREFIXO"	,cE2PFX			,Nil},;
									{"E2_NUM"		,aTitulos[nK][2],Nil},;
									{"E2_PARCELA"	,aTitulos[nK][3],Nil},;
									{"E2_TIPO"		,aTitulos[nK][4],Nil} }
					MsgRun("Excluindo Titulo a Pagar: Parc. " + cValToChar(nK) + "/" + cValToChar(Len(aTitulos)),"Aguarde", {|| MsExecAuto({|x,y,z| FINA050(x,y,z)}, aDados2,,5)})
						
					If lMsErroAuto
						disarmTransaction()
						mostraErro()
						lRet := .F.
						exit
					endIf
				else
					Loop
				endIf
			next
		EndIf	//#RVC20180713.en

		// criar SE1	
		//#RVC20180717.bn
//		If lRet 			//#RVC20180915.o
		If lRet .OR. lRa	//#RVC20180915.n
			
			If lExecAuto
				MsgRun("Processando...","Aguarde", {|| StaticCall(TMKVPED,CriaTitulo,cNumTlv,cNumPV,3,_cFilAtu,1,"1",@nCredito,SUA->UA_VEND,cARQLOG,cDirImp)})
			Else
				MsgRun("Processando...","Aguarde", {|| StaticCall(TMKVPED,GERASE1,cNumTlv,cNumPV,3,_cFilAtu,1,"1",@nCredito,SUA->UA_VEND,cARQLOG,cDirImp)})
			EndIf
		EndIF
		
//		If lRet				//#RVC20180915.o
 		If lRet .OR. lRa	//#RVC20180915.n
			If nCredito > 0
				cCliente := SUA->UA_CLIENTE
				cLoja    := SUA->UA_LOJA
//				MsgRun("Processando...","Aguarde", {|| StaticCall(TMKVPED,SyBxNCC1,nCredito,@cCliente,@cLoja,_cFilAtu,cNumTlv,cNumPV)})				//#RVC20181030.o
				MsgRun("Processando...","Aguarde", {|| StaticCall(TMKVPED,SyBxNCC1,nCredito,@cCliente,@cLoja,_cFilAtu,cNumTlv,cNumPV,@nCredNCC)})	//#RVC20181030.n
			EndIf
			//#RVC20181030.bn
			recLock("SUA", .F.)
				SUA->UA_XVLRCRD := nCredNCC
			msUnlock()
			//#RVC20181030.en
		EndIf
		
		If lRet
		//Refaz o SL4 do CR anterior mantendo a consistencia na impressใo do PV
			If _nCrAnt > 0
			recLock("SL4", .T.)
					SL4->L4_FILIAL  := xFilial("SL4")
					SL4->L4_NUM     := cNumTlv
					SL4->L4_DATA    := dDataBase
					SL4->L4_VALOR   := _nCrAnt
					SL4->L4_FORMA   := "CR"
					SL4->L4_OBS     := ""
					SL4->L4_TERCEIR := .F.
					SL4->L4_AUTORIZ := ""
					SL4->L4_MOEDA   := 1
					SL4->L4_ORIGEM  := "SIGATMK"
					SL4->L4_XFORFAT := "1"
					SL4->L4_XPARC	:= "1"
				msUnlock()
			EndIf
		EndIf
		//#RVC20180717.en
		
		//#RVC20180719.bo
/*		If lRet
			dbSelectArea("SE1")
			xParc := "00"
			for nI := 1 to len( aParcelas )
				xParc    := Soma1( xParc )
				cNaturez := callNatu( aParcelas[nI,4], aParcelas[nI,3] )
				aDados   := {	{"E1_PREFIXO", cPrefixo          , Nil},;
				{"E1_NUM"    , cNumPV         , Nil},;
				{"E1_PARCELA", xParc          , Nil},;
				{"E1_TIPO"   , aParcelas[nI,3], Nil},;
				{"E1_CLIENTE", SUA->UA_CLIENTE, Nil},;
				{"E1_LOJA"   , SUA->UA_LOJA   , Nil},;
				{"E1_VENCTO" , aParcelas[nI,1], Nil},;
				{"E1_NATUREZ", cNaturez       , Nil},;
				{"E1_VALOR"  , aParcelas[nI,2], Nil},;
				{"E1_PEDIDO" , cNumPV         , Nil},;
				{"E1_CPFCNPJ", cCGC           , Nil},;
				{"E1_NUMSUA" , cNumTlv        , Nil},;
				{"E1_01VLBRU", aParcelas[nI,2], Nil},;
				{"E1_01QPARC", len(aParcelas) , Nil} }
				
				for nJ := 1 to len(aVend)
					If SE1->( fieldPos("E1_VEND"+cValToChar(nJ)) ) > 0
						aadd( aDados, { "E1_VEND"+cValToChar(nJ), aVend[nJ], nil } )
					endIf
				next
				
				MsgRun("Gerando Titulo a Receber: Parc. " + cValToChar(nI) + "/" + cValToChar(Len(aParcelas)),"Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aDados,3) })
				If lMsErroAuto
					MostraErro()
					lRet := .F.
					disarmTransaction()
				EndIf
			next
		endIf
		
		//AFD20180518.bn
		If lRet
			for nI := 1 to len(aParcelas)
				if alltrim(aParcelas[nI][3]) == "CHK"

					dbSelectArea("SEF")
					dbsetorder(1) // EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM
					
					cBanco := avkey(separa(aParcelas[nI,4],"|")[1],"EF_BANCO") 
					cAgencia := avkey(separa(aParcelas[nI,4],"|")[2],"EF_AGENCIA")
					cConta := avkey(separa(aParcelas[nI,4],"|")[3],"EF_CONTA")
					cNumCheque := avkey(separa(aParcelas[nI,4],"|")[4],"EF_NUM")
					cCgc := avkey(separa(aParcelas[nI,4],"|")[5],"EF_CPFCNPJ")
					cTelefone := avkey(separa(aParcelas[nI,4],"|")[6],"EF_TEL")
										
					if dbseek(xfilial("SEF")+ cBanco + cAgencia + cConta + cNumCheque)
						recLock("SEF", .F.)
							
							SEF->EF_NUM := cNumCheque
							SEF->EF_BANCO := cBanco
							SEF->EF_AGENCIA := cAgencia
							SEF->EF_CONTA := cConta 
							SEF->EF_TEL := cTelefone
							SEF->EF_CPFCNPJ := cCgc

						msUnlock()
					endif
				endif
			next
		endif
		//AFD20180518.be
		*/
		//#RVC20180719.eo
						
		If lRet .OR. lRa
			lTudoOK	:= .T.
		else
			disarmTransaction()
			msgAlert("Ocorreu algum problema e nใo foi possํvel concluir a opera็ใo", "Altera Forma de Pagamento")
		endIf
		
	else
		disarmTransaction()
		msgStop( "A็ใo cancelada pelo usuแrio", "Altera Forma de Pagamento")
	endIf
	
	End transaction
	
	if lTudoOK
		msgInfo( "Processo finalizado!", "Altera Forma de Pagamento" )
	end

endIf

//#RVC20180816.bn
SL4->(DbSetOrder(4))
SL4->(dbGoTop())
If SL4->(DbSeek(xFilial("SL4") + cNumTlv))
	While SL4->(!EOF()) .AND. SL4->L4_FILIAL + SL4->L4_NUM == xFilial("SL4") + cNumTlv
		recLock("SL4",.F.)
			SL4->L4_ORIGEM := "SIGATMK"
		msUnLock()
		SL4->(DbSkip())
	EndDo
EndIf
//#RVC20180816.en
		
nModulo := nModOld	//#RVC20180718.n

restArea( aArea )
return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALLNATU  บAutor  ณ Cristiam Rossi     บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function callNatu( cForma, cTipo )
Local cNaturez := "1010018"		// DINHEIRO
Local aArea    := getArea()
Local xTemp    := strTokArr( cForma, "|")

If cTipo == "CH "
	cNaturez := "1010015"	// Tele Cheque
	return cNaturez
elseIf cTipo == "CHK"
	cNaturez := "1010014"	// Cheque Komfort
	return cNaturez
endIf

If len( xTemp ) > 0 .and. len( xTemp[1] ) > 3
	cNaturez := Posicione("SAE",1,xFilial("SAE")+left(xTemp[1],3),"AE_01NAT")
endIf

If Empty(cNaturez)
	If AllTrim(cTipo) == "R$"
		cNaturez := STRTRAN(GetMv("MV_NATDINH"),'"',"")
	ElseIf AllTrim(cTipo) == "CH"
		cNaturez := STRTRAN(GetMv("MV_NATCHEQ"),'"',"")
	Else
		cNaturez := STRTRAN(GetMv("MV_NATOUTR"),'"',"")
	EndIf
EndIf

restArea( aArea )

Return cNaturez

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPREV  บAutor  ณ Cristiam Rossi    บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPrev()

Local nI
Local _cQuery := ""

If Empty(AllTrim(cNumPV))
	MsgStop("Or็amento sem N๚mero do Pedido de Vendas", "Altera Forma de Pagamento")
	Return .F.
EndIf

SC5->( DbSetOrder(1) )
If ! SC5->( DbSeek( xFilial("SC5") + cNumPV ) )
	MsgStop("Pedido de Vendas "+cNumPV+" nใo encontrada na base", "Altera Forma de Pagamento")
	Return .F.
EndIf

For nI := 1 to 5
	If SC5->( fieldPos("C5_VEND"+cValToChar(nI)) ) > 0
		AADD( aVend, SC5->( fieldGet( fieldPos("C5_VEND"+cValToChar(nI)) ) ) )
	EndIf
Next nI

SE1->( dbSetOrder(1) )
SE1->( dbSeek( xFilial("SE1")+cPrefixo+SC5->C5_NUM) )

//#CMG20180424.bn     

If SELECT("_SE1_") > 0
	_SE1_->(DbCloseArea())
EndIf                             

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SE1") + " SE1 "
_cQuery += " WHERE E1_FILIAL='" +XFILIAL("SE1")+ "' AND "
//_cQuery += " E1_PREFIXO = '"+cPrefixo+"' AND " 	//#AFD20180518.o
_cQuery += " E1_MSFIL = '"+SC5->C5_MSFIL+"' AND " 	//#AFD20180518.n
//_cQuery += " E1_PEDIDO = '"+SC5->C5_NUM+"' AND "	//#RVC20181022.o
//#RVC20181022.bn
if _lCanc
	_cQuery += "E1_NUMSUA = '"+SC5->C5_NUMTMK+"' AND "
else
	_cQuery += " E1_PEDIDO = '"+SC5->C5_NUM+"' AND "
endIf
//#RVC20181022.en
//_cQuery += " E1_SALDO > 0 AND "
_cQuery += " SE1.D_E_L_E_T_<>'*'"

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_SE1_",.F.,.T.)
                       
_nValBx := 0

While ! _SE1_->(EOF())

	If _SE1_->E1_SALDO > 0
	
		AADD( aTitulos,{_SE1_->E1_PREFIXO,_SE1_->E1_NUM,_SE1_->E1_PARCELA,_SE1_->E1_TIPO,_SE1_->E1_VALOR,_SE1_->E1_VENCTO,_SE1_->R_E_C_N_O_,_SE1_->E1_NSUTEF,_SE1_->E1_XPARNSU})
		
	Else	
	                   //          1           2             3               4                5                 6               7
		AADD( _aTitBx,{_SE1_->E1_PREFIXO,_SE1_->E1_NUM,_SE1_->E1_PARCELA,_SE1_->E1_TIPO,_SE1_->E1_VALOR,_SE1_->E1_VENCTO,_SE1_->R_E_C_N_O_,_SE1_->E1_NSUTEF,_SE1_->E1_XPARNSU})
		_nValBx += _SE1_->E1_VALOR
	
	EndIf
	
	_SE1_->(DbSkip())
	
EndDo

//#RVC20180723.bn
If len( _aTitBx ) == 0
	AADD( _aTitBx, { "", "", "", "",0, CtoD(""), 0,"",""} )
EndIf
//#RVC20180723.en

//#CMG20180424.en 

If len( aTitulos ) == 0
	AADD( aTitulos, { "", "", "", "", 0, CtoD(""), 0 ,"",""} )
EndIf

_SE1_->(DbCloseArea())

//#RVC20180722.bn
If SELECT("_SE5_") > 0
	_SE5_->(DbCloseArea())
	_cQuery := ""
EndIf                             

_cQuery := " SELECT * "
_cQuery += " FROM " + RETSQLNAME("SE5") + " SE5 "
_cQuery += " WHERE "
_cQuery += " E5_FILIAL='" +XFILIAL("SE5")+ "' AND "
_cQuery += " E5_TIPO IN ('RA','NCC') AND " 
_cQuery += " E5_CLIFOR = '"+SC5->C5_CLIENTE+"' AND "
_cQuery += " E5_LOJA = '"+SC5->C5_LOJACLI+"' AND "
_cQuery += " E5_HISTOR LIKE '%"+ SC5->C5_NUM +"' AND"
_cQuery += " E5_SITUACA <> 'C' AND"
_cQuery += " E5_DTCANBX =' ' AND"
_cQuery += " SE5.D_E_L_E_T_<>'*'"

_cQuery := ChangeQuery(_cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_SE5_",.F.,.T.)

_nCrAnt := 0

While ! _SE5_->(EOF())

 	
	//"Prefixo","N๚mero","Emissใo","Valor","Hist๓rico",""
	AADD( aCredRA,{_SE5_->E5_PREFIXO,_SE5_->E5_NUMERO,_SE5_->E5_DATA,_SE5_->E5_VALOR,_SE5_->E5_HISTOR})
	_nCrAnt += _SE5_->E5_VALOR
		
	_SE5_->(DbSkip())
	
EndDo

If len( aCredRA ) == 0
	AADD( aCredRA, { "", "", CtoD(""), 0, "", ""} )
EndIf

_SE5_->(DbCloseArea())
//#RVC20180722.en

Return len( aTitulos ) > 0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCARGAPGTO บAutor  ณ Cristiam Rossi     บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function cargaPgto()
Local aFormas := {}

SL4->(DbSetOrder(1))
If SL4->(DbSeek(xFilial("SL4")+cNumTlv + "SIGATMK"))
	While ! SL4->(EOF()) .AND. xFilial("SL4") == SL4->L4_FILIAL .AND. SL4->L4_NUM == cNumTlv
		
		If AllTrim(SL4->L4_ORIGEM) == "SIGATMK"
			SL4->( Aadd( aFormPG , { SL4->L4_DATA , SL4->L4_VALOR, SL4->L4_FORMA, SL4->L4_OBS, "", "",.F., RECNO(), SL4->L4_XPARNSU, SL4->L4_NUM } ) )
			//#RVC20180815.bn
			recLock("SL4",.F.)
				SL4->L4_ORIGEM := ""
			msUnLock()
			//#RVC20180815.en
		EndIf

		SL4->(DbSkip())
	End
Else
	Aadd( aFormPG , { CtoD(""), 0, "", "", "", "",.F., 0, "", "" } )
EndIf

Return aClone( aFormPG )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALLPA    บAutor  ณ Cristiam Rossi     บ Data ณ  30/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CallVPA()

Local   aArea        := getArea()
Local   cFunName     := funName()
Local   nOpc         := 3
Local   lHabilita    := nOpc <> 2
Local   aItens       := {}
Local   cCodPagto    := SUA->UA_CONDPG
Local   oCodPagto    := nil
Local   cDescPagto   := posicione("SE4",1,xFilial("SE4")+cCodPagto,"E4_DESCRI")
Local   oDescPagto   := nil
Local   cCodTransp   := SUA->UA_TRANSP
Local   oCodTransp   := nil
Local   cTransp      := posicione("SA4",1,xFilial("SA4")+cCodPagto,"A4_NOME")
Local   oTransp      := nil
Local   cCob         := SUA->UA_ENDCOB
Local   oCob         := nil
Local   cEnt         := SUA->UA_ENDENT
Local   oEnt         := nil
Local   cCidadeC     := SUA->UA_MUNC
Local   oCidadeC     := nil
Local   cCepC        := SUA->UA_CEPC
Local   oCepC        := nil
Local   cUfC         := SUA->UA_ESTC
Local   oUfC         := nil
Local   cBairroE     := SUA->UA_BAIRROE
Local   oBairroE     := nil
Local   cBairroC     := SUA->UA_BAIRROC
Local   oBairroC     := nil
Local   cCidadeE     := SUA->UA_MUNE
Local   oCidadeE     := nil
Local   cCepE        := SUA->UA_CEPE
Local   oCepE        := nil
Local   cUfE         := SUA->UA_ESTE
Local   oUfE         := nil
Local   nLiquido     := SUA->UA_VLRLIQ
Local   oLiquido     := nil
Local   nTxJuros     := 0
Local   oTxJuros     := nil
Local   nTxDescon    := 0
Local   oTxDescon    := nil
Local   aParcelas    := {}
Local   oParcelas    := nil
Local   nEntrada     := SUA->UA_ENTRADA
Local   oEntrada     := nil
Local   nFinanciado  := SUA->UA_FINANC
Local   oFinanciado  := nil
Local   nNumParcelas := SUA->UA_PARCELA
Local   oNumParcelas := nil
Local   nVlJur       := 0
Local   cCodAnt      := cCodPagto
Local   lTipo9       := .F.
Local   oValNFat     := nil
Local   nValNFat     := SUA->UA_VALBRUT
Local   cCliAnt      := SUA->UA_CLIENTE + SUA->UA_LOJA
Local   lSigaCRD     := .F.
Local   lTLVReg      := .F.
Local 	nLiq2		 := 0 //#RVC20180815.n

Private aValores     := {0,0,0,0,0,0,0,0}         					// Array com os valores dos objetos utilizados no Folder do rodape
Private nFolder      := 2
Private aObj         := {nil,nil,nil,nil,nil,nil,nil,nil}

SX5->( dbSeek( xFilial("SX5")+"24" ) )
While ! SX5->(Eof()) .AND. xFilial("SX5")+"24" == SX5->(X5_FILIAL+X5_TABELA)
	Aadd( aItens, { X5DESCRI(), ALLTRIM(SX5->X5_CHAVE) } )
	SX5->(DbSkip())
End

If _lFrmPg
	nLiq2 := _nNwVlr
Else
	nLiq2 := SUA->UA_VLRLIQ - (_nValBx + _nCrAnt)
EndIf
aValores[1] := SUA->UA_VALMERC
aValores[2] := SUA->UA_DESCONT
aValores[3] := SUA->UA_ACRECND
aValores[4] := SUA->UA_FRETE
aValores[5] := SUA->UA_DESPESA
//aValores[6] := SUA->UA_VLRLIQ				//#CMG20180424.o
//aValores[6] := SUA->UA_VLRLIQ - _nValBx	//#CMG20180424.n	//#RVC20180721.o
//aValores[6] := SUA->UA_VLRLIQ - (_nValBx + _nCrAnt)			//#RVC20180721.n	//#RVC20180815.o
aValores[6] := nLiq2			//#RVC20180815.n
aValores[7] := SUA->UA_VALMERC

restArea( aArea )
regToMemory("SUA")

setFunName( "TMKA271" )

Tk273Pagamento(nOpc		,lHabilita		,aItens			,cCodPagto,;
oCodPagto		,cDescPagto		,oDescPagto		,cCodTransp,;
oCodTransp		,cTransp		,oTransp		,cCob,;
oCob			,cEnt			,oEnt			,cCidadeC,;
oCidadeC		,cCepC			,oCepC			,cUfC,;
oUfC			,cBairroE		,oBairroE		,cBairroC,;
oBairroC		,cCidadeE		,oCidadeE		,cCepE,;
oCepE			,cUfE			,oUfE			,nLiquido,;
oLiquido		,nTxJuros		,oTxJuros		,nTxDescon,;
oTxDescon		,aParcelas		,oParcelas		,nEntrada,;
oEntrada		,nFinanciado	,oFinanciado	,nNumParcelas,;
oNumParcelas	,nVlJur			,cCodAnt		,lTipo9,;
oValNFat		,nValNFat		,cCliAnt		,lSigaCRD,;
lTLVReg)

restArea( aArea )

setFunName( cFunName )

return aClone( aParcelas )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ SkForm   บ Autor ณ Rafael V. Cruz     บ Data ณ  14/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array de Formas de Pagto  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SkForm(aFormas)

Local oDlg, oBrw
Local oOk  		:= LoadBitMap(GetResources(), "LBOK")
Local oNo  		:= LoadBitMap(GetResources(), "LBNO")
Local lMVPAR    := .F.
Local aForm2	:= {}
Local _lOk		:= .T.
Local nPos 		:= 0
Local nParcela := 1

DbSelectArea("SX5")
SX5->(DbSetOrder(1))
SX5->(DbGoTop())
For nA := 1 to Len(aFormas) 
	If SX5->(DbSeek(xFilial("SX5") + "24" + Alltrim(aFormas[nA][3])))
	    //SL4->L4_DATA , SL4->L4_VALOR, SL4->L4_FORMA, SL4->L4_OBS, "", "",.F., RECNO(), SL4->L4_XPARNSU, SL4->L4_NUM
		//(tipo, parcela, numuro_atendimento)
		//if vldBx(aFormas[nA][3],aFormas[nA][9],aFormas[nA][10])
			nPos := 0
			
			if alltrim(aformas[nA][3]) == 'R$'
				nPos := ASCAN(aForm2,{|x| Alltrim(x[2]) == Alltrim(aFormas[nA][3])})
			elseif alltrim(aformas[nA][3]) == 'CD'
				nPos := ASCAN(aForm2,{|x| Alltrim(x[2]) == Alltrim(aFormas[nA][3])})
			elseif alltrim(aformas[nA][3]) == 'CC'
				nPos := ASCAN(aForm2,{|x| Alltrim(x[2]) == Alltrim(aFormas[nA][3])})	
			else
				nPos := ASCAN(aForm2,{|x| Alltrim(x[2]) == Alltrim(aFormas[nA][3]) .and.  Alltrim(x[4]) == alltrim(separa(aformas[nA][4],"|")[2]) })
			endif

			If nPos == 0 
				nParcela := 1
				if alltrim(aformas[nA][3]) == 'R$'
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , "", nParcela, aformas[nA][2]} )
				elseif alltrim(aformas[nA][3]) == 'BOL'
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , "", aformas[nA][9], aformas[nA][2]} )
				elseif alltrim(aformas[nA][3]) == 'CD'
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , "", nParcela, aformas[nA][2]} )
				elseif alltrim(aformas[nA][3]) == 'CR'
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , "", nParcela, aformas[nA][2]} )
				elseif alltrim(aformas[nA][3]) == 'CC' //Incluida valida็ใo para tratar o tipo CC sem a fun็ใo SEPARA
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , "", nParcela, aformas[nA][2]} )	
				else
					aAdd( aForm2 , { .F. , SX5->X5_CHAVE , SX5->X5_DESCRI , alltrim(separa(aformas[nA][4],"|")[2]), nParcela, aformas[nA][2]} ) 
				endif
			else
				aForm2[nPos][6] += aformas[nA][2]
				aForm2[nPos][5] := aForm2[nPos][5]++
			EndIf
		//endif
	EndIF
Next

if len(aForm2) == 0
	aAdd(aForm2,{.F.,"","","","", 0})
endif

DEFINE MSDIALOG oDlg FROM 0,0 TO 300,900 TITLE "Formas de Pagamento" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

@ 010, 005 BUTTON "&Confirma"			SIZE 50,10 OF oDlg PIXEL ACTION {|| lMVPAR := .T. , oDlg:End() }
@ 025, 005 BUTTON "&Marcar Todos"		SIZE 50,10 OF oDlg PIXEL ACTION {|| aForm2 := MarkAll(1,aForm2), oBrw:Refresh()}
@ 040, 005 BUTTON "&Desmarcar Todos"	SIZE 50,10 OF oDlg PIXEL ACTION {|| aForm2 := MarkAll(2,aForm2), oBrw:Refresh()}
@ 055, 005 BUTTON "&Sair"				SIZE 50,10 OF oDlg PIXEL ACTION {|| atuSl4(), oDlg:End() }

oBrw:= TWBrowse():New(010,060,390,135,,{"","C๓digo","Descri็ใo","NSU","Parcelas","Valor Total"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(aForm2)
oBrw:bLine := {|| { If(aForm2[oBrw:nAt][1],oOk,oNo)	,;
					aForm2[oBrw:nAt][2]			    ,;
					aForm2[oBrw:nAt][3] 			,;
					aForm2[oBrw:nAt][4]				,;
					aForm2[oBrw:nAt][5]				,;
					aForm2[oBrw:nAt][6]}}

oBrw:bLDblClick := {|| ( aForm2[oBrw:nAt,1] := !aForm2[oBrw:nAt,1] , oBrw:Refresh() ) }

ACTIVATE MSDIALOG oDlg CENTER

IF lMVPAR
	_cChar := ""
	_cNSU := ""
	_cParNSU := ""
	
	For nX:=1 To Len(aForm2)
		IF aForm2[nX,1]
			
			if empty(_cChar)
				_cChar += Alltrim(aForm2[nX,2])
			else
				_cChar += "|" + Alltrim(aForm2[nX,2])
			endif

			if !empty(Alltrim(aForm2[nX,4]))
				if empty(_cNSU)
					_cNSU += Alltrim(aForm2[nX,4]) 
				else
					_cNSU += "|" + Alltrim(aForm2[nX,4]) 
				endif
			endif
			
			if !empty(Alltrim(aForm2[nX,5])) .and. alltrim(aForm2[nX,2]) == "BOL"
				if empty(_cParNSU)
					_cParNSU += Alltrim(aForm2[nX,5])
				else
					_cParNSU += "|" + Alltrim(aForm2[nX,5])
				endif
			endif

		EndIF
	Next
	
Else
	_lOk := .F.
EndIF

Return (_lOk)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ MarkAll  บ Autor ณ LUIZ EDUARDO F.C.  บ Data ณ  23/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Marca/Desmarca todos os itens do array                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION MarkAll(nOpc,aAcols)

Local nX := 0

IF nOpc = 1
	For nX:=1 To Len(aAcols)
		aAcols[nX,1] := .T.
	Next
Else
	For nX:=1 To Len(aAcols)
		aAcols[nX,1] := .F.
	Next
EndIF

RETURN(aAcols)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ AtuForm  บ Autor ณ Rafael V. Cruz     บ Data ณ  15/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Atualiza o Vetor de Forma de pagamento conforme sele็ใo	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AtuForm(aFormas)

Local aFormX := {}

For nY := 1 to Len(aFormas)

	//if vldBx(aFormas[nY][3],aFormas[nY][9],aFormas[nY][10])
		if alltrim(aFormas[nY][3]) == "BOL"
			
			If Alltrim(aFormas[nY][3]) $ _cChar .and. /*alltrim(separa(aFormas[nY][4],"|")[4]) == alltrim(_cNSU) .and.*/ alltrim(aFormas[nY][9]) $ _cParNSU
				aadd(aFormX,aFormas[nY])
				_nNwVlr += aFormas[nY][2]
			EndIf

		elseif alltrim(aFormas[nY][3]) $ "CHK|R$"

			If Alltrim(aFormas[nY][3]) $ _cChar 
				aadd(aFormX,aFormas[nY])
				_nNwVlr += aFormas[nY][2]
			EndIf
		
		elseif alltrim(aFormas[nY][3]) $ "CD"

			If Alltrim(aFormas[nY][3]) $ _cChar 
				aadd(aFormX,aFormas[nY])
				_nNwVlr += aFormas[nY][2]
			EndIf
		
		elseif alltrim(aFormas[nY][3]) $ "CC"  //Incluida valida็ใo para tratar o tipo CC sem a fun็ใo SEPARA 

			If Alltrim(aFormas[nY][3]) $ _cChar 
				aadd(aFormX,aFormas[nY])
				_nNwVlr += aFormas[nY][2]
			EndIf
		
		else

			If Alltrim(aFormas[nY][3]) $ _cChar .and. alltrim(separa(aFormas[nY][4],"|")[2]) $ alltrim(_cNSU)
				aadd(aFormX,aFormas[nY])
				_nNwVlr += aFormas[nY][2]
			EndIf

		endif
	//endif

Next

Return Aclone(aFormX)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ AtuTit   บ Autor ณ Rafael V. Cruz     บ Data ณ  15/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Atualiza o Vetor de Forma de pagamento conforme sele็ใo	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AtuTit(aTitulos)

Local aTituloX := {}

For nZ := 1 to Len(aTitulos)
	
	if alltrim(aTitulos[nZ][4]) == "BOL"  
	
		If Alltrim(aTitulos[nZ][4]) $ _cChar .and. /*Alltrim(aTitulos[nZ][8]) == _cNSU .and.*/ Alltrim(aTitulos[nZ][9]) $ alltrim(_cParNSU)
			aadd(aTituloX,aTitulos[nZ])
		EndIf
	
	elseif alltrim(aTitulos[nZ][4]) $ "CHK|R$"
		
		If Alltrim(aTitulos[nZ][4]) $ _cChar 
			aadd(aTituloX,aTitulos[nZ])
		EndIf
	
	elseif alltrim(aTitulos[nZ][4]) $ "CD"
		
		If Alltrim(aTitulos[nZ][4]) $ _cChar 
			aadd(aTituloX,aTitulos[nZ])
		EndIf
	
	elseif alltrim(aTitulos[nZ][4]) $ "CC"
		
		If Alltrim(aTitulos[nZ][4]) $ _cChar 
			aadd(aTituloX,aTitulos[nZ])
		EndIf	
		
	else

		If Alltrim(aTitulos[nZ][4]) $ _cChar .and. Alltrim(aTitulos[nZ][8]) $ _cNSU
			aadd(aTituloX,aTitulos[nZ])
		EndIf

	endif

Next

If len( aTituloX ) == 0
	AADD( aTituloX, { "", "", "", "", 0, CtoD(""), 0,"", "" } )
EndIf

Return Aclone(aTituloX)

Static Function fSkSE1()

Local _aArea := SE1->(getArea())

dbSelectArea("SE1")
SE1->(dbOrderNickName("SE1TLV"))
SE1->(dbGoTop())
if SE1->(dbSeek(xFilial("SE1") + cNumTlv))
	cNumPV := SE1->E1_NUM
endif
SE1->(dbCloseArea())

RestArea(_aArea)
Return

//--------------------------------------------------------------
/*/{Protheus.doc} vldbx
Description //Validar se o titulo ja esta baixado
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function vldbx(cTipo, cParcela, cAtend)

	Local cQuery := ""
	Local cAlias := getNextAlias()
	Local lRet := .F.
	
	cQuery := "SELECT UA_NUM, UA_NUMSC5, E1_PARCELA, E1_SALDO, E1_TIPO "
	cQuery += " FROM "+ retSqlName("SUA")+ " SUA"
	cQuery += " INNER JOIN "+ retSqlName("SE1")+" SE1 ON SUA.UA_NUMSC5 = SE1.E1_PEDIDO"
	cQuery += " WHERE SUA.UA_NUM = '"+ cAtend +"'"
	cQuery += " AND SE1.E1_PEDIDO = SUA.UA_NUMSC5"
	cQuery += " AND SE1.E1_PARCELA = '"+ cParcela +"'"
	cQuery += " AND SE1.E1_TIPO = '"+ cTipo +"'"
	cQuery += " AND SE1.E1_SALDO > 0"
	cQuery += " AND SE1.D_E_L_E_T_ = ' '
	cQuery += " AND SUA.D_E_L_E_T_ = ' '

	PLSQuery(cQuery, cAlias)

	if (cAlias)->(!eof())
		lRet := .T.
	endif

	(cAlias)->(dbCloseArea())

Return lRet


Static Function atuSl4()

	SL4->(DbSetOrder(4))
	SL4->(dbGoTop())
	If SL4->(DbSeek(xFilial("SL4") + cNumTlv))
		While SL4->(!EOF()) .AND. SL4->L4_FILIAL + SL4->L4_NUM == xFilial("SL4") + cNumTlv
			recLock("SL4",.F.)
				SL4->L4_ORIGEM := "SIGATMK"
			msUnLock()
			SL4->(DbSkip())
		EndDo
	EndIf

return

//--------------------------------------------------------------
/*/{Protheus.doc} NomeDaFuncao
Description //Descri็ใo da Fun็ใo
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since dd/mm/aaaa /*/
//--------------------------------------------------------------
Static Function fDelSEF(cTitulo)

	Local cAlias := getNextAlias()
	Local cQuery := ""

	cQuery := "SELECT R_E_C_N_O_ AS RECNO FROM"+ retsqlname("SEF")
	cQuery += " WHERE EF_TITULO = '"+ cTitulo +"'"
	cQuery += " AND D_E_L_E_T_ = ' '"

	dbSelectArea("SEF")

	PLSQuery(cQuery, cAlias)
		
	while (cAlias)->(!eof())

		dbGoto( (cAlias)->RECNO )
		
		recLock("SEF",.F.)
			dbDelete()
		msUnLock()
		
	(cAlias)->(dbSkip())
	end

	(cAlias)->(DbCloseArea())

Return