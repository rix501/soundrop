module RichiHater (State, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Signal exposing (Signal)


-- MODEL

type alias State =
    { richiHater : String
    }

init : String -> State
init name =
    { richiHater = name
    }


-- UPDATE

type Action = EnterHaterName String


update : Action -> State -> State
update action state =
    case action of
        EnterHaterName name ->
            { state |
                richiHater = name
            }

-- VIEW

labelElement : State -> Html
labelElement state =
    div [ ]
        [
            text (state.richiHater ++ " hates richi")
        ]

inputElement : State -> Signal.Address Action -> Html
inputElement state address =
    input
        [ placeholder "Who hates Richi?"
        , value state.richiHater
        , on "input" targetValue (Signal.message address << EnterHaterName)
        ]
        []

view : Signal.Address Action -> State -> Html
view address state =
    div [ ]
        [
            inputElement state address
        ,   labelElement state
        ]
