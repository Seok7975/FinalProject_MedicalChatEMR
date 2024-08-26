package com.emr.www.repository.chatMessage;

import com.emr.www.entity.chatMessage.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    // 특정 수신자(receiver)와 발신자(sender) 간의 채팅 메시지를 조회하는 메서드
    List<ChatMessage> findByReceiverAndSenderOrderByTimestampAsc(String receiver, String sender);

    // 특정 수신자(receiver)에 대한 모든 채팅 메시지를 조회하는 메서드
    List<ChatMessage> findByReceiverOrderByTimestampAsc(String receiver);
}