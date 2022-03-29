module.exports = function getTableNames(dev){
    if(dev){
        return {
            event: 'Event',
            program: 'Program',
            participant: 'Participant',
            programParticipant: 'ProgramParticipants'
        }
    }else{
        return {
            event: 'gpta2019-reportdesk-EventTable-1COJ1IFY61BP7',
            program: 'gpta2019-reportdesk-ProgramTable-15MVZJ2HUJGEC',
            participant: 'gpta2019-reportdesk-Participant-1KHGCSV39MGG5',
            programParticipant: 'gpta2019-reportdesk-ProgramParticipants-1C4VH378RI1M7'
        }
    }
}