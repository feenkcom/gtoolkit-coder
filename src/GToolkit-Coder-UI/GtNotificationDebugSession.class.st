Class {
	#name : #GtNotificationDebugSession,
	#superclass : #GtNotificationEvent,
	#instVars : [
		'debugSession'
	],
	#category : #'GToolkit-Coder-UI-DebugSession'
}

{ #category : #'private - asserting' }
GtNotificationDebugSession >> assertDebugSession: aDebugSession [
	self 
		assert: [ aDebugSession isNotNil ] 
		description: [ 'Debug session must be non-nil' ].
	self 
		assert: [ aDebugSession isKindOf: GtSharedDebugSession ] 
		description: [ 'Debug session must be a ',
			GtSharedDebugSession name, ' instance, instead of a ', 
			aDebugSession class name, ' instance'  ]
]

{ #category : #accessing }
GtNotificationDebugSession >> debugSession [
	<return: #GtSharedDebugSession>
	^ debugSession
]

{ #category : #accessing }
GtNotificationDebugSession >> debugSession: aDebugSession [
	self assertDebugSession: aDebugSession.
	debugSession ifNotNil: [ debugSession unsubscribe: self ].
	debugSession := aDebugSession.
	aDebugSession weak
		when: GtSharedDebugSessionAnnouncement
		send: #onSharedDebugSessionAnnouncement:
		to: self
]

{ #category : #'api - accessing' }
GtNotificationDebugSession >> elementClass [
	^ GtNotificationDebugSessionElement
]

{ #category : #'private - announcement handling' }
GtNotificationDebugSession >> onSharedDebugSessionAnnouncement: anAnnouncement [
	self debugSession unsubscribe: self.
	self requestRemoval
]

{ #category : #'private - adding / removing' }
GtNotificationDebugSession >> removeFrom: aGtNotifications [
	aGtNotifications removeNotification: self
]
