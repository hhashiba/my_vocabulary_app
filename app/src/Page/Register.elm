module Page.Register exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Css exposing (formViewStyle, saveErrorStyle, viewFormButtonStyle, viewFormFieldInputStyle, viewFormFieldStyle, viewFormSelectStyle, viewFormStyle, viewH1Style)
import Error exposing (buildErrorMessage)
import Form exposing (FormError, FormField(..))
import Html exposing (Html, br, button, div, h1, input, label, option, select, strong, text)
import Html.Attributes exposing (hidden, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Route
import Validate
import Word exposing (Word, initialWord, wordDecoder, wordEncoder)


type alias Model =
    { word : Word
    , formErrors : List FormError
    , registerError : Maybe String
    , navKey : Nav.Key
    }


type Msg
    = StoreName String
    | StoreMeans String
    | SelectLanguage String
    | RegisterWord
    | WordRegistered (Result Http.Error Word)


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { word = initialWord
    , formErrors = []
    , registerError = Nothing
    , navKey = navKey
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newWord =
            model.word
    in
    case msg of
        StoreName name ->
            let
                storeName =
                    { newWord | name = name }
            in
            ( { model | word = storeName }, Cmd.none )

        StoreMeans means ->
            let
                storeMeans =
                    { newWord | means = means }
            in
            ( { model | word = storeMeans }, Cmd.none )

        SelectLanguage language ->
            let
                storeLanguage =
                    { newWord | language = language }
            in
            ( { model | word = storeLanguage }, Cmd.none )

        RegisterWord ->
            case Validate.validate Form.formValidator model.word of
                Ok _ ->
                    ( { model | formErrors = [] }
                    , registerWord model.word
                    )

                Err errors ->
                    ( { model | formErrors = errors }
                    , Cmd.none
                    )

        WordRegistered (Ok word) ->
            let
                route =
                    Route.List word.language
            in
            ( { model | word = word }
            , Route.pushUrl route model.navKey
            )

        WordRegistered (Err httpError) ->
            ( { model | registerError = Just (buildErrorMessage httpError) }, Cmd.none )


registerWord : Word -> Cmd Msg
registerWord word =
    Http.post
        { url = "http://localhost:4242/" ++ word.language
        , body = Http.jsonBody (wordEncoder word)
        , expect = Http.expectJson WordRegistered wordDecoder
        }


view : Model -> Html Msg
view model =
    let
        registerForm =
            case model.registerError of
                Just error ->
                    div
                        saveErrorStyle
                        [ Form.viewSaveError error ]

                Nothing ->
                    div
                        formViewStyle
                        [ h1
                            viewH1Style
                            [ text "New Word" ]
                        , viewRegisterForm model
                        ]
    in
    registerForm


viewRegisterForm : Model -> Html Msg
viewRegisterForm model =
    Html.form
        (onSubmit RegisterWord :: viewFormStyle)
        [ registerFormField Name model.formErrors "Word" StoreName
        , registerFormField Means model.formErrors "Means" StoreMeans
        , div []
            [ strong [] [ text "Language" ]
            , br [] []
            , select
                (onInput SelectLanguage :: viewFormSelectStyle)
                [ option
                    [ value "", hidden True ]
                    [ text "Select Language" ]
                , option [ value "english" ] [ text "ENGLISH" ]
                , option [ value "korean" ] [ text "KOREAN" ]
                ]
            , Form.viewFormErrors Language model.formErrors
            ]
        , button
            viewFormButtonStyle
            [ text "Register" ]
        ]


registerFormField : FormField -> List FormError -> String -> (String -> Msg) -> Html Msg
registerFormField formField errors inputLabel msg =
    label viewFormFieldStyle
        [ strong [] [ text inputLabel ]
        , br [] []
        , input
            ([ type_ "text", onInput msg ]
                ++ viewFormFieldInputStyle
            )
            []
        , Form.viewFormErrors formField errors
        ]
