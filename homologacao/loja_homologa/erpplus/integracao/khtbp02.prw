#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.Ch'
#Include 'TbiConn.ch'



/*/{Protheus.doc} KHTBP02
//TODO:  Envia itens da tabela de preços para a Rakuten
@author ERPPLUS
@since 26/04/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function KHTBP02()

Local oTabela := Nil
Local cQuery := ""
Local nLoja		:= 0
Local cCodTab	:= ""
Local cNomeTab	:= ""
Local cVigAtual	:= ""
Local cVigFinal	:= ""
Local nStatus	:= 0
Local cA1		:= ""
Local cA2		:= ""
Local cTabela	:= ""

Default nOpc := 1

If len(aPrepEnv) > 0
	_lInJob := .T.
	RPCClearEnv()
	RPCSetType(3)
	RPCSetEnv(aPrepEnv[1,1], aPrepEnv[1,2])

	PREPARE ENVIRONMENT EMPRESA aPrepEnv[1,1] FILIAL aPrepEnv[1,2] TABLES "Z08" MODULO "FAT"
Endif	

cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))

oTabela := WSTabelaPrecokH():New()


cQuery := "SELECT * FROM "+RetSqlName("Z08") +" " + CRLF
cQuery += "WHERE Z08_FILIAL = '"+xFilial("Z08")+"' AND Z08_INTEGI = 'S' AND D_E_L_E_T_ = ' ' " 

MemoWrite("TZ08_ITEM.SQL",cQuery)

TcQuery cQuery New Alias "TZ08"

While TZ08->(!Eof())
	
	If cTabela != AllTrim(TZ08->Z08_CODTAB)
		cTabela := AllTrim(TZ08->Z08_CODTAB)
	Endif
	
	While TZ08->(!Eof()) .AND. Alltrim(TZ08->Z08_CODTAB) == cTabela 
	
		nLoja					:= 0
		cCodTab					:= AllTrim(TZ08->Z08_CODTAB)
		cNomeTab				:= POSICIONE("DA0",1 , xFilial("DA0")+cCodTab,"DA0_DESCRI")
		cCodProd				:= TZ08->Z08_PRODUT
		cVigAtual				:= U_ConvData(AllTrim(TZ08->Z08_DTVIGE)) 
		cVigFinal				:= U_ConvData(AllTrim(TZ08->Z08_DTVIGE)) 
		nStatus					:= Val(TZ08->Z08_STATUS) 
		nPrc					:= TZ08->Z08_PRECO
		nPrcPor					:= TZ08->Z08_PRECO
		
		if oTabela:SalvarItem(nLoja, AllTrim(TZ08->Z08_CODTAB), AllTrim(cCodProd),,nPrc,nPrcPor,nStatus,cA1,cA2)
			Conout("Item Incluso/Alterado com sucesso")
			If oTabela:oWSSalvarItemResult:nCodigo == 1			
				Z08->(DbSetOrder(1))
				If Z08->(DbSeek(xFilial("Z08") + cCodTab + cCodProd + TZ08->Z08_ITEM))
					
					Z08->(RecLock("Z08"), .F. )
					
					Z08->Z08_DTINTE := dDataBase
					Z08->Z08_HRINTE := Time()
					Z08->Z08_INTEGI := "N"
					
					Z08->(MsUnLock())
					
				EndIf
			Else

				U_KHLOGWS("Z08",dDataBase,Time(),"[SalvarItem]- "+oTabela:oWSSalvarItemResult:cDescricao+" - KHINTPV","PROTHEUS")

				Conout("Erro na Integração "+ CRLF + ;
					oTabela:oWSSalvarItemResult:cDescricao)						
			EndIf
		Else
			U_KHLOGWS("Z08",dDataBase,Time(),"[SalvarItem]- Erro ao consumir WebService, favor vericiar dados informados - KHINTPV","PROTHEUS")
		EndIf
		
		TZ08->(DbSkip())
	EndDo
Enddo

return


User Function KHJB0007(_cEmp,_cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"

	U_KHTBP02()
	RESET ENVIRONMENT
Return
