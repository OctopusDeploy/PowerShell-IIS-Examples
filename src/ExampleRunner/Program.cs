using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using ExampleRunner.Generation;
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
            var files = Directory.GetFiles(Environment.CurrentDirectory, "*", SearchOption.AllDirectories)
                .OrderBy(f => f, StringComparer.OrdinalIgnoreCase)
                .ToList();

            var examples = 
                from file in files
                let fileName = Path.GetFileName(file)
                where FileNameFilterRegex.IsMatch(fileName)
                let contents = File.ReadAllText(file)
                select ExampleParser.Parse(contents);

            using (var streamWriter = new StreamWriter(OutputFile))
            using (var exampleWriter = new ExampleWriter(streamWriter))
            {
                foreach (var example in examples) exampleWriter.Write(example);
            }
        }

        static void RunAllExamples()
        {

        }
    }

    internal class ExampleWriter : IDisposable
    {
        readonly TextWriter writer;

        public ExampleWriter(TextWriter writer)
        {
            this.writer = writer;
        }

        public void Write(Example example)
        {
            writer.Write("#### ");
            writer.WriteLine(example.Title);
            writer.WriteLine();
            writer.WriteLine(example.Description);
            writer.WriteLine();
            writer.WriteLine("```powershell");
            writer.WriteLine(example.Code);
            writer.WriteLine("```");
        }

        public void Dispose()
        {
            writer.Dispose();
        }
    }
}
