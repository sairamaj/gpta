using System.Collections.Generic;
using ExtractProgramSchedule.Model;

namespace ExtractProgramSchedule.Repository
{
	internal interface IDataRepository
	{
		IEnumerable<Program> Load(string file);
	}
}
