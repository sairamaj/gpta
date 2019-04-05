namespace ExtractProgramSchedule.Repository
{
	class DataMapInfo
	{
		public DataMapInfo()
		{
			SheetName = "Particpants  Check-in";
		}

		public string SheetName { get; set; }

		public int SequenceNumberCellIndex = 1;
		public int NameCellIndex = 2;
		public int ChoreographerNameCellIndex = 4;
		public int DurationCellIndex = 5;
		public int StartTimeCellIndex = 7;
		public int ReportTimeCellIndex = 3;
		public int ParticipantsCellIndex = 7;

	}
}
