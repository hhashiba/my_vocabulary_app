port module Ports exposing (confirm, confirmReceiver)


port confirm : () -> Cmd msg


port confirmReceiver : (Bool -> msg) -> Sub msg
