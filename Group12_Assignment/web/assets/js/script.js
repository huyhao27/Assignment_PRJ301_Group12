/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.querySelectorAll('.dropdown-item').forEach(item => {
    item.addEventListener('click', () => {
        const applied = document.querySelector('.applied-filters');
        const span = document.createElement('span');
        span.textContent = item.textContent;
        applied.appendChild(span);
    });
});

document.querySelector('.clear-all').addEventListener('click', () => {
    document.querySelector('.applied-filters').innerHTML = '';
});



function showSetting(id) {
    document.querySelectorAll('.settings-item').forEach(item => item.classList.remove('active'));
    document.querySelectorAll('.settings-content > div').forEach(div => div.classList.remove('active'));
    document.querySelector(`.settings-item[onclick*="${id}"]`).classList.add('active');
    document.getElementById(id).classList.add('active');
}


/*========== CHAT ============*/

// Mở hộp chat
function openChatBox() {
    const chatButton = document.querySelector('.chat-button');
    const chatPopup = document.querySelector('.chat-popup');

    // Ẩn nút chat
    chatButton.style.display = 'none';

    // Hiển thị hộp chat với hiệu ứng
    chatPopup.classList.add('active');

    // Focus vào ô nhập tin nhắn
    setTimeout(() => {
        document.querySelector('.chat-input').focus();
    }, 300);
}

// Đóng hộp chat
function closeChatBox() {
    const chatButton = document.querySelector('.chat-button');
    const chatPopup = document.querySelector('.chat-popup');

    // Ẩn hộp chat với hiệu ứng
    chatPopup.classList.remove('active');

    // Hiển thị lại nút chat sau khi hiệu ứng kết thúc
    setTimeout(() => {
        chatButton.style.display = 'flex';
    }, 300);
}

// Thu gọn/mở rộng hộp chat
function toggleChat() {
    const chatPopup = document.querySelector('.chat-popup');
    chatPopup.classList.toggle('collapsed');
}


// Khởi tạo
document.addEventListener('DOMContentLoaded', function () {
    // Ẩn nút chat nếu hộp chat đang mở (khi refresh trang)
    if (document.querySelector('.chat-popup').classList.contains('active')) {
        document.querySelector('.chat-button').style.display = 'none';
    }
});
