import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { FirebaseProvider } from "src/core/provider/firebase/firebase-provider";

@Injectable()
export class FirebaseCloudMessagingService {
  messageConfig;
  constructor(
    private readonly config: ConfigService,
    private firebaseProvoder: FirebaseProvider
  ) {
    this.messageConfig = {
      android: {
        notification: {
          imageUrl: this.config.get<string>("FIREBASE_CLOUD_MESSAGING_IMAGE"),
        },
        priority: this.config.get<string>("FIREBASE_CLOUD_MESSAGING_PRIO"),
      },
      apns: {
        payload: {},
        fcmOptions: {
          imageUrl: this.config.get<string>("FIREBASE_CLOUD_MESSAGING_IMAGE"),
        },
      },
      webpush: {
        headers: {
          image: this.config.get<string>("FIREBASE_CLOUD_MESSAGING_IMAGE"),
        },
      },
    };
  }

  async sendToDevice(token, title, description) {
    const payload = {
      token,
      notification: {
        title: title,
        body: description,
      },
      ...this.messageConfig,
    };
    return await this.firebaseProvoder.app
      .messaging()
      .send(payload)
      .then(() => {
        console.log("Successfully sent message");
      })
      .catch((error) => {
        console.log(`Error sending notif! ${error.message}`);
      });
  }
}
