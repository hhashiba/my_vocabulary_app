-- ListPage and Top => elm-ui
-- Other => Html.Attribute


module Css exposing (..)

import Element exposing (Color, centerX, centerY, fill, height, mouseOver, padding, paddingEach, paddingXY, px, rgba255, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (letterSpacing)
import Html
import Html.Attributes exposing (style)



-- main


mainViewHeaderStyle : List (Html.Attribute msg)
mainViewHeaderStyle =
    [ style "width" "100%"
    , style "height" "100px"
    , style "text-align" "center"
    , style "border-bottom" "1px solid #000000"
    ]


mainViewHeaderH1Style : List (Html.Attribute msg)
mainViewHeaderH1Style =
    [ style "margin-top" "30px"
    , style "margin-bottom" "20px"
    ]


mainViewHeaderAStyle : List (Html.Attribute msg)
mainViewHeaderAStyle =
    [ style "text-decoration" "none"
    , style "color" "#000000"
    , style "letter-spacing" "3px"
    , style "font-size" "40px"
    ]



--register&edit


commonSaveErrorStyle : List (Html.Attribute msg)
commonSaveErrorStyle =
    [ style "text-align" "center" ]


commonFormViewStyle : List (Html.Attribute msg)
commonFormViewStyle =
    [ style "width" "100%"
    , style "height" "100%"
    , style "margin-top" "50px"
    ]


commonViewFormH1Style : List (Html.Attribute msg)
commonViewFormH1Style =
    [ style "text-align" "center"
    , style "font-size" "30px"
    ]


commonViewFormStyle : List (Html.Attribute msg)
commonViewFormStyle =
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


commonViewFormSelectStyle : List (Html.Attribute msg)
commonViewFormSelectStyle =
    [ style "width" "250px"
    , style "height" "30px"
    , style "margin-top" "10px"
    , style "text-align" "center"
    , style "font-weight" "bold"
    , style "border-radius" "5px"
    , style "border" "solid 1px solid 1px rgba(0, 0, 0, 0.8)"
    ]


commonViewFormButtonStyle : List (Html.Attribute msg)
commonViewFormButtonStyle =
    [ style "width" "120px"
    , style "height" "40px"
    , style "margin-top" "20px"
    , style "border-radius" "10px"
    , style "border" "solid 1px rgba(0, 0, 0, 0.2)"
    , style "background-color" "#36bcff"
    , style "color" "#ffffff"
    ]


commonViewFormFieldStyle : List (Html.Attribute msg)
commonViewFormFieldStyle =
    [ style "margin-top" "50px" ]


commonViewFormFieldInputStyle : List (Html.Attribute msg)
commonViewFormFieldInputStyle =
    [ style "width" "250px"
    , style "height" "25px"
    , style "border-radius" "5px"
    , style "border" "solid 1px rgba(0, 0, 0, 0.8)"
    , style "font-size" "20px"
    , style "text-align" "center"
    , style "margin-top" "10px"
    ]


editViewWordLoadingStyle : List (Html.Attribute msg)
editViewWordLoadingStyle =
    [ style "text-align" "center"
    , style "font-style" "italic"
    , style "font-weight" "900"
    , style "font-size" "30px"
    , style "letter-spacing" "3px"
    ]



-- Top
-- common


topViewButtonLabelStyle : List (Element.Attribute msg)
topViewButtonLabelStyle =
    [ centerX, centerY ]


topViewStyle : List (Element.Attribute msg)
topViewStyle =
    [ width fill, height fill, Font.semiBold, paddingXY 0 50 ]


topViewNewWordColumnStyle : List (Element.Attribute msg)
topViewNewWordColumnStyle =
    [ spacing 20, centerX ]


topViewNewWordButtonStyle : List (Element.Attribute msg)
topViewNewWordButtonStyle =
    [ padding 10
    , Font.color (rgba255 0 0 0 1)
    , Background.color (rgba255 100 250 150 0.7)
    , Border.rounded 10
    , Border.solid
    , Border.color (rgba255 0 0 0 0.2)
    , Border.width 1
    , Font.size 20
    , mouseOver
        [ Background.color (rgba255 100 255 150 1) ]
    ]


topViewLangListStyle : List (Element.Attribute msg)
topViewLangListStyle =
    [ paddingEach { top = 40, right = 60, bottom = 70, left = 60 }
    , centerX
    , Font.semiBold
    , Background.color (rgba255 200 200 200 0.8)
    , Border.rounded 10
    , spacing 8
    ]


topViewLangStyle : List (Element.Attribute msg)
topViewLangStyle =
    [ width (px 220)
    , height (px 40)
    , padding 5
    , letterSpacing 5
    , Background.color (rgba255 255 255 255 1)
    , Border.rounded 10
    , Border.solid
    , Border.color (rgba255 0 0 0 0.2)
    , Border.width 1
    , centerX
    ]


topViewSelectLangButtonStyle : List (Element.Attribute msg)
topViewSelectLangButtonStyle =
    [ width (px 220)
    , height (px 40)
    , padding 5
    , letterSpacing 5
    , Background.color (rgba255 255 255 255 1)
    , Border.rounded 10
    , Border.solid
    , Border.color (rgba255 0 0 0 0.3)
    , Border.width 1
    , mouseOver
        [ Background.color (rgba255 100 250 150 1) ]
    ]



-- listpage


listPageViewNewWordButtonStyle : List (Element.Attribute msg)
listPageViewNewWordButtonStyle =
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


listPageViewWordLoadingStyle : List (Element.Attribute msg)
listPageViewWordLoadingStyle =
    [ centerX
    , centerY
    , Font.italic
    , Font.bold
    , Font.size 30
    , Font.letterSpacing 3
    ]


listPageViewBodyStyle : List (Element.Attribute msg)
listPageViewBodyStyle =
    [ height fill, width fill, paddingXY 0 50, Font.semiBold ]


listPageViewContentsStyle : List (Element.Attribute msg)
listPageViewContentsStyle =
    [ centerX
    , width (px 1000)
    , spacing 20
    ]


listPageViewTableColumnStyle : List (Element.Attribute msg)
listPageViewTableColumnStyle =
    [ height fill
    , width (px 1000)
    , centerX
    , centerY
    , Background.color (rgba255 200 200 200 0.8)
    , paddingEach { top = 20, right = 60, bottom = 70, left = 60 }
    , Border.rounded 10
    ]


listPageViewTableStyle : List (Element.Attribute msg)
listPageViewTableStyle =
    [ centerX, width fill, spacing 10 ]


listPageViewTableHeaderStyle : List (Element.Attribute msg)
listPageViewTableHeaderStyle =
    [ paddingXY 30 40, spacing 10 ]


listPageViewTableRowStyle : Bool -> List (Element.Attribute msg)
listPageViewTableRowStyle invisible =
    let
        ( fontColor, hoverColor ) =
            if invisible then
                ( Font.color (rgba255 255 255 255 1), mouseOver [ Font.color (rgba255 0 0 0 1) ] )

            else
                ( Font.color (rgba255 0 0 0 1), mouseOver [ Font.color (rgba255 0 0 0 1) ] )
    in
    [ padding 10
    , centerY
    , centerX
    , Background.color (rgba255 255 255 255 1)
    , Border.rounded 5
    , fontColor
    , hoverColor
    ]


listPageViewTableRowButtonStyle : Color -> Color -> List (Element.Attribute msg)
listPageViewTableRowButtonStyle currColor pushColor =
    [ width (px 40)
    , height (px 40)
    , centerX
    , centerY
    , Background.color currColor
    , Border.rounded 50
    , Border.solid
    , Border.color (rgba255 0 0 0 0.2)
    , Border.width 1
    , mouseOver
        [ Background.color pushColor ]
    ]


listPageViewWordListErrorStyle : List (Element.Attribute msg)
listPageViewWordListErrorStyle =
    [ spacing 30
    , centerX
    , Font.family
        [ Font.typeface "Hiragino Kaku Gothic ProN"
        , Font.sansSerif
        ]
    , paddingXY 0 50
    ]


listPageViewWordListErrorHeadingStyle : List (Element.Attribute msg)
listPageViewWordListErrorHeadingStyle =
    [ Font.bold
    , Font.size 24
    ]


listPageViewWordListErrorMsgStyle : List (Element.Attribute msg)
listPageViewWordListErrorMsgStyle =
    [ Font.size 16
    , Font.regular
    , centerX
    ]
