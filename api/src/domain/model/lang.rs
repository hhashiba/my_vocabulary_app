use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Deserialize, Serialize, Clone, FromRow)]
pub struct Lang {
    pub id: i32,
    pub name: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct AddLang {
    pub name: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct UpdateLang {
    pub name: String,
}
