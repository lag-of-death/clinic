module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Styles exposing (..)


newEntity : Html.Attribute a -> String -> Html a
newEntity onClick label =
    div [ style [ ( "width", "15%" ) ] ]
        [ Html.button
            [ style Styles.button
            , style [ ( "width", "100%" ), ( "word-break", "break-all" ) ]
            , onClick
            ]
            [ text label ]
        ]


list : List (List (Html msg)) -> Html msg
list content =
    ul [ style [ ( "width", "70%" ), ( "padding", "0" ) ] ]
        (List.map
            (\element ->
                li [ style block, style blockCentered, style blockStretched ]
                    element
            )
            content
        )


actions : Html.Attribute a -> Html.Attribute a -> List (Html a)
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
