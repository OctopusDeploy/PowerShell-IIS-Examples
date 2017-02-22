using System.Linq;
using System.Text.RegularExpressions;
using Serilog;

namespace ExampleRunner.Generation
{
    public static class ExampleParser
    {
        public static Example Parse(string scriptContents)
        {
            var match = ParserRegex.Match(scriptContents);
            if (!match.Success)
            {
                // Fail
            }

            var example = new Example
            {
                Code = match.Groups["example"].Value.Trim()
            };
            return example;
        }

        static readonly Regex ParserRegex = new Regex(@"# Meta:
# Whatever in the middle
.*?

# Example:
\#\s-----+\r\n
\#\s*Example\s*\r\n
\#\s-----+\r\n
(?<example>.*?)
(?=\#\s-----+)

", RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);
    }
}
