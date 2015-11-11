{-# LANGUAGE GADTs,FlexibleContexts #-}
{-|
Defines how things will be called in the CCode generated by CodeGen.hs
Provides mappings from class/method names to their C-name.

The purpose of this module is to

 - get one central place where identifiers in the generated code can be changed

 - ease following of good conventions (ie use @Ptr char@ instead of @Embed "char*"@)

-}

module CodeGen.CCodeNames where

import qualified Identifiers as ID
import Types as Ty
import CCode.Main
import Data.List

import qualified AST.AST as A

char :: CCode Ty
char = Typ "char"

int :: CCode Ty
int = Typ "int64_t"

uint :: CCode Ty
uint = Typ "uint64_t"

bool :: CCode Ty
bool = Typ "int64_t" -- For pony argument tag compatibility. Should be changed to something smaller

double :: CCode Ty
double = Typ "double"

void :: CCode Ty
void = Typ "void"

encoreActorT :: CCode Ty
encoreActorT = Typ "encore_actor_t"

ponyTypeT :: CCode Ty
ponyTypeT = Typ "pony_type_t"

ponyActorT :: CCode Ty
ponyActorT = Typ "pony_actor_t"

ponyActorTypeT :: CCode Ty
ponyActorTypeT = Typ "pony_actor_type_t"

encoreArgT :: CCode Ty
encoreArgT = Typ "encore_arg_t"

isEncoreArgT :: CCode Ty -> Bool
isEncoreArgT (Typ "encore_arg_t") = True
isEncoreArgT _ = False

ponyMsgT :: CCode Ty
ponyMsgT = Typ "pony_msg_t"

encMsgT :: CCode Ty
encMsgT = Typ "encore_fut_msg_t"

taskMsgT = Typ "encore_task_msg_s"

encOnewayMsgT :: CCode Ty
encOnewayMsgT = Typ "encore_oneway_msg_t"

closure :: CCode Ty
closure = Ptr $ Typ "closure_t"

task :: CCode Ty
task = Ptr $ Typ "encore_task_s"

future :: CCode Ty
future = Ptr $ Typ "future_t"

stream :: CCode Ty
stream = Ptr $ Typ "stream_t"

array :: CCode Ty
array = Ptr $ Typ "array_t"

tuple :: CCode Ty
tuple = Ptr $ Typ "tuple_t"

rangeT :: CCode Ty
rangeT = Typ "range_t"

range :: CCode Ty
range = Ptr rangeT

option :: CCode Ty
option = Ptr $ Typ "option_t"

par :: CCode Ty
par = Ptr $ Typ "par_t"

capability :: CCode Ty
capability = Ptr $ Typ "capability_t"

ponyTraceFnType :: CCode Ty
ponyTraceFnType = Typ "pony_trace_fn"

unit :: CCode Lval
unit = Embed "UNIT"

encoreName :: String -> String -> String
encoreName kind name =
  let
    nonEmptys = filter (not . null) ["_enc_", kind, name]
  in
    concat $ intersperse "_" nonEmptys

selfTypeField :: CCode Name
selfTypeField = Nam $ encoreName "self_type" ""

-- | each method is implemented as a function with a `this`
-- pointer. This is the name of that function
methodImplName :: Ty.Type -> ID.Name -> CCode Name
methodImplName clazz mname = Nam $ methodImplNameStr clazz mname

methodImplFutureName :: Ty.Type -> ID.Name -> CCode Name
methodImplFutureName clazz mname =
  Nam $ methodImplFutureNameStr clazz mname

methodImplOneWayName :: Ty.Type -> ID.Name -> CCode Name
methodImplOneWayName clazz mname =
  Nam $ methodImplOneWayNameStr clazz mname

methodImplNameStr :: Ty.Type -> ID.Name -> String
methodImplNameStr clazz mname =
  encoreName "method" $ (Ty.getId clazz) ++ "_" ++ (show mname)

methodImplFutureNameStr :: Ty.Type -> ID.Name -> String
methodImplFutureNameStr clazz mname =
  methodImplNameStr clazz mname ++ "_future"

methodImplOneWayNameStr :: Ty.Type -> ID.Name -> String
methodImplOneWayNameStr clazz mname =
  methodImplNameStr clazz mname ++ "_one_way"

constructorImplName :: Ty.Type -> CCode Name
constructorImplName clazz = Nam $ encoreName "constructor" (Ty.getId clazz)

encoreCreateName :: CCode Name
encoreCreateName = Nam "encore_create"

partySequence :: CCode Name
partySequence = Nam "party_sequence"

partyJoin :: CCode Name
partyJoin = Nam "party_join"

partyExtract :: CCode Name
partyExtract = Nam "party_extract"

partyEach :: CCode Name
partyEach = Nam "party_each"

partyNewParP :: CCode Name
partyNewParP = Nam "new_par_p"

partyNewParV :: CCode Name
partyNewParV = Nam "new_par_v"

partyNewParF :: CCode Name
partyNewParF = Nam "new_par_f"

argName :: ID.Name -> CCode Name
argName name = Nam $ encoreName "arg" (show name)

fieldName :: ID.Name -> CCode Name
fieldName name =
    Nam $ encoreName "field" (show name)

globalClosureName :: ID.Name -> CCode Name
globalClosureName funname =
    Nam $ encoreName "closure" (show funname)

globalFunctionClosureNameOf :: A.Function -> CCode Name
globalFunctionClosureNameOf f = globalClosureName $ A.functionName f

globalFunctionName :: ID.Name -> CCode Name
globalFunctionName funname =
    Nam $ encoreName "global_fun" (show funname)

globalFunctionNameOf :: A.Function -> CCode Name
globalFunctionNameOf f = globalFunctionName $ A.functionName f

globalFunctionWrapperNameOf :: A.Function -> CCode Name
globalFunctionWrapperNameOf f =
  Nam $ encoreName "global_fun_wrapper" $ show $ A.functionName f

closureStructName :: CCode Name
closureStructName = Nam "closure"

closureStructFFieldName :: CCode Name
closureStructFFieldName = Nam "call"

closureFunName :: String -> CCode Name
closureFunName name =
    Nam $ encoreName "closure_fun" name

closureEnvName :: String -> CCode Name
closureEnvName name =
    Nam $ encoreName "env" name

closureTraceName :: String -> CCode Name
closureTraceName name =
    Nam $ encoreName "trace" name

taskFunctionName :: String -> CCode Name
taskFunctionName name =
    Nam $ encoreName "task" name

taskEnvName :: String -> CCode Name
taskEnvName name =
    Nam $ encoreName "task_env" name

taskDependencyName :: String -> CCode Name
taskDependencyName name =
    Nam $ encoreName "task_dep" name

taskTraceName :: String -> CCode Name
taskTraceName name =
    Nam $ encoreName "task_trace" name

streamHandle :: CCode Lval
streamHandle = Var "_stream"

typeVarRefName :: Ty.Type -> CCode Name
typeVarRefName ty =
    Nam $ encoreName "type" (show ty)

classId :: Ty.Type -> CCode Name
classId ty =
    Nam $ encoreName "ID" (Ty.getId ty)

refTypeId :: Ty.Type -> CCode Name
refTypeId ty =
    Nam $ encoreName "ID" (Ty.getId ty)

traitMethodSelectorName = Nam "trait_method_selector"

-- | each class, in C, provides a dispatch function that dispatches
-- messages to the right method calls. This is the name of that
-- function.
classDispatchName :: Ty.Type -> CCode Name
classDispatchName clazz =
    Nam $ encoreName "dispatch" (Ty.getId clazz)

classTraceFnName :: Ty.Type -> CCode Name
classTraceFnName clazz =
    Nam $ encoreName "trace" (Ty.getId clazz)

runtimeTypeInitFnName :: Ty.Type -> CCode Name
runtimeTypeInitFnName clazz =
    Nam $ encoreName "type_init" (Ty.getId clazz)

ponyAllocMsgName :: CCode Name
ponyAllocMsgName = Nam "pony_alloc_msg"

poolIndexName :: CCode Name
poolIndexName = Nam "POOL_INDEX"

futMsgTypeName :: Ty.Type -> ID.Name -> CCode Name
futMsgTypeName cls mname =
    Nam $ encoreName "fut_msg" ((Ty.getId cls) ++ "_" ++ show mname ++ "_t")

oneWayMsgTypeName :: Ty.Type -> ID.Name -> CCode Name
oneWayMsgTypeName cls mname =
    Nam $ encoreName "oneway_msg" ((Ty.getId cls) ++ "_" ++ show mname ++ "_t")

msgId :: Ty.Type -> ID.Name -> CCode Name
msgId ref mname =
    Nam $ "_ENC__MSG_" ++ Ty.getId ref ++ "_" ++ show mname

futMsgId :: Ty.Type -> ID.Name -> CCode Name
futMsgId ref mname =
    Nam $ "_ENC__FUT_MSG_" ++ Ty.getId ref ++ "_" ++ show mname

taskMsgId :: CCode Name
taskMsgId = Nam "_ENC__MSG_TASK"

oneWayMsgId :: Ty.Type -> ID.Name -> CCode Name
oneWayMsgId cls mname =
    Nam $ "_ENC__ONEWAY_MSG_" ++ Ty.getId cls ++ "_" ++ show mname

typeNamePrefix :: Ty.Type -> String
typeNamePrefix ref
  | Ty.isActiveClassType ref = encoreName "active" id
  | Ty.isSharedClassType ref = encoreName "shared" id
  | Ty.isPassiveClassType ref = encoreName "passive" id
  | Ty.isTraitType ref = encoreName "trait" id
  | otherwise = error $ "type_name_prefix Type '" ++ show ref ++
                        "' isnt reference type!"
  where
    id = Ty.getId ref

ponySendvName :: CCode Name
ponySendvName = Nam "pony_sendv"

ponyGcSendName :: CCode Name
ponyGcSendName = Nam "pony_gc_send"

ponySendDoneName :: CCode Name
ponySendDoneName = Nam "pony_send_done"

refTypeName :: Ty.Type -> CCode Name
refTypeName ref = Nam $ (typeNamePrefix ref) ++ "_t"

classTypeName :: Ty.Type -> CCode Name
classTypeName ref = Nam $ (typeNamePrefix ref) ++ "_t"

runtimeTypeName :: Ty.Type -> CCode Name
runtimeTypeName ref = Nam $ (typeNamePrefix ref) ++ "_type"

futureTraceFn :: CCode Name
futureTraceFn = Nam "future_trace"

futureMkFn :: CCode Name
futureMkFn = Nam "future_mk"

closureTraceFn :: CCode Name
closureTraceFn = Nam "closure_trace"

arrayTraceFn :: CCode Name
arrayTraceFn = Nam "array_trace"

streamTraceFn :: CCode Name
streamTraceFn = Nam "stream_trace"

futureTypeRecName :: CCode Name
futureTypeRecName = Nam $ "future_type"

closureTypeRecName :: CCode Name
closureTypeRecName = Nam $ "closure_type"

arrayTypeRecName :: CCode Name
arrayTypeRecName = Nam $ "array_type"

rangeTypeRecName :: CCode Name
rangeTypeRecName = Nam $ "range_type"

partyTypeRecName :: CCode Name
partyTypeRecName = Nam $ "party_type"
