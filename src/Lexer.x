{
module Lexer (
 Token(..),
 scanTokens
) where

import Ast.ParsedAst
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

  $white+               ;
  "//".*                ;
  $digit+               { \s -> TokenNum (read s) }
  int                   { \s -> TokenIntDec }
  char                  { \s -> TokenCharDec }
  bool                  { \s -> TokenBoolDec }
  return                { \s -> TokenReturn }
  while                 { \s -> TokenWhile }
  for                   { \s -> TokenFor }
  if                    { \s -> TokenIf }
  asm                    { \s -> TokenAsm }
  import                { \s -> TokenImport }
  module                { \s -> TokenModule }
  [A-Za-z][A-Za-z0-9_]*  { \s -> TokenSym s }
  \;                    { \s -> TokenSemi }
  \,                    { \s -> TokenComma }
  \.                    { \s -> TokenDot }
  \{                    { \s -> TokenLbrace }
  \}                    { \s -> TokenRbrace }
  \(                    { \s -> TokenLparen }
  \)                    { \s -> TokenRparen }
  \=                    { \s -> TokenAssign }
  \+                    { \s -> TokenPlus }
  \-                    { \s -> TokenMinus }
  \*                    { \s -> TokenStar }
  \/                    { \s -> TokenDiv }
  \<=                   { \s -> TokenLte}
  \<                    { \s -> TokenLt}
  \>=                   { \s -> TokenGte}
  \>                    { \s -> TokenGt}
  \==                   { \s -> TokenEq}
  \!=                   { \s -> TokenNeq}
  \[                    { \s -> TokenLbrack}
  \]                    { \s -> TokenRbrack}
  \'[^']\'              { \s -> TokenChar (read s :: Char)}
  \"[^\"]*\"            { \s -> TokenString (read s :: String)}

{
data Token =
  TokenNum Int
  | TokenInt
  | TokenMain
  | TokenReturn
  | TokenBool Bool
  | TokenSym String
  | TokenSemi
  | TokenDot
  | TokenLbrace
  | TokenRbrace
  | TokenLparen
  | TokenRparen
  | TokenLbrack
  | TokenRbrack
  | TokenAssign
  | TokenPlus
  | TokenMinus
  | TokenStar
  | TokenPrint
  | TokenString String
  | TokenChar Char
  | TokenCharDec
  | TokenStringDec
  | TokenBoolDec
  | TokenIntDec
  | TokenComma
  | TokenWhile
  | TokenFor
  | TokenDiv
  | TokenIf
  | TokenImport
  | TokenModule
  | TokenLt
  | TokenLte
  | TokenGt
  | TokenGte
  | TokenEq
  | TokenNeq
  | TokenAsm
  deriving (Eq, Show)

scanTokens = alexScanTokens
}
