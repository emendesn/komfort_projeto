#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  F060BOR    บ Autor | Caio Garcia        บ Data ณ  29/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑ|Descri…o | Valida marcacao de titulo                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Komfort House                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function F060BOR()
 
Local cNumBor := ""
Local cGrpLib	:= GetMv("MV_KOGRPLB")	//#RVC20181019.n
Local cUserId	:= __cUserID			//#RVC20181019.n

//#RVC20181019.bo
/*
dVencIni  := StoD('20000101')
dVencFim  := StoD('20301231')
dEmisDe   := StoD('20000101')
dEmisAte  := StoD('20301231')  
cPort060  := '341'*/
//#RVC20181019.eo

//#RVC20181019.bn
If Alltrim(cUserId) $ cGrpLib
	dVencIni  := StoD('20000101')
	dVencFim  := StoD('20301231')
	dEmisDe   := StoD('20000101')
	dEmisAte  := StoD('20301231')  
	cPort060  := '341'    
EndIf              
//#RVC20181019.en

cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
	cNumBor := Soma1(cNumBor)
EndDo

Return(cNumBor)
