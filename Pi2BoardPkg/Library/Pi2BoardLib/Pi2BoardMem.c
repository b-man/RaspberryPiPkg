/** @file
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

#include <Library/ArmPlatformLib.h>
#include <Library/DebugLib.h>
#include <Library/PcdLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/IoLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/PcdLib.h>

#include <Pi2Board.h>
#include <BcmMailbox.h>

#define MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS  6

volatile MAILBOX_GET_MEMORY MbGetMemory __attribute__((aligned(16)));

/**
  Return the Virtual Memory Map of your platform

  This Virtual Memory Map is used by MemoryInitPei Module to initialize the MMU on your platform.

  @param[out]   VirtualMemoryMap    Array of ARM_MEMORY_REGION_DESCRIPTOR describing a Physical-to-
                                    Virtual Memory mapping. This array must be ended by a zero-filled
                                    entry

**/
VOID
ArmPlatformGetVirtualMemoryMap (
  IN ARM_MEMORY_REGION_DESCRIPTOR** VirtualMemoryMap
  )
{
  ARM_MEMORY_REGION_ATTRIBUTES  CacheAttributes;
  UINTN                         Index = 0;
  ARM_MEMORY_REGION_DESCRIPTOR  *VirtualMemoryTable;

  ASSERT(VirtualMemoryMap != NULL);

  DEBUG((EFI_D_VERBOSE, "Enter: ArmPlatformGetVirtualMemoryMap\n"));

  VirtualMemoryTable = (ARM_MEMORY_REGION_DESCRIPTOR*)AllocatePages(EFI_SIZE_TO_PAGES (sizeof(ARM_MEMORY_REGION_DESCRIPTOR) * MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS));
  if (VirtualMemoryTable == NULL) {
    return;
  }

  if (FeaturePcdGet(PcdCacheEnable) == TRUE) {
    CacheAttributes = DDR_ATTRIBUTES_CACHED;
  } else {
    CacheAttributes = DDR_ATTRIBUTES_UNCACHED;
  }

  DEBUG((EFI_D_VERBOSE, "CacheAttributes=0x%d\n", CacheAttributes));

  ASSERT(FixedPcdGet32(PcdBootRegionSize) != 0);

  // Boot DRAM region (UEFI binary image & boot working DRAM)
  VirtualMemoryTable[Index].PhysicalBase   = FixedPcdGet32(PcdBootRegionBase);
  VirtualMemoryTable[Index].VirtualBase    = FixedPcdGet32(PcdBootRegionBase);
  VirtualMemoryTable[Index].Length         = FixedPcdGet32(PcdBootRegionSize);
  VirtualMemoryTable[Index].Attributes     = BOOT_IMAGE_ATTRIBUTES;

  // Base SDRAM mapped as is.
  VirtualMemoryTable[++Index].PhysicalBase = PcdGet64(PcdSystemMemoryBase);
  VirtualMemoryTable[Index].VirtualBase    = PcdGet64(PcdSystemMemoryBase);
  VirtualMemoryTable[Index].Length         = PcdGet64(PcdSystemMemorySize);
  VirtualMemoryTable[Index].Attributes     = CacheAttributes;

  // SOC peripheral registers.
  VirtualMemoryTable[++Index].PhysicalBase = SOC_REGISTERS_PHYSICAL_BASE;
  VirtualMemoryTable[Index].VirtualBase    = SOC_REGISTERS_PHYSICAL_BASE;
  VirtualMemoryTable[Index].Length         = SOC_REGISTERS_PHYSICAL_LENGTH;
  VirtualMemoryTable[Index].Attributes     = SOC_REGISTERS_ATTRIBUTES;

  // ARM Core peripheral registers.
  VirtualMemoryTable[++Index].PhysicalBase = ARM_REGISTERS_PHYSICAL_BASE;
  VirtualMemoryTable[Index].VirtualBase    = ARM_REGISTERS_PHYSICAL_BASE;
  VirtualMemoryTable[Index].Length         = ARM_REGISTERS_PHYSICAL_LENGTH;
  VirtualMemoryTable[Index].Attributes     = ARM_REGISTERS_ATTRIBUTES;

  // GPU Shared memory: starts at the top of system memory
  VirtualMemoryTable[++Index].PhysicalBase = PcdGet64 (PcdSystemMemoryBase) + PcdGet64 (PcdSystemMemorySize);
  VirtualMemoryTable[Index].VirtualBase    = PcdGet64 (PcdSystemMemoryBase) + PcdGet64 (PcdSystemMemorySize);
  VirtualMemoryTable[Index].Length         = PcdGet64 (PcdGpuMemorySize);
  VirtualMemoryTable[Index].Attributes     = GPU_SHARED_MEMORY_ATTRIBUTES;

  // End of Table
  VirtualMemoryTable[++Index].PhysicalBase = 0;
  VirtualMemoryTable[Index].VirtualBase    = 0;
  VirtualMemoryTable[Index].Length         = 0;
  VirtualMemoryTable[Index].Attributes     = (ARM_MEMORY_REGION_ATTRIBUTES)0;

  ASSERT((Index + 1) <= MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS);

  *VirtualMemoryMap = VirtualMemoryTable;
}
