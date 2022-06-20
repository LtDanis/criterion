-- The simplest/silliest of all benchmarks!

import Criterion.Main
import Network.URI (parseURI)
import Network.HTTP
import Network.TCP as TCP

main :: IO ()
main = defaultMain [
  bgroup "run" [bench "Q1_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{}\", \"str1\", \"num\"]", searchType = "SEARCH"}),
                bench "Q1_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": {},\\\"fields\\\":  [\\\"str1\\\", \\\"num\\\"],\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q1_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..['num', 'str']\"]", searchType = "SEARCH"}),
                bench "Q2_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{}\", \"nested_obj.str\", \"nested_obj.num\"]", searchType = "SEARCH"}),
                bench "Q2_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": {},\\\"fields\\\":  [\\\"nested_obj.str\\\", \\\"nested_obj.num\\\"],\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q2_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[\'nested_obj.num\', \'nested_obj.num\']\"]", searchType = "SEARCH"}),
                bench "Q3_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$or\\\" : [ { \\\"sparse7700\\\" : {\\\"$exists\\\" : true} } , { \\\"sparse7709\\\" : {\\\"$exists\\\" : true} } ] }\", \"sparse7700\", \"sparse7709\"]", searchType = "SEARCH"}),
                bench "Q3_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$or\\\" : [ { \\\"sparse7700\\\" : {\\\"$exists\\\" : true} } , { \\\"sparse7709\\\" : {\\\"$exists\\\" : true} } ] },\\\"fields\\\":  [\\\"sparse7700\\\", \\\"sparse7709\\\"],\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q3_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[\'sparse7700\', \'sparse7709\']\"]", searchType = "SEARCH"}),
                bench "Q4_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$or\\\" : [ { \\\"sparse7700\\\" : {\\\"$exists\\\" : true} } , { \\\"sparse9900\\\" : {\\\"$exists\\\" : true} } ] }\", \"sparse7700\", \"sparse9900\"]", searchType = "SEARCH"}),
                bench "Q4_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$or\\\" : [ { \\\"sparse7700\\\" : {\\\"$exists\\\" : true} } , { \\\"sparse9900\\\" : {\\\"$exists\\\" : true} } ] },\\\"fields\\\":  [\\\"sparse7700\\\", \\\"sparse9900\\\"],\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q4_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[\'sparse7700\', \'sparse9900\']\"]", searchType = "SEARCH"}),
                bench "Q5_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"str1\\\" : \\\"7d665e63-b35b-4d07-9d7d-f9b2ea888946\\\" }\"]", searchType = "SEARCH"}),
                bench "Q5_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"str1\\\":  \\\"7d665e63-b35b-4d07-9d7d-f9b2ea888946\\\" },\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q5_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.str1 == \'7d665e63-b35b-4d07-9d7d-f9b2ea888946\')]\"]", searchType = "SEARCH"}),
                bench "Q6_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 30000 } }]}\"]", searchType = "SEARCH"}),
                bench "Q6_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 30000 } }]},\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q6_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.num >= 10000 && @.num < 30000)]\"]", searchType = "SEARCH"}),
                bench "Q7_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$and\\\": [{ \\\"dyn1\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"dyn1\\\" : { \\\"$lt\\\" : 30000 } }]}\"]", searchType = "SEARCH"}),
                bench "Q7_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$and\\\": [{ \\\"dyn1\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"dyn1\\\" : { \\\"$lt\\\" : 30000 } }]},\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q7_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.dyn1 >= 10000 && @.dyn1 < 30000)]\"]", searchType = "SEARCH"}),
                bench "Q8_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"nested_arr\\\" : \\\"WRB+DO\\\"}\"]", searchType = "SEARCH"}),
                bench "Q8_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"nested_arr\\\" : { \\\"$in\\\": [\\\"WRB+DO\\\"]}},\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q8_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.nested_arr[0] == \'WRB+DO\' || @.nested_arr[1] == \'WRB+DO\' || @.nested_arr[2] == \'WRB+DO\' || @.nested_arr[3] == \'WRB+DO\' || @.nested_arr[4] == \'DWRB+DOI\' || @.nested_arr[5] == \'WRB+DO\' || @.nested_arr[6] == \'WRB+DO\')]\"]", searchType = "SEARCH"}),
                bench "Q9_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{\\\"sparse500\\\": \\\"8-740a767c-17de-4c73-a2ff-1bc1f491c524\\\"}\"]", searchType = "SEARCH"}),
                bench "Q9_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": {\\\"sparse500\\\": \\\"8-740a767c-17de-4c73-a2ff-1bc1f491c524\\\"},\\\"limit\\\": 2000000}\"]", searchType = "SEARCH"}),
                bench "Q9_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.sparse500 == \'8-740a767c-17de-4c73-a2ff-1bc1f491c524\')]\"]", searchType = "SEARCH"}),
                bench "Q10_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 30000 } }]}\", \"thousandth\"]", searchType = "GROUP"}),
                bench "Q10_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 30000 } }]},\\\"limit\\\": 2000000}\", \"thousandth\"]", searchType = "GROUP"}),
                bench "Q10_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.num >= 10000 && @.num < 30000)]\", \"thousandth\"]", searchType = "GROUP"}),
                bench "Q11_MONGO"  $ whnfIO (run Query {dbType = "MONGO", dbQuery = "[\"{ \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 13000 } }]}\", \"nested_obj.str\", \"str1\"]", searchType = "JOIN"}),
                bench "Q11_COUCH"  $ whnfIO (run Query {dbType = "COUCH_DB", dbQuery = "[\"{\\\"selector\\\": { \\\"$and\\\": [{ \\\"num\\\" : { \\\"$gte\\\" : 10000 } }, { \\\"num\\\" : { \\\"$lt\\\" : 13000 } }]},\\\"limit\\\": 2000000}\", \"nested_obj.str\", \"str1\"]", searchType = "JOIN"}),
                bench "Q11_AERO"  $ whnfIO (run Query {dbType = "AEROSPIKE", dbQuery = "[\"$..[?(@.num >= 10000 && @.num < 13000)]\", \"nested_obj.str\", \"str1\"]", searchType = "JOIN"})
               ]
  ]

data Query = Query {dbType :: String, dbQuery :: String, searchType :: String} deriving (Show)

run :: Query -> IO Integer
run q = execute (dbType q) (dbQuery q) (searchType q)

execute :: String -> String -> String -> IO Integer
execute dbType dbQuery searchType = do
  conn <- TCP.openStream "localhost" 4567
  let request = createRequest dbType dbQuery searchType
  rawResponse <- sendHTTP conn request
  body <- getResponseBody rawResponse
  return (read body :: Integer)

createRequest :: String -> String -> String -> Request String
createRequest t b s = Request {rqURI = case parseURI ("http://localhost:4567/run/" ++ t ++ "/test/" ++ s ++ "/USER-2022-05-17T14:05:50.812193") of Just u -> u
                        , rqMethod  = POST
                        , rqHeaders = [mkHeader HdrContentType "text/html", mkHeader HdrContentLength (show (length b))]
                        , rqBody    = b
}
