using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ExcelLibrary.SpreadSheet;
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
					var serialNumber = programSheet.Cells[row, dataMapInfo.SequenceNumberCellIndex].Value ;
					if (serialNumber != null)
					{
						yield return new Program(name, Convert.ToInt32(serialNumber.ToString()));
					}
				}
				
			}
		}
	}
}
