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
            event: 'gpta2017-reportdesk-EventTable-VAWTYIVOBULZ',
            program: 'gpta2017-reportdesk-ProgramTable-CI86TVI7J02I',
            participant: 'gpta2017-reportdesk-Participant-1ASE6XGQC4WSY',
            programParticipant: 'gpta2017-reportdesk-ProgramParticipants-1W55LQTGSEX12'
        }
    }
}