/*
=====================================================================================
Programa.:              VldCupom
Autor....:              Luis Artuso
Data.....:              01/10/2019
Descricao / Objetivo:
Doc. Origem:
Solicitante:
Uso......:				Rotina responsavel por gerar em tela os clientes que devem
Obs......:				ser contactados apos um determinado periodo.
=====================================================================================
*/
User Function VldCupom()

	Local lRet		:= .F.

	lRet	:= IIF(SuperGetMv("KH_VLDCUPO",,.F.) , fVld01() , .T.)

Return lRet

/*
=====================================================================================
Programa.:              fVld01
Autor....:              Luis Artuso
Data.....:              01/10/2019
Descricao / Objetivo:
Doc. Origem:
Solicitante:
Uso......:				Executa a validacao do codigo do cupom inserido no momento
Obs......:				da geração do PV. Validacoes:
						1-> Se o codigo ja foi utilizado;
						  - Caso positivo: Solicitar um novo codigo para o rela-
						  cionamento
						  - Senao:  permite o cadastro e grava: Vendedor,
						  loja, e data de utilizacao.
						2-> Se nenhum código for informado, não executa a validação
						  e permite o cadastro
=====================================================================================
*/
Static Function fVld01()

	Local cQuery	:= ""
	Local cAlias01	:= "TMP01"
	Local oGrava	:= MNGDATA():NEW()
	Local aCampos	:= {}
	Local aAreaZL7	:= {}
	Local cMsg		:= ""
	Local lRet		:= .F.

	If !(Empty(M->UA_XCUPOM))

		cQuery	:=	" SELECT "
		cQuery	+=		" ZL7.R_E_C_N_O_ REGISTRO, "
		cQuery	+=		" ZL7.ZL7_LJCOMP LOJACOMPRA "
		cQuery	+=	" FROM "
		cQuery	+=		RetSqlName("ZL7") + " ZL7 "
		cQuery	+=	" WHERE "
		cQuery	+=		" ZL7.ZL7_CUPOM = '" + M->UA_XCUPOM + "'"

		cQuery	:= StrTran(cQuery , Space(2) , Space(1))

		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAlias01 , .T. , .F.)

		If ( (cAlias01)->(!EOF()) )

			aAreaZL7	:= ZL7->(GetArea())

			If ( Empty((cAlias01)->(LOJACOMPRA)) )

				aCampos	:=	{{"ZL7_VEND"	, M->UA_VEND},;
							{"ZL7_LJCOMP"	, cFilAnt},;
							{"ZL7_DTCOMP"	, dDataBase};
							}

				ZL7->(dbGoTo((cAlias01)->REGISTRO))

				oGrava:GravaData("ZL7" , .F. , aCampos)

				RestArea(aAreaZL7)

			Else

				cMsg	:= "Este cupom já foi utilizado. Solicite um novo junto a equipe de relacionamento"

			EndIf

		Else

			cMsg		:= "Cupom Inválido. Informe o cupom novamente."

		EndIf

		If !(Empty(cMsg))

			Aviso("Erro" , cMsg)

		Else

			lRet	:= .T.

		EndIf

		(cAlias01)->(dbCloseArea())

	Else

		lRet	:= .T.

	EndIf

Return lRet