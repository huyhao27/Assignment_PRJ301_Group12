<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>SecondUni - Login</title>
        <link rel="stylesheet" href="assets/css/login.css">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
        <link rel="stylesheet" href="assets/icon/themify-icons.css">

    </head>
    <body>
        <div class="container">
            <img class="logo" src="images/logo/Logo_Deleted_Background.png" alt="Logo" />
            <!--            <div >
                            <a href="#" class="home-btn">
                                <i class="ti-home"></i>
                            </a>
                        </div>-->

            <div class="login-box">
                <h1 class="box-title">Đăng nhập</h1>

                <form action="login" method="post">
                    <div class="input-group">
                        <input type="text" name="username" placeholder="Email" required />
                    </div>

                    <div class="input-group" style="position: relative;">
                        <input type="password" name="password" id="password" placeholder="Mật khẩu" required />
                        <i class="ti-eye toggle-password"
                           style="position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
                    </div>

                    <div class="remember-container">
                        <input type="checkbox" id="remember" name="remember"/>
                        <label for="remember">Ghi nhớ tôi</label>

                        <% if (request.getParameter("error") != null) { %>
                        <span class="error-text">Không chính xác!</span>
                        <% } %>
                    </div>

                    <input type="submit" value="Đăng nhập" class="submit-btn"/>
                </form>

                <div class="login-alt">
                    <div class="line"></div>
                    <span>Hoặc đăng nhập bằng</span>
                    <div class="line"></div>
                </div>

                <div class="social-icons">
                    <div class="icon"><i class="ti-facebook"></i></div>
                    <div class="icon"><i class="ti-google"></i></div>
                    <div class="icon"><i class="ti-github"></i></div>
                </div>

                <div class="login-signup">
                    Bạn chưa có tài khoản? <a href="signup.jsp">Đăng ký</a>
                </div>
            </div>
        </div>


        <script>

            document.addEventListener("DOMContentLoaded", function () {
                const toggle = document.getElementById("togglePassword");
                const password = document.getElementById("password");

                toggle.addEventListener("click", function () {
                    const type = password.getAttribute("type") === "password" ? "text" : "password";
                    password.setAttribute("type", type);

                    // Đổi màu khi hiện/ẩn thay vì đổi icon
                    this.style.color = type === "text" ? "gray" : "black";
                });
            });
            document.addEventListener("DOMContentLoaded", function () {
                const toggles = document.querySelectorAll(".toggle-password");

                toggles.forEach(function (toggle) {
                    toggle.addEventListener("click", function () {
                        const passwordInput = this.previousElementSibling;

                        if (passwordInput && passwordInput.type === "password") {
                            passwordInput.type = "text";
                            this.style.color = "gray";
                        } else {
                            passwordInput.type = "password";
                            this.style.color = "black";
                        }
                    });
                });
            });

        </script>

    </body>
</html>
