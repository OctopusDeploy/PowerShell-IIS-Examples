using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using ExampleRunner.Generation;
using ExampleRunner.Testing;
using Serilog;
using Serilog.Events;

namespace ExampleRunner
{
    class Program
    {
        static readonly string ExamplesDirectory = Path.GetFullPath("..\\..\\..\\..\\examples");
        static readonly string OutputFile = Path.GetFullPath("..\\..\\..\\..\\out.md");
        static readonly Regex FileNameFilterRegex = new Regex("^[^_].*README\\.md$", RegexOptions.IgnoreCase);

        static void Main(string[] args)
        {
            Initialize();
            EnsureExamplesDirectory();            
            GenerateDocumentation();
            RunAllExamples();
        }

        static void Initialize()
        {
            Log.Logger = new LoggerConfiguration()
                .WriteTo.LiterateConsole(outputTemplate: "[{Level:U3}] {Indent}{Message}{NewLine}{Exception}", restrictedToMinimumLevel: LogEventLevel.Debug)
                .WriteTo.Sink<TeamCitySink>()
                .Enrich.FromLogContext()
                .CreateLogger();
        }

        static void EnsureExamplesDirectory()
        {
            if (!Directory.Exists(ExamplesDirectory))
            {
                Log.Error("Expected to find examples directory at {examples}", ExamplesDirectory);
                Environment.Exit(1);
            }

            Environment.CurrentDirectory = ExamplesDirectory;
        }

        static void GenerateDocumentation()
        {
            Log.Information("Generating docs");
            using (var streamWriter = new StreamWriter(OutputFile))
            using (var exampleWriter = new ExampleWriter(streamWriter))
            {
                foreach (var example in GetExampleFiles())
                {
                    Log.Information("Parsing {file}", Path.GetFileNameWithoutExtension(example.WebExampleScriptFile));
                    exampleWriter.WriteIntroduction(File.ReadAllText(example.IntroductionMarkdownFile));
                    if (example.WebExampleScriptFile != null)
                        exampleWriter.WriteExample("WebAdministration", ExampleParser.Parse(File.ReadAllText(example.WebExampleScriptFile)));
                    if (example.IisExampleScriptFile != null)
                        exampleWriter.WriteExample("IISAdministration", ExampleParser.Parse(File.ReadAllText(example.IisExampleScriptFile)));
                }
            }
            Log.Information("Docs written to: {output}", OutputFile);
        }

        static void RunAllExamples()
        {
            Log.Information("Running tests...");

            foreach (var example in GetExampleFiles())
            {
                if (example.WebExampleScriptFile != null) RunTest(example.WebExampleScriptFile);
                if (example.IisExampleScriptFile != null) RunTest(example.IisExampleScriptFile);
            }

            Log.Information("Test run complete");
        }

        static void RunTest(string file)
        {
            Log.Information("Running test: {file}", file);
            ScriptRunner.RunScript(file);
        }

        static IEnumerable<ExampleFileSet> GetExampleFiles()
        {
            return (
                from file in Directory.GetFiles(Environment.CurrentDirectory, "*", SearchOption.AllDirectories)
                let fileName = Path.GetFileName(file)
                where string.Equals(fileName, "README.md", StringComparison.OrdinalIgnoreCase)
                let directory = Path.GetDirectoryName(file)
                where directory != null
                let webExample = Path.Combine(directory, "Web.ps1")
                let iisExample = Path.Combine(directory, "IIS.ps1")
                orderby directory
                select new ExampleFileSet
                {
                    IntroductionMarkdownFile = file,
                    WebExampleScriptFile = File.Exists(webExample) ? webExample : null,
                    IisExampleScriptFile = File.Exists(iisExample) ? iisExample : null
                }).ToList();
        }
    }

    public class ExampleFileSet
    {
        public string IntroductionMarkdownFile { get; set; }
        public string WebExampleScriptFile { get; set; }
        public string IisExampleScriptFile { get; set; }
    }
}
