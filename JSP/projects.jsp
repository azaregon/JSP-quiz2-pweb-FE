<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Projects List</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/ListPage.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <header>
        <div class="top-bar">
            <div class="profile-icon">
                <a href="/akusigmak/JSP/profile.jsp">
                    <img src="${pageContext.request.contextPath}/images/Profile%20Buttons.svg" alt="Profile Icon">
                </a>
            </div>

            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Search project">
                <button id="searchBtn" type="button" class="btn-primary" style="cursor: pointer">
                    <img src="${pageContext.request.contextPath}/images/Oval.svg" alt="Search Icon" class="search-icon">
                </button>
            </div>

            <div class="auth-icon" id="authIcon" style="margin-left:1rem;">
                <!-- Will be populated by JavaScript -->
            </div>

            <div class="auth-buttons" id="authButtons">
                <!-- Will be populated by JavaScript -->
            </div>
        </div>

        <div class="header-content">
            <h1><span id="userName">Guest</span>'s Projects</h1>
            <p>Welcome to your project dashboard. Here you can see all your active, planned, and completed projects.</p>
        </div>
    </header>

    <main>
        <section class="projects" id="projectsList">
            <div class="loading-spinner" id="loadingSpinner"></div>
        </section>
    </main>

    <script>
    const contextPath = "${pageContext.request.contextPath}";

    $(document).ready(function() {
        // Check if user is authenticated
        if (!TokenAPI.isAuthenticated()) {
            window.location.href = '/akusigmak/JSP/login.jsp';
            return;
        }

        // Load projects
        loadProjects();
        setupUI();

        // Search functionality
        $('#searchBtn').on('click', function() {
            const query = $('#searchInput').val().trim();
            if (!query) {
                $('#searchInput').focus();
                return;
            }
            // TODO: Implement search functionality
            alert('Search untuk: ' + query);
        });

        $('#searchInput').on('keypress', function(e) {
            if (e.which === 13) {
                $('#searchBtn').click();
            }
        });
    });

    function setupUI() {
        const user = StorageAPI.getUser();
        const username = user ? user.user_name || user.name : 'Guest';
        
        $('#userName').text(username);

        // Setup auth buttons
        const $authIcon = $('#authIcon');
        const $authButtons = $('#authButtons');

        $authIcon.html(`
            <form action="#" method="GET" style="display:inline;">
                <button type="button" class="add-project-btn" id="addProjectBtn">
                    Add Project 
                    <img src="\${contextPath}/images/plus.svg" alt="Create Project Icon">
                </button>
            </form>
        `);

        $authButtons.html(`
            <button type="button" class="sign-in" id="logoutBtn">
                Logout
                <img src="\${contextPath}/images/logout.svg">
            </button>
        `);

        $('#addProjectBtn').on('click', function() {
            window.location.href = '/akusigmak/JSP/create.jsp';
        });

        $('#logoutBtn').on('click', async function() {
            try {
                await AuthAPI.logout();
            } catch (e) {
                console.log('Logout API call failed, clearing local storage anyway');
            }
            TokenAPI.removeToken();
            StorageAPI.clearUser();
            window.location.href = '/akusigmak/JSP/login.jsp';
        });
    }

    async function loadProjects() {
        const $projectsList = $('#projectsList');
        
        try {
            const userId = TokenAPI.getUserId();
            const response = await ProjectAPI.getAll(userId);
            
            if (response.success && response.data) {
                const projects = Array.isArray(response.data) ? response.data : [response.data];
                
                if (projects.length === 0) {
                    $projectsList.html('<p class="no-projects">No projects found. Create your first project!</p>');
                    return;
                }

                let html = '';
                projects.forEach(project => {
                    const statusClass = (project.status || 'ongoing').toLowerCase();
                    const technologies = project.technologies || [];
                    const projectLinks = project.project_links || {};
                    
                    html += `
                        <div class="card ${statusClass}">
                            <div class="card-content">
                                <h3>\${escapeHtml(project.project_name || project.name || 'Unnamed')}</h3>
                                <p>\${escapeHtml(truncateText(project.project_desc || project.description || '', 100))}</p>

                                <div class="tags">
                                    \${technologies.length > 0 ? 
                                        technologies.map(tech => `<span>\${escapeHtml(tech.tech_name || tech)}</span>`).join('') :
                                        ''
                                    }
                                </div>

                                <div class="card-actions">
                                    <div class="icons">
                                        \${Object.keys(projectLinks).map(key => {
                                            const link = projectLinks[key];
                                            if (link) {
                                                // You can add more specific icons based on the key (e.g., 'github', 'website')
                                                return `
                                                    <a href="\${escapeHtml(link)}" target="_blank" title="\${escapeHtml(key)}">
                                                        <img src="\${contextPath}/images/Vector\ link\ copy\ for\ list.svg" alt="\${escapeHtml(key)} link">
                                                    </a>
                                                `;
                                            }
                                            return '';
                                        }).join('')}
                                        \${''/* projectLink ? `
                                            <a href="\${escapeHtml(projectLink)}" target="_blank">
                                                <img src="\${pageContext.request.contextPath}/images/Vector\ link\ copy\ for\ list.svg" alt="Link">
                                            </a>
                                        ` : '' */}
                                    </div>
                                    <a href="details.jsp?id=\${project.ID || project.id}">
                                        <button class="details-btn">Details</button>
                                    </a>
                                </div>
                            </div>
                        </div>
                    `;
                });

                $projectsList.html(html);
            } else {
                $projectsList.html(`<p class="no-projects">${response.error_message || 'Failed to load projects'}</p>`);
            }
        } catch (error) {
            console.error('Error loading projects:', error);
            $projectsList.html(`<p class="no-projects">Error loading projects: ${error.message}</p>`);
        }
    }

    function truncateText(text, maxLength) {
        if (!text || text.length <= maxLength) return text;
        return text.substr(0, maxLength) + '...';
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    </script>
</body>
</html>
