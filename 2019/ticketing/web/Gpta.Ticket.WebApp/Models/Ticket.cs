namespace Gpta.Ticket.WebApp.Models{
    public class Ticket
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public int Adults { get; set; }
        public int Kids { get; set; }

        public override string ToString()
        {
            return $"Id={Id} Name={Name} Adults={Adults} Kids={Kids}";
        }


        public static Ticket Parse(string info)
        {
            const int adultCountIndex = 0;
            const int kidCountIndex = 1;
            const int nameIndex = 5;
            const int confirmationIndex = 14;
            if (string.IsNullOrWhiteSpace(info))
            {
                return null;
            }

            if (info.Split(',').Length < confirmationIndex)
            {
                throw new System.ArgumentException($"{info} does not contain ${confirmationIndex} parts");
            }

            return new Ticket
            {
                Name = info.Split(',')[nameIndex],
                Adults = System.Convert.ToInt32(info.Split(',')[adultCountIndex]),
                Kids = System.Convert.ToInt32(info.Split(',')[kidCountIndex]),
                Id = info.Split(',')[confirmationIndex]
            };
        }
    }
}