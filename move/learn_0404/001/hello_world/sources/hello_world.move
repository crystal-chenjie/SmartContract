/*
/// Module: hello_world
module hello_world::hello_world;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

// Imports the `String` type from the Standard Library
module hello_world::hello_world;
use std::string::String;

/// Returns the "Hello, World!" as a `String`.
public fun hello(): String {
    b"Hello, World!".to_string()
}