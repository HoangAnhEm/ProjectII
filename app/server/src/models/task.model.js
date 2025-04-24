// models/task.model.js
const mongoose = require('mongoose');
const { toJSON, paginate } = require('./plugins');

const taskSchema = mongoose.Schema(
    {
        project_id: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Project',
            required: true,
        },
        name: {
            type: String,
            required: true,
            trim: true,
            maxlength: 255,
        },
        description: {
            type: String,
            trim: true,
        },
        status: {
            type: String,
            enum: ['to_do', 'in_progress', 'in_review', 'done'],
            default: 'to_do',
        },
        priority: {
            type: String,
            enum: ['low', 'medium', 'high', 'urgent'],
            default: 'medium',
        },
        due_date: {
            type: Date,
        },
        estimated_hours: {
            type: Number,
            min: 0,
        },
        actual_hours: {
            type: Number,
            default: 0,
            min: 0,
        },
        assignee_id: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
        },
        created_by: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,
        },
    },
    {
        timestamps: {
            createdAt: 'created_at',
            updatedAt: 'updated_at',
        },
    }
);

// Check if task name is taken within the same project
taskSchema.statics.isNameTakenInProject = async function (name, projectId, excludeTaskId) {
    const task = await this.findOne({
        name,
        project_id: projectId,
        _id: { $ne: excludeTaskId },
    });
    return !!task;
};

taskSchema.plugin(toJSON);
taskSchema.plugin(paginate);

const Task = mongoose.model('Task', taskSchema);
module.exports = Task;
