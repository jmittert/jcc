module Ast.OffsetAst where

import Types
import Control.Monad

newtype TypedAst = TypedAst Prog
  deriving(Eq, Ord)
instance Show TypedAst where
  show (TypedAst p) = show p

newtype Prog = Prog [Function]
  deriving(Eq, Ord)
instance Show Prog where
  show (Prog f) = join $ show <$> f

data Function = Func Type Name [Type] Statement
  deriving(Eq, Ord)
instance Show Function where
  show (Func tpe name tps stmnt) = show tpe ++ " " ++ toString name ++ show tps ++ show stmnt

data Statements
 = Statements' Statement Type
 | Statements Statements Statement Type
  deriving (Eq, Ord)
instance Show Statements where
  show (Statements' stmnt _) = show stmnt
  show (Statements stmnts stmnt _) = show stmnts ++ show stmnt

data Statement
  = SExpr Expr Type
  | SDecl Name Type Type
  | SDeclAssign Name Type Expr Type
  | SBlock Statements Type
  | SWhile Expr Statement Type
  | SIf Expr Statement Type
  | SReturn Expr Type
  deriving (Eq, Ord)
instance Show Statement where
  show (SExpr e _) = show e ++ ";\n"
  show (SDecl name tpe _) = show tpe ++ " " ++ show name ++ ";\n"
  show (SDeclAssign name tpe expr _) = show tpe ++ " " ++ show name ++ " = " ++ show expr ++ ";\n"
  show (SBlock b _) = show b
  show (SWhile e stmnt _) = "while (" ++ show e ++ ")\n" ++ show stmnt
  show (SIf e stmnt _) = "if (" ++ show e ++ ")\n" ++ show stmnt
  show (SReturn e _) = "return " ++ show e ++ ";\n"

data Expr
 = BOp BinOp Expr Expr Type
 | EAssign Name Expr Type
 | EAssignArr Expr Expr Expr Type
 | UOp UnOp Expr Type
 | Lit Int
 | Var Name Def Type
 | Ch Char
 | EArr [Expr] Type
  deriving (Eq, Ord)
instance Show Expr where
  show (BOp op e1 e2 _) = show e1 ++ " " ++ show op ++ " " ++ show e2
  show (EAssign name expr _) = show name ++ " = " ++ show expr
  show (EArr exps _) = show exps
  show (EAssignArr e1 e2 e3 _) = show e1 ++ "[" ++ show e2 ++ "] = " ++ show e3
  show (UOp op e1 _) = show op ++ " " ++ show e1
  show (Lit i) = show i
  show (Var name _ _) = show name
  show (Ch char) = show char

{-
  Extract the type attached to a statement
-}
getStmntType :: Statement -> Type
getStmntType (SExpr _ tpe) = tpe
getStmntType (SDecl _ _ tpe) = tpe
getStmntType (SDeclAssign _ _ _ tpe) = tpe
getStmntType (SBlock _ tpe) = tpe
getStmntType (SWhile _ _ tpe) = tpe
getStmntType (SIf _ _ tpe) = tpe
getStmntType (SReturn _ tpe) = tpe

getExprType :: Expr -> Type
getExprType (BOp _ _ _ tpe) = tpe
getExprType (UOp _ _ tpe) = tpe
getExprType (EAssign _ _ tpe) = tpe
getExprType (Lit _)  = Int
getExprType (Var _ _ tpe)  = tpe
getExprType (Ch _)  = Char
getExprType (EArr _ tpe) = tpe
getExprType (EAssignArr _ _ _ tpe) = tpe