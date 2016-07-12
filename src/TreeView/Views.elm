module TreeView.Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import TreeView.Models exposing (..)
import TreeView.Messages exposing (..)
import String

import Style

roots: TreeModel a -> List (TreeNode a)
roots model =
  childNodes model Nothing

childNodes: TreeModel a -> Maybe (TreeNode a) -> List (TreeNode a)
childNodes model node =
  case node of
    Nothing ->
      List.filter (\n -> n.parent == Nothing) model
    Just x ->
      List.filter (\n -> n.parent == Just x.id) model

node: TreeModel a -> IndentLevel -> TreeNode a -> Html Msg
node m i n =
  let
    classes = [ "node"] ++ if n.selected then ["selected"] else []
    childs = if n.expanded then children m i n else []
    childWrapper = div [ class "children"
                      , style (Style.render n.style)] childs
  in
    div [] ([
      div [ class (String.join " " classes) ] (indent i ++ [
        expander m n,
        span [ class "name" ] [
          a [ href "javascript://"
            , onClick (Select n.id) ] [
            text n.name
          ]
        ]
      ])
    ] ++ [ childWrapper ])

expander: TreeModel a -> TreeNode a -> Html Msg
expander m n =
  let
    children = childNodes m (Just n)
  in
    if List.isEmpty children then
        span [ class "expander no-children"] []
    else
      let
        classes = [ "expander" ] ++
          [ (if n.expanded then "expanded" else "collapsed") ]
        linkText = if n.expanded then "▼" else "▶"
      in
        a [ href "javascript://",
          onClick (if n.expanded then Collapse n.id else Expand n.id),
          class (String.join " " classes) ] [ text linkText ]

indent: IndentLevel -> List (Html Msg)
indent i =
  List.map (\i -> span [ class "indent" ] []) [1..i]

children: TreeModel a -> IndentLevel -> TreeNode a -> List (Html Msg)
children m i n =
  let
    nodeI = node m (i + 1)
    childs = childNodes m (Just n)
  in
    List.map nodeI childs

view : TreeModel a -> Html Msg
view model =
  let
    rootElems = List.map (node model 0) (roots model)
  in
    div [ class "tree" ] rootElems
