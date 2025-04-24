const express = require('express');
const auth = require('../../middlewares/auth');
const validate = require('../../middlewares/validate');
const projectValidation = require('../../validations/project.validation');
const projectController = require('../../controllers/project.controller');

const router = express.Router();

// Routes project chính
router
    .route('/')
    .post(
        auth('manageProjects'),
        validate(projectValidation.createProject),
        projectController.createProject
    )
    .get(
        auth('getProjects'),
        validate(projectValidation.getProjects),
        projectController.getProjects
    );

router
    .route('/:projectId')
    .get(
        auth('getProjects'),
        validate(projectValidation.getProject),
        projectController.getProject
    )
    .patch(
        auth('manageProjects'),
        validate(projectValidation.updateProject),
        projectController.updateProject
    )
    .delete(
        auth('manageProjects'),
        validate(projectValidation.deleteProject),
        projectController.deleteProject
    );

// Route lấy projects theo workspace
router
    .route('/workspace/:workspaceId')
    .get(
        auth('getProjects'),
        validate(projectValidation.getProjectsByWorkspace),
        projectController.getProjectsByWorkspace
    );

// Routes quản lý thành viên
router
    .route('/:projectId/members/:userId')
    .post(
        auth('manageProjects'),
        validate(projectValidation.modifyMember),
        projectController.addMember
    )
    .delete(
        auth('manageProjects'),
        validate(projectValidation.modifyMember),
        projectController.removeMember
    );

module.exports = router;


/**
 * @swagger
 * components:
 *   schemas:
 *     Project:
 *       type: object
 *       required:
 *         - name
 *         - workspaceId
 *         - managerId
 *       properties:
 *         id:
 *           type: string
 *           description: Project ID
 *         name:
 *           type: string
 *           description: Project name
 *         description:
 *           type: string
 *           description: Project description
 *         startDate:
 *           type: string
 *           format: date
 *           description: Project start date
 *         endDate:
 *           type: string
 *           format: date
 *           description: Project end date
 *         status:
 *           type: string
 *           enum: [not_started, in_progress, on_hold, completed, cancelled]
 *           description: Project status
 *         managerId:
 *           type: string
 *           description: Project manager ID
 *         workspaceId:
 *           type: string
 *           description: ID of the workspace containing this project
 *         members:
 *           type: array
 *           items:
 *             type: string
 *           description: List of member IDs
 *         tasks:
 *           type: array
 *           items:
 *             type: string
 *           description: List of task IDs in this project
 *       example:
 *         id: 615a5c7c7d24a82c906a2321
 *         name: Website Development Project
 *         description: Develop a website using ReactJS and NodeJS
 *         startDate: 2025-01-01T00:00:00.000Z
 *         endDate: 2025-06-30T00:00:00.000Z
 *         status: in_progress
 *         managerId: 615a5c7c7d24a82c906a2320
 *         workspaceId: 615a5c7c7d24a82c906a2319
 *         members: [615a5c7c7d24a82c906a2320, 615a5c7c7d24a82c906a2318]
 *         tasks: [615a5c7c7d24a82c906a2333, 615a5c7c7d24a82c906a2334]
 */

