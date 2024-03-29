using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ExtractProgramSchedule.Extensions;
using ExtractProgramSchedule.Model;
using OfficeOpenXml;

namespace ExtractProgramSchedule.Repository
{
	internal class DataRepository : IDataRepository
	{
		public IEnumerable<Program> Load(string excelFile, string programSheetName)
		{
			FileInfo newFile = new FileInfo(excelFile);
			var dataMapInfo = new DataMapInfo(programSheetName);
			using (ExcelPackage package = new ExcelPackage(newFile))
			{
				if(package.Workbook == null)
				{
					throw new ApplicationException($"Workbook cannot be opended in {newFile}");
				}
				if( package.Workbook.Worksheets == null)
				{
					throw new ApplicationException($"Could not open worksheets in {newFile}");
				}
				var programSheet = package.Workbook.Worksheets.FirstOrDefault(s => s.Name == dataMapInfo.SheetName);
				if (programSheet == null)
				{
					throw new Exception(string.Format("{0} not found in :{1}", dataMapInfo.SheetName, excelFile));
				}

				for (int row=2;; row++)
				{
					var name = programSheet.Get<string>(row, dataMapInfo.NameCellIndex);
					if (name == null)
					{
						break;
					}

					var serialNumberValue = programSheet.Get<string>(row, dataMapInfo.SequenceNumberCellIndex);
					if (serialNumberValue != null)
					{
						//Console.WriteLine($"==> {serialNumberValue}");
						var choreographerName = programSheet.Get<string>(row, dataMapInfo.ChoreographerNameCellIndex);
						var startTime = programSheet.Get<DateTime>(row,dataMapInfo.StartTimeCellIndex);
						var reportTime = programSheet.Get<DateTime>(row, dataMapInfo.ReportTimeCellIndex);
						var durationSpan = new TimeSpan(0, 5, 0);
						var serialNumber = 0;
						Int32.TryParse(serialNumberValue.ToString(), out serialNumber);
						
						var program = new Program(serialNumber, name, choreographerName, reportTime, startTime, durationSpan);
						var participants = programSheet.Get<string>(row, dataMapInfo.ParticipantsCellIndex);
						//Console.WriteLine($"|{participants}|");
						var parts = participants.Trim(new char[] { '"' }).Split(new string[] { "\n", "\t" }, StringSplitOptions.RemoveEmptyEntries);
						//Console.WriteLine($"parts: {parts.Length}");
						foreach (var participant in participants.Trim(new char[] { '"' }).Split(new string[] { "\n", "\t"}, StringSplitOptions.RemoveEmptyEntries))
						{
							var participantName = participant.FixParticipantName();
							if (!string.IsNullOrWhiteSpace(participantName))
							{
								program.AddParticipant(new Participant(participantName));
							}
						}

						yield return program;
					}
				}
				
			}
		}
	}
}
