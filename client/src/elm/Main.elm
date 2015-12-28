import RichiHater exposing (update, view, init)
import StartApp.Simple exposing (start)
import Html exposing (Html)
import Signal exposing (Signal)

main : Signal Html
main =
  start
    { model = RichiHater.init "everyone"
    , update = update
    , view = view
    }
