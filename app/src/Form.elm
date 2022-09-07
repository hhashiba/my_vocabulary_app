module Form exposing (FormError, FormField(..), formValidator, viewFormErrors, viewSaveError)

import Html exposing (Html, div, h2, p, strong, text)
import Html.Attributes exposing (style)
import Validate exposing (Validator, ifBlank)
import Word exposing (Word)


type FormField
    = Name
    | Means
    | Language


type alias FormError =
    ( FormField, String )


viewSaveError : Maybe String -> Html msg
viewSaveError maybeError =
    case maybeError of
        Just error ->
            div []
                [ h2 []
                    [ text "Couldn't save a word at this time." ]
                , text ("Error : " ++ error)
                ]

        Nothing ->
            text ""


viewFormErrors : FormField -> List FormError -> Html msg
viewFormErrors formField errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == formField)
        |> List.map
            (\( _, error ) ->
                strong
                    [ style "color" "red"
                    , style "font-size" "14px"
                    ]
                    [ text error ]
            )
        |> p []


formValidator : Validator ( FormField, String ) Word
formValidator =
    Validate.all
        [ Validate.firstError
            [ ifBlank .name ( Name, "Please enter a word" )
            , ifBlank .means ( Means, "Please enter the meaning of the word" )
            , ifBlank .language ( Language, "Please select a language" )
            ]
        ]
