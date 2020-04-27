#include "totvs.ch"

#DEFINE ENTER CHR(13)+CHR(10)

//--------------------------------------------------------------
/*/{Protheus.doc} A410EXC - Exclus�o do pedido de vendas
Description //Descri��o da Fun��o
@param xParam Parameter Description
@return xRet Return Description
@author  - Alexis Duarte
@since 17/05/2019 /*/
//--------------------------------------------------------------

User Function A410EXC()

    Local lRet := .T.
    Local aAreaSC5 := SC5->(getArea())
    Local aAreaSC6 := SC6->(getArea())
    Local cRespV := SUPERGETMV("KH_RESPV", .T., "000000") //Responsavel Vendas
    Local cRespS := SUPERGETMV("KH_RESPS", .T., "000478") //Responsavel Sac
    Local cRespE := SUPERGETMV("KH_RESPE", .T., "000770|000951") //Responsavel Estoque/Logistica
    Local cResDv := SUPERGETMV("KH_RESDV", .T., "000770|000951|000033|000486") //Responsavel Estoque/Logistica - Devolu��o    
	Local cMsg := ""

    if SC5->C5_LIBEROK == "S" .and. SC5->C5_NOTA == Repl("X",Len(SC5->C5_NOTA)) .and. empty(SC5->C5_BLQ)	
		msgAlert("Pedido j� consta eliminado por res�duo!!","Aten��o")
        lRet := .F.
	endif

    if !INCLUI .and. !ALTERA .and. lRet
		//Exclus�o de Pedido de Devolu��o  - Marcio Nunes - 30/07/2019 - Chamado: 10964
		If SC5->C5_01TPOP == '3' .And. lRet
				If !(__cUserId $ cResDv)				    				
					msgAlert("Usuario sem permiss�o para excluir Pedidos de Devolu��o!!","Aten��o KH_RESDV")
					lRet := .F.
				Endif 	
			//Pedido Normal
		ElseIf dDatabase > SC5->C5_EMISSAO .and. SC5->C5_01TPOP == '1' .and. lRet
			cMsg := "N�o � permitido excluir Pedidos ap�s a data de emiss�o!!" + ENTER + ENTER
			cMsg += "Utilize a op��o, eliminar residuo."
			msgAlert(cMsg,"Aten��o")
			lRet := .F.
		else
			 //Pedido de transferencia
			if SC5->C5_01TPOP == '2' .and. lRet
				if __cUserId $ cRespE
				    //msgAlert("Excluindo pedido de transferencia!!","Aten��o")
					lRet := .T.
				else
					msgAlert("Usuario sem permiss�o para excluir Pedidos de Transfer�ncia!!","Aten��o KH_RESPE")
					lRet := .F.
				endif
			//Pedido Normal
			elseif SC5->C5_01TPOP == '1' .and. SC5->C5_MSFIL <> '0101' .and. lRet
				if __cUserId $ cRespV
				    //msgAlert("Excluindo pedido Normal!!","Aten��o")
					lRet := .T.
				else
					msgAlert("Usuario sem permiss�o para excluir Pedidos!!","Aten��o KH_RESPV")
					lRet := .F.
				endif
			//Pedido matriz
			elseif SC5->C5_MSFIL == '0101' .and. SC5->C5_01TPOP == '1' .and. lRet
				if __cUserId $ cRespS
                    //msgAlert("Excluindo pedido da matriz!!","Aten��o")
					lRet := .T.
				else
					msgAlert("Usuario sem permiss�o para excluir Pedidos!!","Aten��o KH_RESPS")
					lRet := .F.
				endif 
			else
				msgAlert("Pedido n�o identificado!!","Aten��o")
				lRet := .F.
			endif
		endif
	endif

    SC5->(restArea(aAreaSC5))
	SC6->(restArea(aAreaSC6))
	
Return lRet