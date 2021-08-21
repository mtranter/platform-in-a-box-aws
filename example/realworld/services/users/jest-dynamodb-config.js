module.exports = {
  tables: [
    {
      TableName: `UserService`,
      KeySchema: [
        {
          AttributeName: "hash",
          KeyType: "HASH",
        },
        {
          AttributeName: "range",
          KeyType: "RANGE",
        },
      ],
      AttributeDefinitions: [
        { AttributeName: "hash", AttributeType: "S" },
        { AttributeName: "range", AttributeType: "S" },
        { AttributeName: "gsi1Hash", AttributeType: "S" },
        { AttributeName: "gsi2Hash", AttributeType: "S" },
      ],
      ProvisionedThroughput: { ReadCapacityUnits: 1, WriteCapacityUnits: 1 },
      GlobalSecondaryIndexes: [
        {
          IndexName: `gsi1`,
          KeySchema: [
            {
              AttributeName: "gsi1Hash",
              KeyType: "HASH",
            },
            {
              AttributeName: "range",
              KeyType: "RANGE",
            },
          ],
          Projection: { ProjectionType: "ALL" },
          ProvisionedThroughput: {
            ReadCapacityUnits: 1,
            WriteCapacityUnits: 1,
          },
        },
        {
          IndexName: `gsi2`,
          KeySchema: [
            {
              AttributeName: "gsi2Hash",
              KeyType: "HASH",
            },
            {
              AttributeName: "range",
              KeyType: "RANGE",
            },
          ],
          Projection: { ProjectionType: "ALL" },
          ProvisionedThroughput: {
            ReadCapacityUnits: 1,
            WriteCapacityUnits: 1,
          },
        },
      ],
    },
    // etc
  ],
};
