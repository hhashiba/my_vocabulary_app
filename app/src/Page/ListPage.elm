module Page.ListPage exposing (Model, Msg, init, update, view)

import Css
import Element exposing (Element, alignRight, centerX, column, el, fill, layout, link, paddingXY, px, rgba255, row, table, text)
import Element.Input as Input exposing (button, checkbox)
import Error exposing (buildErrorMessage)
import Html exposing (Html)
import Http
import RemoteData exposing (WebData)
import Word exposing (Word, initialWord, stringFromId, wordsDecoder)


type alias Model =
    { words : WebData (List Word)
    , deleteError : Maybe String
    , invisibleWord : Bool
    , invisibleMeans : Bool
    }


type Msg
    = WordsReceived (WebData (List Word))
    | DeleteWord Word
    | WordDeleted (Result Http.Error String)
    | InvisibleWord Bool
    | InvisibleMeans Bool


init : String -> ( Model, Cmd Msg )
init language =
    ( initialModel, fetchWords language )


initialModel : Model
initialModel =
    { words = RemoteData.Loading
    , deleteError = Nothing
    , invisibleMeans = False
    , invisibleWord = False
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

        InvisibleMeans _ ->
            ( { model | invisibleMeans = not model.invisibleMeans }
            , Cmd.none
            )

        InvisibleWord _ ->
            ( { model | invisibleWord = not model.invisibleWord }
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
    let
        newWordButton =
            case model.words of
                RemoteData.Success _ ->
                    row [ alignRight ]
                        [ button
                            Css.listPageViewNewWordButtonStyle
                            { onPress = Nothing
                            , label =
                                link []
                                    { url = "/register"
                                    , label = text "New Word"
                                    }
                            }
                        ]

                _ ->
                    text ""

        content =
            case model.deleteError of
                Just _ ->
                    viewDeleteError model.deleteError

                Nothing ->
                    column Css.listPageViewBodyStyle
                        [ column
                            Css.listPageViewContentsStyle
                            [ newWordButton
                            , viewWordList model
                            ]
                        ]
    in
    layout [] <| content



-- , viewDeleteError model.deleteError


viewWordList : Model -> Element Msg
viewWordList model =
    case model.words of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            row
                Css.listPageViewWordLoadingStyle
                [ text "Loading.." ]

        RemoteData.Success words ->
            viewTable words model.invisibleMeans model.invisibleWord

        RemoteData.Failure httpError ->
            let
                errorHeading =
                    "Couldn't fetch posts at this time."
            in
            viewWordListError errorHeading (buildErrorMessage httpError)


viewTable : List Word -> Bool -> Bool -> Element Msg
viewTable words invisibleMeans invisibleWord =
    column
        Css.listPageViewTableColumnStyle
        [ table Css.listPageViewTableStyle
            { data = words
            , columns =
                [ { header = viewTableHeader "Word" invisibleWord InvisibleWord
                  , width = px 200
                  , view =
                        \word ->
                            row
                                (Css.listPageViewTableRowStyle invisibleWord)
                                [ text word.name ]
                  }
                , { header = viewTableHeader "Means" invisibleMeans InvisibleMeans
                  , width = px 300
                  , view =
                        \word ->
                            row
                                (Css.listPageViewTableRowStyle invisibleMeans)
                                [ text word.means ]
                  }
                , { header =
                        row [ paddingXY 30 40 ]
                            [ el
                                [ centerX ]
                                (text "Edit")
                            ]
                  , width = fill
                  , view =
                        \word ->
                            row []
                                [ button
                                    (Css.listPageViewTableRowButtonStyle
                                        (rgba255 85 250 91 1)
                                        (rgba255 70 200 80 1)
                                    )
                                    { onPress = Nothing
                                    , label =
                                        link [ centerX ]
                                            { url = "/" ++ word.language ++ "/" ++ stringFromId word.id
                                            , label = text "E"
                                            }
                                    }
                                ]
                  }
                , { header =
                        row [ paddingXY 30 40 ]
                            [ el
                                [ centerX ]
                                (text "Delete")
                            ]
                  , width = fill
                  , view =
                        \word ->
                            row []
                                [ button
                                    (Css.listPageViewTableRowButtonStyle
                                        (rgba255 255 90 80 1)
                                        (rgba255 255 40 40 1)
                                    )
                                    { onPress = Just (DeleteWord word)
                                    , label = row [ centerX ] [ text "D" ]
                                    }
                                ]
                  }
                ]
            }
        ]


viewTableHeader : String -> Bool -> (Bool -> Msg) -> Element Msg
viewTableHeader labelText check msg =
    row Css.listPageViewTableHeaderStyle
        [ column [ centerX ]
            [ text labelText ]
        , column [ centerX ]
            [ checkbox []
                { onChange = msg
                , icon = Input.defaultCheckbox
                , checked = check
                , label = Input.labelRight [] <| text "invisible"
                }
            ]
        ]


viewDeleteError : Maybe String -> Element Msg
viewDeleteError deleteError =
    let
        errorHeading =
            "Couldn't delete post at this time."
    in
    case deleteError of
        Just error ->
            viewWordListError errorHeading error

        Nothing ->
            text ""


viewWordListError : String -> String -> Element Msg
viewWordListError errorHeading errorMsg =
    column
        Css.listPageViewWordListErrorStyle
        [ el
            Css.listPageViewWordListErrorHeadingStyle
            (text errorHeading)
        , el
            Css.listPageViewWordListErrorMsgStyle
            (text ("Error : " ++ errorMsg))
        ]
