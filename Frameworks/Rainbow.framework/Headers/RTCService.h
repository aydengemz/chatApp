/*
 * Rainbow
 *
 * Copyright (c) 2016, ALE International
 * All rights reserved.
 *
 * ALE International Proprietary Information
 *
 * Contains proprietary/trade secret information which is the property of
 * ALE International and must not be made available to, or copied or used by
 * anyone outside ALE International without its written authorization
 *
 * Not to be disclosed or used except in accordance with applicable agreements.
 */

#import <Foundation/Foundation.h>
#import "RTCCall.h"
#import <WebRTC/WebRTC.h>

// The notification emmited when we have new stats available
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceCallStatsNotification;

FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidAllowMicrophoneNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidRefuseMicrophoneNotification;

FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidAddCaptureSessionNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidAddLocalVideoTrackNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidRemoveLocalVideoTrackNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidAddRemoteVideoTrackNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidRemoveRemoteVideoTrackNotification;

FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidChangeRecordingCallStateNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidReceiveHangupCall;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidReceiveEndedSession;
FOUNDATION_EXPORT NSString * _Nonnull const kRTCServiceDidReceiveConnectedSession;


/**
 *  Manage WebRTC calls (audio/video) made through Rainbow
 *  This allow to receive incoming RTC calls and also to start an outgoing call with somebody.
 *
 *  RTC service available notifications
 *   - kRTCServiceCallStatsNotification: `notification sent when new statistics are available`
 */
@interface RTCService : NSObject


@property (readonly) NSArray<RTCCall *> *_Nonnull calls;
@property (nonatomic, readonly) BOOL hasActiveCalls;

@property (nonatomic, strong) NSString *_Nonnull appSoundOutgoingCall;
@property (nonatomic, strong) NSString *_Nonnull appSoundHangup;
@property (nonatomic, strong) NSString *_Nonnull appSoundHoldTone;
@property (nonatomic) BOOL isCallKitAvailable;

@property (nonatomic, readonly) RTCCameraVideoCapturer *cameraVideoCapturer;

// Provide your application icon name, this icon must be a 40 point icon that will be used as a mask for callkit screens
-(void) startCallKitWithIncomingSoundName:(NSString *_Nonnull) incomingSoundName iconTemplate:(NSString *_Nonnull)iconTemplate appName:(NSString *_Nonnull) appName;

/**
 *  Emit a new outgoing RTC call
 *
 *  @param peer The peer to call, only an *online* *Rainbow* peer (Contact or room) can be called
 *  @param features The features you want to enabled for this call (audio, video, audio+video, ..)
 *
 *  @return Return the newly create RTCCall, or `nil` on error
 *  @see RTCCall
 */

-(RTCCall *_Nullable) beginNewOutgoingCallWithPeer:(Peer *_Nonnull)peer withFeatures:(RTCCallFeatureFlags)features;

/**
 *  Emit a new outgoing RTC call with a subject
 *
 *  @param peer The peer to call, only an *online* *Rainbow* peer (Contact or room) can be called
 *  @param features The features you want to enabled for this call (audio, video, audio+video, ..)
 *  @param subject The subject of the call, may be `nil` for no subject
 *
 *  @return Return the newly create RTCCall, or `nil` on error
 *  @see RTCCall
 */
-(RTCCall *_Nullable) beginNewOutgoingCallWithPeer:(Peer * _Nonnull)peer withFeatures:(RTCCallFeatureFlags)features andSubject:(NSString *_Nullable) subject;

/**
 *  Cancel the given outgoing call
 *
 *  @param rtcCall the RTCCall to cancel
 *
 *  @see RTCCall
 */
-(void) cancelOutgoingCall:(RTCCall *_Nonnull)rtcCall;

/**
 *  Accept an incoming RTC call
 *
 *  @param rtcCall The incoming call to answer
 *  @param features The features you want to enabled for this call (audio, video, audio+video, ..)
 *
 *  @see RTCCall
 */
-(void) acceptIncomingCall:(RTCCall *_Nonnull)rtcCall withFeatures:(RTCCallFeatureFlags)features;

/**
 *  Decline an incoming RTC call
 *
 *  @param rtcCall The incoming call to answer
 *
 *  @see RTCCall
 */
-(void) declineIncomingCall:(RTCCall *_Nonnull)rtcCall;

/**
 *  Hang an ongoing RTC call
 *
 *  @param rtcCall the RTCCall to hangup
 *
 *  @see RTCCall
 */
-(void) hangupCall:(RTCCall *_Nonnull)rtcCall;

/**
 *  Check if a call is muted
 *  @param rtcCall the RTCCall to check
 *  @return `YES` if this call is muted, otherwise `NO`
 *  @see RTCCAll
 */
-(BOOL) isCallMuted:(RTCCall *_Nonnull) rtcCall;

/**
 *  Mute the local audio tracks of the given call
 *
 *  @param rtcCall the RTCCall to mute
 *
 *  @see RTCCall
 */
-(void) muteLocalAudioForCall:(RTCCall *_Nonnull)rtcCall;

/**
 *  Check if the speaker is enabled
 *  @return `YES` if speaker is enabled, otherwise return `NO`
 */
-(BOOL) isSpeakerEnabled;


/**
 *  Un-mute the local audio tracks of the given call
 *
 *  @param rtcCall the RTCCall to un-mute
 *
 *  @see RTCCall
 */
-(void) unMuteLocalAudioForCall:(RTCCall *_Nonnull)rtcCall;

/**
 *  Force audio to be played on speaker
 */
-(void) forceAudioOnSpeaker;

/**
 *  Un-force audio to be played on speaker
 */
-(void) unForceAudioOnSpeaker;

/**
 * @name ContactsManager methods
 */

/**
 *  Ask to unlock the microphone
 */
-(void) requestMicrophoneAccess;

/**
 *
 * @return `YES` if the microphone access has been determined by the user otherwise @return `NO`
 */
@property (nonatomic, readonly) BOOL microphoneAccessAlreadyDetermined;

/**
 *
 * @return `YES` if the microphone access has been granted by the user otherwise @return `NO`
 */
@property (nonatomic, readonly) BOOL microphoneAccessGranted;

-(void) handleContinueUserActivity:(NSUserActivity *)userActivity error:(NSError **)errorPointer waitingForResponse:(void (^_Nullable)(BOOL receivedResponse))waitingForResponseBlock restorationHandler:(void (^_Nullable)(NSArray * _Nullable))restorationHandler;

/**
 *  Get the remote video stream for the given call if exist.
 *  @return RTCMediaStream object if this call have one.
 */
-(RTCMediaStream *_Nullable) remoteVideoStreamForCall:(RTCCall* _Nonnull) call;

-(RTCMediaStream *_Nullable) remoteSharingStreamForCall:(RTCCall * _Nonnull) call;

/**
 *  Get the local video stream for the given call if exist.
 *  @return RTCMediaStream object if this call have one.
 */
-(RTCMediaStream *_Nullable) localVideoStreamForCall:(RTCCall *_Nonnull) call;

-(void) addVideoMediaToCall:(RTCCall *_Nonnull) call;

-(void) removeVideoMediaFromCall:(RTCCall *_Nonnull) call;

/**
 *  Emit a new outgoing RTC call
 *
 *  @param number The number to call
 *
 *  @return Return the newly create RTCCall, or `nil` on error
 *  @see RTCCall
 */
-(RTCCall *_Nullable) beginNewOutgoingCallWithWebRTCGatewayToNumber:(NSString *_Nonnull) number;

/**
 *  Send DTMF with WebRTC
 *
 *  @param digit number
 */
-(void) sendDTMF:(NSString *_Nonnull) digit;

/**
 *  Hangup call if app will terminate
 */
-(void) hangupCallOnTerminate;

@end
