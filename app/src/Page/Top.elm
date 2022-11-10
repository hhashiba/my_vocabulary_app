module Page.Top exposing (Model, init, view)

import Css
import Element exposing (Element, alignRight, centerX, column, el, layout, link, row, text)
import Element.Input exposing (button)
import Html exposing (Html)


type alias Model =
    {}


init : Model
init =
    {}


view : Model -> Html msg
view _ =
    layout [] <|
        column
            Css.topViewStyle
            [ column Css.topViewNewWordColumnStyle
                [ row [ alignRight ]
                    [ button
                        Css.topViewNewWordButtonStyle
                        { onPress = Nothing
                        , label =
                            link Css.topViewButtonLabelStyle
                                { url = "/register"
                                , label = text "NewWord"
                                }
                        }
                    ]
                , column
                    Css.topViewLangListStyle
                    [ row
                        Css.topViewLangStyle
                        [ el Css.topViewButtonLabelStyle
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
            Css.topViewSelectLangButtonStyle
            { onPress = Nothing
            , label =
                link Css.topViewButtonLabelStyle
                    { url = path
                    , label =
                        text buttonLabel
                    }
            }
        ]
