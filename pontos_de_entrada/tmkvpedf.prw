#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(10)+CHR(13)

//--------------------------------------------------------------------------------|
//	Function - TMKVPEDF() -> // P.E. depois gravacao do SC5 e SC6 para verificar  | 
//  -----------------------> // o bloqueio financeiro do pedido de venda.		  |
//	Uso - Komfort House									   					  	  |
//  By Alexis Duarte - 18/06/2018  												  |
//--------------------------------------------------------------------------------|

User Function TMKVPEDF(cNumSC5,cFil,cClient,cNumTMK,nPerLib)

	Local aArea := getArea()
    
    if nPerLib > 0
		MsgRun("Aguarde, Verificando pendencias financeiras..." ,,{|| VldPendFi(cNumSC5,cFil,cClient,cNumTMK) })
	endif
	
	restArea(aArea)
		
Return .T.

//--------------------------------------------------------------------------------|
//	Function - VldPendFi() -> // Se o valor recebido for maior que a porcentagem  |
//  ------------------------> //do bloqueio, libera o pedido de venda              |
//	Uso - Komfort House									   					  	  |
//  By Alexis Duarte - 18/06/2018  												  |
//--------------------------------------------------------------------------------|
Static Function VldPendFi(cNumSC5,cFil,cClient,cNumTMK)

	Local cAlias := getNextAlias()
	Local nTotRec := 0
	Local nVlrMin := 0
	
	dbselectarea("SE1")
	SE1->(dbsetorder(30))
	
	if SE1->(dbSeek(xFilial()+cNumSC5))
		while SE1->E1_PEDIDO == cNumSC5 
			if !(SE1->E1_TIPO $ 'BOL|CHK|RA')
				nTotRec += SE1->E1_VALOR
			endif
		SE1->(dbskip())
		end
	endif
	
	dbselectarea("SUA")
	SUA->(dbsetorder(8))
	
	if SUA->(dbSeek(cFil+cNumSC5))
		nVlrMin := (UA_VLRLIQ/100)*UA_XPERLIB //Valor minimo para liberação
	endif

	dbselectarea("SC5")
	SC5->(dbsetorder(1))
	
	dbselectarea("SC6")
	SC6->(dbsetorder(1))

	if nTotRec >= nVlrMin //Libera o bloqueio do pedido de venda 
		
		if SC5->(dbseek(xFilial()+SUA->UA_NUMSC5))
			recLock("SC5",.F.)
				SC5->C5_PEDPEND := "3"
			msUnlock()
		endif
			
		if SC6->(dbseek(xFilial()+ SUA->UA_NUMSC5))
			while SC6->C6_MSFIL == cFil .and. SC6->C6_NUM == SUA->UA_NUMSC5
				recLock("SC6",.F.)
					SC6->C6_PEDPEND := "3"
				msUnlock()
			SC6->(dbskip())
			end
		endif

	else	
	
		if SC5->(dbseek(xFilial()+SUA->UA_NUMSC5))
			recLock("SC5",.F.)
				SC5->C5_PEDPEND := "2"
			msUnlock()
		endif
			
		if SC6->(dbseek(xFilial()+ SUA->UA_NUMSC5))
			while SC6->C6_MSFIL == cFil .and. SC6->C6_NUM == SUA->UA_NUMSC5
				recLock("SC6",.F.)
					SC6->C6_PEDPEND := "2"
				msUnlock()
			SC6->(dbskip())
			end
		endif

	endif

Return .T.