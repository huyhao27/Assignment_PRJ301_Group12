<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SecondUni - SignUp</title>
        <link rel="stylesheet" href="assets/css/signup.css">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="stylesheet" href="assets/css/responsive.css">
        <link rel="stylesheet" href="assets/icon/themify-icons/themify-icons.css">
    </head>
    <body>
        <div class="container">
            <img class="logo" src="${pageContext.request.contextPath}/view/images/logo/Logo_Deleted_Background.png" alt="Logo"/>
            <div class="signup-box">
                <h2 class="box-title">Đăng ký</h2>

                <form id="signupForm" action="signup" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="input-group">
                        <input type="text" name="name" placeholder="Tên hiển thị" required>
                    </div>

                    <div class="input-group">
                        <input type="text" name="username" placeholder="Nhập email" required>
                    </div>

                    <div class="input-group" style="position: relative;">
                        <input type="password" name="password" id="password" placeholder="Nhập mật khẩu" required>
                        <i class="ti-eye toggle-password"
                           style="position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer;"></i>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <button type="submit" class="submit-btn">Đăng ký</button>
                </form>

                <div class="login-signup">
                    Bạn đã có tài khoản rồi? <a href="login.jsp">Đăng nhập</a>
                </div>

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
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js"></script>
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

            $(document).ready(function () {
                // Thêm phương thức validate email tùy chỉnh
                $.validator.addMethod("customEmail", function (value, element) {
                    // Biểu thức chính quy kiểm tra định dạng email
                    return this.optional(element) || /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(value);
                }, "Vui lòng nhập email hợp lệ");

                // Thêm phương thức validate mật khẩu tùy chỉnh
                $.validator.addMethod("strongPassword", function (value, element) {
                    return this.optional(element) ||
                            value.length >= 6 &&
                            value.length <= 30 &&
                            /[A-Z]/.test(value) &&
                            /\d/.test(value) &&
                            /[!@#$%^&*(),.?":{}|<>]/.test(value);
                }, "Mật khẩu phải từ 6-30 ký tự, chứa ít nhất 1 chữ in hoa, 1 chữ số và 1 ký tự đặc biệt");

                // Validate form
                $("#signupForm").validate({
                    rules: {
                        name: {
                            required: false // Không validate phần tên
                        },
                        username: {
                            required: true,
                            customEmail: true
                        },
                        password: {
                            required: true,
                            strongPassword: true
                        }
                    },
                    messages: {
                        username: {
                            required: "Vui lòng nhập email",
                            customEmail: "Vui lòng nhập email hợp lệ"
                        },
                        password: {
                            required: "Vui lòng nhập mật khẩu",
                            strongPassword: "Mật khẩu phải từ 6-30 ký tự, chứa ít nhất 1 chữ in hoa, 1 chữ số và 1 ký tự đặc biệt"
                        }
                    },
                    errorElement: "div",
                    errorClass: "error",
                    errorPlacement: function (error, element) {
                        // Đặt thông báo lỗi ngay dưới input
                        error.insertAfter(element.closest(".input-group"));
                    },
                    highlight: function (element) {
                        $(element).addClass("input-error");
                    },
                    unhighlight: function (element) {
                        $(element).removeClass("input-error");
                    }
                });
            });
        </script>
    </body>
</html>