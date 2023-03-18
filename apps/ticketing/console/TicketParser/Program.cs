// See https://aka.ms/new-console-template for more information
if( args.Length < 0)
{
    System.Console.WriteLine($"Usage TicketParser filename");
    return;
}

foreach(var line in File.ReadAllLines(args[0])){
    var ticket = Parser.Parse(line);
    if(ticket != null)
    {
        System.Console.WriteLine(ticket);
    }
}
