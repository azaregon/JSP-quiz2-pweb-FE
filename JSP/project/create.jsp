<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Project</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/form.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <div class="modal">
        <div class="modal-content">
            <h2>Create New Project</h2>
            <p class="subtitle">Fill in the details to create a new project</p>

            <div id="errorMessage" class="error-box" style="display:none;"></div>
            <div id="successMessage" class="success-message" style="display:none;"></div>

            <form id="createProjectForm">
                <!-- Project Name -->
                <label for="name">Project Name *</label>
                <input id="name" name="name" type="text" placeholder="Enter project name" required />

                <!-- Status -->
                <label for="status">Status *</label>
                <select id="status" name="status" required>
                    <option value="" disabled selected>Select project status</option>
                </select>

                <!-- Dates -->
                <div class="row">
                    <div class="col">
                        <label for="start_date">Start Date *</label>
                        <input id="start_date" name="start_date" type="date" required />
                    </div>
                    <div class="col">
                        <label for="end_date">End Date *</label>
                        <input id="end_date" name="end_date" type="date" required />
                    </div>
                </div>

                <!-- Description -->
                <label for="description">Description *</label>
                <textarea id="description" name="description" placeholder="Write the description of your project" required></textarea>

                <!-- Links and Technologies -->
                <div class="row">
                    <div class="col">
                        <label for="links">Project link</label>
                        <div class="inline-input">
                            <input id="links" name="links[]" type="text" placeholder="Live Web" />
                            <button type="button" class="add-btn" onclick="addLinkInput()">+</button>
                        </div>
                    </div>

                    <div class="col">
                        <label for="technologies">Technology</label>
                        <div class="inline-input">
                            <select id="technologies" name="technologies[]">
                                <option value="" disabled selected>Select Tech</option>
                            </select>
                            <button type="button" class="add-btn" onclick="addTechSelect()">+</button>
                        </div>
                    </div>
                </div>

                <!-- Collaborators -->
                <label for="collaborators">Collaborator</label>
                <div class="inline-input">
                    <input id="collaborators" name="collaborators[]" type="text" placeholder="Enter Collaborator" />
                    <button type="button" class="add-btn" onclick="addCollaborator()">+</button>
                </div>

                <!-- Buttons -->
                <div class="actions">
                    <a href="projects.jsp" class="cancel-btn">Cancel</a>
                    <button type="submit" class="create-btn" id="submitBtn">Create Project</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        // Check authentication
        if (!TokenAPI.isAuthenticated()) {
            window.location.href = 'login.jsp';
            return;
        }

        // Load statuses and technologies
        loadFormData();

        // Form submission
        $('#createProjectForm').on('submit', async function(e) {
            e.preventDefault();
            await submitProject();
        });
    });

    async function loadFormData() {
        try {
            // Load statuses - adjust endpoint sesuai dengan backend
            const statusResponse = await apiRequest('/project/statuses', 'GET');
            if (statusResponse.success && statusResponse.data) {
                const statuses = Array.isArray(statusResponse.data) ? statusResponse.data : [statusResponse.data];
                const statusSelect = document.getElementById('status');
                statuses.forEach(status => {
                    const option = document.createElement('option');
                    option.value = status.ID || status.id;
                    option.textContent = status.status_name || status.name;
                    statusSelect.appendChild(option);
                });
            }

            // Load technologies - adjust endpoint sesuai dengan backend
            const techResponse = await apiRequest('/project/technologies', 'GET');
            if (techResponse.success && techResponse.data) {
                const techs = Array.isArray(techResponse.data) ? techResponse.data : [techResponse.data];
                const techSelect = document.getElementById('technologies');
                techs.forEach(tech => {
                    const option = document.createElement('option');
                    option.value = tech.ID || tech.id;
                    option.textContent = tech.tech_name || tech.name;
                    techSelect.appendChild(option);
                });
            }
        } catch (error) {
            console.error('Error loading form data:', error);
            // Continue anyway - user can still try to submit
        }
    }

    async function submitProject() {
        const $form = $('#createProjectForm');
        const $errorMsg = $('#errorMessage');
        const $successMsg = $('#successMessage');
        const $submitBtn = $('#submitBtn');

        // Collect form data
        const projectData = {
            name: $('#name').val().trim(),
            status: $('#status').val(),
            start_date: $('#start_date').val(),
            end_date: $('#end_date').val(),
            description: $('#description').val().trim(),
            project_links: $('input[name="links[]"]').map(function() {
                return $(this).val().trim();
            }).get().filter(v => v),
            technologies: $('select[name="technologies[]"]').map(function() {
                return $(this).val();
            }).get().filter(v => v),
            collaborators: $('input[name="collaborators[]"]').map(function() {
                return $(this).val().trim();
            }).get().filter(v => v)
        };

        // Validation
        const errors = Validation.validateProjectForm(projectData);
        if (errors.length > 0) {
            $errorMsg.html(`<strong>Validation Error:</strong><ul><li>${errors.join('</li><li>')}</li></ul>`).show();
            return;
        }

        // Show loading
        $submitBtn.prop('disabled', true).text('Creating...');

        try {
            const response = await ProjectAPI.create(projectData);
            
            if (response.success) {
                $successMsg.text('Project created successfully!').show();
                setTimeout(() => {
                    window.location.href = 'projects.jsp';
                }, 1500);
            } else {
                $errorMsg.html(`<strong>Error:</strong> ${response.error_message || 'Failed to create project'}`).show();
            }
        } catch (error) {
            console.error('Error creating project:', error);
            $errorMsg.html(`<strong>Error:</strong> ${error.message || 'An error occurred while creating the project'}`).show();
        } finally {
            $submitBtn.prop('disabled', false).text('Create Project');
        }
    }

    function addLinkInput() {
        const div = document.createElement('div');
        div.classList.add('inline-input');
        div.innerHTML = `
            <input name="links[]" type="text" placeholder="Live Web" />
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.querySelector('#links').parentNode.parentNode.appendChild(div);
    }

    function addTechSelect() {
        const div = document.createElement('div');
        div.classList.add('inline-input');
        const techSelect = document.getElementById('technologies');
        
        div.innerHTML = `
            <select name="technologies[]">
                <option value="" disabled selected>Select Tech</option>
                ${techSelect.innerHTML}
            </select>
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.querySelector('#technologies').parentNode.parentNode.appendChild(div);
    }

    function addCollaborator() {
        const div = document.createElement('div');
        div.classList.add('inline-input');
        div.innerHTML = `
            <input name="collaborators[]" type="text" placeholder="Enter Collaborator" />
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.querySelector('#collaborators').parentNode.parentNode.appendChild(div);
    }
    </script>
</body>
</html>
