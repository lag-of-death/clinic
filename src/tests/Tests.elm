module Tests exposing (suite)

import People.Helpers exposing (getPerson)
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The People.Helpers module"
        [ describe "getPerson"
            [ test "returns a person with a given ID" <|
                \_ ->
                    let
                        person =
                            getPerson 4 [ { id = 4, age = 25 } ] { id = 0, age = 20 }
                    in
                        Expect.equal person { id = 4, age = 25 }
            , test "returns a default person when no ID is matched" <|
                \_ ->
                    let
                        person =
                            getPerson 4 [ { id = 2, name = "John" } ] { id = 0, name = "Thomas" }
                    in
                        Expect.equal person { id = 0, name = "Thomas" }
            ]
        ]
