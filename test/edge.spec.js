import { expect } from "chai";
import _ from "lodash";
import sqlite3 from "sqlite3";

import getDB from "kitsune/systems/db/cache";
import ids from "kitsune/ids";
import bindEdge from "kitsune/systems/edge";
import * as util from "kitsune/util";

let sqliteDB = getDB();

let edgeSys = bindEdge(sqliteDB);

before((done) => sqliteDB.initP.then(() => done(), done));

describe("kitsune/edge", function() {

	describe("get(ids)", function() {
		it("should return the edge data for this id", function() {
			// noop
		});
	});

	describe("relate(head, ...tails)", function() {
		it("should create a generic edge between two nodes", function(done) {

			let [head, tail] = util.createIds(2);

			edgeSys.relate(head, tail)
				.then(edgeSys.get)
				.then(edge => {
					expect(edge).to.include({ head: head, tail: tail });
				})
				.then(done, done);
		});

		it("should create multple edges if multiple values are passed to tail", function(done) {

			let [ parent, childA, childB ] = util.createIds(3);

			edgeSys.relate(parent, childA, childB)
				.then(edgeSys.getMany)
				.then(edges => {
					// NOTE: This failed once, randomly
					expect(edges[0]).to.include({ head: parent, tail: childA });
					expect(edges[1]).to.include({ head: parent, tail: childB });
				})
				.then(done, done);
		});

		it("should allow null tails", function(done) {
			let head = util.createId();
			edgeSys.relate(head)
				.then(edgeSys.get)
				.then(edge => {
					expect(edge).to.contain({ head: head, tail: null });
				})
				.then(done, done);
		});
	});

	describe("del(...ids)", function() {
		it("should delete edges from the system", function(done) {
			let [nodeA, nodeB] = util.createIds(2);

			let edgeId;
			edgeSys.relate(nodeA, nodeB)
				.then(id => {
					edgeId = id;
					return edgeSys.get(id);
				})
				.then(edge => {
					expect(edge).to.include({ head: nodeA, tail: nodeB });
					return edgeSys.del(edgeId);
				})
				.then(edgeSys.get)
				.then(edge => {
					expect(edge).to.equal(undefined);
				})
				.then(done, done);
		});
	});

	describe("getTails(head)", function() {
		it("should get all tails of provided head", function(done) {
			let [head, tailA, tailB] = util.createIds(3);

			edgeSys.relate(head, tailA, tailB)
				.then(edgeSys.getMany)
				.then(edges => edgeSys.getTails(head))
				.then(tails => {
					expect(tails).to.contain(tailA, tailB);
				})
				.then(done, done);
		});
	});

	describe("getHeads(tail)", function(done) {
		it("should get all heads of provided tail", function() {
			let [headA, headB, tail] = util.createIds(3);

			Promise.all(_.map(
				[headA, headB],
				head => edgeSys.relate(head, tail)
			))
				.then(edgeIds => Promise.all(_.map(edgeIds, id => edgeSys.get(id))))
				.then(edges => edgeSys.getHeads(tail))
				.then(heads => {
					expect(heads).to.contain(headA, headB);
				})
				.then(done, done);
		});
	});

	it.skip("TODO: Assign multiple head/tails ???", function() {});

	describe("assign(edgeType, head, tail)", function() {
		it("creates a \"edgeType\" edge bewteen a head node and a tail node", function(done) {

			let [edgeType, head, tail] = util.createIds(3);

			edgeSys.assign(edgeType, head, tail)
				.then(edge => {
					expect(edge.head).to.equal(edgeType);
					return edgeSys.get(edge.tail);
				})
				.then(edge => {
					expect(edge).to.contain({ head, tail });
				})
				.then(done, done);
		});
	});

	describe("findByTail(edgeType, tail)", function() {
		it("resolves a list of nodes that are have \"edgeType\" edges to tail", function(done) {

			let [edgeType, nodeA, nodeB, nameId] = util.createIds(4);

			Promise.all([
				edgeSys.assign(edgeType, nodeA, nameId),
				edgeSys.assign(edgeType, nodeB, nameId)
			])
				.then(() => edgeSys.findByTail(edgeType, nameId))
				.then(ids => {
					expect(ids).to.have.members([nodeA, nodeB]);
				})
				.then(done, done);
		});
	});

	describe("findByHead(edgeType, head)", function() {
		it("resolves a list of nodes that are have \"edgeType\" edges to head", function(done) {

			let [edgeType, node, nameA, nameB] = util.createIds(4);

			Promise.all([
				edgeSys.assign(edgeType, node, nameA),
				edgeSys.assign(edgeType, node, nameB)
			])
				.then(() => edgeSys.findByHead(edgeType, node))
				.then(nameIds => {
					expect(nameIds).to.have.members([nameA, nameB]);
				})
				.then(done, done);
		});
	});
});
