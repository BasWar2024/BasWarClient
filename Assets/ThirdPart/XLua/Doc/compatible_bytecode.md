# 

lualuaclua326432lua32luac

xLualua

## 

* 1xLualuac

* 22018/9/14

## 

### 1xluaPlugins

cmake-DLUAC_COMPATIBLE_FORMAT=ONmake_win64_lua53.bat

~~~bash
mkdir build64 & pushd build64
cmake -DLUAC_COMPATIBLE_FORMAT=ON -G "Visual Studio 14 2015 Win64" ..
popd
cmake --build build64 --config Release
md plugin_lua53\Plugins\x86_64
copy /Y build64\Release\xlua.dll plugin_lua53\Plugins\x86_64\xlua.dll
pause
~~~

xluaPlugins

## 2luacluac1Plugins

[](../../../build/luac/)windowmake_win64.batmaclinuxmake_unix.sh

## 3

CustomLoaderCustomLoaderEncodinglua

## PS: OpCode

lualua-5.3.512
