#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SYTMOV03 � Autor � LUIZ EDUARDO F.C.  � Data �  31/08/16   ���
�������������������������������������������������������������������������͹��
���Descricao � GERA AS NOTAS DE TRANSFERENCIA PARA A VENDA DE MOSTRUARIO  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION SYTMOV03(_cPedOrig)

Local aArea		 := GetArea()
Local aAreaSM0   := SM0->(GetArea())
Local aAreaSC5   := SC5->(GetArea())
Local aAreaSC6   := SC6->(GetArea())
Local aAreaSA1   := SA1->(GetArea())
Local aAreaSUA   := SUA->(GetArea())
Local aAreaSUB   := SUB->(GetArea())
Local cLOCGLP    := GetMV("MV_LOCGLP")
Local aOrdFil    := {}
Local cFlBkp     := cFilAnt
Local _aSB9    := {}   //#CMG20180619.n

Private aPrdMost := {}
Private cMSKKFT  := GetMV("MV_MSKKFT",,"999999")
Private cTESTRF  := GetMV("MV_TESTRF",,"502")
Private nFILSAI	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_FILSAI"})
Private nLOCAL	 := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_LOCAL"})
Private nPRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Private nQUANT   := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_QUANT"})
Private nVRUNIT  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VRUNIT"})
Private nPRODUTO := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_PRODUTO"})
Private nVLRITEM := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_VLRITEM"})
Private nUM      := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_UM"})
Private nITEM    := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_ITEM"})

Private lMsErroAuto := .F. //#CMG20180619.n
//���������������������������������������������������������������������������������Ŀ
//� ATUALIZA O CAMPO ARMAZEM DO PEDIDO ORIGINAL COM O CONTEUDO DO ARMAZEM DE SALDAO �
//�����������������������������������������������������������������������������������
DbSelectArea("SUB")
SUB->(DbSetOrder(1))

For nT:=1 To Len(aMost)
	SUB->(DbGoTop())
	SUB->(DbSeek(xFilial("SUB") + SUA->UA_NUM))
	While SUB->(!EOF()) .AND. SUB->UB_FILIAL + SUB->UB_NUM == xFilial("SUB") + SUA->UA_NUM
		//#CMG20180619.bn
		DbSelectArea("SB9")
		SB9->(DbSetOrder(1))//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
		SB9->(DbGoTop())
		
		If !(SB9->(DbSeek(xFilial("SB9")+aMost[nt,2]+aMost[nt,11])))
			
			_aSB9 := {}
			aadd(_aSB9,{"B9_FILIAL",xFilial("SB9"), Nil})
			aadd(_aSB9,{"B9_COD",aMost[nt,2], Nil})
			aadd(_aSB9,{"B9_LOCAL",aMost[nt,11], Nil})
			aadd(_aSB9,{"B9_QINI",0, Nil})
			
			DbSelectArea("SB9")
			SB9->(DbSetOrder(1))
			
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			
			MSExecAuto({|x,y| MATA220(x,y)},_aSB9,3)
			
			If lMsErroAuto
				MostraErro()
			EndIf
			
		EndIf
		//#CMG20180619.en
		IF ALLTRIM(SUB->UB_ITEM) + ALLTRIM(SUB->UB_PRODUTO) + ALLTRIM(SUB->UB_FILSAI) + ALLTRIM(SUB->UB_LOCAL) == ALLTRIM(aMost[nT,nITEM]) + ALLTRIM(aMost[nT,nPRODUTO]) + ALLTRIM(aMost[nT,nFILSAI]) + ALLTRIM(aMost[nT,nLOCAL])
			RecLock("SUB",.F.)
			SUB->UB_LOCAL := cLOCGLP
			SUB->(MsUnLock())
		EndIF
		SUB->(DbSkip())
	EndDo
Next

//���������������������������������������������Ŀ
//� Carregando o vetor com os codigos das lojas |
//�����������������������������������������������
SM0->(DbGoTop())
While SM0->(!EOF())
	Aadd( aOrdFil , { SM0->M0_CODFIL , SubStr(SM0->M0_FILIAL,1,6) , SM0->M0_CODIGO} )
	SM0->(DbSkip())
EndDo

//������������������������������������������������������������������������������������������Ŀ
//� VARRE O ARRAY DE PRODUTOS MOSTRUARIO/ACESSORIOS PARA SABER QUANTOS PEDIDOS SERAM GERADOS �
//��������������������������������������������������������������������������������������������
For nX:=1 To Len(aOrdFil)
	aPrdMost := {}
	For nY:=1 To Len(aMost)
		IF ALLTRIM(aOrdFil[nX,1]) == ALLTRIM(aMost[nY,nFILSAI])
			aAdd( aPrdMost , aMost[nY] )
		EndIF
	Next
	IF Len(aPrdMost) > 0
		FwMsgRun( ,{|| GERAPED(_cPedOrig) }, , "Gerando Pedido de Transferencia - " + aOrdFil[nX,1] + " , Por Favor Aguarde..." )
		aPrdMost := {}
	EndIF
Next

cFilAnt := cFlBkp
RestArea(aArea)
RestArea(aAreaSM0)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSUA)
RestArea(aAreaSUB)

RETURN()
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  GERAPED � Autor � LUIZ EDUARDO F.C.  � Data �  17/10/2016 ���
�������������������������������������������������������������������������͹��
���Objetivo  � GERA PEDIDO DE TRANSFERENCIA NA FILIAL DE ORIGEM DO PRODUTO���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                              `
���������������������������������������������������������������������������*/
STATIC FUNCTION GERAPED(_cPedOrig)

Local cNumSC5   := ""
Local cMay      := ""
Local cItemPc   := "00"
Local aCabPv	:= {}
Local aItemPV   := {}
Local aItemSC6  := {}
Local aAreaSB1  := SB1->(GetArea())	//#RVC20180615.n
Local lCredito	:= .T.
Local lEstoque	:= .T.
Local lAvCred	:= .F.
Local lAvEst	:= .F.
Local lLiber	:= .T.
Local lTransf   := .F.
Local lRetEnv	:= .F.
Local cArmz		:= SuperGetMV("SY_LOCPAD",.F.,"01")	//#RVC20180619.n
Local _cNomefil :=''

//Local _cCliOrig := posicione("SC5",1,xFilial("SUA")+_cPedOrig,"C5_CLIENT")				//#RVC20180729.o
Local _cCliOrig := GetAdvFVal("SUA","UA_DESCNT",xFilial("SUA") + _cPedOrig,8,"SEM NOME")	//#RVC20180729.n


Private lMSHelpAuto := .T.
Private lMsErroAuto := .F.

//Local cFilBkp	:= cFilAnt

//cFilAnt := aPrdMost[1,nFILSAI]  -Comentado por Deo - precisa manter a filial posicionada, a filial de saida do campo UB_FILSAI corresponde ao CD destino MIT 025

/*
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())
SA1->(DbSeek(xFilial("SA1") + cMSKKFT + RIGHT(ALLTRIM(aPrdMost[1,nFILSAI]),2))) -- comentado por deo
*/
//////////////////////////////////////////////////////
//Encontrar o cliente atraves do campo A1_FILTRF 
///////////////////////////DEO//K026/////////////////
SA1->(DbOrderNickName("FILTRF"))
If !SA1->(DbSeek(xFilial("SA1") + ALLTRIM(aPrdMost[1,nFILSAI]))) 
	Aviso("SYTMOB03 - Aten��o!!!","Cliente correspondente a filial destino "+ALLTRIM(aPrdMost[1,nFILSAI]) +;
	      " nao encontrado. Verifique vinculo pelo campo Filial de Transferencia (A1_FILTRF)",{"Ok"})
	Return
EndIf


//��������������������������������������������������������������Ŀ
//� Pega o numero do pedido de venda.                            �
//����������������������������������������������������������������
Dbselectarea("SC5")
DbSetorder(1)

//#CMG20180612.bo
/*cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
cMay := "SC5"+ALLTRIM(cFilAtu)+cNumSC5
While (DbSeek(cFilAtu+cNumSC5) .OR. !MayIUseCode(cMay))
	cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
	cMay 	:= "SC5"+ALLTRIM(cFilAtu)+cNumSC5
End
If __lSX8
	ConfirmSX8()
EndIf*/ //#CMG20180612.eo
	
//cNumSC5 := U_fGerREG(1) //#CMG20180612.n - Substituido pois a numera��o n�o iniciou como 000001 no GoLive	//#RVC20180613.o

//#RVC20180613.bn
cNumSC5 := GetSxeNum("SC5","C5_NUM")
	
cMay := "SC5"+ALLTRIM(cFilAnt)+cNumSC5
While (DbSeek(cFilAnt+cNumSC5) .OR. !MayIUseCode(cMay))
	cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
	cMay 	:= "SC5"+ALLTRIM(cFilAnt)+cNumSC5
End
If __lSX8
	ConfirmSX8()
EndIf 
//#RVC20180613.en

DBSelectarea("SM0")
	SM0-> (DbSetorder(1))
	SM0-> (DbSeek(cEmpant + cFilant))
	_cNomefil:= Alltrim(SM0->M0_FILIAL) +' - ' + cFilant

aCabPV:= {	{"C5_NUM" 		,cNumSC5 	        		,Nil},; 	// Numero do pedido
			{"C5_TIPO" 		,"N"       					,Nil},; 	// Tipo de pedido
			{"C5_CLIENTE"	, SA1->A1_COD 				,Nil},; 	// Codigo do cliente
			{"C5_LOJACLI"	, SA1->A1_LOJA   			,Nil},; 	// Loja do cliente
			{"C5_CONDPAG"	, "001" 	        		,Nil},; 	// Codigo da condicao de pagamanto - SE4
			{"C5_EMISSAO"	, dDataBase					,Nil},; 	// Data de emissao
			{"C5_TIPOCLI"	, SA1->A1_TIPO				,Nil},; 	// Tipo do Cliente
			{"C5_MSFIL"		, aPrdMost[1,nFILSAI]		,Nil},; 	// Tipo do Cliente 
			{"C5_MENNOTA"	, _cNomefil		            ,Nil},; 	// Mensagem para Nota
			{"C5_01PEDMO"	, "1"						,Nil},; 	// Tipo do Cliente
			{"C5_01TPOP"	, "2"						,Nil},; 	// Tipo de Operacao 2 = Transferencia
			{"C5_XCLICS"	, _cCliOrig				    ,Nil},; 	// Cliente Origem **campo novo cs
			{"C5_XPEDCS"	, _cPedOrig 				,Nil},; 	// Pedido Origem **campo novo cs					 
			{"C5_MOEDA"  	, 1        					,Nil}}	 	// Moeda     


//#RVC20180615.bn
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
//#RVC20180615.en

For nZ:=1 To Len(aPrdMost)
	
	//#RVC20180615.bn
	nPrUnit	:= aPrdMost[nZ,nVRUNIT]
	nValor	:= aPrdMost[nZ,nVLRITEM]
	
	If dbSeek(xFilial("SB1") + Alltrim(aPrdMost[nZ,nPRODUTO]))
		If !Empty(SB1->B1_PRV1)
			nPrUnit	:= SB1->B1_PRV15
			nValor	:= (nPrUnit * aPrdMost[nZ,nQUANT])
		EndIF
	EndIF
	//#RVC20180615.en
	
	cItemPC := Soma1(cItemPc)
	
	aItemSC6	:= {	{"C6_NUM"  		, cNumSC5				,Nil},;	 	// Numero do Pedido
						{"C6_ITEM"   	, cItemPc	    		,Nil},; 	// Numero do Item no Pedido
						{"C6_CLI"    	, SA1->A1_COD			,Nil},; 	// Cliente
						{"C6_LOJA"   	, SA1->A1_LOJA			,Nil},; 	// Loja do Cliente
						{"C6_ENTREG" 	, dDataBase    			,Nil},; 	// Data da Entrega
						{"C6_PRODUTO"	, aPrdMost[nZ,nPRODUTO]	,Nil},; 	// Codigo do Produto
						{"C6_QTDVEN" 	, aPrdMost[nZ,nQUANT]	,Nil},; 	// Quantidade Vendida
						{"C6_PRUNIT" 	, nPrUnit				,Nil},; 	// Preco Unitario Liquido	//{"C6_PRUNIT" 	, aPrdMost[nZ,nVRUNIT]	,Nil},; //#RVC20180615.n
						{"C6_PRCVEN" 	, nPrUnit             	,Nil},; 	// Preco Unitario Liquido	//{"C6_PRCVEN" 	, aPrdMost[nZ,nVRUNIT]	,Nil},; //#RVC20180615.n
						{"C6_VALOR"  	, nValor               	,Nil},; 	// Valor Total do Item		//{"C6_VALOR"  	, aPrdMost[nZ,nVLRITEM]	,Nil},; //#RVC20180615.n
						{"C6_UM"     	, aPrdMost[nZ,nUM]		,Nil},; 	// Unidade de Medida Primar.
						{"C6_MSFIL"		, aPrdMost[1,nFILSAI]	,Nil},; 	// Tipo do Cliente
						{"C6_TES"		, cTESTRF				,Nil},; 	// TES
						{"C6_QTDLIB"	, aPrdMost[nZ,nQUANT]	,"AlwaysTrue()"},; 	// TES
						{"C6_LOCAL"  	, cArmz					,Nil}}		//{"C6_LOCAL"  	, aPrdMost[nZ,nLOCAL]	,Nil}} //#RVC20180619.n
	
	Aadd(aItemPv,aClone(aItemSC6))
	
	SB1->(dbGoTop()) //#RVC20180615.n
Next

LjMsgRun("Aguarde...Gerando Pedido de Transferencia...",,{|| MsExecAuto({|x,y,z| mata410(x,y,z)},aCabPV,aItemPv,3) } )

If lMsErroAuto
	
	cPath := "\Transf_Mostruario\Erro"
	cNomeArq := "cFilAnt" + "_" + ALLTRIM(cNumSC5) + ".TXT"
    
	//Salva o erro no arquivo e local indicado
    MostraErro(cPath, cNomeArq)
	
	MostraErro()
	//memowrite("\Transf_Mostruario\Erro\"+cFilAnt+"_" + ALLTRIM(cNumSC5) + ".TXT", MostraErro())
	Return(.F.)
Else
	MsgInfo("Pedido de transfer�ncia incluido com sucesso. N�mero : " + cNumSC5 + " - Filial : " + cFilAnt)
	
	_cEMail		:= SuperGetMV("KH_MAILFAT",.F.,"rafael.cruz@komforthouse.com.br")
	_cFilial	:= AllTrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt+cFilAnt,1,"Sem Nome"))
	
	cMensagem := "Aos cuidados do departamento de log�stica da Komfort House,"+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Por favor providenciar o faturamento do pedido n.� "+ cNumSC5 + " proveniente do retorno simb�lico da Loja " + _cFilial +"." +chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Faz-se urgente e primordial o faturamento deste e sua devida entrada no CD Principal (Armaz�m de Mostru�rios) ap�s transmiss�o do DANFe."+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "O pedido n.� "+ _cPedOrig +" do cliente "+ _cCliOrig +" depende desta transfer�ncia para ser faturado."+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Caso o(a) senhor(a) n�o seja o destinat�rio correto desta mensagem, por favor nos informar."+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Atenciosamente,"+chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += chr(13)+chr(10)+chr(13)+chr(10)
	cMensagem += "Por favor n�o responder esse e-mail!"+chr(13)+chr(10)+chr(13)+chr(10)
	
	Processa( {|| fEnvMail(_cEmail,"[LOJA "+_cFilial+"] Retorno de Mostru�rio - PV N.�: " + cNumSC5,"\Transf_Mostruario\"+cFilAnt+"_" + ALLTRIM(cNumSC5) + ".TXT",cMensagem)},"Enviando e-mail para a �rea de log�stica...")
						//(cEnvia,cAssunto,cAnexos,cMensagem)
	memowrite("\Transf_Mostruario\"+cFilAnt+"_" + ALLTRIM(cNumSC5) + ".TXT", cMensagem)
	
	//�������������������������������������������������������������������Ŀ
	//� Executa a liberacao do pedido sem avaliacao de credito e estoque. �
	//���������������������������������������������������������������������
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+cNumSC5)
	
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNumSC5
		MaLibDoFat(SC6->(Recno()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
		DbSelectArea("SC6")
		DbSkip()
	EndDo
EndIF

//cFilAnt := cFilBkp

RestArea(aAreaSB1) //#RVC20180615.n

RETURN()

//#RVC20180613.bn
Static Function fEnvMail(cEnvia,cAssunto,cAnexos,cMensagem)

cServer     := GETMV('MV_RELSERV')
cAccount    := GETMV('MV_RELACNT')
cPassword   := GETMV('MV_RELAPSW')

//cEnvia := "caio@globalgcs.com.br"
//cAnexos := "\rpedcom\pedido_compra000054.pdf"

//��������������������������Ŀ
//� Conecta no Servidor SMTP �
//����������������������������

lConectou:=MailSmtpOn(cServer, cAccount, cPassword )

If !lConectou
	Alert("N�o conectou SMTP")
Endif

MailAuth(cAccount,cPassword)

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
Send Mail From cAccount To cEnvia SubJect cAssunto BODY cMensagem ATTACHMENT cAnexos RESULT lEnviado

If !lEnviado
	cErro := ""
	Get Mail Error cErro
	
	Alert(cErro)
	
Else
	
	//	Alert("E-mail Enviado com Sucesso!!")
Endif

//�����������������������������Ŀ
//� Desconecta do Servidor SMTP �
//�������������������������������
Disconnect SMTP SERVER Result lDesConectou

If !lDesconectou
	Alert("N�o Desconectou SMTP")
Endif

Return
//#RVC20180613.en
