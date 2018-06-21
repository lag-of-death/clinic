module Main exposing (main)

import View exposing (view)
import Update exposing (update)
import Types exposing (Flags, init, Model, Msg(Animate, UrlChange))
import Navigation
import Animation
import Visits.Update exposing (subs)


main : Program Types.Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate [ model.style ]
        , Sub.map Types.NewVisitMsg subs
        ]
