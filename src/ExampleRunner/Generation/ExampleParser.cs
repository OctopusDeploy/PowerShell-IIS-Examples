using System.Linq;
using System.Text.RegularExpressions;

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
                Title = NoNewlines(ParseMultilineComment(match.Groups["title"].Value)),
                Description = ParseMultilineComment(match.Groups["description"].Value),
                Code = match.Groups["example"].Value.Trim()
            };
            return example;
        }

        static string NoNewlines(string potentiallyMultipleLines)
        {
            return string.Join(" ", potentiallyMultipleLines.Split('\n').Select(s => s.Trim()));
        }

        static string ParseMultilineComment(string desc)
        {
            var lines = desc.Split('\n');
            return string.Join("\r\n", lines.Select(l => l.Trim().TrimStart('#').Trim())).Trim();
        }

        static readonly Regex ParserRegex = new Regex(@"# Meta:
\#\s-----+\r\n
\#\s*Title:\s*(?<title>.*?\r\n)
\#\s*Description:\s*
  (?<description>.*?)
(?=\#\s-----+)

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
