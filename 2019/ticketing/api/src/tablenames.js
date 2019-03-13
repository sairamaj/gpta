module.exports = function getTableNames(dev){
    if(dev){
        return {
            ticket: 'Ticket'
        }
    }else{
        return {
            ticket: 'gpta2018-ticketing-TicketTable-F3TQB98RIQL'
        }
    }
}