// routes/task.route.js
const express = require('express');
const auth = require('../../middlewares/auth');
const validate = require('../../middlewares/validate');
const taskValidation = require('../../validations/task.validation');
const taskController = require('../../controllers/task.controller');

const router = express.Router();

router
    .route('/')
    .post(
        auth('manageTasks'),
        validate(taskValidation.createTask),
        taskController.createTask
    )
    .get(
        auth('getTasks'),
        validate(taskValidation.getTasks),
        taskController.getTasks
    );

router
    .route('/:taskId')
    .get(
        auth('getTasks'),
        validate(taskValidation.getTask),
        taskController.getTask
    )
    .patch(
        auth('manageTasks'),
        validate(taskValidation.updateTask),
        taskController.updateTask
    )
    .delete(
        auth('manageTasks'),
        validate(taskValidation.deleteTask),
        taskController.deleteTask
    );

router
    .route('/:taskId/assign/:userId')
    .patch(
        auth('manageTasks'),
        validate(taskValidation.assignTask),
        taskController.assignTask
    );

module.exports = router;

/**
 * @swagger
 * tags:
 *   name: Tasks
 *   description: Task management and retrieval
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Task:
 *       type: object
 *       required:
 *         - name
 *         - project_id
 *         - created_by
 *       properties:
 *         id:
 *           type: string
 *           description: Task ID
 *         project_id:
 *           type: string
 *           description: Project ID this task belongs to
 *         name:
 *           type: string
 *           maxLength: 255
 *           description: Task name
 *         description:
 *           type: string
 *           description: Task description
 *         status:
 *           type: string
 *           enum: [to_do, in_progress, in_review, done]
 *           default: to_do
 *           description: Task status
 *         priority:
 *           type: string
 *           enum: [low, medium, high, urgent]
 *           default: medium
 *           description: Task priority
 *         due_date:
 *           type: string
 *           format: date-time
 *           description: Due date
 *         estimated_hours:
 *           type: number
 *           description: Estimated hours
 *         actual_hours:
 *           type: number
 *           default: 0
 *           description: Actual hours spent
 *         assignee_id:
 *           type: string
 *           description: Assigned user ID
 *         created_by:
 *           type: string
 *           description: Creator user ID
 *         created_at:
 *           type: string
 *           format: date-time
 *         updated_at:
 *           type: string
 *           format: date-time
 *       example:
 *         id: 661e2b3f1a2b3c4d5e6f7890
 *         project_id: 661e2b3f1a2b3c4d5e6f7888
 *         name: Implement login feature
 *         description: Allow users to log in with email and password
 *         status: in_progress
 *         priority: high
 *         due_date: 2025-05-01T00:00:00.000Z
 *         estimated_hours: 8
 *         actual_hours: 2
 *         assignee_id: 661e2b3f1a2b3c4d5e6f7881
 *         created_by: 661e2b3f1a2b3c4d5e6f7880
 *         created_at: 2025-04-24T02:35:00.000Z
 *         updated_at: 2025-04-24T03:00:00.000Z
 */

/**
 * @swagger
 * /tasks:
 *   post:
 *     summary: Create a new task
 *     description: Create a new task in a project
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - project_id
 *               - created_by
 *             properties:
 *               project_id:
 *                 type: string
 *               name:
 *                 type: string
 *                 maxLength: 255
 *               description:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [to_do, in_progress, in_review, done]
 *                 default: to_do
 *               priority:
 *                 type: string
 *                 enum: [low, medium, high, urgent]
 *                 default: medium
 *               due_date:
 *                 type: string
 *                 format: date-time
 *               estimated_hours:
 *                 type: number
 *               actual_hours:
 *                 type: number
 *                 default: 0
 *               assignee_id:
 *                 type: string
 *               created_by:
 *                 type: string
 *     responses:
 *       201:
 *         description: Task created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Task'
 *       400:
 *         description: Invalid data or task name already exists in this project
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 *
 *   get:
 *     summary: Get all tasks
 *     description: Get a paginated and filtered list of tasks
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: name
 *         schema:
 *           type: string
 *         description: Task name
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: Task status
 *       - in: query
 *         name: priority
 *         schema:
 *           type: string
 *         description: Task priority
 *       - in: query
 *         name: project_id
 *         schema:
 *           type: string
 *         description: Project ID
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *         description: Sort by field (e.g., name:asc, due_date:desc)
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *         default: 10
 *         description: Number of results per page
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *         default: 1
 *         description: Page number
 *     responses:
 *       200:
 *         description: List of tasks
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 results:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Task'
 *                 page:
 *                   type: integer
 *                 limit:
 *                   type: integer
 *                 totalPages:
 *                   type: integer
 *                 totalResults:
 *                   type: integer
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 */

/**
 * @swagger
 * /tasks/{taskId}:
 *   get:
 *     summary: Get a single task
 *     description: Get detailed information of a task by ID
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: taskId
 *         required: true
 *         schema:
 *           type: string
 *         description: Task ID
 *     responses:
 *       200:
 *         description: Task details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Task'
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 *       404:
 *         description: Task not found
 *
 *   patch:
 *     summary: Update a task
 *     description: Update task information by ID
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: taskId
 *         required: true
 *         schema:
 *           type: string
 *         description: Task ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 maxLength: 255
 *               description:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [to_do, in_progress, in_review, done]
 *               priority:
 *                 type: string
 *                 enum: [low, medium, high, urgent]
 *               due_date:
 *                 type: string
 *                 format: date-time
 *               estimated_hours:
 *                 type: number
 *               actual_hours:
 *                 type: number
 *               assignee_id:
 *                 type: string
 *     responses:
 *       200:
 *         description: Task updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Task'
 *       400:
 *         description: Invalid data or task name already exists in this project
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 *       404:
 *         description: Task not found
 *
 *   delete:
 *     summary: Delete a task
 *     description: Delete a task by ID
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: taskId
 *         required: true
 *         schema:
 *           type: string
 *         description: Task ID
 *     responses:
 *       204:
 *         description: Task deleted successfully
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 *       404:
 *         description: Task not found
 */

/**
 * @swagger
 * /tasks/{taskId}/assign/{userId}:
 *   patch:
 *     summary: Assign a user to a task
 *     description: Assign a user as the assignee of a task
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: taskId
 *         required: true
 *         schema:
 *           type: string
 *         description: Task ID
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID to assign
 *     responses:
 *       200:
 *         description: Task assigned successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Task'
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden
 *       404:
 *         description: Task or user not found
 */

