#Include "Totvs.ch"
#include "Protheus.ch"

#define cAlert1 "Já existe Titulo para o Produto "
#define cAlert2 "Linha "
#define cAlert3 "O item não será considerado para geração do Titulo NCC."
#define cAlert4 "ATENÇÃO !!!"

#DEFINE ENTER (Chr(13)+Chr(10))

//----------------------------------------------------------------
/*/{Protheus.doc} TK271BOK()
Ponto de entrada chamado no botão "OK" da barra de ferramentas da
tela de atendimento do Call Center, antes da função de gravação.
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------

User Function TK271BOK()

Local lRet := .T. //Varial de Controle, .T. Realiza a baixa <---> .F. Não Realiza a baixa
Local cTipoAcesso := tkgettipoate()
Local xVlrFrt:=GetMV("KH_VLFRTFI")
Local aVlrFrt:=StrtokArr(xVlrFrt, ",")

if cTipoAcesso == '1' //Verifico se o usuario esta abrindo chamado(1= telemarketing)
	
	GerNCCNDC(@lRet)
	
	fBlqPed(@lRet)
	
	//Cancela Substitui
	CancSubs(@lRet)
	
	//Trava Cancela 
	//fTravaC(@lRet)
	
	if INCLUI
		//atribui uma comunicação automaticamente
		fComunic(@lRet)
	endif
	
endif

//lRet := .F.	//Utilizar somente para Teste, para não gravar o registro corrente

/*
//Alterado em 13/03/2019 - Vanito Rocha
Ticket 7983

O campo de frete de um pedido de valor entre 0,01 a 1999,99 será preenchido obrigatoriamente R$ 90,00 ou mais e não é menos de 90,00.
O campo de frete de um pedido de valor entre 2000,00 a 2999,99 será preenchido obrigatoriamente R$ 110,00 ou mais e não é menos de 110,00.
O campo de frete de um pedido de valor entre 3000,00 a cima, será preenchido obrigatoriamente R$ 140,00 ou mais e não é menos de 140,00.

aValores[1]    = Valor Mercadori
aValores[2]    = Descontosi
aValores[3]    = Suframa
aValores[4]    = Frete
aValores[5]    = Despesas
aValores[6]    = Despesasri
aValores[7]    = Valor Mercadori
aValores[8]    = Valor Mercadori

O parâmetro  KH_VLFRTF em suas primeiras posições sempre terá o valor do frete e em seguida o valor da mercadoria (sem adição de nenhuma taxa)


*/
//Início alteração Vanito Rocha
If cTipoAcesso == '2'	
	If aValores[4] >  0
		If  aValores[1] >  Val(aVlrFrt[1]) .And. aValores[1] < Val(aVlrFrt[2])
			If  !(aValores[4] >= Val(aVlrFrt[1]))
				msgAlert( "O campo de frete de um pedido de valor entre 0,01 a  "+aVlrFrt[2] + " DEVE ser preenchido obrigatoriamente R$ 90,00 ou mais.", "Atenção" )
				lRet:=.F.
				Return lRet
			Endif
		ElseIf  aValores[1] >  Val(aVlrFrt[3]) .And. aValores[1] < Val(aVlrFrt[4])
			If  !(aValores[4]  >=  Val(aVlrFrt[3]))
				msgAlert( "O campo de frete de um pedido de valor entre 2000,00 a  "+aVlrFrt[4] + "  DEVE ser preenchido obrigatoriamente R$ 110,00 ou mais.", "Atenção" )
				lRet:=.F.
				Return lRet
			Endif
		ElseIf  aValores[1] >=  Val(aVlrFrt[6])
			If  !(aValores[4]  >=  Val(aVlrFrt[5]))
				msgAlert( "O campo de frete de um pedido de valor entre "+aVlrFrt[6] + "ou superior DEVE ser preenchido obrigatoriamente R$ 140,00 ou mais.", "Atenção" )
				lRet:=.F.
				Return lRet
			Endif
		Endif
	Endif
Endif
//Fim da alteração Vanito Rocha

Return lRet
        

//--------------------------------------------------------------
/*/{Protheus.doc} fBlqPed
Description //Descrição da Função
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 30/05/2019 /*/
//--------------------------------------------------------------
Static Function fBlqPed(lRet)

	Local nPosTpAcao := gdFieldPos("UD_01TIPO",aHeader) 	//Tipo Acao
	Local nPosStatus := gdFieldPos("UD_STATUS",aHeader)		//Status
	Local cNumPed 	 := iif(INCLUI,right(M->UC_01PED,6),right(SUC->UC_01PED,6))
	Local aItens 	 := {} 
	Local nZ		 := 0  
	Local _cUser := SUPERGETMV("KH_SAC003", .T., "000478") //Parametro reutilizado pois contem os usuários chaves com permissão do SAC - Marcio Nunes 11/07/2019
	
	for nx := 1 to len(aCols)
		//Verifico se a linha esta deletada e se o Status esta em aberto
		if aCols[nx][len(aHeader)+1] == .F. .AND. aCols[nx][nPosStatus] == "1"
			//Verifico se a ação é do tipo (Cancela Substitui)
			if vldTpAC(aCols[nx][nPosTpAcao])
				lRet := .T.
				aAdd(aItens,{;
							0,;	//1 - Valor do Pedido
							"",;//2 - Cliente
							"",;//3 - Loja
							"",;//4 - Não Utilizado, tabela X5 - O1
							"",;//5 - Numero do Atendimento
							"",;//6 - Observações
							"",;//7 - Tipo Acao NDC ou NCC
							nx})//8 - Linha Posicionada
			endif
		endif		
	next nx
             
	//Verifica se a linha digitada é diferente da primeira ocorrência. - Marcio Nunes -11/07/2019 -  Chamado: 8781
	If !(__cUserid $ _cUser)               
		For nZ := 1 to Len(aCols)  
			If !(aCols[nZ][2] == aCols[1][2])			
				MsgAlert("O Assunto não pode ser diferente para o mesmo do Chamado.")
				Return(lRet := .F.)
			EndIf			
		Next nZ
	EndIf 

	if len(aItens) == 0 //Se não existir nenhum tipo de ação de bloqueio de PV
		Return(.T.)
	endif  	

	dbSelectArea("SC5")                                   
	SC5->(dbsetorder(1))
	SC5->(dbgotop())
                                                                     
	if lRet
		if SC5->(dbSeek(xFilial() + cNumPed))

			if !(empty(SC5->C5_NOTA)) .and. !(SC5->C5_NOTA $ 'X')
				msgAlert("Não é possivel realizar o cancelamento. O pedido ja encontra-se Faturado ou Cancelado.",cAlert4)
				Return(lRet := .F.)
			endif

			if SC5->C5_EMISSAO == dDatabase
				msgAlert("Para o cancelamento no mesmo dia, utilize a rotina (Exclusão de Pedidos).",cAlert4)
				Return(lRet := .F.)
			endif

			if !SC5->C5_XBLQCAN == 'L'
				if SC5->C5_XBLQCAN == 'R'
					cMsg := "Sua solicitação de cancela/Substitui foi recusada pela Diretoria." + ENTER
					cMsg += "Para seguir com o processo, entre em contato com o seu Supervisor."	
					
					msgAlert(cMsg,cAlert4)

					atuSud(aItens)	
					Return(lRet := .T.)				
				else
					if SC5->C5_EMISSAO + 5 < dDatabase
						
						M->UC_STATUS := '11'

						recLock("SC5",.F.)
							SC5->C5_XBLQCAN := 'B'
						SC5->(msunlock())
						
						cMsg := "Não é possivel Realizar o cancelamento do PV após 5 Dias." + ENTER
						cMsg += "Por favor, Aguarde a autorização da Diretoria." + ENTER  + ENTER

						msgAlert(cMsg,cAlert4)
						
						atuSud(aItens)
						Return(lRet := .T.)	
					endif
				endif
			endif
		else
			msgAlert("O pedido informado não foi encontrado.",cAlert4)
			Return(lRet := .F.)
		endif

	endif

Return

//----------------------------------------------------------------
/*/{Protheus.doc} vldTpAC()
Rotina responsavel pela validação do Tipo de Ação, Verifico se a ação é do tipo (Bloqueio de PV)
@author Alexis Duarte
@utilizacao Komfort House
@since 30/05/2019
/*/
//----------------------------------------------------------------
Static Function vldTpAC(cCodAcao)

	Local aArea := getArea()
	Local lRet := .F.

	dbSelectArea("Z01")
	dbSetOrder(1)
	Z01->(dbgotop())

	if Z01->(dbSeek(xFilial("Z01") + cCodAcao))
		
		if Z01->Z01_TIPO == '7' .AND. Z01_COD == 'CSBLOQ'
			lRet := .T.
		endif
		
	endif

	Z01->(dbCloseArea())

	restArea(aArea)

Return lRet


//--------------------------------------------------------------
/*/{Protheus.doc} fComunic
Description //Preenche o campo comunicação automaticamente na emissão dos chamados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/12/2018 /*/
//--------------------------------------------------------------
Static Function fTravaC(lRet)
Local nPosAssunto := gdFieldPos("UD_ASSUNTO",aHeader) //Assunto 
Local nPosSolu := gdFieldPos("UD_SOLUCAO",aHeader) //Solução 
Local nPosTit  := gdFieldPos("UD_XNUMTIT",aHeader) //Titulo 
Local nPosAca  := gdFieldPos("UD_01TIPO",aHeader) //Acao
Local _cUser := SUPERGETMV("KH_SAC003", .T., "000478") //Parametro reutilizado pois contem os usuários chaves com permissão do SAC - Marcio Nunes 11/07/2019
Local cAssun := ""

 cAssun := acols[1][nPosAssunto]
	
	If M->UC_STATUS == "3"
		
		If cAssun == "000009"
			If !(__cUserid $ _cUser)         
				for ny := 1 to len(acols)
				
					If acols[ny][nPosSolu] == "000146" .AND. EMPTY(acols[ny][nPosTit])
					MsgAlert("Para Encerrar o chamado de Cancela Substituí é necessário Realizar o processo completo!","Atenção")
					lRet := .F.
					EndIf
					
				Next ny
			EndIf
		EndIf
	
	EndIf

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} fComunic
Description //Preenche o campo comunicação automaticamente na emissão dos chamados
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 18/12/2018 /*/
//--------------------------------------------------------------
Static Function fComunic(lRet)

Local nPosAssunto := gdFieldPos("UD_ASSUNTO",aHeader) 	//Assunto
Local aOperadores := {}
Local cAssunto := ""
Local cUltimo := ""
Local nPosUltimo := 0
Local cAtual := ""

dbselectarea("SUL")
SUL->(dbsetorder(1))
SUL->(dbGoTop())

if len(aCols) > 0
	
	cAssunto := acols[1][nPosAssunto]
	
	While SUL->(!eof())
		if SUL->UL_XASSUNT == cAssunto .and. SUL->UL_VALIDO == '1'
			
			aAdd(aOperadores,{;
			SUL->UL_TPCOMUN,;
			SUL->UL_DESC,;
			SUL->UL_XASSUNT;
			})
			
			if !empty(SUL->UL_XULT)
				cUltimo := SUL->UL_TPCOMUN
			endif
			
		endif
		SUL->(dbSkip())
	End
endif

nQtdOperad := len(aOperadores)

if nQtdOperad > 0
	nPosUltimo := Ascan(aOperadores,{|x| Alltrim(x[1]) == cUltimo})
	
	Do Case
		Case empty(cUltimo)
			cAtual := aOperadores[1][1]
			lUltimo := .F.
			lAtual := .T.
		Case nPosUltimo == nQtdOperad
			cAtual := aOperadores[1][1]
			lUltimo := .T.
			lAtual := .T.
		Otherwise
			cAtual := aOperadores[nPosUltimo+1][1]
			lUltimo := .T.
			lAtual := .T.
	EndCase
	
else
	lRet := .F.
	Return(msgAlert("Não existe operadores cadastrados para esse assunto.","Atenção"))
endif

if lUltimo
	
	cUpdate := "UPDATE "+ retSqlName("SUL")+" SET UL_XULT = '' WHERE UL_TPCOMUN = '"+cUltimo+"' AND UL_VALIDO = '1' AND D_E_L_E_T_ = ''"
	
	nStatus := TcSqlExec(cUpdate)
	
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError(),"Atenção")
	endif
endif

if lAtual
	
	cUpdate := "UPDATE "+ retSqlName("SUL")+" SET UL_XULT = 'S' WHERE UL_TPCOMUN = '"+cAtual+"' AND UL_VALIDO = '1' AND D_E_L_E_T_ = ''"
	
	nStatus := TcSqlExec(cUpdate)
	
	if (nStatus < 0)
		msgAlert("Erro ao executar o update: " + TCSQLError(),"Atenção")
	endif
	
	M->UC_TIPO := cAtual
	
	if ExistTrigger('UC_TIPO')
		runTrigger(1,Nil,Nil,,'UC_TIPO')
	endif
endif

Return lRet

//----------------------------------------------------------------
/*/{Protheus.doc} GerNCCNDC()
Rotina responsavel pela geração do NCC ou NDC
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------

Static Function GerNCCNDC(lRet)

Local aArea := getArea()
Local cHistorico := "TITULO GERADO PELO TIPO DE AÇÃO (NCC)"
//Informações do Cliente
Local cCodCli := ""
Local cCodLoja := ""

Local cNumPed := iif(INCLUI,right(M->UC_01PED,6),right(SUC->UC_01PED,6))

Local cNrChamado := iif(INCLUI,M->UC_CODIGO,SUC->UC_CODIGO)

//Posição dos campos no ACols
Local nPosTpAcao := gdFieldPos("UD_01TIPO",aHeader) 	//Tipo Acao
Local nPostitulo := gdFieldPos("UD_XNUMTIT",aHeader)	//Numero do Titulo
Local nPosValPed := gdFieldPos("UD_01VLPED",aHeader)	// Valor Pedido
Local nPosProdut := gdFieldPos("UD_PRODUTO",aHeader)	// Codigo do produto
Local nPosStatus := gdFieldPos("UD_STATUS",aHeader)		//Status

Local cTipoAcao := ""
Local cMotivo := ""
Local aItens := {}
Local nValtotPed := 0
Local cNumTitulo := ""
Default lRet := .T.

retCodLoja(cNumPed, @cCodCli, @cCodLoja)

for nx := 1 to len(aCols)
	//Verifico se a linha esta deletada e se o Status esta em aberto
	if aCols[nx][len(aHeader)+1] == .F. .AND. aCols[nx][nPosStatus] == "1"
		//Valida o Tipo de Ação // NDC ou NCC
		if vldTpAcao(aCols[nx][nPosTpAcao], @cTipoAcao)
			if empty(aCols[nx][nPostitulo])
				aAdd(aItens,{;
				aCols[nx][nPosValPed],;			//1 - Valor do Pedido
				cCodCli,; 			 			//2 - Cliente
				cCodLoja,;			  			//3 - Loja
				cMotivo,;			   			//4 - Não Utilizado, tabela X5 - O1
				cNrChamado,;					//5 - Numero do Atendimento
				cHistorico,; 					//6 - Observações
				cTipoAcao,;						//7 - Tipo Acao NDC ou NCC
				nx})							//8 - Linha Posicionada
			else
				//cMsgAlert := cAlert1 + alltrim(aCols[nx][nPosProdut]) + cAlert2 + cValtoChar(nx)+"."+ chr(13)+chr(10)
				//cMsgAlert += cAlert3
				
				//msgAlert(cMsgAlert,cAlert4)
			endif
		endif
	endif
next nx

for ny := 1 to len(aItens)
	
	if aItens[ny][7] == "NCC"
		nValtotPed += aItens[ny][1]
	endif
	
next ny

if !empty(aItens)
	if msgYesNo("Confirma a geração do Titulo " + cTipoAcao + " no valor de "+ transform(nValtotPed,"@E 999,999.99") ,"Komfort House")
		if CriaTit(@cNumTitulo,nValtotPed,cCodCli,cCodLoja,cMotivo,cNrChamado,cHistorico,cTipoAcao,cNumPed,.T.)
			atuSud(aItens,cNumTitulo)
		else
			Return .F.
		endif
	endif
endif

RestArea(aArea)

Return lRet

//----------------------------------------------------------------
/*/{Protheus.doc} retCodLoja()
Retorna o codigo e loja do cliente com base no pedido de venda
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------

Static Function retCodLoja(cNumPed, cCodCli, cCodLoja)

Local aArea := getArea()

dbSelectArea("SC5")
dbSetOrder(1)

if SC5->(dbSeek(xFilial("SC5") + cNumPed))
	
	cCodCli := SC5->C5_CLIENTE
	cCodLoja := SC5->C5_LOJACLI
	
else
	
	Do Case
		Case INCLUI
			cCodCli := left(M->UC_CHAVE,6)//Codigo do cliente
			cCodLoja := right(alltrim(M->UC_CHAVE),2)//Codigo da Loja do Cliente
		Case ALTERA
			cCodCli := left(SUC->UC_CHAVE,6)//Codigo do cliente
			cCodLoja := right(alltrim(SUC->UC_CHAVE),2)//Codigo da Loja do Cliente
	EndCase
	
endif

SC5->(dbCloseArea())

restArea(aArea)

Return

//----------------------------------------------------------------
/*/{Protheus.doc} vldTpAcao()
Rotina responsavel pela validação do Tipo de Ação
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------

Static Function vldTpAcao(cCodAcao, cTipoAcao)

Local aArea := getArea()
Local lRet := .F.

dbSelectArea("Z01")
dbSetOrder(1)
Z01->(dbgotop())

if Z01->(dbSeek(xFilial("Z01") + cCodAcao))
	
	if Z01->Z01_TIPO = '4'
		cTipoAcao := "NCC"
		lRet := .T.
	endif
	
endif

Z01->(dbCloseArea())

restArea(aArea)

Return lRet

//----------------------------------------------------------------
/*/{Protheus.doc} CriaTit()
Criação de Titulo via execAuto
@author Alexis DuarteCONE
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------
Static Function CriaTit(cNumTitulo,nValorTit,cCliente,cLoja,cMotivo,cNrChamado,cObs,cTPTit,cPedOri,lConf)

	Local lRet 			:= .T.                  				// Retorno
	Local aVetor        := {}                   				// Array com dados para gerar.
	//	Local cPrefixo		:= "MAN"	//#RVC20180607.o
	Local cPrefixo		:= "SAC"	//#RVC20180607.n
	//Local cPrefixo		:= "CLS"	//#wellington Raul chamado:15102
	Local cNumTit     	:= GetSxeNum("SE1","E1_NUM")
	Local cTipo			:= iif(cTPTit=="NCC","NCC","NDC")
	Local cNatNCC	 	:= SuperGetMV("MV_NATNCC")
	Local cNatNDC		:= SuperGetMV("MV_NATNDC")
	Local cParcela 		:= SuperGetMV("MV_1DUP")				// Parcela a gerar

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	Default lConf := .F.

	cNumTitulo := cNumTit

	DbSelectArea("SE1")
	DbSetOrder(1)

	While SE1->(DbSeek(xFilial("SE1") + cPrefixo + cNumTitulo + cParcela + cTipo))
		cParcela := CHR(ASC(cParcela)+1)
	End

	aAdd(aVetor,{"E1_PREFIXO"	,cPrefixo											,Nil})
	aAdd(aVetor,{"E1_NUM"	  	,cNumTitulo											,Nil})
	aAdd(aVetor,{"E1_PARCELA" 	,cParcela											,Nil})
	aAdd(aVetor,{"E1_NATUREZ" 	,iif(cTPTit=="NCC",cNatNCC,cNatNDC)                 	,Nil})
	//	aAdd(aVetor,{"E1_NATUREZ" 	,iif(cTPTit=="NCC",cNatNCC,cNatNDC)                 	,Nil})	//#RVC20180514.o
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
	aAdd(aVetor,{"E1_ORIGEM"	,"TMKA271"											,Nil})
	aAdd(aVetor,{"E1_MULTNAT"	,"2"												,Nil})
	aAdd(aVetor,{"E1_FLUXO"		,"N"												,Nil})
	aAdd(aVetor,{"E1_BASCOM1"	,xMoeda(nValorTit,1,1,nValorTit)					,Nil})
	aAdd(aVetor,{"E1_HIST"		,cObs												,Nil})
	aAdd(aVetor,{"E1_01SAC"		,cNrChamado											,Nil})
	aAdd(aVetor,{"E1_01MOTIV"	,cMotivo											,Nil})
	AAdd(aVetor,{"E1_USRNAME"	,UsrRetName(__cUserID)								,Nil})

	if lConf
		AAdd(aVetor,{"E1_XCONFSC"	,"N"												,Nil})
	endif

	if !empty(alltrim(cPedOri))
		AAdd(aVetor,{"E1_XPEDORI"	,cPedOri										,Nil})
	endif

	Begin Transaction

	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3)

	If  lMsErroAuto
		MostraErro()
		DisarmTransaction()
		RollBackSX8()
		lRet := .F.
		//aLogRotAut := GetAutoGrLog()
	Else
		ConfirmSX8()
		msgInfo("Titulo "+ cNumTitulo +" gerado com sucesso!!!","Komfort House")
	EndIf

	End Transaction

Return lRet

//----------------------------------------------------------------
/*/{Protheus.doc} atuSud()
Atualiza campo UD_XNUMTIT da tabela SUD apos a gravação do titulo de NCC
@author Alexis Duarte
@utilizacao Komfort House
@since 18/04/2018
/*/
//----------------------------------------------------------------
Static Function atuSud(aItens,cNumTitulo)

Local nPostitulo := gdFieldPos("UD_XNUMTIT",aHeader)	//Numero do Titulo
Local nPosStatus := gdFieldPos("UD_STATUS",aHeader)		//Status

default cNumTitulo := ""

for nx := 1 to len(aItens)
	for ny := 1 to len(aCols)
		if ny == aItens[nx][8]
			
			if !empty(cNumTitulo)
				aCols[ny][nPostitulo] := cNumTitulo
			endif
			
			aCols[ny][nPosStatus] := "2"

		endif
	next ny
next nx

Return


//-----------------------------------------------------------|
/*/{Protheus.doc} CancSubs()                                 |
Função responsavel pela ação de cancelar e substituir o PV   |
@author Alexis Duarte                                        |
@utilizacao Komfort House                                    |
@since 18/04/2018                                            |
/*///                                                        |
//-----------------------------------------------------------|
Static Function CancSubs(lRet)

	Local cUsrEx := SuperGetMV("KH_USREXPV",.T.,"000040")
	Local cNumPed := iif(INCLUI,right(M->UC_01PED,6),right(SUC->UC_01PED,6))
	Local aItens := {}
	Local cNrChamado := M->UC_CODIGO
	Local nValorTot := 0
	Local cHistorico := "TITULO GERADO PELO TIPO DE AÇÃO "
	Local cNumTitulo := ""
	Local cMotivo := ""
	Local cTipoAcao := ""
	Local lTeleVend := .F.

	//Informações do Cliente
	Local cCodCli := ""
	Local cCodLoja := ""

	//Posição dos campos no ACols
	Local nPosTpAcao := gdFieldPos("UD_01TIPO",aHeader) 	//Tipo Acao
	Local nPostitulo := gdFieldPos("UD_XNUMTIT",aHeader)	//Numero do Titulo
	Local nPosValPed := gdFieldPos("UD_01VLPED",aHeader)	// Valor Pedido
	Local nPosProdut := gdFieldPos("UD_PRODUTO",aHeader)	// Codigo do produto
	Local nPosStatus := gdFieldPos("UD_STATUS",aHeader)		//Status

	local cMsg := ""

	retCodLoja(cNumPed, @cCodCli, @cCodLoja)

	for nx := 1 to len(aCols)
		//Verifico se a linha esta deletada e se o Status esta em aberto
		if aCols[nx][len(aHeader)+1] == .F. .AND. aCols[nx][nPosStatus] == "1"
			//Verifico se a ação é do tipo (Cancela Substitui)
			if vldTpCS(aCols[nx][nPosTpAcao], @cTipoAcao) .and. empty(aCols[nx][nPostitulo])
				aAdd(aItens,{;
				0,;								//1 - Valor do Pedido
				cCodCli,; 			 			//2 - Cliente
				cCodLoja,;			  			//3 - Loja
				cMotivo,;			   			//4 - Não Utilizado, tabela X5 - O1
				cNrChamado,;					//5 - Numero do Atendimento
				cHistorico,;					//6 - Observações
				cTipoAcao,;						//7 - Tipo Acao NDC ou NCC
				nx})							//8 - Linha Posicionada
			endif
		endif
	next nx

	if empty(aItens)//Se não existir nenhuma ocorrencia de cancela/substitui
		Return(.T.)
	endif

	if !(__cUserID $ cUsrEx)
		msgAlert("Usuario "+ UsrRetName(__cUserID) +" Não tem permissão para lançar esse tipo de ação.",cAlert4)
		Return(lRet := .F.)
	endif

	dbSelectArea("SC5")
	SC5->(dbsetorder(1))
	SC5->(dbgotop())
	
	if SC5->(dbSeek(xFilial() + cNumPed))

		if !(empty(SC5->C5_NOTA)) .and. !(SC5->C5_NOTA $ 'X')
			msgAlert("Não é possivel realizar o cancelamento. O pedido ja encontra-se Faturado ou Cancelado.",cAlert4)
			Return(lRet := .F.)
		endif
	
		if SC5->C5_EMISSAO == dDatabase
			msgAlert("Para o cancelamento no mesmo dia, utilize a rotina (Exclusão de Pedidos).",cAlert4)
			Return(lRet := .F.)
		endif

		if !SC5->C5_XBLQCAN == 'L'
			if SC5->C5_XBLQCAN == 'R'
				cMsg := "Sua solicitação de cancela/Substitui foi recusada pela Diretoria." + ENTER
				cMsg += "Para seguir com o processo, entre em contato com o seu Supervisor."	
				
				msgAlert(cMsg,cAlert4)
					
				Return(lRet := .F.)				
			else
				if SC5->C5_EMISSAO + 5 < dDatabase
					
					M->UC_STATUS := '11'

					recLock("SC5",.F.)
						SC5->C5_XBLQCAN := 'B'
					SC5->(msunlock())
					
					cMsg := "Não é possivel Realizar o cancelamento do PV após 5 Dias." + ENTER
					cMsg += "Por favor, Aguarde a autorização da Diretoria." + ENTER  + ENTER

					cMsg += "Obs: Para salvar o chamado, remova o conteudo do campo (Tipo de Ação) e confirme novamente."
					
					msgAlert(cMsg,cAlert4)
					
					Return(lRet := .F.)	
				endif
			endif
		endif
	else
		msgAlert("O pedido informado não foi encontrado.",cAlert4)
		Return(lRet := .F.)
	endif
  

	if empty(alltrim(SC5->C5_NUMTMK))
		
		nValorTot := SC5->C5_FRETE + SC5->C5_DESPESA
		
		dbselectarea("SC6")
		SC6->(dbsetorder(1))
		SC6->(dbseek(xfilial("SC6")+SC5->C5_NUM))
		
		while SC6->C6_NUM == SC5->C5_NUM
			nValorTot += SC6->C6_VALOR
			SC6->(dbskip())
		end
	else
		dbselectarea("SUA")
		SUA->(dbsetorder(8))
		SUA->(dbseek(SC5->C5_MSFIL+SC5->C5_NUM))
		
		nValorTot := SUA->UA_VLRLIQ
		
		_cFil := SC5->C5_MSFIL
		_cPed := SC5->C5_NUM
		
		lTeleVend := .T.
	endif

	if !empty(aItens)
		if msgYesNo("Confirma o cancelamento do pedido " + cNumPed + " no valor de "+ transform(nValorTot,"@E 999,999.99") ,"Komfort House")
			if CancelSC6(cNumPed)//CancelaPed(cNumPed)
				lGerNCC := .T.
			else
				lGerNCC := .F.
			endif
		else
			Return (lRet := .F.)
		endif
	endif

	if lGerNCC
		
		cHistorico += cTipoAcao
		
		if CriaTit(@cNumTitulo,nValorTot,cCodCli,cCodLoja,cMotivo,cNrChamado,cHistorico,cTipoAcao,cNumPed)
			
			atuSud(aItens,cNumTitulo)
			
			if lTeleVend
				cancTLV(_cFil, _cPed)
			endif
			
			lRet := .T.
		else
			Return (lRet := .F.)
		endif
	else
		lRet := .F.
	endif

	//Envia email de cancelamento para o departamento de compras
	if lRet
		//fEmailCanc(cNumPed)
		U_KHCOM006(cNumPed)
	Else 
		cMsg := ("Não foi possivel realizar o cancelamento do PV, entre em contato com o Administrador!")
		msgAlert(cMsg,cAlert4)
	endif

Return


//----------------------------------------------------------------
/*/{Protheus.doc} vldTpCS()
Rotina responsavel pela validação do Tipo de Ação, Verifico se a ação é do tipo (Cancela Substitui)
@author Alexis Duarte
@utilizacao Komfort House
@since 17/04/2018
/*/
//----------------------------------------------------------------

Static Function vldTpCS(cCodAcao, cTipoAcao)

Local aArea := getArea()
Local lRet := .F.

dbSelectArea("Z01")
dbSetOrder(1)
Z01->(dbgotop())

if Z01->(dbSeek(xFilial("Z01") + cCodAcao))
	
	if Z01->Z01_TIPO == '7' .AND. Z01_COD <> 'CSBLOQ'
		cTipoAcao := "NCC"
		lRet := .T.
	endif
	
endif

Z01->(dbCloseArea())

restArea(aArea)

Return lRet


//----------------------------------------------------------------
/*/{Protheus.doc} CancelSC6()
Rotina responsavel pelo Estorno, liberação do item e Eliminar Resíduo do PV.
@author Alexis Duarte
@utilizacao Komfort House
@since 05/07/2018
/*/
//----------------------------------------------------------------

Static Function CancelSC6(cPedido)

local lCarga 	:= .F.
Local lNota  	:= .F.
Local lRet	 	:= .F.
Local lReserva	:= .F.
Local lCanCs 	:= .F.
Local aAreaSC5 := SC5->( getArea() )
Local aAreaSC6 := SC6->( getArea() )

dbSelectArea("SC5")
//Retorno de mostruario chamado: 14710 #Wellington Raul -> inicio
SC5->(dbSetOrder(12))
//Se encontrar o pedido ele é de origem tranferencia e deve ser tratado 
IF SC5->(dbSeek(xFilial("SC5") +cPedido))
	//Se não possuir nota 
	if empty(SC5->C5_NOTA)
		//Estorna pedido de venda antes de realizar a exclusão.
		If u_xEstPed(SC5->C5_NUM)
 			//Eliminação de residuo
			 Ma410Resid("SC5",SC5->(recno()),1)
			if SC5->(C5_NOTA $ "X")
				lCanCs := .T.
			EndIf
		EndIf
	ElseIf  ! SC5->(C5_NOTA $ 'X')
		//Faço a devolução dos produtos para o armazem origem para evitar duplicidade de saldo no 01 e saldo negativo lojas
		U_KHDEVCS(SC5->C5_NUM,SC5->C5_NOTA,SC5->C5_MSFIL)
	EndIf 
EndIf
//Retorno de mostruario chamado: 14710 #Wellington Raul -> Fim
dbSetOrder(1)
If SC5->(dbSeek(xFilial("SC5") + cPedido ))
	SC6->(dbGoTop())
	SC6->(dbSeek( xFilial("SC6") + cPedido ) )
	While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == SC5->C5_NUM
		
		If OmsHasCg(SC6->C6_NUM,SC6->C6_ITEM)
			lCarga := .T.
			Exit
		ElseIf !Empty(SC6->C6_NOTA)
			lNota := .T.
			Exit
		Endif

		SC6->(dbSkip())
	EndDo
	
	If !lCarga .AND. !lNota
		//Estorna pedido de venda antes de realizar a exclusão.
		If u_xEstPed(cPedido)
			
			//Eliminação de residuo
			 Ma410Resid("SC5",SC5->(recno()),1)
			 dbSetOrder(1)
			 If SC5->(dbSeek(xFilial("SC5") + cPedido ))
			 	SC5->(C5_NOTA $ "X")
				lRet := .T.
			EndIf
		EndIf
		
	EndIf
	
	If lCarga
		Conout("Não foi possível estornar o pedido N." + cPedido + ". Pedido em Carga.")
		lRet := .F.
		Return lRet
	ElseIf lNota
		Conout("Não foi possível estornar o pedido N." + cPedido + ". Pedido Faturado.")
		lRet := .F.
		Return lRet
	EndIf
EndIf

SC6->( restArea( aAreaSC6 ) )
SC5->( restArea( aAreaSC5 ) )

Return lRet


//----------------------------------------------------------------
/*/{Protheus.doc} cancTLV()
Rotina responsavel pelo Cancelamento do Tele-Vendas
@author Alexis Duarte
@utilizacao Komfort House
@since 05/07/2018
/*/
//----------------------------------------------------------------
Static Function cancTLV(_cFil, _cPed)

dbselectarea("SUA")
SUA->(dbsetorder(8))

if SUA->(dbseek(_cFil+_cPed))
	recLock("SUA",.F.)
	SUA->UA_CODCANC := upper(substr(FWUUIDV1(),1,6))
	SUA->UA_STATUS := "CAN"
	SUA->UA_NUMSC5 := ""
	msunlock()
endif

Return


Static Function fEmailCanc(cPedido)

Local cPara := "compras@komforthouse.com.br"
Local cAssunto := "Cancelamento do pedido "+ cPedido
Local cBody := ""

cBody += "Email enviado automaticamente, não responder este email."+ ENTER + ENTER
cBody += "Por favor verificar se existe pedidos de compras vinculados ao pedido de venda "+ cPedido +"."+ ENTER
cBody += "Caso haja necessidade, realizar o cancelamento do pedido de compras para não gerar compras desnecessárias."+ ENTER+ ENTER
cBody += "Att."+ ENTER
cBody += "Sistema Protheus"

processa( {|| U_sendMail( cPara, cAssunto, cBody ) }, "Aguarde...", "Enviando email de Cancelamento do pedido "+ cPedido +"...", .F.)

Return

//--------------------------------------------------------------
/*/{Protheus.doc} fSolucao
Description //Gatilho para o preenchimento do campo tipo de ação para ação de abertura do cancela/Substitui
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 31/05/2019 /*/
//--------------------------------------------------------------
User Function fSolucao()

	Local nPosAcao := gdFieldPos("UD_SOLUCAO",aHeader)	//Numero do Titulo	
	Local nPosTpAcao := gdFieldPos("UD_01TIPO",aHeader) 	//Tipo Acao
	Local nPosStatus := gdFieldPos("UD_STATUS",aHeader)		//Status

	if Len(acols) > 0 .and. aCols[n][nPosStatus] == "1"
		if aCols[n][nPosAcao] == '000145'
			aCols[n][nPosTpAcao] := 'CSBLOQ'

			if ExistTrigger('UD_01TIPO') //se existir gatilho no campo, disparo o gatilho
				runTrigger(1,Nil,Nil,,'UD_01TIPO')
			endif
		endif
	endif

Return .T.