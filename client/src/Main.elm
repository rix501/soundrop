import RichiHater exposing (update, view, init)
import StartApp.Simple exposing (start)


main =
  start
    { model = RichiHater.init "everyone"
    , update = update
    , view = view
    }
