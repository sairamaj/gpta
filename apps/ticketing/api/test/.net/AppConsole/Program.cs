using System;
using System.Collections.Generic;
using System.CommandLine;
using System.CommandLine.Invocation;
using AppConsole.Model;
using AppConsole.Repository;

namespace AppConsole
{

    class Program
    {
        static int Main(string[] args)
        {
            // Create some options and a parser
            Option listOption = new Option(
                "--list",
                "List the tickets");
            Option checkInOption = new Option(
                        "--checkin",
                        "name", new Argument<string>(defaultValue: ""));

            var rootCommand = new RootCommand();
            rootCommand.Description = "Ticket App Console";
            rootCommand.AddOption(listOption);
            rootCommand.AddOption(checkInOption);

            rootCommand.Handler = CommandHandler.Create<string>((list) =>
                {
                    Console.WriteLine($"List tickets");
                });
            rootCommand.Handler = CommandHandler.Create<string>(async (name) =>
                            {
                                var repository = new TicketRepository("http://localhost:4000");
                                var tickets = repository.GetTicketsAsync().Result;
                                DisplayTickets(tickets);

                                foreach (var ticket in tickets)
                                {
                                    ticket.Adults += 2;
                                    ticket.Kids += 2;
                                }

                                // Update
                                await repository.AddTicketsAsync(tickets);
                                System.Console.WriteLine("Press any key to quit...");
                                System.Console.ReadLine();

                                DisplayTickets(repository.GetTicketsAsync().Result);

                            });
            return rootCommand.InvokeAsync(args).Result;
        }

        private static void DisplayTickets(IEnumerable<Ticket> tickets)
        {
            foreach (var ticket in tickets)
            {
                System.Console.WriteLine(ticket);
            }
        }
    }
}
