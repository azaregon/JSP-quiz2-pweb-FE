<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Page</title>

    <link href="https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+Antique&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/reseter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
</head>
<body>
    <div class="bg-fullscreen">
        <form class="register-tab" id="registerForm" role="form">
            <div class="reg-heading">Create New Account</div>
            <div class="reg-subtext">Already have account? 
                <a href="login.jsp" class="reg-login-link">Login here!</a>
            </div>

            <!-- Error messages -->
            <div id="errorMessage" class="error-message" style="display:none;"></div>

            <!-- Name -->
            <div class="name-row">
                <div class="name-field first-name">
                    <input type="text" id="first_name" name="first_name" placeholder="First name" required />
                </div>
                <div class="name-field last-name">
                    <input type="text" id="last_name" name="last_name" placeholder="Last name" required />
                </div>
            </div>

            <!-- Username -->
            <div class="user-name-row">
                <input type="text" id="user_name" name="user_name" placeholder="Username" required />
            </div>

            <!-- Password -->
            <div class="password-row">
                <input id="password" name="password" type="password" placeholder="Password" required />
                <button type="button" class="password-toggle" aria-label="Toggle password visibility" aria-pressed="false">
                    <img src="${pageContext.request.contextPath}/images/eye.png" width="20" height="20" alt="show password" />
                </button>
            </div>

            <!-- Terms -->
            <div class="terms-row">
                <input type="checkbox" id="agree-terms" name="terms" required />
                <label for="agree-terms" class="terms-text">
                    I agree <a href="https://lipsum.com/feed/html" class="terms-text-link" target="_blank">Terms & Conditions</a>
                </label>
            </div>

            <!-- Submit -->
            <div class="register-action">
                <button type="submit" class="register-btn" id="register-btn">Create Account</button>
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
        $('#registerForm').on('submit', async function(e) {
            e.preventDefault();

            const firstName = $('#first_name').val().trim();
            const lastName = $('#last_name').val().trim();
            const username = $('#user_name').val().trim();
            const password = $('#password').val();
            const termsAgreed = $('#agree-terms').is(':checked');
            const $errorMsg = $('#errorMessage');

            // Validation
            const errors = Validation.validateRegisterForm(username, password, firstName, lastName);
            if (!termsAgreed) {
                errors.push('Anda harus setuju dengan Terms & Conditions');
            }

            if (errors.length > 0) {
                $errorMsg.text(errors.join(', ')).show();
                return;
            }

            // Show loading state
            const $btn = $('#register-btn');
            const originalText = $btn.html();
            $btn.prop('disabled', true).html('Loading...');

            try {
                const response = await AuthAPI.register(username, password, firstName, lastName);
                
                if (response.success) {
                    // Simpan token jika ada
                    if (response.Authorization || response.token) {
                        const token = response.Authorization || response.token;
                        TokenAPI.setToken(token);
                    }
                    
                    // Redirect ke halaman login atau dashboard
                    alert('Pendaftaran berhasil! Silakan login');
                    window.location.href = 'login.jsp';
                } else {
                    $errorMsg.text(response.error_message || 'Pendaftaran gagal').show();
                }
            } catch (error) {
                console.error('Register error:', error);
                $errorMsg.text(error.message || 'Terjadi kesalahan saat pendaftaran').show();
            } finally {
                $btn.prop('disabled', false).html(originalText);
            }
        });

        // Clear error message on input
        $('#first_name, #last_name, #user_name, #password').on('input', function() {
            $('#errorMessage').hide();
        });
    });
    </script>
</body>
</html>
