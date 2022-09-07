module Page.Top exposing (Model, Msg, init, view)

import Element exposing (Element, alignRight, centerX, centerY, column, el, explain, fill, height, layout, link, mouseOver, padding, paddingEach, paddingXY, px, rgba255, row, spacing, text, width)
import Element.Background as Background exposing (color)
import Element.Border as Border
import Element.Font as Font exposing (letterSpacing)
import Element.Input exposing (button)
import Html exposing (Html)


type alias Model =
    {}


type Msg
    = NoOp


init : Model
init =
    {}


view : Model -> Html msg
view model =
    layout [] <|
        column
            [ width fill, height fill, Font.semiBold, paddingXY 0 50 ]
            [ column [ spacing 20, centerX ]
                [ row [ alignRight ]
                    [ button
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
                        { onPress = Nothing
                        , label =
                            link [ centerX, centerY ]
                                { url = "/register"
                                , label = text "NewWord"
                                }
                        }
                    ]
                , column
                    [ paddingEach { top = 40, right = 60, bottom = 70, left = 60 }
                    , centerX
                    , Font.semiBold
                    , Background.color (rgba255 200 200 200 0.8)
                    , Border.rounded 10
                    , spacing 8
                    ]
                    [ row
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
                        [ el [ centerX ]
                            (text "NewLanguage")
                        ]
                    , selectLangButton "English" "english"
                    , selectLangButton "한국어" "korean"
                    ]
                ]
            ]


selectLangButton : String -> String -> Element msg
selectLangButton buttonLabel path =
    row [ centerX ]
        [ button
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
            { onPress = Nothing
            , label =
                link [ centerX ]
                    { url = path
                    , label =
                        text buttonLabel
                    }
            }
        ]
