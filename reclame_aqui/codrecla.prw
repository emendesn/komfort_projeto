#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'parmtype.ch'

/*/{Protheus.doc} LISRECLA
(long_description)
@author    wellington.raul
@since     06/11/2019
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class CODRECLA 
	data order_id as string 
	data delivery_date as string
	method New(order_id,delivery_date)
    method setData(order_id,delivery_date)
endclass

method New(order_id,delivery_date) class CODRECLA
	Default order_id       := '000001'
	Default delivery_date   := '2019-11-06T15:30:40+00:00'
return

method setData(order_id,delivery_date) class CODRECLA
	self:order_id       := order_id
	self:delivery_date   := delivery_date
return 



