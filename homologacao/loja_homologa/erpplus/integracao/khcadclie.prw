#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'
#Include 'TbiConn.ch'


//--------------------------------------------------------------
/*/{Protheus.doc} KHCADCLIE
Description //Cadastra clientes do e-commerce
@param xParam Parameter Description
@return xRet Return Description
@author  - Rafael S.Silva
@since: 01-08-2019 /*/
//--------------------------------------------------------------
User function KHCADCLIE()

	Local aDados	:= {}
	Local cQuery	:= ""
	Local cMun		:= ""
	Private cCod_mun	:= ""
	
	cQuery += CRLF + "SELECT R_E_C_N_O_ RECNO,* FROM "+RetSqlName("Z11")+" (NOLOCK)  "
	cQuery += CRLF + "	WHERE Z11_FILIAL = '"+xFilial("Z11")+"' "
	cQuery += CRLF + "	AND Z11_CADCLI = 'S' AND D_E_L_E_T_ = ' ' "
	
	MemoWrite("Z11_CADCLI.SQL",cQuery)
	
	If Select("TZ11") > 0
		TZ11->(DbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "TZ11"
	
	TZ11->(DbGoTop())
	
	While .Not. (TZ11->(Eof()))
		
		
		
		cNomeCli	:= AllTrim(TZ11->Z11_NOME) + " " + AllTrim(TZ11->Z11_SNOME)
		
		aAdd(aDados,{"A1_COD",GetSxeNum("SA1","A1_COD"),Nil})
		aAdd(aDados,{"A1_LOJA","01",Nil})
		aAdd(aDados,{"A1_NOME",cNomeCli,Nil})
		aAdd(aDados,{"A1_END",TZ11->Z11_END ,Nil})
		If TZ11->Z11_PESSO == "J" 
			aAdd(aDados,{"A1_NREDUZ",AllTrim(TZ11->Z11_SNOME),Nil})
		Else
			aAdd(aDados,{"A1_NREDUZ",AllTrim(TZ11->Z11_SNOME),Nil})
		Endif
		
		aAdd(aDados,{"A1_PESSOA",TZ11->Z11_PESSO,Nil})
		aAdd(aDados,{"A1_BAIRRO",AllTrim(TZ11->Z11_BAIRRO),Nil})
		aAdd(aDados,{"A1_TIPO","F",Nil})
		aAdd(aDados,{"A1_EST",AllTrim(TZ11->Z11_EST),Nil})
		//aAdd(aDados,{"A1_ESTADO",AllTrim(TZ11->Z11_ESTADO),Nil})
		aAdd(aDados,{"A1_CEP",TZ11->Z11_CEP,Nil})
		
		cCod_mun := POSICIONE("CC2",4,xFilial("CC2") + AllTrim(TZ11->Z11_EST) + Upper(AllTrim(TZ11->Z11_ESTADO) ),"CC2_CODMUN")  
		cMun	 := POSICIONE("CC2",4,xFilial("CC2") + AllTrim(TZ11->Z11_EST) + Upper(AllTrim(TZ11->Z11_ESTADO) ),"CC2_MUN")   
		
		//cCod_mun := POSICIONE("CC2",3,xFilial("CC2") + cCod_mun ,"CC2_CODMUN")
		//cMun	 := POSICIONE("CC2",3,xFilial("CC2") + cCod_mun ,"CC2_MUN")
		
		aAdd(aDados,{"A1_COD_MUN",cCod_mun,Nil})
		aAdd(aDados,{"A1_MUN",cMun,Nil})
		
		//aAdd(aDados,{"A1_NATUREZ",TZ11->Z11_NATUERZ,Nil})
		aAdd(aDados,{"A1_CGC",TZ11->Z11_CGC,Nil})
		aAdd(aDados,{"A1_TEL",StrTran(TZ11->Z11_TELEF1,'-',''),Nil})
		aAdd(aDados,{"A1_TEL2",StrTran(TZ11->Z11_TELCEL,'-',''),Nil})
		aAdd(aDados,{"A1_INSCR",IIF(Empty(TZ11->Z11_INSCE),"ISENTO",AllTrim(TZ11->Z11_INSCE)),Nil})
		aAdd(aDados,{"A1_RG",TZ11->Z11_RG,Nil})
		aAdd(aDados,{"A1_BAIRROC",AllTrim(TZ11->Z11_BAIRRO),Nil})
		aAdd(aDados,{"A1_CEPC",TZ11->Z11_CEPC,Nil})
		//aAdd(aDados,{"A1_MUNC",TZ11->Z11_MUNC,Nil})
		aAdd(aDados,{"A1_BAIRROE",LEFT(TZ11->Z11_BAIRE,TamSX3("A1_BAIRROE")[1] ),Nil})
		aAdd(aDados,{"A1_CEPE",TZ11->Z11_CEPE,Nil})
		aAdd(aDados,{"A1_MUNE",LEFT(TZ11->Z11_MUN,TamSX3("A1_MUNE")[1]),Nil})
		aAdd(aDados,{"A1_EMAIL",TZ11->Z11_EMAIL,Nil})
		aAdd(aDados,{"A1_DDD",TZ11->Z11_DDD1,NIL})
		aAdd(aDados,{"A1_DTNASC",STOD(TZ11->Z11_DTNASC),NIL})
		
		//Marca Flag como cadastrado somente se ExecAuto for executado com sucesso.
		If CADCLISA1(aDados) //Realiza cadastro do cliente
			Z11->(DbGoTo(TZ11->RECNO))
			RecLock("Z11",.F.)
			Z11->Z11_DTINC := dDataBase
			Z11->Z11_HRINC := Time()
			Z11->Z11_CADCLI := "N" //CADASTRAR CLIENTE ?
			Z11->(MsUnlock())					
		EndIf
		
		aDados := {}
		
		TZ11->(DbSkip())
	EndDo
RESET ENVIRONMENT
Return


Static Function CADCLISA1(aCliente)
	
	Local xRet		:= .T.
	Local nOpc      := 0
	Local nPosCgc   := 0
	Local cCodCli   := ""
	Local cLojaCli  := ""
	local nPosCod   := 0
	Local nPosLoja  := 0

	DbSelectArea('SA1')
	SA1->(DbSetOrder(3))//A1_CGC

	//Localiza Cpf/Cnpj no cliente para evitar erro no ExecAuto
	nPosCgc := aScan(aCliente,{|x| AllTrim(x[1]) == "A1_CGC" })
	nPosLoja := aScan(aCliente,{|x| AllTrim(x[1]) == "A1_LOJA" })
	nPosCod := aScan(aCliente,{|x| AllTrim(x[1]) == "A1_COD" })

	lMsErroAuto := .F.
	
	Begin Transaction
	
		//Defino inicialmente como cadastro novo -- opção 3
		nOpc := 3

		//Se encontrar CPF/CNPJ verifica Existência
		if nPosCgc > 0

			//Se existir cliente a opção será Alteraçao
			If SA1->( DbSeek(xFilial("SA1") + Padr(aCliente[nPosCgc][2],TamSx3("A1_CGC")[1]) ) )
				nOpc := 4
				
				//Gravo código e loja do cliente
				cCodCli  := SA1->A1_COD
				cLojaCli := SA1->A1_LOJA

				//Substituo o código do cliente existente no Array para o código encontrado
				aCliente[nPosCod] := Nil
				aCliente[nPosCod] := {"A1_COD",cCodCli,Nil}

			Endif
			
			MSExecAuto({|x,y| MATA030(x,y)},aCliente,nOpc)
		
			If !lMsErroAuto
				ConfirmSx8()
			Else
				xRet := .F.
				cErro := "MATA030_JOB_D"+StrTran(cValToChar(dDataBase),'/','')+'H_'+StrTran(Time(),':','-')+'.LOG'
				MostraErro("\SYSTEM\EXECAUTO",cErro)
				cErro := MemoRead("\SYSTEM\EXECAUTO"+cErro)
				
				U_KHLOGWS("SA1",dDataBase,Time(),cErro + " KHCADCLIE","PROTHEUS")
				RollBackSx8()
			EndIf

		Else
			xRet := .F.
			U_KHLOGWS("SA1",dDataBase,Time(),"CAMPO CNPJ/CPF NÃO INFORMADO -  KHCADCLIE","PROTHEUS")
		Endif

		

	End Transaction

	SA1->(DbCloseArea())
Return xRet

User Function KHJB002(aEmp)

	Local aEmp := {"01","0142"}

	PREPARE ENVIRONMENT EMPRESA aEmp[1] FILIAL aEmp[2] 
	U_KHCADCLIE()

	RESET ENVIRONMENT
Return 

