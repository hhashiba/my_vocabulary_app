-- ListPage and Top => elm-ui
-- Other => Html.Attribute


module Css exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (style)



--register&edit


saveErrorStyle : List (Attribute msg)
saveErrorStyle =
    [ style "text-align" "center" ]


formViewStyle : List (Attribute msg)
formViewStyle =
    [ style "width" "100%"
    , style "height" "100%"
    , style "margin-top" "50px"
    ]


viewH1Style : List (Attribute msg)
viewH1Style =
    [ style "text-align" "center"
    , style "font-size" "30px"
    ]


viewFormStyle : List (Attribute msg)
viewFormStyle =
    [ style "width" "400px"
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


viewFormSelectStyle : List (Attribute msg)
viewFormSelectStyle =
    [ style "width" "250px"
    , style "height" "30px"
    , style "margin-top" "10px"
    , style "text-align" "center"
    , style "font-weight" "bold"
    , style "border-radius" "5px"
    , style "border" "solid 1px solid 1px rgba(0, 0, 0, 0.8)"
    ]


viewFormButtonStyle : List (Attribute msg)
viewFormButtonStyle =
    [ style "width" "120px"
    , style "height" "40px"
    , style "margin-top" "20px"
    , style "border-radius" "10px"
    , style "border" "solid 1px rgba(0, 0, 0, 0.2)"
    , style "background-color" "#36bcff"
    , style "color" "#ffffff"
    ]


viewFormFieldStyle : List (Attribute msg)
viewFormFieldStyle =
    [ style "margin-top" "50px" ]


viewFormFieldInputStyle : List (Attribute msg)
viewFormFieldInputStyle =
    [ style "width" "250px"
    , style "height" "25px"
    , style "border-radius" "5px"
    , style "border" "solid 1px rgba(0, 0, 0, 0.8)"
    , style "font-size" "20px"
    , style "text-align" "center"
    , style "margin-top" "10px"
    ]
