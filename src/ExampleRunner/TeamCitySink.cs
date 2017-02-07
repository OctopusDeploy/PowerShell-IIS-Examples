using System;
using Serilog.Core;
using Serilog.Events;

namespace ExampleRunner
{
    class TeamCitySink : ILogEventSink
    {
        public void Emit(LogEvent logEvent)
        {
            if (logEvent.Level >= LogEventLevel.Warning)
            {
                var formatter = new JetBrains.TeamCity.ServiceMessages.Write.ServiceMessageFormatter();
                var formatted = formatter.FormatMessage("message",
                    new
                    {
                        status = TranslateStatus(logEvent.Level),
                        text = logEvent.RenderMessage()
                    });
                Console.WriteLine(formatted);
            }
        }

        static string TranslateStatus(LogEventLevel logEventLevel)
        {
            // The status attribute may take following values: NORMAL, WARNING, FAILURE, ERROR. The default value is NORMAL.
            switch (logEventLevel)
            {
                default:
                    return "NORMAL";
                case LogEventLevel.Warning:
                    return "WARNING";
                case LogEventLevel.Error:
                    return "ERROR";
                case LogEventLevel.Fatal:
                    return "FAILURE";
            }
        }
    }
}