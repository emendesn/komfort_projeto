#include 'totvs.ch'
#include 'protheus.ch'

#DEFINE ENTER CHR(13)+CHR(10)

User Function MSGBLQAG()

	Local cMensagem := ""
	Local Ablqs := {}

	dbSelectArea("ZK7")
	ZK7->(dbSetOrder(1))
	ZK7->(dbgotop())
	
	while ZK7->(!eof()) 
		if ZK7->ZK7_DTBLQ >= dDataBase
			aAdd(Ablqs,ZK7->ZK7_DTBLQ)
		endif
	ZK7->(DbSkip())
	end

	cMensagem += "Atenção,"+ ENTER
	
	if len(Ablqs) > 1
		cMensagem += "O Agendamento ja encontra-se encerrado para os dias: "+ ENTER
	else
		cMensagem += "O Agendamento ja encontra-se encerrado para o dia: "+ ENTER	
	endif

	for nx := 1 to len(Ablqs)
		if nx == len(Ablqs)
			cMensagem += dtoc(Ablqs[nx]) + '.' + ENTER + ENTER
		elseif nx == len(Ablqs) -1
			cMensagem += dtoc(Ablqs[nx]) + " e "
		else
			cMensagem += dtoc(Ablqs[nx]) + ", "
		endif
	next nx

	cMensagem += "Para novos agendamentos utilizar datas diferentes das informadas acima"+"."+ ENTER+ ENTER
	cMensagem += "Atenciosamente"+ ENTER
	cMensagem += "Isaias Gomes"+ ENTER
	cMensagem += "Coordenador de Sac"+ ENTER+ ENTER
	cMensagem += "Isaias.gomes@komforthouse.com.br"+ ENTER

	apMsgInfo(cMensagem ,"PERIODO BLOQUEADO PARA AGENDAMENTO")

	SC7->(dbcloseArea())

Return