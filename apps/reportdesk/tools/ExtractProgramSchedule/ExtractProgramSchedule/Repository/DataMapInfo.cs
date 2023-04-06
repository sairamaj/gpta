namespace ExtractProgramSchedule.Repository
{
	class DataMapInfo
	{
		public DataMapInfo(string sheetName)
		{
			SheetName = sheetName;
		}

		public string SheetName { get; set; }

		public int SequenceNumberCellIndex = 3;
		public int NameCellIndex = 5;
		public int ChoreographerNameCellIndex = 7;
		public int DurationCellIndex = -1;
		public int StartTimeCellIndex = -1;
		public int ReportTimeCellIndex = -1;
		public int ParticipantsCellIndex = 10;

	}
}
