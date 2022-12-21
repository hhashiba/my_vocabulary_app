use crate::domain::model::lang::{AddLang, Lang, UpdateLang};

use axum::async_trait;

#[async_trait]
pub trait LangRepository: Clone + std::marker::Send + std::marker::Sync + 'static {
    async fn add(&self, payload: AddLang) -> anyhow::Result<Lang>;
    async fn all(&self) -> anyhow::Result<Vec<Lang>>;
    async fn update(&self, id: i32, payload: UpdateLang) -> anyhow::Result<Lang>;
    async fn delete(&self, id: i32) -> anyhow::Result<()>;
}
