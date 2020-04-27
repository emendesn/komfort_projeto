#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ A030CGC  º Autor ³ Marcelo A. Lauschner º Data ³ 13/05/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Recurso que substitui a função padrão A030CGC na validação doº±±
±±º			 ³ campo A1_CGC. Complemento para validação da filial para      º±±
±±º			 ³ Clientes com a mesma raiz de CNPJ.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ N/D                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ferramentas KOMFORT HOUSE -                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºObs       ³ Compatibilizado por Rafael Cruz - Komfort House              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A030CGC()

Local	aAreaOld	:= SA1->(GetArea())
Local	cCNPJ		:= M->A1_CGC
Local	cA1_COD		:= M->A1_COD
Local	cA1_LOJA	:= M->A1_LOJA
Local	cCGCBAse     
Local	nLoja         

// Não funcionará em caso de alteração de cadastro. //#RVC20180528.n
If !INCLUI 
	Return
EndIf
     
// Forço atualização para Juridica se o numero de digitos for maior que 11
If Len(Alltrim(cCNPJ)) > 11
	M->A1_PESSOA = "J"
Endif

If M->A1_PESSOA == "J"
	cA1_LOJA	:= SubStr(cCNPJ,9,2)
	nLoja		:= Val(cA1_LOJA)
	// Faço controle se o numero da loja for maior que 100, ajusta pelo Microsiga
	If nLoja >= 100
		cA1_LOJA	:= "99"
		For iW := 1 To (nLoja - 100)
			cA1_LOJA := Soma1(cA1_LOJA)
		Next       
	Else
		cA1_LOJA := SubStr(cCNPJ,11,2)
	Endif
	cCGCBase := SubStr(cCNPJ,1,8)
	DbSelectArea("SA1")
	DbSetOrder(3)
	If DbSeek(xFilial("SA1")+cCGCBase)
		cA1_COD      := SA1->A1_COD
		// Efetua loop para evitar duplicidade de Loja, mesmo que não corresponda a loja do CNPJ
		While .T.
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+cA1_COD+cA1_LOJA)
				cA1_LOJA := Soma1(cA1_LOJA)
			Else
				Exit
			Endif
		Enddo
	Endif
	M->A1_COD	:= cA1_COD
	M->A1_LOJA	:= cA1_LOJA
	RestArea(aAreaOld)
Endif

Return A030CGC(M->A1_PESSOA, M->A1_CGC)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ A030CGC  º Autor ³ Marcelo A. Lauschner º Data ³ 13/05/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Recurso que substitui a função padrão A030CGC na validação doº±±
±±º			 ³ campo A1_CGC. Complemento para validação da filial para      º±±
±±º			 ³ Clientes com a mesma raiz de CNPJ.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ N/D                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ferramentas KOMFORT HOUSE -                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºObs       ³ Compatibilizado por Rafael Cruz - Komfort House              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A020CGC()

Local	aAreaOld	:= SA2->(GetArea())
Local	cCNPJ		:= M->A2_CGC
Local	cA2_COD		:= M->A2_COD
Local	cA2_LOJA	:= M->A2_LOJA
Local	cCGCBAse     
Local	nLoja         

// Não funcionará em caso de alteração de cadastro. //#RVC20180528.n
If !INCLUI 
	Return
EndIf
     
// Forço atualização para Juridica se o numero de digitos for maior que 11
If Len(Alltrim(cCNPJ)) > 11
	M->A2_PESSOA = "J"
Endif

If M->A2_PESSOA == "J"
	cA2_LOJA	:= SubStr(cCNPJ,9,2)
	nLoja		:= Val(cA2_LOJA)
	// Faço controle se o numero da loja for maior que 100, ajusta pelo Microsiga
	If nLoja >= 100
		cA2_LOJA	:= "99"
		For iW := 1 To (nLoja - 100)
			cA2_LOJA := Soma1(cA2_LOJA)
		Next       
	Else
		cA2_LOJA := SubStr(cCNPJ,11,2)
	Endif
	cCGCBase := SubStr(cCNPJ,1,8)
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2")+cCGCBase)
		cA2_COD      := SA2->A2_COD
		// Efetua loop para evitar duplicidade de Loja, mesmo que não corresponda a loja do CNPJ
		While .T.
			DbSelectArea("SA2")
			DbSetOrder(1)
			If DbSeek(xFilial("SA2")+cA2_COD+cA2_LOJA)
				cA2_LOJA := Soma1(cA2_LOJA)
			Else
				Exit
			Endif
		Enddo
	Endif
	M->A2_COD	:= cA2_COD
	M->A2_LOJA	:= cA2_LOJA
	RestArea(aAreaOld)
Endif

Return A020CGC(M->A2_PESSOA, M->A2_CGC)