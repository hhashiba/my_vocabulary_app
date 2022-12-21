use crate::domain::model::{
    lang::{AddLang, UpdateLang},
    word::{AddWord, UpdateWord},
};
use crate::domain::repository::{langrepository::LangRepository, wordrepository::WordRepository};

use axum::{
    extract::{Extension, Path},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use std::sync::Arc;

pub async fn add_lang<T: LangRepository>(
    Json(payload): Json<AddLang>,
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let lang = repository
        .add(payload)
        .await
        .or(Err(StatusCode::NOT_FOUND))?;
    Ok((StatusCode::CREATED, Json(lang)))
}

pub async fn all_lang<T: LangRepository>(
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let langs = repository.all().await.unwrap();

    Ok((StatusCode::OK, Json(langs)))
}

// /languages/:lang_id
pub async fn update_lang<T: LangRepository>(
    Path(id): Path<i32>,
    Json(payload): Json<UpdateLang>,
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let lang = repository
        .update(id, payload)
        .await
        .or(Err(StatusCode::NOT_FOUND))?;

    Ok((StatusCode::OK, Json(lang)))
}

pub async fn delete_lang<T: LangRepository>(
    Path(id): Path<i32>,
    Extension(repository): Extension<Arc<T>>,
) -> StatusCode {
    repository
        .delete(id)
        .await
        .map(|_| StatusCode::NO_CONTENT)
        .unwrap_or(StatusCode::NOT_FOUND)
}

pub async fn add_word<T: WordRepository>(
    Path(lang_id): Path<i32>,
    Json(payload): Json<AddWord>,
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let word = repository
        .add(lang_id, payload)
        .await
        .or(Err(StatusCode::NOT_FOUND))?;

    Ok((StatusCode::CREATED, Json(word)))
}

pub async fn all_word<T: WordRepository>(
    Path(lang_id): Path<i32>,
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let words = repository.all(lang_id).await.unwrap();

    Ok((StatusCode::OK, Json(words)))
}

// /languages/:lang_id/:id
pub async fn update_word<T: WordRepository>(
    Path((lang_id, id)): Path<(i32, i32)>,
    Json(payload): Json<UpdateWord>,
    Extension(repository): Extension<Arc<T>>,
) -> Result<impl IntoResponse, StatusCode> {
    let word = repository
        .update(lang_id, id, payload)
        .await
        .or(Err(StatusCode::NOT_FOUND))?;

    Ok((StatusCode::OK, Json(word)))
}

pub async fn delete_word<T: WordRepository>(
    Path((lang_id, id)): Path<(i32, i32)>,
    Extension(repository): Extension<Arc<T>>,
) -> StatusCode {
    repository
        .delete(lang_id, id)
        .await
        .map(|_| StatusCode::NO_CONTENT)
        .unwrap_or(StatusCode::NOT_FOUND)
}
