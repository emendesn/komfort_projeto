#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include 'TbiConn.ch'


/*/{Protheus.doc} KHESTRAK
//TODO: Envia saldo dos Kits para o E-Commerce..
@author ERPPLUS
@since 29/04/2019
@version 1.0
@return Nil
 
@type function
/*/
USER FUNCTION KHESTRAK()
	
	PROCEST()
	/*Else
		PROCESSA({|| PROCEST()} , "Envia Estoque e-Commerce" , "Processando")
	Endif*/
RETURN

STATIC FUNCTION PROCEST()
	Local nCont 	:= 0
	Local cQuery 	:= ""
    Local cAlmEst	:= ALLTRIM(GETNEWPAR("MV_XALMRAK","15"))
    Local nSaldo	:= 0
    Local cAlmRak	:= ALLTRIM(GETNEWPAR("MV_XAMDRAK","15"))
	Local cMsg 		:= ""
	
	DbSelectArea("Z07")
	Z07->(dbSetOrder(1))
	
	cQuery += CRLF + "SELECT  "
	//cQuery += CRLF + "	[PRODUTO]   = ZKC_SKU,  "
	cQuery += CRLF + "	[PRODUTO]   = ZKC_CODPAI,  "
	cQuery += CRLF + "	[B2_SALDO]  = MIN(B2_SALDO),  "
	cQuery += CRLF + "	B1_ESTSEG 	"
	cQuery += CRLF + "	FROM (	 "
	cQuery += CRLF + "	SELECT  "
	//cQuery += CRLF + "		ZKC_SKU, "
	cQuery += CRLF + "		ZKC_CODPAI, "
	cQuery += CRLF + "		B1_ESTSEG,  "
	cQuery += CRLF + "		CASE   "
	cQuery += CRLF + "			WHEN SUM(B2_QATU -B2_QEMP - B2_RESERVA) < 0 THEN 0  "
	cQuery += CRLF + "			ELSE SUM(B2_QATU -B2_QEMP - B2_RESERVA)  "
	cQuery += CRLF + "		END AS B2_SALDO  "
	cQuery += CRLF + "	FROM "+RetSqlName("SB2")+" SB2    "
	cQuery += CRLF + "		INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' 	"
	cQuery += CRLF + "			AND B1_COD = B2_COD AND SB1.D_E_L_E_T_ = ' '  "
	cQuery += CRLF + "		INNER JOIN "+RetSqlName("ZKD")+" ZKD ON ZKD_FILIAL = '"+xFilial("ZKD")+"'   "
	cQuery += CRLF + "			AND ZKD_CODFIL = B1_COD AND ZKD.D_E_L_E_T_ = ' '  "
	cQuery += CRLF + "		INNER JOIN "+RetSqlName("ZKC")+" ZKC ON ZKC_FILIAL = '"+xFilial("ZKC")+"'  "
	cQuery += CRLF + "			AND ZKC_CODPAI = ZKD_CODPAI AND ZKC.D_E_L_E_T_ = ' '  "
	cQuery += CRLF + "	WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL IN "+ FORMATIN( cAlmEst ,";") + " AND SB2.D_E_L_E_T_ = ' '   "
	//cQuery += CRLF + "	GROUP BY ZKC_SKU,B1_COD,B1_ESTSEG  "
	cQuery += CRLF + "	GROUP BY ZKC_CODPAI,B1_COD,B1_ESTSEG  "
	cQuery += CRLF + "	) SALDOS  "
	//cQuery += CRLF + "GROUP BY ZKC_SKU,B1_ESTSEG "
	cQuery += CRLF + "GROUP BY ZKC_CODPAI,B1_ESTSEG "	       
	
	
	If Select("TSB2") > 0
		TSB2->(DbCloseArea())
	Endif
	
	TcQuery cQuery Alias TSB2 New
	
	MemoWrite("TSB2.SQL",cQuery)
	
	TSB2->(dbGoTop())
	While !TSB2->(EOF())
		nCont++
		TSB2->(dbSkip())	
	Enddo
	
	ProcRegua(nCont)

	TSB2->(dbGoTop())	
	While !TSB2->(EOF())
		IncProc("Produto: "+ TSB2->PRODUTO)
		nSaldo := TSB2->B2_SALDO - TSB2->B1_ESTSEG
		
		If nSaldo < 0
			nSaldo := 0
		Endif

		//Busca o produto na tabela intermediária
		cQuery := "SELECT R_E_C_N_O_ Z07_RECNO" + CRLF
		cQuery += "FROM "+RetSqlName("Z07")+" " + CRLF
		cQuery += "WHERE Z07_PRODUT = '"+TSB2->PRODUTO+"'  " + CRLF
		cQuery += "AND Z07_LOCAL IN "+ FORMATIN( cAlmEst ,";") + " AND D_E_L_E_T_ = ' ' "
		
		If Select("TZ07") > 0
			TZ07->(DbCloseArea())
		Endif
		
		TcQuery cQuery Alias TZ07 New		
		
		//If !Z07->(dbSeek(xFILIAL("Z07")+TSB2->PRODUTO+cAlmRak))
		If TZ07->(Eof())
			
			Z07->(RecLock("Z07",.T.))
			Z07->Z07_FILIAL := "0142"//Z07->(xFILIAL("Z07"))
			Z07->Z07_LOCAL	:= cAlmRak
			Z07->Z07_PRODUT	:= TSB2->PRODUTO
			Z07->Z07_STATUS	:= "1"
			Z07->Z07_DTINC	:= Date()
			Z07->Z07_HRINC	:= Time()
			Z07->Z07_INTEG	:= 'S'
			Z07->Z07_QUANT  := nSaldo
			Z07->Z07_ESTSEG := TSB2->B1_ESTSEG
			Z07->(MsUnLock())	
		Else
			//Atualiza somente se o saldo da Z07 estiver diferente da SB2
			
			Z07->(DbGoTo(TZ07->Z07_RECNO))
			IF nSaldo != Z07->Z07_QUANT		
				Z07->(RecLock("Z07",.F.))				
				Z07->Z07_FILIAL := "0142"//Z07->(xFILIAL("Z07"))
				Z07->Z07_LOCAL	:= cAlmRak
				Z07->Z07_STATUS	:= "1"
				Z07->Z07_DTINC	:= Date()
				Z07->Z07_HRINC	:= Time()
				Z07->Z07_INTEG	:= 'S'
				Z07->Z07_QUANT  := nSaldo
				Z07->Z07_ESTSEG := TSB2->B1_ESTSEG
				Z07->(MsUnLock())
			Endif					
		Endif
		
		TSB2->(dbSkip())	
	Enddo
	
	TSB2->(DbCloseArea())
	
RETURN

User Function KHESTLOAD(aEmp)

	Local aEmp := {"01","0101"}


	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2]    

	U_KHESTRAK()

	RESET ENVIRONMENT
Return 
