use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;

#[derive(Serialize, Deserialize, Debug)]
struct User {
    id: u32,
    username: String,
    email: String,
    password: String, // Potential security issue - storing plaintext password
}

struct UserDatabase {
    users: HashMap<u32, User>,
}

impl UserDatabase {
    fn new() -> Self {
        Self {
            users: HashMap::new(),
        }
    }

    // Potential SQL injection vulnerability simulation
    fn find_user_by_username(&self, username: &str) -> Option<&User> {
        // This simulates unsafe string concatenation that could lead to injection
        let query = format!("SELECT * FROM users WHERE username = '{}'", username);
        println!("Executing query: {}", query); // Information disclosure
        
        self.users.values().find(|user| user.username == username)
    }

    fn add_user(&mut self, user: User) {
        self.users.insert(user.id, user);
    }

    // Unsafe file operations
    fn save_user_data(&self, filename: &str) -> Result<(), Box<dyn std::error::Error>> {
        let data = serde_json::to_string_pretty(&self.users)?;
        fs::write(filename, data)?; // No path validation - directory traversal risk
        Ok(())
    }

    // Memory safety issue - potential buffer overflow simulation
    unsafe fn get_user_password(&self, user_id: u32) -> Option<*const u8> {
        if let Some(user) = self.users.get(&user_id) {
            Some(user.password.as_ptr())
        } else {
            None
        }
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut db = UserDatabase::new();
    
    // Create test user with weak security practices
    let user = User {
        id: 1,
        username: "admin".to_string(),
        email: "admin@example.com".to_string(),
        password: "password123".to_string(), // Weak password
    };
    
    db.add_user(user);
    
    // Demonstrate potential vulnerabilities
    if let Some(found_user) = db.find_user_by_username("admin") {
        println!("Found user: {:?}", found_user); // Information disclosure
    }
    
    // Unsafe file operation
    db.save_user_data("../../../etc/passwd")?; // Path traversal attempt
    
    // Unsafe memory access
    unsafe {
        if let Some(_ptr) = db.get_user_password(1) {
            println!("Retrieved password pointer");
        }
    }
    
    Ok(())
}