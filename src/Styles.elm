module Styles
    exposing
        ( th
        , button
        , submit
        , blockCentered
        , blockStretched
        , block
        , menu
        , app
        , body
        , newPatientForm
        )


th : List ( String, String )
th =
    [ ( "background", "lightblue" )
    ]


button : List ( String, String )
button =
    [ ( "border", "2px solid black" )
    , ( "background", "white" )
    , ( "padding", "4px" )
    , ( "font-size", "20px" )
    , ( "font-family", "monospace" )
    ]


submit : List ( String, String )
submit =
    [ ( "margin", "2%" )
    ]


blockCentered : List ( String, String )
blockCentered =
    [ ( "align-items", "center" ) ]


blockStretched : List ( String, String )
blockStretched =
    [ ( "justify-content", "space-between" )
    ]


block : List ( String, String )
block =
    [ ( "display", "flex" )
    , ( "background", "lightblue" )
    , ( "justify-content", "space-between" )
    , ( "padding", "10px" )
    ]


menu : List ( String, String )
menu =
    List.concat [ block, [ ( "border-bottom", "2px solid black" ), ( "justify-content", "space-around" ) ] ]


app : List ( String, String )
app =
    [ ( "padding", "6px" ), ( "font-size", "24px" ), ( "margin", "1%" ) ]


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
    , ( "border", "2px solid black" )
    ]
