using ExtractProgramSchedule.Repository;

namespace ExtractProgramSchedule
{
	class MainProgram
	{
		static void Main(string[] args)
		{
			ServiceLocator.Initialize();
			var repository = ServiceLocator.Resolve<IDataRepository>();
			foreach (var program in repository.Load(@"c:\temp\2017 Ugadi Program Sequence - Final.xlsx"))
			{
				System.Console.WriteLine(program);
			}
		}
	}
}
