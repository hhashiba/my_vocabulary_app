use crate::domain::model::word::{AddWord, UpdateWord, Word};

use axum::async_trait;

#[async_trait]
pub trait WordRepository: Clone + std::marker::Send + std::marker::Sync + 'static {
    async fn add(&self, lang_id: i32, payload: AddWord) -> anyhow::Result<Word>;
    async fn all(&self, lang_id: i32) -> anyhow::Result<Vec<Word>>;
    async fn update(&self, lang_id: i32, id: i32, payload: UpdateWord) -> anyhow::Result<Word>;
    async fn delete(&self, lang_id: i32, id: i32) -> anyhow::Result<()>;
}
