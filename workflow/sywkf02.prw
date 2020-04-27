#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "SYVA003.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSYWKF02   บAutor  ณSYMM Consultoria    บ Data ณ  15/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a atualizacao de preco.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SYWKF02(cEmpTrab, cFilTrab, cIntervalo , cHorario )

Local nStep
Local nCount

Private cDirImp	:= "\DEBUG\"
Private cARQLOG	:= cDirImp+"SYWKF02_"+cEmpTrab+"_"+cFilTrab+".LOG"
Private cHoras	:= ""

DEFAULT cIntervalo := "60000" // 60000 milisegundos = 1 minuto
DEFAULT cHorario   := "15:05"

nIntervalo := Val(cIntervalo)
cHoras	   := Left(cHorario,5)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Comando para nao comer licensas. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RpcSetType(3)     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa ambiente. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PREPARE ENVIRONMENT EMPRESA cEmpTrab FILIAL cFilTrab

MakeDir(cDirImp) // Cria diretorio de DEBUG caso nao exista

While !KillApp()
    If Left(Time(),5)==cHoras

		CONOUT("")
		CONOUT(Replicate('-',80))
		CONOUT("INICIADO A RELACAO DE PEDIDOS PENDENTES: SYWKF02() - DATA/HORA: "+DToC(Date())+" AS "+Time())
		
		LjWriteLog( cARQLOG, Replicate('-',80) )
		LjWriteLog( cARQLOG, "INICIADO A RELACAO DE PEDIDOS PENDENTES: SYWKF02() - DATA/HORA: "+DToC(Date())+" AS "+Time() )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Chamada da rotina de processamento. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		WKF02PROC(,.T.)	
		
		CONOUT("FINALIZADO A RELACAO DE PEDIDOS PENDENTES: SYWKF02() - DATA/HORA: "+DToC(Date())+" AS "+Time())
		CONOUT(Replicate('-',80)) 
		CONOUT("")       
		
		LjWriteLog( cARQLOG, "FINALIZADO A RELACAO DE PEDIDOS PENDENTES: SYWKF02() - DATA/HORA: "+DToC(Date())+" AS "+Time() )
		LjWriteLog( cARQLOG, Replicate('-',80) )

	Endif	
	
	nStep  := 1
	nCount := nIntervalo/1000
	While !KillApp() .AND. nStep <= nCount
		Sleep(1000) //Sleep de 1 segundo
		nStep++
	EndDo
EndDo
 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza ambiente. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RESET ENVIRONMENT   

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ WKF02PROC    บ Autor ณ TOTVS			 บ Data ณ  07/10/11    บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara os dados para que seja gerado a relacao dos pedidos บฑฑ
ฑฑบ          ณ pendentes.                                                  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WKF02PROC(cLote,lWorkflow)

Local aAreaAtu 	:= GetArea()
Local cQuery	:= ""
Local cAlias	:= CriaTrab(,.F.)
Local lRetorno	:= .F.
Local nReg		:= 0                            


Private aPedidos:= {}

DEFAULT cLote 	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrego todos os pedidos que passaram sete dias da emissao e |
//ณencontam-se pendentes.                                       |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "	SELECT "+ CRLF
cQuery += "			UA_NUM AS PEDIDO, "+ CRLF
cQuery += "			UA_CLIENTE AS CLIENTE, "+ CRLF
cQuery += "			UA_LOJA AS LOJA, "+ CRLF
cQuery += "			UA_CODCONT AS CONTATO, "+ CRLF
cQuery += "			ISNULL(U5_DDD,'') AS DDD, "+ CRLF
cQuery += "			ISNULL(U5_FONE,'') AS TEL, "+ CRLF
cQuery += "			UA_VALBRUT AS VALOR_TOTAL, "+ CRLF
cQuery += "			UA_CODOBS AS OBS, "+ CRLF
cQuery += "			MAX(UA_EMISSAO) AS EMISSAO, "+ CRLF
cQuery += "			DATEDIFF(DAY,CONVERT(DATE,SUBSTRING(MAX(UA_EMISSAO),1,4)+'-'+SUBSTRING(MAX(UA_EMISSAO),5,2)+'-'+SUBSTRING(MAX(UA_EMISSAO),7,2)),CONVERT(DATE,'"+SUBSTR(dTOS(dDatabase),1,4)+"-"+SUBSTR(Dtos(dDatabase),5,2)+"-"+SUBSTR(Dtos(dDatabase),7,2)+"')) AS DIAS "+ CRLF

cQuery += " FROM "+RetSqlName("SUA")+" SUA (NOLOCK) "+ CRLF
	
cQuery += "	LEFT JOIN "+RetSqlName("SU5")+" SU5 (NOLOCK) "+ CRLF
cQuery += "	ON U5_CODCONT=UA_CODCONT AND SU5.D_E_L_E_T_ = ' ' "+ CRLF

cQuery += "	WHERE "+ CRLF
cQuery += "			UA_FILIAL 	= '"+xFilial("SUA")+"' "+ CRLF
cQuery += "		AND UA_CANC   	= ' ' "+ CRLF
cQuery += "		AND UA_EMISNF 	= ' ' "+ CRLF
cQuery += "		AND UA_PEDPEND 	= '2' "+ CRLF

cQuery += "   	AND SUA.D_E_L_E_T_ <> '*' "+ CRLF
   		
cQuery += "	GROUP BY "+ CRLF
cQuery += "			UA_NUM,UA_CLIENTE,UA_LOJA,UA_CODCONT,U5_DDD,U5_FONE,UA_VALBRUT,UA_CODOBS "+ CRLF

cQuery += "	HAVING "+ CRLF
cQuery += "		DATEDIFF(DAY,CONVERT(DATE,SUBSTRING(MAX(UA_EMISSAO),1,4)+'-'+SUBSTRING(MAX(UA_EMISSAO),5,2)+'-'+SUBSTRING(MAX(UA_EMISSAO),7,2)),CONVERT(DATE,'"+SUBSTR(Dtos(dDatabase),1,4)+"-"+SUBSTR(Dtos(dDatabase),5,2)+"-"+SUBSTR(Dtos(dDatabase),7,2)+"')) > 7 "+ CRLF
		
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva query em disco para debug. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If GetNewPar("SY_DEBUG", .T.)
	MakeDir(cDirImp)
	MemoWrite(cDirImp+"SYWKF02.SQL", cQuery)
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,"EMISSAO","D",8,0)

COUNT TO nReg

CONOUT(cValToChar(nReg) + " REGISTRO(S) ATUALIZADO(S) PELA ROTINA")
LjWriteLog( cARQLOG, cValToChar(nReg) + " REGISTRO(S) ATUALIZADO(S) PELA ROTINA" )

(cAlias)->(DbGoTop())
While (cAlias)->(!EOF())
	AAdd( aPedidos , { (cAlias)->PEDIDO , (cAlias)->CLIENTE , (cAlias)->LOJA , (cAlias)->CONTATO , (cAlias)->DDD , (cAlias)->TEL , (cAlias)->VALOR_TOTAL , (cAlias)->EMISSAO , MSMM((cAlias)->OBS,100 )  } )	
	(cAlias)->(DbSkip())
EndDo
                  
If Len(aPedidos) > 0
	CONOUT("INICIADO A GERACAO DO WORKFLOW GeraWKF02()")
	GeraWKF02(aPedidos)
	CONOUT("FINALIZADO A GERACAO DO WORKFLOW GeraWKF02()")
Endif

RestArea(aAreaAtu)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraWKF02 บAutor ณ Symm Consultoria   บ Data ณ  19/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia WKF com a relacao dos pedidos pendentes.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraWKF02(aPedidos)

Local oProcess
Local oHTML
Local cTime	   := Time()
Local cHora	   := Substr(cTime,1,2) + Substr(cTime,4,2) + Substr(cTime,7,2)
Local cTo      := ""
Local nVlrTot  := 0
Local nX	   := 0
Local cPath	   := GetMV("MV_CSREPOR",,"workflow\report\")
Local cReport  := cEmpAnt + "-" + DTOS(ddatabase) + "-" + cHora + "-pedidos_pendentes.htm"

oProcess:= TWFProcess():New( "000001", "Notificacao - Envia da relacao dos pedidos pendentes no financeiro." )
oProcess:NewTask( "Envio da relacao dos pedidos pendentes", "\workflow\pedidos_pendentes.htm" )
oProcess:cSubject := "Envio da relacao dos pedidos pendentes"
oProcess:cTo := "eduardopatriani@uol.com.br"
oProcess:NewVersion(.T.)

oHtml := oProcess:oHTML

oHtml:ValByName( "data" , Dtoc(dDatabase) )

For nX := 1 To Len(aPedidos)

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + aPedidos[nX,2] + aPedidos[nX,3] ))
	
	SU5->(DbSetOrder(1))
	SU5->(DbSeek(xFilial("SU5") + aPedidos[nX,4] ))
		
	AAdd( (oHtml:ValByName( "it.numero" 	)), aPedidos[nX,1] 	)	
	AAdd( (oHtml:ValByName( "it.cliente" 	)), SA1->A1_COD+'-'+SA1->A1_LOJA+" "+Alltrim(SA1->A1_NOME) )
	AAdd( (oHtml:ValByName( "it.contato" 	)), SU5->U5_CONTAT 	)
	AAdd( (oHtml:ValByName( "it.ddd" 	 	)), aPedidos[nX,5] 	)
	AAdd( (oHtml:ValByName( "it.tel" 		)), aPedidos[nX,6] 	)
	AAdd( (oHtml:ValByName( "it.data" 		)), Dtoc(aPedidos[nX,8])	)
	AAdd( (oHtml:ValByName( "it.valor" 		)), Transform(aPedidos[nX,7],'@E 999,999.99') )
	AAdd( (oHtml:ValByName( "it.obs" 		)), aPedidos[nX,9] 	)
	
	nVlrTot += aPedidos[nX,7]	
Next 

oHtml:ValByName( "total" ,TRANSFORM( nVlrTot , '@E 999,999.99' ) )

oProcess:ClientName( Subs(cUsuario,7,15) )

oHTML:SaveFile(cPath+cReport)

oProcess:Start()  
oProcess:Finish()
                   
Return

User Function VAWKF02Debug()
Return U_SYWKF02("99","01","60000")