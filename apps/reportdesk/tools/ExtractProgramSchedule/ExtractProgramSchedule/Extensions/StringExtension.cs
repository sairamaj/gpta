
using OfficeOpenXml.FormulaParsing.Utilities;
using System;
using System.Text;

namespace ExtractProgramSchedule.Extensions
{
	internal static class StringExtension
	{
		public static string FixParticipantName(this string name)
		{
			var val = name.Trim();
			if (val.Equals("Girls") || val.Equals("Boys"))
			{
				return null;
			}

			//Console.WriteLine("------------------------");
			//System.Console.WriteLine($"name:|{name}|");
			var val1 = string.Empty;
			for (var i = 0; i < val.Length; i++)
			{
				if (char.IsDigit(val[i]) || val[i] == '.')
				{
					// skip
				}
				else
				{
					val1 += val[i];
				}
			}
			//Console.WriteLine(); 
			//Console.WriteLine("------------------------");
			//Console.ReadLine();
			
			return val1.Trim();
		}
	}
}
