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
            event: 'gpta2022-reportdesk-EventTable-135HYKUH94SFY',
            program: 'gpta2022-reportdesk-ProgramTable-1TKVBIRGHM73I',
            participant: 'gpta2022-reportdesk-Participant-1IIZF2HBGN3EX',
            programParticipant: 'gpta2022-reportdesk-ProgramParticipants-1JC9H3YZ6WGUZ'
        }
    }
}