module Page.Edit exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage, viewFetchError)
import Form exposing (FormError, FormField(..))
import Html exposing (Html, br, button, div, h1, h2, input, label, option, p, select, strong, text)
import Html.Attributes exposing (hidden, style, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import RemoteData exposing (WebData)
import Route
import Validate
import Word exposing (Word, WordId, stringFromId, wordDecoder, wordEncoder)


type alias Model =
    { word : WebData Word
    , formErrors : List FormError
    , saveError : Maybe String
    , navKey : Nav.Key
    }


type Msg
    = WordReceived (WebData Word)
    | UpdateName String
    | UpdateMeans String
    | UpdateLanguage String
    | SaveEdit Word
    | EditSaved (Result Http.Error Word)


init : String -> WordId -> Nav.Key -> ( Model, Cmd Msg )
init language wordId navKey =
    ( initialModel navKey, fetchWord language wordId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { word = RemoteData.Loading
    , formErrors = []
    , saveError = Nothing
    , navKey = navKey
    }


fetchWord : String -> WordId -> Cmd Msg
fetchWord language wordId =
    let
        path =
            language ++ "/" ++ stringFromId wordId
    in
    Http.get
        { url = "http://localhost:4242/" ++ path
        , expect = Http.expectJson (RemoteData.fromResult >> WordReceived) wordDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WordReceived word ->
            ( { model | word = word }, Cmd.none )

        UpdateName name ->
            let
                updateName =
                    RemoteData.map
                        (\wordData ->
                            { wordData | name = name }
                        )
                        model.word
            in
            ( { model | word = updateName }, Cmd.none )

        UpdateMeans means ->
            let
                updateMeans =
                    RemoteData.map
                        (\wordData ->
                            { wordData | means = means }
                        )
                        model.word
            in
            ( { model | word = updateMeans }, Cmd.none )

        UpdateLanguage language ->
            let
                updateLanguage =
                    RemoteData.map
                        (\wordData ->
                            { wordData | language = language }
                        )
                        model.word
            in
            ( { model | word = updateLanguage }, Cmd.none )

        SaveEdit word ->
            case Validate.validate Form.formValidator word of
                Ok _ ->
                    ( { model | formErrors = [] }
                    , saveEdit model.word
                    )

                Err errors ->
                    ( { model | formErrors = errors }
                    , Cmd.none
                    )

        EditSaved (Ok wordData) ->
            let
                word =
                    RemoteData.Success wordData

                route =
                    Route.List wordData.language
            in
            ( { model | word = word }
            , Route.pushUrl route model.navKey
            )

        EditSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }
            , Cmd.none
            )


saveEdit : WebData Word -> Cmd Msg
saveEdit word =
    case word of
        RemoteData.Success wordData ->
            let
                path =
                    wordData.language ++ "/" ++ stringFromId wordData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = "http://localhost:4242/" ++ path
                , body = Http.jsonBody (wordEncoder wordData)
                , expect = Http.expectJson EditSaved wordDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


view : Model -> Html Msg
view model =
    let
        theme =
            case model.word of
                RemoteData.Success _ ->
                    "Edit Word"

                _ ->
                    ""
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "margin-top" "50px"
        ]
        [ h1
            [ style "text-align" "center"
            , style "font-size" "30px"
            ]
            [ text theme ]
        , viewWord model
        , Form.viewSaveError model.saveError
        ]


viewWord : Model -> Html Msg
viewWord model =
    case model.word of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            p
                [ style "text-align" "center"
                , style "font-style" "italic"
                , style "font-weight" "900"
                , style "font-size" "30px"
                , style "letter-spacing" "3px"
                ]
                [ text "Loading.." ]

        RemoteData.Success word ->
            viewEditForm model word

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


viewEditForm : Model -> Word -> Html Msg
viewEditForm model word =
    Html.form
        [ onSubmit (SaveEdit word)
        , style "width" "400px"
        , style "height" "400px"
        , style "text-align" "center"
        , style "margin-left" "auto"
        , style "margin-right" "auto"
        , style "margin-top" "10px"
        , style "background-color" "rgba(200, 200, 200, 0.8)"
        , style "border-radius" "5px"
        , style "border" "solid 1px rgba(0, 0, 0, 0.2)"
        , style "padding-top" "50px"
        , style "letter-spacing" "2px"
        ]
        [ editFormElement Name model.formErrors "Word" word.name UpdateName
        , editFormElement Means model.formErrors "Means" word.means UpdateMeans
        , div []
            [ strong [] [ text "Language" ]
            , br [] []
            , select
                [ onInput UpdateLanguage
                , style "width" "250px"
                , style "height" "30px"
                , style "margin-top" "10px"
                , style "text-align" "center"
                , style "font-weight" "bold"
                , style "border-radius" "5px"
                , style "border" "solid 1px solid 1px rgba(0, 0, 0, 0.8)"
                ]
                [ option [ hidden True, value word.language ] [ text (String.toUpper word.language) ]
                , option [ value "english" ] [ text "ENGLISH" ]
                , option [ value "korean" ] [ text "KOREAN" ]
                ]
            , Form.viewFormErrors Language model.formErrors
            ]
        , button
            [ style "width" "120px"
            , style "height" "40px"
            , style "margin-top" "20px"
            , style "border-radius" "10px"
            , style "border" "solid 1px rgba(0, 0, 0, 0.2)"
            , style "background-color" "#36bcff"
            , style "color" "#ffffff"
            ]
            [ text "Save" ]
        ]


editFormElement : FormField -> List FormError -> String -> String -> (String -> Msg) -> Html Msg
editFormElement formField errors inputLabel oldValue msg =
    label [ style "margin-top" "50px" ]
        [ strong [] [ text inputLabel ]
        , br [] []
        , input
            [ type_ "text"
            , value oldValue
            , onInput msg
            , style "width" "250px"
            , style "height" "25px"
            , style "border-radius" "5px"
            , style "border" "solid 1px rgba(0, 0, 0, 0.8)"
            , style "font-size" "20px"
            , style "text-align" "center"
            , style "margin-top" "10px"
            ]
            []
        , Form.viewFormErrors formField errors
        ]
