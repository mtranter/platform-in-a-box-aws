const AWS = require("aws-sdk");
const firehose = new AWS.Firehose();

const handler = (event) =>
  firehose
    .putRecordBatch({
      Records: event.Records.map((r) => ({ Data: `${r.body}\n` })),
      DeliveryStreamName: process.env.DELIVERY_STREAM_NAME,
    })
    .promise()
    .catch((e) => {
      console.error(e);
      throw e;
    });

module.exports.handler = handler;
