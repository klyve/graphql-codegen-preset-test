## Graphql codegen near operation bug

This repository is created to illustrate a bug where using the codegen preset `near-operation-file` results in skipped typechecking operations.

Given the following codegen yaml

```yaml
generates:
  generated:
    documents: "*.graphql"
    preset: near-operation-file
    presetConfig:
      extension: .generated.ts
      baseTypesPath: ./types.ts
    plugins:
      - typescript-operations
      - typescript-react-apollo
    config:
      withHooks: true
    schema: ./schema.graphql
```

The schema

```graphql
schema {
  mutation: Mutation
  query: Query
}

type User {
  id: ID!
  name: String!
}

input CreateUserInput {
  name: String!
}

type Query {
  user(id: ID!): User!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
}
```

And the near-operation file:

```graphql
mutation CreateUser($input: CreateUserInput!) {
  createUser(unknown: $unknown) {
    ...UNKNOWN_FRAGMENT
  }
}
```

Running this through codegen with the preset `near-operation-file`
results in no errors but the expected result is:

- `unknown` is not an argument
- UNKNOWN_FRAGMENT does not exist in the schema

As observed it skips the typechecking and generates code for the invalid file

## Running the tests:

To run the tests clone the repo and run `yarn install` then `yarn test`.
This will run the shell script `run-tests.sh` which will run all the tests and clean up after itself.

To run each individual tests run `yarn test:setup`

- `yarn test:introspection` to test generation using a json file generated from introspection as schema input
- `yarn test:schema` to test using the schema.graphql file as input
- `yarn test:operations` to run the operations test (This fails during typecheckign as expected)
