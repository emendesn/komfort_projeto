#include 'protheus.ch' 
#include 'totvs.ch' 
#include 'topconn.ch' 
#include 'parmtype.ch'

//--------------------------------------------------------------
//Fonte: SA1RECLA 
//Descrição: Classe de clientes reclame aqui
//--------------------------------------------------------------

Class SA1RECLA
    data email as string
    data first_name as string 
    data last_name as string
    data phone_number as string
    method New(email,first_name,last_name,phone_number)
    method setData(email,first_name,last_name,phone_number)
EndClass

method New(email,first_name,last_name,phone_number) class SA1RECLA  
    Default email    := 'jbuyer@komfort.com'
    Default first_name   := 'Wellington'
    Default last_name   := 'Raul'
    Default phone_number   := '999994488' 
return 

method setData(email,first_name,last_name,phone_number) class SA1RECLA
    self:email       := email
    self:first_name      := first_name
    self:last_name      := last_name
    self:phone_number      := phone_number
return

