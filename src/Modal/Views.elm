module Modal.Views exposing (view)

import Html exposing (Attribute, Html, button, div, span, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Modal.Types as MT
import Styles


view xButtonMsg model locals =
    let
        question =
            model.textMsg

        shouldShow =
            model.shouldShow

        actionMsg =
            model.msg

        showCloseBtn =
            model.showCloseBtn
    in
    if shouldShow == True then
        if showCloseBtn then
            div []
                [ Html.button
                    [ onClick xButtonMsg ]
                    [ text "X" ]
                , div [ style "text-align" "center" ] [ text question ]
                , div
                    []
                    [ button
                        [ onClick actionMsg, style "margin-right" "4px" ]
                        [ text locals.yes ]
                    , button [ onClick xButtonMsg ] [ text locals.cancel ]
                    ]
                ]

        else
            div [ style "flex-direction" "column", style "justify-content" "space-between" ]
                [ span [] []
                , div [ style "text-align" "center" ] [ text question ]
                , div
                    [ style "width" "50%" ]
                    [ button
                        [ onClick actionMsg, style "margin-right" "4px", style "width" "100%" ]
                        [ text locals.ok ]
                    ]
                ]

    else
        span [] []
