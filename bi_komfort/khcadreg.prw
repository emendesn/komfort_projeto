#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#INCLUDE "JPEG.CH"

#DEFINE ENTER (Chr(13)+Chr(10))

/*
=====================================================================================
Programa.:              KHCADREG
Autor....:              Luis Artuso
Data.....:              18/10/2019
Descricao / Objetivo:
Doc. Origem:            Tela de manutenção do cadastro de Regionais
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/

User Function KHCADREG()

	Local cAlias 	:= "ZLD"
	Local cTitulo	:= "Cadastro de Regionais"
	Local cVldExc	:= "U_fVldOp(M->ZLD_COD , 1)" //Validação na Exclusão
	Local cVldOk	:= "U_fVldOp(M->ZLD_COD , 2)" //Validação na Inclusão

	AxCadastro(cAlias, cTitulo, cVldExc, cVldOk)

Return

/*
=====================================================================================
Programa.:              fVldOp
Autor....:              Luis Artuso
Data.....:              18/10/2019
Descricao / Objetivo:
Doc. Origem:            Funcao de validacao de Alteracao/Exclusao
Solicitante:
Uso......:
Obs......:
=====================================================================================
*/
User Function fVldOp(cChave , nOp)

	Local lRet		:= .T.
	Local cCampo	:= ""

	If !(ALTERA)
	
		If (INCLUI)
			
			cCampo	:= M->ZLD_XCODFI
			
		Else
		
			cCampo	:= ZLD->ZLD_XCODFI
		
		EndIf

		If ( ZLD->(dbSeek(xFilial("ZLD")+cCampo)) )

			Do Case

				Case (nOp == 1) //Exclusao

					If ( (MsgYesNo("Confirma a exclusao do Registro ? " , "Confirma") .AND. (RecLock("ZLD" , .F.)) ) )

						lRet	:= .T.
						
						ZLD->(dbDelete())

						ZLD->(MsUnlock())

					EndIf

				OtherWise //Inclusao

					Aviso("Ja Existe" , "Ja existe um responsavel cadastrado para esta filial. ")

			EndCase

		EndIf

	Else

		lRet	:= .T.

	EndIf

Return lRet