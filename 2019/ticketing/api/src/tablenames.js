module.exports = function getTableNames(dev){
    if(dev){
        return {
            ticket: 'Ticket'
        }
    }else{
        return {
            ticket: 'gpta2019-ticketing-TicketTable-FHA13AUCLC2X'
        }
    }
}