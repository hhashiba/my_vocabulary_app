module Word exposing
    ( Word
    , WordId
    , idDecoder
    , idParser
    , initialWord
    , stringFromId
    , wordDecoder
    , wordEncoder
    , wordsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)


type alias Word =
    { id : WordId
    , name : String
    , means : String
    , language : String
    }


type WordId
    = WordId Int


wordsDecoder : Decoder (List Word)
wordsDecoder =
    list wordDecoder


wordDecoder : Decoder Word
wordDecoder =
    Decode.succeed Word
        |> required "id" idDecoder
        |> required "name" string
        |> required "means" string
        |> required "language" string


idDecoder : Decoder WordId
idDecoder =
    Decode.map WordId int


wordEncoder : Word -> Encode.Value
wordEncoder word =
    Encode.object
        [ ( "name", Encode.string word.name )
        , ( "means", Encode.string word.means )
        , ( "language", Encode.string word.language )
        ]


initialWord : Word
initialWord =
    { id = initialId
    , name = ""
    , means = ""
    , language = ""
    }


initialId : WordId
initialId =
    WordId -1


stringFromId : WordId -> String
stringFromId (WordId id) =
    String.fromInt id


idParser : Parser (WordId -> a) a
idParser =
    custom "WORDID" <|
        \wordId ->
            Maybe.map WordId (String.toInt wordId)
