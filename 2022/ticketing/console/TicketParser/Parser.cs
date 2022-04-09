class Parser
{
    public static Ticket? Parse(string info)
    {
        // todo: parse header and get the positions.
        const int nameIndex = 0;
        const int confirmationIndex = 2;
        const int adultsIndex = 3;
        const int kidIndex = 4;

        if (string.IsNullOrWhiteSpace(info))
        {
            return null;
        }

        if (info.Split(',').Length < kidIndex)
        {
            throw new System.ArgumentException($"{info} does not contain ${kidIndex} parts");
        }

        var parts = info.Split(',');
        return new Ticket
        {
            Name = parts[nameIndex],
            Id = parts[confirmationIndex],
            Adults = Convert.ToInt32(parts[adultsIndex]),
            Kids = Convert.ToInt32(parts[kidIndex]),
        };
    }
}
