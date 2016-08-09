import fs from "fs";
import { execSync as exec } from "child_process";

import _ from "lodash";

function buildManualSystemLoader(systems) {
    let bind = systems("878c8ef64d31a194159765945fc460cb6b3f486f");
    let autoParam = systems("b69aeff3eb1a14156b1a9c52652544bcf89761e2");
    let putSystem = systems("a26808f06030bb4c165ecbfe43d9d200672a0878");

    var manSysFuncs = {};
    let addManSys = function(id, builderFunc) {
        if(typeof id == "object") {
            _.forEach(id, value => {
                manSysFuncs[value] = builderFunc;
            });
        } else
            manSysFuncs[id] = builderFunc;
    };

    var manualSystems = function({ manSysFuncs, systems, putSystem, id }) {
        let result;

        if(manSysFuncs[id]) {
            result = manSysFuncs[id](systems);

            if(typeof result == "object") {
                _.forEach(result, (value, key) => {
                    putSystem({ id: key, system: value });
                });
                result = result[id];
            }
        }

        return result;
    };
    manualSystems = bind({ func: manualSystems, params: { manSysFuncs, systems, putSystem }});
    manualSystems = autoParam({ func: manualSystems, paramName: "id" });

    // TODO: See which of these can be converted to function call systems
    // TODO; Report of which of these have/have-not been loaded at certain points
    addManSys("4e63843a9bee61351b80fac49f4182bd582907b4", function(systems) {
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");
        let stringPut = systems("b4cdd85ce19700c7ef631dc7e4a320d0ed1fd385");

        let stringAutoPut = systems("8f8b523b9a05a55bfdffbf14187ecae2bf7fe87f");
        stringAutoPut = bind({ func: stringAutoPut, params: { stringFind, stringPut }});
        stringAutoPut = autoParam({ func: stringAutoPut, paramName: "string" });
        return stringAutoPut;
    });

    addManSys("c83cd0ab78a1d57609f9224f851bde6d230711d0", function(systems) {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let graphFactor = systems("4163d1cd63d3949b79c37223bd7da04ad6cd36c8");
        graphFactor = bind({ func: graphFactor, params: { graphFind }});
        return graphFactor;
    });

    addManSys("08f8db63b1843f7dea016e488bd547555f345c59", function(systems) {
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");
        let returnFirst = systems("68d3fb9d10ae2b0455a33f2bfb80543c4f137d51");
        let returnProperty = systems("c1020aea14a46b72c6f8a4b7fa57acc14a73a64e");

        let stringReadString = autoParam({ func: stringFind, paramName: "id" });
        stringReadString = returnFirst(stringReadString);
        stringReadString = returnProperty({ func: stringReadString, propertyName: "string" });
        return stringReadString;
    });

    addManSys("f7b073eb5ef5680e7ba308eaf289de185f0ec3f7", function(systems) {
        let graphPut = systems("7e5e764e118960318d513920a0f33e4c5ae64b50");
        let autoId = systems("e048e5d7d4a4fbc45d5cd0d035982dae2ee768d0");

        let graphAutoPut = autoParam({ func: graphPut, paramName: "element" });
        graphAutoPut = autoId(graphAutoPut);
        return graphAutoPut;
    });

    addManSys("990053fb6f50ab8cf4ea766f765acb89f88d3b3d", function() {
        let printReport = function(report) {
            report.forEach(({ node, names }) => {
                console.log(`${node} ${JSON.stringify(names)}`);
            });
        };
        return printReport;
    });

    addManSys("1cbcbae3c4aea924e7bb9af6c6bde5192a6646ae", function() {
        let groupReport = systems("f4d6f188f91fe3569bfc833d7d7ca960dc60d1f3");
        let printReport = systems("990053fb6f50ab8cf4ea766f765acb89f88d3b3d");

        let _printGroupReport = function({ groupReport, printReport, groupId }) {
            let report = groupReport(groupId);
            printReport(report);
        };

        let printGroupReport = bind({ func: _printGroupReport, params: { groupReport, printReport }});
        printGroupReport = autoParam({ func: printGroupReport, paramName: "groupId" });
        return printGroupReport;
    });

    addManSys("7b5e1726ccc3a1c2ac69e441900ba002c26b2f74", function(systems) {
        let graphAutoPut = systems("f7b073eb5ef5680e7ba308eaf289de185f0ec3f7");

        let graphAssign = systems("6c877bef62bc8f57eb55265c62e75b36515ef458");
        graphAssign = bind({ func: graphAssign, params: { graphAutoPut }});
        return graphAssign;
    });

    addManSys("25cff8a2afcf560b5451d2482dbf9d9d69649f26", function(systems) {
        let returnFirst = systems("68d3fb9d10ae2b0455a33f2bfb80543c4f137d51");
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let graphReadEdge = returnFirst(graphFind);
        graphReadEdge = autoParam({ func: graphReadEdge, paramName: "id" });
        return graphReadEdge;
    });

    addManSys("ca79cd84ab6a9eb3e5ac06ed48d3d24e6649d0bc", function(systems) {
        let callNodeFunction = systems("ad95b67eca3c4044cb78a730a9368c3e54a56c5f");
        callNodeFunction = bind({ func: callNodeFunction, params: { funcSys: systems }});
        return callNodeFunction;
    });

    addManSys("bf565ae1309f425b0ab00efa2ba541ae03ad22cf", function(systems) {
        let hashString = systems("c2ea0ae0bca74d50be301049b8ff6e3a5b7d10ae");

        let hashRandom = systems("2f7ff34b09a1fb23b9a5d4fbdd8bb44abbe2007a");
        hashRandom = bind({ func: hashRandom, params: { hashString }});
        return hashRandom;
    });

    addManSys("2885e34819b8a2f043b139bd92b96e484efd6217", function(systems) {
        let stringAutoPut = systems("4e63843a9bee61351b80fac49f4182bd582907b4");
        let graphAssign = systems("7b5e1726ccc3a1c2ac69e441900ba002c26b2f74");

        let name = systems("ddfe7d402ff26c18785bcc899fa69183b3170a7d");
        name = bind({ func: name, params: { stringAutoPut, graphAssign }});
        return name;
    });

    addManSys("890b0b96d7d239e2f246ec03b00cb4e8e06ca2c3", function(systems) {
        let graphFactor = systems("c83cd0ab78a1d57609f9224f851bde6d230711d0");
        let stringReadString = systems("08f8db63b1843f7dea016e488bd547555f345c59");

        let nameList = systems("81e0ef7e2fae9ccc6e0e3f79ebf0c9e14d88d266");
        nameList = bind({ func: nameList, params: { graphFactor, stringReadString }});
        nameList = autoParam({ func: nameList, paramName: "node" });
        return nameList;
    });

    addManSys("2bf3bbec64d4b33302b9ab228eb90bc3f04b22a8", function() {
        let graphFactor = systems("c83cd0ab78a1d57609f9224f851bde6d230711d0");
        let stringAutoPut = systems("4e63843a9bee61351b80fac49f4182bd582907b4");

        let nameListIds = systems("c4863daa27736a3fb94fa536fcf17bab5fce25bf");
        nameListIds = bind({ func: nameListIds, params: { stringAutoPut, graphFactor }});
        nameListIds = autoParam({ func: nameListIds, paramName: "name" });
        return nameListIds;
    });

    addManSys("d7f80b3486eee7b142c190a895c5496242519608", function() {
        let graphFactor = systems("c83cd0ab78a1d57609f9224f851bde6d230711d0");
        let stringReadString = systems("08f8db63b1843f7dea016e488bd547555f345c59");
        let graphReadEdge = systems("25cff8a2afcf560b5451d2482dbf9d9d69649f26");
        let callNodeFunction = systems("ca79cd84ab6a9eb3e5ac06ed48d3d24e6649d0bc");

        let readObject = systems("e5ac371a5d01eb2e1df8f42166f2ef20a5ae094b");
        readObject = bind({ func: readObject, params: { graphFactor, stringReadString, graphReadEdge, nodeFunc: callNodeFunction }});
        readObject = autoParam({ func: readObject, paramName: "node" });
        return readObject;
    });

    addManSys("c2d807f302ca499c3584a8ccf04fb7a76cf589ad", function() {
        let lokiRemove = systems("2ebd8d9fff28833dab44f086d4692fb888525fc8");
        let graphColl = systems("adf6b91bb7c0472237e4764c044733c4328b1e55");

        let graphRemove = bind({ func: lokiRemove, params: { db: graphColl }});
        graphRemove = autoParam({ func: graphRemove, paramName: "id" });
        return graphRemove;
    });

    addManSys("74b1eb95baaf14385cf3a0b1b76198a5cadfa258", function() {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let graphListNodes = systems("b7916f86301a6bc2af32f402f6515809bac75b03");
        graphListNodes = bind({ func: graphListNodes, params: { graphFind }});
        return graphListNodes;
    });

    addManSys("8c7d214678ce851d39ebb4a774c9f168bfffe43d", function() {
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");
        let returnFirst = systems("68d3fb9d10ae2b0455a33f2bfb80543c4f137d51");
        let returnProperty = systems("c1020aea14a46b72c6f8a4b7fa57acc14a73a64e");

        let stringGetId = autoParam({ func: stringFind, paramName: "string" });
        stringGetId = returnFirst(stringGetId);
        stringGetId = returnProperty({ func: stringGetId, propertyName: "id" });
        return stringGetId;
    });

    addManSys("a8a338d08b0ef7e532cbc343ba1e4314608024b2", function() {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let groupList = systems("ab54a0a1abd5f849fcc04c809e5db0ebb1f1cc29");
        groupList = bind({ func: groupList, params: { graphFind }});
        groupList = autoParam({ func: groupList, paramName: "group" });
        return groupList;
    });

    addManSys("6f00c44367d415878955630378683e1463f87aea", function() {
        let lokiRemove = systems("2ebd8d9fff28833dab44f086d4692fb888525fc8");
        let stringColl = systems("ce6de1160131bddb4e214f52e895a68583105133");

        let stringRemove = bind({ func: lokiRemove, params: { db: stringColl }});
        return stringRemove;
    });

    addManSys("708f17af0e4f537757cf8817cbca4ed016b7bb8b", function() {
        let graphFactor = systems("c83cd0ab78a1d57609f9224f851bde6d230711d0");
        let graphRemove = systems("c2d807f302ca499c3584a8ccf04fb7a76cf589ad");
        let stringGetId = systems("8c7d214678ce851d39ebb4a774c9f168bfffe43d");

        let nameRemove = systems("7087272f7205fdac70e1f29d3d4b9e170d99a431");
        nameRemove = bind({ func: nameRemove, params: { stringGetId, graphFactor, graphRemove }});
        return nameRemove;
    });

    addManSys("e048e5d7d4a4fbc45d5cd0d035982dae2ee768d0", function() {
        let hashRandom = systems("bf565ae1309f425b0ab00efa2ba541ae03ad22cf");

        let autoId = systems("a0089c410302c18427b4cbdc4c3a55de6a69eb8b");
        autoId = bind({ func: autoId, params: { hashRandom, paramName: "id" }});
        autoId = autoParam({ func: autoId, paramName: "func" });
        return autoId;
    });

    addManSys("76c55430fccd4f9e0b19c1c2b98d8a3babea81b2", function(systems) {
        let hashRandom = systems("bf565ae1309f425b0ab00efa2ba541ae03ad22cf");
        let graphAutoPut = systems("f7b073eb5ef5680e7ba308eaf289de185f0ec3f7");
        let name = systems("2885e34819b8a2f043b139bd92b96e484efd6217");

        let _createSystemFile = function({ hashRandom, graphAutoPut, nameFn, name }) {
            let newSystemId = hashRandom();
            exec("cp src/kitsune-core/ddfe7d402ff26c18785bcc899fa69183b3170a7d src/kitsune-core/"+newSystemId);
            graphAutoPut({ head: "66564ec14ed18fb88965140fc644d7b813121c78", tail: newSystemId });
            nameFn({ node: newSystemId, name: name });
        };

        let createSystemFile = bind({ func: _createSystemFile, params: { hashRandom, graphAutoPut, nameFn: name }});
        createSystemFile = autoParam({ func: createSystemFile, paramName: "name" });
        return createSystemFile;
    });

    addManSys("a21b86930a00f7b31b5984aabb21cb5eea7efc56", function(systems) {
        let graphAutoPut = systems("f7b073eb5ef5680e7ba308eaf289de185f0ec3f7");
        let name = systems("2885e34819b8a2f043b139bd92b96e484efd6217");

        let _createCoreNode = function({ node, name, graphAutoPut, nameFn }) {
            graphAutoPut({ head: "7f82d45a6ffb5c345f84237a621de35dd8b7b0e3", tail: node });
            nameFn({ node: node, name: name });
        };

        let createCoreNode = bind({ func: _createCoreNode, params: { graphAutoPut, nameFn: name }});
        return createCoreNode;
    });

    addManSys("f3db04b0138e827a9b513ab195cc373433407f83", function(systems) {
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");
        let graphListNodes = systems("74b1eb95baaf14385cf3a0b1b76198a5cadfa258");
        let stringRemove = systems("6f00c44367d415878955630378683e1463f87aea");

        let _cleanStringSystem = function({ stringFind, graphListNodes, stringRemove }) {
            let stringIds = stringFind({}).map(value => value.id);
            let graphNodes = graphListNodes();

            console.log(stringIds.length, graphNodes.length);

            let diff = _.difference(stringIds, graphNodes);

            console.log(diff);

            diff.forEach(id => {
                stringRemove({ id });
            });
        };

        let cleanStringSystem = bind({ func: _cleanStringSystem, params: { stringFind, graphListNodes, stringRemove }});
        return cleanStringSystem;
    });

    addManSys("9f3a4c1bb1d1e8da1fc3ab19c23cd5507666ab45", function(systems) {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let isInGroup = systems("a3fd8e7c0d51f13671ebbb6f9758833ff6120b42");
        isInGroup = bind({ func: isInGroup, params: { graphFind }});
        return isInGroup;
    });

    addManSys("20bfa138672de625230eef7faebe0e10ba6a49d0", function(systems) {
        let isInCollection = systems("d2f544f574dae26adb5ed3ee70c71e302b2575fa");
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let isEdge = bind({ func: isInCollection, params: { collFind: graphFind }});
        isEdge = autoParam({ func: isEdge, paramName: "node" });
        return isEdge;
    });

    addManSys("821f1f34a4998adf0f1efd9b772b57efef71a070", function(systems) {
        let isInCollection = systems("d2f544f574dae26adb5ed3ee70c71e302b2575fa");
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");

        let isString = bind({ func: isInCollection, params: { collFind: stringFind }});
        isString = autoParam({ func: isString, paramName: "node" });
        return isString;
    });

    addManSys("15b16d6f586760a181f017d264c4808dc0f8bd06", function(systems) {
        let typeMap = systems("4f22989e5edf2634371133db2720b09fc441a141")();

        let describeNode = systems("4bea815e7814aa415569ecd48e5733a19e7777db");
        describeNode = bind({ func: describeNode, params: { types: typeMap }});
        describeNode = autoParam({ func: describeNode, paramName: "node" });
        return describeNode;
    });

    addManSys("f3d18aa9371f876d4264bfe051e5b4e312e90040", function(systems) {
        let graphListNodes = systems("74b1eb95baaf14385cf3a0b1b76198a5cadfa258");
        let describeNode = systems("15b16d6f586760a181f017d264c4808dc0f8bd06");

        let _nodeDescReport = function({ systems, graphListNodes, describeNode }) {
            let nodeList = graphListNodes();

            console.log("== Node Description Report ==");
            nodeList.forEach(node => {
                let types = describeNode(node);
                console.log(node+" => "+JSON.stringify(types));
            });
        };

        let nodeDescReport = bind({ func: _nodeDescReport, params: { systems, graphListNodes, describeNode }});
        return nodeDescReport;
    });

    addManSys("39bedcfba59c016590ddd53ddc7d89268b5340fd", function(systems) {
        let isInGroup = systems("a3fd8e7c0d51f13671ebbb6f9758833ff6120b42");
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let isCoreNode = bind({ func: isInGroup, params: { graphFind, group: "7f82d45a6ffb5c345f84237a621de35dd8b7b0e3" }});
        isCoreNode = autoParam({ func: isCoreNode, paramName: "node" });
        return isCoreNode;
    });

    addManSys("b7df76bb3573caba7da57400c412f344cc309978", function(systems) {
        let isInGroup = systems("a3fd8e7c0d51f13671ebbb6f9758833ff6120b42");
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let isSystemFile = bind({ func: isInGroup, params: { graphFind, group: "66564ec14ed18fb88965140fc644d7b813121c78" }});
        isSystemFile = autoParam({ func: isSystemFile, paramName: "node" });
        return isSystemFile;
    });

    addManSys("f4d6f188f91fe3569bfc833d7d7ca960dc60d1f3", function(systems) {
        let groupList = systems("a8a338d08b0ef7e532cbc343ba1e4314608024b2");
        let nameList = systems("890b0b96d7d239e2f246ec03b00cb4e8e06ca2c3");

        let _groupReport = function({ groupList, nameList, groupId }) {
            let coreNodes = groupList(groupId);
            let nodesAndNames = [];
            coreNodes.forEach(node => {
                let names = nameList(node);
                nodesAndNames.push({
                    node,
                    names
                });
            });

            // Sort by first name
            nodesAndNames = _.sortBy(nodesAndNames, value => {
                return value.names[0];
            });

            return nodesAndNames;
        };

        let groupReport = bind({ func: _groupReport, params: { groupList, nameList }});
        groupReport = autoParam({ func: groupReport, paramName: "groupId" });
        return groupReport;
    });

    addManSys("604a2dbd0f19f35564efc9b9ca3d77ac82ea9382", function(systems) {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");
        let graphListNodes = systems("74b1eb95baaf14385cf3a0b1b76198a5cadfa258");

        let _graphReport = function({ graphFind, graphListNodes }) {
            let edges = graphFind();
            let nodes = graphListNodes();
            let nodePercent = (edges.length/nodes.length*100).toPrecision(4);

            console.log("== Graph Report ==");
            console.log("Nodes: "+nodes.length);
            console.log("Edges: "+edges.length+" ("+nodePercent+"%)");
        };

        let graphReport = bind({ func: _graphReport, params: { graphFind, graphListNodes }});
        return graphReport;
    });

    addManSys("8efd75de58a2802dd9b784d8bc1bdd66aaedd856", function() {
        let stringFind = systems("8b1f2122a8c08b5c1314b3f42a9f462e35db05f7");

        let _stringReport = function({ stringFind }) {
            let strings = stringFind();

            strings = _.sortBy(strings, "string");

            console.log("== String Report ==");
            strings.forEach(value => {
                console.log(`${value.id} => ${value.string}`);
            });
        };

        let stringReport = bind({ func: _stringReport, params: { stringFind }});
        return stringReport;
    });

    addManSys("8d15cc103c5f3453e8b5ad8cdada2e5d2dde8039", function(systems) {
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");
        let graphListNodes = systems("74b1eb95baaf14385cf3a0b1b76198a5cadfa258");
        let nameList = systems("890b0b96d7d239e2f246ec03b00cb4e8e06ca2c3");
        let describeNode = systems("15b16d6f586760a181f017d264c4808dc0f8bd06");

        let _edgeReport = function({ graphFind }) {
            console.log("== Graph Report ==");

            var edgeTypes = {};

            let makeFn = function(groupId) {
                return edgeId => {
                    let edge = graphFind({ id: edgeId })[0];
                    return edge.head == groupId;
                };
            };

            let allowedGroups = [
                "585d4cc792af1a4754f1819630068bdbb81bfd20",
                "66564ec14ed18fb88965140fc644d7b813121c78",
                "7f82d45a6ffb5c345f84237a621de35dd8b7b0e3",
                "d2cd5a6f99428baaa05394cf1fe3afa17fb59aff",
                "f1830ba2c84e3c6806d95e74cc2b04d99cd269e0"
            ];
            allowedGroups.forEach(coreNode => {
                let name = nameList(coreNode)[0];
                edgeTypes[name+"-group"] = makeFn(coreNode);
            });

            edgeTypes["name-edge"] = function(edgeId) {
                let search = graphFind({ head: "f1830ba2c84e3c6806d95e74cc2b04d99cd269e0", tail: edgeId });
                return search.length;
            };

            let edges = graphFind();
            let edgeIds = _.map(edges, "id");
            let edgeReport = _.map(edgeIds, function(edge) {
                let types = _.map(edgeTypes, (edgeType, name) => edgeType(edge) ? name : null).filter(x => x);
                return { edge, types };
            });

            edgeReport = _.sortBy(edgeReport, value => value.types.join(""));

            let [goodEdges, badEdges] = _.partition(edgeReport, value => value.types.length);

            let totalCount = edgeIds.length;
            let goodCount = goodEdges.length;
            let badCount = badEdges.length;
            let goodRatio = (goodCount / totalCount) * 100;

            console.log(`-- Good Edges: ${goodCount}/${totalCount} [${goodRatio.toFixed(2)}%] --`);
            _.forEach(goodEdges, data => console.log(`${data.edge} =>`, data.types));
            console.log(`-- Bad Edges: ${badCount} --`);
            _.forEach(badEdges, data => {
                console.log(data.edge);
                let edge = graphFind({ id: data.edge })[0];
                let headDesc = describeNode(edge.head);
                console.log(`\tH ${edge.head}  =>`, headDesc);
                let tailDesc = describeNode(edge.tail);
                console.log(`\tT ${edge.tail}  =>`, tailDesc);
            });

            console.log(`Good Edges: ${goodCount}/${totalCount} [${goodRatio.toFixed(2)}%]`);
            console.log(`Bad Edges: ${badCount}`);
        };

        let edgeReport = bind({ func: _edgeReport, params: { graphFind, graphListNodes }});
        return edgeReport;
    });

    addManSys("0750f117e54676b9eb32aebe5db1d3dae2e1853e", function(systems) {
        let groupList = systems("a8a338d08b0ef7e532cbc343ba1e4314608024b2");
        let nameList = systems("890b0b96d7d239e2f246ec03b00cb4e8e06ca2c3");

        let coreNodes = fs.readdirSync("node_modules/kitsune-core");

        let _systemFileReport = function({ groupList, nameList, coreNodes }) {
            console.log("=== System File Report ===");
            console.log("System files: "+coreNodes.length);

            let group = groupList("66564ec14ed18fb88965140fc644d7b813121c78");
            let systemFiles = group.sort();

            let list = coreNodes.map(node => {
                let isInGroup = systemFiles.indexOf(node) != -1;
                let myNames = nameList(node);
                return {
                    node,
                    isInGroup,
                    names: myNames
                };
            });

            list.sort((a, b) => {
                let aName = a.names[0] || "";
                let bName = b.names[0] || "";
                return aName.localeCompare(bName);
            });

            list.forEach(({isInGroup, node, names}) => {
                console.log(`[${isInGroup ? "X" : " "}] ${node} ${JSON.stringify(names)}`);
            });
        };

        let systemFileReport = bind({ func: _systemFileReport, params: { groupList, nameList, coreNodes }});
        return systemFileReport;
    });

    addManSys("842d244f8e9698d469dc060db0f9c9b4e24c50b0", function(systems) {
        let isInGroup = systems("a3fd8e7c0d51f13671ebbb6f9758833ff6120b42");
        let graphFind = systems("a1e815356dceab7fded042f3032925489407c93e");

        let isInNameGroup = bind({ func: isInGroup, params: { graphFind, group: "f1830ba2c84e3c6806d95e74cc2b04d99cd269e0" }});
        isInNameGroup = autoParam({ func: isInNameGroup, paramName: "node" });
        return isInNameGroup;
    });

    addManSys("7bee27a3335f7d2e3f562a84b9358b58f49390c1", function(systems) {
        let andIs = systems("90184a3d0c84658aac411637f7442f80b3fe0040");
        let isEdge = systems("20bfa138672de625230eef7faebe0e10ba6a49d0");
        let isInNameGroup = systems("842d244f8e9698d469dc060db0f9c9b4e24c50b0");

        let isNameEdge = bind({ func: andIs, params: { types: [ isEdge, isInNameGroup ] }});
        isNameEdge = autoParam({ func: isNameEdge, paramName: "node" });
        return isNameEdge;
    });

    addManSys("4f22989e5edf2634371133db2720b09fc441a141", function(systems) {
        let isCoreNode = systems("39bedcfba59c016590ddd53ddc7d89268b5340fd");
        let isEdge = systems("20bfa138672de625230eef7faebe0e10ba6a49d0");
        let isNameEdge = systems("7bee27a3335f7d2e3f562a84b9358b58f49390c1");
        let isString = systems("821f1f34a4998adf0f1efd9b772b57efef71a070");
        let isSystemFile = systems("b7df76bb3573caba7da57400c412f344cc309978");

        let typeMap = function() { return { isEdge, isString, isCoreNode, isSystemFile, isNameEdge }; };
        return typeMap;
    });

    addManSys("cfcb898db1a24d50ed7254644ff75aba4fb5c5f8", () => console.log);

    addManSys("58f4149870fd4f99bcbf8083eedfee6fbc1199b0", function() {
        let hashInteger = systems("cb76708f83577aa1a50f91ed39b98f077e969efe");
        let readInteger = systems("a3cb3210c4688aabf0772e5a7dec9c9922247194");
        let stringAutoPut = systems("4e63843a9bee61351b80fac49f4182bd582907b4");
        let stringReadString = systems("08f8db63b1843f7dea016e488bd547555f345c59");

        let typeMappings = {
            "integer": {
                typeFunc: _.isInteger,
                putFunc: hashInteger,
                readFuncId: readInteger.id
            },
            "string": {
                typeFunc: _.isString,
                putFunc: stringAutoPut,
                readFuncId: stringReadString.id
            },
            "function": {
                typeFunc: _.isFunction,
                putFunc: value =>  value.id,
                readFuncId: systems.id
            }
        };

        return function() {
            return typeMappings;
        };
    });

    addManSys(["c5cfe7d5154188daaa2a5cdf5d27a18fce4c2345",
               "0abebb208d96e3aa8a17890a5606734e03fa2539",
               "30381757ef98651b92e54ce11a4fb839e76aa847",
               "6e52da614fc7779bd2aed50b06e753ee09cc346b",
               "0d4085c107c1e9fab3fcb0cd49a8372003f00484",
               "253cd1812a32a6a81f1365e1eca19cc1549f6002"], function(systems) {

        // Object Put and Auto Put
        let graphAssign = systems("7b5e1726ccc3a1c2ac69e441900ba002c26b2f74");
        let graphAutoPut = systems("f7b073eb5ef5680e7ba308eaf289de185f0ec3f7");
        let stringAutoPut = systems("4e63843a9bee61351b80fac49f4182bd582907b4");
        let typeMappings = systems("58f4149870fd4f99bcbf8083eedfee6fbc1199b0")();
        let autoId = systems("e048e5d7d4a4fbc45d5cd0d035982dae2ee768d0");
        let name = systems("2885e34819b8a2f043b139bd92b96e484efd6217");

        let objectPut = systems("eed13556a72cf02a35da377d6d074fe39c3b59c4");
        objectPut = bind({ func: objectPut, params: { graphAssign, graphAutoPut, stringAutoPut, typeMappings }});

        let objectAutoPut = autoId(objectPut);
        objectAutoPut = autoParam({ func: objectAutoPut, paramName: "object" });

        // Add object to type mappings
        let readObject = systems("d7f80b3486eee7b142c190a895c5496242519608");
        typeMappings.objects = {
            typeFunc: _.isPlainObject,
            putFunc: objectAutoPut,
            readFuncId: readObject.id
        };

        let mappingResult = _.mapValues(typeMappings, function(value) {
            return value.readFuncId;
        });
        console.log(mappingResult);

        // Write func call Stuff
        let writeValue = systems("d2a5636a4b4e88b0c7c640bfd8915e78919641a0");
        writeValue = bind({ func: writeValue, params: { typeMappings }});
        writeValue = autoParam({ func: writeValue, paramName: "value" });

        let writeFuncCall = function({ writeValue, graphAssign, func, param }) {
            if(typeof func == "function")
                func = func.id;

            if(!func)
                throw new Error("funcId must not be null or must have an id");

            let ref = writeValue(param);

            let args = { head: ref.funcId, type: func, tail: ref.id };
            let result = graphAssign(args);

            return result;
        };
        writeFuncCall = bind({ func: writeFuncCall, params: { writeValue, graphAssign }});

        let writeAndNameFuncCall = function({ writeFuncCall, nameFn, func, param, name }) {
            let id = writeFuncCall({ func, param });
            graphAutoPut({ head: "d2cd5a6f99428baaa05394cf1fe3afa17fb59aff", tail: id });
            nameFn({ node: id, name });
            return id;
        };
        writeAndNameFuncCall = bind({ func: writeAndNameFuncCall, params: { writeFuncCall, nameFn: name }});

                   return { "c5cfe7d5154188daaa2a5cdf5d27a18fce4c2345": objectPut,
                            "0abebb208d96e3aa8a17890a5606734e03fa2539": objectAutoPut,
                            "30381757ef98651b92e54ce11a4fb839e76aa847": readObject,
                            "6e52da614fc7779bd2aed50b06e753ee09cc346b": writeValue,
                            "0d4085c107c1e9fab3fcb0cd49a8372003f00484": writeFuncCall,
                            "253cd1812a32a6a81f1365e1eca19cc1549f6002": writeAndNameFuncCall };
    });

    return manualSystems;
}

module.exports = buildManualSystemLoader;