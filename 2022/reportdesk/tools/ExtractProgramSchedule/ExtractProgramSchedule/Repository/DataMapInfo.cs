namespace ExtractProgramSchedule.Repository
{
	class DataMapInfo
	{
		public DataMapInfo()
		{
			SheetName = "Program Line-up";
		}

		public string SheetName { get; set; }

		public int SequenceNumberCellIndex = 1;
		public int NameCellIndex = 2;
		public int ChoreographerNameCellIndex = 5;
		public int DurationCellIndex = 5;
		public int StartTimeCellIndex = 4;
		public int ReportTimeCellIndex = 3;
		public int ParticipantsCellIndex = 8;

	}
}
