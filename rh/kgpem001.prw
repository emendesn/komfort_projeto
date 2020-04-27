#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ KGPEM001    ณ  HR DUARTE INFORMATICA  บ Data ณ  17/05/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa็ใo da ficha financeira.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function KGPEM001()

Local aArea		:= GetArea()
Local oGera
Private cPerg	:= "KGPEM001  "

ValidPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 400,480 DIALOG oGera TITLE OemToAnsi("Importa็ใo da Ficha Financeira")
@ 02,10 TO 095,230
@ 35,018 Say " Este programa ira importar a ficha financeira acumulada para a"
@ 42,018 Say " Komfort House.                                                "

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGera)
@ 70,188 BMPBUTTON TYPE 01 ACTION OkGera(oGera)

Activate Dialog oGera Centered

RestArea(aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERA   บ Autor ณ PRIMA INFORMATICA  บ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function OkGera(oGera)

//-- Confirma a operacao antes de sair executando
If !GPECROk()
	Return()
Endif

Processa( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

Close(oGera)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณ PRIMA INFORMATICA  บ Data ณ  28/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a query para o programa principal                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPrograma principal                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

Local cQuery	:= ""
Local cNomeTab	:= "FICHAGPE2"
Local cRetProc	:= ""
Local cProcErr	:= ""
Local cPrefixo	:= "RD_"
Local cTab_		:= "SRD"
Local cPdAux	:= ""
Local nHandle
Local nSize		:= 0
Local nTotImp	:= 0
Local nTotNImp	:= 0
Local nx		:= 0
Local TXT		:= ""
Local aLog		:= {}
Local aTitle	:= {}
Local aInfoFile	:= {}
Local aFields	:= 	{	;
{'TXT'		,'C',256, 0 };
}
Local aVerbas	:= {}
Local aFiliais	:= {}
Local aLogFun	:= {}
Local aTitle	:= {}
Local cRD_PD1	:= 	cRD_PD2	:= cRD_PD3	:= ''
Private cArqTXT	:= MV_PAR01
Private lRot132	:= MV_PAR02 == 2
Private cArquivo:= CriaTrab(,.F.)
Private cAno	:= mv_par02
Private cFilImp	:= mv_par03
Private cPath	:= AllTrim(GetTempPath())
Private cDirDocs:= MsDocPath()

Aadd(aLogFun,{})
Aadd(aTitle,"KGPM001 - Importa็ใo Ficha Financeira")

//-- Copia do arquivo texto para o servidor
IF !__copyfile(cArqTxt,cDirDocs+"\"+cArquivo+".TXT")
	Alert("Nใo foi possํvel copiar o arquivo selecionado.")
	return
Endif

//-- Inicia o tratamento da importacao arquivo de comiss๕es de representantes.
If Len(aFields) > 0
	
	// Exclui tabela temporaria
	If TCCanOpen(cNomeTab)
		TcDelFile(cNomeTab)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho                 							ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsCreate(cNomeTab,aFields,__cRdd)
	DbUseArea( .T.,__cRdd , cNomeTab, "QSRD", .F. )
	If Select("QSRD") == 0
		Aviso("Aten็ใo","Rotina estแ sendo usada por outro usuแrio",{"OK"})
		Return
	EndIf
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Importa o arquivo de ficha financeira               	     ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	MsAguarde({|| fAppendD() },OemToAnsi("Preparando importa็ใo de ficha financeira."),OemToAnsi("Aguarde..."))
	
	//-- Carrega o De X Para de Verbas
	fLoadPD(@aVerbas)
	fLoadFil(@aFiliais)
	
	//-- Testa quantidade de registros a serem importados
	ProcRegua( (nRegistros	:= QSRD->( reccount() )) )
	If nRegistros == 0
		Aviso("Aten็ใo","O arquivo de Ficha Financeira nใo cont้m dados a serem importados.",{"OK"})
		//-- Fecha o alias do arquivo temporario
		dbSelectArea( "QSRD" )
		dbCloseArea()
		return
	Endif
	
	//-- Abre tabela de Acumulados e de Funcionแrios
	DbSelectArea("SRD")
	DbSetOrder(1)
	DbSelectArea("SRA")
	DbSetOrder(RetOrder("SRA","RA_NOME+RA_FILIAL"))
//	_xNtxSRA := CriaTrab(nil,.f.)
//	IndRegua('SRA',_xNtxSRA,"RA_NOMECMP+RA_FILIAL",,,"Ordena por nome")
	
	//-- Processa a importa็ใo de lan็amentos acumulados
	cQuery := " SELECT * "
	cQuery += " FROM "+cNomeTab+" A"
	cQuery += " WHERE"
	cQuery += " A.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY R_E_C_N_O_"
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "FICHA"
	
	cCpf		:= ""
	cMatImp		:= ""
	cPdImp		:= ""
	cPdAnt		:= ""
	cFilialAnt	:= ""
	
	//-- Carrega informa็๕es de comissใo.
	While FICHA->(!eof())
//		If "000054-0 - ALESSANDRO CLAUDIO DA SILVA" $FICHA->TXT
//			ALERT(FICHA->TXT)
//		Endif
		IncProc()
		//-- Salta cabe็alho de pแgina, linha em branco e linha divis๓ria de informa็๕es
		If "DATAMACE"$FICHA->TXT .Or. "------------"$FICHA->TXT // .Or. "      FERIAS"$FICHA->TXT
			cRD_DATARQ	:= If(val(Substr(FICHA->TXT,92,4)+Substr(FICHA->TXT,89,2)) > 0,Substr(FICHA->TXT,92,4)+Substr(FICHA->TXT,89,2),cRD_DATARQ)
			If "      FERIAS"$FICHA->TXT
				FICHA->(DbSkip())
				FICHA->(DbSkip())
				FICHA->(DbSkip())
			Else
				FICHA->(DbSkip())
			Endif
			loop
			//-- Tratamento da Filial da ficha financeira
		ElseIf "GPD01A "$FICHA->TXT
			cFilialAnt	:= substr(FICHA->TXT,98,3) //Substituir pela nova filial
			If ( nPosPd	:= Ascan(aFiliais,{|X| X[1] == cFilialAnt}) )> 0
				cFilialAnt	:= aFiliais[nPosPd,2]
			Else
				cFilialAnt	:= "XXXX"  //ver se nใo encontrar o que fazer *******
			Endif
			FICHA->(DbSkip())
			loop
			//-- Tratamento do c๓digo de matricula
		ElseIf "REG: "$FICHA->TXT
			cRD_MAT		:= Substr(FICHA->TXT,06,06)
			CRD_MATORIG	:= Substr(FICHA->TXT,06,06)
			cNOMEFUNC	:= Substr(FICHA->TXT,17,30)
			//-- Pesquisa a matrํcula correspondente ao funcionแrio	//-- implementar o tratamento de matrํcula
			If !SRA->(Dbseek(cNOMEFUNC))
				Aadd(aLogFun[1],"Funcionแrio nใo encontrado: "+Alltrim(FICHA->TXT))
			Else
				cRD_MAT		:= SRA->RA_MAT	//-- Substr(FICHA->TXT,06,06)
			Endif
			//-- Saltar 2 linhas para pegar a pr๓xima informa็ใo
			FICHA->(Dbskip())
			If "DEMITIDO COD"$FICHA->TXT .Or. "RETORNO: "$FICHA->TXT
				FICHA->(Dbskip())
			Endif
			FICHA->(Dbskip())
			While FICHA->(!Eof()) .And. !Empty(alltrim(Substr(FICHA->TXT,1,220)))
				cRD_PD1		:= 	cRD_PD2	:= cRD_PD3	:= ''
				cRD_PDO1	:= 	cRD_PDO2:= cRD_PDO3	:= ''
				cRD_DPD1	:= 	cRD_DPD2:= cRD_DPD3	:= ''
				cRD_PD1		:= Substr(FICHA->TXT,002,3)
				cRD_PDO1	:= Substr(FICHA->TXT,002,3)
				cRD_DPD1	:= Substr(FICHA->TXT,006,12)
				cRD_PD2		:= Substr(FICHA->TXT,051,3)
				cRD_PDO2	:= Substr(FICHA->TXT,051,3)
				cRD_DPD2	:= Substr(FICHA->TXT,055,12)
				cRD_PD3		:= Substr(FICHA->TXT,100,3)
				cRD_PDO3	:= Substr(FICHA->TXT,100,3)
				cRD_DPD3	:= Substr(FICHA->TXT,105,12)

				//-- Pesquisa o c๓digo da Verba no Protheus
				If ( nPosPd	:= Ascan(aVerbas,{|X| X[1] == cRD_PD1}) )> 0
					cRD_PD1	:= aVerbas[nPosPd,2]
				Else
					cRD_PD1	:= ""
				Endif
				If ( nPosPd	:= Ascan(aVerbas,{|X| X[1] == cRD_PD2}) )> 0
					cRD_PD2	:= aVerbas[nPosPd,2]
				Else
					cRD_PD2	:= ""
				Endif
				If ( nPosPd	:= Ascan(aVerbas,{|X| X[1] == cRD_PD3}) )> 0
					cRD_PD3	:= aVerbas[nPosPd,2]
				Else
					cRD_PD3	:= ""
				Endif

				//-- Continua somente se encontrar um c๓digo de verba De/Para
				For nx := 1 to 3
					//-- Salta cabe็alho de pแgina, linha em branco e linha divis๓ria de informa็๕es
//					If "000054-0 - ALESSANDRO CLAUDIO DA SILVA" $FICHA->TXT
//						ALERT(FICHA->TXT)
//					Endif
					If "DATAMACE"$FICHA->TXT .Or. "------------"$FICHA->TXT // .Or. "      FERIAS"$FICHA->TXT
						cRD_DATARQ	:= If(val(Substr(FICHA->TXT,92,4)+Substr(FICHA->TXT,89,2)) > 0,Substr(FICHA->TXT,92,4)+Substr(FICHA->TXT,89,2),cRD_DATARQ)
						If "      FERIAS"$FICHA->TXT
							FICHA->(DbSkip())
							FICHA->(DbSkip())
							FICHA->(DbSkip())
						Else
							FICHA->(DbSkip())
						Endif
						loop
						//-- Tratamento da Filial da ficha financeira
					ElseIf "GPD01A "$FICHA->TXT
						cFilialAnt	:= substr(FICHA->TXT,98,3) //Substituir pela nova filial
						If ( nPosPd	:= Ascan(aFiliais,{|X| X[1] == cFilialAnt}) )> 0
							cFilialAnt	:= aFiliais[nPosPd,2]
						Else
							cFilialAnt	:= "XXXX"  //ver se nใo encontrar o que fazer *******
						Endif
						FICHA->(DbSkip())
						loop
						//-- Tratamento do c๓digo de matricula
					ElseIf "REG: "$FICHA->TXT
						cRD_MAT		:= Substr(FICHA->TXT,06,06)
						cRD_MATORIG	:= Substr(FICHA->TXT,06,06)
						cNOMEFUNC	:= alltrim(Substr(FICHA->TXT,17,30))
						//-- Pesquisa a matrํcula correspondente ao funcionแrio	//-- implementar o tratamento de matrํcula
						If !SRA->(Dbseek(cNOMEFUNC))
							Aadd(aLogFun[1],"Funcionแrio nใo encontrado: "+Alltrim(FICHA->TXT))
						Else
							cRD_MAT		:= SRA->RA_MAT	//-- Substr(FICHA->TXT,06,06)
						Endif
						//-- Saltar 2 linhas para pegar a pr๓xima informa็ใo
						FICHA->(Dbskip())
						If "DEMITIDO COD"$FICHA->TXT .Or. "RETORNO: "$FICHA->TXT
							FICHA->(Dbskip())
						Endif
						Exit
					Endif

					//-- Nใo trata linha de totais de verbas
					If "Total de Vencimentos:"$FICHA->TXT
						FICHA->(Dbskip())
						Loop
					Endif
					//-- Busca valor e horas
					If nx == 1
						cRD_PD		:= cRD_PD1
						cRD_POD		:= cRD_PDO1
						cRD_DPD		:= cRD_DPD1
						cRD_VALOR	:= val(strtran(strtran(Substr(FICHA->TXT,031,13),".",""),",","."))
						cRD_HORAS	:= val(strtran(strtran(Substr(FICHA->TXT,022,06),".",""),",","."))
						cRD_TIPO1	:= If(cRD_PD$"416","D",'V')		// Faltas
						cRD_TIPO1	:= If(cRD_PD$"293,136,137,138","H",cRD_TIPO1) //Horas Extras
					ElseIf nx == 2
						cRD_PD		:= cRD_PD2
						cRD_POD		:= cRD_PDO2
						cRD_DPD		:= cRD_DPD2
						cRD_VALOR	:= val(strtran(strtran(Substr(FICHA->TXT,080,13),".",""),",","."))
						cRD_HORAS	:= val(strtran(strtran(Substr(FICHA->TXT,071,06),".",""),",","."))
						cRD_TIPO1	:= If(cRD_PD$"416","D",'V')		// Faltas
						cRD_TIPO1	:= If(cRD_PD$"293,136,137,138","H",cRD_TIPO1) //Horas Extras
					ElseIf nx == 3
						cRD_PD		:= cRD_PD3
						cRD_POD		:= cRD_PDO3
						cRD_DPD		:= cRD_DPD3
						cRD_VALOR	:= val(strtran(strtran(Substr(FICHA->TXT,120,13),".",""),",","."))
						cRD_HORAS	:= 0
						cRD_TIPO1	:= If(cRD_PD$"416","D",'V')		// Faltas
						cRD_TIPO1	:= If(cRD_PD$"293,136,137,138","H",cRD_TIPO1) //Horas Extras
					Endif
					
					If cRD_VALOR > 0 .And. !Empty(cRD_PD)
						//-- Verifica a existencia de evento anterior e inclui novas informa็๕es
						lIncReg	:= !SRD->(DbSeek(cFilialAnt+cRD_MAT+cRD_DATARQ+cRD_PD))
						RecLock("SRD",lIncReg)
						SRD->RD_FILIAL	:= cFilialAnt
						SRD->RD_MAT		:= cRD_MAT
						SRD->RD_PD		:= cRD_PD
						SRD->RD_DATARQ	:= cRD_DATARQ
						SRD->RD_PERIODO := cRD_DATARQ
						SRD->RD_PROCES  := '00001'
						SRD->RD_ROTEIR  := If(lRot132,"132","FOL")
						SRD->RD_SEMANA  := '01'
						SRD->RD_VALOR	:= cRD_VALOR
						SRD->RD_HORAS	:= cRD_HORAS
						SRD->RD_MES		:= right(cRD_DATARQ,2)
						SRD->RD_DATPGT	:= stod(cRD_DATARQ+strzero(f_ultdia(stod(cRD_DATARQ+"01")),2))+5 //If(SRD->RD_MES == "13",stod(left(cRD_DATARQ,4)+"1220"),stod(cRD_DATARQ+strzero(f_ultdia(stod(cRD_DATARQ+"01")),2)))
						SRD->RD_TIPO1	:= cRD_TIPO1
						SRD->RD_TIPO2	:= "I"
						SRD->RD_STATUS	:= "M"
						SRD->RD_CC		:= SRA->RA_CC
						SRD->RD_DPDORIG	:= cRD_DPD
						SRD->RD_PDORIG	:= cRD_POD
						SRD->RD_NOMEDTM	:= cNOMEFUNC
						SRD->RD_MATORIG	:= cRD_MATORIG
						SRD->(MsUnlock())
					Endif
				Next nx
				FICHA->(DbSkip())
			Enddo
		Endif
		FICHA->(DbSkip())
	Enddo
	
	//-- Fecha a tabela de ficha financeira
	FICHA->(DbCloseArea())

	// Exclui tabela temporaria
	If TCCanOpen(cNomeTab)
//		TcDelFile(cNomeTab)
	EndIf

	//-- Exclui tabela temporaria
	If TCCanOpen(cNomeTab)
		dbSelectArea( "QSRD" )
		dbCloseArea()
//		TcDelFile(cNomeTab)
	EndIf

	fMakeLog(aLogFun,aTitle,,,"KGPEM001",,"G","P",,.F.)

Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPECROk  บAutor  ณPrima Informatica   บ Data ณ  10/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao GPECROK() - Confirmacao da execucao da geracao das  บฑฑ
ฑฑบ          ณ                    parcelas.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estatica                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GPECROk()
Return ( MsgYesNo( OemToAnsi( "Confirma processamento?" ), OemToAnsi( "Atencao" ) ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfappendD  บAutor  ณPrima Informatica   บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o append do arquivo do dissidio para o banco Oracleบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fAppendD()

Append From (cDirDocs+"\"+cArquivo+".TXT") SDF
fErase(cDirDocs+"\"+cArquivo+".TXT")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ Prima Informatica  บ Data ณ  14/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function ValidPerg()

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/                    Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
Aadd(aRegs,{cPerg,"01","Local do arquivo?","Local do arquivo?","Local do arquivo?"                           ,"mv_ch1","C",99,0,0,"G" ,"U_fOpenAF2()","mv_par01","","","","","","","","","","","","","","","","","","","","",""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"02","Folha 2aP.13o Salแrio?","Folha 2aP.13o Salแrio?","Folha 2aP.13o Salแrio?"            ,"mv_ch2","C",01,0,0,"C" ,"            ","mv_par02","Nใo","" ,"" ,"","","Sim","" ,"" ,"","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfOpenAF1  บAutor  ณ Prima Informtica   บ Data ณ  19/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona o arquivo a importar.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function fOpenAF2()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "Arquivo Texto(*.TXT)  |*.TXT| "
Local cNewPathArq	:= cGetFile( cTipo , "Selecione o arquivo" )

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( "TXT" ) )
		Aviso( "Aten็ใo","Arquivo selecionado: " + cNewPathArq , { "OK" } )
	Else
		MsgAlert( "Arquivo invแlido" )
		Return
	EndIF
Else
	Aviso("Aten็ใo","Sele็ใo cancelada" ,{ "OK" })
	Return
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa o parametro para a Carga do Novo Arquivo                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX1")
IF lAchou := ( SX1->( dbSeek( cPerg + "01" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par01 := cNewPathArq
	MsUnLock()
EndIF
dbSelectArea( cSvAlias )

Return(lAchou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLoadPD   บAutor  ณ Prima Informtica   บ Data ณ  19/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o De X Para de Verbas a importar.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fLoadPD(aCodigos)

Aadd(aCodigos,{'001','101'})
Aadd(aCodigos,{'004','150'})
Aadd(aCodigos,{'005','148'})
Aadd(aCodigos,{'006','176'})
Aadd(aCodigos,{'008','293'})
Aadd(aCodigos,{'009','155'})
Aadd(aCodigos,{'009','155'})
Aadd(aCodigos,{'024','124'})
Aadd(aCodigos,{'031','143'})
Aadd(aCodigos,{'033','143'})
Aadd(aCodigos,{'033','143'})
Aadd(aCodigos,{'034','301'})
Aadd(aCodigos,{'036','399'})
Aadd(aCodigos,{'039','558'})
Aadd(aCodigos,{'041','125'})
Aadd(aCodigos,{'044','108'})
Aadd(aCodigos,{'045','143'})
Aadd(aCodigos,{'046','117'})
Aadd(aCodigos,{'047','119'})
Aadd(aCodigos,{'048','126'})
Aadd(aCodigos,{'052','215'})
Aadd(aCodigos,{'055','151'})
Aadd(aCodigos,{'059','248'})
Aadd(aCodigos,{'060','126'})
Aadd(aCodigos,{'061','107'})
Aadd(aCodigos,{'062','296'})
Aadd(aCodigos,{'063','128'})
Aadd(aCodigos,{'065','129'})
Aadd(aCodigos,{'066','131'})
Aadd(aCodigos,{'067','141'})
Aadd(aCodigos,{'068','142'})
Aadd(aCodigos,{'071','754'})
Aadd(aCodigos,{'072','755'})
Aadd(aCodigos,{'073','109'})
Aadd(aCodigos,{'074','109'})
Aadd(aCodigos,{'075','118'})
Aadd(aCodigos,{'078','120'})
Aadd(aCodigos,{'080','300'})
Aadd(aCodigos,{'092','227'})
Aadd(aCodigos,{'103','194'})
Aadd(aCodigos,{'105','194'})
Aadd(aCodigos,{'106','467'})
Aadd(aCodigos,{'107','254'})
Aadd(aCodigos,{'108','470'})
Aadd(aCodigos,{'140','104'})
Aadd(aCodigos,{'146','136'})
Aadd(aCodigos,{'148','137'})
Aadd(aCodigos,{'153','138'})
Aadd(aCodigos,{'161','104'})
Aadd(aCodigos,{'162','114'})
Aadd(aCodigos,{'164','202'})
Aadd(aCodigos,{'195','196'})
Aadd(aCodigos,{'198','144'})
Aadd(aCodigos,{'200','289'})
Aadd(aCodigos,{'203','116'})
Aadd(aCodigos,{'209','156'})
Aadd(aCodigos,{'240','494'})
Aadd(aCodigos,{'245','301'})
Aadd(aCodigos,{'246','554'})
Aadd(aCodigos,{'268','121'})
Aadd(aCodigos,{'286','200'})
Aadd(aCodigos,{'289','226'})
Aadd(aCodigos,{'291','421'})
Aadd(aCodigos,{'292','257'})
Aadd(aCodigos,{'315','559'})
Aadd(aCodigos,{'320','227'})
Aadd(aCodigos,{'325','209'})
Aadd(aCodigos,{'343','482'})
Aadd(aCodigos,{'391','126'})
Aadd(aCodigos,{'392','468'})
Aadd(aCodigos,{'401','413'})
Aadd(aCodigos,{'402','414'})
Aadd(aCodigos,{'404','415'})
Aadd(aCodigos,{'405','415'})
Aadd(aCodigos,{'406','413'})
Aadd(aCodigos,{'408','415'})
Aadd(aCodigos,{'410','410'})
Aadd(aCodigos,{'411','412'})
Aadd(aCodigos,{'411','412'})
Aadd(aCodigos,{'412','412'})
Aadd(aCodigos,{'413','412'})
Aadd(aCodigos,{'414','411'})
Aadd(aCodigos,{'415','401'})
Aadd(aCodigos,{'421','416'})
Aadd(aCodigos,{'423','409'})
Aadd(aCodigos,{'424','407'})
Aadd(aCodigos,{'424','407'})
Aadd(aCodigos,{'425','407'})
Aadd(aCodigos,{'427','423'})
Aadd(aCodigos,{'428','449'})
Aadd(aCodigos,{'434','402'})
Aadd(aCodigos,{'435','419'})
Aadd(aCodigos,{'441','457'})
Aadd(aCodigos,{'442','431'})
Aadd(aCodigos,{'442','431'})
Aadd(aCodigos,{'443','454'})
Aadd(aCodigos,{'444','441'})
Aadd(aCodigos,{'445','441'})
Aadd(aCodigos,{'457','234'})
Aadd(aCodigos,{'457','234'})
Aadd(aCodigos,{'460','233'})
Aadd(aCodigos,{'463','296'})
Aadd(aCodigos,{'466','296'})
Aadd(aCodigos,{'469','554'})
Aadd(aCodigos,{'472','554'})
Aadd(aCodigos,{'475','301'})
Aadd(aCodigos,{'476','301'})
Aadd(aCodigos,{'478','233'})
Aadd(aCodigos,{'482','481'})
Aadd(aCodigos,{'489','461'})
Aadd(aCodigos,{'507','474'})
Aadd(aCodigos,{'511','190'})
Aadd(aCodigos,{'520','419'})
Aadd(aCodigos,{'536','492'})
Aadd(aCodigos,{'540','472'})
Aadd(aCodigos,{'542','462'})
Aadd(aCodigos,{'544','455'})
Aadd(aCodigos,{'552','475'})
Aadd(aCodigos,{'553','433'})
Aadd(aCodigos,{'556','420'})
Aadd(aCodigos,{'569','416'})
Aadd(aCodigos,{'575','152'})
Aadd(aCodigos,{'587','431'})
Aadd(aCodigos,{'593','528'})
Aadd(aCodigos,{'604','403'})
Aadd(aCodigos,{'648','480'})
Aadd(aCodigos,{'654','477'})
Aadd(aCodigos,{'666','513'})
Aadd(aCodigos,{'668','513'})
Aadd(aCodigos,{'686','541'})
Aadd(aCodigos,{'706','451'})
Aadd(aCodigos,{'717','143'})
Aadd(aCodigos,{'725','559'})
Aadd(aCodigos,{'801','702'})
Aadd(aCodigos,{'802','705'})
Aadd(aCodigos,{'803','705'})
Aadd(aCodigos,{'804','704'})
Aadd(aCodigos,{'805','704'})
Aadd(aCodigos,{'807','712'})
Aadd(aCodigos,{'808','713'})
Aadd(aCodigos,{'809','714'})
Aadd(aCodigos,{'809','714'})
Aadd(aCodigos,{'810','708'})
Aadd(aCodigos,{'816','703'})
Aadd(aCodigos,{'818','704'})
Aadd(aCodigos,{'823','709'})
Aadd(aCodigos,{'824','750'})
Aadd(aCodigos,{'825','721'})
Aadd(aCodigos,{'825','721'})
Aadd(aCodigos,{'826','750'})
Aadd(aCodigos,{'826','750'})
Aadd(aCodigos,{'827','721'})
Aadd(aCodigos,{'829','721'})
Aadd(aCodigos,{'830','750'})
Aadd(aCodigos,{'831','783'})
Aadd(aCodigos,{'837','903'})
Aadd(aCodigos,{'844','706'})
Aadd(aCodigos,{'845','710'})
Aadd(aCodigos,{'859','811'})
Aadd(aCodigos,{'859','811'})
Aadd(aCodigos,{'893','710'})
Aadd(aCodigos,{'109','185'})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLoadPD   บAutor  ณ Prima Informtica   บ Data ณ  19/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o De X Para de Verbas a importar.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fLoadFil(aCodigos)

Aadd(aCodigos,{'332','0115'})
Aadd(aCodigos,{'333','0102'})
Aadd(aCodigos,{'334','0103'})
Aadd(aCodigos,{'335','0106'})
Aadd(aCodigos,{'336','0105'})
Aadd(aCodigos,{'337','0108'})
Aadd(aCodigos,{'337','0205'})
Aadd(aCodigos,{'338','0104'})
Aadd(aCodigos,{'338','0206'})
Aadd(aCodigos,{'339','0107'})
Aadd(aCodigos,{'349','0109'})
Aadd(aCodigos,{'350','0110'})
Aadd(aCodigos,{'352','0111'})
Aadd(aCodigos,{'357','0112'})
Aadd(aCodigos,{'362','0114'})
Aadd(aCodigos,{'363','0113'})
Aadd(aCodigos,{'363','0203'})
Aadd(aCodigos,{'364','0116'})
Aadd(aCodigos,{'365','0101'})
Aadd(aCodigos,{'386','0117'})
Aadd(aCodigos,{'387','0118'})
Aadd(aCodigos,{'388','0119'})
Aadd(aCodigos,{'389','0120'})
Aadd(aCodigos,{'400','0123'})
Aadd(aCodigos,{'400','0207'})
Aadd(aCodigos,{'401','0121'})
Aadd(aCodigos,{'401','0202'})
Aadd(aCodigos,{'402','0122'})
Aadd(aCodigos,{'403','0125'})
Aadd(aCodigos,{'404','0124'})
Aadd(aCodigos,{'405','0126'})
Aadd(aCodigos,{'413','0128'})
Aadd(aCodigos,{'415','0201'})
Aadd(aCodigos,{'419','0127'})
Aadd(aCodigos,{'420','0131'})
Aadd(aCodigos,{'420','0209'})
Aadd(aCodigos,{'421','0133'})
Aadd(aCodigos,{'422','0130'})
Aadd(aCodigos,{'423','0129'})
Aadd(aCodigos,{'424','0134'})
Aadd(aCodigos,{'425','0132'})
Aadd(aCodigos,{'425','0210'})
Aadd(aCodigos,{'427','0135'})
Aadd(aCodigos,{'432','0137'})
Aadd(aCodigos,{'436','0136'})
Aadd(aCodigos,{'442','0138'})
Aadd(aCodigos,{'446','0139'})
Aadd(aCodigos,{'447','0141'})
Aadd(aCodigos,{'448','0140'})

Return

/*

MECANISMO E LำGICA OK APำS AJUSTES,
FALTA DE X PARA DE VERBAS
FALTA TRATAMENTO DE MATRICULAS DE FUNCIONมRIOS ATRAVษS DE NOME E DATA DE ADMISSรO

SELECT RD_FILIAL, RD_MAT, MIN(R_E_C_N_O_) RECSRD
FROM SRDZZ0 A
GROUP BY RD_FILIAL, RD_MAT
ORDER BY RECSRD

--TRUNCATE TABLE SRDZZ0

*/
