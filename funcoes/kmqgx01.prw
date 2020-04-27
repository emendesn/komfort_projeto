#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'


/*/{Protheus.doc}KMQGX01
	Interface de execução de expressões SQL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
User Function KMQGX01(cQry)

	private oDlg,oTMultiget, oTGet, oTButton
	private cQuery , cTGet

	cTGet := Space(50)
	cQuery := cQry

	DEFINE DIALOG oDlg TITLE "SGBD" FROM 180,180 TO 550,700 PIXEL

	oTGet := TGet():New( 01,01,{|u| if(PCount()>0,cTGet:=u,cTGet)},oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet ,,,, )
	oTMultiget := TMultiget():Create(oDlg,{|u|if(Pcount()>0,cQuery:=u,cQuery)},20,01,200 , 92 ,,,,,,.T.)
	oTButton := TButton():Create( oDlg,130,001,"Executar",{|| U_KMQGX01A( cQuery , cTGet )  }, 40,10,,,,.T.,,,,,,)

	oTMultiget:EnableVScroll( .T. )
	oTMultiget:EnableHScroll( .T. )

	ACTIVATE DIALOG oDlg CENTERED

return


/*/{Protheus.doc}KMQGX01A
	Rotina de Processamento

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
user function KMQGX01A( cQuery , cRel , cPerg , cAlias , aCab2 )

	local aArea := getArea()
	local cCRLF :=  CHR(10) //CHR(13) +  COMPATIBILIDADE COM A VERSAO 10G DO ORACLE
	Local cError  := ""
	local aAreaSX3,aAreaSW0
	local cAux
	local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

	private nError

	if cPerg <> nil
		Pergunte(cPerg,.f.)

		if !Pergunte(cPerg,.t.)
			Return
		endif
	endif

	if Type("aCab") = "A"
		aCab2 := aCab
	endif

	dbSelectArea("SX3")
	aAreaSX3 := SX3->(getArea())
	dbSelectArea("SW0")
	aAreaSW0 := SW0->(getArea())

	cAux := strTran(cQuery,cCRLF,"")
	cAux := strTran(cAux," ","")
	cAux := strTran(cAux,'"',"")
	cAux := alltrim(cAux)
	cAux := substr(cAux,1,6)
	cAux := upper(cAux)

	cQuery := macro(cQuery)

	if cAux == 'SELECT'

		Processa({ || expExcel(@cQuery,@cRel,@cAlias,@aCab2)},OemToAnsi('Gerando o relatorio.'),	OemToAnsi('Aguarde...'))

	else

		nError := 0

		LJMsgRun("Executando...","Aguarde...",{||nError := TCSQLExec(cQuery)})

		If (nError < 0)
			MsgStop(TCSQLError())
		else
			MsgInfo("OK!")
		EndIf

	endif

	ErrorBlock(oLastError)

	if !empty(cError)
		alert(cError)
	endif

	restArea(aAreaSW0)
	restArea(aAreaSX3)
	restArea(aArea)

return


/*/{Protheus.doc}expExcel
	Exporta SELECT para excel

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
static function expExcel(cQuery, cNomeRel, cAlias, aCab2)
	local nTotal

	if cAlias = nil
		cAlias := getNextAlias()
	   //TCQuery cQuery NEW ALIAS (cAlias)
		LJMsgRun("Executando...","Aguarde...",{||ExecQuery(cQuery,cAlias)})
		//LJMsgRun("Executando...","Aguarde...",{||PlsQuery(cQuery,cAlias)})
	endif

	dbselectarea(cAlias)
	Count to nTotal
	(cAlias)->(DbGoTop())
	procregua(nTotal)

	if (nTotal > 0)
		geraArquivo(cAlias, @nTotal, @cNomeRel, @aCab2)
	endif

	(cAlias)->(dbCloseArea())

return


/*/{Protheus.doc}geraArquivo
	Controle de Gerenção do Arquivo em Excel

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
static function geraArquivo(cAliQuer, nTotal, cNomeRel, aCab2)
	local aTabela
	local aStruct
	local nCol

//inicializa variaveis
	DBSelectArea(cAliQuer)
	aStruct := DbStruct()

	nCol := Len(aStruct)

	nPartes := nTotal / 60000;

		if(nPartes%1>0.0)
	nPartes+=1
end

nPartes := int(nPartes)

aCab    := Array(nCol  , 1)

for nCol := 1 to Len(aStruct)
	aCab[nCol] := getTitulo(aStruct[nCol, 1])
next

if nPartes > 1

	for nx := 1 to nPartes
		if nx = nPartes
			nQuant := nTotal-((nPartes-1)*60000)
		else
			nQuant := 60000
		endif

		aTabela := Array(nQuant, nCol)
		montaTabela(@cAliQuer, @aTabela, @aStruct, 1)
		procregua(0)
		cNome := 'Parte '+cValToChar(nx)+' - '+cNomeRel

		if alltrim(valtype(aCab2))= "A"
			DlgToExcel({{"ARRAY", cNome, aCab2, aTabela}})
		else
			DlgToExcel({{"ARRAY", cNome, aCab, aTabela}})
		endif
	next
else
	aTabela := Array(nTotal, nCol)
	montaTabela(@cAliQuer, @aTabela, @aStruct, 1)
	procregua(0)

	if alltrim(valtype(aCab2))= "A"
		DlgToExcel({{"ARRAY", cNomeRel, aCab2, aTabela}})
	else
		DlgToExcel({{"ARRAY", cNomeRel, aCab, aTabela}})
	endif
endif


return



/*/{Protheus.doc}montaTabela
	Monta tabela do excel

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
static function montaTabela(cAliQuer, aTabela, aStruct, nLin)
	local nCont := 0

	while (cAliQuer)->(!EOF())

		geraLinha(@cAliQuer, @aTabela, @aStruct, @nLin)
		(cAliQuer)->(DBSkip())
		nCont++

		if nCont == 60000
			exit
		endif

		incProc()
		nLin++

	endDo

return


/*/{Protheus.doc}geraLinha
	Gera linha da tabela EXCEL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
static function geraLinha(cAliQuer, aTabela, aStruct, nLin)
	local nCol

	for nCol := 1 to Len (aStruct)
		dbselectarea("SX3")
		dbSetorder(2)
		if dbseek(aStruct[nCol,1])
			if '_USERLGI' $ SX3->X3_CAMPO ;
					.OR. '_USERLGA' $ SX3->X3_CAMPO ;
					.OR. '_USERLGI' $ SX3->X3_CAMPO;
					.OR. '_USERGA' $ SX3->X3_CAMPO;
					.OR. '_USERLGI' $ SX3->X3_CAMPO
				aTabela[nLin,nCol]:=(cAliQuer)->(FWLeUserlg(SX3->X3_CAMPO,1)+"-"+FWLeUserlg(SX3->X3_CAMPO,2))
			elseif SX3->X3_TIPO = 'C'
				aTabela[nLin,nCol]:= '="' + (cAliQuer)->&(aStruct[nCol,1]) + '"'
			elseif SX3->X3_TIPO = 'D'
				aTabela[nLin,nCol]:= STOD((cAliQuer)->&(aStruct[nCol,1]))
			else
				aTabela[nLin,nCol]:= (cAliQuer)->&(aStruct[nCol,1])
			endif

		else
			aTabela[nLin,nCol]:= iif(aStruct[nCol,2]<>'D',(cAliQuer)->&(aStruct[nCol,1]),stod((cAliQuer)->&(aStruct[nCol,1])))
		endif
	next nCol

return


/*/{Protheus.doc}getTitulo
	Retorna titulo da coluna conforme SX3 (obs: se não existir será o proprio no da coluna do SELECT)

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
static function getTitulo(cCampo)

	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek( cCampo )
		return X3TITULO()
	else
		return UPPER(cCampo)
	EndIf

return

/*/{Protheus.doc}macro
	Executa Macro ADVPL

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
Static Function macro(cQuery , cTGet)

	local cCRLF :=  CHR(13) + CHR(10)
	local cCRLF2 :=  CHR(10)
	local cquery2 := ""
	local cAux
	local aQuery := StrToArray(cQuery,cCRLF)
	local nx,nxt

	nxt := len(aQuery)

	For nx := 1 to nxt

		cAux := alltrim(aQuery[nx])

		if ValType(cAux) == 'C' .and. len(cAux) > 0

			cAux := '"' + cAux
			cAux := cAux + '"'

			cQuery2 += &(cAux) + cCRLF2

		endif

	next

return cQuery2


/*/{Protheus.doc}ExecQuery
	Executa SELECT

	@author Paulo Seno
	@since 05/07/2014
	@version MP11
/*/
Static function ExecQuery(cQuery,cAlias)
	TCQUERY cQuery NEW ALIAS (cAlias)
Return

