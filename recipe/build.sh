#!/bin/sh

# https://gitlab.kitware.com/paraview/paraview/issues/19645
export LDFLAGS=`echo "${LDFLAGS}" | sed "s|-Wl,-dead_strip_dylibs||g"`

mkdir build && cd build
cmake -LAH \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DCMAKE_INSTALL_RPATH:STRING=${PREFIX}/lib \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON \
  -DPARAVIEW_USE_VTKM=OFF \
  -DPARAVIEW_USE_PYTHON=ON \
  -DPython3_FIND_STRATEGY=LOCATION \
  -DPython3_ROOT_DIR=${PREFIX} \
  -DPARAVIEW_BUILD_WITH_EXTERNAL=ON \
  -DVTK_MODULE_USE_EXTERNAL_VTK_libharu=OFF \
  -DVTK_MODULE_USE_EXTERNAL_VTK_utf8=OFF \
  -DPARAVIEW_ENABLE_WEB=ON \
  -DPARAVIEW_ENABLE_VISITBRIDGE=ON \
  -DPARAVIEW_ENABLE_XDMF3=ON \
  ..
make install -j${CPU_COUNT}

if test `uname` = "Darwin"; then
  ln -s $PREFIX/Applications/paraview.app/Contents/MacOS/paraview ${PREFIX}/bin/paraview
fi
