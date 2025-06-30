/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
                const toggleIcon = document.getElementById("togglePassword");
                const passwordInput = document.getElementById("password");

                toggleIcon.addEventListener("click", function () {
                    const isHidden = passwordInput.type === "password";

                    // Toggle input type
                    passwordInput.type = isHidden ? "text" : "password";

                    // Toggle icon
                    toggleIcon.src = isHidden
                            ? toggleIcon.dataset.open
                            : toggleIcon.dataset.close;
                });
            });

