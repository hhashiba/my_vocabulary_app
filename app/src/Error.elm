module Error exposing (buildErrorMessage, viewDeleteError, viewFetchError)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (style)
import Http


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Sever is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach the server"

        Http.BadStatus statusCode ->
            "Request failed with status code : " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


viewFetchError : String -> Html msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch posts at this time."
    in
    div [ style "text-align" "center" ]
        [ h2 [] [ text errorHeading ]
        , text ("Error : " ++ errorMessage)
        ]


viewDeleteError : Maybe String -> Html msg
viewDeleteError deleteError =
    case deleteError of
        Just error ->
            div []
                [ h2 [] [ text "Couldn't delete post at this time." ]
                , text ("Error : " ++ error)
                ]

        Nothing ->
            text ""
