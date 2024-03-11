#!/bin/bash
# 32 Bit Version
# build for Ubuntu16.04
luacdir53="lua53"
luacdir54="lua54"
luajitdir="luajit-2.1"
luapath=""
lualibname=""
outpath="Plugins"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while :
do
    echo "Please choose (1)luajit; (2)lua5.3; (3)lua5.4"
    if [ $# -eq 0 ] 
    then
        read input
        param_input=$input
    else
        param_input=$1
        echo "param_input: $param_input"
    fi
    case $param_input in
        "1")
            luapath=$luajitdir
            lualibname="libluajit"
            outpath="Plugins"
            break
        ;;
        "2")
            luapath=$luacdir53
            lualibname="liblua"
            outpath="Plugins53"
            break
        ;;
        "3")
            luapath=$luacdir54
            lualibname="liblua"
            outpath="Plugins54"
            break
        ;;
        *)
            echo "Please enter 1 or 2!!"
            continue
        ;;
    esac
done

echo "select : $luapath"

cd $DIR/$luapath
make clean

case $luapath in 
    $luacdir53)
        make linux BUILDMODE=static CC="gcc -fPIC -m32 -O2"
    ;;
    $luacdir54)
        make linux BUILDMODE=static CC="gcc -fPIC -m32 -O2"
    ;;
    $luajitdir)
        make BUILDMODE=static CC="gcc -fPIC -m32 -O2"
    ;;
esac

cp src/$lualibname.a ../$outpath/x86/$lualibname.a
make clean

echo -e "\n[MAINTAINCE] build $lualibname.a done\n"

cd ..

gcc -m32 -O2 -std=gnu99 -shared \
 tolua.c \
 int64.c \
 uint64.c \
 pb.c \
 lpeg/lpcap.c \
 lpeg/lpcode.c \
 lpeg/lpprint.c \
 lpeg/lptree.c \
 lpeg/lpvm.c \
 struct.c \
 cjson/strbuf.c \
 cjson/lua_cjson.c \
 cjson/fpconv.c \
 luasocket/auxiliar.c \
 luasocket/buffer.c \
 luasocket/except.c \
 luasocket/inet.c \
 luasocket/io.c \
 luasocket/luasocket.c \
 luasocket/mime.c \
 luasocket/options.c \
 luasocket/select.c \
 luasocket/tcp.c \
 luasocket/timeout.c \
 luasocket/udp.c \
 luasocket/usocket.c \
 luasocket/compat.c \
 lsqlite3/sqlite3.c \
 lsqlite3/lsqlite3.c \
 lpack.c \
 -fPIC\
 -o $outpath/x86/libtolua.so \
 -I./ \
 -I$luapath/src \
 -Iluasocket \
 -Wl,--whole-archive $outpath/x86/$lualibname.a -Wl,--no-whole-archive -static-libgcc -static-libstdc++

if [ "$?" = "0" ]; then
	echo -e "\n[MAINTAINCE] build libtolua.so success"
else
	echo -e "\n[MAINTAINCE] build libtolua.so failed"
fi
