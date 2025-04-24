const express = require('express');
const auth = require('../../middlewares/auth');
const validate = require('../../middlewares/validate');
const workspaceValidation = require('../../validations/workspace.validation');
const workspaceController = require('../../controllers/workspace.controller');

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Workspaces
 *   description: Workspace management and retrieval
 */

/**
 * @swagger
 * /workspaces:
 *   post:
 *     summary: Create a workspace
 *     description: Only admins can create workspaces.
 *     tags: [Workspaces]
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
 *             properties:
 *               name:
 *                 type: string
 *                 maxLength: 100
 *               description:
 *                 type: string
 *               is_public:
 *                 type: boolean
 *               members:
 *                 type: array
 *                 items:
 *                   type: string
 *                   description: User ID
 *             example:
 *               name: Workspace Demo
 *               description: Example workspace
 *               is_public: false
 *               members: []
 *     responses:
 *       "201":
 *         description: Created
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Workspace'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *
 *   get:
 *     summary: Get all workspaces
 *     description: Only admins can retrieve all workspaces.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: name
 *         schema:
 *           type: string
 *         description: Workspace name
 *       - in: query
 *         name: is_public
 *         schema:
 *           type: boolean
 *         description: Is workspace public
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *         description: sort by query in the form of field:desc/asc (ex. name:asc)
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *         default: 10
 *         description: Maximum number of workspaces
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 results:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Workspace'
 *                 page:
 *                   type: integer
 *                   example: 1
 *                 limit:
 *                   type: integer
 *                   example: 10
 *                 totalPages:
 *                   type: integer
 *                   example: 1
 *                 totalResults:
 *                   type: integer
 *                   example: 1
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 */

/**
 * @swagger
 * /workspaces/{id}:
 *   get:
 *     summary: Get a workspace
 *     description: Logged in users can fetch workspaces they have access to. Only admins can fetch all workspaces.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Workspace id
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Workspace'
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a workspace
 *     description: Only admins can update workspaces.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Workspace id
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 maxLength: 100
 *               description:
 *                 type: string
 *               is_public:
 *                 type: boolean
 *               members:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Workspace'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a workspace
 *     description: Only admins can delete workspaces.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Workspace id
 *     responses:
 *       "204":
 *         description: No content
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */

/**
 * @swagger
 * /workspaces/{workspaceId}/members/{userId}:
 *   post:
 *     summary: Add a member to workspace
 *     description: Only admins can add members to a workspace.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: workspaceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Workspace id
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: User id
 *     responses:
 *       "200":
 *         description: Member added
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Workspace'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *   delete:
 *     summary: Remove a member from workspace
 *     description: Only admins can remove members from a workspace.
 *     tags: [Workspaces]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: workspaceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Workspace id
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: User id
 *     responses:
 *       "200":
 *         description: Member removed
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Workspace'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */

// Main workspace routes
router
    .route('/')
    .post(
        auth('manageWorkspaces'),
        validate(workspaceValidation.createWorkspace),
        workspaceController.createWorkspace
    )
    .get(
        auth('getWorkspaces'),
        validate(workspaceValidation.getWorkspaces),
        workspaceController.getWorkspaces
    );

router
    .route('/:workspaceId')
    .get(
        auth('getWorkspaces'),
        validate(workspaceValidation.getWorkspace),
        workspaceController.getWorkspace
    )
    .patch(
        auth('manageWorkspaces'),
        validate(workspaceValidation.updateWorkspace),
        workspaceController.updateWorkspace
    )
    .delete(
        auth('manageWorkspaces'),
        validate(workspaceValidation.deleteWorkspace),
        workspaceController.deleteWorkspace
    );

// Member management
router
    .route('/:workspaceId/members/:userId')
    .post(
        auth('manageWorkspaces'),
        validate(workspaceValidation.modifyMember),
        workspaceController.addMember
    )
    .delete(
        auth('manageWorkspaces'),
        validate(workspaceValidation.modifyMember),
        workspaceController.removeMember
    );

module.exports = router;

/**
 * @swagger
 * components:
 *   schemas:
 *     Workspace:
 *       type: object
 *       properties:
 *         _id:
 *           type: string
 *           description: Workspace ID
 *         name:
 *           type: string
 *         description:
 *           type: string
 *         is_public:
 *           type: boolean
 *         members:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/User'
 *         created_at:
 *           type: string
 *           format: date-time
 *         updated_at:
 *           type: string
 *           format: date-time
 *       example:
 *         _id: 661e2b3f1a2b3c4d5e6f7890
 *         name: Workspace Demo
 *         description: Example workspace
 *         is_public: false
 *         members:
 *           - _id: 661e2b3f1a2b3c4d5e6f7891
 *             name: Alice
 *             email: alice@example.com
 *         created_at: 2025-04-24T02:35:00.000Z
 *         updated_at: 2025-04-24T02:35:00.000Z
 */
