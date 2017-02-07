using System;
using System.IO;
using System.Text;
using JetBrains.TeamCity.ServiceMessages.Write;
using JetBrains.TeamCity.ServiceMessages.Write.Special.Impl;
using JetBrains.TeamCity.ServiceMessages.Write.Special.Impl.Writer;

namespace ExampleRunner.Testing
{
    public class ScriptRunner
    {
        public static void RunScript(string fileName)
        {
            var cwd = Environment.CurrentDirectory;
            try
            {
                var fullPath = Path.GetFullPath(fileName);
                var directory = Path.GetDirectoryName(fullPath) ?? Environment.CurrentDirectory;

                using (var scope = new TestScope(fileName))
                {
                    var exitCode = SilentProcessRunner.ExecuteCommand(
                        "PowerShell.exe", 
                        FormatCommandArguments(fullPath), 
                        directory, 
                        scope.StdOut,
                        scope.StdErr
                    );
                    scope.Exited(exitCode);
                }
            }
            finally
            {
                Environment.CurrentDirectory = cwd;
            }
        }

        public static string FormatCommandArguments(string scriptFile)
        {
            var commandArguments = new StringBuilder();
            commandArguments.Append("-NoLogo ");
            commandArguments.Append("-NonInteractive ");
            commandArguments.Append("-ExecutionPolicy Unrestricted ");
            var escapedBootstrapFile = scriptFile.Replace("'", "''");
            commandArguments.AppendFormat("-Command \"Try {{. {{. '{0}'; if ((test-path variable:global:lastexitcode)) {{ exit $LastExitCode }}}};}} catch {{ throw }}\"", escapedBootstrapFile);
            return commandArguments.ToString();
        }

        class TestScope : IDisposable
        {
            readonly TeamCityTestWriter testWriter;

            public TestScope(string testName)
            {
                testWriter = new TeamCityTestWriter(new ServiceMessagesWriter(new ServiceMessageFormatter(), Console.WriteLine), testName, new NullDisposable());
                testWriter.OpenTest();
            }

            public void StdOut(string line)
            {
                testWriter.WriteStdOutput(line);
            }

            public void StdErr(string line)
            {
                testWriter.WriteErrOutput(line);
            }

            public void Exited(int exit)
            {
                if (exit != 0)
                    testWriter.WriteFailed("Exited with code " + exit, "");
            }

            public void Dispose()
            {
                testWriter.Dispose();
            }
        }

        class NullDisposable : IDisposable { public void Dispose() {} }
    }
}
