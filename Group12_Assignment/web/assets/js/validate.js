/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


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