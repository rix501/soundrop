module RichiHater (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Signal exposing (Signal)


-- MODEL

type alias Model =
    { richiHater : String
    }

init : String -> Model
init name =
    { richiHater = name
    }


-- UPDATE

type Action = EnterHaterName String


update : Action -> Model -> Model
update action model =
    case action of
        EnterHaterName name ->
            { model |
                richiHater = name
            }

-- VIEW

labelElement : Model -> Html
labelElement model =
    div [ ]
        [
            text (model.richiHater ++ " hates richi a lot")
        ]

inputElement : Model -> Signal.Address Action -> Html
inputElement model address =
    input
        [ placeholder "Who hates Richi?"
        , value model.richiHater
        , on "input" targetValue (Signal.message address << EnterHaterName)
        ]
        []

view : Signal.Address Action -> Model -> Html
view address model =
    div [ ]
        [
            inputElement model address
        ,   labelElement model
        ]
