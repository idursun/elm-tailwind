module Main exposing (..)

import Browser
import Html exposing (Html, a, aside, div, h1, i, img, input, li, nav, span, text, ul)
import Html.Attributes exposing (class, placeholder, src, type_)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


navbar : Html Msg
navbar =
    nav [ class "flex justify-between items-center bg-white m-0 p-2 shadow-lg" ]
        [ div [ class "flex-initial w-1/2 mx-auto " ]
            [ input [ class "justify-center w-full border p-2 rounded", placeholder "Search courses", type_ "text" ]
                []
            , text "  "
            ]
        , div [ class "flex items-center" ]
            []
        ]


sidebar : Html Msg
sidebar =
    aside [ class "flex-none w-full h-full border-r shadow-lg h-screen bg-gray-800 " ]
        [ h1 [ class "h-24 text-white tracking-4 uppercase font-bold p-4 text-left text-middle leading-lg text-lg" ]
            [ text "ONAT'S ACADEMY" ]
        , sidebarSection "Repositories"
        ]


sidebarSectionHeader : String -> Html Msg
sidebarSectionHeader header =
    div [ class "flex items-center font-bold text-gray-500 uppercase pb-2 px-2" ]
        [ i [ class "flex-none" ]
            []
        , span [ class "flex-grow mx-1 select-none" ]
            [ text header ]
        , i [ class "flex-none" ]
            []
        , text ""
        ]


sidebarSectionItem : String -> Html Msg
sidebarSectionItem title =
    li []
        [ a [ class "block py-2 text-sm pl-5 text-gray-500 select-none hover:bg-gray-900 hover:shadow-lg hover:text-gray-300" ] [ text title ]
        ]


sidebarSection : String -> Html Msg
sidebarSection header =
    div [ class "m-2 my-3" ]
        [ sidebarSectionHeader header
        , ul [ class "list-reset" ]
            [ li []
                [ a [ class "block py-2 text-sm pl-5 text-gray-500 select-none hover:bg-gray-900 hover:shadow-lg hover:text-gray-300" ] [ text "Item1" ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "w-full" ]
        [ div [ class "flex" ]
            [ div [ class "flex-none w-64" ]
                [ sidebar
                ]
            , div [ class "flex-grow" ]
                [ navbar
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
