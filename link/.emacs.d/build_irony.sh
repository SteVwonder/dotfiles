#!/bin/bash

module load clang

IRONY_SRC_DIR=$HOME/.emacs.d/elpa/irony-20180703.1740/server
CLANG_DIR=/usr/tce/packages/clang/clang-4.0.0

export CXX=clang++
export CC=clang

ccmake -DLIBCLANG_INCLUDE_DIR=$CLANG_DIR/include -DLIBCLANG_LIBRARY=$CLANG_DIR/lib/libclang.so -DCMAKE_INSTALL_PREFIX=$HOME/.emacs.d/irony/ $IRONY_SRC_DIR && cmake --build . --use-stderr --config Release --target install
