use crate::domain::repository::{langrepository::LangRepository, wordrepository::WordRepository};
use crate::handler::handler::{
    add_lang, add_word, all_lang, all_word, delete_lang, delete_word, update_lang, update_word,
};

use axum::{
    extract::Extension,
    http::Method,
    routing::{get, patch},
    Router,
};
use http::header::CONTENT_TYPE;
use std::sync::Arc;
use tower_http::cors::{CorsLayer, Origin};

pub fn create_app<T: LangRepository + WordRepository>(repository: T) -> Router {
    Router::new()
        .route("/languages", get(all_lang::<T>).post(add_lang::<T>))
        .route(
            "/languages/:lang_id",
            get(all_word::<T>)
                .post(add_word::<T>)
                .patch(update_lang::<T>)
                .delete(delete_lang::<T>),
        )
        .route(
            "/languages/:lang_id/:id",
            patch(update_word::<T>).delete(delete_word::<T>),
        )
        .layer(
            CorsLayer::new()
                .allow_origin(Origin::exact("http://localhost:8000".parse().unwrap()))
                .allow_headers([CONTENT_TYPE])
                .allow_methods(vec![
                    Method::GET,
                    Method::POST,
                    Method::PATCH,
                    Method::DELETE,
                ]),
        )
        .layer(Extension(Arc::new(repository)))
}
