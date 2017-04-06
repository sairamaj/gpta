using System.Reflection;
using ExtractProgramSchedule.Repository;

namespace ExtractProgramSchedule
{
	class MainProgram
	{
		static void Main(string[] args)
		{
			if (args.Length < 1)
			{
				System.Console.WriteLine("{0} programsheetfilename", Assembly.GetExecutingAssembly().GetName().Name);
				System.Environment.Exit(-2);
			}
			ServiceLocator.Initialize();
			var repository = ServiceLocator.Resolve<IDataRepository>();
			foreach (var program in repository.Load(args[0]))
			{
				System.Console.WriteLine("#program|{0}|{1}|{2}|{3}|{4}",program.Name, program.ChoreographerName, program.ReportTime.ToString("HH:mm:ss"), program.StartTime.ToString("HH:mm:ss"), program.Duration);
				System.Console.WriteLine("");
				foreach (var p in program.Participants)
				{
					System.Console.WriteLine("     {0}", p.Name);
				}
				System.Console.WriteLine("");
			}
		}
	}
}
