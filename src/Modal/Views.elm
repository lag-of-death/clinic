module Modal.Views exposing (view)

import Html exposing (Attribute, div, Html, text, button, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Styles


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


view : msg -> String -> String -> Bool -> msg -> Bool -> Bool -> Html msg
view xButtonMsg actionBtnLabel question shouldShow actionMsg withActions showCloseBtn =
    if shouldShow == True then
        div [ styles ]
            [ if showCloseBtn then
                Html.button
                    [ onClick xButtonMsg, buttonsStyles, style Styles.button, closeButtonStyles ]
                    [ text "X" ]
              else
                span [] []
            , div [] [ text question ]
            , if withActions then
                div
                    [ buttonsStyles, yesNoButtonsStyles ]
                    [ button
                        [ onClick actionMsg, style Styles.button, style [ ( "margin-right", "4px" ) ] ]
                        [ text actionBtnLabel ]
                    , if showCloseBtn then
                        button [ onClick xButtonMsg, style Styles.button ] [ text "Cancel" ]
                      else
                        span [] []
                    ]
              else
                span [] []
            ]
    else
        span [] []
