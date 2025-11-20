<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>

    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/login.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <div class="bg-fullscreen">
        <form class="login-tab" id="loginForm" role="form" aria-labelledby="login-heading">
            <div class="login-row login-heading" id="login-heading">Login</div>

            <!-- Error messages -->
            <div id="errorMessage" class="error-message" style="display:none;"></div>

            <div class="login-row login-email">
                <input id="user_name" name="user_name" type="text" placeholder="Username" required />
            </div>

            <div class="login-row login-password">
                <input id="password" name="password" type="password" placeholder="Password" required />
                <button type="button" class="password-toggle" aria-label="Toggle password visibility" aria-pressed="false">
                    <img src="${pageContext.request.contextPath}/images/eye.png" width="20" height="20" alt="show password" />
                </button>
            </div>

            <div class="login-row login-action">
                <button id="login-btn" type="submit"><span class="btn-text">Login</span></button>
            </div>

            <div class="login-row login-signup">
                 Don't have an account? <a href="register.jsp">Sign up here!</a>
            </div>
        </form>
    </div>

<script>
$(document).ready(function(){
    // Password toggle functionality
    const $toggle = $('.password-toggle');
    const $pwd = $('#password');
    if(!$toggle.length || !$pwd.length) return;

    let visible = false;
    const strike = () => $('<div class="strike-line"></div>').css({
        position: 'absolute',
        top: '50%',
        left: '50%',
        width: '83%',
        height: '1.6px',
        background: '#8F9185',
        pointerEvents: 'none',
        transform: 'translate(-50%, -50%) rotate(-20deg)',
        borderRadius: '2px'
    });

    strike().appendTo($toggle);

    $toggle.on('click', function(){
        visible = !visible;
        $pwd.attr('type', visible ? 'text' : 'password');
        $(this).find('.strike-line').remove();
        if(!visible) strike().appendTo(this);
    });

    // Form submission
    $('#loginForm').on('submit', async function(e) {
        e.preventDefault();

        const username = $('#user_name').val().trim();
        const password = $('#password').val();
        const $errorMsg = $('#errorMessage');

        // Validation
        const errors = Validation.validateLoginForm(username, password);
        if (errors.length > 0) {
            $errorMsg.text(errors.join(', ')).show();
            return;
        }

        // Show loading state
        const $btn = $('#login-btn');
        const originalText = $btn.html();
        $btn.prop('disabled', true).html('<span>Loading...</span>');

        try {
            const response = await AuthAPI.login(username, password);
            
            if (response.success) {
                // Simpan token
                if (response.Authorization || response.token) {
                    const token = response.Authorization || response.token;
                    TokenAPI.setToken(token);
                }
                
                // Redirect ke halaman utama
                window.location.href = 'projects.jsp';
            } else {
                $errorMsg.text(response.error_message || 'Login gagal').show();
            }
        } catch (error) {
            console.error('Login error:', error);
            $errorMsg.text(error.message || 'Terjadi kesalahan saat login').show();
        } finally {
            $btn.prop('disabled', false).html(originalText);
        }
    });

    // Clear error message on input
    $('#user_name, #password').on('input', function() {
        $('#errorMessage').hide();
    });
});
</script>
</body>
</html>
