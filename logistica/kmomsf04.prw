#include 'protheus.ch'
#include 'parmtype.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³KMOMSF04  ³AUTOR: ³Caio Garcia            ³DATA: ³25/10/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Logistica - Komfort House                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               |  /  /  |                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user function KMOMSF04()

	LOCAL _cCarga:=DAK->DAK_COD

	IF DAK->DAK_ACECAR == '2'

		IF MSGYESNO ("Deseja excluir apontamento da carga "+_cCarga+"?", "APAGA")

			DBSELECTAREA("DAH")
			DAH->(DBSETORDER(1)) //DAH_FILIAL+DAH_CODCAR+DAH_SEQCAR+DAH_SEQUEN                                                                                                                     
			DAH->(DBGOTOP())
			DAH->(DBSEEK(XFILIAL("DAH")+_cCarga))

			WHILE DAH->(!EOF()) .AND. XFILIAL("DAH") == DAH->DAH_FILIAL .AND. _cCarga ==DAH->DAH_CODCAR

			alert("PASSOU")

				RECLOCK("DAH",.F.)

				DAH->(DBDELETE())

				DAH->(MSUNLOCK())

				DAH->(DBSKIP())

			ENDDO 

		ENDIF

	ELSE

		MSGSTOP("Carga ja encerrada", "Aviso")

	ENDIF

return