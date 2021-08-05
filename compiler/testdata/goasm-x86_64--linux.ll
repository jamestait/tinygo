; ModuleID = 'goasm.go'
source_filename = "goasm.go"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64--linux"

@main.asmGlobalExport = hidden global i32 0, align 4

@__GoABI0_main.asmGlobalExport = alias i32, i32* @main.asmGlobalExport

declare noalias nonnull i8* @runtime.alloc(i64, i8*, i8*)

define hidden void @main.init(i8* %context, i8* %parentHandle) unnamed_addr {
entry:
  ret void
}

; Function Attrs: noinline
define double @main.AsmSqrt(double %x, i8* %0, i8* %1) #0 {
entry:
  %callframe = alloca { { double }, double }, align 8
  %2 = call { { double }, double }* asm "movq %rsp, ${0}", "=r,r"({ { double }, double }* nonnull %callframe) #2
  %3 = getelementptr { { double }, double }, { { double }, double }* %2, i64 0, i32 0, i32 0
  store double %x, double* %3, align 8
  call void @__GoABI0_main.AsmSqrt()
  %4 = call { { double }, double }* asm sideeffect alignstack "movq %rsp, ${0}", "=r,r,~{rbx},~{r12},~{r13},~{r14},~{r15},~{memory}"({ { double }, double }* nonnull %callframe) #2
  %result.gep = getelementptr { { double }, double }, { { double }, double }* %4, i64 0, i32 1
  %result = load double, double* %result.gep, align 8
  ret double %result
}

declare void @__GoABI0_main.AsmSqrt()

; Function Attrs: noinline
define double @main.AsmAdd(double %x, double %y, i8* %0, i8* %1) #0 {
entry:
  %callframe = alloca { { double, double }, double }, align 8
  %2 = call { { double, double }, double }* asm "movq %rsp, ${0}", "=r,r"({ { double, double }, double }* nonnull %callframe) #2
  %3 = getelementptr { { double, double }, double }, { { double, double }, double }* %2, i64 0, i32 0, i32 0
  store double %x, double* %3, align 8
  %4 = getelementptr { { double, double }, double }, { { double, double }, double }* %2, i64 0, i32 0, i32 1
  store double %y, double* %4, align 8
  call void @__GoABI0_main.AsmAdd()
  %5 = call { { double, double }, double }* asm sideeffect alignstack "movq %rsp, ${0}", "=r,r,~{rbx},~{r12},~{r13},~{r14},~{r15},~{memory}"({ { double, double }, double }* nonnull %callframe) #2
  %result.gep = getelementptr { { double, double }, double }, { { double, double }, double }* %5, i64 0, i32 1
  %result = load double, double* %result.gep, align 8
  ret double %result
}

declare void @__GoABI0_main.AsmAdd()

; Function Attrs: noinline
define { i64, double } @main.AsmFoo(double %x, i8* %0, i8* %1) #0 {
entry:
  %callframe = alloca { { double }, { i64, double } }, align 8
  %2 = call { { double }, { i64, double } }* asm "movq %rsp, ${0}", "=r,r"({ { double }, { i64, double } }* nonnull %callframe) #2
  %3 = getelementptr { { double }, { i64, double } }, { { double }, { i64, double } }* %2, i64 0, i32 0, i32 0
  store double %x, double* %3, align 8
  call void @__GoABI0_main.AsmFoo()
  %4 = call { { double }, { i64, double } }* asm sideeffect alignstack "movq %rsp, ${0}", "=r,r,~{rbx},~{r12},~{r13},~{r14},~{r15},~{memory}"({ { double }, { i64, double } }* nonnull %callframe) #2
  %result.elt = getelementptr { { double }, { i64, double } }, { { double }, { i64, double } }* %4, i64 0, i32 1, i32 0
  %result.unpack = load i64, i64* %result.elt, align 8
  %5 = insertvalue { i64, double } undef, i64 %result.unpack, 0
  %result.elt1 = getelementptr { { double }, { i64, double } }, { { double }, { i64, double } }* %4, i64 0, i32 1, i32 1
  %result.unpack2 = load double, double* %result.elt1, align 8
  %result3 = insertvalue { i64, double } %5, double %result.unpack2, 1
  ret { i64, double } %result3
}

declare void @__GoABI0_main.AsmFoo()

define hidden double @main.asmExport(double %x, i8* %context, i8* %parentHandle) unnamed_addr {
entry:
  ret double 0.000000e+00
}

; Function Attrs: noinline
define internal void @"main.asmExport$goasmwrapper"(i8* %0) #0 {
entry:
  %x.gep = getelementptr i8, i8* %0, i64 8
  %x.cast = bitcast i8* %x.gep to double*
  %x = load double, double* %x.cast, align 8
  %result = call double @main.asmExport(double %x, i8* null, i8* null)
  %result.gep = getelementptr i8, i8* %0, i64 16
  %result.cast = bitcast i8* %result.gep to double*
  store double %result, double* %result.cast, align 8
  ret void
}

; Function Attrs: naked
define void @__GoABI0_main.asmExport() #1 {
entry:
  %sp = call i8* asm "mov %rsp, $0", "=r"() #2
  tail call void @"main.asmExport$goasmwrapper"(i8* %sp)
  ret void
}

attributes #0 = { noinline }
attributes #1 = { naked }
attributes #2 = { nounwind }
