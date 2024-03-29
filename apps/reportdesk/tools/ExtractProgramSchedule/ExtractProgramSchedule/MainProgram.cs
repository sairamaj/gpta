using System.Reflection;
using ExtractProgramSchedule.Repository;

namespace ExtractProgramSchedule
{
	class MainProgram
	{
		static void Main(string[] args)
		{
			if (args.Length < 2)
			{
				System.Console.WriteLine("{0} programsheetfilename sheetName", Assembly.GetExecutingAssembly().GetName().Name);
				System.Environment.Exit(-2);
			}
			ServiceLocator.Initialize();
			var excelFileName = args[0];
			var sheetName = args[1];

			var repository = ServiceLocator.Resolve<IDataRepository>();
			foreach (var program in repository.Load(excelFileName, sheetName))
			{
				System.Console.WriteLine("#program|{0}|{1}|{2}|{3}|{4}|{5}|{6}",
					program.Name, 
					program.SequenceNumber,
					program.ChoreographerName, 
					program.StartTime.ToString("HH:mm:ss"),
					program.GreenRoomTime.ToString("HH:mm:ss"),
					program.ReportTime.ToString("HH:mm:ss"), 
					program.Duration);
				System.Console.WriteLine("");
				foreach (var p in program.Participants)
				{
					System.Console.WriteLine($"{p.Name}");
				}
				System.Console.WriteLine("");
			}
		}
	}
}
