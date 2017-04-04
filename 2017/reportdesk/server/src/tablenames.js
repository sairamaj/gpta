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
            event: 'gpta2017-EventTable-45HQ1XBPFK95',
            program: 'gpta2017-ProgramTable-QLFCACRYZAMQ',
            participant: 'gpta2017-Participant-1GYB6I1H5I51L',
            programParticipant: 'gpta2017-ProgramParticipants-RYIOZZA62W47'
        }
    }
}