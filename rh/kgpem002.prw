#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KGPEM002 � Autor �RICARDO DUARTE COSTA� Data �  26/07/2019 ���
�������������������������������������������������������������������������͹��
���Descricao � Soma temporariamente SALMES, SALDIA e SALHORA a media de   ���
���          � comissao para formar a base de c�lculo de banco de horas em���
���          � rescis�o de contrato.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Shark                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function KGPEM002()

Local aArea1	  := GetArea()
Local aAreaRGB	  := RGB->(GetArea())
Local nx		  := 0
Local aTabU001	  := {}
Private w_cPdsBase	:= ""
Private w_cVerbas	:= ""

c__Roteiro :=  GETROTEXEC()

// Busca verbas na tabela U001
fCarrTab( @aTabU001,"U001",stod(CPERIODO+"01"),.T. )
w_cPdsBase	:= aTabU001[1,5]
w_cVerbas 	:= aTabU001[1,6]
w_nMeses	:= aTabU001[1,7]

//-- Abertura da tabela de lan�amentos
RGB->(DbSetOrder(1))

w_nMesIni := w_nAnoIni := w_nMesAux := w_nAnoAux := 0

//Se existe parametrizacao de meses de media de comissao para hora extra
If c__Roteiro == "RES" .And. SRA->RA_CATFUNC == "C"
	
	//-- Salva o sal�rio base corrente.
	M_SALMES  := SALMES
	M_SALDIA  := SALDIA
	M_SALHORA := SALHORA
	
	w_nPercDia := SALDIA  / SALMES
	w_nPercHor := SALHORA / SALMES
	
	//Busca mes anterior ao inicio de gozo  como referencia para periodo de medias
	If c__Roteiro == "RES"
		If cCompl == "S"	//-- Tratamento diferenciado para rescis�es complementares, onde temos que reencontrar a mesma base de c�lculo original
			//-- para a apura��o das horas extras sobre a base de c�lculo das comiss�es.
			w_nMesAux := month(GETMEMVAR('RG_DATADEM')) - 1
			w_nAnoAux := year(GETMEMVAR('RG_DATADEM'))
		Else
			w_nMesAux := month(GETMEMVAR('RG_DATAHOM')) - 1
			w_nAnoAux := year(GETMEMVAR('RG_DATAHOM'))
		Endif
	EndIf
	
	If w_nMesAux = 0
		w_nMesAux := 12
		w_nAnoAux := w_nAnoAux - 1
	EndIf
	
	w_nTotCom := 0
	
	w_nMesIni := w_nAnoIni := 0
	w_nMesIni := w_nMesAux - (w_nMeses-1)
	w_nAnoIni := w_nAnoAux
	
	If w_nMesIni < 1
		w_nMesIni += 12
		w_nAnoIni -= 1
	EndIf
	
	w_dInicio 	:= ctod("01/"+strzero(w_nMesIni,2)+"/"+right(str(w_nAnoIni),2))
	w_dFim		:= ctod("01/"+strzero(w_nMesAux,2)+"/"+right(str(w_nAnoAux),2))
	
	w_nTotCom += fBuscaAcm(w_cPdsBase,,w_dInicio,w_dFim,"V")  //Comissao e demais verbas de comiss�o
	
	SALMES  := round(w_nTotCom/w_nMeses,2)
	SALDIA  := round(SALMES * w_nPercDia,2)
	SALHORA := round(SALMES * w_nPercHor,2)
	
	For X := 1 to len(w_cVerbas) step 4
		Y := substr(w_cVerbas,X,3)
		If (nPos := aScan(aPd,{|x| x[1] == Y })) > 0
			If apd[nPos,6] <> "V"	//-- Somente verba informadas em horas ou dias, em valor, n�o mexeremos no valor calculado pelo sistema
				w_nPerc := posicione("SRV",1,xFilial("SRV")+Y,"RV_PERC")-100.00		//-- Reduzimos 100 do percentual, pois a hora extra de comissionado � somente o percentual de valoriza��o, n�o se paga novamente o principal. S�mula 340 TST
				nx_Perc	:= posicione("SRV",1,xFilial("SRV")+Y,"RV_PERC")
				//-- Novo valor de horas extras � encontrado pela COMISSAO x %ADICIONAL DE HORAS EXTRAS + SALARIO x %ADICONAL + SAL�RIO BASE
				apd[nPos,5] := 	round(SALHORA*apd[nPos,4]/100*w_nPerc,2)
			EndIf
		EndIf
	Next
	
	//-- N�o regravar quando o c�lculo efetuado � de PROVIS�ES
	If FunName() <> "GPER080"
		SALMES  := M_SALMES
		SALDIA  := M_SALDIA
		SALHORA := M_SALHORA
	Endif
	
	//-- Ajusta vari�vel de Horas normais e horas de descanso
	//-- para o correto c�lculo de DSR sobre as horas extras
	If c__Roteiro == "RES"
		If (nPosDSR	:= Ascan(apd,{|X| X[1] == acodfol[35,1] .And. X[6] == "H" .And. !X[7] $"IEG" .And. X[9] <> "D"})) > 0
			FDelPd(acodfol[35,1],cSemana)
			CalDsrHex(aCodfol,@DSr_HrEx,@Dsr_HhEx,"S",,nHrsTrab,nHrsDesc)
		Endif
		nHrsTrab	:= normal
		nHrsDesc	:= descanso
	Endif
	
EndIf

RestArea(aAreaRGB)
RestArea(aArea1)

Return()
