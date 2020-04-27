#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"
#INCLUDE "TOPCONN.CH"

User Function KMCOMA08()

Local cCadastro := OemToAnsi("Importação de Planilha de Compras")
Local nOpc		:= 0
Local aButtons	:= {}
Local aSays		:= {}

AADD(aSays,OemToAnsi( "Este programa tem como objetivo gerar o Pedido de Compras importando "))
AADD(aSays,OemToAnsi( "os dados a partir de uma planilha formatada com padrão determinado.  "))

AADD(aButtons, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )				
AADD(aButtons, { 2,.T.,{|| nOpc := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

if nOpc == 1
	Processa( { || fGeraPC() }  ,"Aguarde"   ,"Processando importação...")
endIf
	   
Return

Static Function fGeraPC()

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local _cNumBkp := ""
	Local _lOk     := .T.
	Local _cPrds   := ""
	Local _prcPC	:= 0
	Local cArquivo  := ""
	Local cArq01   	:= ""
	Local cAlias 	:= GetNextAlias()
	Local cTipoArq 	:= "Todos os Arquivos *.* | *.* |"
	Local cDirDocs 	:= "C:\TEMP\"
	Local cDirServ	:= "\importacao\"
	Local nHdl		:= 0
	Local aArqTemp	:= {}
	Local aLeitura	:= {}
	Local aDados	:= {}
	Local cStrTXT	:= ""
	Local lRet		:= .T.
	Local cBuffer	:= ""
	Local _cQuery	:= ""
	Local _cMSG		:= "Pedido(s): {"
	Local _cCond	:= ""				//#RVC20181129.n
	Private _cArqTMP:= CriaTrab(,.F.)
	Private lMsErroAuto := .F.

	fGeraTMP()
	
	//Carrego todOs arquivos textos da maquina local para exclui-los
	aArqTemp := Directory(cDirDocs+"*.LOG")
	aEval(aArqTemp, {|x| FErase(cDirDocs+x[1])})
	
	//Cria Diretorio
	MakeDir(cDirDocs)
	
	//Cria Diretorio
	MakeDir(cDirServ)
	
	cArquivo := cGetFile(cTipoArq,"Selecione o arquivo para importação.",0,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.)
	
	IF !Empty(cArquivo)
		
		//Copia o arquivo local para o servidor
		lRet := CpyT2S( cArquivo , cDirServ , .F. )
		If lRet
			cArquivo := SubStr(cArquivo,RAT("\",cArquivo) + 1,Len(cArquivo))
		Endif
		cArq01 := Substr(cArquivo,1,Len(cArquivo)-4)
		
		//Abre o arquivo que sera importado
		nHdl := FT_FUSE(cDirServ+cArquivo)
		If nHdl == -1
			MsgStop("Erro na criacao do arquivo."	)
			Return
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura do arquivo texto e avalia o tipo se B(venda) ou C(conciliação)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cStrTXT  := FT_FREADLN()
		aLeitura := Separa(cStrTXT , ";")
		
		if Len(aLeitura) < 8
			msgstop("Leiaute do arquivo não corresponde ao padrão.")
			Return
		endIf
		
	else
		msgstop("Operação Abortada")
		Return
	EndIf
	
	if lRet
		
		FT_FGOTOP()
		ProcRegua(FT_FLASTREC())
		
		While !FT_FEOF()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Leitura do arquivo texto.                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cBuffer  := FT_FREADLN()
			aDados := Separa(cBuffer , ";")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
			//³Desconsiderar registros do Header (C01) e Trailler (C03)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
			If Alltrim(aDados[1]) $ "PEDIDOS"
				FT_FSKIP(1)
				Loop
			Endif
			
			if	Empty(Alltrim(aDados[1])) .AND. Empty(Alltrim(aDados[2])) .AND. Empty(Alltrim(aDados[3])) .AND. Empty(Alltrim(aDados[5])) 
				FT_FSKIP(1)
				Loop
			endIf
			
			IncProc()
			
			RecLock(_cArqTMP,.T.)	
				REPLACE ZZ1_NUM	   WITH aDados[01]
				REPLACE ZZ1_COD	   WITH aDados[02]
				REPLACE ZZ1_QUANT  WITH VAL(aDados[03])
				REPLACE ZZ1_VALOR  WITH 1
				REPLACE ZZ1_PVPRT  WITH aDados[04]
				REPLACE ZZ1_FORNE  WITH aDados[05]
				REPLACE ZZ1_NUMSC  WITH aDados[06]
				REPLACE ZZ1_ITEMSC WITH aDados[07]
				REPLACE ZZ1_QTDSC  WITH VAL(aDados[08])
			MsUnLock()
			
			FT_FSKIP(1)
		EndDo
		
	endIf
	
	_cQuery := " SELECT * "
	_cQuery += " FROM " + _cArqTMP + " TMP"
//	_cQuery += " ORDER BY ZZ1_NUMSC DESC, ZZ1_ITEMSC"			//#RVC20181126.o
	_cQuery += " ORDER BY ZZ1_NUM, ZZ1_NUMSC DESC, ZZ1_ITEMSC"	//#RVC20181126.n

	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.T.,.T.)
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	
	While (cAlias)->(!Eof())
	
		_cNumBkp := AllTrim((cAlias)->ZZ1_NUM)

		aCabec	:= {}
		aItens	:= {}
		_prcPC	:= 0
		_cNumPC	:= GETNUMSC7()
		_cCond	:= Posicione("SA2",1,xFilial("SA2") + Strzero(val((cAlias)->ZZ1_FORNE),6) + "01","A2_COND")
		
		
		aadd(aCabec,{"C7_EMISSAO"	,dDataBase})
		aadd(aCabec,{"C7_FORNECE"	,Strzero(val((cAlias)->ZZ1_FORNE),6)})
		aadd(aCabec,{"C7_LOJA"		,"01"})
//		aadd(aCabec,{"C7_COND"		,"001"})						//#RVC20181128.o
		aadd(aCabec,{"C7_COND"		,IIF(_cCond=="","001",_cCond)})	//#RVC20181129.n
		aadd(aCabec,{"C7_CONTATO"	,"AUTO"})
		aadd(aCabec,{"C7_FILENT"	,cFilAnt})
		aadd(aCabec,{"C7_NUM"		,_cNumPC})
			
		While (cAlias)->(!Eof()) .And. AllTrim(_cNumBkp) == AllTrim((cAlias)->ZZ1_NUM)
		
			if !Empty(Alltrim((cAlias)->ZZ1_NUM)) .AND. !Empty(Alltrim((cAlias)->ZZ1_COD)) .AND. !Empty(Alltrim((cAlias)->ZZ1_FORNE)) .AND. (cAlias)->ZZ1_QUANT <> 0
				If !SB1->(DbSeek(xFilial("SB1")+(cAlias)->ZZ1_COD))
					
					_cPrds += "Produto: " + ALLTRIM((cAlias)->ZZ1_COD) +", Venda: " + ALLTRIM((cAlias)->ZZ1_PVPRT) + ", SC: " + ALLTRIM((cAlias)->ZZ1_NUMSC) + CHR(10) + CHR(13)//+ ", Seq.: " + (cAlias)->R_E_C_N_O_ +"." + CHR(10) + CHR(13)  
					
					_lOk := .F.
			
					(cAlias)->(DbSkip())
				
					Loop
					
				else
					If SB1->B1_MSBLQL == '1'
					
						_cPrds += "Produto: " + ALLTRIM((cAlias)->ZZ1_COD) +", Venda: " + ALLTRIM((cAlias)->ZZ1_PVPRT) + ", SC: " + ALLTRIM((cAlias)->ZZ1_NUMSC) + CHR(10) + CHR(13)//", Seq.: " + (cAlias)->R_E_C_N_O_ +"." + CHR(10) + CHR(13)
						
						_lOk := .F.
						
						(cAlias)->(DbSkip())
						
						Loop
						
					endIf
				EndIf
			else
				Loop
			endIf
	
			aLinha := {}
				
			_prcPC := FPreco((cAlias)->ZZ1_COD)
				
			_prcPC := IIF(_prcPC==0,(cAlias)->ZZ1_VALOR,_prcPC)
				
			aadd(aLinha,{"C7_PRODUTO"	,AllTrim((cAlias)->ZZ1_COD)							,Nil})
			aadd(aLinha,{"C7_QUANT"		,(cAlias)->ZZ1_QUANT 								,Nil})
			aadd(aLinha,{"C7_PRECO"		,_prcPC											,Nil})
			aadd(aLinha,{"C7_TOTAL"		,((cAlias)->ZZ1_QUANT*_prcPC)						,Nil})
			aadd(aLinha,{"C7_OBS"		,"PEDIDO EXCEL "+ STRZERO(val((cAlias)->ZZ1_NUM),6)	,Nil})			
			aadd(aLinha,{"C7_TES"		,"050"											,Nil})
			aadd(aLinha,{"C7_01NUMPV"	,STRZERO(val((cAlias)->ZZ1_PVPRT),6)					,Nil})
				
			if (cAlias)->ZZ1_NUMSC <> "0"
				aadd(aLinha,{"C7_NUMSC" ,STRZERO(val((cAlias)->ZZ1_NUMSC),6) 	,Nil})
				aadd(aLinha,{"C7_ITEMSC" ,STRZERO(val((cAlias)->ZZ1_ITEMSC),4)	,Nil})
				aadd(aLinha,{"C7_QTDSOL" ,(cAlias)->ZZ1_QTDSC					,Nil})
			endIf
				
			aadd(aItens,aLinha)
				
			(cAlias)->(DbSkip())
				
		EndDo
		
		MATA120(1,aCabec,aItens,3)
		
		If !lMsErroAuto
			ConOut("Incluido com sucesso! ")
			_cMSG += _cNumPC + "; "
		Else
			ConOut("Erro na inclusao!")
			MostraErro()
			exit
		EndIf
		
		(cAlias)->(DbSkip())
		
	EndDo
		
	if !_lOk
		
		MsgAlert(_cPrds,"Pedidos que não subiram")
		
		if Len(_cMSG) > 12
			_cMSG := Substr(_cMSG,1,(Len(Alltrim(_cMSG)) - 1)) + "}"
			MsgAlert(_cMSG,"Pedido(s) gerado(s)")
		endIf
		
	else
		if Len(_cMSG) > 12
			_cMSG := Substr(_cMSG,1,(Len(Alltrim(_cMSG)) - 1)) + "}"
			MsgAlert(_cMSG,"Pedido(s) gerado(s)")
		endIf
	endIf

Return

Static Function fNewTAB()

Local aFields		:= {}
Local oTempTable	:= NIL
Local cAlias 		:= "MEUALIAS"
Local cQuery		:= ""
Local cRet			:= ""

//-------------------
//Criação do objeto
//-------------------
oTempTable := FWTemporaryTable():New( cAlias )

//--------------------------
//Monta os campos da tabela
//--------------------------
aadd(aFields,{"ZZ1_NUM","C",6,0})
aadd(aFields,{"ZZ1_COD","C",15,0})
aadd(aFields,{"ZZ1_QUANT","N",12,2})
aadd(aFields,{"ZZ1_VALOR","N",14,2})
aadd(aFields,{"ZZ1_FORNE","C",6,0})
aadd(aFields,{"ZZ1_PVPRT","C",6,0})
aadd(aFields,{"ZZ1_NUMSC","C",6,0})
aadd(aFields,{"ZZ1_ITEMSC","C",4,0})
aadd(aFields,{"ZZ1_QTDSC","N",12,2})

oTemptable:SetFields( aFields )
oTempTable:AddIndex("1", {"ZZ1_NUM"} )

//------------------
//Criação da tabela
//------------------
oTempTable:Create()
cRet:= Substr(oTempTable:GetRealName(),5)
	
//---------------------------------
//Exclui a tabela 
//---------------------------------
//oTempTable:Delete() 

return cRet


Static Function FPreco(cCod)

Local nPreco := 0

dbSelectArea("SB1")
SB1->(dbGoTop())
if SB1->(dbSeek(xFilial("SB1") + cCod))
	nPreco := SB1->B1_01CUSTO
endIf

return nPreco

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGeraTMP   ºAutor  ³                   º Data ³  02/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera arquivo temporario fGeraTMP atraves do arquivo XXX     º±±
±±º          ³importado atraves do comando APPEND						  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGeraTMP()

Local aCpoTMP	:= {}
Local aCampos	:= {}

aadd(aCpoTMP,{"ZZ1_NUM"	  ,"C", 6,0})
aadd(aCpoTMP,{"ZZ1_COD"	  ,"C",15,0})
aadd(aCpoTMP,{"ZZ1_QUANT" ,"N",12,2})
aadd(aCpoTMP,{"ZZ1_VALOR" ,"N",14,2})
aadd(aCpoTMP,{"ZZ1_FORNE" ,"C", 6,0})
aadd(aCpoTMP,{"ZZ1_PVPRT" ,"C", 6,0})
aadd(aCpoTMP,{"ZZ1_NUMSC" ,"C", 6,0})
aadd(aCpoTMP,{"ZZ1_ITEMSC","C", 4,0})
aadd(aCpoTMP,{"ZZ1_QTDSC" ,"N",12,2})

DBCreate(_cArqTMP,aCpoTMP,"TOPCONN")

// Fecha Area Se Estiver Aberta
If Select(_cArqTMP) > 0
	DbSelectArea(_cArqTMP)
	DbCloseArea(_cArqTMP)
EndIf

DbUseArea(.T.,"TOPCONN",_cArqTMP,_cArqTMP,.T.,.F.)
DbCreateIndex(_cArqTMP+"1","ZZ1_NUM",{|| ZZ1_NUM },.F.)

Return