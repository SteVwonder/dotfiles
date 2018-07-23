#!/bin/bash

module load clang

IRONY_SRC_DIR=/g/g17/herbein1/.emacs.d/elpa/irony-20180104.1109/server
CLANG_DIR=/usr/tce/packages/clang/clang-4.0.0

export CXX=clang++
export CC=clang

cmake -DLIBCLANG_INCLUDE_DIR=$CLANG_DIR/include -DLIBCLANG_LIBRARY=$CLANG_DIR/lib/libclang.so -DCMAKE_INSTALL_PREFIX=/g/g17/herbein1/.emacs.d/irony/ $IRONY_SRC_DIR && cmake --build . --use-stderr --config Release --target install
