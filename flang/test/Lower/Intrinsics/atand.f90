! RUN: bbc -emit-fir -hlfir=false %s -o - | FileCheck %s --check-prefixes="CHECK,CHECK-FAST"
! RUN: bbc --math-runtime=precise -emit-fir -hlfir=false %s -o - | FileCheck %s --check-prefixes="CHECK,CHECK-PRECISE"
! RUN: %flang_fc1 -emit-fir -flang-deprecated-no-hlfir %s -o - | FileCheck %s --check-prefixes="CHECK,CHECK-FAST"

function test_real4(x)
  real :: x, test_real4
  test_real4 = atand(x)
end function

! CHECK-LABEL: @_QPtest_real4
! CHECK-PRECISE: %[[atan:.*]] = fir.call @atanf({{%[A-Za-z0-9._]+}}) fastmath<contract> : (f32) -> f32
! CHECK-FAST: %[[atan:.*]] = math.atan %{{.*}} : f32
! CHECK: %[[dfactor:.*]] = arith.constant 57.295779513082323 : f64
! CHECK: %[[factor:.*]] = fir.convert %[[dfactor]] : (f64) -> f32
! CHECK: %{{.*}} = arith.mulf %[[atan]], %[[factor]] fastmath<contract> : f32

function test_real8(x)
  real(8) :: x, test_real8
  test_real8 = atand(x)
end function

! CHECK-LABEL: @_QPtest_real8
! CHECK-PRECISE: %[[atan:.*]] = fir.call @atan({{%[A-Za-z0-9._]+}}) fastmath<contract> : (f64) -> f64
! CHECK-FAST: %[[atan:.*]] = math.atan %{{.*}} : f64
! CHECK: %[[factor:.*]] = arith.constant 57.295779513082323 : f64
! CHECK: %{{.*}} = arith.mulf %[[atan]], %[[factor]] fastmath<contract> : f64

function test_real4_yx(y,x)
  real(4) :: x, y, test_real4
  test_real4 = atand(y,x)
end function

! CHECK-LABEL: @_QPtest_real4_yx
! CHECK: %[[atan2:.*]] = math.atan2 %{{.*}}, %{{.*}}: f32
! CHECK: %[[dfactor:.*]] = arith.constant 57.295779513082323 : f64
! CHECK: %[[factor:.*]] = fir.convert %[[dfactor]] : (f64) -> f32
! CHECK: %{{.*}} = arith.mulf %[[atan2]], %[[factor]] fastmath<contract> : f32

function test_real8_yx(y,x)
  real(8) :: x, y, test_real8
  test_real8 = atand(y,x)
end function

! CHECK-LABEL: @_QPtest_real8_yx
! CHECK: %[[atan2:.*]] = math.atan2 %{{.*}}, %{{.*}}: f64
! CHECK: %[[factor:.*]] = arith.constant 57.295779513082323 : f64
! CHECK: %{{.*}} = arith.mulf %[[atan2]], %[[factor]] fastmath<contract> : f64
