module Page.Register exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage)
import Form exposing (FormError, FormField(..))
import Html exposing (Html, br, button, div, h1, input, label, li, option, select, strong, text)
import Html.Attributes exposing (hidden, style, type_, value)
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
                Just _ ->
                    div [ style "text-align" "center" ] [ Form.viewSaveError model.registerError ]

                Nothing ->
                    div
                        [ style "width" "100%"
                        , style "height" "100%"
                        , style "margin-top" "50px"
                        ]
                        [ h1
                            [ style "text-align" "center"
                            , style "font-size" "30px"
                            ]
                            [ text "New Word" ]
                        , viewRegisterForm model
                        ]
    in
    registerForm


viewRegisterForm : Model -> Html Msg
viewRegisterForm model =
    Html.form
        [ onSubmit RegisterWord
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
        [ registerFormElement Name model.formErrors "Word" StoreName
        , registerFormElement Means model.formErrors "Means" StoreMeans
        , div []
            [ strong [] [ text "Language" ]
            , br [] []
            , select
                [ onInput SelectLanguage
                , style "width" "250px"
                , style "height" "30px"
                , style "margin-top" "10px"
                , style "text-align" "center"
                , style "font-weight" "bold"
                , style "border-radius" "5px"
                , style "border" "solid 1px solid 1px rgba(0, 0, 0, 0.8)"
                ]
                [ option
                    [ value ""
                    , hidden True
                    ]
                    [ text "Select Language" ]
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
            [ text "Register" ]
        ]


registerFormElement : FormField -> List FormError -> String -> (String -> Msg) -> Html Msg
registerFormElement formField errors inputLabel msg =
    label [ style "margin-top" "50px" ]
        [ strong [] [ text inputLabel ]
        , br [] []
        , input
            [ type_ "text"
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
