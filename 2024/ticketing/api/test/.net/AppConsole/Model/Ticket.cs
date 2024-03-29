using System;

namespace AppConsole.Model
{
    class Ticket
    {
        public string Id { get; set; }
        public String Name { get; set; }
        public int Adults { get; set; }
        public int Kids { get; set; }

        public override string ToString()
        {
            return $"Id={Id} Name={Name} Adults={Adults} Kids={Kids}";
        }
    }
}