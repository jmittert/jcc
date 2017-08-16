module Types where

data Type
  = Int
  | Void
  | Bool
  | Char
  | Pointer Type
  | Arr Type Int
  deriving (Eq, Ord, Show)

data BinOp = Plus | Minus | Times | Div | Lt | Lte | Access
  deriving (Eq, Ord)
instance Show BinOp where
  show Plus = "+"
  show Minus = "-"
  show Times = "*"
  show Div = "/"
  show Lt = "<"
  show Lte = "<="
  show Access = "*"

data UnOp = Deref | Neg
  deriving (Eq, Ord)
instance Show UnOp where
  show Deref = "*"
  show Neg = "-"

toSize :: Type -> Int
toSize Int = 8
toSize (Pointer _) = 8
toSize Char = 1
toSize Void = 0
toSize Bool = 1
toSize (Arr tpe size) = size * toSize tpe

newtype Name = Name {toString :: String}
  deriving (Eq, Ord)

instance Show Name where
  show = toString
