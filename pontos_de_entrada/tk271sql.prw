User Function TK271SQL()

Local _cAlias	:= ParamIxb[1]
Local _cFiltro	:= ""
Local _cGrpCred	:= GetMv("MV_KOGRPLB")

If _cAlias == "SUA" .AND. __cUserId $ _cGrpCred           
	//_cFiltro := "UA_PEDPEND = '2' AND UA_CANC <> 'S'"     //Expressão SQL
	_cFiltro := "UA_XSTATUS <> '' AND UA_CANC <> 'S'" 
EndIf

Return _cFiltro