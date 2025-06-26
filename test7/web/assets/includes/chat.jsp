<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.*, dao.*" %>
<%@page isELIgnored="true" %>

<div class="chat-button" onclick="openChatBox()">
    <img src="./assets/icon/envelope.png" alt="Chat hỗ trợ" class="chat-icon">
    <span>Chat</span>
</div>

<div class="chat-popup">
    <div class="chat-header">
        <button class="toggle-collapse" onclick="toggleChat()">❯</button>
        <div class="chat-title">Chat</div>
        <button class="close-chat" onclick="closeChatBox()">✖</button>
    </div>

    <%
        MessageDAO messDAO = new MessageDAO();
        AccountDAO accDAO = new AccountDAO();

        Account thisUser = (Account) session.getAttribute("account");
        if (thisUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = thisUser.getUserId();
        ArrayList<Message> listInbox = messDAO.getInboxByUser(userId);
    %>

    <div class="chat-container">
        <div class="contact-list">
            <% Set<Integer> displayedUserIds = new HashSet<>();
               for (Message inbox : listInbox) {
                   int otherUserId = (inbox.getSenderId() != userId) ? inbox.getSenderId() : inbox.getReceiverId();
                   if (otherUserId == userId || displayedUserIds.contains(otherUserId)) continue;
                   Account otherUser = accDAO.getAccountById(otherUserId);
                   displayedUserIds.add(otherUserId);
            %>
            <div class="contact" data-userid="<%= otherUserId %>" onclick="loadConversation(this)">
                <img src="images/avatar/<%= otherUser.getAvatar() %>" alt="" class="contact-avatar">
                <div class="contact-info">
                    <div class="contact-name"><%= otherUser.getUsername() %></div>
                    <div class="last-message"><%= inbox.getContent() %></div>
                </div>
            </div>
            <% } %>
        </div>

        <div class="chat-area">
            <div class="messages">
            </div>

            <div class="message-input">
                <form class="chat-form" id="chatForm">
                    <input type="hidden" name="receiver" value="" />
                    <input type="text" name="content" placeholder="Nhập tin nhắn..." class="chat-input" required>
                    <input type="submit" value="Gửi" class="chat-send"/>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function openChatBox() {
        document.querySelector('.chat-button').style.display = 'none';
        document.querySelector('.chat-popup').classList.add('active');
        setTimeout(() => document.querySelector('.chat-input').focus(), 300);
    }

    function closeChatBox() {
        document.querySelector('.chat-popup').classList.remove('active');
        setTimeout(() => document.querySelector('.chat-button').style.display = 'flex', 300);
    }

    function toggleChat() {
        document.querySelector('.chat-popup').classList.toggle('collapsed');
    }

    function scrollToBottom() {
        const messages = document.querySelector('.messages');
        messages.scrollTop = messages.scrollHeight;
    }

    let currentChatUserId = null;

    function loadConversation(contactElem) {
        const userId = contactElem.getAttribute('data-userid');
        currentChatUserId = userId;

        document.querySelector('input[name="receiver"]').value = userId;

        fetch('load-messages?userId=' + userId)
                .then(response => response.text())
                .then(html => {
                    document.querySelector('.messages').innerHTML = html;
                    scrollToBottom();
                });

        document.querySelectorAll('.contact').forEach(c => c.classList.remove('active'));
        contactElem.classList.add('active');
    }

    document.getElementById("chatForm").addEventListener("submit", function (event) {
        event.preventDefault();
        const receiverId = document.querySelector('input[name="receiver"]').value;
        const content = document.querySelector('input[name="content"]').value.trim();

        if (!receiverId)
            return alert("⚠ Bạn chưa chọn người để gửi.");
        if (content === "")
            return alert("⚠ Tin nhắn không được để trống.");

        const formData = new FormData();
        formData.append("receiver", receiverId);
        formData.append("content", content);
        console.log("Receiver:", receiverId);
        console.log("Content:", content);

        fetch("chat", {
            method: "POST",
            body: formData
        }).then(response => {
            if (response.ok) {
                document.querySelector("#chatForm").reset();

                const messages = document.querySelector('.messages');
                messages.innerHTML += `
                    <div class="message sent">
                        <div class="message-content">${content}</div>
                    </div>`;
                scrollToBottom();

                const contactElem = document.querySelector(`.contact[data-userid="${receiverId}"]`);
                if (contactElem) {
                    const lastMsgElem = contactElem.querySelector('.last-message');
                    if (lastMsgElem)
                        lastMsgElem.textContent = content;
                }
            } else {
                console.error("Gửi thất bại với mã trạng thái:", response.status);
                alert("⚠ Gửi tin nhắn thất bại.");
            }
        }).catch(err => {
            console.error("Lỗi:", err);
            alert("⚠ Có lỗi khi gửi tin nhắn.");
        });
    });

    function isNearBottom(elem, threshold = 50) {
        return elem.scrollHeight - elem.scrollTop - elem.clientHeight < threshold;
    }

    function pollMessages() {
        if (!currentChatUserId)
            return;

        const messages = document.querySelector('.messages');
        const shouldScroll = isNearBottom(messages);

        fetch('load-messages?userId=' + currentChatUserId)
                .then(response => response.text())
                .then(html => {
                    messages.innerHTML = html;
                    if (shouldScroll) {
                        scrollToBottom();
                    }
                });
    }

    setInterval(pollMessages, 2000);

</script>
