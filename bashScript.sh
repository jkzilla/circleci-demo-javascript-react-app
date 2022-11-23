#!/bin/bash
export MATCHED_VALUE="u10l"
curl --request GET 'https://circleci.com/api/v2/context?owner-id=39114a72-17c0-4a08-96b6-5d6e8126b7f2' --header "circle-token: ${CIRCLE_TOKEN}"  | jq -r '.items[].id' >> listIds.txt
cat listIds.txt
while read -r line; do
    export TRUNCATED_VALUE=$(curl -X POST -H content-type:application/json -H Authorization:$CIRCLE_TOKEN \
        https://circleci.com/graphql-unstable \
        -d '{"operationName":"Context","variables":{"contextId": "'"$line"'"},"query":"query Context($contextId: ID!) {\n  context(id: $contextId) {\n    id\n    resources {\n      createdAt\n      truncatedValue\n      variable\n      __typename\n    }\n    groups {\n      edges {\n        node {\n          id\n          name\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    owner {\n      ... on Organization {\n        id\n        groups {\n          edges {\n            node {\n              id\n              name\n              __typename\n            }\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    name\n    __typename\n  }\n}\n"}' | jq -r '.data.context.resources[].truncatedValue')
    echo $TRUNCATED_VALUE
    if [[ "$MATCHED_VALUE" = *"$TRUNCATED_VALUE"* ]]; then
        echo "Matched"
        export CONTEXT_ID=$line
        echo $CONTEXT_ID
        export VARIABLE_NAME=$(curl -X POST -H content-type:application/json -H Authorization:$CIRCLE_TOKEN \
        https://circleci.com/graphql-unstable \
        -d '{"operationName":"Context","variables":{"contextId": "'"$line"'"},"query":"query Context($contextId: ID!) {\n  context(id: $contextId) {\n    id\n    resources {\n      createdAt\n      truncatedValue\n      variable\n      __typename\n    }\n    groups {\n      edges {\n        node {\n          id\n          name\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    owner {\n      ... on Organization {\n        id\n        groups {\n          edges {\n            node {\n              id\n              name\n              __typename\n            }\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    name\n    __typename\n  }\n}\n"}' | jq -r '.data.context.resources[].variable')
        echo $VARIABLE_NAME
    fi
done < listIds.txt


