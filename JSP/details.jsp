<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Details</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <style>
        body {
            font-family: "Zen Kaku Gothic Antique", sans-serif;
            background-image: url("../images/Desktop\ -\ 1.svg");
            background-size: cover;
            background-position: center;
            color: #fff;
            margin: 0;
            padding: 0;
        }

        header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 40px;
            background: rgba(0, 0, 0, 0.5);
        }

        .logo {
            width: 40px;
            height: 40px;
            cursor: pointer;
        }

        .status {
            width: 40px;
            height: 40px;
        }

        main {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 40px;
        }

        .project-tab {
            background: rgba(77, 92, 0, 0.7);
            border-radius: 20px;
            padding: 40px;
            color: #fff;
        }

        .project-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .project-name-time {
            flex: 1;
        }

        .project-name-time h1 {
            margin: 0 0 15px 0;
            font-size: 2.5rem;
        }

        .project-times-details {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #d0d0d0;
        }

        .project-times-details img {
            width: 20px;
            height: 20px;
        }

        .dates {
            margin: 0;
            padding: 0;
        }

        .week-text {
            margin: 0;
            padding: 0;
        }

        .project-tab-buttons {
            display: flex;
            gap: 10px;
        }

        .edit-btn, .delete-btn {
            background: transparent;
            border: 1px solid #d5ff01;
            padding: 10px;
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .edit-btn:hover {
            background: #d5ff01;
            transform: scale(1.1);
        }

        .delete-btn:hover {
            background: #ff6b6b;
            border-color: #ff6b6b;
            transform: scale(1.1);
        }

        .project-description {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 30px;
            color: #d0d0d0;
        }

        .info-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .technologies, .collaborator {
            margin-bottom: 20px;
        }

        .technologies h4, .collaborator h4 {
            margin: 0 0 15px 0;
            font-size: 1.2rem;
        }

        .tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .tags span {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid #d5ff01;
            font-size: 0.95rem;
        }

        .link-section {
            margin-bottom: 30px;
        }

        .link-btn {
            background-color: #d5ff01;
            color: #000;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .link-btn:hover:not(:disabled) {
            box-shadow: 0 2px 8px rgba(213, 255, 1, 0.4);
        }

        .link-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .link-btn img {
            width: 20px;
            height: 20px;
        }

        .add-comment-section {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 2px solid rgba(255, 255, 255, 0.2);
        }

        .add-comment-section h4 {
            margin: 0 0 15px 0;
        }

        .comment-input {
            width: 100%;
            min-height: 100px;
            padding: 10px;
            background-color: #373A27;
            border: 1px solid #fdfdfdb5;
            border-radius: 8px;
            color: #fff;
            font-family: "Zen Kaku Gothic Antique", sans-serif;
            margin-bottom: 10px;
            resize: vertical;
        }

        .post-comment-btn {
            background-color: #4D5C00;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .post-comment-btn:hover {
            background-color: #a6c700;
            box-shadow: 0 0 10px rgba(87, 113, 1, 0.4);
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #d5ff01;
            text-decoration: none;
            transition: color 0.3s;
        }

        .back-link:hover {
            color: #fff;
        }

        .loading-spinner {
            text-align: center;
            padding: 40px;
            color: #d0d0d0;
        }

        .error-message {
            background-color: rgba(255, 107, 107, 0.2);
            border: 1px solid #ff6b6b;
            border-radius: 8px;
            padding: 15px;
            color: #ff6b6b;
            margin-bottom: 20px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <header>  
        <a href="javascript:history.back()" class="back-link">
            <img class="logo" src="${pageContext.request.contextPath}/images/Group\ 32.svg" alt="Logo">
        </a> 
        <img src="${pageContext.request.contextPath}/images/Status\ Done.svg" alt="Status Icon" class="status">
    </header>

    <main>
        <div id="loadingSpinner" class="loading-spinner">Loading project details...</div>
        <div id="errorMessage" class="error-message" style="display:none;"></div>
        <div id="projectContent" style="display:none;"></div>
    </main>

    <script>
    $(document).ready(function() {
        // Check authentication
        if (!TokenAPI.isAuthenticated()) {
            window.location.href = 'login.jsp';
            return;
        }

        // Get project ID from URL
        const urlParams = new URLSearchParams(window.location.search);
        const projectId = urlParams.get('id');
        console.log(projectId);
        
        
        if (!projectId) {
            $('#loadingSpinner').hide();
            $('#errorMessage').text('Project ID not found').show();
            return;
        }
        loadProjectDetails(projectId);

    });

    async function loadProjectDetails(projectId) {
        const $loadingSpinner = $('#loadingSpinner');
        const $errorMessage = $('#errorMessage');
        const $projectContent = $('#projectContent');

        try {
            console.log("askdlkajdlkasdjalkdjlkj")
            const response = await ProjectAPI.getById(projectId);
            if (response.success && response.data) {
                const project = response.data;
                const html = renderProjectDetails(project);
                $projectContent.html(html).show();
                $loadingSpinner.hide();
            } else {
                throw new Error(response.error_message || 'Failed to load project');
            }
        } catch (error) {
            console.error('Error loading project:', error);
            $loadingSpinner.hide();
            $errorMessage.text(`Error: ${error.message}`).show();
        }
    }

    function renderProjectDetails(project) {
        const contextPath = "${pageContext.request.contextPath}";

        const startDate = UIUtils.formatDate(project.project_start || project.start_date);
        const endDate = UIUtils.formatDate(project.project_date || project.end_date);
        const technologies = project.technologies || project.project_tech_stacks || [];
        const collaborators = project.collaborators || [];
        const projectLink = project.project_links || project.link || '';

        // Build technologies HTML separately to avoid JSP EL conflicts
        const technologiesHtml = technologies.length > 0
            ? technologies.map(tech => `<span>${escapeHtml(tech.tech_name || tech)}</span>`).join('')
            : '<span>No tech listed</span>';

        // Build collaborators HTML separately
        const collaboratorsHtml = collaborators.length > 0
            ? collaborators.map(col => `<span>${escapeHtml(col.user_name || col)}</span>`).join('')
            : '<span>None</span>';

        let html = `
            <div class="project-tab">
                <div class="project-header">
                    <div class="project-name-time">
                        <h1>\${escapeHtml(project.project_name || project.name)}</h1>
                        <div class="project-times-details">
                            <img src="\${contextPath}/images/Vector\ Calendar.svg" alt="Calendar Icon" class="calendar-icon">
                            <p class="dates">\${escapeHtml(startDate)} -</p>
                            <img src="\${contextPath}/images/Vector\ Time.svg" alt="Time Icon" class="time-icon">
                            <p class="week-text">\${escapeHtml(endDate)}</p>
                        </div>
                    </div>
                    <div class="project-tab-buttons">
                        <button class="edit-btn" onclick="editProject(\${project.ID || project.id})">
                            <img src="\${contextPath}/images/Vector\ edit.svg" alt="Edit">
                        </button>
                        <button class="delete-btn" onclick="deleteProject(\${project.ID || project.id})">
                            <img src="\${contextPath}/images/Vector\ delete.svg" alt="Delete">
                        </button>
                    </div>
                </div>

                <p class="project-description">
                    \${escapeHtml(project.project_desc || project.description || 'No description')}
                </p>

                <div class="info-section">
                    <div class="technologies">
                        <h4>Technologies</h4>
                        <div class="tags">
                            \${technologiesHtml}
                        </div>
                    </div>
                    <div class="collaborator">
                        <span style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                            <img src="\${contextPath}/images/Icon.svg" alt="Collaborator Icon" style="width: 20px;">
                            <h4 style="margin: 0;">Collaborator</h4>
                        </span>
                        <div class="tags">\${collaboratorsHtml}</div>
                    </div>
                </div>

                <div class="link-section">
                    \${(projectLink && (projectLink.website || projectLink.github))
                        ? `<a href="\${escapeHtml(projectLink.website || projectLink.github)}" target="_blank" class="link-btn">
                                <img src="\${contextPath}/images/Vector Link copy.svg" alt="Link">
                                Link
                           </a>`
                        : `<button class="link-btn" disabled>
                                <img src="\${contextPath}/images/Vector Link copy.svg" alt="Link">
                                No Link
                           </button>`
                    }
                </div>

                <hr>
            </div>
        `;

        return html;
    }

    function editProject(projectId) {
        // TODO: Implement edit functionality
        window.location.href = `edit.jsp?id=${projectId}`;
    }

    async function deleteProject(projectId) {
        if (!confirm('Are you sure you want to delete this project?')) {
            return;
        }

        try {
            const response = await ProjectAPI.delete(projectId);
            if (response.success) {
                alert('Project deleted successfully');
                window.location.href = 'projects.jsp';
            } else {
                alert('Error deleting project: ' + (response.error_message || 'Unknown error'));
            }
        } catch (error) {
            alert('Error: ' + error.message);
        }
    }

    const UIUtils = {
        formatDate: function(dateString) {
            if (!dateString) return 'N/A';
            try {
                const date = new Date(dateString);
                // Format to something like: Jan 1, 2024
                return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
            } catch (e) {
                return dateString; // Return original string if parsing fails
            }
        }
    };

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    </script>
</body>
</html>
