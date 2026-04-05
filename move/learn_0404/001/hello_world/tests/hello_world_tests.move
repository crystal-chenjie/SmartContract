/*
#[test_only]
module hello_world::hello_world_tests;
// uncomment this line to import the module
// use hello_world::hello_world;

#[error(code = 0)]
const ENotImplemented: vector<u8> = b"Not Implemented";

#[test]
fun test_hello_world() {
    // pass
}

#[test, expected_failure(abort_code = ::hello_world::hello_world_tests::ENotImplemented)]
fun test_hello_world_fail() {
    abort ENotImplemented
}
*/

#[test_only]
module hello_world::hello_world_tests;

use hello_world::hello_world;
use std::debug;

const ENotImplemented: u64 = 0;

#[test]
fun test_hello_world() {
    debug::print(&hello_world::hello());
}

#[test, expected_failure(abort_code = ::hello_world::hello_world_tests::ENotImplemented)]
fun test_hello_world_fail() {
    abort ENotImplemented;
}