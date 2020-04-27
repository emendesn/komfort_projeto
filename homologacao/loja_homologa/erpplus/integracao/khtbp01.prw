#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'
#Include 'TbiConn.ch'


#DEFINE CRLF Chr(13) + Chr(10) 



/*/{Protheus.doc} KHTABPRC
//TODO :Envia tabelas de preços para a Rakuten
@author Rafael S.Silva
@since 26/04/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function KHTABPRC()

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


cA1		:= ALLTRIM(GETNEWPAR("KH_A1KEYWS","D39243EF-5943-4378-A3EB-AA3D58865678"))
cA2		:= ALLTRIM(GETNEWPAR("KH_A2KEYWS","39132A70-1622-43D5-AABD-B504DC924D26"))

oTabela := WSTabelaPrecokH():New()


cQuery := "SELECT * FROM "+RetSqlName("Z08") +" " + CRLF
cQuery += "WHERE D_E_L_E_T_ = ' ' AND Z08_INTEGI = 'S' " 

MemoWrite("TZ08.SQL",cQuery)


TcQuery cQuery New Alias "TZ08"

Do While !( TZ08->( Eof() ) )
	
	
	nLoja					:= 0
	cCodTab					:= AllTrim(TZ08->Z08_CODTAB)
	cNomeTab				:= POSICIONE("DA0",1 , xFilial("DA0")+cCodTab,"DA0_DESCRI")
	cVigAtual				:= U_ConvData(AllTrim(TZ08->Z08_DTVIGE)) 
	cVigFinal				:= U_ConvData(AllTrim(TZ08->Z08_DTVIGE)) 
	nStatus					:= Val(TZ08->Z08_STATUS) 
	
	If oTabela:Salvar(nLoja,cCodTab,cNomeTab,cVigAtual,cVigFinal,nStatus,cA1,cA2)
		Conout("Tabela de preço Criada/Alterada com sucesso.")
		If oTabela:oWSSalvarResult:nCodigo == 1
			Z08->(DbSetOrder(2))
			If Z08->(DbSeek(xFilial("Z08") + cCodTab ))
				
				Z08->(RecLock("Z08"), .F. )
				
				Z08->Z08_DTINTE := dDataBase
				Z08->Z08_HRINTE := Time()
				Z08->Z08_INTEGI  := "N"
				
				Z08->(MsUnLock())
				
			EndIf
		Else
			U_KHLOGWS("Z08",dDataBase,Time(),"[Salvar]- "+ oTabela:oWSSalvarResult:cDescricao +" - KHINTPV","PROTHEUS")
			Conout("Erro na Integração "+ CRLF + ;
					oTabela:oWSSalvarResult:cDescricao)			
		Endif
	Else
		U_KHLOGWS("Z08",dDataBase,Time(),"[Salvar]- Erro ao consumir WebService, favor vericiar dados informados - KHINTPV","PROTHEUS")
	EndIf
	
	TZ08->(DbSkip())
	
EndDo


RESET ENVIRONMENT
return

User Function KHJB0006(_cEmp, _cFil)

	Default _cEmp := "01"
	Default _cFil := "0142"


	RPCClearEnv()
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES "Z06,SB1,SB2,ZKC,ZKD,ZKG,Z07,Z08,Z11,Z12" MODULO "EST"
	U_KHTABPRC()
	RESET ENVIRONMENT
Return
