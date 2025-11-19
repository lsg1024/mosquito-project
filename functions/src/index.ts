import * as admin from "firebase-admin";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {getMessaging, SendResponse} from "firebase-admin/messaging";

// Firebase Admin SDK 초기화
admin.initializeApp();

const db = admin.firestore();
const messaging = getMessaging();

export const sendScheduledNotifications = onSchedule(
  {
    schedule: "*/1 * * * *",
    timeZone: "Asia/Seoul",
  },
  async () => {
    const now = new Date();
    const currentHour = now.getHours().toString().padStart(2, "0");
    const currentMinute = now.getMinutes().toString().padStart(2, "0");
    const currentTime = `${currentHour}:${currentMinute}`;

    console.log(`v2 스케줄러 실행: 현재 시간(KST) ${currentTime}`);

    try {
      const querySnapshot = await db
        .collection("scheduledTokens")
        .where("time", "==", currentTime)
        .get();

      if (querySnapshot.empty) {
        console.log("이 시간에 알림을 받을 사용자가 없습니다.");
        return;
      }

      const tokens: string[] = [];
      querySnapshot.forEach((doc) => {
        tokens.push(doc.data().token);
      });

      console.log(`${tokens.length}개의 기기에 알림을 보냅니다.`);

      if (tokens.length > 0) {
        const response = await messaging.sendEachForMulticast({
          tokens: tokens,
          notification: {
            title: "🦟 모기 알림",
            body: "설정한 시간이 되었습니다! 모기 예보를 확인하세요.",
          },
        });

        if (response.failureCount > 0) {
          response.responses.forEach((resp: SendResponse, idx: number) => {
            if (!resp.success) {
              const failedToken = tokens[idx];
              console.error("알림 전송 실패 토큰:", failedToken, resp.error);

              const errorCode = resp.error?.code;
              if (
                errorCode === "messaging/registration-token-not-registered" ||
                errorCode === "messaging/invalid-registration-token"
              ) {
                db.collection("scheduledTokens").doc(failedToken).delete();
              }
            }
          });
        }
      }
    } catch (error) {
      console.error("스케줄링 함수 실행 중 오류 발생:", error);
    }
  });

// 파일 끝 빈 줄 추가 (lint 오류 방지)
