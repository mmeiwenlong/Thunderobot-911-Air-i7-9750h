// In config ACPI, _OSI renamed XOSI
// Find:     5F4F5349
// Replace:  584F5349
// TgtBridge:no
// Search "_OSI" in Method (_INI....
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "XOSI", 0)
{
#endif
    Method(XOSI, 1)
    {
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP1",     // Windows XP SP1
            "Windows 2001 SP2",     // Windows XP SP2
            "Windows 2001.1",       // Windows Server 2003
            "Windows 2001.1 SP1",   // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            "Windows 2013",         // Windows 8.1/Windows Server 2012 R2
            "Windows 2015",
            "Windows 2016",
            "Windows 2017",
            "Windows 2017.2",
            "Windows 2018",
            "Windows 2018.2",
        }        
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
