using System;
using System.IO;

namespace ExampleRunner.Generation
{
    internal class ExampleWriter : IDisposable
    {
        readonly TextWriter writer;

        public ExampleWriter(TextWriter writer)
        {
            this.writer = writer;
        }

        public void WriteIntroduction(string contents)
        {
            writer.WriteLine(contents);
        }

        public void WriteExample(string name, Example example)
        {
            writer.WriteLine("```powershell " + name);
            writer.WriteLine(example.Code);
            writer.WriteLine("```");
            writer.WriteLine();
        }

        public void Dispose()
        {
            writer.Dispose();
        }
    }
}