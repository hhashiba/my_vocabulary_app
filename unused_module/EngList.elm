module Page.EngList exposing (Model, Msg, init, update, view)

import Element exposing (Element, alignRight, centerX, centerY, column, explain, fill, height, htmlAttribute, layout, link, padding, paddingEach, paddingXY, px, rgba255, row, spacing, table, text, width)
import Element.Background exposing (color)
import Element.Input exposing (button)
import Error exposing (buildErrorMessage, viewDeleteError, viewFetchError)
import Html exposing (Html)
import Http
import Page.Top exposing (Msg)
import RemoteData exposing (WebData)
import Word exposing (Word, WordId, initialWord, stringFromId, wordsDecoder)


type alias Model =
    { words : WebData (List Word)
    , deleteError : Maybe String
    }


type Msg
    = WordsReceived (WebData (List Word))
    | DeleteWord Word
    | WordDeleted (Result Http.Error String)


init : String -> ( Model, Cmd Msg )
init language =
    ( initialModel, fetchWords language )


initialModel : Model
initialModel =
    { words = RemoteData.Loading
    , deleteError = Nothing
    }


fetchWords : String -> Cmd Msg
fetchWords language =
    Http.get
        { url = "http://localhost:4242/" ++ language
        , expect =
            wordsDecoder
                |> Http.expectJson (RemoteData.fromResult >> WordsReceived)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WordsReceived response ->
            ( { model | words = response }, Cmd.none )

        DeleteWord word ->
            ( model, deleteWord word )

        WordDeleted (Ok _) ->
            let
                word =
                    case model.words of
                        RemoteData.Success words ->
                            Maybe.withDefault initialWord (List.head words)

                        _ ->
                            initialWord
            in
            ( model, fetchWords word.language )

        WordDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )


deleteWord : Word -> Cmd Msg
deleteWord word =
    let
        path =
            word.language ++ "/" ++ stringFromId word.id
    in
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:4242/" ++ path
        , body = Http.emptyBody
        , expect = Http.expectString WordDeleted
        , timeout = Nothing
        , tracker = Nothing
        }


view : Model -> Html Msg
view model =
    layout [] <|
        column [ height fill, width fill ]
            [ column [ centerX, width (px 700) ]
                [ row [ alignRight ]
                    [ button [ padding 10, color (rgba255 100 100 100 1) ]
                        { onPress = Nothing
                        , label =
                            link []
                                { url = "/register"
                                , label = text "New Word"
                                }
                        }
                    ]
                , viewWordList model
                ]
            ]



-- , viewDeleteError model.deleteError


viewWordList : Model -> Element Msg
viewWordList model =
    case model.words of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            row [] [ text "Loading.." ]

        RemoteData.Success words ->
            viewTable words

        RemoteData.Failure httpError ->
            -- viewFetchError (buildErrorMessage httpError)
            text "Error"


viewTable : List Word -> Element Msg
viewTable words =
    column [ height fill, width fill, centerX, centerY ]
        [ table [ centerX, width (px 600) ]
            { data = words
            , columns =
                [ { header =
                        row [ paddingXY 50 20 ]
                            [ text "Word" ]
                  , width = fill
                  , view =
                        \word ->
                            text word.name
                  }
                , { header =
                        row [ paddingXY 50 20 ]
                            [ text "Means" ]
                  , width = fill
                  , view =
                        \word ->
                            text word.means
                  }
                , { header =
                        row [ paddingXY 50 20 ]
                            [ text "Edit" ]
                  , width = fill
                  , view =
                        \word ->
                            link []
                                { url = "/" ++ word.language ++ "/" ++ stringFromId word.id
                                , label =
                                    button []
                                        { onPress = Nothing
                                        , label = text "E"
                                        }
                                }
                  }
                , { header =
                        row [ width fill, paddingXY 50 20, centerX, explain Debug.todo ]
                            [ text "Delete" ]
                  , width = fill
                  , view =
                        \word ->
                            button [ centerX, explain Debug.todo ]
                                { onPress = Just (DeleteWord word)
                                , label = row [ centerX ] [ text "D" ]
                                }
                  }
                ]
            }
        ]
