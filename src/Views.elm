module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Styles exposing (..)


newEntity onClick label =
    div []
        [ Html.button
            [ style Styles.button
            , onClick
            ]
            [ text label ]
        ]


list content =
    ul [ style [ ( "width", "70%" ) ] ]
        (List.map
            (\element ->
                li [ style block, style blockCentered, style blockStretched ]
                    element
            )
            content
        )


actions onClick1 onClick2 =
    [ Html.button
        [ style Styles.button
        , onClick1
        ]
        [ text "Details" ]
    , Html.button
        [ style Styles.button
        , style [ ( "margin-left", "4px" ) ]
        , onClick2
        ]
        [ text "Delete" ]
    ]
