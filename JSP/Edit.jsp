<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Existing Project</title>

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
            <h2>Edit Existing Project</h2>
            <p class="subtitle">Fill in the details to edit a existing project</p>

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
                            <div id="link-inputs">
                                <input name="link_key" type="text" placeholder="e.g., github" />
                                <input name="link_value" type="text" placeholder="https://..." />
                                <button type="button" class="add-btn" onclick="addLinkInput()">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <label for="technologies">Technology</label>
                        <div class="inline-input">
                            <div id="tech-inputs">
                                <select name="technologies[]">
                                    <option value="" disabled selected>Select Tech</option>
                                </select>
                                <button type="button" class="add-btn" onclick="addTechSelect()">+</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Collaborators -->
                <label for="collaborators">Collaborator</label>
                <div class="inline-input">
                    <div id="collaborator-inputs">
                        <input name="collaborators[]" type="text" placeholder="Enter Collaborator" />
                    </div>
                    <button type="button" class="add-btn" onclick="addCollaborator()">+</button>
                </div>

                <!-- Buttons -->
                <div class="actions">
                    <a href="/akusigmak/JSP/projects.jsp" class="cancel-btn">Cancel</a>
                    <button type="submit" class="create-btn" id="submitBtn">Edit Project</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    let currentProjectId = null; // Store the project ID being edited

    $(document).ready(function() {
        // Check authentication
        if (!TokenAPI.isAuthenticated()) {
            window.location.href = '/akusigmak/JSP/login.jsp';
            return;
        }

        // Get project ID from URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        currentProjectId = urlParams.get('id');

        // Load statuses and technologies first, then load project data if ID exists
        loadFormData().then(() => {
            if (currentProjectId) {
                loadProjectData(currentProjectId);
            }
        });

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
                const techSelect = document.querySelector('#tech-inputs select');
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

    // NEW: Load project data when editing
    async function loadProjectData(projectId) {
        try {
            const response = await ProjectAPI.getById(projectId);
            if (response.success && response.data) {
                populateEditForm(response.data);
            } else {
                console.error('Failed to load project:', response.error_message);
            }
        } catch (error) {
            console.error('Error loading project:', error);
        }
    }

    // NEW: Populate form with project data
    function populateEditForm(project) {
        // Set basic fields
        $('#name').val(project.project_name || project.name || '');
        $('#status').val(project.PROJECT_STATUS_ID || project.status_id || '');
        $('#description').val(project.project_desc || project.description || '');
        
        // Set dates - convert to YYYY-MM-DD format if needed
        const startDate = formatDateForInput(project.project_start || project.start_date);
        const endDate = formatDateForInput(project.project_date || project.end_date);
        $('#start_date').val(startDate);
        $('#end_date').val(endDate);

        // Populate project links
        const projectLinks = project.project_links || project.links || {};
        const linkInputsContainer = document.getElementById('link-inputs');
        
        // Clear existing link inputs (except the template)
        linkInputsContainer.querySelectorAll('.link-pair').forEach(el => el.remove());
        
        // Populate first link
        const linkKeys = Object.keys(projectLinks);
        if (linkKeys.length > 0) {
            const firstKey = linkKeys[0];
            linkInputsContainer.querySelector('input[name="link_key"]').value = firstKey;
            linkInputsContainer.querySelector('input[name="link_value"]').value = projectLinks[firstKey];
            
            // Add additional links
            for (let i = 1; i < linkKeys.length; i++) {
                const div = document.createElement('div');
                div.classList.add('inline-input', 'link-pair');
                div.innerHTML = `
                    <input name="link_key" type="text" placeholder="e.g., website" value="${linkKeys[i]}" />
                    <input name="link_value" type="text" placeholder="https://..." value="${projectLinks[linkKeys[i]]}" />
                    <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
                `;
                linkInputsContainer.appendChild(div);
            }
        }

        // Populate technologies
        const technologies = project.technologies || project.project_tech_stacks || [];
        const techInputsContainer = document.getElementById('tech-inputs');
        const firstTechSelect = techInputsContainer.querySelector('select[name="technologies[]"]');
        
        // Clear existing tech selects (except the template)
        techInputsContainer.querySelectorAll('.inline-input').forEach(el => el.remove());
        
        if (technologies.length > 0) {
            // Set first technology
            const firstTechId = technologies[0].ID || technologies[0].id;
            firstTechSelect.value = firstTechId;
            
            // Add additional technologies
            for (let i = 1; i < technologies.length; i++) {
                const div = document.createElement('div');
                div.classList.add('inline-input');
                const techId = technologies[i].ID || technologies[i].id;
                const techName = technologies[i].tech_name || technologies[i].name;
                
                div.innerHTML = `
                    <select name="technologies[]">
                        ${firstTechSelect.innerHTML.replace('<option value="" disabled="" selected="">Select Tech</option>', '')}
                    </select>
                    <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
                `;
                const newSelect = div.querySelector('select');
                newSelect.value = techId;
                techInputsContainer.appendChild(div);
            }
        }

        // Populate collaborators
        const collaborators = project.collaborators || [];
        const collabContainer = document.getElementById('collaborator-inputs');
        
        // Clear existing collaborator inputs (except the template)
        collabContainer.querySelectorAll('.collaborator-item').forEach(el => el.remove());
        
        if (collaborators.length > 0) {
            // Set first collaborator
            collabContainer.querySelector('input[name="collaborators[]"]').value = collaborators[0].user_name || collaborators[0];
            
            // Add additional collaborators
            for (let i = 1; i < collaborators.length; i++) {
                const collabName = collaborators[i].user_name || collaborators[i];
                const div = document.createElement('div');
                div.classList.add('collaborator-item');
                div.innerHTML = `
                    <input name="collaborators[]" type="text" placeholder="Enter Collaborator" value="${collabName}" />
                    <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
                `;
                collabContainer.appendChild(div);
            }
        }

        // Update button text
        $('#submitBtn').text('Update Project');
    }

    // Helper function to format date for input[type="date"]
    function formatDateForInput(dateString) {
        if (!dateString) return '';
        try {
            const date = new Date(dateString);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        } catch (e) {
            return dateString;
        }
    }

    async function submitProject() {
        const $form = $('#createProjectForm');
        const $errorMsg = $('#errorMessage');
        const $successMsg = $('#successMessage');
        const $submitBtn = $('#submitBtn');

        // Hide previous messages
        $errorMsg.hide();
        $successMsg.hide();

        // Collect form data
        const projectLinks = {};
        // Handle the initial, non-dynamic link input
        const initialLinkKey = $('#link-inputs input[name="link_key"]').first().val().trim();
        const initialLinkValue = $('#link-inputs input[name="link_value"]').first().val().trim();
        if (initialLinkKey && initialLinkValue) {
            projectLinks[initialLinkKey] = initialLinkValue;
        }
        // Handle dynamically added link inputs
        $('#link-inputs .link-pair').each(function() {
            const key = $(this).find('input[name="link_key"]').val().trim();
            const value = $(this).find('input[name="link_value"]').val().trim();
            if (key && value) {
                projectLinks[key] = value;
            }
        });

        const projectData = {
            USER_ID_PM: localStorage.getItem('user_id'),
            PROJECT_STATUS_ID: parseInt($('#status').val(), 10) || null,
            project_name: $('#name').val().trim(),
            project_desc: $('#description').val().trim(),
            project_start: $('#start_date').val(),
            project_date: $('#end_date').val(),
            project_links: projectLinks,
            project_milestone: {}, // Form doesn't have this, sending empty object
            technologies: $('select[name="technologies[]"]').map((_, el) => parseInt($(el).val(), 10)).get().filter(v => !isNaN(v)),
            collaborators: $('input[name="collaborators[]"]').map((_, el) => $(el).val().trim()).get().filter(v => v)
        };

        // Validation
        // const errors = Validation.validateProjectForm(projectData);
        // if (errors.length > 0) {
        //     $errorMsg.html(`<strong>Validation Error:</strong><ul><li>${errors.join('</li><li>')}</li></ul>`).show();
        //     return;
        // }

        // Show loading
        $submitBtn.prop('disabled', true).text('Creating...');

        try {
            // MODIFIED: Use PUT if editing, POST if creating
            let response;
            if (currentProjectId) {
                // Update existing project
                $submitBtn.text('Updating...');
                response = await ProjectAPI.update(currentProjectId, projectData);
                
                if (response.success) {
                    $successMsg.text('Project updated successfully!').show();
                    setTimeout(() => {
                        window.location.href = `/akusigmak/JSP/details.jsp?id=${currentProjectId}`;
                    }, 1500);
                } else {
                    $errorMsg.html(`<strong>Error:</strong> ${response.error_message || 'Failed to update project'}`).show();
                }
            } else {
                // Create new project
                response = await ProjectAPI.create(projectData);
                
                if (response.success) {
                    $successMsg.text('Project created successfully!').show();
                    setTimeout(() => {
                        window.location.href = '/akusigmak/JSP/projects.jsp';
                    }, 1500);
                } else {
                    $errorMsg.html(`<strong>Error:</strong> ${response.error_message || 'Failed to create project'}`).show();
                }
            }
        } catch (error) {
            console.error('Error submitting project:', error);
            $errorMsg.html(`<strong>Error:</strong> ${error.message || 'An error occurred'}`).show();
        } finally {
            $submitBtn.prop('disabled', false).text(currentProjectId ? 'Update Project' : 'Create Project');
        }
    }

    function addLinkInput() {
        const div = document.createElement('div');
        div.classList.add('inline-input', 'link-pair');
        div.innerHTML = `
            <input name="link_key" type="text" placeholder="e.g., website" />
            <input name="link_value" type="text" placeholder="https://..." />
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.getElementById('link-inputs').appendChild(div);
    }

    function addTechSelect() {
        const div = document.createElement('div');
        div.classList.add('inline-input');
        const techSelect = document.querySelector('#tech-inputs select');
        
        div.innerHTML = `
            <select name="technologies[]">
                <option value="" disabled selected>Select Tech</option>
                ${techSelect.innerHTML.replace('<option value="" disabled="" selected="">Select Tech</option>', '')}
            </select>
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.getElementById('tech-inputs').appendChild(div);
    }

    function addCollaborator() {
        const div = document.createElement('div');
        div.classList.add('collaborator-item');
        div.innerHTML = `
            <input name="collaborators[]" type="text" placeholder="Enter Collaborator" />
            <button type="button" class="add-btn" onclick="this.parentNode.remove()">−</button>
        `;
        document.getElementById('collaborator-inputs').appendChild(div);
    }
    </script>
</body>
</html>
