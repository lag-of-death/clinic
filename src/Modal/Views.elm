module Modal.Views exposing (..)

import Modal.Update exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


styles : Attribute msg
styles =
    style
        [ ( "position", "fixed" )
        , ( "bottom", "50%" )
        , ( "left", "10%" )
        , ( "height", "20%" )
        , ( "display", "flex" )
        , ( "justify-content", "center" )
        , ( "align-items", "center" )
        , ( "width", "80%" )
        , ( "font-family", "monospace" )
        , ( "padding", "12px" )
        , ( "font-size", "150%" )
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


view : msg -> String -> String -> Bool -> msg -> Html msg
view xButtonMsg actionBtnLabel question shouldShow actionMsg =
    if shouldShow == True then
        div [ styles ]
            [ div [ buttonsStyles, closeButtonStyles ]
                [ (Html.button
                    [ onClick xButtonMsg ]
                    [ text "X" ]
                  )
                ]
            , text question
            , div
                [ buttonsStyles, yesNoButtonsStyles ]
                [ button
                    [ onClick actionMsg ]
                    [ text actionBtnLabel ]
                , button [ onClick xButtonMsg ] [ text "Cancel" ]
                ]
            ]
    else
        span [] []
