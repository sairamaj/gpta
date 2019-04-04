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
            event: 'gpta2018-reportdesk-EventTable-6F6SMK2UAWXQ',
            program: 'gpta2018-reportdesk-ProgramTable-1WHLR307YV53W',
            participant: 'gpta2018-reportdesk-Participant-H0SULO1SPA30',
            programParticipant: 'gpta2018-reportdesk-ProgramParticipants-18PXF0YZT5ZXB'
        }
    }
}