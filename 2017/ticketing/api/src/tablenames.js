module.exports = function getTableNames(dev){
    if(dev){
        return {
            ticket: 'Ticket'
        }
    }else{
        return {
            ticket: 'gpta2017-ticketing-TicketTable-12OKQYJX9TLOG'
        }
    }
}