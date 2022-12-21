use crate::domain::error::repositoryerror::RepositoryError;
use crate::domain::model::{
    lang::{AddLang, Lang, UpdateLang},
    word::{AddWord, UpdateWord, Word},
};
use crate::domain::repository::{langrepository::LangRepository, wordrepository::WordRepository};

use axum::async_trait;
use sqlx::PgPool;

#[derive(Debug, Clone)]
pub struct RepositoryForDb {
    pool: PgPool,
}
impl RepositoryForDb {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}
#[async_trait]
impl LangRepository for RepositoryForDb {
    async fn add(&self, payload: AddLang) -> anyhow::Result<Lang> {
        let lang = sqlx::query_as::<_, Lang>(
            r#"
                insert into languages (name)
                values ($1)
                returning *
            "#,
        )
        .bind(payload.name.clone())
        .fetch_one(&self.pool)
        .await?;

        Ok(lang)
    }

    async fn all(&self) -> anyhow::Result<Vec<Lang>> {
        let langs = sqlx::query_as::<_, Lang>(
            r#"
                select *
                from languages
                order by id desc
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(langs)
    }

    async fn update(&self, id: i32, payload: UpdateLang) -> anyhow::Result<Lang> {
        let lang = sqlx::query_as::<_, Lang>(
            r#"
                update languages
                set name=$1
                where id=$2
                returning *
            "#,
        )
        .bind(payload.name.clone())
        .bind(id)
        .fetch_one(&self.pool)
        .await?;

        Ok(lang)
    }

    async fn delete(&self, id: i32) -> anyhow::Result<()> {
        sqlx::query(
            r#"
                delete
                from languages
                where id=$1
            "#,
        )
        .bind(id)
        .execute(&self.pool)
        .await
        .map_err(|e| match e {
            sqlx::Error::RowNotFound => RepositoryError::NotFound(id),
            _ => RepositoryError::Unexpected(e.to_string()),
        })?;

        Ok(())
    }
}

#[async_trait]
impl WordRepository for RepositoryForDb {
    async fn add(&self, lang_id: i32, payload: AddWord) -> anyhow::Result<Word> {
        let word = sqlx::query_as::<_, Word>(
            r#"
                insert into words (name, means, lang_id)
                values ($1, $2, $3)
                returning *
                "#,
        )
        .bind(payload.name.clone())
        .bind(payload.means.clone())
        .bind(lang_id)
        .fetch_one(&self.pool)
        .await?;

        Ok(word)
    }

    async fn all(&self, lang_id: i32) -> anyhow::Result<Vec<Word>> {
        let words = sqlx::query_as::<_, Word>(
            r#"
                select *
                from words
                where lang_id=$1
                order by id desc
            "#,
        )
        .bind(lang_id)
        .fetch_all(&self.pool)
        .await?;

        Ok(words)
    }

    async fn update(&self, lang_id: i32, id: i32, payload: UpdateWord) -> anyhow::Result<Word> {
        let word = sqlx::query_as::<_, Word>(
            r#"
                update words
                set name=$1, means=$2, lang_id=$3
                where id=$4
                returning *
            "#,
        )
        .bind(payload.name.clone())
        .bind(payload.means.clone())
        .bind(lang_id)
        .bind(id)
        .fetch_one(&self.pool)
        .await?;

        Ok(word)
    }

    async fn delete(&self, lang_id: i32, id: i32) -> anyhow::Result<()> {
        sqlx::query(
            r#"
                delete from words
                where id=$1 AND lang_id=$2
            "#,
        )
        .bind(id)
        .bind(lang_id)
        .execute(&self.pool)
        .await
        .map_err(|e| match e {
            sqlx::Error::RowNotFound => RepositoryError::NotFound(id),
            _ => RepositoryError::Unexpected(e.to_string()),
        })?;

        Ok(())
    }
}
