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
        static readonly Regex FileNameFilterRegex = new Regex("^[^_].*\\.ps1$");

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
                foreach (var file in GetScriptFiles())
                {
                    Log.Information("Parsing {file}", file);
                    var example = ExampleParser.Parse(File.ReadAllText(file));
                    exampleWriter.Write(example);
                }
            }
            Log.Information("Docs written to: {output}", OutputFile);
        }

        static void RunAllExamples()
        {
            Log.Information("Running tests...");

            foreach (var file in GetScriptFiles())
            {
                Log.Information("Running test: {file}", file);
                ScriptRunner.RunScript(file);
            }
            Log.Information("Test run complete");
        }

        static IEnumerable<string> GetScriptFiles()
        {
            return (
                from file in Directory.GetFiles(Environment.CurrentDirectory, "*", SearchOption.AllDirectories)
                let relative = file.Substring(Environment.CurrentDirectory.Length + 1)
                let fileName = Path.GetFileName(file)
                where FileNameFilterRegex.IsMatch(fileName)
                select relative).OrderBy(f => f, StringComparer.OrdinalIgnoreCase).ToList();
        }
    }
}
