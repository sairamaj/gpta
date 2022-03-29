﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ExtractProgramSchedule.Model;
using OfficeOpenXml;

namespace ExtractProgramSchedule.Repository
{
	internal class DataRepository : IDataRepository
	{
		public IEnumerable<Program> Load(string file)
		{
			

			FileInfo newFile = new FileInfo(file);
			var dataMapInfo = new DataMapInfo();
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
					throw new Exception(string.Format("{0} not found in :{1}", dataMapInfo.SheetName, file));
				}

				for (int row=2;; row++)
				{
					var name = programSheet.Cells[row, dataMapInfo.NameCellIndex].Value as string;
					if (name == null)
					{
						break;
					}
					var serialNumberValue = programSheet.Cells[row, dataMapInfo.SequenceNumberCellIndex].Value ;
					if (serialNumberValue != null)
					{
						//Console.WriteLine($"==> {serialNumberValue}");
						var choreographerName = programSheet.Cells[row, dataMapInfo.ChoreographerNameCellIndex].Value as string;
						//var duration = (DateTime)programSheet.Cells[row, dataMapInfo.DurationCellIndex].Value;
						var startTimeValue = programSheet.Cells[row, dataMapInfo.StartTimeCellIndex].Value;
						var startTime = DateTime.ParseExact(startTimeValue.ToString(), "H:mm:ss", null);
						var reportTimeValue = programSheet.Cells[row, dataMapInfo.ReportTimeCellIndex].Value;
						var reportTime = DateTime.ParseExact(reportTimeValue.ToString(), "H:mm:ss", null);
						//var reportTime = startTime;
						//var durationSpan = new TimeSpan(0, duration.Minute, duration.Second);
						var durationSpan = new TimeSpan(0, 5, 0);
						var serialNumber = 0;
						Int32.TryParse(serialNumberValue.ToString(), out serialNumber);
						
						var program = new Program(serialNumber, name, choreographerName, reportTime, startTime, durationSpan);
						var participants = programSheet.Cells[row, dataMapInfo.ParticipantsCellIndex].Value as string;
						foreach (var participant in participants.Split(new string[] { "\r\n\t" }, StringSplitOptions.None))
						{
							program.AddParticipant(new Participant(participant));
						}

						yield return program;
					}
				}
				
			}
		}
	}
}
