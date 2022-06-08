const AWS = require("aws-sdk");
const { SNS } = require("aws-sdk");

const _sns = new SNS();

const isEvent = (e) => e.isEvent;

const handlerFactory =
  (sns = _sns) =>
  async (e) => {
    console.info("Received event", e);

    const eventBatches = e.Records.map((r) =>
      AWS.DynamoDB.Converter.unmarshall(r.dynamodb.NewImage)
    )
      .filter(isEvent)
      .reduce((p, e) => ({
        ...p,
        [e.topicArn]: [
          ...(p[e.topicArn] || []),
          {
            Message: JSON.stringify(e.data),
            MessageGroupId: e.data.key,
            MessageDeduplicationId: e.data.eventId,
          },
        ],
      }), {});

    await Promise.all(
      Object.keys(eventBatches).map((k) =>
        sns
          .publishBatch({
            TopicArn: k,
            PublishBatchRequestEntries: eventBatches[k],
          })
          .promise()
      )
    );
  };

const handler = handlerFactory(_sns, process.env.TOPIC_ARN);
module.exports = {
  handlerFactory,
  handler,
};
