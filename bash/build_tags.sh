set -x
set -e

if [ "$#" -eq 0 ]
then
        dirs=src
else
        dirs=$*
fi

echo "creating file list from $dirs..."

find -L $dirs -name '*.h' -or -name '*.cpp' -or -name '*.ipp' -or -name '*.hpp' >cscope.files
echo "building tags..."
ctags --c++-kinds=+p --fields=+ialS --extra=+q -L cscope.files
echo "building cross references..."
cscope -b -i cscope.files
