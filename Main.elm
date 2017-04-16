module To exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Navigation as Nav
import UrlParser exposing (..)


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
        [ button [ onClick (NewUrl "/patients/") ] [ text "patients" ]
        , button [ onClick (NewUrl "/patients/1") ] [ text "patients/1" ]
        , button [ onClick (NewUrl "/") ] [ text "home" ]
        , ul [] (List.map viewRoute model.history)
        ]


viewRoute : Maybe Route -> Html msg
viewRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            li [] [ text "no route matched" ]

        Just route ->
            li [] [ code [] [ text (toString route) ] ]
