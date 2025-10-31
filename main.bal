import ballerina/http;

final http:Client webhookClient = check new ("https://webhook.site");

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowHeaders: ["Content-Type", "Authorization"],
        allowCredentials: false,
        maxAge: 84900
    }
}
service / on new http:Listener(9090) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get greeting() returns string {
        return "Hello, World!";
    }

    resource function post guestService(@http:Payload GuestStatus payload) returns error|json {
        do {
            http:Response webhookResponse = check webhookClient->/["79cec4ce-3aed-449f-9e01-f641071b04e9"].post(payload);
            json responsePayload = check webhookResponse.getJsonPayload();
            return responsePayload;
        } on fail error err {
            return error("Failed to send payload to webhook", err);
        }
    }
}
