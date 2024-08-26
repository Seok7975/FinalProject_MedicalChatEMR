//package com.emr.www.controller.webSocket;
//
//import com.emr.www.dto.ChatMessageDto;
//import com.emr.www.entity.ChatMessage;
//import com.emr.www.repository.ChatMessageRepository;
//import org.springframework.messaging.handler.annotation.MessageMapping;
//import org.springframework.messaging.handler.annotation.Payload;
//import org.springframework.messaging.simp.SimpMessagingTemplate;
//import org.springframework.stereotype.Controller;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Controller
//public class WebSocketController {
//
//    private final SimpMessagingTemplate messagingTemplate;
//    private final ChatMessageRepository chatMessageRepository;
//
//    public WebSocketController(SimpMessagingTemplate messagingTemplate, ChatMessageRepository chatMessageRepository) {
//        this.messagingTemplate = messagingTemplate;
//        this.chatMessageRepository = chatMessageRepository;
//    }
//
//    // 직원 상태 업데이트를 브로드캐스트 (예: 온라인, 오프라인 등)
//    @MessageMapping("/status")
//    public void updateStatus(@Payload StatusMessage status) {
//        // 상태 메시지를 모든 클라이언트에게 브로드캐스트
//        messagingTemplate.convertAndSend("/topic/status", status);
//    }
//
//    // 특정 직원과 1:1 채팅 메시지 처리
//    @MessageMapping("/chat/{employeeName}")
//    public void sendPrivateMessage(@Payload ChatMessageDto messageDto) {
//        // 메시지 데이터베이스에 저장
//        ChatMessage chatMessage = new ChatMessage(
//            messageDto.getSender(),
//            messageDto.getReceiver(),
//            messageDto.getContent(),
//            LocalDateTime.now()
//        );
//        chatMessageRepository.save(chatMessage);
//
//        // 메시지를 수신자에게 전송
//        messagingTemplate.convertAndSend("/topic/chat/" + messageDto.getReceiver(), messageDto);
//    }
//
//    // 특정 직원과의 채팅 기록을 조회하는 메서드 (REST 엔드포인트로 활용 가능)
//    public List<ChatMessage> getChatHistory(String receiver, String sender) {
//        return chatMessageRepository.findByReceiverAndSenderOrderByTimestampAsc(receiver, sender);
//    }
//}