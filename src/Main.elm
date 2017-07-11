module Main exposing (main)

import View exposing (view)
import Update exposing (update)
import Types exposing (init, Model, Msg(Animate, UrlChange))
import Navigation
import Animation


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]
