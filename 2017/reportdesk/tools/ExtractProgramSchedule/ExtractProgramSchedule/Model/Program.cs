using System;
using System.Collections.Generic;

namespace ExtractProgramSchedule.Model
{
	internal class Program
	{
		private List<Participant> _participants = new List<Participant>();

		/// <summary>
		/// Initializes a new instance of the <see cref="Program"/> class.
		/// </summary>
		/// <param name="name">Program name.</param>
		/// <param name="number">Program number</param>
		public Program(int number, string name, string choreographerName, DateTime reportTime, DateTime startTime, TimeSpan duration )
		{
			this.Name = name;
			this.SequenceNumber = number;
			if (choreographerName != null)
			{
				var trimStrings = new string[] { "-choreographer", "/Choreographers", "/Choreogrpaher", "Choreographer"};
				
				foreach (var trimString in trimStrings)
				{
					var index = choreographerName.IndexOf(trimString);
					if (index > 0)
					{
						choreographerName = choreographerName.Substring(0, index);
					}
				}

				choreographerName = choreographerName.Trim(new char[] {' ', '-', '/' });
			}
			this.ChoreographerName = choreographerName;
			this.ReportTime = reportTime;
			this.StartTime = startTime;
			this.Duration = duration;
		}

		/// <summary>
		/// Gets program name
		/// </summary>
		public string Name { get; private set; }

		/// <summary>
		/// Gets sequence number.
		/// </summary>
		public int SequenceNumber { get; private set; }

		public string ChoreographerName { get; set; }

		public TimeSpan Duration { get; set; }
		public DateTime ReportTime { get; set; }
		public DateTime StartTime { get; set; }

		public IEnumerable<Participant> Participants
		{
			get
			{
				return _participants;
			}
		}


		public override string ToString()
		{
			return string.Format("{0}-{1}", SequenceNumber, Name);
		}

		public void AddParticipant(Participant p)
		{
			_participants.Add(p);
		}
	}
}
