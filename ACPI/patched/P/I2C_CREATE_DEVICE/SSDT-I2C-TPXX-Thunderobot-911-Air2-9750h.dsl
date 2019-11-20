// In config ACPI, I2C1.TPD0:_STA to XSTA
// Find:     5F535441
// Replace:  58535441
// TgtBridge:54504430
//
// I2C1.TPxx is my new's device
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "I2C-TPXX", 0)
{
#endif
    External(_SB.PCI0.I2C1.TPD0, DeviceObj)
    External(_SB.PCI0.I2C1, DeviceObj)
    External (_SB_.INUM, MethodObj)
    External (_SB_.PCI0.HIDD, MethodObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (HIDG, IntObj)
    External (BDID, IntObj)
    External (B8ID, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC0.II2C, FieldUnitObj)
    
    //path:_SB.PCI0.I2C1.TPD0
    Scope (_SB.PCI0.I2C1.TPD0)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Store (BDID, Local0)
                And (Local0, 0x61, Local0)
                If (LAnd (LEqual (Local0, 0x21), LEqual (B8ID, Zero)))
                {
                    Store (One, ^^^LPCB.EC0.II2C)
                    Return (0x0F)
                }

                If (LAnd (LEqual (Local0, 0x41), LEqual (B8ID, One)))
                {
                    Store (One, ^^^LPCB.EC0.II2C)
                    Return (0x0F)
                }

                If (LEqual (Local0, 0x60))
                {
                    Store (One, ^^^LPCB.EC0.II2C)
                    Return (0x0F)
                }

                If (LEqual (Local0, 0x61))
                {
                    Store (One, ^^^LPCB.EC0.II2C)
                    Return (0x0F)
                }

                Store (Zero, ^^^LPCB.EC0.II2C)
                Return (Zero)
            }
        }
    }
    
    //path:_SB.PCI0.I2C1
    Scope (_SB.PCI0.I2C1)
    {
        Device (TPXX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0020, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, _Y38, Exclusive,
                    )
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y39)
                {
                    0x00000000,
                }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y38._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y38._SPE, SPED)  // _SPE: Speed
            CreateDWordField (SBFI, \_SB.PCI0.I2C1.TPXX._Y39._INT, INT2)  // _INT: Interrupts
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                Store (INUM (0x0301000F), INT2)
                Store ("SYN1B8B", _HID)
                Store (0x2C, BADR)
                Store (0x20, HID2)
                Store (0x00061A80, SPED)
                Return (Zero)
            }

            Name (_HID, "XXXX0000")  // _HID: Hardware ID
            Name (_CID, "PNP0C50")  // _CID: Compatible ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg0, HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                Return (Buffer (One)
                {
                     0x00                                           
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
               If (_OSI ("Darwin"))
               {
                   Return (0x0F)
               }
               Else
               {
                   Return (Zero)
               }
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ConcatenateResTemplate (SBFB, SBFI))
            }
        }
    } 
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF