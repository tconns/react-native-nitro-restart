#include <fbjni/fbjni.h>
#include <jni.h>

#include "NitroRestartOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
  return facebook::jni::initialize(vm, [=]
                                   { margelo::nitro::restart::initialize(vm); });
}
