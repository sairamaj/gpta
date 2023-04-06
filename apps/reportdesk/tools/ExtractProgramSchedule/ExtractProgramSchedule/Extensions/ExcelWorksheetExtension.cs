using ExtractProgramSchedule.Repository;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExtractProgramSchedule.Extensions
{
	internal static class ExcelWorksheetExtension
	{
		public static T Get<T>(this ExcelWorksheet sheet, int row, int pos)
		{
			if (pos == -1)
			{
				return default(T);
			}

			var val = sheet.Cells[row, pos].Value;
			return (T)Convert.ChangeType(val, typeof(T));
		}
	}
}
