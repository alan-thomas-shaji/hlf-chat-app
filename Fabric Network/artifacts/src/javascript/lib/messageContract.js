/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

// message{
//     messageId
//     sender:
//     DeviceMAC:
//     reciever:
//     multimediaPath:
//     timestamp:
//     state: active/origin

//     STATE-KEY: senderTimestampMultimediaReciever

// }

class MessageContract extends Contract {

    async initLedger(ctx) {

        console.info('============= START : Init Ledger ===========');
        const firstMessage = {
            messageId: "0000",
            docType: 'msg',
            sender: "Aneesh",
            deviceMAC: "08:56:27:6f:2b:9c",
            reciever: "PB",
            multimediaPath: "/home/usr/",
            timestamp: "Sat May 14 2022 11:05:14 GMT+0530"
        }

        await ctx.stub.putState("0000", Buffer.from(JSON.stringify(firstMessage)));
        console.info('============= END : Init Ledger ===========');
    }

    async queryMessage(ctx, messageId) {
        const messageAsBytes = await ctx.stub.getState(messageId); // get the car from chaincode state
        if (!messageAsBytes || messageAsBytes.length === 0) {
            throw new Error(`${messageId} does not exist`);
        }
        console.log(messageAsBytes.toString());
        return messageAsBytes.toString();
    }

    async createMessage(ctx, messageId, sender, deviceMAC, reciever, multimediaPath, timestamp) {
        console.info('============= START : Create Message ===========');

        const message = {
            messageId,
            docType: 'msg',
            sender,
            deviceMAC,
            reciever,
            multimediaPath,
            timestamp
        };

        await ctx.stub.putState(messageId, Buffer.from(JSON.stringify(message)));
        console.info('============= END : Create Message ===========');
    }

    async forwardMessage(ctx, messageId, newSender, newReciever) {
        console.info('============= START : forwardMessage ===========');

        const messageAsBytes = await ctx.stub.getState(messageId); // get the car from chaincode state
        if (!messageAsBytes || messageAsBytes.length === 0) {
            throw new Error(`${messageId} does not exist`);
        }
        const message = JSON.parse(messageAsBytes.toString());
        message.sender = newSender;
        message.reciever = newReciever;

        await ctx.stub.putState(messageId, Buffer.from(JSON.stringify(message)));
        console.info('============= END : forwardMessage ===========');
    }

    async getAssetHistory(ctx, messageId) {
        console.info('============= START : getAssetHistory ===========');
        let iterator = await ctx.stub.getHistoryForKey(messageId);
        let result = [];
        let res = await iterator.next();
        while (!res.done) {
            if (res.value) {
                console.info(`found state update with value: ${res.value.value.toString('utf8')}`);
                const obj = JSON.parse(res.value.value.toString('utf8'));
                result.push(obj);
            }
            res = await iterator.next();
        }
        await iterator.close();
        console.info('============= END : getAssetHistory ===========');
        return result;
    }

}

module.exports = MessageContract;
