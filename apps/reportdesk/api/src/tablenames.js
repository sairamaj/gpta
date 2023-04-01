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
            event: 'gpta2023-reportdesk-EventTable-HU6Y3CZY31MD',
            program: 'gpta2023-reportdesk-ProgramTable-E4RSKYMT7SL5',
            participant: 'gpta2023-reportdesk-Participant-ER6OX952H7FT',
            programParticipant: 'gpta2023-reportdesk-ProgramParticipants-RL85B0URCIJ8'
        }
    }
}