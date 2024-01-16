use std::collections::HashMap;

#[swift_bridge::bridge]
pub mod ffi_string_map {
    extern "Rust" {
        type RStringMap;

        #[swift_bridge(init, associated_to=RStringMap)]
        pub fn r_new() -> RStringMap;

        #[swift_bridge(associated_to=RStringMap)]
        pub fn r_get(self: &RStringMap, key: &str) -> Option<&str>;

        #[swift_bridge(associated_to=RStringMap)]
        pub fn r_insert(self: &mut RStringMap, key: String, value: String) -> Option<String>;

        #[swift_bridge(associated_to=RStringMap)]
        pub fn r_contains_key(self: &RStringMap, key: &str) -> bool;

        #[swift_bridge(associated_to=RStringMap)]
        pub fn r_change_or_insert(self: &mut RStringMap, key: String, new_value: String) -> &str;
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RStringMap(HashMap<String, String>);

impl RStringMap {
    pub fn r_new() -> Self {
        RStringMap { 0: HashMap::new() }
    }

    pub fn r_get(&self, key: &str) -> Option<&str> {
        if let Some(value) = self.0.get(key) {
            Some(value.as_str())
        } else {
            None
        }
    }

    pub fn r_insert(&mut self, key: String, value: String) -> Option<String> {
        self.0.insert(key, value)
    }

    pub fn r_contains_key(&self, key: &str) -> bool {
        self.0.contains_key(key)
    }

    pub fn r_change_or_insert(&mut self, key: String, new_value: String) -> &str {
        let nv = new_value.to_string();
        self.0
            .entry(key)
            .and_modify(|v| *v = new_value)
            .or_insert(nv)
            .as_str()
    }
}
