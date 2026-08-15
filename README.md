# SSC OpenJDK custom plugin template walkthrough

This walkthrough will help you learn how to create a Java microservice using SSC's OpenJDK from scratch.

## Create a microservice

In order to do so, access to [Mia-Platform DevOps Console](https://console.cloud.mia-platform.eu/login), create a new project and go to the **Design** area. Once there, select _Microservices_ and go ahead creating a new one: that will take you to the [Mia-Platform Marketplace](https://docs.mia-platform.eu/development_suite/api-console/api-design/marketplace/), where you can find a set of Examples and Templates that can be used to set-up microservices with a pre-defined and tested function.

For this walkthrough select the following template: **SSC OpenJDK template**. After clicking on ut you will be asked to give the following information:

- Name (Internal Hostname)
- GitLab Group Name
- GitLab Repository Name
- Docker Image Name
- Description (optional)

You can read more about these fields in the [Manage your Microservices from the Dev Console](https://docs.mia-platform.eu/development_suite/api-console/api-design/services/) section of the Mia-Platform documentation.

Pick the name you prefer for your microservice: in this walkthrough we'll refer to it as **sighup-openjdk-demo**.
Then, fill the other required fields and confirm that you want to create a microservice. You have now generated a _sighup-openjdk-demo_ repository that will be deployed on Mia-Platform's [Nexus Repository Manager](https://nexus.mia-platform.eu/) as soon as the CI build script is successful.

## Save your changes

It is important to know that the microservice that you have just created is not saved yet on the DevOps Console. It is not essential to save the changes that you have made, since you will later make other modifications inside of your project in the DevOps Console.
If you decide to save your changes now, remember to choose a meaningful title for your commit (e.g "created service sighup_openjdk_demo"). After some seconds you will be prompted with a popup message which confirms that you have successfully saved all your changes.
A more detailed description on how to create and save a Microservice can be found in [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/#2-service-creation) section of the Mia-Platform documentation.

## Look inside your repository

After having created your first microservice (based on this template) you will be able to access to its git repository from the DevOps Console. You will find the project files in the _src_ folder: we provided a simple starting point for you to start with, but you are free to change it as you prefer. We took care of adding a few useful http endpoints that will be useful to integrate with kubernetes.

The repository also contains a rich _Makefile_, containing additional linters and fixers for other languages (e.g. bash, yaml, markdown): you can find the list of all the available commands by typing `make help` in your terminal.

## Add a new route

Now that you have successfully created a microservice from our SSC OpenJDK template you will add a _weather_ route to it.

Open the `src/Main.java` file and modify the code to add a new route and a new handler, so that it looks like this:

```java
package io.sighup;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
    public static void main(String[] args) throws IOException {
        // Create an HTTP server on port 8080
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);

        // Map the "/greetings" endpoint to the GreetingsHandler
        server.createContext("/greetings", new GreetingsHandler());

        // Map the "/weather" endpoint to the WeatherHandler
        server.createContext("/weather", new WeatherHandler());

        // Start the server
        server.start();

        System.out.println("Server started at http://0.0.0.0:8080");
    }

    static class GreetingsHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = "Hello, world!";
            exchange.sendResponseHeaders(200, response.length());
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

    static class WeatherHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = "{\"message\":\"It's sunny!\"}";
            exchange.sendResponseHeaders(200, response.length());
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
}
```

Once that is done, you can build the docker image as follows:

```bash
docker build --target=runtime -t mia-platfrom/openjdk-example:v0.1.0 .
```

Finally, you can run it:

```bash
docker run --rm -p 8080:8080 mia-platfrom/openjdk-example:v0.1.0
```

By running the server and visiting the `http://0.0.0.0:8080/weather` route, you can also test it's working as expected yourself:

```json
{"message":"It's sunny!"}
```

After committing these changes to your repository, you can go back to Mia Platform DevOps Console.

## Expose an endpoint to your microservice

In order to access to your new microservice it is necessary to create an endpoint that targets it. The _Step 3_ of the [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/#3-creating-the-endpoint) section of the Mia-Platform documentation explains in detail how to to do so from the DevOps Console.

For the sake of this walkthrough you will create an endpoint to your _sighup-openjdk-demo_. In order to do so, select _Endpoints_ from the Design area of your project and then create a new one.
Now you need to choose a path for your endpoint and connect it to your microservice. Give the following path to your endpoint: **/weather**. Then, specify that you want to connect your endpoint to a microservice and select _sighup-openjdk-demo_.

## Save your changes once more

After having created an endpoint for your microservice, you should **save the changes** that you have done to your project in the DevOps console, in a similar way to what you have previously done after the microservice creation.

## Deploy

Once all the changes that you have made are saved, you should deploy your project through the DevOps Console: you can do so within its **Deploy** area.
Once there, select the environment and the branch you have worked on and confirm your choices by clicking on the _deploy_ button. When the deploy process is finished, you will be informed by a pop-up message.
The _Step 5_ of the [Microservice from template - Get started](https://docs.mia-platform.eu/development_suite/api-console/api-design/custom_microservice_get_started/#5-deploy-the-project-through-the-api-console) section of the Mia-Platform documentation explains in detail how to correctly deploy your project.

## Try it

If you now run the following command in your terminal (remember to replace `${PROJECT_HOST}` with the actual host of your project):

```shell
curl ${PROJECT_HOST}/weather
```

You should see a message that looks like this:

```text
It's sunny!
```

Congratulations! You have successfully learnt how to modify a blank template into an _Hello World_ OpenJDK microservice!
