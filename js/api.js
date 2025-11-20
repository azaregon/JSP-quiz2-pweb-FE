/**
 * API Configuration dan Utility Functions
 * Menangani komunikasi dengan backend Python (Quiz-2-PWEB)
 */

const API_BASE_URL = 'http://localhost:5000'; // Sesuaikan dengan URL backend Python

/**
 * Generic API request function
 */
async function apiRequest(endpoint, method = 'GET', data = null) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json',
        }
    };

    // Tambahkan Authorization token jika ada
    const token = localStorage.getItem('auth_token');
    if (token) {
        options.headers['Authorization'] = `Bearer ${token}`;
    }

    if (data && (method === 'POST' || method === 'PUT' || method === 'PATCH')) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        
        if (!response.ok) {
            if (response.status === 401) {
                // Token expired or invalid - clear and redirect to login
                localStorage.clear();
                window.location.href = '/JSP/login.jsp';
            }
            const errorData = await response.json();
            throw new Error(errorData.error_message || `HTTP Error: ${response.status}`);
        }

        return await response.json();
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

/**
 * Authentication Functions
 */
const AuthAPI = {
    login: async (username, password) => {
        return apiRequest('/auth/login', 'POST', {
            user_name: username,
            password: password
        });
    },

    register: async (username, password, firstName, lastName) => {
        return apiRequest('/auth/register', 'POST', {
            user_name: username,
            password: password,
            first_name: firstName,
            last_name: lastName
        });
    },

    logout: async () => {
        return apiRequest('/auth/logout', 'POST');
    },

    getProfile: async () => {
        return apiRequest('/auth/me', 'GET');
    }
};

/**
 * Project Functions
 */
const ProjectAPI = {
    getAll: async (userId = null) => {
        const endpoint = userId ? `/project/all/${userId}` : '/project/all';
        return apiRequest(endpoint);
    },

    getById: async (projectId) => {
        return apiRequest(`/project/${projectId}`);
    },

    create: async (projectData) => {
        return apiRequest('/project/new', 'POST', projectData);
    },

    update: async (projectId, projectData) => {
        return apiRequest(`/project/${projectId}`, 'PUT', projectData);
    },

    delete: async (projectId) => {
        return apiRequest(`/project/delete/${projectId}`, 'DELETE');
    }
};

/**
 * Token Management Functions
 */
const TokenAPI = {
    setToken: (token) => {
        localStorage.setItem('auth_token', token);
    },

    getToken: () => {
        return localStorage.getItem('auth_token');
    },

    removeToken: () => {
        localStorage.removeItem('auth_token');
    },

    isAuthenticated: () => {
        return !!localStorage.getItem('auth_token');
    },

    getUserId: () => {
        const token = localStorage.getItem('auth_token');
        if (!token) return null;
        
        try {
            // Decode JWT (simple approach - assumes it's a valid JWT)
            const payload = JSON.parse(atob(token.split('.')[1]));
            return payload.sub || payload.user_id;
        } catch (e) {
            return null;
        }
    }
};

/**
 * Storage Functions
 */
const StorageAPI = {
    setUser: (user) => {
        localStorage.setItem('user_data', JSON.stringify(user));
    },

    getUser: () => {
        const userData = localStorage.getItem('user_data');
        return userData ? JSON.parse(userData) : null;
    },

    clearUser: () => {
        localStorage.removeItem('user_data');
    }
};

/**
 * Utility Functions for UI
 */
const UIUtils = {
    showError: (message, elementId = 'error-message') => {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.style.display = 'block';
            setTimeout(() => {
                errorElement.style.display = 'none';
            }, 5000);
        } else {
            alert(`Error: ${message}`);
        }
    },

    showSuccess: (message, elementId = 'success-message') => {
        const successElement = document.getElementById(elementId);
        if (successElement) {
            successElement.textContent = message;
            successElement.style.display = 'block';
            setTimeout(() => {
                successElement.style.display = 'none';
            }, 3000);
        }
    },

    showLoading: (show = true, elementId = 'loading') => {
        const loadingElement = document.getElementById(elementId);
        if (loadingElement) {
            loadingElement.style.display = show ? 'block' : 'none';
        }
    },

    disableForm: (formId, disabled = true) => {
        const form = document.getElementById(formId);
        if (form) {
            const inputs = form.querySelectorAll('input, select, textarea, button');
            inputs.forEach(input => {
                input.disabled = disabled;
            });
        }
    },

    formatDate: (date) => {
        if (!date) return '';
        const d = new Date(date);
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        const year = d.getFullYear();
        return `${day}/${month}/${year}`;
    },

    truncateText: (text, length = 100) => {
        if (!text) return '';
        return text.length > length ? text.substring(0, length) + '...' : text;
    }
};

/**
 * Validation Functions
 */
const Validation = {
    isEmail: (email) => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    isUsername: (username) => {
        // Username harus 3-20 karakter, alfanumerik dan underscore
        const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
        return usernameRegex.test(username);
    },

    isPassword: (password) => {
        // Minimal 6 karakter
        return password.length >= 6;
    },

    validateLoginForm: (username, password) => {
        const errors = [];
        if (!username) errors.push('Username harus diisi');
        if (!password) errors.push('Password harus diisi');
        return errors;
    },

    validateRegisterForm: (username, password, firstName, lastName) => {
        const errors = [];
        if (!username) errors.push('Username harus diisi');
        if (!Validation.isUsername(username)) errors.push('Username harus 3-20 karakter, alfanumerik dan underscore');
        if (!password) errors.push('Password harus diisi');
        if (!Validation.isPassword(password)) errors.push('Password minimal 6 karakter');
        if (!firstName) errors.push('Nama depan harus diisi');
        if (!lastName) errors.push('Nama belakang harus diisi');
        return errors;
    },

    validateProjectForm: (data) => {
        const errors = [];
        if (!data.name) errors.push('Nama project harus diisi');
        if (!data.description) errors.push('Deskripsi project harus diisi');
        if (!data.start_date) errors.push('Tanggal mulai harus diisi');
        if (!data.end_date) errors.push('Tanggal selesai harus diisi');
        if (!data.status) errors.push('Status project harus dipilih');
        if (new Date(data.start_date) >= new Date(data.end_date)) {
            errors.push('Tanggal mulai harus sebelum tanggal selesai');
        }
        return errors;
    }
};

// Export untuk penggunaan di modul lain (jika menggunakan ES6 modules)
// export { apiRequest, AuthAPI, ProjectAPI, TokenAPI, StorageAPI, UIUtils, Validation };
