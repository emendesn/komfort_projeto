#include "totvs.ch"
#Include "PROTHEUS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} KMTMKA01
มrea de decisใo para operadores das Lojas

@param N/A
@return N/A                                 
@author  Rafael Cruz - Komfort House
@since 27/03/2018

//#RVC20180426 - Corre็ใo na atribui็ใo do perfil de operador.

/*/                                                             
//--------------------------------------------------------------
User Function KMFINA03()
Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Static oDlg

DEFINE MSDIALOG oDlg TITLE "KMFINA03 | Altera Forma de Pagamento" FROM 000, 000  TO 140, 400 COLORS 0, 16777215 PIXEL

@ 001, 001 GROUP oGroup1 TO 070, 202 PROMPT " Tipo de Opera็ใo " OF oDlg COLOR 0, 16777215 PIXEL
@ 020, 010 SAY oSay1 PROMPT "Que opera็ใo deseja realizar?" SIZE 222, 075 OF oGroup1 COLORS 0, 16777215 PIXEL
@ 043, 043 BUTTON oButton1 PROMPT "Altera PV" SIZE 040, 013 OF oGroup1 PIXEL Action (oDlg:End(),U_AltFrmPg())
@ 043, 126 BUTTON oButton2 PROMPT "Altera RA" SIZE 040, 014 OF oGroup1 PIXEL Action (oDlg:End(),fAltRA())
    
ACTIVATE MSDIALOG oDlg CENTERED

Return

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
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function fAltRA()

Local aArea		  := getArea()
Local cFilQuery	  := " E1_TIPO='RA' "
Local aCores	  := {}																			
Private cCadastro := "Mudar Forma de Pagamento - Recebimento Antecipado"
Private aRotina   := {}
Private bEstorna  := {|| alteraRA() }

aadd( aRotina, { "Pesquisar"       ,"AxPesqui" ,0,1,0 ,.F.})
aadd( aRotina, { "Visualizar"      ,"AxVisual" ,0,2,0 ,NIL})
aadd( aRotina, { "Alt. Forma Pagto","eval(bEstorna)"  ,0,4,0 ,NIL})

/*aCores :=   {{" E1_SALDO == E1_VALOR .AND. E1_STATUS == 'A'" , 'BR_VERDE'},; 
			 {" E1_SALDO <> 0 .AND. E1_SALDO < E1_VALOR .AND. E1_STATUS == 'A'", 'BR_AZUL' },;
             {" EMPTY(E1_SALDO) .AND. E1_STATUS == 'B'", 'BR_VERMELHO' }}*/
             
        
Aadd(aCores, { 'ROUND(E1_SALDO,2) = 0'					, 'BR_VERMELHO'	})
Aadd(aCores, { '!Empty(E1_NUMBOR)'						, 'BR_PRETO'	})
Aadd(aCores, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2)'	, 'BR_AZUL'		})
Aadd(aCores, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2)'	, 'BR_VERDE'	})

DbSelectArea("SE1")

mBrowse( 6, 1,22,75,"SE1" ,,,,, ,aCores,,,,,,,,cFilQuery)		//#RVC20181022.n

restArea( aArea )

Return Nil

Static Function alteraRA()

	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local cE2PFX := SuperGetMV("KH_PREFSE2",.F.,"TXA")
	Local cBanco := Space(GetSx3Cache("E1_BCOCHQ"    , "X3_TAMANHO"))
	Local cAgencia := Space(GetSx3Cache("E1_AGECHQ"    , "X3_TAMANHO"))//#WRP20190109.n
	Local cConta := Space(GetSx3Cache("E1_CTACHQ"    , "X3_TAMANHO"))
	Local cVende := SE1->E1_VEND1
	Local cFilOri:= SE1->E1_MSFIL
	Local cTipo	 := ""
	Local cHist	 := SE1->E1_HIST
	Local cPref  := SE1->E1_PREFIXO
	Local cNumTit:= SE1->E1_NUM
	Local cCliSE1:= SE1->E1_CLIENTE
	Local cLojSE1:= SE1->E1_LOJA
	Local aSE1RA := {}
	Local aDados := {}
	Local aDados2:= {}

	Local lRet	 := .T.

	Local nI	 := 0
	Local nK	 := 0

	Local lTudoOk := .F.

	Private nValor := 0
	Private aParcelas := {}
	Private aValores  := {}

	cQuery := " SELECT * FROM SE1010 "
	cQuery += " WHERE E1_FILIAL = '"+ SE1->E1_FILIAL +"'"
	cQuery += " AND E1_PREFIXO = '"+ SE1->E1_PREFIXO +"'
	cQuery += " AND E1_NUM = '"+ SE1->E1_NUM +"'
	cQuery += " AND E1_TIPO <> 'RA'
	cQuery += " AND E1_CLIENTE = '"+ SE1->E1_CLIENTE +"'
	cQuery += " AND E1_LOJA = '"+ SE1->E1_LOJA +"'
	cQuery += " AND SE1010.D_E_L_E_T_ = ' ' "

	If SELECT(cAlias) > 0
		(cAlias)->(DbCloseArea())
	EndIf    

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!EOF())
		aAdd(aSE1RA,{;
						(cAlias)->E1_MSFIL,;
						(cAlias)->E1_PREFIXO,;
						(cAlias)->E1_NUM,;
						(cAlias)->E1_PARCELA,;
						(cAlias)->E1_TIPO,;
						(cAlias)->E1_VALOR,;
						(cAlias)->E1_NUMBOR,;
						(cAlias)->E1_BAIXA,;
						(cAlias)->E1_SALDO,;
						(cAlias)->R_E_C_N_O_;
					};
			)
		
		nValor += (cAlias)->E1_VALOR
		(cAlias)->(dbSkip())
	endDo

	DEFINE MSDIALOG oDlg FROM 0,0 TO 380,590 TITLE "Tํtulos existentes" Of oMainWnd PIXEL

	oTFolder := TFolder():New( 2, 5, {'Tํtulos a Receber'},,oDlg,,,,.T.,,290,150 )

	@ 5,5 say "Tํtulos existentes relacionados ao R.A." of oTFolder:aDialogs[1] pixel
	@ 15,5 LISTBOX oList1 Fields HEADER "Filial","Prefixo","Numero","Parcela","Tipo","Valor","Bordero","Baixado","Saldo","" SIZE 280,110  OF oTFolder:aDialogs[1] PIXEL
	oList1:SetArray(aSE1RA)
	oList1:bLine := { || { aSE1RA[oList1:nAt,1], aSE1RA[oList1:nAt,2], aSE1RA[oList1:nAt,3], aSE1RA[oList1:nAt,4],aSE1RA[oList1:nAt,5],aSE1RA[oList1:nAt,6],aSE1RA[oList1:nAt,7],aSE1RA[oList1:nAt,8],aSE1RA[oList1:nAt,9], "" }}

	@ 160, 05 say "Voc๊ confirma a exclusใo do(s) registro(s) acima?" of oDlg Pixel

	@ 170, 05 button oBtnExc prompt "Excluir" size 40,15 of oDlg pixel action ( lRet := .T., oDlg:end() )
	@ 170, 250 button "Sair" size 40,15 of oDlg pixel action ( lRet := .F., oDlg:end() )
	/*
	If len(aTitulos) == 1 .and. aTitulos[1,5] == 0		// nใo tem financeiro
	oBtnExc:disable()
	endIf
	*/
	Activate msDialog oDlg Centered

	BEGIN TRANSACTION

	If lRet
		If len(aSE1RA) == 1 .and. aSE1RA[1,6] == 0		// nใo tem financeiro
			msgStop("Certifique-se de que haja tํtulos disponํveis para altera็ใo!","Nใo hแ tํtulo(s) เ ser(em) processado(s).")
			lRet := .F.
		EndIf
	Else
		Return
	endIf

	If lRet
		dbSelectArea("SE1")
		for nI := 1 to len( aSE1RA )
			dbGoto( aSE1RA [nI,10] )
			If recno() == aSE1RA[nI,10]
				lMsErroAuto := .F.
				aDados  := {	{"E1_FILIAL"    ,SE1->E1_FILIAL     ,Nil},;
								{"E1_PREFIXO"	,SE1->E1_PREFIXO	,Nil},;
								{"E1_NUM"		,SE1->E1_NUM		,Nil},;
								{"E1_PARCELA"	,SE1->E1_PARCELA	,Nil},;
								{"E1_TIPO"		,SE1->E1_TIPO		,Nil} }
				MsgRun("Excluindo Titulo a Receber: Parc. " + cValToChar(nI) + "/" + cValToChar(Len(aSE1RA)),"Aguarde", {|| MSExecAuto({|x,y| Fina040(x,y)},aDados,5) })
						
				If lMsErroAuto
					disarmtransaction()
					mostraErro()
					lRet := .F.
					exit
				endIf
			else
				Loop	
			endIf
		next
	Else
		Return
	EndIf

	If lRet
		dbSelectArea("SE2")
		SE2->(dbSetOrder(1))
		SE2->(dbGoTop())
		for nK := 1 to len(aSE1RA)								// FILIAL    + PREFIX  + NUM + PARCELA + TIPO
			If Alltrim(aSE1RA[nK][5]) $ "CC|CD" .AND. SE2->(dbSeek(xFilial("SE2") + cE2PFX + aSE1RA[nK][3] + aSE1RA[nK][4] + aSE1RA[nK][5]))
				lMsErroAuto := .F.
				aDados2  := {	{"E2_FILIAL"    ,xFilial("SE2")	,Nil},;
								{"E2_PREFIXO"	,cE2PFX			,Nil},;
								{"E2_NUM"		,aSE1RA[nK][3]	,Nil},;
								{"E2_PARCELA"	,aSE1RA[nK][4]	,Nil},;
								{"E2_TIPO"		,aSE1RA[nK][5]	,Nil}}
				MsgRun("Excluindo Titulo a Pagar: Parc. " + cValToChar(nK) + "/" + cValToChar(Len(aSE1RA)),"Aguarde", {|| MsExecAuto({|x,y,z| FINA050(x,y,z)}, aDados2,,5)})
						
				If lMsErroAuto
					disarmtransaction()
					mostraErro()
					lRet := .F.
					exit
				endIf
			else
				Loop
			endIf
		next
	Else
		Return
	EndIF
		
	If !lRet
		disarmtransaction()
		Return
	Else

		If Empty(AllTrim(cVende))
			disarmtransaction()
			MsgStop("Por favor preencher o vendedor!","NOVEND")   
			lRet   := .F.  
		EndIf   
		
		If cFilAnt == '0101'
			If Empty(AllTrim(cFilOri))
				disarmtransaction()
				MsgStop("Por favor preencher a filial!","NOFIL")
				lRet   := .F.		
			EndIf	
		EndIf                 
		
		aValores 	:= {nValor,0,0,0,0,0,0,nValor}
		aParcelas	:= U_MtForma(nValor,aValores)

		FilBco(aParcelas,@cBanco,@cAgencia,@cConta,@cTipo)
		
		if Len(aParcelas)==0
			disarmtransaction()
			MsgStop("As formas de pagamento nใo foram definidas","Errooooou!")
			lRet   := .F.
		endIf

		If lRet

			If !Empty(cConta)
				
				If Len(aParcelas) >= 1
	//				FwMsgRun( ,{|| lRet := FGeraSE1(aParcelas,cPref,cNumTit,cTipo,cHist,cBanco,cAgencia,cConta,cVende,cFilOri) }, , "Por favor, aguarde gerando o(s) tํtulo(s)..." )
					FwMsgRun( ,{|| lRet := StaticCall(LANCRA,FGeraSE1,aParcelas,cPref,cNumTit,cTipo,cCliSE1,cLojSE1,cHist,cBanco,cAgencia,cConta,cVende,cFilOri) }, , "Por favor, aguarde gerando o(s) tํtulo(s)..." )
				Else
					disarmtransaction()
					MsgStop("Nใo serแ possivel confirmar a opera็ใo, sem escolher a forma de pagamento.","Aten็ใo")
					Return
				Endif
				
			Else
				disarmtransaction()
				MsgStop("ษ obrigat๓rio informar os dados do banco.","Aten็ใo")
				Return
			Endif
			
			lTudoOk := .T.
			
		Else
			Return
		EndIf
		
	Endif                                            

	END TRANSACTION

	if lTudoOk
		MsgInfo("Opera็ใo concluํda.","Fim da Altera็ใo")
	endIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออัออออออออออออออออออออออหออออออัออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ FILBCO   บ Autor  ณ  Eduardo Patriani.   บ Data ณ  10/01/17            บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra o banco no cadastro de formas de pagamentos (RA)                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FilBco(aParcelas,cBanco,cAgencia,cConta,cTipo)

If Len(aParcelas) > 0
	
	DbSelectArea("Z02")
	DbSetOrder(1)
	DbSeek(xFilial("Z02") + aParcelas[1][3] )
	
	cBanco:=Z02->Z02_BANCO
	
	cAgencia:=Z02->Z02_AGENCI
	
	cConta:=Z02->Z02_NUMCON
	
	cTipo := IF(Z02->Z02_OPER=="1","RA","PR")
	
EndIF

Return