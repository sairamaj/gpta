namespace ExtractProgramSchedule.Repository
{
	class DataMapInfo
	{
		public DataMapInfo()
		{
			SheetName = "FinalParticipants List";
		}

		public string SheetName { get; set; }

		public int SequenceNumberCellIndex = 1;
		public int NameCellIndex = 2;
		public int ChoreographerNameCellIndex = 4;
		public int DurationCellIndex = 5;
		public int StartTimeCellIndex = 7;
		public int ReportTimeCellIndex = 8;
		public int ParticipantsCellIndex = 11;

	}
}
