module Weeder where
import qualified Ast.ParsedAst as PA
import qualified Ast.WeededAst as WA

weeder :: PA.Prog -> Either String WA.Prog
weeder = return . weedProg

weedProg :: PA.Prog -> WA.Prog
weedProg (PA.Prog funcs) = WA.Prog $ weedFunc <$> funcs

weedFunc :: PA.Function -> WA.Function
weedFunc (PA.Func tpe name tpes stmnts) =
  WA.Func tpe name tpes (weedStmnts stmnts)

weedStmnts :: PA.Statements -> WA.Statements
weedStmnts (PA.Statements' stmnt) = WA.Statements' (weedStmnt stmnt)
weedStmnts (PA.Statements stmnts stmnt) = WA.Statements (weedStmnts stmnts) (weedStmnt stmnt)

weedStmnt :: PA.Statement -> WA.Statement
weedStmnt (PA.SExpr expr) = WA.SExpr $ weedExpr expr
weedStmnt (PA.SDecl name tpe) = WA.SDecl name tpe
weedStmnt (PA.SDeclAssign name tpe expr) = WA.SDeclAssign name tpe (weedExpr expr)
weedStmnt (PA.SBlock stmnts) = WA.SBlock (weedStmnts stmnts)
weedStmnt (PA.SWhile expr stmnt) = WA.SWhile (weedExpr expr) (weedStmnt stmnt)
weedStmnt (PA.SIf expr stmnt) = WA.SIf (weedExpr expr) (weedStmnt stmnt)
weedStmnt (PA.SReturn expr) = WA.SReturn (weedExpr expr)

weedExpr :: PA.Expr -> WA.Expr
weedExpr (PA.BOp op exp1 exp2) = WA.BOp op (weedExpr exp1) (weedExpr exp2)
weedExpr (PA.EAssign name e) = WA.EAssign name (weedExpr e)
weedExpr (PA.UOp op e) = WA.UOp op (weedExpr e)
weedExpr (PA.Lit l) = WA.Lit l
weedExpr (PA.Var v) = WA.Var v
weedExpr (PA.Ch c) = WA.Ch c
weedExpr (PA.EArr exprlist) = WA.EArr (map weedExpr exprlist)
weedExpr (PA.EAssignArr e1 e2 e3) = WA.EAssignArr (weedExpr e1) (weedExpr e2) (weedExpr e3)
weedExpr (PA.Call name exprs) = WA.Call name (map weedExpr exprs)
