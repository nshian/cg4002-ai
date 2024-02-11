// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xpredict.h"

extern XPredict_Config XPredict_ConfigTable[];

#ifdef SDT
XPredict_Config *XPredict_LookupConfig(UINTPTR BaseAddress) {
	XPredict_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XPredict_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XPredict_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XPredict_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPredict_Initialize(XPredict *InstancePtr, UINTPTR BaseAddress) {
	XPredict_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPredict_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPredict_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XPredict_Config *XPredict_LookupConfig(u16 DeviceId) {
	XPredict_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XPREDICT_NUM_INSTANCES; Index++) {
		if (XPredict_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XPredict_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPredict_Initialize(XPredict *InstancePtr, u16 DeviceId) {
	XPredict_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPredict_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPredict_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

