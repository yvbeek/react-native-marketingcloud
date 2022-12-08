export interface InboxMessage {
    id: string;
    subject: string;
    url: string;
    read: boolean;
    deleted: boolean;
    sendDateUtc: Date;
    startDateUtc: Date;
    endDateUtc: Date;
}
export declare class SFMCSDK {
    /**
     * Initializes the Salesforce Marketing Cloud SDK.
     */
    static initializeSDK(): Promise<boolean>;
    /**
     * Enables or disables verbose logging within the native Marketing Cloud SDK.
     * @param enabled - The value to enable / disable verbose logging
     */
    static setDebugLoggingEnabled(enabled: boolean): void;
    /**
     * Returns the token used to send push messages to the device.
     * @returns A promise to the system token string or null
     */
    static getDeviceToken(): Promise<string | null>;
    /**
     * Returns the profile id currently set on the device.
     * @returns A promise to the current profile id or null
     */
    static getProfileId(): Promise<string | null>;
    /**
     * Sets the profile id for the device's user.
     * @param profileId - The value to be set as the profile id of the device's user
     */
    static setProfileId(profileId: string): void;
    /**
     * Sets custom profile attributes on the push notification record.
     * @param attributes - The attributes keys and values to set
     */
    static setProfileAttributes(attributes: Record<string, string>): void;
    /**
     * Indicates if the push messaging functionality is enabled.
     * @returns A promise to the boolean that indicates if push is enabled
     */
    static isPushEnabled(): Promise<boolean>;
    /**
     * Enables or disables the push messaging functionality.
     * @param enabled - The value to enable / disable push messaging
     */
    static setPushEnabled(enabled: boolean): void;
    /**
     * Returns all messages in the inbox.
     * @returns A promise to a list of inbox messages
     */
    static getAllMessages(): Promise<InboxMessage[]>;
    /**
     * Returns the total number of messages in the inbox.
     * @returns A promise to the number of inbox messages
     */
    static getAllMessagesCount(): Promise<number>;
    /**
     * Returns the number of unread messages in the inbox.
     * @returns A promise to the number of unread inbox messages
     */
    static getUnreadMessagesCount(): Promise<number>;
    /**
     * Marks a single message as deleted.
     * @param messageId - The message to mark as deleted
     * @returns A promise to the boolean indicating if the action was succesful
     */
    static markMessageDeleted(messageId: string): Promise<boolean>;
    /**
     * Marks a single message as read.
     * @param messageId - The message to mark as read
     * @returns A promise to the boolean indicating if the action was succesful
     */
    static markMessageRead(messageId: string): Promise<boolean>;
    /**
     * Marks all messages in the inbox as deleted.
     * @returns A promise to the boolean indicating if the action was succesful
     */
    static markAllMessagesDeleted(): Promise<boolean>;
    /**
     * Marks all messages in the inbox as read.
     * @returns A promise to the boolean indicating if the action was succesful
     */
    static markAllMessagesRead(): Promise<boolean>;
    /**
     * Reload and refresh Inbox messages from the MarketingCloud server.
     * The underlying request to the server will be throttled such that it will execute at most every 60 seconds.
     * @returns A promise to the boolean indicating if the refresh was succesful
     */
    static refreshMessages(): Promise<boolean>;
}
export default SFMCSDK;
//# sourceMappingURL=index.d.ts.map