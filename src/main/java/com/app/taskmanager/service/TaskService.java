package com.app.taskmanager.service;

import com.app.taskmanager.model.Task;
import com.app.taskmanager.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskService {

    private final TaskRepository taskRepository;

    @Cacheable(value = "tasks", key = "'all'")
    public List<Task> getAllTasks() {
        log.info("Fetching all tasks from database");
        return taskRepository.findAll();
    }

    @Cacheable(value = "tasks", key = "#id")
    public Task getTaskById(Long id) {
        log.info("Fetching task {} from database", id);
        return taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found with id: " + id));
    }

    @CacheEvict(value = "tasks", key = "'all'")
    @Transactional
    public Task createTask(Task task) {
        log.info("Creating new task: {}", task.getTitle());
        return taskRepository.save(task);
    }

    @CachePut(value = "tasks", key = "#id")
    @CacheEvict(value = "tasks", key = "'all'")
    @Transactional
    public Task updateTask(Long id, Task taskDetails) {
        log.info("Updating task {}", id);
        Task task = getTaskById(id);
        task.setTitle(taskDetails.getTitle());
        task.setDescription(taskDetails.getDescription());
        task.setCompleted(taskDetails.getCompleted());
        task.setPriority(taskDetails.getPriority());
        return taskRepository.save(task);
    }

    @CacheEvict(value = "tasks", allEntries = true)
    @Transactional
    public void deleteTask(Long id) {
        log.info("Deleting task {}", id);
        taskRepository.deleteById(id);
    }

    public List<Task> getTasksByStatus(Boolean completed) {
        return taskRepository.findByCompleted(completed);
    }
}