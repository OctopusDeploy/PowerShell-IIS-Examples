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