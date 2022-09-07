module Route exposing (Route(..), parseUrl, pushUrl)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)
import Word exposing (Word, WordId, stringFromId)


type Route
    = NotFound
    | Top
    | List String
    | Register
    | Word String WordId


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Top top
        , map Register (s "register")
        , map List string
        , map Word (string </> Word.idParser)
        ]


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    Nav.pushUrl navKey <|
        stringFromRoute route


stringFromRoute : Route -> String
stringFromRoute route =
    case route of
        NotFound ->
            "/notfound"

        Top ->
            "/"

        List language ->
            "/" ++ language

        Register ->
            "/register"

        Word language wordId ->
            "/" ++ language ++ "/" ++ stringFromId wordId
