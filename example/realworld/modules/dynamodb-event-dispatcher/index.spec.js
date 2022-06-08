const { handlerFactory } = require(".");

describe("DynamoDBEventDispatcher", () => {
  describe("handler", () => {
    it("Should forward events to SNS", async () => {
      const publishBatch = jest.fn().mockReturnValue({
        promise: () => Promise.resolve(),
      });
      const sut = handlerFactory({ publishBatch });
      await sut({
        Records: [
          {
            dynamodb: {
              NewImage: {
                isEvent: { BOOL: true },
                topicArn: { S: "topic-arn" },
                data: {
                  M: {
                    key: { S: "123" },
                    eventId: { S: "321" },
                  },
                },
              },
            },
          },
          {
            dynamodb: {
              NewImage: {
                isEvent: { BOOL: true },
                topicArn: { S: "topic-arn" },
                data: {
                  M: {
                    key: { S: "123" },
                    eventId: { S: "456" },
                  },
                },
              },
            },
          },
          {
            dynamodb: {
              NewImage: {
                isEvent: { BOOL: true },
                topicArn: { S: "topic2-arn" },
                data: {
                  M: {
                    key: { S: "123" },
                    eventId: { S: "456" },
                  },
                },
              },
            },
          },
        ],
      });
      expect(publishBatch).toHaveBeenCalledTimes(2);
      expect(publishBatch.mock.calls).toEqual([
        [
          {
            PublishBatchRequestEntries: [
              {
                Message: '{"key":"123","eventId":"321"}',
                MessageDeduplicationId: "321",
                MessageGroupId: "123",
              },
              {
                Message: '{"key":"123","eventId":"456"}',
                MessageDeduplicationId: "456",
                MessageGroupId: "123",
              },
            ],
            TopicArn: "topic-arn",
          },
        ],
        [
          {
            PublishBatchRequestEntries: [
              {
                Message: '{"key":"123","eventId":"456"}',
                MessageDeduplicationId: "456",
                MessageGroupId: "123",
              },
            ],
            TopicArn: "topic2-arn",
          },
        ],
      ]);
    });
  });
});
