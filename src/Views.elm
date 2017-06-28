module Views exposing (centerElement, list, actions, newEntity, bordered)

import Html exposing (div, Html, text, ul, li)
import Html.Attributes exposing (style)
import Styles exposing (block, blockStretched, blockCentered)


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
    ul [ style [ ( "width", "80%" ), ( "padding", "0" ) ] ]
        (List.map
            (\element ->
                li [ style block, style blockCentered, style blockStretched ]
                    element
            )
            content
        )


actions : Html.Attribute a -> Html.Attribute a -> List (Html a)
actions onClick1 onClick2 =
    [ div [ style [ ( "display", "flex" ) ] ]
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
    ]


centerElement : Html msg -> Html msg
centerElement el =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "center" )
            ]
        ]
        [ el ]


bordered : Html msg -> Html msg
bordered el =
    div
        [ style [ ( "border", "2px solid black" ) ] ]
        [ el ]
