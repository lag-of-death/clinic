module Styles exposing (..)


menuButton : List ( String, String )
menuButton =
    [ ( "border", "2px solid black" )
    , ( "background", "white" )
    , ( "padding", "4px" )
    , ( "font-family", "monospace" )
    ]


menu : List ( String, String )
menu =
    [ ( "display", " flex" )
    , ( "justify-content", " space-around" )
    , ( "padding", " 10px" )
    , ( "border-bottom", " 2px solid black" )
    ]


app : List ( String, String )
app =
    [ ( "padding", "6px" ) ]


body : List ( String, String )
body =
    [ ( "margin", "0" )
    , ( "padding", "0" )
    , ( "font-family", "monospace" )
    ]
