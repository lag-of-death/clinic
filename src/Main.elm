module Main exposing (main)

import Animation
import Browser
import Types exposing (Flags, Model, Msg(..), init)
import Update exposing (update)
import View exposing (view)
import Visits.Update exposing (subs)


main : Program Types.Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate [ model.style ]
        , Sub.map Types.NewVisitMsg subs
        ]
