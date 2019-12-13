cmake_minimum_required(VERSION 3.4.3)

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  message(STATUS "LLD-STANDALONE: out-of-tree configuration")
  set(LLD_STANDALONE_IN_TREE OFF)
else()
  message(STATUS "LLD-STANDALONE: in-tree configuration")
  set(LLD_STANDALONE_IN_TREE ON)
endif()

if (NOT LLD_STANDALONE_IN_TREE)
  cmake_policy(SET CMP0048 NEW)
  project(lld-standalone)

  find_package(LLVM CONFIG REQUIRED tablegen)

  list(APPEND CMAKE_MODULE_PATH ${LLVM_DIR})
  include(AddLLVM)
  include(TableGen)
  set(LLVM_TABLEGEN_EXE "llvm-tblgen")
  include(HandleLLVMOptions)
endif()

message(STATUS "LLD-STANDALONE: configuring for LLVM ${LLVM_VERSION}...")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

include_directories(
  ${LLVM_INCLUDE_DIRS}
  ${PROJECT_SOURCE_DIR}
  ${PROJECT_BINARY_DIR})

set(LLVM_TARGET_DEFINITIONS Options.td)
tablegen(LLVM Options.inc -gen-opt-parser-defs)
add_public_tablegen_target(LLDStandaloneOptionsTableGen)

set(LLVM_LINK_COMPONENTS
  Support
  Option
  Target
  ${LLVM_TARGETS_TO_BUILD}
  )

add_llvm_executable(lld-standalone
  lld-standalone.cpp

  DEPENDS
  LLDStandaloneOptionsTableGen
  )

install(TARGETS lld-standalone
  RUNTIME DESTINATION bin
  )
