#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
��� Programa � A030CGC  � Autor � Marcelo A. Lauschner � Data � 13/05/2014  ���
���������������������������������������������������������������������������͹��
���Descricao � Recurso que substitui a fun��o padr�o A030CGC na valida��o do���
���			 � campo A1_CGC. Complemento para valida��o da filial para      ���
���			 � Clientes com a mesma raiz de CNPJ.                           ���
���������������������������������������������������������������������������͹��
���Parametros� N/D                                                          ���
���������������������������������������������������������������������������͹��
���Uso       � Ferramentas KOMFORT HOUSE -                                  ���
���������������������������������������������������������������������������ͼ��
���Obs       � Compatibilizado por Rafael Cruz - Komfort House              ���
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function A030CGC()

Local	aAreaOld	:= SA1->(GetArea())
Local	cCNPJ		:= M->A1_CGC
Local	cA1_COD		:= M->A1_COD
Local	cA1_LOJA	:= M->A1_LOJA
Local	cCGCBAse     
Local	nLoja         

// N�o funcionar� em caso de altera��o de cadastro. //#RVC20180528.n
If !INCLUI 
	Return
EndIf
     
// For�o atualiza��o para Juridica se o numero de digitos for maior que 11
If Len(Alltrim(cCNPJ)) > 11
	M->A1_PESSOA = "J"
Endif

If M->A1_PESSOA == "J"
	cA1_LOJA	:= SubStr(cCNPJ,9,2)
	nLoja		:= Val(cA1_LOJA)
	// Fa�o controle se o numero da loja for maior que 100, ajusta pelo Microsiga
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
		// Efetua loop para evitar duplicidade de Loja, mesmo que n�o corresponda a loja do CNPJ
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

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
��� Programa � A030CGC  � Autor � Marcelo A. Lauschner � Data � 13/05/2014  ���
���������������������������������������������������������������������������͹��
���Descricao � Recurso que substitui a fun��o padr�o A030CGC na valida��o do���
���			 � campo A1_CGC. Complemento para valida��o da filial para      ���
���			 � Clientes com a mesma raiz de CNPJ.                           ���
���������������������������������������������������������������������������͹��
���Parametros� N/D                                                          ���
���������������������������������������������������������������������������͹��
���Uso       � Ferramentas KOMFORT HOUSE -                                  ���
���������������������������������������������������������������������������ͼ��
���Obs       � Compatibilizado por Rafael Cruz - Komfort House              ���
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function A020CGC()

Local	aAreaOld	:= SA2->(GetArea())
Local	cCNPJ		:= M->A2_CGC
Local	cA2_COD		:= M->A2_COD
Local	cA2_LOJA	:= M->A2_LOJA
Local	cCGCBAse     
Local	nLoja         

// N�o funcionar� em caso de altera��o de cadastro. //#RVC20180528.n
If !INCLUI 
	Return
EndIf
     
// For�o atualiza��o para Juridica se o numero de digitos for maior que 11
If Len(Alltrim(cCNPJ)) > 11
	M->A2_PESSOA = "J"
Endif

If M->A2_PESSOA == "J"
	cA2_LOJA	:= SubStr(cCNPJ,9,2)
	nLoja		:= Val(cA2_LOJA)
	// Fa�o controle se o numero da loja for maior que 100, ajusta pelo Microsiga
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
		// Efetua loop para evitar duplicidade de Loja, mesmo que n�o corresponda a loja do CNPJ
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