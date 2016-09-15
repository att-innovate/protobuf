#!/bin/bash
cd ../ext/google/protobuf/
make clean
set -e

phpize && ./configure --enable-debug CFLAGS='-g -O0' && make
cd -

tests=( array_test.php encode_decode_test.php generated_class_test.php map_field_test.php )

for t in "${tests[@]}"
do
  echo "****************************"
  echo "* $t"
  echo "****************************"
  php -dextension=../ext/google/protobuf/modules/protobuf.so `which phpunit` $t
  echo ""
done

# Make sure to run the memory test in debug mode.
php -dextension=../ext/google/protobuf/modules/protobuf.so memory_leak_test.php

USE_ZEND_ALLOC=0 valgrind --leak-check=yes php -dextension=../ext/google/protobuf/modules/protobuf.so memory_leak_test.php
