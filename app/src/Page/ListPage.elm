module Page.ListPage exposing (Model, Msg, init, update, view)

import Element exposing (Element, alignLeft, alignRight, centerX, centerY, column, el, explain, fill, height, layout, link, mouseOver, none, padding, paddingEach, paddingXY, px, rgba255, row, spacing, spacingXY, table, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input exposing (button, checkbox)
import Error exposing (buildErrorMessage)
import Html exposing (Html)
import Http
import Page.Top exposing (Msg)
import RemoteData exposing (WebData)
import Word exposing (Word, initialWord, stringFromId, wordsDecoder)


type alias Model =
    { words : WebData (List Word)
    , deleteError : Maybe String
    , invisibleMeans : Bool
    , invisibleWord : Bool
    }


type Msg
    = WordsReceived (WebData (List Word))
    | DeleteWord Word
    | WordDeleted (Result Http.Error String)
    | InvisibleMeans Bool
    | InvisibleWord Bool


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
                            [ width fill
                            , height fill
                            , padding 18
                            , Background.color (rgba255 255 250 150 1)
                            , Border.rounded 10
                            , Border.solid
                            , Border.color (rgba255 0 0 0 0.2)
                            , Border.width 1
                            , mouseOver
                                [ Background.color (rgba255 255 240 100 1) ]
                            ]
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

        wordList =
            case model.deleteError of
                Just _ ->
                    viewDeleteError model.deleteError

                Nothing ->
                    column [ height fill, width fill, paddingXY 0 50, Font.semiBold ]
                        [ column
                            [ centerX
                            , width (px 1000)
                            , spacing 20
                            ]
                            [ newWordButton
                            , viewWordList model
                            ]
                        ]
    in
    layout [] <| wordList



-- , viewDeleteError model.deleteError


viewWordList : Model -> Element Msg
viewWordList model =
    case model.words of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            row
                [ centerX
                , centerY
                , Font.italic
                , Font.bold
                , Font.size 30
                , Font.letterSpacing 3
                ]
                [ text "Loading.." ]

        RemoteData.Success words ->
            viewTable words model.invisibleMeans model.invisibleWord

        RemoteData.Failure httpError ->
            let
                errorHeading =
                    "Couldn't fetch posts at this time."
            in
            column
                [ spacing 30
                , Font.family
                    [ Font.typeface "Hiragino Kaku Gothic ProN"
                    , Font.sansSerif
                    ]
                , centerX
                ]
                [ el
                    [ Font.bold
                    , Font.size 24
                    ]
                    (text errorHeading)
                , el
                    [ Font.size 16
                    , Font.regular
                    , centerX
                    ]
                    (text ("Error : " ++ buildErrorMessage httpError))
                ]


viewTable : List Word -> Bool -> Bool -> Element Msg
viewTable words invisibleMeans invisibleWord =
    column
        [ height fill
        , width (px 1000)
        , centerX
        , centerY
        , Background.color (rgba255 200 200 200 0.8)
        , paddingEach { top = 20, right = 60, bottom = 70, left = 60 }
        , Border.rounded 10
        ]
        [ table [ centerX, width fill, spacing 10 ]
            { data = words
            , columns =
                [ { header =
                        row [ paddingXY 30 40, spacing 10 ]
                            [ column [ centerX ]
                                [ text "Word" ]
                            , column [ centerX ]
                                [ checkbox []
                                    { onChange = InvisibleWord
                                    , icon = Input.defaultCheckbox
                                    , checked = invisibleWord
                                    , label = Input.labelRight [] <| text "invisible"
                                    }
                                ]
                            ]
                  , width = px 200
                  , view =
                        let
                            fontColor =
                                if invisibleWord then
                                    Font.color (rgba255 255 255 255 1)

                                else
                                    Font.color (rgba255 0 0 0 1)

                            hoverColor =
                                if invisibleWord then
                                    mouseOver [ Font.color (rgba255 0 0 0 1) ]

                                else
                                    mouseOver [ Font.color (rgba255 0 0 0 1) ]
                        in
                        \word ->
                            row
                                [ padding 10
                                , centerY
                                , centerX
                                , Background.color (rgba255 255 255 255 1)
                                , Border.rounded 5
                                , fontColor
                                , hoverColor
                                ]
                                [ text word.name ]
                  }
                , { header =
                        row [ paddingXY 30 40, spacing 10 ]
                            [ column [ centerX ]
                                [ text "Means" ]
                            , column [ centerX ]
                                [ checkbox []
                                    { onChange = InvisibleMeans
                                    , icon = Input.defaultCheckbox
                                    , checked = invisibleMeans
                                    , label = Input.labelRight [] <| text "invisible"
                                    }
                                ]
                            ]
                  , width = px 300
                  , view =
                        let
                            fontColor =
                                if invisibleMeans then
                                    Font.color (rgba255 255 255 255 1)

                                else
                                    Font.color (rgba255 0 0 0 1)

                            hoverColor =
                                if invisibleMeans then
                                    mouseOver [ Font.color (rgba255 0 0 0 1) ]

                                else
                                    mouseOver [ Font.color (rgba255 0 0 0 1) ]
                        in
                        \word ->
                            row
                                [ height (px 40)
                                , paddingXY 10 0
                                , centerY
                                , Background.color (rgba255 255 255 255 1)
                                , Border.rounded 5
                                , fontColor
                                , hoverColor
                                ]
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
                                    [ width (px 40)
                                    , height (px 40)
                                    , centerX
                                    , centerY
                                    , Background.color (rgba255 85 250 91 1)
                                    , Border.rounded 50
                                    , Border.solid
                                    , Border.color (rgba255 0 0 0 0.2)
                                    , Border.width 1
                                    , mouseOver
                                        [ Background.color (rgba255 70 200 80 1) ]
                                    ]
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
                                    [ width (px 40)
                                    , height (px 40)
                                    , centerX
                                    , centerY
                                    , Background.color (rgba255 255 90 80 1)
                                    , Border.rounded 50
                                    , Border.solid
                                    , Border.color (rgba255 0 0 0 0.2)
                                    , Border.width 1
                                    , mouseOver
                                        [ Background.color (rgba255 255 40 40 1) ]
                                    ]
                                    { onPress = Just (DeleteWord word)
                                    , label = row [ centerX ] [ text "D" ]
                                    }
                                ]
                  }
                ]
            }
        ]


viewDeleteError : Maybe String -> Element Msg
viewDeleteError deleteError =
    let
        errorHeading =
            "Couldn't delete post at this time."
    in
    case deleteError of
        Just error ->
            column
                [ spacing 30
                , centerX
                , Font.family
                    [ Font.typeface "Hiragino Kaku Gothic ProN"
                    , Font.sansSerif
                    ]
                , paddingXY 0 50
                ]
                [ el
                    [ Font.bold
                    , Font.size 24
                    ]
                    (text errorHeading)
                , el
                    [ Font.size 16
                    , Font.regular
                    , centerX
                    ]
                    (text ("Error : " ++ error))
                ]

        Nothing ->
            text ""
