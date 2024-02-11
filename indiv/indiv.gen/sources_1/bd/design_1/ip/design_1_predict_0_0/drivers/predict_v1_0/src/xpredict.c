// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xpredict.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XPredict_CfgInitialize(XPredict *InstancePtr, XPredict_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XPredict_Start(XPredict *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL) & 0x80;
    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XPredict_IsDone(XPredict *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XPredict_IsIdle(XPredict *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XPredict_IsReady(XPredict *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XPredict_EnableAutoRestart(XPredict *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XPredict_DisableAutoRestart(XPredict *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_AP_CTRL, 0);
}

void XPredict_InterruptGlobalEnable(XPredict *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_GIE, 1);
}

void XPredict_InterruptGlobalDisable(XPredict *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_GIE, 0);
}

void XPredict_InterruptEnable(XPredict *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_IER);
    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_IER, Register | Mask);
}

void XPredict_InterruptDisable(XPredict *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_IER);
    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_IER, Register & (~Mask));
}

void XPredict_InterruptClear(XPredict *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPredict_WriteReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_ISR, Mask);
}

u32 XPredict_InterruptGetEnabled(XPredict *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_IER);
}

u32 XPredict_InterruptGetStatus(XPredict *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPredict_ReadReg(InstancePtr->Control_BaseAddress, XPREDICT_CONTROL_ADDR_ISR);
}

