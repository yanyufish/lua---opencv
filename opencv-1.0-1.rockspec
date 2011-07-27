
package = "opencv"
version = "1.0-1"

source = {
   url = "opencv-1.0-1.tgz"
}

description = {
   summary = "Wrapper for some highlevel opencv function",
   detailed = [[
      For now, it contains wrappers for:
       + cvCalcOpticalFlowBM
       + cvCalcOpticalFlowHS
       + cvCalcOpticalFlowLK
       + cvHaarDetectObjects
       + cvCaptureFromCAM
       + cvSobel
       + cvCanny
   ]],
   homepage = "",
   license = "MIT/X11" -- or whatever you like
}

dependencies = {
   "lua >= 5.1",
   "torch",
   "xlua"
}

build = {
   type = "cmake",

   cmake = [[
         cmake_minimum_required(VERSION 2.8)

         set (CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})

         # infer path for Torch7
         string (REGEX REPLACE "(.*)lib/luarocks/rocks.*" "\\1" TORCH_PREFIX "${CMAKE_INSTALL_PREFIX}" )
         message (STATUS "Found Torch7, installed in: " ${TORCH_PREFIX})

         find_package (Torch REQUIRED)
	 find_package (OpenCV REQUIRED)

         set (CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

	 MESSAGE(STATUS "Found OpenCV")
	 MESSAGE(STATUS "OpenCV libs: ${OpenCV_LIBS}")
	 MESSAGE(STATUS "OpenCV include dirs: ${OpenCV_INCLUDE_DIRS}")
   	 INCLUDE_DIRECTORIES (${TORCH_INCLUDE_DIR} ${PROJECT_SOURCE_DIR} ${OpenCV_INCLUDE_DIRS})
   	 add_library(opencv SHARED opencv.c)
	 MESSAGE(STATUS "TORCH_LIBRARY_DIR: ${TORCH_LIBRARY_DIR}")
	 MESSAGE(STATUS "TORCH_LIBRARIES: ${TORCH_LIBRARIES}")

	 link_directories (${TORCH_LIBRARY_DIR})
	 target_link_libraries(opencv ${TORCH_LIBRARIES} ${OpenCV_LIBS})
	 install_files(/lua/opencv init.lua)
	 install_files(/lua/opencv img1.jpg)
	 install_files(/lua/opencv img2.jpg) 
	 install_targets(/lib opencv) 

   ]],

   variables = {
      CMAKE_INSTALL_PREFIX = "$(PREFIX)"
   }
}