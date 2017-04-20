module Styles exposing (..)


button : List ( String, String )
button =
    [ ( "border", "2px solid black" )
    , ( "background", "white" )
    , ( "padding", "4px" )
    , ( "font-family", "monospace" )
    ]


blockCentered : List ( String, String )
blockCentered =
    [ ( "align-items", "center" ) ]


blockStreteched : List ( String, String )
blockStreteched =
    [ ( "justify-content", "space-between" )
    ]


block : List ( String, String )
block =
    [ ( "display", "flex" )
    , ( "justify-content", "space-around" )
    , ( "padding", "10px" )
    ]


menu : List ( String, String )
menu =
    List.concat [ block, [ ( "border-bottom", "2px solid black" ) ] ]


app : List ( String, String )
app =
    [ ( "padding", "6px" ) ]


body : List ( String, String )
body =
    [ ( "margin", "0" )
    , ( "padding", "0" )
    , ( "font-family", "monospace" )
    ]


newPatientForm : List ( String, String )
newPatientForm =
    [ ( "width", "60%" )
    , ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    ]
