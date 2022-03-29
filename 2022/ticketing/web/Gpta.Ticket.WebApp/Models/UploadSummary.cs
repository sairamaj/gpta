using System.Collections.Generic;

namespace Gpta.Ticket.WebApp.Models
{
    public class UploadSummary
    {
        public UploadSummary(
            string status,
            int totalParsed,
            int totalFailed,
            IEnumerable<FailedLineInfo> failedLines)
        {
            this.Status = status;
            this.TotalLinesParsed = totalParsed;
            this.TotalLinesParsedFailed = totalFailed;
            this.FailedLines = failedLines;
        }

        public string Status { get; }
        public IEnumerable<FailedLineInfo> FailedLines { get; }
        public int TotalLinesParsed { get; }
        public int TotalLinesParsedFailed { get; }
    }
}