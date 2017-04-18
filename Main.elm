module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class)
import Navigation as Nav
import UrlParser exposing (..)
import Home.Main as Home
import Patients.Main as Patients


main : Program Never Model Msg
main =
    Nav.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { history : List (Maybe Route)
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [ UrlParser.parsePath routeParser location ] }
    , Cmd.none
    )



-- ROUTES


type Route
    = Home
    | PatientId Int
    | Patients


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Patients ((UrlParser.s "patients"))
        , UrlParser.map PatientId ((UrlParser.s "patients") </> int)
        ]



-- UPDATE


type Msg
    = NewUrl String
    | UrlChange Nav.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model
            , Nav.newUrl url
            )

        UrlChange location ->
            ( { model | history = (UrlParser.parsePath routeParser location) :: model.history }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div
            [ class "menu" ]
            [ button [ class "menu__button", onClick (NewUrl "/") ] [ text "home" ]
            , button [ class "menu__button", onClick (NewUrl "/patients/") ] [ text "patients" ]
            , button [ class "menu__button", onClick (NewUrl "/patients/1") ] [ text "patient nr. 1" ]
            , button [ class "menu__button", onClick (NewUrl "/404/") ] [ text "404" ]
            ]
        , main_ [ class "main" ]
            [ model.history
                |> List.head
                |> Maybe.withDefault (Just Home)
                |> toRouteView
            ]
        ]


toRouteView : Maybe Route -> Html msg
toRouteView maybeRoute =
    case maybeRoute of
        Nothing ->
            div [] [ text "no route matched" ]

        Just route ->
            div []
                [ case route of
                    Patients ->
                        text Patients.hello

                    Home ->
                        text Home.hello

                    PatientId id ->
                        text <| toString id
                ]
