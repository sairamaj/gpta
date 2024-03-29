using System.Text.Json;

namespace Gpta.Ticketing.Web.Shared;

public class Ticket
{
    public string? Id { get; set; }

    public string? Name { get; set; }

    public int Adults { get; set; }

    public int Kids { get; set; }

    public int Cost {get; set;}
    public int Member {get; set;}

    public static Ticket? Parse(string info)
    {
        // todo: parse header and get the positions.
        const int nameIndex = 0;
        const int confirmationIndex = 2;
        const int adultsIndex = 3;
        const int kidIndex = 4;
        const int costIndex = 5;
        const int memberIndex = 6;

        if (string.IsNullOrWhiteSpace(info))
        {
            return null;
        }

        if (info.Split(',').Length < memberIndex)
        {
            throw new System.ArgumentException($"{info} does not contain ${memberIndex} parts");
        }

        var parts = info.Split(',');
        if(!Int32.TryParse(parts[adultsIndex], out var adultsCount)){
            throw new FormatException($"Adults Count version error: val : |{parts[adultsIndex]}| cannot be converted to int");
        }
        if(!Int32.TryParse(parts[kidIndex], out var kidsCount)){
            throw new FormatException($"kidsIndex Count version error: val : |{parts[kidIndex]}| cannot be converted to int");
        }

        return new Ticket
        {
            Name = parts[nameIndex],
            Id = parts[confirmationIndex],
            Adults = TryConvert(parts[adultsIndex],adultsIndex),
            Kids = TryConvert(parts[kidIndex],kidIndex),
            Cost = TryConvert(parts[costIndex],costIndex),
            Member = TryConvert(parts[memberIndex],kidIndex),
        };
    }

    public override string ToString()
    {
        return JsonSerializer.Serialize(this);
    }

    private static int TryConvert(string val, int index){
        if(!Int32.TryParse(val, out var intVal)){
            throw new FormatException($"{index}  error: val : |{val}| cannot be converted to int");
        }

        return intVal;
    }
}
