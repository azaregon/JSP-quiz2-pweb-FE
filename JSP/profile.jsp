<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/ListPage.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px;
        }

        .profile-header {
            background: rgba(77, 92, 0, 0.5);
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 40px;
            text-align: center;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: #d5ff01;
            color: #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            font-weight: bold;
            margin: 0 auto 20px;
        }

        .profile-header h1 {
            margin: 0;
            font-size: 2rem;
        }

        .profile-header p {
            color: #d0d0d0;
            margin: 10px 0 0 0;
        }

        .profile-projects-container {
            font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial;
            color: #fff;
        }

        .projects-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .projects-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }

        .projects-header p {
            margin: 0;
            color: #d0d0d0;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .project-card {
            background: rgba(77, 92, 0, 0.5);
            border: 1px solid rgba(213, 255, 1, 0.3);
            border-radius: 15px;
            padding: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .project-card:hover {
            border-color: #d5ff01;
            box-shadow: 0 4px 15px rgba(213, 255, 1, 0.2);
            transform: translateY(-5px);
        }

        .project-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 10px;
        }

        .project-card h3 {
            margin: 0;
            font-size: 1.1rem;
            flex: 1;
        }

        .project-status {
            display: inline-block;
            padding: 4px 12px;
            font-size: 0.75rem;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.1);
            color: #d5ff01;
            white-space: nowrap;
        }

        .project-card p {
            margin: 0 0 15px 0;
            color: #d0d0d0;
            font-size: 0.9rem;
        }

        .project-tech {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }

        .tech-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .tech-color {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
        }

        .project-collabs {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .collab-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #d5ff01;
            color: #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .view-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 16px;
            background-color: #d5ff01;
            color: #000;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .view-btn:hover {
            box-shadow: 0 2px 8px rgba(213, 255, 1, 0.4);
        }

        .no-projects {
            text-align: center;
            padding: 40px;
            color: #d0d0d0;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <header>
        <div class="top-bar">
            <div class="profile-icon">
                <a href="profile.jsp">
                    <img src="${pageContext.request.contextPath}/images/Profile\ Buttons.svg" alt="Profile Icon">
                </a>
            </div>

            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Search project">
                <button id="searchBtn" type="button" class="btn-primary">
                    <img src="${pageContext.request.contextPath}/images/Oval.svg" alt="Search Icon" class="search-icon">
                </button>
            </div>

            <div class="auth-buttons" id="authButtons">
                <!-- Will be populated by JavaScript -->
            </div>
        </div>

        <div class="header-content">
            <h1>My Profile</h1>
            <p>View and manage your projects</p>
        </div>
    </header>

    <main>
        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar" id="profileAvatar">U</div>
                <h1 id="profileName">User Name</h1>
                <p id="profileUsername">@username</p>
            </div>

            <div class="profile-projects-container">
                <div class="projects-header">
                    <div>
                        <h2>My Projects</h2>
                        <p id="projectCount">Loading...</p>
                    </div>
                </div>

                <div id="projectsGrid" class="grid">
                    <div class="loading-spinner"></div>
                </div>
            </div>
        </div>
    </main>

    <script>
    $(document).ready(function() {
        if (!TokenAPI.isAuthenticated()) {
            window.location.href = '/akusigmak/JSP/login.jsp';
            return;
        }

        loadProfile();
        setupAuthButtons();
    });

    function setupAuthButtons() {
        const $authButtons = $('#authButtons');
        $authButtons.html(`
            <a href="project/projects.jsp"><button class="sign-in">Back to Projects</button></a>
            <button type="button" class="register" id="logoutBtn">Logout</button>
        `);

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

    async function loadProfile() {
        try {
            // Load user profile
            const userResponse = await AuthAPI.getProfile();
            if (userResponse.success && userResponse.data) {
                const user = userResponse.data;
                updateProfileUI(user);
            }

            // Load projects
            const projectsResponse = await ProjectAPI.getAll();
            if (projectsResponse.success && projectsResponse.data) {
                const projects = Array.isArray(projectsResponse.data) ? projectsResponse.data : [projectsResponse.data];
                displayProjects(projects);
            }
        } catch (error) {
            console.error('Error loading profile:', error);
            $('#projectsGrid').html(`<p class="no-projects">Error loading projects: ${error.message}</p>`);
        }
    }

    function updateProfileUI(user) {
        const name = user.name || user.user_name || 'User';
        const initials = name.split(' ').map(n => n[0].toUpperCase()).join('').substring(0, 2);
        
        $('#profileName').text(name);
        $('#profileUsername').text('@' + (user.user_name || 'user'));
        $('#profileAvatar').text(initials);
        
        StorageAPI.setUser(user);
    }

    function displayProjects(projects) {
        const $grid = $('#projectsGrid');
        const $count = $('#projectCount');

        if (!projects || projects.length === 0) {
            $grid.html('<p class="no-projects" style="grid-column: 1/-1;">No projects yet. Create your first project!</p>');
            $count.text('0 projects');
            return;
        }

        $count.text(`Showing ${projects.length} project${projects.length !== 1 ? 's' : ''}`);

        let html = '';
        projects.forEach(project => {
            const technologies = project.technologies || [];
            const collaborators = project.collaborators || [];
            const projectLink = project.project_links || project.link || '';

            html += `
                <div class="project-card">
                    <div class="project-card-header">
                        <h3>${escapeHtml(project.project_name || project.name)}</h3>
                        <span class="project-status">${escapeHtml(project.status || 'Active')}</span>
                    </div>
                    <p>${escapeHtml(UIUtils.truncateText(project.project_desc || project.description, 80))}</p>

                    <div class="project-tech">
                        ${technologies.length > 0 ?
                            technologies.map(tech => {
                                const color = tech.tech_color || '#d5ff01';
                                return `
                                    <div class="tech-badge">
                                        <span class="tech-color" style="background-color: ${color};"></span>
                                        <span>${escapeHtml(tech.tech_name || tech)}</span>
                                    </div>
                                `;
                            }).join('') :
                            '<small style="color: #d0d0d0;">No tech stacks</small>'
                        }
                    </div>

                    <div class="project-collabs">
                        ${collaborators.length > 0 ?
                            collaborators.map(collab => {
                                const initials = (collab.user_name || 'U').substring(0, 2).toUpperCase();
                                return `<div class="collab-avatar" title="${escapeHtml(collab.user_name)}">${initials}</div>`;
                            }).join('') :
                            '<small style="color: #d0d0d0;">No collaborators</small>'
                        }
                    </div>

                    <a href="project/details.jsp?id=${project.ID || project.id}" class="view-btn">View Details</a>
                </div>
            `;
        });

        $grid.html(html);
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
