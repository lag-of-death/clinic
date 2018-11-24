module Views exposing (actions, bordered, centerElement, list, newEntity)

import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (style)
import Styles exposing (block, blockCentered, blockStretched)


newEntity : Html.Attribute a -> String -> Html a
newEntity onClick label =
    div [ style "width" "20%" ]
        [ Html.button
            [ style "width" "100%"
            , onClick
            ]
            [ text label ]
        ]


list : List (List (Html msg)) -> Html msg
list content =
    ul [ style "width" "70%", style "padding" "0" ]
        (List.map
            (\element ->
                li []
                    element
            )
            content
        )


actions onClick1 onClick2 locals =
    [ div [ style "display" "flex" ]
        [ Html.button
            [ onClick1
            ]
            [ text locals.details ]
        , Html.button
            [ style "margin-left" "4px"
            , onClick2
            ]
            [ text locals.delete ]
        ]
    ]


centerElement : Html msg -> Html msg
centerElement el =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        ]
        [ el ]


bordered : Html msg -> Html msg
bordered el =
    div
        [ style "border" "2px solid black", style "padding" "2px" ]
        [ el ]
