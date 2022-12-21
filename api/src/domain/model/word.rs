use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Serialize, Deserialize, Debug, Clone, FromRow)]
pub struct Word {
    pub id: i32,
    pub name: String,
    pub means: String,
    pub lang_id: i32,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AddWord {
    pub name: String,
    pub means: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UpdateWord {
    pub name: String,
    pub means: String,
}
