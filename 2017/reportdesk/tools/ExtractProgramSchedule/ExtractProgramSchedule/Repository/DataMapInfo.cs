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

	}
}
