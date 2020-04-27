#include 'protheus.ch'
#include 'parmtype.ch'

user function RETSTATS(cCod)

	Local cAliasSUC := getNextAlias()
	Local cQuery := ""
	Local cDesStatus := ""
	


	#DEFINE ENTER (Chr(13) + Chr(10))

	cQuery := "SELECT  " + ENTER
	cQuery +=	"	CASE  	WHEN UC_STATUS = '1'  THEN 'Planejada' "+ ENTER
	cQuery +=	"   WHEN UC_STATUS = '2'  THEN 'Pendente'"+ ENTER
	cQuery +=	"   WHEN UC_STATUS = '3'  THEN 'Encerrada' "+ ENTER
	cQuery +=	"   WHEN UC_STATUS = '4'  THEN 'Em Andamento' "+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '5'  THEN 'Visita Tec' "+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '6'  THEN 'Devolucao'"+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '7'  THEN 'Retorno'"+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '8'  THEN 'Troca Aut' "+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '9'  THEN 'Email Fabricante'"+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '10'  THEN 'Foto/Video'"+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '11'  THEN 'Canc/Bloqueado'"+ ENTER
	cQuery +=	"	WHEN UC_STATUS = '12'  THEN 'Canc/Liberado'"+ ENTER
	cQuery +=	"   END  UC_STATUS	"+ ENTER
	cQuery +=   "   FROM "+ retSqlName("SUC")+ " SUC"+ ENTER
	cQuery +=   "   WHERE UC_CODIGO = '"+cCod+"'" + ENTER

	PLSQuery(cQuery, cAliasSUC)

	if (cAliasSUC)->(!eof())
	cDesStatus := (cAliasSUC)->UC_STATUS
	endif

	(cAliasSUC)->(dbCloseArea())

return cDesStatus