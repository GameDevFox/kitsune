import systemLoader from "kitsune-core/31d21eb2620a8f353a250ad2edd4587958faf3b1";
import buildManualSystemLoader from "kitsune/manual-systems.js";

import Logger from "js-logger";
let rootLogger = Logger.get("root");
let bootstrapLogger = Logger.get("bootstrap");

rootLogger.setLevel(Logger.INFO);
bootstrapLogger.setLevel(Logger.WARN);

// BOOTSTRAP - STEP 1
function buildLoader({ bind, autoParam }) {
    // INIT LOADER SYSTEM - already loaded, just here for reference
    // let systemLoaderId = "31d21eb2620a8f353a250ad2edd4587958faf3b1"; // system-loader
    let loader = bind({ func: systemLoader, params: { path: "kitsune-core" }});
    loader = autoParam({ func: loader, paramName: "id" });

    return loader;
}

// BOOTSTRAP - STEP 2
function buildCache({ loader, bind }) {
    let systemList = {};

    let dictFunc = loader("30c8959d5d7804fb80cc9236edec97e04e5c4c3d"); // dictionary-function
    let cache = dictFunc(systemList);

    var putSystem = loader("d1e484530280752dd99b7e64a854f96cf66dd502"); // put-system
    putSystem = bind({ func: putSystem, params: { systemList }});

    return { cache, putSystem };
}

// BOOTSTRAP - STEP 3
function buildCore({ cache, modules, putSystem, bind, autoParam }) {
    let systems = function({ cache, modules, id }) {

        let system = cache(id);

        if(!system) {
            for(let key in modules) {
                let module = modules[key];
                system = module(id);

                if(system)
                    break;
            }

            if(system)
                putSystem({ id, system });
            else
                rootLogger.warn("System was not found for id: "+id);
        }
        return system;
    };
    systems = bind({ func: systems, params: { cache, modules }});
    systems = autoParam({ func: systems, paramName: "id" });

    return systems;
}

// BOOTSTRAP - STEP 4
function loadDataSystems({ loader, bind, autoParam, putSystem }) {

    let graphData = loader("24c045b912918d65c9e9aaea9993e9ab56f50d2e");
    let stringData = loader("1cd179d6e63660fba96d54fe71693d1923e3f4f1");

    let lokiColl = loader("0741c54e604ad973eb41c02ab59c5aabdf2c6bc3");
    let lokiPut = loader("f45ccdaba9fdca2234be7ded1a5578dd17c2374e");
    let lokiFind = loader("30dee1b715bcfe60afeaadbb0e3e66019140686a");

    let valueFunc = loader("62126ce823b700cf7441b5179a3848149c9d8c89");

    // Graph
    let graphColl = lokiColl();
    putSystem({ id: "adf6b91bb7c0472237e4764c044733c4328b1e55", system: valueFunc(graphColl) });

    let graphPut = bind({ func: lokiPut, params: { db: graphColl }});
    putSystem({ id: "7e5e764e118960318d513920a0f33e4c5ae64b50", system: graphPut });

    let graphFind = bind({ func: lokiFind, params: { db: graphColl }});
    graphFind = autoParam({ func: graphFind, paramName: "where" });
    putSystem({ id: "a1e815356dceab7fded042f3032925489407c93e", system: graphFind });

    // String
    let stringColl = lokiColl();
    putSystem({ id: "ce6de1160131bddb4e214f52e895a68583105133", system: valueFunc(stringColl) });

    let stringPut = bind({ func: lokiPut, params: { db: stringColl }});
    putSystem({ id: "b4cdd85ce19700c7ef631dc7e4a320d0ed1fd385", system: stringPut });

    let stringFind = bind({ func: lokiFind, params: { db: stringColl }});
    stringFind = autoParam({ func: stringFind, paramName: "where" });
    putSystem({ id: "8b1f2122a8c08b5c1314b3f42a9f462e35db05f7", system: stringFind });

    // Populate collections
    var insertData = function({ data, put }) {
        data().forEach(value => {
            put({ element: value });
        });
    };

    insertData({ data: graphData, put: graphPut });
    insertData({ data: stringData, put: stringPut });

    return { graphFind, stringPut, stringFind };
}

// SYSTEM LOADER: Function Call
function buildFuncCallLoader(systems) {

    let bind = systems("878c8ef64d31a194159765945fc460cb6b3f486f");
    let autoParam = systems("b69aeff3eb1a14156b1a9c52652544bcf89761e2");
    let putSystem = systems("a26808f06030bb4c165ecbfe43d9d200672a0878");

    // 4
    let returnFirst = systems("68d3fb9d10ae2b0455a33f2bfb80543c4f137d51");
    let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");
    let graphReadEdge = returnFirst(graphFind);
    graphReadEdge = autoParam({ func: graphReadEdge, paramName: "id" });

    // 3
    let readAssign = systems("b8aea374925bfcd5884054aa23fed2ccce3c1174");
    readAssign = bind({ func: readAssign, params: { graphReadEdge }});
    readAssign = autoParam({ func: readAssign, paramName: "id" });

    let callNodeFunction = systems("ad95b67eca3c4044cb78a730a9368c3e54a56c5f");
    // TODO: Figure out why this isn't needed
    // callNodeFunction = bind({ func: callNodeFunction, params: { funcSys: systems }});

    // 2
    let readFuncCall = systems("2751294a2da41ad516a23054f3273a9f3bd028b4");
    readFuncCall = bind({ func: readFuncCall, params: { readAssign }});
    readFuncCall = autoParam({ func: readFuncCall, paramName: "id" });

    let executeFunction = systems("db7ab44b273faf81159baba0e847aaf0e46a406b");
    executeFunction = bind({ func: executeFunction, params: {callNodeFunc: callNodeFunction, funcSys: systems }});

    // 1
    // TODO: Make a file system
    let loadSystem = function({ readFuncCall, executeFunction, id }) {
        let funcCall = readFuncCall(id);

        if(!funcCall)
            return null;

        let func = executeFunction(funcCall);

        return func;
    };
    loadSystem = bind({ func: loadSystem, params: { readFuncCall, executeFunction }});
    loadSystem = autoParam({ func: loadSystem, paramName: "id" });

    // 0
    // TODO: Make a file system
    let funcCallSystems = function({ loadSystem, putSystem, id }) {

        let system = loadSystem(id);

        if(system)
            putSystem({ id, system });

        return system;
    };
    funcCallSystems = bind({ func: funcCallSystems, params: {
        loadSystem,
        putSystem
    }});
    funcCallSystems = autoParam({ func: funcCallSystems, paramName: "id" });
    return funcCallSystems;
}

// SYSTEM LOADER: Manual
function bootstrap() {

    let log = bootstrapLogger;

    // STEP 1: LOADER
    log.info(":Loader");
    let bind = systemLoader({ path: "kitsune-core", id: "878c8ef64d31a194159765945fc460cb6b3f486f" });
    let autoParam = systemLoader({ path: "kitsune-core", id: "b69aeff3eb1a14156b1a9c52652544bcf89761e2" });
    let loader = buildLoader({ bind, autoParam });

    // STEP 2: CACHE MODULE
    log.info(":Cache Modules");
    let { cache, putSystem } = buildCache({ loader, bind });
    putSystem({ id: "a26808f06030bb4c165ecbfe43d9d200672a0878", system: putSystem });

    // STEP 3: BUILD CORE
    log.info(":Build Core");
    let modules = [loader];
    let systems = buildCore({ cache, modules, putSystem, bind, autoParam });
    putSystem({ id: "ab3c2b8f8ef49a450344437801bbadef765caf69", system: systems });

    // STEP 4: LOAD DATA SYSTEMS
    log.info(":Load Data Systems");
    let { graphFind, stringPut, stringFind } = loadDataSystems({ loader, bind, autoParam, putSystem });

    // Build and load system loaders
    log.info(":Manual System Loader");
    let manualSystems = buildManualSystemLoader(systems);
    log.info(":Function Call Systems");
    let funcCallSystems = buildFuncCallLoader(systems);

    modules.push(manualSystems, funcCallSystems);

    return { modules, systems };
}

module.exports = bootstrap;