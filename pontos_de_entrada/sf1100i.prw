#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   º Autor ³ Ellen Santiago     º Data ³  25/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E na confirmacao da NF para reserva do produto           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KOMFORTHOUSE   -- PRECISA ALIMENTAR SB2                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//-----------------------------------------------------------------------------------------------
//----- > EXCLUIR DO RPO PARA PODER FAZER A RESERVA EM UM P.E NA ROTINA DE ENDERECAMENTO < ------
//-----------------------------------------------------------------------------------------------
User Function SF1100I

	//FwMsgRun( ,{|| GeraReserva() }, , "Endereçando e reservando, Favor Aguardar..." )   
	
Return

Static Function GeraReserva()

Local aArea 		:= GetArea()// Armazena ultima area utilizada
Local cObs			:= ""		// Observacao na reserva
Local nDtlimit		:= 10		// Numero de dias para calculo da data limite da reserva	
Local aOperacao		:= {}		// Array com os dados de envio para a rotina a430Reserv
Local aHeaderAux	:= {}		// Simulacao do aHeader para a rotina a430Reserv
Local aColsAux 		:= {}		// Simulacao do aCols para a rotina a430Reserv			
Local cNumRes 		:= ""		// Gera Numero de Reserva Sequencial 
Local cCliente		:= ""		// Cliente do pedido de venda
Local cProduto		:= ""		// Produto a ser reservado
Local cLocal		:= ""		// Armazem
Local nQUANT		:= 0		// Quantidade a ser reservada
Local nUso			:= 0		// Contador auxiliar para montagem do aHeader
Local aLote			:= {"","","",""} // Array com os dados do lote para a rotina a430Reserv	
Local cItem			:= ""
Local lRet			:= .F.

PUTMV("MV_DISTMOV", "F") //--> Nao exibe a interface de enderecamento, se permitir nao será possível reservar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com aHeader e aCols somente 		    ³
//³ com os dados necessarios para a rotina de reserva ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaderAux := {}
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("C0_VALIDA ")
		nUso++
		AADD(aHeaderAux,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT }	)
Endif

// Numero de dias para calculo da data limite da reserva
//nDtlimit	:= SuperGetMV("MV_DTLIMIT",,0)

aColsAux := Array(nUso+1)
aColsAux[1] := dDataBase+nDtlimit
aColsAux[nUso+1] := .F.

cObs := "Reserva automatica ao dar entrada na nota nos casos de encomendas"

Dbselectarea("SD1")
DbsetOrder(1)

Dbselectarea("SB1")
DbsetOrder(1)
	
SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
Do While ! SD1->(Eof()) .And. SD1->D1_FILIAL == SF1->F1_FILIAL .AND.  SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA
	IF SB1->(DbSeek(xFilial('SB1')+SD1->D1_COD))
		If SB1->B1_XENCOME == '2' //-->³Somente para os casos de encomenda³
				
			aOperacao := {	1						,;	// Operacao : 1 Inclui,2 Altera,3 Exclui
							"PD"					,;	// Tipo da Reserva : PD - Pedido
							SD1->D1_DOC				,;	// Documento que originou a Reserva
							UsrRetName(RetCodUsr())	,;	// Solicitante
							xFilial("SF1")			,;	// Filial
							cObs		} 				// Observacao
			
			cProduto	:= SD1->D1_COD 
			cLocal		:= SD1->D1_LOCAL
			nQuant		:= SD1->D1_QUANT
			cItem		:= SD1->D1_ITEM
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ---------- Enderecamento automatico ------------- ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet := KH265I(SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_ITEM,SD1->D1_QUANT,SD1->D1_NUMSEQ,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA)
			If lRet 	
				cNumRes := GetSx8Num("SC0","C0_NUM") 	
				lReserv := A430Reserv (aOPERACAO,cNumRes,cProduto,cLocal,nQuant,aLOTE,aHeaderAux,aColsAux,NIL,.F.) 	//-->³Efetua a Reserva 	 
				SC0->( MsUnLock() )  //-->³Libera a tabela SC0 para confirmar reserva³
				If !lReserv
					cNumRes	 := ""
					AutoGrLog("------------------------------------------------------------------------")
					AutoGrLog("------------------------------ RESERVA ----------------------------")
					AutoGrLog("---------------- Não foi possivel realizar a reserva -----------------")
					AutoGrLog("----------------------------------------------------------------------------")
					RollBackSx8()		
				Else
					AutoGrLog("------------------------------------------------------------------------")
					AutoGrLog("------------------------------ RESERVA ----------------------------")
					AutoGrLog(" Reserva " + cNumRes + "realizada com sucesso.")
					AutoGrLog("-----------------------------------------------------------------------")
					ConfirmSX8()
				EndIf
			Else
			KHEXCLUI(SF1->(RECNO()),SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
			Endif
		Endif		
	Endif		
SD1->(dbSkip())
EndDo

MostraErro()

RestArea(aArea)

PUTMV("MV_DISTMOV", "T") 

Return


 //+------------+--------------+-------+------------------------+------+------------+
//| Função:    | KH265I        | Autor | Ellen Santiago         | Data | 26/04/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Rotina para enderecar                                              |
//+------------+--------------------------------------------------------------------+
//|Uso         | KomfortHouse                                                       |              
//+---------------------------------------------------------------------------------+

Static Function KH265I(cProduto,cLocal,cItem,nQuant,cNumSeq,cDoc,cSerie,cClifor,cLoja)

Local aCab 		:= {}
Local aItem		:= {}
Local lRet		:= .F.
Local _cHTML 	:= ""
Local cTO 		:= SuperGetMv("KH_TOEMAIL",,.T.)
Local cEndereco	:= SuperGetMv("KH_ENDEREC",,.T.)

AutoGrLog("------------------------------------------------------------------------")
AutoGrLog("------------------ ENDEREÇAMENTO AUTOMÁTICO ---------------------")

lMsErroAuto := .F.

aCab := {	{"DA_PRODUTO",cProduto,NIL},; 
          	{"DA_LOCAL",cLocal,NIL},;
          	{"DA_NUMSEQ" ,cNumSeq,NIL},;
          	{"DA_DOC",cDoc,NIL},;
          	{"DA_SERIE",cSerie,NIL},;
          	{"DA_CLIFOR",cClifor,NIL},;
          	{"DA_LOJA",cLoja,NIL}}
          	   	

aAdd(aItem, { {"DB_ITEM",cItem,NIL},; 
		  {"DB_ESTORNO"  ," "       ,Nil},;
          {"DB_LOCALIZ",cEndereco,NIL},; 
          {"DB_DATA",dDataBase,NIL},; 
          {"DB_QUANT",nQuant,NIL}})

MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3) //Distribui

If !lMsErroAuto 
	AutoGrLog( "Data.........: " + DtoC(Date()) )
	AutoGrLog( "Hora.........: " + Time() )
	AutoGrLog( "Ocorrência...: Problema no enderaçamento automático " )
	AutoGrLog( "Solução...: Realizar endereçamento manual" )
	MostraErro()
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o e-mail de alerta             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	_cHTML  := "<hr align='tr' color='#00008B'>"
	_cHTML  += "<p align='center'><font color='#DC143C' size='4' face='Arial'>"
	_cHTML  += "<img align='center' src='C:\totvs\logo.png' />" 
	_cHTML  += "<p align='center' <b>- A T E N Ç Ã O -</b></font></p></hr>"
	_cHTML  += "<hr align='tr' color='#00008B'>"
	_cHTML 	+= "<p><span style='font-size:11.0pt;color:#000000;font-family:Arial'><b>OCORRÊNCIA:</b> Houve problemas no endereçamento automático</span></p>"
	_cHTML 	+= "<p><span style='font-size:11.0pt;color:#000000;font-family:Arial'><b>SOLUÇÃO:</b> Realizar o endereçamento manual com urgência</b></span></p>"
	_cHTML 	+= "<p><span style='font-size:10.0pt;font-family:Arial'>DOCUMENTO: "+AllTrim(cDoc)+ " - Serie:" + cSerie + "</span></p>"
	_cHTML 	+= "<p><span style='font-size:10.0pt;font-family:Arial'>PRODUTO: "+AllTrim(cProduto) +" </b></span></p>"	
	_cHTML 	+= "<p span </span></p>"		 	 	
	_cHTML	+= "<p span </span></p>"		 	 	
	_cHTML	+= "<p span </span></p>"		 	 	
	_cHTML	+= "<p span  bgcolor ='#FFFFFF' class=MsoNormal <font face='Arial' size='1'></span></p>"
	_cHTML	+= "<p align=center style='text-align:center'><b>"
	_cHTML	+= "<span span <font face='Arial' size='1' color:#000000>-------------------------- Declaração de Confidencialidade de E-mail na Internet --------------------------</span></b><span <font face='Arial' size='1'></span></p>"
	_cHTML	+= "<p class=MsoNormal>"
	_cHTML	+= "<span <font face='Arial' size='1' color:#000000>Esta é uma mensagem automática. Não responda a esta mensagem.<br>"
	_cHTML	+= "<span color:#000000><b>Nota de Confidencialidade:</b> Esta mensagem e seus anexos podem conter informação confidencial ou privilegiada. Caso você não seja um dos destinatários, por favor apague-a e informe-nos sobre seu recebimento indevido. É proibida a retenção, divulgação ou utilização de quaisquer informações contidas nesta mensagem por pessoas não autorizadas. Agradecemos pela cooperação.</span><BR>"
	_cHTML	+= "<span color:#000000><b>Confidentiality Note: </b>This e-mail and its attachments may contain confidential or privileged information. If you are not the intended recipient, please delete the mail and notify us by reply. No one but the addresses may retain, disclose or use any of the contents of this email. Thank you for your cooperation.</span>"
	_cHTML	+= "<span color:#000000><p>Programa Fonte: SF1100I</span></p>"
	memowrite('C:\temp\arquivo.html',_cHTML)									
	cAssunto := 'Problemas no endereçamento'
	cMsg     := _cHTML
	cTO      := 'ellen.santiago@globalgcs.com.br'
	cCC      := ''
	lDNSAuth := .T.
	cAnexo   := ''
	U_KMHSendMail(cAssunto, cMsg, cTO, cCC, lDNSAuth, cAnexo)
Else
	lRet := .T.
	AutoGrLog( "Endereçamento automãtico realizado com sucesso." )
Endif

Return lRet

//+------------+---------------+-------+------------------------+------+------------+
//| Função:    | KMHSendMail   | Autor | Ellen Santiago         | Data | 27/04/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Funcao que envia  emails                                           |
//+------------+--------------------------------------------------------------------+
//|Parƒmetros  | ExpC1 -> assunto para envio do e-mail                              |              
//|            | ExpC2 -> mensagem                                                  |
//|            | ExpC3 -> e-mail do destinatario                                    |
//|            | ExpC4 -> e-mail para copia carbono                                 | 
//|            | ExpL1 -> se usa o dominio da conta para autenticacao               |
//+---------------------------------------------------------------------------------+

User Function KMHSendMail( cAssunto, cMsg, cTO, cCC, lDNSAuth, cAnexo)

Local lOk		:= .F.		// Variavel que verifica se foi conectado OK
Local lSendOk	:= .F.		// Variavel que verifica se foi enviado OK
Local cError	:= ""
Local cEmailTo	:= ""
Local cEmailBcc	:= ""
Local lMailAuth	:= SuperGetMv("MV_RELAUTH",,.T.)
Local cMailAuth	:= ""      
Local lResult	:= .F.

Default cCC		:= ""
Default cMsg	:= ""
Default lDNSAuth	:= .F.
Default cAnexo    	:= "" 

Private cMailConta	:= Nil
Private cMailServer	:= Nil
Private cMailSenha	:= Nil

cMailConta	:= AllTrim(If( cMailConta	== NIL, GetMV( "MV_EMCONTA" ), cMailConta  ))
cMailServer	:= AllTrim(If( cMailServer	== NIL, GetMV( "MV_RELSERV" ), cMailServer ))
cMailSenha	:= AllTrim(If( cMailSenha	== NIL, GetMV( "MV_EMSENHA" ), cMailSenha  ))

//Verifica se existe o SMTP Server
If 	Empty(cMailServer)
	Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a CONTA 
If 	Empty(cMailServer)
	Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a Senha
If 	Empty(cMailServer)
	Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf                                              

cEmailTo := Alltrim(cTO)
cEmailBcc:= Alltrim(cCC)

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	
	While .T.
		
		//CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk SSL
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk //SSL
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a autenticacao no servidor SMTP                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMailAuth
			If ( "@" $ cMailConta ) .AND. !lDNSAuth
				cMailAuth := Subs(cMailConta,1,At("@",cMailConta)-1)
			Else
				cMailAuth := cMailConta
			EndIf
	
			lResult := MailAuth(cMailAuth,cMailSenha)
		Else
			lResult := .T. //Envia E-mail
		Endif
	
		If 	lOk .And. lResult    
			
	        	If !Empty(cAnexo)
				
					SEND MAIL 	FROM cMailConta;
								TO cEmailTo;
			 					CC cEmailBcc;
								SUBJECT cAssunto;
								BODY cMsg;
								ATTACHMENT cAnexo;
								RESULT lSendOk
				Else			
					
					SEND MAIL 	FROM cMailConta;
								TO cEmailTo;
			 					CC cEmailBcc;
								SUBJECT cAssunto;
								BODY cMsg;
								RESULT lSendOk
				EndIf	
				
				If !lSendOk
					//Erro no Envio do e-mail
					GET MAIL ERROR cError
					If Aviso("Erro no envio de Email!!!",cError + "Tentar novamente?",{"Sim","Não"}) == 1

				    	DISCONNECT SMTP SERVER

						Loop
					EndIf 
				EndIf
		            
	            Exit
	                        
	    	DISCONNECT SMTP SERVER
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			MsgInfo( cError, OemToAnsi( "Erro no envio de Email" ) ) 
		EndIf
		
    EndDo 

EndIf

Return lSendOk

 //+------------+--------------+-------+------------------------+------+------------+
//| Função:    | KH265I        | Autor | Ellen Santiago         | Data | 26/04/2018 | 
//+------------+---------------+-------+------------------------+------+------------+
//| Descrição: | Rotina para exclusao da nota em caso de problemas no enderecamento |
//+------------+--------------------------------------------------------------------+
//|Uso         | KomfortHouse                                                       |              
//+---------------------------------------------------------------------------------+

Static Function KHExclui(nRecno,xFilial,cDoc,cSerie,cFornece,cLoja)

Do While !SD1->(Eof()) .And. SD1->D1_FILIAL == xFilial .AND.  SD1->D1_DOC == cDoc .AND. SD1->D1_SERIE == cSerie .And. SD1->D1_FORNECE == cFornece .And. SD1->D1_LOJA == cLoja 
	RecLock("SD1", .F.)
		dbDelete()
	MsUnlock()
SD1->(dbSkip())
EndDo

SF1->(dbGoto(nRecno))
RecLock("SF1", .F.)
	RecLock("SF1", .F.)
	dbDelete()
MsUnlock()

Return