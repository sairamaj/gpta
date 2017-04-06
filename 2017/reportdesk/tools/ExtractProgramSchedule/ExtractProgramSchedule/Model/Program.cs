namespace ExtractProgramSchedule.Model
{
	public class Program
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="Program"/> class.
		/// </summary>
		/// <param name="name">Program name.</param>
		/// <param name="number">Program number</param>
		public Program(string name, int number)
		{
			this.Name = name;
			this.SequenceNumber = number;
		}

		/// <summary>
		/// Gets program name
		/// </summary>
		public string Name { get; private set; }

		/// <summary>
		/// Gets sequence number.
		/// </summary>
		public int SequenceNumber { get; private set; }

		public override string ToString()
		{
			return string.Format("{0}-{1}", SequenceNumber, Name);
		}
	}
}
