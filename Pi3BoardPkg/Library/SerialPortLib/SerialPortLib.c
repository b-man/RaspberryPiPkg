/** @file
*
*  Serial I/O Port library functions with no library constructor/destructor
*
*  Copyright (c), Microsoft Corporation. All rights reserved.
*
*  This program and the accompanying materials
*  are licensed and made available under the terms and conditions of the BSD License
*  which accompanies this distribution.  The full text of the license may be found at
*  http://opensource.org/licenses/bsd-license.php
*
*  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
*  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
*
**/

#include <Uefi.h>

#include <Base.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DebugLib.h>
#include <Library/SerialPortLib.h>
#include <Library/PcdLib.h>
#include <Library/IoLib.h>
#include <Bcm2836.h>
#include <BcmMailbox.h>


/* Baud rate for 115,200 */
/*
//        core_clock_freq
// baud = -----------------
//        8 x (baud_reg + 1)
//
// or,
//
//            { core_clock_freq }
// baud_reg = {-----------------} - 1
//            {    8 x baud     }
//
// If core clock is 250MHz, for baud rate of 115,200 baud_reg is reg=270 (actually, 115,313)
*/
#define MINI_UART_DEF_CLOCK_HZ              (250000000)
#define MINI_UART_DEF_BAUD_RATE_BPS         (921600)


/*

  Programmed hardware of Serial port.

**/
RETURN_STATUS
EFIAPI
SerialPortInitialize (
  VOID
  )
{
    static BOOLEAN g_bInitComplete = 0;
    EFI_STATUS Status;
    UINT32 UartClockHz = MINI_UART_DEF_CLOCK_HZ;

    if (g_bInitComplete)
    {
        return RETURN_SUCCESS;
    }

    /* Enable the UART 1 */
    {
        UINT32 u32AUXENB = MmioRead32(AUX_AUXENB);

        u32AUXENB |= AUX_AUXENB_MINIUART_BIT;
        MmioWrite32(AUX_AUXENB, u32AUXENB);
    }

    //
    // Setup the UART
    //

    //
    // UART clock:
    // UART1 uses core clock, so we query the clock frequency
    // to setup the UART baud rate.
    //
    {
        // Ensure 16 byte alignment
        MAILBOX_GET_CLOCK_RATE MbGcr __attribute__((aligned(16)));

        ZeroMem((void*)&MbGcr, sizeof(MbGcr));
        MbGcr.Header.BufferSize = sizeof(MbGcr);
        MbGcr.Header.TagID = TAG_GET_CLOCK_RATE;
        MbGcr.Header.TagLength = 8;
        MbGcr.ClockId = CLOCK_ID_CORE;

        Status = MailboxProperty(
            MAILBOX_CHANNEL_PROPERTY_ARM_VC,
            (MAILBOX_HEADER*)&MbGcr
            );
        if (EFI_ERROR(Status))
        {
            return Status;
        }

        UartClockHz = MbGcr.Rate;
    }

    // Baud rate
    {
        UINT32 BaudRateReg;
        UINT32 BaudRateValue = (UINT32)FixedPcdGet64(PcdUartDefaultBaudRate);

        if (BaudRateValue == 0)
        {
            BaudRateValue = MINI_UART_DEF_BAUD_RATE_BPS;
        }
        BaudRateReg = (UartClockHz / 8 / BaudRateValue) - 1;

        MmioWrite32(AUX_MU_BAUD_REG, BaudRateReg);
    }

    // Data bits
    {
        UINT32 DataBits = FixedPcdGet8(PcdUartDefaultDataBits);
        switch (DataBits)
        {
        case 7:
            MmioWrite32(AUX_MU_LCR_REG, 0x00); /* 7-bit mode */
            break;
        case 8:
            /* There is BCM2635 datasheet errata on the web: http://elinux.org/BCM2835_datasheet_errata */
            /* Here, we need to set the proper 16550 value of 0x03, not 0x01, to get 8 bits */

            MmioWrite32(AUX_MU_LCR_REG, 0x03); /* 8-bit mode */
            break;
        default:
            return RETURN_INVALID_PARAMETER;
        }
    }

    // Parity
    {
        UINT32 IsParityCheckNone = FixedPcdGet8(PcdUartDefaultParity);

        //
        // Mini UART does not provide interface for settings
        // parity check to other than 'none'.
        //
        if (IsParityCheckNone != 1)
        {
            return RETURN_INVALID_PARAMETER;
        }
    }

    // Stop bits
    {
        UINT32 StopBits = FixedPcdGet8(PcdUartDefaultStopBits);

        //
        // Mini UART does not provide interface for settings
        // stop bits to other than 1.
        //
        if (StopBits != 1)
        {
            return RETURN_INVALID_PARAMETER;
        }
    }

    /* Read any pending character from the input FIFO */
    MmioRead32(AUX_MU_IO_REG);

    /* Test output */
    SerialPortWrite( (UINT8 *) "UART1\r\n", 7);

    g_bInitComplete = TRUE;

    return RETURN_SUCCESS;
}


/**
  Write data to serial device.

  @param  Buffer           Point of data buffer which need to be written.
  @param  NumberOfBytes    Number of output bytes which are cached in Buffer.

  @retval 0                Write data failed.
  @retval !0               Actual number of bytes written to serial device.

**/
UINTN
EFIAPI
SerialPortWrite (
  IN UINT8     *Buffer,
  IN UINTN     NumberOfBytes
)
{
    UINTN   Count;

    for (Count = 0; Count < NumberOfBytes; Count++, Buffer++) 
    {

        /* Wait for space in the FIFO */
        while ((MmioRead32(AUX_MU_STAT_REG) & 0x02) == 0)
        {
        }

        /* Write out a character */
        MmioWrite32(AUX_MU_IO_REG, *Buffer);
    }

    return NumberOfBytes;
}


/**
  Read data from serial device and save the data in buffer.

  @param  Buffer           Point of data buffer which need to be written.
  @param  NumberOfBytes    Number of output bytes which are cached in Buffer.

  @retval 0                Read data failed.
  @retval !0               Actual number of bytes read from serial device.

**/
UINTN
EFIAPI
SerialPortRead (
  OUT UINT8     *Buffer,
  IN  UINTN     NumberOfBytes
)
{
    UINTN   Count;

    for (Count = 0; Count < NumberOfBytes; Count++, Buffer++) 
    {

        /* Wait for character in the FIFO */
        while ((MmioRead32(AUX_MU_STAT_REG) & 0x01) == 0)
        {
        }

        /* Load the character into the buffer */
        *Buffer = (UINT8) (MmioRead32(AUX_MU_IO_REG));
    }

    return NumberOfBytes;
}


/**
  Polls a serial device to see if there is any data waiting to be read.

  Polls a serial device to see if there is any data waiting to be read.
  If there is data waiting to be read from the serial device, then TRUE is returned.
  If there is no data waiting to be read from the serial device, then FALSE is returned.

  @retval TRUE             Data is waiting to be read from the serial device.
  @retval FALSE            There is no data waiting to be read from the serial device.

**/
BOOLEAN
EFIAPI
SerialPortPoll (
  VOID
  )
{
    if ((MmioRead32(AUX_MU_STAT_REG) & 0x01) != 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}


/**
  Sets the control bits on a serial device.

  @param Control                Sets the bits of Control that are settable.

  @retval RETURN_SUCCESS        The new control bits were set on the serial device.
  @retval RETURN_UNSUPPORTED    The serial device does not support this operation.
  @retval RETURN_DEVICE_ERROR   The serial device is not functioning correctly.

**/
RETURN_STATUS
EFIAPI
SerialPortSetControl (
  IN UINT32 Control
  )
{
  return RETURN_UNSUPPORTED;
}


/**
  Retrieve the status of the control bits on a serial device.

  @param Control                A pointer to return the current control signals from the serial device.

  @retval RETURN_SUCCESS        The control bits were read from the serial device.
  @retval RETURN_UNSUPPORTED    The serial device does not support this operation.
  @retval RETURN_DEVICE_ERROR   The serial device is not functioning correctly.

**/
RETURN_STATUS
EFIAPI
SerialPortGetControl (
  OUT UINT32 *Control
  )
{
  return RETURN_UNSUPPORTED;
}


/**
  Sets the baud rate, receive FIFO depth, transmit/receice time out, parity,
  data bits, and stop bits on a serial device.

  @param BaudRate           The requested baud rate. A BaudRate value of 0 will use the
                            device's default interface speed.
                            On output, the value actually set.
  @param ReveiveFifoDepth   The requested depth of the FIFO on the receive side of the
                            serial interface. A ReceiveFifoDepth value of 0 will use
                            the device's default FIFO depth.
                            On output, the value actually set.
  @param Timeout            The requested time out for a single character in microseconds.
                            This timeout applies to both the transmit and receive side of the
                            interface. A Timeout value of 0 will use the device's default time
                            out value.
                            On output, the value actually set.
  @param Parity             The type of parity to use on this serial device. A Parity value of
                            DefaultParity will use the device's default parity value.
                            On output, the value actually set.
  @param DataBits           The number of data bits to use on the serial device. A DataBits
                            vaule of 0 will use the device's default data bit setting.
                            On output, the value actually set.
  @param StopBits           The number of stop bits to use on this serial device. A StopBits
                            value of DefaultStopBits will use the device's default number of
                            stop bits.
                            On output, the value actually set.

  @retval RETURN_SUCCESS            The new attributes were set on the serial device.
  @retval RETURN_UNSUPPORTED        The serial device does not support this operation.
  @retval RETURN_INVALID_PARAMETER  One or more of the attributes has an unsupported value.
  @retval RETURN_DEVICE_ERROR       The serial device is not functioning correctly.

**/
RETURN_STATUS
EFIAPI
SerialPortSetAttributes (
  IN OUT UINT64             *BaudRate,
  IN OUT UINT32             *ReceiveFifoDepth,
  IN OUT UINT32             *Timeout,
  IN OUT EFI_PARITY_TYPE    *Parity,
  IN OUT UINT8              *DataBits,
  IN OUT EFI_STOP_BITS_TYPE *StopBits
  )
{
  return RETURN_UNSUPPORTED;
}
