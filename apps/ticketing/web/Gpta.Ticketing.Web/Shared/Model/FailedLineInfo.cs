public class FailedLineInfo
{
    public FailedLineInfo(string line, int lineNumber, string reason)
    {
        this.Line = line;
        this.LineNumber = lineNumber;
        this.Reason = reason;
    }

    public string Line { get; }
    public int LineNumber { get; }
    public string Reason { get; }
}