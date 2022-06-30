import { NativeModules } from 'react-native';

const NativeSDK = NativeModules.RNMarketingCloud
  ? NativeModules.RNMarketingCloud
  : new Proxy({}, {
    get() {
      throw new Error("The package 'react-native-marketingcloud' doesn't seem to be linked.");
    }
  });

export interface InboxMessage {
  id: string
  subject: string
  url: string
  read: boolean
  deleted: boolean
  sendDateUtc: Date
  startDateUtc: Date
  endDateUtc: Date
}

export class SFMCSDK {
  /**
   * Initializes the Salesforce Marketing Cloud SDK.
   */
  static async initializeSDK(): Promise<boolean> {
    return NativeSDK.initializeSDK()
  }

  /**
   * Enables or disables verbose logging within the native Marketing Cloud SDK.
   * @param enabled - The value to enable / disable verbose logging
   */
  static setDebugLoggingEnabled(enabled: boolean): void {
    NativeSDK.setDebugLoggingEnabled(enabled)
  }

  // PUSH MESSAGING

  /**
   * Returns the token used to send push messages to the device.
   * @returns A promise to the system token string or null
   */
  static getDeviceToken(): Promise<string | null> {
    return NativeSDK.getDeviceToken()
  }

  /**
   * Returns the profile id currently set on the device.
   * @returns A promise to the current profile id or null
   */
  static async getProfileId(): Promise<string | null> {
    return NativeSDK.getProfileId()
  }

  /**
   * Sets the profile id for the device's user.
   * @param profileId - The value to be set as the profile id of the device's user
   */
  static setProfileId(profileId: string): void {
    NativeSDK.setProfileId(profileId)
  }

  /**
   * Sets custom profile attributes on the push notification record.
   * @param attributes - The attributes keys and values to set
   */
  static setProfileAttributes(attributes: Record<string, string>): void {
    NativeSDK.setProfileAttributes(attributes)
  }

  /**
   * Indicates if the push messaging functionality is enabled.
   * @returns A promise to the boolean that indicates if push is enabled
   */
  static isPushEnabled(): Promise<boolean> {
    return NativeSDK.isPushEnabled()
  }

  /**
   * Enables or disables the push messaging functionality.
   * @param enabled - The value to enable / disable push messaging
   */
  static setPushEnabled(enabled: boolean): void {
    NativeSDK.setDebugLoggingEnabled(enabled)
  }

  // PUSH MESSAGING INBOX

  /**
   * Returns all messages in the inbox.
   * @returns A promise to a list of inbox messages
   */
  static async getAllMessages(): Promise<InboxMessage[]> {
    const messages: any[] = await NativeSDK.getAllMessages()
    return messages.map((message: any) => {
      const {
        id, subject, url, read, deleted,
        sendDateEpoch, startDateEpoch, endDateEpoch
      } = message

      const today = new Date()
      const result: InboxMessage = {
        id, subject, read, deleted, url,
        sendDateUtc: sendDateEpoch ? new Date(sendDateEpoch) : today,
        startDateUtc: startDateEpoch ? new Date(startDateEpoch) : today,
        endDateUtc: endDateEpoch ? new Date(endDateEpoch) : today
      }

      // Make sure that the start date is not the same as the end date
      if (result.endDateUtc === result.startDateUtc) {
        result.endDateUtc = result.startDateUtc
        result.endDateUtc.setDate(result.startDateUtc.getDate() + 1)
      }

      return result
    })
  }

  /**
   * Returns the total number of messages in the inbox.
   * @returns A promise to the number of inbox messages
   */
  static async getAllMessagesCount(): Promise<number> {
    return NativeSDK.getAllMessagesCount()
  }

  /**
   * Returns the number of unread messages in the inbox.
   * @returns A promise to the number of unread inbox messages
   */
  static async getUnreadMessagesCount(): Promise<number> {
    return NativeSDK.getUnreadMessagesCount()
  }

  /**
   * Marks a single message as deleted.
   * @param messageId - The message to mark as deleted
   * @returns A promise to the boolean indicating if the action was succesful
   */
  static async markMessageDeleted(messageId: string): Promise<boolean> {
    return NativeSDK.markMessageDeleted(messageId)
  }

  /**
   * Marks a single message as read.
   * @param messageId - The message to mark as read
   * @returns A promise to the boolean indicating if the action was succesful
   */
  static async markMessageRead(messageId: string): Promise<boolean> {
    return NativeSDK.markMessageRead(messageId)
  }

  /**
   * Marks all messages in the inbox as deleted.
   * @returns A promise to the boolean indicating if the action was succesful
   */
  static async markAllMessagesDeleted(): Promise<boolean> {
    return NativeSDK.markAllMessagesDeleted()
  }

  /**
   * Marks all messages in the inbox as read.
   * @returns A promise to the boolean indicating if the action was succesful
   */
  static async markAllMessagesRead(): Promise<boolean> {
    return NativeSDK.markAllMessagesRead()
  }

  /**
   * Reload and refresh Inbox messages from the MarketingCloud server.
   * The underlying request to the server will be throttled such that it will execute at most every 60 seconds.
   * @returns A promise to the boolean indicating if the refresh was succesful
   */
  static async refreshMessages(): Promise<boolean> {
    return NativeSDK.refreshMessages()
  }
}

export default SFMCSDK
