# If not stated otherwise in this file or this component's license file the
# following copyright and licenses apply:
#
# Copyright 2020 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if(NOT PYTHON_EXECUTABLE)
    find_package(PythonInterp 3.5 REQUIRED QUIET)
endif()

set(PROXYSTUB_GENERATOR "/home/ubuntu/metro_build2/anjali/17-02/buildroot/output/host/usr/sbin/ProxyStubGenerator/StubGenerator.py")

function(ProxyStubGenerator)
    if (NOT PROXYSTUB_GENERATOR)
        message(FATAL_ERROR "The path PROXYSTUB_GENERATOR is not set!")
    endif()

    if(NOT EXISTS "${PROXYSTUB_GENERATOR}" OR IS_DIRECTORY "${PROXYSTUB_GENERATOR}")
        message(FATAL_ERROR "ProxyStubGenerator path ${PROXYSTUB_GENERATOR} invalid.")
    endif()

    set(optionsArgs SCAN_IDS TRACES OLD_CPP NO_WARNINGS KEEP VERBOSE)
    set(oneValueArgs INCLUDE NAMESPACE INDENT OUTDIR)
    set(multiValueArgs INPUT INCLUDE_PATH)

    cmake_parse_arguments(Argument "${optionsArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    if(Argument_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ProxyStubGenerator(): \"${Argument_UNPARSED_ARGUMENTS}\"")
    endif()

    cmake_parse_arguments(Argument "${optionsArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    set(_execute_command ${PROXYSTUB_GENERATOR})

    if(Argument_SCAN_IDS)
        list(APPEND _execute_command  "--scan-ids")
    endif()

    if(Argument_TRACES)
        list(APPEND _execute_command  "--traces")
    endif()

    if(Argument_OLD_CPP)
        list(APPEND _execute_command  "--old-cpp")
    endif()

    if(Argument_NO_WARNINGS)
        list(APPEND _execute_command  "--no-warnings")
    endif()

    if(Argument_KEEP)
        list(APPEND _execute_command  "--keep")
    endif()

    if(Argument_VERBOSE)
        list(APPEND _execute_command  "--verbose")
    endif()

    if (Argument_INCLUDE)
        list(APPEND _execute_command  "-i" "${Argument_INCLUDE}")
    endif()

    if (Argument_NAMESPACE)
        list(APPEND _execute_command  "--namespace" "${Argument_NAMESPACE}")
    endif()

    if (Argument_INDENT)
        list(APPEND _execute_command  "--indent" "${Argument_INDENT}")
    endif()

    if (Argument_OUTDIR)
        file(MAKE_DIRECTORY "${Argument_OUTDIR}")
        list(APPEND _execute_command  "--outdir" "${Argument_OUTDIR}")
    endif()

    foreach(_include_path ${Argument_INCLUDE_PATH})
        list(APPEND _execute_command  "-I" "${_include_path}")
    endforeach(_include_path)

    foreach(_input ${Argument_INPUT})
        execute_process(COMMAND ${PYTHON_EXECUTABLE} ${_execute_command} ${_input} RESULT_VARIABLE rv)
        if(NOT ${rv} EQUAL 0)
            message(FATAL_ERROR "ProxyStubGenerator generator failed.")
        endif()
    endforeach(_input)


endfunction(ProxyStubGenerator)

message(STATUS "ProxyStubGenerator ready ${PROXYSTUB_GENERATOR}")
