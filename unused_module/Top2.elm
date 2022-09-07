module Page.Top2 exposing (Model, Msg, init, view)

import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (href)
import Http
import Json.Decode as Decode exposing (Decoder, string)
import Language exposing (Language)


type alias Model =
    { languages : List Language }


type Msg
    = LanguagesReceived (Result Http.Error (List Language))


init : ( Model, Cmd Msg )
init =
    ( [], fetchLanguages )


fetchLanguages : Cmd Msg
fetchLanguages =
    Http.get
        { url = "http://localhost:4242"
        , expect = Http.expectJson LanguagesReceived languagesDecoder
        }


languagesDecoder : Decoder string
languagesDecoder =
    Decode.map


view : Model -> Html msg
view model =
    div []
        [ div []
            [ button []
                [ a [ href "/register" ] [ text "+" ] ]
            ]
        , selectLangButton "English" "english"
        , selectLangButton "한국어" "korean"
        ]


selectLangButton : String -> String -> Html msg
selectLangButton buttonLabel path =
    div []
        [ button
            []
            [ a [ href path ] [ text buttonLabel ] ]
        ]
