module Modal.Views exposing (view)

import Html exposing (Attribute, div, Html, text, button, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Styles
import Modal.Types as MT


styles : Attribute msg
styles =
    style
        [ ( "position", "fixed" )
        , ( "bottom", "55%" )
        , ( "left", "20%" )
        , ( "height", "25%" )
        , ( "display", "flex" )
        , ( "justify-content", "center" )
        , ( "box-sizing", "border-box" )
        , ( "align-items", "center" )
        , ( "width", "60%" )
        , ( "font-family", "monospace" )
        , ( "padding", "12px" )
        , ( "font-size", "30px" )
        , ( "background", "#FFF" )
        , ( "border", "2px solid black" )
        ]


buttonsStyles : Attribute msg
buttonsStyles =
    style
        [ ( "position", "absolute" )
        , ( "right", "8px" )
        ]


closeButtonStyles : Attribute msg
closeButtonStyles =
    style
        [ ( "top", "4px" )
        ]


yesNoButtonsStyles : Attribute msg
yesNoButtonsStyles =
    style
        [ ( "bottom", "4px" )
        ]


view : msg -> MT.Modal msg -> Html msg
view xButtonMsg model =
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
                div [ styles ]
                    [ Html.button
                        [ onClick xButtonMsg, buttonsStyles, style Styles.button, closeButtonStyles ]
                        [ text "X" ]
                    , div [ style [ ( "text-align", "center" ) ] ] [ text question ]
                    , div
                        [ buttonsStyles, yesNoButtonsStyles ]
                        [ button
                            [ onClick actionMsg, style Styles.button, style [ ( "margin-right", "4px" ) ] ]
                            [ text "YES" ]
                        , button [ onClick xButtonMsg, style Styles.button ] [ text "Cancel" ]
                        ]
                    ]
            else
                div [ styles, style [ ( "flex-direction", "column" ), ( "justify-content", "space-between" ) ] ]
                    [ span [] []
                    , div [ style [ ( "text-align", "center" ) ] ] [ text question ]
                    , div
                        [ yesNoButtonsStyles, style [ ( "width", "50%" ) ] ]
                        [ button
                            [ onClick actionMsg, style Styles.button, style [ ( "margin-right", "4px" ), ( "width", "100%" ) ] ]
                            [ text "OK" ]
                        ]
                    ]
        else
            span [] []
