#include "Protheus.ch"

#DEFINE MERCADORIA 	1
#DEFINE DESCONTO	2
#DEFINE	 ACRESCIMO	3
#DEFINE	 FRETE	   	4
#DEFINE	 DESPESA	5
#DEFINE	 BASEDUP	6
#DEFINE	 SUFRAMA	7
#DEFINE	 TOTAL		8

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  LANCRA  º Autor  ³  Luiz Eduardo F.C.   º Data ³  27/07/16            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TELA CUSTOMIZADA PARA LANCAMENTOS DE TITULOS DE RECEBIMENTO ANTECIPADO º±±
±±º          ³ CONTROLE NA TELA DE FORMA DE PAGAMENTO PELA VARIAVEL LTELRA            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORT HOUSE                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION LANCRA()

//Local cPrefixo    := cFilAnt #RVC20180322.o
Local cPrefixo    := SuperGetMv("KM_PREFIXO",.T.,"ADM") //Parâmetro deve ser único por Loja. Este parâmetro identificará o RA de cada loja com seu prefixo.
Local cNumTit     := GetSxeNum("SE1","E1_NUM")
Local cHist       := Space(GetSx3Cache("E1_HIST"      , "X3_TAMANHO"))
Local nValor      := 0
Local dDtPagto    := dDataBase
Local nOpc		  := 1			
                   
Private oTelaRA
Private cCliRA    := Space(GetSx3Cache("E1_CLIENTE"   , "X3_TAMANHO"))
Private cLjCliRA  := Space(GetSx3Cache("E1_LOJA"      , "X3_TAMANHO"))
Private cNomeRA   := Space(GetSx3Cache("E1_NOMCLI"    , "X3_TAMANHO"))
Private cBanco 	  := Space(GetSx3Cache("E1_BCOCHQ"    , "X3_TAMANHO"))
Private cAgencia  := Space(GetSx3Cache("E1_AGECHQ"    , "X3_TAMANHO"))
Private cConta	  := Space(GetSx3Cache("E1_CTACHQ"    , "X3_TAMANHO"))
//Private _cVende   := Space(GetSx3Cache("E1_VEND1"    , "X3_TAMANHO"))	//#CMG20180918.n	//#RVC20180926.o
Private _cNomVe	  := Space(GetSx3Cache("A3_NOME"    , "X3_TAMANHO"  ))	//#CMG20180918.n
Private _cVende   := RetVend()											//#RVC20180926.n
Private _cFil     := Space(GetSx3Cache("E1_FILIAL"    , "X3_TAMANHO"))	//#CMG20180918.n
Private cTipo     := ""
Private _cCGC	  := ""													//#CMG20181001.n
Private aParcelas := {}
Private aValores  := {}
//Private bFormaPg  := {|| aParcelas := U_MtForma(nValor,aValores) }																//#RVC20180628.o
Private bFormaPg  := {|| aParcelas := U_MtForma(nValor,aValores,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.T.) }	//#RVC20180628.n

Private bBanco    := {|| FilBco(aParcelas,@cBanco,@cAgencia,@cConta,@oBanco,@oAgencia,@oConta,@cTipo) }
Private oBanco 	  := Nil
Private oAgencia  := Nil
Private oConta	  := Nil
Private lExecAuto := GetMv("KM_EXECAUT",,.T.)	//#RVC20181220.n

DEFINE MSDIALOG oTelaRA TITLE "Lançamentos - Recebimento Antecipado" FROM 000,000 TO 440, 465 PIXEL

@ 010, 005 SAY "Cliente" SIZE 50,10 PIXEL OF oTelaRA
@ 008, 025 MSGET cCliRA PICTURE PesqPict("SE1","E1_CLIENTE") SIZE 40,10 PIXEL OF oTelaRA F3 GetSx3Cache("E1_CLIENTE", "X3_F3") VALID VLDCLIENTE().and.!vazio() 


@ 010, 070 SAY "Loja" SIZE 50,10 PIXEL OF oTelaRA
@ 008, 085 MSGET cLjCliRA PICTURE PesqPict("SE1","E1_LOJA") SIZE 20,10 PIXEL OF oTelaRA

@ 025, 005 SAY "Nome" SIZE 35,10 PIXEL OF oTelaRA
@ 023, 025 MSGET cNomeRA PICTURE PesqPict("SE1","E1_NOMCLI") SIZE 200,10 PIXEL OF oTelaRA WHEN .F.

@ 040, 000 SAY Replicate("-",500) SIZE 500,10 PIXEL OF oTelaRA

@ 055, 005 SAY "Pref./Loja" SIZE 35,10 PIXEL OF oTelaRA
@ 053, 035 MSGET cPrefixo PICTURE PesqPict("SE1","E1_PREFIXO") SIZE 20,10 PIXEL OF oTelaRA WHEN .F.

//@ 055, 055 SAY "Número" SIZE 35,10 PIXEL OF oTelaRA												//RC20180317.bo
//@ 053, 080 MSGET cNumTit PICTURE PesqPict("SE1","E1_NUM") SIZE 30,10 PIXEL OF oTelaRA WHEN .F.	//RC20180317.eo

@ 055, 060 SAY "Número" SIZE 35,10 PIXEL OF oTelaRA												//RC20180317.bn
@ 053, 085 MSGET cNumTit PICTURE PesqPict("SE1","E1_NUM") SIZE 30,10 PIXEL OF oTelaRA WHEN .F.	//RC20180317.en

@ 055, 130 SAY "Data Pagamento" SIZE 50,10 PIXEL OF oTelaRA
@ 053, 175 MSGET dDtPagto PICTURE PesqPict("SE1","E1_EMISSAO") SIZE 50,10 PIXEL OF oTelaRA WHEN .F.

@ 075, 005 SAY "Valor R$" SIZE 35,10 PIXEL OF oTelaRA
@ 073, 035 MSGET nValor PICTURE PesqPict("SE1","E1_VALOR") SIZE 60,10 PIXEL OF oTelaRA Valid (nValor > 0)

@ 095, 005 SAY "Histórico" SIZE 35,10 PIXEL OF oTelaRA
//@ 093, 035 MSGET cHist PICTURE PesqPict("SE1","E1_HIST") SIZE 190,10 PIXEL OF oTelaRA 					//#RVC20180730.o
@ 093, 035 MSGET cHist PICTURE PesqPict("SE1","E1_HIST") SIZE 190,10 PIXEL OF oTelaRA VALID !Empty(cHist)	//#RVC20180730.n

//#CMG20180918.bn                                                                                      

@ 105, 000 SAY Replicate("-",500) SIZE 500,10 PIXEL OF oTelaRA                                                              

@ 120, 005 SAY "Vendedor" SIZE 50,10 PIXEL OF oTelaRA
@ 118, 035 MSGET _cVende PICTURE PesqPict("SE1","E1_VEND1") SIZE 40,10 PIXEL OF oTelaRA F3 "SA3" WHEN Empty(_cVende) VALID fValidVend(_cVende) .And. Existcpo("SA3") .And. !vazio()

If cFilAnt == '0101'                      
	
	@ 120, 085 SAY "Filial" SIZE 50,10 PIXEL OF oTelaRA
	@ 118, 105 MSGET _cFil PICTURE PesqPict("SE1","E1_FILIAL") SIZE 40,10 PIXEL OF oTelaRA F3 "SM0" VALID !vazio()
	
EndIf                    

@ 140, 005 SAY "Nome" SIZE 35,10 PIXEL OF oTelaRA
@ 138, 025 MSGET _cNomVe PICTURE PesqPict("SA3","A3_NOME") SIZE 200,10 PIXEL OF oTelaRA WHEN .F.

//#CMG20180918.en

@ 150, 000 SAY Replicate("-",500) SIZE 500,10 PIXEL OF oTelaRA                                                              

If !IsInCallStack('TMKA271') //#RVC20180317.bn
	@ 168, 005 SAY "Banco" SIZE 35,10 PIXEL OF oTelaRA
	@ 166, 035 MSGET oBanco VAR cBanco  PICTURE PesqPict("SE1","E1_BCOCHQ") SIZE 30,10 PIXEL OF oTelaRA /*WHEN .F. */F3 GetSx3Cache("A2_BANCO", "X3_F3")
	
	@ 168, 085 SAY "Agencia" SIZE 35,10 PIXEL OF oTelaRA
	@ 166, 110 MSGET oAgencia VAR cAgencia  PICTURE PesqPict("SE1","E1_AGECHQ") SIZE 30,10 PIXEL OF oTelaRA //WHEN .F.
	
	@ 168, 150 SAY "Conta" SIZE 50,10 PIXEL OF oTelaRA
	@ 166, 175 MSGET oConta VAR cConta  PICTURE PesqPict("SE1","E1_CTACHQ") SIZE 50,10 PIXEL OF oTelaRA //WHEN .F.
Else 						//#RVC20180317.en
	@ 168, 005 SAY "Banco" SIZE 35,10 PIXEL OF oTelaRA
	@ 166, 035 MSGET oBanco VAR cBanco  PICTURE PesqPict("SE1","E1_BCOCHQ") SIZE 30,10 PIXEL OF oTelaRA WHEN .F. F3 GetSx3Cache("A2_BANCO", "X3_F3")
	
	@ 168, 085 SAY "Agencia" SIZE 35,10 PIXEL OF oTelaRA
	@ 166, 110 MSGET oAgencia VAR cAgencia  PICTURE PesqPict("SE1","E1_AGECHQ") SIZE 30,10 PIXEL OF oTelaRA WHEN .F.
	
	@ 168, 150 SAY "Conta" SIZE 50,10 PIXEL OF oTelaRA
	@ 166, 175 MSGET oConta VAR cConta  PICTURE PesqPict("SE1","E1_CTACHQ") SIZE 50,10 PIXEL OF oTelaRA WHEN .F.
EndIf

@ 180, 000 SAY Replicate("-",500) SIZE 500,10 PIXEL OF oTelaRA

@ 200, 005 BUTTON  "&Forma Pagamento" 	SIZE 060,015 PIXEL OF oTelaRA ACTION ( aValores := {nValor,0,0,0,0,0,0,nValor} , If(nValor > 0,( Eval(bFormaPg) , Eval(bBanco) ),{MsgStop("É obrigátorio o preenchimento do campo Valor R$","Atenção"),.F.} ))
@ 200, 150 BUTTON  "&Confirma"			SIZE 030,015 PIXEL OF oTelaRA ACTION ( FSair(aParcelas,oTelaRA,cPrefixo,cNumTit,cTipo,cHist,cConta,1,cBanco,cAgencia,_cVende,_cFil) )
@ 200, 190 BUTTON  "&Sair"				SIZE 030,015 PIXEL OF oTelaRA ACTION ( FSair(aParcelas,oTelaRA,cPrefixo,cNumTit,cTipo,cHist,cConta,2,cBanco,cAgencia,_cVende,_cFil) )


ACTIVATE DIALOG oTelaRA

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  FSair   ºAutor  ³Microsiga           º Data ³  30/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de validacao da saida da rotina.                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FSair(aParcelas,oTelaRA,cPrefixo,cNumTit,cTipo,cHist,cConta,nOpc,cBanco,cAgencia,_cVende,_cFil)

Local lOk   := .T.
Local cMsg  := "Não será possivel confirmar a operação, sem escolher a forma de pagamento."
Local cMsg1 := "É obrigatório informar os dados do banco."

If nOpc == 2
	RollbackSx8()	//#RVC20181106.n
	lOk := .T.
Else

	If Empty(AllTrim(_cVende))
	
		MsgStop("Por favor preencher o vendedor!","NOVEND")   
		lOk   := .F.  
	
	EndIf   
	
	If cFilAnt == '0101'
		
		If Empty(AllTrim(_cFil))
			
			MsgStop("Por favor preencher a filial!","NOFIL")
			lOk   := .F.
			
		EndIf
		
	EndIf                 

	If lOk

		If !Empty(cConta)
			
			If Len(aParcelas) >= 1
	//			Begin Transaction	//#RVC20180628.o
				
//				FwMsgRun( ,{|| lOk := FGeraSE1(aParcelas,cPrefixo,cNumTit,cTipo,cHist,cBanco,cAgencia,cConta,_cVende,_cFil) }, , "Por favor, aguarde gerando o(s) título(s)..." )					//#RVC20181226.o
				FwMsgRun( ,{|| lOk := FGeraSE1(aParcelas,cPrefixo,cNumTit,cTipo,cCliRA,cLjCliRA,cHist,cBanco,cAgencia,cConta,_cVende,_cFil) }, , "Por favor, aguarde gerando o(s) título(s)..." )	//#RVC20181226.o
				
	//			End Transaction		//#RVC20180628.o
			Else
				MsgStop(cMsg,"Atenção")
			Endif
			
		Else
			MsgStop(cMsg1,"Atenção")
		Endif
		
	EndIf
	
Endif                                                                                                         

If lOk
	oTelaRA:End()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FGeraSE1 ºAutor  ³Microsiga           º Data ³  30/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para geracao dos titulos de RA.                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FGeraSE1(aParcelas,cPrefixo,cTitulo,cTipo,cCliRA,cLjCliRA,cHist,cBanco,cAgencia,cConta,_cVende,_cFil)

Local aRotAuto 		:= {}
Local aDados		:= {}
Local aBaixa   		:= {}
Local cNatRec  		:= ""
Local nX			:= 0
Local nY			:= 0		//#RVC20180702.n
Local cParcela		:= 0		//#RVC20180829.n
Local nModOld		:= nModulo
Local lConfirma		:= .F.
Local aCheque		:= {}
Local lCartao		:= .F.
Local lGeraTaxa    	:= .F.
Local cSAECod      	:= ""
Local cForma		:= ""
Local cPortado 		:= GetMv("KM_PORTADO",,"C01") 		// INCLUIDO UM PARAMETRO PARA TRAZER POR PADRAO O BANCO GERADOR DOS TITULOS [E1_PORTADO] - LUIZ EDUARDO F.C. - 16.08.2017
Local cNatRA 		:= GetMv("KH_XNATRA",,"6000003") 	// PARAMETRO UTILIZADO PARA PEGAR A NATUREZA CORRETA DO RA - LUIZ EDUARDO F.C. - 28.12.2017
Local nVlrTot      	:= 0
Local nNatTX        := "" // GRAVA A NATUREZA ADMINISTRATIVA (SAE) NO CASO DE GERAR AS TAXAS NO CONTAS A PAGAR - LUIZ EDUARDO F.C. - 28.12.2017
Local cDescNat      := "" // GRAVA A DESCRICAO DA NATUREZA - LUIZ EDUARDO F.C. - 31/08/2018
Local cCodSAE       := ""       
Local cForTX        := ""
Local cLojTX        := ""
Local cTpTax		:= ""
//Local nTmpTx		:= 0
Local _cFilName		:= ""
Local _cCgc			:= ""
Local aNSU			:= {}	//#RVC20180628.n
Local cParcNSU		:= "0"	//#RVC20180628.n 
Local cBand			:= ""	//#RVC20180628.n
Local lRet			:= .T.	//#RVC20180821.n
Local _lFil         := .F.  //#CMG20180918.n
Local cTpPagto		:= SuperGetMV("KH_CPTPPG",.F.,"20") //#RVC20180921.n
Local cDscAdm		:= ""	//#RVC20181206.n
Private _nTmpTx		:= 0	//#RVC20180821.n
Private lMSHelpAuto	:= .T.
Private lMsErroAuto := .F.
Private lExecAuto := SuperGetMV("KM_EXECAUT",.F.,.F.)

nModulo := 06                                                                                       

If cFilAnt == '0101'

	If !Empty(AllTrim(_cFil))
	
		cFilAnt 	:= _cFil  
		_lFil   	:= .T.
		_cFilName	:= Alltrim(FWFILIALNAME(cEmpAnt,cFilAnt,1)) //#RVC20180326.n
    EndIf
Else
	_cFilName	:= Alltrim(FWFILIALNAME(cEmpAnt,cFilAnt,1)) //#RVC20180326.n
EndIf                                       

//Begin Transaction //#RVC20180821.n	//#AFD20181123.o

For nX := 1 To Len(aParcelas)
	
	cParcela 	:= Strzero(nX,TamSx3("E1_PARCELA")[1])	//#RVC20180801.o	//#RVC20180829.n
//	cParcela 	:= SOMA1(cParcela)						//#RVC20180801.n	//#RVC20180829.O
	aRotAuto	:= {}
	aDados		:= {}
	lMSHelpAuto	:= .T.
	lMsErroAuto := .F.
	
	IF aParcelas[nX,3] $ "CH/CHT/CHK"
		cCodSAE := Right(aParcelas[nX][4],3)
	Else
		cCodSAE := Left(aParcelas[nX][4],3)
	EndIF
	
	DbSelectArea("SAE")
	DbSetOrder(1)
	If DbSeek(xFilial("SAE") + AvKey(cCodSAE,"AE_COD") )
		cNatRec  := SAE->AE_01NAT
		cDescNat := SAE->AE_DESC
		lCartao  := .T.
		cPortado := SAE->AE_XPORTAD		// TRAZ O BANCO CADASTRADO NO SAE - LUIZ EDUARDO F.C. - 16.08.2017
		nNatTX   :=	SAE->AE_01NATTX		// TRAZ A NATUREZA NO CASO DE GERAR AS TAXAS NO SE2 - 28.12.2017
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FAZ TRATAMENTO PARA TAXAS DE ADMINISTRADORA - LUIZ EDUARDO .F.C. - 21.07.2017 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF SAE->AE_TAXA > 0
//			cNumSA2   := IncSA2()		//#RVC20181126.o
			cNumSA2	  := "999999"		//#RVC20181126.n
			cSAECod   := SAE->AE_TIPO
			lGeraTaxa := .T.         			  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ID K098 - TRATA OS TITULOS DE TAXA PARA CRIAR PARA UM UNICO FORNECEDOR - LUIZ EDUARDO F.C. - 02.02.2018 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValAdm	:= aParcelas[nX,2]*SAE->AE_TAXA //#RVC20180321.n
			cForTX	:= SAE->AE_XFORTX
			cLojTX	:= SAE->AE_XLJTX
			cTpTax	:= "1"
			cDscAdm	:= SAE->AE_DESC
		Else 							//#RVC20180321.bn
//			cNumSA2	:= IncSA2()			//#RVC20181126.o
			cNumSA2	:= "999999"			//#RVC20181126.n						
			cSAECod	:= SAE->AE_TIPO		  
			
			DbSelectArea("MEN")
			MEN->(DbSetOrder(2))
			MEN->(DbGoTop())
			MEN->(DbSeek(xFilial("MEN") + SAE->AE_COD))
			If MEN->(EOF())
				lGeraTaxa := .F.
			Else			
				While MEN->(!EOF()) .AND. MEN->MEN_FILIAL + MEN->MEN_CODADM == xFilial("MEN") + SAE->AE_COD
					IF Len(aParcelas) >= MEN->MEN_PARINI .AND. Len(aParcelas) <= MEN->MEN_PARFIN
						nValAdm	:= aParcelas[nX,2]*MEN->MEN_TAXADM
						_nTmpTx := MEN->MEN_TAXADM
						cDscAdm	:= MEN->MEN_XDESC			//#RVC20181206.n
					EndIF
					MEN->(DbSkip())
				EndDo
				//nValAdm	:= aParcelas[nX,2]*SAE->AE_TAXA
				cForTX	:= SAE->AE_XFORTX
				cLojTX	:= SAE->AE_XLJTX
				lGeraTaxa := .T.
				cTpTax	:= "2"
			EndIf
		Endif 							//#RVC20180321.en
	Endif
	
	IF Empty(cNatRec)
		If AllTrim(aParcelas[nX,3]) == "R$"
			cNatRec := SuperGetMv("MV_NATDINH",.T.,"1010018")
		ElseIf AllTrim(aParcelas[nX,3]) == "CH"
			cNatRec := SuperGetMv("MV_NATCHEQ",.T.,"1010014")
		Else
			cNatRec := SuperGetMv("MV_NATOUTR",.T.,"102")
		Endif
	EndIF
	
	cForma := aParcelas[nX,3]
	
	AAdd( aRotAuto, { "E1_PREFIXO"	, cPrefixo								, NIL } )
	AAdd( aRotAuto, { "E1_NUM"    	, cTitulo								, NIL } )
	AAdd( aRotAuto, { "E1_TIPO"   	, aParcelas[nX,3]						, NIL } )
	AAdd( aRotAuto, { "E1_NATUREZ"	, cNatRec								, NIL } )
	AAdd( aRotAuto, { "E1_PARCELA"	, cParcela								, NIL } )
	AAdd( aRotAuto, { "E1_CLIENTE"	, cCliRA								, NIL } )
	AAdd( aRotAuto, { "E1_LOJA"   	, cLjCliRA								, NIL } )
	AAdd( aRotAuto, { "E1_EMISSAO"	, dDataBase								, NIL } )
	AAdd( aRotAuto, { "E1_VENCTO" 	, aParcelas[nX,1]						, NIL } )
	AAdd( aRotAuto, { "E1_VENCREA"	, DataValida( aParcelas[nX,1] )			, NIL } )
	AAdd( aRotAuto, { "E1_VALOR"  	, aParcelas[nX,2]						, NIL } )
	AAdd( aRotAuto, { "E1_HIST"	  	, cHist									, NIL } )
	AAdd( aRotAuto, { "E1_VEND1"	, _cVende								, NIL } )	
	AAdd( aRotAuto, { "E1_USRNAME"	, UsrRetName(__cUserID)					, Nil } )
	AAdd( aRotAuto, { "E1_FORMREC"	, aParcelas[nX,3]						, "AlwaysTrue()" } )
	AAdd( aRotAuto, { "E1_PORTADO"	, cPortado								, "AlwaysTrue()" } )
	AAdd( aRotAuto, { "E1_01MOTIV"	, "999999"								, "AlwaysTrue()" } )
//	AAdd( aRotAuto, { "E1_01QPARC"	, Len(aParcelas)	   					, Nil } ) //#RVC20181001.o
	AAdd( aRotAuto, { "E1_01QPARC"	, Val(aParcelas[nX,5]) 					, Nil } ) //#RVC20181001.n
	AAdd( aRotAuto, { "E1_01VLBRU"	, aParcelas[nX,2]	   					, Nil } )
	AAdd( aRotAuto, { "E1_XDESCFI"	, _cFilName								, NIL } ) //#RVC20180326.n
//	AAdd( aRotAuto, { "E1_ORIGEM"	, "TMKVPA"								, NIL } ) //#RVC20180328.n	//#RVC20181129.o
	AAdd( aRotAuto, { "E1_ORIGEM"	, "FINA040"								, NIL } ) 					//#RVC20181129.n
	AAdd( aRotAuto, { "E1_CPFCNPJ"	, _cCGC									, NIL } ) //#RVC20181001.n 
	IF cTipo == "RA"
		AADD( aRotAuto, { "cBancoAdt"  		, cBanco						, Nil } )
		AADD( aRotAuto, { "cAgenciaAdt" 	, cAgencia						, Nil } )
		AADD( aRotAuto, { "cNumCon"  		, cConta						, Nil } )
	EndIF
	
	If Alltrim(aParcelas[nX,3]) $ "CD|CC"
		aDados := Separa(aParcelas[nX,4],"|")
		
		AAdd( aRotAuto, { "E1_ADM"		, LEFT(aParcelas[nX,4],3)							, "AlwaysTrue()" } )
		//#RVC20180731.bo
		//AAdd( aRotAuto, { "E1_CARTAUT"	, Strzero(VAL(aDados[2]),TAMSX3("E1_CARTAUT")[1])	, "AlwaysTrue()" } )
		//AAdd( aRotAuto, { "E1_NSUTEF"	, Strzero(VAL(aDados[2]),TAMSX3("E1_NSUTEF")[1])	, "AlwaysTrue()" } )
		//AAdd( aRotAuto, { "E1_DOCTEF"	, Strzero(VAL(aDados[2]),TAMSX3("E1_DOCTEF")[1])	, "AlwaysTrue()" } )
		//#RVC20180731.eo
		//#RVC20180731.bn	
		AAdd( aRotAuto, { "E1_CARTAUT"	, aDados[2]	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_NSUTEF"	, aDados[2]	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_DOCTEF"	, aDados[2]	, "AlwaysTrue()" } )

//#RVC20180628.bn		
		If Empty(aNSU)
			Aadd(aNSU,{aDados[2]})
			AAdd( aRotAuto, { "E1_XPARNSU"	, "1"	, "AlwaysTrue()" } )
//			cParcNSU := "1"	//#RVC20181001.o
		Else
			Aadd(aNSU,{aDados[2]})
			ASort(aNSU)
//			For  nX := 1 to Len(aNSU)	//#RVC20180702.o
			For  nY := 1 to Len(aNSU)	//#RVC20180702.o
				If Alltrim(aNSU[nY][1]) == Alltrim(aDados[2])
//					cParcNSU := SOMA1(cParcNSU,TamSX3("E1_PARCELA")[1])	//#RVC20180801.o
					cParcNSU := SOMA1(cParcNSU)							//#RVC20180801.n
				EndIf
			Next
			AAdd( aRotAuto, { "E1_XPARNSU"	, cParcNSU	, "AlwaysTrue()" } )
			cParcNSU := "0"
		EndIf

		AAdd( aRotAuto, { "E1_XNCART4"	, aDados[4], "AlwaysTrue()" } )							
		AAdd( aRotAuto, { "E1_XFLAG"	, aDados[5], "AlwaysTrue()" } )				
//#RVC20180628.en
	ElseIf Alltrim(aParcelas[nX,3]) $ "CH|CHK"
		cBco1  	:= Substr(aParcelas[nX,4],1,3)
		cAge1	:= Substr(aParcelas[nX,4],4,5)
		cConta1 := Substr(aParcelas[nX,4],9,10)
		
		AAdd( aRotAuto, { "E1_BCOCHQ"	, STRTRAN(cBco1,"|","")			, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_AGECHQ"	, STRTRAN(cAge1,"|","")			, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_CTACHQ"	, STRTRAN(cConta1,"|","")		, "AlwaysTrue()" } )
	ElseIf Alltrim(aParcelas[nX,3]) $ "BOL"
		aDados := Separa(aParcelas[nX,4],"|")
		AAdd( aRotAuto, { "E1_DOCTEF"	, Strzero(VAL(aDados[2]),TAMSX3("E1_DOCTEF")[1])	, "AlwaysTrue()" } )
	Endif
	
	If lCartao
		If cTpTax == '1'														 //#RVC20180327.bn
			AAdd( aRotAuto, { "E1_01TAXA"	, SAE->AE_TAXA	, "AlwaysTrue()" } ) 
		Else
			AAdd( aRotAuto, { "E1_01TAXA"	, _nTmpTx	, "AlwaysTrue()" } ) 
		EndIf																	 //#RVC20180327.be
		AAdd( aRotAuto, { "E1_01REDE"	, SAE->AE_REDE	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01NORED"	, Posicione("SX5",1,xFilial("SX5")+"L9" + SAE->AE_REDE,"X5_DESCRI")	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01OPER"	, SAE->AE_COD	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01NOOPE"	, SAE->AE_DESC	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_XDSCADM"	, cDscAdm		, "AlwaysTrue()" } )	//#RVC20181206.n
	//#RVC20181206.bn
	Else
		AAdd( aRotAuto, { "E1_01REDE"	, SAE->AE_REDE	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01NORED"	, Posicione("SX5",1,xFilial("SX5")+"L9" + SAE->AE_REDE,"X5_DESCRI")	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01OPER"	, SAE->AE_COD	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01NOOPE"	, SAE->AE_DESC	, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_XDSCADM"	, cDscAdm		, "AlwaysTrue()" } )
	//#RVC20181206.en	
	EndIF
	
	Begin Transaction	//#AFD20181123.n

	MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )
	
	IF lMsErroAuto
		lConfirma := .F.
		MostraErro()
		lRet := .F.
		RollbackSx8()		//#RVC20181106.n
//		DisarmTransaction()	//#RVC20180628.o
		DisarmTransaction()	//#RVC20180821.n
//		Exit				//#AFD20181123.o
	EndIF
	
	end Transaction			//#AFD20181123.n
	lConfirma := .T.
	ConfirmSX8()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ID K019 - SE O PAGAMENTO FOR EM DINHEIRO, EFETUAR A BAIXA AUTOMATICA - LUIZ EDUARDO F.C. - 01/02/2018 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	IF Alltrim(aParcelas[nX][3]) $ "R$"	//#RVC20180523.o
	IF Alltrim(aParcelas[nX][3]) $ "R$|RAN|DOC"	//#RVC20180523.n
		
		SE1->(DbSetOrder(1))
//		If SE1->(DbSeek(xFilial("SE1") + LEFT((Left(cTipo,1)+cPrefixo),3) + cTitulo + cParcela + aParcelas[nX,3] )) #RVC20180322.o
		If SE1->(DbSeek(xFilial("SE1") + cPrefixo + cTitulo + cParcela + aParcelas[nX,3] ))
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
			
			begin Transaction		//#AFD20181123.n

			MSExecAuto({|x, y| FINA070(x, y)}, aBaixa, 3)
			
			If  lMsErroAuto
				MostraErro()
				lRet := .F.			//#RVC20180821.n
//				DisarmTransaction()	//#RVC20180628.o
				DisarmTransaction()	//#RVC20180821.n
//				Exit				//#RVC20180821.n	//#AFD20181123.o
			EndIf
			
			end Transaction			//#AFD20181123.n
			
		EndIf
	EndIF
	
	//Realiza o cadastro do cheque na tabela SEF
	IF Alltrim(aParcelas[nX][3]) $ "CH|CHK"
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + cCliRA + cLjCliRA ))
		
		aCheque := Separa(aParcelas[nX][4],"|")
		
		DbSelectArea("SEF")
		Reclock( "SEF" , .T. )
		REPLACE SEF->EF_FILIAL  	 WITH xFilial("SEF")
		REPLACE SEF->EF_NUM			 WITH aCheque[4]
		REPLACE SEF->EF_BANCO	     WITH aCheque[1]
		REPLACE SEF->EF_AGENCIA 	 WITH aCheque[2]
		REPLACE SEF->EF_CONTA	     WITH aCheque[3]
		REPLACE SEF->EF_VALOR	     WITH aParcelas[nX][2]
		REPLACE SEF->EF_DATA	     WITH dDataBase
		REPLACE SEF->EF_VENCTO		 WITH aParcelas[nX][1]
		REPLACE SEF->EF_BENEF	  	 WITH SM0->M0_NOMECOM
		REPLACE SEF->EF_CART		 WITH "R"
		REPLACE SEF->EF_TEL			 WITH aCheque[6]
		REPLACE SEF->EF_RG		     WITH aCheque[5]
		REPLACE SEF->EF_TITULO   	 WITH SE1->E1_NUM
		REPLACE SEF->EF_PREFIXO	     WITH SE1->E1_PREFIXO
		REPLACE SEF->EF_TIPO	     WITH SE1->E1_TIPO
		REPLACE SEF->EF_TERCEIR 	 WITH .F.
		REPLACE SEF->EF_HIST	     WITH ""   		  // PARA RDMAKE
		REPLACE SEF->EF_PARCELA  	 WITH SE1->E1_PARCELA
		REPLACE SEF->EF_CLIENTE	     WITH cCliRA
		REPLACE SEF->EF_LOJACLI	     WITH cLjCliRA
		REPLACE SEF->EF_CPFCNPJ	     WITH SA1->A1_CGC
		REPLACE SEF->EF_EMITENT	     WITH SA1->A1_NOME
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ID K057 -  GRAVA A NATUREZA NO CHEQUE - LUIZ EDUARDO F.C. - 31/08/2018 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		REPLACE SEF->EF_NATUR	     WITH cNatRec
		REPLACE SEF->EF_XDESCNA	     WITH cDescNat
		
		MsUnlock()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CRIA TITULO NO CONTAS A PAGAR REFERENTE AS TAXAS ADMISTRATIVAS - LUIZ EDUARDO F.C. - 21.07.2017 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lGeraTaxa
		if !lExecAuto
			recLock("SE2",.T.)
				
				cFornece := IIF(EMPTY(cForTX),cNumSA2,cForTX)
				cLjFornece := IIF(EMPTY(cLojTX),SE1->E1_LOJA,cLojTX)

				SE2->E2_PREFIXO := SuperGetMv("KH_PREFSE2",.F.,"TXA")		
				SE2->E2_NUM := SE1->E1_NUM    						
				SE2->E2_PARCELA := SE1->E1_PARCELA						
				SE2->E2_TIPO := cSAECod								
				SE2->E2_NATUREZ := nNatTX
				SE2->E2_FORNECE := cFornece
				SE2->E2_LOJA := cLjFornece
				SE2->E2_EMISSAO := dDataBase      						
				SE2->E2_VENCTO := SE1->E1_VENCTO 						
				SE2->E2_VENCREA := SE1->E1_VENCREA						
				SE2->E2_VALOR := A410Arred((nValAdm)/100,"L2_VRUNIT")	
				SE2->E2_PORTADO := cPortado								
				SE2->E2_HIST := AllTrim(SE1->E1_NUM)					
				SE2->E2_XNSUTEF := SE1->E1_NSUTEF							
				SE2->E2_XPARNSU := SE1->E1_XPARNSU						
				SE2->E2_XNCART4 := SE1->E1_XNCART4						
				SE2->E2_XFLAG := SE1->E1_XFLAG							
				SE2->E2_XTPPAG := cTpPagto								
				SE2->E2_XDESCFI := _cFilName
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
					SE2->E2_XDSCADM := SE1->E1_XDSCADM
				endIf

			SE2->(MsUnlock())
		
		else

			aVetorSE2 :={{"E2_PREFIXO"	,SuperGetMv("KH_PREFSE2",.F.,"TXA")		,Nil},;								// 01 //#RVC20180322.n 
						{"E2_NUM"	   	,SE1->E1_NUM    						,Nil},; 		 	 				// 02
						{"E2_PARCELA"	,SE1->E1_PARCELA						,Nil},; 		   					// 03
						{"E2_TIPO"		,cSAECod								,Nil},;			   	 				// 04
						{"E2_NATUREZ"	,nNatTX									,"AlwaysTrue()"},; 					// 05
						{"E2_FORNECE"	,IIF(EMPTY(cForTX),cNumSA2,cForTX)	 	,Nil},;								// 06
						{"E2_LOJA"		,IIF(EMPTY(cLojTX),SE1->E1_LOJA,cLojTX) ,Nil},; 			  				// 07
						{"E2_EMISSAO"	,dDataBase      						,NIL},;				 				// 08
						{"E2_VENCTO"	,SE1->E1_VENCTO 						,NIL},; 			   				// 09
						{"E2_VENCREA"	,SE1->E1_VENCREA						,NIL},; 							// 10
						{"E2_VALOR"	,A410Arred((nValAdm)/100,"L2_VRUNIT")	,NIL},;								// 11
						{"E2_PORTADO"	,cPortado								,NIL},;								// 12
						{"E2_HIST"		,AllTrim(SE1->E1_NUM)					,NIL},;	   							// 13
						{"E2_XNSUTEF"	,SE1->E1_NSUTEF							,NIL},;								// 15	//#RVC20180628.n
						{"E2_XPARNSU"	,SE1->E1_XPARNSU						,NIL},;								// 16	//#RVC20180628.n
						{"E2_XNCART4"	,SE1->E1_XNCART4						,NIL},;								// 17	//#RVC20180628.n
						{"E2_XFLAG"	,SE1->E1_XFLAG							,NIL},;								// 18	//#RVC20180628.n
						{"E2_XTPPAG"	,cTpPagto								,NIL},;								// 19	//#RVC20180921.n
						{"E2_XDESCFI"	,_cFilName								,NIL}}								// 14	
								
			if FieldPos("E2_XDSCADM")>0
				aAdd(aVetorSE2,{"E2_XDSCADM"	,AllTrim(SE1->E1_XDSCADM),NIL})				// 21
			endIf
								
			lMsErroAuto := .F.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a inclusao do contas a pagar via ExecAuto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			begin Transaction	//#AFD20181123.n
			
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetorSE2,,3)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se houveram erros durante a execucao da rotina automatica.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lMsErroAuto
				MostraErro()
				lRet := .F.			//#RVC20180821.n
				DisarmTransaction()	//#RVC20180821.n
			Endif

			end Transaction	//#AFD20181123.n

		endif
	Endif
	
	nVlrTot += aParcelas[nX,2]
	
Next

cParcela := ""	//#RVC20180801.n	//#RVC20180829.o
cParcela := 0	//#RVC20180829.o

//#RVC20181226.bn
If ISINCALLSTACK('U_KMFINA03')  
	If _lFil
		cFilAnt := '0101'	
	EndIf	             
	
	nModulo := nModOld
	
	Return
Else
//#RVC20181226.en

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera titulo aglutinador.                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//IF nVlrTot > 0				//#RVC20180821.o
	If (nVlrTot > 0) .and. lRet		//#RVC20180821.n
	//#RVC20181220.bo	
	/*	aRotAuto	:= {}
		aDados		:= {}
		lMSHelpAuto	:= .T.
		lMsErroAuto := .F.
		
	//	AAdd( aRotAuto, { "E1_PREFIXO"	, Left(cTipo,1)+cPrefixo				, NIL } ) //#RVC20180322.o
		AAdd( aRotAuto, { "E1_PREFIXO"	, cPrefixo								, NIL } ) //#RVC20180322.n
		AAdd( aRotAuto, { "E1_NUM"    	, cTitulo								, NIL } )
		AAdd( aRotAuto, { "E1_TIPO"   	, cTipo									, NIL } )
		AAdd( aRotAuto, { "E1_NATUREZ"	, cNatRA								, NIL } )
		AAdd( aRotAuto, { "E1_PARCELA"	, "A"									, NIL } )
		AAdd( aRotAuto, { "E1_CLIENTE"	, cCliRA								, NIL } )
		AAdd( aRotAuto, { "E1_LOJA"   	, cLjCliRA								, NIL } )
		AAdd( aRotAuto, { "E1_EMISSAO"	, dDataBase								, NIL } )
		AAdd( aRotAuto, { "E1_VENCTO" 	, dDataBase								, NIL } )
		AAdd( aRotAuto, { "E1_VEND1" 	, _cVende								, NIL } )	
		AAdd( aRotAuto, { "E1_VENCREA"	, DataValida(dDataBase)					, NIL } )
		AAdd( aRotAuto, { "E1_VALOR"  	, nVlrTot								, NIL } )
		AAdd( aRotAuto, { "E1_HIST"	  	, cHist									, NIL } )
		AAdd( aRotAuto, { "E1_USRNAME"	, UsrRetName(__cUserID)					, Nil } )
		AAdd( aRotAuto, { "E1_FORMREC"	, cForma								, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_PORTADO"	, cPortado								, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_01MOTIV"	, "999999"								, "AlwaysTrue()" } )
		AAdd( aRotAuto, { "E1_XDESCFI"	, _cFilName								, NIL } )
		AAdd( aRotAuto, { "E1_CPFCNPJ"	, _cCGC									, NIL } ) //#RVC20181002.n
			
		begin Transaction	//#AFD20181123.n
		
		MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )
			
		IF lMsErroAuto
			lConfirma := .F.
			MostraErro()
			lRet := .F.			//#RVC20180821.n
	//		DisarmTransaction()	//#RVC20180628.o
			DisarmTransaction()	//#RVC20180821.n
		EndIF
			
		end Transaction		//#AFD20181123.n*/
	//#RVC20181220.eo	
		If lExecAuto
		
			aRotAuto	:= {}
			aDados		:= {}
			lMSHelpAuto	:= .T.
			lMsErroAuto := .F.
		
		//	AAdd( aRotAuto, { "E1_PREFIXO"	, Left(cTipo,1)+cPrefixo				, NIL } ) //#RVC20180322.o
			AAdd( aRotAuto, { "E1_PREFIXO"	, cPrefixo								, NIL } ) //#RVC20180322.n
			AAdd( aRotAuto, { "E1_NUM"    	, cTitulo								, NIL } )
			AAdd( aRotAuto, { "E1_TIPO"   	, cTipo									, NIL } )
			AAdd( aRotAuto, { "E1_NATUREZ"	, cNatRA								, NIL } )
			AAdd( aRotAuto, { "E1_PARCELA"	, "A"									, NIL } )
			AAdd( aRotAuto, { "E1_CLIENTE"	, cCliRA								, NIL } )
			AAdd( aRotAuto, { "E1_LOJA"   	, cLjCliRA								, NIL } )
			AAdd( aRotAuto, { "E1_EMISSAO"	, dDataBase								, NIL } )
			AAdd( aRotAuto, { "E1_VENCTO" 	, dDataBase								, NIL } )
			AAdd( aRotAuto, { "E1_VEND1" 	, _cVende								, NIL } )	
			AAdd( aRotAuto, { "E1_VENCREA"	, DataValida(dDataBase)					, NIL } )
			AAdd( aRotAuto, { "E1_VALOR"  	, nVlrTot								, NIL } )
			AAdd( aRotAuto, { "E1_HIST"	  	, cHist									, NIL } )
			AAdd( aRotAuto, { "E1_USRNAME"	, UsrRetName(__cUserID)					, Nil } )
			AAdd( aRotAuto, { "E1_FORMREC"	, cForma								, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_PORTADO"	, cPortado								, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_01MOTIV"	, "999999"								, "AlwaysTrue()" } )
			AAdd( aRotAuto, { "E1_XDESCFI"	, _cFilName								, NIL } )
			AAdd( aRotAuto, { "E1_CPFCNPJ"	, _cCGC									, NIL } ) //#RVC20181002.n
			
			begin Transaction	//#AFD20181123.n
		
			MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3 )
			
			IF lMsErroAuto
				lConfirma := .F.
				MostraErro()
				lRet := .F.			//#RVC20180821.n
		//		DisarmTransaction()	//#RVC20180628.o
				DisarmTransaction()	//#RVC20180821.n
			EndIF
			
			end Transaction		//#AFD20181123.n
		else
			RecLock("SE1",.T.)
				SE1->E1_FILIAL 	:= XFILIAL("SE1")
				SE1->E1_PREFIXO := cPrefixo
				SE1->E1_NUM		:= cTitulo
				SE1->E1_PARCELA	:= "A"
				SE1->E1_NATUREZ	:= cNatRA
				SE1->E1_TIPO	:= cTipo			
				SE1->E1_CLIENTE	:= cCliRA
				SE1->E1_LOJA	:= cLjCliRA
				SE1->E1_NOMCLI	:= Posicione("SA1",1,xFilial("SA1") + cCliRA + cLjCliRA,"A1_NREDUZ")
				SE1->E1_EMISSAO	:= dDataBase
				SE1->E1_VENCTO	:= dDataBase
				SE1->E1_VENCREA	:= DataValida(dDataBase)
				SE1->E1_VENCORI	:= dDataBase
				SE1->E1_VALOR	:= nVlrTot
				SE1->E1_EMIS1	:= dDataBase
				SE1->E1_SITUACA	:= "0"
				SE1->E1_SALDO	:= nVlrTot
				SE1->E1_MOEDA	:= 1
				SE1->E1_PEDIDO	:= ""
				SE1->E1_VLCRUZ	:= nVlrTot
				SE1->E1_BASCOM1	:= nVlrTot
				SE1->E1_VALLIQ	:= nVlrTot
				SE1->E1_STATUS	:= "A"
				SE1->E1_ORIGEM	:= "FINA040"
				SE1->E1_FLUXO	:= "S"
				SE1->E1_TIPODES	:= "1"
				SE1->E1_FILORIG	:= cFilAnt
				SE1->E1_MULTNAT := "2"
				SE1->E1_MSFIL	:= cFilAnt
				SE1->E1_MSEMP	:= cEmpAnt
				SE1->E1_PROJPMS	:= "2"
				SE1->E1_DESDOBR	:= "2"
				SE1->E1_MODSPB	:= "1"
				SE1->E1_SCORGP	:= "2"
				SE1->E1_RELATO 	:= "2"
				SE1->E1_TPDESC	:= "C"
				SE1->E1_VLMINIS	:= "1"
				SE1->E1_APLVLMN	:= "1"
				SE1->E1_CPFCNPJ	:= _cCGC
				SE1->E1_PEDPEND	:= '2'
				SE1->E1_01VLBRU := nVlrTot
				SE1->E1_VEND1	:= _cVende	
				SE1->E1_HIST	:= cHist
				SE1->E1_USRNAME	:= UsrRetName(__cUserID)
				SE1->E1_FORMREC	:= cForma
				SE1->E1_PORTADO	:= cPortado
				SE1->E1_01MOTIV	:= "999999"
				SE1->E1_XDESCFI	:= _cFilName
				SE1->E1_TCONHTL := "3"
				SE1->E1_01VALCX := "2"
			MsUnlock()
		endIf	
		
		//#RVC20180821.bn
		If lRet
			SE1->(dbSetOrder(1))
			SE1->(dbGotop())
			if SE1->(dbSeek(xFilial("SE1") + cPrefixo + cTitulo))
				While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == xFilial("SE1") + cPrefixo + cTitulo
					If Alltrim(SE1->E1_TIPO) $ ('CD','CC')
						Reclock("SE1" ,.F.)
							SE1->E1_01TAXA := _nTmpTx
						MsUnlock()
					EndIf
					SE1->(dbSkip())
				Enddo
			endIf
		EndIf
		//#RVC20180821.en
	EndIF
	
	//End Transaction //#RVC20180821.n	//#AFD20181123.o
	             
	If lConfirma .and. lRet
		MsgInfo("Rotina finalizada com sucesso.","Atenção")
	//	FwMsgRun( ,{|| U_KMFINR03(SE1->E1_NUM,SE1->E1_PREFIXO) }, , "Imprimindo Comprovante do RA, Por Favor Aguarde..." )	//#RVC20180823.o
		FwMsgRun( ,{|| U_KMFINR03(cTitulo,cPrefixo) }, , "Imprimindo Comprovante do RA, Por Favor Aguarde..." )				//#RVC20180823.n
	//#RVC20180821.bn
	Else
		MsgStop("Ocorreram erros que impendem a gravação do RA." + CHR(13) + CHR(10) + "Acione o administrador do sistema.","Atenção")
	Endif
	//#RVC20180821.en
EndIf

If _lFil

	cFilAnt := '0101'
	
EndIf	             

nModulo := nModOld

Return(lConfirma)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDCLIENTEº Autor  ³  Luiz Eduardo F.C.   º Data ³  28/07/16            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA SE O CLIENTE EXISTE E JA BUSCA A LOJA E O NOME DO MESMO         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION VLDCLIENTE()

Local lRet := .F.

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

IF SA1->(DbSeek(xFilial("SA1") + cCliRA))

	If SA1->A1_MSBLQL == '1'

		MsgAlert("Cliente está bloqueado para uso, verifique o cadastro do cliente!","BLOQUEADO")
    
	Else
	
		lRet		:= .T.
		cLjCliRA	:= SA1->A1_LOJA
		cNomeRA		:= SA1->A1_NOME
		_cCGC		:= SA1->A1_CGC
		oTelaRA:Refresh()
	
	EndIf
Else
	If !Empty(cCliRA)
		MsgAlert("Cliente Não Encontrado!","Atenção")
	Else
		lRet := .T.
	Endif
EndIF

RETURN(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FILBCO   º Autor  ³  Eduardo Patriani.   º Data ³  10/01/17            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra o banco no cadastro de formas de pagamentos (RA)                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FilBco(aParcelas,cBanco,cAgencia,cConta,oBanco,oAgencia,oConta,cTipo)

If Len(aParcelas) > 0
	
	DbSelectArea("Z02")
	DbSetOrder(1)
	DbSeek(xFilial("Z02") + aParcelas[1][3] )
	
	//cBanco:=Z02->Z02_BANCO
	//oBanco:Refresh()
	
	cAgencia:=Z02->Z02_AGENCI
	oAgencia:Refresh()
	
	cConta:=Z02->Z02_NUMCON
	oConta:Refresh()
	
	cTipo := IF(Z02->Z02_OPER=="1","RA","PR")
	
	DbSelectArea("SAE")
	SAE->(DbSetOrder(1))
	If SAE->(DbSeek(xFilial("SAE") + Left(aParcelas[1][4],3)) )
		cBanco:=SAE->AE_XPORTAD // TRAZ O BANCO CADASTRADO NO SAE - LUIZ EDUARDO F.C. - 16.08.2017
		oBanco:Refresh()
	EndIF
	
EndIF

Return
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
		Endif
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A Administradora financeira ja esta cadastrada³
	//³como fornecedor retorna o codigo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Return SA2->A2_COD
Endif

Return (cNextCodfo)

Static Function fValidVend(_cVende)
            
Local _lRet := .F.       
       
DbSelectArea("SA3")
SA3->(DbSetOrder(1))
SA3->(DbGoTop())

If SA3->(DbSeek(xFilial("SA3")+_cVende))
            
	If SA3->A3_MSBLQL == '1'            
            
		MsgAlert("Vendedor está bloqueado para uso, verifique o cadastro!","VENDBLQ")
	
	Else
	
		_cNomVe := SA3->A3_NOME
		_lRet := .T.         
        
    EndIf     
EndIf

Return _lRet

Static Function RetVend()

Local _cVend := Space(GetSx3Cache("E1_VEND1","X3_TAMANHO"))
Local _aArea := SA3->(getArea())

if isInCallStack('TMKA271')

	DbSelectArea("SA3")
	DbSetOrder(7)
	if SA3->(dbSeek(xFilial("SA3") + __cUserId))
		_cVend 	:= SA3->A3_COD
		_cNomVe	:= SA3->A3_NOME
	endIF
endIF

restArea(_aArea)

Return _cVend
