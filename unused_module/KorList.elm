module Page.KorList exposing (Model, Msg, init, update, view)

import Error exposing (buildErrorMessage, viewDeleteError, viewFetchError)
import Html exposing (Html, a, button, div, h2, table, td, text, th, tr)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Page.Top exposing (Msg)
import RemoteData exposing (WebData)
import String exposing (words)
import Word exposing (Word, WordId, stringFromId, wordsDecoder)


type alias Model =
    { words : WebData (List Word)
    , deleteError : Maybe String
    }


type Msg
    = FetchWords
    | WordsReceived (WebData (List Word))
    | DeleteWord WordId
    | WordDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchWords )


initialModel : Model
initialModel =
    { words = RemoteData.Loading
    , deleteError = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchWords ->
            ( { model | words = RemoteData.Loading }
            , fetchWords
            )

        WordsReceived response ->
            ( { model | words = response }, Cmd.none )

        DeleteWord wordId ->
            ( model, deleteWord wordId )

        WordDeleted (Ok _) ->
            ( model, fetchWords )

        WordDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )


fetchWords : Cmd Msg
fetchWords =
    Http.get
        { url = "http://localhost:4242/korean" --
        , expect =
            wordsDecoder
                |> Http.expectJson (RemoteData.fromResult >> WordsReceived)
        }


deleteWord : WordId -> Cmd Msg
deleteWord wordId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:4242/korean/" ++ stringFromId wordId --
        , body = Http.emptyBody
        , expect = Http.expectString WordDeleted
        , timeout = Nothing
        , tracker = Nothing
        }


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button []
                [ a [ href "/register" ]
                    [ text "단어등록" ]

                --
                ]
            ]
        , viewWordList model
        , viewDeleteError model.deleteError
        ]


viewWordList : Model -> Html Msg
viewWordList model =
    case model.words of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h2 [] [ text "Loading.." ]

        RemoteData.Success words ->
            div []
                [ table []
                    ([ tableHeader ] ++ List.map viewList words)
                ]

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


tableHeader : Html Msg
tableHeader =
    tr []
        [ th []
            [ text "단어" ]

        --
        , th []
            [ text "의미" ]

        --
        , th []
            [ text "펀집" ]

        --
        , th []
            [ text "삭제" ]

        --
        ]


viewList : Word -> Html Msg
viewList word =
    let
        wordPath =
            "/korean/" ++ stringFromId word.id

        --
    in
    tr []
        [ td []
            [ text word.name ]
        , td []
            [ text word.means ]
        , td []
            [ button []
                [ a [ href wordPath ]
                    [ text "E" ]
                ]
            ]
        , deleteButton word.id
        ]


deleteButton : WordId -> Html Msg
deleteButton wordId =
    td []
        [ button [ onClick (DeleteWord wordId) ]
            [ text "D" ]
        ]
