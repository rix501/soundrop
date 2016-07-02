module Search (Model, init, Action, update, view) where

import String
import Effects
import Html
import Html.Attributes
import Html.Events
import Http
import Task
import Signal
import Json.Decode as Decode exposing (Decoder, (:=))


-- MODEL

type alias Model =
    { query : SearchQuery
    , searchResults: List SearchResult
    , isSearching: Bool
    }

type alias SearchQuery =
    String


type alias SearchResult =
    { id : String
    , name : String
    }


init : (Model, Effects.Effects Action)
init =
    ( Model "" [] False
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
            let shouldSearch = (String.length query > 0)
                fx = if shouldSearch then (searchSong query) else Effects.none
            in
                ( { model |
                    query = query
                  , isSearching = shouldSearch
                  , searchResults = if shouldSearch then model.searchResults else []
                  }
                , fx
                )
        NewSearchResults maybeSearchResults ->
            ( { model |
                isSearching = False
              , searchResults = Maybe.withDefault [] maybeSearchResults
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

indicatorElement: Model -> Html.Html
indicatorElement model =
    let indicatorText =
        if model.isSearching then
            "Searching..."
        else
            ""
    in
        Html.div []
            [ Html.text indicatorText
            ]


inputElement : Model -> Signal.Address Action -> Html.Html
inputElement model address =
    Html.input
        [ Html.Attributes.placeholder "Search"
        , Html.Attributes.value model.query
        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << EnterQuery)
        ]
        []


resultElement: SearchResult -> Html.Html
resultElement searchResult =
    Html.li [ ]
        [ Html.text searchResult.name
        ]


resultsElement : Model -> Html.Html
resultsElement model =
    Html.ul [ ] (List.map resultElement model.searchResults)


view : Signal.Address Action -> Model -> Html.Html
view address model =
    Html.div [ ]
        [ inputElement model address
        , indicatorElement model
        , resultsElement model
        ]
