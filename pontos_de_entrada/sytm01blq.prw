#include "totvs.ch" 

#DEFINE ENTER	CHR(10)+CHR(13)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SYTM01BLQ �Autor  � Cristiam Rossi     � Data �  07/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. para bloquear o agendamento de entrega                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House / GLOBAL                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SYTM01BLQ()
Local aArea    := getArea()
Local aAreaSC5 := SC5->( getArea() )
Local lRet     := .F.
Local _FilPed  := ""
Local _Pedido  := ""

	if len( ParamIXB ) < 2
		msgAlert( "O P.E. est� encaminhando menos par�metros, verificar!", "Agendamento de Pedidos" )
		return lRet
	endif
	
	_FilPed := ParamIXB[1]
	_Pedido := ParamIXB[2]

	if empty(_Pedido)
		msgAlert( "O P.E. est� recebendo o N�mero do PV em branco, verificar!", "Agendamento de Pedidos" )
		return lRet
	endif

	SC5->( dbSetOrder(1) )
	if SC5->( dbSeek( _FilPed + _Pedido ) ) .and. SC5->C5_XLIBER == "B"
		lRet := .T.
		msgAlert( "O Pedido de Venda: "+_Pedido+" est� Bloqueado por conta de Desconto nos itens, verificar!", "Agendamento de Pedidos" )
	endif

	SC5->( restArea( aAreaSC5 ) )
	restArea( aArea )
    
	MsgRun("Validando itens do pedido...","Aguarde",{|| validBipar(@lRet,aItens)} )

return lRet

//#AFD20180523.bn
/*
----------------------------------------------------|
-> Valida��o dos itens no agendamento de produtos	|
-> By Alexis Duarte									|
-> 23/05/2018                                       |
-> Uso: Komfort House                               |
----------------------------------------------------|
*/
Static Function validBipar(lRet,aItens)
	
	Local aArea := getArea()
	Local aBiPar := {}
	Local aUnico := {}
	Local nx := 0
	Local ny := 0
	
	dbselectarea("SB1")
	SB1->(dbsetorder(1))
	
	for nx := 1 to len(aItens)

		if dbseek(SB1->(xFilial())+aItens[nx][3])
			if empty(alltrim(aItens[nx][14])) //Coluna Nota fiscal, linha dos itens na tela de agendamento...
				if SB1->B1_01BIPAR == '1' .and. aItens[nx][1]:cname == "BR_VERMELHO"
					aAdd(aBiPar,{aItens[nx][2],aItens[nx][3],aItens[nx][4],aItens[nx][5],aItens[nx][7],aItens[nx][8],aItens[nx][9]})
				else
					aAdd(aUnico,{aItens[nx][2],aItens[nx][3],aItens[nx][4],aItens[nx][5],aItens[nx][7],aItens[nx][8],aItens[nx][9]})
				endif
			endif
		else
			msgStop("Produto: "+ aItens[nx][3] +" N�o encontrado no cadastro de produtos..","ATEN��O")
			lRet := .T.
		endif
		
    next nx
    
	if len(aBiPar) > 0
		
		asort(aBiPar, , , { | x,y | x[2] > y[2] } )
		
		if len(aBiPar) < 2
			cMsgBipar := "O Produto: "+ aItens[1][2] +" Esta cadastrado como Bipartido"+ENTER
			cMsgBipar += "N�o � possivel agendar somente uma das partes !!!"			
			msgStop(cMsgBipar,"ATEN��O")
			
			lRet := .T.
		else
			for ny := 1 to len(aBiPar)

				nPos1 := ascan(aBiPar,{|x| substr(x[2],1,12) == substr(aBiPar[ny][2],1,12)})
				nPos2 := ascan(aBiPar,{|x| substr(x[2],1,12) == substr(aBiPar[ny][2],1,12)},nPos1+1)

				if nPos1 > 0
					if !nPos2 > 0
						cMsgBipar := "Existe Produtos cadastrados como Bipartido"+ENTER
						cMsgBipar += "N�o � possivel agendar somente uma das partes !!!"			
						msgStop(cMsgBipar,"ATEN��O")
                        
						lRet := .T.
						exit
					else
						if aBiPar[nPos1][7] > 0
							if !aBiPar[nPos2][7] > 0
								cMsgBipar := "Produto: "+aBiPar[nPos2][2]+ " n�o possui saldo!" +ENTER
								cMsgBipar += "verifique o estoque."+ENTER
								msgStop(cMsgBipar,"ATEN��O")
								
								lRet := .T.
								exit
							endif
						else
							cMsgBipar := "Produto: "+aBiPar[nPos1][2]+ " n�o possui saldo!" +ENTER
							cMsgBipar += "verifique o estoque."+ENTER
							msgStop(cMsgBipar,"ATEN��O")
							
							lRet := .T.
							exit
						endif
					endif
				endif
			next ny	
		endif
	endif
	
	if len(aUnico) > 0
		for nx := 1 to len(aUnico)
			if !aUnico[nx][7] > 0
				cMsgUnico := "Produto: "+aUnico[nx][2]+ " n�o possui saldo!" +ENTER
				cMsgUnico += "verifique o estoque."+ENTER
				msgStop(cMsgUnico,"ATEN��O")

				lRet := .T.	
			endif
		next
	endif
	
	if len(aBiPar) == 0 .and. len(aUnico) == 0
		cMsgBipar := "N�o existe itens a serem agendados."+ENTER
		msgStop(cMsgBipar,"ATEN��O")
		
		lRet := .T.	
	endif
	
    restarea(aArea)
	
Return lRet
//#AFD20180523.be