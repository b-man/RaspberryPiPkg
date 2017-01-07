#/** @file
# Pi2 board package.
#
#  Copyright (c), Microsoft Corporation. All rights reserved.
#
#  This program and the accompanying materials
#  are licensed and made available under the terms and conditions of the BSD License
#  which accompanies this distribution.  The full text of the license may be found at
#  http://opensource.org/licenses/bsd-license.php
#
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
#**/

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = Pi2BoardPkg
  PLATFORM_GUID                  = 91fa6c28-33df-46ac-aee6-292d6811ea31
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/Pi2Board
  SUPPORTED_ARCHITECTURES        = ARM
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = RaspberryPiPkg/Pi2BoardPkg/Pi2BoardPkg.fdf

[LibraryClasses.common]
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf
  ArmMmuLib|ArmPkg/Library/ArmMmuLib/ArmMmuBaseLib.inf
  ArmPlatformLib|RaspberryPiPkg/Pi2BoardPkg/Library/Pi2BoardLib/Pi2BoardLib.inf
  ArmCpuLib|ArmPkg/Drivers/ArmCpuLib/ArmCortexA9Lib/ArmCortexA9Lib.inf
  ArmPlatformStackLib|ArmPlatformPkg/Library/ArmPlatformStackLib/ArmPlatformStackLib.inf
  ArmSmcLib|ArmPkg/Library/ArmSmcLib/ArmSmcLib.inf

  ArmGenericTimerCounterLib|ArmPkg/Library/ArmGenericTimerPhyCounterLib/ArmGenericTimerPhyCounterLib.inf
  TimerLib|ArmPkg/Library/ArmArchTimerLib/ArmArchTimerLib.inf
  RealTimeClockLib|RaspberryPiPkg/Pi2BoardPkg/Library/VirtualRealTimeClockLib/VirtualRealTimeClockLib.inf

  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf

!if $(TARGET) == RELEASE
  # Comment/Uncomment to enable processing DEBUG messages and sending
  # them serially to the terminal
  DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  #DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
!else
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
!endif
  UncachedMemoryAllocationLib|ArmPkg/Library/UncachedMemoryAllocationLib/UncachedMemoryAllocationLib.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf

  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  MemoryInitPeiLib|ArmPlatformPkg/MemoryInitPei/MemoryInitPeiLib.inf

  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf

  EfiResetSystemLib|RaspberryPiPkg/Pi2BoardPkg/Library/ResetSystemLib/ResetSystemLib.inf

  PciLib|MdePkg/Library/BasePciLibCf8/BasePciLibCf8.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf

  EfiFileLib|EmbeddedPkg/Library/EfiFileLib/EfiFileLib.inf

  PeCoffGetEntryPointLib|MdePkg/Library/BasePeCoffGetEntryPointLib/BasePeCoffGetEntryPointLib.inf

  #
  # The Standard IO window in the JTAG debugger will show an entry for each loaded/unloaded module
  # that consists of the module symbol path and the module load address which is useful for JTAG
  # source-level debugging
  #
  #PeCoffExtraActionLib|ArmPkg/Library/DebugPeCoffExtraActionLib/DebugPeCoffExtraActionLib.inf
  PeCoffExtraActionLib|MdePkg/Library/BasePeCoffExtraActionLibNull/BasePeCoffExtraActionLibNull.inf

  CacheMaintenanceLib|ArmPkg/Library/ArmCacheMaintenanceLib/ArmCacheMaintenanceLib.inf
  DefaultExceptionHandlerLib|ArmPkg/Library/DefaultExceptionHandlerLib/DefaultExceptionHandlerLib.inf
  CpuExceptionHandlerLib|ArmPkg/Library/ArmExceptionLib/ArmExceptionLib.inf
  PrePiLib|EmbeddedPkg/Library/PrePiLib/PrePiLib.inf

  #
  # PL011 UART 0 is used for console output
  #
  PL011UartLib|ArmPlatformPkg/Drivers/PL011Uart/PL011Uart.inf
  SerialPortLib|ArmPlatformPkg/Library/PL011SerialPortLib/PL011SerialPortLib.inf

  SemihostLib|ArmPkg/Library/SemihostLib/SemihostLib.inf

  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf

  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  HobLib|MdePkg/Library/DxeHobLib/DxeHobLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf

  DxeServicesTableLib|MdePkg/Library/DxeServicesTableLib/DxeServicesTableLib.inf
  UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf

#
# Assume everything is fixed at build but system memory size
#
  PcdLib|RaspberryPiPkg/Pi2BoardPkg/Library/Pi2PcdLib/Pi2PcdLib.inf

  UefiRuntimeLib|MdePkg/Library/UefiRuntimeLib/UefiRuntimeLib.inf

  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf

  CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf

  LedLib|RaspberryPiPkg/Pi2BoardPkg/Library/BcmLedLib/BcmLedLib.inf
  BcmMailboxLib|RaspberryPiPkg/Pi2BoardPkg/Library/BcmMailboxLib/BcmMailboxLib.inf

  ArmDisassemblerLib|ArmPkg/Library/ArmDisassemblerLib/ArmDisassemblerLib.inf
  DebugAgentLib|MdeModulePkg/Library/DebugAgentLibNull/DebugAgentLibNull.inf
  DmaLib|ArmPkg/Library/ArmDmaLib/ArmDmaLib.inf

  FdtLib|EmbeddedPkg/Library/FdtLib/FdtLib.inf

  # Networking
  NetLib|MdeModulePkg/Library/DxeNetLib/DxeNetLib.inf

  # UEFI Shell
  ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  SortLib|MdeModulePkg/Library/BaseSortLib/BaseSortLib.inf
  FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf

  # Boot Manager dependencies
  UefiBootManagerLib|MdeModulePkg/Library/UefiBootManagerLib/UefiBootManagerLib.inf
  BootLogoLib|MdeModulePkg/Library/BootLogoLib/BootLogoLib.inf
  PlatformBootManagerLib|RaspberryPiPkg/Pi2BoardPkg/Library/PlatformBootManagerLib/PlatformBootManagerLib.inf
  CustomizedDisplayLib|MdeModulePkg/Library/CustomizedDisplayLib/CustomizedDisplayLib.inf

  # UiApp dependencies
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  FileExplorerLib|MdeModulePkg/Library/FileExplorerLib/FileExplorerLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf


[LibraryClasses.common.SEC]
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf
  ArmPlatformSecLib|RaspberryPiPkg/Pi2BoardPkg/Library/SecLib/SecLib.inf
  ArmTrustedMonitorLib|ArmPlatformPkg/Library/ArmTrustedMonitorLibNull/ArmTrustedMonitorLibNull.inf

  UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
  ExtractGuidedSectionLib|EmbeddedPkg/Library/PrePiExtractGuidedSectionLib/PrePiExtractGuidedSectionLib.inf
  LzmaDecompressLib|MdeModulePkg/Library/LzmaCustomDecompressLib/LzmaCustomDecompressLib.inf

  # Temp work around for Movt relocation issue.
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf

  HobLib|EmbeddedPkg/Library/PrePiHobLib/PrePiHobLib.inf
  PrePiHobListPointerLib|ArmPlatformPkg/Library/PrePiHobListPointerLib/PrePiHobListPointerLib.inf
  MemoryAllocationLib|EmbeddedPkg/Library/PrePiMemoryAllocationLib/PrePiMemoryAllocationLib.inf
  PlatformPeiLib|ArmPlatformPkg/PlatformPei/PlatformPeiLib.inf

[LibraryClasses.common.PEI_CORE]
  PcdLib|RaspberryPiPkg/Pi2BoardPkg/Library/Pi2PcdLib/Pi2PcdLib.inf
  ReportStatusCodeLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf

[LibraryClasses.common.DXE_CORE]
  HobLib|MdePkg/Library/DxeCoreHobLib/DxeCoreHobLib.inf
  MemoryAllocationLib|MdeModulePkg/Library/DxeCoreMemoryAllocationLib/DxeCoreMemoryAllocationLib.inf
  DxeCoreEntryPoint|MdePkg/Library/DxeCoreEntryPoint/DxeCoreEntryPoint.inf
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  ExtractGuidedSectionLib|MdePkg/Library/DxeExtractGuidedSectionLib/DxeExtractGuidedSectionLib.inf
  UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf

  PerformanceLib|MdeModulePkg/Library/DxeCorePerformanceLib/DxeCorePerformanceLib.inf

[LibraryClasses.common.DXE_DRIVER]
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  SecurityManagementLib|MdeModulePkg/Library/DxeSecurityManagementLib/DxeSecurityManagementLib.inf
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf

[LibraryClasses.common.UEFI_APPLICATION]
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  UefiDecompressLib|IntelFrameworkModulePkg/Library/BaseUefiTianoCustomDecompressLib/BaseUefiTianoCustomDecompressLib.inf
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf

[LibraryClasses.common.UEFI_DRIVER]
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  UefiDecompressLib|IntelFrameworkModulePkg/Library/BaseUefiTianoCustomDecompressLib/BaseUefiTianoCustomDecompressLib.inf
  ExtractGuidedSectionLib|MdePkg/Library/DxeExtractGuidedSectionLib/DxeExtractGuidedSectionLib.inf
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf

[LibraryClasses.common.DXE_RUNTIME_DRIVER]
  HobLib|MdePkg/Library/DxeHobLib/DxeHobLib.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibNull/DxeCapsuleLibNull.inf

  #
  # The Coff lib cannot be the PeCoffLib|EmbeddedPkg/Library/DxeHobPeCoffLib/DxeHobPeCoffLib.inf one
  # because it's rooted in PEI memory. As a result the call to SetVirtualAddressMap after ExitBootServices
  # will crash because the global memory (gPeCoffLoader) it uses is no longer mapped.
  #

  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf

[LibraryClasses.ARM]
  #
  # It is not possible to prevent the ARM compiler for generic intrinsic functions.
  # This library provides the instrinsic functions generate by a given compiler.
  # [LibraryClasses.ARM] and NULL mean link this library into all ARM images.
  #
  NULL|ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf

  #
  # Since software stack checking may be heuristically enabled by the compiler
  # include BaseStackCheckLib unconditionally.
  #
  NULL|MdePkg/Library/BaseStackCheckLib/BaseStackCheckLib.inf


[BuildOptions]
  XCODE:*_*_ARM_PLATFORM_FLAGS == -arch armv7

  GCC:*_*_ARM_PLATFORM_FLAGS == -march=armv7-a

  # Uncomment to allow generation of mixed source/assembly list files
  ; GCC:*_*_ARM_ARCHCC_FLAGS ==  -S -Wa,-adhlns="$@.lst" -fverbose-asm

  RVCT:*_*_ARM_PLATFORM_FLAGS == --cpu Cortex-A8

  *_*_*_CC_FLAGS = -DDISABLE_NEW_DEPRECATED_INTERFACES

################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################

[PcdsFeatureFlag.common]
  gEfiMdePkgTokenSpaceGuid.PcdComponentNameDisable|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdDriverDiagnosticsDisable|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdComponentName2Disable|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdDriverDiagnostics2Disable|TRUE

  #
  # Control what commands are supported from the UI
  # Turn these on and off to add features or save size
  #
  gEmbeddedTokenSpaceGuid.PcdEmbeddedMacBoot|TRUE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedDirCmd|TRUE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedHobCmd|TRUE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedHwDebugCmd|TRUE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedPciDebugCmd|TRUE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedIoEnable|FALSE
  gEmbeddedTokenSpaceGuid.PcdEmbeddedScriptCmd|FALSE

  gEmbeddedTokenSpaceGuid.PcdCacheEnable|TRUE

  # Use the Vector Table location in CpuDxe. We will not copy the Vector Table at PcdCpuVectorBaseAddress
  gArmTokenSpaceGuid.PcdRelocateVectorTable|FALSE

  gEmbeddedTokenSpaceGuid.PcdPrePiProduceMemoryTypeInformationHob|TRUE
  gArmTokenSpaceGuid.PcdCpuDxeProduceDebugSupport|FALSE

  gEfiMdeModulePkgTokenSpaceGuid.PcdTurnOffUsbLegacySupport|TRUE

  ## If TRUE, Graphics Output Protocol will be installed on virtual handle created by ConsplitterDxe.
  #  It could be set FALSE to save size.
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutGopSupport|TRUE

  # The secondary cores are parked in the Pi2 boot firwmware. This flag triggers
  # the Pre Pi MP core component to send a signal releasing them (in the Pi 2 case
  # this is the write of the jump address into a mailbox implemented in the
  # BCM specific GIC component in order to match the ARM GIC case)
  gArmPlatformTokenSpaceGuid.PcdSendSgiToBringUpSecondaryCores|TRUE

  gArmPlatformTokenSpaceGuid.PcdBdsLinuxSupport|TRUE

[PcdsFixedAtBuild.common]
  gArmPlatformTokenSpaceGuid.PcdFirmwareVendor|"Pi2 Board"
  gArmPlatformTokenSpaceGuid.PcdCoreCount|4

  gEmbeddedTokenSpaceGuid.PcdEmbeddedPrompt|"Pi2Edk2"
  gEfiMdePkgTokenSpaceGuid.PcdMaximumUnicodeStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumLinkedListLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdSpinLockTimeout|10000000
  gEfiMdePkgTokenSpaceGuid.PcdDebugClearMemoryValue|0xAF
  gEfiMdePkgTokenSpaceGuid.PcdPerformanceLibraryPropertyMask|1
  gEfiMdePkgTokenSpaceGuid.PcdPostCodePropertyMask|0
  gEfiMdePkgTokenSpaceGuid.PcdUefiLibMaxPrintBufferSize|320

  # Default table revision to be ACPI 5.0 compliant
  #gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiExposedTableVersions|0x20

  # We want to use the Shell Libraries but don't want it to initialise
  # automatically. We initialise the libraries when the command is called by the
  # Shell.
  gEfiShellPkgTokenSpaceGuid.PcdShellLibAutoInitialize|FALSE

  # UEFI Shell GUID
  gEfiIntelFrameworkModulePkgTokenSpaceGuid.PcdShellFile|{ 0x83, 0xA5, 0x04, 0x7C, 0x3E, 0x9E, 0x1C, 0x4F, 0xAD, 0x65, 0xE0, 0x52, 0x68, 0xD0, 0xB4, 0xD1 }

  # UI app GUID
  gEfiMdeModulePkgTokenSpaceGuid.PcdBootManagerMenuFile|{ 0x21, 0xaa, 0x2c, 0x46, 0x14, 0x76, 0x03, 0x45, 0x83, 0x6e, 0x8a, 0xb6, 0xf4, 0x66, 0x23, 0x31 }

  gEfiMdeModulePkgTokenSpaceGuid.PcdResetOnMemoryTypeInformationChange|FALSE

# DEBUG_ASSERT_ENABLED       0x01
# DEBUG_PRINT_ENABLED        0x02
# DEBUG_CODE_ENABLED         0x04
# CLEAR_MEMORY_ENABLED       0x08
# ASSERT_BREAKPOINT_ENABLED  0x10
# ASSERT_DEADLOOP_ENABLED    0x20
!if $(TARGET) == RELEASE
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x21
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
!endif

  #  DEBUG_INIT       0x00000001  // Initialization
  #  DEBUG_WARN       0x00000002  // Warnings
  #  DEBUG_LOAD       0x00000004  // Load events
  #  DEBUG_FS         0x00000008  // EFI File system
  #  DEBUG_POOL       0x00000010  // Alloc & Free's
  #  DEBUG_PAGE       0x00000020  // Alloc & Free's
  #  DEBUG_INFO       0x00000040  // Informational debug messages
  #  DEBUG_DISPATCH   0x00000080  // PEI/DXE/SMM Dispatchers
  #  DEBUG_VARIABLE   0x00000100  // Variable
  #  DEBUG_TIMER_INT  0x00000200  // Timer & Interrupt Drivers
  #  DEBUG_BM         0x00000400  // Boot Manager
  #  DEBUG_BLKIO      0x00001000  // BlkIo Driver
  #  DEBUG_NET        0x00004000  // SNI Driver
  #  DEBUG_MMCHOST_SD 0x00008000  // MMCHost Miniport Driver
  #  DEBUG_UNDI       0x00010000  // UNDI Driver
  #  DEBUG_LOADFILE   0x00020000  // UNDI Driver
  #  DEBUG_EVENT      0x00080000  // Event messages
  #  DEBUG_GCD        0x00100000  // Global Coherency Database changes
  #  DEBUG_CACHE      0x00200000  // Memory range cachability changes
  #  DEBUG_VERBOSE    0x00400000  // Detailed debug messages that may significantly impact boot performance
  #  DEBUG_ACPI       0x00800000  // ACPI table errors
  #  DEBUG_ERROR      0x80000000  // Error
  #
  # By default only enable init, error, warning and load debug prints to minimize
  # debug messages. Use "0x8FEF4DCF" for detailed debugging purposes.
  #gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel| 0x80000003 # 0x8FEF4DCF

  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x07

  gEmbeddedTokenSpaceGuid.PcdEmbeddedAutomaticBootCommand|""
  gEmbeddedTokenSpaceGuid.PcdEmbeddedDefaultTextColor|0x07
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxVariableSize|0x000F0000
  gEmbeddedTokenSpaceGuid.PcdEmbeddedMemVariableStoreSize|0x10000

#
# Optional feature to help prevent EFI memory map fragments
# Turned on and off via: PcdPrePiProduceMemoryTypeInformationHob
# Values are in EFI Pages (4K). DXE Core will make sure that
# at least this much of each type of memory can be allocated
# from a single memory range. This way you only end up with
# maximum of two fragements for each type in the memory map
# (the memory used, and the free memory that was prereserved
# but not used).
#
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIReclaimMemory|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIMemoryNVS|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiReservedMemoryType|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesData|80
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesCode|40
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesCode|400
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesData|3000
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderCode|10
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderData|0

  gEfiMdePkgTokenSpaceGuid.PcdDefaultTerminalType|4

#
# Pi2 board Specific PCDs
#
  #
  # ARM PL011 UART 0 settings to be used when it's included as the default serial port.
  #
  gArmPlatformTokenSpaceGuid.PL011UartClkInHz|16000000 # 16MHz this must match config.txt default is 3MHz

  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x3F201000 # NOTE: Datasheet errata!

  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultBaudRate|921600
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultDataBits|8
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultParity|1   # NoParity
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultStopBits|1 # OneStopBit

  gArmTokenSpaceGuid.PcdVFPEnabled|1

  # Reserve the lower 2MB of physical memory for UEFI
  gPi2BoardTokenSpaceGuid.PcdBootRegionBase|0x0
  gPi2BoardTokenSpaceGuid.PcdBootRegionSize|0x200000

  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x00200000

  # Size of the region used by UEFI in permanent memory (Reserved 16MB)
  gArmPlatformTokenSpaceGuid.PcdSystemMemoryUefiRegionSize|0x01000000

  # Size of the region reserved for fixed address allocations (Reserved 32MB)
  gArmTokenSpaceGuid.PcdArmLinuxKernelMaxOffset|0x02000000

  #
  # Fixed allocation memory for initial boot.
  # This region lives at offset 0xE0000 (896Kb) with length 0x20000 (128Kb)
  #
  # 0xE0000 -> 0xE0FFF - 1 x 4Kb page for the exception vector table.
  # 0xE1000 -> 0xE1FFF - 1 x 4Kb page for the first entry in the HOB list (dynamic memory)
  # 0xE2000 -> 0xE3FFF - 2 x 4Kb page for the Secure execution stacks (four stacks of 2Kb each)
  # 0xE4000 -> 0xEBFFF - 8 x 4Kb pages for the Primary Core normal stack (32Kb)
  # 0xEC000 -> 0xEEFFF - 3 x 4Kb pages for the Secondary Core normal stacks (three stacks of 4Kb each)
  # 0xEF000 -> 0xF0000 - 1 x 4Kb page unused (accidental GIC access)
  # 0xF0000 -> 0xF4000 - 4 x 4Kb pages for the Multi-Processor Parking Protocol mailboxes (four of 4Kb)
  #

  gArmTokenSpaceGuid.PcdCpuVectorBaseAddress|0x000E0000  # Exception vector table.

  #
  # Stacks for MPCores in Secure World
  #
  gArmPlatformTokenSpaceGuid.PcdCPUCoresSecStackBase|0x000E2000
  gArmPlatformTokenSpaceGuid.PcdCPUCoreSecPrimaryStackSize|0x800
  gArmPlatformTokenSpaceGuid.PcdCPUCoreSecSecondaryStackSize|0x800

  #
  # Stacks for MPCores in Normal World
  # This is *required* to be used for the Multi-Processor Parking Protocol as used by Windows
  # because the secondary cores are started after ExitBootServices such that UEFI memory has already
  # been released. Therefore, the memory represented by PcdCPUCoresStackBase *must* be outside of the
  # System Memory declared to UEFI such that it's always available for use at any time.
  #
  gArmPlatformTokenSpaceGuid.PcdCPUCoresStackBase|0x000E4000
  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x8000
  gArmPlatformTokenSpaceGuid.PcdCPUCoreSecondaryStackSize|0x1000

  #
  # ARM General Interrupt Controller settings
  #
  # Since the 2836 doesn't have an ARM GIC we use the BCM "stub" library instead to provide only
  # enough functionality to be able to get the platform started and support multi-processor through
  # the MP Parking Protocol.
  # Therefore, these values are unused and set to point to unused memory in case something trys to
  # use it.
  #
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x000EF000
  gArmTokenSpaceGuid.PcdGicInterruptInterfaceBase|0x000EF100

  # Mailbox base for the Multi-Processor Parking Protocol (uses one 4Kb page per core, thus 16Kb)
  #
  # NOTE: This value is also reflected in the ACPI tables in the GIC Parked Address (mailbox address)
  #       fields for the four cores as 0x000F0000, 0x000F1000, 0x000F2000 & 0x000F3000. Therefore, if
  #       changed here it MUST also be changed in the ACPI tables to match.
  #
  gWOASupportTokenSpaceGuid.PcdCPUCoresMPPPMailboxBase|0x000F0000

  #
  # In the BCM Gic implementation this represents the address of the secondary
  # core start as written into the mailbox to be picked up by the Pi 2 boot
  # firmware. The net effect is to boot the secondary cores in exactly the same
  # way as the primary cores (through Sec and Pre Pi etc).
  #
  gArmTokenSpaceGuid.PcdCpuResetAddress|0x00008000  # Pi2 image load & start

  #
  # The Pi2 cores are in cluster 15
  #
  gArmTokenSpaceGuid.PcdArmPrimaryCore|0xF00
  gPi2BoardTokenSpaceGuid.PcdCoresClusterId|0xF

  #
  # The timer frequency is set by the ARM core timer prescaler to 19.2MHz.
  # Since the GIC CntFrq register is set in secure mode by the boot firmware
  # to 19.2MHz the UEFI platform init sets the prescaler to match the 19.2MHz
  # that's been set. Therefore, the value below is a constant and must be set to
  # 19.2MHz to match it.
  #

  gArmTokenSpaceGuid.PcdArmArchTimerFreqInHz|19200000  # 19.2MHz

  #
  # Timer interrupt routing.
  # If the GIC is used, these two lines can be removed as the ARM package defaults
  # are correct for the routing of the GIT interrupts to the GIC. Since the BCM2836 doesn't
  # use the GIC, these values represent the bit number in the Timer Control and IRQ Source
  # registers.
  #
  gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum|0  #Interrupt Source/Vector 0
  gArmTokenSpaceGuid.PcdArmArchTimerIntrNum|1     #Interrupt Source/Vector 1

  #
  # Set the tick period for UEFI polling and timeouts expressed in 100ns units.
  #  100000 ==  10ms (usual)
  # 1000000 == 100ms (can be used if DEBUG_TIMER_INT is on)
  #
  gEmbeddedTokenSpaceGuid.PcdTimerPeriod|100000  #10ms tick.

  # TBD if the below are correct.
  gEmbeddedTokenSpaceGuid.PcdEmbeddedPerformanceCounterPeriodInNanoseconds|77
  gEmbeddedTokenSpaceGuid.PcdEmbeddedPerformanceCounterFrequencyInHz|13000000

  #
  # ARM Pcds
  #
  gArmTokenSpaceGuid.PcdArmUncachedMemoryMask|0x0000000040000000


  #
  # Default boot timeout
  #
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|5

  #
  # MBR+GPT Workaround for SD Card
  #
!if $(RAMDISK_BOOT_ENABLE)
  # gPi2BoardTokenSpaceGuid.PcdArasanSDCardMBRGPTWorkaroundEnabled|0
!elseif $(MBRGPT_WORKAROUND_ENABLE)
  gPi2BoardTokenSpaceGuid.PcdArasanSDCardMBRGPTWorkaroundEnabled|1
  # This should be the same value passed to param <LBA Offset of GPT Header> of MBRPlusGPT.exe
  gPi2BoardTokenSpaceGuid.PcdArasanSDCardMBRGPTWorkaroundGPTOffsetLba|0x0009d000
!else
  gPi2BoardTokenSpaceGuid.PcdArasanSDCardMBRGPTWorkaroundEnabled|0
!endif

  # JTAG enable flag enabled on DEBUG build only
!if $(TARGET) == DEBUG
  gPi2BoardTokenSpaceGuid.PcdJtagEnabled|TRUE
!endif

  # Set this if the OS supports runtime pin muxing. This will leave pins as
  # GPIO by default, and it is the OS's responsibility to mux them away.
  gPi2BoardTokenSpaceGuid.PcdRuntimeMuxingEnabled|TRUE

[PcdsDynamicDefault]
  # This Pcd is declared as both Fixed and Dynamic in the Arm package dec file
  # The default is Fixed unless we redeclare it in the dsc as Dynamic
  # The value of 0 assigned here will be ignored, the actual PcdSystemMemorySize
  # will be calculated in runtime by means of UEFI<->VideoCore communication
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x0

[PcdsPatchableInModule]
  # Console Resolution
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1024
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|768


################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
#
################################################################################
[Components.common]

  #
  # SEC
  #
  RaspberryPiPkg/Pi2BoardPkg/Sec/Sec.inf {
    <LibraryClasses>
      # Since the 2836 doesn't have an ARM GIC we use the BCM "stub" library instead to provide only
      # enough functionality to be able to get the platform started and support multi-processor through
      # the MP Parking Protocol. The BCM interrupt controller has no secure/none-secure knowledge.
      # Real interrupts for EFI are supported on the BCM part in the Interrupt DXE implementation.
      ArmGicLib|RaspberryPiPkg/Pi2BoardPkg/Library/BcmGicLib/BcmGicLib.inf

      # This is included so that the default configuration can be set based on the hardware settings.
      PL011UartLib|ArmPlatformPkg/Drivers/PL011Uart/PL011Uart.inf
  }

  #
  # PEI
  #
  # The Multi-Processor implementation is used that supports the Parking Protcol as required
  # by Windows.
  #
  RaspberryPiPkg/Pi2BoardPkg/PrePi/PeiMPCoreMPPP.inf {
    <LibraryClasses>
      # Use the implementation which has the none-secure bits.
      ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf

      # Since the 2836 doesn't have an ARM GIC we use the BCM "stub" library instead to provide only
      # enough functionality to be able to get the platform started and support multi-processor through
      # the MP Parking Protocol. The BCM interrupt controller has no secure/none-secure knowledge.
      # Real interrupts for EFI are supported on the BCM part in the Interrupt DXE implementation.
      ArmGicLib|RaspberryPiPkg/Pi2BoardPkg/Library/BcmGicLib/BcmGicLib.inf
  }

  #
  # DXE
  #
  MdeModulePkg/Core/Dxe/DxeMain.inf {
    <LibraryClasses>
      PcdLib|RaspberryPiPkg/Pi2BoardPkg/Library/Pi2PcdLib/Pi2PcdLib.inf
      NULL|MdeModulePkg/Library/DxeCrc32GuidedSectionExtractLib/DxeCrc32GuidedSectionExtractLib.inf
      NULL|EmbeddedPkg/Library/LzmaHobCustomDecompressLib/LzmaHobCustomDecompressLib.inf
  }

  ArmPkg/Drivers/CpuDxe/CpuDxe.inf

  MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf
  MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf
  MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
  MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
  MdeModulePkg/Universal/Variable/EmuRuntimeDxe/EmuVariableRuntimeDxe.inf
  EmbeddedPkg/EmbeddedMonotonicCounter/EmbeddedMonotonicCounter.inf

  MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
  MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
  MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
  MdeModulePkg/Universal/Console/TerminalDxe/TerminalDxe.inf
  MdeModulePkg/Universal/SerialDxe/SerialDxe.inf

  EmbeddedPkg/ResetRuntimeDxe/ResetRuntimeDxe.inf
  EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
  EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf

  #
  # Semi-hosting filesystem
  #
  ArmPkg/Filesystem/SemihostFs/SemihostFs.inf

  #
  # FAT filesystem + GPT/MBR partitioning
  #
  MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
  MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
  MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf

  #
  # MMC/SD
  #
  RaspberryPiPkg/Pi2BoardPkg/Drivers/MmcDxe/MmcDxe.inf
  RaspberryPiPkg/Pi2BoardPkg/Drivers/SdHostDxe/SdHostDxe.inf

  #
  # ARM GIC+GIT Drivers
  #
  # NOTE: The BCM2836 does not include an ARM GIC so we must use
  #       a device specific driver for interrupts.
  #
  # IN GENERAL IT IS MANDATORY THAT DEVICES USE THE ARM GIC FOR INTERRUPTS
  # AND THE ARM GIT FOR TIMERS FOR WINDOWS SUPPORT.
  #
  RaspberryPiPkg/Pi2BoardPkg/Drivers/InterruptDxe/InterruptDxe.inf
  ArmPkg/Drivers/TimerDxe/TimerDxe.inf

  #
  # Display Support
  #
  RaspberryPiPkg/Pi2BoardPkg/Drivers/DisplayDxe/DisplayDxe.inf

  #
  # ACPI Support
  #
  MdeModulePkg/Universal/Acpi/AcpiTableDxe/AcpiTableDxe.inf
  MdeModulePkg/Universal/Acpi/AcpiPlatformDxe/AcpiPlatformDxe.inf
  RaspberryPiPkg/Pi2BoardPkg/AcpiTables/AcpiTables.inf
  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf

  #
  # SMBIOS Support
  #
  RaspberryPiPkg/Pi2BoardPkg/Drivers/PlatformSmbiosDxe/PlatformSmbiosDxe.inf
  MdeModulePkg/Universal/SmbiosDxe/SmbiosDxe.inf

  #
  # Bds
  #
  MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
  MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
  MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
  MdeModulePkg/Universal/DisplayEngineDxe/DisplayEngineDxe.inf
  MdeModulePkg/Universal/BdsDxe/BdsDxe.inf
  RaspberryPiPkg/Pi2BoardPkg/Logo/LogoDxe.inf
  MdeModulePkg/Application/UiApp/UiApp.inf {
    <LibraryClasses>
      NULL|MdeModulePkg/Library/DeviceManagerUiLib/DeviceManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootManagerUiLib/BootManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootMaintenanceManagerUiLib/BootMaintenanceManagerUiLib.inf
  }
  ShellPkg/Application/Shell/Shell.inf {
    <LibraryClasses>
      ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
      NULL|ShellPkg/Library/UefiShellLevel2CommandsLib/UefiShellLevel2CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellLevel1CommandsLib/UefiShellLevel1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellLevel3CommandsLib/UefiShellLevel3CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellDriver1CommandsLib/UefiShellDriver1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellDebug1CommandsLib/UefiShellDebug1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellInstall1CommandsLib/UefiShellInstall1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellNetwork1CommandsLib/UefiShellNetwork1CommandsLib.inf

      HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
      PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
      BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf

    <PcdsFixedAtBuild>
      gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0xFF
      gEfiShellPkgTokenSpaceGuid.PcdShellLibAutoInitialize|FALSE
      gEfiMdePkgTokenSpaceGuid.PcdUefiLibMaxPrintBufferSize|8000
  }
