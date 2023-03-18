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
}
