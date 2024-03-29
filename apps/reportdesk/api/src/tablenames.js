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
            event: 'gpta2023-reportdesk-EventTable-O3Z6LPRMVGFI',
            program: 'gpta2023-reportdesk-ProgramTable-1QU4WBU2RR0IX',
            participant: 'gpta2023-reportdesk-Participant-PS7BNYOX4KVE',
            programParticipant: 'gpta2023-reportdesk-ProgramParticipants-154S3NIZQC1DQ'
        }
    }
}