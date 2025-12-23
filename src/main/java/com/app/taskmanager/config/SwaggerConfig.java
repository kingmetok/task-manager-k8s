package com.app.taskmanager.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class SwaggerConfig {

    @Value("${app.swagger.server-url:http://localhost:8080}")
    private String serverUrl;

    @Bean
    public OpenAPI taskManagerOpenAPI() {
        Server server = new Server();
        server.setUrl(serverUrl);
        server.setDescription("Task Manager API Server");

        Contact contact = new Contact();
        contact.setName("Task Manager Team");
        contact.setEmail("support@taskmanager.com");

        License license = new License()
                .name("MIT License")
                .url("https://opensource.org/licenses/MIT");

        Info info = new Info()
                .title("Task Manager REST API")
                .version("1.0.0")
                .description("A simple task management REST API with Redis caching and PostgreSQL storage. " +
                        "Built with Spring Boot for Kubernetes deployment.")
                .contact(contact)
                .license(license);

        return new OpenAPI()
                .info(info)
                .servers(List.of(server));
    }
}