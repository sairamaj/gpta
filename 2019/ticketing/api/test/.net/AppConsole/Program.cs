using System;
using System.Collections.Generic;
using Pathoschild.Http.Client;

namespace AppConsole
{
    class Ticket{
        public String Name {get; set;}
    }

    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            var client = new FluentClient("http://localhost:4000");
            var tickets = client.GetAsync("/tickets").As<IEnumerable<Ticket>>().Result;
            foreach(var ticket in tickets){
                System.Console.WriteLine(ticket.Name);
            }
        }
    }
}
