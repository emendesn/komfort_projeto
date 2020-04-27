#include "protheus.ch"       
#include "TbiConn.ch"
#Include "Topconn.ch"

#DEFINE CRLF CHR(10)+CHR(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ KMCOMA07 ³ Autor ³ Global                ³ Data ³03/04/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para alimentar tabelas SBZ via Job                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ KomfortHouse                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION KMCOMA07(_cEmp, _cFil)
	
Local aLojas 	:= {}
Local cGrupo	:= "" 
Local nX 		:= 0
Local cQuery 	:=	""
Local _cInicio	:= Time()  
Local cAliasQry	:= GetNextAlias()

ConOut("Inicio de execucao do Schedule")

Prepare Environment Empresa _cEmp Filial _cFil TABLES "SM0" MODULO 'TMK' 
RpcSetType(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grupo de Produtos que nao deverao cadastrar na tabela SBZ   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cGrupo	:= SuperGetMv("KH_GRPPROD",,"2001|2002")

dbSelectArea("SM0")
dbSetOrder(1)
While SM0->(!Eof())
     AADD(aLojas, {SM0->M0_CODIGO, SM0->M0_CODFIL})
     SM0->(dbSkip())
     ConOut("Entrou no while SM0")
Enddo

ConOut("Quantidade de lojas" + cValtoChar(Len(aLojas)))

// Fecha Area Se Estiver Aberta
If Select(cAliasQry) > 0
	DbCloseArea(cAliasQry)
EndIf

cQuery := "SELECT BZ_COD, COUNT(*) QTDE " + CRLF
cQuery += "FROM "+RetSqlName("SBZ") + " SBZ "+CRLF
cQuery += "GROUP BY BZ_COD HAVING COUNT(BZ_COD) <=" + "'1'"
			
cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), cAliasQry, .T., .F. )

DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())
While (cAliasQry)->(!EOF() ) 	

	For nX:=1 To Len(aLojas)	
	
		ConOut("Acesso While da Query - Loja: " + cValtoChar(Len(Alltrim(aLojas[nX][2]))))

	 	_cEmp := aLojas[nX][1]
	 	_cFil := Alltrim(aLojas[nX][2])
	 	/*
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1") + AvKey((cAliasQry)->BZ_COD,"B1_COD") ))
		RecLock("SB1",.F.) 
			SB1->B1_MSBLQL := '2' // Desbloqueia Produto
		SB1->(MsUnlock())
	 */
		DbSelectArea("SBZ")
		DbSetOrder(1)
		IF SBZ->(!DbSeek(_cFil+(cAliasQry)->BZ_COD))  
			RecLock("SBZ",.T.) // .T. = INCLUI
				SBZ->BZ_FILIAL  := _cFil
				SBZ->BZ_COD     := (cAliasQry)->BZ_COD
				SBZ->BZ_LOCPAD  := ALLTRIM(SUPERGETMV("SY_LOCPAD",,"01", _cFil))
				SBZ->BZ_LOCALIZ := iif( (_cFil $ Alltrim(SUPERGETMV("SY_LOCALIZ"))) .And. !(SB1->B1_GRUPO $ cGrupo)  ,"S","N")
				SBZ->BZ_DTINCLU := DDATABASE
				SBZ->BZ_TIPOCQ  := 'M' 
				SBZ->BZ_CTRWMS  := '2'  
			SBZ->(MsUnLock())
		EndIF		
		//GRAVAINF((cAliasQry)->BZ_COD,_cFil) --> Caso for necessário alimentar SB2/SB9
	Next nX

(cAliasQry)->(DBSKIP())

EndDo

ConOut("Fim Da Execução Do Schedule " + Alltrim(ProcName()) + " Tempo Execução: " + ElapTime(_cInicio,Time()))

(cAliasQry)->(DbCloseArea())

RESET ENVIRONMENT 
	
Return .T.