#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA60FIL   บ Autor | Caio Garcia        บ Data ณ  29/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑ|Descri…o | Valida marcacao de titulo                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao da pergunta1 do SX1                              บฑฑ
ฑฑบ MV_PAR02 ณ Descricao da pergunta2 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta3 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta4 do SX1                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao do parametro 1                                   บฑฑ
ฑฑบ MV_PAR02 ณ Descricao do parametro 2                                   บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do parametro 3                                   บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do parametro 4                                   บฑฑ
ฑฑศออออออออออฯอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
FA60FIL - Filtro de registros processados do border๔. ( < cPort> , < cAgen> , 
< cConta> , < cSituacao> , < dVencIni> , < dVencFim> , < nLimite> , < nMoeda>
, < cContrato> , < dEmisDe> , < dEmisAte> , < cCliDe> , < cCliAte> ) --> URET
*/
User Function FA60FIL()

Local cFiltr:=""     
Local cGrpLib	:= GetMv("MV_KOGRPLB")
Local cUserId	:= __cUserID
Local cTipoX	:= ""					//#RVC20181019.n

If Alltrim(cUserId) $ cGrpLib

	cFiltr:="ALLTRIM(SE1->E1_TIPO) == 'BOL' .And. ALLTRIM(SE1->E1_NUMBCO) <> ' '"	//#RVC20181019.n
//	cFiltr:="SE1->E1_TIPO == 'BOL' .And. E1_NUMBCO <> ' '"							//#RVC20181019.o
	
Else
	cTipoX := StrTran(Alltrim(cTipos),"/","")			//#RVC20181019.n
	cTipoX := StrTran(cTipoX," ","")					//#RVC20181019.n
	
	cFiltr:="ALLTRIM(SE1->E1_TIPO) $ '" + cTipoX +"' " 	//#RVC20181019.n

//	cFiltr:="SE1->E1_PORTADO == '"+cPort060+"' "		//#RVC20181019.o

EndIf	

Return(cFiltr)
