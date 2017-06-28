module Modal.Views exposing (..)

import Modal.Update exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


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


textStyles : Attribute msg
textStyles =
    style [ ( "text-align", "center" ) ]


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


view : msg -> String -> String -> Bool -> msg -> Bool -> Html msg
view xButtonMsg actionBtnLabel question shouldShow actionMsg withActions =
    if shouldShow == True then
        div [ styles ]
            [ (Html.button
                [ onClick xButtonMsg, buttonsStyles, closeButtonStyles ]
                [ text "X" ]
              )
            , div [] [ text question ]
            , if withActions then
                (div
                    [ buttonsStyles, yesNoButtonsStyles ]
                    [ button
                        [ onClick actionMsg ]
                        [ text actionBtnLabel ]
                    , button [ onClick xButtonMsg ] [ text "Cancel" ]
                    ]
                )
              else
                (span [] [])
            ]
    else
        span [] []
