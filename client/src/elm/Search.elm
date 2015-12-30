module Search (Model, init, Action, update, view) where

import String
import Effects
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, (:=))
import Task
import Signal exposing (Signal)


-- MODEL

type alias Model =
    { query : SearchQuery
    , searchResults: List SearchResult
    }

type alias SearchQuery =
    String


type alias SearchResult =
    { id : String
    , name : String
    }


init : (Model, Effects.Effects Action)
init =
    ( Model "" []
    , Effects.none
    )

-- UPDATE

type Action
    = EnterQuery SearchQuery
    | NewSearchResults (Maybe (List SearchResult))


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
    case action of
        EnterQuery query ->
            ( { model |
                query = query
              }
            ,
                if (String.length query > 0) then
                    searchSong query
                else
                    Effects.none
            )
        NewSearchResults maybeSearchResults ->
            ( { model |
                searchResults = Maybe.withDefault model.searchResults maybeSearchResults
              }
            , Effects.none
            )



searchResultDecoder : Decoder (SearchResult)
searchResultDecoder =
    Decode.object2 SearchResult
        ("id" := Decode.string)
        ("name" := Decode.string)


searchResultsDecoder : Decoder (List SearchResult)
searchResultsDecoder =
    Decode.at ["tracks", "items"] (Decode.list searchResultDecoder)


getSearchUrl : SearchQuery -> String
getSearchUrl query =
    "https://api.spotify.com/v1/search?q=" ++ (query ++ "&type=track")


searchSong : SearchQuery -> Effects.Effects Action
searchSong query =
    let
        url = getSearchUrl query
    in
        Http.get searchResultsDecoder url
            |> Task.toMaybe
            |> Task.map NewSearchResults
            |> Effects.task

-- VIEW

inputElement : Model -> Signal.Address Action -> Html
inputElement model address =
    input
        [ placeholder "Search"
        , value model.query
        , on "input" targetValue (Signal.message address << EnterQuery)
        ]
        []

resultElement: SearchResult -> Html
resultElement searchResult =
    li [ ]
        [
            text searchResult.name
        ]

resultsElement : Model -> Html
resultsElement model =
    ul [ ] (List.map resultElement model.searchResults)


view : Signal.Address Action -> Model -> Html
view address model =
    div [ ]
        [
            inputElement model address
        ,   resultsElement model
        ]
